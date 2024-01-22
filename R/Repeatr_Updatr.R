
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
#' @param really
#'
#' @return
#' @export
#'
#' @examples
#' Repeatr_Updatr(really = "not_really")
#'
#'
Repeatr_Updatr <- function(really = "not_really") {


  if (really == "really") {

    fugotcha <- system.file("extdata", "fugotcha.csv", package = "Repeatr")
    releases_songs_durations_wikipedia <- system.file("extdata", "releases_songs_durations_wikipedia.csv", package = "Repeatr")
    releasesdatafile <- system.file("extdata", "releases.csv", package = "Repeatr")
    Repeatr_1_results <- Repeatr_1(mycsvfile = fugotcha, mysongdatafile = releases_songs_durations_wikipedia, releasesdatafile = releasesdatafile)

    Repeatr2 <- Repeatr_2(mydf = Repeatr1)

    Repeatr3 <- Repeatr_3(mydf = Repeatr2)

    ml_Repeatr4 <- Repeatr_4()

    Repeatr_5_results <- Repeatr_5(mymodeldf = results_ml_Repeatr4)

  }


}
