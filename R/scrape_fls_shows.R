

# Internal helpers -----------------------------------------------------------

# gids that have a Fugazi Live Series detail page but aren't an actual show,
# so should never be scraped into the show data. "fugazi-live-all-access"
# (FLS0000) is a standing all-access download bundle, not a show - it has no
# date and doesn't fit the show row schema. This is not expected to change.
fls_non_show_gids <- c("fugazi-live-all-access")

# Extracts the highest page number referenced in the site's pagination widget
# on a listing page. Requesting a page beyond this does not 404 - the site
# silently returns unrelated fallback content - so this must be read fresh
# from the page rather than assumed/hardcoded.
fls_get_max_listing_page <- function(page) {

  hrefs <- page %>%
    rvest::html_elements("ul.pagination a.page-link") %>%
    rvest::html_attr("href")

  page_nums <- as.integer(stringr::str_extract(hrefs, "(?<=page=)\\d+"))
  page_nums <- page_nums[is.na(page_nums) == FALSE]

  if (length(page_nums) == 0) {
    return(1L)
  }

  max(page_nums)

}

# Scrapes the show links (gids) out of one listing page, along with the
# "Available" Yes/No flag, touring period, and city/subdivision/country shown
# for each show, scoped specifically to the show-listing tables since the
# page template also contains an unrelated "on this day" link elsewhere that
# matches the same URL pattern used for gid discovery. All of this is
# captured here (for free, since the page is already being fetched for gid
# discovery) so that shows whose recording has newly gone from unavailable
# to available can be detected, and every show's tour/location recovered,
# without extra per-show requests - city/subdivision/country and tour are not
# shown on a show's own detail page in a form the existing per-show scraper
# reads, only here on the listing pages.
#
# Walks row-by-row (rather than pulling each field as an independent
# html_elements() call across the whole table and hoping the resulting
# vectors stay aligned) so gid/available/city/subdivision/country can't
# silently drift out of sync with each other if a row is ever missing one
# of them.
#
# Tour is not a column within each row - it's shown as an <h2> heading
# immediately preceding the table.fugazi-shows-table for that tour, with
# (potentially) several <h2>+table pairs on one listing page. City/state/
# country ARE per-row: shown as separate links (href containing
# "filter%5Bcity%5D=" / "filter%5Bstate%5D=" / "filter%5Bcountry%5D=") in
# the City/State and Country columns (the site's own labels; our column is
# `subdivision`, see below); subdivision is absent (NA) for shows outside
# the US, Canada, and Australia, which don't have one to show.
#
# None of this is verified against the live site by an actual R run as of
# this writing (the structure was confirmed by inspecting the page, not by
# executing this code) - spot-check with a small max_listing_pages before
# trusting a full crawl.
#
# carry_tour supplies the tour already in effect when this page starts, for
# the case where one tour's shows are split across a page boundary and the
# heading is only shown once, on the earlier page.
fls_scrape_listing_page <- function(page_num, base_url, user_agent, carry_tour = NA_character_) {

  url <- if (page_num == 1) base_url else paste0(base_url, "?page=", page_num)

  page <- rvest::read_html(url, user_agent = user_agent)

  tables <- page %>% rvest::html_elements("table.fugazi-shows-table")

  current_tour <- carry_tour

  gids <- character(0)
  available <- character(0)
  tour <- character(0)
  city <- character(0)
  subdivision <- character(0)
  country <- character(0)

  for (tbl in tables) {

    heading <- xml2::xml_find_first(tbl, "preceding-sibling::h2[1]")

    if (is.na(heading) == FALSE) {
      current_tour <- heading %>% rvest::html_text2() %>% stringr::str_trim()
    }

    # Not scoped to "tbody tr" - HTML tables don't always get an explicit
    # <tbody> node in the parsed tree (libxml2's HTML parser doesn't
    # reliably insert one the way a browser DOM does), which silently
    # matched zero rows here. Header rows (no td.date a) are filtered out
    # below instead, the same way the original gid-only version of this
    # function implicitly relied on td.date only existing in data rows.
    rows <- tbl %>% rvest::html_elements("tr")

    for (row in rows) {

      date_href <- row %>%
        rvest::html_element("td.date a") %>%
        rvest::html_attr("href")

      if (is.na(date_href)) {
        next
      }

      gids <- c(gids, basename(date_href))

      available <- c(available, row %>%
        rvest::html_element("td.available") %>%
        rvest::html_text2() %>%
        stringr::str_trim())

      tour <- c(tour, current_tour)

      city <- c(city, row %>%
        rvest::html_element("a[href*='filter%5Bcity%5D=']") %>%
        rvest::html_text2() %>%
        stringr::str_trim())

      subdivision <- c(subdivision, row %>%
        rvest::html_element("a[href*='filter%5Bstate%5D=']") %>%
        rvest::html_text2() %>%
        stringr::str_trim())

      country <- c(country, row %>%
        rvest::html_element("a[href*='filter%5Bcountry%5D=']") %>%
        rvest::html_text2() %>%
        stringr::str_trim())

    }

  }

  list(page = page, gids = gids, available = available, tour = tour,
       city = city, subdivision = subdivision, country = country, last_tour = current_tour)

}

