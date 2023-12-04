
#' sets
#' @title compares the setlists of two or more shows.
#' @description sets returns a list with two dataframes
#' @description the first is a table with the list of shows in the rows and the shows in the columns, including a total column showing how many shows each song was played in. .
#' @description the second is a summary table of the number of shows in which songs appear, with one row per number of shows, the number of songs in each category, and the proportion of the total number of songs.
#'
#' @param mydf the dataframe to use. must contain the columns "gid" and "song".
#' @param shows a list of show ids
#'
#' @return
#' @export
#'
#' @examples
#' sets <- sets(mydf = duration_data_da, shows = c("aalst-belgium-92390", "aberdeen-scotland-50499", "leeds-england-103102"))
#' sets[[1]]
#' sets[[2]]


sets <- function(mydf = NULL, shows = NULL) {


  if(is.null(shows)==FALSE) {

    mydf <- mydf %>%
      select(gid, song)

    sets <- mydf %>%
      filter(gid %in% shows) %>%
      mutate(played = 1)

    sets <- sets %>%
      pivot_wider(names_from = gid, values_from = played) %>%
      arrange(song)

    sets <- sets %>% replace(is.na(.), 0)

    songs <- sets  %>%
      mutate(shows = rowSums(across(where(is.numeric)), na.rm=TRUE))  %>%
      arrange(desc(shows), song)

    total_songs <- nrow(songs)

    shows <- songs %>%
      group_by(shows) %>%
      summarize(songs = n()) %>%
      ungroup() %>%
      arrange(shows) %>%
      mutate(proportion = songs / total_songs)

  } else {

    shows <- NULL
    songs <- NULL

  }

  sets <- list(songs, shows)

  return(sets)

}

