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
  myplayed_with = NULL,
  myothervariables = NULL,
  mytransitions_data_da = NULL,
  myfls_tags = NULL
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

- myothervariables:

  optional `othervariables` dataframe (as produced by
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md))
  to be used for recording credits (recorded by/mastered by/original
  source). If omitted the currently lazy-loaded default will be used.

- mytransitions_data_da:

  optional `transitions_data_da` dataframe (as produced by
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md))
  to be used for song-to-song transition occurrence counts. If omitted
  the currently lazy-loaded default will be used.

- myfls_tags:

  optional `fls_tags` dataframe (as produced by
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md))
  to be used for the raw per-track tagged duration of non-song tracks
  (interludes, intro/outro, etc.), which have no duration elsewhere. If
  omitted the currently lazy-loaded default will be used.

## Value

A list of three elements: `context` (a named list of the show's
prose-summary facts, including ready-made
`paragraph1`/`paragraph2`/`paragraph3` strings), `tracklist` (a
dataframe with one row per track on the recording, songs and non-song
tracks alike, or `NULL` if no recording exists) and `release_breakdown`
(a dataframe of song counts by release for this show, or `NULL` if no
recording exists).

## Examples

``` r
result <- recap(mygid = "washington-dc-usa-13196")
result$context$where_played
#> [1] "9:30 Club, Washington, DC, USA"
result$tracklist
#> # A tibble: 24 × 11
#>    track title          minutes mins_mean position pos_mean rendition renditions
#>    <dbl> <chr>            <dbl>     <dbl>    <dbl>    <dbl>     <int>      <int>
#>  1     1 opening remar…    3.32     NA       NA       NA           NA         NA
#>  2     2 brendan #1        3.18      2.95     0        0.17       161        170
#>  3     3 bed for the s…    2.88      3.03     0.05     0.4        123        310
#>  4     4 do you like me    2.5       2.69     0.1      0.34       107        282
#>  5     5 and the same      4.48      4.46     0.14     0.19       301        397
#>  6     6 margin walker     2.73      2.7      0.19     0.45       384        467
#>  7     7 styrofoam         2.87      2.85     0.24     0.29       242        294
#>  8     8 caustic acros…    2.43      2.07     0.29     0.4          2         53
#>  9     9 interlude 1       0.78     NA       NA       NA           NA         NA
#> 10    10 shut the door     8.63      6.56     0.38     0.7        304        342
#> # ℹ 14 more rows
#> # ℹ 3 more variables: transition <int>, transitions <int>, release_date <date>
```
