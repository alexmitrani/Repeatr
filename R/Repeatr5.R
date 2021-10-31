#' @name Repeatr5
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
#' Repeatr5 <- Repeatr5 (mymodel = ml.Repeatr4)
#'
#'
#'
Repeatr5 <- function(mymodel = NULL) {

  songs_releases <- read.csv("releases_rym.csv")
  songs_releases$X <- NULL

  # Report results of the choice modelling for the preferred choice model ----------------------------------

  browser()

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

  write.csv(results.mymodel, "fugazi_song_preferences.csv")


  # To produce normalised ratings on the interval [0,1] ------------------------

  mydf <- read.csv("fugazi_song_preferences.csv")

  mydf <- mydf %>%
    rename(rank_rating = X)

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
    relocate(duration, .after=launchdate)

  write.csv(mydf2, "summary.csv")

  knitr::kable(mydf2, "pipe")


  # Evaluation of releases using the song ratings ---------------------------

  mydf <- read.csv("songs_releases.csv")

  mydf <- mydf %>%
    group_by(release) %>%
    summarise(releaseid = mean(releaseid), releasedate=min(releasedate)) %>%
    ungroup()

  mydf <- mydf %>%
    select(releaseid, release, releasedate) %>%
    arrange(releasedate)

  write.csv(mydf, "releases.csv")

  mydf <- read.csv("songs_releases.csv")

  mydf2 <- read.csv("summary.csv")

  mydf2 <- mydf2 %>%
    select(songid, song, rating)

  mydf2 <- mydf2 %>%
    left_join(mydf)

  mydf2 <- mydf2 %>%
    group_by(release, releaseid, releasedate) %>%
    summarise(rating = mean(rating), songs_rated = n()) %>%
    ungroup()

  mydf2 <- mydf2 %>%
    arrange(desc(rating))

  # remove First Demo as it is not comparable to the others.
  mydf2 <- mydf2 %>%
    filter(releaseid!=11)

  write.csv(mydf2, "releases_rated.csv")

  mydf <- read.csv("releases_rated_rym.csv")

  mydf$X <- NULL

  mydf <- mydf %>%
    filter(is.na(releaseid)==FALSE)

  mydf <- mydf %>%
    select(release, releaseid, releasedate, songs_rated, rating, rym_rating)

  knitr::kable(mydf, "pipe")

}
