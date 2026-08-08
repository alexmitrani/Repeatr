# nscmov = No satellite could map our veins.

Retired from the rebuild pipeline - venue coordinates are now maintained
directly in `inst/extdata/fls_venue_geocoding_v2.csv` (see
[`vignette("Rebuilding-the-Data")`](https://alexmitrani.github.io/Repeatr/articles/Rebuilding-the-Data.md)),
with no separate to-do-list workflow. Left here for reference; not
called anywhere in
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)/
[`Repeatr_Updatr`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_Updatr.md),
and its default argument will resolve to no file unless called with an
explicit `fls_venue_geocoding_update_filename`.

## Usage

``` r
nscmov(fls_venue_geocoding_update_filename = NULL)
```

## Arguments

- fls_venue_geocoding_update_filename:

  filename of file with which to update coordinates data in
  othervariables.rda

## Value

The updated `othervariables` data frame, with coordinates and `checked`
status refreshed from `fls_venue_geocoding_update_filename`. Also saved
to `data/othervariables.rda`, and writes
`fls_venue_geocoding_update.csv` - a template listing any venues still
unresolved (`checked == 0`) - to the working directory.

## Examples

``` r
if (FALSE) { # \dontrun{
# Retired (see @description above) - kept for reference only. Has no
# output_dir override, so it always writes to data/ under getwd(); not
# safe to run as a documentation example.
fls_venue_geocoding_update <- system.file("extdata", "fls_venue_geocoding_v2.csv", package = "Repeatr")
othervariables <- nscmov(fls_venue_geocoding_update_filename = fls_venue_geocoding_update)
} # }
```
