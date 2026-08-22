# `releases_data_input` enriched with tempo (BPM) and duration

`releases_data_input` enriched with tempo (BPM) and duration

## Usage

``` r
shiny_releases_data_input
```

## Format

dataframe with the same rows as
[`releases_data_input`](https://alexmitrani.github.io/Repeatr/reference/releases_data_input.md),
plus `tempo_bpm`, `duration_seconds`, `minutes` (`title` becomes a
factor, ordered as returned by the underlying `arrange()`).

## Provenance

Shiny-presentation-only. Produced by
[`build_shiny_precompute`](https://alexmitrani.github.io/Repeatr/reference/build_shiny_precompute.md)
from
[`releases_data_input`](https://alexmitrani.github.io/Repeatr/reference/releases_data_input.md),
[`song_tempo_bpm_data`](https://alexmitrani.github.io/Repeatr/reference/song_tempo_bpm_data.md),
and
[`songvarslookup`](https://alexmitrani.github.io/Repeatr/reference/songvarslookup.md).
Not to be confused with the package's own `releases_data_input`, which
this does not overwrite.

## Examples

``` r
shiny_releases_data_input
#> # A tibble: 92 × 15
#>      rid release_title track_number title last_show colour_code count date      
#>    <int> <fct>                <int> <fct>     <int> <chr>       <int> <date>    
#>  1    11 first demo              10 in d…       951 #adb56a        31 1987-09-03
#>  2    11 first demo               8 turn…       951 #adb56a        17 1987-09-03
#>  3    11 first demo               5 the …       951 #adb56a        37 1987-09-03
#>  4    10 furniture                3 hell…       951 #d15743         2 2001-04-27
#>  5    10 furniture                2 numb…       951 #d15743       120 1998-11-21
#>  6    10 furniture                1 furn…       951 #d15743       108 1987-09-03
#>  7     9 the argument            11 argu…       951 #99c3cb        76 1999-08-26
#>  8     9 the argument            10 nigh…       951 #99c3cb        46 1999-08-26
#>  9     9 the argument             9 ex-s…       951 #99c3cb        52 1999-08-26
#> 10     9 the argument             8 oh          951 #99c3cb        91 1998-11-29
#> # ℹ 82 more rows
#> # ℹ 7 more variables: show_num <int>, shows <dbl>, intensity <dbl>,
#> #   rating <dbl>, tempo_bpm <dbl>, duration_seconds <int>, minutes <dbl>
```
