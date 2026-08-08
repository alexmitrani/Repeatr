# Restructuring part 2: reverse the fugazi.db dependency direction

## Context

Yesterday's first restructuring pass moved all primary raw data out of Repeatr
and into a new sibling package, `fugazi.db` (`C:\Users\alemi\Documents\GitHub\fugazi.db`),
which Repeatr now depends on at runtime (`Depends: fugazi.db` in `DESCRIPTION`,
`R/Repeatr_1.R` reads `fugazi.db::fls_data`, `fugazi.db::songvarslookup`,
`fugazi.db::releases`, `fugazi.db::fls_venue_geocoding`, `fugazi.db::fls_tags_raw`).
That made Repeatr's pipeline dependent on an external package for its starting
point, and `fugazi.db` itself turned out not to justify existing on its own:
its tables are raw, uncorrected-for-joining (no `gid` on the tags table), and
offer little value to anyone else since all the actual cleaning/correction
logic still lives in Repeatr.

The goal now is to **reverse the dependency direction**: Repeatr goes back to
being fully self-contained (raw data lives in Repeatr again, no runtime
dependency on `fugazi.db`), and `fugazi.db` becomes a generated **output** of
Repeatr — a clean, fact-based, well-keyed data package with the corrections
and reformatting already applied, but without any joined/summarized/modeled
columns, and without the copyrighted free-text show notes (`fls_notes`).

**Important complication discovered during research**: yesterday's migration
didn't just move raw files — it baked several one-time corrections into them
and then deleted the correction files (`venue_name_corrections.csv`,
`fls_tags_name_recoded.csv`, `othervariables_patch.csv`, `fugazi-small.csv`),
and simplified `R/Repeatr_1.R` accordingly. Restoring Repeatr's raw data from
pre-migration git history (`git show b7c21f13^`) would mean resurrecting that
now-deleted correction logic and would **not** reproduce today's outputs.
Instead, **source the restored raw files from `fugazi.db`'s current
`data-raw/` checkout** (which already has the corrections baked in) — this
reproduces current outputs exactly, with zero new correction logic to write.
Verified: `releases.csv`, `releases_songs_durations_wikipedia.csv`, and
`song_tempo_bpm_data.csv` are content-identical between pre-migration and
current `fugazi.db` copies anyway.

Decisions already confirmed with the user:
- `songidlookup` (the pure `songid`↔`song` title lookup, no `tracktype`) ships
  in fugazi.db as join-key infrastructure; no fuller classification detail.
