# Session notes: Issue #271 — Recap tab PDF download via Quarto + Typst

Plan: [`202609032322_plan_issue271-recap-pdf-download.md`](202609032322_plan_issue271-recap-pdf-download.md).

## What changed

- `inst/shiny/Fugazetteer/recap_template.Rmd` deleted, replaced by
  `inst/shiny/Fugazetteer/recap_template.qmd` (`format: typst`, `papersize: a4`).
  Raw HTML in the inline `ctx$url` link and the footer was converted to plain
  Pandoc markdown (`[text](url)` links, `---` rule) since raw HTML doesn't
  survive a Typst render.
- New `R/recap_pdf.R`: one non-exported `render_recap_pdf(gid, output_dir,
  file_stub)` function that copies the qmd template to a working dir and
  renders it to PDF via `quarto::quarto_render(..., output_format = "typst")`,
  guarded by `requireNamespace("quarto")` and `quarto::quarto_path()` checks.
- `inst/shiny/Fugazetteer/app.R`'s `output$downloadRecapDoc`: filename
  extension changed `.html` → `.pdf`; render now goes through
  `Repeatr:::render_recap_pdf()` in a per-request `tempfile()` dir (cleaned
  up via `on.exit`), wrapped in `tryCatch` with a `showNotification` +
  `req()` on failure instead of letting a raw render error hit Shiny's
  generic download-failed dialog.
- `DESCRIPTION`: added `quarto` and `webshot2` to `Suggests`, added a
  `SystemRequirements:` field documenting the Quarto CLI + a Chrome/Chromium
  binary as external dependencies for this one feature.
- New `tests/testthat/test-recap_pdf.R`: one test rendering a real sample
  gid end-to-end, skipped when `quarto` isn't available.
- Version bumped `0.0.0.9278` → `0.0.0.9279`.

## Key decisions

- **Map**: the interactive Leaflet map is rasterized to a static PNG via a
  headless-Chrome screenshot (`webshot2`/`chromote`), not simplified or
  dropped. This needed no explicit screenshot code in the qmd — knitr
  automatically intercepts htmlwidget output for non-HTML render targets and
  rasterizes it when `webshot2` is installed. The map chunk only needed
  explicit sizing (`screenshot.opts = list(vwidth = 700, vheight = 500)` for
  the capture resolution, `out.width = "90%"` for the in-document display
  width) to look right on the page.
- **Popup**: left closed in the screenshot (its info — date/venue/city/
  country — is already in the prose/heading elsewhere in the PDF).
- **Missing-Chrome fallback**: hard-fail with a `showNotification`, not
  graceful degradation. Ship the simple version; revisit only if testing
  against the real Posit Connect Cloud deployment shows Chrome is actually
  missing there.
- `recap()` in `R/recap.R` needed no changes — it was already
  template-agnostic. No fugazibase impact (no data files touched).

## What testing surfaced beyond the plan

The plan anticipated the map/table might need Typst-specific sizing but
didn't know the specifics until actually rendering:

- **Map overflow**: the first render (`out.width="700px"`) produced a map
  image that visibly ran off the right edge of the A4 page — pandoc/typst
  doesn't treat a literal `"700px"` `out.width` as page-relative. Fixed by
  switching to `out.width="90%"` (a percentage, which Typst does scale to
  the text width), while keeping `screenshot.opts` for the actual capture
  resolution.
- **Table overflow**: the tracklist has 11 columns (track, title, minutes,
  mins_mean, position, pos_mean, rendition, renditions, transition,
  transitions, release_date) and at the document's default text size the
  table ran wider than the page, garbling column headers. Fixed by wrapping
  the tracklist chunk in a `#set text(size: 8pt)` / `#set text(size: 11pt)`
  pair of raw `{=typst}` blocks — shrink before the table, restore the
  original body size after. This is a real Typst-specific technique (not
  foreseeable from the CSS-based approach the old HTML template used) and is
  the mechanism the plan flagged as a "revisit if needed" contingency.
- **`app.R` non-exported call**: the plan's app.R code sketch called
  `render_recap_pdf(...)` as a bare name, but since `app.R` only does
  `library(Repeatr)` (attaching exported symbols only) and
  `render_recap_pdf()` is intentionally not exported, the bare-name call
  would have failed with "could not find function" at runtime. Fixed to
  `Repeatr:::render_recap_pdf(...)`. There was no prior precedent in `app.R`
  for calling a non-exported package function, so this establishes the
  pattern for this case.

## Verification performed

