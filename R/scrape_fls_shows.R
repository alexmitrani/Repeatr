

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
# "Available" Yes/No flag shown next to each show, scoped specifically to the
# show-listing tables since the page template also contains an unrelated
# "on this day" link elsewhere that matches the same URL pattern. The
# available flag is captured here (for free, since the page is already being
# fetched for gid discovery) so that shows whose recording has newly gone
# from unavailable to available can be detected without extra requests.
fls_scrape_listing_page <- function(page_num, base_url, user_agent) {

  url <- if (page_num == 1) base_url else paste0(base_url, "?page=", page_num)

  page <- rvest::read_html(url, user_agent = user_agent)

  hrefs <- page %>%
    rvest::html_elements("table.fugazi-shows-table td.date a") %>%
    rvest::html_attr("href")

  gids <- basename(hrefs)

  available <- page %>%
    rvest::html_elements("table.fugazi-shows-table td.available") %>%
    rvest::html_text2() %>%
    stringr::str_trim()

  list(page = page, gids = gids, available = available)

}

# Discovers every gid currently listed on the site (plus its Available flag),
# paging through the listing until the site's own pagination widget says
# there are no more pages (capped by max_listing_pages for testing). Returns
# a data frame with one row per gid, deduplicated in case a show is ever
# linked from more than one place on a listing page.
fls_discover_gids <- function(base_url, max_listing_pages, sleepseconds, user_agent) {

  message("Discovering listing pages from ", base_url)

  first <- fls_scrape_listing_page(1, base_url, user_agent)

  total_pages <- min(fls_get_max_listing_page(first$page), max_listing_pages)

  message("Found ", total_pages, " listing page(s) to scrape (site max may be higher if capped by max_listing_pages)")

  message("Scraping listing page 1 of ", total_pages)

  all_gids <- first$gids
  all_available <- first$available

  if (total_pages > 1) {

    for (page_num in 2:total_pages) {

      Sys.sleep(sleepseconds)

      message("Scraping listing page ", page_num, " of ", total_pages)

      this_page <- fls_scrape_listing_page(page_num, base_url, user_agent)

      all_gids <- c(all_gids, this_page$gids)
      all_available <- c(all_available, this_page$available)

    }

  }

  listing <- data.frame(gid = all_gids, available = all_available, stringsAsFactors = FALSE)

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
#' @import stringr
#' @import dplyr
#' @import lubridate
#' @return A data frame with one row per show and columns `gid`, `fls_id`,
#'   `show_date`, `venue`, `door_price`, `attendance`, `recorded_by`,
#'   `mastered_by`, `original_source`, `sound_quality`, `played_with`, and
#'   `track_1` ... `track_n` (as many track columns as the widest tracklist in
#'   the result).
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
    return(fls_shows_to_dataframe(list()))
  }

  results <- fls_shows_to_dataframe(shows)

  if (is.null(mycsvfilename) == FALSE) {

    utils::write.csv(results, file = mycsvfilename, fileEncoding = "UTF-8", row.names = FALSE)

  }

  return(results)

}
