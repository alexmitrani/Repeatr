#' rankr
#' @title Undertakes paired comparisons for ranking a set of coefficients, considering whether the differences between the coefficients are significant or not.
#' @description The index numbers are based on the model coefficient table that comes straight out of the model, with no sorting.
#' @description The function will return a dataframe with the results for each pair of coeeficients tested.
#'
#' @import readr
#'
#' @param mymodel the choice model to be used
#' @param fromcoef index number of first coefficient to be ranked
#'
#' @return
#' @export
#'
#' @examples
#' mysongidlist <- as.data.frame(summary$songid)
#' myranking <- rankr(mymodel = ml.Repeatr4, mysongidlist = mysongidlist)
#'
rankr <- function(mymodel = NULL, mysongidlist = NULL) {

  nsongs <- nrow(mysongidlist)
  ntests <- nsongs - 1

  for(test in 1:ntests) {

    coefindex1 <- mysongidlist[test,]-1
    coefindex2 <- mysongidlist[test+1,]-1

    if(coefindex1>=1 & coefindex2>=1) {

      mytest <- diffr(mymodel = mymodel, coefindex1 = coefindex1, coefindex2 = coefindex2)

    }

    if(test == 1) {

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

