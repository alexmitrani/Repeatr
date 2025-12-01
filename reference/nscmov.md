# nscmov = No satellite could map our veins.

Process for updating coordinates on Shiny app:

1.  pull updated data from github

2.  run nscmov()

3.  run Repeatr_1

4.  Put updated rda files in the data folder

5.  push updates to github

6.  reinstall Repeatr package from github

7.  run shiny app from app.R

8.  reinstall the Shiny app on shinyapps.io

## Usage

``` r
nscmov(fls_venue_geocoding_update_filename = NULL)
```

## Arguments

- fls_venue_geocoding_update_filename:

  filename of file with which to update coordinates data in
  othervariables.rda

## Examples

``` r
fls_venue_geocoding_update <- system.file("extdata", "fls_venue_geocoding.csv", package = "Repeatr")
othervariables <- nscmov(fls_venue_geocoding_update_filename = fls_venue_geocoding_update)
#> Joining with `by = join_by(venue, city, country)`
#> Error in setwd(mydatadir): cannot change working directory
```
