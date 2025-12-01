# Adds an initial text column and a footer with text to tables for download.

All columns in the dataframe will be converted to character formaat to
avoid blanks appearing as "NA".

When the downloaded file is opened in Excel or a similar program,
numeric columns should still be recognised as numeric.

## Usage

``` r
download_table_footer(
  mydf,
  nblankrows = 1,
  textcolumnname = "Sources",
  rowtext = NULL
)
```

## Arguments

- mydf:

  datafrae to work with

- nblankrows:

  number of blank rows to add before text at bottom of table

- textcolumnname:

  name of text column that will be added to the front of the dataframe

- rowtext:

  character vector of text to be added at bottom of table

## Details

download_table_footer

## Examples

``` r
sourcestext = c("https://alexmitrani.shinyapps.io/Fugazetteer/","https://dischord.com/fugazi_live_series")
mydf <- download_table_footer(mydf = Repeatr::summary, nblankrows = 1, textcolumnname = "sources", rowtext = sourcestext)
```
