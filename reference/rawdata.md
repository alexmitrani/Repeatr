# Fugazi Live Series raw data

This data was scraped from the Fugazi Live Series website by Carni Klirs
for his project "Visualizing the History of Fugazi".

## Usage

``` r
rawdata
```

## Format

dataframe with one row for each show.

- year:

  year of the show

- V1:

  show id

- V2:

  Fugazi Live Series id

- V3:

  Show date

- V4:

  Venue

- V5:

  Door price

- V6:

  Attendance

- V7:

  Recorded by

- V8:

  Mastered by

- V9:

  Original source

- V10-V50:

  Tracks

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
# What is the total number of people that Fugazi performed for in the shows that are available in the Fugazi Live Series data?
test <- rawdata
test <- test %>% mutate(attendancedata = nchar(V6))
test <- test %>% filter(attendancedata>0)
test <- test %>% mutate(attendance = as.numeric(V6))
#> Warning: There was 1 warning in `mutate()`.
#> ℹ In argument: `attendance = as.numeric(V6)`.
#> Caused by warning:
#> ! NAs introduced by coercion
test <- test %>% filter(is.na(attendance)==FALSE)
totalpeople <- sum(test$attendance)
totalpeople
#> [1] 885250
```
