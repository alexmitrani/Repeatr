# Runs the whole analysis process to update the site and Fugazetteer web app from the input data files.

This can take a while which is why the parameter "really" is
"not_really" by default.

To run the full update: Repeatr_Updatr(really = "really")

## Usage

``` r
Repeatr_Updatr(
  really = "not_really",
  min_song_count = 2,
  update_stacks = FALSE,
  myfls_data = NULL,
  mysongvarslookup = NULL,
  myreleases = NULL,
  myfls_venue_geocoding = NULL,
  myfls_tags = NULL,
  input_dir = NULL,
  output_dir = NULL
)
```

## Arguments

- really:

  set to "really" to actually run the update; any other value (the
  default, "not_really") does nothing.

- min_song_count:

  passed through to
  [`Repeatr_2`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md):
  minimum number of performances a song needs to compete as an
  alternative in the choice model. Default 2. Does not affect
  `songid`/`songidlookup`, which cover every classified song regardless
  of this threshold.

- update_stacks:

  if TRUE, the gid_initial_gid_sound_quality data will be refreshed by
  re-generating a set of stacks considering the full available set of
  relevant data.

- myfls_data, mysongvarslookup, myreleases, myfls_venue_geocoding,
  myfls_tags:

  optional data frame overrides passed straight through to
  [`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md).
  If omitted, `Repeatr_1` uses this package's own `inst/extdata/`
  sources - see its documentation for each.

- input_dir:

  passed through to
  [`Repeatr_2`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_2.md)/[`Repeatr_5`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md):
  where to write their output-export CSVs. If omitted, defaults to this
  package's own `inst/extdata`.

- output_dir:

  passed through to every stage: where to save the rebuilt `data/*.rda`
  objects. If omitted, defaults to `data/` under the current working
  directory.

## Value

Invisibly, the list of results from the final
[`Repeatr_5()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md)
call when `really = "really"`; `NULL` otherwise. The real effect is
refreshing all of the package's `data/*.rda` objects in place, ready to
be reinstalled.

## Examples

``` r
Repeatr_Updatr(really = "not_really")
```
