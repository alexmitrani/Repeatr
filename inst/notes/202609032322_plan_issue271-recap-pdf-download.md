# Plan: Issue #271 — Recap tab PDF download via Quarto + Typst

## Context

The Fugazetteer Shiny app's "recap" tab (single-show summary — title, prose
summary, a zoomed-in Leaflet street map, tracklist) has a download button
that currently renders `recap_template.Rmd` to a self-contained HTML file via
`rmarkdown::render()`. [Issue #271](https://github.com/alexmitrani/Repeatr/issues/271)
asks to switch this to a real PDF, using Quarto + Typst rather than
LaTeX/TinyTeX. This is a deliberate style choice (Typst is bundled inside the
Quarto CLI, so no LaTeX system dependency is needed), and a sibling project
(`cvmachine`) has already proven the Quarto+Typst pattern works when deployed
to Posit Connect Cloud — the same platform Fugazetteer is deployed to
(footer link: `https://alexmitrani-fugazetteer.share.connect.posit.cloud/`).

The one part of the current page that can't survive a static PDF unchanged
is the interactive Leaflet map. Per discussion, the map will be rasterized
via a headless-Chrome screenshot (`webshot2`/`chromote`) rather than
replaced with a simplified static map or dropped — this preserves the same
zoomed street-level tile view users see live. Two follow-on decisions are
resolved as: **leave the marker popup closed** in the screenshot (its info
is redundant with the prose/heading already in the doc), and **hard-fail
with a Shiny notification** (not graceful degradation) if Chrome isn't
available at render time — ship the simple version first, and only add a
"map unavailable" fallback later if testing against the real Posit Connect
Cloud deployment shows Chrome is genuinely missing there.

`recap()` in `R/recap.R` (the data-prep logic) needs **no changes** — it's
already template-agnostic. This is purely a rendering/presentation change
confined to the Shiny app; it has no bearing on fugazibase data consistency
(no `.rda` files or `R/export_fugazibase_data.R` are touched).

## Implementation

### 1. Replace `inst/shiny/Fugazetteer/recap_template.Rmd` with `recap_template.qmd`

- YAML header: swap `output: html_document: self_contained: true` for
  `format: typst:` (add `papersize:` — confirm `a4` vs `letter` during
  testing). Keep `title:` and `params: gid: NA` unchanged.
- Drop the `<style>` print-CSS block entirely — meaningless for Typst, which
  auto-paginates. Only revisit table sizing if testing shows the tracklist
  needs it (a chunk-scoped `{=typst}` `#set text(size: ...)` snippet, not a
  CSS port).
- Chunk syntax (`{r setup, include=FALSE}` etc.) is unchanged — Quarto
  accepts classic knitr chunk options in `.qmd` files.
- **Map chunk**: no code change needed for the screenshot mechanism itself —
  knitr automatically intercepts htmlwidget output for non-HTML targets and
  rasterizes via `webshot2` when it's installed (confirmed via
  `knitr:::html_screenshot()` / `htmlwidgets:::knit_print.htmlwidget`
  logic). Do add explicit sizing (`out.width`/`out.height` as literal px, or
  `screenshot.opts = list(vwidth=, vheight=)`) so the PDF's map has a
  pinned, consistent size rather than whatever the untested default
  produces. Leave the popup closed (no `onRender()` hook needed) per the
  decision above.
- **Footer chunk and the inline `ctx$url` link right under the heading**:
  both currently emit raw HTML (`<a href>`, `<hr>`) via `cat(..., results='asis')`
  / `HTML(paste0(...))`. This is a Pandoc/rmarkdown HTML-target trick that
  will not survive a Typst render — convert both to plain Pandoc markdown
  (`[text](url)` links, `---` for a rule). This is a real content fix, not
  cosmetic. Note this only affects the template's own copy of this logic —
  `app.R`'s live `recap_link`/`recap_summary_text3` outputs stay raw
  HTML/`HTML()` since the live Shiny UI is unaffected.
- Tracklist chunk (`knitr::kable(...)`) is unchanged — Quarto's typst format
  renders plain markdown/kable tables natively, no raw Typst needed.

