library(dplyr)
library(stringr)
library(lubridate)
library(mlogit)
library(fastDummies)
library(rlang)
library(knitr)


# Load useful functions ---------------------------------------------------


dropr <- function(mydf,...) {

  my_return_name <- deparse(substitute(mydf))

  myinitialsize <- round(object.size(mydf)/1000000, digits = 3)
  cat(paste0("Size of ", my_return_name, " before removing variables: ", myinitialsize, " MB. \n"))

  names_to_drop <- c(...)
  mytext <- paste("The following variables will be dropped from ", my_return_name, ": ", sep = "")
  print(mytext)
  print(names_to_drop)
  mydf <- mydf[,!names(mydf) %in% names_to_drop]

  myfinalsize <- round(object.size(mydf)/1000000, digits = 3)
  cat(paste0("Size of ", my_return_name, " after removing variables: ", myfinalsize, " MB. \n"))
  ramsaved <- round(myinitialsize - myfinalsize, digits = 3)
  cat(paste0("RAM saved: ", ramsaved, " MB. \n"))

  return(mydf)

}

compressr <- function(mydf,...) {

  my_return_name <- deparse(substitute(mydf))

  myinitialsize <- round(object.size(mydf)/1000000, digits = 3)
  cat(paste0("Size of ", my_return_name, " before converting the storage modes of specified variables to integer: ", myinitialsize, " MB. \n"))


  variables_to_compress <- c(...)
  cat(paste0("The following variables will have their storage modes converted to integer, if they exist in ", my_return_name,  ": ", "\n"))
  print(variables_to_compress)

  for (var in variables_to_compress) {

    if(var %in% colnames(mydf)) {

      myparsedvar <- parse_expr(var)

      mydf <- mydf %>%
        mutate(!!myparsedvar := as.integer(!!myparsedvar))

    }

  }

  myfinalsize <- round(object.size(mydf)/1000000, digits = 3)
  cat(paste0("Size of ", my_return_name, " after converting storage mode of variables to integer: ", myfinalsize, " MB. \n"))
  ramsaved <- round(myinitialsize - myfinalsize, digits = 3)
  cat(paste0("RAM saved: ", ramsaved, " MB. \n"))

  return(mydf)

}


# This is where the work with the FLS data starts -------------------------


fugotcha <- read.csv("fugotcha.csv", header=FALSE)
saveRDS(fugotcha, "fugotcha.rds")

# Select the most relevant columns -------

mydf <- subset(fugotcha, select = -c(V2, V4, V5, V6, V7, V8, V9))

names(mydf)

# Define gig id -----------------------------------------------------------

names(mydf)[names(mydf) == "V1"] <- "gid"


# Define date variables ----------------------------------------------------

names(mydf)[names(mydf) == "V3"] <- "date"

mydf <- mydf %>%
  mutate(date = as.Date(date))

mydf <- mydf %>%
  mutate(year = year(date)) %>%
  relocate(year, .after=date)

mydf <- mydf %>%
  mutate(month = month(date)) %>%
  relocate(month, .after=year)

mydf <- mydf %>%
  mutate(day = day(date)) %>%
  relocate(day, .after=month)

# Rename variables to make reshaping the data easier ----------------------

myv <- 10

for(mysong in 1:44) {

  myinitialname <- paste0("V", myv)
  mynewname <- paste0("song.", mysong)
  names(mydf)[names(mydf) == myinitialname] <- mynewname
  myv <- myv + 1

}

mydf$nchar <- nchar(mydf$song.1)

mydf <- mydf %>%
  filter(nchar>0)

mydf$nchar <- NULL

# Reshape to long format with 1 row per song ------------------------------

mydf <- reshape(data = mydf
                            , direction = "long"
                            , varying = 6:49
                            , idvar = "gid"
)

# Define song number ------------------------------------------------------

names(mydf)[names(mydf) == "time"] <- "song_number"

mydf <- mydf %>%
  arrange(gid, song_number)

mydf$nchar <- nchar(mydf$song)

mydf <- mydf %>%
  mutate(song = str_to_lower(song))

# Recode variants of song titles to the main song title -------------------

mydf <- mydf %>%
  mutate(song = str_replace(song, " instrumental", ""))

mydf <- mydf %>%
  mutate(song = str_replace(song, " acapella", ""))

