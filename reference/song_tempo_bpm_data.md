# Song tempo BPM data

Song tempo BPM data

## Usage

``` r
song_tempo_bpm_data
```

## Format

dataframe with one row for each song in the Fugazi discography, except
those which never appear in the Fugazi Live Series data.

- song:

  The name of the song

- tempo_bpm:

  The tempo of the song in beats per minute

## Source

Tempos of selected songs from
https://www.dischord.com/fugazi_live_series measured with 'liveBPM' app
for Android and also finger tapping with a timer.

## Examples

``` r
  song_tempo_bpm_data
#> # A tibble: 94 × 2
#>    song                 tempo_bpm
#>    <chr>                    <dbl>
#>  1 23 beats off             110  
#>  2 and the same             148. 
#>  3 argument                 102  
#>  4 arpeggiator              179  
#>  5 back to base             194  
#>  6 bad mouth                 95.5
#>  7 bed for the scraping      93.5
#>  8 birthday pony            102. 
#>  9 blueprint                102  
#> 10 break                    132  
#> # ℹ 84 more rows
```
