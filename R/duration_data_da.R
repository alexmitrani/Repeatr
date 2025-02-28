#' Duration Data
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each rendition of each song in the Fugazi Live Series data.
#' \describe{
#'
#'
#' \item{gid}{Unique identifier for the show}
#' \item{date}{The date of the show.}
#' \item{song_number}{this is the number of the song in the set, where 1 is the first song in that show. Larger numbers will indicate that the song was played later in the set,}
#' \item{song}{the name of the song}
#' \item{urls}{A string used to form the URLs of the corresponding page on the Fugazi Live series site.}
#' \item{fls_link}{a link to the corresponding page of the Fugazi Live Series site.}
#' \item{minutes}{duration of the song in minutes}
#'
#' }
#' @examples
#'   duration_data_da
"duration_data_da"
