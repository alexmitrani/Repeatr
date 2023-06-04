#' fls_tags_importer
#'
#' @name fls_tags_importer
#' @title imports a .txt file of duration data, converts the duration variable to hh:mm:ss (hms) format, and exports the resulting data to an rda file.
#' @description fls_tags_importer is used to import a .txt file of duration data generated with kid3 audio tagger (https://kid3.kde.org/)
#'
#'
#' @param myfilename the full path and filename of the file to be imported and converted.
#'
#' @return
#' @export
#'
#' @examples
#' fls_tags_importer(myfilename = "C:/Users/alexm/Music/fls_tags.txt")
#'
#'
fls_tags_importer <- function(myfilename = NULL) {

  fls_tags <- read_delim(myfilename, delim = ";", escape_double = FALSE, trim_ws = TRUE)

  fls_tags <- fls_tags %>%
    mutate(seconds = as.numeric(duration)/60)

  fls_tags <- fls_tags %>%
    mutate(minutes = round(seconds/60, digits = 2))

  fls_tags <- fls_tags %>%
    mutate(duration = seconds_to_period(seconds))


  return(fls_tags)

}




