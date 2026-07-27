# Estimated coefficients and related statistics from the model ml.Repeatr4

Basic choice model

## Usage

``` r
results_ml_Repeatr4
```

## Format

dataframe with one row for each coefficient in the model.

- Estimate:

  The coefficient value

- Std. Error:

  The standard error of the coefficient

- z-value:

  The z-value of the coefficient

- Pr(\>\|z\|):

  The P value of the coefficient

## Details

This model was estimated with mlogit on all of the data.

The utility formula was as follows:

choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 +
yearsold_5 + yearsold_6 + yearsold_7 + yearsold_8 + song2 + ... + song92

## Examples

``` r
results_ml_Repeatr4
#>              Estimate Std. Error    z-value     Pr(>|z|)
#> yearsold_1  0.1903361 0.02587634   7.355605 1.900702e-13
#> yearsold_2 -0.2152485 0.02679963  -8.031772 8.881784e-16
#> yearsold_3 -0.4219570 0.02911149 -14.494517 0.000000e+00
#> yearsold_4 -0.7941751 0.03243460 -24.485432 0.000000e+00
#> yearsold_5 -0.9140304 0.03808157 -24.001908 0.000000e+00
#> yearsold_6 -1.0550251 0.03961634 -26.631058 0.000000e+00
#> yearsold_7 -1.2654153 0.04465737 -28.336089 0.000000e+00
#> yearsold_8 -1.2295809 0.03245618 -37.884342 0.000000e+00
```
