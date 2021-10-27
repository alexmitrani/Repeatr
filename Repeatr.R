library(dplyr)
library(stringr)
library(lubridate)
library(mlogit)

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
                , varying = 7:282
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

write.csv(mycount2_sl, "fugazi_song_performance_intensity.csv")

# merge on repertoire-level availability
mydf2$available_rl <- NULL
mydf2 <- mydf2 %>% left_join(available_rl_lookup)

# available_gl is gig-level availability.  A song is considered available at the gig level if it is available in the repertoire and it has not already been played.
mydf2 <- mydf2 %>% mutate(available_gl=ifelse((played==1 & chosen==0),0,available_rl))
mydf2 <- mydf2 %>% left_join(mysongidlookup)
mydf2 <- mydf2 %>% select(gid, date, song_number, songid, song, chosen, played, available_rl, available_gl)
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

mydf2 <- mydf2 %>%
  left_join(mycaseidlookup) %>%
  relocate(case)

mydf2 <- mydf2 %>% rename(alt = song)
mydf2 <- mydf2 %>% rename(choice = chosen)
sc <- mydf2 %>% select(case, alt, choice, yearsold)

# Add a set of dummy variables, one for each song, to be used as alternative-specific constants in the choice model

for(mysongid in 1:92) {
  
  myvarname <- paste0("song.", mysongid)
  mysongname <- as.character(mysongidlookup[mysongid,2])
  sc <- sc %>% mutate(!!myvarname := ifelse(alt == mysongname,1,0))
  
}

rm(mydf, mydf2)
gc()

sc <- dfidx(sc)

ml.sc1 <- mlogit(choice ~ yearsold, data = sc)

# Save disaggregate data -----------------------------------

saveRDS(mydf, "Repeatr1.rds")
saveRDS(mydf2, "Repeatr2.rds")

#

