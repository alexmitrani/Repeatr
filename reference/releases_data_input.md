# Releases data input

Releases data input

## Usage

``` r
releases_data_input
```

## Format

dataframe with one row for each song in the Fugazi discography, except
those which never appear in the Fugazi Live Series data.

- rid:

  numeric id in ascending chronological order

- release_title:

  release name

- track_number:

  The track number for the song on the release

- title:

  The name of the song

- last_show:

  The number of the last show in the series

- colour_code:

  The hex colour code used for the corresponding release

- count:

  The number of times the song was performed according to the data

- date:

  The debut date of the song

- show_num:

  The show number of the debut of the song

- shows:

  The number of shows in which the song could have been performed

- intensity:

  The rate at which the song was played - this is count / shows

- rating:

  The rating calculated for the song based on preferences implied by the
  choices of which songs to play.

## Source

https://www.dischord.com/fugazi_live_series

## Provenance

Derived-modeled. Produced twice: an intermediate version in
[`Repeatr_1`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_1.md),
finalized by
[`Repeatr_5`](https://alexmitrani.github.io/Repeatr/reference/Repeatr_5.md)
once the choice-model `rating` column is available.

## Examples

``` r
releases_data_input
#> # A tibble: 92 × 12
#>      rid release_title track_number title last_show colour_code count date      
#>    <int> <fct>                <int> <fct>     <int> <chr>       <int> <date>    
#>  1    11 first demo              10 in d…       951 #adb56a        31 1987-09-03
#>  2    11 first demo               8 turn…       951 #adb56a        17 1987-09-03
#>  3    11 first demo               5 the …       951 #adb56a        37 1987-09-03
#>  4    10 furniture                3 hell…       951 #d15743         2 2001-04-27
#>  5    10 furniture                2 numb…       951 #d15743       120 1998-11-21
#>  6    10 furniture                1 furn…       951 #d15743       108 1987-09-03
#>  7     9 the argument            11 argu…       951 #99c3cb        76 1999-08-26
#>  8     9 the argument            10 nigh…       951 #99c3cb        46 1999-08-26
#>  9     9 the argument             9 ex-s…       951 #99c3cb        52 1999-08-26
#> 10     9 the argument             8 oh          951 #99c3cb        91 1998-11-29
#> # ℹ 82 more rows
#> # ℹ 4 more variables: show_num <int>, shows <dbl>, intensity <dbl>,
#> #   rating <dbl>
```