- Rendered `recap_template.qmd` directly via `render_recap_pdf()` for both a
  recorded show (`washington-dc-usa-90387` — exercises the tracklist path)
  and an unrecorded show (`berlin-germany-120389` — exercises the "no
  recording" text branch). Read both resulting PDFs in full: heading/link
  render as real hyperlinks, all prose paragraphs present, map renders as a
  correctly-sized static street-level tile image (no popup, as decided),
  tracklist table fits the page cleanly, footer links work as plain
  markdown links.
- Simulated the exact `output$downloadRecapDoc` `content()` function body
  standalone (Chrome extension for a literal live-browser click-test wasn't
  connected in this session) — confirmed it produces an identical PDF to
  the direct `render_recap_pdf()` call.
- Simulated the failure path with an invalid gid: confirmed the error is
  caught by `tryCatch`, `pdf_path` stays `NULL`, and the function returns
  cleanly without an uncaught error (matching the hard-fail-with-
  notification design).
- `tests/testthat/test-recap_pdf.R` passes (`Sys.setenv(NOT_CRAN = "true")`
  needed locally since `skip_on_cran()` otherwise skips outside
  `devtools::test()`/`R CMD check`).
- `devtools::check()` (with `--no-build-vignettes` for speed, since
  vignettes are unrelated to this change): 0 errors. The only warnings/notes
  present are pre-existing/unrelated to this change — vignette-build
  warnings caused by the `--no-build-vignettes` flag itself, and a
  pre-existing NOTE about a hidden `inst/shiny/Fugazetteer/.posit` directory
  (a Posit Connect deployment artifact, not introduced by this change). A
  full check including vignette rebuilding failed locally with "Pandoc is
  required to build R Markdown vignettes but not available" — a known local
  environment gap (the `callr` subprocess `devtools::check()` uses doesn't
  inherit `RSTUDIO_PANDOC`; see the `reference_r_environment_repeatr` memory
  note), unrelated to this PR's changes since it doesn't touch vignettes.

## Follow-up fixes (post-implementation feedback)

After the initial implementation, the user reviewed a rendered PDF and
flagged two more issues, plus asked a font-matching question:

- **Table header overlap**: a screenshot showed "minutes"/"mins_mean" and
  "position"/"pos_mean" headers visually overlapping and illegible (not
  just the earlier-noted text-extraction concatenation artifact — this was
  a real rendering defect). Fixed by adding `margin: {x: 1.5cm, y: 2cm}` to
  the qmd's typst format YAML (down from Typst's ~2.5cm default), giving
  the 11-column table enough width for the 8pt headers to wrap without
  colliding.
- **Notes not bulleted**: the "Notes:" section rendered as one flowing
  paragraph instead of a bullet list. Cause: `ctx$paragraph3` (built in
  `R/recap.R`) is raw HTML (`<p><strong>Notes:</strong></p><ul><li>...`),
  which rendered fine in the old HTML template but gets its tags silently
  stripped by pandoc when targeting Typst, collapsing the list into plain
  text. Fixed entirely within the qmd (not `recap.R`, keeping `recap()`
  template-agnostic as planned): the `summary-text-3` chunk now parses
  `ctx$paragraph3` with `xml2::read_html()` + `rvest::html_elements(...,
  "li")` (both already Imports — no new dependency) and re-emits it as
  plain Pandoc markdown bullets (`- item`) instead of `cat()`-ing the raw
  HTML.
