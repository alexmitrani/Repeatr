library(dplyr)
library(stringr)

fugotcha <- read.csv("fugotcha.csv", header=FALSE)
saveRDS(fugotcha, "fugotcha.rds")


# Select the most relevant columns -------


mydf <- subset(fugotcha, select = -c(V2, V3, V4, V5, V6, V7, V8, V9))

names(mydf)


# Define gig id -----------------------------------------------------------

names(mydf)[names(mydf) == "V1"] <- "gid"


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
                            , varying = 2:45
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


# Save disaggregate data in long format -----------------------------------

saveRDS(mydf, "Repeatr.rds")

# Summarise the data to check frequency counts for all songs --------------

mycount <- mydf %>%
  group_by(song) %>%
  summarise(count= n()) %>%
  ungroup()

mycount <- mycount %>%
  arrange(desc(count))

write.csv(mycount, "fugazi_song_counts.csv")




#

