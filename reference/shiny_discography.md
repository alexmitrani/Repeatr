# `summary`, trimmed to `title`/`release_title`

`summary`, trimmed to `title`/`release_title`

## Usage

``` r
shiny_discography
```

## Format

dataframe with one row for each song in
[`summary`](https://alexmitrani.github.io/Repeatr/reference/summary.md).

- title:

  the name of the song

- release_title:

  name of album or EP

## Provenance

Shiny-presentation-only. Produced by
[`build_shiny_precompute`](https://alexmitrani.github.io/Repeatr/reference/build_shiny_precompute.md)
from
[`summary`](https://alexmitrani.github.io/Repeatr/reference/summary.md).

## Examples

``` r
shiny_discography
#> # A tibble: 92 × 2
#>    title            release_title
#>    <chr>            <chr>        
#>  1 waiting room     fugazi       
#>  2 bulldog front    fugazi       
#>  3 bad mouth        fugazi       
#>  4 burning          fugazi       
#>  5 give me the cure fugazi       
#>  6 suggestion       fugazi       
#>  7 glueman          fugazi       
#>  8 margin walker    margin walker
#>  9 and the same     margin walker
#> 10 burning too      margin walker
#> # ℹ 82 more rows
```
