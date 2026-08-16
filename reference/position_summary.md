# Fugazi song position summary data

Summary data on each song's normalized position within the setlist,
across the Fugazi Live Series.

## Usage

``` r
position_summary
```

## Format

dataframe with one row for each song in the Fugazi discography that
appears in
[`duration_data_da`](https://alexmitrani.github.io/Repeatr/reference/duration_data_da.md).

- title:

  Name of the song

- renditions:

  The number of times the song was played live according to the
  available recordings.

- position_min:

  The minimum normalized position (0 = first song in the set).

- position_median:

  The median normalized position: if all the renditions were lined up in
  order from earliest to latest in the set this would be the middle one.

- position_max:

  The maximum normalized position (1 = last song in the set).

- position_mean:

  The average normalized position.

- position_sd:

  The standard deviation of the normalized position - this is a measure
  of spread, it indicates how much variation there is in where the song
  falls in the set across all of the renditions.

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-cleaned. Produced by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md).

## Examples

``` r
position_summary
#> # A tibble: 92 × 7
#>    title      renditions position_min position_median position_max position_mean
#>    <chr>           <int>        <dbl>           <dbl>        <dbl>         <dbl>
#>  1 23 beats …         27            0            0.4          0.85          0.46
#>  2 and the s…        397            0            0.13         1             0.19
#>  3 argument           76            0            0.59         1             0.61
#>  4 arpeggiat…        163            0            0.78         1             0.73
#>  5 back to b…        142            0            0.56         1             0.49
#>  6 bad mouth         311            0            0.44         1             0.45
#>  7 bed for t…        310            0            0.33         1             0.4 
#>  8 birthday …        203            0            0.29         0.97          0.36
#>  9 blueprint         608            0            0.66         1             0.6 
#> 10 break             179            0            0.15         1             0.27
#> # ℹ 82 more rows
#> # ℹ 1 more variable: position_sd <dbl>
```
