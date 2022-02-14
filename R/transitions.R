# Libraries
library(ggraph)
library(igraph)
library(dplyr)

mydf1 <- Repeatr1 %>% select(gid,song_number,song)
mydf2 <- mydf1 %>% mutate(song_number = song_number-1)
mydf1 <- mydf1 %>% rename(song1 = song)
mydf2 <- mydf2 %>% rename(song2 = song)
mydf3 <- mydf1 %>% left_join(mydf2)
mydf3 <- mydf3 %>% filter(is.na(song2)==FALSE)
mydf3 <- mydf3 %>% rename(transition_number = song_number)
head(mydf3)


