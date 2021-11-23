#' Estimated coefficients and related statistics from the model ml.Repeatr4
#'
#' Basic choice model
#'
#' This model was estimated with mlogit on all of the data.
#'
#' The utility formula was as follows:
#'
#' choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5 + yearsold_6 + yearsold_7 + yearsold_8 + song2 + ... + song92
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
#'   results.ml.Repeatr4
"results.ml.Repeatr4"
