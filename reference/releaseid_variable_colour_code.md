# Release ID, variable, colour code

Release ID, variable, colour code

## Usage

``` r
releaseid_variable_colour_code
```

## Format

dataframe with one row for each release in the Fugazi discography,
except those which never appear in the Fugazi Live Series data.

- releaseid:

  A unique identifier for the release based on the alphabetical order of
  the titles.

- variable:

  The name of the release in snake case.

- colour code:

  Hex code of the colour used for this release in graphs.

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
  releaseid_variable_colour_code
#>    releaseid               variable colour_code
#> 1          1                 fugazi     #80110e
#> 2          2          margin_walker     #f1bd98
#> 3          3            three_songs     #6a5662
#> 4          4               repeater     #546084
#> 5          5 steady_diet_of_nothing     #9a5715
#> 6          6    in_on_the_killtaker     #e6ca6f
#> 7          7           red_medicine     #c02118
#> 8          8               end_hits     #5b734d
#> 9          9           the_argument     #99c3cb
#> 10        10              furniture     #d15743
#> 11        11             first_demo     #adb56a
#> 12        12               released     #009e73
#> 13        13             unreleased     #e69f00
#> 14        14                  songs     #e8853a
#> 15        15                  other     #8a8784
```
