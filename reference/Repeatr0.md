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

- tour:

  The touring period the show belongs to (e.g. "1988 Fall European
  Tour"), scraped from the FLS listing pages' own tour headings - see
  [`scrape_fls_listing_data`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_listing_data.md).

- city:

  City, scraped from the FLS listing pages - see
  [`scrape_fls_listing_data`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_listing_data.md).
  Not yet disambiguated for cities that share a name with another tour
  stop (Portland, Columbia, etc.) - see
  [`othervariables`](https://alexmitrani.github.io/Repeatr/reference/othervariables.md)
  for the disambiguated version.

- subdivision:

  Subnational administrative unit (US state, DC, Canadian province, or
  Australian state/territory), where applicable (`NA` outside those
  three countries) - see
  [`scrape_fls_listing_data`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_listing_data.md).

- country:

  Country, scraped from the FLS listing pages - see
  [`scrape_fls_listing_data`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_listing_data.md).

- track_1-track_n:

  Tracks, one column per track slot up to the widest tracklist in the
  data

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-cleaned. Produced by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)
from the raw scrape
([`scrape_fls_shows`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_shows.md));
typed/cleaned, no song classification yet.

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
