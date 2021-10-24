library(dplyr)
library(stringr)

fugotcha <- read.csv("fugotcha.csv", header=FALSE)
saveRDS(fugotcha, "fugotcha.rds")

mydf <- subset(fugotcha, select = -c(V2, V3, V4, V5, V6, V7, V8, V9))

names(mydf)

#gig id
names(mydf)[names(mydf) == "V1"] <- "gid"

myv <- 10

for(mysong in 1:44) {
  
  myinitialname <- paste0("V", myv)
  mynewname <- paste0("song.", mysong)
  names(mydf)[names(mydf) == myinitialname] <- mynewname
  myv <- myv + 1
  
}

mydf <- reshape(data = mydf
                            , direction = "long"
                            , varying = 2:45
                            , idvar = "gid"
)

#songnumber
names(mydf)[names(mydf) == "time"] <- "song_number"

mydf <- mydf %>% arrange(gid, song_number)

mydf$nchar <- nchar(mydf$song)

mydf <- mydf %>%
  filter(nchar>0)

mydf <- mydf %>%
  filter(!grepl("Interlude",song))

mydf <- mydf %>%
  filter(!grepl("Intro",song))

mycount <- mydf %>%
  group_by(song) %>%
  summarise(count= n()) %>%
  ungroup()

mycount <- mycount %>%
  arrange(count)

saveRDS(mydf, "Repeatr.rds")


#

