# Fugazi song choice model results, with song names substituted in for intercept terms

Produced by
[`Repeatr_5`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md)
from
[`results_ml_Repeatr4`](https://alexmitrani.github.io/Repeatr/reference/results_ml_Repeatr4.md):
the raw model `variable` names for the per-song intercept terms (e.g.
`(Intercept):5`) are replaced with the corresponding song name, using
[`songidlookup`](https://alexmitrani.github.io/Repeatr/reference/songidlookup.md).

## Usage

``` r
fugazi_song_choice_model
```

## Format

dataframe with one row for each coefficient in the model.

- variable:

  The name of the model covariate, or the song name for intercept terms

- Estimate:

  The coefficient value

- Std. Error:

  The standard error of the coefficient

- z-value:

  The z-value of the coefficient

- Pr(\>\|z\|):

  The P value of the coefficient

## Examples

``` r
fugazi_song_choice_model
#>     variable   Estimate Std. Error    z-value     Pr(>|z|)
#> 1 yearsold_1  0.1903361 0.02587634   7.355605 1.900702e-13
#> 2 yearsold_2 -0.2152485 0.02679963  -8.031772 8.881784e-16
#> 3 yearsold_3 -0.4219570 0.02911149 -14.494517 0.000000e+00
#> 4 yearsold_4 -0.7941751 0.03243460 -24.485432 0.000000e+00
#> 5 yearsold_5 -0.9140304 0.03808157 -24.001908 0.000000e+00
#> 6 yearsold_6 -1.0550251 0.03961634 -26.631058 0.000000e+00
#> 7 yearsold_7 -1.2654153 0.04465737 -28.336089 0.000000e+00
#> 8 yearsold_8 -1.2295809 0.03245618 -37.884342 0.000000e+00
```