# Discovers every gid currently listed on the site (plus its Available
# flag, tour, and city/subdivision/country), paging through the listing until the
# site's own pagination widget says there are no more pages (capped by
# max_listing_pages for testing). Returns a data frame with one row per
# gid, deduplicated in case a show is ever linked from more than one place
# on a listing page.
fls_discover_gids <- function(base_url, max_listing_pages, sleepseconds, user_agent) {

  message("Discovering listing pages from ", base_url)

  first <- fls_scrape_listing_page(1, base_url, user_agent)

  total_pages <- min(fls_get_max_listing_page(first$page), max_listing_pages)

  message("Found ", total_pages, " listing page(s) to scrape (site max may be higher if capped by max_listing_pages)")

  message("Scraping listing page 1 of ", total_pages)

  all_gids <- first$gids
  all_available <- first$available
  all_tour <- first$tour
  all_city <- first$city
  all_subdivision <- first$subdivision
  all_country <- first$country
  last_tour <- first$last_tour

  if (total_pages > 1) {

    for (page_num in 2:total_pages) {

      Sys.sleep(sleepseconds)

      message("Scraping listing page ", page_num, " of ", total_pages)

      this_page <- fls_scrape_listing_page(page_num, base_url, user_agent, carry_tour = last_tour)

      all_gids <- c(all_gids, this_page$gids)
      all_available <- c(all_available, this_page$available)
      all_tour <- c(all_tour, this_page$tour)
      all_city <- c(all_city, this_page$city)
      all_subdivision <- c(all_subdivision, this_page$subdivision)
      all_country <- c(all_country, this_page$country)
      last_tour <- this_page$last_tour

    }

  }

  listing <- data.frame(gid = all_gids, available = all_available, tour = all_tour,
                         city = all_city, subdivision = all_subdivision, country = all_country,
                         stringsAsFactors = FALSE)

  listing[duplicated(listing$gid) == FALSE, ]

}

# Reads a summary of the existing dataset out of either the tidy CSV produced
# by scrape_fls_shows(), or the legacy headerless fugotcha.csv format (gid in
# the first column, tracks from the 10th column onward) - so incremental runs
# and change-detection work against either. Returns a data frame with one row
# per known gid and a has_tracks flag (whether a tracklist is already on file
# for that show), which is what lets newly-available recordings be detected.
fls_read_existing_summary <- function(path) {

  df <- utils::read.csv(path, header = TRUE, stringsAsFactors = FALSE)

  if ("gid" %in% names(df)) {

    track_cols <- grep("^track_", names(df), value = TRUE)

    has_tracks <- if (length(track_cols) == 0) {
      rep(FALSE, nrow(df))
    } else {
      apply(as.data.frame(df[, track_cols]), 1, function(row) {
        any(is.na(row) == FALSE & nchar(stringr::str_trim(row)) > 0)
      })
    }

    return(data.frame(gid = df$gid, has_tracks = has_tracks, stringsAsFactors = FALSE))

  }

  df <- utils::read.csv(path, header = FALSE, stringsAsFactors = FALSE)

  has_tracks <- is.na(df$V10) == FALSE & nchar(stringr::str_trim(as.character(df$V10))) > 0

  data.frame(gid = df$V1, has_tracks = has_tracks, stringsAsFactors = FALSE)

}