- `played_with`/`played_with_data` ship as fact tables (not excluded as "join
  output"), since they're one-row-per-real-event tables, not aggregates.
- Files are written directly into the sibling `fugazi.db` checkout on disk;
  nothing is committed/pushed there — that's left for separate review.
- fugazi.db's tables are renamed for clarity now that they're cleaned output,
  not raw passthrough (`fls_data`→`fls_shows`, `fls_tags_raw`→`fls_tags`).

## Part A — Make Repeatr standalone again

**A1. Restore raw data files.** Copy (not move — leave fugazi.db's copies
alone) from `fugazi.db\data-raw\` into `Repeatr\inst\extdata\`:
`fls_data.csv`, `fls_tags.txt`, `releases.csv`,
`releases_songs_durations_wikipedia.csv`, `song_tempo_bpm_data.csv`.

**Venue geocoding — single file, verified.** `fugazi.db`'s merged geocoding
file (757 data rows) was checked directly against Repeatr's existing
`inst/extdata/fls_venue_geocoding_v2.csv` (754 rows) with a proper
CSV-aware diff keyed on `country`/`city`/`venue`: all 754 common rows have
byte-identical coordinates, and the 3 rows unique to the merged file
(`Australia/Croydon/The Hull`, `USA/Oxford/Lafayettes`,
`USA/St Louis/1227` — all under non-disambiguated city spellings) are
**dead duplicates**, not real gaps: `Repeatr_1()` always renames these
cities to their disambiguated form (`Croydon (Australia)`, `Oxford (USA)`)
or the real show data already uses the punctuated form (`St. Louis`) before
the geocoding join runs, and v2 already has the corresponding disambiguated
row with the same coordinates in every case. So **no show loses coordinates
by using `fls_venue_geocoding_v2.csv` alone** — no second file is needed.
`Repeatr_1()` reads `inst/extdata/fls_venue_geocoding_v2.csv` directly as
the single source of truth (the same file Part B's fugazi.db export also
reads), and nothing needs to be added to the Google Sheet.

**A2. `R/Repeatr_1.R`** — keep the existing override-parameter shape
(`myfls_data`, `mysongvarslookup`, `myreleases`, `myfls_venue_geocoding`,
`myfls_tags`), change only the `NULL` defaults, from `fugazi.db::xxx` back to
`read.csv(system.file("extdata", "...", package = "Repeatr"))` /
`fls_tags_importer(system.file("extdata", "fls_tags.txt", package = "Repeatr"))`
for the five inputs (`fls_data.csv`, `releases_songs_durations_wikipedia.csv`,
`releases.csv`, `fls_venue_geocoding_v2.csv`, `fls_tags.txt`). Two
additions needed, since these two objects currently exist ONLY via
`fugazi.db`'s `Depends:` attachment and have no Repeatr-side counterpart:
- Re-save `songvarslookup` into `data/` in the same block that already saves
  `othervariables`/`releasesdatalookup`/`Repeatr0`/`gid_sound_quality`
  (~line 368).
- Add a new read+save step for `song_tempo_bpm_data` (currently nothing in
  `Repeatr_1()` touches this object at all) from
  `inst/extdata/song_tempo_bpm_data.csv`, no transformation.

Also remove all `fugazi.db::` references from the roxygen doc block
(lines 1-24) and the two `warning()` message strings (~lines 871, 876) that
mention `fugazi.db::songvarslookup`.

**A3–A4. Doc-only edits, no data-flow change**: `R/Repeatr_2.R`,
`R/Repeatr_5.R`, `R/Repeatr_Updatr.R` roxygen text referencing `fugazi.db`;
`R/nscmov.R`'s comment referencing `fugazi.db::fls_venue_geocoding`.

**A5. `R/build_fugazidb_data.R`** — delete and replace with
`R/export_fugazidb_data.R` (see Part B; the old function did the opposite
direction and the name would be actively misleading if kept). Remove
`man/build_fugazidb_data.Rd` and regenerate via `devtools::document()`.

**A6. `R/data.R`** — remove `fugazi.db::` mentions from `othervariables`,
`releasesdatalookup`, `fls_tags` provenance text (note: `fls_tags`'s doc
already says "raw `inst/extdata/fls_tags.txt`" — a pre-existing stale
leftover this restoration incidentally fixes, no change needed there). Add
new roxygen blocks documenting `song_tempo_bpm_data` and `songvarslookup` as
Repeatr data objects (neither was ever documented in Repeatr's own
`R/data.R`, since they previously came from `fugazi.db`'s docs).

**A7. `DESCRIPTION`/`NAMESPACE`** — remove `fugazi.db` from `Depends:` and
delete the `Remotes: alexmitrani/fugazi.db` line entirely. Regenerate
`NAMESPACE` via `devtools::document()`.

**A8. `inst/shiny/Fugazetteer/app.R`** — one line change: `fugazi.db::songvarslookup`
(line 143) → bare `songvarslookup`. Confirmed via grep this is the *only*
explicit `fugazi.db::` reference in app.R; the only bare-name object it reads
that came via `fugazi.db`'s `Depends:` attachment is `song_tempo_bpm_data`,
restored in A2. No other app.R changes needed.

**A9. `man/*.Rd`** — regenerate via `devtools::document()`, don't hand-edit.

## Part B — fugazi.db as a generated output of Repeatr

**B1. New function `export_fugazidb_data(fugazidb_dir, repeatr_data_dir = NULL)`**
in `R/export_fugazidb_data.R`. `fugazidb_dir` has **no default value** — it's
a required argument the caller must supply explicitly; the user's local
absolute path (`C:\Users\alemi\Documents\GitHub\fugazi.db`) must never be
hardcoded into this or any other package function (verified: no such
hardcoding currently exists anywhere in `R/`; the only place a fugazi.db path
appears at all is `data-raw/build_data.R`'s `fugazidb_dir <- "../fugazi.db"`,
a *relative* path in a dev-only script excluded from the built package via
`.Rbuildignore`, matching the existing pattern from yesterday's
`build_fugazidb_data(fugazidb_dir)`, which also has no default). `roxygen`
`@examples` may show `export_fugazidb_data(fugazidb_dir = "../fugazi.db")` as
illustrative dev-script usage, same as today — that's a doc example, not a
function default. `repeatr_data_dir` defaults to `data/` under
the package root (i.e. expects `Repeatr_Updatr(really = "really", ...)` to
have already run). It `load()`s already-saved `.rda` objects — no
re-derivation, no new business logic — composes 8 export tables, and for each
writes `fugazidb_dir/data-raw/<name>.csv` (`write.csv(..., row.names = FALSE)`)
and `fugazidb_dir/data/<name>.rda`.

**B2. Table-by-table design** (verified column-by-column against the actual
`R/Repeatr_1.R` code):

| fugazi.db table | Built from (already-saved Repeatr objects) | Columns / transform |
|---|---|---|
| `fls_shows` (was `fls_data`) | `othervariables` + `gid_sound_quality` + `fls_tags_show` (for duration/seconds) | `othervariables %>% left_join(gid_sound_quality) %>% left_join(fls_tags_show %>% select(gid, seconds))`, then drop `fls_notes` (copyright). Keeps `gid, flsid, date, venue, doorprice, attendance, recorded_by, mastered_by, original_source, tour, city, subdivision, country, year, checked, x, y, sound_quality, seconds`. Note: `othervariables` already excludes shows missing `tour` or coordinates (existing filters at Repeatr_1.R:296-299, 358-359) — `fls_shows` won't cover literally every scraped show; document this. |
| `fls_venue_geocoding` | `inst/extdata/fls_venue_geocoding_v2.csv` directly (not from `data/`) | Straight copy, all columns, no transform — per explicit requirement to mirror this file exactly, no fallback-venue merge this time. |
| `fls_tags` (was `fls_tags_raw`) | `data/fls_tags.rda` | Already has `gid` (joined at Repeatr_1.R:453-457) and the album-format/track-title corrections from the "process tags data" section. Columns: `gid, date, track, song, duration, seconds`. |
| `releases` | `data/releasesdatalookup.rda` | Drop `colour_code` (UI-only, stays in Repeatr's `releaseid_variable_colour_code`). **Filter out `releaseid` 12/13/14/15** — confirmed these are synthetic UI-bucket rows (`released`/`unreleased`/`songs`/`other`) with blank `releasedate`, not real releases (see `fugazi.db/data-raw/releases.csv` rows 12-15). Keep `releaseid, release, variable, releasedate, release_date_source, rym_rating`. |
| `songvarslookup` | `data/songvarslookup.rda` | Pass through as-is: `releaseid, track_number, song, instrumental, vocals_picciotto, vocals_mackaye, vocals_lally, duration_seconds`. |
| `song_tempo_bpm_data` | `data/song_tempo_bpm_data.rda` (new in A2) | Pass through: `song, tempo_bpm`. |
| `songidlookup` | `data/songidlookup.rda` | Pass through as-is: `songid, song, count`. Already pure key infrastructure, no `tracktype`. |
| `played_with` / `played_with_data` | `data/played_with.rda` (has `gid` already) / `data/played_with_data.rda` (does **not** currently have `gid` — verified at Repeatr_1.R:1522-1530) | `played_with`: pass through (`gid, fls_id, played_with`). `played_with_data`: **add `gid` to its `select()`** in `R/Repeatr_1.R` (~line 1530) — it's available upstream from `othervariables`, zero-risk one-column addition, needed so this table has a real join key per the user's stated goal. |

Excluded from fugazi.db (stay Repeatr-only): `Repeatr0`, `othervariables`
itself (folded into `fls_shows`, not shipped separately), `gid_sound_quality`
(folded in), `played_with_summary`, `duration_data_da`, `duration_summary`,
`cumulative_duration_counts`, `cumulative_song_counts`, `last_performance_data`,
`xray`, `transitions_data_da`, `releases_menu_list`,
`releaseid_variable_colour_code`, `Repeatr1`, and everything from
`Repeatr_2()`–`Repeatr_6()`.

**B3. `fls_notes` exclusion** — confirmed via grep this column is produced
only by `R/scrape_fls_shows.R` and consumed only inside `R/Repeatr_1.R`
(feeding `Repeatr0`/`othervariables`/`shows_data`); nothing in `app.R` or any
vignette displays it. Simply never selecting it into `fls_shows` (B2, above)
is sufficient — Repeatr's own internal objects keep it unaffected.

**B4. Write location** — directly into
`C:\Users\alemi\Documents\GitHub\fugazi.db\data-raw\*.csv` and
`...\data\*.rda` (8 files each, replacing the current 6), plus `DESCRIPTION`,
`R\data.R`, `man\*.Rd`, `README.md`, `vignettes\Data-Catalogue.Rmd`,
`LICENSE` — no git commit/push in that repo.

## Part C — Documentation updates

**Repeatr `vignettes/Data-Provenance.Rmd`**: flip the intro (raw data now
originates in Repeatr's `inst/extdata/`; fugazi.db is downstream output, not
upstream input). Rewrite the "Data processing sequence" diagram: root becomes
Repeatr's own `inst/extdata/` raw sources; add a new terminal branch
`export_fugazidb_data() → fugazi.db (fls_shows, fls_venue_geocoding, fls_tags,
releases, songvarslookup, song_tempo_bpm_data, songidlookup, played_with,
played_with_data)`. Update "Types of data" bullets and the dataset catalogue
table to remove `fugazi.db::` mentions and add rows for the now-local
`songvarslookup`/`song_tempo_bpm_data`. Update the closing "Note on app.R"
paragraph (no longer attaches fugazi.db's data via `Depends:`).

**Repeatr `vignettes/Rebuilding-the-Data.Rmd`** and **`data-raw/build_data.R`**:
rewrite the 3-stage process — A. refresh Repeatr's own `inst/extdata/` raw
sources (scraping/hand-curation, writing directly to `inst/extdata/`); B.
`Repeatr_Updatr(really = "really", update_stacks = TRUE)`, unchanged
mechanically; C. (new) `export_fugazidb_data(fugazidb_dir = "../fugazi.db")`.
Remove the `devtools::install_github("alexmitrani/fugazi.db")` step entirely.

**`R/Repeatr_1.R`'s "process tags data" section**: add a comment noting the
provenance nuance the user asked for — the underlying MP3 tag data
(track/album/song names) originates from the Fugazi Live Series itself, not
personal data; the maintainer applied consistent album-name formatting and a
handful of track-title corrections on top.

**fugazi.db `DESCRIPTION`**: flip framing from "primary source data...
contains no processing code" to "Repeatr's cleaned, corrected Fugazi Live
Series data, exported from Repeatr — see Repeatr for all processing code."
Keep the Dischord Records `cph` credit (still accurate). Bump `Version`.

**fugazi.db `README.md`**: flip the "no processing code, Repeatr depends on
fugazi.db for raw inputs" framing to "Repeatr produces this data and exports
it here." Update the object table (6→8 rows, renamed tables, add
`songidlookup`/`played_with`/`played_with_data`).

**fugazi.db `R/data.R`**: rewrite the package-level description and each
roxygen block for the renamed/changed objects per the B2 column design above
(new column lists, updated Provenance notes pointing at
`Repeatr::export_fugazidb_data()` and the specific Repeatr objects each is
built from); add new blocks for `songidlookup` and `played_with`/`played_with_data`.

**fugazi.db `vignettes/Data-Catalogue.Rmd`**: update "The tables" summary (8
rows), simplify the `gid` section (no longer need the "`fls_tags_raw` does
not carry `gid` directly, don't re-parse `album` by hand" caveat — `fls_tags`
carries `gid` directly now), add a `songid`/`songidlookup` join-key section.

**fugazi.db `LICENSE`**: keep the core copyright/pending-permission framing
unchanged (Dischord Records still owns the underlying show facts). Update the
opening to reflect this package now ships Repeatr's cleaned output, not raw
data directly. Replace the specific `fls_data$fls_notes` example callout
(that column is no longer shipped here at all) with general language noting
free-text show notes are deliberately excluded from this package.

**fugazi.db `man/*.Rd`**: regenerate via `devtools::document()` after the
`R/data.R` rewrite.

## Ambiguities/risks flagged for awareness (no action needed unless something looks wrong post-verification)

1. `fls_shows` row count will be smaller than "every show ever scraped" (existing `othervariables` filters, not new).
2. `releases` excludes `releaseid` 12-15 (synthetic buckets) — a new, more consistent decision than today's `releases_menu_list` filter (which inconsistently keeps 13).
3. `played_with_data` gains a `gid` column (Repeatr-side addition, zero-risk per app.R's own usage pattern — it rebuilds its own local reactive from `othervariables`/`played_with` rather than reading the saved `played_with_data` object).

## Verification plan

1. **Baseline**: on current `main`, run `Repeatr_Updatr(really = "really", update_stacks = TRUE)`, snapshot every `data/*.rda` object (md5sum/RDS copies in a scratch dir).
2. **After Part A**: confirm Repeatr loads/documents/checks cleanly with `fugazi.db` **not installed** (the real test of "no runtime dependency"). Rerun `Repeatr_Updatr()` into a separate scratch `output_dir` (don't overwrite real `data/` yet). `identical()`/`waldo::compare()` every object against the baseline — expect byte-identical results except the deliberate, documented `played_with_data$gid` addition, and the new `songvarslookup.rda`/`song_tempo_bpm_data.rda` (no prior baseline, just confirm they load and match shape/values of fugazi.db's current versions).
3. `devtools::test()` and `devtools::check()` on Repeatr before/after; `grep -rn "fugazi\.db" R/ vignettes/ inst/` should return zero hits after Part A.
4. **Shiny app**: `shiny::runApp("inst/shiny/Fugazetteer")` with `fugazi.db` uninstalled — confirm it starts and every tab/table/plot listed in the earlier inventory (today, flow/shows, flow/with, flow/attendance, flow/xray, flow/renditions, flow/matrix, flow/transition, flow/sets, flow/stacks, stock/discography, stock/variation, stock/duration, stock/search) renders identically. The three live-Google-Sheet-driven pieces (venue coordinates, quiz, link-track index) are unaffected either way.
5. **fugazi.db export (Part B)**: run `export_fugazidb_data()` against the verified-identical `data/`, then `devtools::check()` on the regenerated fugazi.db (0 errors). Spot-check: `fls_shows` row count vs. `Repeatr0` row count (expected gap, documented), `fls_venue_geocoding` (754 rows, matches `fls_venue_geocoding_v2.csv` exactly), `releases` row count is 11 not 15.
6. Leave both repos' changes uncommitted for the user's own review/commit.

### Critical files
- `Repeatr\R\Repeatr_1.R` (main data-flow changes)
- `Repeatr\R\build_fugazidb_data.R` → replaced by `Repeatr\R\export_fugazidb_data.R`
- `Repeatr\DESCRIPTION`, `Repeatr\data-raw\build_data.R`
- `Repeatr\vignettes\Data-Provenance.Rmd`, `Repeatr\vignettes\Rebuilding-the-Data.Rmd`
- `Repeatr\inst\shiny\Fugazetteer\app.R` (line 143 only)
- `fugazi.db\R\data.R`, `fugazi.db\DESCRIPTION`, `fugazi.db\LICENSE`, `fugazi.db\README.md`, `fugazi.db\vignettes\Data-Catalogue.Rmd`
