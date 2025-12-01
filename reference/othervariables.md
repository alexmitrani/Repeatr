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

  city

- country:

  country

- tour:

  tour

- year:

  year

- checked:

  checked==1 indicates that the data was checked and updated by Alex
  Mitrani, in particular making sure that the coordinates indicate as
  closely as possible the actual locations of the venues.

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
othervariables
#> # A tibble: 1,047 × 16
#>    gid       flsid date       venue doorprice attendance recorded_by mastered_by
#>    <chr>     <chr> <date>     <chr> <chr>          <dbl> <chr>       <chr>      
#>  1 aalst-be… FLS0… 1990-09-23 Netw… ""              600  Joey Picuri Warren Rus…
#>  2 aberdeen… FLS0… 1999-05-04 Lemo… "6(pound…       550  Joey Picuri Jerry Bush…
#>  3 adelaide… FLS0… 1993-11-11 Dom … "15"            550  Joey Picuri Warren Rus…
#>  4 adelaide… FLS0… 1996-11-12 Adel… ""              913. Nick Pelli… Jerry Bush…
#>  5 adelaide… FLS0… 1991-10-22 Le R… ""              450  Joey Picuri Warren Rus…
#>  6 akron-oh… FLS0… 1990-06-28 Jack… "5"             700  Joey Picuri Warren Rus…
#>  7 albany-n… FLS0… 1993-09-20 S.U.… "5"            1000  Joey Picuri Warren Rus…
#>  8 albuquer… FLS0… 1995-11-13 Five… "5"             895  Joey Picuri Warren Rus…
#>  9 albuquer… FLS0… 2001-04-08 Suns… "6"            1100  Nick Pelli… Warren Rus…
#> 10 albuquer… FLS0… 1991-09-11 Suns… "5"             800  Joey Picuri Warren Rus…
#> # ℹ 1,037 more rows
#> # ℹ 8 more variables: original_source <chr>, x <dbl>, y <dbl>, city <chr>,
#> #   country <chr>, tour <chr>, year <dbl>, checked <dbl>
```
