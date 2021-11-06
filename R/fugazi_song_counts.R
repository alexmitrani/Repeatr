#' Fugazi song performance counts
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each song in the Fugazi discography, except those which never appear in the Fugazi Live Series data.
#' \describe{
#' \item{songid}{numeric id for each song}
#' \item{song}{The name of the song}
#' \item{launchdate}{The date on which the song was first performed according to the data}
#' \item{count}{The number of times the song was performed according to the data}
#' }
#' @examples
#'   fugazi_song_counts
"fugazi_song_counts"
