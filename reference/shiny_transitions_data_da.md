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
#> # A tibble: 12,610 × 9
#>    gid                 url   fls_link date  transition title1 title2  year tour 
#>    <chr>               <chr> <chr>    <chr>      <int> <chr>  <chr>  <dbl> <chr>
#>  1 aalst-belgium-92390 http… <a href… 1990…          2 turno… brend…  1990 1990…
#>  2 aalst-belgium-92390 http… <a href… 1990…          3 brend… merch…  1990 1990…
#>  3 aalst-belgium-92390 http… <a href… 1990…          4 merch… sieve…  1990 1990…
#>  4 aalst-belgium-92390 http… <a href… 1990…          5 sieve… and t…  1990 1990…
#>  5 aalst-belgium-92390 http… <a href… 1990…          8 bulld… burni…  1990 1990…
#>  6 aalst-belgium-92390 http… <a href… 1990…         13 recla… bluep…  1990 1990…
#>  7 aalst-belgium-92390 http… <a href… 1990…         14 bluep… shut …  1990 1990…
#>  8 aalst-belgium-92390 http… <a href… 1990…         15 shut … two b…  1990 1990…
#>  9 aalst-belgium-92390 http… <a href… 1990…         16 two b… repro…  1990 1990…
#> 10 aalst-belgium-92390 http… <a href… 1990…         21 runaw… repea…  1990 1990…
#> # ℹ 12,600 more rows
```
