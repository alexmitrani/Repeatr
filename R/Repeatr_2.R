#' @name Repeatr_2
#' @title takes a dataframe with one row per show-song and reshapes it long again so that the rows are identified by combinations of gid, song_number, and songid.
#' @description The first line of the data this was originally developed with:
#' @description washington-dc-usa-90387	FLS0001	03/09/1987	Wilson Center	$5	300	Joey Picuri	Fugazi	Cassette	Joe #1	Intro	Song #1	Furniture	Merchandise	Turn Off Your Guns	In Defense Of Humans	Waiting Room	The Word
#' @description "gid" is short for "gig id"
#'
#' @import dplyr
#' @import stringr
#' @import lubridate
#' @import mlogit
#' @import fastDummies
#' @import rlang
#' @import knitr
#'
#' @param mydf
#'
#' @return
#' @export
#'
#' @examples
#' myRepeatr1 <- system.file("data", "Repeatr1.rda", package = "Repeatr")
#' load(myRepeatr1)
#' mysongidlookup <- system.file("data", "songidlookup.rda", package = "Repeatr")
#' load(mysongidlookup)
#' Repeatr_2_results <- Repeatr_2(mydf = Repeatr1, mysongidlookup = songidlookup)
#'

Repeatr_2 <- function(mydf = NULL, mysongidlookup = NULL) {

  # Reshape to long again so that there will now be one row per combination of song performed and song potentially available ------------------------------

  if (is.null(mydf)==FALSE) {

    Repeatr2 <- mydf

  } else {

    Repeatr2 <- Repeatr1

  }

  # Add dummy variable for each song to the disaggregate data --------------

  Repeatr2 <- Repeatr2 %>% arrange(date, song_number)

  for(mysongid in 1:92) {

    myvarname <- paste0("song.", mysongid)
    mysongname <- as.character(mysongidlookup[mysongid,2])
    Repeatr2 <- Repeatr2 %>% mutate(!!myvarname := ifelse(song == mysongname,1,0))

  }

  for(mysongid in 1:92) {

    mysongvar <- rlang::sym(paste0("song.", mysongid))
    myavailablevarname <- paste0("available.", mysongid)
    Repeatr2 <- Repeatr2 %>% mutate(!!myavailablevarname := ifelse(cumsum(!!mysongvar)>=1,1,0))

  }

  for(mysongid in 1:92) {

    mysongvar <- rlang::sym(paste0("song.", mysongid))
    myplayedvarname <- paste0("played.", mysongid)
    Repeatr2 <- Repeatr2 %>%
      group_by(gid) %>%
      mutate(!!myplayedvarname := ifelse(cumsum(!!mysongvar)>=1,1,0)) %>%
      ungroup()

  }

  Repeatr2$song <- NULL
  Repeatr2$nchar <- NULL

  Repeatr2 <- reshape(data = Repeatr2
                   , direction = "long"
                   , varying = 19:294
                   , idvar = c("gid", "song_number")
  )

  Repeatr2$songid <- NULL
  Repeatr2 <- Repeatr2 %>% rename(songid = time)
  Repeatr2 <- Repeatr2 %>% rename(chosen = song)
  Repeatr2 <- Repeatr2 %>% arrange(date, year, month, day, song_number, songid)

  # available_rl is repertoire-level availability: is the song available in the repertoire?  It is considered available at the repertoire level from the time of its first performance in this data onwards.
  Repeatr2 <- Repeatr2 %>% rename(available_rl = available)

  # Summarise the long data to check frequency counts for all songs --------------

  # summarise the data at gig level
  mycount2_gl <- Repeatr2 %>%
    group_by(gid, date, songid) %>%
    summarise(chosen= sum(chosen), available_rl=max(available_rl)) %>%
    arrange(date, gid, songid) %>%
    ungroup()

  available_rl_lookup <- mycount2_gl %>%
    select(gid, songid, available_rl)

  # get the launch date of each song
  mylaunchdatelookup <- mycount2_gl %>%
    filter(available_rl==1) %>%
    group_by(songid) %>%
    summarise(launchdate = min(date)) %>%
    ungroup()

  # add launch dates to count file
  fugazi_song_counts <- mycount %>%
    left_join(mylaunchdatelookup) %>%
    select(songid, song, launchdate, count)

  knitr::kable(fugazi_song_counts, "pipe")

  write.csv(fugazi_song_counts, "fugazi_song_counts.csv")



  # summarise the data at song level

  mycount2_sl <- mycount2_gl %>%
    group_by(songid) %>%
    summarise(chosen= sum(chosen), available_rl=sum(available_rl)) %>%
    ungroup()

  mycount2_sl <- mycount2_sl %>%
    mutate(intensity = chosen/available_rl)

  mycount2_sl <- mycount2_sl %>%
    arrange(desc(intensity))

  mycount2_sl <- mycount2_sl %>%
    left_join(mysongidlookup)

  mycount2_sl <- mycount2_sl %>%
    left_join(mylaunchdatelookup)

  fugazi_song_performance_intensity <- mycount2_sl %>%
    select(songid, song, launchdate, chosen, available_rl, intensity)

  knitr::kable(fugazi_song_performance_intensity, "pipe")

  write.csv(fugazi_song_performance_intensity, "fugazi_song_performance_intensity.csv")

  # merge on repertoire-level availability
  Repeatr2$available_rl <- NULL
  Repeatr2 <- Repeatr2 %>% left_join(available_rl_lookup)
  Repeatr2 <- Repeatr2 %>% left_join(mysongidlookup)
  Repeatr2 <- Repeatr2 %>% select(gid, date, song_number, songid, song, chosen, played, available_rl, first_song, last_song, releaseid,	release, track_number, instrumental,	vocals_picciotto,	vocals_mackaye,	vocals_lally,	duration_seconds)
  Repeatr2 <- Repeatr2 %>% arrange(date, gid, song_number, songid)

  # Merge on the launch date of each song and calculate how many years old each song is at the time of each gig
  Repeatr2 <- Repeatr2 %>% left_join(mylaunchdatelookup)
  Repeatr2 <- Repeatr2 %>% relocate(launchdate, .after=date)
  Repeatr2 <- Repeatr2 %>% mutate(yearsold = ifelse(available_rl==1,as.duration(launchdate %--% date) / dyears(1),0))
  Repeatr2 <- Repeatr2 %>% relocate(yearsold, .after=launchdate)

  # set the song "provisional" to unavailable after the launch of "reprovisional"
  Repeatr2 <- Repeatr2 %>%
    mutate(available_rl=ifelse((date>="1989-12-29" & song=="provisional"), 0, available_rl))

  # available_gl is gig-level availability.  A song is considered available at the gig level if it is available in the repertoire and it has not already been played.
  Repeatr2 <- Repeatr2 %>% mutate(available_gl=ifelse((played==1 & chosen==0),0,available_rl))
  Repeatr2 <- Repeatr2 %>% relocate(available_gl, .after=available_rl)

  # Remove records for unavailable songs

  Repeatr2 <- Repeatr2 %>% filter(available_gl==1)

  # Choice modelling with multinomial logit

  # define case variable and add it to the data

  mycaseidlookup <- Repeatr1 %>%
    group_by(gid, song_number) %>%
    summarise(records = n(), date=min(date)) %>%
    arrange(date, song_number) %>%
    select(gid, song_number) %>%
    ungroup()

  mycaseidlookup <- mycaseidlookup %>%
    mutate(case = row_number())

  saveRDS(mycaseidlookup, "mycaseidlookup.rds")

  Repeatr2 <- Repeatr2 %>%
    left_join(mycaseidlookup) %>%
    relocate(case)

  Repeatr2 <- Repeatr2 %>% rename(alt = songid)
  Repeatr2 <- Repeatr2 %>% rename(choice = chosen)

  Repeatr2 <- Repeatr2 %>%
    mutate(year = year(date)) %>%
    relocate(year, .after=date)

  Repeatr2 <- Repeatr2 %>%
    mutate(first_song_instrumental = first_song*instrumental)

  return(Repeatr2)

}

#

