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

- song:

  Name of the song

- release:

  Name of the corresponding discographical release

- count:

  The cumulative count of the number of times the song had been
  performed up to and including this duration.

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
  cumulative_duration_counts
#> # A tibble: 44,759 × 4
#>    minutes song                   release             count
#>      <dbl> <chr>                  <chr>               <int>
#>  1    0.05 cassavetes             in on the killtaker     1
#>  2    0.05 public witness program in on the killtaker     1
#>  3    0.08 cassavetes             in on the killtaker     1
#>  4    0.08 public witness program in on the killtaker     1
#>  5    0.08 waiting room           fugazi                  1
#>  6    0.15 cassavetes             in on the killtaker     1
#>  7    0.15 public witness program in on the killtaker     2
#>  8    0.15 waiting room           fugazi                  1
#>  9    0.25 cassavetes             in on the killtaker     1
#> 10    0.25 public witness program in on the killtaker     2
#> # ℹ 44,749 more rows
```
