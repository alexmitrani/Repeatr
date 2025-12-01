# Tags data

Tags data

## Usage

``` r
fls_tags
```

## Format

dataframe with one row for each track in the Fugazi Live Series data,
including data from the audio file tags.

- track:

  track number

- album:

  album name, which includes the date, venue, city, state, and country

- song:

  track name

- duration:

  duration in period format (lubridate)

- seconds:

  duration in seconds

- minutes:

  duration in decimal minutes

- date:

  date

- venue:

  venue

- city:

  city

- state:

  state for USA shows

- country:

  country

- gid:

  show id

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
  fls_tags
#> # A tibble: 23,258 × 11
#> # Rowwise: 
#>    track album song  duration seconds date       venue city  state country gid  
#>    <chr> <chr> <chr> <Period>   <dbl> <date>     <chr> <chr> <chr> <chr>   <chr>
#>  1 01    1987… joe … 1M 22S        82 1987-09-03 Wils… Wash… DC    USA     wash…
#>  2 02    1987… intro 56S           56 1987-09-03 Wils… Wash… DC    USA     wash…
#>  3 03    1987… song… 2M 46S       166 1987-09-03 Wils… Wash… DC    USA     wash…
#>  4 04    1987… furn… 6M 32S       392 1987-09-03 Wils… Wash… DC    USA     wash…
#>  5 05    1987… merc… 3M 10S       190 1987-09-03 Wils… Wash… DC    USA     wash…
#>  6 06    1987… turn… 4M 56S       296 1987-09-03 Wils… Wash… DC    USA     wash…
#>  7 07    1987… in d… 3M 25S       205 1987-09-03 Wils… Wash… DC    USA     wash…
#>  8 08    1987… wait… 3M 52S       232 1987-09-03 Wils… Wash… DC    USA     wash…
#>  9 09    1987… the … 4M 59S       299 1987-09-03 Wils… Wash… DC    USA     wash…
#> 10 01    1987… intro 2M 37S       157 1987-09-26 St. … Wash… DC    USA     wash…
#> # ℹ 23,248 more rows
```
