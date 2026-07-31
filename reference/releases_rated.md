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

- release:

  The name of the release.

- releaseid:

  numeric id in ascending chronological order

- releasedate:

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
#>    release                releaseid releasedate songs_rated rating
#>    <chr>                      <int> <chr>             <int>  <dbl>
#>  1 the argument                   9 16/10/2001           10  0.791
#>  2 end hits                       8 24/04/1998           13  0.782
#>  3 repeater                       4 01/03/1990           11  0.768
#>  4 fugazi                         1 19/11/1988            7  0.733
#>  5 red medicine                   7 12/05/1995           13  0.721
#>  6 in on the killtaker            6 18/06/1993           12  0.719
#>  7 margin walker                  2 15/06/1989            6  0.709
#>  8 3 songs                        3 01/12/1989            3  0.632
#>  9 steady diet of nothing         5 01/08/1991           11  0.614
#> 10 furniture                     10 16/10/2001            3  0.555
```