- **Font matching**: the user asked whether the PDF uses the same
  Inconsolata font as the Shiny app's UI. It didn't — the app's Inconsolata
  is CSS-embedded `.woff2` files for the browser (see
  `202608230610_notes_bundle-inconsolata-font-locally.md`), a completely
  separate mechanism from Typst's PDF rendering, and Typst doesn't support
  `.woff2` at all (confirmed via `typst fonts --font-path ... --ignore-
  system-fonts` — the bundled woff2 files simply don't appear). After
  confirming the user wanted font parity despite Inconsolata being a
  monospace face unusual for prose, added two new TTF assets fetched via
  `sysfonts::font_add_google("Inconsolata")` (a one-time, user-approved
  download, not a runtime dependency):
  `inst/shiny/Fugazetteer/fonts/Inconsolata-{Regular,Bold}.ttf`. Wired up
  in the qmd via `mainfont: "Inconsolata"` and `font-paths: ["__FONT_DIR__"]`
  (note: the correct Quarto YAML key is `font-paths`, kebab-case — plain
  `fontpaths` is silently ignored, passed through as inert metadata instead
  of reaching the typst compiler's `--font-path` flag; this cost a
  debugging round-trip). `__FONT_DIR__` is a placeholder `render_recap_pdf()`
  substitutes with the render's own absolute `output_dir` at copy time
  (`gsub()` on the qmd's lines before `writeLines()`), since a relative
  `font-paths: ["."]` didn't reliably resolve to the qmd's directory and
  `execute_params` can't set a static format-level YAML option like this.
  `render_recap_pdf()` also copies both TTF files into `output_dir`
  alongside the qmd (matching the font-loading-sandbox lesson from
  cvmachine's own Quarto+Typst deployment work, even though this wasn't
  directly hit here).

## Deployment fixes (found only after redeploying to Posit Connect Cloud)

The open item above was resolved by the user actually redeploying and
hitting two real errors in sequence - both fixed in this round, each
requiring a redeploy+retest to confirm since neither is reproducible
locally (this dev machine already has `quarto`/`webshot2`/Chrome installed,
so both bugs are specific to what's/isn't present on Posit Connect Cloud's
environment):

1. **"The 'quarto' package is required..."** — the very first download
   attempt on the deployed app failed immediately with our own guard's
   error message. Root cause: `quarto` and `webshot2` were declared in
   `Suggests`, not `Imports`. `Suggests` is correct for genuinely optional
   CRAN-style soft dependencies (and is what `R CMD check`'s "declared
   Imports must be used" check expects for a bare `requireNamespace()`
   guard), but it also means a deployment tool's dependency scanner isn't
   obligated to install it - and evidently Posit Connect Cloud's didn't.
   Since PDF export is no longer optional for this app (that's the whole
   point of issue #271), fix: moved `quarto` and `webshot2` to `Imports`.
2. **Chrome SIGABRT crash on launch** — after the Imports fix was deployed,
   the download got further (quarto itself now ran) but crashed with a
   native Chrome crash (signal 6, `sys/devices/system/cpu/cpu0/cpufreq/
   scaling_max_freq: No such file or directory` followed by a SIGABRT
   backtrace through `chromote:::launch_chrome`) - this is the classic
   "headless Chrome needs `--no-sandbox` inside a restricted container"
   failure mode, well documented in Puppeteer/Playwright Docker deployment
   guides. `chromote` already has heuristics for this
   (`chromote:::default_chrome_args()` auto-adds `--no-sandbox` and
   `--disable-dev-shm-usage` when `is_inside_docker()`/`is_missing_linux_user()`
   detect a container - checking for `/.dockerenv`, `/proc/self/cgroup`
   containing "docker", or `id` failing), but this didn't trigger on Posit
   Connect Cloud's container (likely not using classic Docker markers).
   Fix: force `--no-sandbox`, `--disable-dev-shm-usage`, and `--disable-gpu`
   unconditionally via `chromote::set_chrome_args()` in the qmd's own
   `setup` chunk - **not** in `R/recap_pdf.R`, because `quarto::quarto_render()`
   shells out to the Quarto CLI, which spawns a *separate* R subprocess to
   actually run the qmd's knitr chunks; any chromote config set in our own
   calling R session (inside `render_recap_pdf()`) would never reach that
   child process's in-memory `chromote:::globals`. This mirrors why
   cvmachine had to use an env var (`TYPST_FONT_PATHS`) for its own
   subprocess-boundary problem - env vars propagate across that boundary,
   in-memory R state doesn't. Setting the args at the top of the qmd's own
   `setup` chunk sidesteps the whole problem, since that code runs in the
   same session that later triggers the first Chrome launch.

Follow-on R CMD check fix from moving `webshot2` to Imports: it triggered a
new "Namespace in Imports field not imported from: 'webshot2' - All
declared Imports should be used" NOTE, since nothing in `R/` code calls
`webshot2::` directly (it's only ever invoked internally by knitr, and only
from qmd-chunk code, which `R CMD check` doesn't scan). The
`requireNamespace()`-guard idiom that silences this for `Suggests` packages
does **not** satisfy it for `Imports` packages - confirmed by testing
before finding the right fix. Resolved with a standalone
`#' @importFrom webshot2 webshot \n NULL` declaration in `R/recap_pdf.R`
(a real NAMESPACE `importFrom` entry, the standard pattern for "hard
dependency used only by another package's internal machinery, never called
directly by our own code"), regenerated via `devtools::document()`.
Also replaced the earlier `requireNamespace("webshot2", ...)` runtime guard
with a `chromote::find_chrome()` pre-flight check instead - redundant once
`webshot2` is a guaranteed-installed Import (package-load itself would fail
without it), and a check for the actual Chrome *binary* being locatable is
more useful/non-redundant than re-checking an R package we already know is
installed.

Version bumped `0.0.0.9280` → `0.0.0.9281` (Imports fix) → `0.0.0.9282`
(sandbox-args + NOTE fix). `R CMD check` re-run clean after each change (0
errors; same two pre-existing/unrelated warnings/note as before - see
Verification section above).

The `--no-sandbox`/etc. fix worked - the next redeploy got a working PDF
download on Posit Connect Cloud (the Chrome crash is resolved). Two things
were reported after that redeploy:

- **General app layout looked broken** (tiny unstyled content, big blank
  space) in a screenshot of the deployed app. Investigated by launching the
  app locally and screenshotting it with headless Chrome
  (`chrome.exe --headless=new --screenshot=...`), which *also* showed the
  same broken-looking layout - seemingly a local repro. Set up a
  `git worktree` at the pre-feature commit to compare against, but before
  finishing that comparison the user clarified: the app looks fine locally
  in an actual browser (tested in Positron), and closing/reopening Chrome
  with a different zoom level fixed the deployed version too. So this was
  a Chrome rendering/zoom quirk, not a real bug - the headless-Chrome
  screenshot was misleading (most likely captured before Shiny's
  websocket-driven client init and `bslib`'s CSS had fully settled, since a
  single `--screenshot` capture doesn't wait for that). Worktree removed,
  no code change made for this. **Lesson for future sessions**: don't trust
  a single headless-Chrome `--screenshot` snapshot as a reliable stand-in
  for "does this Shiny app render correctly" without cross-checking against
  a real interactive session first - it can catch the page mid-init.
- **PDF font was Typst's default, not Inconsolata** on the deployed app,
  despite rendering correctly locally on every prior local test. This is
  the exact symptom cvmachine's own Quarto+Typst work already diagnosed for
  a different font: Typst silently falls back to its default font (no hard
  error, no warning surfaced to the user) when it can't read the font files
  at the given `font-paths`, and that failure mode is specific to certain
  cloud sandboxes even when the same code works locally. Applied
  cvmachine's full fix in `render_recap_pdf()` (`R/recap_pdf.R`): explicit
  `Sys.chmod(..., mode = "0644")` on the copied font files (forcing
  permissions rather than trusting whatever `file.copy()` produces), plus
  `Sys.setenv(TYPST_FONT_PATHS = font_dir)` as a redundant second path to
  the same directory alongside the qmd's `font-paths:` YAML key - unlike
  the Chrome-args problem, `TYPST_FONT_PATHS` is an environment variable
  Typst itself reads directly, and env vars *do* propagate across the
  quarto-CLI subprocess boundary (this is why cvmachine used the same
  mechanism for their own font problem), so setting it in `render_recap_pdf()`
  itself (not the qmd) is correct here, unlike the Chrome-args fix.
  **Not yet confirmed fixed on Posit Connect Cloud** - verified only that
  it doesn't break the local render (identical output, still correctly
  showing Inconsolata). Needs a redeploy+retest to confirm the actual fix,
  same as the two fixes above required.

**That fix did not work** - the user redeployed and checked the actual
Posit Connect Cloud logs directly this time, which showed the exact same
`warning: unknown font family: inconsolata` as the earlier local failure
(before the `fontpaths` → `font-paths` key correction), even though the
logged metadata dump showed `font-paths:` correctly resolved to an
absolute path with real files confirmed present there. Re-investigated
cvmachine's actual current code (not just prior session summaries) to
compare directly:

- cvmachine's own qmd YAML actually uses `fontpaths` (no hyphen) - the
  same spelling this session found broken locally and corrected to the
  schema-valid `font-paths` (confirmed via Quarto's own
  yaml-intelligence-resources.json schema file, which lists `font-paths`
  and not `fontpaths`). cvmachine's own session notes
  (`inst/notes/202608282326_notes_issue-7-pdf-typst-export.md` in that
  repo) admit they were never sure the YAML key was what fixed their bug -
  their working theory is `Sys.setenv(TYPST_FONT_PATHS = ...)` was the
  actual fix, not the (possibly-also-wrong) YAML key. That doesn't
  directly explain this case though, since Repeatr already had both the
  schema-correct key *and* the env var set, and it still failed.
- Root-caused the more likely explanation instead: the previous
  implementation baked `font-paths` into the qmd's *static* YAML via
  `gsub()` string-substitution of a `__FONT_DIR__` placeholder - a fragile
  mechanism with no guarantee quarto's YAML-frontmatter-merging behaves
  identically across quarto versions/platforms. `quarto::quarto_render()`
  has a proper `metadata` parameter for exactly this (per its own source,
  `quarto:::quarto_render()` writes it to a temp YAML file and passes
  `--metadata-file <path>` to the CLI - the standard, version-stable way
  to override format options at render time, not a home-grown text hack).

Switched to it: removed `font-paths` (and the `__FONT_DIR__`
placeholder/gsub machinery) from `recap_template.qmd`'s static YAML
entirely, keeping only `mainfont: "Inconsolata"` there; `render_recap_pdf()`
now copies the qmd verbatim (`file.copy()`, no more `readLines`/`gsub`/
`writeLines`) and passes
`metadata = list(format = list(typst = list(`font-paths` = font_dir)))`
directly to `quarto::quarto_render()`. `Sys.chmod()`/`Sys.setenv(TYPST_FONT_PATHS)`
kept as before. Verified locally: renders identically, no font warnings,
Inconsolata still correctly applied throughout. **Also not yet confirmed
on Posit Connect Cloud** - this is a genuinely different, more robust
mechanism than the previous attempt, but still unverified against the
actual failure, which only reproduces there.

**That fix didn't work either** - the user checked the Posit Connect Cloud
logs directly again: the metadata dump confirmed `font-paths` correctly
resolved to an absolute path via the new `--metadata-file` mechanism (so
that layer is proven to work, ruling out the YAML-substitution fragility
theory), yet Typst still logged the identical `unknown font family:
inconsolata` warning. Since the *path-delivery* mechanism is now confirmed
correct via two independently different routes (frontmatter substitution,
then `--metadata-file`) and both failed identically, the problem is likely
downstream of that entirely - either the font files aren't actually present
at that path when Typst compiles on that host, or something in that
sandbox blocks Typst's process specifically from reading them regardless of
permissions.

Rather than guess a third fix blind, added targeted diagnostic logging to
`render_recap_pdf()` (`R/recap_pdf.R`) instead - printed via `message()`
right before the `quarto::quarto_render()` call, so it lands in the same
log stream the user is already reading: `fonts_src` (the resolved
`system.file()` path and whether it's non-empty - a `system.file()` miss
would return `""`, and `file.copy(character(0), ...)` silently copies
nothing without erroring, which was the leading unverified hypothesis),
the list of font files found there, and for each file actually copied into
`output_dir`: `file.exists()`, `file.access(mode = 4)` (readable), and
`file.size()`. This is deliberately **not a fix attempt** - purely
instrumentation to get real evidence from the failing environment instead
of another speculative change, since two speculative fixes in a row have
already failed and burned real redeploy cycles. Confirmed locally the
diagnostic block prints sane values (real absolute path, both files
`exists=TRUE readable=TRUE size=~100000`) without otherwise changing
render behavior.

The diagnostics came back and settled the open questions definitively:
`fonts_src` resolved correctly on Posit Connect Cloud
(`/cloud/lib/x86_64-pc-linux-gnu-library/4.5/Repeatr/shiny/Fugazetteer/fonts`,
both `.ttf` files found there), and both copies in the render's `output_dir`
showed `exists=TRUE readable=TRUE` with byte-for-byte correct sizes
(102148/101748, identical to local) - ruling out both leading hypotheses
(packaging/deployment miss, and file-level permission/corruption). Deployed
typst version wasn't captured this round (added after this test), but the
`font-paths` metadata dump was again confirmed correctly delivered. Yet
Typst still logged the identical `unknown font family: inconsolata`
warning. So: correct path, correct real files, confirmed readable by our
own process, delivered via two independent mechanisms - and it still
fails. That's strong evidence the remaining gap isn't in path/file
plumbing at all.

Per the user's suggestion, re-investigated cvmachine's actual Shiny-app
deployment context specifically (not just the render function, which the
earlier investigation already covered) via a fresh, more targeted
sub-agent pass. Key finding: cvmachine's own font fix was **never actually
isolated** - their code comment
(`render_cv_typst.R:370-390` in that repo, as of their HEAD) says outright
it wasn't worth another deploy round-trip to find out which piece mattered,
and their session notes' leading theory is that `TYPST_FONT_PATHS` (not the
`fontpaths:` YAML key, not the copy/chmod dance) was the actual fix - a
sandboxed-subprocess theory (the `typst` process Quarto spawns can't read
what the parent R process can, even though standard `file.access()` checks
from R report it as readable) matching this session's exact symptom
pattern. Nothing in their Shiny app's own download handler
(`inst/app/app.R:1032-1097` there) does anything font/permission/env-var
specific - it's a thin synchronous wrapper with no `future`/`promises`/
`callr`, no custom temp-dir strategy, no Posit-Connect-specific env
detection affecting the render path. So there's no hidden "the actual
final answer" to port over - Repeatr already had every piece cvmachine
ever tried (fontpaths/font-paths YAML, TYPST_FONT_PATHS, file chmod) and it
still doesn't work, unlike cvmachine's confirmed-working case.

One concrete structural difference did turn up on close comparison,
though: cvmachine copies its font files into a **subdirectory** of
`output_dir` (`output_dir/fonts/`), not into `output_dir` itself, and uses
`file.copy(..., copy.mode = FALSE)` (explicitly discarding the source
file's own permission bits, rather than the previous approach here of
copying with default `copy.mode = TRUE` then chmod-ing after). Neither is
obviously necessary in principle, but since cvmachine's exact structure is
the only version of this fix with confirmed, screenshot-verified success
on a live deployed Shiny app on a cloud host, `render_recap_pdf()` was
changed to mirror it exactly rather than continue iterating on a
from-scratch variant: fonts now go into `output_dir/fonts/`,
`copy.mode = FALSE` is used, and both `TYPST_FONT_PATHS` and the
`quarto_render(metadata=...)` `font-paths` value point at that
subdirectory. Kept the font/typst-version diagnostic logging in place for
this next round too, in case this still doesn't work and more evidence is
needed. Verified locally: identical output, no font warnings, Inconsolata
still correctly applied. **Still not yet confirmed on Posit Connect
Cloud.**

**Matching cvmachine's exact subdirectory/copy.mode structure also didn't
fix it.** Same diagnostics as before (files `exists=TRUE readable=TRUE`,
correct sizes, `font-paths` correctly delivered), plus this round's new
diagnostic revealed the deployed `typst version: typst 0.15.1 (9dfd3a08)` -
**identical** to the local dev machine's version, byte-for-byte matching
build hash. So this also rules out a Quarto/Typst version mismatch as the
explanation.

The user then corrected an assumption in the note above: cvmachine's
Quarto+Typst PDF export continues to work today on Posit Connect Cloud
specifically (not shinyapps.io as the earlier session-notes reference
implied) - so the "different hosting platforms" theory floated above is
wrong. Same platform, same typst version, same overall approach, different
outcome. The user also asked directly whether the code was calling the
font by the right name - a good, sharp question that hadn't actually been
re-verified since the font files were first fetched. Checked properly this
time via `systemfonts::font_info()` (reads the font's own internal
OpenType name table, the same metadata Typst itself matches against, not
just the filename): both files confirmed `family = "Inconsolata"` exactly.
Not a naming mismatch.

Re-investigated cvmachine once more per the user's memory of "something
about reading a font dictionary" - a fresh, narrowly-scoped search (grep
for "dict"/"dictionary"/"registry"/"manifest" across their whole repo, full
read of `R/typst_helpers.R`) found no such structure. The user's memory
most likely conflates `typst_font_weight()`'s inline `weight_suffixes`
lookup vector (for the unrelated SemiBold weight-matching bug) and/or a
one-off external `fontTools.ttLib.TTFont(path)['name']` Python inspection
mentioned only in a code comment - not a checked-in data structure. Nothing
new to port over from this lead.

Given all path/file/version/naming evidence checks out identically to a
working local render, but still fails identically on deployment, the
remaining live theory is that the failure is specific to *how the font
family name reaches Typst's compiler*, not the font/path itself. Found one
real, previously-untried structural difference on closer comparison: this
session's qmd set the font via Pandoc's `mainfont:` YAML key, which
Pandoc's own typst-writer template translates into a
`set text(font: font) if font != none` call in the generated `.typ`
preamble (visible in every failing log - that's literally the line the
warning points at, Pandoc-generated code). cvmachine, by contrast, never
uses `mainfont:` at all - it only ever sets fonts via raw
`text(font: "...", weight: "...")` calls written directly into Typst
content, bypassing Pandoc's translation layer entirely. Switched to match:
removed `mainfont: "Inconsolata"` from the qmd's YAML, added a raw
`` ```{=typst}\n#set text(font: "Inconsolata")\n``` `` block right after
the `setup` chunk instead (`inst/shiny/Fugazetteer/recap_template.qmd`).
Verified locally: renders identically, *zero* font warnings this time
(previously two, one for body text and one for headings, both driven by
the same `mainfont`-derived Pandoc variables) - both resolved by the same
single raw `#set text()` call, since headings never had their own working
font in this session's setup to begin with (no `mainfont`-derived
`heading-family` was ever explicitly configured, so removing the `mainfont`
key was actually a wash for headings specifically, and the raw `#set text()`
now legitimately governs the whole document).

Also added a second, more decisive diagnostic to `render_recap_pdf()`:
`quarto typst fonts --font-path <dir> --ignore-system-fonts`, run directly
against the actual deployed `typst` binary right before the real render.
This is the exact same test that originally confirmed the local setup
worked, early in this whole investigation - run here it should
unambiguously separate "Typst itself can't see this font on this host"
(would also fail to list Inconsolata) from "Quarto's metadata layer isn't
forwarding font-paths to the typst subprocess the way its own dump claims"
(would list Inconsolata successfully, proving the bug is entirely within
Quarto's own translation, independent of the raw-Typst-directive fix
above). Locally this diagnostic correctly lists `Inconsolata` among the
detected families, confirming the diagnostic itself works as intended.

**The raw-Typst-directive change didn't fix it either - but the decisive
diagnostic finally isolated the actual root cause.** The user redeployed
and reported the new log output: `typst fonts --font-path <dir>
--ignore-system-fonts`, run directly against the deployed `typst` binary,
correctly listed `Inconsolata` among the detected families. Yet in the
*same* render, Quarto's own compile of `recap.typ` (containing the raw
`#set text(font: "Inconsolata")` directive from the previous round, at the
exact line the warning pointed at) still logged `unknown font family:
inconsolata`. This is conclusive: Typst itself, given `--font-path`
directly, correctly finds and parses the font on that host - so the font
file, its internal name table, the path, and the typst binary are all
fine. The failure is entirely inside **Quarto's own translation from
whatever font-path configuration it's given (YAML `font-paths:`,
`metadata=` `--metadata-file`, `TYPST_FONT_PATHS` env var - all tried,
all failed identically) into the actual `--font-path` argument it passes
to the `typst compile` subprocess it spawns internally**. Quarto's own
metadata dump showing `font-paths: <correct path>` was a red herring -
apparently just an echo of the document's resolved metadata for logging
purposes, not proof that value reaches the real compile invocation.

