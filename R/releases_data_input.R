#' Summary
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each song in the Fugazi discography, except those which never appear in the Fugazi Live Series data.
#' \describe{
#' \item{releaseid}{numeric id in ascending chronological order}
#' \item{release}{release name}
#' \item{track_number}{The track number for the song on the release}
#' \item{song}{The name of the song}
#' \item{last_show}{The number of the last show in the series}
#' \item{colour_code}{The hex colour code used for the corresponding release}
#' \item{count}{The number of times the song was performed according to the data}
#' \item{date}{The debut date of the song}
#' \item{show_num}{The show number of the debut of the song}
#' \item{shows}{The number of shows in which the song could have been performed}
#' \item{rate}{The rate at which the song was played - this is count / shows}
#' }
#' @examples
#'   releases_data_input
"releases_data_input"
