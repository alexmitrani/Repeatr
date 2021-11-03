#' Fugazi Live Series choice data in long format with related discography data and dummy variables for age categories of songs.
#'
#' Song data from the Fugazi discography pages on Wikipedia. The variables attributing lead vocals are simplifications in some cases where lead vocals were shared.
#' The variables song_number, first_song and last_song were defined after data cleaning, so intros, outros, sound checks, interludes and one-offs are not included.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @source https://web.archive.org/web/20201112000517/http://en.wikipedia.org/wiki/Fugazi_discography
#' @format dataframe with one row for each show, each song performed and each song available in all the Fugazi Live Series shows with data.
#' \describe{
#' \item{gid}{gig id. This is a concatenation of city, country, and date}
#' \item{case}{This is a numerical id with unique values for each combination of gid and song_number}
#' \item{song_number}{The number of the song in the sequence of songs that were performed as part of that show}
#' \item{alt}{alt is the songid variable renamed}
#' \item{choice}{1 if the song was performed at that point in the show, 0 otherwise}
#' \item{yearsold}{The difference between the date of the show and the launchdate of the song, measured in years}
#' \item{vocals_picciotto}{indicates whether or not Guy Picciotto sang lead vocals on this track}
#' \item{vocals_mackaye}{indicates whether or not Ian Mackaye sang lead vocals on this track}
#' \item{vocals_lally}{indicates whether or not Joe Lally sang lead vocals on this track}
#' \item{instrumental}{Indicates whether or not the piece is an instrumental}
#' \item{first_song}{Identifies the first song of the set}
#' \item{last_song}{Identifies the last song of the set}
#' \item{duration_seconds}{The duration of the song in seconds}
#' \item{yearsold_0}{0 < age < 1}
#' \item{yearsold_1}{1 ≤ age < 2}
#' \item{yearsold_2}{2 ≤ age < 3}
#' \item{yearsold_3}{3 ≤ age < 4}
#' \item{yearsold_4}{4 ≤ age < 5}
#' \item{yearsold_5}{5 ≤ age < 6}
#' \item{yearsold_6}{6 ≤ age < 7}
#' \item{yearsold_7}{7 ≤ age < 8}
#' \item{yearsold_8}{8 ≤ age}
#' \item{yearsold_1_vp}{1 ≤ age < 2 and vocals Picciotto}
#' \item{yearsold_2_vp}{2 ≤ age < 3 and vocals Picciotto}
#' \item{yearsold_3_vp}{3 ≤ age < 4 and vocals Picciotto}
#' \item{yearsold_4_vp}{4 ≤ age < 5 and vocals Picciotto}
#' \item{yearsold_5_vp}{5 ≤ age < 6 and vocals Picciotto}
#' \item{yearsold_6_vp}{6 ≤ age < 7 and vocals Picciotto}
#' \item{yearsold_7_vp}{7 ≤ age < 8 and vocals Picciotto}
#' \item{yearsold_8_vp}{8 ≤ age and vocals Picciotto}
#' \item{first_song_instrumental}{1 if first song of the show and instrumental, 0 otherwise}
#' \item{vocals_picciotto_sum}{running total of songs with lead vocals by Guy Picciotto in this show}
#' \item{vocals_mackaye_sum}{running total of songs with lead vocals by Ian Mackaye in this show}
#' \item{vocals_lally_sum}{running total of songs with lead vocals by Joe Lally in this show}
#' }
#' @examples
#'   Repeatr3
"Repeatr3"
