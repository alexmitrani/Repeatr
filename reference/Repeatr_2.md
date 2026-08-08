# takes a dataframe with one row per show-song and reshapes it long again so that the rows are identified by combinations of gid, song_number, and alt.

The first line of the data this was originally developed with:

washington-dc-usa-90387 FLS0001 03/09/1987 Wilson Center \$5 300 Joey
Picuri Fugazi Cassette Joe \#1 Intro Song \#1 Furniture Merchandise Turn
Off Your Guns In Defense Of Humans Waiting Room The Word

"gid" is short for "gig id"

## Usage

``` r
Repeatr_2(
  mydf = NULL,
  mysongidlookup = NULL,
  min_song_count = 2,
  input_dir = NULL,
  output_dir = NULL
)
```

## Arguments

- mydf:

  optional dataframe to be used (the `Repeatr1` element of
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)'s
  return list). If omitted the default (currently lazy-loaded)
  `Repeatr1` dataframe will be used.

- mysongidlookup:

  optional `songidlookup` dataframe to be used (the `songidlookup`
  element of
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)'s
  return list). If omitted the default (currently lazy-loaded)
  `songidlookup` dataframe will be used. Pass this explicitly - rather
  than relying on the default - when calling `Repeatr_2()` right after a
  fresh
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)
  in the same session, since the lazy-loaded default reflects the last
  build on disk, not the one just computed.

- min_song_count:

  Minimum number of performances a song needs to compete as an
  alternative in the choice model (`Repeatr_4`). Songs performed fewer
  times still appear in `songid`/`song` on the output, they just won't
  get an `alt` and can't be chosen as an alternative. Default 2 - songs
  performed only once can't support a stable alternative-specific
  intercept in the choice model. This is a choice-model concern only: it
  does not affect `songid`, which
  [`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)
  assigns to every classified song regardless of this threshold.

- input_dir:

  Optional directory to write the
  `fugazi_song_counts.csv`/`fugazi_song_performance_intensity.csv`
  output-export CSVs into. If omitted, defaults to this package's own
  `inst/extdata` (these are Repeatr's own downloadable outputs, not
  primary data, so they are not sourced from `fugazi.db`).

- output_dir:

  Optional directory to save the rebuilt `data/*.rda` objects into. If
  omitted, defaults to `data/` under the current working directory.

## Value

A list of 2 elements: `Repeatr2`, a data frame with one row per
gid/song_number/alt combination, prepared for choice modelling (`case`
is the choice-situation id, `alt` a dense 1..n index over the
`min_song_count`-eligible songs only - this is what `mlogit`/`Repeatr_4`
actually sees - `songid` the stable, full identity from `songidlookup`
kept alongside `alt` rather than overwritten by it, `choice` whether
that song was the one played, availability/played dummy variables, and
years-since-launch bucket variables); and `altlookup` (`alt`, `songid`,
`song`, `count` - one row per `min_song_count`-eligible song), needed by
[`Repeatr_5`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md)/[`rankr`](https://alexmitrani.github.io/Repeatr/reference/rankr.md)
to translate `mlogit`'s `alt`-indexed coefficients back to song
identity. Also saved to `data/Repeatr2.rda` and `data/altlookup.rda`,
alongside `fugazi_song_counts` and `fugazi_song_performance_intensity`
(which cover every classified song, not just the
`min_song_count`-eligible ones).

## Examples

``` r
Repeatr_2_results <- Repeatr_2(mydf = Repeatr1)
#> Error in setwd(mydatadir): cannot change working directory
Repeatr2 <- Repeatr_2_results[[1]]
#> Error: object 'Repeatr_2_results' not found
altlookup <- Repeatr_2_results[[2]]
#> Error: object 'Repeatr_2_results' not found
```
