#' rankr
#'
#' @import readr
#'
#' @param mymodel
#' @param fromcoef
#' @param tocoef
#'
#' @return
#' @export
#'
#' @examples
#' myranking <- rankr(mymodel = ml.Repeatr4, fromcoef = 1, tocoef = 91)
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

  myresultsdf <- myresultsdf %>%
    mutate(songid1 = parse_number(var1)) %>%
    mutate(songid2 = parse_number(var2))

  songidlookup1 <- songidlookup %>%
    rename(songid1 = songid) %>%
    rename(song1 = song)

  songidlookup2 <- songidlookup %>%
    rename(songid2 = songid) %>%
    rename(song2 = song)

  myresultsdf <- myresultsdf %>%
    left_join(songidlookup1) %>%
    left_join(songidlookup2) %>%

  myresultsdf <- myresultsdf %>%
    relocate(song1, song2)

  myresultsdf <- myresultsdf %>%
    select(song1, song2, mycoef1, mycoef2, mycoefdiff, myz, myp, lower95ci, upper95ci)

  return(myresultsdf)

}

