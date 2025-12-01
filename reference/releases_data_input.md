# Releases data input

Releases data input

## Usage

``` r
releases_data_input
```

## Format

dataframe with one row for each song in the Fugazi discography, except
those which never appear in the Fugazi Live Series data.

- releaseid:

  numeric id in ascending chronological order

- release:

  release name

- track_number:

  The track number for the song on the release

- song:

  The name of the song

- last_show:

  The number of the last show in the series

- colour_code:

  The hex colour code used for the corresponding release

- count:

  The number of times the song was performed according to the data

- date:

  The debut date of the song

- show_num:

  The show number of the debut of the song

- shows:

  The number of shows in which the song could have been performed

- intensity:

  The rate at which the song was played - this is count / shows

- rating:

  The rating calculated for the song based on preferences implied by the
  choices of which songs to play.

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
  releases_data_input
#> # A tibble: 94 × 12
#>    releaseid release   track_number song  last_show colour_code count date      
#>        <int> <fct>            <int> <fct>     <int> <chr>       <int> <date>    
#>  1        13 unreleas…            2 worl…       899 #e69f00         2 1996-01-30
#>  2        13 unreleas…            1 prep…       899 #e69f00         6 1988-10-31
#>  3        11 first de…           10 in d…       899 #adb56a        25 1987-09-03
#>  4        11 first de…            8 turn…       899 #adb56a        15 1987-09-03
#>  5        11 first de…            5 the …       899 #adb56a        31 1987-09-03
#>  6        10 furniture            3 hell…       899 #d15743         2 2001-04-27
#>  7        10 furniture            2 numb…       899 #d15743       110 1998-11-21
#>  8        10 furniture            1 furn…       899 #d15743        94 1987-09-03
#>  9         9 the argu…           11 argu…       899 #99c3cb        66 1999-08-26
#> 10         9 the argu…           10 nigh…       899 #99c3cb        44 1999-08-26
#> # ℹ 84 more rows
#> # ℹ 4 more variables: show_num <int>, shows <dbl>, intensity <dbl>,
#> #   rating <dbl>
```