### 2. New internal helper: `R/recap_pdf.R`

Add one non-exported (`@noRd`, no `@export`) function, `render_recap_pdf()`,
mirroring cvmachine's `render_cv_typst()` shape:

```r
render_recap_pdf <- function(gid, output_dir, file_stub = "recap") {
  if (!requireNamespace("quarto", quietly = TRUE)) {
    stop("The 'quarto' package is required to export the recap as PDF; ",
         "install it with install.packages('quarto').")
  }
  quarto_bin <- tryCatch(quarto::quarto_path(), error = function(e) "")
  if (!nzchar(quarto_bin)) {
    stop("The Quarto CLI was not found; it is required to export the recap ",
         "as PDF. See https://quarto.org/docs/get-started/.")
  }

  template_src <- system.file("shiny", "Fugazetteer", "recap_template.qmd",
                               package = "Repeatr")
  qmd_path <- file.path(output_dir, paste0(file_stub, ".qmd"))
  file.copy(template_src, qmd_path, overwrite = TRUE)

  quarto::quarto_render(
    input = qmd_path,
    output_format = "typst",
    execute_params = list(gid = gid),
    output_file = paste0(file_stub, ".pdf"),
    quiet = FALSE
  )

  pdf_path <- file.path(output_dir, paste0(file_stub, ".pdf"))
  if (!file.exists(pdf_path)) {
    stop("Quarto render completed but no PDF was produced.")
  }
  pdf_path
}
```

Uses `system.file(..., package = "Repeatr")` to locate the template rather
than a relative path, so the helper is independently callable/testable
without relying on Shiny's working directory. Failures (missing `quarto`
package, missing CLI, missing Chrome inside the Quarto/webshot2 chain,
render errors) all surface as R errors with clear messages — the
downloadHandler catches these and shows a notification per the hard-fail
decision above.

### 3. `inst/shiny/Fugazetteer/app.R` — `output$downloadRecapDoc` (currently ~line 3380)

```r
output$downloadRecapDoc <- downloadHandler(
  filename = function() paste0(datestring, "_Fugazetteer_Recap_", input$search_shows_recap, ".pdf"),
  content = function(file) {
    out_dir <- tempfile("recap_")
    dir.create(out_dir)
    on.exit(unlink(out_dir, recursive = TRUE), add = TRUE)

    pdf_path <- tryCatch(
      Repeatr:::render_recap_pdf(gid = input$search_shows_recap, output_dir = out_dir),
      error = function(e) {
        showNotification(paste("Failed to generate recap PDF:", conditionMessage(e)),
                          type = "error", duration = NULL)
        NULL
      }
    )
    req(pdf_path)
    file.copy(pdf_path, file, overwrite = TRUE)
  }
)
```

Changes from current code: `.html` → `.pdf` extension; a per-request unique
`tempfile()`-based output dir (cleaned up via `on.exit`) instead of a shared
`tempdir()`-root copy — this also incidentally fixes a latent concurrency
bug where two simultaneous downloads would race on the same file path, and
gives Quarto's own render artifacts (`.quarto/` cache, `_files/`) an
isolated place to land; render delegated to `render_recap_pdf()` wrapped in
`tryCatch` with a `showNotification` on failure instead of letting a raw
error hit Shiny's generic download-failed dialog. Since `render_recap_pdf()`
is not exported, `app.R` calls it via `Repeatr:::` (there was no existing
precedent for calling internal package functions from `app.R`, so this
establishes the convention for this case).

### 4. `DESCRIPTION`

