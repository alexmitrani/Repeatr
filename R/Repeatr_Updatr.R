
#' @name Repeatr_Updatr
#' @title Runs the whole analysis process to update the site and Fugazetteer web app from the input data files.
#' @description This can take a while which is why the parameter "really" is "not_really" by default.
#' @description To run the full update: Repeatr_Updatr(really = "really")
#'
#' @import dplyr
#' @import stringr
#' @import lubridate
#' @import fastDummies
#' @import rlang
#' @import knitr
#'
#' @param really set to "really" to actually run the update; any other value (the default, "not_really") does nothing.
#' @param min_song_count passed through to \code{\link{Repeatr_1}}: minimum number of performances a song needs to compete as an alternative in the choice model. Default 2.
#'
#' @return Invisibly, the list of results from the final `Repeatr_5()` call when `really = "really"`; `NULL` otherwise. The real effect is refreshing all of the package's `data/*.rda` objects in place, ready to be reinstalled.
#' @export
#'
#' @examples
#' Repeatr_Updatr(really = "not_really")
#'
#'
Repeatr_Updatr <- function(really = "not_really", min_song_count = 2) {

  if (really == "really") {

    fls_data <- system.file("extdata", "fls_data.csv", package = "Repeatr")
    releases_songs_durations_wikipedia <- system.file("extdata", "releases_songs_durations_wikipedia.csv", package = "Repeatr")
    releasesdatafile <- system.file("extdata", "releases.csv", package = "Repeatr")

    Repeatr_1_results <- Repeatr_1(mycsvfile = fls_data, mysongdatafile = releases_songs_durations_wikipedia, releasesdatafile = releasesdatafile, min_song_count = min_song_count)

    # Thread each stage's own return value into the next explicitly, rather
    # than relying on bare object names (which previously resolved to
    # whichever value of that name the package's lazy-loaded data had
    # bound *before* this function ran - stale as soon as an earlier stage
    # in this same call actually changes that data, since save()ing a new
    # .rda mid-session doesn't retroactively update an already-established
    # lazy binding).

    Repeatr2 <- Repeatr_2(mydf = Repeatr_1_results[[2]])

    Repeatr3 <- Repeatr_3(mydf = Repeatr2)

    ml_Repeatr4 <- Repeatr_4(mydf = Repeatr3)

    Repeatr_5_results <- Repeatr_5(mymodeldf = ml_Repeatr4)

  }


}
