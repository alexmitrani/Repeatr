# recap brings together all the notable facts about a single Fugazi show: date, venue, tour context, how many times the band had previously played in that country/state/city/venue, the previous and next show of the tour, and (if a recording exists) a detailed tracklist with duration, release and rendition statistics.

recap brings together all the notable facts about a single Fugazi show:
date, venue, tour context, how many times the band had previously played
in that country/state/city/venue, the previous and next show of the
tour, and (if a recording exists) a detailed tracklist with duration,
release and rendition statistics.

## Usage

``` r
recap(
  mygid,
  myshows_data = NULL,
  myduration_data_da = NULL,
  myrepeatr1 = NULL,
  myreleasesdatalookup = NULL,
  myduration_summary = NULL,
  myposition_summary = NULL,
  myplayed_with = NULL
)
```

## Arguments

- mygid:

  gig id of the show to recap, as a string, for instance
  "washington-dc-usa-13196".

- myshows_data:

  optional `shows_data` dataframe (as produced by
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md))
  to be used for show/tour/location details. If omitted the currently
  lazy-loaded default will be used.

- myduration_data_da:

  optional `duration_data_da` dataframe (as produced by
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md))
  to be used for recorded renditions, live durations and set position.
  If omitted the currently lazy-loaded default will be used.

- myrepeatr1:

  optional `Repeatr1` dataframe (as produced by
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md))
  to be used for release/track lookups. If omitted the currently
  lazy-loaded default will be used.

- myreleasesdatalookup:

  optional `releasesdatalookup` dataframe (as produced by
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md))
  to be used for release dates. If omitted the currently lazy-loaded
  default will be used.

- myduration_summary:

  optional `duration_summary` dataframe (as produced by
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md))
  to be used for each song's maximum recorded duration and total number
  of recorded renditions. If omitted the currently lazy-loaded default
  will be used.

- myposition_summary:

  optional `position_summary` dataframe (as produced by
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md))
  to be used for each song's average recorded set position. If omitted
  the currently lazy-loaded default will be used.

- myplayed_with:

  optional `played_with` dataframe (as produced by
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md))
  to be used for the bands Fugazi played with at the show. If omitted
  the currently lazy-loaded default will be used.

## Value

A list of three elements: `context` (a named list of the show's
prose-summary facts, including ready-made `paragraph1`/`paragraph2`
strings), `tracklist` (a dataframe with one row per song on the
recording, or `NULL` if no recording exists) and `release_breakdown` (a
dataframe of song counts by release for this show, or `NULL` if no
recording exists).

## Examples

``` r
result <- recap(mygid = "washington-dc-usa-13196")
result$context$where_played
#> [1] "9:30 Club, Washington, DC, USA"
result$tracklist
#> # A tibble: 19 × 10
#>    track title minutes mins_mean mins_max position pos_mean rendition renditions
#>    <int> <chr>   <dbl>     <dbl>    <dbl>    <dbl>    <dbl>     <int>      <int>
#>  1     1 bren…    3.18      2.95     4.13     0        0.17       161        170
#>  2     2 bed …    2.88      3.03     5.03     0.05     0.4        123        310
#>  3     3 do y…    2.5       2.69     6.48     0.1      0.34       107        282
#>  4     4 and …    4.48      4.46     8.57     0.14     0.19       301        396
#>  5     5 marg…    2.73      2.7      5.1      0.19     0.45       384        464
#>  6     6 styr…    2.87      2.85     8.55     0.24     0.29       242        292
#>  7     7 caus…    2.43      2.07     2.65     0.29     0.4          2         53
#>  8     8 shut…    8.63      6.56    11.8      0.38     0.7        304        340
#>  9     9 fore…    3.43      3.36     5.13     0.43     0.66       116        204
#> 10    10 by y…    4.62      4.38     6.2      0.48     0.55       136        237
#> 11    11 grea…    1.75      1.92     3.33     0.57     0.62       197        277
#> 12    12 targ…    3.82      3.86     5.85     0.62     0.48       104        267
#> 13    13 inst…    3.52      3.59     7.57     0.67     0.58       218        282
#> 14    14 publ…    1.87      2        4.13     0.76     0.44       138        274
#> 15    15 back…    1.87      1.75     2.67     0.81     0.49        72        142
#> 16    16 fell…    4.52      3.96     5.55     0.86     0.71       112        137
#> 17    17 long…    2.62      2.52     5.95     0.9      0.62       348        522
#> 18    18 vers…    5.82      5.01     7.4      0.95     0.87         9         36
#> 19    19 two …    8.32      4.62     8.32     1        0.64       356        390
#> # ℹ 1 more variable: release_date <date>
```
