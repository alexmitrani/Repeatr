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
constant.

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

## Examples

``` r
mytest <- diffr(coeftable = results_ml_Repeatr4, vcovmat = vcovmat_ml_Repeatr4, coefindex1 = 1, coefindex2 = 2)
#> 
#>  
#> First coefficient: 2.54493169309144 
#>  
#> Second coefficient: 2.70186219139716 
#>  
#> Difference to be tested: -0.156930498305724 
#>  
#> Variance of the first coefficient: 0.00443420102574495 
#>  
#> Variance of the second coefficient: 0.00425815529488678 
#>  
#> Covariance of the two coefficients: 0.00256233487451444 
#>  
#> Z-statistic: -2.62732626187157 
#>  
#> P-statistic: 0.00860587760402746 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: -0.27400152261776 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: -0.0398594739936872 
#>  
#> 
```
