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

- country:

  The country.

- attendance:

  The number of people who attended.

- door_price:

  The ticket price.

- door_price:

  The ticket price.

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

## Examples

``` r
  shows_data
#> # A tibble: 1,047 × 15
#>    gid          tour   year date       venue city  country attendance door_price
#>    <chr>        <chr> <dbl> <date>     <chr> <chr> <chr>        <int> <chr>     
#>  1 aalst-belgi… 1990…  1990 1990-09-23 Netw… Aalst Belgium        600 ""        
#>  2 aberdeen-sc… 1999…  1999 1999-05-04 Lemo… Aber… Scotla…        550 "6(pounds…
#>  3 adelaide-au… 1993…  1993 1993-11-11 Dom … Adel… Austra…        550 "15"      
#>  4 adelaide-au… 1996…  1996 1996-11-12 Adel… Adel… Austra…        913 ""        
#>  5 adelaide-sa… 1991…  1991 1991-10-22 Le R… Adel… Austra…        450 ""        
#>  6 akron-oh-us… 1990…  1990 1990-06-28 Jack… Akron USA            700 "5"       
#>  7 albany-ny-u… 1993…  1993 1993-09-20 S.U.… Alba… USA           1000 "5"       
#>  8 albuquerque… 1995…  1995 1995-11-13 Five… Albu… USA            895 "5"       
#>  9 albuquerque… 2001…  2001 2001-04-08 Suns… Albu… USA           1100 "6"       
#> 10 albuquerque… 1991…  1991 1991-09-11 Suns… Albu… USA            800 "5"       
#> # ℹ 1,037 more rows
#> # ℹ 6 more variables: latitude <dbl>, longitude <dbl>, urls <chr>,
#> #   fls_link <chr>, minutes <dbl>, sound_quality <chr>
```
