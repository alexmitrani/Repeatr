# Shows Data

Shows Data

## Usage

``` r
shows_data
```

## Format

dataframe with one row for each show in the Fugazi Live Series data.

- gid:

  Unique identifier for the show

- tour:

  The tour that the show belongs to.

- year:

  The year of the show,

- date:

  The date of the show.

- venue:

  the venue,

- city:

  the city.

- subdivision:

  Subnational administrative unit (US state, DC, Canadian province,
  Australian state/territory, or Brazilian state), where applicable
  (`NA` elsewhere) - see
  [`othervariables`](https://alexmitrani.github.io/Repeatr/reference/othervariables.md)
  for how Brazilian codes are filled in.

- country:

  The country.

- attendance:

  The number of people who attended.

- price:

  Numeric ticket price (`NA` where unknown, `0` for free shows) - see
  [`othervariables`](https://alexmitrani.github.io/Repeatr/reference/othervariables.md)
  for how this is split from the raw scraped door-price text.

- currency:

  ISO 4217 currency code for `price`.

- latitude:

  The latitude of the show location.

- longitude:

  The longitude of the show location.

- urls:

  A string used to form the URLs of the corresponding page on the Fugazi
  Live series site.

- fls_link:

  a link to the corresponding page of the Fugazi Live Series site.

- minutes:

  duration of the show in minutes if a recording is available

- sound_quality:

  Sound quality rating: Excellent, Very Good, Good, or Poor.

- distance_home_km:

  Great-circle distance (km, via
  [`geosphere::distGeo`](https://rdrr.io/pkg/geosphere/man/distGeo.html))
  from this show to "home" - the location of the earliest-dated show in
  the series (the Wilson Center, Fugazi's first ever show in 1987).
  Always populated.

- distance_to_km:

  Distance (km) traveled *to* this show: from the previous show, if this
  show is classified as part of the same tour chain as it (see
  `Provenance` below), otherwise from home (i.e. equal to
  `distance_home_km`, for a home-based show or the first stop of a tour
  chain). Always populated.

- distance_back_km:

  Distance (km) traveled *back home* after this show. Populated only for
  a home-based show or the last stop of a tour chain (`NA` for every
  other tour stop, since the band hadn't returned home yet).

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-cleaned. Produced by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md).
Actively consumed directly by `inst/shiny/Fugazetteer/app.R`. The three
`distance_*_km` columns (issue \#259) are computed by
`classify_show_trips()` in `R/recap.R`, which classifies each show as
home-based or part of a moving tour chain purely from geography and
dates (whether it's geographically closer to the previous show than to
home, and within a plausible date gap of it) - a show within
`home_radius_km` of home is always treated as home-based. This
classification is deliberately independent of the `tour` column above,
whose own tour/regional-dates labelling isn't reliable enough to build
on; `tour` is used only as an informal sanity check against it (see
`inst/notes` for the cross-check from when this was added), never as an
input. These three columns are internal to Repeatr and are not exported
to fugazibase.

## Examples

``` r
shows_data
#> # A tibble: 1,049 × 21
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
#> # ℹ 11 more variables: currency <chr>, latitude <dbl>, longitude <dbl>,
#> #   fls_notes <chr>, urls <chr>, fls_link <chr>, minutes <dbl>,
#> #   sound_quality <chr>, distance_home_km <dbl>, distance_to_km <dbl>,
#> #   distance_back_km <dbl>
```
