#' rankr
#' @title Undertakes paired comparisons for ranking a set of coefficients, considering whether the differences between the coefficients are significant or not.
#' @description The index numbers are based on the model coefficient table that comes straight out of the model, with no sorting.
#' @description The function will return a dataframe with the results for each pair of coeeficients tested.
#'
#' @import readr
#'
#' @param mymodel the choice model to be used
#' @param fromcoef index number of first coefficient to be ranked
#' @param tocoef index number of second coefficient to be tested
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
    left_join(songidlookup1)

  myresultsdf <- myresultsdf %>%
    left_join(songidlookup2)

  myresultsdf <- myresultsdf %>%
    relocate(song1, song2)

  myresultsdf <- myresultsdf %>%
    select(song1, song2, mycoef1, mycoef2, mycoefdiff, myz, myp, lower95ci, upper95ci)

  return(myresultsdf)

}

