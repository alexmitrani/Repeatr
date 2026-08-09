# Tidy up fugazi.db package

## Context

`fugazi.db` (C:\Users\alemi\Documents\GitHub\fugazi.db) is a data-only R package generated entirely by Repeatr's `export_fugazidb_data()` function (C:\Users\alemi\Documents\GitHub\Repeatr\R\export_fugazidb_data.R). It currently ships 9 tables plus a `data-raw/` folder of mirrored CSVs, and has accumulated redundancy: columns duplicated across tables, scratch/helper columns from the geocoding workflow, two near-duplicate `played_with`/`played_with_data` tables, three tables (`songidlookup`, `songvarslookup`, `song_tempo_bpm_data`) that should logically be one `songs` table (or dropped), and inconsistent object classes (`fls_tags` is a vestigial `rowwise_df`, others are plain `data.frame` or `tbl_df`). The goal is to remove this redundancy, tighten each table to just the columns that belong there, and keep `export_fugazidb_data()` as the single source of truth so re-running it never resurrects what's being removed. Documentation in both packages (roxygen, README, vignette) must stay accurate after the schema change.

Both research passes confirm: fugazi.db has **no processing code of its own** (only roxygen doc blocks in `R/data.R`), so every substantive edit happens in Repeatr's `export_fugazidb_data()`; fugazi.db's own edits are its `R/data.R` docs, `README.md`, `vignettes/Data-Catalogue.Rmd`, and `DESCRIPTION`. No code anywhere (Shiny app, vignettes, R/) references `fugazi.db::` — Repeatr keeps its own separate copies of the source objects, untouched by this change, so nothing on the Repeatr side breaks functionally.

**`played_with` vs `played_with_data` in Repeatr itself, and why one can go away.** The user found it confusing that Repeatr has both `played_with` (gid, fls_id, played_with — the real fact table) and `played_with_data` (the same data enriched with show/venue columns via `othervariables %>% left_join(played_with)`). Tracing every usage of `played_with_data` in Repeatr (`R/Repeatr_1.R`, `inst/shiny/Fugazetteer/app.R`, `R/data.R`) shows:
- It's built and saved to `data/played_with_data.rda` in `Repeatr_1.R` (lines 1532-1542), then used immediately after to derive `played_with_summary` (lines 1544-1550), which the Shiny app does use.
- `app.R` (lines 97-108) **does not use the saved `played_with_data.rda` object at all** — it rebuilds an equivalent table itself from scratch (`played_with %>% select(gid, played_with)` left-joined onto `othervariables`, with `subdivision` added) and reassigns that to the name `played_with` before `server()` even starts. The reactive named `played_with_data` inside `server()` (line 1833) is a Shiny reactive function built from that reassigned `played_with`, not a reference to the lazy-loaded data object of the same name.
- No other pipeline stage (`Repeatr_2`-`6`, `sweepstack`, `stacks`) reads `played_with_data`.

So `data/played_with_data.rda` is fully redundant: derivable on demand from `othervariables`+`played_with`, and nothing actually loads the persisted copy — its only "consumer" was the now-removed fugazi.db export. (One alternative explanation considered: maybe it exists as a precomputed cache so the Shiny app can start faster. Ruled out — the `app.R` code that builds its own copy runs unconditionally at app startup regardless of whether the persisted file exists, so the app gets no benefit from it either way; and the join itself is trivial (~1000 shows, ~1700 rows), nowhere near the cost of the actual expensive precomputed stage, the `mlogit` choice model.) **Fix**: stop persisting it as its own top-level package object in Repeatr (drop the `save(played_with_data, file = "played_with_data.rda")` line only; keep the local variable computation feeding `played_with_summary` unchanged), remove its `R/data.R` doc block and `man/played_with_data.Rd`, delete `Repeatr/data/played_with_data.rda`, and update the 2-3 places `Repeatr`'s own vignettes (`Data-Provenance.Rmd`, `Rebuilding-the-Data.Rmd`) list it as a persisted/exported object. This is a pure subtraction — no behavior change to the Shiny app (which never read the persisted object anyway) and no risk to any pipeline stage (confirmed via full-repo grep). `export_fugazidb_data()` therefore never loads `played_with_data` at all anymore — `played_with` is exported as-is (trimmed to `gid, played_with`), no merge/backfill needed.

