# Fugazi Live Series data

This data was originally scraped from the Fugazi Live Series website by
Carni Klirs for his project "Visualizing the History of Fugazi", and is
now kept up to date via
[`scrape_fls_shows`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_shows.md).

## Usage

``` r
Repeatr0
```

## Format

dataframe with one row for each show.

- gid:

  show id

- fls_id:

  Fugazi Live Series id

- show_date:

  Show date

- venue:

  Venue

- door_price:

  Door price

- attendance:

  Attendance

- recorded_by:

  Recorded by

- mastered_by:

  Mastered by

- original_source:

  Original source

- sound_quality:

  Sound quality rating: Excellent, Very Good, Good, or Poor

- played_with:

  Bands played with, comma-separated

- fls_notes:

  Any official note shown on the show's page (e.g. "Previously released
  on CD (FLS29)"), NA when the show has none

- track_1-track_n:

  Tracks, one column per track slot up to the widest tracklist in the
  data

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
# What is the total number of people that Fugazi performed for in the shows that are available in the Fugazi Live Series data?
test <- Repeatr0
test <- test %>% mutate(attendancedata = nchar(attendance))
test <- test %>% filter(attendancedata>0)
test <- test %>% mutate(attendance = as.numeric(attendance))
test <- test %>% filter(is.na(attendance)==FALSE)
totalpeople <- sum(test$attendance)
totalpeople
#> [1] 885650
```
