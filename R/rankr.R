#' rankr
#' @title Undertakes paired comparisons for ranking a set of coefficients, considering whether the differences between the coefficients are significant or not.
#' @description The index numbers are based on the model coefficient table that comes straight out of the model, with no sorting.
#' @description The function will return a dataframe with the results for each pair of coeeficients tested.
#'
#' @import readr
#'
#' @param mysongidlist a dataframe containing the list of song ids to be tested.  It can contain other variables but only songid will be used.
#' @param mymodel the choice model to be used
#'
#' @return
#' @export
#'
#' @examples
#' songstobecompared <- summary %>% slice(seq(from=1, to=92, by=10))
#' mycomparisons <- rankr(mymodel = ml.Repeatr4, mysongidlist = songstobecompared)
#' mycomparisons
#'
rankr <- function(mymodel = NULL, mysongidlist = NULL) {

  mysongidlist <- mysongidlist %>%
    select(songid)

  nsongs <- nrow(mysongidlist)
  ntests <- nsongs - 1

  for(test in 1:ntests) {

    coefindex1 <- as.numeric(mysongidlist[test,1]-1)
    coefindex2 <- as.numeric(mysongidlist[test+1,1]-1)

    mytest <- diffr(mymodel = mymodel, coefindex1 = coefindex1, coefindex2 = coefindex2)

    if(test == 1) {

      myresultsdf <- mytest

    } else {

      myresultsdf <- rbind.data.frame(myresultsdf, mytest)

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