Before landing on the fix, also directly addressed two more specific leads
the user raised, both now ruled out with hard evidence rather than
assumption:
- **"Are you sure the code calls the fonts by the right names?"** -
  re-checked with `fontTools.ttLib.TTFont` (the same tool cvmachine's own
  debugging used, reading the font's raw OpenType name table directly, not
  a higher-level R wrapper): both files are genuinely static (no `fvar`
  table - not variable-font instances), nameID 1 (legacy family) =
  `"Inconsolata"` cleanly for both, and neither file even has a nameID
  16/17 (typographic family) entry - so there's no possibility of the
  exact ambiguous-name conflict cvmachine's own SemiBold bug was about
  (their font had a typographic-family name conflicting with its legacy
  one; these Inconsolata files have no typographic-family entry at all to
  conflict with anything).
- **"Cvmachine still works on Posit Connect Cloud today, and I recall
  something about a font dictionary"** - corrected an earlier assumption
  in this file that cvmachine's confirmed fix was on shinyapps.io (the
  user clarified it's the same Posit Connect Cloud platform, still working
  today, ruling out a "different hosting platform" explanation). A
  follow-up targeted search for a "font dictionary/registry" in cvmachine
  found nothing beyond what was already known (`typst_font_weight()`'s
  inline `weight_suffixes` lookup, for the unrelated SemiBold bug) - the
  user's memory most likely conflates that lookup vector with a one-off
  external `fontTools` inspection mentioned only in a code comment there,
  not a checked-in data structure to port over.

