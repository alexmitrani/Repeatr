library(dplyr)
library(stringr)
library(lubridate)
library(mlogit)
library(fastDummies)
library(rlang)

# Version history
# 20210119 v1 01 by Alex Mitrani.  This function was inspired by the "compress" function in Stata and a need to reduce the size of large datafiles by optimizing the storage modes of variables.
# 20210610 v1 02 by Alex Mitrani.  Removed tidyverse dependency.

#' @name compressr
#' @title changes the type of specified variables to integer
#' @description compressr is used to reduce the size of data files with double-precision storage of integer variables, by changing the storage type of these variables to integer.
#' @details compressr is used internally by the fsm package.
#'
#' @import tidyverse
#' @import crayon
#' @import rlang
#'
#' @param mydf the dataframe to be modified.
#' @param ... a list of the variables to have their storage modes changed to integer.
#'
#' @return
#' @export
#'
#' @examples
#' mydf <- mtcars
#' mycompressrvars <- scan(text="vs am gear carb", what="")
#' mydf <- compressr(mydf, mycompressrvars)
#' mydf
#'
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

#




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
saveRDS(mysongidlookup, "mysongidlookup.rds")

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

saveRDS(mycaseidlookup, "mycaseidlookup.rds")

mydf2 <- mydf2 %>%
  left_join(mycaseidlookup) %>%
  relocate(case)

mydf2 <- mydf2 %>% rename(alt = songid)
mydf2 <- mydf2 %>% rename(choice = chosen)

mydf2 <- mydf2 %>%
  mutate(year = year(date)) %>%
  relocate(year, .after=date)

# Save disaggregate data -----------------------------------

saveRDS(mydf, "Repeatr1.rds")
saveRDS(mydf2, "Repeatr2.rds")
rm(mydf, mydf2)

# Keep only the specific variables needed for the modelling --------

mydf2 <- readRDS("Repeatr2.rds")

sc <- mydf2 %>% 
  select(case, alt, choice, yearsold)

sc <- sc %>%
  mutate(yearsold = case_when(
    yearsold >= 0 & yearsold < 1  ~ 0L,
    yearsold >= 1 & yearsold < 2  ~ 1L,
    yearsold >= 2 & yearsold < 3  ~ 2L,
    yearsold >= 3 & yearsold < 4  ~ 3L,
    yearsold >= 4 & yearsold < 5  ~ 4L,
    yearsold >= 5 & yearsold < 6  ~ 5L,
    yearsold >= 6 & yearsold < 7  ~ 6L,
    yearsold >= 7 & yearsold < 8  ~ 7L,
    yearsold >= 8 & yearsold < 9  ~ 8L,
    yearsold >= 9 & yearsold < 10  ~ 9L,
    yearsold >= 10 & yearsold < 11  ~ 10L,
    yearsold >= 11 & yearsold < 12  ~ 11L,
    yearsold >= 12 & yearsold < 13  ~ 12L,
    yearsold >= 13 & yearsold < 14  ~ 13L,
    yearsold >= 14 & yearsold < 15  ~ 14L,
    TRUE ~ 15L
    )
  )

sc <- sc %>%
  mutate(yearsold_other = yearsold_8 + yearsold_9 + yearsold_10 + yearsold_11 + yearsold_12 + yearsold_13 + yearsold_14 + yearsold_15)

sc <- dummy_cols(sc, select_columns = "yearsold")

mycompressrvars <- scan(text="yearsold_1 yearsold_2 yearsold_3 yearsold_4 yearsold_5 yearsold_6 yearsold_7 yearsold_8 yearsold_9 yearsold_10 yearsold_11 yearsold_12 yearsold_13 yearsold_14 yearsold_15 s.2 s.3 s.4 s.5 s.6 s.7 s.8 s.9 s.10 s.11 s.12 s.13 s.14 s.15 s.16 s.17 s.18 s.19 s.20 s.21 s.22 s.23 s.24 s.25 s.26 s.27 s.28 s.29 s.30 s.31 s.32 s.33 s.34 s.35 s.36 s.37 s.38 s.39 s.31 s.41 s.42 s.43 s.44 s.45 s.46 s.47 s.48 s.49 s.50 s.51 s.52 s.53 s.54 s.55 s.56 s.57 s.58 s.59 s.60 s.61 s.62 s.63 s.64 s.65 s.66 s.67 s.68 s.69 s.70 s.71 s.72 s.73 s.74 s.75 s.76 s.77 s.78 s.79 s.80 s.81 s.82 s.83 s.84 s.85 s.86 s.87 s.88 s.89 s.90 s.91 s.92", what="")
sc <- compressr(sc, mycompressrvars)

sc$case <- factor(as.numeric(as.factor(sc$case)))
sc$alt <- as.factor(sc$alt)
sc$choice <- as.logical(sc$choice)
sc <- dfidx(sc, idx = c("case", "alt"), drop.index = FALSE)

saveRDS(sc, "sc.rds")

# Choice modelling --------------------------------

sc <- readRDS("sc.rds")

ml.sc1 <- mlogit(choice ~ yearsold, data = sc)

summary(ml.sc1)

ml.sc2 <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5 
                 + yearsold_6 + yearsold_7 + yearsold_8 + yearsold_9 + yearsold_10
                 + yearsold_11 + yearsold_12 + yearsold_13 + yearsold_14 + yearsold_15
                 , data = sc)

summary(ml.sc2)


ml.sc3 <- mlogit(choice ~ yearsold_0 + yearsold_1 + yearsold_2, data = sc)

summary(ml.sc3)

ml.sc4 <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5 
                 + yearsold_6 + yearsold_7 + yearsold_other , data = sc)


# Report results of the choice modelling ----------------------------------



summary.ml.sc4 <- summary(ml.sc4)

results.ml.sc4 <- as.data.frame(summary.ml.sc4[["CoefTable"]])

results.ml.sc4 <- results.ml.sc4 %>%
  mutate(parameter_id = row_number()) %>%
  relocate(parameter_id)

variable <- row.names(results.ml.sc4)

choice_model_results_table <- cbind(variable, results.ml.sc4)

choice_model_results_table <- choice_model_results_table %>%
  mutate(songid = ifelse(parameter_id<=91,parameter_id+1,NA))

choice_model_results_table <- choice_model_results_table %>%
  left_join(mysongidlookup)

choice_model_results_table <- choice_model_results_table %>%
  mutate(variable = ifelse(parameter_id<=91,song,variable))

choice_model_results_table$songid <- NULL
choice_model_results_table$song <- NULL

write.csv(choice_model_results_table, "fugazi_song_choice_model.csv")

results.ml.sc4 <- results.ml.sc4 %>%
  filter(parameter_id<=91)

results.ml.sc4 <- results.ml.sc4 %>%
  mutate(songid = parameter_id+1)

results.ml.sc4 <- results.ml.sc4 %>%
  left_join(mysongidlookup)

results.ml.sc4 <- results.ml.sc4 %>%
  select(songid, song, Estimate, "z-value")

results.ml.sc4.os <- mysongidlookup %>%
  filter(songid==1) %>%
  mutate(Estimate = 0) %>%
  mutate("z-value" = NA)

results.ml.sc4 <- rbind(results.ml.sc4, results.ml.sc4.os)

results.ml.sc4 <- results.ml.sc4 %>%
  arrange(desc(Estimate))

write.csv(results.ml.sc4, "fugazi_song_preferences_implied_by_choices.csv")

#

