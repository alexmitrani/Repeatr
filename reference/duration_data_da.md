# Duration Data

Duration Data

## Usage

``` r
duration_data_da
```

## Format

dataframe with one row for each rendition of each song in the Fugazi
Live Series data.

- gid:

  Unique identifier for the show

- date:

  The date of the show.

- song_number:

  this is the number of the song in the set, where 1 is the first song
  in that show. Larger numbers will indicate that the song was played
  later in the set,

- song:

  the name of the song

- urls:

  A string used to form the URLs of the corresponding page on the Fugazi
  Live series site.

- fls_link:

  a link to the corresponding page of the Fugazi Live Series site.

- minutes:

  duration of the song in minutes

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
  duration_data_da
#> # A tibble: 17,391 × 7
#>    gid                 date       song_number song        urls  fls_link minutes
#>    <chr>               <date>           <dbl> <chr>       <chr> <chr>      <dbl>
#>  1 aalst-belgium-92390 1990-09-23           2 turnover    http… <a href…    4.43
#>  2 aalst-belgium-92390 1990-09-23           3 brendan #1  http… <a href…    2.93
#>  3 aalst-belgium-92390 1990-09-23           4 merchandise http… <a href…    3.07
#>  4 aalst-belgium-92390 1990-09-23           5 sieve-fist… http… <a href…    3.58
#>  5 aalst-belgium-92390 1990-09-23           6 and the sa… http… <a href…    4.3 
#>  6 aalst-belgium-92390 1990-09-23           8 bulldog fr… http… <a href…    2.75
#>  7 aalst-belgium-92390 1990-09-23           9 burning too http… <a href…    2.72
#>  8 aalst-belgium-92390 1990-09-23          11 suggestion  http… <a href…    6.4 
#>  9 aalst-belgium-92390 1990-09-23          13 reclamation http… <a href…    3.52
#> 10 aalst-belgium-92390 1990-09-23          14 blueprint   http… <a href…    4.33
#> # ℹ 17,381 more rows
```
