# imports raw data in CSV format (1 row per show), cleans the data, and reshapes it long so that the rows are identified by combinations of gid and song_number.

This was originally developed with a headerless file called
"fugotcha.csv". It now reads "fls_data.csv" instead - a tidy, headered
CSV produced by
[`scrape_fls_shows`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_shows.md),
with one row per show and columns gid, fls_id, show_date, venue,
door_price, attendance, recorded_by, mastered_by, original_source,
sound_quality, played_with, fls_notes, track_1 ... track_n.

"gid" is short for "gig id"

Another data file that was used was called
"releases_songs_durations_wikipedia.csv" and was obtained from the
Wikipedia data on the Fugazi discography.

This file contains the following variables: index releaseid release
track_number songid song instrumental vocals_picciotto vocals_mackaye
vocals_lally duration_seconds

## Usage

``` r
Repeatr_1(
  mycsvfile = NULL,
  mysongdatafile = NULL,
  releasesdatafile = NULL,
  min_song_count = 2
)
```

## Arguments

- mycsvfile:

  Optional name of CSV file containing Fugazi Live Series data to be
  used (tidy, headered, as produced by
  [`scrape_fls_shows`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_shows.md)).
  If omitted, the default file provided with the package (fls_data.csv)
  will be used.

- mysongdatafile:

  Optional name of CSV file containing song data to be used. If omitted,
  the default file provided with the package will be used.

- releasesdatafile:

  Optional name of CSV file containing releases data to be used. If
  omitted, the default file provided with the package will be used.

- min_song_count:

  Minimum number of performances a song needs to be included in
  `songidlookup` and to compete as an alternative in the choice model
  (`Repeatr_4`). Songs performed fewer times still appear in `Repeatr1`
  by name, they just won't have a `songid`. Default 2 - songs performed
  only once can't support a stable alternative-specific intercept in the
  choice model.

## Value

A list of 11 elements: `Repeatr0`, `Repeatr1`, `songidlookup`,
`mycount`, `songvarslookup`, `releasesdatalookup`, `othervariables`,
`cumulative_song_counts`, `fls_tags`, `fls_tags_show`, and
`cumulative_duration_counts`. As a side effect, these and several other
derived datasets (including `gid_sound_quality`, `played_with`,
`shows_data`, `xray`) are also saved into `data/`.

## Examples

``` r
fls_data <- system.file("extdata", "fls_data.csv", package = "Repeatr")
releases_songs_durations_wikipedia <- system.file("extdata", "releases_songs_durations_wikipedia.csv", package = "Repeatr")
releasesdatafile <- system.file("extdata", "releases.csv", package = "Repeatr")
Repeatr_1_results <- Repeatr_1(mycsvfile = fls_data, mysongdatafile = releases_songs_durations_wikipedia, releasesdatafile = releasesdatafile)
#> Joining with `by = join_by(date, venue)`
#> Joining with `by = join_by(year)`
#> Warning: cannot open file '/home/runner/work/Repeatr/Repeatr/docs/reference/inst/extdata/fls_venue_geocoding.csv': No such file or directory
#> Error in file(file, "rt"): cannot open the connection
```
