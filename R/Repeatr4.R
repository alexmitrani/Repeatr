#' @name Repeatr4
#' @title Runs choice models
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
#' @param mydf
#'
#' @return
#' @export
#'
#' @examples
#' Repeatr4 <- Repeatr4(mydf = Repeatr3)
#'
#'
#'
#'
#'

Repeatr4 <- function(mydf = NULL) {

  # Choice modelling --------------------------------

  if(file.exists("data.RData")) {

    load("data.RData")

  }

  if (is.null(mydf)==FALSE) {

    Repeatr3 <- mydf

  }

  Repeatr4 <- Repeatr3
  rm(Repeatr3)

  Repeatr4$case <- factor(as.numeric(as.factor(Repeatr4$case)))
  Repeatr4$alt <- as.factor(Repeatr4$alt)
  Repeatr4$choice <- as.logical(Repeatr4$choice)
  Repeatr4 <- dfidx(Repeatr4, idx = c("case", "alt"), drop.index = FALSE)

  # The basic model.

  ml.Repeatr4 <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5
                         + yearsold_6 + yearsold_7 + yearsold_8 , data = Repeatr4)

  summary.ml.Repeatr4 <- summary(ml.Repeatr4)

  summary.ml.Repeatr4

  save(Repeatr0, Repeatr1, Repeatr2, Repeatr4, fugazi_song_counts, fugazi_song_performance_intensity, mysongidlookup, mycount, mysongvarslookup, ml.Repeatr4, file = "data.RData", compress = "xz")

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
    left_join(mysongidlookup) %>%
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

  save(Repeatr0, Repeatr1, Repeatr2, Repeatr4, fugazi_song_counts, fugazi_song_performance_intensity, mysongidlookup, mycount, mysongvarslookup, ml.Repeatr4, ml.Repeatr4_fs, file = "data.RData", compress = "xz")

  # Last song model ---------------------------------------------------

  Repeatr4_ls <- Repeatr4 %>%
    filter(last_song==1)

  Repeatr4_ls_counts <- Repeatr4_ls %>%
    filter(choice==TRUE) %>%
    group_by(alt) %>%
    summarise(chosen=n()) %>%
    mutate(songid=as.integer(alt)) %>%
    ungroup()

  Repeatr4_ls_counts <- Repeatr4_ls_counts %>%
    left_join(mysongidlookup) %>%
    select(alt, song, chosen)

  Repeatr4_ls <- Repeatr4_ls %>%
    left_join(Repeatr4_ls_counts)

  # It is necessary to remove the alternatives that were never chosen

  Repeatr4_ls <- Repeatr4_ls %>%
    filter(is.na(chosen)==FALSE)

  ml.Repeatr4_ls <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5 + yearsold_6 + yearsold_7 + yearsold_8, data = Repeatr4_ls)

  summary.ml.Repeatr4_ls <- summary(ml.Repeatr4_ls)

  summary.ml.Repeatr4_ls

  save(Repeatr0, Repeatr1, Repeatr2, Repeatr4, fugazi_song_counts, fugazi_song_performance_intensity, mysongidlookup, mycount, mysongvarslookup, ml.Repeatr4, ml.Repeatr4_fs, ml.Repeatr4_ls, file = "data.RData", compress = "xz")

# Intermediate song model -------------------------------------------------

  Repeatr4_is <- Repeatr4 %>%
    filter(first_song==0 & last_song==0)

  Repeatr4_is_counts <- Repeatr4_is %>%
    filter(choice==TRUE) %>%
    group_by(alt) %>%
    summarise(chosen=n()) %>%
    mutate(songid=as.integer(alt)) %>%
    ungroup()

  Repeatr4_is_counts <- Repeatr4_is_counts %>%
    left_join(mysongidlookup) %>%
    select(alt, song, chosen)

  Repeatr4_is <- Repeatr4_is %>%
    left_join(Repeatr4_is_counts)

  # It is necessary to remove the alternatives that were never chosen

  Repeatr4_is <- Repeatr4_is %>%
    filter(is.na(chosen)==FALSE)

  ml.Repeatr4_is <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5
                         + yearsold_6 + yearsold_7 + yearsold_8 + yearsold_1_vp + yearsold_2_vp + yearsold_3_vp + yearsold_4_vp + yearsold_5_vp + yearsold_6_vp + yearsold_7_vp + yearsold_8_vp, data = Repeatr4_is)

  summary.ml.Repeatr4_is <- summary(ml.Repeatr4_is)

  summary.ml.Repeatr4_is


# Save results ------------------------------------------------------------

  save(Repeatr0, Repeatr1, Repeatr2, Repeatr3, Repeatr4, fugazi_song_counts, fugazi_song_performance_intensity, mysongidlookup, mycount, mysongvarslookup, ml.Repeatr4, ml.Repeatr4_fs, ml.Repeatr4_ls, ml.Repeatr4_is, file = "data.RData", compress = "xz")

  myreturnlist <- list(ml.Repeatr4, ml.Repeatr4_fs, ml.Repeatr4_ls, ml.Repeatr4_is)

  return(myreturnlist)

}


