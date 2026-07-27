# Fugazi Live Series summary data on bands that fugazi played with, one row per combination of year, tour and band, with corresponding number of shows.

Fugazi Live Series summary data on bands that fugazi played with, one
row per combination of year, tour and band, with corresponding number of
shows.

## Usage

``` r
played_with_summary
```

## Format

dataframe with one row for each band that Fugazi played with in the
Fugazi Live Series shows with data.

- year:

  year

- tour:

  tour

- played_with:

  band name

- shows:

  number of shows

## Source

https://www.dischord.com/fugazi_live_series

https://arquivomotor.wordpress.com/1994/08/12/bhrif-programacao/

## Examples

``` r
played_with_summary
#> # A tibble: 1,272 × 4
#>     year tour                                   played_with       shows
#>    <dbl> <chr>                                  <chr>             <int>
#>  1  1992 1992 Spring European Tour              Tech Ahead           17
#>  2  1996 1996 Southern USA Tour                 Branch Manager       17
#>  3  1990 1990 Fall European Tour                Urge                 14
#>  4  1991 1991 Summer/Fall USA/Canada Tour       Nation of Ulysses    13
#>  5  1993 1993 Winter Southern USA Tour          Shudder to Think     13
#>  6  1997 1997 Summer Australia/New Zealand Tour NA                   13
#>  7  1999 1999 Fall European Tour                NA                   13
#>  8  1990 1990 Spring/Summer USA Tour            Beat Happening       12
#>  9  1993 1993 Fall USA/Canada Tour              Shudder to Think     11
#> 10  1995 1995 Spring/Summer European Tour       NA                   11
#> # ℹ 1,262 more rows
```
