#' @name diffr
#' @title Tests whether differences between pairs of model parameters are significant or not.
#' @description The function finds the standard error of the difference between the two coefficients in terms of their variances and their covariance: myse <- (sqrt(myvar1 + myvar2 - 2*mycov))
#' @description It then proceeds to calculate a z-statistic: myz <- (mycoefdiff)/myse
#' @description A z-statistic of 1.96 or greater would indicate that the difference between the coefficients is significant at the 95% level of confidence.
#' @description The index numbers are based on the model coefficient table that comes straight out of the model, with no sorting.
#' @description The function will return a one-row dataframe with the following columns: var1, var2, coefindex1, coefindex2, mycoef1, mycoef2, mycoefdiff, myz, myp, lower95ci, upper95ci
#' @description A coefficient index of 0 will be interpreted as referring to the omitted constant.
#'
#' @import mlogit
#' @import crayon
#'
#' @param mymodel model to be used.
#' @param coefindex1 index number of first coefficient to be tested
#' @param coefindex2 index number of second coefficient to be tested
#'
#' @return
#' @export
#'
#' @examples
#' mytest <- diffr(mymodel = ml.Repeatr4, coefindex1 = 1, coefindex2 = 2)
#'
diffr <- function(mymodel = NULL, coefindex1 = NULL, coefindex2 = NULL) {

  # Source: https://stats.stackexchange.com/questions/59085/how-to-test-for-simultaneous-equality-of-choosen-coefficients-in-logit-or-probit

  mycoefs <- as.data.frame(mymodel[["coefficients"]])

  mycoefs$varname <- row.names(mycoefs)

  myvcovmat <- as.data.frame(vcov(mymodel))

  if (coefindex1==0) {

    mycoef1 <- 0
    var1 <- "(Intercept):1"

  } else {

    mycoef1 <- as.numeric(mycoefs[coefindex1,1])
    var1 <- mycoefs[coefindex1,2]

  }

  cat(yellow(paste0("\n \n",  "First coefficient: ", mycoef1, " \n \n")))

  if (coefindex2==0) {

    mycoef2 <- 0
    var2 <- "(Intercept):1"

  } else {

    mycoef2 <- as.numeric(mycoefs[coefindex2,1])
    var2 <- mycoefs[coefindex2,2]

  }

  cat(yellow(paste0("Second coefficient: ", mycoef2, " \n \n")))

  mycoefdiff <- as.numeric(mycoef1 - mycoef2)
  cat(yellow(paste0("Difference to be tested: ", mycoefdiff, " \n \n")))

  if (coefindex1==0) {

    myvar1 <- 0

  } else {

    myvar1 <- as.numeric(myvcovmat[coefindex1,coefindex1])

  }

  cat(yellow(paste0("Variance of the first coefficient: ", myvar1, " \n \n")))

  if (coefindex2==0) {

    myvar2 <- 0

  } else {

    myvar2 <- as.numeric(myvcovmat[coefindex2,coefindex2])

  }

  cat(yellow(paste0("Variance of the second coefficient: ", myvar2, " \n \n")))

  if (coefindex1==0 | coefindex2==0) {

    mycov <- 0

  } else {

    mycov <- as.numeric(myvcovmat[coefindex1,coefindex2])

  }

  cat(yellow(paste0("Covariance of the two coefficients: ", mycov, " \n \n")))

  myse <- as.numeric(sqrt(myvar1 + myvar2 - 2*mycov))

  myz <- (mycoefdiff)/myse

  cat(yellow(paste0("Z-statistic: ", myz, " \n \n")))

  myp <- 2*pnorm(myz)

  cat(yellow(paste0("P-statistic: ", myp, " \n \n")))

  lower95ci <- mycoefdiff - 1.96*myse

  cat(yellow(paste0("Lower boundary of 95% confidence interval of the difference between the two coefficients: ", lower95ci, " \n \n")))

  upper95ci <- mycoefdiff + 1.96*myse

  cat(yellow(paste0("Upper boundary of 95% confidence interval of the difference between the two coefficients: ", upper95ci, " \n \n")))

  myreturndf <- data.frame(var1, var2, coefindex1, coefindex2, mycoef1, mycoef2, mycoefdiff, myz, myp, lower95ci, upper95ci)

  return(myreturndf)

}
