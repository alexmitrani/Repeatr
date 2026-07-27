# prepares data for choice modelling with mlogit, and estimates a basic choice model.

Defines indices, makes changes to variable formats and data structure to
prepare for choice modelling with mlogit.

## Usage

``` r
Repeatr_4(mydf = NULL)
```

## Arguments

- mydf:

  optional dataframe to be used. If omitted, the default dataframe will
  be used. Example of use: ml_Repeatr4 \<- Repeatr_4()

## Value

A data frame (`results_ml_Repeatr4`) of the mlogit coefficient table:
one row per model covariate, with columns for the estimate, standard
error, z-value and p-value. Also saved to
`data/results_ml_Repeatr4.rda`.

## Examples

``` r
results_ml_Repeatr4 <- Repeatr_4()
#> Error in setwd(mydatadir): cannot change working directory
```
