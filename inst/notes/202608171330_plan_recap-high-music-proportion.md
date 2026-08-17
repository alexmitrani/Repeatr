# Plan: address issue #258 (recap — note when music proportion is unusually high)

## Context

GitHub issue #258 ("recap - add note when proportion of music to other seems
unusually high") asks that the recap tab's "Notes:" list flag shows where
non-music content (intros, interludes, encores, outros) makes up an unusually
small share of the recording's total duration, with the text:

> "The estimated proportion of music seems very high - some song durations
> may be exaggerated due to inclusion of interludes and other pauses"

The issue explicitly frames this as a policy update: recap's existing logic
(`R/recap.R`, `note_untracked_interludes()`) already handles the case where
non-song content wasn't tracked *at all* (`music_minutes == minutes`,
proportion exactly 100%) by explaining that song durations may run long
because interludes were never separated out. What's missing is the
in-between case: non-music content *was* tracked, but it's such a small
sliver of the recording (e.g. 98% music, 2% other) that individual song
durations are still probably inflated by uncaptured pauses/crowd noise
bleeding into song tracks. The two situations share the same underlying
concern and are mutually exclusive by construction (one fires only at
exactly 100% music, the other only when it's tracked but still very high),
so they're handled as two branches of one generalized note rather than two
separate notes (see below).

This is a pure prose-generation addition to `recap()`'s existing
`paragraph3` "Notes:" list mechanism (added for issues #250/#251, extended
several times since — see `inst/notes/202608171130_notes_recap-map-scale-exceptional-notes.md`
and `inst/notes/202608171400_notes_recap-first-last-percentile-renditions.md`).
No data files, `data-raw/` scripts, or fugazibase export are affected —
`music_minutes`/`minutes` are already computed live inside `recap()` from
existing data, not stored data. `app.R` and `recap_template.Rmd` both
already render `context$paragraph3` verbatim, so no UI/template wiring is
needed — this is a `R/recap.R`-only change.

Rather than adding a second, separate note function, `note_untracked_interludes()`
itself is generalized: "no non-music content tracked at all" (0%) is just
the extreme end of "non-music content is an implausibly small share of the
total" — both are the same underlying concern (song durations may be
overstated because interludes/pauses weren't cleanly separated out), so one
function with a threshold covers both, matching the issue's framing of this
as a single policy update rather than two unrelated notes.

## Implementation

**Generalize `note_untracked_interludes()`** in `R/recap.R` (~line 393-404):

```r
# When this recording's non-song content (interludes, banter, crowd noise,
# etc.) makes up an implausibly small share of the total duration, song
# durations shown may run long - whether because it wasn't tracked at all
# (0%) or because the tracked split is itself unusually lopsided (below
# `threshold`%). Same underlying concern either way, so one function with a
# threshold, not two.
note_untracked_interludes <- function(music_minutes, minutes, threshold = 5) {

  nonmusic_proportion <- (minutes - music_minutes) / minutes * 100

  if (round(music_minutes, digits = 2) >= round(minutes, digits = 2)) {
    "Interludes and other non-song content were not tracked separately for this recording, so song durations shown may be slightly over-estimated."
  } else if (nonmusic_proportion < threshold) {
    "The estimated proportion of music seems very high - some song durations may be exaggerated due to inclusion of interludes and other pauses."
  } else {
    NA_character_
  }

}
```

- Computes the non-music proportion directly from `music_minutes`/`minutes`
  (not the already-`round()`ed `music_proportion` field), avoiding
  double-rounding.
- `threshold` defaults to `5`. The issue's own "10%" is just the example it
  happened to use to illustrate the idea, not a specified requirement, so
  it isn't hardcoded anywhere — it's a tunable assumption like every other
  "how much counts as noteworthy" cutoff in this file (`rare_track_max_count`,
  `position_deviation_threshold`, `position_edge_threshold`,
  `rendition_percentile`, `rendition_min_count` — see
  `inst/notes/202608171400_notes_recap-first-last-percentile-renditions.md`
  section 5/6, where the user's explicit "I don't like hard-coded
  assumptions" drove the same treatment for other notes).
- The two branches are mutually exclusive by construction (one requires
  `music_minutes >= minutes`, the other requires `music_minutes < minutes`),
  so exactly one message (or none) is ever produced — no duplicate bullets.

**Wire into `recap()`:**
- Add `nonmusic_proportion_threshold = 5` to `recap()`'s signature (~line 534,
  alongside the other note-tuning parameters) and a matching `@param` roxygen
  line (~line 515).
- Update the existing call in the `note_pieces <- c(...)` list (~line 963)
  to pass the new threshold through:
  ```r
  note_untracked_interludes(music_minutes, minutes, threshold = nonmusic_proportion_threshold)
  ```
- No change to `note_pieces`'s structure or ordering — same single call
  site as before.

**Docs:**
- Run `devtools::document()` to regenerate `man/recap.Rd` for the new
  parameter.
- Add a short clause to the "recap" section of `vignettes/Fugazetteer.Rmd`
  (~line 334, the sentence listing note types — "a soundcheck, ... and other
  one-off curiosities") mentioning the new high-music-proportion note.
- No fugazibase-side documentation changes needed (no data shape changed).

**Version:** bump `DESCRIPTION` by one increment.

**Session notes:** write `inst/notes/<timestamp>_notes_recap-high-music-proportion.md`
summarizing the change, decisions, and verification (per `CLAUDE.md`).

## Verification

Same approach as prior recap note-feature sessions (direct `recap(gid)$context$paragraph3`
calls, no formal testthat suite exists for `recap.R`):

1. Query `duration_data_da`/the recording totals to find real gids spanning
   the three cases:
   - non-music proportion == 0% exactly (`music_minutes == minutes`,
     untracked) → existing "not tracked separately" wording, unchanged from
     current behavior.
   - non-music proportion clearly between 0% and 5% (tracked, small
     sliver) → new "seems very high" wording.
   - non-music proportion comfortably >= 5% → no note (regression check:
     confirm this was already true before the change, i.e. default
     `threshold = 5` doesn't newly silence or duplicate anything).
2. Confirm `nonmusic_proportion_threshold` actually changes behavior (e.g.
   raising it to 50 catches more shows with the "seems very high" wording;
   lowering to 0 disables that branch entirely, leaving only the exact-0%
   wording).
3. Regression-check `paragraph3` for the existing set of previously-verified
   gids (the ~19 gids listed in `inst/notes/202608171130_notes_recap-map-scale-exceptional-notes.md`)
   to confirm no unrelated output changed and the new note only appears
   where genuinely applicable.
4. Load the Shiny app and visually confirm the new bullet renders correctly
   in the recap tab's "Notes:" list for a show that triggers it, matching
   the verify-don't-eyeball standard used for prior recap UI work (headless
   check of the actual rendered text, not just reasoning about the code).
