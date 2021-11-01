
#' @name Repeatr3
#' @title takes a dataframe with gid, song_number, and songid, and modifies it to make it suitable for choice modelling.
#' @description
#' @description
#' @description "gid" is short for "gig id"
#'
#' @import dplyr
#' @import stringr
#' @import lubridate
#' @import mlogit
#' @import fastDummies
#' @import rlang
#' @import knitr
#'
#' @param mydf
#' @param savedata
#'
#' @return
#' @export
#'
#' @examples
#' Repeatr3 <- Repeatr3(mydf = Repeatr2)
#'
Repeatr3 <- function(mydf = NULL, savedata = FALSE) {

  if(file.exists("data.RData")) {

    load("data.RData")

  }

  if (is.null(mydf)==FALSE) {

    Repeatr2 <- mydf

  }

  # Keep only the specific variables needed for the modelling --------

  Repeatr3 <- Repeatr2 %>%
    select(gid, case, song_number, alt, choice, yearsold, vocals_mackaye, vocals_picciotto, vocals_lally, instrumental, first_song, last_song, duration_seconds) %>%
    arrange(case, song_number, alt)

  rm(Repeatr2)

  Repeatr3 <- Repeatr3 %>%
    mutate(yearsold = case_when(
      yearsold >= 0 & yearsold < 1  ~ 0L,
      yearsold >= 1 & yearsold < 2  ~ 1L,
      yearsold >= 2 & yearsold < 3  ~ 2L,
      yearsold >= 3 & yearsold < 4  ~ 3L,
      yearsold >= 4 & yearsold < 5  ~ 4L,
      yearsold >= 5 & yearsold < 6  ~ 5L,
      yearsold >= 6 & yearsold < 7  ~ 6L,
      yearsold >= 7 & yearsold < 8  ~ 7L,
      yearsold >= 8  ~ 8L,
      TRUE ~ 9L
    )
    )

  Repeatr3 <- dummy_cols(Repeatr3, select_columns = "yearsold")

  Repeatr3 <- Repeatr3 %>%
    mutate(yearsold_1_vp = yearsold_1*vocals_picciotto) %>%
    mutate(yearsold_2_vp = yearsold_2*vocals_picciotto) %>%
    mutate(yearsold_3_vp = yearsold_3*vocals_picciotto) %>%
    mutate(yearsold_4_vp = yearsold_4*vocals_picciotto) %>%
    mutate(yearsold_5_vp = yearsold_5*vocals_picciotto) %>%
    mutate(yearsold_6_vp = yearsold_6*vocals_picciotto) %>%
    mutate(yearsold_7_vp = yearsold_7*vocals_picciotto) %>%
    mutate(yearsold_8_vp = yearsold_8*vocals_picciotto)

  Repeatr3 <- Repeatr3 %>%
    mutate(first_song_instrumental = first_song*instrumental)

  Repeatr3_lookup <- Repeatr3 %>%
    filter(choice==TRUE) %>%
    group_by(gid, song_number) %>%
    slice(1) %>%
    ungroup()

  Repeatr3_lookup <- Repeatr3_lookup %>%
    group_by(gid) %>%
    arrange(gid, song_number) %>%
    mutate(vocals_picciotto_sum = cumsum(vocals_picciotto)) %>%
    mutate(vocals_mackaye_sum = cumsum(vocals_mackaye)) %>%
    mutate(vocals_lally_sum = cumsum(vocals_lally)) %>%
    ungroup()

  Repeatr3_lookup <- Repeatr3_lookup %>%
    select(case, vocals_picciotto_sum, vocals_mackaye_sum, vocals_lally_sum)

  Repeatr3 <- Repeatr3 %>%
    left_join(Repeatr3_lookup)

  # compress the data by converting variables to integers --------

  mycompressrvars <- scan(text="vocals_mackaye vocals_picciotto vocals_lally vocals_picciotto_sum vocals_mackaye_sum vocals_lally_sum instrumental song_number first_song_instrumental duration_seconds yearsold yearsold_1 yearsold_2 yearsold_3 yearsold_4 yearsold_5 yearsold_6 yearsold_7 yearsold_8 yearsold_1_vp yearsold_2_vp yearsold_3_vp yearsold_4_vp yearsold_5_vp yearsold_6_vp yearsold_7_vp yearsold_8_vp", what="")
  Repeatr3 <- compressr(Repeatr3, mycompressrvars)

  # Repeatr3$case <- factor(as.numeric(as.factor(Repeatr3$case)))
  # Repeatr3$alt <- as.factor(Repeatr3$alt)
  # Repeatr3$choice <- as.logical(Repeatr3$choice)
  # Repeatr3 <- dfidx(Repeatr3, idx = c("case", "alt"), drop.index = FALSE)

  checksongcounts <- Repeatr3 %>% group_by(alt) %>% summarise(count = sum(choice)) %>% ungroup()
  checksongcounts

  if (savedata==TRUE) {

    save(Repeatr0, Repeatr1, Repeatr2, Repeatr3, fugazi_song_counts, fugazi_song_performance_intensity, mysongidlookup, mycount, mysongvarslookup, releasesdatalookup, file = "data.RData", compress = "xz")

  }

  return(Repeatr3)

  gc()

}

