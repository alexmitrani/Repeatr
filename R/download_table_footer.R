

#' download_table_footer
#' @title Adds an initial text column and a footer with text to tables for download.
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
#' mydf <- download_table_footer(mydf = Repeatr::summary, nblankrows = 1, textcolumnname = "sources", rowtext = c("https://alexmitrani.shinyapps.io/Repeatr-app/","https://dischord.com/fugazi_live_series"))
#'
download_table_footer <- function(mydf, nblankrows = 1, textcolumnname = "Sources", rowtext = NULL){

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

    mydf[nrows+myrowindex,] <- NA

    mytextindex <- myrowindex - nblankrows

    if(mytextindex>=1) {

      mydf[nrows+myrowindex, 1] <- rowtext[mytextindex]

    }

  }

  return(mydf)

}
