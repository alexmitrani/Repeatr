# Undertakes paired comparisons for ranking a set of coefficients, considering whether the differences between the coefficients are significant or not.

The index numbers are based on the model coefficient table that comes
straight out of the model, with no sorting.

The function will return a dataframe with the results for each pair of
coeeficients tested.

## Usage

``` r
rankr(
  coeftable = NULL,
  vcovmat = NULL,
  mysongidlist = NULL,
  myaltlookup = NULL
)
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

- myaltlookup:

  optional `altlookup` dataframe (the second element of
  [`Repeatr_2()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md)'s
  return list) used to translate `mysongidlist`'s `songid` values into
  `coeftable`'s `alt`-indexed rows, and to attach song names to the
  results - `songid` and `alt` are different scales (`songid` spans
  every classified song, `alt` only the `min_song_count`-eligible ones
  actually fit by the model), so this translation is required, not
  optional bookkeeping. If omitted the currently lazy-loaded default
  will be used. Songs in `mysongidlist` that aren't in `altlookup` (i.e.
  below `min_song_count`) are dropped with a warning, since they have no
  coefficient to compare.

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
#> First coefficient: 3.15160717544381 
#>  
#> Second coefficient: 1.1804771823996 
#>  
#> Difference to be tested: 1.97112999304421 
#>  
#> Variance of the first coefficient: 0.0424198483543461 
#>  
#> Variance of the second coefficient: 0.14101846094101 
#>  
#> Covariance of the two coefficients: 0.0397520462780542 
#>  
#> Z-statistic: 6.11414863943603 
#>  
#> P-statistic: 1.99999999902926 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: 1.33924892272679 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: 2.60301106336164 
#>  
#> 
#>  
#> First coefficient: 1.1804771823996 
#>  
#> Second coefficient: 2.99125045503584 
#>  
#> Difference to be tested: -1.81077327263624 
#>  
#> Variance of the first coefficient: 0.14101846094101 
#>  
#> Variance of the second coefficient: 0.0402153553683423 
#>  
#> Covariance of the two coefficients: 0.0387413994726352 
#>  
#> Z-statistic: -5.62170294705247 
#>  
#> P-statistic: 1.8908419439589e-08 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: -2.44209720557863 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: -1.17944933969384 
#>  
#> 
#>  
#> First coefficient: 2.99125045503584 
#>  
#> Second coefficient: 1.55497313773894 
#>  
#> Difference to be tested: 1.43627731729689 
#>  
#> Variance of the first coefficient: 0.0402153553683423 
#>  
#> Variance of the second coefficient: 0.0440670936195828 
#>  
#> Covariance of the two coefficients: 0.0379532956637188 
#>  
#> Z-statistic: 15.6936389764983 
#>  
#> P-statistic: 2 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: 1.25689868203469 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: 1.61565595255909 
#>  
#> 
#>  
#> First coefficient: 1.55497313773894 
#>  
#> Second coefficient: 1.7709465185483 
#>  
#> Difference to be tested: -0.215973380809354 
#>  
#> Variance of the first coefficient: 0.0440670936195828 
#>  
#> Variance of the second coefficient: 0.0443255740862942 
#>  
#> Covariance of the two coefficients: 0.037049365818188 
#>  
#> Z-statistic: -1.80644319347025 
#>  
#> P-statistic: 0.0708491398455441 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: -0.45030559115312 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: 0.0183588295344116 
#>  
#> 
#>  
#> First coefficient: 1.7709465185483 
#>  
#> Second coefficient: 3.43463368962312 
#>  
#> Difference to be tested: -1.66368717107483 
#>  
#> Variance of the first coefficient: 0.0443255740862942 
#>  
#> Variance of the second coefficient: 0.0416408587411747 
#>  
#> Covariance of the two coefficients: 0.0370539702928315 
#>  
#> Z-statistic: -15.2776631703945 
#>  
#> P-statistic: 1.07735208464099e-52 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: -1.87712471181244 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: -1.45024963033721 
#>  
#> 
#>  
#> First coefficient: 3.43463368962312 
#>  
#> Second coefficient: 2.19875828310069 
#>  
#> Difference to be tested: 1.23587540652243 
#>  
#> Variance of the first coefficient: 0.0416408587411747 
#>  
#> Variance of the second coefficient: 0.0450744117590485 
#>  
#> Covariance of the two coefficients: 0.0379531307884917 
#>  
#> Z-statistic: 11.8872597418323 
#>  
#> P-statistic: 2 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: 1.03210129462517 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: 1.43964951841969 
#>  
#> 
#>  
#> First coefficient: 2.19875828310069 
#>  
#> Second coefficient: 2.45670420855044 
#>  
#> Difference to be tested: -0.257945925449744 
#>  
#> Variance of the first coefficient: 0.0450744117590485 
#>  
#> Variance of the second coefficient: 0.0491032660733902 
#>  
#> Covariance of the two coefficients: 0.0385323434380715 
#>  
#> Z-statistic: -1.9718129369467 
#>  
#> P-statistic: 0.0486309649554755 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: -0.514346522285449 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: -0.00154532861403855 
#>  
#> 
#>  
#> First coefficient: 2.45670420855044 
#>  
#> Second coefficient: 2.61508600037117 
#>  
#> Difference to be tested: -0.158381791820735 
#>  
#> Variance of the first coefficient: 0.0491032660733902 
#>  
#> Variance of the second coefficient: 0.0735540408379587 
#>  
#> Covariance of the two coefficients: 0.041617793563402 
#>  
#> Z-statistic: -0.797696099838669 
#>  
#> P-statistic: 0.425046867706681 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: -0.547537902815163 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: 0.230774319173694 
#>  
#> 
#>  
#> First coefficient: 2.61508600037117 
#>  
#> Second coefficient: -1.02160744461325 
#>  
#> Difference to be tested: 3.63669344498442 
#>  
#> Variance of the first coefficient: 0.0735540408379587 
#>  
#> Variance of the second coefficient: 0.0997223633400827 
#>  
#> Covariance of the two coefficients: 0.0317249024098666 
#>  
#> Z-statistic: 10.9736960151414 
#>  
#> P-statistic: 2 
#>  
#> Lower boundary of 95% confidence interval of the difference between the two coefficients: 2.9871475543078 
#>  
#> Upper boundary of 95% confidence interval of the difference between the two coefficients: 4.28623933566103 
#>  
#> 
#> Joining with `by = join_by(alt1)`
#> Joining with `by = join_by(alt2)`
mycomparisons
#>                 song1               song2  mycoef1   mycoef2 mycoefdiff
#> 1        waiting room         provisional 3.151607  1.180477  1.9711300
#> 2         provisional           blueprint 1.180477  2.991250 -1.8107733
#> 3           blueprint              stacks 2.991250  1.554973  1.4362773
#> 4              stacks returning the screw 1.554973  1.770947 -0.2159734
#> 5 returning the screw      do you like me 1.770947  3.434634 -1.6636872
#> 6      do you like me        back to base 3.434634  2.198758  1.2358754
#> 7        back to base        floating boy 2.198758  2.456704 -0.2579459
#> 8        floating boy            the kill 2.456704  2.615086 -0.1583818
#> 9            the kill  turn off your guns 2.615086 -1.021607  3.6366934
#>           myz          myp  lower95ci    upper95ci
#> 1   6.1141486 2.000000e+00  1.3392489  2.603011063
#> 2  -5.6217029 1.890842e-08 -2.4420972 -1.179449340
#> 3  15.6936390 2.000000e+00  1.2568987  1.615655953
#> 4  -1.8064432 7.084914e-02 -0.4503056  0.018358830
#> 5 -15.2776632 1.077352e-52 -1.8771247 -1.450249630
#> 6  11.8872597 2.000000e+00  1.0321013  1.439649518
#> 7  -1.9718129 4.863096e-02 -0.5143465 -0.001545329
#> 8  -0.7976961 4.250469e-01 -0.5475379  0.230774319
#> 9  10.9736960 2.000000e+00  2.9871476  4.286239336
```
