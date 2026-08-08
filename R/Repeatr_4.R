#' @name Repeatr_4
#' @title prepares data for choice modelling with mlogit, and estimates a basic choice model.
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
#' @param mydf optional dataframe to be used.  If omitted, the default dataframe will be used.  Example of use: ml_Repeatr4 <- Repeatr_4()
#' @param output_dir Optional directory to save the rebuilt `data/results_ml_Repeatr4.rda`/`data/vcovmat_ml_Repeatr4.rda` into. If omitted, defaults to `data/` under the current working directory.
#'
#' @return A data frame (`results_ml_Repeatr4`) of the mlogit coefficient table: one row per model covariate, with columns for the estimate, standard error, z-value and p-value. Also saved to `data/results_ml_Repeatr4.rda`, alongside the corresponding `vcovmat_ml_Repeatr4.rda` (needed by \code{\link{diffr}}/\code{\link{rankr}}) - both are always written together by this function so they can never go out of sync with each other.
#' @export
#'
#' @examples
#' results_ml_Repeatr4 <- Repeatr_4()

Repeatr_4 <- function(mydf = NULL, output_dir = NULL) {

  mydir <- getwd()
  on.exit(setwd(mydir), add = TRUE)
  mydatadir <- if (is.null(output_dir)) paste0(mydir, "/data") else output_dir

  # Choice modelling --------------------------------

  if (is.null(mydf)==FALSE) {

    Repeatr3 <- mydf

  } else {

    Repeatr3 <- Repeatr3

  }

  Repeatr4 <- Repeatr3

  Repeatr4$case <- factor(as.numeric(as.factor(Repeatr4$case)))
  Repeatr4$alt <- as.factor(Repeatr4$alt)
  Repeatr4$choice <- as.logical(Repeatr4$choice)

  Repeatr4 <- dfidx(Repeatr4, idx = c("case", "alt"), drop.index = TRUE)

  # Alternative-specific constants (one per song) are what we actually want
  # to estimate here, so the intercept is intentionally kept (no "- 1").
  # This formula previously failed to estimate ("system is computationally
  # singular") under mlogit 1.1.3 combined with dfidx >= 0.1-0 - not because
  # of a real collinearity in the data, but because of a version
  # incompatibility between the two packages for models with this many
  # alternatives. mlogit >= 2.0-0 (see DESCRIPTION) resolves it.
  ml.Repeatr4 <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5
                         + yearsold_6 + yearsold_7 + yearsold_8, data = Repeatr4)

  summary.ml.Repeatr4 <- summary(ml.Repeatr4)

  results_ml_Repeatr4 <- as.data.frame(summary.ml.Repeatr4[["CoefTable"]])

  # vcov(ml.Repeatr4) has the same row/column order as results_ml_Repeatr4
  # above (both come straight from the same fit) - save it alongside, not
  # separately, so the two can never end up describing different fits.
  vcovmat_ml_Repeatr4 <- vcov(ml.Repeatr4)

  setwd(mydatadir)

  save(results_ml_Repeatr4, file = "results_ml_Repeatr4.rda")
  save(vcovmat_ml_Repeatr4, file = "vcovmat_ml_Repeatr4.rda")

  setwd(mydir)

  return(results_ml_Repeatr4)

}


