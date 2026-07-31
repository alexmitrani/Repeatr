# Summary

Summary

## Usage

``` r
summary
```

## Format

dataframe with one row for each song in the Fugazi discography, except
those which never appear in the Fugazi Live Series data.

- rank_rating:

  The rank of the song in terms of the rating derived from the choice
  modelling, with the highest-rated song in the first position.

- songid:

  numeric id for each song

- song:

  The name of the song

- launchdate:

  The date on which the song was first performed according to the data

- duration_seconds:

  The duration of the song in seconds

- chosen:

  The number of times the song was performed according to the data

- available_rl:

  The number of shows for which the song was available in the band's
  repertoire

- intensity:

  The performance intensity is the ratio of chosen/available_rl

- rating:

  Rating on the interval between 0 and 1 where 1 is the highest rating
  and 0 the lowest.

- releaseid:

  numeric id in ascending chronological order

- release:

  release name

- track_number:

  The track number for the song on the release

- instrumental:

  Indicates whether or not the piece is an instrumental

- vocals_picciotto:

  indicates whether or not Guy Picciotto sang lead vocals on this track

- vocals_mackaye:

  indicates whether or not Ian Mackaye sang lead vocals on this track

- vocals_lally:

  indicates whether or not Joe Lally sang lead vocals on this track

- releasedate:

  The date of the corresponding release

- lead:

  The number of days between the launch date and the release date

- launchyear:

  The year in which the song was first performed

- releaseyear:

  The year in which the song was released

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-modeled. Produced by
[`Repeatr_5`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md),
the final combined song-level output of the whole pipeline. Actively
consumed directly by `inst/shiny/Fugazetteer/app.R`.

## Examples

``` r
summary
#> # A tibble: 92 × 16
#>     rank songid track_number song        launchdate duration chosen available_rl
#>    <int>  <int>        <int> <chr>       <date>        <int>  <int>        <int>
#>  1     8     91            1 waiting ro… 1987-09-03      173    675          952
#>  2    54     13            2 bulldog fr… 1988-06-15      173    249          925
#>  3    45      6            3 bad mouth   1987-10-16      155    312          949
#>  4    58     14            4 burning     1988-02-06      159    243          942
#>  5    37     37            5 give me th… 1988-03-30      178    401          939
#>  6    42     82            6 suggestion  1987-12-03      284    373          947
#>  7    79     38            7 glueman     1988-05-07      263    148          935
#>  8    17     54            1 margin wal… 1988-07-28      150    467          921
#>  9    30      2            2 and the sa… 1987-09-26      207    397          951
#> 10    57     15            3 burning too 1988-07-28      170    238          921
#> # ℹ 82 more rows
#> # ℹ 8 more variables: intensity <dbl>, rating <dbl>, releaseid <int>,
#> #   release <chr>, releasedate <date>, lead <int>, launchyear <dbl>,
#> #   releaseyear <dbl>
```
