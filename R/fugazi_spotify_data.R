

#' fugazi_spotify_data
#' @name fugazi_spotify_data
#' @title fugazi_spotify_data provides basic code for extracting metadata on Fugazi songs from the Spotify API. .
#' @description Based on code from this presentation: https://brunaw.com/shortcourses/IXSER/en/pres-en.html#1
#' @description Go to https://developer.spotify.com/ and log in,
#' @description Go to https://developer.spotify.com/dashboard/ and create a new app,
#' @description Save the client ID and the client Secret generated,
#' @description Define the redirect URL as http://localhost:1410/,
#' @description Use the spotifyOAuth() to authenticate:
#' @description library(Rspotify)
#' @description key_spotify <- spotifyOAuth("app_id","client_id","client_secret")
#' @description This function will produce an error if you do not load the package RSpotify first or if you do not provide as arguments your app_id, client_id and client_secret.
#'
#' @param app_id Spotify app id, as generated in the Spotify developer dashboard.
#' @param client_id Spotify client id, as generated in the Spotify developer dashboard.
#' @param client_secret Spotify client secret, as generated in the Spotify developer dashboard.
#'
#' @return A data frame with one row per Fugazi track, combining Spotify's per-song audio features (e.g. tempo) with the track and album name.
#' @export
#'
#' @examples
#' \dontrun{
#' library(Rspotify)
#' key_spotify <- spotifyOAuth("app_id", "client_id", "client_secret")
#' fugazi_tracks <- fugazi_spotify_data(app_id = "app_id", client_id = "client_id",
#'                                       client_secret = "client_secret")
#' }
fugazi_spotify_data <- function(app_id = NULL, client_id = NULL, client_secret = NULL) {

  key_spotify <- spotifyOAuth(app_id, client_id, client_secret)

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
    dplyr::pull(.data$id) %>%
    purrr::map_df(
      ~{
        getAlbum(.x, token = key_spotify) %>%
          dplyr::select(.data$id, .data$name)
      }) %>%
    tidyr::unnest()
  ids <- albums_res %>%
    dplyr::pull(.data$id)

  # 4. Obtain the variables for each song
  features <- ids %>%
    purrr::map_dfr(~getFeatures(.x, token = key_spotify)) %>%
    dplyr::left_join(albums_res, by = "id")

  mydf <- features %>%
    select(-.data$id, -.data$uri, -.data$analysis_url)

  mydf <- mydf %>%
    relocate(.data$name, .data$tempo) %>%
    arrange(.data$name)

  return(mydf)

}
