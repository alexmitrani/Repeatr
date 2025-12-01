# production of date stamps

datestampr is used to create the datestamps used to produce unique
filenames for the output files.

## Usage

``` r
datestampr(
  dateonly = FALSE,
  houronly = FALSE,
  minuteonly = FALSE,
  myusername = FALSE
)
```

## Arguments

- dateonly:

  requests a simplified timestamp with only the date (no time).

- houronly:

  requests a simplified timestamp with only the date and the hour (no
  minutes or seconds).

- minuteonly:

  requests a simplified timestamp with only the date, the hour and the
  minutes (no seconds).

- myusername:

  adds the active username to the timestamp.

## Details

datestampr is used internally by the fsm package.

## Examples

``` r
datestring <- datestampr(myusername=TRUE)
cat(yellow(paste0("\n \n", "Hello world, have a datestamp: ", datestring, "\n \n")))
#> 
#>  
#> Hello world, have a datestamp: 20251201110534
#>  
#> 
```