## Changes to `Repeatr/R/export_fugazidb_data.R`

Rewrite the function to drop the CSV/`data-raw` half of `write_table()`, drop the unused `fls_tags_show` load, and change/merge the 9 write_table calls into 6:

```r
export_fugazidb_data <- function(fugazidb_dir, repeatr_data_dir = NULL) {

  mydir <- getwd()
  mydatadir <- if (is.null(repeatr_data_dir)) file.path(mydir, "data") else repeatr_data_dir

  out_dir <- file.path(fugazidb_dir, "data")

  load_obj <- function(name) {
    e <- new.env()
    load(file.path(mydatadir, paste0(name, ".rda")), envir = e)
    get(name, envir = e)
  }

  write_table <- function(df, name) {
    df <- dplyr::as_tibble(df) %>% dplyr::ungroup()
    assign(name, df)
    save(list = name, file = file.path(out_dir, paste0(name, ".rda")), envir = environment())
    df
  }

  # fls_shows - one row per gid; drops fls_notes (copyright), year/checked
  # (maintainer workflow only), x/y (duplicated by fls_venue_geocoding).
  # No longer needs the fls_tags_show join (only ever contributed `seconds`,
  # which is also dropped).
  othervariables <- load_obj("othervariables")
  gid_sound_quality <- load_obj("gid_sound_quality")

  fls_shows <- othervariables %>%
    left_join(gid_sound_quality, by = "gid") %>%
    select(-fls_notes, -year, -checked, -x, -y)
  fls_shows <- write_table(fls_shows, "fls_shows")

  # fls_venue_geocoding - mirror of the Google Sheet export, minus its
  # Google-Maps-lookup helper columns.
  fls_venue_geocoding <- read.csv(system.file("extdata", "fls_venue_geocoding_v2.csv", package = "Repeatr"), header = TRUE) %>%
    select(country, city, venue, y, x)
  fls_venue_geocoding <- write_table(fls_venue_geocoding, "fls_venue_geocoding")

  # fls_tags - date dropped (join fls_shows on gid instead), seconds dropped
  # (duplicates duration), track normalized character -> integer.
  fls_tags <- load_obj("fls_tags") %>%
    select(gid, track, song, duration) %>%
    mutate(track = as.integer(track))
  fls_tags <- write_table(fls_tags, "fls_tags")

  # releases - drop variable (snake_case UI name) and rym_rating.
  releases <- load_obj("releasesdatalookup") %>%
    filter(!releaseid %in% c(12, 13, 14, 15)) %>%
    select(releaseid, release, releasedate, release_date_source)
  releases <- write_table(releases, "releases")

  # songs - songidlookup (stable numeric songid + performance count) combined
  # with songvarslookup (discography metadata), joined by song title text.
  # Verified: both 92-row, one-row-per-song, identical song sets, no
  # overlapping columns besides `song` - a clean 1:1 merge.
  songidlookup <- load_obj("songidlookup")
  songvarslookup <- load_obj("songvarslookup")
  songs <- songidlookup %>% full_join(songvarslookup, by = "song")
  songs <- write_table(songs, "songs")

  # played_with - one row per real show+co-billed act. played_with_data is no
  # longer produced/loaded at all (see Context: it was a fully-derivable,
  # unused-by-the-app object in Repeatr itself, now removed there too).
  played_with <- load_obj("played_with") %>% select(gid, played_with)
  played_with <- write_table(played_with, "played_with")

  invisible(list(
    fls_shows = fls_shows,
    fls_venue_geocoding = fls_venue_geocoding,
    fls_tags = fls_tags,
    releases = releases,
    songs = songs,
    played_with = played_with
  ))
}
```

`song_tempo_bpm_data` is simply no longer loaded/written — Repeatr keeps its own copy for the Shiny app. (Note: each `write_table()` call's return value is captured back into the local variable, so the function's own `invisible(list(...))` return matches exactly what was written to disk, class included — a fix made during implementation, see session notes.)

