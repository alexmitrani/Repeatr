#' Fugazi Live Series data on bands that fugazi played with in long format, combined with show data and coordinates
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @source https://arquivomotor.wordpress.com/1994/08/12/bhrif-programacao/
#' @format dataframe with one row for show and each band that Fugazi played with in the Fugazi Live Series shows with data.
#' \describe{
#' \item{fls_link}{link to the corresponding page on the Fugazi Live Series site}
#' \item{year}{year}
#' \item{tour}{tour}
#' \item{date}{date}
#' \item{venue}{Venue}
#' \item{city}{city}
#' \item{country}{country}
#' \item{played_with}{Band name}
#' \item{attendance}{Attendance}
#' \item{sound_quality}{Sound quality rating: Excellent, Very Good, Good, or Poor.}
#' \item{latitude}{latitude}
#' \item{longitude}{longitude}
#'
#' @examples
#'   played_with_data
"played_with_data"
