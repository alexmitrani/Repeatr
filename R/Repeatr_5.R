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
#' @param mymodeldf optional choice model coefficients dataframe to be used to generate the results. If omitted, the default choice model coefficients dataframe will be used, which is results.ml.Repeatr4.
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

  choice_model_results_table <- cbind.data.frame(variable, results.mymodel)

  choice_model_results_table <- choice_model_results_table %>%
    mutate(songid = ifelse(grepl("(Intercept)",variable)==TRUE,readr::parse_number(variable),NA))

  choice_model_results_table <- choice_model_results_table %>%
    left_join(songidlookup)

  choice_model_results_table <- choice_model_results_table %>%
    mutate(variable = ifelse(grepl("(Intercept)",variable)==TRUE,song,variable))

  choice_model_results_table$songid <- NULL
  choice_model_results_table$song <- NULL

  knitr::kable(choice_model_results_table, "pipe")

  write.csv(choice_model_results_table, "fugazi_song_choice_model.csv")

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

  # remove First Demo as it is not comparable to the others.
  releases_rated <- mydf2 %>%
    filter(releaseid!=11)

  releases_rated <- releases_rated %>%
    filter(is.na(releaseid)==FALSE)

  releases_rated <- releases_rated %>%
    select(release, releaseid, releasedate, songs_rated, rating, rym_rating)

  write.csv(releases_rated, "releases_rated.csv")

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
    arrange(launchdate)

  summary$launchyear <- lubridate::year(summary$launchdate)
  summary$releaseyear <- lubridate::year(summary$releasedate)

  summary$songid <- as.integer(summary$songid)
  summary$chosen <- as.integer(summary$chosen)
  summary$available_rl <- as.integer(summary$available_rl)
  summary$releaseid <- as.integer(summary$releaseid)
  summary$lead <- as.integer(summary$lead)

  write.csv(summary, "summary.csv")

  knitr::kable(summary, "pipe")

  myreturnlist <- list(choice_model_results_table, fugazi_song_preferences, summary, releases_rated)

  return(myreturnlist)

}
