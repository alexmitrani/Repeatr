# Plan: GitHub issue #257 — group repetitive rendition-length notes in recap

## Context

Issue [#257](https://github.com/alexmitrani/Repeatr/issues/257) (reported by
alexmitrani, open, no labels) is on the Fugazetteer Shiny app's "recap" tab
(single-show summary page; see [[project_recap_tab_shipped]]). The tab's
`paragraph3` "notes" section can currently emit a run of near-identical
consecutive sentences, one per song, e.g. (from
`berlin-germany-62892`, the show the issue cites):

> This show includes one of the 5% longest recorded renditions of latin
> roots. This show includes one of the 5% longest recorded renditions of
> suggestion. This show includes one of the 5% shortest recorded renditions
> of sweet and low. This show includes the longest rendition of repeater
> recorded anywhere in the Fugazi Live Series. This show includes one of the
> 5% longest recorded renditions of song #1. This show includes one of the
> 5% longest recorded renditions of glueman.

The issue asks that this be grouped instead, e.g.:

> This show includes the longest rendition of repeater recorded anywhere in
> the Fugazi Live Series. This show includes one of the 5% longest recorded
> renditions of latin roots, suggestion, song #1 and glueman. This show
> includes one of the 5% shortest recorded renditions of sweet and low.

Requirements from the issue:
- Group all song-length notes together.
- Order: longest-ever-recorded first, then percentile-longest, then
  (by the same grouping logic) shortest-ever-recorded, then
  percentile-shortest.
- Correct singular/plural phrasing depending on how many songs land in each
  bucket.
- Add a note about possible incomplete recording when a flagged short
  rendition is under a parameterized duration (default 60 seconds) — and
  (per user clarification) that note must name specifically which song(s)
  triggered it, not just restate the whole short-rendition group.

## Where this lives

All of `paragraph3`'s prose is assembled inside `R/recap.R` itself (never in
`app.R` or `inst/shiny/Fugazetteer/recap_template.Rmd` — confirmed the
template just does `cat(ctx$paragraph3)`), per the existing project
convention of keeping the two call sites from drifting apart.

The function to rewrite is **`note_record_rendition()`**
(`R/recap.R:219-264`), called from `note_pieces` in `recap()` at
`R/recap.R:901`. It currently loops per-row with `vapply` and returns one
full sentence per eligible song — that per-row loop is the repetition
source. Its sibling, **`note_first_last_rendition()`**
(`R/recap.R:275-326`), already does the grouping pattern we want (bucket
titles into `only_titles`/`debut_titles`/`farewell_titles`, then one
`oxford_join()`-based sentence per non-empty bucket) — reuse that shape.

Existing building blocks to reuse, not reinvent:
- `oxford_join(x, force_comma = FALSE)` (`R/recap.R:31-42`) — "A", "A and
  B", "A, B, and C" joiner. Note it always uses the Oxford comma for 3+
  items; the issue's own hand-written example omits it ("song #1 and
  glueman") but that reads as informal phrasing, not a spec — stay
  consistent with the rest of the app's Oxford-comma convention rather than
  special-casing this one sentence.
- The `recap()` parameter-threading pattern established by
  `rendition_percentile`/`rendition_min_count` (added in `f859c7c5`,
  `85c6e385`) — new thresholds get a `recap()` argument with a roxygen
  `@param`, threaded straight down into the `note_*` function.

## Implementation

### 1. Rewrite `note_record_rendition()`

Replace the `vapply`-per-row body with:

1. Compute the same per-row classification as today (`top_fraction`,
   `bottom_fraction`, record vs. percentile), but instead of building a
   sentence per row, sort each eligible row's `title` into exactly one of
   four buckets, in the same priority order the current `if/else if` chain
   already uses (a row only ever matches one branch):
   - `longest_record` — `row_minutes >= max(all_minutes)`
   - `longest_percentile` — `top_fraction <= percentile/100`
   - `shortest_record` — `row_minutes <= min(all_minutes)`
   - `shortest_percentile` — `bottom_fraction <= percentile/100`
   Also record, for rows landing in either shortest bucket, whether
   `row_minutes * 60 < incomplete_seconds` (new parameter, see below).
