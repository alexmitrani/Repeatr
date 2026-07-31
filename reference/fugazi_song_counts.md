# Fugazi song performance counts

Fugazi song performance counts

## Usage

``` r
fugazi_song_counts
```

## Format

dataframe with one row for each song in the Fugazi discography, except
those which never appear in the Fugazi Live Series data.

- songid:

  numeric id for each song

- song:

  The name of the song

- launchdate:

  The date on which the song was first performed according to the data

- count:

  The number of times the song was performed according to the data

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-modeled. Produced by
[`Repeatr_2`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md),
but covers every classified song, not just the `min_song_count`-eligible
subset used to build `alt` - one-off performances and rarities appear
here too.

## Examples

``` r
fugazi_song_counts
#> # A tibble: 92 × 4
#>    songid song                 launchdate count
#>     <int> <chr>                <date>     <int>
#>  1      1 23 beats off         1992-10-23    27
#>  2      2 and the same         1987-09-26   397
#>  3      3 argument             1999-08-26    76
#>  4      4 arpeggiator          1997-05-02   163
#>  5      5 back to base         1994-11-20   142
#>  6      6 bad mouth            1987-10-16   312
#>  7      7 bed for the scraping 1994-11-20   310
#>  8      8 birthday pony        1994-08-15   203
#>  9      9 blueprint            1989-09-23   608
#> 10     10 break                1996-08-15   179
#> # ℹ 82 more rows
```