**Fix**: since Quarto's own font-path plumbing cannot be trusted regardless
of which of its documented mechanisms is used, `render_recap_pdf()`
(`R/recap_pdf.R`) now bypasses it for the final compile step entirely.
`quarto::quarto_render(..., debug = TRUE)` is still used to run knitr and
produce the intermediate `recap.typ` file (`debug = TRUE` is what makes
Quarto leave that intermediate file in place instead of deleting it after
compiling its own, wrongly-fonted PDF) - but the PDF Quarto itself produces
is then discarded, and `typst compile <recap.typ> <recap.pdf> --font-path
<dir>` is invoked directly via `processx::run()` (added as an explicit
Import, since `render_recap_pdf()` now calls it directly rather than only
via `quarto::quarto_render()`'s own internal use of it), reusing the exact
CLI invocation the diagnostic already proved works on the deployed host.
The former `typst fonts --font-path` diagnostic became a genuine pre-flight
guard rather than a log-only diagnostic: `render_recap_pdf()` now `stop()`s
early with a clear message if Inconsolata isn't found via that direct
check, before wasting time on the full knitr/pandoc render pipeline. The
now-proven-ineffective `metadata = list(format = list(typst = list(...)))`
argument to `quarto_render()` was removed as dead code. `TYPST_FONT_PATHS`
is still set as a harmless legacy fallback, though it's no longer
load-bearing - the direct recompile step is what actually determines the
final PDF's font now, regardless of anything Quarto's own pipeline does or
doesn't honor.

Verified locally end-to-end: full `render_recap_pdf()` run (not just an
isolated test script) produces a PDF with Inconsolata correctly applied
throughout (read the resulting PDF in full - title, headings, prose, table,
footer all correctly show the font), byte-size-consistent with every prior
known-good local render. Also re-verified the failure path still works
cleanly with the restructured function (an invalid gid still produces a
`tryCatch`-catchable error with no uncaught exception, same as before).
`R CMD check` clean (0 errors; same two pre-existing/unrelated
warnings/note as always).

**This fix is structurally different from every prior attempt** - it
doesn't try to get Quarto to do the right thing, it stops depending on
Quarto for this one step at all. Given the diagnostic evidence is about as
direct as evidence gets (the same CLI invocation, run by the same code,
confirmed to work on the exact host where the full pipeline fails), this
is expected to actually resolve it - but per the established pattern in
this file, "verified locally" has not meant "verified on Posit Connect
Cloud" all session, so **still needs a redeploy+test to confirm**.

Version bumped `0.0.0.9280` → `0.0.0.9281` (Imports fix) → `0.0.0.9282`
(sandbox-args + NOTE fix) → `0.0.0.9283` (font permissions/env-var fix) →
`0.0.0.9284` (empty-selection guard + docs) → `0.0.0.9285` (metadata-file
font-paths fix) → `0.0.0.9286` (font diagnostics only, no functional
change) → `0.0.0.9287` (mirror cvmachine's exact subdirectory/copy.mode
structure) → `0.0.0.9288` (raw Typst font directive replacing Pandoc
`mainfont:`, plus a decisive `typst fonts --font-path` diagnostic) →
`0.0.0.9289` (root-cause fix: bypass Quarto's font-path plumbing entirely,
recompile the intermediate .typ directly with typst). `R CMD check`
re-run clean after each change (0 errors; same two pre-existing/unrelated
warnings/note as before - see Verification section above).

## Empty-selection error (found by the user testing the deployed app)

Clicking download with no show selected in `input$search_shows_recap`
crashed through to a raw, very technical error notification (the full
quarto-CLI/knitr backtrace down to `recap()`'s own `mygid must match
exactly one show in shows_data` validation error). Two-part fix in
`inst/shiny/Fugazetteer/app.R`:

- The download button itself (`downloadButton("downloadRecapDoc", "")`,
  previously always visible, outside the `conditionalPanel` that already
  gates the rest of the tab's content on a show being selected) is now
  wrapped in the same `input.search_shows_recap!=''` `conditionalPanel`
  condition - it simply doesn't appear until a show is chosen, matching the
  "should do nothing" half of the request and preventing the whole
  situation.
- Defense-in-depth: `output$downloadRecapDoc`'s `content()` function now
  checks `nzchar(input$search_shows_recap)` first and, if empty, shows a
  friendly `showNotification("Please select a show before downloading the
  recap PDF.", type = "warning")` then `req(FALSE)` to halt cleanly -
  covers any edge case where the button is somehow triggered despite being
  conditionally hidden (e.g. a stale client state), without ever reaching
  `render_recap_pdf()`/the quarto render at all.

Verified: the app starts with no errors with this change (structurally
identical `conditionalPanel` pattern to the one already used successfully
elsewhere on this same tab); the empty-string short-circuit logic itself
was tested standalone and confirmed to halt cleanly with no uncaught
error. Full interactive click-through (confirming the button visually
appears/disappears correctly) wasn't independently verified this session
since no connected browser tool was available - flagged so it's still
worth a quick manual check.

## Documentation updates

Per request, updated docs referencing the recap download's old HTML
format:
- `vignettes/Fugazetteer.Rmd`'s "recap" section: replaced the sentence
  describing a "self-contained HTML take-away document" (plus browser
  print-to-PDF instructions, now obsolete) with one describing the actual
  current behavior - a self-contained PDF download, button only visible
  once a show is selected.
- `R/recap.R`: fixed a stale in-code comment still referring to
  `recap_template.Rmd` (renamed to `.qmd` earlier this session).
