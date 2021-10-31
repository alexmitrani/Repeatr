
#' @name Repeatr3
#' @title takes a dataframe with gid, song_number, and songid, and modifies it to make it suitable for choice modelling.  Runs several choice models on the data.
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
#'
#' @return
#' @export
#'
#' @examples
#'
#'
#'
Repeatr3 <- function(mydf = NULL) {

  if (is.null(mydf)==FALSE) {

    Repeatr2 <- mydf

  } else {

    Repeatr2 <- Repeatr2

  }

  # Keep only the specific variables needed for the modelling --------

  Repeatr3 <- Repeatr2 %>%
    select(gid, case, song_number, alt, choice, yearsold, vocals_mackaye, vocals_picciotto, vocals_lally, instrumental, first_song, last_song, duration_seconds) %>%
    arrange(case, song_number, alt)

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
    group_by(gid, song_number, case) %>%
    slice(1) %>%
    ungroup()

  Repeatr3_lookup <- Repeatr3_lookup %>%
    mutate(song_number = song_number+1)

  Repeatr3_lookup <- Repeatr3_lookup %>%
    rename(vocals_picciotto_lag = vocals_picciotto) %>%
    rename(vocals_mackaye_lag = vocals_mackaye)

  Repeatr3_lookup <- Repeatr3_lookup %>%
    select(case, vocals_mackaye_lag, vocals_picciotto_lag)

  Repeatr3 <- Repeatr3 %>%
    left_join(Repeatr3_lookup)

  Repeatr3 <- Repeatr3 %>%
    mutate(vp_lag_vocals_mackaye = vocals_picciotto*vocals_mackaye_lag) %>%
    mutate(vp_lag_vocals_picciotto = vocals_picciotto*vocals_picciotto_lag) %>%
    mutate(vm_lag_vocals_mackaye = vocals_mackaye*vocals_mackaye_lag) %>%
    mutate(vm_lag_vocals_picciotto = vocals_mackaye*vocals_picciotto_lag)



  # compress the data by converting variables to integers --------

  mycompressrvars <- scan(text="vocals_mackaye vocals_picciotto vocals_lally vocals_mackaye_lag vocals_picciotto_lag vp_lag_vocals_mackaye vp_lag_vocals_picciotto vm_lag_vocals_picciotto vm_lag_vocals_mackaye instrumental song_number first_song_instrumental duration_seconds yearsold yearsold_1 yearsold_2 yearsold_3 yearsold_4 yearsold_5 yearsold_6 yearsold_7 yearsold_8 yearsold_1_vp yearsold_2_vp yearsold_3_vp yearsold_4_vp yearsold_5_vp yearsold_6_vp yearsold_7_vp yearsold_8_vp", what="")
  Repeatr3 <- compressr(Repeatr3, mycompressrvars)

  Repeatr3$case <- factor(as.numeric(as.factor(Repeatr3$case)))
  Repeatr3$alt <- as.factor(Repeatr3$alt)
  Repeatr3$choice <- as.logical(Repeatr3$choice)
  Repeatr3 <- dfidx(Repeatr3, idx = c("case", "alt"), drop.index = FALSE)

  checksongcounts <- Repeatr3 %>% group_by(alt) %>% summarise(count = sum(choice)) %>% ungroup()
  checksongcounts

  save(Repeatr1, Repeatr2, Repeatr3, file = "data.RData", compress = "xz")

  gc()

  # Choice modelling --------------------------------

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

  # intermediate song model, the idea being to model the two main vocalists taking turns to sing

  Repeatr3_is <- Repeatr3 %>%
    filter(first_song==0 & last_song==0)

  ml.Repeatr3_is <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5
                             + yearsold_6 + yearsold_7 + yearsold_8 + vp_lag_vocals_mackaye + vm_lag_vocals_picciotto, data = Repeatr3_is)

  summary.ml.Repeatr3_is <- summary(ml.Repeatr3_is)

  summary.ml.Repeatr3_is

  # save choice models
  save(Repeatr_wide, Repeatr_long, Repeatr3, ml.Repeatr31, ml.Repeatr32, ml.Repeatr3_fs, ml.Repeatr3_ls, ml.Repeatr3_is, file = "data.RData", compress = "xz")

  # Report results of the choice modelling for the preferred choice model ----------------------------------

  results.ml.sc6 <- as.data.frame(summary.ml.sc6[["CoefTable"]])

  results.ml.sc6 <- results.ml.sc6 %>%
    mutate(parameter_id = row_number()) %>%
    relocate(parameter_id)

  variable <- row.names(results.ml.sc6)

  choice_model_results_table <- cbind(variable, results.ml.sc6)

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

  results.ml.sc6 <- results.ml.sc6 %>%
    filter(parameter_id<=91)

  results.ml.sc6 <- results.ml.sc6 %>%
    mutate(songid = parameter_id+1)

  results.ml.sc6 <- results.ml.sc6 %>%
    left_join(mysongidlookup)

  results.ml.sc6 <- results.ml.sc6 %>%
    select(songid, song, Estimate, "z-value")

  # to add back in "waiting room" which was the omitted constant in the choice model and has a parameter value of zero by definition.

  results.ml.sc6.os <- mysongidlookup %>%
    filter(songid==1) %>%
    mutate(Estimate = 0) %>%
    mutate("z-value" = NA)

  results.ml.sc6 <- rbind(results.ml.sc6, results.ml.sc6.os)

  results.ml.sc6 <- results.ml.sc6 %>%
    arrange(desc(Estimate))

  write.csv(results.ml.sc6, "fugazi_song_preferences.csv")


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

  mydf2 <- read.csv("fugazi_song_performance_intensity.csv")

  mydf2$X <- NULL

  mydf2 <- mydf2 %>%
    left_join(mydf)

  mydf2 <- mydf2 %>%
    arrange(desc(rating))

  mydf2 <- mydf2 %>%
    relocate(rank_rating)

  mydf3 <- read.csv("releases_songs_durations_wikipedia.csv")
  mydf3 <- mydf3 %>% mutate(duration = seconds_to_period(duration_seconds))
  mydf3 <- mydf3 %>% mutate(duration = sprintf('%02d:%02d', minute(duration), second(duration)))
  mydf3 <- mydf3 %>% select(songid, duration)
  write.csv(mydf3, "mysongdurationlookup.csv")

  mydf2 <- mydf2 %>%
    left_join(mydf3)

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

