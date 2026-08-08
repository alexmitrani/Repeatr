# Builds fugazi.db's data/\*.rda objects from its data-raw/ sources

Reads the six plain, human-editable source files in a local `fugazi.db`
checkout's `data-raw/` (`fls_data.csv`, `fls_tags.txt`, `releases.csv`,
`releases_songs_durations_wikipedia.csv`, `song_tempo_bpm_data.csv`,
`fls_venue_geocoding.csv`) and writes the corresponding lazy-loadable
`.rda` objects into `data/` - the ongoing, repeatable counterpart to the
one-time bake-ins that removed
`othervariables_patch.csv`/`venue_name_corrections.csv`/`fls_tags_name_recoded.csv`.
Run this (from Repeatr, since `fugazi.db` itself contains no code)
whenever any of `fugazi.db`'s `data-raw/` sources change - a fresh
scrape, a synced geocoding sheet, a new tempo reading, a re-exported tag
file - before committing `fugazi.db` and reinstalling it for
[`Repeatr_Updatr`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_Updatr.md)
to pick up.

## Usage

``` r
build_fugazidb_data(fugazidb_dir)
```

## Arguments

- fugazidb_dir:

  path to a local `fugazi.db` checkout.

## Value

Invisibly, a named list of the six objects built. As a side effect,
writes `fugazidb_dir/data/*.rda`.

## Examples

``` r
if (FALSE) { # \dontrun{
build_fugazidb_data(fugazidb_dir = "../fugazi.db")
} # }
```
