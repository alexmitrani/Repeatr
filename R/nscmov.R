
#' nscmov = No satellite could map our veins.
#'
#' @description Retired from the rebuild pipeline - venue coordinates are
#' now maintained directly in `inst/extdata/fls_venue_geocoding_v2.csv` (see
#' `vignette("Rebuilding-the-Data")`), with no separate to-do-list workflow.
#' Left here for reference; not called anywhere in \code{\link{Repeatr_1}}/
#' \code{\link{Repeatr_Updatr}}, and its default argument will resolve to no
#' file unless called with an explicit
#' `fls_venue_geocoding_update_filename`.
#'
#' @param fls_venue_geocoding_update_filename filename of file with which to update coordinates data in othervariables.rda
#'
#' @return The updated `othervariables` data frame, with coordinates and `checked` status refreshed from `fls_venue_geocoding_update_filename`. Also saved to `data/othervariables.rda`, and writes `fls_venue_geocoding_update.csv` - a template listing any venues still unresolved (`checked == 0`) - to the working directory.
#' @export
#'
#' @examples
#' \dontrun{
#' # Retired (see @description above) - kept for reference only. Has no
#' # output_dir override, so it always writes to data/ under getwd(); not
#' # safe to run as a documentation example.
#' fls_venue_geocoding_update <- system.file("extdata", "fls_venue_geocoding_v2.csv", package = "Repeatr")
#' othervariables <- nscmov(fls_venue_geocoding_update_filename = fls_venue_geocoding_update)
#' }
#'
nscmov <- function(fls_venue_geocoding_update_filename=NULL) {

  mydir <- getwd()
  myinputdir <- paste0(mydir, "/inst/extdata/")
  mydatadir <- paste0(mydir, "/data")

  if(is.null(fls_venue_geocoding_update_filename)==TRUE) {

    fls_venue_geocoding_update_filename <- paste0(myinputdir, "fls_venue_geocoding.csv")

  }

  # Update coordinates from geocoding file
  fls_venue_geocoding_update <- utils::read.csv(fls_venue_geocoding_update_filename, header=TRUE) %>%
    select(.data$country, .data$city, .data$venue, .data$link_x, .data$link_y, .data$city_disambiguation, .data$guess, .data$unknown) %>%
    filter(is.na(.data$link_x)==FALSE) %>%
    mutate(geocoding_check=1)

  fls_venue_geocoding_update <- fls_venue_geocoding_update %>%
    mutate(city_disambiguation = ifelse(nchar(.data$city_disambiguation)>0,.data$city_disambiguation,NA))

  othervariables <- othervariables %>%
    left_join(fls_venue_geocoding_update)

  othervariables <- othervariables %>%
    mutate(x = ifelse(is.na(.data$link_x)==FALSE, .data$link_x, .data$x),
           y = ifelse(is.na(.data$link_y)==FALSE, .data$link_y, .data$y),
           city = ifelse(is.na(.data$city_disambiguation)==FALSE, .data$city_disambiguation, .data$city),
           checked = ifelse(is.na(.data$geocoding_check)==FALSE & is.na(.data$guess)==TRUE & is.na(.data$unknown)==TRUE, .data$geocoding_check, .data$checked))

  othervariables <- othervariables %>%
    select(-.data$link_x, -.data$link_y, -.data$city_disambiguation, -.data$geocoding_check, -.data$guess, -.data$unknown)


  setwd(mydatadir)

  save(othervariables, file="othervariables.rda")

  setwd(mydir)

  # Create file for geocoding

  gc_mydf <- othervariables

  gc_mydf <- gc_mydf %>%
    filter(.data$checked==0)

  gc_mydf <- gc_mydf %>%
    group_by(.data$country, .data$city, .data$venue) %>%
    summarize(count = n()) %>%
    ungroup()

  gc_mydf <- gc_mydf %>%
    arrange(.data$country, .data$city, .data$venue)

  gc_mydf2 <- gc_mydf %>%
    group_by(.data$country, .data$city) %>%
    summarize(n_venues=n()) %>%
    ungroup()

  gc_mydf2 <- gc_mydf2 %>%
    arrange(desc(.data$n_venues))

  gc_mydf3 <- gc_mydf %>%
    left_join(gc_mydf2)

  gc_mydf3 <- gc_mydf3 %>%
    arrange(desc(.data$n_venues), .data$country, .data$city, .data$venue)

  gc_mydf3 <- gc_mydf3 %>%
    select(.data$country, .data$city, .data$venue) %>%
    mutate(googlemaps_hyperlink="",
           count1="",
           count2="",
           count3="",
           link_x="",
           link_y="")

  write_csv(gc_mydf3, file="fls_venue_geocoding_update.csv")

  return(othervariables)

}



