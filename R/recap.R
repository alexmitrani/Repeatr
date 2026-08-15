
#' @title format_ordinal formats an integer as an ordinal string, e.g. 1 -> "1st", 2 -> "2nd", 3 -> "3rd", 4 -> "4th", 11 -> "11th".
#'
#' @param n integer to format.
#'
#' @return A character string.
#' @export
#'
#' @examples
#' format_ordinal(1)
#' format_ordinal(22)
#'
format_ordinal <- function(n) {
  if (n %% 100 %in% 11:13) {
    paste0(n, "th")
  } else if (n %% 10==1) {
    paste0(n, "st")
  } else if (n %% 10==2) {
    paste0(n, "nd")
  } else if (n %% 10==3) {
    paste0(n, "rd")
  } else {
    paste0(n, "th")
  }
}

#' @title recap brings together all the notable facts about a single Fugazi show: date, venue, tour context, how many times the band had previously played in that country/state/city/venue, the previous and next show of the tour, and (if a recording exists) a detailed tracklist with duration, release and rendition statistics.
#'
#' @param mygid gig id of the show to recap, as a string, for instance "washington-dc-usa-13196".
#' @param myshows_data optional `shows_data` dataframe (as produced by `Repeatr_1()`) to be used for show/tour/location details. If omitted the currently lazy-loaded default will be used.
#' @param myduration_data_da optional `duration_data_da` dataframe (as produced by `Repeatr_1()`) to be used for recorded renditions, live durations and set position. If omitted the currently lazy-loaded default will be used.
#' @param myrepeatr1 optional `Repeatr1` dataframe (as produced by `Repeatr_1()`) to be used for release/track lookups. If omitted the currently lazy-loaded default will be used.
#' @param myreleasesdatalookup optional `releasesdatalookup` dataframe (as produced by `Repeatr_1()`) to be used for release dates. If omitted the currently lazy-loaded default will be used.
#' @param myduration_summary optional `duration_summary` dataframe (as produced by `Repeatr_1()`) to be used for each song's maximum recorded duration and total number of recorded renditions. If omitted the currently lazy-loaded default will be used.
#' @param myposition_summary optional `position_summary` dataframe (as produced by `Repeatr_1()`) to be used for each song's average recorded set position. If omitted the currently lazy-loaded default will be used.
#' @param myplayed_with optional `played_with` dataframe (as produced by `Repeatr_1()`) to be used for the bands Fugazi played with at the show. If omitted the currently lazy-loaded default will be used.
#'
#' @return A list of three elements: `context` (a named list of the show's prose-summary facts), `tracklist` (a dataframe with one row per song on the recording, or `NULL` if no recording exists) and `release_breakdown` (a dataframe of song counts by release for this show, or `NULL` if no recording exists).
#' @export
#'
#' @examples
#' result <- recap(mygid = "washington-dc-usa-13196")
#' result$context$where_played
#' result$tracklist
#'
recap <- function(mygid,
                   myshows_data = NULL, myduration_data_da = NULL,
                   myrepeatr1 = NULL, myreleasesdatalookup = NULL,
                   myduration_summary = NULL, myposition_summary = NULL,
                   myplayed_with = NULL) {

# pre-processing to check that all required parameters are defined -----------------------------------------------------------

  # Use freshly-supplied lookup tables if given, otherwise fall back to
  # whatever is currently lazy-loaded from data/ (the package's last build).
  if (is.null(myshows_data)==FALSE) { shows_data <- myshows_data } else { shows_data <- Repeatr::shows_data }
  if (is.null(myduration_data_da)==FALSE) { duration_data_da <- myduration_data_da } else { duration_data_da <- Repeatr::duration_data_da }
  if (is.null(myrepeatr1)==FALSE) { Repeatr1 <- myrepeatr1 } else { Repeatr1 <- Repeatr::Repeatr1 }
  if (is.null(myreleasesdatalookup)==FALSE) { releasesdatalookup <- myreleasesdatalookup } else { releasesdatalookup <- Repeatr::releasesdatalookup }
  if (is.null(myduration_summary)==FALSE) { duration_summary <- myduration_summary } else { duration_summary <- Repeatr::duration_summary }
  if (is.null(myposition_summary)==FALSE) { position_summary <- myposition_summary } else { position_summary <- Repeatr::position_summary }
  if (is.null(myplayed_with)==FALSE) { played_with <- myplayed_with } else { played_with <- Repeatr::played_with }

  this_show <- shows_data %>% filter(gid==mygid)

  if (nrow(this_show)!=1) {
    stop("mygid must match exactly one show in shows_data")
  }

# date string and location text -----------------------------------------------------------------------------------------------

  day_num <- lubridate::day(this_show$date)

  datestring <- paste0(weekdays(this_show$date), " the ", format_ordinal(day_num), " of ",
                        format(this_show$date, "%B"), " ", lubridate::year(this_show$date))

  where_played <- paste0(this_show$venue, ", ", this_show$city,
                          ifelse(is.na(this_show$subdivision) | this_show$subdivision=="", "", paste0(", ", this_show$subdivision)),
                          ", ", this_show$country)

  bands <- played_with %>% filter(gid==mygid) %>% pull(played_with)

  # Joins a vector of band names into a grammatically correct list: "A" for
  # one band, "A and B" for two, "A, B, and C" (Oxford comma) for three or more.
  played_with_text <- if (length(bands)==0) {
    ""
  } else if (length(bands)==1) {
    paste0(" with ", bands)
  } else if (length(bands)==2) {
    paste0(" with ", paste(bands, collapse = " and "))
  } else {
    paste0(" with ", paste(bands[seq_len(length(bands)-1)], collapse = ", "), ", and ", bands[length(bands)])
  }

  url <- paste0("https://www.dischord.com/fugazi_live_series/", mygid)
  fls_link <- paste0("<a href='", url, "' target='_blank'>", mygid, "</a>")

# tour position and previous/next show on the same tour -----------------------------------------------------------------------

  tour_ranked <- shows_data %>%
    arrange(tour, date) %>%
    group_by(tour) %>%
    mutate(tour_position = row_number(),
           tour_total = n(),
           previous_venue = dplyr::lag(venue), previous_city = dplyr::lag(city),
           previous_country = dplyr::lag(country), previous_date = dplyr::lag(date),
           next_venue = dplyr::lead(venue), next_city = dplyr::lead(city),
           next_country = dplyr::lead(country), next_date = dplyr::lead(date)) %>%
    ungroup() %>%
    filter(gid==mygid)

  tour_position <- tour_ranked$tour_position
  tour_total <- tour_ranked$tour_total

  previous_show_text <- if (is.na(tour_ranked$previous_date)) {
    NA_character_
  } else {
    paste0(tour_ranked$previous_venue, ", ", tour_ranked$previous_city, ", ", tour_ranked$previous_country,
           " on ", format(tour_ranked$previous_date, "%d %B %Y"))
  }

  next_show_text <- if (is.na(tour_ranked$next_date)) {
    NA_character_
  } else {
    paste0(tour_ranked$next_venue, ", ", tour_ranked$next_city, ", ", tour_ranked$next_country,
           " on ", format(tour_ranked$next_date, "%d %B %Y"))
  }

# prior-visit counts, strictly before this show's date ------------------------------------------------------------------------

  country_visit_number <- sum(shows_data$country==this_show$country & shows_data$date<this_show$date) + 1

  city_visit_number <- sum(shows_data$city==this_show$city & shows_data$country==this_show$country &
                              shows_data$date<this_show$date) + 1

  venue_visit_number <- sum(shows_data$venue==this_show$venue & shows_data$city==this_show$city &
                               shows_data$country==this_show$country & shows_data$date<this_show$date) + 1

  subdivision_visit_number <- if (is.na(this_show$subdivision) | this_show$subdivision=="") {
    NA_integer_
  } else {
    sum(shows_data$subdivision==this_show$subdivision & shows_data$country==this_show$country &
          shows_data$date<this_show$date, na.rm = TRUE) + 1
  }

# recording-derived stats ------------------------------------------------------------------------------------------------------

  show_renditions <- duration_data_da %>% filter(gid==mygid)

  has_recording <- nrow(show_renditions)>0

  n_songs <- nrow(show_renditions)
  minutes <- this_show$minutes
  sound_quality <- this_show$sound_quality

  release_breakdown <- NULL
  release_breakdown_text <- NA_character_
  tracklist <- NULL

  if (has_recording) {

    release_breakdown <- Repeatr1 %>%
      filter(gid==mygid, tracktype==1) %>%
      count(release_title, rid, name = "n_songs") %>%
      mutate(release_title = ifelse(is.na(release_title), "unreleased", release_title)) %>%
      left_join(releasesdatalookup %>% select(rid, release_date), by = "rid") %>%
      arrange(release_date)

    release_breakdown_text <- release_breakdown %>%
      mutate(piece = paste0(n_songs, " from ", release_title,
                             ifelse(is.na(release_date), "", paste0(" (", lubridate::year(release_date), ")")))) %>%
      pull(piece) %>%
      paste(collapse = ", ")

    # nth recorded rendition of each song, across the whole series
    rendition_ranked <- duration_data_da %>%
      arrange(date, song_number) %>%
      group_by(title) %>%
      mutate(rendition_number = row_number()) %>%
      ungroup() %>%
      filter(gid==mygid) %>%
      select(gid, song_number, rendition_number)

    track_lookup <- Repeatr1 %>%
      filter(gid==mygid, tracktype==1) %>%
      select(gid, song_number, track_number, rid, release_title)

    tracklist <- show_renditions %>%
      select(gid, song_number, title, minutes, position) %>%
      left_join(track_lookup, by = c("gid", "song_number")) %>%
      left_join(releasesdatalookup %>% select(rid, release_date), by = "rid") %>%
      left_join(duration_summary %>% select(title, minutes_max, renditions), by = "title") %>%
      left_join(position_summary %>% select(title, position_mean), by = "title") %>%
      left_join(rendition_ranked, by = c("gid", "song_number")) %>%
      arrange(song_number) %>%
      select(track_number, title, minutes, minutes_max, release_title, release_date,
             rendition_number, renditions, position, position_mean)

  }

  context <- list(
    gid = mygid,
    date = this_show$date,
    datestring = datestring,
    venue = this_show$venue,
    city = this_show$city,
    subdivision = this_show$subdivision,
    country = this_show$country,
    where_played = where_played,
    played_with_text = played_with_text,
    tour = this_show$tour,
    tour_position = tour_position,
    tour_total = tour_total,
    previous_show_text = previous_show_text,
    next_show_text = next_show_text,
    country_visit_number = country_visit_number,
    subdivision_visit_number = subdivision_visit_number,
    city_visit_number = city_visit_number,
    venue_visit_number = venue_visit_number,
    has_recording = has_recording,
    n_songs = n_songs,
    minutes = minutes,
    sound_quality = sound_quality,
    release_breakdown_text = release_breakdown_text,
    url = url,
    fls_link = fls_link
  )

  list(context = context, tracklist = tracklist, release_breakdown = release_breakdown)

}
