# Transitions Data

Transitions Data

## Usage

``` r
transitions_data_da
```

## Format

dataframe with one row for each combination of show, first song and
second song in the Fugazi Live Series data.

- gid:

  gig id. This is a concatenation of city, country, and date

- url:

  url to the corresponding page of the Fugazi Live Series site.

- fls_link:

  provides a link to the corresponding page of the Fugazi Live Series
  site

- date:

  date of the show

- transition:

  Number of the transition in the show

- song1:

  Name of the first song

- song2:

  Name of the second song

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
  transitions_data_da
#> # A tibble: 12,052 × 7
#>    gid                 url                 fls_link date  transition song1 song2
#>    <chr>               <chr>               <chr>    <chr>      <int> <chr> <chr>
#>  1 aalst-belgium-92390 https://www.discho… <a href… 1990…          2 turn… bren…
#>  2 aalst-belgium-92390 https://www.discho… <a href… 1990…          3 bren… merc…
#>  3 aalst-belgium-92390 https://www.discho… <a href… 1990…          4 merc… siev…
#>  4 aalst-belgium-92390 https://www.discho… <a href… 1990…          5 siev… and …
#>  5 aalst-belgium-92390 https://www.discho… <a href… 1990…          8 bull… burn…
#>  6 aalst-belgium-92390 https://www.discho… <a href… 1990…         13 recl… blue…
#>  7 aalst-belgium-92390 https://www.discho… <a href… 1990…         14 blue… shut…
#>  8 aalst-belgium-92390 https://www.discho… <a href… 1990…         15 shut… two …
#>  9 aalst-belgium-92390 https://www.discho… <a href… 1990…         16 two … repr…
#> 10 aalst-belgium-92390 https://www.discho… <a href… 1990…         21 runa… repe…
#> # ℹ 12,042 more rows
```
