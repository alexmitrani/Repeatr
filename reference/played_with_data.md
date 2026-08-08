# Fugazi Live Series data on bands that fugazi played with in long format, combined with show data and coordinates

Fugazi Live Series data on bands that fugazi played with in long format,
combined with show data and coordinates

## Usage

``` r
played_with_data
```

## Format

dataframe with one row for show and each band that Fugazi played with in
the Fugazi Live Series shows with data.

- gid:

  gig id. This is a concatenation of city, country, and date

- fls_link:

  link to the corresponding page on the Fugazi Live Series site

- year:

  year

- tour:

  tour

- date:

  date

- venue:

  Venue

- city:

  city

- country:

  country

- played_with:

  Band name

- attendance:

  Attendance

- sound_quality:

  Sound quality rating: Excellent, Very Good, Good, or Poor.

- latitude:

  latitude

- longitude:

  longitude

## Source

https://www.dischord.com/fugazi_live_series

https://arquivomotor.wordpress.com/1994/08/12/bhrif-programacao/

## Provenance

Derived-cleaned. Produced by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md).
Exported as-is as fugazi.db's `played_with_data` table by
[`export_fugazidb_data`](https://alexmitrani.github.io/Repeatr/reference/export_fugazidb_data.md).

## Examples

``` r
played_with_data
#> # A tibble: 1,754 × 13
#>    gid           fls_link  year tour  date       venue city  country played_with
#>    <chr>         <chr>    <dbl> <chr> <date>     <chr> <chr> <chr>   <chr>      
#>  1 aalst-belgiu… <a href…  1990 1990… 1990-09-23 Netw… Aalst Belgium Alice Donut
#>  2 aberdeen-sco… <a href…  1999 1999… 1999-05-04 Lemo… Aber… Scotla… Laeto      
#>  3 adelaide-aus… <a href…  1993 1993… 1993-11-11 Dom … Adel… Austra… Magic Dirt 
#>  4 adelaide-aus… <a href…  1996 1996… 1996-11-12 Adel… Adel… Austra… Sin Dog Je…
#>  5 adelaide-aus… <a href…  1996 1996… 1996-11-12 Adel… Adel… Austra… Test Eagles
#>  6 adelaide-sa-… <a href…  1991 1991… 1991-10-22 Le R… Adel… Austra… Baba Ganous
#>  7 akron-oh-usa… <a href…  1990 1990… 1990-06-28 Jack… Akron USA     Holy Rolle…
#>  8 akron-oh-usa… <a href…  1990 1990… 1990-06-28 Jack… Akron USA     Hyper as H…
#>  9 albany-ny-us… <a href…  1993 1993… 1993-09-20 S.U.… Alba… USA     Spinanes   
#> 10 albany-ny-us… <a href…  1993 1993… 1993-09-20 S.U.… Alba… USA     Very Pleas…
#> # ℹ 1,744 more rows
#> # ℹ 4 more variables: attendance <dbl>, sound_quality <chr>, latitude <dbl>,
#> #   longitude <dbl>
```
