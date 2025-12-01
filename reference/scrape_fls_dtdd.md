# Scrape data from Fugazi Live Series show info tables using dt and dd tags.

The dt tags hold the captions and the dd tags hold the data. The user
specifies what caption corresponds to the data they are interested in
and the function will get the data.

## Usage

``` r
scrape_fls_dtdd(
  mygiddata = NULL,
  mylimit = 3,
  sleepseconds = 1,
  mycsvfilename = "gid_fls_id_sound_quality.csv",
  mydt_caption = "Played with:",
  test_page_to_scrape = NULL
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

- mydt_caption:

  caption of data to be extracted. This could be: "Show Date:",
  "Venue:", "Door Price:", "Attendance:", "Played with:", "Recorded by",
  "Mastered by", or "Original Source:". The data will be extracted from
  the corresponding cell to the right of this caption, on the same row.

- test_page_to_scrape:

  specific URL to use for test

## Examples

``` r
scraped_data_played_with <- scrape_fls_dtdd(mygiddata = NULL, mylimit = 5, sleepseconds = 1, mycsvfilename = "gid_fls_id_fls_data.csv", mydt_caption = "Played with:")
#> [1] "Scraping https://www.dischord.com/fugazi_live_series/aalst-belgium-92390"
#> [1] "Scraping https://www.dischord.com/fugazi_live_series/aberdeen-scotland-50499"
#> [1] "Scraping https://www.dischord.com/fugazi_live_series/adelaide-australia-111193"
#> [1] "Scraping https://www.dischord.com/fugazi_live_series/adelaide-australia-111296"
#> [1] "Scraping https://www.dischord.com/fugazi_live_series/adelaide-sa-australia-102291"
scraped_data_original_source <- scrape_fls_dtdd(mygiddata = NULL, mylimit = 5, sleepseconds = 1, mycsvfilename = "gid_fls_id_fls_data.csv", mydt_caption = "Original Source:")
#> [1] "Scraping https://www.dischord.com/fugazi_live_series/aalst-belgium-92390"
#> [1] "Scraping https://www.dischord.com/fugazi_live_series/aberdeen-scotland-50499"
#> [1] "Scraping https://www.dischord.com/fugazi_live_series/adelaide-australia-111193"
#> [1] "Scraping https://www.dischord.com/fugazi_live_series/adelaide-australia-111296"
#> [1] "Scraping https://www.dischord.com/fugazi_live_series/adelaide-sa-australia-102291"
```
