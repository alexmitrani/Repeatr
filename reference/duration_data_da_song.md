# Duration Data, including unreleased/one-off songs

Same construction and columns as
[`duration_data_da`](https://alexmitrani.github.io/Repeatr/reference/duration_data_da.md),
but built from `tracktype %in% c(1, 2)` instead of `tracktype==1` - so
it additionally includes unreleased/one-off songs (tracktype 2, e.g.
"untitled" performances) alongside released songs (tracktype 1). Exists
only so the Fugazetteer Shiny app's "stock \\ details" and "stock \\
search" song pickers can surface these performances without changing
what
[`duration_data_da`](https://alexmitrani.github.io/Repeatr/reference/duration_data_da.md)
itself feeds - Discography, Variation, Recap, and Stacks all keep
reading the tracktype==1-only
[`duration_data_da`](https://alexmitrani.github.io/Repeatr/reference/duration_data_da.md),
unaffected by this object.

## Usage

``` r
duration_data_da_song
```

## Format

Same format as
[`duration_data_da`](https://alexmitrani.github.io/Repeatr/reference/duration_data_da.md).

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-cleaned. Produced by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md).
Consumed only by `inst/shiny/Fugazetteer/app.R`'s "stock \\ details" and
"stock \\ search" tabs (via `shiny_duration_data_da_song`, precomputed
by
[`build_shiny_precompute`](https://alexmitrani.github.io/Repeatr/reference/build_shiny_precompute.md)).

## Examples

``` r
duration_data_da_song
#> # A tibble: 18,302 × 8
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
```
