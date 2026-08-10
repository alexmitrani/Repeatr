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

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-cleaned. Produced by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md).
Actively consumed directly by `inst/shiny/Fugazetteer/app.R`.

## Examples

``` r
shows_data
#> # A tibble: 1,049 × 18
#>    gid   tour   year date       venue city  subdivision country attendance price
#>    <chr> <chr> <dbl> <date>     <chr> <chr> <chr>       <chr>        <int> <dbl>
#>  1 aals… 1990…  1990 1990-09-23 Netw… Aalst NA          Belgium        600    NA
#>  2 aber… 1999…  1999 1999-05-04 Lemo… Aber… NA          Scotla…        550     6
#>  3 adel… 1993…  1993 1993-11-11 Dom … Adel… SA          Austra…        550    15
#>  4 adel… 1996…  1996 1996-11-12 Adel… Adel… SA          Austra…        913    NA
#>  5 adel… 1991…  1991 1991-10-22 Le R… Adel… SA          Austra…        450    NA
#>  6 akro… 1990…  1990 1990-06-28 Jack… Akron OH          USA            700     5
#>  7 alba… 1993…  1993 1993-09-20 S.U.… Alba… NY          USA           1000     5
#>  8 albu… 1995…  1995 1995-11-13 Five… Albu… NM          USA            895     5
#>  9 albu… 2001…  2001 2001-04-08 Suns… Albu… NM          USA           1100     6
#> 10 albu… 1991…  1991 1991-09-11 Suns… Albu… NM          USA            800     5
#> # ℹ 1,039 more rows
#> # ℹ 8 more variables: currency <chr>, latitude <dbl>, longitude <dbl>,
#> #   fls_notes <chr>, urls <chr>, fls_link <chr>, minutes <dbl>,
#> #   sound_quality <chr>
```
