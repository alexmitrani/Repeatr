# Fugazi Live Series choice data in long format with related discography data

Song data from the Fugazi discography pages on Wikipedia. The variables
attributing lead vocals are simplifications in some cases where lead
vocals were shared. The variables song_number, first_song and last_song
were defined after data cleaning, so intros, outros, sound checks,
interludes and one-offs are not included.

## Usage

``` r
Repeatr2
```

## Format

dataframe with one row for each show, each song performed and each song
available in all the Fugazi Live Series shows with data.

- case:

  This is a numerical id with unique values for each combination of gid
  and song_number

- gid:

  gig id. This is a concatenation of city, country, and date

- date:

  Show date

- year:

  Year

- launchdate:

  The date on which the song was first performed according to the data

- yearsold:

  The difference between the date of the show and the launchdate of the
  song, measured in years

- song_number:

  The number of the song in the sequence of songs that were performed as
  part of that show

- alt:

  A dense 1..n index over the `min_song_count`-eligible songs only, in
  `songid` order - this is the alternative-specific index
  `mlogit`/[`Repeatr_4`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_4.md)
  actually sees. See `songid` below for the stable song identity this is
  derived from.

- songid:

  The stable, full song identity from
  [`songidlookup`](https://alexmitrani.github.io/Repeatr/reference/songidlookup.md),
  kept alongside `alt` rather than overwritten by it.

- title:

  The name of the song

- choice:

  1 if the song was performed at that point in the show, 0 otherwise

- played:

  1 if the song was performed at or before that point in the show, 0
  otherwise

- available_rl:

  Repertoire-level availability: 1 if the song was available in the
  repertoire for this show, 0 otherwise

- available_gl:

  Gig-level availability: 1 if the song was available in the repertoire
  and was available to be played at this point in this show, 0 otherwise

- first_song:

  Identifies the first song of the set

- last_song:

  Identifies the last song of the set

- rid:

  numeric id in ascending chronological order

- release_title:

  name of album or EP

- track_number:

  The track number for the song on the release

- instrumental:

  Indicates whether or not the piece is an instrumental

- vocals_picciotto:

  indicates whether or not Guy Picciotto sang lead vocals on this track

- vocals_mackaye:

  indicates whether or not Ian Mackaye sang lead vocals on this track

- vocals_lally:

  indicates whether or not Joe Lally sang lead vocals on this track

- duration_seconds:

  The duration of the song in seconds

- first_song_instrumental:

  1 if first song of the show and instrumental, 0 otherwise

## Source

https://www.dischord.com/fugazi_live_series

https://web.archive.org/web/20201112000517/http://en.wikipedia.org/wiki/Fugazi_discography

## Provenance

Derived-modeled. Produced by
[`Repeatr_2`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md):
this is where the `min_song_count` modelling-eligibility filter is
applied and the dense `alt` choice-model index is constructed from the
stable `songid` in
[`songidlookup`](https://alexmitrani.github.io/Repeatr/reference/songidlookup.md) -
the analysis-side counterpart to `Repeatr1`'s full, unfiltered song set.

## Examples

``` r
Repeatr2
#> # A tibble: 896,887 × 25
#>     case gid       date        year launchdate yearsold song_number   alt songid
#>    <int> <chr>     <date>     <dbl> <date>        <dbl>       <dbl> <dbl>  <int>
#>  1     1 washingt… 1987-09-03  1987 1987-09-03        0           1    36     36
#>  2     1 washingt… 1987-09-03  1987 1987-09-03        0           1    43     43
#>  3     1 washingt… 1987-09-03  1987 1987-09-03        0           1    45     45
#>  4     1 washingt… 1987-09-03  1987 1987-09-03        0           1    55     55
#>  5     1 washingt… 1987-09-03  1987 1987-09-03        0           1    77     77
#>  6     1 washingt… 1987-09-03  1987 1987-09-03        0           1    86     86
#>  7     1 washingt… 1987-09-03  1987 1987-09-03        0           1    87     87
#>  8     1 washingt… 1987-09-03  1987 1987-09-03        0           1    91     91
#>  9     3 washingt… 1987-09-03  1987 1987-09-03        0           3    36     36
#> 10     3 washingt… 1987-09-03  1987 1987-09-03        0           3    43     43
#> # ℹ 896,877 more rows
#> # ℹ 16 more variables: title <chr>, choice <dbl>, played <dbl>,
#> #   available_rl <dbl>, available_gl <dbl>, first_song <dbl>, last_song <dbl>,
#> #   rid <int>, release_title <chr>, track_number <int>, instrumental <int>,
#> #   vocals_picciotto <int>, vocals_mackaye <int>, vocals_lally <int>,
#> #   duration_seconds <int>, first_song_instrumental <dbl>
```
