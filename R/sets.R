
#' sets
#' @title compares the setlists of two or more shows.
#' @description sets returns a table with the list of shows in the rows and the shows in the columns, including a total column showing how many shows each song was played in. .
#'
#' @param shows a list of show ids
#'
#'
#' @examples
#' sets <- sets(shows = c("aalst-belgium-92390", "aberdeen-scotland-50499", "leeds-england-103102"))


sets <- function(shows = NULL) {


  if(is.null(shows)==FALSE) {

    duration_data_da <- duration_data_da %>%
      select(gid, song)

    sets <- duration_data_da %>%
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

  sets <- list(shows, songs)

  return(sets)

}
