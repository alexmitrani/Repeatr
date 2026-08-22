# `Repeatr1`, summarized by year/gid/release and joined with `othervariables`

`Repeatr1`, summarized by year/gid/release and joined with
`othervariables`

## Usage

``` r
shiny_year_tour_release
```

## Format

dataframe with one row for each combination of year, `gid`, and
`release_title` that appears in
[`Repeatr1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr1.md).

- year:

  year

- gid:

  show id

- release_title:

  name of album or EP

- tour:

  the touring period the show belongs to, from
  [`othervariables`](https://alexmitrani.github.io/Repeatr/reference/othervariables.md)

- count:

  number of songs from this release performed at this show

## Provenance

Shiny-presentation-only. Produced by
[`build_shiny_precompute`](https://alexmitrani.github.io/Repeatr/reference/build_shiny_precompute.md)
from
[`Repeatr1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr1.md)
and
[`othervariables`](https://alexmitrani.github.io/Repeatr/reference/othervariables.md).

## Examples

``` r
shiny_year_tour_release
#> # A tibble: 5,609 × 5
#>     year gid                     release_title tour                        count
#>    <dbl> <chr>                   <chr>         <chr>                       <int>
#>  1  1987 frederick-md-usa-112587 3 songs       1987 Fall/Winter Regional …     3
#>  2  1987 frederick-md-usa-112587 first demo    1987 Fall/Winter Regional …     2
#>  3  1987 frederick-md-usa-112587 fugazi        1987 Fall/Winter Regional …     2
#>  4  1987 frederick-md-usa-112587 furniture     1987 Fall/Winter Regional …     1
#>  5  1987 frederick-md-usa-112587 margin walker 1987 Fall/Winter Regional …     1
#>  6  1987 frederick-md-usa-112587 repeater      1987 Fall/Winter Regional …     1
#>  7  1987 norwalk-ct-usa-120587   3 songs       1987 Fall/Winter Regional …     2
#>  8  1987 norwalk-ct-usa-120587   first demo    1987 Fall/Winter Regional …     2
#>  9  1987 norwalk-ct-usa-120587   fugazi        1987 Fall/Winter Regional …     2
#> 10  1987 norwalk-ct-usa-120587   furniture     1987 Fall/Winter Regional …     1
#> # ℹ 5,599 more rows
```
