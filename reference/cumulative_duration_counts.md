# Cumulative Duration Counts

Cumulative Duration Counts

## Usage

``` r
cumulative_duration_counts
```

## Format

dataframe with one row for each combination of song and duration in the
Fugazi Live Series data.

- minutes:

  Duration of the show in minutes

- title:

  Name of the song

- release_title:

  Name of the corresponding discographical release

- count:

  The cumulative count of the number of times the song had been
  performed up to and including this duration.

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-cleaned. Produced by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md).

## Examples

``` r
cumulative_duration_counts
#> # A tibble: 44,680 × 4
#>    minutes title                  release_title       count
#>      <dbl> <chr>                  <chr>               <int>
#>  1    0.05 cassavetes             in on the killtaker     1
#>  2    0.05 public witness program in on the killtaker     1
#>  3    0.08 cassavetes             in on the killtaker     1
#>  4    0.08 public witness program in on the killtaker     1
#>  5    0.08 waiting room           fugazi                  1
#>  6    0.1  cassavetes             in on the killtaker     1
#>  7    0.1  public witness program in on the killtaker     1
#>  8    0.1  waiting room           fugazi                  1
#>  9    0.1  suggestion             fugazi                  1
#> 10    0.15 cassavetes             in on the killtaker     1
#> # ℹ 44,670 more rows
```
