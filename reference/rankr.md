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

## Details

rankr

## Examples

``` r
songstobecompared <- summary %>% slice(seq(from=1, to=92, by=10))
mycomparisons <- rankr(coeftable = results_ml_Repeatr4, vcovmat = vcovmat_ml_Repeatr4, mysongidlist = songstobecompared)
#> 
#>  
#> First coefficient: 3.14790706395908 
#>  
#> Second coefficient: 0.521754023206018 
#>  
#> Difference to be tested: 2.62615304075306 
#>  
#> Variance of the first coefficient: 0.528235277021886 
#>  
#> Variance of the second coefficient: 0.0124891074988492 
#>  
#> Covariance of the two coefficients: 0.0016387992505919 
#>  
#> Z-statistic: 3.58222034598307 
#>  
#> P-statistic: 1.99965931375992 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: 1.18926210085097 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: 4.06304398065515 
#>  
#> 
#>  
#> First coefficient: 0.521754023206018 
#>  
#> Second coefficient: 3.01111204166612 
#>  
#> Difference to be tested: -2.4893580184601 
#>  
#> Variance of the first coefficient: 0.0124891074988492 
#>  
#> Variance of the second coefficient: 0.0046794363459201 
#>  
#> Covariance of the two coefficients: 0.00169180892121045 
#>  
#> Z-statistic: -21.2024057619051 
#>  
#> P-statistic: 9.07375333311069e-100 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: -2.71948009851897 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: -2.25923593840123 
#>  
#> 
#>  
#> First coefficient: 3.01111204166612 
#>  
#> Second coefficient: 1.56969954209443 
#>  
#> Difference to be tested: 1.44141249957169 
#>  
#> Variance of the first coefficient: 0.0046794363459201 
#>  
#> Variance of the second coefficient: 0.0494846260902958 
#>  
#> Covariance of the two coefficients: 0.00406706571721051 
#>  
#> Z-statistic: 6.71843503264215 
#>  
#> P-statistic: 1.99999999998163 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: 1.0209025913216 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: 1.86192240782177 
#>  
#> 
#>  
#> First coefficient: 1.56969954209443 
#>  
#> Second coefficient: 1.78112886293662 
#>  
#> Difference to be tested: -0.211429320842189 
#>  
#> Variance of the first coefficient: 0.0494846260902958 
#>  
#> Variance of the second coefficient: 0.0444326554597425 
#>  
#> Covariance of the two coefficients: 0.0206092237692128 
#>  
#> Z-statistic: -0.921010776051624 
#>  
#> P-statistic: 0.357044800962752 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: -0.661371362375331 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: 0.238512720690953 
#>  
#> 
#>  
#> First coefficient: 1.78112886293662 
#>  
#> Second coefficient: 3.44000072643505 
#>  
#> Difference to be tested: -1.65887186349843 
#>  
#> Variance of the first coefficient: 0.0444326554597425 
#>  
#> Variance of the second coefficient: 0.00569784656156396 
#>  
#> Covariance of the two coefficients: 0.00404870824434851 
#>  
#> Z-statistic: -8.09127953451885 
#>  
#> P-statistic: 5.90411812036592e-16 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: -2.06071051442947 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: -1.2570332125674 
#>  
#> 
#>  
#> First coefficient: 3.44000072643505 
#>  
#> Second coefficient: 2.20314013910345 
#>  
#> Difference to be tested: 1.2368605873316 
#>  
#> Variance of the first coefficient: 0.00569784656156396 
#>  
#> Variance of the second coefficient: 0.00389868718892827 
#>  
#> Covariance of the two coefficients: 0.0017020834387324 
#>  
#> Z-statistic: 15.7178236425456 
#>  
#> P-statistic: 2 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: 1.0826250642527 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: 1.3910961104105 
#>  
#> 
#>  
#> First coefficient: 2.20314013910345 
#>  
#> Second coefficient: 2.53811968424915 
#>  
#> Difference to be tested: -0.3349795451457 
#>  
#> Variance of the first coefficient: 0.00389868718892827 
#>  
#> Variance of the second coefficient: 0.0107625693703899 
#>  
#> Covariance of the two coefficients: 0.00171381562879152 
#>  
#> Z-statistic: -3.16051838932986 
#>  
#> P-statistic: 0.00157488663366669 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: -0.542717589228014 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: -0.127241501063385 
#>  
#> 
#>  
#> First coefficient: 2.53811968424915 
#>  
#> Second coefficient: 2.66794602353301 
#>  
#> Difference to be tested: -0.129826339283862 
#>  
#> Variance of the first coefficient: 0.0107625693703899 
#>  
#> Variance of the second coefficient: 0.057980060154878 
#>  
#> Covariance of the two coefficients: 0.00797617930683449 
#>  
#> Z-statistic: -0.565048681787777 
#>  
#> P-statistic: 0.572040652457022 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: -0.580158555246698 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: 0.320505876678974 
#>  
#> 
#>  
#> First coefficient: 2.66794602353301 
#>  
#> Second coefficient: -1.08800023700546 
#>  
#> Difference to be tested: 3.75594626053847 
#>  
#> Variance of the first coefficient: 0.057980060154878 
#>  
#> Variance of the second coefficient: 0.0804502488495918 
#>  
#> Covariance of the two coefficients: 0.0163387855450476 
#>  
#> Z-statistic: 11.5497759566453 
#>  
#> P-statistic: 2 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: 3.11856119798063 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: 4.39333132309631 
#>  
#> 
#> Joining with `by = join_by(songid1)`
#> Joining with `by = join_by(songid2)`
mycomparisons
#>                 song1               song2  mycoef1   mycoef2 mycoefdiff
#> 1        waiting room         provisional 3.147907  0.521754  2.6261530
#> 2         provisional           blueprint 0.521754  3.011112 -2.4893580
#> 3           blueprint              stacks 3.011112  1.569700  1.4414125
#> 4              stacks returning the screw 1.569700  1.781129 -0.2114293
#> 5 returning the screw      do you like me 1.781129  3.440001 -1.6588719
#> 6      do you like me        back to base 3.440001  2.203140  1.2368606
#> 7        back to base        floating boy 2.203140  2.538120 -0.3349795
#> 8        floating boy            the kill 2.538120  2.667946 -0.1298263
#> 9            the kill  turn off your guns 2.667946 -1.088000  3.7559463
#>           myz           myp  lower95ci  upper95ci
#> 1   3.5822203  1.999659e+00  1.1892621  4.0630440
#> 2 -21.2024058 9.073753e-100 -2.7194801 -2.2592359
#> 3   6.7184350  2.000000e+00  1.0209026  1.8619224
#> 4  -0.9210108  3.570448e-01 -0.6613714  0.2385127
#> 5  -8.0912795  5.904118e-16 -2.0607105 -1.2570332
#> 6  15.7178236  2.000000e+00  1.0826251  1.3910961
#> 7  -3.1605184  1.574887e-03 -0.5427176 -0.1272415
#> 8  -0.5650487  5.720407e-01 -0.5801586  0.3205059
#> 9  11.5497760  2.000000e+00  3.1185612  4.3933313
```
