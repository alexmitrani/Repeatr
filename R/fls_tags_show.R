#' Tags data
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each track in the Fugazi Live Series data, including data from the audio file tags.
#' \describe{
#' \item{date}{duration in seconds}
#' \item{venue}{venue}
#' \item{city}{city}
#' \item{state}{state for USA shows}
#' \item{country}{country}
#' \item{album}{album name, which includes the date, venue, city, state, and country}
#' \item{gid}{show id}
#' \item{duration}{duration in period format (lubridate)}
#' \item{seconds}{duration in seconds}
#'
#' }
#' @examples
#'   fls_tags_show
"fls_tags_show"
