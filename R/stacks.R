
#' stacks
#' @title stacks puts together a set of shows that will contain a specified number of unique songs.
#' @description sets returns a list with two dataframes
#' @description the first is a table with the list of shows in the rows and the shows in the columns, including a total column showing how many shows each song was played in. .
#' @description the second is a summary table of the number of shows in which songs appear, with one row per number of shows, the number of songs in each category, and the proportion of the total number of songs.
#'
#'
#' @param mydf dataframs of shows and songs containing the columns gid and song.
#' @param mystack starting stack - a table with the columns gid and song.
#' @param mynumberofsongs the number of unique songs that are required. the maximum is 94.
#'
#' @return
#' @export
#'
#' @examples
#' gid_song <- duration_data_da %>%
#'   select(gid, song)
#'
#' stack <- gid_song %>%
#'   filter(gid=="washington-dc-usa-13196") %>%
#'   select(gid, song)
#'
#' results <- stacks(mydf = gid_song, mystack = stack, mynumberofsongs = 94)
#' stack1 <- results[[1]]
#' stack2 <- results[[2]]
#'
#'
stacks <- function(mydf = NULL, mystack = NULL, mynumberofsongs = NULL){

  stack_songs <- mystack %>%
    mutate(stack=1)

  repeat{

    gid_song_stack <- mydf %>%
      left_join(stack_songs, by = c("song")) %>%
      rename(gid = gid.x) %>%
      select(gid, song, stack)

    gid_song_stack <- gid_song_stack %>%
      replace(is.na(.), 0)  %>%
      mutate(new = 1-stack)

    gid_selected <- gid_song_stack %>%
      group_by(gid) %>%
      summarize(new = sum(new)) %>%
      ungroup() %>%
      arrange(desc(new)) %>%
      mutate(selected = ifelse(row_number()==1,1,0)) %>%
      select(gid, selected)

    stack2 <- gid_song %>%
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

    if(unique_songs==mynumberofsongs){
      break
    }


  }

  stacks <- list(stack_songs, stack_shows_songs)

  return(stacks)

}



