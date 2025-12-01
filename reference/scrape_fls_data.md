# Scrape data from Fugazi Live Series pages

A simple function to scrape data from the Fugazi Live Series website
using rvest.

## Usage

``` r
scrape_fls_data(
  mygiddata = NULL,
  mylimit = 3,
  sleepseconds = 1,
  mycsvfilename = "gid_fls_id_sound_quality.csv",
  my_data_html_element = "dd strong"
)
```

## Arguments

- mygiddata:

  Name of data frame containing list of gids to be scraped (optional).
  If this is not specified gids from othervariables will be used (1048
  of them).

- mylimit:

  The number of shows from which to scrape sound quality rating. Set to
  a low number for testing.

- sleepseconds:

  seconds to wait before getting info from the next page.

- mycsvfilename:

  filename for the CSV file to which the results will be written.

- my_data_html_element:

  html element that contains the data to be scraped

## Examples

``` r
scraped_data_1 <- scrape_fls_data(mygiddata = NULL, mylimit = 3, sleepseconds = 1, mycsvfilename = "gid_fls_id_sound_quality.csv", my_data_html_element = "dd strong")
#> [1] "Scraping https://www.dischord.com/fugazi_live_series/aalst-belgium-92390"
#> [1] "Scraping https://www.dischord.com/fugazi_live_series/aberdeen-scotland-50499"
#> [1] "Scraping https://www.dischord.com/fugazi_live_series/adelaide-australia-111193"
scraped_data_2 <- scrape_fls_data(mygiddata = NULL, mylimit = 3, sleepseconds = 1, mycsvfilename = "gid_fls_id_played_with.csv", my_data_html_element = "dd:nth-child(10)")
#> [1] "Scraping https://www.dischord.com/fugazi_live_series/aalst-belgium-92390"
#> [1] "Scraping https://www.dischord.com/fugazi_live_series/aberdeen-scotland-50499"
#> [1] "Scraping https://www.dischord.com/fugazi_live_series/adelaide-australia-111193"
mydf <- system.file("extdata", "gid_played_with_8.csv", package = "Repeatr")
scraped_data_3 <- scrape_fls_data(mygiddata = mydf, mylimit = 3, sleepseconds = 1, mycsvfilename = "gid_fls_id_played_with_8.csv", my_data_html_element = "dd:nth-child(8)")
#> Error in UseMethod("select"): no applicable method for 'select' applied to an object of class "character"
mydf <- system.file("extdata", "gid_played_with_6.csv", package = "Repeatr")
scraped_data_4 <- scrape_fls_data(mygiddata = mydf, mylimit = 3, sleepseconds = 1, mycsvfilename = "gid_fls_id_played_with_6.csv", my_data_html_element = "dd:nth-child(6)")
#> Error in UseMethod("select"): no applicable method for 'select' applied to an object of class "character"
```
