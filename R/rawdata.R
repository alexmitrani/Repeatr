#' Fugazi Live Series raw data
#'
#' This data was scraped from the Fugazi Live Series website by Carni Klirs for his project "Visualizing the History of Fugazi".
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each show.
#' \describe{
#' \item{year}{year of the show}
#' \item{V1}{show id}
#' \item{V2}{Fugazi Live Series id}
#' \item{V3}{Show date}
#' \item{V4}{Venue}
#' \item{V5}{Door price}
#' \item{V6}{Attendance}
#' \item{V7}{Recorded by}
#' \item{V8}{Mastered by}
#' \item{V9}{Original source}
#' \item{V10-V50}{Tracks}

#' }
#' @examples
#' # What is the total number of people that Fugazi performed for in the shows that are available in the Fugazi Live Series data?
#' test <- rawdata
#' test <- test %>% mutate(attendancedata = nchar(V6))
#' test <- test %>% filter(attendancedata>0)
#' test <- test %>% mutate(attendance = as.numeric(V6))
#' test <- test %>% filter(is.na(attendance)==FALSE)
#' totalpeople <- sum(test$attendance)
#' totalpeople
#'
"rawdata"
