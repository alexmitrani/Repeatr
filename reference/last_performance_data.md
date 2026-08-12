# Last Performance Data

Last Performance Data

## Usage

``` r
last_performance_data
```

## Format

dataframe with one row for each song that was performed at least twice
in the Fugazi Live Series data.

- title:

  name of the song

- last_performance:

  date of the last performance.

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-cleaned. Produced by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md).

## Examples

``` r
last_performance_data
#> # A tibble: 92 × 2
#>    title                last_performance
#>    <chr>                <date>          
#>  1 23 beats off         1996-04-07      
#>  2 and the same         2002-11-02      
#>  3 argument             2002-11-03      
#>  4 arpeggiator          2002-11-04      
#>  5 back to base         2002-11-03      
#>  6 bad mouth            2002-11-03      
#>  7 bed for the scraping 2002-11-02      
#>  8 birthday pony        2002-11-04      
#>  9 blueprint            2002-11-04      
#> 10 break                2002-11-03      
#> # ℹ 82 more rows
```
