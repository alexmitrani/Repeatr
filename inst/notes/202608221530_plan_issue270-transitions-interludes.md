# Plan: Fix issue #270 — transitions not defined across interludes

## Context

Issue #270: "a transition has not been defined when two songs have an
interlude in between. A transition should be defined every time one song
follows an earlier song, ignoring interludes in between." The issue gives a
check: per show, `t = n - 1`; series-wide, `t = n - s` (t = transitions,
n = songs performed, s = shows).

Root cause, confirmed against the real data (`data/Repeatr1.rda`,
`data/transitions_data_da.rda`): transitions are built by filtering to
`tracktype==1` (real songs) and then requiring the **raw** `song_number`
(which counts every track — interludes/intros/outros/encores included) to
differ by exactly 1 between two songs. Whenever a non-song track sits
between two songs, that join key no longer differs by 1 and the transition
silently disappears instead of being recognized.

Measured impact: 18,286 songs across 952 shows → expected 17,334
transitions (`n - s`), but `transitions_data_da` currently has only 12,610 —
**4,724 real transitions are missing** (~27%). Verified example:
`aalst-belgium-92390` — "and the same" (song_number 6) → "interlude 1"
(7) → "bulldog front" (8): today no transition links "and the same" to
"bulldog front"; it should.

This exact bug is duplicated in three places (same shift-and-join pattern),
plus one related pre-existing doc/behavior mismatch the user asked to fix in
the same pass: the Shiny "transition" column is documented as "the number of
the transition in the set, where 1 is the first transition in that show"
but is actually the raw source-song track position, not a sequential count.

`transitions_data_da` is a derived/summary object and is **not** exported to
fugazibase (confirmed in `R/export_fugazibase_data.R`), so this fix has no
cross-package data-consistency step.

## Fix approach (validated against real data before writing this plan)

Replace the "filter to songs, shift `song_number` by 1, join" pattern with:
filter to `tracktype==1`, `arrange(gid, song_number)`, then
`group_by(gid)` + `dplyr::lead()` on `title`/`song_number`. Because the
`lead()` operates on the already-filtered, ordered songs-only rows, it
naturally pairs each song with the *next real song*, regardless of any
interludes/other non-song tracks sitting between them in the raw sequence.

Tested this exact logic against `data/Repeatr1.rda` in a scratch script:
produces exactly 17,334 rows (matches `n - s`), 0 shows where
`count(transitions) != count(songs) - 1`, and correctly links "and the
same" → "bulldog front" in the `aalst-belgium-92390` example above.

Per the user's decision, also renumber the `transition` column to be a true
1-indexed per-show sequential count (`row_number()` within `group_by(gid)`
after the fix, in show order) so it matches the vignette's documented
claim. A new `to_song_number` column carries the destination song's real
(raw) `song_number`, since downstream code needs to re-attach transition
data to the correct tracklist row and can no longer assume "destination =
source + 1".

## Files to change

### 1. `R/Repeatr_1.R` (~lines 1288–1312) — canonical build

Replace the `transitions_data_da1`/`transitions_data_da2`/`left_join`
construction with the `arrange` + `group_by(gid)` + `lead()` pattern
described above, then add a per-show `transition = row_number()`. Final
columns: `gid, url, fls_link, date, transition, to_song_number, title1,
title2` (same set as today plus `to_song_number`).

### 2. `inst/shiny/Fugazetteer/app.R` — "matrix" tab (~lines 2691–2708)

The `transitions_data` reactive independently re-derives song-to-song pairs
straight from `Repeatr1` using the identical buggy shift/join pattern (it
does not go through `transitions_data_da`). Apply the same `lead()`-based
fix here. This reactive only ever surfaces `from`/`to`/`count` (heatmap +
data table), so no renumbering concern here — just fixing the dropped
pairs.

### 3. `R/recap.R` (~lines 987–999) — `transition_ranked`

Currently: `mutate(song_number = .data$transition + 1)` to reattach ranked
transition data to the destination tracklist row — this assumption breaks
once transitions can span interludes. Change to use the new
`to_song_number` column directly (rename to `song_number` for the existing
join key at line 1045, `left_join(transition_ranked, by = c("gid",
"song_number"))`). Update the stale comment (lines 988–991) that currently
documents the old (buggy) "+1 by construction" assumption as intentional.

