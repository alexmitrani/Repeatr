#' rankr
#'
#' @param mymodel
#' @param fromcoef
#' @param tocoef
#'
#' @return
#' @export
#'
#' @examples
#' test <- rankr(mymodel = ml.Repeatr4, fromcoef = 1, tocoef = 91)
#'
rankr <- function(mymodel = NULL, fromcoef = NULL, tocoef = NULL) {

  myfirstcoef <- fromcoef
  mylastcoef <- tocoef - 1

  for(mycoef in myfirstcoef:mylastcoef) {

    mynextcoef <- mycoef + 1

    mytest <- diffr(mymodel = mymodel, coefindex1 = mycoef, coefindex2 = mynextcoef)

    if(mycoef == myfirstcoef) {

      myresultsdf <- mytest

    } else {

      myresultsdf <- rbind(myresultsdf, mytest)

    }

  }

  return(myresultsdf)

}

