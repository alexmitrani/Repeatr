# Version history
# 20200916 v1 01 by Alex Mitrani, first version in R.
# 20210104 v1 02 by Alex Mitrani, Added Roxygen skeleton and started adding documentation content.

# syntax, [dateonly houronly minuteonly username]
#' @name datestampr
#' @title production of date stamps
#' @description datestampr is used to create the datestamps used to produce unique filenames for the output files.
#' @details datestampr is used internally by the fsm package.
#'
#' @import tidyverse
#' @import crayon
#' @import rlang
#'
#' @param dateonly requests a simplified timestamp with only the date (no time).
#' @param houronly requests a simplified timestamp with only the date and the hour (no minutes or seconds).
#' @param minuteonly requests a simplified timestamp with only the date, the hour and the minutes (no seconds).
#' @param myusername adds the active username to the timestamp.
#'
#' @return
#' @export
#'
#' @examples
#' datestring <- datestampr(myusername=TRUE)
#' cat(yellow(paste0("\n \n", "Hello world, have a datestamp: ", datestring, "\n \n")))
#'
datestampr <- function(dateonly = FALSE, houronly = FALSE, minuteonly = FALSE, myusername = FALSE) {

#General info
now <- Sys.time()
year <- format(now, "%Y")
month <- format(now, "%m")
day <- format(now, "%d")
hour <- format(now, "%H")
minute <- format(now, "%M")
second <- format(now, "%S")
username <- Sys.getenv("USERNAME")

# Work --------------------------------------------------------------------


  if (nchar(day)==2) {

    day <- day

  } else {

    day <- paste0("0",day)

  }

  if (nchar(month)==2) {

    month <- month

  } else {

    month <- paste0("0",month)

  }

  if (myusername == TRUE) {

    if (dateonly == TRUE) {

      datestampr <- paste0(year,month,day,username)

    } else if (houronly == TRUE) {

      datestampr <- paste0(year,month,day,hour,username)

    } else if (minuteonly == TRUE) {

      datestampr <- paste0(year,month,day,hour,minute,username)

    } else {

      datestampr <- paste0(year,month,day,hour,minute,second,username)

    }

  } else {

    if (dateonly == TRUE) {

      datestampr <- paste0(year,month,day)

    } else if (houronly == TRUE) {

      datestampr <- paste0(year,month,day,hour)

    } else if (minuteonly == TRUE) {

      datestampr <- paste0(year,month,day,hour,minute)

    } else {

      datestampr <- paste0(year,month,day,hour,minute,second)

    }

  }

return(datestampr)

}

#
