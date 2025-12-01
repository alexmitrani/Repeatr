# Fugazi Live Series data on bands that fugazi played with in long format

Fugazi Live Series data on bands that fugazi played with in long format

## Usage

``` r
played_with
```

## Format

dataframe with one row for show and each band that Fugazi played with in
the Fugazi Live Series shows with data.

- gid:

  gig id. This is a concatenation of city, country, and date

- fls_id:

  Fugazi Live Series ID

- played_with:

  Band name

## Source

https://www.dischord.com/fugazi_live_series

https://arquivomotor.wordpress.com/1994/08/12/bhrif-programacao/

## Examples

``` r
  played_with
#> # A tibble: 1,670 × 3
#>    gid                      fls_id  played_with     
#>    <chr>                    <chr>   <chr>           
#>  1 washington-dc-usa-90387  FLS0001 Fire Party      
#>  2 washington-dc-usa-90387  FLS0001 Ignition        
#>  3 washington-dc-usa-90387  FLS0001 Marginal Man    
#>  4 washington-dc-usa-92687  FLS0002 Darkness at Noon
#>  5 washington-dc-usa-92687  FLS0002 Sarcastic Orgasm
#>  6 washington-dc-usa-92687  FLS0002 Swiz            
#>  7 chapel-hill-nc-usa-92787 FLS0003 Days Of         
#>  8 chapel-hill-nc-usa-92787 FLS0003 Slush Puppies   
#>  9 richmond-va-usa-100787   FLS0004 Killjoy         
#> 10 richmond-va-usa-100787   FLS0004 Oi Polloi       
#> # ℹ 1,660 more rows
```
