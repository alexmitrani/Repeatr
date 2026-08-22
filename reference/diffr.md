# Tests whether differences between pairs of model parameters are significant or not.

The function finds the standard error of the difference between the two
coefficients in terms of their variances and their covariance: myse \<-
(sqrt(myvar1 + myvar2 - 2\*mycov))

It then proceeds to calculate a z-statistic: myz \<- (mycoefdiff)/myse

A z-statistic of 1.96 or greater would indicate that the difference
between the coefficients is significant at the 95% level of confidence.

The index numbers are based on the model coefficient table that comes
straight out of the model, with no sorting.

The function will return a one-row dataframe with the following columns:
var1, var2, coefindex1, coefindex2, mycoef1, mycoef2, mycoefdiff, myz,
myp, lower95ci, upper95ci

A coefficient index of 0 will be interpreted as referring to the omitted
constant, labeled "(Intercept):1" below. This is always correct, not a
hardcoded assumption about which song is omitted:
[`Repeatr_2()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md)
builds `alt` as a dense 1..n index (`row_number()`), so `as.factor(alt)`
in
[`Repeatr_4()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_4.md)
always has 1 as its lowest level, and mlogit always drops the lowest
level as the reference - whichever song that numerically is.

## Usage

``` r
diffr(coeftable = NULL, vcovmat = NULL, coefindex1 = NULL, coefindex2 = NULL)
```

## Arguments

- coeftable:

  coefficients table from mlogit, with one row per coefficient

- vcovmat:

  variance covariance matrix from mlogit, with one row and one column
  per coefficient

- coefindex1:

  index number of first coefficient to be tested

- coefindex2:

  index number of second coefficient to be tested

## Value

A one-row data frame with columns `var1`, `var2`, `coefindex1`,
`coefindex2`, `mycoef1`, `mycoef2`, `mycoefdiff`, `myz`, `myp`,
`lower95ci`, `upper95ci`, giving the z-test of the difference between
the two specified coefficients.

## Examples

``` r
mytest <- diffr(coeftable = results_ml_Repeatr4, vcovmat = vcovmat_ml_Repeatr4,
                 coefindex1 = 1, coefindex2 = 2)
#> 
#>  
#> First coefficient: 2.53141417247347 
#>  
#> Second coefficient: 2.70962457612322 
#>  
#> Difference to be tested: -0.178210403649746 
#>  
#> Variance of the first coefficient: 0.0434251826455706 
#>  
#> Variance of the second coefficient: 0.0566868791184421 
#>  
#> Covariance of the two coefficients: 0.0326788510176007 
#>  
#> Z-statistic: -0.955935099041361 
#>  
#> P-statistic: 0.339105024831357 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: -0.543603819482875 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: 0.187183012183382 
#>  
#> 
```
