
# get preferences data from song number one choice model results

mydf <- Repeatr_5(mymodel = ml.Repeatr4_fs)

mypreferences <- mydf[[2]]

# convert parameter estimates to rating scale from 0 to 1

mymin <- min(mypreferences$Estimate)

mypreferences <- mypreferences %>%
  mutate(Estimate2 = Estimate - mymin)

mymax <- max(mypreferences$Estimate2)

mypreferences <- mypreferences %>%
  mutate(rating = Estimate2/mymax)

# calculate counts and performance intensity

songnumberone_counts <- Repeatr2 %>%
  filter(first_song==1) %>%
  rename(songid = alt)

songnumberone_counts <- songnumberone_counts %>%
  group_by(songid) %>%
  summarise(chosen= sum(choice), available_rl=sum(available_rl)) %>%
  arrange(desc(chosen)) %>%
  ungroup()

songnumberonesummary <- mypreferences %>%
  left_join(songnumberone_counts)

songnumberonesummary <- songnumberonesummary %>%
  mutate(intensity = chosen/available_rl)

mylaunchdatelookup <- fugazi_song_performance_intensity %>%
  select(songid, launchdate)

songnumberonesummary <- songnumberonesummary %>%
  left_join(mylaunchdatelookup)

songnumberonesummary <- songnumberonesummary %>%
  select(songid, song, launchdate, chosen, available_rl, intensity, rating)

# export results

knitr::kable(songnumberonesummary, "pipe")

write.csv(songnumberonesummary, "songnumberonesummary.csv")

#






