# Scrape an up-to-date Fugazi Live Series dataset, including new shows

Discovers the full, current list of shows directly from the Fugazi Live
Series listing pages
(`https://www.dischord.com/fugazi_live_series?page=N`), auto-detecting
how many listing pages currently exist from the site's own pagination
widget rather than assuming a fixed number - so it picks up shows added
since the last scrape without any manual bookkeeping.

For each target show it scrapes one detail page and returns a single
tidy row combining the same information as `fugotcha.csv` (show date,
venue, door price, attendance, recorded by, mastered by, original
source, tracklist) plus sound quality and played-with, which previously
required separate scraping passes (see `scrape_fls_data.R`).

By default, only shows not already present in `existing_data` are
scraped, so routine re-runs are cheap and polite to the site. Set
`update_existing = TRUE` to re-scrape everything discovered.

The listing pages also show an Available Yes/No flag per show (whether a
recording is downloadable), which is captured for free while discovering
gids. When `detect_changes = TRUE` (the default), any show already on
file with no tracklist yet, whose flag has since turned to "Yes", is
added to the scrape targets alongside brand-new shows - this catches
shows that had a tracklist (and usually sound quality/played with) added
after the fact, without visiting every existing show's page. This can
only catch changes visible on the listing page itself (a recording newly
appearing); it won't catch e.g. a corrected door price or a sound
quality rating changed on a show that was already available - use
`update_existing = TRUE` (optionally with `gids` to target specific
shows) to refresh those.

`fugazi-live-all-access` (FLS0000) has a detail page like a show but is
actually a standing all-access download bundle, not a show - it is
always excluded from the scrape targets.

## Usage

``` r
scrape_fls_shows(
  existing_data = NULL,
  update_existing = FALSE,
  detect_changes = TRUE,
  gids = NULL,
  max_shows = Inf,
  max_listing_pages = Inf,
  sleepseconds = 2,
  mycsvfilename = NULL
)
```

## Arguments

- existing_data:

  Path to a CSV used to determine which gids are already known, so only
  new shows get scraped. Accepts either the tidy format this function
  produces (must have a `gid` column) or the legacy headerless
  `fugotcha.csv` format (gid in the first column). Defaults to the
  `fugotcha.csv` shipped with the package. Ignored when
  `update_existing = TRUE`.

- update_existing:

  If `TRUE`, scrape every discovered (or supplied) gid regardless of
  what's in `existing_data`. Default `FALSE`.

- detect_changes:

  If `TRUE` (the default), also re-scrape shows already in
  `existing_data` that have no tracklist on file but whose listing-page
  Available flag has turned to "Yes", since that means a recording was
  added after the last scrape. Only applies during listing-page
  discovery (i.e. when `gids` is not supplied) and is ignored when
  `update_existing = TRUE` (which already re-scrapes everything).

- gids:

  Optional character vector of specific gids to scrape, bypassing
  listing-page discovery entirely. Useful for testing or for refreshing
  a handful of known shows.

- max_shows:

  Maximum number of shows to scrape. Set to a low number for testing.
  Defaults to `Inf` (no cap).

- max_listing_pages:

  Maximum number of listing pages to page through during discovery. Set
  to a low number for testing. Defaults to `Inf` (pages through
  everything the site's pagination widget reports). Ignored when `gids`
  is supplied.

- sleepseconds:

  Seconds to wait before every request (both listing pages and show
  pages), to stay polite to the site. Default 2.

- mycsvfilename:

  Optional filename to write the resulting data frame to as a CSV
  (headered, UTF-8). If `NULL` (the default) the result is only
  returned, not written to disk.

## Value

A data frame with one row per show and columns `gid`, `fls_id`,
`show_date`, `venue`, `door_price`, `attendance`, `recorded_by`,
`mastered_by`, `original_source`, `sound_quality`, `played_with`,
`fls_notes` (any official note shown on the show's page, e.g.
"Previously released on CD (FLS29)"; `NA` when the show has none),
`tour` (the touring period, e.g. "1988 Fall European Tour"), `city`,
`subdivision` (`NA` outside the US, Canada, and Australia, which don't
have one to show), `country` - the last four all read from the listing
page, not the show's own detail page (see
[`scrape_fls_listing_data`](https://alexmitrani.github.io/Repeatr/reference/scrape_fls_listing_data.md)),
so all four are `NA` when `gids` is supplied directly, since that
bypasses the listing-page crawl they come from - and `track_1` ...
`track_n` (as many track columns as the widest tracklist in the result).

## Examples

``` r
# Small-scale test: only the first listing page, and only 3 new shows
test_shows <- scrape_fls_shows(max_listing_pages = 1, max_shows = 3, sleepseconds = 2)
#> Discovering listing pages from https://www.dischord.com/fugazi_live_series
#> Found 1 listing page(s) to scrape (site max may be higher if capped by max_listing_pages)
#> Scraping listing page 1 of 1
#> Detected 2 previously-unavailable show(s) that now show a recording as available - re-scraping them too
#> Scraping 2 show(s)
#> Scraping show 1 of 2: rockville-md-usa-40988
#> Scraping show 2 of 2: clarksville-in-usa-50788

# Re-scrape a few specific, already-known shows (e.g. to spot-check fields)
known_shows <- scrape_fls_shows(
  gids = c("washington-dc-usa-90387", "chapel-hill-nc-usa-92787"),
  update_existing = TRUE,
  sleepseconds = 2
)
#> Scraping 2 show(s)
#> Scraping show 1 of 2: washington-dc-usa-90387
#> Scraping show 2 of 2: chapel-hill-nc-usa-92787

if (FALSE) { # \dontrun{
# Full run: only shows not already in the packaged fugotcha.csv, writing
# the result out to a new CSV. This can make 1000+ requests and take
# 30-40 minutes, so it is not run automatically.
updated_shows <- scrape_fls_shows(mycsvfilename = "fugotcha_updated.csv")
} # }
```