mydf <- mydf %>%
  mutate(song = str_replace(song, " drum and bass jam", ""))

mydf <- mydf %>%
  mutate(song = ifelse(song=="bed for the scraping (continued)", "bed for the scraping", song))

mydf <- mydf %>%
  mutate(song = ifelse(song=="surf tune 1", "surf tune", song))

mydf <- mydf %>%
  mutate(song = ifelse(song=="surf tune 2", "surf tune", song))

mydf <- mydf %>%
  mutate(song = ifelse(song=="surf tune 3", "surf tune", song))

mydf <- mydf %>%
  mutate(song = ifelse(song=="promises bit soundcheck", "promises", song))

mydf <- mydf %>%
  mutate(song = ifelse(song=="promises coda", "promises", song))

mydf <- mydf %>%
  mutate(song = ifelse(song=="provisional medley", "provisional", song))

mydf <- mydf %>%
  mutate(song = ifelse(song=="the argument", "argument", song))


# Filter the data to remove blank rows, intros, interludes, sound checks -----------------------------------------------------------------

mydf <- mydf %>%
  filter(nchar>0)

mydf$nchar <- NULL

mydf <- mydf %>%
  filter(!grepl("interlude",song))

mydf <- mydf %>%
  filter(!grepl("encore",song))

mydf <- mydf %>%
  filter(!grepl("intro",song))

mydf <- mydf %>%
  filter(!grepl("track",song))

mydf <- mydf %>%
  filter(!grepl("remarks",song))

mydf <- mydf %>%
  filter(!grepl("ice cream",song))

mydf <- mydf %>%
  filter(!grepl("outside",song))

mydf <- mydf %>%
  filter(!grepl("sound check",song))

mydf <- mydf %>%
  filter(!grepl("soundcheck",song))

# Filter to remove unreleased songs or improvised one-offs ---------------------------------------

mydf <- mydf %>%
  filter(song!=("heart on my chest"))

mydf <- mydf %>%
  filter(song!=("lock dug"))

mydf <- mydf %>%
  filter(song!=("nedcars"))

mydf <- mydf %>%
  filter(song!=("noisy dub"))

mydf <- mydf %>%
  filter(song!=("nsa"))

mydf <- mydf %>%
  filter(song!=("set the charges"))

mydf <- mydf %>%
  filter(song!=("she is blind"))

mydf <- mydf %>%
  filter(song!=("world beat"))

mydf <- mydf %>%
  filter(song!=("surf tune"))

mydf <- mydf %>%
  filter(song!=("preprovisional"))

# Summarise the data to check frequency counts for all songs --------------

mycount <- mydf %>%
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

mydf <- mydf %>%
  arrange(gid, song_number)

mydf <- mydf %>%
  group_by(gid) %>%
  mutate(song_number = row_number())

mydf <- mydf %>%
  mutate(first_song = ifelse(song_number==1, 1, 0))

mydf <- mydf %>%
  group_by(gid) %>%
  mutate(number_songs = n()) %>%
  mutate(last_song = ifelse(song_number==number_songs, 1, 0)) %>%
  ungroup()


# Add dummy variable for each song to the disaggregate data --------------

mydf <- mydf %>% arrange(date, song_number)

for(mysongid in 1:92) {

  myvarname <- paste0("song.", mysongid)
  mysongname <- as.character(mysongidlookup[mysongid,2])
  mydf <- mydf %>% mutate(!!myvarname := ifelse(song == mysongname,1,0))

}

for(mysongid in 1:92) {

  mysongvar <- rlang::sym(paste0("song.", mysongid))
  myavailablevarname <- paste0("available.", mysongid)
  mydf <- mydf %>% mutate(!!myavailablevarname := ifelse(cumsum(!!mysongvar)>=1,1,0))

}

for(mysongid in 1:92) {

  mysongvar <- rlang::sym(paste0("song.", mysongid))
  myplayedvarname <- paste0("played.", mysongid)
  mydf <- mydf %>%
    group_by(gid) %>%
    mutate(!!myplayedvarname := ifelse(cumsum(!!mysongvar)>=1,1,0)) %>%
    ungroup()

}

# Reshape to long again so that there will now be one row per combination of song performed and song potentially available ------------------------------

