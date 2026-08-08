# imports raw data (1 row per show), cleans the data, and reshapes it long so that the rows are identified by combinations of gid and song_number.

Reads its raw inputs from this package's own `inst/extdata/` by default:
`fls_data.csv` (one row per show, produced by
[`scrape_fls_shows`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_shows.md);
`tour`, `city`, `subdivision`, and `country` all come from the FLS
listing pages' own filter links/tour headings - see
[`scrape_fls_listing_data`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_listing_data.md)),
`releases_songs_durations_wikipedia.csv` (Wikipedia discography
metadata), `releases.csv` (release metadata),
`fls_venue_geocoding_v2.csv` (venue coordinates), and `fls_tags.txt`
(tag/duration data, via
[`fls_tags_importer`](https://alexmitrani.github.io/Repeatr/reference/fls_tags_importer.md)).
Each can be overridden with an explicit data frame instead - see the
parameters below.

"gid" is short for "gig id"

`songvarslookup` (read from
`inst/extdata/releases_songs_durations_wikipedia.csv`) contains the
following variables: releaseid track_number song instrumental
vocals_picciotto vocals_mackaye vocals_lally duration_seconds. It is
joined onto the live, classified song set by `song` title text, not by a
hardcoded id column - see `songid` below.

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
  `inst/extdata/fls_data.csv` (same shape: one row per show, as produced
  by
  [`scrape_fls_shows`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_shows.md)).

- mysongvarslookup:

  Optional data frame of song data to use instead of
  `inst/extdata/releases_songs_durations_wikipedia.csv`.

- myreleases:

  Optional data frame of releases data to use instead of
  `inst/extdata/releases.csv`.

- myfls_venue_geocoding:

  Optional data frame of venue coordinates to use instead of
  `inst/extdata/fls_venue_geocoding_v2.csv`.

- myfls_tags:

  Optional data frame of tag/duration data to use instead of
  `inst/extdata/fls_tags.txt`.

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
Repeatr_1_results <- Repeatr_1(output_dir = tempdir())
#> Joining with `by = join_by(year)`
#> Joining with `by = join_by(venue, city, country)`
#> Rows: 24531 Columns: 5
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ";"
#> chr (5): track, artist, album, name, duration
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> Joining with `by = join_by(date)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid, song)`
#> Joining with `by = join_by(song)`
#> Joining with `by = join_by(song)`
#> Joining with `by = join_by(releaseid)`
#> Joining with `by = join_by(song)`
#> Joining with `by = join_by(release)`
#> Joining with `by = join_by(song)`
#> Joining with `by = join_by(song)`
#> Joining with `by = join_by(song)`
#> Joining with `by = join_by(gid, date, song_number)`
#> Joining with `by = join_by(date)`
#> Joining with `by = join_by(releaseid)`
#> Joining with `by = join_by(releaseid)`
#> Joining with `by = join_by(gid, song)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(releaseid, release)`
#> Joining with `by = join_by(songid)`
#> Joining with `by = join_by(song)`
#> Joining with `by = join_by(gid, song)`
#> Joining with `by = join_by(gid, song)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
```
