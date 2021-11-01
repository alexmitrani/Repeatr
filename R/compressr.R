# Version history
# 20210119 v1 01 by Alex Mitrani.  This function was inspired by the "compress" function in Stata and a need to reduce the size of large datafiles by optimizing the storage modes of variables.
# 20210610 v1 02 by Alex Mitrani.  Removed tidyverse dependency.

#' @name compressr
#' @title changes the type of specified variables to integer
#' @description compressr is used to reduce the size of data files with double-precision storage of integer variables, by changing the storage type of these variables to integer.
#' @details compressr is used internally by the fsm package.
#'
#' @import dplyr
#' @import crayon
#' @import rlang
#'
#' @param mydf the dataframe to be modified.
#' @param ... a list of the variables to have their storage modes changed to integer.
#'
#' @return
#' @export
#'
#' @examples
#' mydf <- mtcars
#' mycompressrvars <- scan(text="vs am gear carb", what="")
#' mydf <- compressr(mydf, mycompressrvars)
#' mydf
#'
compressr <- function(mydf,...) {

  my_return_name <- deparse(substitute(mydf))

  myinitialsize <- round(object.size(mydf)/1000000, digits = 3)
  cat(paste0("Size of ", my_return_name, " before converting the storage modes of specified variables to integer: ", myinitialsize, " MB. \n"))


  variables_to_compress <- c(...)
  cat(paste0("The following variables will have their storage modes converted to integer, if they exist in ", my_return_name,  ": ", "\n"))
  print(variables_to_compress)

  for (var in variables_to_compress) {

    if(var %in% colnames(mydf)) {

      myparsedvar <- parse_expr(var)

      mydf <- mydf %>%
        mutate(!!myparsedvar := as.integer(!!myparsedvar))

    }

  }

  myfinalsize <- round(object.size(mydf)/1000000, digits = 3)
  cat(paste0("Size of ", my_return_name, " after converting storage mode of variables to integer: ", myfinalsize, " MB. \n"))
  ramsaved <- round(myinitialsize - myfinalsize, digits = 3)
  cat(paste0("RAM saved: ", ramsaved, " MB. \n"))

  return(mydf)

}

#