mydf2 <- mydf
mydf2$song <- NULL
mydf2$nchar <- NULL

mydf2 <- reshape(data = mydf2
                , direction = "long"
                , varying = 10:285
                , idvar = c("gid", "song_number")
)

mydf2 <- mydf2 %>% rename(songid = time)
mydf2 <- mydf2 %>% rename(chosen = song)
mydf2 <- mydf2 %>% arrange(date, year, month, day, song_number, songid)

# available_rl is repertoire-level availability: is the song available in the repertoire?  It is considered available at the repertoire level from the time of its first performance in this data onwards.
mydf2 <- mydf2 %>% rename(available_rl = available)

# Summarise the long data to check frequency counts for all songs --------------

# summarise the data at gig level
mycount2_gl <- mydf2 %>%
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
mycount <- mycount %>%
  left_join(mylaunchdatelookup) %>%
  select(songid, song, launchdate, count)

knitr::kable(mycount, "pipe")

write.csv(mycount, "fugazi_song_counts.csv")



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

mycount2_sl <- mycount2_sl %>%
  select(songid, song, launchdate, chosen, available_rl, intensity)

knitr::kable(mycount2_sl, "pipe")

write.csv(mycount2_sl, "fugazi_song_performance_intensity.csv")

# merge on repertoire-level availability
mydf2$available_rl <- NULL
mydf2 <- mydf2 %>% left_join(available_rl_lookup)

# available_gl is gig-level availability.  A song is considered available at the gig level if it is available in the repertoire and it has not already been played.
mydf2 <- mydf2 %>% mutate(available_gl=ifelse((played==1 & chosen==0),0,available_rl))
mydf2 <- mydf2 %>% left_join(mysongidlookup)
mydf2 <- mydf2 %>% select(gid, date, song_number, songid, song, chosen, played, available_rl, available_gl, first_song, last_song)
mydf2 <- mydf2 %>% arrange(date, gid, song_number, songid)

# Merge on the launch date of each song and calculate how many years old each song is at the time of each gig
mydf2 <- mydf2 %>% left_join(mylaunchdatelookup)
mydf2 <- mydf2 %>% relocate(launchdate, .after=date)
mydf2 <- mydf2 %>% mutate(yearsold = ifelse(available_rl==1,as.duration(launchdate %--% date) / dyears(1),0))
mydf2 <- mydf2 %>% relocate(yearsold, .after=launchdate)

# Remove records for unavailable songs

mydf2 <- mydf2 %>% filter(available_gl==1)

# Choice modelling with multinomial logit

# define case variable and add it to the data

mycaseidlookup <- mydf %>%
  group_by(gid, song_number) %>%
  summarise(records = n(), date=min(date)) %>%
  arrange(date, song_number) %>%
  select(gid, song_number) %>%
  ungroup()

mycaseidlookup <- mycaseidlookup %>%
  mutate(case = row_number())

saveRDS(mycaseidlookup, "mycaseidlookup.rds")

mydf2 <- mydf2 %>%
  left_join(mycaseidlookup) %>%
  relocate(case)

# add additional variables for potential use in the choice modelling
mydf3 <- read.csv("releases_songs_durations_wikipedia.csv")
mysongvarslookup <- mydf3 %>% select(songid, instrumental, vocals_picciotto, vocals_mackaye, vocals_lally, duration_seconds)

mydf2 <- mydf2 %>%
  left_join(mysongvarslookup)

write.csv(mysongvarslookup, "mysongvarslookup.csv")

mydf2 <- mydf2 %>% rename(alt = songid)
mydf2 <- mydf2 %>% rename(choice = chosen)

mydf2 <- mydf2 %>%
  mutate(year = year(date)) %>%
  relocate(year, .after=date)

mydf2 <- mydf2 %>%
  mutate(first_song_instrumental = first_song*instrumental)

# Save disaggregate data -----------------------------------

Repeatr_wide <- mydf %>% select(gid, date, year, month, day, song_number, song, first_song, number_songs, last_song)
Repeatr_long <- mydf2
save(Repeatr_wide, Repeatr_long, file = "data.RData", compress = "xz")
rm(mydf, mydf2)

# Keep only the specific variables needed for the modelling --------

