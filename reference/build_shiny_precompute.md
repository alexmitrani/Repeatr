# Precompute Fugazetteer's build-time-only Shiny inputs

Builds and saves the handful of `data/*.rda` objects that exist purely
so `inst/shiny/Fugazetteer/app.R` doesn't have to redo, on every app
start, joins/aggregations that never touch the app's three live Google
Sheets reads (`fls_venue_geocoding`, `quizdata`, `linktracksindexdata`).
These are Shiny-presentation-only cached views, not part of Repeatr's
canonical data model and not exported to fugazibase - see
[`vignette("Data-Provenance")`](https://alexmitrani.github.io/Repeatr/articles/Data-Provenance.md)
and the `Provenance` section on each object's own help page (e.g.
[`?shiny_shows_data_base`](https://alexmitrani.github.io/Repeatr/reference/shiny_shows_data_base.md)).
Mirrors the exact joins `app.R` used to run inline; if `app.R`'s
sheet-independent preprocessing ever changes, update both together.

## Usage

``` r
build_shiny_precompute(output_dir = NULL)
```

## Arguments

- output_dir:

  where to save the rebuilt `data/*.rda` objects. If omitted, defaults
  to `data/` under the current working directory.

## Value

Invisibly, `NULL`. The real effect is writing the `shiny_*.rda` files.

## Examples

``` r
if (FALSE) { # \dontrun{
build_shiny_precompute()
} # }
```
