
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

# paragraph3 note-generators -----------------------------------------------------------------------------------------------
# Each note_* function inspects one specific kind of noteworthy fact about a
# single show's recording and returns either NA_character_ ("nothing to
# say") or one or more complete, capitalized, period-terminated sentences as
# a single string. recap() collects whichever of these apply, drops the
# NAs, and space-joins what's left into paragraph3.

# Songs performed at this show that are rare across the whole series (fewer
# than `rare_max_count` total recorded occurrences, tracktype 1/2 only -
# non-song tracktype 0 content like interludes/soundcheck is a different
# kind of rarity, handled by note_soundcheck() instead).
note_rare_tracks <- function(mygid, Repeatr1, rare_max_count = 20) {

  show_titles <- Repeatr1 %>%
    filter(gid==mygid, tracktype %in% c(1, 2)) %>%
    distinct(title) %>%
    pull(title)

  series_counts <- Repeatr1 %>%
    filter(tracktype %in% c(1, 2)) %>%
    count(title)

  rare_titles <- show_titles[show_titles %in% series_counts$title[series_counts$n<rare_max_count]]

  if (length(rare_titles)==0) {
    NA_character_
  } else if (length(rare_titles)==1) {
    paste0("This show features a rarely performed track: ", rare_titles, ".")
  } else {
    paste0("This show features rarely performed tracks: ", oxford_join(rare_titles), ".")
  }

}

# Songs performed noticeably earlier or later in the set than usual - more
# than `position_deviation_threshold` away (on the show's own 0-1
# first-to-last scale) from the song's series-wide mean position.
# tracklist_full is the pre-select tracklist join (see recap()'s
# tracklist-building code), so non-song tracks (with no position_mean) are
# automatically excluded. `position_edge_threshold` sets how close to
# either end of the set counts as "near the start"/"near the end" for the
# wording (position <= threshold, or >= 1 - threshold, respectively) -
# symmetric around the midpoint, since there's no reason a show's start
# and end should be described using different margins.
note_out_of_position <- function(tracklist_full, position_deviation_threshold = 0.8, position_edge_threshold = 0.3) {

  position_bucket <- function(p) {
    if (p>=(1-position_edge_threshold)) {
      "near the end of the set"
    } else if (p<=position_edge_threshold) {
      "near the start of the set"
    } else {
      "mid-set"
    }
  }

  out_of_position <- tracklist_full %>%
    filter(is.na(position)==FALSE, is.na(position_mean)==FALSE, abs(position - position_mean)>position_deviation_threshold)

  if (nrow(out_of_position)==0) {
    return(NA_character_)
  }

  sentences <- vapply(seq_len(nrow(out_of_position)), function(i) {
    title <- out_of_position$title[i]
    usual <- position_bucket(out_of_position$position_mean[i])
    actual <- position_bucket(out_of_position$position[i])
    paste0(toupper(substr(title, 1, 1)), substr(title, 2, nchar(title)),
           ", normally performed ", usual, ", was performed ", actual, " this time.")
  }, character(1))

  paste(sentences, collapse = " ")

}

# Songs performed more than once within this show.
note_repeated_song <- function(mygid, Repeatr1) {

  repeat_counts <- Repeatr1 %>%
    filter(gid==mygid, tracktype==1) %>%
    count(title) %>%
    filter(n>=2)

  if (nrow(repeat_counts)==0) {
    return(NA_character_)
  }

  sentences <- vapply(seq_len(nrow(repeat_counts)), function(i) {
    title <- repeat_counts$title[i]
    times_word <- ifelse(repeat_counts$n[i]==2, "twice", paste0(repeat_counts$n[i], " times"))
    paste0(toupper(substr(title, 1, 1)), substr(title, 2, nchar(title)),
           " was performed ", times_word, " in this show.")
  }, character(1))

  paste(sentences, collapse = " ")

}

