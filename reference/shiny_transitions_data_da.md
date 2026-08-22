# `transitions_data_da` joined with `shiny_fls_link_year_tour`

`transitions_data_da` joined with `shiny_fls_link_year_tour`

## Usage

``` r
shiny_transitions_data_da
```

## Format

dataframe with the same rows as
[`transitions_data_da`](https://alexmitrani.github.io/Repeatr/reference/transitions_data_da.md),
plus `year`/`tour`.

## Provenance

Shiny-presentation-only. Produced by
[`build_shiny_precompute`](https://alexmitrani.github.io/Repeatr/reference/build_shiny_precompute.md)
from
[`transitions_data_da`](https://alexmitrani.github.io/Repeatr/reference/transitions_data_da.md)
and
[`shiny_fls_link_year_tour`](https://alexmitrani.github.io/Repeatr/reference/shiny_fls_link_year_tour.md).
Not to be confused with the package's own `transitions_data_da`, which
this does not overwrite.

## Examples

``` r
shiny_transitions_data_da
#> # A tibble: 17,334 × 10
#>    gid        url   fls_link date  transition to_song_number title1 title2  year
#>    <chr>      <chr> <chr>    <chr>      <int>          <int> <chr>  <chr>  <dbl>
#>  1 aalst-bel… http… <a href… 1990…          1              3 turno… brend…  1990
#>  2 aalst-bel… http… <a href… 1990…          2              4 brend… merch…  1990
#>  3 aalst-bel… http… <a href… 1990…          3              5 merch… sieve…  1990
#>  4 aalst-bel… http… <a href… 1990…          4              6 sieve… and t…  1990
#>  5 aalst-bel… http… <a href… 1990…          5              8 and t… bulld…  1990
#>  6 aalst-bel… http… <a href… 1990…          6              9 bulld… burni…  1990
#>  7 aalst-bel… http… <a href… 1990…          7             11 burni… sugge…  1990
#>  8 aalst-bel… http… <a href… 1990…          8             13 sugge… recla…  1990
#>  9 aalst-bel… http… <a href… 1990…          9             14 recla… bluep…  1990
#> 10 aalst-bel… http… <a href… 1990…         10             15 bluep… shut …  1990
#> # ℹ 17,324 more rows
#> # ℹ 1 more variable: tour <chr>
```
