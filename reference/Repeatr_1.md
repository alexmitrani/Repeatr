# imports raw data (1 row per show), cleans the data, and reshapes it long so that the rows are identified by combinations of gid and song_number.

Reads its raw inputs from the `fugazi.db` package by default:
[`fugazi.db::fls_data`](https://rdrr.io/pkg/fugazi.db/man/fls_data.html)
(one row per show, produced by
[`scrape_fls_shows`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_shows.md);
`tour`, `city`, `subdivision`, and `country` all come from the FLS
listing pages' own filter links/tour headings - see
[`scrape_fls_listing_data`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_listing_data.md)),
[`fugazi.db::songvarslookup`](https://rdrr.io/pkg/fugazi.db/man/songvarslookup.html)
(Wikipedia discography metadata),
[`fugazi.db::releases`](https://rdrr.io/pkg/fugazi.db/man/releases.html)
(release metadata),
[`fugazi.db::fls_venue_geocoding`](https://rdrr.io/pkg/fugazi.db/man/fls_venue_geocoding.html)
(venue coordinates), and
[`fugazi.db::fls_tags_raw`](https://rdrr.io/pkg/fugazi.db/man/fls_tags_raw.html)
(tag/duration data). Each can be overridden with an explicit data frame
instead - e.g. to run this against a local `fugazi.db` checkout without
reinstalling it - see the parameters below.

"gid" is short for "gig id"

[`fugazi.db::songvarslookup`](https://rdrr.io/pkg/fugazi.db/man/songvarslookup.html)
contains the following variables: releaseid track_number song
instrumental vocals_picciotto vocals_mackaye vocals_lally
duration_seconds. It is joined onto the live, classified song set by
`song` title text, not by a hardcoded id column - see `songid` below.

## Usage

``` r
Repeatr_1(
  myfls_data = NULL,
  mysongvarslookup = NULL,
  myreleases = NULL,
  myfls_venue_geocoding = NULL,
  myfls_tags = NULL,
  output_dir = NULL
)
```

## Arguments

- myfls_data:

  Optional data frame of Fugazi Live Series show data to use instead of
  [`fugazi.db::fls_data`](https://rdrr.io/pkg/fugazi.db/man/fls_data.html)
  (same shape: one row per show, as produced by
  [`scrape_fls_shows`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_shows.md)).

- mysongvarslookup:

  Optional data frame of song data to use instead of
  [`fugazi.db::songvarslookup`](https://rdrr.io/pkg/fugazi.db/man/songvarslookup.html).

- myreleases:

  Optional data frame of releases data to use instead of
  [`fugazi.db::releases`](https://rdrr.io/pkg/fugazi.db/man/releases.html).

- myfls_venue_geocoding:

  Optional data frame of venue coordinates to use instead of
  [`fugazi.db::fls_venue_geocoding`](https://rdrr.io/pkg/fugazi.db/man/fls_venue_geocoding.html).

- myfls_tags:

  Optional data frame of tag/duration data to use instead of
  [`fugazi.db::fls_tags_raw`](https://rdrr.io/pkg/fugazi.db/man/fls_tags_raw.html).

- output_dir:

  Optional directory to save the rebuilt `data/*.rda` objects into. If
  omitted, defaults to `data/` under the current working directory (the
  package root, in the normal `devtools::load_all(); Repeatr_Updatr()`
  workflow).

## Value

A list of 13 elements: `Repeatr0`, `Repeatr1`, `songidlookup`,
`mycount`, `songvarslookup`, `releasesdatalookup`, `othervariables`,
`cumulative_song_counts`, `fls_tags`, `fls_tags_show`,
`cumulative_duration_counts`, `releases_data_input`, and
`raw_fls_song_list`. As a side effect, these and several other derived
datasets (including `gid_sound_quality`, `played_with`, `shows_data`,
`xray`) are also saved into `data/` (or `output_dir`, if supplied).
`songidlookup` assigns a stable `songid` to every classified song,
including one-offs and rarities - the modelling-eligibility filter
(`min_song_count`) that used to be applied here has moved to
[`Repeatr_2`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md),
which is where it belongs since it's a choice-model concern, not a
question of song identity.

## Examples

``` r
Repeatr_1_results <- Repeatr_1()
#> Joining with `by = join_by(year)`
#> Joining with `by = join_by(venue, city, country)`
#> Error in setwd(mydatadir): cannot change working directory
```
