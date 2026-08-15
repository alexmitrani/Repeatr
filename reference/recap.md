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
prose-summary facts), `tracklist` (a dataframe with one row per song on
the recording, or `NULL` if no recording exists) and `release_breakdown`
(a dataframe of song counts by release for this show, or `NULL` if no
recording exists).

## Examples

``` r
result <- recap(mygid = "washington-dc-usa-13196")
result$context$where_played
#> [1] "9:30 Club, Washington, DC, USA"
result$tracklist
#> # A tibble: 19 × 10
#>    track_number title             minutes minutes_max release_title release_date
#>           <int> <chr>               <dbl>       <dbl> <chr>         <date>      
#>  1            3 brendan #1           3.18        4.13 repeater      1990-03-01  
#>  2            2 bed for the scra…    2.88        5.03 red medicine  1995-05-12  
#>  3            1 do you like me       2.5         6.48 red medicine  1995-05-12  
#>  4            2 and the same         4.48        8.57 margin walker 1989-06-15  
#>  5            1 margin walker        2.73        5.1  margin walker 1989-06-15  
#>  6            9 styrofoam            2.87        8.55 repeater      1990-03-01  
#>  7            6 caustic acrostic     2.43        2.65 end hits      1998-04-24  
#>  8           11 shut the door        8.63       11.8  repeater      1990-03-01  
#>  9            5 forensic scene       3.43        5.13 red medicine  1995-05-12  
#> 10            8 by you               4.62        6.2  red medicine  1995-05-12  
#> 11            9 great cop            1.75        3.33 in on the ki… 1993-06-18  
#> 12           10 target               3.82        5.85 red medicine  1995-05-12  
#> 13           11 instrument           3.52        7.57 in on the ki… 1993-06-18  
#> 14            2 public witness p…    1.87        4.13 in on the ki… 1993-06-18  
#> 15           11 back to base         1.87        2.67 red medicine  1995-05-12  
#> 16            7 fell, destroyed      4.52        5.55 red medicine  1995-05-12  
#> 17            7 long division        2.62        5.95 steady diet … 1991-08-01  
#> 18            9 version              5.82        7.4  red medicine  1995-05-12  
#> 19            8 two beats off        8.32        8.32 repeater      1990-03-01  
#> # ℹ 4 more variables: rendition_number <int>, renditions <int>, position <dbl>,
#> #   position_mean <dbl>
```
