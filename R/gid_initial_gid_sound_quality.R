#' 899 stacks of 10-12 shows covering the whole Fugazi repertoire (94 songs), one for each show in the Fugazi Live Series.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each combination of initial show and stacked show.
#' \describe{
#' \item{gid_initial}{show id of the initial show, used to identify each stack of shows}
#' \item{gid}{show id of each show contained within each stack}
#' \item{sound_quality}{Sound quality rating: Excellent, Very Good, Good, or Poor.}
#'
#' }
#'
#' @examples
#'   gid_initial_gid_sound_quality
"gid_initial_gid_sound_quality"
