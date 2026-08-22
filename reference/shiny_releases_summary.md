# `releases_summary` enriched with average tempo (BPM) and duration

`releases_summary` enriched with average tempo (BPM) and duration

## Usage

``` r
shiny_releases_summary
```

## Format

dataframe with the same rows as
[`releases_summary`](https://alexmitrani.github.io/Repeatr/reference/releases_summary.md),
plus `tempo_bpm`, `minutes`.

## Provenance

Shiny-presentation-only. Produced by
[`build_shiny_precompute`](https://alexmitrani.github.io/Repeatr/reference/build_shiny_precompute.md)
from
[`releases_summary`](https://alexmitrani.github.io/Repeatr/reference/releases_summary.md)
and
[`shiny_releases_data_input`](https://alexmitrani.github.io/Repeatr/reference/shiny_releases_data_input.md).
Not to be confused with the package's own `releases_summary`, which this
does not overwrite.

## Examples

``` r
shiny_releases_summary
#> # A tibble: 11 × 12
#>      rid release_title     first_debut last_debut release_date songs count shows
#>    <int> <chr>             <date>      <date>     <date>       <int> <int> <dbl>
#>  1     1 fugazi            1987-09-03  1988-06-15 1988-11-19       7  2401   940
#>  2     2 margin walker     1987-09-26  1989-05-03 1989-06-15       6  1684   922
#>  3     3 3 songs           1987-09-03  1987-10-16 1989-12-01       3   635   950
#>  4     4 repeater          1987-09-03  1989-09-23 1990-03-01      11  4062   893
#>  5     5 steady diet of n… 1987-10-07  1991-04-12 1991-08-01      11  2539   781
#>  6     6 in on the killta… 1991-07-28  1993-02-05 1993-06-18      12  2642   587
#>  7     7 red medicine      1993-04-24  1994-11-27 1995-05-12      13  2104   408
#>  8     8 end hits          1996-01-30  1998-05-01 1998-04-24      13  1429   235
#>  9     9 the argument      1998-11-29  2001-06-21 2001-10-16      10   475    87
#> 10    10 furniture         1987-09-03  2001-04-27 2001-10-16       3   230   385
#> 11    11 first demo        1987-09-03  1987-09-03 2014-11-18       3    85   951
#> # ℹ 4 more variables: intensity <dbl>, rating <dbl>, tempo_bpm <dbl>,
#> #   minutes <dbl>
```
