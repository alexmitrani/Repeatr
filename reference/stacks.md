# stacks puts together a set of shows that will contain a specified number of unique songs.

stacks puts together a set of shows that will contain a specified number
of unique songs.

## Usage

``` r
stacks(
  mydf = NULL,
  mygid = NULL,
  mynumberofsongs = NULL,
  exclude_poor_sound_quality = FALSE,
  mysummary = NULL,
  myothervariables = NULL,
  mygidsoundquality = NULL
)
```

## Arguments

- mydf:

  dataframs of shows and songs containing the columns gid and song.

- mygid:

  gig id of initial show as a string, for instance
  "washington-dc-usa-13196".

- mynumberofsongs:

  the number of unique songs that are required. the maximum is 94 (the
  number of songs Fugazi played live at least twice) and the number of
  songs in the initial show will be taken as a minimum.

- exclude_poor_sound_quality:

  set to TRUE to exclude shows with poor sound quality

- mysummary:

  optional `summary` dataframe (as produced by
  [`Repeatr_5()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md))
  to be used for song play counts. If omitted the currently lazy-loaded
  default will be used - pass this explicitly if calling `stacks()`
  right after a fresh
  [`Repeatr_Updatr()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_Updatr.md)
  run in the same session.

- myothervariables:

  optional `othervariables` dataframe (as produced by
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md))
  to be used for show details. If omitted the currently lazy-loaded
  default will be used.

- mygidsoundquality:

  optional `gid_sound_quality` dataframe (as produced by
  [`Repeatr_1()`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md))
  to be used for sound quality filtering/display. If omitted the
  currently lazy-loaded default will be used.

## Value

A list of two data frames: `stack_songs` (`gid`, `song` - one row per
unique song in the stack, and the show it came from) and
`stack_shows_songs` (one row per show included in the stack, with
venue/date/sound-quality details and the number of new songs it
contributed).

## Examples

``` r
gid_song <- duration_data_da %>%
  select(gid, song)

results <- stacks(mydf = gid_song, mygid = "washington-dc-usa-13196", mynumberofsongs = 94)
#> Joining with `by = join_by(song)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(song)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(song)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(song)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(song)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(song)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(song)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(song)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(song)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(song)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
#> Joining with `by = join_by(gid)`
stack1 <- results[[1]]
stack2 <- results[[2]]

```