**Roxygen block above the function** (currently lines 1-36): update `@title`/`@description` from "nine published tables"/"data-raw/*.csv and data/*.rda" to "six published tables"/"data/*.rda" only; update `@return` from "nine objects... writes `data-raw/*.csv` and `data/*.rda`" to "six objects... writes `data/*.rda`".

## Changes to `Repeatr/R/data.R`

Update the `@section Provenance:` line on these existing doc blocks to describe the new export shape (exact current text confirmed by grep):

- `othervariables` (line 69): mention `year`/`checked`/`x`/`y` are now also dropped from the `fls_shows` export.
- `played_with` (line 238): still "exported as-is" as fugazi.db's `played_with` (just trimmed to `gid`/`played_with`).
- `songidlookup` (line 326): no longer exported as its own table — now combined with `songvarslookup` into fugazi.db's `songs`.
- `songvarslookup` (line 376): same — combined into `songs`.
- `releasesdatalookup` (line 357): note `variable` and `rym_rating` are now also dropped from the `releases` export.
- `fls_tags` (lines 470-473): note `date`/`seconds` dropped, `track` now integer.
- `song_tempo_bpm_data` (line 496): no longer exported to fugazi.db at all — Repeatr-only now.

**Additional change (the `played_with_data` simplification from Context, above)**: delete the `played_with_data` doc block (lines 249-266) entirely — it's no longer a persisted/lazy-loadable data object.

In `R/Repeatr_1.R`: remove only the `save(played_with_data, file = "played_with_data.rda")` line (~line 1542). Leave everything else in that section untouched — `played_with_data` still gets computed as a local variable and still feeds `played_with_summary`'s derivation immediately after, unchanged.

Delete `Repeatr/data/played_with_data.rda` and `Repeatr/man/played_with_data.Rd`.

