
#' stacks
#' @title stacks puts together a set of shows that will contain a specified number of unique songs.
#' @description sets returns a list with two dataframes
#' @description the first is a table with the list of shows in the rows and the shows in the columns, including a total column showing how many shows each song was played in. .
#' @description the second is a summary table of the number of shows in which songs appear, with one row per number of shows, the number of songs in each category, and the proportion of the total number of songs.
#'
#'
#' @param mydf dataframs of shows and songs containing the columns gid and song.
#' @param mygid gig id of initial show as a string, for instance "washington-dc-usa-13196".
#' @param mynumberofsongs the number of unique songs that are required. the maximum is 94 (the number of songs Fugazi played live  at least twice) and the number of songs in the initial show will be taken as a minimum.
#'
#' @return
#' @export
#'
#' @examples
#' gid_song <- duration_data_da %>%
#'   select(gid, song)
#'
#' results <- stacks(mydf = gid_song, mygid = "washington-dc-usa-13196", mynumberofsongs = 94)
#' stack1 <- results[[1]]
#' stack2 <- results[[2]]
#'
#'
stacks <- function(mydf = NULL, mygid = NULL, mynumberofsongs = NULL){


# pre-processing to check that all required parameters are defined -----------------------------------------------------------


  song_chosen <- summary %>%
    select(song, chosen) %>%
    arrange(chosen)

  if(is.null(mydf)==TRUE){

    mydf <- duration_data_da %>%
      select(gid, song)

  }

  if(is.null(mygid)==TRUE){

    gid_data <- mydf %>%
      left_join(song_chosen) %>%
      arrange(chosen) %>%
      mutate(gid_chosen = ifelse(row_number()==1, 1, 0)) %>%
      filter(gid_chosen==1)

    mygid <- as.character(gid_data[1,1])

    rm(gid_data)

  }

  stack_songs <- mydf %>%
    filter(gid==mygid) %>%
    select(gid, song) %>%
    mutate(stack=1)

  minimumsongs <- nrow(stack_songs)

  if(is.null(mynumberofsongs)==TRUE) {

    mynumberofsongs <- 94

  }

  if(mynumberofsongs > 94) {

    mynumberofsongs <- 94

  }

  if(mynumberofsongs < minimumsongs) {

    mynumberofsongs <- minimumsongs

  }


# while loop --------------------------------------------------------------------


  repeat{

    gid_song_stack <- mydf %>%
      left_join(stack_songs, by = c("song")) %>%
      rename(gid = gid.x) %>%
      select(gid, song, stack)

    gid_song_new <- gid_song_stack %>%
      replace(is.na(.), 0)  %>%
      mutate(new = 1-stack)  %>%
      select(gid, song, new)

    # restrict the data to shows with the next rarest song

    gid_data <- gid_song_new %>%
      left_join(song_chosen) %>%
      filter(new==1)

    lowest_play_count <- min(gid_data$chosen)

    gid_data <- gid_data %>%
      mutate(selected_song = ifelse(chosen == lowest_play_count, 1, 0))

    gid_data <- gid_data %>%
      group_by(gid) %>%
      summarise(new = sum(new), selected_song = sum(selected_song)) %>%
      filter(selected_song>0) %>%
      ungroup()

    # out of all the shows with the next rarest song, pick the show offering the most new songs

    gid_selected <- gid_data %>%
      arrange(desc(new)) %>%
      mutate(selected = ifelse(row_number()==1,1,0)) %>%
      select(gid, selected)

    stack2 <- mydf %>%
      left_join(gid_selected) %>%
      filter(selected==1) %>%
      rename(stack = selected)

    stack <- as.data.frame(rbind(stack_songs, stack2))

    stack_songs <- stack %>%
      group_by(song) %>%
      mutate(number = row_number()) %>%
      ungroup() %>%
      filter(number == 1) %>%
      select(gid, song, stack)

    unique_songs <- nrow(stack_songs)

    stack_shows <- stack_songs %>%
      group_by(gid) %>%
      summarize(selected = 1) %>%
      ungroup()

    stack_shows_songs <- gid_song_stack %>%
      left_join(stack_shows) %>%
      filter(selected==1) %>%
      group_by(gid) %>%
      summarize(songs = sum(selected)) %>%
      ungroup()

    stack_shows_songs <- stack_shows_songs %>%
      left_join(othervariables) %>%
      select(flsid, gid, tour, date, venue, city, country, songs) %>%
      arrange(date)

    if(unique_songs>=mynumberofsongs){
      break
    }


  }

  stacks <- list(stack_songs, stack_shows_songs)

  return(stacks)

}



