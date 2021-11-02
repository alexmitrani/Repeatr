#' Fugazi releases data
#'
#' This data was scraped from the Fugazi Live Series website by Carni Klirs for his project "Visualizing the History of Fugazi".
#'
#' @source https://web.archive.org/web/20210211085323/https://rateyourmusic.com/artist/fugazi
#' @format dataframe with one row for each release.
#' \describe{
#' \item{release}{release name}
#' \item{releaseid}{numeric id in ascending chronological order}
#' \item{releasedate}{release date}
#' \item{rym_rating}{RYM rating scaled to the interval [0,1]}
#' }
#' @examples
#'   releasesdatalookup
"releasesdatalookup"
