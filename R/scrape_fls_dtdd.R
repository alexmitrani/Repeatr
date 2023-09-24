

#' @name scrape_fls_dtdd
#' @title Scrape data from Fugazi Live Series show info tables using dt and dd tags.
#' @description The dt tags hold the captions and the dd tags hold the data. The user specifies what caption corresponds to the data they are interested in and the function will get the data.
#'
#' @param mygiddata Name of data frame containing list of gids to be scraped (optional).  If this is not specified gids from othervariables will be used (1048 of them).
#' @param mylimit The number of shows from which to scrape sound quality rating. Set to a low number for testing.
#' @param mycsvfilename filename for the CSV file to which the results will be written.
#' @param sleepseconds seconds to wait before getting info from the next page.
#' @param mydt_caption caption of data to be extracted.  This could be: "Show Date:", "Venue:", "Door Price:", "Attendance:", "Played with:", "Recorded by", "Mastered by", or "Original Source:". The data will be extracted from the corresponding cell to the right of this caption, on the same row.
#' @param test_page_to_scrape specific URL to use for test
#'
#' @import rvest
#' @return
#' @export
#'
#' @examples
#' scraped_data_played_with <- scrape_fls_dtdd(mygiddata = NULL, mylimit = 5, sleepseconds = 1, mycsvfilename = "gid_fls_id_fls_data.csv", mydt_caption = "Played with:")
#' scraped_data_original_source <- scrape_fls_dtdd(mygiddata = NULL, mylimit = 5, sleepseconds = 1, mycsvfilename = "gid_fls_id_fls_data.csv", mydt_caption = "Original Source:")
#'
scrape_fls_dtdd <- function(mygiddata = NULL, mylimit = 3, sleepseconds = 1, mycsvfilename = "gid_fls_id_sound_quality.csv", mydt_caption = "Played with:", test_page_to_scrape = NULL) {


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

  if(is.null(test_page_to_scrape)==TRUE) {

    pages_to_scrape <- as.data.frame(gid_url$url)

  } else {

    pages_to_scrape <- as.data.frame(test_page_to_scrape)

  }

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

    fls_probe1 <- c(html_show %>%
                      html_element("dt:nth-child(1)") %>%
                      html_text2()
    )

    fls_probe3 <- c(html_show %>%
                      html_element("dt:nth-child(3)") %>%
                      html_text2()
    )

    fls_probe5 <- c(html_show %>%
        html_element("dt:nth-child(5)") %>%
        html_text2()
    )

    fls_probe7 <- c(html_show %>%
        html_element("dt:nth-child(7)") %>%
        html_text2()
    )

    fls_probe9 <- c(html_show %>%
        html_element("dt:nth-child(9)") %>%
        html_text2()
    )

    fls_probe11 <- c(html_show %>%
                      html_element("dt:nth-child(11)") %>%
                      html_text2()
    )

    if(is.na(fls_probe1)==FALSE & fls_probe1==mydt_caption) {

      fls_data <- c(
        fls_data,
        html_show %>%
          html_element("dd:nth-child(2)") %>%
          html_text2()
      )

    } else if(is.na(fls_probe3)==FALSE & fls_probe3==mydt_caption) {

      fls_data <- c(
        fls_data,
        html_show %>%
          html_element("dd:nth-child(4)") %>%
          html_text2()
      )

    } else if(is.na(fls_probe5)==FALSE & fls_probe5==mydt_caption) {

      fls_data <- c(
        fls_data,
        html_show %>%
          html_element("dd:nth-child(6)") %>%
          html_text2()
      )

    } else if (is.na(fls_probe7)==FALSE & fls_probe7==mydt_caption) {

      fls_data <- c(
        fls_data,
        html_show %>%
          html_element("dd:nth-child(8)") %>%
          html_text2()
      )

    } else if (is.na(fls_probe9)==FALSE & fls_probe9==mydt_caption){

      fls_data <- c(
        fls_data,
        html_show %>%
          html_element("dd:nth-child(10)") %>%
          html_text2()
      )

    } else if (is.na(fls_probe11)==FALSE & fls_probe11==mydt_caption){

      fls_data <- c(
        fls_data,
        html_show %>%
          html_element("dd:nth-child(12)") %>%
          html_text2()
      )

    } else {

      fls_data <- c(
        fls_data, ""
      )

    }

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

  if(is.null(test_page_to_scrape)==TRUE){

    gid <- as.data.frame(gid_url$gid)
    gid <- gid[1:limit, ]

  } else {

    gid <- as.data.frame(test_page_to_scrape)

  }

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