Repeatr_sc <- Repeatr_long %>%
  select(case, alt, choice, yearsold, vocals_mackaye, vocals_picciotto, vocals_lally, instrumental, first_song, last_song, duration_seconds)

Repeatr_sc <- Repeatr_sc %>%
  mutate(yearsold = case_when(
    yearsold >= 0 & yearsold < 1  ~ 0L,
    yearsold >= 1 & yearsold < 2  ~ 1L,
    yearsold >= 2 & yearsold < 3  ~ 2L,
    yearsold >= 3 & yearsold < 4  ~ 3L,
    yearsold >= 4 & yearsold < 5  ~ 4L,
    yearsold >= 5 & yearsold < 6  ~ 5L,
    yearsold >= 6 & yearsold < 7  ~ 6L,
    yearsold >= 7 & yearsold < 8  ~ 7L,
    yearsold >= 8  ~ 8L,
    TRUE ~ 9L
    )
  )

Repeatr_sc <- dummy_cols(Repeatr_sc, select_columns = "yearsold")

Repeatr_sc <- Repeatr_sc %>%
  mutate(yearsold_1_vp = yearsold_1*vocals_picciotto) %>%
  mutate(yearsold_2_vp = yearsold_2*vocals_picciotto) %>%
  mutate(yearsold_3_vp = yearsold_3*vocals_picciotto) %>%
  mutate(yearsold_4_vp = yearsold_4*vocals_picciotto) %>%
  mutate(yearsold_5_vp = yearsold_5*vocals_picciotto) %>%
  mutate(yearsold_6_vp = yearsold_6*vocals_picciotto) %>%
  mutate(yearsold_7_vp = yearsold_7*vocals_picciotto) %>%
  mutate(yearsold_8_vp = yearsold_8*vocals_picciotto)

Repeatr_sc <- Repeatr_sc %>%
  mutate(first_song_instrumental = first_song*instrumental)

# compress the data by converting variables to integers --------

mycompressrvars <- scan(text="vocals_mackaye vocals_picciotto vocals_lally instrumental songnumberone first_song_instrumental duration_seconds yearsold yearsold_1 yearsold_2 yearsold_3 yearsold_4 yearsold_5 yearsold_6 yearsold_7 yearsold_8 yearsold_1_vp yearsold_2_vp yearsold_3_vp yearsold_4_vp yearsold_5_vp yearsold_6_vp yearsold_7_vp yearsold_8_vp", what="")
Repeatr_sc <- compressr(Repeatr_sc, mycompressrvars)

Repeatr_sc$case <- factor(as.numeric(as.factor(Repeatr_sc$case)))
Repeatr_sc$alt <- as.factor(Repeatr_sc$alt)
Repeatr_sc$choice <- as.logical(Repeatr_sc$choice)
Repeatr_sc <- dfidx(Repeatr_sc, idx = c("case", "alt"), drop.index = FALSE)

checksongcounts <- Repeatr_sc %>% group_by(alt) %>% summarise(count = sum(choice)) %>% ungroup()
checksongcounts

save(Repeatr_wide, Repeatr_long, Repeatr_sc, file = "data.RData", compress = "xz")

gc()

# Choice modelling --------------------------------

# The basic model.

ml.Repeatr_sc1 <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5
                  + yearsold_6 + yearsold_7 + yearsold_8 , data = Repeatr_sc)

summary.ml.Repeatr_sc1 <- summary(ml.Repeatr_sc1)

summary.ml.Repeatr_sc1

# A more detailed model that includes first song instrumental effect and potential differences between the preferences of Ian MacKaye and Guy Picciotto regarding the age of their songs.

ml.Repeatr_sc2 <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5
                 + yearsold_6 + yearsold_7 + yearsold_8 + yearsold_1_vp + yearsold_2_vp + yearsold_3_vp + yearsold_4_vp + yearsold_5_vp + yearsold_6_vp + yearsold_7_vp + yearsold_8_vp + first_song_instrumental, data = Repeatr_sc)

summary.ml.Repeatr_sc2 <- summary(ml.Repeatr_sc2)

summary.ml.Repeatr_sc2

# First song model ---------------------------------------------------

Repeatr_sc_fs <- Repeatr_sc %>%
  filter(first_song==1)

