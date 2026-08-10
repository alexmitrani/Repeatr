# Move doorprice→price/currency split and Brazil subdivision fill upstream into Repeatr_1()

## Context

Two recent changes were implemented *inside* `export_fugazidb_data()`
(`R/export_fugazidb_data.R`) instead of upstream in `Repeatr_1()`:

1. **`ba37dbba`** ("tidied up doorprice variable") - splits `othervariables$doorprice`
   (raw scraped text) into a numeric `price` + ISO 4217 `currency` via
   `inst/extdata/fls_doorprice_currency_lookup.csv`, but only when building
   fugazi.db's `shows` table.
2. **`adbc46f1`** ("Add Brazil subdivisions") - fills in Brazilian state codes
   (`case_when()` over 12 cities) and standardizes blank `subdivision` (a mix of
   `""`/`NA`) to `NA`, again only inside `export_fugazidb_data()`.

Confirmed by reading `R/export_fugazidb_data.R:85-124`: both transformations run
on `othervariables` *after* it's loaded from `data/othervariables.rda` - a copy
made inside the export function, never written back. The result: fugazi.db's
`shows` table has clean `price`/`currency`/`subdivision`, but Repeatr's own
`data/othervariables.rda` and `data/shows_data.rda` (which the Shiny app,
`inst/shiny/Fugazetteer/app.R`, reads directly - confirmed via
`app.R:197 shows_data <- Repeatr::shows_data`) still have the raw, unsplit
`doorprice` and blank/incomplete Brazilian `subdivision`. This is exactly the
inconsistency the user flagged: fugazi.db was meant to be a strict downstream
*export* of Repeatr's own cleaned data (per `data-raw/build_data.R`'s own
stage comments: "fugazi.db is downstream of Repeatr, not upstream of it"), not
a place where new cleaning logic produces different values than the package
itself ships.

The existing precedent for this exact kind of fix already lives in
`R/Repeatr_1.R` - e.g. its Hobart `TZ`→`TAS` typo correction and its
Australia-subdivision-filling block (`R/Repeatr_1.R:115-139`), both applied to
`othervariables` at construction time, upstream of everything. This plan moves
the two new transformations into that same location/style, so both Repeatr's
package data and fugazi.db's export are built from one consistent set of
values, and `export_fugazidb_data()` goes back to being close to a pure
pass-through (select/rename only, no independent business logic).

Confirmed safe: `app.R` has zero references to `doorprice`/`door_price`
(grepped, no hits), so replacing that column with `price`/`currency` in
`othervariables`/`shows_data` doesn't touch any current Shiny behavior.
`app.R`'s own subdivision-handling (`add_subdivision_to_city()`,
`where_played` fallback) already treats `NA` and `""` identically
(`is.na(subdivision) | subdivision == ""`), so standardizing blanks to `NA`
upstream is also safe there.

## Changes

### 1. `R/Repeatr_1.R` - move both transformations upstream

