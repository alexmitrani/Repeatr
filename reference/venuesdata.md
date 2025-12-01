# Venues data

Venues data

## Usage

``` r
venuesdata
```

## Format

dataframe with one row for each venue in the Fugazi Live Series data.

- venue:

  Venue of the show

- city:

  City

- country:

  Country

- from:

  Year of first show at the venue

- to:

  Year of last show at the venue

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
  venuesdata
#> # A tibble: 733 × 6
#>    venue         city        country shows  from    to
#>    <chr>         <chr>       <chr>   <int> <dbl> <dbl>
#>  1 Fort Reno     Washington  USA        12  1988  2002
#>  2 9:30 Club     Washington  USA        11  1988  2001
#>  3 Liberty Lunch Austin      USA         9  1988  1998
#>  4 40 Watt       Athens      USA         8  1988  1999
#>  5 First Avenue  Minneapolis USA         8  1991  2001
#>  6 Maxwell's     Hoboken     USA         8  1988  1998
#>  7 Wilson Center Washington  USA         8  1987  1997
#>  8 Masquerade    Atlanta     USA         7  1990  1999
#>  9 Cat's Cradle  Chapel Hill USA         6  1987  1993
#> 10 dc space      Washington  USA         6  1987  1991
#> # ℹ 723 more rows
```
