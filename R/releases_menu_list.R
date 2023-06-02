#' Releases Summary
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each release in the Fugazi discography, except those which never appear in the Fugazi Live Series data.
#' \describe{
#'
#' \item{releaseid}{A unique identifier for the release based on the alphabetical order of the titles.}
#' \item{release}{The name of the release.}
#' \item{variable}{The name of the release in snake case.}
#' \item{first_debut}{the date of the first debut from this release}
#' \item{release_date}{this is an assumption based on the available evidence. Actual release dates will have been different in different places.}
#' \item{release_date_source}{The source of the release date assumption}
#' \item{colour code}{Hex code of the colour used for this release in graphs.}
#' \item{rym}{The rate your music rating of the release - November 2021.}
#' }
#' @examples
#'   releases_menu_list
"releases_menu_list"
