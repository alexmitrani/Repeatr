# Undertakes paired comparisons for ranking a set of coefficients, considering whether the differences between the coefficients are significant or not.

The index numbers are based on the model coefficient table that comes
straight out of the model, with no sorting.

The function will return a dataframe with the results for each pair of
coeeficients tested.

## Usage

``` r
rankr(coeftable = NULL, vcovmat = NULL, mysongidlist = NULL)
```

## Arguments

- coeftable:

  coefficients table from mlogit, with one row per coefficient

- vcovmat:

  variance covariance matrix from mlogit, with one row and one column
  per coefficient

- mysongidlist:

  a dataframe containing the list of song ids to be tested. It can
  contain other variables but only songid will be used.

## Value

A data frame with one row per adjacent pair of songs tested, giving
`song1`, `song2`, their coefficients (`mycoef1`, `mycoef2`), the
coefficient difference and its z-statistic, p-value and 95% confidence
interval (as produced by
[`diffr()`](https://alexmitrani.github.io/Repeatr/reference/diffr.md)).

## Details

rankr

## Examples

``` r
songstobecompared <- summary %>% slice(seq(from=1, to=92, by=10))
mycomparisons <- rankr(coeftable = results_ml_Repeatr4, vcovmat = vcovmat_ml_Repeatr4, mysongidlist = songstobecompared)
#> 
#>  
#> First coefficient: NA 
#>  
#> Second coefficient: NA 
#>  
#> Difference to be tested: NA 
#>  
#> Variance of the first coefficient: 0.00453742924223042 
#>  
#> Variance of the second coefficient: 0.00855050607579515 
#>  
#> Covariance of the two coefficients: 0.00184567407828399 
#>  
#> Z-statistic: NA 
#>  
#> P-statistic: NA 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: NA 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: NA 
#>  
#> 
#>  
#> First coefficient: NA 
#>  
#> Second coefficient: NA 
#>  
#> Difference to be tested: NA 
#>  
#> Variance of the first coefficient: 0.00855050607579515 
#>  
#> Variance of the second coefficient: 0.0236674697358574 
#>  
#> Covariance of the two coefficients: 0.00370389077326437 
#>  
#> Z-statistic: NA 
#>  
#> P-statistic: NA 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: NA 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: NA 
#>  
#> 
#>  
#> First coefficient: NA 
#>  
#> Second coefficient: -1.0550251349753 
#>  
#> Difference to be tested: NA 
#>  
#> Variance of the first coefficient: 0.0236674697358574 
#>  
#> Variance of the second coefficient: 0.00453255097738979 
#>  
#> Covariance of the two coefficients: 0.0036794376800882 
#>  
#> Z-statistic: NA 
#>  
#> P-statistic: NA 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: NA 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: NA 
#>  
#> 
#>  
#> First coefficient: -1.0550251349753 
#>  
#> Second coefficient: NA 
#>  
#> Difference to be tested: NA 
#>  
#> Variance of the first coefficient: 0.00453255097738979 
#>  
#> Variance of the second coefficient: 0.0046368645007149 
#>  
#> Covariance of the two coefficients: 0.00196996762434043 
#>  
#> Z-statistic: NA 
#>  
#> P-statistic: NA 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: NA 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: NA 
#>  
#> 
#>  
#> First coefficient: NA 
#>  
#> Second coefficient: NA 
#>  
#> Difference to be tested: NA 
#>  
#> Variance of the first coefficient: 0.0046368645007149 
#>  
#> Variance of the second coefficient: 0.0192717930043312 
#>  
#> Covariance of the two coefficients: 0.00298093290655243 
#>  
#> Z-statistic: NA 
#>  
#> P-statistic: NA 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: NA 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: NA 
#>  
#> 
#>  
#> First coefficient: NA 
#>  
#> Second coefficient: NA 
#>  
#> Difference to be tested: NA 
#>  
#> Variance of the first coefficient: 0.0192717930043312 
#>  
#> Variance of the second coefficient: 0.0144238577046019 
#>  
#> Covariance of the two coefficients: 0.00983982772986972 
#>  
#> Z-statistic: NA 
#>  
#> P-statistic: NA 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: NA 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: NA 
#>  
#> 
#>  
#> First coefficient: NA 
#>  
#> Second coefficient: NA 
#>  
#> Difference to be tested: NA 
#>  
#> Variance of the first coefficient: 0.0144238577046019 
#>  
#> Variance of the second coefficient: 0.0433360457412497 
#>  
#> Covariance of the two coefficients: 0.0150482705176275 
#>  
#> Z-statistic: NA 
#>  
#> P-statistic: NA 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: NA 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: NA 
#>  
#> 
#>  
#> First coefficient: NA 
#>  
#> Second coefficient: NA 
#>  
#> Difference to be tested: NA 
#>  
#> Variance of the first coefficient: 0.0433360457412497 
#>  
#> Variance of the second coefficient: 0.0494846260902958 
#>  
#> Covariance of the two coefficients: 0.0219604946383592 
#>  
#> Z-statistic: NA 
#>  
#> P-statistic: NA 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: NA 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: NA 
#>  
#> 
#>  
#> First coefficient: NA 
#>  
#> Second coefficient: NA 
#>  
#> Difference to be tested: NA 
#>  
#> Variance of the first coefficient: 0.0494846260902958 
#>  
#> Variance of the second coefficient: 0.0804502488495918 
#>  
#> Covariance of the two coefficients: 0.022641593498318 
#>  
#> Z-statistic: NA 
#>  
#> P-statistic: NA 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: NA 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: NA 
#>  
#> 
#> Joining with `by = join_by(songid1)`
#> Joining with `by = join_by(songid2)`
mycomparisons
#>       song1     song2   mycoef1   mycoef2 mycoefdiff myz myp lower95ci
#> 1      <NA>      <NA>        NA        NA         NA  NA  NA        NA
#> 2      <NA>      <NA>        NA        NA         NA  NA  NA        NA
#> 3      <NA> bad mouth        NA -1.055025         NA  NA  NA        NA
#> 4 bad mouth      <NA> -1.055025        NA         NA  NA  NA        NA
#> 5      <NA>      <NA>        NA        NA         NA  NA  NA        NA
#> 6      <NA>      <NA>        NA        NA         NA  NA  NA        NA
#> 7      <NA>      <NA>        NA        NA         NA  NA  NA        NA
#> 8      <NA>      <NA>        NA        NA         NA  NA  NA        NA
#> 9      <NA>      <NA>        NA        NA         NA  NA  NA        NA
#>   upper95ci
#> 1        NA
#> 2        NA
#> 3        NA
#> 4        NA
#> 5        NA
#> 6        NA
#> 7        NA
#> 8        NA
#> 9        NA
```
