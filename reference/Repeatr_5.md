# produces results using a coefficient table for a choice model estimated with mlogit.

Produces a summary table that includes song performance counts, song
performance intensities, and ratings based on the estimated choice model
parameters.

## Usage

``` r
Repeatr_5(mymodeldf = NULL)
```

## Arguments

- mymodeldf:

  optional choice model coefficients dataframe to be used to generate
  the results. If omitted, the default choice model coefficients
  dataframe will be used, which is results_ml_Repeatr4.

## Value

A list of 5 elements: `fugazi_song_choice_model` (per-variable
coefficient table with song names substituted in for the intercept
terms), `fugazi_song_preferences` (songs ranked by estimated
preference), `summary` (song performance summary combining counts,
intensity and rating), `releases_rated` (average rating by release), and
`releases_data_input` (per-song-per-release data enriched with the
estimated rating). Each of these, plus `releases_summary`, is also saved
into `data/`.

## Examples

``` r
Repeatr_5_results <- Repeatr_5(mymodeldf = results_ml_Repeatr4)
#> Joining with `by = join_by(songid)`
#> Error in setwd(myinputdir): cannot change working directory
```
