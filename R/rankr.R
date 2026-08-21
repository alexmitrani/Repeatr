#' rankr
#' @title Undertakes paired comparisons for ranking a set of coefficients, considering whether the differences between the coefficients are significant or not.
#' @description The index numbers are based on the model coefficient table that comes straight out of the model, with no sorting.
#' @description The function will return a dataframe with the results for each pair of coeeficients tested.
#'
#' @param coeftable coefficients table from mlogit, with one row per coefficient
#' @param vcovmat variance covariance matrix from mlogit, with one row and one column per coefficient
#' @param mysongidlist a dataframe containing the list of song ids to be tested.  It can contain other variables but only songid will be used.
#' @param myaltlookup optional `altlookup` dataframe (the second element of `Repeatr_2()`'s return list) used to translate `mysongidlist`'s `songid` values into `coeftable`'s `alt`-indexed rows, and to attach song names to the results - `songid` and `alt` are different scales (`songid` spans every classified song, `alt` only the `min_song_count`-eligible ones actually fit by the model), so this translation is required, not optional bookkeeping. If omitted the currently lazy-loaded default will be used. Songs in `mysongidlist` that aren't in `altlookup` (i.e. below `min_song_count`) are dropped with a warning, since they have no coefficient to compare.
#'
#' @return A data frame with one row per adjacent pair of songs tested, giving `title1`, `title2`, their coefficients (`mycoef1`, `mycoef2`), the coefficient difference and its z-statistic, p-value and 95% confidence interval (as produced by `diffr()`).
#' @export
#'
#' @examples
#' songstobecompared <- dplyr::slice(summary, seq(from=1, to=92, by=10))
#' mycomparisons <- rankr(coeftable = results_ml_Repeatr4, vcovmat = vcovmat_ml_Repeatr4, mysongidlist = songstobecompared)
#' mycomparisons
#'
rankr <- function(coeftable = NULL, vcovmat = NULL, mysongidlist = NULL, myaltlookup = NULL) {

  # Use a freshly-supplied altlookup if given, otherwise fall back to
  # whatever is currently lazy-loaded from data/ (the package's last build).
  if (is.null(myaltlookup)==FALSE) { altlookup <- myaltlookup } else { altlookup <- altlookup }

  mysongidlist <- mysongidlist %>%
    select(songid)

  nsongs_requested <- nrow(mysongidlist)

  # coeftable's rows are indexed by `alt` (mlogit's alternative-specific
  # index over the min_song_count-eligible songs only), not by the fuller
  # `songid` - translate before using these as coefficient-table indices.
  # inner_join, not left_join: a songid with no alt can't be compared.
  mysongidlist <- mysongidlist %>%
    inner_join(altlookup %>% select(songid, alt), by = "songid")

  if (nrow(mysongidlist) < nsongs_requested) {
    warning("rankr(): dropped ", nsongs_requested - nrow(mysongidlist),
            " songid(s) from mysongidlist with no matching alt in altlookup ",
            "(performed fewer times than min_song_count, so they have no coefficient to compare).")
  }

  nsongs <- nrow(mysongidlist)
  ntests <- nsongs - 1

  for(test in 1:ntests) {

    coefindex1 <- as.numeric(mysongidlist[test,"alt"]-1)
    coefindex2 <- as.numeric(mysongidlist[test+1,"alt"]-1)

    mytest <- diffr(coeftable = coeftable, vcovmat = vcovmat, coefindex1 = coefindex1, coefindex2 = coefindex2)

    if(test == 1) {

      myresultsdf <- mytest

    } else {

      myresultsdf <- rbind.data.frame(myresultsdf, mytest)

    }

  }

  # The number embedded in var1/var2 (e.g. "(Intercept):5") is `alt`, not
  # `songid` - translate back via altlookup before attaching song names.
  myresultsdf <- myresultsdf %>%
    mutate(alt1 = parse_number(var1)) %>%
    mutate(alt2 = parse_number(var2))

  altlookup1 <- altlookup %>%
    select(alt, title) %>%
    rename(alt1 = alt) %>%
    rename(title1 = title)

  altlookup2 <- altlookup %>%
    select(alt, title) %>%
    rename(alt2 = alt) %>%
    rename(title2 = title)

  myresultsdf <- myresultsdf %>%
    left_join(altlookup1)

  myresultsdf <- myresultsdf %>%
    left_join(altlookup2)

  myresultsdf <- myresultsdf %>%
    relocate(title1, title2)

  myresultsdf <- myresultsdf %>%
    select(title1, title2, mycoef1, mycoef2, mycoefdiff, myz, myp, lower95ci, upper95ci)

  return(myresultsdf)

}
