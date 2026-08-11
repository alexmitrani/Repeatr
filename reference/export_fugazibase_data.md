# Exports fugazibase's data/\*.rda objects from Repeatr's own cleaned data

Composes fugazibase's six published tables (`shows`, `locations`,
`durations`, `discography`, `songs`, `bands`) from Repeatr's own
already-saved `data/*.rda` objects (the "Derived-cleaned" tier produced
by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md),
which already includes the `price`/`currency` split and the
Brazilian/`NA`-standardized `subdivision` values) and from
`inst/extdata/fls_venue_geocoding_v2.csv` directly - no re-derivation or
new business logic, just selecting, renaming, and joining columns
Repeatr itself already computed. Also runs basic integrity checks (no
missing/duplicate id columns) on each table just before it's written,
aborting the export if any fail. Writes each table as a `data/*.rda`
(lazy-loadable) file directly into a local `fugazibase` checkout. Does
not commit or push anything in that checkout - review and commit
fugazibase's changes separately.

Excludes anything joined/summarized/modeled (e.g. `xray`,
`duration_summary`, `Repeatr1`, and everything from
[`Repeatr_2`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md)
onward) and the copyrighted free-text show notes (`fls_notes`, scraped
from the Fugazi Live Series site - see fugazibase's own `LICENSE`) - see
[`vignette("Data-Provenance")`](https://alexmitrani.github.io/Repeatr/articles/Data-Provenance.md)
for the full tier catalogue.

## Usage

``` r
export_fugazibase_data(fugazibase_dir, repeatr_data_dir = NULL)
```

## Arguments

- fugazibase_dir:

  Path to a local `fugazibase` checkout. Required - there is no default,
  so a caller's own local path is never hardcoded here.

- repeatr_data_dir:

  Optional directory to read Repeatr's own already- saved `data/*.rda`
  objects from. If omitted, defaults to `data/` under the current
  working directory (the package root, after a
  [`Repeatr_Updatr`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_Updatr.md)
  run).

## Value

Invisibly, a named list of the six objects written. As a side effect,
writes `fugazibase_dir/data/*.rda`.

## Examples

``` r
if (FALSE) { # \dontrun{
export_fugazibase_data(fugazibase_dir = "../fugazibase")
} # }
```
