#' Fugazi song duration summary data
#'
#' Summary data on the song durations in the Fugazi Live Series.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each song in the Fugazi discography, except those which never appear in the Fugazi Live Series data.
#' \describe{
#' \item{song}{Name of the song}
#' \item{renditions}{The number of times the song was played live according to the available recordings.}
#' \item{minutes_min}{The minimum duration. In many cases this will be as short as it is because the recording was cut off, not because the band played the song really fast.}
#' \item{minutes_median}{The median duration: if all the renditions were lined up in order from shortest to longest this would be the middle one.}
#' \item{minutes_max}{The maximum duration.}
#' \item{minutes_mean}{The average duration.}
#' \item{minutes_sd}{The standard deviation of the duration - this is a measure of spread, it indicates how much variation there is across all of the renditions.}
#' \item{minutes_total}{The total duration of all the times the song was played.}
#' }
#' @examples
#'   duration_summary
"duration_summary"
