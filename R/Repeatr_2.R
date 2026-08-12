#' @name Repeatr_2
#' @title takes a dataframe with one row per show-song and reshapes it long again so that the rows are identified by combinations of gid, song_number, and alt.
#' @description The first line of the data this was originally developed with:
#' @description washington-dc-usa-90387	FLS0001	03/09/1987	Wilson Center	$5	300	Joey Picuri	Fugazi	Cassette	Joe #1	Intro	Song #1	Furniture	Merchandise	Turn Off Your Guns	In Defense Of Humans	Waiting Room	The Word
#' @description "gid" is short for "gig id"
#'
#' @import dplyr
#' @import stringr
#' @import lubridate
#' @import fastDummies
#' @import rlang
#' @import knitr
#'
#' @param mydf optional dataframe to be used (the `Repeatr1` element of `Repeatr_1()`'s return list). If omitted the default (currently lazy-loaded) `Repeatr1` dataframe will be used.
#' @param mysongidlookup optional `songidlookup` dataframe to be used (the `songidlookup` element of `Repeatr_1()`'s return list). If omitted the default (currently lazy-loaded) `songidlookup` dataframe will be used. Pass this explicitly - rather than relying on the default - when calling `Repeatr_2()` right after a fresh `Repeatr_1()` in the same session, since the lazy-loaded default reflects the last build on disk, not the one just computed.
#' @param min_song_count Minimum number of performances a song needs to compete as an alternative in the choice model (`Repeatr_4`). Songs performed fewer times still appear in `songid`/`title` on the output, they just won't get an `alt` and can't be chosen as an alternative. Default 2 - songs performed only once can't support a stable alternative-specific intercept in the choice model. This is a choice-model concern only: it does not affect `songid`, which \code{\link{Repeatr_1}} assigns to every classified song regardless of this threshold.
#' @param input_dir Optional directory to write the `fugazi_song_counts.csv`/`fugazi_song_performance_intensity.csv` output-export CSVs into. If omitted, defaults to this package's own `inst/extdata` (these are Repeatr's own downloadable outputs, not primary/raw data).
#' @param output_dir Optional directory to save the rebuilt `data/*.rda` objects into. If omitted, defaults to `data/` under the current working directory.
#'
#' @return A list of 3 elements: `Repeatr2`, a data frame with one row per gid/song_number/alt combination, prepared for choice modelling (`case` is the choice-situation id, `alt` a dense 1..n index over the `min_song_count`-eligible songs only - this is what `mlogit`/`Repeatr_4` actually sees - `songid` the stable, full identity from `songidlookup` kept alongside `alt` rather than overwritten by it, `choice` whether that song was the one played, availability/played dummy variables, and years-since-launch bucket variables); `altlookup` (`alt`, `songid`, `title`, `count` - one row per `min_song_count`-eligible song), needed by \code{\link{Repeatr_5}}/\code{\link{rankr}} to translate `mlogit`'s `alt`-indexed coefficients back to song identity; and `fugazi_song_performance_intensity` (`min_song_count`-eligible songs only), needed by \code{\link{Repeatr_5}} - returned explicitly (not just saved to disk) so a fresh `Repeatr_Updatr()` run can thread it through rather than falling back to a stale lazy-loaded binding. Also saved to `data/Repeatr2.rda` and `data/altlookup.rda`, alongside `fugazi_song_counts` (which covers every classified song, not just the `min_song_count`-eligible ones).
#' @export
#'
#' @examples
#' Repeatr_2_results <- Repeatr_2(mydf = Repeatr1, output_dir = tempdir(), input_dir = tempdir())
#' Repeatr2 <- Repeatr_2_results[[1]]
#' altlookup <- Repeatr_2_results[[2]]
#' fugazi_song_performance_intensity <- Repeatr_2_results[[3]]
#'

