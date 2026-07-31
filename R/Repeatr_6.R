
#' @name Repeatr_6
#' @title Regenerates gid_initial_gid_sound_quality, a set of "stacks" of shows covering the whole Fugazi repertoire.
#' @description Runs sweepstack() over the full available set of shows/songs and rebuilds gid_initial_gid_sound_quality,
#' the dataset behind the Shiny app's "stock" pages (see inst/shiny/Fugazetteer/app.R).
#'
#' @import dplyr
#' @import stringr
#' @import lubridate
#' @import fastDummies
#' @import rlang
#' @import knitr
#'
#' @param myduration_data_da optional `duration_data_da` dataframe (as produced by `Repeatr_1()`), passed through to `sweepstack()`. If omitted the currently lazy-loaded default will be used - pass this explicitly when calling `Repeatr_6()` right after a fresh `Repeatr_1()` in the same session.
#' @param mysummary optional `summary` dataframe (as produced by `Repeatr_5()`), passed through to `sweepstack()`/`stacks()`. If omitted the currently lazy-loaded default will be used.
#' @param myothervariables optional `othervariables` dataframe (the clean, pre-join copy as saved by `Repeatr_1()`), passed through to `sweepstack()`/`stacks()`. If omitted the currently lazy-loaded default will be used.
#' @param mygidsoundquality optional `gid_sound_quality` dataframe (as produced by `Repeatr_1()`), passed through to `sweepstack()`/`stacks()` and used again directly here to attach sound quality to each stacked show. If omitted the currently lazy-loaded default will be used.
#' @param number_stacks passed through to `sweepstack()` - the number of starting shows to test. If omitted all possible starting shows will be tested.
#' @param exclude_poor_sound_quality passed through to `sweepstack()`/`stacks()` - set to TRUE to exclude shows with sound quality rated as 'Poor'.
#'
#' @return Invisibly, `gid_initial_gid_sound_quality` (`gid_initial`, `gid`, `sound_quality`, `count` - one row per unique show/stack/sound-quality combination). As a side effect, also saved into `data/gid_initial_gid_sound_quality.rda`.
#' @export
#'
#' @examples
#' Repeatr_6(number_stacks = 10, exclude_poor_sound_quality = TRUE)
#'
Repeatr_6 <- function(myduration_data_da = NULL, mysummary = NULL, myothervariables = NULL, mygidsoundquality = NULL,
                       number_stacks = NULL, exclude_poor_sound_quality = FALSE) {

  mydir <- getwd()
  on.exit(setwd(mydir), add = TRUE)
  mydatadir <- paste0(mydir, "/data")

  # Use the lookup tables freshly returned by this session's Repeatr_1()/
  # Repeatr_5() calls if supplied, otherwise fall back to whatever is
  # currently lazy-loaded from data/ (the package's last build) - see
  # Repeatr_Updatr.R for why threading these through matters when chaining
  # a fresh pipeline run.
  if (is.null(myduration_data_da)==FALSE) { duration_data_da <- myduration_data_da } else { duration_data_da <- duration_data_da }
  if (is.null(mysummary)==FALSE) { summary <- mysummary } else { summary <- summary }
  if (is.null(myothervariables)==FALSE) { othervariables <- myothervariables } else { othervariables <- othervariables }
  if (is.null(mygidsoundquality)==FALSE) { gid_sound_quality <- mygidsoundquality } else { gid_sound_quality <- gid_sound_quality }

  results <- sweepstack(number_stacks = number_stacks, exclude_poor_sound_quality = exclude_poor_sound_quality,
                         myduration_data_da = duration_data_da, mysummary = summary,
                         myothervariables = othervariables, mygidsoundquality = gid_sound_quality)

  results1 <- results[[1]]
  results2 <- results[[2]]

  results2 <- results2 %>% left_join(gid_sound_quality)

  gid_initial_gid_sound_quality <- results2 %>%
    group_by(gid_initial, gid, sound_quality) %>%
    summarize(count = n()) %>%
    ungroup()

  setwd(mydatadir)
  save(gid_initial_gid_sound_quality, file = "gid_initial_gid_sound_quality.rda")
  setwd(mydir)

  check_stacks <- gid_initial_gid_sound_quality %>%
    filter(is.na(sound_quality)==FALSE) %>%
    group_by(gid_initial) %>%
    summarize(count = n()) %>%
    ungroup()

  nstacks <- nrow(check_stacks)
  minshows <- min(check_stacks$count)
  maxshows <- max(check_stacks$count)

  stacks_message <- paste0(nstacks, " stacks of ", minshows, " - ", maxshows, " shows.")
  print(stacks_message)

  return(invisible(gid_initial_gid_sound_quality))

}
