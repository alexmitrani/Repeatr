# nscmov = No satellite could map our veins.

Retired from the rebuild pipeline - venue coordinates are now maintained
directly in
[`fugazi.db::fls_venue_geocoding`](https://rdrr.io/pkg/fugazi.db/man/fls_venue_geocoding.html)
(see
[`vignette("Rebuilding-the-Data")`](https://alexmitrani.github.io/Repeatr/articles/Rebuilding-the-Data.md)),
with no separate to-do-list workflow. Left here for reference; not
called anywhere in
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)/
[`Repeatr_Updatr`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_Updatr.md),
and its default argument will resolve to no file
(`fls_venue_geocoding.csv` no longer ships in this package's
`inst/extdata`) unless called with an explicit
`fls_venue_geocoding_update_filename`.

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
fls_venue_geocoding_update <- system.file("extdata", "fls_venue_geocoding.csv", package = "Repeatr")
othervariables <- nscmov(fls_venue_geocoding_update_filename = fls_venue_geocoding_update)
#> Warning: file("") only supports open = "w+" and open = "w+b": using the former
#> Error in read.table(file = file, header = header, sep = sep, quote = quote,     dec = dec, fill = fill, comment.char = comment.char, ...): no lines available in input
```
