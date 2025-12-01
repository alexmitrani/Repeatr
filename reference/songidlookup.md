# Fugazi song id lookup table

Fugazi song id lookup table

## Usage

``` r
songidlookup
```

## Format

dataframe with one row for each song in the Fugazi discography, except
those which never appear in the Fugazi Live Series data.

- songid:

  numeric id for each song, based on the alphabetical order of the song
  names.

- song:

  The name of the song

## Examples

``` r
  songidlookup
#> # A tibble: 94 × 2
#>    songid song                
#>     <int> <chr>               
#>  1      1 23 beats off        
#>  2      2 and the same        
#>  3      3 argument            
#>  4      4 arpeggiator         
#>  5      5 back to base        
#>  6      6 bad mouth           
#>  7      7 bed for the scraping
#>  8      8 birthday pony       
#>  9      9 blueprint           
#> 10     10 break               
#> # ℹ 84 more rows
```
