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
#> # A tibble: 95 × 6
#>    songid song                 launchdate chosen available_rl intensity
#>     <dbl> <chr>                <date>      <dbl>        <dbl>     <dbl>
#>  1     17 cashout              2000-06-04     67           74     0.905
#>  2     20 closed captioned     1997-06-18    169          211     0.801
#>  3      7 bed for the scraping 1994-11-20    310          393     0.789
#>  4     59 number 5             1998-11-21    120          157     0.764
#>  5     70 reclamation          NA            612          820     0.746
#>  6      4 arpeggiator          1997-05-02    163          220     0.741
#>  7     10 break                1996-08-15    179          244     0.734
#>  8     23 do you like me       1994-11-20    282          393     0.718
#>  9     93 waiting room         NA            675          952     0.709
#> 10      9 blueprint            1989-09-23    608          873     0.696
#> # ℹ 85 more rows
```
