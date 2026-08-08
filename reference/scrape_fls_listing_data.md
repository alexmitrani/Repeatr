# Scrape just the gid -\> tour/city/subdivision/country mapping from the FLS listing pages

Crawls only the Fugazi Live Series listing pages
(`https://www.dischord.com/fugazi_live_series?page=N`) to recover each
show's touring period (e.g. "1988 Fall European Tour") and location
(city, subdivision, and country). None of these four are shown on
individual show detail pages in a form
[`scrape_fls_shows`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_shows.md)'s
per-show scrape reads - tour is an `<h2>` heading grouping the shows
table beneath it, and city/subdivision/country are separate filter links
in the listing table's own columns - so that function can't recover any
of them for a show unless it happens to be re-scraped for some other
reason.

Because this only needs the listing pages (a few dozen requests total),
not one request per show, it's the cheap way to backfill all four onto
every already-known show, e.g.:
`fls_data <- fls_data %>% select(-tour, -city, -subdivision, -country) %>% left_join(scrape_fls_listing_data(), by = "gid")`

- much faster than a full `update_existing = TRUE`
  [`scrape_fls_shows`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_shows.md)
  re-scrape, which would revisit every show's own detail page for no
  benefit here (none of these four are there).

This has not been verified against the live site by an actual R run as
of this writing (the page structure it targets was confirmed by
inspecting the page, not by executing this code) - spot-check with
`max_listing_pages = 1` before trusting a full crawl.

## Usage

``` r
scrape_fls_listing_data(max_listing_pages = Inf, sleepseconds = 2)
```

## Arguments

- max_listing_pages:

  Maximum number of listing pages to page through. Set to a low number
  for testing. Defaults to `Inf` (pages through everything the site's
  pagination widget reports).

- sleepseconds:

  Seconds to wait before every request, to stay polite to the site.
  Default 2.

## Value

A data frame with one row per show currently listed on the site, columns
`gid`, `tour`, `city`, `subdivision` (`NA` outside the US, Canada, and
Australia), `country`.

## Examples

``` r
if (FALSE) { # \dontrun{
# Makes live requests to dischord.com - not run automatically.
test_listing_data <- scrape_fls_listing_data(max_listing_pages = 1)
} # }
```
