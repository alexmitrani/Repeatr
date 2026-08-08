# Fugazi Live Series data - other variables

some of this data was scraped from the Fugazi Live Series website by
Carni Klirs for his project "Visualizing the History of Fugazi". The
original data on coordinates, cities and tours data came from The D-I-Y
Data of Fugazi by Matthew Conlen. Rows with checked==1 were updated by
Alex Mitrani, in particular making sure that the coordinates indicated
the actual locations of the venues for city-level mapping.

## Usage

``` r
othervariables
```

## Format

dataframe with one row for each show.

- gid:

  show id

- flsid:

  Fugazi Live Series id

- venue:

  Venue

- doorprice:

  Door price

- attendance:

  Attendance

- recorded_by:

  Recorded by

- mastered_by:

  Mastered by

- original_source:

  Original source

- x:

  longitude

- y:

  latitude

- city:

  city - plain city name (e.g. "Portland", "Columbia", "Croydon"); see
  `subdivision`/`country` to disambiguate cities that share a name with
  another Fugazi tour stop. Internally,
  [`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)
  temporarily suffixes these as "City (ST/Country)" to match the
  venue-coordinate lookup's join key, then strips the suffix back off
  once coordinates are resolved - the suffix never persists to this
  exposed column.

- subdivision:

  Subnational administrative unit (US state, DC, Canadian province, or
  Australian state/territory), where applicable (`NA` outside those
  three countries) - scraped directly, see
  [`Repeatr0`](https://alexmitrani.github.io/Repeatr/reference/Repeatr0.md)/[`scrape_fls_listing_data`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_listing_data.md).

- country:

  country

- tour:

  The touring period the show belongs to, scraped directly from the FLS
  listing pages (see
  [`Repeatr0`](https://alexmitrani.github.io/Repeatr/reference/Repeatr0.md)/[`scrape_fls_listing_data`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_listing_data.md)).

- year:

  year

- checked:

  checked==1 indicates that the data was checked and updated by Alex
  Mitrani, in particular making sure that the coordinates indicate as
  closely as possible the actual locations of the venues.

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-cleaned. Produced by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)
by joining `inst/extdata/fls_data.csv` with
`inst/extdata/fls_venue_geocoding_v2.csv`. Actively consumed directly by
`inst/shiny/Fugazetteer/app.R` (e.g. its attendance/tour reactives).
Exported (minus `fls_notes`, plus `sound_quality` and duration) as
fugazi.db's `fls_shows` table by
[`export_fugazidb_data`](https://alexmitrani.github.io/Repeatr/reference/export_fugazidb_data.md).

## Examples

``` r
othervariables
#> # A tibble: 1,049 × 18
#>    gid       flsid date       venue doorprice attendance recorded_by mastered_by
#>    <chr>     <chr> <date>     <chr> <chr>          <dbl> <chr>       <chr>      
#>  1 aalst-be… FLS0… 1990-09-23 Netw… NA              600  Joey Picuri Warren Rus…
#>  2 aberdeen… FLS0… 1999-05-04 Lemo… 6(pounds)       550  Joey Picuri Jerry Bush…
#>  3 adelaide… FLS0… 1993-11-11 Dom … 15              550  Joey Picuri Warren Rus…
#>  4 adelaide… FLS0… 1996-11-12 Adel… NA              913. Nick Pelli… Jerry Bush…
#>  5 adelaide… FLS0… 1991-10-22 Le R… NA              450  Joey Picuri Warren Rus…
#>  6 akron-oh… FLS0… 1990-06-28 Jack… 5               700  Joey Picuri Warren Rus…
#>  7 albany-n… FLS0… 1993-09-20 S.U.… 5              1000  Joey Picuri Warren Rus…
#>  8 albuquer… FLS0… 1995-11-13 Five… 5               895  Joey Picuri Warren Rus…
#>  9 albuquer… FLS0… 2001-04-08 Suns… 6              1100  Nick Pelli… Warren Rus…
#> 10 albuquer… FLS0… 1991-09-11 Suns… 5               800  Joey Picuri Warren Rus…
#> # ℹ 1,039 more rows
#> # ℹ 10 more variables: original_source <chr>, fls_notes <chr>, tour <chr>,
#> #   city <chr>, subdivision <chr>, country <chr>, year <dbl>, checked <dbl>,
#> #   x <dbl>, y <dbl>
```
