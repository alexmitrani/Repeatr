#' @name runExample
#' @title runExample
#' @description Runs a Shiny app to show some things that can be done with the Repeatr package.
#' @return
#' @export
#'
#' @examples
#' Repeatr::runExample()
#'
runExample <- function() {

  appDir <- system.file("shiny-examples", "myapp", package = "Repeatr")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `mypackage`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")

}
