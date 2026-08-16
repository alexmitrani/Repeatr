
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

# Joins a vector of strings into a grammatically correct list: "A" for one
# item, "A and B" for two, "A, B, and C" (Oxford comma) for three or more.
# force_comma=TRUE always uses the comma-before-"and" form even for two items
# (needed when an item's own label already contains a comma, e.g. "Washington, DC").
oxford_join <- function(x, force_comma = FALSE) {
  n <- length(x)
  if (n==0) {
    ""
  } else if (n==1) {
    x
  } else if (n==2) {
    if (force_comma) paste0(x[1], ", and ", x[2]) else paste(x, collapse = " and ")
  } else {
    paste0(paste(x[seq_len(n-1)], collapse = ", "), ", and ", x[n])
  }
}

# Converts any ALL-CAPS word in a string to sentence case (e.g. "ANON." -> "Anon."),
# leaving already mixed-case words, non-letter tokens, and known acronyms
# (e.g. "DAT"/"CD"/"PRS", which should stay all-caps rather than become
# "Dat"/"Cd"/"Prs") untouched.
fix_caps <- function(x) {
  if (is.na(x)) {
    return(x)
  }
  acronyms <- c("DAT", "CD", "PRS")
  words <- strsplit(x, " ")[[1]]
  words <- vapply(words, function(w) {
    if (gsub("[[:punct:]]", "", w) %in% acronyms) {
      w
    } else if (w==toupper(w) & w!=tolower(w)) {
      paste0(toupper(substr(w, 1, 1)), tolower(substr(w, 2, nchar(w))))
    } else {
      w
    }
  }, character(1))
  paste(words, collapse = " ")
}

# Formats a Date as "Weekday the Nth of Month Year", e.g. "Thursday the 3rd
# of September 1987" - used everywhere a show date is mentioned in prose, so
# every date in the text reads the same way. include_year=FALSE drops the
# trailing year (used when it's already obvious from context, e.g. a
# previous/next show in the same calendar year as the show being recapped).
format_show_date <- function(date, include_year = TRUE) {
  day_num <- lubridate::day(date)
  paste0(weekdays(date), " the ", format_ordinal(day_num), " of ", format(date, "%B"),
         if (include_year) paste0(" ", lubridate::year(date)) else "")
}

# Formats a numeric price without a spurious trailing ".0".
format_price <- function(p) {
  if (is.na(p)) {
    NA_character_
  } else if (p==round(p)) {
    as.character(round(p))
  } else {
    as.character(round(p, 2))
  }
}

