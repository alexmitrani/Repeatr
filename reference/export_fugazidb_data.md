# Exports fugazi.db's data/\*.rda objects from Repeatr's own cleaned data

Composes fugazi.db's six published tables (`shows`, `locations`,
`durations`, `discography`, `songs`, `bands`) from Repeatr's own
already-saved `data/*.rda` objects (the "Derived-cleaned" tier produced
by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md))
and from
`inst/extdata/fls_venue_geocoding_v2.csv`/`fls_doorprice_currency_lookup.csv`
directly - almost no re-derivation or new business logic, with two
small, documented exceptions confined to `shows$subdivision`: Brazilian
state codes are filled in (Repeatr's own scrape never populates a
subdivision outside the US/Canada/Australia) from a hand-verified city
lookup, and any remaining blank subdivision (a pre-existing mix of `NA`
and `""`) is standardized to `NA`. Also runs basic integrity checks (no
missing/ duplicate id columns) on each table just before it's written,
aborting the export if any fail. Writes each table as a `data/*.rda`
(lazy-loadable) file directly into a local `fugazi.db` checkout. Does
not commit or push anything in that checkout - review and commit
fugazi.db's changes separately.

Excludes anything joined/summarized/modeled (e.g. `xray`,
`duration_summary`, `Repeatr1`, and everything from
[`Repeatr_2`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md)
onward) and the copyrighted free-text show notes (`fls_notes`, scraped
from the Fugazi Live Series site - see fugazi.db's own `LICENSE`) - see
[`vignette("Data-Provenance")`](https://alexmitrani.github.io/Repeatr/articles/Data-Provenance.md)
for the full tier catalogue.

## Usage

``` r
export_fugazidb_data(fugazidb_dir, repeatr_data_dir = NULL)
```

## Arguments

- fugazidb_dir:

  Path to a local `fugazi.db` checkout. Required - there is no default,
  so a caller's own local path is never hardcoded here.

- repeatr_data_dir:

  Optional directory to read Repeatr's own already- saved `data/*.rda`
  objects from. If omitted, defaults to `data/` under the current
  working directory (the package root, after a
  [`Repeatr_Updatr`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_Updatr.md)
  run).

## Value

Invisibly, a named list of the six objects written. As a side effect,
writes `fugazidb_dir/data/*.rda`.

## Examples

``` r
if (FALSE) { # \dontrun{
export_fugazidb_data(fugazidb_dir = "../fugazi.db")
} # }
```
