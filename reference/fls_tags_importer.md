# imports a .txt file of duration data, converts the duration variable to hh:mm:ss (hms) format, and exports the resulting data to an rda file.

fls_tags_importer is used to import a .txt file of duration data
generated with kid3 audio tagger (https://kid3.kde.org/)

## Usage

``` r
fls_tags_importer(myfilename = NULL)
```

## Arguments

- myfilename:

  the full path and filename of the file to be imported and converted.

## Details

fls_tags_importer

## Examples

``` r
fls_tags_importer(myfilename = "C:/Users/alexm/Music/fls_tags.txt")
#> Error: 'C:/Users/alexm/Music/fls_tags.txt' does not exist.

```