# Songs whose duration at this show is unusual relative to every recorded
# rendition of that song (this one included), restricted to songs with at
# least `min_renditions` recorded renditions - below that neither an
# all-time record nor a percentile claim is meaningfully "record-setting".
# The absolute longest/shortest ever gets the strongest phrasing; a
# rendition merely among the top/bottom `percentile`% (without being the
# outright record) gets "one of the X% longest/shortest recorded
# renditions" instead, using the percentile parameter itself as X, not the
# exact computed rank, so every rendition in that band reads the same way
# and the wording adapts cleanly if the parameter changes. Songs are
# bucketed by which of the four categories they fall into (a song only
# ever matches one, in this priority order) and each non-empty bucket
# becomes a single oxford-joined sentence, rather than one sentence per
# song, to avoid a run of near-identical consecutive sentences (issue
# #257). A flagged short rendition under `incomplete_seconds` gets named
# in a separate trailing "may be incomplete" sentence, rather than folded
# into the shortest-rendition sentence itself, since which songs are
# unusually short and which are possibly-incomplete-short are related but
# distinct claims.
note_record_rendition <- function(tracklist_full, mygid, duration_data_da, percentile = 5, min_renditions = 20, incomplete_seconds = 60) {

  eligible <- tracklist_full %>%
    filter(is.na(renditions)==FALSE, renditions>=min_renditions)

  if (nrow(eligible)==0) {
    return(NA_character_)
  }

  longest_record <- character(0)
  longest_percentile <- character(0)
  shortest_record <- character(0)
  shortest_percentile <- character(0)
  incomplete_titles <- character(0)

  incomplete_minutes <- incomplete_seconds/60

  for (i in seq_len(nrow(eligible))) {

    row_title <- eligible$title[i]
    row_minutes <- eligible$minutes[i]

    all_minutes <- duration_data_da %>%
      filter(title==row_title) %>%
      pull(minutes)
    all_minutes <- all_minutes[is.na(all_minutes)==FALSE]

    if (length(all_minutes)==0 | is.na(row_minutes)) {
      next
    }

    top_fraction <- mean(all_minutes>=row_minutes)
    bottom_fraction <- mean(all_minutes<=row_minutes)

    if (row_minutes>=max(all_minutes)) {
      longest_record <- c(longest_record, row_title)
    } else if (top_fraction<=percentile/100) {
      longest_percentile <- c(longest_percentile, row_title)
    } else if (row_minutes<=min(all_minutes)) {
      shortest_record <- c(shortest_record, row_title)
      if (row_minutes<incomplete_minutes) { incomplete_titles <- c(incomplete_titles, row_title) }
    } else if (bottom_fraction<=percentile/100) {
      shortest_percentile <- c(shortest_percentile, row_title)
      if (row_minutes<incomplete_minutes) { incomplete_titles <- c(incomplete_titles, row_title) }
    }

  }

  rendition_sentence <- function(titles, singular_lead, plural_lead, tail) {
    if (length(titles)==0) {
      NA_character_
    } else if (length(titles)==1) {
      paste0(singular_lead, titles, tail)
    } else {
      paste0(plural_lead, oxford_join(titles), tail)
    }
  }

  sentences <- c(
    rendition_sentence(longest_record,
                        "This show includes the longest rendition of ",
                        "This show includes the longest renditions of ",
                        " recorded anywhere in the Fugazi Live Series."),
    rendition_sentence(longest_percentile,
                        paste0("This show includes one of the ", percentile, "% longest recorded renditions of "),
                        paste0("This show includes one of the ", percentile, "% longest recorded renditions of "),
                        "."),
    rendition_sentence(shortest_record,
                        "This show includes the shortest rendition of ",
                        "This show includes the shortest renditions of ",
                        " recorded anywhere in the Fugazi Live Series."),
    rendition_sentence(shortest_percentile,
                        paste0("This show includes one of the ", percentile, "% shortest recorded renditions of "),
                        paste0("This show includes one of the ", percentile, "% shortest recorded renditions of "),
                        "."),
    rendition_sentence(incomplete_titles,
                        "The recording of ",
                        "The recordings of ",
                        " may be incomplete.")
  )

  sentences <- sentences[is.na(sentences)==FALSE]

  if (length(sentences)==0) NA_character_ else paste(sentences, collapse = " ")

}

