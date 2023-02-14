#' Fugazi releases data
#'
#'
#' @format dataframe with one row for each release.
#' \describe{
#' \item{releaseid}{numeric id in ascending chronological order}
#' \item{release}{release name}
#' \item{variable}{release names for use as variable names}
#' \item{releasedate}{release date}
#' \item{release_date_source}{source of the release date}
#' \item{colour_code}{hex colour code to be used for the release in graphs}
#' \item{rym_rating}{RYM rating scaled to the interval between 0 and 1}
#'
#' }
#' @examples
#'   releasesdatalookup
"releasesdatalookup"
