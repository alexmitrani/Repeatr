#' fls_tags_importer
#'
#' @name fls_tags_importer
#' @title imports a CSV file of duration data, converts the duration variable to hh:mm:ss (hms) format, and exports the resulting data to an rda file.
#' @description fls_tags_importer is used to import a CSV file of duration data generated with kid3 audio tagger (https://kid3.kde.org/)
#'
#'
#' @param myfilename the full path and filename of the file to be imported and converted.
#'
#' @return
#' @export
#'
#' @examples
#' fls_tags_importer(myfilename = "C:/Users/alexm/Music/fls_tags.csv")
#'
#'
fls_tags_importer <- function(myfilename = NULL) {

  fls_tags <- read_delim(myfilename, delim = ";", escape_double = FALSE, trim_ws = TRUE)
  fls_tags$duration <- gsub(',','',fls_tags$duration)
  fls_tags <- fls_tags %>% mutate(duration = lubridate::ms(duration),
                                  seconds = period_to_seconds(duration))

  save(fls_tags, file = "fls_tags.rda")

  cat(paste0("\n \n The imported data has been written to fls_tags.rda in the working directory. \n \n"))

  return(fls_tags)

}




