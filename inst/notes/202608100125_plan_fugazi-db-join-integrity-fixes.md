# fugazi.db join-integrity fixes: durations NA gid, locations city disambiguation

## Context

Two separate data-correctness bugs were found and fixed in quick succession
while reviewing `fugazi.db`'s tables against their upstream sources in
`Repeatr`. Both are the same *shape* of bug - a value in one of fugazi.db's
exported tables that doesn't match the corresponding join-key value in
`shows`, so a `left_join()` a user would naturally write silently drops
rows instead of erroring - but with different root causes, in different
tables, found in separate requests from the user. Neither went through
plan mode (both were narrow, well-scoped fixes the user asked for directly
after the root cause was identified), so this file documents the approach
actually taken for each, retroactively, alongside the paired notes file.

## Fix 1: `durations` table - 74 rows with `gid = NA`

**Symptom**: the user initially thought this was in the `bands` table, then
corrected themselves - it's `durations`.

**Root cause**: `durations` (Repeatr's internal `fls_tags`) gets its `gid`
via a `left_join()` on `date` against `othervariables` (`Repeatr_1.R`,
around line 463-467). `date` is parsed from the raw MP3 tag's `album`
string (a `YYYYMMDD Venue, City, ST, Country` convention). For 74 tagged
tracks across 3 shows, the tagger wrote the wrong date into that string, so
the parsed `date` didn't match any real show date and the join produced
`gid = NA`. This is the same class of bug as the handful of hardcoded
album-string corrections already present in `Repeatr_1.R` (e.g. the
`20220218 40 Watt...` → `19930218 40 Watt...` fix) - these three just
weren't caught previously.

**Approach**: add three more hardcoded `mutate(album = ifelse(album ==
"<wrong>", "<right>", album))` corrections to `Repeatr_1.R`, in the same
place and style as the existing ones (right after the two existing exact-
album-string corrections, before the date is parsed out of the album
string). Then rebuild Repeatr's own data by running `Repeatr_1()` for real
(not into a scratch dir), and re-run `export_fugazidb_data()` to refresh
fugazi.db's tables - `durations` is the only one of the six tables that
depends on `fls_tags`, so it's the only one expected to change.

Rebuilding via `Repeatr_1()` alone (not the full
`Repeatr_Updatr(update_stacks = TRUE)`) is a deliberate scope decision:
`Repeatr_1()` covers the "Derived-cleaned"/"Derived-classified" tier, which
is everything `fls_tags` feeds into and everything `export_fugazidb_data()`
reads from - the modelling tier (`Repeatr_2()` onward, the `mlogit` choice
model) is unaffected by a handful of corrected tag dates in any way that
matters for this fix, and is a much slower rebuild not worth doing for this
change alone.

## Fix 2: `locations` table - bracketed city text breaks the `shows` join

**Symptom** (user-reported): `locations` documents that some cities are
disambiguated with a bracketed suffix (e.g. `"Portland (OR)"`), which means
a `shows %>% left_join(locations, by = c("country","city","venue"))` won't
match those rows, since `shows$city` is always the plain city name
(`"Portland"`).

**Root cause**: the raw `inst/extdata/fls_venue_geocoding_v2.csv` suffixes
6 cities that share a name with another tour stop (Portland, Columbia,
Croydon, Newcastle, Oxford, Springfield - 22 rows total) as `"City (ST)"`/
`"City (Country)"`, purely so the sheet itself can be keyed unambiguously.
`Repeatr_1.R` already handles this correctly for `othervariables`/`shows`:
it applies the *same* temporary suffix to `othervariables$city` just long
enough to join against that CSV (lines ~147-160), then strips it back off
immediately after (lines ~336-358), so `shows$city` never carries it.
`export_fugazidb_data()`'s `locations` block, however, reads that CSV
directly and was never taught to strip the suffix - so `locations$city`
kept the bracketed form, silently breaking the join for those 22 rows / 25
shows.

**Approach**: add a `mutate(city = trimws(gsub("\\s*\\([^)]*\\)$", "",
city)))` step to the `locations` block in `export_fugazidb_data()`, before
the raw CSV's columns are selected/renamed. A general regex was chosen over
copying `Repeatr_1()`'s explicit per-city `ifelse` list, specifically
*because* this bug's root cause was two hardcoded lists (implicitly) drifting
out of sync - a regex that strips "any trailing parenthetical" doesn't need
updating if a new disambiguated city is ever added to the raw CSV. Verified
empirically first that stripping the suffix introduces no duplicate
`country`+`city`+`venue` key (754 rows, no collisions) before writing the
fix.

Since this changes what `locations$city` actually contains and how it
should be joined, fugazi.db's own documentation (`R/data.R`'s `locations`
field docs, `vignettes/Data-Catalogue.Rmd`'s join-key section) needs
updating in the same pass - both previously described the bracketed form as
intentional/permanent, which is no longer true.

## Verification (both fixes)

- Fix 1: NA-gid count in `durations` 74 → 0; total row count unchanged
  (24,530); the three previously-orphaned shows
  (`ypsilanti-mi-eastern-michigan-university-12288`, `portland-me-usa-72698`,
  `el-paso-tx-usa-40901`) confirmed present with their tracks correctly
  attached.
- Fix 2: zero bracketed values left in `locations$city` across all 754
  rows; `shows %>% left_join(locations, ...)` now matches coordinates for
  all 25 shows in the six previously-affected cities (was 25 unmatched, now
  0); `devtools::check()` on fugazi.db - 0 errors/warnings/notes after
  regenerating `man/*.Rd`.
- Both fixes: confirmed via `git status --short` that only the expected
  files changed in each repo, left uncommitted for review.
