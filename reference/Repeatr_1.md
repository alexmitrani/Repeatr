# imports raw data in CSV format (1 row per show), cleans the data, and reshapes it long so that the rows are identified by combinations of gid and song_number.

This was originally developed with a file called "fugotcha.csv", the
first line of which went like this:

washington-dc-usa-90387 FLS0001 03/09/1987 Wilson Center \$5 300 Joey
Picuri Fugazi Cassette Joe \#1 Intro Song \#1 Furniture Merchandise Turn
Off Your Guns In Defense Of Humans Waiting Room The Word

"gid" is short for "gig id"

Another data file that was used was called
"releases_songs_durations_wikipedia.csv" and was obtained from the
Wikipedia data on the Fugazi discography.

This file contains the following variables: index releaseid release
track_number songid song instrumental vocals_picciotto vocals_mackaye
vocals_lally duration_seconds

## Usage

``` r
Repeatr_1(mycsvfile = NULL, mysongdatafile = NULL, releasesdatafile = NULL)
```

## Arguments

- mycsvfile:

  Optional name of CSV file containing Fugazi Live Series data to be
  used. If omitted, the default file provided with the package will be
  used.

- mysongdatafile:

  Optional name of CSV file containing song data to be used. If omitted,
  the default file provided with the package will be used.

- releasesdatafile:

  Optional name of CSV file containing releases data to be used. If
  omitted, the default file provided with the package will be used.

## Examples

``` r
fugotcha <- system.file("extdata", "fugotcha.csv", package = "Repeatr")
releases_songs_durations_wikipedia <- system.file("extdata", "releases_songs_durations_wikipedia.csv", package = "Repeatr")
releasesdatafile <- system.file("extdata", "releases.csv", package = "Repeatr")
Repeatr_1_results <- Repeatr_1(mycsvfile = fugotcha, mysongdatafile = releases_songs_durations_wikipedia, releasesdatafile = releasesdatafile)
#> Joining with `by = join_by(date, venue)`
#> Joining with `by = join_by(year)`
#> Warning: cannot open file '/home/runner/work/Repeatr/Repeatr/docs/reference/inst/extdata/fls_venue_geocoding.csv': No such file or directory
#> Error in file(file, "rt"): cannot open the connection
```
