library(Repeatr)

mydf <- othervariables

mydf <- mydf %>%
  filter(checked==0)

mydf <- mydf %>%
  group_by(country, city, venue) %>%
  summarize(count = n()) %>%
  ungroup()

mydf <- mydf %>%
  arrange(country, city, venue)

mydf2 <- mydf %>%
  group_by(country, city) %>%
  summarize(n_venues=n()) %>%
  ungroup()

mydf2 <- mydf2 %>%
  arrange(desc(n_venues))

mydf3 <- mydf %>%
  left_join(mydf2)

mydf3 <- mydf3 %>%
  arrange(desc(n_venues), country, city, venue)

mydf3 <- mydf3 %>%
  select(country, city, venue) %>%
  mutate(googlemaps_hyperlink="",
         count1="",
         count2="",
         count3="",
         link_x="",
         link_y="")

write_csv(mydf3, file="fls_venue_geocoding.csv")




