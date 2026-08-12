# Fugazi alt id lookup table (choice-model alternative index)

Fugazi alt id lookup table (choice-model alternative index)

## Usage

``` r
altlookup
```

## Format

dataframe with one row for each song meeting `min_song_count` in
[`Repeatr_2`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md) -
i.e. every song that competes as a `mlogit` alternative.

- alt:

  Dense 1..n index over the `min_song_count`-eligible songs, in `songid`
  order. The alternative-specific index
  `mlogit`/[`Repeatr_4`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_4.md)
  actually sees - not the same as `songid`, which spans every classified
  song.

- songid:

  The stable, full song identity from
  [`songidlookup`](https://alexmitrani.github.io/Repeatr/reference/songidlookup.md).

- title:

  The name of the song

- count:

  The number of times the song was performed according to the data

## Provenance

Derived-modeled. Computed live in
[`Repeatr_2`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md);
the translation table between `alt` (what the choice model sees) and
`songid`/`title` (stable identity) used by
[`Repeatr_5`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md)
and [`rankr`](https://alexmitrani.github.io/Repeatr/reference/rankr.md).

## Examples

``` r
altlookup
#> # A tibble: 92 × 4
#>      alt songid title                count
#>    <int>  <int> <chr>                <int>
#>  1     1      1 23 beats off            27
#>  2     2      2 and the same           397
#>  3     3      3 argument                76
#>  4     4      4 arpeggiator            163
#>  5     5      5 back to base           142
#>  6     6      6 bad mouth              312
#>  7     7      7 bed for the scraping   310
#>  8     8      8 birthday pony          203
#>  9     9      9 blueprint              608
#> 10    10     10 break                  179
#> # ℹ 82 more rows
```
