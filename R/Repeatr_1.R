
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
#'
#' @return
#' @export
#'
#' @examples
#' fugotcha <- system.file("extdata", "fugotcha.csv", package = "Repeatr")
#' releases_songs_durations_wikipedia <- system.file("extdata", "releases_songs_durations_wikipedia.csv", package = "Repeatr")
#' releasesdatafile <- system.file("extdata", "releases.csv", package = "Repeatr")
#' Repeatr_1_results <- Repeatr_1(mycsvfile = fugotcha, mysongdatafile = releases_songs_durations_wikipedia, releasesdatafile = releasesdatafile)
#'
Repeatr_1 <- function(mycsvfile = NULL, mysongdatafile = NULL, releasesdatafile = NULL) {


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

  mydir <- getwd()
  myinputdir <- paste0(mydir, "/inst/extdata/")
  mydatadir <- paste0(mydir, "/data")

  if (is.null(mycsvfile)==FALSE) {

    Repeatr0 <- read.csv(mycsvfile, header=FALSE)

  } else {

    fugotcha <- system.file("extdata", "fugotcha.csv", package = "Repeatr")
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

    releasesdatafile <- system.file("extdata", "releases.csv", package = "Repeatr")
    releasesdatalookup <- read.csv(releasesdatafile)
    releasesdatalookup$X <- NULL

  }


# Define othervariables data file which includes venue coordinates --------

  geocodedatafilename <- system.file("extdata", "fugazi-small.csv", package = "Repeatr")
  geocodedatafile <- read.csv(geocodedatafilename)
  geocodedatafile$X <- NULL

  geocodedatafile <- geocodedatafile %>%
    mutate(date = as.Date(date))

  othervariables_patchfilename <- system.file("extdata", "othervariables_patch.csv", package = "Repeatr")
  othervariables_patchfile <- read.csv(othervariables_patchfilename) %>%
    mutate(date = as.Date(date, "%m-%d-%Y"),
           checked = 1)

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
    mutate(date = as.Date(date),
           checked = 0)

  othervariables <- othervariables %>%
    mutate(attendance = as.numeric(attendance))

  othervariables <- othervariables %>% left_join(geocodedatafile)

  othervariables <- othervariables %>%
    mutate(country = ifelse(flsid=="FLS0970", "USA", country),
           country = ifelse(city=="Ljubljana" & year>=1991, "Slovenia", country),
           city = ifelse(flsid=="FLS0970", "San Francisco", city),
           x = ifelse(flsid=="FLS0970", -122.4272376, x),
           y = ifelse(flsid=="FLS0970", 37.760407, y),
           tour = ifelse(flsid=="FLS0970", "2000 Summer/Fall Regional Dates", tour),
           tour = ifelse(tour=="1993 Fall USA/Canda Tour", "1993 Fall USA/Canada Tour", tour),
           year = ifelse(flsid=="FLS0970", 2000, year),
           recorded_by = ifelse(flsid=="FLS0970", "Stephen Kozlowski", recorded_by),
           checked = ifelse(flsid=="FLS0970", 1, checked))

  othervariables <- othervariables %>%
    filter(is.na(x)==FALSE)

  othervariables <- rbind.data.frame(othervariables, othervariables_patchfile)

  # Disambiguation

  othervariables <- othervariables %>%
    mutate(city = ifelse(country=="England" & city=="Newcastle", "Newcastle-Upon-Tyne", city),
           city = ifelse(country=="USA" & city=="Oxford", "Oxford (USA)", city),
           city = ifelse(country=="Australia" & city=="Croydon", "Croydon (Australia)", city))

  othervariables <- othervariables %>%
    mutate(venue = ifelse(country=="USA" & city=="Washington" & venue=="9:30 Club" & year<=1995, "9:30 Club (1980-1995)", venue),
           x = ifelse(country=="USA" & city=="Washington" & venue=="9:30 Club (1980-1995)" & year<=1995, -77.0255867, x),
           y = ifelse(country=="USA" & city=="Washington" & venue=="9:30 Club (1980-1995)" & year<=1995, 38.8971517, y))

  # correct values where necessary

  othervariables <- othervariables %>%
    mutate(x = ifelse(city=="Newcastle-Upon-Tyne" & venue=="Riverside", -1.6051, x),
           y = ifelse(city=="Newcastle-Upon-Tyne" & venue=="Riverside", 54.9717, y),
           checked = ifelse(city=="Newcastle-Upon-Tyne" & venue=="Riverside", 1, checked),
           x = ifelse(city=="Lisbon" & venue=="Gartejo", -9.1755975, x),
           y = ifelse(city=="Lisbon" & venue=="Gartejo", 38.7042177, y),
           checked = ifelse(city=="Lisbon" & venue=="Gartejo", 1, checked),
           x = ifelse(country == "Japan" & city=="Osaka" & venue=="AM Hall", 135.4995612, x),
           y = ifelse(country == "Japan" & city=="Osaka" & venue=="AM Hall", 34.7012144, y),
           checked = ifelse(country == "Japan" & city=="Osaka" & venue=="AM Hall", 1, checked),
           x = ifelse(country == "Japan" & city=="Osaka" & venue=="Sun Hall", 135.4808578, x),
           y = ifelse(country == "Japan" & city=="Osaka" & venue=="Sun Hall", 34.6709861, y),
           checked = ifelse(country == "Japan" & city=="Osaka" & venue=="Sun Hall", 1, checked),
           x = ifelse(country == "Japan" & city=="Nagoya" & venue=="Club Quattro", 136.9082324, x),
           y = ifelse(country == "Japan" & city=="Nagoya" & venue=="Club Quattro", 35.1637276, y),
           checked = ifelse(country == "Japan" & city=="Nagoya" & venue=="Club Quattro", 1, checked),
           x = ifelse(country == "Japan" & city=="Nagoya" & venue=="Heartland", 136.9192034, x),
           y = ifelse(country == "Japan" & city=="Nagoya" & venue=="Heartland", 35.1693198, y),
           checked = ifelse(country == "Japan" & city=="Nagoya" & venue=="Heartland", 1, checked),
           x = ifelse(country == "USA" & city=="San Francisco" & venue=="Women's Building", -122.4228365, x),
           y = ifelse(country == "USA" & city=="San Francisco" & venue=="Women's Building", 37.7614483, y),
           checked = ifelse(country == "USA" & city=="San Francisco" & venue=="Women's Building", 1, checked),
           x = ifelse(country == "USA" & city=="San Francisco" & venue=="Russian Theater", -122.4413234, x),
           y = ifelse(country == "USA" & city=="San Francisco" & venue=="Russian Theater", 37.7854355, y),
           checked = ifelse(country == "USA" & city=="San Francisco" & venue=="Russian Theater", 1, checked),
           x = ifelse(country == "USA" & city=="San Francisco" & venue=="Fort Mason Pier C", -122.4314681, x),
           y = ifelse(country == "USA" & city=="San Francisco" & venue=="Fort Mason Pier C", 37.8067481, y),
           checked = ifelse(country == "USA" & city=="San Francisco" & venue=="Fort Mason Pier C", 1, checked),
           x = ifelse(country == "USA" & city=="San Francisco" & venue=="Trocadero Transfer", -122.3982015, x),
           y = ifelse(country == "USA" & city=="San Francisco" & venue=="Trocadero Transfer", 37.7790623, y),
           checked = ifelse(country == "USA" & city=="San Francisco" & venue=="Trocadero Transfer", 1, checked),
           x = ifelse(country == "USA" & city=="San Francisco" & venue=="Maritime", -122.3936571, x),
           y = ifelse(country == "USA" & city=="San Francisco" & venue=="Maritime", 37.7864189, y),
           checked = ifelse(country == "USA" & city=="San Francisco" & venue=="Maritime", 1, checked),
           x = ifelse(country == "Germany" & city=="Bremen" & venue=="Schlachthof", 8.8099035, x),
           y = ifelse(country == "Germany" & city=="Bremen" & venue=="Schlachthof", 53.0884866, y),
           checked = ifelse(country == "Germany" & city=="Bremen" & venue=="Schlachthof", 1, checked),
           x = ifelse(country == "Canada" & city=="Ottawa" & venue=="Carleton University Porter Hall", -75.6978497, x),
           y = ifelse(country == "Canada" & city=="Ottawa" & venue=="Carleton University Porter Hall", 45.3840001, y),
           checked = ifelse(country == "Canada" & city=="Ottawa" & venue=="Carleton University Porter Hall", 1, checked),
           x = ifelse(country == "Australia" & city=="Sydney" & (venue=="Metro Theatre" | venue=="Metro"), 151.2066274, x),
           y = ifelse(country == "Australia" & city=="Sydney" & (venue=="Metro Theatre" | venue=="Metro"), -33.8756943, y),
           checked = ifelse(country == "Australia" & city=="Sydney" & (venue=="Metro Theatre" | venue=="Metro"), 1, checked),
           x = ifelse(country == "USA" & city=="Watsonville" & venue=="Veteran's Memorial Hall", -121.7545246, x),
           y = ifelse(country == "USA" & city=="Watsonville" & venue=="Veteran's Memorial Hall", 36.9126013, y),
           checked = ifelse(country == "USA" & city=="Watsonville" & venue=="Veteran's Memorial Hall", 1, checked),
           x = ifelse(country == "Australia" & city=="Wollongong" & venue=="Youth Centre", 150.8928958, x),
           y = ifelse(country == "Australia" & city=="Wollongong" & venue=="Youth Centre", -34.4264333, y),
           checked = ifelse(country == "Australia" & city=="Wollongong" & venue=="Youth Centre", 1, checked),
           x = ifelse(country == "USA" & city=="Fayetteville" & venue=="Studio 225", -94.1667044, x),
           y = ifelse(country == "USA" & city=="Fayetteville" & venue=="Studio 225", 36.0657152, y),
           checked = ifelse(country == "USA" & city=="Fayetteville" & venue=="Studio 225", 1, checked),
           x = ifelse(country == "USA" & city=="Columbia (SC)" & venue=="Dance Graphics", -81.0175133, x),
           y = ifelse(country == "USA" & city=="Columbia (SC)" & venue=="Dance Graphics", 34.0032201, y),
           checked = ifelse(country == "USA" & city=="Columbia (SC)" & venue=="Dance Graphics", 1, checked),
           x = ifelse(country == "Brazil" & city=="Sao Paulo" & venue=="Aeroanta", -46.6949865, x),
           y = ifelse(country == "Brazil" & city=="Sao Paulo" & venue=="Aeroanta", -23.5651133, y),
           checked = ifelse(country == "Brazil" & city=="Sao Paulo" & venue=="Aeroanta", 1, checked))

  # Correct country
  othervariables <- othervariables %>%
    mutate(country = ifelse(city=="Belfast" | city=="Derry", "Northern Ireland", country),
           country = ifelse(flsid=="FLS0970", "USA", country))


  # Correct location of Queen's Hall, Belfast
  othervariables <- othervariables %>%
    mutate(x = ifelse(country == "Northern Ireland" & city=="Belfast" & venue=="Queen's Hall", -5.9396578, x),
           y = ifelse(country == "Northern Ireland" & city=="Belfast" & venue=="Queen's Hall", 54.5848401, y),
           checked = ifelse(country == "Northern Ireland" & city=="Belfast" & venue=="Queen's Hall", 1, checked))

  # impute values where they are missing
  meanattendance <- othervariables %>%
    filter(is.na(tour)==FALSE) %>%
    filter(is.na(attendance)==FALSE) %>%
    group_by(year) %>%
    summarise(meanattendance = mean(attendance)) %>%
    ungroup()

  othervariables <- othervariables %>%
    filter(is.na(tour)==FALSE) %>%
    left_join(meanattendance) %>%
    mutate(attendance = ifelse(is.na(attendance)==TRUE,meanattendance,attendance))

  othervariables <- othervariables %>%
    select(-meanattendance)

  othervariables <- othervariables %>%
    relocate(checked, .after = year)

  mydir <- getwd()
  myinputdir <- paste0(mydir, "/inst/extdata/")
  mydatadir <- paste0(mydir, "/data")

  fls_venue_geocoding_update_filename <- paste0(myinputdir, "fls_venue_geocoding.csv")

  # Update coordinates from geocoding file
  fls_venue_geocoding_update <- read.csv(fls_venue_geocoding_update_filename, header=TRUE) %>%
    select(country, city, venue, link_x, link_y, city_disambiguation, guess, unknown) %>%
    filter(is.na(link_x)==FALSE) %>%
    mutate(geocoding_check=1)

  fls_venue_geocoding_update <- fls_venue_geocoding_update %>%
    mutate(city_disambiguation = ifelse(nchar(city_disambiguation)>0,city_disambiguation,NA))

  othervariables <- othervariables %>%
    left_join(fls_venue_geocoding_update)

  othervariables <- othervariables %>%
    mutate(x = ifelse(is.na(link_x)==FALSE, link_x, x),
           y = ifelse(is.na(link_y)==FALSE, link_y, y),
           city = ifelse(is.na(city_disambiguation)==FALSE, city_disambiguation, city),
           checked = ifelse(is.na(geocoding_check)==FALSE & is.na(guess)==TRUE & is.na(unknown)==TRUE, geocoding_check, checked))

  othervariables <- othervariables %>%
    select(-link_x, -link_y, -city_disambiguation, -geocoding_check, -guess, -unknown)


  setwd(mydatadir)

  othervariables <- othervariables %>%
    group_by(gid) %>%
    slice(1) %>%
    ungroup()

  save(othervariables, file="othervariables.rda")

  setwd(mydir)

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

  songidlookup <- mycount
  songidlookup$count <- NULL
  setwd(mydatadir)
  save(songidlookup, file="songidlookup.rda")
  setwd(mydir)

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

  Repeatr1 <- Repeatr1 %>% left_join(songidlookup)

  # add additional variables for potential use in the choice modelling
  mysongvarslookup <- mysongvarslookup %>% select(songid, releaseid, release, track_number, instrumental, vocals_picciotto, vocals_mackaye, vocals_lally, duration_seconds)

  Repeatr1 <- Repeatr1 %>%
    left_join(mysongvarslookup)

  write.csv(mysongvarslookup, "mysongvarslookup.csv")

  # Save disaggregate data -----------------------------------

  Repeatr1 <- Repeatr1 %>%
    select(gid, date, year, month, day, song_number, songid, song, number_songs, first_song, last_song, releaseid,	release, track_number, instrumental,	vocals_picciotto,	vocals_mackaye,	vocals_lally,	duration_seconds) %>%
    arrange(date, song_number)

  # get rid of duplicated song records
  Repeatr1 <- Repeatr1 %>%
    filter(gid!="perth-australia-111096" | song_number<20)

  setwd(mydatadir)

  save(Repeatr1, file = "Repeatr1.rda")

  setwd(mydir)

  mydf <- Repeatr1 %>% select(date, song)

  mydf <- mydf %>%
    group_by(date, song) %>%
    summarize(count=n()) %>% ungroup()

  mydf_wide <- mydf %>%
    pivot_wider(names_from = song, values_from = count, values_fill = 0)

  mydf_wide2 <- mydf_wide

  for(colindex in 2:94) {

    mydf_wide2[,colindex] <- cumsum(mydf_wide2[,colindex])

  }

  mydf_long <- mydf_wide2 %>%
    pivot_longer(!date, names_to = "song", values_to = "count") %>%
    filter(count>0)

  releases_lookup <- Repeatr1 %>%
    group_by(song, release) %>%
    summarize(count = n()) %>%
    ungroup() %>%
    select(song, release)

  mydf_long <- mydf_long %>%
    left_join(releases_lookup)

  cumulative_song_counts <- mydf_long %>%
    select(date, song, release, count)

  setwd(mydatadir)

  save(cumulative_song_counts, file = "cumulative_song_counts.rda")

  setwd(mydir)

  myreturnlist <- list(Repeatr0, Repeatr1, songidlookup, mycount, mysongvarslookup, releasesdatalookup, othervariables, cumulative_song_counts)

  return(myreturnlist)

}
