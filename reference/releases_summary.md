# Releases Summary

Releases Summary

## Usage

``` r
releases_summary
```

## Format

dataframe with one row for each release in the Fugazi discography.

- release:

  The name of the release.

- first_debut:

  the date of the first debut from this release

- last_debut:

  the date of the last debut from this release

- release_date:

  this is an assumption based on the available evidence. Actual release
  dates will have been different in different places.

- songs:

  number of songs on the release

- count:

  total number of performances of the songs on the release

- shows:

  number of shows at which songs from the release were performed

- rate:

  the average of the rates for the songs on the release

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
  releases_summary
#> # A tibble: 12 × 10
#>    releaseid release       first_debut last_debut release_date songs count shows
#>        <int> <fct>         <date>      <date>     <date>       <int> <int> <dbl>
#>  1         1 fugazi        1987-09-03  1988-06-15 1988-11-19       7  2195   889
#>  2         2 margin walker 1987-09-26  1988-11-14 1989-06-15       6  1574   878
#>  3         3 3 songs       1987-09-03  1987-10-16 1989-12-01       3   588   898
#>  4         4 repeater      1987-09-03  1990-05-17 1990-03-01      11  3887   846
#>  5         5 steady diet … 1987-10-07  1991-04-12 1991-08-01      11  2455   752
#>  6         6 in on the ki… 1991-07-28  1993-02-05 1993-06-18      12  2559   565
#>  7         7 red medicine  1993-04-24  1994-11-27 1995-05-12      13  2055   392
#>  8         8 end hits      1996-01-30  1998-05-01 1998-04-24      13  1361   221
#>  9         9 the argument  1998-11-29  2001-06-21 2001-10-16      10   430    79
#> 10        10 furniture     1987-09-03  2001-04-27 2001-10-16       3   206   363
#> 11        11 first demo    1987-09-03  1987-09-03 2014-11-18       3    71   899
#> 12        13 unreleased    1988-10-31  1996-01-30 NA               2     8   560
#> # ℹ 2 more variables: intensity <dbl>, rating <dbl>
```
