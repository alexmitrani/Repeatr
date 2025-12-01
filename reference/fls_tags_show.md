# Tags data, one record per show

Tags data, one record per show

## Usage

``` r
fls_tags_show
```

## Format

dataframe with one row for each show in the Fugazi Live Series data,
including data from the audio file tags.

- date:

  date

- venue:

  venue

- city:

  city

- state:

  state for USA shows

- country:

  country

- album:

  album name, which includes the date, venue, city, state, and country

- gid:

  show id

- duration:

  duration in period format (lubridate)

- seconds:

  duration in seconds

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
  fls_tags_show
#> # A tibble: 899 × 9
#>    date       venue             city  state country album gid   duration seconds
#>    <date>     <chr>             <chr> <chr> <chr>   <chr> <chr> <Period>   <dbl>
#>  1 1987-09-03 Wilson Center     Wash… DC    USA     1987… wash… 31M 58S     1918
#>  2 1987-09-26 St. Stephen's Ch… Wash… DC    USA     1987… wash… 36M 38S     2198
#>  3 1987-10-07 New Horizons      Rich… VA    USA     1987… rich… 46M 6S      2766
#>  4 1987-10-16 dc space          Wash… DC    USA     1987… wash… 37M 9S      2229
#>  5 1987-11-25 Weinberg Center   Fred… MD    USA     1987… fred… 43M 29S     2609
#>  6 1987-12-03 Wilson Center     Wash… DC    USA     1987… wash… 54M 22S     3262
#>  7 1987-12-05 Anthrax           Norw… CT    USA     1987… norw… 46M 26S     2786
#>  8 1987-12-28 dc space          Wash… DC    USA     1987… wash… 55M 43S     3343
#>  9 1988-01-21 Fallout Shelter   Capi… MI    USA     1988… flin… 52M 22S     3142
#> 10 1988-01-22 Eastern Michigan… Ypsi… MI    USA     1988… ypsi… 50M 57S     3057
#> # ℹ 889 more rows
```