# Songs whose rendition at this show is the first or last one recorded
# anywhere in the series (a debut or, to date, a farewell), skipped
# entirely for the earliest and latest recorded shows themselves, since
# every song in those two setlists would trivially qualify (there being
# nothing recorded before/after them to compare against) rather than any
# one song being individually noteworthy for it. A song with only one
# recorded rendition ever, performed at this show, is both at once - that
# gets its own "only recorded rendition" phrasing rather than stating the
# same fact twice.
note_first_last_rendition <- function(mygid, this_show_date, show_renditions, duration_data_da) {

  earliest_date <- min(duration_data_da$date)
  latest_date <- max(duration_data_da$date)

  if (this_show_date==earliest_date | this_show_date==latest_date) {
    return(NA_character_)
  }

  title_dates <- duration_data_da %>%
    group_by(title) %>%
    summarize(first_date = min(date), last_date = max(date)) %>%
    ungroup()

  show_titles <- show_renditions %>%
    distinct(title) %>%
    left_join(title_dates, by = "title")

  only_titles <- show_titles %>% filter(first_date==this_show_date, last_date==this_show_date) %>% pull(title)
  debut_titles <- show_titles %>% filter(first_date==this_show_date, last_date!=this_show_date) %>% pull(title)
  farewell_titles <- show_titles %>% filter(first_date!=this_show_date, last_date==this_show_date) %>% pull(title)

  only_sentence <- if (length(only_titles)==0) {
    NA_character_
  } else if (length(only_titles)==1) {
    paste0("This show includes the only recorded rendition of ", only_titles, ".")
  } else {
    paste0("This show includes the only recorded renditions of ", oxford_join(only_titles), ".")
  }

  debut_sentence <- if (length(debut_titles)==0) {
    NA_character_
  } else if (length(debut_titles)==1) {
    paste0("This show includes the first ever recorded rendition of ", debut_titles, ".")
  } else {
    paste0("This show includes the first ever recorded renditions of ", oxford_join(debut_titles), ".")
  }

  farewell_sentence <- if (length(farewell_titles)==0) {
    NA_character_
  } else if (length(farewell_titles)==1) {
    paste0("This show includes the last recorded rendition of ", farewell_titles, " to date.")
  } else {
    paste0("This show includes the last recorded renditions of ", oxford_join(farewell_titles), " to date.")
  }

  sentences <- c(only_sentence, debut_sentence, farewell_sentence)
  sentences <- sentences[is.na(sentences)==FALSE]

  if (length(sentences)==0) NA_character_ else paste(sentences, collapse = " ")

}

# Whether this show's own total recording duration is the longest or
# shortest of any Fugazi show with a surviving recording.
note_record_show_duration <- function(minutes, shows_data, duration_data_da) {

  recorded_shows <- shows_data %>% semi_join(duration_data_da, by = "gid")

  if (minutes==max(recorded_shows$minutes, na.rm = TRUE)) {
    "This is the longest Fugazi recording in the Fugazi Live Series."
  } else if (minutes==min(recorded_shows$minutes, na.rm = TRUE)) {
    "This is the shortest Fugazi recording in the Fugazi Live Series."
  } else {
    NA_character_
  }

}

# When this recording's non-song content (interludes, banter, crowd noise,
# etc.) wasn't tagged separately, song durations shown may run slightly
# long - the same condition already used to omit music_bracket, just above.
note_untracked_interludes <- function(music_minutes, minutes) {

  if (round(music_minutes, digits = 2) < round(minutes, digits = 2)) {
    NA_character_
  } else {
    "Interludes and other non-song content were not tracked separately for this recording, so song durations shown may be slightly over-estimated."
  }

}

# Whether this show's recording includes a soundcheck - rare enough across
# the whole series to flag, with the "only N shows" count computed live so
# it stays correct as new soundcheck recordings are added.
note_soundcheck <- function(mygid, Repeatr1) {

  soundcheck_gids <- Repeatr1 %>%
    filter(tracktype==0, grepl("sound.?check", title, ignore.case = TRUE)) %>%
    distinct(gid) %>%
    pull(gid)

  if (mygid %in% soundcheck_gids==FALSE) {
    NA_character_
  } else {
    paste0("This is one of only ", length(soundcheck_gids), " Fugazi Live Series recordings that include a soundcheck.")
  }

}