# Describes another show (the previous or following one) relative to this
# one: names the venue, city, subdivision (if any) and country in full unless
# same_venue says it's safe to collapse to "the same venue" (the caller
# decides this, not just a raw venue==venue comparison - see the note where
# previous/next_collapses_venue are built, on why the *following* show's
# clause can't always collapse even when its venue does match). Always states
# the explicit date (an earlier version substituted "the night before"/"the
# next night" for literally-adjacent calendar days, but that read as
# ambiguous when the sentence already names another explicit date - see
# issue #253), omitting only the year when it's the same as this_show_date's,
# since same-tour shows are usually within one calendar year.
describe_other_show <- function(venue, city, subdivision, country, date, same_venue, this_show_date) {
  location_part <- if (same_venue) {
    "the same venue"
  } else {
    paste0(venue, ", ", city,
           ifelse(is.na(subdivision) | subdivision=="", "", paste0(", ", subdivision)),
           ", ", country)
  }
  paste0(location_part, " on ",
         format_show_date(date, include_year = lubridate::year(date)!=lubridate::year(this_show_date)))
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
#' @param myothervariables optional `othervariables` dataframe (as produced by `Repeatr_1()`) to be used for recording credits (recorded by/mastered by/original source). If omitted the currently lazy-loaded default will be used.
#' @param mytransitions_data_da optional `transitions_data_da` dataframe (as produced by `Repeatr_1()`) to be used for song-to-song transition occurrence counts. If omitted the currently lazy-loaded default will be used.
#' @param myfls_tags optional `fls_tags` dataframe (as produced by `Repeatr_1()`) to be used for the raw per-track tagged duration of non-song tracks (interludes, intro/outro, etc.), which have no duration elsewhere. If omitted the currently lazy-loaded default will be used.
#'
#' @return A list of three elements: `context` (a named list of the show's prose-summary facts, including ready-made `paragraph1`/`paragraph2` strings), `tracklist` (a dataframe with one row per track on the recording, songs and non-song tracks alike, or `NULL` if no recording exists) and `release_breakdown` (a dataframe of song counts by release for this show, or `NULL` if no recording exists).
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
                   myplayed_with = NULL, myothervariables = NULL,
                   mytransitions_data_da = NULL, myfls_tags = NULL) {

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
  if (is.null(myothervariables)==FALSE) { othervariables <- myothervariables } else { othervariables <- Repeatr::othervariables }
  if (is.null(mytransitions_data_da)==FALSE) { transitions_data_da <- mytransitions_data_da } else { transitions_data_da <- Repeatr::transitions_data_da }
  if (is.null(myfls_tags)==FALSE) { fls_tags <- myfls_tags } else { fls_tags <- Repeatr::fls_tags }

  this_show <- shows_data %>% filter(gid==mygid)

  if (nrow(this_show)!=1) {
    stop("mygid must match exactly one show in shows_data")
  }

# date string and location text -----------------------------------------------------------------------------------------------

  datestring <- format_show_date(this_show$date)

  where_played <- paste0(this_show$venue, ", ", this_show$city,
                          ifelse(is.na(this_show$subdivision) | this_show$subdivision=="", "", paste0(", ", this_show$subdivision)),
                          ", ", this_show$country)

  bands <- played_with %>% filter(gid==mygid) %>% pull(played_with)

  played_with_text <- if (length(bands)==0) "" else paste0(" with ", oxford_join(bands))

  url <- paste0("https://www.dischord.com/fugazi_live_series/", mygid)
  fls_link <- paste0("<a href='", url, "' target='_blank'>", mygid, "</a>")

  attendance <- this_show$attendance

  attendance_clause <- if (is.na(attendance)) {
    paste0("Fugazi played ", where_played, played_with_text, ".")
  } else {
    paste0("Fugazi played to ", format(round(attendance), big.mark = "", scientific = FALSE), " people in ",
           where_played, played_with_text, ".")
  }

  price <- this_show$price
  currency <- this_show$currency

  door_price_clause <- if (is.na(price)) {
    ""
  } else if (price==0) {
    " The show was free."
  } else {
    paste0(" The door price was ", currency, " ", format_price(price), ".")
  }

# overall show number, across the whole series (recorded or not) --------------------------------------------------------------

  overall_rank <- shows_data %>%
    arrange(date) %>%
    mutate(overall_show_number = row_number()) %>%
    filter(gid==mygid)

  overall_show_number <- overall_rank$overall_show_number

  last_show_sentence <- if (overall_show_number==nrow(shows_data)) "This was the last Fugazi show to date." else ""

# tour position and previous/next show on the same touring period -------------------------------------------------------------

  tour_ranked <- shows_data %>%
    arrange(tour, date) %>%
    group_by(tour) %>%
    mutate(tour_position = row_number(),
           tour_total = n(),
           previous_venue = dplyr::lag(venue), previous_city = dplyr::lag(city),
           previous_subdivision = dplyr::lag(subdivision),
           previous_country = dplyr::lag(country), previous_date = dplyr::lag(date),
           next_venue = dplyr::lead(venue), next_city = dplyr::lead(city),
           next_subdivision = dplyr::lead(subdivision),
           next_country = dplyr::lead(country), next_date = dplyr::lead(date)) %>%
    ungroup() %>%
    filter(gid==mygid)

  tour_position <- tour_ranked$tour_position
  tour_total <- tour_ranked$tour_total

  previous_same_venue <- is.na(tour_ranked$previous_date)==FALSE &
    tour_ranked$previous_venue==this_show$venue & tour_ranked$previous_city==this_show$city &
    tour_ranked$previous_country==this_show$country

  next_same_venue <- is.na(tour_ranked$next_date)==FALSE &
    tour_ranked$next_venue==this_show$venue & tour_ranked$next_city==this_show$city &
    tour_ranked$next_country==this_show$country

  # The following-show clause can only collapse to "the same venue" when the
  # previous-show clause hasn't just named a *different* venue - otherwise
  # "the same venue" reads as anaphoric to whichever venue was mentioned
  # immediately before it (the previous show's) rather than to this show's
  # own, e.g. on the first night of a stand: "...at Academy, Bristol,
  # England, the night before, and the following show was at the same
  # venue..." would wrongly imply the *next* show was also in Bristol.
  # The previous-show clause has no such risk, since nothing else in the
  # sentence has been named yet when it appears.
  next_collapses_venue <- next_same_venue & (is.na(tour_ranked$previous_date) | previous_same_venue)

  previous_show_text <- if (is.na(tour_ranked$previous_date)) {
    NA_character_
  } else {
    describe_other_show(tour_ranked$previous_venue, tour_ranked$previous_city, tour_ranked$previous_subdivision,
                         tour_ranked$previous_country, tour_ranked$previous_date,
                         same_venue = previous_same_venue, this_show_date = this_show$date)
  }

  next_show_text <- if (is.na(tour_ranked$next_date)) {
    NA_character_
  } else {
    describe_other_show(tour_ranked$next_venue, tour_ranked$next_city, tour_ranked$next_subdivision,
                         tour_ranked$next_country, tour_ranked$next_date,
                         same_venue = next_collapses_venue, this_show_date = this_show$date)
  }

  tour_clause <- paste0("show ", tour_position, " of ", tour_total, " of the ", this_show$tour)

  # Whether this is the first/last/only show of the touring period is already
  # conveyed by "show X of Y" above, so this sentence sticks to naming the
  # actual previous/next show (if any) and never repeats "first"/"last"/"only".
  tour_context_sentence <- if (is.na(previous_show_text) & is.na(next_show_text)) {
    ""
  } else if (is.na(previous_show_text)) {
    paste0("The following show was at ", next_show_text, ".")
  } else if (is.na(next_show_text)) {
    paste0("The previous show was at ", previous_show_text, ".")
  } else {
    paste0("The previous show was at ", previous_show_text, ", and the following show was at ", next_show_text, ".")
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

  # Build the country/subdivision/city/venue hierarchy (broad to narrow) and
  # collapse any consecutive levels that share the same visit count into one
  # clause, using only the broadest level's label/preposition - since equal
  # counts mean the broader level has never (so far) hosted a show anywhere
  # else, making it redundant to state both (e.g. Washington is the only city
  # ever visited in DC, so "the Nth show in Washington, DC" says it once;
  # Jönköping's only venue being Kulturhuset on a city debut collapses
  # further to just "the 1st show in Jönköping", leaving the venue implicit
  # rather than the city). Priority is broadest-first for the same reason a
  # country debut always wins outright: every deeper level is trivially also
  # a debut (count 1) whenever the country is, so there's nothing narrower
  # left worth naming.
  level_names <- c("country")
  level_counts <- c(country_visit_number)

  if (is.na(subdivision_visit_number)==FALSE) {
    level_names <- c(level_names, "subdivision")
    level_counts <- c(level_counts, subdivision_visit_number)
  }
  level_names <- c(level_names, "city")
  level_counts <- c(level_counts, city_visit_number)
  level_names <- c(level_names, "venue")
  level_counts <- c(level_counts, venue_visit_number)

  group_clauses <- c()

  # If this is the very first Fugazi show ever, every location-level count is
  # trivially 1 too - already said, no need to spell any of them out.
  if (overall_show_number>1) {

    n_levels <- length(level_names)
    i <- 1

    while (i<=n_levels) {

      j <- i
      while (j<n_levels && level_counts[j+1]==level_counts[i]) {
        j <- j + 1
      }

      group_names <- level_names[i:j]
      count <- level_counts[i]

      clause <- if ("country" %in% group_names) {
        paste0("the ", format_ordinal(count), " time Fugazi played in ", this_show$country)
      } else if ("city" %in% group_names & "subdivision" %in% group_names) {
        paste0("the ", format_ordinal(count), " show in ", this_show$city, ", ", this_show$subdivision)
      } else if ("city" %in% group_names) {
        paste0("the ", format_ordinal(count), " show in ", this_show$city)
      } else if ("subdivision" %in% group_names) {
        paste0("the ", format_ordinal(count), " show in ", this_show$subdivision)
      } else {
        paste0("the ", format_ordinal(count), " show at ", this_show$venue)
      }

      group_clauses <- c(group_clauses, clause)
      i <- j + 1

    }

  }

  # The overall show number always leads, before any other ordinal fact.
  overall_clause <- paste0("the ", format_ordinal(overall_show_number), " Fugazi show")

  location_sentence <- paste0("It was ", oxford_join(c(overall_clause, tour_clause, group_clauses), force_comma = TRUE), ".")

  paragraph1 <- paste0("On ", datestring, ", ", attendance_clause, door_price_clause, " ",
                       location_sentence,
                       ifelse(tour_context_sentence=="", "", paste0(" ", tour_context_sentence)),
                       ifelse(last_show_sentence=="", "", paste0(" ", last_show_sentence)))

# recording-derived stats ------------------------------------------------------------------------------------------------------

  show_renditions <- duration_data_da %>% filter(gid==mygid)

  has_recording <- nrow(show_renditions)>0

  n_songs <- nrow(show_renditions)
  minutes <- this_show$minutes
  sound_quality <- this_show$sound_quality
  music_minutes <- NA_real_
  music_proportion <- NA_real_

  release_breakdown <- NULL
  release_breakdown_text <- NA_character_
  tracklist <- NULL
  paragraph2 <- ""
  recorded_by <- NA_character_
  mastered_by <- NA_character_
  original_source <- NA_character_

  if (has_recording) {

    show_othervars <- othervariables %>% filter(gid==mygid)

    if (nrow(show_othervars)==1) {
      recorded_by <- fix_caps(show_othervars$recorded_by[1])
      mastered_by <- fix_caps(show_othervars$mastered_by[1])
      original_source <- fix_caps(show_othervars$original_source[1])
    }

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
      oxford_join()

    # nth recorded rendition of each song, across the whole series
    rendition_ranked <- duration_data_da %>%
      arrange(date, song_number) %>%
      group_by(title) %>%
      mutate(rendition_number = row_number()) %>%
      ungroup() %>%
      filter(gid==mygid) %>%
      select(gid, song_number, rendition_number)

    # nth occurrence of each (title1, title2) transition pair, and its total
    # count, across the whole series - attached to the *destination* song's
    # row (destination song_number = transition + 1, by construction; see
    # transitions_data_da's build in Repeatr_1.R), per issue #252.
    transition_ranked <- transitions_data_da %>%
      arrange(date, transition) %>%
      group_by(title1, title2) %>%
      mutate(transition_number = row_number(), transition_count = n()) %>%
      ungroup() %>%
      filter(gid==mygid) %>%
      mutate(song_number = transition + 1) %>%
      select(gid, song_number, transition_number, transition_count)

    # release/track lookup - only rid is needed here to bring in release_date;
    # the show's own song_number (below) becomes the displayed track number,
    # not Repeatr1's studio-release track_number, which is unrelated to set order.
    track_lookup <- Repeatr1 %>%
      filter(gid==mygid, tracktype==1) %>%
      select(gid, song_number, rid)

    # Every track as actually sequenced in the recording, including non-song
    # tracks (interludes, intro/outro, crowd noise, etc. - tracktype 0/2).
    # song_number already reflects true position across ALL tracks, so it
    # doubles as the displayed track number once every track has a row.
    all_tracks <- Repeatr1 %>%
      filter(gid==mygid) %>%
      select(gid, song_number, title)

    # Non-song tracks have no entry in show_renditions (built from the
    # tracktype==1-only duration_data_da), so their duration would otherwise
    # be blank even though it exists - fls_tags' own track number lines up
    # with song_number directly (unlike the title-based join used elsewhere,
    # which is only reliable in aggregate, not per-track - see the xray
    # `other` fix), so it's used here only to fill in the gap for tracks
    # show_renditions has no minutes for; songs keep their existing minutes
    # from show_renditions unchanged.
    track_minutes <- fls_tags %>%
      filter(gid==mygid) %>%
      mutate(song_number = as.numeric(track), track_minutes = round(seconds/60, digits = 2)) %>%
      select(gid, song_number, track_minutes)

    tracklist <- all_tracks %>%
      left_join(show_renditions %>% select(gid, song_number, minutes, position), by = c("gid", "song_number")) %>%
      left_join(track_minutes, by = c("gid", "song_number")) %>%
      mutate(minutes = ifelse(is.na(minutes), track_minutes, minutes)) %>%
      left_join(track_lookup, by = c("gid", "song_number")) %>%
      left_join(releasesdatalookup %>% select(rid, release_date), by = "rid") %>%
      left_join(duration_summary %>% select(title, minutes_mean, minutes_max, renditions), by = "title") %>%
      left_join(position_summary %>% select(title, position_mean), by = "title") %>%
      left_join(rendition_ranked, by = c("gid", "song_number")) %>%
      left_join(transition_ranked, by = c("gid", "song_number")) %>%
      arrange(song_number) %>%
      select(track = song_number, title, minutes, mins_mean = minutes_mean, mins_max = minutes_max,
             position, pos_mean = position_mean, rendition = rendition_number, renditions,
             transition = transition_number, transitions = transition_count, release_date)

    music_minutes <- sum(show_renditions$minutes, na.rm = TRUE)
    music_proportion <- round(music_minutes / minutes * 100)

    # If music_minutes equals the total, no non-song content was tracked
    # separately for this recording (interludes/banter/etc. always exist in
    # some form) - meaning the music/other split isn't actually known for
    # this show, not that the whole recording was literally music, so the
    # bracketed figure is omitted rather than implying a precision we don't
    # have.
    music_bracket <- if (round(music_minutes, digits = 2) < round(minutes, digits = 2)) {
      paste0(" (", music_minutes, " minutes of music)")
    } else {
      ""
    }

    recording_sentence <- paste0("A recording of this show is available, with a total duration of ", minutes, " minutes",
                                 music_bracket,
                                 ifelse(is.na(sound_quality), "", paste0(", rated '", sound_quality, "' for sound quality")), ".")

    has_recorded_by <- is.na(recorded_by)==FALSE & recorded_by!=""
    has_mastered_by <- is.na(mastered_by)==FALSE & mastered_by!=""
    has_original_source <- is.na(original_source)==FALSE & original_source!=""

    recorded_clause <- if (has_recorded_by & has_original_source) {
      paste0("Recorded by ", recorded_by, " on ", original_source)
    } else if (has_recorded_by) {
      paste0("Recorded by ", recorded_by)
    } else if (has_original_source) {
      paste0("Recorded on ", original_source)
    } else {
      NA_character_
    }

    mastered_clause <- if (has_mastered_by) paste0("mastered by ", mastered_by) else NA_character_

    detail_pieces <- c(recorded_clause, mastered_clause)
    detail_pieces <- detail_pieces[is.na(detail_pieces)==FALSE]

    recording_detail_sentence <- if (length(detail_pieces)==0) {
      ""
    } else {
      detail_text <- paste(detail_pieces, collapse = ", ")
      paste0(toupper(substr(detail_text, 1, 1)), substr(detail_text, 2, nchar(detail_text)), ".")
    }

    songs_sentence <- paste0(n_songs, " songs: ", release_breakdown_text, ".")

    paragraph2 <- paste0(recording_sentence,
                         ifelse(recording_detail_sentence=="", "", paste0(" ", recording_detail_sentence)),
                         " ", songs_sentence)

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
    attendance = attendance,
    price = price,
    currency = currency,
    overall_show_number = overall_show_number,
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
    music_minutes = round(music_minutes, digits = 2),
    music_proportion = music_proportion,
    sound_quality = sound_quality,
    recorded_by = recorded_by,
    mastered_by = mastered_by,
    original_source = original_source,
    release_breakdown_text = release_breakdown_text,
    paragraph1 = paragraph1,
    paragraph2 = paragraph2,
    url = url,
    fls_link = fls_link
  )

  list(context = context, tracklist = tracklist, release_breakdown = release_breakdown)

}