Repeatr_sc_fs_counts <- Repeatr_sc_fs %>%
  filter(choice==TRUE) %>%
  group_by(alt) %>%
  summarise(chosen=n()) %>%
  mutate(songid=as.integer(alt)) %>%
  ungroup()

Repeatr_sc_fs_counts <- Repeatr_sc_fs_counts %>%
  left_join(mysongidlookup) %>%
  select(alt, song, chosen)

Repeatr_sc_fs <- Repeatr_sc_fs %>%
  left_join(Repeatr_sc_sno_counts)

Repeatr_sc_fs <- Repeatr_sc_fs %>%
  mutate(yearsold_3 = yearsold_3 + yearsold_4 + yearsold_5 + yearsold_6 + yearsold_7 + yearsold_8)

# It is necessary to remove the alternatives that were never chosen as the first song

Repeatr_sc_fs <- Repeatr_sc_fs %>%
  filter(is.na(chosen)==FALSE)

ml.Repeatr_sc3 <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3, data = Repeatr_sc_fs)

summary.ml.Repeatr_sc3 <- summary(ml.Repeatr_sc3)

summary.ml.Repeatr_sc3

# Last song model ---------------------------------------------------

Repeatr_sc_ls <- Repeatr_sc %>%
  filter(last_song==1)

Repeatr_sc_ls_counts <- Repeatr_sc_ls %>%
  filter(choice==TRUE) %>%
  group_by(alt) %>%
  summarise(chosen=n()) %>%
  mutate(songid=as.integer(alt)) %>%
  ungroup()

Repeatr_sc_ls_counts <- Repeatr_sc_ls_counts %>%
  left_join(mysongidlookup) %>%
  select(alt, song, chosen)

Repeatr_sc_ls <- Repeatr_sc_ls %>%
  left_join(Repeatr_sc_ls_counts)

# It is necessary to remove the alternatives that were never chosen as the last song

Repeatr_sc_ls <- Repeatr_sc_ls %>%
  filter(is.na(chosen)==FALSE)

ml.Repeatr_sc4 <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5 + yearsold_6 + yearsold_7 + yearsold_8, data = Repeatr_sc_ls)

summary.ml.Repeatr_sc4 <- summary(ml.Repeatr_sc4)

summary.ml.Repeatr_sc4

# intermediate song model, the idea being to model the two main vocalists taking turns to sing

Repeatr_sc_is <- Repeatr_sc %>%
  mutate(lag_vocals_mackaye = lag(vocals_mackaye, n=1L)) %>%
  mutate(lag_vocals_picciotto = lag(vocals_mackaye, n=1L)) %>%
  mutate(vp_lag_vocals_mackaye = vocals_picciotto*lag_vocals_mackaye) %>%
  mutate(vm_lag_vocals_picciotto = vocals_mackaye*lag_vocals_picciotto)

Repeatr_sc_is <- Repeatr_sc_is %>%
  filter(first_song!=1 & last_song!=1)

ml.Repeatr_sc5 <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5
                         + yearsold_6 + yearsold_7 + yearsold_8 + yearsold_1_vp + yearsold_2_vp + yearsold_3_vp + yearsold_4_vp + yearsold_5_vp + yearsold_6_vp + yearsold_7_vp + yearsold_8_vp + vp_lag_vocals_mackaye + vm_lag_vocals_picciotto, data = Repeatr_sc_is)


summary.ml.Repeatr_sc5 <- summary(ml.Repeatr_sc5)

summary.ml.Repeatr_sc5

# save choice models
save(Repeatr_wide, Repeatr_long, Repeatr_sc, ml.Repeatr_sc1, ml.Repeatr_sc2, ml.Repeatr_sc3, ml.Repeatr_sc4, file = "data.RData", compress = "xz")

# Report results of the choice modelling for the preferred choice model ----------------------------------

results.ml.sc6 <- as.data.frame(summary.ml.sc6[["CoefTable"]])

results.ml.sc6 <- results.ml.sc6 %>%
  mutate(parameter_id = row_number()) %>%
  relocate(parameter_id)

variable <- row.names(results.ml.sc6)

choice_model_results_table <- cbind(variable, results.ml.sc6)

choice_model_results_table <- choice_model_results_table %>%
  mutate(songid = ifelse(parameter_id<=91,parameter_id+1,NA))

choice_model_results_table <- choice_model_results_table %>%
  left_join(mysongidlookup)

