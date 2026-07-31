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

  album name, which includes the date, venue, city, subdivision, and
  country

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

- subdivision:

  subdivision, parsed from the album tag text - only ever populated for
  `country=="USA"`, blank otherwise (unlike
  [`shows_data`](https://alexmitrani.github.io/Repeatr/reference/shows_data.md)'s
  `subdivision`, which is sourced from the site's own per-show field and
  also covers Canada/Australia)

- country:

  country

- gid:

  show id

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-cleaned. Parsed by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)
(via
[`fls_tags_importer`](https://alexmitrani.github.io/Repeatr/reference/fls_tags_importer.md))
from the raw `inst/extdata/fls_tags.txt` kid3 MP3-tag export.

## Examples

``` r
fls_tags
#> # A tibble: 24,530 × 11
#> # Rowwise: 
#>    track album song  duration seconds date       venue city  subdivision country
#>    <chr> <chr> <chr> <Period>   <dbl> <date>     <chr> <chr> <chr>       <chr>  
#>  1 01    1987… joe … 1M 22S        82 1987-09-03 Wils… Wash… DC          USA    
#>  2 02    1987… intro 56S           56 1987-09-03 Wils… Wash… DC          USA    
#>  3 03    1987… song… 2M 46S       166 1987-09-03 Wils… Wash… DC          USA    
#>  4 04    1987… furn… 6M 32S       392 1987-09-03 Wils… Wash… DC          USA    
#>  5 05    1987… merc… 3M 10S       190 1987-09-03 Wils… Wash… DC          USA    
#>  6 06    1987… turn… 4M 56S       296 1987-09-03 Wils… Wash… DC          USA    
#>  7 07    1987… in d… 3M 25S       205 1987-09-03 Wils… Wash… DC          USA    
#>  8 08    1987… wait… 3M 52S       232 1987-09-03 Wils… Wash… DC          USA    
#>  9 09    1987… the … 4M 59S       299 1987-09-03 Wils… Wash… DC          USA    
#> 10 01    1987… intro 2M 37S       157 1987-09-26 St. … Wash… DC          USA    
#> # ℹ 24,520 more rows
#> # ℹ 1 more variable: gid <chr>
```
