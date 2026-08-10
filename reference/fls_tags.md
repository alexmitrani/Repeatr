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

- song:

  track name

- duration:

  duration in period format (lubridate)

- seconds:

  duration in seconds

- date:

  date

- gid:

  show id

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-cleaned. Parsed by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)
(via
[`fls_tags_importer`](https://alexmitrani.github.io/Repeatr/reference/fls_tags_importer.md))
from the raw `inst/extdata/fls_tags.txt` kid3 MP3-tag export. The
underlying track/album/song names themselves are sourced from the Fugazi
Live Series site, not personal data - Alex Mitrani applied a consistent
album-name format and a handful of one-off track-title corrections on
top (see the "process tags data" section of
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)).
The raw `album` tag text (`YYYYMMDD Venue, City, State, Country`) is
used internally to parse `venue`/`city`/`subdivision`/`country` for a
couple of mistagged-track filters and to derive
[`fls_tags_show`](https://alexmitrani.github.io/Repeatr/reference/fls_tags_show.md),
but those fields (and `album` itself) are dropped before saving, since
parsing them by counting commas silently misparses whenever a venue or
city name itself contains a comma (e.g. Ypsilanti, Flint, Eau Claire,
Osaka), and
[`shows_data`](https://alexmitrani.github.io/Repeatr/reference/shows_data.md)
(joined via `gid`) is the sole authoritative source for them. Exported
(minus `date` - join fugazi.db's `shows` on `gid` instead - and
`seconds`, which duplicated `duration`; `track` converted from character
to integer) as fugazi.db's `durations` table by
[`export_fugazidb_data`](https://alexmitrani.github.io/Repeatr/reference/export_fugazidb_data.md).

## Examples

``` r
fls_tags
#> # A tibble: 24,530 × 6
#> # Rowwise: 
#>    track song                 duration seconds date       gid                   
#>    <chr> <chr>                <Period>   <dbl> <date>     <chr>                 
#>  1 01    joe #1               1M 22S        82 1987-09-03 washington-dc-usa-903…
#>  2 02    intro                56S           56 1987-09-03 washington-dc-usa-903…
#>  3 03    song #1              2M 46S       166 1987-09-03 washington-dc-usa-903…
#>  4 04    furniture            6M 32S       392 1987-09-03 washington-dc-usa-903…
#>  5 05    merchandise          3M 10S       190 1987-09-03 washington-dc-usa-903…
#>  6 06    turn off your guns   4M 56S       296 1987-09-03 washington-dc-usa-903…
#>  7 07    in defense of humans 3M 25S       205 1987-09-03 washington-dc-usa-903…
#>  8 08    waiting room         3M 52S       232 1987-09-03 washington-dc-usa-903…
#>  9 09    the word             4M 59S       299 1987-09-03 washington-dc-usa-903…
#> 10 01    intro                2M 37S       157 1987-09-26 washington-dc-usa-926…
#> # ℹ 24,520 more rows
```
