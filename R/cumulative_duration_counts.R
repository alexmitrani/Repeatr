#' Cumulative Duration Counts
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each combination of song and duration in the Fugazi Live Series data.
#' \describe{
#' \item{minutes}{Duration of the show in minutes}
#' \item{song}{Name of the song}
#' \item{release}{Name of the corresponding discographical release}
#' \item{count}{The cumulative count of the number of times the song had been performed up to and including this duration.}
#'
#'
#' }
#' @examples
#'   cumulative_duration_counts
"cumulative_duration_counts"
