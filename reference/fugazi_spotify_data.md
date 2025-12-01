# fugazi_spotify_data provides basic code for extracting metadata on Fugazi songs from the Spotify API. .

Based on code from this presentation:
https://brunaw.com/shortcourses/IXSER/en/pres-en.html#1

Go to https://developer.spotify.com/ and log in,

Go to https://developer.spotify.com/dashboard/ and create a new app,

Save the client ID and the client Secret generated,

Define the redirect URL as http://localhost:1410/,

Use the spotifyOAuth() to authenticate:

library(Rspotify)

key_spotify \<- spotifyOAuth("app_id","client_id","client_secret")

This function will produce an error if you do not load the package
RSpotify first or if you do not provide as arguments your app_id,
client_id and client_secret.

## Usage

``` r
fugazi_spotify_data(app_id = NULL, client_id = NULL, client_secret = NULL)
```

## Arguments

- client_secret:

## Details

fugazi_spotify_data
