# Regenerates gid_initial_gid_sound_quality, a set of "stacks" of shows covering the whole Fugazi repertoire.

Runs sweepstack() over the full available set of shows/songs and
rebuilds gid_initial_gid_sound_quality, the dataset behind the Shiny
app's "stock" pages (see inst/shiny/Fugazetteer/app.R).

## Usage

``` r
Repeatr_6(
  myduration_data_da = NULL,
  mysummary = NULL,
  myothervariables = NULL,
  mygidsoundquality = NULL,
  number_stacks = NULL,
  exclude_poor_sound_quality = FALSE
)
```

## Arguments

- myduration_data_da:

  optional `duration_data_da` dataframe (as produced by
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)),
  passed through to
  [`sweepstack()`](https://alexmitrani.github.io/Repeatr/reference/sweepstack.md).
  If omitted the currently lazy-loaded default will be used - pass this
  explicitly when calling `Repeatr_6()` right after a fresh
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)
  in the same session.

- mysummary:

  optional `summary` dataframe (as produced by
  [`Repeatr_5()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md)),
  passed through to
  [`sweepstack()`](https://alexmitrani.github.io/Repeatr/reference/sweepstack.md)/[`stacks()`](https://alexmitrani.github.io/Repeatr/reference/stacks.md).
  If omitted the currently lazy-loaded default will be used.

- myothervariables:

  optional `othervariables` dataframe (the clean, pre-join copy as saved
  by
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)),
  passed through to
  [`sweepstack()`](https://alexmitrani.github.io/Repeatr/reference/sweepstack.md)/[`stacks()`](https://alexmitrani.github.io/Repeatr/reference/stacks.md).
  If omitted the currently lazy-loaded default will be used.

- mygidsoundquality:

  optional `gid_sound_quality` dataframe (as produced by
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md)),
  passed through to
  [`sweepstack()`](https://alexmitrani.github.io/Repeatr/reference/sweepstack.md)/[`stacks()`](https://alexmitrani.github.io/Repeatr/reference/stacks.md)
  and used again directly here to attach sound quality to each stacked
  show. If omitted the currently lazy-loaded default will be used.

- number_stacks:

  passed through to
  [`sweepstack()`](https://alexmitrani.github.io/Repeatr/reference/sweepstack.md) -
  the number of starting shows to test. If omitted all possible starting
  shows will be tested.

- exclude_poor_sound_quality:

  passed through to
  [`sweepstack()`](https://alexmitrani.github.io/Repeatr/reference/sweepstack.md)/[`stacks()`](https://alexmitrani.github.io/Repeatr/reference/stacks.md) -
  set to TRUE to exclude shows with sound quality rated as 'Poor'.

## Value

Invisibly, `gid_initial_gid_sound_quality` (`gid_initial`, `gid`,
`sound_quality`, `count` - one row per unique show/stack/sound-quality
combination). As a side effect, also saved into
`data/gid_initial_gid_sound_quality.rda`.

## Examples

``` r
Repeatr_6(number_stacks = 10, exclude_poor_sound_quality = TRUE)
#> stack 1
#> 
#> Error in UseMethod("select"): no applicable method for 'select' applied to an object of class "function"
```
