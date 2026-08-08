# prepares data for choice modelling with mlogit, and estimates a basic choice model.

Defines indices, makes changes to variable formats and data structure to
prepare for choice modelling with mlogit.

## Usage

``` r
Repeatr_4(mydf = NULL, output_dir = NULL)
```

## Arguments

- mydf:

  optional dataframe to be used. If omitted, the default dataframe will
  be used. Example of use: ml_Repeatr4 \<- Repeatr_4()

- output_dir:

  Optional directory to save the rebuilt
  `data/results_ml_Repeatr4.rda`/`data/vcovmat_ml_Repeatr4.rda` into. If
  omitted, defaults to `data/` under the current working directory.

## Value

A data frame (`results_ml_Repeatr4`) of the mlogit coefficient table:
one row per model covariate, with columns for the estimate, standard
error, z-value and p-value. Also saved to
`data/results_ml_Repeatr4.rda`, alongside the corresponding
`vcovmat_ml_Repeatr4.rda` (needed by
[`diffr`](https://alexmitrani.github.io/Repeatr/reference/diffr.md)/[`rankr`](https://alexmitrani.github.io/Repeatr/reference/rankr.md)) -
both are always written together by this function so they can never go
out of sync with each other.

## Examples

``` r
if (FALSE) { # \dontrun{
# Fits a real mlogit choice model on the full dataset - the slow step
# in the pipeline (see vignette("Rebuilding-the-Data")), not run here.
results_ml_Repeatr4 <- Repeatr_4(output_dir = tempdir())
} # }
```
