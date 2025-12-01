# Last Performance Data

Last Performance Data

## Usage

``` r
last_performance_data
```

## Format

dataframe with one row for each song that was performed at least twice
in the Fugazi Live Series data.

- song:

  name of the song

- last_performance:

  date of the last performance.

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
  last_performance_data
#> # A tibble: 94 × 2
#>    song                 last_performance
#>    <chr>                <date>          
#>  1 23 beats off         1996-04-07      
#>  2 and the same         2002-10-29      
#>  3 argument             2002-10-31      
#>  4 arpeggiator          2002-11-04      
#>  5 back to base         2002-10-31      
#>  6 bad mouth            2002-10-30      
#>  7 bed for the scraping 2002-10-31      
#>  8 birthday pony        2002-11-04      
#>  9 blueprint            2002-11-04      
#> 10 break                2002-11-01      
#> # ℹ 84 more rows
```
