# Fix `rendition`/`renditions` inconsistency in the recap tracklist

## Context

The recap tab (`R/recap.R`) shows two columns per song in its tracklist: `rendition`
(this occurrence's ordinal number, computed fresh in `recap()` from `duration_data_da`)
and `renditions` (the song's all-time total, taken from `duration_summary$renditions`).
On the last show of the whole series (`london-england-110402`, 4 Nov 2002), every song's
`rendition` should equal its `renditions` by definition — the last show contains each
song's chronologically-last recorded performance. It doesn't, for 12 of the 25 songs on
that show (verified directly via `recap()`): e.g. `margin walker` shows `rendition=467`
vs `renditions=464`, `waiting room` 675 vs 672, `cashout` 67 vs 69.

Direct data inspection (`data/duration_summary.rda`, `data/position_summary.rda`,
`data/duration_data_da.rda`, `data/fls_tags.rda`, `data/Repeatr1.rda`,
`data/othervariables.rda`, `data/gid_sound_quality.rda`) found **two distinct bugs**, both
in `R/Repeatr_1.R`, both upstream of `recap()` (which itself needs no changes).

### Bug 1: ambiguous `(gid, title)` join loses/duplicates repeated-song occurrences

- `duration_summary$renditions` (~line 1142-1144) is a raw per-title row count of
  **`fls_tags`** (the imported MP3-tag data).
- `position_summary$renditions` / `duration_data_da`'s row count (~line 1663-1671) is a row
  count of **`duration_data_da`**, built from **`Repeatr1`** (the hand-classified live-show
  data, `tracktype==1`).
- Despite recap's own session notes stating both are "the same source", they never were —
  these are two independently-counted tables that happen to usually agree.

They diverge because `duration_data_da`'s construction (line 1594-1599) joins `Repeatr1` to
`gid_song_minutes` (itself `fls_tags %>% select(gid, title, minutes)`, line 1400-1402) using
a plain `left_join()` on the **implicit natural key `(gid, title)` only** — no per-occurrence
disambiguator. Whenever a song title repeats within a single show:
- If `fls_tags` also has 2+ tagged rows for that `(gid, title)`, the join is many-to-many and
  silently multiplies rows (exactly what 5 existing hardcoded filters, lines 1601-1623, were
  patched to remove, for `annapolis-md-usa-20688`, `canberra-australia-111793`,
  `peoria-il-usa-100995`, `richmond-va-usa-51198`, `washington-dc-usa-73198` — the comment
  there even says "fake duplicates caused by the match not being done on all the required
  variables").
- If `fls_tags` has only 1 tagged row for that `(gid, title)` (the tagger merged two
  back-to-back live performances under one audio track), the 1:2 join silently duplicates
  that single duration onto both `Repeatr1` occurrences instead of leaving the second one
  unmatched. Confirmed for 6 more titles at `norwich-england-50792` alone (`long division`,
  `margin walker`, `promises`, `runaway return`, `song #1`, `waiting room`), none of which
  have a hardcoded patch. At least `atlanta-ga-usa-51291`, `glasgow-scotland-102902`,
  `okayama-japan-102296`, and `washington-dc-usa-41291` have the same unpatched issue.

### Bug 2: `washington-dc-usa-100688` is a fully phantom "recording"

`washington-dc-usa-100688` (10/6/88, 9:30 Club) has 13 songs classified in `Repeatr1` but
**zero** matching rows anywhere in `fls_tags`/`fls_tags_show` — confirmed to be the only gid
in the whole dataset where every `duration_data_da` row for a gid has `NA` minutes (952 gids
total, 1 fully-NA). This is a real, distinct historical show (confirmed by the user against
the FLS site's own flyer for that date, matching supporting bands) — its date, venue, city,
`played_with`, door price, and attendance are all genuine and stay untouched. Only the
recording is mixed up: the audio posted under that page is actually a copy of the
higher-quality 6/15/88 recording, and the page's own comments confirm no recording exists for
10/6/88 (Dischord has been unable to correct this due to how their site works). So the fields
that specifically describe *the recording* — `recorded_by`, `mastered_by`, `original_source`,
and (by the same logic, since there's no recording to rate) `sound_quality` — belong to
`washington-dc-usa-61588`, not this page. `fls_tags`/`fls_tags_show`
(`inst/extdata/fls_tags.txt`) already reflect this correctly, attributing the one real
recording to its true date/gid (`washington-dc-usa-61588`, `1988-06-15`) — but
`othervariables`/`gid_sound_quality` (scraped straight from the site's per-page text) were
never correspondingly corrected, and neither was `duration_data_da`'s construction, which
still emits a full phantom tracklist row per song for `washington-dc-usa-100688`.

This has two visible consequences, confirmed by calling `recap(mygid =
"washington-dc-usa-100688")` directly:
1. `has_recording` comes back `TRUE` with a tracklist of 13 `NA`-duration rows, and
   `paragraph2` reads "A recording of this show is available, with a total duration of NA
   minutes, rated 'Very Good' for sound quality. Recorded by Eli Janney on 1/4", mastered by
   Jerry Busher." — nonsensical, since no recording exists.
2. Each of those 13 phantom rows also occupies a slot in `recap()`'s `rendition_number`
   sequencing (`duration_data_da %>% arrange(date, song_number) %>% group_by(title) %>%
   mutate(rendition_number = row_number())`), silently inflating every later real
   `rendition_number` for those 13 song titles by one — a second, independent contributor to
   the original mismatch, on top of Bug 1.

Confirmed with the user: `recorded_by`/`mastered_by`/`original_source`/`sound_quality` should
be nulled out for `washington-dc-usa-100688` as part of this fix, consistent with treating it
as genuinely unrecorded everywhere.

### Fugazibase scope

`fugazibase`'s export (`R/export_fugazibase_data.R`) explicitly excludes `duration_data_da`,
`duration_summary`, `position_summary`, `xray`, and the `cumulative_*` tables — it only
receives `fls_tags` itself (as its `durations` table), raw and already correctly attributed.
`othervariables`/`gid_sound_quality` **are** exported (into fugazibase's `shows` table, via
`recorded_by`/`mastered_by`/`original_source`/`sound_quality`), so fixing them in Repeatr
does need a re-export. Confirmed `fugazibase`'s own vignette doesn't independently recompute
a renditions-style count, so Bug 1 needs no fugazibase changes at all.

## Fix approach

All source changes are in `R/Repeatr_1.R` (no changes needed to `R/recap.R`, `app.R`, or
`recap_template.Rmd` — they just consume whatever `duration_summary`/`duration_data_da`/
`position_summary`/`othervariables` already contain).

1. **Fix the join (Bug 1).** In the `gid_song_minutes` construction (~line 1400) and the
   `duration_data_da` construction (~line 1594), add a within-`(gid, title)` occurrence rank
   on both sides before joining — `fls_tags` ranked by `track` (its in-show tag order),
   `Repeatr1` (`tracktype==1`) ranked by `song_number` (its in-show set order) — and join on
   `(gid, title, occurrence)` instead of the bare `(gid, title)`. This pairs repeated
   performances of the same song correctly by chronological order within the show, instead of
   cross-multiplying or duplicating. Verify this reproduces the same pairing the 5 existing
   hardcoded filters (lines 1601-1623) were manually patching (e.g. `annapolis-md-usa-20688`'s
   `break-in` occurrences should land on `song_number` 13→1.48min, 16→1.57min, matching the
   current patch) — if so, remove those 5 filters as redundant. Where `fls_tags` has fewer
   tagged occurrences than `Repeatr1` has live occurrences (the norwich-style case), the extra
   `Repeatr1` occurrence(s) will correctly get `NA` duration rather than a duplicated wrong
   value — a real, pre-existing data gap that becomes visible instead of silently wrong.

2. **Drop fully-unrecorded gids from `duration_data_da` (Bug 2).** After the join, exclude
   any gid where every row's `minutes` is `NA` (currently only `washington-dc-usa-100688`) —
   general logic, not a gid-specific hardcode, so it stays correct if the site ever mislabels
   another show the same way. This fixes `recap()`'s `has_recording`/broken-paragraph2 symptom
   for this gid automatically (no `recap.R` change needed) and removes the 13 phantom slots
   from the cross-series `rendition_number` sequencing.

3. **Null the bogus credit fields for `washington-dc-usa-100688`.** In `othervariables`'s
   one-off-correction block (~line 116-134, same pattern as the existing Hobart/Canberra
   subdivision fixes — condition on `gid`, not on text content, and comment why), add:
   `recorded_by`/`mastered_by`/`original_source` → `NA` when `gid=="washington-dc-usa-100688"`.
   In `gid_sound_quality`'s construction (~line 60-62), filter out
   `gid=="washington-dc-usa-100688"` the same way `is.na(sound_quality)==FALSE` already filters
   real `NA`s, so the later `left_join(gid_sound_quality)` calls produce `NA` for this gid.

4. **Make `duration_summary$renditions` (and its other stats) derive from `duration_data_da`**
   instead of raw `fls_tags`, mirroring how `position_summary` (line 1663-1671) already does
   it. This is what actually closes the loop: once both `duration_summary` and
   `position_summary`/`duration_data_da` count from the same corrected table, `rendition` and
   `renditions` become consistent by construction, not by coincidence — matching what the
   recap feature's own design notes assumed was already true.

## Files affected

- `R/Repeatr_1.R` — all four changes above (join fix, dropped hardcoded filters,
  fully-unrecorded-gid exclusion, `washington-dc-usa-100688` credit-field correction,
  `duration_summary` recomputation). The only source file that needs to change.
- Regenerated `.rda` files (via `Repeatr_Updatr(really = "really")`, fully reproducible from
  local `inst/extdata/` sources, no network/scraping needed): `data/duration_data_da.rda`,
  `data/duration_summary.rda`, `data/position_summary.rda`, `data/othervariables.rda`,
  `data/gid_sound_quality.rda`, `data/shows_data.rda` (carries `sound_quality`), `data/
  cumulative_duration_counts.rda`, `data/cumulative_position_counts.rda`, `data/xray.rda`
  (also joins `gid_song_minutes` at line 1477, same Bug 1 fix applies). Double-check `data/
  cumulative_song_counts.rda` is unaffected (built straight from `Repeatr1`, not through
  `gid_song_minutes`).
- `fugazibase` — re-run `export_fugazibase_data()` and review/commit the diff to its `shows`
  table (only `washington-dc-usa-100688`'s 4 credit fields should change, per Bug 2's fix
  above). No changes needed for Bug 1 (see Fugazibase scope above).
- Docs: `vignettes/Data-Provenance.Rmd`'s tier table (~line 46-89) shouldn't need wording
  changes since the affected tables stay in the same tiers — just confirm after the fix. Per
  existing project convention, do not add "fixed because X" narrative to vignettes.
- `DESCRIPTION` version bump per `CLAUDE.md` convention once the fix is implemented.
- A session note in `inst/notes/` documenting the diagnosis and fix (per `CLAUDE.md`).

## Verification

1. Direct data check (already the method used to diagnose this): after regenerating,
   recompute the `(gid, title)` count comparison between `duration_data_da`/
   `position_summary` and `duration_summary` — should be zero mismatches for real songs.
2. Call `recap(mygid = "london-england-110402")` directly and confirm every song's
   `rendition == renditions` (the original user-reported symptom).
3. Call `recap(mygid = "washington-dc-usa-100688")` directly and confirm `has_recording ==
   FALSE`, `tracklist` is `NULL`, and `recorded_by`/`mastered_by`/`original_source`/
   `sound_quality` are all `NA`/empty in the context and prose.
4. Spot-check the previously-patched shows (`annapolis-md-usa-20688`, `canberra-australia-
   111793`, `peoria-il-usa-100995`, `richmond-va-usa-51198`, `washington-dc-usa-73198`) still
   get correct per-occurrence durations after removing their hardcoded filters.
5. Spot-check `norwich-england-50792` (6 previously-unpatched repeated titles) and confirm the
   second occurrence of each is either correctly paired or explicitly `NA` (not a duplicated
   wrong value).
6. `devtools::document()` + `devtools::check()` on the full package.
7. Full local `shiny::runApp()` + a live browser pass (per the standing project convention for
   this app) across a few tabs that consume these tables — recap (`london-england-110402`,
   `washington-dc-usa-100688`, and one or two earlier-used test gids), and whichever tab
   surfaces `duration_summary`/`position_summary` directly (the "variation" tab) — to confirm
   numbers changed only where they should have and the app still renders cleanly.