Add to **Suggests** (not Imports — this feature is optional/Shiny-only and
shouldn't gate package load or `R CMD check` on machines without Quarto):

```
Suggests:
    heatmaply(>= 1.3.0),
    quarto,
    testthat (>= 3.0.0),
    webshot2
```

(`chromote` is `webshot2`'s own dependency — no separate entry needed unless
Repeatr code calls it directly, which it doesn't here.)

Add a `SystemRequirements:` field documenting the Quarto CLI and a
Chrome/Chromium binary as external dependencies for this feature, noting
that PDF export fails gracefully with a Shiny notification (not a crash) if
either is missing.

### 5. Tests: `tests/testthat/test-recap_pdf.R`

Currently there is **no** existing test coverage for `recap()`, the
template, or the download mechanism — this is a fresh addition. Add,
mirroring cvmachine's test pattern:

```r
quarto_pdf_available <- function() {
  if (!requireNamespace("quarto", quietly = TRUE)) return(FALSE)
  nzchar(tryCatch(quarto::quarto_path(), error = function(e) ""))
}

test_that("render_recap_pdf() produces a non-empty PDF for a sample gid", {
  skip_on_cran()
  skip_if_not(quarto_pdf_available())
  out_dir <- tempfile("recap_test_"); dir.create(out_dir)
  on.exit(unlink(out_dir, recursive = TRUE))
  pdf_path <- render_recap_pdf(gid = "washington-dc-usa-90387", output_dir = out_dir)
  expect_true(file.exists(pdf_path))
  expect_gt(file.size(pdf_path), 0)
})
```

Because `quarto`/`webshot2` are in Suggests and only touched behind
`requireNamespace()` guards inside `render_recap_pdf()`, and the test skips
when unavailable, this introduces no `R CMD check` NOTEs/errors on a machine
lacking either. `app.R` itself isn't parsed by `R CMD check`'s
namespace/undefined-global checks (Shiny app scripts under `inst/` are
exempt), so only `R/recap_pdf.R` needs the Suggests-guard discipline.

## Verification

**Local, before considering this done:**
1. Confirm `webshot2`/`chromote` are installed locally and `chromote` finds
   a Chrome binary (separately from `quarto check`'s own Chrome detection,
   which may not be the identical lookup).
2. Render `recap_template.qmd` directly via `quarto::quarto_render()` for a
   sample show with a recording (exercises the tracklist path) and one
   without (exercises the "no recording" text branch). Open each PDF and
   confirm: heading/link render as real hyperlinks (not broken raw HTML),
   all prose paragraphs present, map appears as a static street-level image
   matching the live Leaflet tiles/marker (no popup, as decided), tracklist
   table renders or is correctly omitted, footer links work as markdown
   links.
3. Run the same flow through `output$downloadRecapDoc` inside a locally
   running `shiny::runApp()` session (not just the CLI render) to catch any
   working-directory/env differences from Shiny's `content=function(file)`
   context.
4. Deliberately break the Chrome/webshot2 path (e.g. temporarily rename the
   Chrome binary) and confirm the download fails with a clear
   `showNotification` rather than a cryptic generic Shiny error.
5. `R CMD check` — confirm 0 errors/warnings/notes, and confirm it still
   passes (via skip) on a hypothetical machine without `quarto`/`webshot2`
   installed (can simulate by checking the guard logic manually).

**After deploying to Posit Connect Cloud (the one real open risk):**
- Do an end-to-end recap PDF download on the live deployed app. Confirm the
  Quarto CLI is present there (Connect environments generally bundle
  Quarto, but version/availability should be confirmed for this deployment)
  and, critically, that headless Chrome is reachable by `chromote` — this is
  unverified, since cvmachine's own Quarto+Typst deployment there never
  needed raster screenshots (pure text/Typst). If Chrome turns out to be
  missing on Connect Cloud, the hard-fail behavior means the PDF button is
  fully broken there until a graceful-degradation fallback (skip the map,
  print a note) is added as a follow-up.

## Housekeeping (per CLAUDE.md conventions)

- Save this plan to `inst/notes/<timestamp>_plan_issue271-recap-pdf-download.md`.
- After implementation, write session notes to
  `inst/notes/<timestamp>_notes_issue271-recap-pdf-download.md` covering what
  changed, why, and the key decisions above (map screenshot approach, popup
  left closed, hard-fail-on-missing-Chrome).
- Bump `DESCRIPTION` version by one increment (`0.0.0.9278` → `0.0.0.9279`).
- Update package documentation (`R/recap_pdf.R` — even non-exported
  functions should get a one-line comment, not roxygen docs, per project
  convention observed in similar internal helpers) and confirm fugazibase
  docs need no changes (confirmed above: no data touched).
