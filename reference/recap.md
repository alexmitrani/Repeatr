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
#>    track title     mins mean_mins max_mins release rendition renditions position
#>    <int> <chr>    <dbl>     <dbl>    <dbl> <chr>       <int>      <int>    <dbl>
#>  1     1 brendan…  3.18      2.95     4.13 repeat…       161        170     0   
#>  2     2 bed for…  2.88      3.03     5.03 red me…       123        310     0.05
#>  3     3 do you …  2.5       2.69     6.48 red me…       107        282     0.1 
#>  4     4 and the…  4.48      4.46     8.57 margin…       301        396     0.14
#>  5     5 margin …  2.73      2.7      5.1  margin…       384        464     0.19
#>  6     6 styrofo…  2.87      2.85     8.55 repeat…       242        292     0.24
#>  7     7 caustic…  2.43      2.07     2.65 end hi…         2         53     0.29
#>  8     8 shut th…  8.63      6.56    11.8  repeat…       304        340     0.38
#>  9     9 forensi…  3.43      3.36     5.13 red me…       116        204     0.43
#> 10    10 by you    4.62      4.38     6.2  red me…       136        237     0.48
#> 11    11 great c…  1.75      1.92     3.33 in on …       197        277     0.57
#> 12    12 target    3.82      3.86     5.85 red me…       104        267     0.62
#> 13    13 instrum…  3.52      3.59     7.57 in on …       218        282     0.67
#> 14    14 public …  1.87      2        4.13 in on …       138        274     0.76
#> 15    15 back to…  1.87      1.75     2.67 red me…        72        142     0.81
#> 16    16 fell, d…  4.52      3.96     5.55 red me…       112        137     0.86
#> 17    17 long di…  2.62      2.52     5.95 steady…       348        522     0.9 
#> 18    18 version   5.82      5.01     7.4  red me…         9         36     0.95
#> 19    19 two bea…  8.32      4.62     8.32 repeat…       356        390     1   
#> # ℹ 1 more variable: mean_pos <dbl>
```
