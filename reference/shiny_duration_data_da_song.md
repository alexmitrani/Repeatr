# `duration_data_da_song` joined with each song's `release_title`

Same construction as
[`shiny_duration_data_da`](https://alexmitrani.github.io/Repeatr/reference/shiny_duration_data_da.md),
but sourced from
[`duration_data_da_song`](https://alexmitrani.github.io/Repeatr/reference/duration_data_da_song.md)
instead of
[`duration_data_da`](https://alexmitrani.github.io/Repeatr/reference/duration_data_da.md),
so it additionally includes unreleased/one-off songs (e.g. "untitled"
performances).

## Usage

``` r
shiny_duration_data_da_song
```

## Format

dataframe with the same rows as
[`duration_data_da_song`](https://alexmitrani.github.io/Repeatr/reference/duration_data_da_song.md),
plus `release_title`.

## Provenance

Shiny-presentation-only. Produced by
[`build_shiny_precompute`](https://alexmitrani.github.io/Repeatr/reference/build_shiny_precompute.md)
from
[`duration_data_da_song`](https://alexmitrani.github.io/Repeatr/reference/duration_data_da_song.md)
and
[`summary`](https://alexmitrani.github.io/Repeatr/reference/summary.md).
Consumed only by `inst/shiny/Fugazetteer/app.R`'s "stock \\ details" and
"stock \\ search" tabs.

## Examples

``` r
shiny_duration_data_da_song
#> # A tibble: 18,302 × 9
#>    gid              date       song_number title urls  fls_link minutes position
#>    <chr>            <date>           <dbl> <chr> <chr> <chr>      <dbl>    <dbl>
#>  1 aalst-belgium-9… 1990-09-23           6 and … http… <a href…    4.3      0.2 
#>  2 aalst-belgium-9… 1990-09-23          14 blue… http… <a href…    4.33     0.6 
#>  3 aalst-belgium-9… 1990-09-23           3 bren… http… <a href…    2.93     0.05
#>  4 aalst-belgium-9… 1990-09-23           8 bull… http… <a href…    2.75     0.3 
#>  5 aalst-belgium-9… 1990-09-23           9 burn… http… <a href…    2.72     0.35
#>  6 aalst-belgium-9… 1990-09-23           4 merc… http… <a href…    3.07     0.1 
#>  7 aalst-belgium-9… 1990-09-23          13 recl… http… <a href…    3.52     0.55
#>  8 aalst-belgium-9… 1990-09-23          22 repe… http… <a href…    3.18     1   
#>  9 aalst-belgium-9… 1990-09-23          17 repr… http… <a href…    4.95     0.75
#> 10 aalst-belgium-9… 1990-09-23          21 runa… http… <a href…    4.17     0.95
#> # ℹ 18,292 more rows
#> # ℹ 1 more variable: release_title <chr>
```
