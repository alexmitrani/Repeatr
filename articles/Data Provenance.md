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
and the `Provenance` section of its help page). This vignette is the
single place that catalogues every dataset in `data/` against that
spectrum, so that question never again requires cross-referencing
`R/data.R`’s `@source` tags, `data-raw/build_data.R`’s comments, and
file modification times by hand.

Each dataset’s help page
([`?Repeatr1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr1.md),
[`?songidlookup`](https://alexmitrani.github.io/Repeatr/reference/songidlookup.md),
etc., all documented in `R/data.R`) carries a `Provenance` section using
the same five tiers used here. **Before adding a new dataset or
reclassifying an existing one, check `inst/shiny/Fugazetteer/app.R` and
`vignettes/*.Rmd` for consumers, not just `R/`** - the Shiny app and
several vignettes read package data directly without that being visible
from a search of `R/` alone, and some of them locally rebuild an object
under the same name as a package dataset without ever touching the
lazy-loaded original (see the `Frozen-legacy` table below for concrete
examples of both traps).

## Types of data

- **Raw-scraped** - pulled directly from an external website by an
  automated scraper, no hand-editing.
- **Raw-hand-curated** - a CSV or text file edited by a human outside of
  any script, using an external reference source (Wikipedia, Google
  Maps, a personal MP3 collection, a `liveBPM` reading).
- **Derived-cleaned** - mechanically produced from raw inputs by
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
  this vignette’s last update - flagged here specifically because “not
  written by the pipeline” is not sufficient evidence of “unused” (see
  the raw-hand-curated and Shiny-only datasets below, which also aren’t
  written by the pipeline but are very much in use).

## Data processing sequence

    Raw sources
    ├─ fls_data.csv (scraped, scrape_fls_shows())
    ├─ fls_tags.txt (hand-curated, kid3 export)
    ├─ fls_venue_geocoding*.csv (hand-curated, Google Maps)
    ├─ releases_songs_durations_wikipedia.csv (hand-curated, Wikipedia)
    ├─ releases.csv (hand-curated, rateyourmusic.com + manual colour_code)
    └─ song_tempo_bpm_data.csv (hand-curated, liveBPM app)
            │
            ▼ (all except song_tempo_bpm_data.csv, which the Shiny app reads directly)
    Repeatr_1()
    ├─ Repeatr0, othervariables, gid_sound_quality, played_with*, shows_data,
    │  fls_tags*, duration_data_da, duration_summary, cumulative_*, xray,
    │  releasesdatalookup, releases_menu_list, releaseid_variable_colour_code,
    │  transitions_data_da, last_performance_data   [Derived-cleaned]
    ├─ Repeatr1, songidlookup                        [Derived-classified]
    └─ songvarslookup                                [Raw-hand-curated, joined in by song name]
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

    Frozen-legacy (disconnected from the live pipeline)
    rawdata, toursdata, attendancedata, transitions

## Dataset catalogue

### Raw sources (not R objects - files in `inst/extdata/`)

| Source file | Tier | Read by |
|----|----|----|
| `fls_data.csv` | Raw-scraped | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md), via [`scrape_fls_shows()`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_shows.md). Also carries `tour`/`city`/`subdivision`/`country`, scraped from the listing pages via [`scrape_fls_listing_data()`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_listing_data.md) (see [`?Repeatr0`](https://alexmitrani.github.io/Repeatr/reference/Repeatr0.md)) |
| `fls_tags.txt` | Raw-hand-curated | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md), via [`fls_tags_importer()`](https://alexmitrani.github.io/Repeatr/reference/fls_tags_importer.md) |
| `fls_venue_geocoding_v2.csv` | Raw-hand-curated | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) - the current primary source of venue `x`/`y`, matched by `country`/`city`/`venue`. A periodically hand-updated local snapshot of a private Google Sheet (not fetched live - that sheet isn’t reliably available) |
| `fugazi-small.csv` | Raw-hand-curated, legacy | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) - fallback `x`/`y` only, for venues `fls_venue_geocoding_v2.csv` doesn’t cover yet (matched by `date`+`venue`, not `country`/`city`/`venue`); `tour`/`city`/`country`/`year` no longer read from this file |
| `fls_venue_geocoding.csv` | Frozen-legacy | Not read by [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) anymore (superseded by `_v2.csv`) or by [`nscmov()`](https://alexmitrani.github.io/Repeatr/reference/nscmov.md)’s workflow, which is itself retired - kept for reference only |
| `venue_name_corrections.csv` | Raw-hand-curated | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) - `country`/`city`/`venue` → `*_corrected` aliases so scraped show locations match `fls_venue_geocoding_v2.csv`’s spelling (e.g. venue “Rivoli” → “Rivoli Theater”, city “Gavoi, Sardinia” → “Gavoi”, country “Spain/Basque” → “Spain”); same idea as `fls_tags_name_recoded.csv` below but for show locations. `fls_venue_geocoding_v2.csv` is the source of truth for these names as well as coordinates - if a geocoding entry’s own label turns out to be wrong, fix it in the sheet, not with a code-side override |
| `releases_songs_durations_wikipedia.csv` | Raw-hand-curated | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md), joined by `song` name (see [`?songvarslookup`](https://alexmitrani.github.io/Repeatr/reference/songvarslookup.md)) |
| `releases.csv` | Raw-hand-curated | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md), produces `releasesdatalookup` |
| `song_tempo_bpm_data.csv` | Raw-hand-curated | `inst/shiny/Fugazetteer/app.R` directly - **not** read by [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) |
| `fugotcha.csv`, `gid_fls_id_played_with.csv`, `gid_fls_id_sound_quality.csv`, `gid_played_with_6.csv`, `gid_played_with_8.csv` | Raw-scraped, superseded | None - kept for reference only |
| `outsiders.csv` | Raw-hand-curated | Not read by `R/`; consult before assuming unused (see caveat above) |
| `othervariables_patch.csv` | Raw-hand-curated | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) |
| `fls_tags_name_recoded.csv` | Raw-hand-curated | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) |

### `data/*.rda` objects

| Dataset | Tier | Produced by |
|----|----|----|
| `Repeatr0` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) |
| `othervariables` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md); also read directly by `app.R` |
| `gid_sound_quality` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) |
| `gid_initial_gid_sound_quality` | Derived-modeled | [`Repeatr_6()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_6.md), via [`sweepstack()`](https://alexmitrani.github.io/Repeatr/reference/sweepstack.md)/[`stacks()`](https://alexmitrani.github.io/Repeatr/reference/stacks.md), whenever [`Repeatr_Updatr()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_Updatr.md) is run with `update_stacks = TRUE`; read directly by `app.R`’s “stock” pages |
| `played_with`, `played_with_data`, `played_with_summary` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) |
| `shows_data` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md); also read directly by `app.R` |
| `fls_tags`, `fls_tags_show` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md), from `fls_tags.txt` |
| `duration_data_da`, `duration_summary`, `cumulative_duration_counts`, `cumulative_song_counts` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) |
| `last_performance_data`, `xray`, `transitions_data_da` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) |
| `releasesdatalookup`, `releases_menu_list`, `releaseid_variable_colour_code` | Derived-cleaned | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) |
| `Repeatr1` | Derived-classified | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md) |
| `songidlookup` | Derived-classified | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md); the single source of truth for song identity |
| `songvarslookup` | Raw-hand-curated | [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md), read from `releases_songs_durations_wikipedia.csv` |
| `song_tempo_bpm_data` | Raw-hand-curated | Not regenerated by any script; read directly by `app.R` |
| `Repeatr2`, `Repeatr3` | Derived-modeled | [`Repeatr_2()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md) / [`Repeatr_3()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_3.md) - applies the `min_song_count` filter and builds `alt` |
| `altlookup` | Derived-modeled | [`Repeatr_2()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md); the `alt` \<-\> `songid`/`song` translation table used by [`Repeatr_5()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md)/[`rankr()`](https://alexmitrani.github.io/Repeatr/reference/rankr.md) |
| `fugazi_song_counts` | Derived-modeled | [`Repeatr_2()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md); covers every classified song, not just the `min_song_count`-eligible ones |
| `fugazi_song_performance_intensity` | Derived-modeled | [`Repeatr_2()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md); `min_song_count`-eligible songs only |
| `results_ml_Repeatr4`, `vcovmat_ml_Repeatr4` | Derived-modeled | [`Repeatr_4()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_4.md), saved together so they always describe the same fit |
| `fugazi_song_choice_model`, `fugazi_song_preferences`, `releases_rated`, `releases_summary`, `releases_data_input`, `summary` | Derived-modeled | [`Repeatr_5()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md); `summary` is also read directly by `app.R` |
| `rawdata` | Frozen-legacy | Superseded by `Repeatr0`; no consumers found |
| `toursdata`, `attendancedata` | Frozen-legacy | No consumers found; same-named local variables in `app.R`/vignettes shadow rather than use these |
| `transitions` | Frozen-legacy | No consumers found; distinct from the actively-used `transitions_data_da` |

For the full column-by-column description of any dataset, see its help
page
(e.g. [`?summary`](https://alexmitrani.github.io/Repeatr/reference/summary.md)).