# Curated one-off notes for shows whose noteworthy fact has no generic
# detection signal elsewhere in this file (e.g. bonus/alternate material
# included in the download, which doesn't correlate with any measurable
# property of the recording itself). One more line here is all a new case
# needs - no other code changes required.
note_curated <- function(mygid) {

  curated_notes <- c(
    "dallas-tx-usa-50490" = "This show's download also includes an alternate recording, \"Outside the Gig!\", of the crowd outside the venue after the police forced the audience out of the building.",
    "birmingham-al-usa-52191" = "Greed was performed twice at this show, in the actual \"Two for Tuesdays\" bit that gave the phrase its name - but the two renditions are merged into a single track in this recording, so they don't appear as separate rows in the tracklist above."
  )

  if (mygid %in% names(curated_notes)) {
    unname(curated_notes[mygid])
  } else {
    NA_character_
  }

}

# Whether this show's attendance is the largest or smallest of any Fugazi
# show (independent of has_recording - called from paragraph1, not
# collected into paragraph3).
note_record_attendance <- function(attendance, shows_data) {

  if (attendance==max(shows_data$attendance, na.rm = TRUE)) {
    "This show had the largest attendance of any Fugazi show."
  } else if (attendance==min(shows_data$attendance, na.rm = TRUE)) {
    "This show had the smallest attendance of any Fugazi show."
  } else {
    NA_character_
  }

}

# Whether this show's ticket price is the highest of any USD-denominated
# Fugazi show - restricted to USD since foreign-currency prices aren't
# directly comparable without conversion (independent of has_recording -
# called from paragraph1, not collected into paragraph3).
note_record_price <- function(price, currency, shows_data) {

  if (is.na(price) | is.na(currency) | currency!="USD") {
    return(NA_character_)
  }

  usd_prices <- shows_data$price[is.na(shows_data$currency)==FALSE & shows_data$currency=="USD" & is.na(shows_data$price)==FALSE]

  if (price==max(usd_prices)) {
    "This was the most expensive Fugazi show (in USD)."
  } else {
    NA_character_
  }

}

