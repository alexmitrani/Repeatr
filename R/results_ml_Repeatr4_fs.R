#' Estimated coefficients and related statistics from the model ml.Repeatr4_fs
#'
#' First song choice model
#'
#' This model was estimated with mlogit on only the data for the first song of each show.
#'
#' Songs that were never ever played as the first song of a Fugazi song were excluded, by necessity.
#'
#' The utility formula was as follows:
#'
#' choice ~ yearsold_1 + yearsold_2 + yearsold_3 + song2 + ... + song92
#'
#' Where yearsold_3 = yearsold_3 + yearsold_4 + yearsold_5 + yearsold_6 + yearsold_7 + yearsold_8
#'
#'
#' @format dataframe with one row for each coefficient in the model.
#' \describe{
#' \item{Estimate}{The coefficient value}
#' \item{Std. Error}{The standard error of the coefficient}
#' \item{z-value}{The z-value of the coefficient}
#' \item{Pr(>|z|)}{The P value of the coefficient}
#' }
#' @examples
#'   results_ml_Repeatr4_fs
"results_ml_Repeatr4_fs"