# Scrapes a single show detail page into a named list of scalar fields plus
# an ordered character vector of track names. dt/dd pairs on this site are
# omitted entirely (not left blank) when a show has no data for that field,
# so fields are looked up by label rather than by fixed position.
fls_scrape_show <- function(gid, base_url, user_agent) {

  url <- paste0(base_url, "/", gid)

  page <- rvest::read_html(url, user_agent = user_agent)

  html_show <- page %>% rvest::html_elements("#releaseDetail")

  fls_id <- html_show %>%
    rvest::html_element("h1 span.releaseNumber") %>%
    rvest::html_text2() %>%
    stringr::str_extract("FLS\\d+")

  dl <- html_show %>% rvest::html_element("dl.release-details")

  if (is.na(dl)) {

    labels <- character(0)
    dd_nodes <- list()

  } else {

    dd_nodes <- dl %>% rvest::html_elements("dd")

    labels <- dl %>%
      rvest::html_elements("dt") %>%
      rvest::html_text2() %>%
      stringr::str_trim()

  }

  get_field <- function(label) {

    idx <- match(label, labels)

    if (is.na(idx)) {
      return(NA_character_)
    }

    stringr::str_trim(rvest::html_text2(dd_nodes[[idx]]))

  }

  show_date_raw <- get_field("Show Date:")

  show_date <- if (is.na(show_date_raw) || nchar(show_date_raw) == 0) {
    NA_character_
  } else {
    format(lubridate::ymd(show_date_raw), "%d/%m/%Y")
  }

  sound_quality_idx <- match("Sound Quality:", labels)

  sound_quality <- if (is.na(sound_quality_idx)) {
    NA_character_
  } else {
    sq <- dd_nodes[[sound_quality_idx]] %>%
      rvest::html_element("strong") %>%
      rvest::html_text2()
    if (is.na(sq)) NA_character_ else stringr::str_trim(sq)
  }

  # Official notes, when present, sit in a div.trix-content between Sound
  # Quality and the sample-track player. The source wraps it in a <p
  # class='information'> that HTML5 parsing auto-closes before the <div> (a
  # <p> can't legally contain a block element), so the div ends up as a
  # sibling rather than nested inside that <p> - hence targeting the div
  # directly rather than "p.information div.trix-content".
  fls_notes <- html_show %>%
    rvest::html_element("div.trix-content") %>%
    rvest::html_text2()

  fls_notes <- if (is.na(fls_notes) || nchar(stringr::str_trim(fls_notes)) == 0) {
    NA_character_
  } else {
    stringr::str_trim(fls_notes)
  }

  tracks <- html_show %>%
    rvest::html_elements("div.mp3_list td.track_name") %>%
    rvest::html_text2() %>%
    stringr::str_trim()

  list(
    gid = gid,
    fls_id = fls_id,
    show_date = show_date,
    venue = get_field("Venue:"),
    door_price = get_field("Door Price:"),
    attendance = get_field("Attendance:"),
    recorded_by = get_field("Recorded by"),
    mastered_by = get_field("Mastered by"),
    original_source = get_field("Original Source:"),
    sound_quality = sound_quality,
    played_with = get_field("Played with:"),
    fls_notes = fls_notes,
    tracks = tracks
  )

}

# Turns a list of fls_scrape_show() results into one tidy data frame, padding
# every show's track list out to the widest tracklist found in the batch.
fls_shows_to_dataframe <- function(shows) {

  track_lengths <- vapply(shows, function(x) length(x$tracks), integer(1))

  max_tracks <- max(0L, track_lengths)

  rows <- lapply(shows, function(x) {

    track_values <- x$tracks
    length(track_values) <- max_tracks

    track_cols <- as.list(track_values)

    if (max_tracks > 0) {
      names(track_cols) <- paste0("track_", seq_len(max_tracks))
    }

    as.data.frame(
      c(x[setdiff(names(x), "tracks")], track_cols),
      stringsAsFactors = FALSE
    )

  })

  dplyr::bind_rows(rows)

}


