# `shows_data`, trimmed to `fls_link`/`year`/`tour`

`shows_data`, trimmed to `fls_link`/`year`/`tour`

## Usage

``` r
shiny_fls_link_year_tour
```

## Format

dataframe with one row for each show in
[`shows_data`](https://alexmitrani.github.io/Repeatr/reference/shows_data.md).

- fls_link:

  a link to the corresponding page of the Fugazi Live Series site

- year:

  year

- tour:

  the touring period the show belongs to

## Provenance

Shiny-presentation-only. Produced by
[`build_shiny_precompute`](https://alexmitrani.github.io/Repeatr/reference/build_shiny_precompute.md)
from
[`shows_data`](https://alexmitrani.github.io/Repeatr/reference/shows_data.md).

## Examples

``` r
shiny_fls_link_year_tour
#> # A tibble: 1,049 × 3
#>    fls_link                                                           year tour 
#>    <chr>                                                             <dbl> <chr>
#>  1 <a href='https://www.dischord.com/fugazi_live_series/washington-…  1987 1987…
#>  2 <a href='https://www.dischord.com/fugazi_live_series/washington-…  1987 1987…
#>  3 <a href='https://www.dischord.com/fugazi_live_series/chapel-hill…  1987 1987…
#>  4 <a href='https://www.dischord.com/fugazi_live_series/richmond-va…  1987 1987…
#>  5 <a href='https://www.dischord.com/fugazi_live_series/washington-…  1987 1987…
#>  6 <a href='https://www.dischord.com/fugazi_live_series/frederick-m…  1987 1987…
#>  7 <a href='https://www.dischord.com/fugazi_live_series/bethesda-md…  1987 1987…
#>  8 <a href='https://www.dischord.com/fugazi_live_series/washington-…  1987 1987…
#>  9 <a href='https://www.dischord.com/fugazi_live_series/middletown-…  1987 1987…
#> 10 <a href='https://www.dischord.com/fugazi_live_series/norwalk-ct-…  1987 1987…
#> # ℹ 1,039 more rows
```