Update the 3 spots in Repeatr's own vignettes that enumerate this object as persisted/exported:
- `vignettes/Data-Provenance.Rmd` lines 69-71 (tree diagram of fugazi.db's exports) and line 103 (same list) — update to the new 6-table set (`fls_shows, fls_venue_geocoding, fls_tags, releases, songs, played_with`).
- `vignettes/Data-Provenance.Rmd` line 86 — drop `played_with_data` from the `| played_with, played_with_data, played_with_summary | Derived-cleaned | Repeatr_1() |` catalogue row (becomes `played_with, played_with_summary`).
- `vignettes/Rebuilding-the-Data.Rmd` line 63 — update "writes `fugazidb_dir/data-raw/*.csv` and `fugazidb_dir/data/*.rda` - nine tables in all (...)" to "writes `fugazidb_dir/data/*.rda` - six tables in all (`fls_shows`, `fls_venue_geocoding`, `fls_tags`, `releases`, `songs`, `played_with`)".

Run `devtools::document()` on Repeatr afterward (regenerates `man/*.Rd` there, including removing the orphaned `played_with_data.Rd` if the manual deletion above is skipped).

## Changes to `fugazi.db/R/data.R`

Delete the `songidlookup`, `songvarslookup`, `song_tempo_bpm_data`, and `played_with_data` doc blocks entirely. Update column lists (`\describe{}`) and provenance lines for `fls_shows`, `fls_venue_geocoding`, `fls_tags`, `releases`, `played_with` to match the new schemas above. Add a new `songs` doc block (replacing the three deleted ones), documenting: `songid, song, count, releaseid, track_number, instrumental, vocals_picciotto, vocals_mackaye, vocals_lally, duration_seconds`, sourced from combining `songidlookup` + `songvarslookup` by `song` title text. Update `releases`' `releaseid` item cross-reference from `\code{\link{songvarslookup}}` to `\code{\link{songs}}`. Package-level doc block: no object-count number to change there (only the vignette/README state "nine"), but verify.

Then run `devtools::document()` on fugazi.db and confirm the 4 orphaned `.Rd` files (`songidlookup.Rd`, `songvarslookup.Rd`, `song_tempo_bpm_data.Rd`, `played_with_data.Rd`) are auto-removed (they carry the roxygen2-generated header, so `roxygenize()` should clean them up) — delete manually if any remain.

## Changes to `fugazi.db/README.md`

- "Nine lazy-loaded data objects" → "Six lazy-loaded data objects".
- Replace the 9-row object table with 6 rows (drop `songvarslookup`/`song_tempo_bpm_data`/`songidlookup`/`played_with_data`, add `songs`).
- Delete the `data-raw/` sentence ("`data-raw/` holds the plain, human-readable copy of each table...") — that folder no longer exists.

## Changes to `fugazi.db/vignettes/Data-Catalogue.Rmd`

- "nine lazy-loaded data objects" → "six lazy-loaded data objects".
- Replace the "The tables" summary table (9 rows → 6, add `songs`).
- `### gid` section: drop `played_with_data` from the list of tables keyed by `gid`.
- `### song - discography metadata` section: replace the `songvarslookup`/`song_tempo_bpm_data`/`songidlookup` three-way join example with a `fls_tags %>% left_join(songs, by = "song")` example.
- `### releaseid` section: change `songvarslookup %>% left_join(releases, ...)` example to `songs %>% left_join(releases, ...)`.
- "What's excluded, and why": update the `songidlookup` reference to `songs$songid`; add a bullet noting song tempo (BPM) data is no longer exported here, kept in Repeatr only for its Shiny app.
- Closing line: drop the `data-raw/` mention.
- Per existing repo convention (confirmed in memory), keep all changes factual/present-tense — no "this used to include X" historical narrative.

## `fugazi.db/DESCRIPTION`

Bump `Version: 0.1.2` → `0.1.3`.

## Execution sequence

1. Edit `Repeatr/R/export_fugazidb_data.R`, `Repeatr/R/data.R`, and `Repeatr/R/Repeatr_1.R` (drop the `played_with_data.rda` save line); delete `Repeatr/data/played_with_data.rda` and `Repeatr/man/played_with_data.Rd`; update `Repeatr/vignettes/Data-Provenance.Rmd` and `Repeatr/vignettes/Rebuilding-the-Data.Rmd`. Run `devtools::document()` on Repeatr.
2. Delete `fugazi.db/data-raw/` entirely (`unlink(..., recursive = TRUE)`).
3. Delete the 4 stale `.rda` files from `fugazi.db/data/`: `song_tempo_bpm_data.rda`, `songidlookup.rda`, `songvarslookup.rda`, `played_with_data.rda`.
4. `devtools::load_all()` the updated Repeatr, then run `export_fugazidb_data(fugazidb_dir = "path/to/fugazi.db")` to regenerate the 6 `.rda` files fresh.
5. Edit `fugazi.db/R/data.R`, `README.md`, `vignettes/Data-Catalogue.Rmd`, `DESCRIPTION`.
6. Run `devtools::document()` on fugazi.db; confirm orphaned `.Rd` files are gone.
7. Verify: object classes are all consistent (`tbl_df`, ungrouped); `fls_tags$track` is integer; dropped columns are actually absent from each table; and the documented joins work — `fls_shows`↔`fls_tags` on `gid`, `fls_shows`↔`fls_venue_geocoding` on `country`+`city`+`venue`, `fls_shows`↔`played_with` on `gid`, `fls_tags`↔`songs` on `song` (expect 0 unmatched), `songs`↔`releases` on `releaseid` (some NA expected — unreleased songs, not a bug).
8. `devtools::check()` both packages. Additionally, run the Shiny app locally (`shiny::runApp("inst/shiny/Fugazetteer")`) to confirm removing `played_with_data.rda` from Repeatr's `data/` doesn't break it (expected: no effect, since `app.R` never read that object — but worth confirming empirically since it touches the app).
9. Leave both repos' changes uncommitted for review (per existing repo convention) — do not commit/push either package.

R is at `C:\Program Files\R\R-4.5.3\bin\Rscript.exe` (not on PATH). For anything beyond a one-line `Rscript -e`, write a `.R` script file and run it — inline multi-line `-e` strings are fragile in PowerShell.