# Main function ---------------------------------------------------------------

#' @name scrape_fls_shows
#' @title Scrape an up-to-date Fugazi Live Series dataset, including new shows
#' @description Discovers the full, current list of shows directly from the
#'   Fugazi Live Series listing pages (`https://www.dischord.com/fugazi_live_series?page=N`),
#'   auto-detecting how many listing pages currently exist from the site's own
#'   pagination widget rather than assuming a fixed number - so it picks up
#'   shows added since the last scrape without any manual bookkeeping.
#' @description For each target show it scrapes one detail page and returns a
#'   single tidy row combining the same information as `fugotcha.csv` (show
#'   date, venue, door price, attendance, recorded by, mastered by, original
#'   source, tracklist) plus sound quality and played-with, which previously
#'   required separate scraping passes (see `scrape_fls_data.R`).
#' @description By default, only shows not already present in `existing_data`
#'   are scraped, so routine re-runs are cheap and polite to the site. Set
#'   `update_existing = TRUE` to re-scrape everything discovered.
#' @description The listing pages also show an Available Yes/No flag per show
#'   (whether a recording is downloadable), which is captured for free while
#'   discovering gids. When `detect_changes = TRUE` (the default), any show
#'   already on file with no tracklist yet, whose flag has since turned to
#'   "Yes", is added to the scrape targets alongside brand-new shows - this
#'   catches shows that had a tracklist (and usually sound quality/played
#'   with) added after the fact, without visiting every existing show's page.
#'   This can only catch changes visible on the listing page itself (a
#'   recording newly appearing); it won't catch e.g. a corrected door price
#'   or a sound quality rating changed on a show that was already available -
#'   use `update_existing = TRUE` (optionally with `gids` to target specific
#'   shows) to refresh those.
#' @description `fugazi-live-all-access` (FLS0000) has a detail page like a
#'   show but is actually a standing all-access download bundle, not a show -
#'   it is always excluded from the scrape targets.
#'
#' @param existing_data Path to a CSV used to determine which gids are already
#'   known, so only new shows get scraped. Accepts either the tidy format this
#'   function produces (must have a `gid` column) or the legacy headerless
#'   `fugotcha.csv` format (gid in the first column). Defaults to the
#'   `fugotcha.csv` shipped with the package. Ignored when `update_existing = TRUE`.
#' @param update_existing If `TRUE`, scrape every discovered (or supplied) gid
#'   regardless of what's in `existing_data`. Default `FALSE`.
#' @param detect_changes If `TRUE` (the default), also re-scrape shows already
#'   in `existing_data` that have no tracklist on file but whose listing-page
#'   Available flag has turned to "Yes", since that means a recording was
#'   added after the last scrape. Only applies during listing-page discovery
#'   (i.e. when `gids` is not supplied) and is ignored when `update_existing = TRUE`
#'   (which already re-scrapes everything).
#' @param gids Optional character vector of specific gids to scrape, bypassing
#'   listing-page discovery entirely. Useful for testing or for refreshing a
#'   handful of known shows.
#' @param max_shows Maximum number of shows to scrape. Set to a low number for
#'   testing. Defaults to `Inf` (no cap).
#' @param max_listing_pages Maximum number of listing pages to page through
#'   during discovery. Set to a low number for testing. Defaults to `Inf`
#'   (pages through everything the site's pagination widget reports). Ignored
#'   when `gids` is supplied.
#' @param sleepseconds Seconds to wait before every request (both listing
#'   pages and show pages), to stay polite to the site. Default 2.
#' @param mycsvfilename Optional filename to write the resulting data frame to
#'   as a CSV (headered, UTF-8). If `NULL` (the default) the result is only
#'   returned, not written to disk.
#'
#' @import rvest
#' @import xml2
#' @import stringr
#' @import dplyr
#' @import lubridate
#' @return A data frame with one row per show and columns `gid`, `fls_id`,
#'   `show_date`, `venue`, `door_price`, `attendance`, `recorded_by`,
#'   `mastered_by`, `original_source`, `sound_quality`, `played_with`,
#'   `fls_notes` (any official note shown on the show's page, e.g. "Previously
#'   released on CD (FLS29)"; `NA` when the show has none), `tour` (the
#'   touring period, e.g. "1988 Fall European Tour"), `city`, `subdivision`
#'   (`NA` outside the US, Canada, and Australia, which don't have one to
#'   show), `country` - the
#'   last four all read from the listing page, not the show's own detail
#'   page (see \code{\link{scrape_fls_listing_data}}), so all four are `NA`
#'   when `gids` is supplied directly, since that bypasses the listing-page
#'   crawl they come from - and `track_1` ... `track_n` (as many track
#'   columns as the widest tracklist in the result).
#' @export
#'
#' @examples
#' # Small-scale test: only the first listing page, and only 3 new shows
#' test_shows <- scrape_fls_shows(max_listing_pages = 1, max_shows = 3, sleepseconds = 2)
#'
#' # Re-scrape a few specific, already-known shows (e.g. to spot-check fields)
#' known_shows <- scrape_fls_shows(
#'   gids = c("washington-dc-usa-90387", "chapel-hill-nc-usa-92787"),
#'   update_existing = TRUE,
#'   sleepseconds = 2
#' )
#'
#' \dontrun{
#' # Full run: only shows not already in the packaged fugotcha.csv, writing
#' # the result out to a new CSV. This can make 1000+ requests and take
#' # 30-40 minutes, so it is not run automatically.
#' updated_shows <- scrape_fls_shows(mycsvfilename = "fugotcha_updated.csv")
#' }
#'
scrape_fls_shows <- function(existing_data = NULL,
                              update_existing = FALSE,
                              detect_changes = TRUE,
                              gids = NULL,
                              max_shows = Inf,
                              max_listing_pages = Inf,
                              sleepseconds = 2,
                              mycsvfilename = NULL) {

  base_url <- "https://www.dischord.com/fugazi_live_series"

  user_agent <- "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36"

  httr::set_config(httr::user_agent(user_agent))

  if (is.null(existing_data)) {
    existing_data <- system.file("extdata", "fugotcha.csv", package = "Repeatr")
  }

  existing_summary <- NULL

  if (nzchar(existing_data) && file.exists(existing_data)) {
    existing_summary <- fls_read_existing_summary(existing_data)
  }

  listing <- NULL

  if (is.null(gids)) {

    listing <- fls_discover_gids(base_url, max_listing_pages, sleepseconds, user_agent)

    target_gids <- listing$gid

  } else {

    target_gids <- unique(gids)

  }

  if (update_existing == FALSE) {

    known_gids <- if (is.null(existing_summary)) character(0) else existing_summary$gid

    target_gids <- setdiff(target_gids, known_gids)

    if (detect_changes && is.null(listing) == FALSE && is.null(existing_summary) == FALSE) {

      previously_unavailable <- existing_summary$gid[existing_summary$has_tracks == FALSE]

      now_available <- listing$gid[listing$available == "Yes"]

      changed_gids <- intersect(previously_unavailable, now_available)

      if (length(changed_gids) > 0) {
        message("Detected ", length(changed_gids), " previously-unavailable show(s) that now show a recording as available - re-scraping them too")
      }

      target_gids <- union(target_gids, changed_gids)

    }

  }

  target_gids <- setdiff(target_gids, fls_non_show_gids)

  if (length(target_gids) > max_shows) {
    target_gids <- target_gids[1:max_shows]
  }

  message("Scraping ", length(target_gids), " show(s)")

  shows <- list()

  for (i in seq_along(target_gids)) {

    gid <- target_gids[i]

    Sys.sleep(sleepseconds)

    message("Scraping show ", i, " of ", length(target_gids), ": ", gid)

    shows[[i]] <- fls_scrape_show(gid, base_url, user_agent)

  }

  if (length(shows) == 0) {
    message("No new shows found to scrape.")
    empty <- fls_shows_to_dataframe(list())
    empty$tour <- character(0)
    empty$city <- character(0)
    empty$subdivision <- character(0)
    empty$country <- character(0)
    return(empty)
  }

  results <- fls_shows_to_dataframe(shows)

  # tour/city/subdivision/country are only ever known from the listing-page
  # crawl (none of them are shown in a form the per-show scraper above reads
  # on a show's own detail page - see fls_scrape_listing_page()), so they're
  # only available here when that crawl actually ran (gids wasn't supplied
  # directly).
  if (is.null(listing) == FALSE) {

    results <- results %>%
      dplyr::left_join(listing[, c("gid", "tour", "city", "subdivision", "country")], by = "gid")

  } else {

    results$tour <- NA_character_
    results$city <- NA_character_
    results$subdivision <- NA_character_
    results$country <- NA_character_

  }

  if (is.null(mycsvfilename) == FALSE) {

    # Writing out is a nice-to-have on top of the (potentially long, rate-
    # limited) scrape above - if the path is bad, warn and still return the
    # scraped data rather than losing it by letting write.csv's error abort
    # the whole function before it can return anything.
    tryCatch(

      utils::write.csv(results, file = mycsvfilename, fileEncoding = "UTF-8", row.names = FALSE),

      error = function(e) {
        warning(
          "Could not write to '", mycsvfilename, "': ", conditionMessage(e),
          ". Returning the scraped data anyway - write it out yourself, e.g. write.csv(results, \"<path>\", row.names = FALSE).",
          call. = FALSE
        )
      }

    )

  }

  return(results)

}

