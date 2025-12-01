# Fugazi song duration summary data

Summary data on the song durations in the Fugazi Live Series.

## Usage

``` r
duration_summary
```

## Format

dataframe with one row for each song in the Fugazi discography, except
those which never appear in the Fugazi Live Series data.

- song:

  Name of the song

- renditions:

  The number of times the song was played live according to the
  available recordings.

- minutes_min:

  The minimum duration. In many cases this will be as short as it is
  because the recording was cut off, not because the band played the
  song really fast.

- minutes_median:

  The median duration: if all the renditions were lined up in order from
  shortest to longest this would be the middle one.

- minutes_max:

  The maximum duration.

- minutes_mean:

  The average duration.

- minutes_sd:

  The standard deviation of the duration - this is a measure of spread,
  it indicates how much variation there is across all of the renditions.

- minutes_total:

  The total duration of all the times the song was played.

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
  duration_summary
#> # A tibble: 94 × 8
#>    song           renditions minutes_min minutes_median minutes_max minutes_mean
#>    <chr>               <int>       <dbl>          <dbl>       <dbl>        <dbl>
#>  1 23 beats off           26        3.2            3.78        4.6          3.77
#>  2 and the same          375        0.62           4.43        8.57         4.48
#>  3 argument               66        0.57           4.7         6.58         4.73
#>  4 arpeggiator           154        0.8            3.83        5.32         3.85
#>  5 back to base          136        1.53           1.7         3.48         1.77
#>  6 bad mouth             279        0.25           2.48        5.6          2.56
#>  7 bed for the s…        299        1.42           2.98        5.03         3.03
#>  8 birthday pony         199        0.27           2.4         7.48         2.44
#>  9 blueprint             584        1.35           3.63        6            3.74
#> 10 break                 172        0.87           2.07        6.48         2.14
#> # ℹ 84 more rows
#> # ℹ 2 more variables: minutes_sd <dbl>, minutes_total <dbl>
```
