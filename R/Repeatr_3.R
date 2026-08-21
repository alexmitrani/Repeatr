
#' @name Repeatr_3
#' @title takes a dataframe with gid, song_number, and alt, and modifies it to make it suitable for choice modelling.
#' @description "gid" is short for "gig id"
#'
#' @param mydf optional dataframe to be used.  If omitted the default dataframe will be used.
#' @param output_dir Optional directory to save the rebuilt `data/Repeatr3.rda` into. If omitted, defaults to `data/` under the current working directory.
#'
#' @return A data frame (`Repeatr3`) reduced to the variables needed for mlogit choice modelling (`case`, `song_number`, `alt`, `choice`, `yearsold` buckets and their interactions with vocalist dummies, etc.), with numeric variables compressed to integer storage via `compressr()`. Also saved to `data/Repeatr3.rda`.
#' @export
#'
#' @examples
#' Repeatr3 <- Repeatr_3(mydf = Repeatr2, output_dir = tempdir())
#'
Repeatr_3 <- function(mydf = NULL, output_dir = NULL) {

  mydir <- getwd()
  on.exit(setwd(mydir), add = TRUE)
  mydatadir <- if (is.null(output_dir)) paste0(mydir, "/data") else output_dir

  if (is.null(mydf)==FALSE) {

    Repeatr2 <- mydf

  } else {

    Repeatr2 <- Repeatr2

  }

  # Keep only the specific variables needed for the modelling --------

  Repeatr3 <- Repeatr2 %>%
    select(.data$gid, .data$case, .data$song_number, .data$alt, .data$choice, .data$yearsold, .data$vocals_mackaye, .data$vocals_picciotto, .data$vocals_lally, .data$instrumental, .data$first_song, .data$last_song, .data$duration_seconds) %>%
    arrange(.data$case, .data$song_number, .data$alt)

  rm(Repeatr2)

  Repeatr3 <- Repeatr3 %>%
    mutate(yearsold = case_when(
      .data$yearsold >= 0 & .data$yearsold < 1  ~ 0L,
      .data$yearsold >= 1 & .data$yearsold < 2  ~ 1L,
      .data$yearsold >= 2 & .data$yearsold < 3  ~ 2L,
      .data$yearsold >= 3 & .data$yearsold < 4  ~ 3L,
      .data$yearsold >= 4 & .data$yearsold < 5  ~ 4L,
      .data$yearsold >= 5 & .data$yearsold < 6  ~ 5L,
      .data$yearsold >= 6 & .data$yearsold < 7  ~ 6L,
      .data$yearsold >= 7 & .data$yearsold < 8  ~ 7L,
      .data$yearsold >= 8  ~ 8L,
      TRUE ~ 9L
    )
    )

  Repeatr3 <- dummy_cols(Repeatr3, select_columns = "yearsold")

  Repeatr3 <- Repeatr3 %>%
    mutate(yearsold_1_vp = .data$yearsold_1*.data$vocals_picciotto) %>%
    mutate(yearsold_2_vp = .data$yearsold_2*.data$vocals_picciotto) %>%
    mutate(yearsold_3_vp = .data$yearsold_3*.data$vocals_picciotto) %>%
    mutate(yearsold_4_vp = .data$yearsold_4*.data$vocals_picciotto) %>%
    mutate(yearsold_5_vp = .data$yearsold_5*.data$vocals_picciotto) %>%
    mutate(yearsold_6_vp = .data$yearsold_6*.data$vocals_picciotto) %>%
    mutate(yearsold_7_vp = .data$yearsold_7*.data$vocals_picciotto) %>%
    mutate(yearsold_8_vp = .data$yearsold_8*.data$vocals_picciotto)

  Repeatr3 <- Repeatr3 %>%
    mutate(first_song_instrumental = .data$first_song*.data$instrumental)

  Repeatr3_lookup <- Repeatr3 %>%
    filter(.data$choice==TRUE) %>%
    group_by(.data$gid, .data$song_number) %>%
    slice(1) %>%
    ungroup()

  Repeatr3_lookup <- Repeatr3_lookup %>%
    group_by(.data$gid) %>%
    arrange(.data$gid, .data$song_number) %>%
    mutate(vocals_picciotto_sum = cumsum(.data$vocals_picciotto)) %>%
    mutate(vocals_mackaye_sum = cumsum(.data$vocals_mackaye)) %>%
    mutate(vocals_lally_sum = cumsum(.data$vocals_lally)) %>%
    ungroup()

  Repeatr3_lookup <- Repeatr3_lookup %>%
    select(.data$case, .data$vocals_picciotto_sum, .data$vocals_mackaye_sum, .data$vocals_lally_sum)

  Repeatr3 <- Repeatr3 %>%
    left_join(Repeatr3_lookup)

  # compress the data by converting variables to integers --------

  mycompressrvars <- scan(text="vocals_mackaye vocals_picciotto vocals_lally vocals_picciotto_sum vocals_mackaye_sum vocals_lally_sum instrumental song_number first_song_instrumental duration_seconds yearsold yearsold_1 yearsold_2 yearsold_3 yearsold_4 yearsold_5 yearsold_6 yearsold_7 yearsold_8 yearsold_1_vp yearsold_2_vp yearsold_3_vp yearsold_4_vp yearsold_5_vp yearsold_6_vp yearsold_7_vp yearsold_8_vp", what="")
  Repeatr3 <- compressr(Repeatr3, mycompressrvars)

  # Repeatr3$case <- factor(as.numeric(as.factor(Repeatr3$case)))
  # Repeatr3$alt <- as.factor(Repeatr3$alt)
  # Repeatr3$choice <- as.logical(Repeatr3$choice)
  # Repeatr3 <- dfidx(Repeatr3, idx = c("case", "alt"), drop.index = FALSE)

  checksongcounts <- Repeatr3 %>% group_by(.data$alt) %>% summarise(count = sum(.data$choice)) %>% ungroup()
  checksongcounts

  setwd(mydatadir)

  save(Repeatr3, file = "Repeatr3.rda")

  setwd(mydir)

  return(Repeatr3)

  gc()

}

