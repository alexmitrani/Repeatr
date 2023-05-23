#' Tags data
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each track in the Fugazi Live Series data, including data from the audio file tags.
#' \describe{
#' \item{track}{track number}
#' \item{album}{album name, which includes the date, venue, city, state, and country}
#' \item{song}{track name}
#' \item{duration}{duration in period format (lubridate)}
#' \item{seconds}{duration in seconds}
#' \item{date}{duration in seconds}
#' \item{venue}{venue}
#' \item{city}{city}
#' \item{state}{state for USA shows}
#' \item{country}{country}
#' \item{gid}{show id}
#'
#' }
#' @examples
#'   fls_tags
"fls_tags"
