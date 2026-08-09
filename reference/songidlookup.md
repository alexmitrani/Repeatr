# Fugazi song id lookup table

Fugazi song id lookup table

## Usage

``` r
songidlookup
```

## Format

dataframe with one row for each song in the Fugazi discography, except
those which never appear in the Fugazi Live Series data.

- songid:

  numeric id for each song, based on the alphabetical order of the song
  names. Assigned to every classified song, including one-off
  performances and rarities below `min_song_count`.

- song:

  The name of the song

- count:

  The number of times the song was performed according to the data. Used
  by
  [`Repeatr_2`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md)
  to apply the `min_song_count` choice-model eligibility filter.

## Provenance

Derived-classified. Computed live in
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)
from `Repeatr1`; the single source of truth for song identity - not
hand-edited, and (after the songid fix) assigned to every classified
song including one-offs, not just those meeting `min_song_count`. Not
exported to fugazi.db - `songid` and `count` are calculated/summary
values, kept internal to `Repeatr` by design; fugazi.db's `songs` table
is
[`songvarslookup`](https://alexmitrani.github.io/Repeatr/reference/songvarslookup.md)
alone, joined by `song` title text where needed.

## Examples

``` r
songidlookup
#> # A tibble: 92 × 3
#>    songid song                 count
#>     <int> <chr>                <int>
#>  1      1 23 beats off            27
#>  2      2 and the same           397
#>  3      3 argument                76
#>  4      4 arpeggiator            163
#>  5      5 back to base           142
#>  6      6 bad mouth              312
#>  7      7 bed for the scraping   310
#>  8      8 birthday pony          203
#>  9      9 blueprint              608
#> 10     10 break                  179
#> # ℹ 82 more rows
```
