# takes a dataframe with gid, song_number, and songid, and modifies it to make it suitable for choice modelling.

"gid" is short for "gig id"

## Usage

``` r
Repeatr_3(mydf = NULL)
```

## Arguments

- mydf:

  optional dataframe to be used. If omitted the default dataframe will
  be used.

## Examples

``` r
Repeatr3 <- Repeatr_3(mydf = Repeatr2)
#> Joining with `by = join_by(case)`
#> Size of Repeatr3 before converting the storage modes of specified variables to integer: 144.262 MB. 
#> The following variables will have their storage modes converted to integer, if they exist in Repeatr3: 
#>  [1] "vocals_mackaye"          "vocals_picciotto"       
#>  [3] "vocals_lally"            "vocals_picciotto_sum"   
#>  [5] "vocals_mackaye_sum"      "vocals_lally_sum"       
#>  [7] "instrumental"            "song_number"            
#>  [9] "first_song_instrumental" "duration_seconds"       
#> [11] "yearsold"                "yearsold_1"             
#> [13] "yearsold_2"              "yearsold_3"             
#> [15] "yearsold_4"              "yearsold_5"             
#> [17] "yearsold_6"              "yearsold_7"             
#> [19] "yearsold_8"              "yearsold_1_vp"          
#> [21] "yearsold_2_vp"           "yearsold_3_vp"          
#> [23] "yearsold_4_vp"           "yearsold_5_vp"          
#> [25] "yearsold_6_vp"           "yearsold_7_vp"          
#> [27] "yearsold_8_vp"          
#> Size of Repeatr3 after converting storage mode of variables to integer: 137.23 MB. 
#> RAM saved: 7.032 MB. 
#> Error in setwd(mydatadir): cannot change working directory
```
