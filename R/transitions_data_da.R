#' Transitions Data
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each combination of show, first song and second song in the Fugazi Live Series data.
#' \describe{
#' \item{gid}{gig id.  This is a concatenation of city, country, and date}
#' \item{url}{url to the corresponding page of the Fugazi Live Series site.}
#' \item{fls_link}{provides a link to the corresponding page of the Fugazi Live Series site}
#' \item{date}{date of the show}
#' \item{transition}{Number of the transition in the show}
#' \item{song1}{Name of the first song}
#' \item{song2}{Name of the second song}
#'
#' }
#' @examples
#'   transitions_data_da
"transitions_data_da"
