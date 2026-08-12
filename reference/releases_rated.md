# Average estimated song rating by release

Produced by
[`Repeatr_5`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md):
average of the estimated
[`summary`](https://alexmitrani.github.io/Repeatr/reference/summary.md)
rating across the songs on each release (excluding First Demo and
Unreleased, which aren't comparable to the others).

## Usage

``` r
releases_rated
```

## Format

dataframe with one row for each release.

- release_title:

  The name of the release.

- rid:

  numeric id in ascending chronological order

- release_date:

  The date of the release

- songs_rated:

  The number of songs on the release that were rated

- rating:

  The average rating across the rated songs on the release

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-modeled. Produced by
[`Repeatr_5`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md).

## Examples

``` r
releases_rated
#> # A tibble: 10 × 5
#>    release_title            rid release_date songs_rated rating
#>    <chr>                  <int> <date>             <int>  <dbl>
#>  1 the argument               9 2001-10-16            10  0.791
#>  2 end hits                   8 1998-04-24            13  0.782
#>  3 repeater                   4 1990-03-01            11  0.768
#>  4 fugazi                     1 1988-11-19             7  0.733
#>  5 red medicine               7 1995-05-12            13  0.721
#>  6 in on the killtaker        6 1993-06-18            12  0.719
#>  7 margin walker              2 1989-06-15             6  0.709
#>  8 3 songs                    3 1989-12-01             3  0.632
#>  9 steady diet of nothing     5 1991-08-01            11  0.614
#> 10 furniture                 10 2001-10-16             3  0.555
```
