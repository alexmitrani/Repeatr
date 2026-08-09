# Data Provenance

## Introduction

Every dataset in this package is somewhere on a spectrum from “raw,
exactly as scraped or hand-entered from an external source” to “the
output of a statistical model.” That distinction matters: raw and
hand-curated data can only be *wrong* (a typo, a stale lookup), while
derived and modelled data can also be *inconsistent with itself* if two
different steps compute the same thing two different ways - which is
exactly what happened to `songid` (see
[`?songidlookup`](https://alexmitrani.github.io/Repeatr/reference/songidlookup.md)
and the `Provenance` section of its help page). This vignette catalogues
every dataset produced *in this package* against that spectrum.

Primary/raw data - the “raw, exactly as scraped or hand-entered” end of
the spectrum - lives in this package’s own `inst/extdata/`
(`fls_data.csv`, `fls_tags.txt`, `releases.csv`,
`releases_songs_durations_wikipedia.csv`, `song_tempo_bpm_data.csv`,
`fls_venue_geocoding_v2.csv`).
[`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)
turns those six raw sources into everything below.

The companion package
[`fugazi.db`](https://github.com/alexmitrani/fugazi.db) is downstream of
this package, not upstream of it: composes a subset of Repeatr’s own
Derived-cleaned tier (corrected, reformatted, and keyed for joining, but
with no joined/summarized/modeled columns and no copyrighted free-text
show notes) and writes it into a local `fugazi.db` checkout. See
`vignette("Data-Catalogue", package = "fugazi.db")` for that package’s
own catalogue and join keys.

**Before adding a new dataset or reclassifying an existing one, check
`inst/shiny/Fugazetteer/app.R` and `vignettes/*.Rmd` for consumers, not
just `R/`** - the Shiny app and several vignettes read package data
directly without that being visible from a search of `R/` alone, and
some of them locally rebuild an object under the same name as a package
dataset without ever touching the lazy-loaded original (see the
`Frozen-legacy` table below for concrete examples of both traps).

## Types of data

- **Raw-scraped** / **Raw-hand-curated** - primary data, as scraped ()
  or hand-curated directly into this package’s own `inst/extdata/`.
- **Derived-cleaned** - mechanically produced from `inst/extdata/`’s raw
  sources by
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md),
  with no judgment calls beyond straightforward joins/typing/renaming.
- **Derived-classified** - mechanically produced by
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md),
  but shaped by the hand-written
  [`grepl()`](https://rdrr.io/r/base/grep.html)-based song-title
  recoding and `tracktype` classification rules - i.e. the layer where a
  rule change can shift which songs exist and how they’re numbered.
- **Derived-modeled** - depends on the `mlogit` choice model fit in
  [`Repeatr_4()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_4.md),
  or on the `min_song_count` modelling-eligibility filter applied from
  [`Repeatr_2()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md)
  onward.
- **Frozen-legacy** - present in `data/` but not written by any current
  pipeline stage (no [`save()`](https://rdrr.io/r/base/save.html) call
  anywhere in `R/`, not touched by `data-raw/build_data.R`). Confirmed
  to have no consumers in `R/`, `vignettes/`, or `app.R` either, as of
  this vignette’s last update.

## Data processing sequence

    inst/extdata/ (primary data - fls_data.csv, fls_tags.txt, releases.csv,
                   releases_songs_durations_wikipedia.csv,
                   song_tempo_bpm_data.csv, fls_venue_geocoding_v2.csv)
            │
            ▼
    Repeatr_1()
    ├─ Repeatr0, othervariables, gid_sound_quality, played_with*, shows_data,
    │  fls_tags*, duration_data_da, duration_summary, cumulative_*, xray,
    │  releasesdatalookup, releases_menu_list, releaseid_variable_colour_code,
    │  transitions_data_da, last_performance_data, songvarslookup,
    │  song_tempo_bpm_data                          [Derived-cleaned]
    └─ Repeatr1, songidlookup                        [Derived-classified]
            │
            ▼
    Repeatr_2() ─▶ Repeatr_3() ─▶ Repeatr_4() ─▶ Repeatr_5()
    ├─ Repeatr2, Repeatr3, altlookup,
    │  fugazi_song_performance_intensity              [Derived-modeled: min_song_count filter + alt]
    ├─ fugazi_song_counts                              [Derived-modeled: covers every classified song]
    ├─ results_ml_Repeatr4, vcovmat_ml_Repeatr4        [Derived-modeled: mlogit fit]
    └─ fugazi_song_choice_model, fugazi_song_preferences,
       releases_rated, releases_summary, releases_data_input, summary
                                                        [Derived-modeled: model output]
            │
            ▼ (update_stacks = TRUE)
    Repeatr_6()
    └─ gid_initial_gid_sound_quality                  [Derived-modeled: depends on summary]

            │ (from the Derived-cleaned tier only, minus fls_notes)
            ▼
    export_fugazidb_data()
    └─ fugazi.db: fls_shows, fls_venue_geocoding, fls_tags, releases,
       songs, played_with

`songvarslookup` is joined into `Repeatr1` by song title, not carried
forward with its own `songid` column - the hand-maintained CSV behind it
(`inst/extdata/releases_songs_durations_wikipedia.csv`) doesn’t carry
one, precisely so it can’t silently drift out of sync with the songid
[`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)
computes; see
[`?songidlookup`](https://alexmitrani.github.io/Repeatr/reference/songidlookup.md)
for that mapping.

## Dataset catalogue

### `data/*.rda` objects

| Dataset | Tier | Produced by |
|----|----|----|
| `Repeatr0` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md), from `inst/extdata/fls_data.csv` |
| `othervariables` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md), joining `inst/extdata/fls_data.csv` with `inst/extdata/fls_venue_geocoding_v2.csv`; also read directly by `app.R` |
| `gid_sound_quality` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) |
| `gid_initial_gid_sound_quality` | Derived-modeled | [`Repeatr_6()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_6.md), via [`sweepstack()`](https://alexmitrani.github.io/Repeatr/reference/sweepstack.md)/[`stacks()`](https://alexmitrani.github.io/Repeatr/reference/stacks.md), whenever [`Repeatr_Updatr()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_Updatr.md) is run with `update_stacks = TRUE`; read directly by `app.R`’s “stock” pages |
| `played_with`, `played_with_summary` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) |
| `shows_data` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md); also read directly by `app.R` |
| `fls_tags`, `fls_tags_show` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md), from `inst/extdata/fls_tags.txt` (via ) |
| `duration_data_da`, `duration_summary`, `cumulative_duration_counts`, `cumulative_song_counts` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) |
| `last_performance_data`, `xray`, `transitions_data_da` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) |
| `releasesdatalookup`, `releases_menu_list`, `releaseid_variable_colour_code` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md), from `inst/extdata/releases.csv` |
| `songvarslookup` | Derived-cleaned/Raw-hand-curated | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) reads it as-is from `inst/extdata/releases_songs_durations_wikipedia.csv` |
| `song_tempo_bpm_data` | Raw-hand-curated | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) reads it as-is from `inst/extdata/song_tempo_bpm_data.csv` |
| `Repeatr1` | Derived-classified | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) |
| `songidlookup` | Derived-classified | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md); the single source of truth for song identity |
| `Repeatr2`, `Repeatr3` | Derived-modeled | [`Repeatr_2()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md) / [`Repeatr_3()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_3.md) - applies the `min_song_count` filter and builds `alt` |
| `altlookup` | Derived-modeled | [`Repeatr_2()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md); the `alt` \<-\> `songid`/`song` translation table used by [`Repeatr_5()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md)/[`rankr()`](https://alexmitrani.github.io/Repeatr/reference/rankr.md) |
| `fugazi_song_counts` | Derived-modeled | [`Repeatr_2()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md); covers every classified song, not just the `min_song_count`-eligible ones |
| `fugazi_song_performance_intensity` | Derived-modeled | [`Repeatr_2()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md); `min_song_count`-eligible songs only |
| `results_ml_Repeatr4`, `vcovmat_ml_Repeatr4` | Derived-modeled | [`Repeatr_4()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_4.md), saved together so they always describe the same fit |
| `fugazi_song_choice_model`, `fugazi_song_preferences`, `releases_rated`, `releases_summary`, `releases_data_input`, `summary` | Derived-modeled | [`Repeatr_5()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md); `summary` is also read directly by `app.R` |

For the full column-by-column description of any dataset, see its help
page
(e.g. [`?summary`](https://alexmitrani.github.io/Repeatr/reference/summary.md)).
For fugazi.db’s own tables (`fls_shows`, `fls_venue_geocoding`,
`fls_tags`, `releases`, `songs`, `played_with`), see
`vignette("Data-Catalogue", package = "fugazi.db")`.

Note on `app.R`: it reads `song_tempo_bpm_data` and
`shows_data`/`othervariables` directly (via
[`library(Repeatr)`](https://alexmitrani.github.io/Repeatr)’s
lazy-loaded data), but for venue coordinates specifically it does *not*
use the package’s own `x`/`y` - at startup it re-fetches coordinates
live from a Google Sheet (`gsheet2tbl()`) and overwrites whatever
`othervariables`/`shows_data` provided. So the deployed app’s map
coordinates track that live sheet, not any package release.
