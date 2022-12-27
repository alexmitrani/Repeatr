
#' nscmov = No satellite could map our veins.
#'
#' Process for updating coordinates on Shiny app:
#' 1) pull updated data from github
#' 2) run nscmov()
#' 3) push updates to github
#' 4) reinstall Repeatr package from github
#' 5) run shiny app from app.R
#' 6) reinstall the Shiny app on shinyapps.io
#'
#' @param fls_venue_geocoding_update_filename filename of file with which to update coordinates data in othervariables.rda
#'
#' @return
#' @export
#'
#' @examples
#' fls_venue_geocoding_update <- system.file("extdata", "fls_venue_geocoding.csv", package = "Repeatr")
#' othervariables <- nscmov(fls_venue_geocoding_update_filename = fls_venue_geocoding_update)
#'
nscmov <- function(fls_venue_geocoding_update_filename=NULL) {

  mydir <- getwd()
  myinputdir <- paste0(mydir, "/inst/extdata/")
  mydatadir <- paste0(mydir, "/data")

  if(is.null(fls_venue_geocoding_update_filename)==TRUE) {

    fls_venue_geocoding_update_filename <- paste0(myinputdir, "fls_venue_geocoding.csv")

  }

  # Update coordinates from geocoding file
  fls_venue_geocoding_update <- read.csv(fls_venue_geocoding_update_filename, header=TRUE) %>%
    select(country, city, venue, link_x, link_y, city_disambiguation, guess, unknown) %>%
    filter(is.na(link_x)==FALSE) %>%
    mutate(geocoding_check=1)

  fls_venue_geocoding_update <- fls_venue_geocoding_update %>%
    mutate(city_disambiguation = ifelse(nchar(city_disambiguation)>0,city_disambiguation,NA))

  othervariables <- othervariables %>%
    left_join(fls_venue_geocoding_update)

  othervariables <- othervariables %>%
    mutate(x = ifelse(is.na(link_x)==FALSE, link_x, x),
           y = ifelse(is.na(link_y)==FALSE, link_y, y),
           city = ifelse(is.na(city_disambiguation)==FALSE, city_disambiguation, city),
           checked = ifelse(is.na(geocoding_check)==FALSE & is.na(guess)==TRUE & is.na(unknown)==TRUE, geocoding_check, checked))

  othervariables <- othervariables %>%
    select(-link_x, -link_y, -city_disambiguation, -geocoding_check, -guess, -unknown)


  setwd(mydatadir)

  save(othervariables, file="othervariables.rda")

  setwd(mydir)

  # Create file for geocoding

  gc_mydf <- othervariables

  gc_mydf <- gc_mydf %>%
    filter(checked==0)

  gc_mydf <- gc_mydf %>%
    group_by(country, city, venue) %>%
    summarize(count = n()) %>%
    ungroup()

  gc_mydf <- gc_mydf %>%
    arrange(country, city, venue)

  gc_mydf2 <- gc_mydf %>%
    group_by(country, city) %>%
    summarize(n_venues=n()) %>%
    ungroup()

  gc_mydf2 <- gc_mydf2 %>%
    arrange(desc(n_venues))

  gc_mydf3 <- gc_mydf %>%
    left_join(gc_mydf2)

  gc_mydf3 <- gc_mydf3 %>%
    arrange(desc(n_venues), country, city, venue)

  gc_mydf3 <- gc_mydf3 %>%
    select(country, city, venue) %>%
    mutate(googlemaps_hyperlink="",
           count1="",
           count2="",
           count3="",
           link_x="",
           link_y="")

  write_csv(gc_mydf3, file="fls_venue_geocoding_update.csv")

  return(othervariables)

}



