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

- price:

  Numeric ticket price, split from the raw scraped door-price text via
  `inst/extdata/fls_doorprice_currency_lookup.csv` (`NA` where the raw
  text is blank, ~33% of shows); `0` for shows marked "Free".

- currency:

  ISO 4217 currency code for `price` (`NA` alongside a missing `price`);
  "Free" shows are `USD` except one 1995 Italy show (`ITL`).

- attendance:

  Attendance

- recorded_by:

  Recorded by

- mastered_by:

  Mastered by. A handful of typo'd values ("Warren Russell Smith"
  missing its hyphen) are corrected here.

- original_source:

  Original source. A handful of terse raw values ("?", "VHS", "VHS
  Tape") are standardized here to "Unknown"/"VHS audio".

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

  Subnational administrative unit (US state, DC, Canadian province,
  Australian state/territory, or Brazilian state), where applicable
  (`NA` elsewhere) - scraped directly for the US/Canada/Australia (see
  [`Repeatr0`](https://alexmitrani.github.io/Repeatr/reference/Repeatr0.md)/[`scrape_fls_listing_data`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_listing_data.md));
  Brazilian state codes are filled in by
  [`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)
  from a hand-verified city lookup, since the FLS site's own scrape
  never populates a subdivision outside the US/Canada/Australia. Any
  remaining blank (a pre-existing mix of `NA` and `""`) is standardized
  to `NA`.

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
Exported as-is (minus `fls_notes`, `year`, `checked`, `x`, `y` - venue
coordinates live in fugazibase's `locations` table instead; plus
`sound_quality` joined in) as fugazibase's `shows` table by
[`export_fugazibase_data`](https://alexmitrani.github.io/Repeatr/reference/export_fugazibase_data.md).

## Examples

``` r
othervariables
#> # A tibble: 1,049 × 19
#>    gid                 flsid date       venue attendance recorded_by mastered_by
#>    <chr>               <chr> <date>     <chr>      <dbl> <chr>       <chr>      
#>  1 aalst-belgium-92390 FLS0… 1990-09-23 Netw…       600  Joey Picuri Warren Rus…
#>  2 aberdeen-scotland-… FLS0… 1999-05-04 Lemo…       550  Joey Picuri Jerry Bush…
#>  3 adelaide-australia… FLS0… 1993-11-11 Dom …       550  Joey Picuri Warren Rus…
#>  4 adelaide-australia… FLS0… 1996-11-12 Adel…       913. Nick Pelli… Jerry Bush…
#>  5 adelaide-sa-austra… FLS0… 1991-10-22 Le R…       450  Joey Picuri Warren Rus…
#>  6 akron-oh-usa-62890  FLS0… 1990-06-28 Jack…       700  Joey Picuri Warren Rus…
#>  7 albany-ny-usa-92093 FLS0… 1993-09-20 S.U.…      1000  Joey Picuri Warren Rus…
#>  8 albuquerque-nm-usa… FLS0… 1995-11-13 Five…       895  Joey Picuri Warren Rus…
#>  9 albuquerque-nm-usa… FLS0… 2001-04-08 Suns…      1100  Nick Pelli… Warren Rus…
#> 10 albuquerque-nm-usa… FLS0… 1991-09-11 Suns…       800  Joey Picuri Warren Rus…
#> # ℹ 1,039 more rows
#> # ℹ 12 more variables: original_source <chr>, fls_notes <chr>, tour <chr>,
#> #   city <chr>, subdivision <chr>, country <chr>, year <dbl>, checked <dbl>,
#> #   x <dbl>, y <dbl>, price <dbl>, currency <chr>
```