choice_model_results_table <- choice_model_results_table %>%
  mutate(variable = ifelse(parameter_id<=91,song,variable))

choice_model_results_table$songid <- NULL
choice_model_results_table$song <- NULL

knitr::kable(choice_model_results_table, "pipe")

write.csv(choice_model_results_table, "fugazi_song_choice_model.csv")

results.ml.sc6 <- results.ml.sc6 %>%
  filter(parameter_id<=91)

results.ml.sc6 <- results.ml.sc6 %>%
  mutate(songid = parameter_id+1)

results.ml.sc6 <- results.ml.sc6 %>%
  left_join(mysongidlookup)

results.ml.sc6 <- results.ml.sc6 %>%
  select(songid, song, Estimate, "z-value")

# to add back in "waiting room" which was the omitted constant in the choice model and has a parameter value of zero by definition.

results.ml.sc6.os <- mysongidlookup %>%
  filter(songid==1) %>%
  mutate(Estimate = 0) %>%
  mutate("z-value" = NA)

results.ml.sc6 <- rbind(results.ml.sc6, results.ml.sc6.os)

results.ml.sc6 <- results.ml.sc6 %>%
  arrange(desc(Estimate))

write.csv(results.ml.sc6, "fugazi_song_preferences.csv")


# To produce normalised ratings on the interval [0,1] ------------------------

mydf <- read.csv("fugazi_song_preferences.csv")

mydf <- mydf %>%
  rename(rank_rating = X)

mydf <- mydf %>%
  select(rank_rating, songid, song, Estimate)

mymin <- min(mydf$Estimate)

mydf <- mydf %>%
  mutate(Estimate2 = Estimate - mymin)

mymax <- max(mydf$Estimate2)

mydf <- mydf %>%
  mutate(rating = Estimate2/mymax)

mydf <- mydf %>%
  select(rank_rating, songid, rating)

mydf2 <- read.csv("fugazi_song_performance_intensity.csv")

mydf2$X <- NULL

mydf2 <- mydf2 %>%
  left_join(mydf)

mydf2 <- mydf2 %>%
  arrange(desc(rating))

mydf2 <- mydf2 %>%
  relocate(rank_rating)

mydf3 <- read.csv("releases_songs_durations_wikipedia.csv")
mydf3 <- mydf3 %>% mutate(duration = seconds_to_period(duration_seconds))
mydf3 <- mydf3 %>% mutate(duration = sprintf('%02d:%02d', minute(duration), second(duration)))
mydf3 <- mydf3 %>% select(songid, duration)
write.csv(mydf3, "mysongdurationlookup.csv")

mydf2 <- mydf2 %>%
  left_join(mydf3)

mydf2 <- mydf2 %>%
  relocate(duration, .after=launchdate)

write.csv(mydf2, "summary.csv")

knitr::kable(mydf2, "pipe")


# Evaluation of releases using the song ratings ---------------------------

mydf <- read.csv("songs_releases.csv")

mydf <- mydf %>%
  group_by(release) %>%
  summarise(releaseid = mean(releaseid), releasedate=min(releasedate)) %>%
  ungroup()

mydf <- mydf %>%
  select(releaseid, release, releasedate) %>%
  arrange(releasedate)

write.csv(mydf, "releases.csv")

mydf <- read.csv("songs_releases.csv")

mydf2 <- read.csv("summary.csv")

mydf2 <- mydf2 %>%
  select(songid, song, rating)

mydf2 <- mydf2 %>%
  left_join(mydf)

mydf2 <- mydf2 %>%
  group_by(release, releaseid, releasedate) %>%
  summarise(rating = mean(rating), songs_rated = n()) %>%
  ungroup()

mydf2 <- mydf2 %>%
  arrange(desc(rating))

# remove First Demo as it is not comparable to the others.
mydf2 <- mydf2 %>%
  filter(releaseid!=11)

write.csv(mydf2, "releases_rated.csv")

mydf <- read.csv("releases_rated_rym.csv")

mydf$X <- NULL

mydf <- mydf %>%
  filter(is.na(releaseid)==FALSE)

mydf <- mydf %>%
  select(release, releaseid, releasedate, songs_rated, rating, rym_rating)

knitr::kable(mydf, "pipe")

#

