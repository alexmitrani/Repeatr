#' Fugazi Live Series data in long format with related discography data
#'
#' Song data from the Fugazi discography pages on Wikipedia. The variables attributing lead vocals are simplifications in some cases where lead vocals were shared.
#' The variables song_number, first_song and last_song were defined after data cleaning, so intros, outros, sound checks, interludes and one-offs are not included.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @source https://web.archive.org/web/20201112000517/http://en.wikipedia.org/wiki/Fugazi_discography
#' @format dataframe with one row for each song performed in all the Fugazi Live Series shows that have data available.
#' \describe{
#' \item{gid}{gig id.  This is a concatenation of city, country, and date}
#' \item{date}{Show date}
#' \item{year}{Year}
#' \item{month}{Month, as a number}
#' \item{day}{Day, as a number}
#' \item{song_number}{The number of the song in the sequence of songs that were performed as part of that show}
#' \item{songid}{numeric id for each song}
#' \item{song}{The name of the song}
#' \item{number_songs}{The number of songs that were performed as part of that show}
#' \item{first_song}{Identifies the first song of the set}
#' \item{last_song}{Identifies the last song of the set}
#' \item{releaseid}{numeric id in ascending chronological order}
#' \item{release}{name of album or EP}
#' \item{track_number}{The track number for the song on the release}
#' \item{instrumental}{Indicates whether or not the piece is an instrumental}
#' \item{vocals_picciotto}{indicates whether or not Guy Picciotto sang lead vocals on this track}
#' \item{vocals_mackaye}{indicates whether or not Ian Mackaye sang lead vocals on this track}
#' \item{vocals_lally}{indicates whether or not Joe Lally sang lead vocals on this track}
#' \item{duration_seconds}{The duration of the song in seconds}
#' }
#' @examples
#'   Repeatr1
"Repeatr1"
