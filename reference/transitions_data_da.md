# Transitions Data

Transitions Data

## Usage

``` r
transitions_data_da
```

## Format

dataframe with one row for each combination of show, first song and
second song in the Fugazi Live Series data.

- gid:

  gig id. This is a concatenation of city, country, and date

- url:

  url to the corresponding page of the Fugazi Live Series site.

- fls_link:

  provides a link to the corresponding page of the Fugazi Live Series
  site

- date:

  date of the show

- transition:

  1-indexed number of the transition within the show (1 = the first
  transition in that show)

- to_song_number:

  song_number (raw track position) of the second/destination song, for
  joining back to the show's tracklist

- title1:

  Name of the first song

- title2:

  Name of the second song

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-cleaned. Produced by
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md).
Songs are paired with the next real song performed at the same show,
skipping over interludes and other non-song tracks in between. Not to be
confused with the orphaned `transitions` object.

## Examples

``` r
transitions_data_da
#> # A tibble: 17,334 × 8
#>    gid              url   fls_link date  transition to_song_number title1 title2
#>    <chr>            <chr> <chr>    <chr>      <int>          <int> <chr>  <chr> 
#>  1 aalst-belgium-9… http… <a href… 1990…          1              3 turno… brend…
#>  2 aalst-belgium-9… http… <a href… 1990…          2              4 brend… merch…
#>  3 aalst-belgium-9… http… <a href… 1990…          3              5 merch… sieve…
#>  4 aalst-belgium-9… http… <a href… 1990…          4              6 sieve… and t…
#>  5 aalst-belgium-9… http… <a href… 1990…          5              8 and t… bulld…
#>  6 aalst-belgium-9… http… <a href… 1990…          6              9 bulld… burni…
#>  7 aalst-belgium-9… http… <a href… 1990…          7             11 burni… sugge…
#>  8 aalst-belgium-9… http… <a href… 1990…          8             13 sugge… recla…
#>  9 aalst-belgium-9… http… <a href… 1990…          9             14 recla… bluep…
#> 10 aalst-belgium-9… http… <a href… 1990…         10             15 bluep… shut …
#> # ℹ 17,324 more rows
```
