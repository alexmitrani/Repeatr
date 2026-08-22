#' @name Repeatr_5
#' @title produces results using a coefficient table for a choice model estimated with mlogit.
#' @description Produces a summary table that includes song performance counts, song performance intensities, and ratings based on the estimated choice model parameters.
#'
#' @param mymodeldf optional choice model coefficients dataframe to be used to generate the results. If omitted, the default choice model coefficients dataframe will be used, which is results_ml_Repeatr4.
#' @param mysongidlookup optional `songidlookup` dataframe (the `songidlookup` element of `Repeatr_1()`'s return list). If omitted the currently lazy-loaded default will be used.
#' @param myaltlookup optional `altlookup` dataframe (the second element of `Repeatr_2()`'s return list) used to translate `mymodeldf`'s `alt`-indexed intercept coefficients back to `songid`/`title`. If omitted the currently lazy-loaded default will be used.
#' @param myfugazi_song_performance_intensity optional `fugazi_song_performance_intensity` dataframe (the third element of `Repeatr_2()`'s return list). If omitted the currently lazy-loaded default will be used - pass this explicitly when calling `Repeatr_5()` right after a fresh `Repeatr_2()` in the same session, since the lazy-loaded default reflects the last build on disk, not the one just computed.
#' @param mysongvarslookup optional `songvarslookup` dataframe (the `songvarslookup` element of `Repeatr_1()`'s return list). If omitted the currently lazy-loaded default will be used.
#' @param myreleasesdatalookup optional `releasesdatalookup` dataframe (the `releasesdatalookup` element of `Repeatr_1()`'s return list). If omitted the currently lazy-loaded default will be used.
#' @param myreleases_data_input optional `releases_data_input` dataframe (the `releases_data_input` element of `Repeatr_1()`'s return list). If omitted the currently lazy-loaded default will be used.
#' @param input_dir Optional directory to write the `fugazi_song_choice_model.csv`/`fugazi_song_preferences.csv`/`releases_rated.csv`/`summary.csv` output-export CSVs into. If omitted, defaults to this package's own `inst/extdata` (these are Repeatr's own downloadable outputs, not primary/raw data).
#' @param output_dir Optional directory to save the rebuilt `data/*.rda` objects into. If omitted, defaults to `data/` under the current working directory.
#'
#' @return A list of 5 elements: `fugazi_song_choice_model` (per-variable coefficient table with song names substituted in for the intercept terms), `fugazi_song_preferences` (songs ranked by estimated preference), `summary` (song performance summary combining counts, intensity and rating), `releases_rated` (average rating by release), and `releases_data_input` (per-song-per-release data enriched with the estimated rating). Each of these, plus `releases_summary`, is also saved into `data/`.
#' @export
#'
#' @examples
#' Repeatr_5_results <- Repeatr_5(mymodeldf = results_ml_Repeatr4,
#'                                 output_dir = tempdir(), input_dir = tempdir())
#'
Repeatr_5 <- function(mymodeldf = NULL, mysongidlookup = NULL, myaltlookup = NULL,
                       myfugazi_song_performance_intensity = NULL, mysongvarslookup = NULL,
                       myreleasesdatalookup = NULL, myreleases_data_input = NULL,
                       input_dir = NULL, output_dir = NULL) {

  mydir <- getwd()
  on.exit(setwd(mydir), add = TRUE)
  myinputdir <- if (is.null(input_dir)) paste0(mydir, "/inst/extdata/") else paste0(input_dir, "/")
  mydatadir <- if (is.null(output_dir)) paste0(mydir, "/data") else output_dir

  # Use the lookup tables freshly returned by this session's Repeatr_1()/
  # Repeatr_2() calls if supplied, otherwise fall back to whatever is
  # currently lazy-loaded from data/ (the package's last build) - see
  # Repeatr_Updatr.R for why threading these through matters when chaining
  # a fresh pipeline run.
  if (is.null(mysongidlookup)==FALSE) { songidlookup <- mysongidlookup } else { songidlookup <- songidlookup }
  if (is.null(myaltlookup)==FALSE) { altlookup <- myaltlookup } else { altlookup <- altlookup }
  if (is.null(myfugazi_song_performance_intensity)==FALSE) { fugazi_song_performance_intensity <- myfugazi_song_performance_intensity } else { fugazi_song_performance_intensity <- fugazi_song_performance_intensity }
  if (is.null(mysongvarslookup)==FALSE) { songvarslookup <- mysongvarslookup } else { songvarslookup <- songvarslookup }
  if (is.null(myreleasesdatalookup)==FALSE) { releasesdatalookup <- myreleasesdatalookup } else { releasesdatalookup <- releasesdatalookup }
  if (is.null(myreleases_data_input)==FALSE) { releases_data_input <- myreleases_data_input } else { releases_data_input <- releases_data_input }

  # Report results of the choice modelling for the preferred choice model ----------------------------------

  if(is.null(mymodeldf)==TRUE) {

    mymodeldf = Repeatr::results_ml_Repeatr4

  }

  results.mymodel <- mymodeldf

  variable <- row.names(results.mymodel)

  fugazi_song_choice_model <- cbind.data.frame(variable, results.mymodel)

  # The number embedded in a per-song intercept name (e.g. "(Intercept):5")
  # is mlogit's `alt` index, not `songid` - translate it back to a song name
  # via altlookup, not songidlookup directly.
  fugazi_song_choice_model <- fugazi_song_choice_model %>%
    mutate(alt = ifelse(grepl("(Intercept)",variable)==TRUE,readr::parse_number(variable),NA))

  fugazi_song_choice_model <- fugazi_song_choice_model %>%
    left_join(altlookup %>% select(.data$alt, .data$title))

  fugazi_song_choice_model <- fugazi_song_choice_model %>%
    mutate(variable = ifelse(grepl("(Intercept)",variable)==TRUE,.data$title,variable))

  fugazi_song_choice_model$alt <- NULL
  fugazi_song_choice_model$title <- NULL

  knitr::kable(fugazi_song_choice_model, "pipe")

  setwd(myinputdir)

  utils::write.csv(fugazi_song_choice_model, "fugazi_song_choice_model.csv")

  setwd(mydatadir)

  save(fugazi_song_choice_model, file = "fugazi_song_choice_model.rda")

  setwd(mydir)

  results.mymodel <- mymodeldf

  variable <- row.names(results.mymodel)

  results.mymodel <- cbind.data.frame(variable, results.mymodel)

  results.mymodel <- results.mymodel %>%
    filter(grepl("(Intercept)",variable)==TRUE)

  results.mymodel <- results.mymodel %>%
    mutate(alt = ifelse(grepl("(Intercept)",variable)==TRUE,readr::parse_number(variable),NA))

  results.mymodel <- results.mymodel %>%
    left_join(altlookup %>% select(.data$alt, .data$songid, .data$title))

  results.mymodel <- results.mymodel %>%
    select(.data$songid, .data$title, .data$Estimate, "z-value")

  # Add back in the omitted reference song, whose intercept mlogit fixes to
  # zero by definition rather than estimating. as.factor(alt) in Repeatr_4()
  # sorts by the numeric alt value before assigning factor levels, and
  # mlogit drops the first level as the reference - so the omitted song is
  # always the one with the smallest alt, not a fixed song name/songid.
  results.mymodel.os <- altlookup %>%
    filter(.data$alt==min(.data$alt)) %>%
    select(.data$songid, .data$title) %>%
    mutate(Estimate = 0) %>%
    mutate("z-value" = NA)

  results.mymodel <- rbind.data.frame(results.mymodel, results.mymodel.os)

  results.mymodel <- results.mymodel %>%
    arrange(desc(.data$Estimate))

  fugazi_song_preferences <- results.mymodel

  fugazi_song_preferences <- fugazi_song_preferences %>%
    mutate(rank_rating = row_number()) %>%
    relocate(.data$rank_rating)

  setwd(myinputdir)

  utils::write.csv(fugazi_song_preferences, "fugazi_song_preferences.csv")

  setwd(mydatadir)

  save(fugazi_song_preferences, file = "fugazi_song_preferences.rda")

  setwd(mydir)

  # To produce normalised ratings on the interval [0,1] ------------------------

  mydf <- fugazi_song_preferences

  mydf <- mydf %>%
    select(.data$rank_rating, .data$songid, .data$title, .data$Estimate)

  mymin <- min(mydf$Estimate)

  mydf <- mydf %>%
    mutate(Estimate2 = .data$Estimate - mymin)

  mymax <- max(mydf$Estimate2)

  mydf <- mydf %>%
    mutate(rating = .data$Estimate2/mymax)

  mydf <- mydf %>%
    select(.data$rank_rating, .data$songid, .data$rating)

  mydf2 <- fugazi_song_performance_intensity

  mydf2 <- mydf2 %>%
    left_join(mydf)

  mydf2 <- mydf2 %>%
    arrange(desc(.data$rating))

  mydf2 <- mydf2 %>%
    relocate(.data$rank_rating)

  mydf2 <- mydf2 %>%
    left_join(songvarslookup)

  mydf2 <- mydf2 %>%
    relocate(.data$duration_seconds, .after="launchdate")

  summary <- mydf2 %>%
    select(.data$songid, .data$track_number, .data$title, .data$launchdate, .data$duration_seconds, .data$chosen, .data$available_rl, .data$intensity, .data$rating) %>%
    arrange(desc(.data$rating)) %>%
    mutate(rank = row_number()) %>%
    relocate(rank) %>%
    rename(duration = .data$duration_seconds)

  # Evaluation of releases using the song ratings ---------------------------

  mydf <- releasesdatalookup

  mydf2 <- summary %>%
    left_join(songvarslookup)

  mydf2 <- mydf2 %>%
    select(.data$songid, .data$rid, .data$title, .data$rating)

  mydf2 <- mydf2 %>%
    left_join(mydf)

  mydf2 <- mydf2 %>%
    group_by(.data$release_title, .data$rid, .data$rym_rating, .data$release_date) %>%
    summarise(rating = mean(.data$rating), songs_rated = n()) %>%
    ungroup()

  mydf2 <- mydf2 %>%
    arrange(desc(.data$rating))

  # remove First Demo and Unreleased as they are not comparable to the others.
  releases_rated <- mydf2 %>%
    filter(.data$rid!=11) %>%
    filter(.data$rid!=13)

  releases_rated <- releases_rated %>%
    filter(is.na(.data$rid)==FALSE)

  releases_rated <- releases_rated %>%
    select(.data$release_title, .data$rid, .data$release_date, .data$songs_rated, .data$rating)

  setwd(myinputdir)

  utils::write.csv(releases_rated, "releases_rated.csv")

  setwd(mydatadir)

  save(releases_rated, file = "releases_rated.rda")

  setwd(mydir)

  knitr::kable(releases_rated, "pipe")

  # add other variables to summary table

  releasedates <- releasesdatalookup %>%
    select(.data$rid, .data$release_date)

  mydf <- songvarslookup %>%
    left_join(releasedates) %>%
    left_join(songidlookup)

  mydf <- mydf %>%
    select(.data$songid, .data$title, .data$rid, .data$release_date) %>%
    arrange(.data$songid)

  summary <- summary %>%
    left_join(mydf) %>%
    mutate(launchdate = as.Date(.data$launchdate, "%d/%m/%Y")) %>%
    mutate(lead = .data$release_date - .data$launchdate) %>%
    arrange(desc(.data$rating))

  summary$launchyear <- lubridate::year(summary$launchdate)
  summary$releaseyear <- lubridate::year(summary$release_date)

  summary$songid <- as.integer(summary$songid)
  summary$chosen <- as.integer(summary$chosen)
  summary$available_rl <- as.integer(summary$available_rl)
  summary$rid <- as.integer(summary$rid)
  summary$lead <- as.integer(summary$lead)

  releaseid_release <- releasesdatalookup %>%
    select(.data$rid, .data$release_title)

  summary <- summary %>%
    left_join(releaseid_release) %>%
    relocate(.data$release_title, .after = "rid") %>%
    arrange(.data$rid, .data$track_number)

  setwd(myinputdir)

  utils::write.csv(summary, "summary.csv")

  setwd(mydatadir)

  save(summary, file = "summary.rda")

  setwd(mydir)

  summary_selected <- summary %>%
    select(.data$rid, .data$track_number, .data$rating)

  releases_data_input <- releases_data_input %>%
    left_join(summary_selected) %>%
    mutate(rating = round(.data$rating, digits = 4))

  setwd(mydatadir)

  save(releases_data_input, file = "releases_data_input.rda")

  setwd(mydir)

  releases_summary <- releases_data_input %>%
    group_by(.data$rid, .data$release_title, .data$last_show) %>%
    summarize(count = sum(count),
              songs=n(),
              first_debut=min(date),
              last_debut=max(date),
              first_show = min(.data$show_num),
              shows = round(mean(.data$shows), digits=0),
              intensity = round(mean(.data$intensity), digits = 4),
              rating = round(mean(.data$rating), digits = 4)) %>%
    ungroup()

  releasesdatalookup <- releasesdatalookup %>%
    select(.data$rid, .data$release_date)

  releases_summary <- releases_summary %>%
    left_join(releasesdatalookup) %>%
    select(.data$rid, .data$release_title, .data$first_debut, .data$last_debut, .data$release_date, .data$songs, count, .data$shows, .data$intensity, .data$rating) %>%
    filter(.data$rid>0)

  setwd(mydatadir)

  save(releases_summary, file = "releases_summary.rda")

  setwd(mydir)

  knitr::kable(summary, "pipe")

  myreturnlist <- list(fugazi_song_choice_model, fugazi_song_preferences, summary, releases_rated, releases_data_input)

  return(myreturnlist)

}
