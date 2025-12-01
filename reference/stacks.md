# stacks puts together a set of shows that will contain a specified number of unique songs.

stacks

## Usage

``` r
stacks(
  mydf = NULL,
  mygid = NULL,
  mynumberofsongs = NULL,
  exclude_poor_sound_quality = FALSE
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
