# Fugazi song performance intensity data

Fugazi song performance intensity data

## Usage

``` r
fugazi_song_performance_intensity
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

- chosen:

  The number of times the song was performed according to the data

- available_rl:

  The number of shows for which the song was available in the band's
  repertoire

- intensity:

  The performance intensity is the ratio of chosen/available_rl

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
  fugazi_song_performance_intensity
#> # A tibble: 94 × 6
#>    songid song                 launchdate chosen available_rl intensity
#>     <dbl> <chr>                <date>      <dbl>        <dbl>     <dbl>
#>  1     17 cashout              2000-09-30     62           66     0.939
#>  2     20 closed captioned     1997-06-18    159          199     0.799
#>  3      7 bed for the scraping 1994-11-20    299          377     0.793
#>  4     59 number 5             1998-11-21    110          145     0.759
#>  5     10 break                1996-08-15    172          229     0.751
#>  6     69 reclamation          1990-05-05    594          795     0.747
#>  7      4 arpeggiator          1997-05-02    154          208     0.740
#>  8     23 do you like me       1994-11-20    272          377     0.721
#>  9      9 blueprint            1989-11-25    584          826     0.707
#> 10     92 waiting room         1987-09-03    633          900     0.703
#> # ℹ 84 more rows
```
