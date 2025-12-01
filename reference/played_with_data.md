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

## Examples

``` r
  played_with_data
#> # A tibble: 1,753 × 12
#>    fls_link     year tour  date       venue city  country played_with attendance
#>    <chr>       <dbl> <chr> <date>     <chr> <chr> <chr>   <chr>            <dbl>
#>  1 <a href='h…  1990 1990… 1990-09-23 Netw… Aalst Belgium Alice Donut        600
#>  2 <a href='h…  1999 1999… 1999-05-04 Lemo… Aber… Scotla… Laeto              550
#>  3 <a href='h…  1993 1993… 1993-11-11 Dom … Adel… Austra… Magic Dirt         550
#>  4 <a href='h…  1996 1996… 1996-11-12 Adel… Adel… Austra… Sin Dog Je…        913
#>  5 <a href='h…  1996 1996… 1996-11-12 Adel… Adel… Austra… Test Eagles        913
#>  6 <a href='h…  1991 1991… 1991-10-22 Le R… Adel… Austra… Baba Ganous        450
#>  7 <a href='h…  1990 1990… 1990-06-28 Jack… Akron USA     Holy Rolle…        700
#>  8 <a href='h…  1990 1990… 1990-06-28 Jack… Akron USA     Hyper as H…        700
#>  9 <a href='h…  1993 1993… 1993-09-20 S.U.… Alba… USA     Spinanes          1000
#> 10 <a href='h…  1993 1993… 1993-09-20 S.U.… Alba… USA     Very Pleas…       1000
#> # ℹ 1,743 more rows
#> # ℹ 3 more variables: sound_quality <chr>, latitude <dbl>, longitude <dbl>
```
