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
[`fugazibase`](https://github.com/alexmitrani/fugazibase) is downstream
of this package, not upstream of it: composes a subset of Repeatr’s own
Derived-cleaned tier (corrected, reformatted, and keyed for joining, but
with no joined/summarized/modeled columns and no copyrighted free-text
show notes) and writes it into a local `fugazibase` checkout. See
`vignette("Data-Catalogue", package = "fugazibase")` for that package’s
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
- **Shiny-presentation-only** - `shiny_*` objects produced by , saved to
  `data/*.rda` purely so `app.R` doesn’t redo, on every app start,
  joins/aggregations that don’t depend on its three live Google Sheets
  reads. Cached views of other tiers’ data, not a distinct source of
  truth - not consumed by any `R/` function and not exported to
  fugazibase.

## Data processing sequence

    inst/extdata/ (primary data - fls_data.csv, fls_tags.txt, releases.csv,
                   releases_songs_durations_wikipedia.csv,
                   song_tempo_bpm_data.csv, fls_venue_geocoding_v2.csv)
            │
            ▼
    Repeatr_1()
    ├─ Repeatr0, othervariables, gid_sound_quality, played_with*, shows_data,
    │  fls_tags*, duration_data_da, duration_summary, position_summary,
    │  cumulative_*, xray,
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
    export_fugazibase_data()
    └─ fugazibase: shows, locations, durations, discography,
       songs, bands

    (separately, from whichever of the tiers above app.R itself reads)
            │
            ▼
    build_shiny_precompute()
    └─ shiny_year_tour_release, shiny_fls_link_year_tour,
       shiny_transitions_data_da, shiny_duration_data_da,
       shiny_othervariables_base, shiny_year_tour_gid_song,
       shiny_discography, shiny_releases_data_input,
       shiny_releases_summary, shiny_shows_data_base
                                              [Shiny-presentation-only]

`songvarslookup` is joined into `Repeatr1` by `title` text, not carried
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
| `duration_data_da`, `duration_summary`, `position_summary`, `cumulative_duration_counts`, `cumulative_position_counts`, `cumulative_song_counts` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) |
| `last_performance_data`, `xray`, `transitions_data_da` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) |
| `releasesdatalookup`, `releases_menu_list`, `releaseid_variable_colour_code` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md), from `inst/extdata/releases.csv` |
| `songvarslookup` | Derived-cleaned/Raw-hand-curated | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) reads it as-is from `inst/extdata/releases_songs_durations_wikipedia.csv` |
| `song_tempo_bpm_data` | Raw-hand-curated | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) reads it as-is from `inst/extdata/song_tempo_bpm_data.csv` |
| `Repeatr1` | Derived-classified | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) |
| `songidlookup` | Derived-classified | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md); the single source of truth for song identity |
| `Repeatr2`, `Repeatr3` | Derived-modeled | [`Repeatr_2()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md) / [`Repeatr_3()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_3.md) - applies the `min_song_count` filter and builds `alt` |
| `altlookup` | Derived-modeled | [`Repeatr_2()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md); the `alt` \<-\> `songid`/`title` translation table used by [`Repeatr_5()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md)/[`rankr()`](https://alexmitrani.github.io/Repeatr/reference/rankr.md) |
| `fugazi_song_counts` | Derived-modeled | [`Repeatr_2()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md); covers every classified song, not just the `min_song_count`-eligible ones |
| `fugazi_song_performance_intensity` | Derived-modeled | [`Repeatr_2()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md); `min_song_count`-eligible songs only |
| `results_ml_Repeatr4`, `vcovmat_ml_Repeatr4` | Derived-modeled | [`Repeatr_4()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_4.md), saved together so they always describe the same fit |
| `fugazi_song_choice_model`, `fugazi_song_preferences`, `releases_rated`, `releases_summary`, `releases_data_input`, `summary` | Derived-modeled | [`Repeatr_5()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md); `summary` is also read directly by `app.R` |
| `shiny_year_tour_release`, `shiny_fls_link_year_tour`, `shiny_transitions_data_da`, `shiny_duration_data_da`, `shiny_othervariables_base`, `shiny_year_tour_gid_song`, `shiny_discography`, `shiny_releases_data_input`, `shiny_releases_summary`, `shiny_shows_data_base` | Shiny-presentation-only | ; read directly, and only, by `app.R` |

For the full column-by-column description of any dataset, see its help
page
(e.g. [`?summary`](https://alexmitrani.github.io/Repeatr/reference/summary.md)).
For fugazibase’s own tables (`shows`, `locations`, `durations`,
`discography`, `songs`, `bands`), see
`vignette("Data-Catalogue", package = "fugazibase")`.

Note on `app.R`: it reads `song_tempo_bpm_data` directly (via
[`library(Repeatr)`](https://alexmitrani.github.io/Repeatr)’s
lazy-loaded data), and the `shiny_*` objects above in place of
recomputing their joins itself, but for venue coordinates specifically
it does *not* use any package data’s `x`/`y` - at startup it re-fetches
coordinates live from a Google Sheet (`gsheet2tbl()`) and joins them
onto `shiny_othervariables_base`/`shiny_shows_data_base` (which
deliberately carry no coordinates of their own) to produce the runtime
`othervariables`/`shows_data`. So the deployed app’s map coordinates
track that live sheet, not any package release. Two other live sheets
(`quizdata`, `linktracksindexdata`) are fetched lazily, inside their own
tab’s server-side `reactive()`, so a cold app start doesn’t pay for
sheets nobody visits that session.

`shows_data`’s `distance_home_km`/`distance_to_km`/`distance_back_km`
columns (issue \#259, see
[`?shows_data`](https://alexmitrani.github.io/Repeatr/reference/shows_data.md))
are an exception to “no judgment calls” within the Derived-cleaned tier:
they depend on `classify_show_trips()`’s geography/date-based
classification of each show as home-based or part of a tour chain. That
classification is intentionally independent of - and checked against,
never driven by - the existing `tour` column, whose own
tour/regional-dates labelling isn’t reliable enough to build on. These
three columns are internal to Repeatr only; ’s `shows` table selects its
columns explicitly and doesn’t include them.