- Immediately after the existing Australia-subdivision block
  (`R/Repeatr_1.R:126-139`), add the Brazil `case_when()` block (12 cities,
  same mapping currently in `export_fugazidb_data.R:105-119`), followed by the
  blank-subdivision→`NA` normalization (`ifelse(subdivision == "", NA, subdivision)`),
  applied once to `othervariables`. Match the existing comment style explaining
  *why* (Brazil isn't in the FLS site's own state/country scrape, hand-verified
  against `fls_venue_geocoding_v2.csv`, same as the Australia block's rationale).
- In the `othervariables` construction block (`R/Repeatr_1.R:74-81`, right after
  the `rename(... doorprice = door_price)` step), add the price/currency split:
  read `inst/extdata/fls_doorprice_currency_lookup.csv` via `system.file(...,
  package = "Repeatr")` (same call already used in `export_fugazidb_data.R:87`),
  left-join on `doorprice`, apply the `"Free"` special-case override (`price =
  0`; `currency` = `"ITL"` for Italy, `"USD"` otherwise), then drop `doorprice`
  (and the lookup's `note` column) so `othervariables` ends up with `price`/
  `currency` instead of `doorprice`. Keep the explanatory comment (58 raw
  values, hand-built lookup, "Free" special-case, non-integer prices, DEM for
  the two Yugoslavia shows) - move it here from `export_fugazidb_data.R` rather
  than duplicating it.
- Update the `shows_data` construction (`R/Repeatr_1.R:1348-1361`): replace
  `doorprice`/`rename(door_price = doorprice)` in the `select()` with
  `price, currency` (no rename needed - `othervariables` already has the final
  names).

### 2. `R/export_fugazidb_data.R` - simplify back to pass-through

- Remove the `doorprice_lookup` read, the `left_join(doorprice_lookup, ...)`,
  and the `price`/`currency` `mutate()` overrides from the `shows` block -
  `othervariables` (loaded via `load_obj("othervariables")`) already has
  `price`/`currency`.
- Remove the Brazil `case_when()` and blank→`NA` `ifelse()` from the same
  block - already done upstream.
- Update the block's leading comment and the function's Roxygen
  `@description` (currently documents "two small, documented exceptions
  confined to `shows$subdivision`" plus the doorprice split as business logic
  living in this function) to state the function is now a pure
  select/rename/join-against-static-CSV export with no re-derivation of
  values Repeatr itself already computed.
- Leave the `check_no_na()`/`check_unique()` integrity checks as-is (those are
  legitimately export-time invariants, not upstream business logic).

### 3. Documentation (`R/data.R`)

- `othervariables` `\describe{}` (`R/data.R:43-68`): replace
  `\item{doorprice}{Door price}` with `\item{price}{...}` +
  `\item{currency}{...}` (mirroring fugazi.db's own `R/data.R:21` wording);
  update the `subdivision` item to mention the Brazil fill and NA
  standardization. Update the `@section Provenance:` sentence
  (`R/data.R:69`) - the doorprice split and Brazil/NA subdivision handling are
  no longer things `export_fugazidb_data()` does; they're now part of
  `Repeatr_1()`'s own cleaning, and `export_fugazidb_data()` just carries them
  through unchanged.
- `shows_data` `\describe{}` (`R/data.R:262-283`): same `door_price` →
  `price`/`currency` item swap; update `subdivision` item for Brazil.
- Regenerate `man/othervariables.Rd`, `man/shows_data.Rd`,
  `man/export_fugazidb_data.Rd` via `devtools::document()` (do not hand-edit
  generated `.Rd` files).

### 4. `vignettes/Rebuilding-the-Data.Rmd`

- Stage B section (around line 49): add a short clause noting `Repeatr_1()`
  also splits door-price into `price`/`currency` and fills/normalizes
  Brazilian `subdivision` codes.
- Stage C section (line 63): drop `fls_doorprice_currency_lookup.csv` from
  the "reads ... plus X directly" list (only `fls_venue_geocoding_v2.csv` is
  still read directly there) and drop the "`shows`'s `doorprice` is split
  into..." sentence, since that's no longer something this stage does.

### 5. `data-raw/build_data.R`

- Stage C comment (~line 84): same drop of `fls_doorprice_currency_lookup.csv`
  from the "plus X" list, matching the vignette change.

### 6. `vignettes/Data-Provenance.Rmd`

- Checked: no mention of doorprice/price/currency/subdivision/Brazil
  specifics anywhere in this file (grepped, no hits) - no change needed
  beyond what's already correct.

### 7. Regenerate data and re-export

- Run `Repeatr_1()` (or the full `Repeatr_Updatr(really = "really", update_stacks
  = TRUE)` per `data-raw/build_data.R`'s documented process) from the package
  root using `C:\Program Files\R\R-4.5.3\bin\Rscript.exe` (or
  `devtools::load_all()` interactively) to regenerate `data/othervariables.rda`,
  `data/shows_data.rda`, and everything else Stage B produces.
- Run `devtools::document()` to regenerate the `.Rd` files listed above.
- Re-run `export_fugazidb_data(fugazidb_dir = "../fugazi.db")` and confirm the
  regenerated `fugazi.db/data/shows.rda` has **identical** `price`/`currency`/
  `subdivision` values to the last committed export (values shouldn't change -
  only *where* they're computed changes) - e.g. compare row counts, the known
  16-currency set, the 12 Brazilian city codes, and the Barrowland
  Ballroom/Yugoslavia spot-checks already recorded in
  `inst/notes/202608092207_notes_fugazi-db-tidy-rename.md`.
- Confirm `export_fugazidb_data()`'s integrity checks (`check_no_na`/
  `check_unique`) still pass with no code changes to them.

### 8. Verification

- Load the rebuilt package (`devtools::load_all()`) and confirm
  `othervariables$price`/`currency`/`subdivision` and `shows_data$price`/
  `currency`/`subdivision` look correct (spot-check the same Barrowland/
  Yugoslavia/Brazil cases from the prior sessions' notes, now sourced from
  Repeatr's own data instead of fugazi.db's export).
- Start the Shiny app locally (`shiny::runApp("inst/shiny/Fugazetteer")`) and
  confirm it still launches cleanly on the renamed `shows_data` columns (no
  code in `app.R` references `doorprice`/`door_price`, so this is a smoke test,
  not an expected-breakage check).
- `git status --short` in both repos to confirm the diff matches this plan's
  scope (no unrelated changes).

### 9. Session notes

- Write a plan file (this file, already saved) and a matching session-notes
  file into `inst/notes/` (following the existing
  `YYYYMMDDHHMM_plan_<slug>.md` / `YYYYMMDDHHMM_notes_<slug>.md` naming and
  structure used by the last several sessions, e.g.
  `inst/notes/202608101341_notes_fugazi-db-brazil-subdivision-checks.md`)
  once implementation is complete, documenting what changed and the
  before/after verification results.
- Leave all changes uncommitted for the user's own review, per this repo's
  established convention (confirmed across every recent session's notes).
