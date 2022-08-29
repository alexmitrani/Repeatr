#' Transitions
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each transition between songs in the Fugazi Live Series data.
#' \describe{
#' \item{from}{Song #1}
#' \item{to}{Song #2}
#' \item{count}{A count of the times this transition appears in the data}
#' \item{count_scaled}{The count scaled by the total number of times this transition was available}
#' }
#' @examples
#'   transitions
"transitions"
