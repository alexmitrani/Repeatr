# Fugazi song preferences, ranked by estimated intercept (implied preference)

Produced by
[`Repeatr_5`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md)
from the per-song intercept terms of
[`results_ml_Repeatr4`](https://alexmitrani.github.io/Repeatr/reference/results_ml_Repeatr4.md)
(the omitted reference song, "23 Beats Off", is added back in with an
estimate of 0), ranked from most to least preferred.

## Usage

``` r
fugazi_song_preferences
```

## Format

dataframe with one row for each song, ranked by estimated preference.

- rank_rating:

  Rank of the song by estimated preference, 1 = most preferred

- songid:

  numeric id for each song

- song:

  The name of the song

- Estimate:

  The estimated intercept for this song (0 for the omitted reference
  song)

- z-value:

  The z-value of the estimate (NA for the omitted reference song)

## Examples

``` r
fugazi_song_preferences
#> # A tibble: 1 × 5
#>   rank_rating songid song         Estimate `z-value`
#>         <int>  <int> <chr>           <dbl> <lgl>    
#> 1           1      1 23 beats off        0 NA       
```
