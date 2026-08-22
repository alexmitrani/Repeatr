# `shows_data` enriched with average tempo (BPM), before the live venue-coordinate join

The base app.R builds its own runtime `shows_data` from: joins in the
live `fls_venue_geocoding` sheet for coordinates, disambiguates
same-named cities, and de-duplicates by `gid`. Coordinates change if the
sheet is edited, so that part must stay a live, runtime join - this
object is everything upstream of it.

## Usage

``` r
shiny_shows_data_base
```

## Format

dataframe with the same rows as
[`shows_data`](https://alexmitrani.github.io/Repeatr/reference/shows_data.md),
plus `tempo_bpm`.

## Provenance

Shiny-presentation-only. Produced by
[`build_shiny_precompute`](https://alexmitrani.github.io/Repeatr/reference/build_shiny_precompute.md)
from
[`shows_data`](https://alexmitrani.github.io/Repeatr/reference/shows_data.md),
[`duration_data_da`](https://alexmitrani.github.io/Repeatr/reference/duration_data_da.md),
and
[`song_tempo_bpm_data`](https://alexmitrani.github.io/Repeatr/reference/song_tempo_bpm_data.md).
Not to be confused with the package's own `shows_data`, which this does
not overwrite.

## Examples

``` r
shiny_shows_data_base
#> # A tibble: 1,049 × 22
#>    gid   tour   year date       venue city  subdivision country attendance price
#>    <chr> <chr> <dbl> <date>     <chr> <chr> <chr>       <chr>        <int> <dbl>
#>  1 wash… 1987…  1987 1987-09-03 Wils… Wash… DC          USA            300     5
#>  2 wash… 1987…  1987 1987-09-26 St. … Wash… DC          USA            200     5
#>  3 chap… 1987…  1987 1987-09-27 Cat'… Chap… NC          USA             50     5
#>  4 rich… 1987…  1987 1987-10-07 New … Rich… VA          USA             50     5
#>  5 wash… 1987…  1987 1987-10-16 dc s… Wash… DC          USA            100     5
#>  6 fred… 1987…  1987 1987-11-25 Wein… Fred… MD          USA            133    NA
#>  7 beth… 1987…  1987 1987-12-02 BCC … Beth… MD          USA             10    NA
#>  8 wash… 1987…  1987 1987-12-03 Wils… Wash… DC          USA            300     5
#>  9 midd… 1987…  1987 1987-12-04 Wesl… Midd… CT          USA            100     5
#> 10 norw… 1987…  1987 1987-12-05 Anth… Norw… CT          USA            100     5
#> # ℹ 1,039 more rows
#> # ℹ 12 more variables: currency <chr>, latitude <dbl>, longitude <dbl>,
#> #   fls_notes <chr>, urls <chr>, fls_link <chr>, minutes <dbl>,
#> #   sound_quality <chr>, distance_home_km <dbl>, distance_to_km <dbl>,
#> #   distance_back_km <dbl>, tempo_bpm <dbl>
```
