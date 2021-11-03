#' First song choice model
#'
#' This model was estimated on only the data for the first song of each show.
#'
#' Songs that were never ever played as the first song of a Fugazi song were excluded, by necessity.
#'
#' The utility formula was as follows:
#'
#' choice ~ yearsold_1 + yearsold_2 + yearsold_3 + song2 + ... + song92
#'
#' Where yearsold_3 = yearsold_3 + yearsold_4 + yearsold_5 + yearsold_6 + yearsold_7 + yearsold_8
#'
#' @examples
#'   ml.Repeatr4_fs
"ml.Repeatr4_fs"
