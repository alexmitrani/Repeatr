#' Releases Summary
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each release in the Fugazi discography.
#' \describe{
#'
#' \item{release}{The name of the release.}
#' \item{first_debut}{the date of the first debut from this release}
#' \item{last_debut}{the date of the last debut from this release}
#' \item{release_date}{this is an assumption based on the available evidence. Actual release dates will have been different in different places.}
#' \item{songs}{number of songs on the release}
#' \item{count}{total number of performances of the songs on the release}
#' \item{shows}{number of shows at which songs from the release were performed}
#' \item{rate}{the average of the rates for the songs on the release}
#' }
#' @examples
#'   releases_summary
"releases_summary"
