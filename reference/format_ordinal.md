# format_ordinal formats an integer as an ordinal string, e.g. 1 -\> "1st", 2 -\> "2nd", 3 -\> "3rd", 4 -\> "4th", 11 -\> "11th".

format_ordinal formats an integer as an ordinal string, e.g. 1 -\>
"1st", 2 -\> "2nd", 3 -\> "3rd", 4 -\> "4th", 11 -\> "11th".

## Usage

``` r
format_ordinal(n)
```

## Arguments

- n:

  integer to format.

## Value

A character string.

## Examples

``` r
format_ordinal(1)
#> [1] "1st"
format_ordinal(22)
#> [1] "22nd"
```
