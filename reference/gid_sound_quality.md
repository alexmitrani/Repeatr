# Sound quality data, one record per show

Sound quality data, one record per show

## Usage

``` r
gid_sound_quality
```

## Format

dataframe with one row for each show in the Fugazi Live Series data.

- gid:

  show id

- sound_quality:

  Sound quality rating: Excellent, Very Good, Good, or Poor.

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
  gid_sound_quality
#> # A tibble: 898 × 2
#>    gid                                            sound_quality
#>    <chr>                                          <chr>        
#>  1 washington-dc-usa-90387                        Good         
#>  2 washington-dc-usa-92687                        Very Good    
#>  3 richmond-va-usa-100787                         Very Good    
#>  4 washington-dc-usa-101687                       Good         
#>  5 frederick-md-usa-112587                        Good         
#>  6 washington-dc-usa-120387                       Good         
#>  7 norwalk-ct-usa-120587                          Good         
#>  8 washington-dc-usa-122887                       Very Good    
#>  9 flint-mi-usa-12188                             Poor         
#> 10 ypsilanti-mi-eastern-michigan-university-12288 Poor         
#> # ℹ 888 more rows
```
