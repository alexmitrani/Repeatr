# Plan: Issue #274 — Recap download PDF improvements

## Context
Issue #274 asks for four more refinements to the recap tab's downloadable PDF
(`inst/shiny/Fugazetteer/recap_template.qmd`, rendered by
`R/recap_pdf.R::render_recap_pdf()` and triggered from
`output$downloadRecapDoc` in `inst/shiny/Fugazetteer/app.R`), building on the
PDF work already shipped in recent commits (`8c966cbf`, `8080d594`):

1. The downloaded filename doesn't sort usefully when several are collected
   together.
2. The page repeats "Fugazetteer Recap" as a generic title when the show
   itself should be the headline.
3. The Fugazi Live Series link has no label explaining what it is.
4. The page is a wall of text/content with no section headings, and the data
   table has no explanation of what its columns mean.

## 1. Filename (app.R)

Current code (`app.R:3385-3386`):
```r
output$downloadRecapDoc <- downloadHandler(
  filename = function() paste0(datestring, "_Fugazetteer_Recap_", input$search_shows_recap, ".pdf"),
```
`datestring` here is the *app-load* timestamp from `datestampr()` (`app.R:56`)
— unrelated to the show, which is why today's downloads look like
`20260907112815_Fugazetteer_Recap_milwaukee-wi-usa-60989.pdf`. Every `gid` in
`shows_data` ends in a numeric suffix (`sub("-[0-9]+$", "", gid)` reliably
strips it — verified against all rows), so the location slug is recoverable
directly from the gid.

Change `filename` to:
```r
filename = function() {
  show_date <- shows_data %>% dplyr::filter(gid == input$search_shows_recap) %>% dplyr::pull(date)
  location_slug <- sub("-[0-9]+$", "", input$search_shows_recap)
  paste0("Fugazetteer_Recap_", format(show_date, "%Y%m%d"), "_", location_slug, ".pdf")
}
```
This produces `Fugazetteer_Recap_19890609_milwaukee-wi-usa.pdf`, matching the
issue's example, and several downloads will now sort in show order.

## 2-4. Template restructuring (recap_template.qmd)

**Title (#2):** Drop the YAML `title: "Fugazetteer — Recap"` field entirely
(Quarto only emits a title block when one is set, so removing it removes the
generic heading). Promote the existing show heading from `##` to `#` so the
show description becomes the document's actual (only) title:
```
# `r ctx$where_played` — `r ctx$datestring`
```

**Link label (#3):** Change
```
[`r ctx$gid`](`r ctx$url`)
```
to
```
Fugazi Live Series link: [`r ctx$gid`](`r ctx$url`)
```

**Section headings (#4):** Add `##` headings around the existing content, in
the order given in the issue, each wrapping the chunk(s) already producing
that content — no change to the underlying prose-generation logic in
`R/recap.R`:
- `## Introduction` — paragraph1 (attendance/tour/location prose)
- `## Recording` — paragraph2, or the "No recording of this show is currently
  available." fallback (unchanged logic)
- `## Notes` — only emitted when `ctx$paragraph3 != ""` (already the
  triggering condition for that chunk; the current bolded `**Notes:**` text
  becomes a real `## Notes` heading, list content unchanged)
- `## Location Map` — the leaflet chunk
- `## Data Table` — the tracklist chunk, gated on `eval=ctx$has_recording`
  (same guard the table itself already uses, so the heading never appears
  over an empty section)

**Column explanation below the table (#4, second half):** Add a short
`results='asis'` chunk after the `tracklist` chunk (still under `## Data
Table`, still `eval=ctx$has_recording`) that prints a plain-language
explanation of the columns, adapted from the existing prose in
`vignettes/Fugazetteer.Rmd`'s `## recap` section (the paragraph starting "If a
recording exists, a detailed tracklist is shown..."), condensed to describe
the table's actual column headers (`minutes (mean)`, `position (mean)`,
`rendition (total)`, `transition (total)`, `release_date`) — i.e. reuse/adapt
that vignette wording rather than writing new copy from scratch, per the
issue's suggestion.

## Verification
- Rebuild/install the package (`devtools::install(quick = TRUE, build =
  FALSE, upgrade = FALSE)`), run the Fugazetteer app, open the recap tab for
  a recorded show and an unrecorded show, and download the PDF for each:
  - confirm filename is `Fugazetteer_Recap_<YYYYMMDD>_<location-slug>.pdf`
  - confirm the show description (not "Fugazetteer — Recap") is the only
    title, at the top
  - confirm "Fugazi Live Series link:" precedes the hyperlink
  - confirm Introduction/Recording/Location Map headings always appear,
    Notes only appears when there are notes, and Data Table (with its
    trailing column explanation) only appears when a recording exists
  - spot-check a show with no notes and one with notes to confirm the Notes
    heading behaves correctly in both cases
- Re-run `R CMD check` to confirm it stays at 0 errors/warnings/notes.
- Update `vignettes/Data-Provenance.Rmd`/docs only if this touches anything
  they describe (it shouldn't — no data changes, only presentation).
- Bump the package version in `DESCRIPTION` (currently `0.0.0.9292`) once
  changes are complete.
- Write session notes and save this plan under `inst/notes/`, per
  `CLAUDE.md` conventions.
