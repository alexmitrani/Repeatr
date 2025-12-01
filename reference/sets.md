# compares the setlists of two or more shows.

sets returns a list with two dataframes

the first is a table with the list of shows in the rows and the shows in
the columns, including a total column showing how many shows each song
was played in. .

the second is a summary table of the number of shows in which songs
appear, with one row per number of shows, the number of songs in each
category, and the proportion of the total number of songs.

## Usage

``` r
sets(mydf = NULL, shows = NULL)
```

## Arguments

- mydf:

  the dataframe to use. must contain the columns "gid" and "song".

- shows:

  a list of show ids

## Details

sets

## Examples

``` r
sets <- sets(mydf = duration_data_da, shows = c("aalst-belgium-92390", "aberdeen-scotland-50499", "leeds-england-103102", "washington-dc-usa-73198"))
sets[[1]]
#> # A tibble: 60 × 6
#>    song      `aalst-belgium-92390` aberdeen-scotland-50…¹ `leeds-england-103102`
#>    <chr>                     <dbl>                  <dbl>                  <dbl>
#>  1 arpeggia…                     0                      1                      1
#>  2 bed for …                     0                      1                      1
#>  3 closed c…                     0                      1                      1
#>  4 reclamat…                     1                      0                      1
#>  5 back to …                     0                      1                      1
#>  6 blueprint                     1                      0                      1
#>  7 break                         0                      1                      0
#>  8 bulldog …                     1                      0                      1
#>  9 foreman'…                     0                      1                      0
#> 10 merchand…                     1                      1                      0
#> # ℹ 50 more rows
#> # ℹ abbreviated name: ¹​`aberdeen-scotland-50499`
#> # ℹ 2 more variables: `washington-dc-usa-73198` <dbl>, shows <dbl>
sets[[2]]
#> # A tibble: 3 × 3
#>   shows songs proportion
#>   <dbl> <int>      <dbl>
#> 1     1    41      0.683
#> 2     2    15      0.25 
#> 3     3     4      0.067
```
