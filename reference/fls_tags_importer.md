# imports a .txt file of duration data, converts the duration variable to hh:mm:ss (hms) format, and exports the resulting data to an rda file.

fls_tags_importer is used to import a .txt file of duration data
generated with kid3 audio tagger (https://kid3.kde.org/)

## Usage

``` r
fls_tags_importer(myfilename = NULL)
```

## Arguments

- myfilename:

  the full path and filename of the file to be imported and converted.

## Value

A data frame of the imported tag data (`track`, `artist`, `album`,
`name`, `duration`), with `duration` parsed into an hms `Period` and
`seconds`/`minutes` columns added.

## Details

fls_tags_importer

## Examples

``` r
fls_tags_importer(myfilename = system.file("extdata", "fls_tags.txt", package = "Repeatr"))
#> Rows: 24531 Columns: 5
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ";"
#> chr (5): track, artist, album, name, duration
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#> # A tibble: 24,531 × 7
#>    track artist album                             name  duration seconds minutes
#>    <chr> <chr>  <chr>                             <chr> <Period>   <dbl>   <dbl>
#>  1 01    Fugazi 19870903 Wilson Center, Washingt… Joe … 1M 22S        82    1.37
#>  2 02    Fugazi 19870903 Wilson Center, Washingt… Intro 56S           56    0.93
#>  3 03    Fugazi 19870903 Wilson Center, Washingt… Song… 2M 46S       166    2.77
#>  4 04    Fugazi 19870903 Wilson Center, Washingt… Furn… 6M 32S       392    6.53
#>  5 05    Fugazi 19870903 Wilson Center, Washingt… Merc… 3M 10S       190    3.17
#>  6 06    Fugazi 19870903 Wilson Center, Washingt… Turn… 4M 56S       296    4.93
#>  7 07    Fugazi 19870903 Wilson Center, Washingt… In D… 3M 25S       205    3.42
#>  8 08    Fugazi 19870903 Wilson Center, Washingt… Wait… 3M 52S       232    3.87
#>  9 09    Fugazi 19870903 Wilson Center, Washingt… the … 4M 59S       299    4.98
#> 10 01    Fugazi 19870926 St. Stephen's Church Ca… Intro 2M 37S       157    2.62
#> # ℹ 24,521 more rows

```
