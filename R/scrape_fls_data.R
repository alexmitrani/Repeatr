

#' @name scrape_fls_data
#' @title Scrape data from Fugazi Live Series pages
#' @description A simple function to scrape data from the Fugazi Live Series website using rvest.
#'
#' @param mygiddata Name of data frame containing list of gids to be scraped (optional).  If this is not specified gids from othervariables will be used (1048 of them).
#' @param mylimit The number of shows from which to scrape sound quality rating. Set to a low number for testing.
#' @param mycsvfilename filename for the CSV file to which the results will be written.
#' @param sleepseconds seconds to wait before getting info from the next page.
#' @param my_data_html_element html element that contains the data to be scraped
#'
#' @import rvest
#' @return
#' @export
#'
#' @examples
#' scraped_data_1 <- scrape_fls_data(mygiddata = NULL, mylimit = 3, sleepseconds = 1, mycsvfilename = "gid_fls_id_sound_quality.csv", my_data_html_element = "dd strong")
#' scraped_data_2 <- scrape_fls_data(mygiddata = NULL, mylimit = 3, sleepseconds = 1, mycsvfilename = "gid_fls_id_played_with.csv", my_data_html_element = "dd:nth-child(10)")
#' mydf <- system.file("extdata", "gid_played_with_8.csv", package = "Repeatr")
#' scraped_data_3 <- scrape_fls_data(mygiddata = mydf, mylimit = 3, sleepseconds = 1, mycsvfilename = "gid_fls_id_played_with_8.csv", my_data_html_element = "dd:nth-child(8)")
#' mydf <- system.file("extdata", "gid_played_with_6.csv", package = "Repeatr")
#' scraped_data_4 <- scrape_fls_data(mygiddata = mydf, mylimit = 3, sleepseconds = 1, mycsvfilename = "gid_fls_id_played_with_6.csv", my_data_html_element = "dd:nth-child(6)")
#'
scrape_fls_data <- function(mygiddata = NULL, mylimit = 3, sleepseconds = 1, mycsvfilename = "gid_fls_id_sound_quality.csv", my_data_html_element = "dd strong") {

  if (is.null(mygiddata) == TRUE) {

    gid_url <- othervariables %>%
      select(gid) %>%
      mutate(url = paste0("https://www.dischord.com/fugazi_live_series/", gid))

  } else {

    gid_url <- mygiddata %>%
      select(gid) %>%
      mutate(url = paste0("https://www.dischord.com/fugazi_live_series/", gid))

  }

  httr::set_config(httr::user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36"))

  # initializing the lists that will store the scraped data
  fls_id <- list()
  fls_data <- list()

  # initializing the list of pages to scrape with the first pagination links
  pages_to_scrape <- as.data.frame(gid_url$url)

  # initializing the list of pages discovered
  pages_discovered <- pages_to_scrape

  # current iteration
  i <- 1
  # max pages to scrape
  limit <- mylimit

  # get list consistent with limit
  pages_to_scrape <- as.list(pages_to_scrape[1:limit, ])

  # until there is still a page to scrape
  while (length(pages_to_scrape) != 0 && i <= limit) {

    # getting the current page to scrape
    page_to_scrape <- pages_to_scrape[[1]]

    messagetoprint <- paste0("Scraping ", page_to_scrape)
    print(messagetoprint)

    # removing the page to scrape from the list
    pages_to_scrape <- pages_to_scrape[-1]

    # retrieving the current page to scrape
    document <- read_html(page_to_scrape,
                          user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36")

    # selecting the list of product HTML elements
    html_show <- document %>% html_elements("#releaseDetail")

    # appending the new results to the lists of scraped data

    fls_id <- c(
      fls_id,
      html_show %>%
        html_element("h1 span") %>%
        html_text2()
    )

    fls_data <- c(
      fls_data,
      html_show %>%
        html_element(my_data_html_element) %>%
        html_text2()
    )

    # incrementing the iteration counter
    i <- i + 1

    # wait a bit before making the next request
    Sys.sleep(sleepseconds)

  }

  # converting the lists containg the scraped data into a data.frame
  fls_id_data <- data.frame(
    unlist(fls_id),
    unlist(fls_data)
  )

  # changing the column names of the data frame before exporting it into CSV
  names(fls_id_data) <- c("fls_id", "fls_data")

  gid <- as.data.frame(gid_url$gid)
  gid <- gid[1:limit, ]

  # results including gid
  results <- cbind.data.frame(gid, fls_id_data)

  results <- results %>%
    mutate(fls_id = str_replace(fls_id, "Fugazi Live Series ", ""),
           fls_data = str_trim(fls_data))

  # export the data frame containing the scraped data to a CSV file
  filename <- paste0("./", mycsvfilename)
  write.csv(results, file = filename, fileEncoding = "UTF-8", row.names = FALSE)

  return(results)

}




