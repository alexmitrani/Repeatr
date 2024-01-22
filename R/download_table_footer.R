

#' download_table_footer
#' @title Adds an initial text column and a footer with text to tables for download.
#' @description All columns in the dataframe will be converted to character formaat to avoid blanks appearing as "NA".
#' @description When the downloaded file is opened in Excel or a similar program, numeric columns should still be recognised as numeric.
#'
#' @param mydf datafrae to work with
#' @param nblankrows number of blank rows to add before text at bottom of table
#' @param textcolumnname name of text column that will be added to the front of the dataframe
#' @param rowtext character vector of text to be added at bottom of table
#'
#' @return
#' @export
#'
#' @examples
#' sourcestext = c("https://alexmitrani.shinyapps.io/Fugazetteer/","https://dischord.com/fugazi_live_series")
#' mydf <- download_table_footer(mydf = Repeatr::summary, nblankrows = 1, textcolumnname = "sources", rowtext = sourcestext)
#'
download_table_footer <- function(mydf, nblankrows = 1, textcolumnname = "Sources", rowtext = NULL){

  mydf <- mydf %>%
    mutate_all(as.character)

  mydf <- cbind(textcolumn = "", mydf)

  colnames(mydf)[1] = textcolumnname

  nrows <- nrow(mydf)

  if(is.null(rowtext) == FALSE) {

    ntextrows <- length(rowtext)

  } else {

    ntextrows <- 0

  }

  ntotalnewrows <- nblankrows + ntextrows

  for(myrowindex in 1:ntotalnewrows) {

    mydf[nrows+myrowindex,] <- ""

    mytextindex <- myrowindex - nblankrows

    if(mytextindex>=1) {

      mydf[nrows+myrowindex, 1] <- rowtext[mytextindex]

    }

  }

  return(mydf)

}
