
#' stacks
#' @title stacks puts together a set of shows that will contain a specified number of unique songs.
#'
#'
#' @param mydf dataframs of shows and songs containing the columns gid and song.
#' @param mygid gig id of initial show as a string, for instance "washington-dc-usa-13196".
#' @param mynumberofsongs the number of unique songs that are required. the maximum is 94 (the number of songs Fugazi played live  at least twice) and the number of songs in the initial show will be taken as a minimum.
#' @param exclude_poor_sound_quality set to TRUE to exclude shows with poor sound quality
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
stacks <- function(mydf = NULL, mygid = NULL, mynumberofsongs = NULL, exclude_poor_sound_quality = FALSE){

# pre-processing to check that all required parameters are defined -----------------------------------------------------------

  song_chosen <- Repeatr::summary %>%
    select(song, chosen) %>%
    arrange(chosen)

  if(is.null(mydf)==TRUE){

    mydf <- duration_data_da %>%
      select(gid, song)

  }



  if(exclude_poor_sound_quality==TRUE) {

    mydf <- mydf %>%
      left_join(gid_sound_quality)

    mydf <- mydf %>%
      filter(sound_quality!="Poor") %>%
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
      summarise(new = sum(new), selected_song = sum(selected_song), chosen = sum(chosen)) %>%
      filter(selected_song>0) %>%
      ungroup()

    # out of all the shows with the next rarest song, pick one of the shows offering the most new songs
    # and out of those shows, pick the one with least played songs

    gid_selected <- gid_data %>%
      arrange(desc(new), chosen) %>%
      mutate(selected = ifelse(row_number()==1,1,0))

    gid_selected <- gid_selected %>%
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
      mutate(urls = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
      mutate(fls_link = paste0("<a href='",  urls, "' target='_blank'>", gid, "</a>")) %>%
      left_join(gid_sound_quality) %>%
      select(fls_link, tour, date, venue, city, country, sound_quality, songs) %>%
      arrange(date)

    if(unique_songs>=mynumberofsongs){
      break
    }


  }

  stack_songs <- stack_songs %>%
    select(gid, song)


  mystacks <- list(stack_songs, stack_shows_songs)

  return(mystacks)

}



