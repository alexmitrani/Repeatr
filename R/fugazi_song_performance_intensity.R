#' Fugazi song performance intensity data
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each song in the Fugazi discography, except those which never appear in the Fugazi Live Series data.
#' \describe{
#' \item{songid}{numeric id for each song}
#' \item{song}{The name of the song}
#' \item{launchdate}{The date on which the song was first performed according to the data}
#' \item{chosen}{The number of times the song was performed according to the data}
#' \item{available_rl}{The number of shows for which the song was available in the band's repertoire}
#' \item{intensity}{The performance intensity is the ratio of chosen/available_rl}
#' }
#' @examples
#'   fugazi_song_performance_intensity
"fugazi_song_performance_intensity"