#' @name scrape_fls_listing_data
#' @title Scrape just the gid -> tour/city/subdivision/country mapping from the FLS listing pages
#' @description Crawls only the Fugazi Live Series listing pages
#'   (`https://www.dischord.com/fugazi_live_series?page=N`) to recover each
#'   show's touring period (e.g. "1988 Fall European Tour") and location
#'   (city, subdivision, and country). None of these four are
#'   shown on individual show detail pages in a form \code{\link{scrape_fls_shows}}'s
#'   per-show scrape reads - tour is an `<h2>` heading grouping the shows
#'   table beneath it, and city/subdivision/country are separate filter links in
#'   the listing table's own columns - so that function can't recover any
#'   of them for a show unless it happens to be re-scraped for some other
#'   reason.
#' @description Because this only needs the listing pages (a few dozen
#'   requests total), not one request per show, it's the cheap way to
#'   backfill all four onto every already-known show, e.g.:
#'   `fls_data <- fls_data %>% select(-tour, -city, -subdivision, -country) %>% left_join(scrape_fls_listing_data(), by = "gid")`
#'   - much faster than a full `update_existing = TRUE` \code{\link{scrape_fls_shows}}
#'   re-scrape, which would revisit every show's own detail page for no
#'   benefit here (none of these four are there).
#' @description This has not been verified against the live site by an
#'   actual R run as of this writing (the page structure it targets was
#'   confirmed by inspecting the page, not by executing this code) -
#'   spot-check with `max_listing_pages = 1` before trusting a full crawl.
#'
#' @param max_listing_pages Maximum number of listing pages to page through.
#'   Set to a low number for testing. Defaults to `Inf` (pages through
#'   everything the site's pagination widget reports).
#' @param sleepseconds Seconds to wait before every request, to stay polite
#'   to the site. Default 2.
#'
#' @import rvest
#' @import xml2
#' @import stringr
#' @return A data frame with one row per show currently listed on the site,
#'   columns `gid`, `tour`, `city`, `subdivision` (`NA` outside the US,
#'   Canada, and Australia), `country`.
#' @export
#'
#' @examples
#' # Small-scale test: only the first listing page
#' test_listing_data <- scrape_fls_listing_data(max_listing_pages = 1)
#'
scrape_fls_listing_data <- function(max_listing_pages = Inf, sleepseconds = 2) {

  base_url <- "https://www.dischord.com/fugazi_live_series"

  user_agent <- "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36"

  httr::set_config(httr::user_agent(user_agent))

  listing <- fls_discover_gids(base_url, max_listing_pages, sleepseconds, user_agent)

  listing[, c("gid", "tour", "city", "subdivision", "country")]

}
