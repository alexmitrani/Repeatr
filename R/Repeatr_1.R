
#' @name Repeatr_1
#' @title imports raw data in CSV format (1 row per show), cleans the data, and reshapes it long so that the rows are identified by combinations of gid and song_number.
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

    songvarslookup <- read.csv(mysongdatafile)

  } else {

    mysongdatafile <- system.file("extdata", "releases_songs_durations_wikipedia.csv", package = "Repeatr")
    songvarslookup <- read.csv(mysongdatafile)

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
    mutate(date = as.Date(date, "%d/%m/%Y"),
           checked = 0)

  othervariables <- othervariables %>%
    mutate(attendance = as.numeric(attendance))

  othervariables <- othervariables %>% left_join(geocodedatafile)

  othervariables <- othervariables %>%
    mutate(country = ifelse(flsid=="FLS0970", "USA", country),
           country = ifelse(city=="Ljubljana" & year>=1991, "Slovenia", country),
           country = ifelse(city=="Prague" & year<=1992, "Czechoslovakia", country),
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


  othervariables <- othervariables %>%
    mutate(venue = ifelse(flsid=="FLS0050", "Frankford YWCA", venue))

  othervariables <- othervariables %>%
    mutate(venue = ifelse(flsid=="FLS0478", "Tempodrom", venue))

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
           checked = ifelse(country == "Brazil" & city=="Sao Paulo" & venue=="Aeroanta", 1, checked),
           venue = ifelse(venue=="Zepplin Rock", "Zeppelin Rock", venue),
           city = ifelse(city=="San.De Campostela", "Santiago de Compostela", city),
           x = ifelse(city=="Huntington" & venue=="Stone Monkey", -82.4201034, x),
           y = ifelse(city=="Huntington" & venue=="Stone Monkey", 38.4272709, y),
           checked = ifelse(city=="Huntington" & venue=="Stone Monkey", 1, checked))

  # Correct country
  othervariables <- othervariables %>%
    mutate(country = ifelse((city=="Belfast" | city=="Derry"), "Northern Ireland", country),
           country = ifelse(flsid=="FLS0970", "USA", country))

  # Correct location of Queen's Hall, Belfast
  othervariables <- othervariables %>%
    mutate(x = ifelse(country == "Northern Ireland" & city=="Belfast" & (venue=="Queen's Hall" | venue=="Queen's University Mandela Hall"), -5.9374134, x),
           y = ifelse(country == "Northern Ireland" & city=="Belfast" & (venue=="Queen's Hall" | venue=="Queen's University Mandela Hall"), 54.5846991, y),
           checked = ifelse(country == "Northern Ireland" & city=="Belfast" & (venue=="Queen's Hall" | venue=="Queen's University Mandela Hall"), 1, checked))

  # Correct location of Rototom
  othervariables <- othervariables %>%
    mutate(city = ifelse(venue=="Rototom", "Gaio di Spilimbergo", city))

  # Correct venue of 1995 Copenhagen show
  othervariables <- othervariables %>%
    mutate(venue = ifelse(gid=="copenhagen-denmark-71095", "Rockmaskinen", venue),
           x = ifelse(gid=="copenhagen-denmark-71095", 12.5994855, x),
           y = ifelse(gid=="copenhagen-denmark-71095", 55.6737142, y))

  # Correct venue of Loppen
  othervariables <- othervariables %>%
    mutate(x = ifelse(gid=="copenhagen-denmark-100700", 12.5973313, x),
           y = ifelse(gid=="copenhagen-denmark-100700", 55.6740572, y))

  # Correct venue of 1988 Nottingham show
  othervariables <- othervariables %>%
    mutate(x = ifelse(gid=="nottingham-england-112788", -1.1349991, x),
           y = ifelse(gid=="nottingham-england-112788", 52.9558396, y))

  # Correct venue name and location for 1995 quebec city show
  othervariables <- othervariables %>%
    mutate(venue = ifelse(gid=="quebec-city-qc-canada-92495", "Cégep Limoilou", venue))

  othervariables <- othervariables %>%
    mutate(x = ifelse(gid=="quebec-city-qc-canada-92495", -71.2283038, x),
           y = ifelse(gid=="quebec-city-qc-canada-92495", 46.8305332, y))

  # Correct venue name https://www.dischord.com/fugazi_live_series/campinas-brazil-81997
  # Assampi = Associação de amigos do Parque Industrial
  othervariables <- othervariables %>%
    mutate(venue = ifelse(gid=="campinas-brazil-81997", "Assampi", venue))

  # Correct venue name https://www.dischord.com/fugazi_live_series/joinville-brazil-81597
  # Liga da Sociedade Joinvilense
  othervariables <- othervariables %>%
    mutate(venue = ifelse(gid=="joinville-brazil-81597", "Liga da Sociedade Joinvilense", venue))

  # Correct venue name for 1998 quebec city show https://dischord.com/fugazi_live_series/quebec-city-qc-canada-72298
  othervariables <- othervariables %>%
    mutate(venue = ifelse(gid=="quebec-city-qc-canada-72298", "Centre des Loisirs Saint-Sacrement", venue))

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
  save(releasesdatalookup, file="releasesdatalookup.rda")
  save(songvarslookup, file="songvarslookup.rda")
  save(Repeatr0, file="Repeatr0.rda")

  setwd(mydir)


  # process tags data -------------------------------------------------------

  setwd(myinputdir)

  fls_tags_name_recoded <- system.file("extdata", "fls_tags_name_recoded.csv", package = "Repeatr")

  fls_tags_name_recoded <- read.csv(fls_tags_name_recoded)

  fls_tags <- fls_tags_importer(myfilename = "fls_tags.txt")

  fls_tags <- fls_tags %>%
    mutate(name = str_to_lower(name))

  fls_tags <- fls_tags %>%
    left_join(fls_tags_name_recoded)

  fls_tags <- fls_tags %>%
    mutate(name = name_corrected)

  fls_tags <- fls_tags %>%
    select(-name_corrected)

  fls_tags <- fls_tags %>%
    rename(song = name)

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(album == "20220218 40 Watt, Athens, GA, USA", "19930218 40 Watt, Athens, GA, USA", album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(album == "20010607 Archie Browning Centre, Victoria, BC, Canada", "20010706 Archie Browning Centre, Victoria, BC, Canada", album))

  fls_tags <- fls_tags %>%
    mutate(year = str_sub(album, 1, 4),
           month = str_sub(album, 5, 6),
           day = str_sub(album, 7, 8),
           datestring = paste0(day, "/", month, "/", year))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(datestring == "20/02/1988" , "19880220 Merrifield Community Center, Merrifield, VA, USA", album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(datestring == "20/08/1994" , "19940820 Aeroanta, Sao Paulo, Brazil", album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(datestring == "24/09/1995" , "19950924 Cegep Limoilou, Quebec City, Quebec, Canada", album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(datestring == "22/07/1998" , "19980722 Centre de Loisirs, Quebec City, QC, Canada", album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(datestring == "11/02/1990" , "19900211 Studio 10, Baltimore, MD, USA", album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(datestring == "06/09/1991" , "19910906 Desert Fest, Jawbone Canyon, CA, USA", album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(datestring == "14/11/1998" , "19981114 University of Wisconsin, Fire Room, Eau Claire, WI, USA", album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(datestring == "03/03/1999" , "19990303 Cal State University Shurmer Gym, Chico, CA, USA", album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(datestring == "25/04/2001" , "20010425 9:30 Club, Washington, DC, USA", album))

  fls_tags <- fls_tags %>%
    mutate(date = as.Date(datestring, "%d/%m/%Y"))

  fls_tags <- fls_tags %>%
    rowwise() %>%
    mutate(firstcomma = unlist(gregexpr(',', album))[1])

  fls_tags <- fls_tags %>%
    rowwise() %>%
    mutate(secondcomma = unlist(gregexpr(',', album))[2])

  fls_tags <- fls_tags %>%
    rowwise() %>%
    mutate(lastcomma = tail(unlist(gregexpr(',', album)), n=1))

  fls_tags <- fls_tags %>%
    mutate(stringlength = nchar(album))

  fls_tags <- fls_tags %>%
    mutate(venue = str_sub(album, 10, firstcomma-1))

  fls_tags <- fls_tags %>%
    filter(venue!="Mayfaur")

  fls_tags <- fls_tags %>%
    mutate(city = str_sub(album, firstcomma + 2, secondcomma-1))

  fls_tags <- fls_tags %>%
    mutate(country = str_sub(album, lastcomma + 2, stringlength))

  fls_tags <- fls_tags %>%
    mutate(state = ifelse(country=="USA", str_sub(album, lastcomma-2, lastcomma-1),""))

  fls_tags <- fls_tags %>%
    select(track, album, song, duration, seconds, date, venue, city, state, country)

  date_gid <- othervariables %>%
    select(date, gid)

  fls_tags <- fls_tags %>%
    left_join(date_gid)

  fls_tags <- fls_tags %>%
    filter(venue!="Van Hall" | gid!="gent-belgium-101688")

  fls_tags <- fls_tags %>%
    filter(venue!="Democrazy" | gid!="amsterdam-netherlands-101688")

  fls_tags <- fls_tags %>%
    mutate(song = ifelse(gid=="peoria-il-usa-100995" & song=="dance rap", "interlude 4", song))

  fls_tags_show <- fls_tags %>%
    group_by(date, venue, city, state, country, album, gid) %>%
    summarize(seconds = sum(seconds)) %>%
    mutate(duration = seconds_to_period(seconds)) %>%
    ungroup()

  fls_tags_show <- fls_tags_show %>%
    select(date, venue, city, state, country, album, gid, duration, seconds)

  setwd(mydatadir)

  save(fls_tags, file = "fls_tags.rda")

  save(fls_tags_show, file = "fls_tags_show.rda")

  setwd(mydir)


  # Select the most relevant columns -------

  Repeatr1 <- subset(Repeatr0, select = -c(V2, V4, V5, V6, V7, V8, V9))

  names(Repeatr1)

  # Define gig id -----------------------------------------------------------

  names(Repeatr1)[names(Repeatr1) == "V1"] <- "gid"


  # Define date variables ----------------------------------------------------

  names(Repeatr1)[names(Repeatr1) == "V3"] <- "date"

  Repeatr1 <- Repeatr1 %>%
    mutate(date = as.Date(date, "%d/%m/%Y"))

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
                              , varying = 6:44
                              , idvar = "gid"
  )

  # Define song number ------------------------------------------------------

  names(Repeatr1)[names(Repeatr1) == "time"] <- "song_number"

  Repeatr1 <- Repeatr1 %>%
    arrange(gid, song_number)

  Repeatr1 <- Repeatr1 %>%
    mutate(song = str_to_lower(song))

  Repeatr1$nchar <- nchar(Repeatr1$song)

  Repeatr1 <- Repeatr1 %>%
    filter(nchar>0)

  Repeatr1$nchar <- NULL

  # add on outros

  Repeatr1_outro <- fls_tags %>%
    filter(song=="outro") %>%
    select(gid, date, track, song) %>%
    rename(song_number = track) %>%
    mutate(song_number = as.numeric(song_number))

  Repeatr1_outro <- Repeatr1_outro %>%
    mutate(date = as.Date(date, "%d/%m/%Y"))

  Repeatr1_outro <- Repeatr1_outro %>%
    mutate(year = year(date)) %>%
    relocate(year, .after=date)

  Repeatr1_outro <- Repeatr1_outro %>%
    mutate(month = month(date)) %>%
    relocate(month, .after=year)

  Repeatr1_outro <- Repeatr1_outro %>%
    mutate(day = day(date)) %>%
    relocate(day, .after=month)

  Repeatr1 <- rbind.data.frame(Repeatr1, Repeatr1_outro)

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
    mutate(song = ifelse(song=="promises bit soundcheck", "promises", song))

  Repeatr1 <- Repeatr1 %>%
    mutate(song = ifelse(song=="promises coda", "promises", song))

  Repeatr1 <- Repeatr1 %>%
    mutate(song = ifelse(song=="provisional medley", "provisional", song))

  Repeatr1 <- Repeatr1 %>%
    mutate(song = ifelse(song=="the argument", "argument", song))


  # define track types: intros, interludes, sound checks -----------------------------------------------------------------

  Repeatr1$tracktype <- 1

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("interlude", song)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("encore", song)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("intro", song)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("track", song)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("remarks", song)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("ice cream", song)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("outside", song)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("sound check", song)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("soundcheck", song)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("crowd", song)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("outro", song)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("untitled", song)==TRUE, 0, tracktype))

  # Filter to remove unreleased songs or improvised one-offs ---------------------------------------

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("heart on my chest", song)==TRUE, 2, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("lock dug", song)==TRUE, 2, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("nedcars", song)==TRUE, 2, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("noisy dub", song)==TRUE, 2, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("nsa", song)==TRUE, 2, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("set the charges", song)==TRUE, 2, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("she is blind", song)==TRUE, 2, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("surf tune", song)==TRUE, 2, tracktype))

  # Summarise the data to check frequency counts for all songs --------------

  mycount <- Repeatr1 %>%
    filter(tracktype==1) %>%
    group_by(song) %>%
    summarise(count= n()) %>%
    ungroup()

  mycount <- mycount %>%
    arrange((song))

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

  Repeatr1a <- Repeatr1 %>%
    filter(tracktype==1) %>%
    group_by(gid) %>%
    mutate(song_number = row_number()) %>%
    ungroup()

  Repeatr1a <- Repeatr1a %>%
    mutate(first_song = ifelse(song_number==1, 1, 0))

  Repeatr1a <- Repeatr1a %>%
    group_by(gid) %>%
    mutate(number_songs = n()) %>%
    mutate(last_song = ifelse(song_number==number_songs, 1, 0)) %>%
    ungroup()

  Repeatr1a <- Repeatr1a %>%
    select(gid, song, number_songs, first_song, last_song)

  Repeatr1b <- Repeatr1a %>%
    group_by(gid) %>%
    slice(1) %>%
    select(gid, number_songs) %>%
    ungroup()

  Repeatr1a <- Repeatr1a %>%
    select(-number_songs)

  Repeatr1 <- Repeatr1 %>%
    left_join(Repeatr1b)

  Repeatr1 <- Repeatr1 %>%
    left_join(Repeatr1a)

  Repeatr1 <- Repeatr1 %>%
    left_join(songidlookup)


  # add additional variables for potential use in the choice modelling
  songvarslookup <- songvarslookup %>% select(songid, releaseid, track_number, instrumental, vocals_picciotto, vocals_mackaye, vocals_lally, duration_seconds)

  Repeatr1 <- Repeatr1 %>%
    left_join(songvarslookup)

  Repeatr1 <- Repeatr1 %>% left_join(releasesdatalookup)

  # Save disaggregate data -----------------------------------

  Repeatr1 <- Repeatr1 %>%
    select(gid, date, year, month, day, tracktype, song_number, songid, song, number_songs, first_song, last_song, releaseid,	release, track_number, instrumental,	vocals_picciotto,	vocals_mackaye,	vocals_lally,	duration_seconds) %>%
    arrange(date, song_number)

  # remove duplicates

  Repeatr1 <- Repeatr1 %>%
    group_by(gid, song_number) %>%
    slice(1) %>%
    ungroup()

  setwd(mydatadir)

  save(Repeatr1, file = "Repeatr1.rda")

  setwd(mydir)


# calculate cumulative rendition counts -----------------------------------


  mydf <- Repeatr1 %>%
    filter(tracktype==1) %>%
    select(date, song)

  mydf <- mydf %>%
    group_by(date, song) %>%
    summarize(count=n()) %>%
    ungroup()

  mydf_wide <- mydf %>%
    pivot_wider(names_from = song, values_from = count, values_fill = 0)

  mydf_wide2 <- mydf_wide

  number_columns <- ncol(mydf_wide2)

  for(colindex in 2:number_columns) {

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

  cumulative_song_counts <- cumulative_song_counts %>%
    mutate(release = tolower(release)) %>%
    left_join(releasesdatalookup) %>%
    select(date, song, release, count, releasedate)

  setwd(mydatadir)

  save(cumulative_song_counts, file = "cumulative_song_counts.rda")

  setwd(mydir)


  # calculate cumulative duration counts -----------------------------------

  song_songid <- Repeatr1 %>%
    filter(tracktype==1) %>%
    group_by(song, songid) %>%
    slice(1) %>%
    select(song, songid) %>%
    ungroup()

  mydf <- fls_tags %>%
    select(song, seconds) %>%
    mutate(minutes = round(seconds/60, digits = 2)) %>%
    select(-seconds) %>%
    left_join(song_songid) %>%
    filter(is.na(songid)==FALSE) %>%
    select(-songid)

  mydf <- mydf %>%
    group_by(minutes, song) %>%
    summarize(count=n()) %>% ungroup()

  mydf_wide <- mydf %>%
    pivot_wider(names_from = song, values_from = count, values_fill = 0)

  mydf_wide2 <- mydf_wide

  number_columns <- ncol(mydf_wide2)

  for(colindex in 2:number_columns) {

    mydf_wide2[,colindex] <- cumsum(mydf_wide2[,colindex])

  }

  mydf_long <- mydf_wide2 %>%
    pivot_longer(!minutes, names_to = "song", values_to = "count") %>%
    filter(count>0)

  releases_lookup <- Repeatr1 %>%
    group_by(song, release) %>%
    summarize(count = n()) %>%
    ungroup() %>%
    select(song, release) %>%
    filter(song!="crowd")

  mydf_long <- mydf_long %>%
    left_join(releases_lookup)

  cumulative_duration_counts <- mydf_long %>%
    select(minutes, song, release, count) %>%
    mutate(release = ifelse(is.na(release)==TRUE, "unreleased", release))

  setwd(mydatadir)

  save(cumulative_duration_counts, file = "cumulative_duration_counts.rda")

  setwd(mydir)

  # calculate duration summary -----------------------------------

  song_songid <- Repeatr1 %>%
    filter(tracktype==1) %>%
    group_by(song, songid) %>%
    slice(1) %>%
    select(song, songid) %>%
    ungroup() %>%
    filter(song!="crowd")

  duration_summary <- fls_tags %>%
    group_by(song) %>%
    summarize(renditions = n(),
              minutes_min = round(min(seconds)/60, digits = 2),
              minutes_median = round(median(seconds)/60, digits = 2),
              minutes_max = round(max(seconds)/60, digits = 2),
              minutes_mean = round(mean(seconds)/60, digits = 2),
              minutes_sd = round(sd(seconds)/60, digits = 2)) %>%
    ungroup() %>%
    left_join(song_songid) %>%
    filter(is.na(songid)==FALSE) %>%
    select(-songid)

    duration_summary <- duration_summary %>%
      mutate(minutes_total = round(renditions*minutes_mean, digits = 2))

    setwd(mydatadir)

    save(duration_summary, file = "duration_summary.rda")

    setwd(mydir)


# Played with data --------------------------------------------------------

    played_with_file <- system.file("extdata", "gid_fls_id_played_with.csv", package = "Repeatr")
    played_with <- read.csv(played_with_file)

    played_with <- played_with %>%
      mutate_if(is.character, utf8::utf8_encode)

    played_with <- played_with %>%
      mutate(played_with = ifelse(gid=="bielefeld-germany-103188", "Pygmies", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(gid=="rome-italy-102790", "Ratos de Porão", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(gid=="ann-arbor-mi-usa-62390", "Ward, Phünhögg", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(gid=="bergara-spainbasque-101099", "Half Foot Outside, Lisabö", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(gid=="jawbone-canyon-ca-usa-90691", "Pop Defect, Sandy Duncan’s Eye, The Paper Tulips, The Offspring, The Fumes, This Great Religion, TVTV$", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(gid=="washington-dc-usa-101589", "Fidelity Jones, Tiik, Lungfish, Juliana Experience, Weatherhead, Moss Icon, Dog Born Society, Choke, Cabal, All White Jury, Daryl Stover, Caroline Ely, 200 Stitches, Transilience, Neverman", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(gid=="belo-horizonte-brazil-81594", "Stigmata, Jorge Cabeleira, Daizy Down, Oz, Intense Manner of Living, Virna Lisi", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(gid=="winnipeg-mb-canada-81491", "Carpe Diem, Propagandhi", played_with))

    played_with<-played_with %>%
      separate_rows(played_with, sep=",")

    played_with<-played_with %>%
      separate_rows(played_with, sep="&amp;")

    played_with<-played_with %>%
      separate_rows(played_with, sep="amp;")

    played_with <- played_with %>%
      mutate(played_with = str_trim(played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Shudder To Think", "Shudder to Think", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Adventures of Immortality", "Adventures In Immortality", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Assault Frontali", "Assalti Frontali", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Assaulti Frontali", "Assalti Frontali", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Darkness At Noon", "Darkness at Noon", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Dirty Districts", "Dirty District", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Genbaku Onanisu", "Genbaku Onanies", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="God Is My Co-Pulot", "God Is My Co-Pilot", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Metamatix", "Metamatics", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Missonarios", "Missionarios", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Nation Of Ulysses", "Nation of Ulysses", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Sandy Duncan's Eye", "Sandy Duncan’s Eye", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Seven Souix", "Seven Sioux", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Thatcher On Acid", "Thatcher on Acid", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Vampire Lesbos", "Vampire Lezbos", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Int. Noise Conspiracy", "The International Noise Conspiracy", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Victim s Family", "Victim's Family", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Offspring", "The Offspring", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Boom", "The Boom", played_with))

    played_with <- played_with %>%
      filter(played_with!="?")

    played_with <- played_with %>%
      group_by(gid, fls_id, played_with) %>%
      summarize(count = n()) %>%
      ungroup()

    played_with <- played_with %>%
      select(gid, fls_id, played_with)

    played_with <- played_with %>%
      arrange(fls_id, played_with)

    setwd(mydatadir)

    save(played_with, file = "played_with.rda")

    setwd(mydir)

# prepare input data for Fugazetteer --------------------------------------

    setwd(mydatadir)

    releaseid_variable_colour_code <- releasesdatalookup %>%
      select(releaseid, variable, colour_code)

    save(releaseid_variable_colour_code, file = "releaseid_variable_colour_code.rda")

    transitions_data_da1 <- Repeatr1 %>%
      filter(tracktype==1) %>%
      select(gid,date,song_number,song) %>%
      rename(song1 = song)

    transitions_data_da2 <- Repeatr1 %>%
      filter(tracktype==1) %>%
      select(gid,date,song_number,song) %>%
      mutate(song_number = song_number-1) %>%
      rename(song2 = song)

    transitions_data_da <- transitions_data_da1 %>%
      left_join(transitions_data_da2) %>%
      filter(is.na(song2)==FALSE) %>%
      rename(transition = song_number) %>%
      mutate(url = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
      mutate(fls_link = paste0("<a href='",  url, "' target='_blank'>", gid, "</a>")) %>%
      select(gid, url, fls_link, date, transition, song1, song2) %>%
      mutate(transition = as.integer(transition))

    transitions_data_da$date <- format(transitions_data_da$date,'%Y-%m-%d')

    save(transitions_data_da, file = "transitions_data_da.rda")

    rm(transitions_data_da1, transitions_data_da2)

    show_sequence <- Repeatr1 %>%
      group_by(date) %>%
      summarize(songs = n()) %>%
      ungroup() %>%
      arrange(date) %>%
      mutate(show_num = row_number(),
             last_show = max(show_num))

    releases_menu_list <- releasesdatalookup %>%
      arrange(releaseid) %>%
      filter(releaseid!=12 & releaseid!=14 & releaseid!=15)

    save(releases_menu_list, file = "releases_menu_list.rda")

    colour_code <- releasesdatalookup %>%
      arrange(releaseid) %>%
      filter(releaseid>0) %>%
      select(releaseid, colour_code)

    releases_data_input <- Repeatr1 %>%
      left_join(show_sequence) %>%
      left_join(colour_code) %>%
      group_by(releaseid, release, track_number, song, last_show, colour_code) %>%
      summarize(count = n(),
                date=min(date),
                show_num = min(show_num)) %>%
      ungroup()

    releases_data_input <- releases_data_input %>%
      arrange(desc(releaseid), desc(track_number)) %>%
      mutate(song = factor(song, levels=unique(song))) %>%
      mutate(release = factor(release, levels=rev(unique(release)))) %>%
      mutate(shows = last_show-show_num+1,
             intensity = round(count / shows, digits=4)) %>%
      filter(releaseid>0)

    save(releases_data_input, file = "releases_data_input.rda")

    releases_summary <- releases_data_input %>%
      group_by(releaseid, release, last_show) %>%
      summarize(count = sum(count),
                songs=n(),
                first_debut=min(date),
                last_debut=max(date),
                first_show = min(show_num),
                shows = round(mean(shows), digits=0),
                intensity = round(mean(intensity), digits = 4)) %>%
      ungroup()

    releasesdatalookup <- releasesdatalookup %>%
      select(releaseid, releasedate) %>%
      mutate(releasedate = as.Date(releasedate, "%d/%m/%Y", origin = "1970-01-01"))

    releases_summary <- releases_summary %>%
      left_join(releasesdatalookup) %>%
      select(releaseid, release, first_debut, last_debut, releasedate, songs, count, shows, intensity) %>%
      rename(release_date = releasedate) %>%
      filter(releaseid>0)

    save(releases_summary, file = "releases_summary.rda")

    gid_minutes <- fls_tags_show %>%
      select(gid, seconds) %>%
      mutate(minutes = round(seconds/60, digits = 2)) %>%
      select(-seconds)

    gid_song_minutes <- fls_tags %>%
      mutate(minutes = round(seconds/60, digits = 2)) %>%
      select(gid, song, minutes)

    checkmatch <- Repeatr1 %>%
      full_join(gid_song_minutes) %>%
      filter(is.na(minutes)==TRUE | is.na(year)==TRUE) %>%
      arrange(date, song_number)

    tour_lookup <- othervariables %>% select(gid, tour) %>%
      group_by(gid) %>%
      slice(1) %>%
      ungroup()

    shows_data <- othervariables %>%
      filter(is.na(attendance)==FALSE) %>%
      filter(is.na(tour)==FALSE) %>%
      mutate(attendance = as.integer(attendance)) %>%
      mutate(date = as.Date(date, "%d-%m-%Y")) %>%
      mutate(year = lubridate::year(date)) %>%
      rename(latitude = y) %>%
      rename(longitude = x) %>%
      select(gid, tour, year, date, venue, city, country, attendance, doorprice, latitude, longitude) %>%
      rename(door_price = doorprice) %>%
      mutate(urls = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
      mutate(fls_link = paste0("<a href='",  urls, "' target='_blank'>", gid, "</a>")) %>%
      left_join(gid_minutes) %>%
      left_join(gid_sound_quality)

    save(shows_data, file = "shows_data.rda")

    last_performance_data <- Repeatr1 %>%
      filter(tracktype==1) %>%
      select(date, song)%>%
      group_by(song) %>%
      summarize(last_performance=max(date)) %>%
      ungroup()

    save(last_performance_data, file = "last_performance_data.rda")

    xray <- Repeatr1 %>%
      left_join(tour_lookup)

    xray <- xray %>%
      left_join(releasesdatalookup)

    xray <- xray %>%
      mutate(releasedate = as.Date(releasedate, "%d/%m/%Y", origin = "1970-01-01"))

    xray <- xray %>%
      mutate(unreleased = ifelse(tracktype==2 | (tracktype==1 & date<releasedate) | song=="preprovisional" | song=="world beat",1,0))

    xray2 <- Repeatr::summary %>%
      select(songid, launchdate)

    xray <- xray %>%
      left_join(xray2)

    xray <- xray %>%
      mutate(debut = ifelse(date==launchdate,1,0)) %>%
      mutate(debut = ifelse(is.na(debut)==TRUE,0,debut))

    xray <- xray %>%
      left_join(last_performance_data)

    xray <- xray %>%
      mutate(last_performance=ifelse(date==last_performance,1,0)) %>%
      mutate(last_performance = ifelse(is.na(last_performance)==TRUE,0,last_performance))

    xray <- xray %>%
      left_join(gid_song_minutes)

    # remove tracks from front-end data that were not actually included in the MP3 download

    xray <- xray %>%
      filter(gid!="washington-dc-usa-80793" | tracktype!=0 | is.na(minutes)==FALSE)

    xray <- xray %>%
      mutate(track = 1,
             songtrack = ifelse(tracktype==1, 1, 0))

    xray <- xray %>%
      mutate(release = ifelse(is.na(release)==TRUE, "other", release))

    xray_tracks <- xray %>%
      mutate(units = "tracks") %>%
      mutate(year = lubridate::year(date)) %>%
      mutate(fugazi = ifelse(release=="fugazi",1,0),
             margin_walker = ifelse(release=="margin walker",1,0),
             three_songs = ifelse(release=="3 songs",1,0),
             repeater = ifelse(release=="repeater",1,0),
             steady_diet_of_nothing = ifelse(release=="steady diet of nothing",1,0),
             in_on_the_killtaker = ifelse(release=="in on the killtaker",1,0),
             red_medicine = ifelse(release=="red medicine",1,0),
             end_hits = ifelse(release=="end hits",1,0),
             the_argument = ifelse(release=="the argument",1,0),
             furniture = ifelse(release=="furniture",1,0),
             first_demo = ifelse(release=="first demo",1,0),
             other = ifelse(release=="other",1,0),
             unreleased = ifelse(unreleased==1,1,0),
             songs = ifelse(songtrack==1,1,0))


    xray_tracks <- xray_tracks %>%
      group_by(gid, date, year, tour, units) %>%
      summarize(unreleased = sum(unreleased),
                debut = sum(debut),
                farewell = sum(last_performance),
                fugazi = sum(fugazi),
                margin_walker = sum(margin_walker),
                three_songs = sum(three_songs),
                repeater = sum(repeater),
                steady_diet_of_nothing = sum(steady_diet_of_nothing),
                in_on_the_killtaker = sum(in_on_the_killtaker),
                red_medicine = sum(red_medicine),
                end_hits = sum(end_hits),
                the_argument = sum(the_argument),
                furniture = sum(furniture),
                first_demo = sum(first_demo),
                other = sum(other),
                unreleased = sum(unreleased),
                songs = sum(songs)) %>%
      arrange(date) %>%
      ungroup()



    xray_minutes <- xray %>%
      mutate(units = "minutes") %>%
      mutate(year = lubridate::year(date)) %>%
      mutate(fugazi = ifelse(release=="fugazi",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             margin_walker = ifelse(release=="margin walker",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             three_songs = ifelse(release=="3 songs",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             repeater = ifelse(release=="repeater",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             steady_diet_of_nothing = ifelse(release=="steady diet of nothing",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             in_on_the_killtaker = ifelse(release=="in on the killtaker",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             red_medicine = ifelse(release=="red medicine",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             end_hits = ifelse(release=="end hits",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             the_argument = ifelse(release=="the argument",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             furniture = ifelse(release=="furniture",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             first_demo = ifelse(release=="first demo",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             other = ifelse(release=="other",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             unreleased = ifelse(unreleased==1,ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             songs = ifelse(songtrack==1,ifelse(is.na(minutes)==TRUE, 0, minutes),0))

    xray_minutes <- xray_minutes %>%
      group_by(gid, date, year, tour, units) %>%
      summarize(unreleased = sum(unreleased),
                debut = sum(debut),
                farewell = sum(last_performance),
                fugazi = sum(fugazi),
                margin_walker = sum(margin_walker),
                three_songs = sum(three_songs),
                repeater = sum(repeater),
                steady_diet_of_nothing = sum(steady_diet_of_nothing),
                in_on_the_killtaker = sum(in_on_the_killtaker),
                red_medicine = sum(red_medicine),
                end_hits = sum(end_hits),
                the_argument = sum(the_argument),
                furniture = sum(furniture),
                first_demo = sum(first_demo),
                other = sum(other),
                unreleased = sum(unreleased),
                songs = sum(songs)) %>%
      arrange(date) %>%
      ungroup()

    xray <- rbind.data.frame(xray_tracks, xray_minutes)

    xray <- xray %>%
      arrange(units, date)

    xray <- xray %>%
      mutate(released = songs - unreleased,
             incumbent = songs - debut - farewell)

    xray <- xray %>%
      mutate(url = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
      mutate(fls_link = paste0("<a href='",  url, "' target='_blank'>", gid, "</a>"))

    xray <- xray %>%
      relocate(gid, url, fls_link, year, tour, date, units, songs, released, unreleased, other, debut, farewell, incumbent, other)

    rm(xray_minutes, xray_tracks, xray2)

    save(xray, file = "xray.rda")

    duration_data_da <- Repeatr1 %>%
      filter(tracktype==1) %>%
      select(gid,date, song_number, song) %>%
      mutate(urls = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
      mutate(fls_link = paste0("<a href='",  urls, "' target='_blank'>", gid, "</a>")) %>%
      left_join(gid_song_minutes)

    # need to knock out a few fake duplicates caused by the match not being done on all the required variables

    duration_data_da <- duration_data_da %>%
      filter(gid!="annapolis-md-usa-20688" | song_number!=13 | minutes!=1.57) %>%
      filter(gid!="annapolis-md-usa-20688" | song_number!=16 | minutes!=1.48)

    duration_data_da <- duration_data_da %>%
      filter(gid!="canberra-australia-111793" | song_number!=5 | minutes!=1.88) %>%
      filter(gid!="canberra-australia-111793" | song_number!=7 | minutes!=2.93)

    duration_data_da <- duration_data_da %>%
      filter(gid!="peoria-il-usa-100995" | song_number!=12 | minutes!=2.75) %>%
      filter(gid!="peoria-il-usa-100995" | song_number!=14 | minutes!=1.48)

    duration_data_da <- duration_data_da %>%
      filter(gid!="richmond-va-usa-51198" | song_number!=10 | minutes!=1.97) %>%
      filter(gid!="richmond-va-usa-51198" | song_number!=22 | minutes!=1.75)

    duration_data_da <- duration_data_da %>%
      filter(gid!="washington-dc-usa-73198" | song_number!=4 | minutes!=5.35) %>%
      filter(gid!="washington-dc-usa-73198" | song_number!=23 | minutes!=4.08) %>%
      filter(gid!="washington-dc-usa-73198" | song_number!=9 | minutes!=5.20) %>%
      filter(gid!="washington-dc-usa-73198" | song_number!=22 | minutes!=5.02)

    save(duration_data_da, file = "duration_data_da.rda")

    othervariables <- othervariables %>%
      left_join(gid_sound_quality) %>%
      mutate(urls = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
      mutate(fls_link = paste0("<a href='",  urls, "' target='_blank'>", gid, "</a>"))

    played_with <- played_with %>%
      select(gid, played_with)

    played_with_data <- othervariables %>%
      left_join(played_with)

    played_with_data <- played_with_data %>%
      rename(latitude = y, longitude = x) %>%
      mutate(attendance = round(attendance, 0))

    played_with_data <- played_with_data %>%
      select(fls_link, year, tour, date, venue, city, country, played_with, attendance, sound_quality, latitude, longitude)

    save(played_with_data, file = "played_with_data.rda")

    played_with_summary <- played_with_data %>%
      group_by(year, tour, played_with) %>%
      summarize(shows = n()) %>%
      arrange(desc(shows)) %>%
      ungroup()

    save(played_with_summary, file = "played_with_summary.rda")

    setwd(mydir)


# finishing up ------------------------------------------------------------



  myreturnlist <- list(Repeatr0, Repeatr1, songidlookup, mycount, songvarslookup, releasesdatalookup, othervariables, cumulative_song_counts, fls_tags, fls_tags_show, cumulative_duration_counts)

  return(myreturnlist)

}


