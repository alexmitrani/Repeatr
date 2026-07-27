# takes a dataframe with one row per show-song and reshapes it long again so that the rows are identified by combinations of gid, song_number, and songid.

The first line of the data this was originally developed with:

washington-dc-usa-90387 FLS0001 03/09/1987 Wilson Center \$5 300 Joey
Picuri Fugazi Cassette Joe \#1 Intro Song \#1 Furniture Merchandise Turn
Off Your Guns In Defense Of Humans Waiting Room The Word

"gid" is short for "gig id"

## Usage

``` r
Repeatr_2(mydf = NULL)
```

## Arguments

- mydf:

  optional dataframe to be used. If omitted the default dataframe will
  be used.

## Value

A data frame (`Repeatr2`) with one row per gid/song_number/songid
combination, prepared for choice modelling: includes `case`
(choice-situation id), `alt` (song id, renamed from `songid`), `choice`
(whether that song was the one played, renamed from `chosen`),
availability/played dummy variables, and years-since-launch bucket
variables. Also saved to `data/Repeatr2.rda`, alongside
`fugazi_song_counts` and `fugazi_song_performance_intensity`.

## Examples

``` r
Repeatr2 <- Repeatr_2(mydf = Repeatr1)
#> Joining with `by = join_by(songid)`
#> Error in setwd(myinputdir): cannot change working directory
```
