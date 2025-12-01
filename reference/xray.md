# xray

xray

## Usage

``` r
xray
```

## Format

dataframe with one row for each rendition of each show in the Fugazi
Live Series data and each type of units (tracks and minutes)

- gid:

  gig id. This is a concatenation of city, country, and date

- url:

  url to the corresponding page of the Fugazi Live Series site.

- fls_link:

  a link to the corresponding page of the Fugazi Live Series site.

- year:

  The year of the show,

- tour:

  The tour that the show belongs to.

- date:

  The date of the show.

- units:

  The units can be either tracks or minutes. The remaining columns on
  any given row will be in these units

- songs:

  songs that were performed at least twice

- released:

  songs that had been released before the date of the show

- unreleased:

  songs that had not been released before the date of the show

- debut:

  songs that were performed for the first time at this show

- farewell:

  songs that were performed for the last time at this show

- incumbent:

  songs that were neither performed for the first time or the last at
  this show

- other:

  tracks that are something else, for instance: intro, opening remarks,
  interlude, encore, outro, interruptions, and one-offs.

- ...:

  The remaining columns correspond to specific releases in the band's
  catalogue.

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
  xray
#> # A tibble: 1,804 × 25
#>    gid     url   fls_link  year tour  date       units songs released unreleased
#>    <chr>   <chr> <chr>    <dbl> <chr> <date>     <chr> <dbl>    <dbl>      <dbl>
#>  1 washin… http… <a href…  1987 1987… 1987-09-03 minu…  31.0     0          31.0
#>  2 washin… http… <a href…  1987 1987… 1987-09-26 minu…  30.0     0          30.0
#>  3 richmo… http… <a href…  1987 1987… 1987-10-07 minu…  37.0     0          37.0
#>  4 washin… http… <a href…  1987 1987… 1987-10-16 minu…  31.8     0          31.8
#>  5 freder… http… <a href…  1987 1987… 1987-11-25 minu…  34.9     0          34.9
#>  6 washin… http… <a href…  1987 1987… 1987-12-03 minu…  45.7     0          45.7
#>  7 norwal… http… <a href…  1987 1987… 1987-12-05 minu…  33.7    -5.55       39.2
#>  8 washin… http… <a href…  1987 1987… 1987-12-28 minu…  52.8     0          52.8
#>  9 flint-… http… <a href…  1988 1988… 1988-01-21 minu…  44.6     0          44.6
#> 10 ypsila… http… <a href…  1988 1988… 1988-01-22 minu…  40.5     0          40.5
#> # ℹ 1,794 more rows
#> # ℹ 15 more variables: other <dbl>, debut <dbl>, farewell <dbl>,
#> #   incumbent <dbl>, fugazi <dbl>, margin_walker <dbl>, three_songs <dbl>,
#> #   repeater <dbl>, steady_diet_of_nothing <dbl>, in_on_the_killtaker <dbl>,
#> #   red_medicine <dbl>, end_hits <dbl>, the_argument <dbl>, furniture <dbl>,
#> #   first_demo <dbl>
```
