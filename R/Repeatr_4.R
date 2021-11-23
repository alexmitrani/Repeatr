#' @name Repeatr_4
#' @title Prepares data for choice modelling with mlogit.  Running pre-defined choice models is optional.
#' @description Defines indices, makes changes to variable formats and data structure to prepare for choice modelling with mlogit.
#'
#' @import dplyr
#' @import stringr
#' @import lubridate
#' @import fastDummies
#' @import rlang
#' @import knitr
#'
#'
#' @param mydf optional dataframe to be used.  If omitted, the default dataframe will be used.
#' @param basic_model This should be set to TRUE if the basic choice model should be run, otherwise it will be skipped.
#' @param first_song_model This should be set to TRUE if the first song choice model should be run, otherwise it will be skipped.
#' @param other_songs_model This should be set to TRUE if the other songs choice model should be run, otherwise it will be skipped.
#'
#' @return
#' @export
#'
#' @examples
#' ml.Repeatr4_fs <- Repeatr_4()

Repeatr_4 <- function(mydf = NULL, basic_model = FALSE, first_song_model = FALSE, other_songs_model = FALSE) {

  # Choice modelling --------------------------------


  if (is.null(mydf)==FALSE) {

    Repeatr3 <- mydf

  }

  Repeatr4 <- Repeatr3

  Repeatr4$case <- factor(as.numeric(as.factor(Repeatr4$case)))
  Repeatr4$alt <- as.factor(Repeatr4$alt)
  Repeatr4$choice <- as.logical(Repeatr4$choice)


  if (basic_model == TRUE) {

    Repeatr4 <- dfidx(Repeatr4, idx = c("case", "alt"), drop.index = FALSE)

    # The basic model.

    ml.Repeatr4 <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5
                           + yearsold_6 + yearsold_7 + yearsold_8 , data = Repeatr4)

    summary.ml.Repeatr4 <- summary(ml.Repeatr4)

    summary.ml.Repeatr4

    return(ml.Repeatr4)

  } else if (first_song_model == TRUE) {

    Repeatr4 <- dfidx(Repeatr4, idx = c("case", "alt"), drop.index = FALSE)

    # First song model ---------------------------------------------------

    Repeatr4_fs <- Repeatr4 %>%
      filter(first_song==1)

    Repeatr4_fs_counts <- Repeatr4_fs %>%
      filter(choice==TRUE) %>%
      group_by(alt) %>%
      summarise(chosen=n()) %>%
      mutate(songid=as.integer(alt)) %>%
      ungroup()

    Repeatr4_fs_counts <- Repeatr4_fs_counts %>%
      left_join(songidlookup) %>%
      select(alt, song, chosen)

    Repeatr4_fs <- Repeatr4_fs %>%
      left_join(Repeatr4_fs_counts)

    Repeatr4_fs <- Repeatr4_fs %>%
      mutate(yearsold_3 = yearsold_3 + yearsold_4 + yearsold_5 + yearsold_6 + yearsold_7 + yearsold_8)

    # It is necessary to remove the alternatives that were never chosen

    Repeatr4_fs <- Repeatr4_fs %>%
      filter(is.na(chosen)==FALSE)

    ml.Repeatr4_fs <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3, data = Repeatr4_fs)

    summary.ml.Repeatr4_fs <- summary(ml.Repeatr4_fs)

    summary.ml.Repeatr4_fs

    return(ml.Repeatr4_fs)

  } else if (other_songs_model == TRUE) {

    Repeatr4 <- dfidx(Repeatr4, idx = c("case", "alt"), drop.index = FALSE)

    # Other songs model -------------------------------------------------

    Repeatr4_os <- Repeatr4 %>%
      filter(first_song==0)

    Repeatr4_os_counts <- Repeatr4_os %>%
      filter(choice==TRUE) %>%
      group_by(alt) %>%
      summarise(chosen=n()) %>%
      mutate(songid=as.integer(alt)) %>%
      ungroup()

    Repeatr4_os_counts <- Repeatr4_os_counts %>%
      left_join(songidlookup) %>%
      select(alt, song, chosen)

    Repeatr4_os <- Repeatr4_os %>%
      left_join(Repeatr4_os_counts)

    # It is necessary to remove the alternatives that were never chosen

    Repeatr4_os <- Repeatr4_os %>%
      filter(is.na(chosen)==FALSE)

    ml.Repeatr4_os <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5
                           + yearsold_6 + yearsold_7 + yearsold_8, data = Repeatr4_os)

    summary.ml.Repeatr4_os <- summary(ml.Repeatr4_os)

    summary.ml.Repeatr4_os

    return(ml.Repeatr4_os)

  }

}


