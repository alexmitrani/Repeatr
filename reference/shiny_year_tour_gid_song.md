# `duration_data_da` joined with `othervariables`, trimmed to `year`/`tour`/`gid`/`title`

`duration_data_da` joined with `othervariables`, trimmed to
`year`/`tour`/`gid`/`title`

## Usage

``` r
shiny_year_tour_gid_song
```

## Format

dataframe with one row for each rendition of each song in
[`duration_data_da`](https://alexmitrani.github.io/Repeatr/reference/duration_data_da.md).

- year:

  year

- tour:

  the touring period the show belongs to

- gid:

  show id

- title:

  the name of the song

## Provenance

Shiny-presentation-only. Produced by
[`build_shiny_precompute`](https://alexmitrani.github.io/Repeatr/reference/build_shiny_precompute.md)
from
[`duration_data_da`](https://alexmitrani.github.io/Repeatr/reference/duration_data_da.md)
and
[`othervariables`](https://alexmitrani.github.io/Repeatr/reference/othervariables.md).
Built from the raw (pre-live-coordinate-join) `othervariables`, since
only `year`/`tour` are kept and those don't depend on the live sheet.

## Examples

``` r
shiny_year_tour_gid_song
#> # A tibble: 18,273 × 4
#>     year tour                    gid                 title         
#>    <dbl> <chr>                   <chr>               <chr>         
#>  1  1990 1990 Fall European Tour aalst-belgium-92390 and the same  
#>  2  1990 1990 Fall European Tour aalst-belgium-92390 blueprint     
#>  3  1990 1990 Fall European Tour aalst-belgium-92390 brendan #1    
#>  4  1990 1990 Fall European Tour aalst-belgium-92390 bulldog front 
#>  5  1990 1990 Fall European Tour aalst-belgium-92390 burning too   
#>  6  1990 1990 Fall European Tour aalst-belgium-92390 merchandise   
#>  7  1990 1990 Fall European Tour aalst-belgium-92390 reclamation   
#>  8  1990 1990 Fall European Tour aalst-belgium-92390 repeater      
#>  9  1990 1990 Fall European Tour aalst-belgium-92390 reprovisional 
#> 10  1990 1990 Fall European Tour aalst-belgium-92390 runaway return
#> # ℹ 18,263 more rows
```
