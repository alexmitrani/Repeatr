# Runs the whole analysis process to update the site and Fugazetteer web app from the input data files.

This can take a while which is why the parameter "really" is
"not_really" by default.

To run the full update: Repeatr_Updatr(really = "really")

## Usage

``` r
Repeatr_Updatr(really = "not_really", min_song_count = 2)
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
