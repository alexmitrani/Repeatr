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

## Examples

``` r
releases_rated
#> # A tibble: 10 × 5
#>    release                releaseid releasedate songs_rated rating
#>    <chr>                      <int> <chr>             <int>  <dbl>
#>  1 3 songs                        3 01/12/1989            2     NA
#>  2 end hits                       8 24/04/1998           12     NA
#>  3 fugazi                         1 19/11/1988            5     NA
#>  4 furniture                     10 16/10/2001            3     NA
#>  5 in on the killtaker            6 18/06/1993            6     NA
#>  6 margin walker                  2 15/06/1989            5     NA
#>  7 red medicine                   7 12/05/1995           11     NA
#>  8 repeater                       4 01/03/1990            4     NA
#>  9 steady diet of nothing         5 01/08/1991            7     NA
#> 10 the argument                   9 16/10/2001            8     NA
```