2. Build one sentence per non-empty bucket (skip empty ones), in this fixed
   order, using the same singular/plural branching style as
   `note_first_last_rendition()` (`length==1` → literal title, else
   `oxford_join()`):
   - `longest_record`: "This show includes the longest rendition of X
     recorded anywhere in the Fugazi Live Series." / "...the longest
     renditions of X, Y, and Z recorded anywhere...".
   - `longest_percentile`: "This show includes one of the {percentile}%
     longest recorded renditions of X." / "...of X, Y, and Z."
   - `shortest_record`: "This show includes the shortest rendition of X
     recorded anywhere in the Fugazi Live Series." / plural form — **drop**
     today's unconditional ", which may indicate the recording is
     incomplete." clause (that becomes its own gated note, see next point).
   - `shortest_percentile`: "This show includes one of the {percentile}%
     shortest recorded renditions of X." / plural form.
3. Incomplete-recording note: collect the titles (from **both** shortest
   buckets combined) whose duration is under `incomplete_seconds`, and if
   that list is non-empty, append one more sentence naming exactly those
   titles: "The recording of X may be incomplete." (one title) / "The
   recordings of X and Y may be incomplete." (`oxford_join`, several) — per
   the user's explicit requirement, this must name only the specific
   song(s) under the threshold, not the whole shortest-bucket group.
4. Join all produced sentences with `paste(..., collapse = " ")`, same as
   today; return `NA_character_` if nothing fired.

Keep the existing `NA`-stripping guards (missing `duration_data_da` rows,
`NA` `row_minutes`) exactly as they are today (`R/recap.R:236-240`).

### 2. New parameter: `incomplete_seconds`

- Add `incomplete_seconds = 60` as a `note_record_rendition()` parameter.
- Add `rendition_incomplete_seconds = 60` as a new `recap()` parameter
  (`R/recap.R:474-482`), documented with a roxygen `@param` alongside the
  existing `rendition_percentile`/`rendition_min_count` docs
  (`R/recap.R:460-461`), and threaded into the `note_record_rendition()`
  call at `R/recap.R:901`.
- Convert seconds → minutes for the comparison (`incomplete_seconds / 60`),
  since `minutes` throughout this function is fractional minutes, not
  seconds.

### 3. Documentation

- Run `devtools::document()` to regenerate `man/recap.Rd` with the new
  `rendition_incomplete_seconds` parameter.
- Update the "recap" section of `vignettes/Fugazetteer.Rmd`
  (`vignettes/Fugazetteer.Rmd:338`), which currently says renditions are
  "called out if it's the longest or shortest ever recorded, or still
  unusually long or short" — add a short clause noting that same-direction
  notes are grouped into one sentence, and that an unusually short
  rendition under the (default 60s) threshold gets an additional note
  identifying it as possibly incomplete.

### 4. Version bump & session notes

- Bump `DESCRIPTION`'s version by one increment (currently `0.0.0.9246`).
- Write session notes to `./inst/notes/YYYYMMDDHHMM_notes_recap-group-rendition-notes.md`
  (today's date, per CLAUDE.md convention) covering what changed, the bucket
  ordering decision, and the Oxford-comma-vs-issue-example call.

## Verification

- Regenerate `berlin-germany-62892`'s `paragraph3` via
  `recap(mygid = "berlin-germany-62892")$context$paragraph3` and confirm it
  now reads as one grouped sentence per direction/tier (matching the
  issue's own desired grouping, modulo the Oxford comma), instead of six
  separate per-song sentences.
- Re-run the same regression sweep the prior percentile-notes session used
  (the ~19 gids referenced in
  `inst/notes/202608171400_notes_recap-first-last-percentile-renditions.md`)
  and confirm no unrelated notes changed.
- Specifically construct/find a case where a flagged short rendition's
  duration is under 60 seconds and confirm the new incomplete-recording
  sentence appears and names only that title — and a case with a short
  rendition well over 60 seconds and confirm no incomplete-recording
  sentence is added at all (today's code would have wrongly always added
  the clause in the record-shortest case).
- Confirm `rendition_incomplete_seconds` actually changes behavior (e.g. a
  very large value like `600` suppresses the incomplete note on a case that
  triggers it at the default `60`; `0` suppresses it entirely).
- Confirm defaults reproduce the same *set* of flagged songs as before this
  change (only the sentence grouping/wording changes, not which songs get
  flagged) — diff old vs. new `paragraph3` output across the regression
  sweep and confirm the only differences are the intended
  grouping/wording/incomplete-note changes.
- Load the Shiny app's recap tab for `berlin-germany-62892` and confirm the
  notes paragraph renders correctly (and the downloadable "takeaway"
  document too, since it shares the same `recap()` call).
