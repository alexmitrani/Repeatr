# Duration Data

Duration Data

## Usage

``` r
duration_data_da
```

## Format

dataframe with one row for each rendition of each song in the Fugazi
Live Series data.

- gid:

  Unique identifier for the show

- date:

  The date of the show.

- song_number:

  this is the number of the song in the set, where 1 is the first song
  in that show. Larger numbers will indicate that the song was played
  later in the set,

- title:

  the name of the song

- urls:

  A string used to form the URLs of the corresponding page on the Fugazi
  Live series site.

- fls_link:

  a link to the corresponding page of the Fugazi Live Series site.

- minutes:

  duration of the song in minutes

- position:

  normalized position of the song within the show's setlist, from 0
  (first song) to 1 (last song), rounded to 2 decimal places

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-cleaned. Produced by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md).
Also a direct input to
[`sweepstack`](https://alexmitrani.github.io/Repeatr/reference/sweepstack.md)/[`stacks`](https://alexmitrani.github.io/Repeatr/reference/stacks.md).

## Examples

``` r
duration_data_da
#> # A tibble: 18,273 × 8
#>    gid              date       song_number title urls  fls_link minutes position
#>    <chr>            <date>           <dbl> <chr> <chr> <chr>      <dbl>    <dbl>
#>  1 aalst-belgium-9… 1990-09-23           6 and … http… <a href…    4.3      0.2 
#>  2 aalst-belgium-9… 1990-09-23          14 blue… http… <a href…    4.33     0.6 
#>  3 aalst-belgium-9… 1990-09-23           3 bren… http… <a href…    2.93     0.05
#>  4 aalst-belgium-9… 1990-09-23           8 bull… http… <a href…    2.75     0.3 
#>  5 aalst-belgium-9… 1990-09-23           9 burn… http… <a href…    2.72     0.35
#>  6 aalst-belgium-9… 1990-09-23           4 merc… http… <a href…    3.07     0.1 
#>  7 aalst-belgium-9… 1990-09-23          13 recl… http… <a href…    3.52     0.55
#>  8 aalst-belgium-9… 1990-09-23          22 repe… http… <a href…    3.18     1   
#>  9 aalst-belgium-9… 1990-09-23          17 repr… http… <a href…    4.95     0.75
#> 10 aalst-belgium-9… 1990-09-23          21 runa… http… <a href…    4.17     0.95
#> # ℹ 18,263 more rows
```
