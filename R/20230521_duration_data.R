library(Repeatr)

othervariables <- othervariables

fls_tags <- fls_tags

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
  mutate(city = str_sub(album, firstcomma + 2, secondcomma-1))

fls_tags <- fls_tags %>%
  mutate(country = str_sub(album, lastcomma + 2, stringlength))

