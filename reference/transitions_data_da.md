# Transitions Data

Transitions Data

## Usage

``` r
transitions_data_da
```

## Format

dataframe with one row for each combination of show, first song and
second song in the Fugazi Live Series data.

- gid:

  gig id. This is a concatenation of city, country, and date

- url:

  url to the corresponding page of the Fugazi Live Series site.

- fls_link:

  provides a link to the corresponding page of the Fugazi Live Series
  site

- date:

  date of the show

- transition:

  Number of the transition in the show

- title1:

  Name of the first song

- title2:

  Name of the second song

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-cleaned. Produced by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md).
Not to be confused with the orphaned `transitions` object.

## Examples

``` r
transitions_data_da
#> # A tibble: 12,610 × 7
#>    gid                 url               fls_link date  transition title1 title2
#>    <chr>               <chr>             <chr>    <chr>      <int> <chr>  <chr> 
#>  1 aalst-belgium-92390 https://www.disc… <a href… 1990…          2 turno… brend…
#>  2 aalst-belgium-92390 https://www.disc… <a href… 1990…          3 brend… merch…
#>  3 aalst-belgium-92390 https://www.disc… <a href… 1990…          4 merch… sieve…
#>  4 aalst-belgium-92390 https://www.disc… <a href… 1990…          5 sieve… and t…
#>  5 aalst-belgium-92390 https://www.disc… <a href… 1990…          8 bulld… burni…
#>  6 aalst-belgium-92390 https://www.disc… <a href… 1990…         13 recla… bluep…
#>  7 aalst-belgium-92390 https://www.disc… <a href… 1990…         14 bluep… shut …
#>  8 aalst-belgium-92390 https://www.disc… <a href… 1990…         15 shut … two b…
#>  9 aalst-belgium-92390 https://www.disc… <a href… 1990…         16 two b… repro…
#> 10 aalst-belgium-92390 https://www.disc… <a href… 1990…         21 runaw… repea…
#> # ℹ 12,600 more rows
```
