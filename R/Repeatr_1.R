
#' @name Repeatr_1
#' @title imports raw data in CSV format, cleans the data, and reshapes it long so that the rows are identified by combinations of gid and song_number.
#' @description This was originally developed with a file called "fugotcha.csv", the first line of which went like this:
#' @description washington-dc-usa-90387	FLS0001	03/09/1987	Wilson Center	$5	300	Joey Picuri	Fugazi	Cassette	Joe #1	Intro	Song #1	Furniture	Merchandise	Turn Off Your Guns	In Defense Of Humans	Waiting Room	The Word
#' @description "gid" is short for "gig id"
#' @description Another data file that was used was called "releases_songs_durations_wikipedia.csv" and was obtained from the Wikipedia data on the Fugazi discography.
#' @description This file contains the following variables: index	releaseid	release	track_number	songid	song	instrumental	vocals_picciotto	vocals_mackaye	vocals_lally	duration_seconds

#'
#' @import dplyr
#' @import stringr
#' @import lubridate
#' @import fastDummies
#' @import rlang
#' @import knitr
#'
#' @param mycsvfile Optional name of CSV file containing Fugazi Live Series data to be used. If omitted, the default file provided with the package will be used.
#' @param mysongdatafile Optional name of CSV file containing song data to be used. If omitted, the default file provided with the package will be used.
#' @param releasesdatafile Optional name of CSV file containing releases data to be used. If omitted, the default file provided with the package will be used.
#' @param geocodedatafile Optional name of CSV file containing coordinates for each gig and other data. If omitted, the default file provided with the package will be used.
#'
#' @return
#' @export
#'
#' @examples
#' fugotcha <- system.file("extdata", "fugotcha.csv", package = "Repeatr")
#' releases_songs_durations_wikipedia <- system.file("extdata", "releases_songs_durations_wikipedia.csv", package = "Repeatr")
#' releasesdatafile <- system.file("extdata", "releases_rym.csv", package = "Repeatr")
#' Repeatr_1_results <- Repeatr_1(mycsvfile = fugotcha, mysongdatafile = releases_songs_durations_wikipedia, releasesdatafile = releasesdatafile)
#'
Repeatr_1 <- function(mycsvfile = NULL, mysongdatafile = NULL, releasesdatafile = NULL, geocodedatafile = NULL) {


# Devel setup -------------------------------------------------------------

  # Uncomment and run the following lines to test the code outside the package

  # library(dplyr)
  # library(stringr)
  # library(lubridate)
  # library(mlogit)
  # library(fastDummies)
  # library(rlang)
  # library(knitr)
  # library(crayon)
  # library(readr)

# Import data -------------------------------------------------------------


  if (is.null(mycsvfile)==FALSE) {

    Repeatr0 <- read.csv(mycsvfile, header=FALSE)

  } else {

    Repeatr0 <- system.file("extdata", "fugotcha.csv", package = "Repeatr")
    Repeatr0 <- read.csv(fugotcha, header=FALSE)

    rawdata <- Repeatr0 %>%
      mutate(date = as.Date(V3, "%Y-%m-%d")) %>%
      mutate(year = lubridate::year(date)) %>%
      relocate(year)

    rawdata$date <- NULL

  }

  if (is.null(mysongdatafile)==FALSE) {

    mysongvarslookup <- read.csv(mysongdatafile)

  } else {

    mysongdatafile <- system.file("extdata", "releases_songs_durations_wikipedia.csv", package = "Repeatr")
    mysongvarslookup <- read.csv(mysongdatafile)

  }

  if (is.null(releasesdatafile)==FALSE) {

    releasesdatalookup <- read.csv(releasesdatafile)

  } else {

    releasesdatafile <- system.file("extdata", "releases_rym.csv", package = "Repeatr")
    releasesdatalookup <- read.csv(releasesdatafile)
    releasesdatalookup$X <- NULL

  }

  if (is.null(geocodedatafile)==FALSE) {

    geocodedatafile <- read.csv(geocodedatafile)

  } else {

    geocodedatafilename <- system.file("extdata", "fugazi-small.csv", package = "Repeatr")
    geocodedatafile <- read.csv(geocodedatafilename)
    geocodedatafile$X <- NULL

  }

  geocodedatafile <- geocodedatafile %>%
    mutate(date = as.Date(date))

  othervariables_patchfilename <- system.file("extdata", "othervariables_patch.csv", package = "Repeatr")
  othervariables_patchfile <- read.csv(othervariables_patchfilename) %>%
    mutate(date = as.Date(date, "%m-%d-%Y"))

  # Define data file with other variables for possible later use
  othervariables <- Repeatr0 %>%
    select(V1, V2, V3, V4, V5, V6, V7, V8, V9)

  othervariables <- othervariables %>%
    rename(gid = V1) %>%
    rename(flsid = V2) %>%
    rename(date = V3) %>%
    rename(venue = V4) %>%
    rename(doorprice = V5) %>%
    rename(attendance = V6) %>%
    rename(recorded_by = V7) %>%
    rename(mastered_by = V8) %>%
    rename(original_source = V9)

  othervariables <- othervariables %>%
    mutate(date = as.Date(date))

  othervariables <- othervariables %>%
    mutate(attendance = as.numeric(attendance))

  othervariables <- othervariables %>% left_join(geocodedatafile)

  othervariables <- othervariables %>%
    mutate(country = ifelse(flsid=="FLS0970", "USA", country),
           city = ifelse(flsid=="FLS0970", "San Francisco", city),
           x = ifelse(flsid=="FLS0970", -122.4272376, x),
           y = ifelse(flsid=="FLS0970", 37.760407, y),
           tour = ifelse(flsid=="FLS0970", "2000 Summer/Fall Regional Dates", tour),
           year = ifelse(flsid=="FLS0970", 2000, year),
           recorded_by = ifelse(flsid=="FLS0970", "Stephen Kozlowski", recorded_by))

  othervariables <- othervariables %>%
    filter(is.na(x)==FALSE)

  othervariables <- rbind.data.frame(othervariables, othervariables_patchfile)

  # correct values where necessary

  othervariables <- othervariables %>%
    mutate(x = ifelse(city=="Newcastle" & venue=="Riverside", -1.6069442, x),
           y = ifelse(city=="Newcastle" & venue=="Riverside", 54.9718324, y),
           x = ifelse(city=="Lisbon" & venue=="Gartejo", -9.1755975, x),
           y = ifelse(city=="Lisbon" & venue=="Gartejo", 38.7042177, y),
           x = ifelse(country == "Japan" & city=="Osaka" & venue=="AM Hall", 135.4995612, x),
           y = ifelse(country == "Japan" & city=="Osaka" & venue=="AM Hall", 34.7012144, y),
           x = ifelse(country == "Japan" & city=="Osaka" & venue=="Sun Hall", 135.4808578, x),
           y = ifelse(country == "Japan" & city=="Osaka" & venue=="Sun Hall", 34.6709861, y),
           x = ifelse(country == "Japan" & city=="Nagoya" & venue=="Club Quattro", 136.9082324, x),
           y = ifelse(country == "Japan" & city=="Nagoya" & venue=="Club Quattro", 35.1637276, y),
           x = ifelse(country == "USA" & city=="San Francisco" & venue=="Women's Building", -122.4228365, x),
           y = ifelse(country == "USA" & city=="San Francisco" & venue=="Women's Building", 37.7614483, y),
           x = ifelse(country == "USA" & city=="San Francisco" & venue=="Russian Theater", -122.4413234, x),
           y = ifelse(country == "USA" & city=="San Francisco" & venue=="Russian Theater", 37.7854355, y),
           x = ifelse(country == "USA" & city=="San Francisco" & venue=="Fort Mason Pier C", -122.4314681, x),
           y = ifelse(country == "USA" & city=="San Francisco" & venue=="Fort Mason Pier C", 37.8067481, y),
           x = ifelse(country == "USA" & city=="San Francisco" & venue=="Trocadero Transfer", -122.3982015, x),
           y = ifelse(country == "USA" & city=="San Francisco" & venue=="Trocadero Transfer", 37.7790623, y),
           x = ifelse(country == "USA" & city=="San Francisco" & venue=="Maritime", -122.3936571, x),
           y = ifelse(country == "USA" & city=="San Francisco" & venue=="Maritime", 37.7864189, y))


  # impute values where they are missing
  meanattendance <- othervariables %>%
    filter(is.na(tour)==FALSE) %>%
    mutate(attendance = ifelse(is.na(attendance)==TRUE, 100, attendance)) %>%
    group_by(year) %>%
    summarise(meanattendance = mean(attendance)) %>%
    ungroup()

  othervariables <- othervariables %>%
    filter(is.na(tour)==FALSE) %>%
    mutate(attendance = ifelse(flsid=="FLS0677", 500, attendance)) %>%
    left_join(meanattendance) %>%
    mutate(attendance = ifelse(is.na(attendance)==TRUE,meanattendance,attendance))

  othervariables <- othervariables %>%
    select(-meanattendance)

  save(othervariables, file="othervariables.rda")

  # Select the most relevant columns -------

  Repeatr1 <- subset(Repeatr0, select = -c(V2, V4, V5, V6, V7, V8, V9))

  names(Repeatr1)

  # Define gig id -----------------------------------------------------------

  names(Repeatr1)[names(Repeatr1) == "V1"] <- "gid"


  # Define date variables ----------------------------------------------------

  names(Repeatr1)[names(Repeatr1) == "V3"] <- "date"

  Repeatr1 <- Repeatr1 %>%
    mutate(date = as.Date(date))

  Repeatr1 <- Repeatr1 %>%
    mutate(year = year(date)) %>%
    relocate(year, .after=date)

  Repeatr1 <- Repeatr1 %>%
    mutate(month = month(date)) %>%
    relocate(month, .after=year)

  Repeatr1 <- Repeatr1 %>%
    mutate(day = day(date)) %>%
    relocate(day, .after=month)

  # Rename variables to make reshaping the data easier ----------------------

  myv <- 10

  for(mysong in 1:44) {

    myinitialname <- paste0("V", myv)
    mynewname <- paste0("song.", mysong)
    names(Repeatr1)[names(Repeatr1) == myinitialname] <- mynewname
    myv <- myv + 1

  }

  Repeatr1$nchar <- nchar(Repeatr1$song.1)

  Repeatr1 <- Repeatr1 %>%
    filter(nchar>0)

  Repeatr1$nchar <- NULL

  # Reshape to long format with 1 row per song ------------------------------

  Repeatr1 <- reshape(data = Repeatr1
                              , direction = "long"
                              , varying = 6:49
                              , idvar = "gid"
  )

  # Define song number ------------------------------------------------------

  names(Repeatr1)[names(Repeatr1) == "time"] <- "song_number"

  Repeatr1 <- Repeatr1 %>%
    arrange(gid, song_number)

  Repeatr1$nchar <- nchar(Repeatr1$song)

  Repeatr1 <- Repeatr1 %>%
    mutate(song = str_to_lower(song))

  # Recode variants of song titles to the main song title -------------------

  Repeatr1 <- Repeatr1 %>%
    mutate(song = str_replace(song, " instrumental", ""))

  Repeatr1 <- Repeatr1 %>%
    mutate(song = str_replace(song, " acapella", ""))

  Repeatr1 <- Repeatr1 %>%
    mutate(song = str_replace(song, " drum and bass jam", ""))

  Repeatr1 <- Repeatr1 %>%
    mutate(song = ifelse(song=="bed for the scraping (continued)", "bed for the scraping", song))

  Repeatr1 <- Repeatr1 %>%
    mutate(song = ifelse(song=="surf tune 1", "surf tune", song))

  Repeatr1 <- Repeatr1 %>%
    mutate(song = ifelse(song=="surf tune 2", "surf tune", song))

  Repeatr1 <- Repeatr1 %>%
    mutate(song = ifelse(song=="surf tune 3", "surf tune", song))

  Repeatr1 <- Repeatr1 %>%
    mutate(song = ifelse(song=="promises bit soundcheck", "promises", song))

  Repeatr1 <- Repeatr1 %>%
    mutate(song = ifelse(song=="promises coda", "promises", song))

  Repeatr1 <- Repeatr1 %>%
    mutate(song = ifelse(song=="provisional medley", "provisional", song))

  Repeatr1 <- Repeatr1 %>%
    mutate(song = ifelse(song=="the argument", "argument", song))


  # Filter the data to remove blank rows, intros, interludes, sound checks -----------------------------------------------------------------

  Repeatr1 <- Repeatr1 %>%
    filter(nchar>0)

  Repeatr1$nchar <- NULL

  Repeatr1 <- Repeatr1 %>%
    filter(!grepl("interlude",song))

  Repeatr1 <- Repeatr1 %>%
    filter(!grepl("encore",song))

  Repeatr1 <- Repeatr1 %>%
    filter(!grepl("intro",song))

  Repeatr1 <- Repeatr1 %>%
    filter(!grepl("track",song))

  Repeatr1 <- Repeatr1 %>%
    filter(!grepl("remarks",song))

  Repeatr1 <- Repeatr1 %>%
    filter(!grepl("ice cream",song))

  Repeatr1 <- Repeatr1 %>%
    filter(!grepl("outside",song))

  Repeatr1 <- Repeatr1 %>%
    filter(!grepl("sound check",song))

  Repeatr1 <- Repeatr1 %>%
    filter(!grepl("soundcheck",song))

  # Filter to remove unreleased songs or improvised one-offs ---------------------------------------

  Repeatr1 <- Repeatr1 %>%
    filter(song!=("heart on my chest"))

  Repeatr1 <- Repeatr1 %>%
    filter(song!=("lock dug"))

  Repeatr1 <- Repeatr1 %>%
    filter(song!=("nedcars"))

  Repeatr1 <- Repeatr1 %>%
    filter(song!=("noisy dub"))

  Repeatr1 <- Repeatr1 %>%
    filter(song!=("nsa"))

  Repeatr1 <- Repeatr1 %>%
    filter(song!=("set the charges"))

  Repeatr1 <- Repeatr1 %>%
    filter(song!=("she is blind"))

  Repeatr1 <- Repeatr1 %>%
    filter(song!=("world beat"))

  Repeatr1 <- Repeatr1 %>%
    filter(song!=("surf tune"))

  Repeatr1 <- Repeatr1 %>%
    filter(song!=("preprovisional"))

  # Summarise the data to check frequency counts for all songs --------------

  mycount <- Repeatr1 %>%
    group_by(song) %>%
    summarise(count= n()) %>%
    ungroup()

  mycount <- mycount %>%
    arrange(desc(count))

  mycount <- mycount %>% mutate(songid = row_number())
  mycount <- mycount %>% relocate(songid)

  # Create lookup table to go from song id to song title --------------

  mysongidlookup <- mycount
  mysongidlookup$count <- NULL
  saveRDS(mysongidlookup, "mysongidlookup.rds")

  write.csv(mysongidlookup, "mysongidlookup.csv")


  # Redefine song index in terms of the included songs ----------------------

  Repeatr1 <- Repeatr1 %>%
    arrange(gid, song_number)

  Repeatr1 <- Repeatr1 %>%
    group_by(gid) %>%
    mutate(song_number = row_number())

  Repeatr1 <- Repeatr1 %>%
    mutate(first_song = ifelse(song_number==1, 1, 0))

  Repeatr1 <- Repeatr1 %>%
    group_by(gid) %>%
    mutate(number_songs = n()) %>%
    mutate(last_song = ifelse(song_number==number_songs, 1, 0)) %>%
    ungroup()

  Repeatr1 <- Repeatr1 %>% left_join(mysongidlookup)

  # add additional variables for potential use in the choice modelling
  mysongvarslookup <- mysongvarslookup %>% select(songid, releaseid, release, track_number, instrumental, vocals_picciotto, vocals_mackaye, vocals_lally, duration_seconds)

  Repeatr1 <- Repeatr1 %>%
    left_join(mysongvarslookup)

  write.csv(mysongvarslookup, "mysongvarslookup.csv")

  # Save disaggregate data -----------------------------------

  Repeatr1 <- Repeatr1 %>%
    select(gid, date, year, month, day, song_number, songid, song, number_songs, first_song, last_song, releaseid,	release, track_number, instrumental,	vocals_picciotto,	vocals_mackaye,	vocals_lally,	duration_seconds) %>%
    arrange(date, song_number)

  myreturnlist <- list(Repeatr0, Repeatr1, mysongidlookup, mycount, mysongvarslookup, releasesdatalookup, othervariables)

  return(myreturnlist)

}
