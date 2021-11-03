#' Intermediate song choice model
#'
#' This model was estimated on only the data for the intermediate songs of each show, excluding the first songs and the last songs.
#'
#'
#' The utility formula was as follows:
#'
#' choice ~ choice ~ choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5 + yearsold_6 + yearsold_7 + yearsold_8 + yearsold_1_vp + yearsold_2_vp + yearsold_3_vp + yearsold_4_vp + yearsold_5_vp + yearsold_6_vp + yearsold_7_vp + yearsold_8_vp + song2 + ... + song92
#'
#'
#' @examples
#'   ml.Repeatr4_is
"ml.Repeatr4_is"
