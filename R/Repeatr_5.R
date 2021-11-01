#' @name Repeatr_5
#' @title Produces results using a preferred choice model supplied by the user as "mymodel"
#' @description
#' @description
#' @description
#'
#' @import dplyr
#' @import stringr
#' @import lubridate
#' @import mlogit
#' @import fastDummies
#' @import rlang
#' @import knitr
#'
#'
#' @param mymodel
#'
#' @return
#' @export
#'
#' @examples
#' mlRepeatr <- system.file("data", "mlRepeatr.rdata", package = "Repeatr")
#' load(mlRepeatr)
#' mysongidlookup <- system.file("data", "songidlookup.rda", package = "Repeatr")
#' load(mysongidlookup)
#' mysongvarslookup <- system.file("data", "songvarslookup.rda", package = "Repeatr")
#' load(mysongvarslookup)
#' fugazi_song_performance_intensity <- system.file("data", "fugazi_song_performance_intensity.rda", package = "Repeatr")
#' load(fugazi_song_performance_intensity)
#' Repeatr_5_results <- Repeatr_5(mymodel = ml.Repeatr4, mysongidlookup = songidlookup, mysongvarslookup = songvarslookup, fugazi_song_performance_intensity = fugazi_song_performance_intensity)
#'
#'
#'
Repeatr_5 <- function(mymodel = NULL, mysongidlookup = songidlookup, mysongvarslookup = songvarslookup, fugazi_song_performance_intensity = fugazi_song_performance_intensity) {

  # Report results of the choice modelling for the preferred choice model ----------------------------------

  summary.mymodel <- summary(mymodel)

  results.mymodel <- as.data.frame(summary.mymodel[["CoefTable"]])

  results.mymodel <- results.mymodel %>%
    mutate(parameter_id = row_number()) %>%
    relocate(parameter_id)

  variable <- row.names(results.mymodel)

  choice_model_results_table <- cbind(variable, results.mymodel)

  choice_model_results_table <- choice_model_results_table %>%
    mutate(songid = ifelse(parameter_id<=91,parameter_id+1,NA))

  choice_model_results_table <- choice_model_results_table %>%
    left_join(mysongidlookup)

  choice_model_results_table <- choice_model_results_table %>%
    mutate(variable = ifelse(parameter_id<=91,song,variable))

  choice_model_results_table$songid <- NULL
  choice_model_results_table$song <- NULL

  knitr::kable(choice_model_results_table, "pipe")

  write.csv(choice_model_results_table, "fugazi_song_choice_model.csv")

  results.mymodel <- results.mymodel %>%
    filter(parameter_id<=91)

  results.mymodel <- results.mymodel %>%
    mutate(songid = parameter_id+1)

  results.mymodel <- results.mymodel %>%
    left_join(mysongidlookup)

  results.mymodel <- results.mymodel %>%
    select(songid, song, Estimate, "z-value")

  # to add back in "waiting room" which was the omitted constant in the choice model and has a parameter value of zero by definition.

  results.mymodel.os <- mysongidlookup %>%
    filter(songid==1) %>%
    mutate(Estimate = 0) %>%
    mutate("z-value" = NA)

  results.mymodel <- rbind(results.mymodel, results.mymodel.os)

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
    left_join(mysongvarslookup)

  mydf2 <- mydf2 %>%
    relocate(duration_seconds, .after=launchdate)

  summary <- mydf2 %>%
    select(songid, song, launchdate, duration_seconds, chosen, available_rl, intensity, rating) %>%
    arrange(desc(rating)) %>%
    mutate(rank = row_number()) %>%
    relocate(rank) %>%
    rename(duration = duration_seconds)

  write.csv(summary, "summary.csv")

  knitr::kable(summary, "pipe")

  # Evaluation of releases using the song ratings ---------------------------

  mydf <- releasesdatalookup

  mydf2 <- summary %>%
    left_join(mysongvarslookup)

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

  myreturnlist <- list(choice_model_results_table, fugazi_song_preferences, summary, releases_rated)

  return(myreturnlist)

}