### 4. `vignettes/CombinationLock.Rmd` (~lines 43–65)

This vignette is almost certainly where the issue's own check formula came
from — it never filters by `tracktype`, so it treats every track (including
interludes) as a "song," which is why its internal math never revealed the
missing-transitions bug even though its prose describes exactly the
invariant in issue #270. Fix `mydf1`/`mydf2`/`mydf3` to filter
`tracktype==1` first and use the same `lead()`-based logic (skip
interludes) instead of the raw `song_number - 1` join, matching the fixed
canonical logic.

The "92 songs" figure in the prose (line 196) already matches the real
`tracktype==1` song-title count — confirmed, no change needed. Other
prose claims that are computed from data at render time (`nrow(transitions)`,
`nrow(transitions_data_da)`) update automatically. Two **hardcoded** prose
claims need re-checking after re-rendering with the fix and should be
corrected if they've moved: "there are 16 possible transitions between
these four groups and all of these were used" (line 255) and "Transitions
between Mackaye and Picciotto songs represent approximately 80% of the
cases" (line 255) — both plausible to shift somewhat now that
interlude-adjacent "noise" pairs are gone from the underlying transitions
data.

### 5. Documentation

- `R/data.R` — `transitions_data_da` roxygen block: add `to_song_number`
  field description; update `transition` field description to reflect the
  1-indexed-per-show-count semantics (now actually true, not aspirational).
  `shiny_transitions_data_da`'s block inherits this via the "same rows as"
  reference, no separate edit needed there beyond regenerating `man/*.Rd`.
- `vignettes/Fugazetteer.Rmd` (~line 300) — no prose change needed here;
  the existing claim ("transition — this is the number of the transition
  in the set, where 1 is the first transition...") becomes accurate once
  the renumbering fix ships. Double check the wording still reads correctly
  once verified against the app.
- Regenerate `man/transitions_data_da.Rd` via `devtools::document()`.

### 6. Data rebuild

- Re-run `Repeatr_1()` (or the relevant portion) to regenerate
  `data/transitions_data_da.rda` from the fixed code.
- Re-run `build_shiny_precompute()` to regenerate
  `data/shiny_transitions_data_da.rda` (no code change needed there — it
  just re-joins the now-fixed `transitions_data_da` with
  `shiny_fls_link_year_tour`).
- Per the session-notes precedent for this exact area
  (`inst/notes/202608162130_notes_recap-tracklist-transitions-xray-fix.md`),
  validate against a scratch copy first (`Repeatr_1(output_dir = tempdir())`)
  before touching the real `R/Repeatr_1.R`/`data/*.rda`, and confirm other
  outputs of `Repeatr_1()` are byte-identical except for the intended
  `transitions_data_da` change.

## Verification plan

1. Re-run the series-wide check from the issue against the rebuilt data:
   `nrow(transitions_data_da) == sum(tracktype==1) - n_distinct(gid)`
   (17,334), and per-show `count(transitions) == count(songs) - 1` for all
   952 shows (0 discrepancies) — same script used to validate this plan.
2. Spot-check `aalst-belgium-92390`: confirm a transition row now links
   "and the same" → "bulldog front" (previously absent).
3. `recap("aalst-belgium-92390")` (or the Shiny recap tab) — tracklist's
   `transition`/`transitions` columns should now populate on the row
   immediately following an interlude, not just immediately following
   another song.
4. Launch the Shiny app (`run` skill) and check:
   - "matrix" tab heatmap/data table — transition counts should be higher
     than before, and now include cross-interlude pairs.
   - "transition" search tab — `transition` column should show small
     sequential integers (1, 2, 3, ...) per show rather than raw track
     positions; "from"/"to" filters still behave correctly.
5. Rebuild `vignettes/CombinationLock.Rmd` and re-read the two hardcoded
   prose claims flagged above (16/16 group pairs, ~80% Mackaye/Picciotto
   share); update the numbers in prose if they've moved.
6. `devtools::document()` — confirm only the expected `.Rd` files change.
7. `devtools::check()` / R CMD check — confirm still 0 errors/warnings/notes
   (per issue #263's baseline).
8. Per CLAUDE.md: write session notes to
   `inst/notes/<timestamp>_notes_issue270-transitions-interludes.md`, bump
   `DESCRIPTION` version by one increment (0.0.0.9268 → 0.0.0.9269).
