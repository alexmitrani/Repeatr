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

## Examples

``` r
  summary
#> # A tibble: 94 × 16
#>     rank songid track_number song        launchdate duration chosen available_rl
#>    <int>  <int>        <int> <chr>       <date>        <int>  <int>        <int>
#>  1     8     92            1 waiting ro… 1987-09-03      173    633          900
#>  2    55     13            2 bulldog fr… 1988-06-15      173    226          876
#>  3    48      6            3 bad mouth   1987-10-16      155    280          897
#>  4    64     14            4 burning     1988-02-06      159    214          890
#>  5    37     37            5 give me th… 1988-03-30      178    369          887
#>  6    44     83            6 suggestion  1987-12-03      284    340          895
#>  7    80     38            7 glueman     1988-05-12      263    133          884
#>  8    19     54            1 margin wal… 1988-08-01      150    430          872
#>  9    31      2            2 and the sa… 1987-09-26      207    376          899
#> 10    61     15            3 burning too 1988-08-01      170    215          872
#> # ℹ 84 more rows
#> # ℹ 8 more variables: intensity <dbl>, rating <dbl>, releaseid <int>,
#> #   release <chr>, releasedate <date>, lead <int>, launchyear <dbl>,
#> #   releaseyear <dbl>
```
