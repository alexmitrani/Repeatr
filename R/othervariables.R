#' Fugazi Live Series data - other variables
#'
#' some of this data was scraped from the Fugazi Live Series website by Carni Klirs for his project "Visualizing the History of Fugazi".
#' The original data on coordinates, cities and tours data came from The D-I-Y Data of Fugazi by Matthew Conlen.
#' Rows with checked==1 were updated by Alex Mitrani, in particular making sure that the coordinates indicated the actual locations of the venues for city-level mapping.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each show.
#' \describe{
#' \item{gid}{show id}
#' \item{flsid}{Fugazi Live Series id}
#' \item{venue}{Venue}
#' \item{doorprice}{Door price}
#' \item{attendance}{Attendance}
#' \item{recorded_by}{Recorded by}
#' \item{mastered_by}{Mastered by}
#' \item{original_source}{Original source}
#' \item{x}{longitude}
#' \item{y}{latitude}
#' \item{city}{city}
#' \item{country}{country}
#' \item{tour}{tour}
#' \item{year}{year}
#' \item{checked}{checked==1 indicates that the data was checked and updated by Alex Mitrani, in particular making sure that the coordinates indicate as closely as possible the actual locations of the venues.}

#' }
#' @examples
#' othervariables
#'
"othervariables"