Repeatr_2 <- function(mydf = NULL, mysongidlookup = NULL, min_song_count = 2,
                       input_dir = NULL, output_dir = NULL) {

  mydir <- getwd()
  on.exit(setwd(mydir), add = TRUE)
  myinputdir <- if (is.null(input_dir)) paste0(mydir, "/inst/extdata/") else paste0(input_dir, "/")
  mydatadir <- if (is.null(output_dir)) paste0(mydir, "/data") else output_dir

  # Use the songidlookup freshly returned by this session's Repeatr_1() call
  # if supplied, otherwise fall back to whatever is currently lazy-loaded
  # from data/songidlookup.rda (the package's last build).
  if (is.null(mysongidlookup)==FALSE) {

    songidlookup <- mysongidlookup

  } else {

    songidlookup <- songidlookup

  }

  # songidlookup (from Repeatr_1) covers every classified song, including
  # one-offs and rarities. songidlookup_model is the min_song_count-eligible
  # subset that can actually compete as a choice-model alternative; `alt` is
  # a dense 1..n index over *this* subset only, kept separate from the
  # stable, global `songid` so that changing min_song_count (or the set of
  # rare songs) can never renumber song identity - only which songs get an
  # `alt` at all.
  songidlookup_model <- songidlookup %>%
    filter(count >= min_song_count) %>%
    arrange(songid) %>%
    mutate(alt = row_number())

  nsongs <- nrow(songidlookup_model)

  # altlookup is the alt <-> songid/song translation table - Repeatr_5() and
  # rankr() need it to map mlogit's alt-indexed coefficients back to a
  # stable song identity, since Repeatr_3()/Repeatr_4() only ever see `alt`.
  altlookup <- songidlookup_model %>%
    select(alt, songid, title, count)

  setwd(mydatadir)
  save(altlookup, file = "altlookup.rda")
  setwd(mydir)

  # Reshape to long again so that there will now be one row per combination of song performed and song potentially available ------------------------------

  if (is.null(mydf)==FALSE) {

    Repeatr2 <- mydf

  } else {

    Repeatr2 <- Repeatr1

  }

  # Keep the full, unfiltered Repeatr1 data (same object mydf was given, or
  # the lazy-loaded default) for mycaseidlookup below - it needs every
  # gid/song_number combination, not just tracktype==1 rows, and must be the
  # same vintage as mydf rather than a separately-resolved bare `Repeatr1`.
  Repeatr1_current <- Repeatr2

  Repeatr2 <- Repeatr2 %>%
    filter(tracktype==1)

  # fugazi_song_counts covers every classified song (not just the
  # min_song_count-eligible subset used for alt below), so one-off
  # performances and rarities are still visible here even though they
  # can't compete as a choice-model alternative.
  fugazi_song_counts <- Repeatr2 %>%
    group_by(songid, title) %>%
    summarize(count = n()) %>%
    ungroup()

  # Add dummy variable for each song to the disaggregate data --------------

  Repeatr2 <- Repeatr2 %>% arrange(date, song_number)

  for(myalt in 1:nsongs) {

    myvarname <- paste0("song.", myalt)
    mysongname <- songidlookup_model %>% filter(alt == myalt) %>% pull(title)
    Repeatr2 <- Repeatr2 %>% mutate(!!myvarname := ifelse(title == mysongname,1,0))

  }

  for(myalt in 1:nsongs) {

    mysongvar <- rlang::sym(paste0("song.", myalt))
    myavailablevarname <- paste0("available.", myalt)
    Repeatr2 <- Repeatr2 %>% mutate(!!myavailablevarname := ifelse(cumsum(!!mysongvar)>=1,1,0))

  }

  for(myalt in 1:nsongs) {

    mysongvar <- rlang::sym(paste0("song.", myalt))
    myplayedvarname <- paste0("played.", myalt)
    Repeatr2 <- Repeatr2 %>%
      group_by(gid) %>%
      mutate(!!myplayedvarname := ifelse(cumsum(!!mysongvar)>=1,1,0)) %>%
      ungroup()

  }

  Repeatr2$title <- NULL
  Repeatr2$nchar <- NULL

  ncols <- ncol(Repeatr2)

  Repeatr2 <- Repeatr2 %>%
    group_by(gid, song_number) %>%
    slice(1) %>%
    ungroup()

  Repeatr2 <- reshape(data = Repeatr2
                   , direction = "long"
                   , varying = 20:ncols
                   , idvar = c("gid", "song_number")
  )

  # Drop the stale, per-row global songid that came along for the ride from
  # Repeatr1 (it's the song actually performed at this gid/song_number,
  # repeated identically across every alternative row by the reshape above -
  # not what we want here). `time` is the dense 1..nsongs index the dummy
  # columns above were built from - that's `alt`, the choice-model
  # alternative id, not song identity.
  Repeatr2$songid <- NULL
  Repeatr2 <- Repeatr2 %>% rename(alt = time)
  Repeatr2 <- Repeatr2 %>% rename(chosen = song)
  Repeatr2 <- Repeatr2 %>% arrange(date, year, month, day, song_number, alt)

  # available_rl is repertoire-level availability: is the song available in the repertoire?  It is considered available at the repertoire level from the time of its first performance in this data onwards.
  Repeatr2 <- Repeatr2 %>% rename(available_rl = available)

  # Summarise the long data to check frequency counts for all songs --------------

  # summarise the data at gig level
  mycount2_gl <- Repeatr2 %>%
    group_by(gid, date, alt) %>%
    summarise(chosen= sum(chosen), available_rl=max(available_rl)) %>%
    arrange(date, gid, alt) %>%
    ungroup()

  available_rl_lookup <- mycount2_gl %>%
    select(gid, alt, available_rl)

  # get the launch date of each song
  mylaunchdatelookup <- mycount2_gl %>%
    filter(available_rl==1) %>%
    group_by(alt) %>%
    summarise(launchdate = min(date)) %>%
    ungroup()


  # add launch dates to count file
  fugazi_song_counts <- fugazi_song_counts %>%
    left_join(songidlookup_model %>% select(songid, alt)) %>%
    left_join(mylaunchdatelookup) %>%
    select(songid, title, launchdate, count)

  knitr::kable(fugazi_song_counts, "pipe")

  setwd(myinputdir)

  write.csv(fugazi_song_counts, "fugazi_song_counts.csv")

  setwd(mydatadir)

  save(fugazi_song_counts, file = "fugazi_song_counts.rda")

  setwd(mydir)

  # summarise the data at song level

  mycount2_sl <- mycount2_gl %>%
    group_by(alt) %>%
    summarise(chosen= sum(chosen), available_rl=sum(available_rl)) %>%
    ungroup()

  mycount2_sl <- mycount2_sl %>%
    mutate(intensity = chosen/available_rl)

  mycount2_sl <- mycount2_sl %>%
    arrange(desc(intensity))

  mycount2_sl <- mycount2_sl %>%
    left_join(songidlookup_model %>% select(alt, songid, title))

  mycount2_sl <- mycount2_sl %>%
    left_join(fugazi_song_counts %>% select(-title))

  fugazi_song_performance_intensity <- mycount2_sl %>%
    select(songid, title, launchdate, chosen, available_rl, intensity)

  knitr::kable(fugazi_song_performance_intensity, "pipe")

  setwd(myinputdir)

  write.csv(fugazi_song_performance_intensity, "fugazi_song_performance_intensity.csv")

  setwd(mydatadir)

  save(fugazi_song_performance_intensity, file = "fugazi_song_performance_intensity.rda")

  setwd(mydir)

  # merge on repertoire-level availability
  Repeatr2$available_rl <- NULL
  Repeatr2 <- Repeatr2 %>% left_join(available_rl_lookup)
  Repeatr2 <- Repeatr2 %>% left_join(songidlookup_model %>% select(alt, songid, title))
  Repeatr2 <- Repeatr2 %>% select(gid, date, song_number, alt, songid, title, chosen, played, available_rl, first_song, last_song, rid,	release_title, track_number, instrumental,	vocals_picciotto,	vocals_mackaye,	vocals_lally,	duration_seconds)
  Repeatr2 <- Repeatr2 %>% arrange(date, gid, song_number, alt)

  # Merge on the launch date of each song and calculate how many years old each song is at the time of each gig
  Repeatr2 <- Repeatr2 %>% left_join(mylaunchdatelookup)
  Repeatr2 <- Repeatr2 %>% relocate(launchdate, .after=date)
  Repeatr2 <- Repeatr2 %>% mutate(yearsold = ifelse(available_rl==1,as.duration(launchdate %--% date) / dyears(1),0))
  Repeatr2 <- Repeatr2 %>% relocate(yearsold, .after=launchdate)

  # set the song "provisional" to unavailable after the launch of "reprovisional"
  Repeatr2 <- Repeatr2 %>%
    mutate(available_rl=ifelse((date>="1989-12-29" & title=="provisional"), 0, available_rl))

  # available_gl is gig-level availability.  A song is considered available at the gig level if it is available in the repertoire and it has not already been played.
  Repeatr2 <- Repeatr2 %>% mutate(available_gl=ifelse((played==1 & chosen==0),0,available_rl))
  Repeatr2 <- Repeatr2 %>% relocate(available_gl, .after=available_rl)

  # Remove records for unavailable songs

  Repeatr2 <- Repeatr2 %>% filter(available_gl==1)

  # Drop any choice occasion (gid, song_number) whose actually-performed
  # song isn't in the alternative set - e.g. a song too rare to meet
  # min_song_count and be included in songidlookup_model above. These have
  # no chosen alternative among the remaining rows, which is degenerate for
  # mlogit: a choice occasion with zero chosen alternatives destabilizes the
  # Hessian during model fitting (Repeatr_4).
  Repeatr2 <- Repeatr2 %>%
    group_by(gid, song_number) %>%
    filter(any(chosen == 1)) %>%
    ungroup()

  # Choice modelling with multinomial logit

  # define case variable and add it to the data

  mycaseidlookup <- Repeatr1_current %>%
    group_by(gid, song_number) %>%
    summarise(records = n(), date=min(date)) %>%
    arrange(date, song_number) %>%
    select(gid, song_number) %>%
    ungroup()

  mycaseidlookup <- mycaseidlookup %>%
    mutate(case = row_number())

  Repeatr2 <- Repeatr2 %>%
    left_join(mycaseidlookup) %>%
    relocate(case)

  Repeatr2 <- Repeatr2 %>% rename(choice = chosen)

  Repeatr2 <- Repeatr2 %>%
    mutate(year = year(date)) %>%
    relocate(year, .after=date)

  Repeatr2 <- Repeatr2 %>%
    mutate(first_song_instrumental = first_song*instrumental)

  setwd(mydatadir)

  save(Repeatr2, file = "Repeatr2.rda")

  setwd(mydir)

  return(list(Repeatr2, altlookup, fugazi_song_performance_intensity))

}

#
