# Fugazi releases data

Fugazi releases data

## Usage

``` r
releasesdatalookup
```

## Format

dataframe with one row for each release.

- releaseid:

  numeric id in ascending chronological order

- release:

  release name

- variable:

  release names for use as variable names

- releasedate:

  release date

- release_date_source:

  source of the release date

- colour_code:

  hex colour code to be used for the release in graphs

- rym_rating:

  RYM rating scaled to the interval between 0 and 1

## Provenance

Derived-cleaned. Produced by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)
from `inst/extdata/releases.csv` (which itself carries a
manually-assigned `colour_code` and an `rym_rating` sourced from
rateyourmusic.com). Exported (minus `colour_code`, `variable`,
`rym_rating`, minus the four synthetic UI-bucket rows) as fugazi.db's
`discography` table by
[`export_fugazidb_data`](https://alexmitrani.github.io/Repeatr/reference/export_fugazidb_data.md).

## Examples

``` r
releasesdatalookup
#>    releaseid                release               variable releasedate
#> 1          1                 fugazi                 fugazi  1988-11-19
#> 2          2          margin walker          margin_walker  1989-06-15
#> 3          3                3 songs            three_songs  1989-12-01
#> 4          4               repeater               repeater  1990-03-01
#> 5          5 steady diet of nothing steady_diet_of_nothing  1991-08-01
#> 6          6    in on the killtaker    in_on_the_killtaker  1993-06-18
#> 7          7           red medicine           red_medicine  1995-05-12
#> 8          8               end hits               end_hits  1998-04-24
#> 9          9           the argument           the_argument  2001-10-16
#> 10        10              furniture              furniture  2001-10-16
#> 11        11             first demo             first_demo  2014-11-18
#> 12        12               released               released        <NA>
#> 13        13             unreleased             unreleased        <NA>
#> 14        14                  songs                  songs        <NA>
#> 15        15                  other                  other        <NA>
#>                                                           release_date_source
#> 1                         https://rateyourmusic.com/release/ep/fugazi/fugazi/
#> 2                          https://www.dischord.com/release/035/margin-walker
#> 3  https://musicbrainz.org/release-group/43766318-cb47-4398-a877-0bfcbb09ad5a
#> 4                          https://fugazi.bandcamp.com/album/repeater-3-songs
#> 5                    https://fugazi.bandcamp.com/album/steady-diet-of-nothing
#> 6                         https://www.officialcharts.com/artist/33439/fugazi/
#> 7                         https://www.officialcharts.com/artist/33439/fugazi/
#> 8                         https://www.officialcharts.com/artist/33439/fugazi/
#> 9  https://musicbrainz.org/release-group/7b1cb5fb-7ba5-3472-a687-1cb8f2d896e7
#> 10 https://musicbrainz.org/release-group/4042fe4e-0444-338b-9f2a-ac80faabcb1f
#> 11 https://musicbrainz.org/release-group/753fb03e-65f5-4805-afe9-373ed573cf87
#> 12                                                                           
#> 13                                                                           
#> 14                                                                           
#> 15                                                                           
#>    colour_code rym_rating
#> 1      #80110e      0.796
#> 2      #f1bd98      0.744
#> 3      #6a5662      0.656
#> 4      #546084      0.774
#> 5      #9a5715      0.708
#> 6      #e6ca6f      0.756
#> 7      #c02118      0.762
#> 8      #5b734d      0.734
#> 9      #99c3cb      0.778
#> 10     #d15743      0.734
#> 11     #adb56a      0.726
#> 12     #009e73         NA
#> 13     #e69f00         NA
#> 14     #e8853a         NA
#> 15     #8a8784         NA
```
