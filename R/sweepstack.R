
#' sweepstack
#' @title sweepstack runs stacks iteratively over a range of different starting shows.
#' @description it returns a dataframe with two columns, "gid" and "shows".  gid is the gig id of the starting show used for the test.  shows is the number of shows included in the resulting stack.
#'
#'
#' @param number_stacks this is the number of starting shows to test.  if not specified all the possible starting shows will be tested.
#' @param exclude_poor_sound_quality set this to TRUE to exclude shows with sound quality rated as 'Poor'.
#' @param myduration_data_da optional `duration_data_da` dataframe (as produced by `Repeatr_1()`) to be used for the pool of shows/songs to sweep over. If omitted the currently lazy-loaded default will be used.
#' @param mysummary,myothervariables,mygidsoundquality optional lookup tables passed straight through to `stacks()` - see there for details. If omitted the currently lazy-loaded defaults will be used.
#'
#' @return A list of two data frames: `stack_summary` (`gid`, `shows` - one row per starting show tested, and the number of shows needed to reach the target unique-song count) and `stack_details` (`gid_initial`, `gid`, `title` - the full, deduplicated set of shows and songs behind every stack tested).
#' @export
#'
#' @examples
#' results <- sweepstack(number_stacks = 10, exclude_poor_sound_quality = TRUE)
#' stack1 <- results[[1]]
#' stack2 <- results[[2]]
#'
sweepstack <- function(number_stacks = NULL, exclude_poor_sound_quality = FALSE,
                        myduration_data_da = NULL, mysummary = NULL, myothervariables = NULL, mygidsoundquality = NULL){

  # Use a freshly-supplied duration_data_da if given, otherwise fall back to
  # whatever is currently lazy-loaded from data/ (the package's last build).
  if (is.null(myduration_data_da)==FALSE) { duration_data_da <- myduration_data_da } else { duration_data_da <- duration_data_da }

  giddf <- duration_data_da %>%
    group_by(gid) %>%
    summarize(songs = n()) %>%
    ungroup()

  maxtests <- nrow(giddf)

  random <- as.data.frame(runif(maxtests))

  colnames(random)[1] = "random"

  giddf <- as.data.frame(cbind(giddf, random)) %>%
    arrange(random)

  if(is.null(number_stacks)==TRUE){

    number_stacks <- nrow(giddf)

  }

  message <- paste0("stack ", 1,"\n")
  cat(yellow(message))

  results <- SimDesign::quiet(stacks(mygid = as.character(giddf[1,1]), exclude_poor_sound_quality = exclude_poor_sound_quality,
                           mysummary = mysummary, myothervariables = myothervariables, mygidsoundquality = mygidsoundquality))

  stack_details <- results[[1]] %>%
    mutate(gid_initial = as.character(giddf[1,1])) %>%
    relocate(gid_initial) %>%
    select(gid_initial, gid, title)

  stack_summary <- results[[2]] %>%
    mutate(gid = as.character(giddf[1,1])) %>%
    group_by(gid) %>%
    summarize(shows = n()) %>%
    ungroup()

  for(i in 2:number_stacks){

    message <- paste0("stack ", i,"\n")
    cat(yellow(message))

    results <- SimDesign::quiet(stacks(mygid = as.character(giddf[i,1]), exclude_poor_sound_quality = exclude_poor_sound_quality,
                             mysummary = mysummary, myothervariables = myothervariables, mygidsoundquality = mygidsoundquality))

    stack_summary2 <- results[[2]] %>%
      mutate(gid = as.character(giddf[i,1])) %>%
      group_by(gid) %>%
      summarize(shows = n()) %>%
      ungroup()

    stack_details2 <- results[[1]] %>%
      mutate(gid_initial = as.character(giddf[i,1])) %>%
      relocate(gid_initial) %>%
      select(gid_initial, gid, title)

    stack_summary <- as.data.frame(rbind(stack_summary, stack_summary2))

    stack_details <- as.data.frame(rbind(stack_details, stack_details2))

  }

  # to remove duplicates

  stack_details <- stack_details %>%
    group_by(gid_initial, gid, title) %>%
    mutate(number = row_number()) %>%
    ungroup() %>%
    arrange(gid_initial, gid, title, number) %>%
    filter(number==1) %>%
    select(gid_initial, gid, title)

  results <- list(stack_summary, stack_details)

  return(results)

}






