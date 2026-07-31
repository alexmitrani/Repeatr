# Tags data, one record per show

Tags data, one record per show

## Usage

``` r
fls_tags_show
```

## Format

dataframe with one row for each show in the Fugazi Live Series data,
including data from the audio file tags.

- gid:

  show id

- album:

  album name, which includes the date, venue, city, subdivision, and
  country

- duration:

  duration in period format (lubridate)

- seconds:

  duration in seconds

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-cleaned. Produced by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)
from `fls_tags`, grouped by `(gid, album)`. Deliberately does not carry
its own venue/city/subdivision/country/date - those are independently
re-parsed from the album tag text by counting commas, which silently
misparses whenever a venue or city name itself contains a comma (e.g.
Ypsilanti, Flint, Eau Claire, Osaka).
[`shows_data`](https://alexmitrani.github.io/Repeatr/reference/shows_data.md)
(joined via `gid`) is the sole authoritative source for those fields.

## Examples

``` r
fls_tags_show
#> # A tibble: 952 × 4
#>    gid                          album                         duration   seconds
#>    <chr>                        <chr>                         <Period>     <dbl>
#>  1 aalst-belgium-92390          19900923 Netwerk, Aalst, Bel… 1H 13M 33S    4413
#>  2 aberdeen-scotland-50499      19990504 Lemon Tree, Aberdee… 1H 18M 54S    4734
#>  3 adelaide-australia-111193    19931111 Dom Polski Hall, Ad… 46M 49S       2809
#>  4 adelaide-australia-111296    19961112 Adelaide University… 1H 17M 8S     4628
#>  5 adelaide-sa-australia-102291 19911022 Le Rox Hotel, Adela… 1H 11M 36S    4296
#>  6 akron-oh-usa-62890           19900628 Jackie Lee's Scoote… 1H 22M 28S    4948
#>  7 albany-ny-usa-92093          19930920 S.U.N.Y. Albany, Al… 1H 19M 41S    4781
#>  8 albuquerque-nm-usa-111395    19951113 Five Points Hall, A… 1H 14M 22S    4462
#>  9 albuquerque-nm-usa-40801     20010408 Sunshine Music Hall… 1H 30M 40S    5440
#> 10 albuquerque-nm-usa-91191     19910911 Sunshine Music Hall… 1H 7M 50S     4070
#> # ℹ 942 more rows
```
