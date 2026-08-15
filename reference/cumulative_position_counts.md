# Cumulative Position Counts

Cumulative Position Counts

## Usage

``` r
cumulative_position_counts
```

## Format

dataframe with one row for each combination of song and normalized
setlist position in the Fugazi Live Series data.

- position:

  Normalized position of the song within the show's setlist, from 0
  (first song) to 1 (last song)

- title:

  Name of the song

- release_title:

  Name of the corresponding discographical release

- count:

  The cumulative count of the number of times the song had been
  performed up to and including this position.

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-cleaned. Produced by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md).

## Examples

``` r
cumulative_position_counts
#> # A tibble: 8,708 × 4
#>    position title                release_title       count
#>       <dbl> <chr>                <chr>               <int>
#>  1        0 23 beats off         in on the killtaker     1
#>  2        0 and the same         margin walker          11
#>  3        0 argument             the argument            1
#>  4        0 arpeggiator          end hits                7
#>  5        0 back to base         red medicine            3
#>  6        0 bad mouth            fugazi                  6
#>  7        0 bed for the scraping red medicine            7
#>  8        0 birthday pony        red medicine           36
#>  9        0 blueprint            repeater               31
#> 10        0 break                end hits               62
#> # ℹ 8,698 more rows
```
