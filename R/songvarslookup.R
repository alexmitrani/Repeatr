#' Fugazi songs data
#'
#' Song data from the Fugazi discography pages on Wikipedia. The variables attributing lead vocals are simplifications in some cases where lead vocals were shared.
#'
#' @source https://web.archive.org/web/20201112000517/http://en.wikipedia.org/wiki/Fugazi_discography
#' @format dataframe with one row for each song in the Fugazi discography, except those which never appear in the Fugazi Live Series data.
#' \describe{
#' \item{songid}{numeric id for each song}
#' \item{releaseid}{numeric id in ascending chronological order}
#' \item{track_number}{The track number for the song on the release}
#' \item{instrumental}{Indicates whether or not the piece is an instrumental}
#' \item{vocals_picciotto}{indicates whether or not Guy Picciotto sang lead vocals on this track}
#' \item{vocals_mackaye}{indicates whether or not Ian Mackaye sang lead vocals on this track}
#' \item{vocals_lally}{indicates whether or not Joe Lally sang lead vocals on this track}
#' \item{duration_seconds}{The duration of the song in seconds}
#' }
#' @examples
#'   songvarslookup
"songvarslookup"
