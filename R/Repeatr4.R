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


  Repeatr3$case <- factor(as.numeric(as.factor(Repeatr3$case)))
  Repeatr3$alt <- as.factor(Repeatr3$alt)
  Repeatr3$choice <- as.logical(Repeatr3$choice)
  Repeatr3 <- dfidx(Repeatr3, idx = c("case", "alt"), drop.index = FALSE)

  # The basic model.

  ml.Repeatr31 <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5
                         + yearsold_6 + yearsold_7 + yearsold_8 , data = Repeatr3)

  summary.ml.Repeatr31 <- summary(ml.Repeatr31)

  summary.ml.Repeatr31

  # A more detailed model that includes first song instrumental effect and potential differences between the preferences of Ian MacKaye and Guy Picciotto regarding the age of their songs.

  ml.Repeatr32 <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5
                         + yearsold_6 + yearsold_7 + yearsold_8 + yearsold_1_vp + yearsold_2_vp + yearsold_3_vp + yearsold_4_vp + yearsold_5_vp + yearsold_6_vp + yearsold_7_vp + yearsold_8_vp + first_song_instrumental, data = Repeatr3)

  summary.ml.Repeatr32 <- summary(ml.Repeatr32)

  summary.ml.Repeatr32

  # First song model ---------------------------------------------------

  Repeatr3_fs <- Repeatr3 %>%
    filter(first_song==1)

  Repeatr3_fs_counts <- Repeatr3_fs %>%
    filter(choice==TRUE) %>%
    group_by(alt) %>%
    summarise(chosen=n()) %>%
    mutate(songid=as.integer(alt)) %>%
    ungroup()

  Repeatr3_fs_counts <- Repeatr3_fs_counts %>%
    left_join(mysongidlookup) %>%
    select(alt, song, chosen)

  Repeatr3_fs <- Repeatr3_fs %>%
    left_join(Repeatr3_sno_counts)

  Repeatr3_fs <- Repeatr3_fs %>%
    mutate(yearsold_3 = yearsold_3 + yearsold_4 + yearsold_5 + yearsold_6 + yearsold_7 + yearsold_8)

  # It is necessary to remove the alternatives that were never chosen as the first song

  Repeatr3_fs <- Repeatr3_fs %>%
    filter(is.na(chosen)==FALSE)

  ml.Repeatr3_fs <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3, data = Repeatr3_fs)

  summary.ml.Repeatr3_fs <- summary(ml.Repeatr3_fs)

  summary.ml.Repeatr3_fs

  # Last song model ---------------------------------------------------

  Repeatr3_ls <- Repeatr3 %>%
    filter(last_song==1)

  Repeatr3_ls_counts <- Repeatr3_ls %>%
    filter(choice==TRUE) %>%
    group_by(alt) %>%
    summarise(chosen=n()) %>%
    mutate(songid=as.integer(alt)) %>%
    ungroup()

  Repeatr3_ls_counts <- Repeatr3_ls_counts %>%
    left_join(mysongidlookup) %>%
    select(alt, song, chosen)

  Repeatr3_ls <- Repeatr3_ls %>%
    left_join(Repeatr3_ls_counts)

  # It is necessary to remove the alternatives that were never chosen as the last song

  Repeatr3_ls <- Repeatr3_ls %>%
    filter(is.na(chosen)==FALSE)

  ml.Repeatr3_ls <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5 + yearsold_6 + yearsold_7 + yearsold_8, data = Repeatr3_ls)

  summary.ml.Repeatr3_ls <- summary(ml.Repeatr3_ls)

  summary.ml.Repeatr3_ls

}


