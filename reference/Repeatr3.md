# Fugazi Live Series choice data in long format with related discography data and dummy variables for age categories of songs.

Song data from the Fugazi discography pages on Wikipedia. The variables
attributing lead vocals are simplifications in some cases where lead
vocals were shared. The variables song_number, first_song and last_song
were defined after data cleaning, so intros, outros, sound checks,
interludes and one-offs are not included.

## Usage

``` r
Repeatr3
```

## Format

dataframe with one row for each show, each song performed and each song
available in all the Fugazi Live Series shows with data.

- gid:

  gig id. This is a concatenation of city, country, and date

- case:

  This is a numerical id with unique values for each combination of gid
  and song_number

- song_number:

  The number of the song in the sequence of songs that were performed as
  part of that show

- alt:

  alt is the songid variable renamed

- choice:

  1 if the song was performed at that point in the show, 0 otherwise

- yearsold:

  The difference between the date of the show and the launchdate of the
  song, measured in years

- vocals_picciotto:

  indicates whether or not Guy Picciotto sang lead vocals on this track

- vocals_mackaye:

  indicates whether or not Ian Mackaye sang lead vocals on this track

- vocals_lally:

  indicates whether or not Joe Lally sang lead vocals on this track

- instrumental:

  Indicates whether or not the piece is an instrumental

- first_song:

  Identifies the first song of the set

- last_song:

  Identifies the last song of the set

- duration_seconds:

  The duration of the song in seconds

- yearsold_0:

  0 \< age \< 1

- yearsold_1:

  1 ≤ age \< 2

- yearsold_2:

  2 ≤ age \< 3

- yearsold_3:

  3 ≤ age \< 4

- yearsold_4:

  4 ≤ age \< 5

- yearsold_5:

  5 ≤ age \< 6

- yearsold_6:

  6 ≤ age \< 7

- yearsold_7:

  7 ≤ age \< 8

- yearsold_8:

  8 ≤ age

- yearsold_1_vp:

  1 ≤ age \< 2 and vocals Picciotto

- yearsold_2_vp:

  2 ≤ age \< 3 and vocals Picciotto

- yearsold_3_vp:

  3 ≤ age \< 4 and vocals Picciotto

- yearsold_4_vp:

  4 ≤ age \< 5 and vocals Picciotto

- yearsold_5_vp:

  5 ≤ age \< 6 and vocals Picciotto

- yearsold_6_vp:

  6 ≤ age \< 7 and vocals Picciotto

- yearsold_7_vp:

  7 ≤ age \< 8 and vocals Picciotto

- yearsold_8_vp:

  8 ≤ age and vocals Picciotto

- first_song_instrumental:

  1 if first song of the show and instrumental, 0 otherwise

- vocals_picciotto_sum:

  running total of songs with lead vocals by Guy Picciotto in this show

- vocals_mackaye_sum:

  running total of songs with lead vocals by Ian Mackaye in this show

- vocals_lally_sum:

  running total of songs with lead vocals by Joe Lally in this show

## Source

https://www.dischord.com/fugazi_live_series

https://web.archive.org/web/20201112000517/http://en.wikipedia.org/wiki/Fugazi_discography

## Examples

``` r
  Repeatr3
#> # A tibble: 879,038 × 34
#>    gid    case song_number   alt choice yearsold vocals_mackaye vocals_picciotto
#>    <chr> <int>       <int> <dbl>  <dbl>    <int>          <int>            <int>
#>  1 wash…     1           1    36      0        0              0                0
#>  2 wash…     1           1    43      0        0              0                0
#>  3 wash…     1           1    45      1        0              0                0
#>  4 wash…     1           1    55      0        0              0                0
#>  5 wash…     1           1    78      0        0              0                0
#>  6 wash…     1           1    87      0        0              0                0
#>  7 wash…     1           1    88      0        0              0                0
#>  8 wash…     1           1    92      0        0              0                0
#>  9 wash…     3           3    36      0        0              1                0
#> 10 wash…     3           3    43      0        0              1                0
#> # ℹ 879,028 more rows
#> # ℹ 26 more variables: vocals_lally <int>, instrumental <int>,
#> #   first_song <dbl>, last_song <dbl>, duration_seconds <int>,
#> #   yearsold_0 <int>, yearsold_1 <int>, yearsold_2 <int>, yearsold_3 <int>,
#> #   yearsold_4 <int>, yearsold_5 <int>, yearsold_6 <int>, yearsold_7 <int>,
#> #   yearsold_8 <int>, yearsold_1_vp <int>, yearsold_2_vp <int>,
#> #   yearsold_3_vp <int>, yearsold_4_vp <int>, yearsold_5_vp <int>, …
```
