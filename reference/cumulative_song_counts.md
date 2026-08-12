# Cumulative Song Counts

Cumulative Song Counts

## Usage

``` r
cumulative_song_counts
```

## Format

dataframe with one row for each combination of song and date in the
Fugazi Live Series data.

- date:

  Date of the show

- title:

  Name of the song

- release_title:

  Name of the corresponding discographical release

- count:

  The cumulative count of the number of times the song had been
  performed up to and including this performance.

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-cleaned. Produced by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md).

## Examples

``` r
cumulative_song_counts
#> # A tibble: 53,665 × 5
#>    date       title                release_title count release_date
#>    <date>     <chr>                <chr>         <int> <date>      
#>  1 1987-09-03 furniture            furniture         1 2001-10-16  
#>  2 1987-09-03 in defense of humans first demo        1 2014-11-18  
#>  3 1987-09-03 joe #1               3 songs           1 1989-12-01  
#>  4 1987-09-03 merchandise          repeater          1 1990-03-01  
#>  5 1987-09-03 song #1              3 songs           1 1989-12-01  
#>  6 1987-09-03 the word             first demo        1 2014-11-18  
#>  7 1987-09-03 turn off your guns   first demo        1 2014-11-18  
#>  8 1987-09-03 waiting room         fugazi            1 1988-11-19  
#>  9 1987-09-26 furniture            furniture         2 2001-10-16  
#> 10 1987-09-26 in defense of humans first demo        2 2014-11-18  
#> # ℹ 53,655 more rows
```
