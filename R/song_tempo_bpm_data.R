#' Song tempo BPM data
#'
#' @source Tempos of selected songs from https://www.dischord.com/fugazi_live_series measured with 'liveBPM' app for Android and also finger tapping with a timer.
#' @format dataframe with one row for each song in the Fugazi discography, except those which never appear in the Fugazi Live Series data.
#' \describe{
#' \item{song}{The name of the song}
#' \item{tempo_bpm}{The tempo of the song in beats per minute}
#' }
#' @examples
#'   song_tempo_bpm_data
"song_tempo_bpm_data"
