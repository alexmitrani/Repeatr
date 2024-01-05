
# Reference: https://brunaw.com/shortcourses/IXSER/en/pres-en.html#1

library(Rspotify)

key_spotify <- spotifyOAuth("app_id","client_id","client_secret")

# 1. Search the artist using the API
find_artist <- searchArtist("Fugazi", token = key_spotify)

# 2. Use the ID to search for album information
albums <- getAlbums(find_artist$id[1], token = key_spotify)

# to add Furniture EP which was not discovered previously
albums[10,1] <- "3TKqkE043OwhT0b9rHXMPe"
albums[10,2] <- "Furniture"
albums[10,3] <- "album"

# 3. Obtain the songs of each album
albums_res <- albums %>%
  dplyr::pull(id) %>%
  purrr::map_df(
    ~{
      getAlbum(.x, token = key_spotify) %>%
        dplyr::select(id, name)
    }) %>%
  tidyr::unnest()
ids <- albums_res %>%
  dplyr::pull(id)

# 4. Obtain the variables for each song
features <- ids %>%
  purrr::map_dfr(~getFeatures(.x, token = key_spotify)) %>%
  dplyr::left_join(albums_res, by = "id")

mydf <- features %>%
  select(-id, -uri, -analysis_url)

mydf <- mydf %>%
  relocate(name, tempo) %>%
  arrange(name)

write.csv(mydf, file = "fugazi_spotify_data.csv")

