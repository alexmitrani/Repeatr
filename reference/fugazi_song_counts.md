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

## Examples

``` r
  fugazi_song_counts
#> # A tibble: 94 × 4
#>    songid song                 launchdate count
#>     <dbl> <chr>                <date>     <int>
#>  1      1 23 beats off         1992-10-23    26
#>  2      2 and the same         1987-09-26   376
#>  3      3 argument             1999-08-26    66
#>  4      4 arpeggiator          1997-05-02   154
#>  5      5 back to base         1994-11-20   136
#>  6      6 bad mouth            1987-10-16   280
#>  7      7 bed for the scraping 1994-11-20   299
#>  8      8 birthday pony        1994-08-15   199
#>  9      9 blueprint            1989-11-25   584
#> 10     10 break                1996-08-15   172
#> # ℹ 84 more rows
```