# Whether this show was a festival - Fugazi played very few, and there's no
# separate flag for it in the data, so it's detected from the venue name
# itself (independent of has_recording - called from paragraph1, not
# collected into paragraph3). The "only N" count is computed live, same
# principle as note_soundcheck().
note_festival <- function(venue, shows_data) {

  if (grepl("festival", venue, ignore.case = TRUE)==FALSE) {
    return(NA_character_)
  }

  n_festivals <- sum(grepl("festival", shows_data$venue, ignore.case = TRUE))

  paste0("This was one of only ", n_festivals, " festival shows Fugazi ever played.")

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
#' @param rendition_percentile the percentile threshold (as a plain number, e.g. `5` for the top/bottom 5%) used by the "exceptionally long/short rendition" note: a rendition that isn't the outright longest/shortest ever recorded, but still falls among the top/bottom percentage of every recorded rendition of the same song (this one included), is called out with wording like "one of the 5% longest recorded renditions of this song". Defaults to `5`.
#' @param rendition_min_count the minimum number of recorded renditions a song must have across the whole series before the "longest/shortest/exceptionally long/short rendition" note will consider it at all - below this, neither an all-time record nor a percentile claim is meaningfully established. Defaults to `20`.
#' @param rendition_incomplete_seconds the duration (in seconds) below which a song flagged as an unusually short rendition (the shortest ever recorded, or among the bottom `rendition_percentile`%) is additionally called out by name as possibly having an incomplete recording. Defaults to `60`.
#' @param rare_track_max_count the maximum number of total recorded occurrences (across the whole series) a track can have before the "rarely performed track" note stops considering it rare. Defaults to `20`.
#' @param position_deviation_threshold how far (on the show's own 0-1 first-to-last scale) a song's position in the set must differ from its series-wide average position before the "performed out of its usual set position" note is triggered. Defaults to `0.8`.
#' @param position_edge_threshold how close to either end of the set (on the show's own 0-1 first-to-last scale) counts as "near the start"/"near the end" of the set, versus "mid-set", when describing a song's usual or actual set position - a position `<=` this value is "near the start", `>=` `1 -` this value is "near the end". Defaults to `0.3`.
#'
#' @return A list of three elements: `context` (a named list of the show's prose-summary facts, including ready-made `paragraph1`/`paragraph2`/`paragraph3` strings), `tracklist` (a dataframe with one row per track on the recording, songs and non-song tracks alike, or `NULL` if no recording exists) and `release_breakdown` (a dataframe of song counts by release for this show, or `NULL` if no recording exists).
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
                   mytransitions_data_da = NULL, myfls_tags = NULL,
                   rendition_percentile = 5, rendition_min_count = 20,
                   rendition_incomplete_seconds = 60,
                   rare_track_max_count = 20, position_deviation_threshold = 0.8,
                   position_edge_threshold = 0.3) {

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

  # Facts about the show itself (not the recording), so unlike paragraph3
  # these apply even when has_recording is FALSE - e.g. the smallest-
  # attendance show in the whole series has no surviving recording.
  attendance_record_note <- note_record_attendance(attendance, shows_data)
  price_record_note <- note_record_price(price, currency, shows_data)
  festival_note <- note_festival(this_show$venue, shows_data)

  paragraph1 <- paste0("On ", datestring, ", ", attendance_clause, door_price_clause, " ",
                       location_sentence,
                       ifelse(tour_context_sentence=="", "", paste0(" ", tour_context_sentence)),
                       ifelse(last_show_sentence=="", "", paste0(" ", last_show_sentence)),
                       ifelse(is.na(attendance_record_note), "", paste0(" ", attendance_record_note)),
                       ifelse(is.na(price_record_note), "", paste0(" ", price_record_note)),
                       ifelse(is.na(festival_note), "", paste0(" ", festival_note)))

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
  paragraph3 <- ""
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

    # tracklist_full keeps every joined column (including each title's
    # series-wide minutes_min/minutes_max/position_mean) for the paragraph3
    # note-generators below to inspect; the user-facing tracklist further
    # down trims this to the columns actually meant for display, dropping
    # mins_max - a record-setting duration is now surfaced in prose instead
    # (see note_record_rendition()) rather than as a bare number in the
    # table.
    tracklist_full <- all_tracks %>%
      left_join(show_renditions %>% select(gid, song_number, minutes, position), by = c("gid", "song_number")) %>%
      left_join(track_minutes, by = c("gid", "song_number")) %>%
      mutate(minutes = ifelse(is.na(minutes), track_minutes, minutes)) %>%
      left_join(track_lookup, by = c("gid", "song_number")) %>%
      left_join(releasesdatalookup %>% select(rid, release_date), by = "rid") %>%
      left_join(duration_summary %>% select(title, minutes_mean, minutes_min, minutes_max, renditions), by = "title") %>%
      left_join(position_summary %>% select(title, position_mean), by = "title") %>%
      left_join(rendition_ranked, by = c("gid", "song_number")) %>%
      left_join(transition_ranked, by = c("gid", "song_number")) %>%
      arrange(song_number)

    tracklist <- tracklist_full %>%
      select(track = song_number, title, minutes, mins_mean = minutes_mean,
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

    # paragraph3 collects whichever noteworthy facts apply to this show -
    # content-notable ones first (rare tracks, unusual set position,
    # repeats, record-setting renditions/recordings, soundcheck, curated
    # one-offs), the untracked-interludes technical caveat last, since it
    # qualifies the numbers just given rather than describing the show
    # itself. Any note with nothing to say returns NA_character_ and is
    # dropped; if none apply, paragraph3 is "" like this file's other
    # optional sentences.
    note_pieces <- c(
      note_rare_tracks(mygid, Repeatr1, rare_max_count = rare_track_max_count),
      note_out_of_position(tracklist_full, position_deviation_threshold = position_deviation_threshold,
                            position_edge_threshold = position_edge_threshold),
      note_repeated_song(mygid, Repeatr1),
      note_record_rendition(tracklist_full, mygid, duration_data_da, percentile = rendition_percentile, min_renditions = rendition_min_count, incomplete_seconds = rendition_incomplete_seconds),
      note_first_last_rendition(mygid, this_show$date, show_renditions, duration_data_da),
      note_record_show_duration(minutes, shows_data, duration_data_da),
      note_soundcheck(mygid, Repeatr1),
      note_curated(mygid),
      note_untracked_interludes(music_minutes, minutes)
    )

    note_pieces <- note_pieces[is.na(note_pieces)==FALSE]

    paragraph3 <- paste(note_pieces, collapse = " ")

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
    paragraph3 = paragraph3,
    url = url,
    fls_link = fls_link
  )

  list(context = context, tracklist = tracklist, release_breakdown = release_breakdown)

}
