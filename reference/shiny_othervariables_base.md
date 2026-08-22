# `othervariables` joined with sound quality and dischord.com link columns

The base app.R builds its own runtime `othervariables` from: joins in
the live `fls_venue_geocoding` sheet for coordinates, disambiguates
same-named cities, and de-duplicates by `gid`. Coordinates change if the
sheet is edited, so that part must stay a live, runtime join - this
object is everything upstream of it.

## Usage

``` r
shiny_othervariables_base
```

## Format

dataframe with the same rows as
[`othervariables`](https://alexmitrani.github.io/Repeatr/reference/othervariables.md),
plus `sound_quality`, `urls`, `fls_link`.

## Provenance

Shiny-presentation-only. Produced by
[`build_shiny_precompute`](https://alexmitrani.github.io/Repeatr/reference/build_shiny_precompute.md)
from
[`othervariables`](https://alexmitrani.github.io/Repeatr/reference/othervariables.md)
and
[`gid_sound_quality`](https://alexmitrani.github.io/Repeatr/reference/gid_sound_quality.md).

## Examples

``` r
shiny_othervariables_base
#> # A tibble: 1,049 × 22
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
#> # ℹ 15 more variables: original_source <chr>, fls_notes <chr>, tour <chr>,
#> #   city <chr>, subdivision <chr>, country <chr>, year <dbl>, checked <dbl>,
#> #   x <dbl>, y <dbl>, price <dbl>, currency <chr>, sound_quality <chr>,
#> #   urls <chr>, fls_link <chr>
```
