

#' @name scrape_sound_quality
#' @title Scrape Sound Quality ratings from Fugazi Live Series pages
#' @description A simple function to scrape sound quality ratings from the Fugazi Live Series website using rvest.
#'
#' @param mylimit The number of shows from which to scrape sound quality rating. Set to a low number for testing.
#' @param mycsvfilename filename for the CSV file to which the results will be written.
#' @param sleepseconds seconds to wait before getting info from the next page.
#'
#' @import rvest
#' @return
#' @export
#'
#' @examples
#' mydf <- scrape_sound_quality(mylimit = 3, sleepseconds = 1, mycsvfilename = "gid_fls_id_sound_quality.csv")
#'
scrape_sound_quality <- function(mylimit = 3, sleepseconds = 1, mycsvfilename = "gid_fls_id_sound_quality.csv") {

  gid_url <- fls_tags_show %>%
    select(gid) %>%
    mutate(url = paste0("https://www.dischord.com/fugazi_live_series/", gid))

  httr::set_config(httr::user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36"))

  # initializing the lists that will store the scraped data
  fls_id <- list()
  sound_quality <- list()

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

    sound_quality <- c(
      sound_quality,
      html_show %>%
        html_element("dd strong") %>%
        html_text2()
    )

    # incrementing the iteration counter
    i <- i + 1

    # wait a bit before making the next request
    Sys.sleep(sleepseconds)

  }

  # converting the lists containg the scraped data into a data.frame
  fls_id_sound_quality <- data.frame(
    unlist(fls_id),
    unlist(sound_quality)
  )

  # changing the column names of the data frame before exporting it into CSV
  names(fls_id_sound_quality) <- c("fls_id", "sound_quality")

  gid <- as.data.frame(gid_url$gid)
  gid <- gid[1:limit, ]

  # results including gid
  results <- cbind.data.frame(gid, fls_id_sound_quality)

  results <- results %>%
    mutate(fls_id = str_replace(fls_id, "Fugazi Live Series ", ""))

  # export the data frame containing the scraped data to a CSV file
  filename <- paste0("./", mycsvfilename)
  write.csv(results, file = "./gid_fls_id_sound_quality.csv", fileEncoding = "UTF-8", row.names = FALSE)

  return(results)

}




