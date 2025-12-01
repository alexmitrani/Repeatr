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

- song:

  Name of the song

- release:

  Name of the corresponding discographical release

- count:

  The cumulative count of the number of times the song had been
  performed up to and including this performance.

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
  cumulative_song_counts
#> # A tibble: 52,218 × 5
#>    date       song                 release    count releasedate
#>    <date>     <chr>                <chr>      <int> <chr>      
#>  1 1987-09-03 furniture            furniture      1 16/10/2001 
#>  2 1987-09-03 in defense of humans first demo     1 18/11/2014 
#>  3 1987-09-03 joe #1               3 songs        1 01/12/1989 
#>  4 1987-09-03 merchandise          repeater       1 01/03/1990 
#>  5 1987-09-03 song #1              3 songs        1 01/12/1989 
#>  6 1987-09-03 the word             first demo     1 18/11/2014 
#>  7 1987-09-03 turn off your guns   first demo     1 18/11/2014 
#>  8 1987-09-03 waiting room         fugazi         1 19/11/1988 
#>  9 1987-09-26 furniture            furniture      2 16/10/2001 
#> 10 1987-09-26 in defense of humans first demo     2 18/11/2014 
#> # ℹ 52,208 more rows
```
