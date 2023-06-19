#' @name Repeatr_5
#' @title Produces results using a preferred choice model supplied by the user as "mymodel"
#' @description Produces a summary table that includes song performance counts, song performance intensities, and ratings based on the estimated choice model parameters.
#'
#' @import dplyr
#' @import stringr
#' @import lubridate
#' @import fastDummies
#' @import rlang
#' @import knitr
#' @import readr
#'
#'
#' @param mymodeldf optional choice model coefficients dataframe to be used to generate the results. If omitted, the default choice model coefficients dataframe will be used, which is results_ml_Repeatr4.
#'
#' @return
#' @export
#'
#' @examples
#' Repeatr_5_results <- Repeatr_5(mymodeldf = results_ml_Repeatr4)
#'
Repeatr_5 <- function(mymodeldf = NULL) {

  # Report results of the choice modelling for the preferred choice model ----------------------------------

  if(is.null(mymodeldf)==TRUE) {

    mymodeldf = results_ml_Repeatr4

  }

  results.mymodel <- mymodeldf

  variable <- row.names(results.mymodel)

  fugazi_song_choice_model <- cbind.data.frame(variable, results.mymodel)

  fugazi_song_choice_model <- fugazi_song_choice_model %>%
    mutate(songid = ifelse(grepl("(Intercept)",variable)==TRUE,readr::parse_number(variable),NA))

  fugazi_song_choice_model <- fugazi_song_choice_model %>%
    left_join(songidlookup)

  fugazi_song_choice_model <- fugazi_song_choice_model %>%
    mutate(variable = ifelse(grepl("(Intercept)",variable)==TRUE,song,variable))

  fugazi_song_choice_model$songid <- NULL
  fugazi_song_choice_model$song <- NULL

  knitr::kable(fugazi_song_choice_model, "pipe")

  write.csv(fugazi_song_choice_model, "fugazi_song_choice_model.csv")

  save(fugazi_song_choice_model, file = "fugazi_song_choice_model.rda")

  results.mymodel <- mymodeldf

  variable <- row.names(results.mymodel)

  results.mymodel <- cbind.data.frame(variable, results.mymodel)

  results.mymodel <- results.mymodel %>%
    filter(grepl("(Intercept)",variable)==TRUE)

  results.mymodel <- results.mymodel %>%
    mutate(songid = ifelse(grepl("(Intercept)",variable)==TRUE,readr::parse_number(variable),NA))

  results.mymodel <- results.mymodel %>%
    left_join(songidlookup)

  results.mymodel <- results.mymodel %>%
    select(songid, song, Estimate, "z-value")

  # to add back in "waiting room" which was the omitted constant in the choice model and has a parameter value of zero by definition.

  results.mymodel.os <- songidlookup %>%
    filter(songid==1) %>%
    mutate(Estimate = 0) %>%
    mutate("z-value" = NA)

  results.mymodel <- rbind.data.frame(results.mymodel, results.mymodel.os)

  results.mymodel <- results.mymodel %>%
    arrange(desc(Estimate))

  fugazi_song_preferences <- results.mymodel

  fugazi_song_preferences <- fugazi_song_preferences %>%
    mutate(rank_rating = row_number()) %>%
    relocate(rank_rating)

  write.csv(fugazi_song_preferences, "fugazi_song_preferences.csv")

  save(fugazi_song_preferences, file = "fugazi_song_preferences.rda")

  # To produce normalised ratings on the interval [0,1] ------------------------

  mydf <- fugazi_song_preferences

  mydf <- mydf %>%
    select(rank_rating, songid, song, Estimate)

  mymin <- min(mydf$Estimate)

  mydf <- mydf %>%
    mutate(Estimate2 = Estimate - mymin)

  mymax <- max(mydf$Estimate2)

  mydf <- mydf %>%
    mutate(rating = Estimate2/mymax)

  mydf <- mydf %>%
    select(rank_rating, songid, rating)

  mydf2 <- fugazi_song_performance_intensity

  mydf2 <- mydf2 %>%
    left_join(mydf)

  mydf2 <- mydf2 %>%
    arrange(desc(rating))

  mydf2 <- mydf2 %>%
    relocate(rank_rating)

  mydf2 <- mydf2 %>%
    left_join(songvarslookup)

  mydf2 <- mydf2 %>%
    relocate(duration_seconds, .after=launchdate)

  summary <- mydf2 %>%
    select(songid, song, launchdate, duration_seconds, chosen, available_rl, intensity, rating) %>%
    arrange(desc(rating)) %>%
    mutate(rank = row_number()) %>%
    relocate(rank) %>%
    rename(duration = duration_seconds)

  # Evaluation of releases using the song ratings ---------------------------

  mydf <- releasesdatalookup

  mydf2 <- summary %>%
    left_join(songvarslookup)

  mydf2 <- mydf2 %>%
    select(songid, releaseid, song, rating)

  mydf2 <- mydf2 %>%
    left_join(mydf)

  mydf2 <- mydf2 %>%
    group_by(release, releaseid, rym_rating, releasedate) %>%
    summarise(rating = mean(rating), songs_rated = n()) %>%
    ungroup()

  mydf2 <- mydf2 %>%
    arrange(desc(rating))

  # remove First Demo and Unreleased as they are not comparable to the others.
  releases_rated <- mydf2 %>%
    filter(releaseid!=11) %>%
    filter(releaseid!=13)

  releases_rated <- releases_rated %>%
    filter(is.na(releaseid)==FALSE)

  releases_rated <- releases_rated %>%
    select(release, releaseid, releasedate, songs_rated, rating, rym_rating)

  write.csv(releases_rated, "releases_rated.csv")

  save(releases_rated, file = "releases_rated.rda")

  knitr::kable(releases_rated, "pipe")

  # add other variables to summary table

  releasedates <- releasesdatalookup %>%
    select(releaseid, releasedate) %>%
    mutate(releasedate = as.Date(releasedate, "%d/%m/%Y"))

  mydf <- songvarslookup %>%
    left_join(releasedates) %>%
    left_join(songidlookup)

  mydf <- mydf %>%
    select(songid, song, releaseid, releasedate) %>%
    arrange(songid)

  summary <- summary %>%
    left_join(mydf) %>%
    mutate(launchdate = as.Date(launchdate, "%d/%m/%Y")) %>%
    mutate(lead = releasedate - launchdate) %>%
    arrange(desc(rating))

  summary$launchyear <- lubridate::year(summary$launchdate)
  summary$releaseyear <- lubridate::year(summary$releasedate)

  summary$songid <- as.integer(summary$songid)
  summary$chosen <- as.integer(summary$chosen)
  summary$available_rl <- as.integer(summary$available_rl)
  summary$releaseid <- as.integer(summary$releaseid)
  summary$lead <- as.integer(summary$lead)

  releaseid_release <- releasesdatalookup %>%
    select(releaseid, release)

  summary <- summary %>%
    left_join(releaseid_release) %>%
    relocate(release, .after = releaseid)

  write.csv(summary, "summary.csv")

  save(summary, file = "summary.rda")

  releases_data_input <- releases_data_input

  summary <- summary %>%
    select(song, rating)

  releases_data_input <- releases_data_input %>%
    left_join(summary) %>%
    mutate(rating = round(rating, digits = 4)) %>%
    arrange(desc(releaseid), desc(track_number))

  save(releases_data_input, file = "releases_data_input.rda")

  releases_summary <- releases_data_input %>%
    group_by(releaseid, release, last_show) %>%
    summarize(count = sum(count),
              songs=n(),
              first_debut=min(date),
              last_debut=max(date),
              first_show = min(show_num),
              shows = round(mean(shows), digits=0),
              intensity = round(mean(intensity), digits = 4),
              rating = round(mean(rating), digits = 4)) %>%
    ungroup()

  releasesdatalookup <- releasesdatalookup %>%
    select(releaseid, releasedate) %>%
    mutate(releasedate = as.Date(releasedate, "%d/%m/%Y", origin = "1970-01-01"))

  releases_summary <- releases_summary %>%
    left_join(releasesdatalookup) %>%
    select(releaseid, release, first_debut, last_debut, releasedate, songs, count, shows, intensity, rating) %>%
    rename(release_date = releasedate) %>%
    filter(releaseid>0)

  save(releases_summary, file = "releases_summary.rda")

  knitr::kable(summary, "pipe")

  myreturnlist <- list(fugazi_song_choice_model, fugazi_song_preferences, summary, releases_rated, releases_data_input)

  return(myreturnlist)

}
