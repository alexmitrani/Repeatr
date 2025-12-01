# Transitions

Transitions

## Usage

``` r
transitions
```

## Format

dataframe with one row for each transition between songs in the Fugazi
Live Series data.

- from:

  Song \#1

- to:

  Song \#2

- count:

  A count of the times this transition appears in the data

- count_scaled:

  The count scaled by the total number of times this transition was
  available

## Source

https://www.dischord.com/fugazi_live_series

## Examples

``` r
  transitions
#> # A tibble: 3,053 × 4
#>    from                to                count count_scaled
#>    <chr>               <chr>             <int>        <dbl>
#>  1 long division       blueprint           179        0.217
#>  2 suggestion          give me the cure    162        0.184
#>  3 repeater            reprovisional       148        0.177
#>  4 argument            blueprint            16        0.16 
#>  5 break               place position       36        0.158
#>  6 sieve-fisted find   reclamation         118        0.149
#>  7 oh                  closed captioned     20        0.147
#>  8 two beats off       repeater            122        0.146
#>  9 do you like me      reclamation          48        0.128
#> 10 returning the screw smallpox champion    64        0.124
#> # ℹ 3,043 more rows
```
