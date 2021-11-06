#' Fugazi releases data
#'
#' Data on Fugazi releases from rateyourmusic.com.
#' First Demo was excluded because only 3 of the songs on this release appear in the Fugazi Live Series data, so it was not possible to compare the RYM ratings with ratings based on the choice modelling results in this case.
#'
#' @source https://web.archive.org/web/20210211085323/https://rateyourmusic.com/artist/fugazi
#' @format dataframe with one row for each release.
#' \describe{
#' \item{release}{release name}
#' \item{releaseid}{numeric id in ascending chronological order}
#' \item{releasedate}{release date}
#' \item{rym_rating}{RYM rating scaled to the interval between 0 and 1}
#' }
#' @examples
#'   releasesdatalookup
"releasesdatalookup"
