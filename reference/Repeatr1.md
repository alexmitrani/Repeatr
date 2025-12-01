# Fugazi Live Series data in long format with related discography data

Song data from the Fugazi discography pages on Wikipedia. The variables
attributing lead vocals are simplifications in some cases where lead
vocals were shared. The variables song_number, first_song and last_song
were defined after data cleaning, so intros, outros, sound checks,
interludes and one-offs are not included.

## Usage

``` r
Repeatr1
```

## Format

dataframe with one row for show and each song performed in all the
Fugazi Live Series shows with data.

- gid:

  gig id. This is a concatenation of city, country, and date

- date:

  Show date

- year:

  Year

- month:

  Month, as a number

- day:

  Day, as a number

- tracktype:

  0 = interlude, 1 = song, 2 = other music

- song_number:

  The number of the song in the sequence of songs that were performed as
  part of that show

- songid:

  numeric id for each song

- song:

  The name of the song

- number_songs:

  The number of songs that were performed as part of that show

- first_song:

  Identifies the first song of the set

- last_song:

  Identifies the last song of the set

- releaseid:

  numeric id in ascending chronological order

- release:

  name of album or EP

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

- duration_seconds:

  The duration of the song in seconds

## Source

https://www.dischord.com/fugazi_live_series

https://web.archive.org/web/20201112000517/http://en.wikipedia.org/wiki/Fugazi_discography

## Examples

``` r
  Repeatr1
#> # A tibble: 23,280 × 20
#>    gid           date        year month   day tracktype song_number songid song 
#>    <chr>         <date>     <dbl> <dbl> <int>     <dbl>       <dbl>  <int> <chr>
#>  1 aalst-belgiu… 1990-09-23  1990     9    23         0           1     NA intro
#>  2 aalst-belgiu… 1990-09-23  1990     9    23         1           2     89 turn…
#>  3 aalst-belgiu… 1990-09-23  1990     9    23         1           3     12 bren…
#>  4 aalst-belgiu… 1990-09-23  1990     9    23         1           4     55 merc…
#>  5 aalst-belgiu… 1990-09-23  1990     9    23         1           5     76 siev…
#>  6 aalst-belgiu… 1990-09-23  1990     9    23         1           6      2 and …
#>  7 aalst-belgiu… 1990-09-23  1990     9    23         0           7     NA inte…
#>  8 aalst-belgiu… 1990-09-23  1990     9    23         1           8     13 bull…
#>  9 aalst-belgiu… 1990-09-23  1990     9    23         1           9     15 burn…
#> 10 aalst-belgiu… 1990-09-23  1990     9    23         0          10     NA inte…
#> # ℹ 23,270 more rows
#> # ℹ 11 more variables: number_songs <int>, first_song <dbl>, last_song <dbl>,
#> #   releaseid <int>, release <chr>, track_number <int>, instrumental <int>,
#> #   vocals_picciotto <int>, vocals_mackaye <int>, vocals_lally <int>,
#> #   duration_seconds <int>
```
