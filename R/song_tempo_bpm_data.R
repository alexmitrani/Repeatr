#' Song tempo BPM data
#'
#' @source Spotify for most songs, https://www.dischord.com/fugazi_live_series, and getsongbpm.com for Preprovisional and World Beat.
#' @format dataframe with one row for each song in the Fugazi discography, except those which never appear in the Fugazi Live Series data.
#' \describe{
#' \item{song}{The name of the song}
#' \item{tempo_bpm}{The tempo of the song in beats per minute}
#' }
#' @examples
#'   song_tempo_bpm_data
"song_tempo_bpm_data"
