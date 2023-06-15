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
#' @import mlogit
#'
#'
#' @param mydf optional dataframe to be used.  If omitted, the default dataframe will be used.
#'
#' @return
#' @export
#'
#' @examples
#' ml_Repeatr4 <- Repeatr_4()

Repeatr_4 <- function(mydf = NULL) {

  # Choice modelling --------------------------------

  if (is.null(mydf)==FALSE) {

    Repeatr3 <- mydf

  }

  Repeatr4 <- Repeatr3

  Repeatr4$case <- factor(as.numeric(as.factor(Repeatr4$case)))
  Repeatr4$alt <- as.factor(Repeatr4$alt)
  Repeatr4$choice <- as.logical(Repeatr4$choice)

  Repeatr4 <- dfidx(Repeatr4, idx = c("case", "alt"), drop.index = FALSE)

  ml.Repeatr4 <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5
                         + yearsold_6 + yearsold_7 + yearsold_8 , data = Repeatr4)

  summary.ml.Repeatr4 <- summary(ml.Repeatr4)

  results_ml_Repeatr4 <- as.data.frame(summary.ml.Repeatr4[["CoefTable"]])

  save(results_ml_Repeatr4, file = "results_ml_Repeatr4.rda")

  return(results_ml_Repeatr4)

}


