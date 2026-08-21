
#' @name Repeatr_1
#' @title imports raw data (1 row per show), cleans the data, and reshapes it long so that the rows are identified by combinations of gid and song_number.
#' @description Reads its raw inputs from this package's own `inst/extdata/` by default: `fls_data.csv` (one row per show, produced by \code{\link{scrape_fls_shows}}; `tour`, `city`, `subdivision`, and `country` all come from the FLS listing pages' own filter links/tour headings - see \code{\link{scrape_fls_listing_data}}), `releases_songs_durations_wikipedia.csv` (Wikipedia discography metadata), `releases.csv` (release metadata), `fls_venue_geocoding_v2.csv` (venue coordinates), and `fls_tags.txt` (tag/duration data, via \code{\link{fls_tags_importer}}). Each can be overridden with an explicit data frame instead - see the parameters below.
#' @description "gid" is short for "gig id"
#' @description `songvarslookup` (read from `inst/extdata/releases_songs_durations_wikipedia.csv`) contains the following variables: rid	track_number	title	instrumental	vocals_picciotto	vocals_mackaye	vocals_lally	duration_seconds. It is joined onto the live, classified song set by `title` text, not by a hardcoded id column - see `songid` below.

#'
#' @param myfls_data Optional data frame of Fugazi Live Series show data to use instead of `inst/extdata/fls_data.csv` (same shape: one row per show, as produced by \code{\link{scrape_fls_shows}}).
#' @param mysongvarslookup Optional data frame of song data to use instead of `inst/extdata/releases_songs_durations_wikipedia.csv`.
#' @param myreleases Optional data frame of releases data to use instead of `inst/extdata/releases.csv`.
#' @param myfls_venue_geocoding Optional data frame of venue coordinates to use instead of `inst/extdata/fls_venue_geocoding_v2.csv`.
#' @param myfls_tags Optional data frame of tag/duration data to use instead of `inst/extdata/fls_tags.txt`.
#' @param output_dir Optional directory to save the rebuilt `data/*.rda` objects into. If omitted, defaults to `data/` under the current working directory (the package root, in the normal `devtools::load_all(); Repeatr_Updatr()` workflow).
#'
#' @return A list of 13 elements: `Repeatr0`, `Repeatr1`, `songidlookup`, `mycount`, `songvarslookup`, `releasesdatalookup`, `othervariables`, `cumulative_song_counts`, `fls_tags`, `fls_tags_show`, `cumulative_duration_counts`, `releases_data_input`, and `raw_fls_song_list`. As a side effect, these and several other derived datasets (including `gid_sound_quality`, `played_with`, `shows_data`, `xray`) are also saved into `data/` (or `output_dir`, if supplied). `songidlookup` assigns a stable `songid` to every classified song, including one-offs and rarities - the modelling-eligibility filter (`min_song_count`) that used to be applied here has moved to \code{\link{Repeatr_2}}, which is where it belongs since it's a choice-model concern, not a question of song identity.
#' @export
#'
#' @examples
#' Repeatr_1_results <- Repeatr_1(output_dir = tempdir())
#'
Repeatr_1 <- function(myfls_data = NULL, mysongvarslookup = NULL, myreleases = NULL,
                       myfls_venue_geocoding = NULL, myfls_tags = NULL, output_dir = NULL) {

# Devel setup -------------------------------------------------------------

  # Uncomment and run the following lines to test the code outside the package

  # library(dplyr)
  # library(stringr)
  # library(lubridate)
  # library(mlogit)
  # library(fastDummies)
  # library(rlang)
  # library(knitr)
  # library(crayon)
  # library(readr)

# Import data -------------------------------------------------------------

  mydir <- getwd()
  on.exit(setwd(mydir), add = TRUE)
  mydatadir <- if (is.null(output_dir)) paste0(mydir, "/data") else output_dir

  Repeatr0 <- if (is.null(myfls_data)) utils::read.csv(system.file("extdata", "fls_data.csv", package = "Repeatr"), header = TRUE) else myfls_data

  # gid_sound_quality used to be a static dataset with no regeneration path -
  # it's now rebuilt live from Repeatr0 every run, same gid/sound_quality
  # shape as before, so the left_join(gid_sound_quality) calls further down
  # need no other change.

  gid_sound_quality <- Repeatr0 %>%
    select(.data$gid, .data$sound_quality) %>%
    filter(is.na(.data$sound_quality)==FALSE)

  # washington-dc-usa-100688 (10/6/88) has no surviving recording - the FLS
  # site's own page comments confirm this, and the audio posted there is
  # actually a mislabeled copy of the 6/15/88 recording (gid
  # washington-dc-usa-61588, correctly dated in fls_tags). Its sound_quality
  # rating describes that other recording, not a real one for this date.
  gid_sound_quality <- gid_sound_quality %>%
    filter(.data$gid!="washington-dc-usa-100688")

  songvarslookup <- if (is.null(mysongvarslookup)) utils::read.csv(system.file("extdata", "releases_songs_durations_wikipedia.csv", package = "Repeatr"), header = TRUE) else mysongvarslookup
  songvarslookup <- songvarslookup %>%
    rename(title = .data$song, rid = .data$releaseid)

  save(songvarslookup, file = file.path(mydatadir, "songvarslookup.rda"))

  song_tempo_bpm_data <- utils::read.csv(system.file("extdata", "song_tempo_bpm_data.csv", package = "Repeatr"), header = TRUE)
  song_tempo_bpm_data <- song_tempo_bpm_data %>%
    rename(title = .data$song)
  save(song_tempo_bpm_data, file = file.path(mydatadir, "song_tempo_bpm_data.rda"))

  releasesdatalookup <- if (is.null(myreleases)) utils::read.csv(system.file("extdata", "releases.csv", package = "Repeatr"), header = TRUE) else myreleases
  releasesdatalookup$X <- NULL
  releasesdatalookup <- releasesdatalookup %>%
    rename(rid = .data$releaseid, release_title = .data$release, release_date = .data$releasedate) %>%
    mutate(release_date = as.Date(.data$release_date, "%d/%m/%Y"))

  othervariables <- Repeatr0 %>%
    select(.data$gid, .data$fls_id, .data$show_date, .data$venue, .data$door_price, .data$attendance, .data$recorded_by, .data$mastered_by, .data$original_source, .data$fls_notes, .data$tour, .data$city, .data$subdivision, .data$country)

  othervariables <- othervariables %>%
    rename(flsid = .data$fls_id, date = .data$show_date, doorprice = .data$door_price)

  othervariables <- othervariables %>%
    mutate(date = as.Date(date, "%d/%m/%Y"),
           year = lubridate::year(date),
           checked = 0,
           # x/y start unset here - inst/extdata/fls_data.csv's venue/city/country
           # are already corrected against fls_venue_geocoding's spelling (a
           # one-time cleanup, see vignette("Rebuilding-the-Data")), so there
           # is no longer a baseline coordinate-fallback join at this point -
           # every coordinate below comes from a hardcoded per-venue
           # correction or from the fls_venue_geocoding join further down.
           x = NA_real_,
           y = NA_real_)

  othervariables <- othervariables %>%
    mutate(attendance = as.numeric(.data$attendance))

  othervariables <- othervariables %>%
    mutate(country = ifelse(.data$flsid=="FLS0970", "USA", .data$country),
           country = ifelse(.data$city=="Ljubljana" & year>=1991, "Slovenia", .data$country),
           country = ifelse(.data$city=="Prague" & year<=1992, "Czechoslovakia", .data$country),
           city = ifelse(.data$flsid=="FLS0970", "San Francisco", .data$city),
           x = ifelse(.data$flsid=="FLS0970", -122.4272376, .data$x),
           y = ifelse(.data$flsid=="FLS0970", 37.760407, .data$y),
           tour = ifelse(.data$flsid=="FLS0970", "2000 Summer/Fall Regional Dates", .data$tour),
           tour = ifelse(.data$tour=="1993 Fall USA/Canda Tour", "1993 Fall USA/Canada Tour", .data$tour),
           year = ifelse(.data$flsid=="FLS0970", 2000, year),
           recorded_by = ifelse(.data$flsid=="FLS0970", "Stephen Kozlowski", .data$recorded_by),
           checked = ifelse(.data$flsid=="FLS0970", 1, .data$checked))

  othervariables <- othervariables %>%
    mutate(city = ifelse(.data$city=="Wesleyan", "Middletown", .data$city))

  # mastered_by/original_source cleanup: a handful of raw scraped values are
  # a typo (missing hyphen) or too terse to be useful downstream.
  othervariables <- othervariables %>%
    mutate(mastered_by = ifelse(.data$mastered_by=="Warren Russell Smith", "Warren Russell-Smith", .data$mastered_by),
           original_source = case_when(
             .data$original_source == "?" ~ "Unknown",
             .data$original_source == "VHS" ~ "VHS audio",
             .data$original_source == "VHS Tape" ~ "VHS audio",
             TRUE ~ .data$original_source
           ))

  # washington-dc-usa-100688 (10/6/88) is a real, distinct show (confirmed
  # against the site's own flyer - date/venue/played_with/door
  # price/attendance are untouched), but the page's own comments confirm no
  # recording survives for this date - the audio posted there is actually a
  # mislabeled copy of the 6/15/88 recording. These three fields describe
  # that other recording, not one that exists for this show.
  othervariables <- othervariables %>%
    mutate(recorded_by = ifelse(.data$gid=="washington-dc-usa-100688", NA_character_, .data$recorded_by),
           mastered_by = ifelse(.data$gid=="washington-dc-usa-100688", NA_character_, .data$mastered_by),
           original_source = ifelse(.data$gid=="washington-dc-usa-100688", NA_character_, .data$original_source))

  # One-off data-entry error on the site: this Hobart show's own "State"
  # filter link reads "TZ", while every other Hobart/Launceston show says
  # "TAS" - not a real distinct designation, just a typo to correct.
  othervariables <- othervariables %>%
    mutate(subdivision = ifelse(.data$city=="Hobart" & .data$country=="Australia" & .data$subdivision=="TZ", "TAS", .data$subdivision))

  # The FLS site's own "State" filter link is blank for a number of
  # Australian shows (and wrong - "NSW" - for every Canberra show, which is
  # actually in the Australian Capital Territory) even though every one of
  # these cities is unambiguously in a single state/territory. Fill/correct
  # them here rather than leaving subdivision blank, since app.R uses
  # subdivision to disambiguate city names (e.g. "Newcastle, NSW" vs
  # "Newcastle-Upon-Tyne"). Verified against each venue's own coordinates in
  # fls_venue_geocoding_v2.csv.
  othervariables <- othervariables %>%
    mutate(subdivision = ifelse(.data$country=="Australia" & .data$city=="Adelaide", "SA", .data$subdivision),
           subdivision = ifelse(.data$country=="Australia" & .data$city=="Ballarat", "VIC", .data$subdivision),
           subdivision = ifelse(.data$country=="Australia" & .data$city=="Brisbane", "QLD", .data$subdivision),
           subdivision = ifelse(.data$country=="Australia" & .data$city=="Canberra", "ACT", .data$subdivision),
           subdivision = ifelse(.data$country=="Australia" & .data$city=="Darwin", "NT", .data$subdivision),
           subdivision = ifelse(.data$country=="Australia" & .data$city=="Geelong", "VIC", .data$subdivision),
           subdivision = ifelse(.data$country=="Australia" & .data$city=="Lismore", "NSW", .data$subdivision),
           subdivision = ifelse(.data$country=="Australia" & .data$city=="Manly", "NSW", .data$subdivision),
           subdivision = ifelse(.data$country=="Australia" & .data$city=="Melbourne", "VIC", .data$subdivision),
           subdivision = ifelse(.data$country=="Australia" & .data$city=="Newcastle", "NSW", .data$subdivision),
           subdivision = ifelse(.data$country=="Australia" & .data$city=="Perth", "WA", .data$subdivision),
           subdivision = ifelse(.data$country=="Australia" & .data$city=="Sydney", "NSW", .data$subdivision),
           subdivision = ifelse(.data$country=="Australia" & .data$city=="Wollongong", "NSW", .data$subdivision))

  # The FLS site's own scrape never populates subdivision outside the US/
  # Canada/Australia, so Brazil's 12 tour cities are filled in here from a
  # hand-verified city lookup (checked against each city's own coordinates in
  # fls_venue_geocoding_v2.csv).
  othervariables <- othervariables %>%
    mutate(subdivision = case_when(
      .data$country == "Brazil" & .data$city == "Belo Horizonte" ~ "MG",
      .data$country == "Brazil" & .data$city == "Brasilia" ~ "DF",
      .data$country == "Brazil" & .data$city == "Campinas" ~ "SP",
      .data$country == "Brazil" & .data$city == "Curitiba" ~ "PR",
      .data$country == "Brazil" & .data$city == "Itaborai" ~ "RJ",
      .data$country == "Brazil" & .data$city == "Joinville" ~ "SC",
      .data$country == "Brazil" & .data$city == "Londrina" ~ "PR",
      .data$country == "Brazil" & .data$city == "Piracicaba" ~ "SP",
      .data$country == "Brazil" & .data$city == "Rio De Janeiro" ~ "RJ",
      .data$country == "Brazil" & .data$city == "Santos" ~ "SP",
      .data$country == "Brazil" & .data$city == "Sao Paulo" ~ "SP",
      .data$country == "Brazil" & .data$city == "Vitoria" ~ "ES",
      TRUE ~ .data$subdivision
    ))

  # Any subdivision still blank at this point is a pre-existing mix of NA and
  # "" for shows outside the US/Canada/Australia/Brazil - standardize to NA.
  othervariables <- othervariables %>%
    mutate(subdivision = ifelse(.data$subdivision == "", NA_character_, .data$subdivision))

  # doorprice is raw scraped text (currency symbols, foreign-currency
  # abbreviations, one price range, "Free", ~33% missing) - split into a
  # numeric price + ISO 4217 currency via a hand-built lookup of its ~58
  # distinct raw values (fls_doorprice_currency_lookup.csv), since currency
  # isn't otherwise recorded and several countries' shows predate that
  # country's euro adoption. "Free" isn't in the lookup (same text, different
  # currency depending on the show's own country) - handled by the mutate()
  # below instead. Two 1990 Yugoslavia shows are priced in Deutsche Mark
  # ("12 Marks"/"15 Marks") rather than the Yugoslav dinar - kept as DEM, not
  # the country's nominal currency, since that's what the raw text says.
  doorprice_lookup <- utils::read.csv(system.file("extdata", "fls_doorprice_currency_lookup.csv", package = "Repeatr"), header = TRUE, colClasses = c(doorprice = "character", price = "numeric", currency = "character", note = "character"))

  othervariables <- othervariables %>%
    left_join(doorprice_lookup, by = "doorprice") %>%
    mutate(
      price = ifelse(.data$doorprice == "Free", 0, .data$price),
      currency = case_when(
        .data$doorprice == "Free" & .data$country == "Italy" ~ "ITL",
        .data$doorprice == "Free" ~ "USD",
        TRUE ~ .data$currency
      )
    ) %>%
    select(-.data$doorprice, -.data$note)

  # Do NOT filter out rows with no x/y here - a show's coordinates may only
  # come from a later source (the disambiguation-corrected city match, the
  # many hardcoded per-venue x/y corrections below, or the
  # fls_venue_geocoding join near the end of this function). The filter runs
  # at the very end, after every coordinate source has had its turn.

  # Disambiguation

  othervariables <- othervariables %>%
    mutate(city = ifelse(.data$country=="England" & .data$city=="Newcastle", "Newcastle-Upon-Tyne", .data$city),
           city = ifelse(.data$country=="USA" & .data$city=="Oxford", "Oxford (USA)", .data$city),
           city = ifelse(.data$country=="Australia" & .data$city=="Croydon", "Croydon (Australia)", .data$city),
           city = ifelse(.data$country=="Australia" & .data$city=="Newcastle", "Newcastle (Australia)", .data$city),
           # Portland and Columbia each cover multiple, differently-located
           # US cities of the same name - fls_venue_geocoding_v2.csv
           # disambiguates them as "City (ST)", so match that convention
           # using the subdivision scraped alongside city/country, or these
           # venues' coordinates can never be found there.
           city = ifelse(.data$country=="USA" & .data$city=="Portland" & is.na(.data$subdivision)==FALSE, paste0("Portland (", .data$subdivision, ")"), .data$city),
           city = ifelse(.data$country=="USA" & .data$city=="Columbia" & is.na(.data$subdivision)==FALSE, paste0("Columbia (", .data$subdivision, ")"), .data$city))

  othervariables <- othervariables %>%
    mutate(venue = ifelse(.data$country=="USA" & .data$city=="Washington" & .data$venue=="9:30 Club" & year<=1995, "9:30 Club (1980-1995)", .data$venue),
           x = ifelse(.data$country=="USA" & .data$city=="Washington" & .data$venue=="9:30 Club (1980-1995)" & year<=1995, -77.0255867, .data$x),
           y = ifelse(.data$country=="USA" & .data$city=="Washington" & .data$venue=="9:30 Club (1980-1995)" & year<=1995, 38.8971517, .data$y))


  othervariables <- othervariables %>%
    mutate(venue = ifelse(.data$flsid=="FLS0050", "Frankford YWCA", .data$venue))

  othervariables <- othervariables %>%
    mutate(venue = ifelse(.data$flsid=="FLS0478", "Tempodrom", .data$venue))

  # correct values where necessary

  othervariables <- othervariables %>%
    mutate(x = ifelse(.data$city=="Newcastle-Upon-Tyne" & .data$venue=="Riverside", -1.6051, .data$x),
           y = ifelse(.data$city=="Newcastle-Upon-Tyne" & .data$venue=="Riverside", 54.9717, .data$y),
           checked = ifelse(.data$city=="Newcastle-Upon-Tyne" & .data$venue=="Riverside", 1, .data$checked),
           x = ifelse(.data$city=="Lisbon" & .data$venue=="Gartejo", -9.1755975, .data$x),
           y = ifelse(.data$city=="Lisbon" & .data$venue=="Gartejo", 38.7042177, .data$y),
           checked = ifelse(.data$city=="Lisbon" & .data$venue=="Gartejo", 1, .data$checked),
           x = ifelse(.data$country == "Japan" & .data$city=="Osaka" & .data$venue=="AM Hall", 135.4995612, .data$x),
           y = ifelse(.data$country == "Japan" & .data$city=="Osaka" & .data$venue=="AM Hall", 34.7012144, .data$y),
           checked = ifelse(.data$country == "Japan" & .data$city=="Osaka" & .data$venue=="AM Hall", 1, .data$checked),
           x = ifelse(.data$country == "Japan" & .data$city=="Osaka" & .data$venue=="Sun Hall", 135.4808578, .data$x),
           y = ifelse(.data$country == "Japan" & .data$city=="Osaka" & .data$venue=="Sun Hall", 34.6709861, .data$y),
           checked = ifelse(.data$country == "Japan" & .data$city=="Osaka" & .data$venue=="Sun Hall", 1, .data$checked),
           x = ifelse(.data$country == "Japan" & .data$city=="Nagoya" & .data$venue=="Club Quattro", 136.9082324, .data$x),
           y = ifelse(.data$country == "Japan" & .data$city=="Nagoya" & .data$venue=="Club Quattro", 35.1637276, .data$y),
           checked = ifelse(.data$country == "Japan" & .data$city=="Nagoya" & .data$venue=="Club Quattro", 1, .data$checked),
           x = ifelse(.data$country == "Japan" & .data$city=="Nagoya" & .data$venue=="Heartland", 136.9192034, .data$x),
           y = ifelse(.data$country == "Japan" & .data$city=="Nagoya" & .data$venue=="Heartland", 35.1693198, .data$y),
           checked = ifelse(.data$country == "Japan" & .data$city=="Nagoya" & .data$venue=="Heartland", 1, .data$checked),
           x = ifelse(.data$country == "USA" & .data$city=="San Francisco" & .data$venue=="Women's Building", -122.4228365, .data$x),
           y = ifelse(.data$country == "USA" & .data$city=="San Francisco" & .data$venue=="Women's Building", 37.7614483, .data$y),
           checked = ifelse(.data$country == "USA" & .data$city=="San Francisco" & .data$venue=="Women's Building", 1, .data$checked),
           x = ifelse(.data$country == "USA" & .data$city=="San Francisco" & .data$venue=="Russian Theater", -122.4413234, .data$x),
           y = ifelse(.data$country == "USA" & .data$city=="San Francisco" & .data$venue=="Russian Theater", 37.7854355, .data$y),
           checked = ifelse(.data$country == "USA" & .data$city=="San Francisco" & .data$venue=="Russian Theater", 1, .data$checked),
           x = ifelse(.data$country == "USA" & .data$city=="San Francisco" & .data$venue=="Fort Mason Pier C", -122.4314681, .data$x),
           y = ifelse(.data$country == "USA" & .data$city=="San Francisco" & .data$venue=="Fort Mason Pier C", 37.8067481, .data$y),
           checked = ifelse(.data$country == "USA" & .data$city=="San Francisco" & .data$venue=="Fort Mason Pier C", 1, .data$checked),
           x = ifelse(.data$country == "USA" & .data$city=="San Francisco" & .data$venue=="Trocadero Transfer", -122.3982015, .data$x),
           y = ifelse(.data$country == "USA" & .data$city=="San Francisco" & .data$venue=="Trocadero Transfer", 37.7790623, .data$y),
           checked = ifelse(.data$country == "USA" & .data$city=="San Francisco" & .data$venue=="Trocadero Transfer", 1, .data$checked),
           x = ifelse(.data$country == "USA" & .data$city=="San Francisco" & .data$venue=="Maritime", -122.3936571, .data$x),
           y = ifelse(.data$country == "USA" & .data$city=="San Francisco" & .data$venue=="Maritime", 37.7864189, .data$y),
           checked = ifelse(.data$country == "USA" & .data$city=="San Francisco" & .data$venue=="Maritime", 1, .data$checked),
           x = ifelse(.data$country == "Germany" & .data$city=="Bremen" & .data$venue=="Schlachthof", 8.8099035, .data$x),
           y = ifelse(.data$country == "Germany" & .data$city=="Bremen" & .data$venue=="Schlachthof", 53.0884866, .data$y),
           checked = ifelse(.data$country == "Germany" & .data$city=="Bremen" & .data$venue=="Schlachthof", 1, .data$checked),
           x = ifelse(.data$country == "Canada" & .data$city=="Ottawa" & .data$venue=="Carleton University Porter Hall", -75.6978497, .data$x),
           y = ifelse(.data$country == "Canada" & .data$city=="Ottawa" & .data$venue=="Carleton University Porter Hall", 45.3840001, .data$y),
           checked = ifelse(.data$country == "Canada" & .data$city=="Ottawa" & .data$venue=="Carleton University Porter Hall", 1, .data$checked),
           x = ifelse(.data$country == "Australia" & .data$city=="Sydney" & (.data$venue=="Metro Theatre" | .data$venue=="Metro"), 151.2066274, .data$x),
           y = ifelse(.data$country == "Australia" & .data$city=="Sydney" & (.data$venue=="Metro Theatre" | .data$venue=="Metro"), -33.8756943, .data$y),
           checked = ifelse(.data$country == "Australia" & .data$city=="Sydney" & (.data$venue=="Metro Theatre" | .data$venue=="Metro"), 1, .data$checked),
           x = ifelse(.data$country == "USA" & .data$city=="Watsonville" & .data$venue=="Veteran's Memorial Hall", -121.7545246, .data$x),
           y = ifelse(.data$country == "USA" & .data$city=="Watsonville" & .data$venue=="Veteran's Memorial Hall", 36.9126013, .data$y),
           checked = ifelse(.data$country == "USA" & .data$city=="Watsonville" & .data$venue=="Veteran's Memorial Hall", 1, .data$checked),
           x = ifelse(.data$country == "Australia" & .data$city=="Wollongong" & .data$venue=="Youth Centre", 150.8928958, .data$x),
           y = ifelse(.data$country == "Australia" & .data$city=="Wollongong" & .data$venue=="Youth Centre", -34.4264333, .data$y),
           checked = ifelse(.data$country == "Australia" & .data$city=="Wollongong" & .data$venue=="Youth Centre", 1, .data$checked),
           x = ifelse(.data$country == "USA" & .data$city=="Fayetteville" & .data$venue=="Studio 225", -94.1667044, .data$x),
           y = ifelse(.data$country == "USA" & .data$city=="Fayetteville" & .data$venue=="Studio 225", 36.0657152, .data$y),
           checked = ifelse(.data$country == "USA" & .data$city=="Fayetteville" & .data$venue=="Studio 225", 1, .data$checked),
           x = ifelse(.data$country == "USA" & .data$city=="Columbia (SC)" & .data$venue=="Dance Graphics", -81.0175133, .data$x),
           y = ifelse(.data$country == "USA" & .data$city=="Columbia (SC)" & .data$venue=="Dance Graphics", 34.0032201, .data$y),
           checked = ifelse(.data$country == "USA" & .data$city=="Columbia (SC)" & .data$venue=="Dance Graphics", 1, .data$checked),
           x = ifelse(.data$country == "Brazil" & .data$city=="Sao Paulo" & .data$venue=="Aeroanta", -46.6949865, .data$x),
           y = ifelse(.data$country == "Brazil" & .data$city=="Sao Paulo" & .data$venue=="Aeroanta", -23.5651133, .data$y),
           checked = ifelse(.data$country == "Brazil" & .data$city=="Sao Paulo" & .data$venue=="Aeroanta", 1, .data$checked),
           venue = ifelse(.data$venue=="Zepplin Rock", "Zeppelin Rock", .data$venue),
           city = ifelse(.data$city=="San.De Campostela", "Santiago de Compostela", .data$city),
           x = ifelse(.data$city=="Huntington" & .data$venue=="Stone Monkey", -82.4201034, .data$x),
           y = ifelse(.data$city=="Huntington" & .data$venue=="Stone Monkey", 38.4272709, .data$y),
           checked = ifelse(.data$city=="Huntington" & .data$venue=="Stone Monkey", 1, .data$checked))

  # Correct country
  othervariables <- othervariables %>%
    mutate(country = ifelse((.data$city=="Belfast" | .data$city=="Derry"), "Northern Ireland", .data$country),
           country = ifelse(.data$flsid=="FLS0970", "USA", .data$country))

  # Correct location of Queen's Hall, Belfast
  othervariables <- othervariables %>%
    mutate(x = ifelse(.data$country == "Northern Ireland" & .data$city=="Belfast" & (.data$venue=="Queen's Hall" | .data$venue=="Queen's University Mandela Hall"), -5.9374134, .data$x),
           y = ifelse(.data$country == "Northern Ireland" & .data$city=="Belfast" & (.data$venue=="Queen's Hall" | .data$venue=="Queen's University Mandela Hall"), 54.5846991, .data$y),
           checked = ifelse(.data$country == "Northern Ireland" & .data$city=="Belfast" & (.data$venue=="Queen's Hall" | .data$venue=="Queen's University Mandela Hall"), 1, .data$checked))

  # Correct location of Rototom
  othervariables <- othervariables %>%
    mutate(city = ifelse(.data$venue=="Rototom", "Gaio di Spilimbergo", .data$city))

  # Correct venue of 1995 Copenhagen show
  othervariables <- othervariables %>%
    mutate(venue = ifelse(.data$gid=="copenhagen-denmark-71095", "Rockmaskinen", .data$venue),
           x = ifelse(.data$gid=="copenhagen-denmark-71095", 12.5994855, .data$x),
           y = ifelse(.data$gid=="copenhagen-denmark-71095", 55.6737142, .data$y))

  # Correct venue of Loppen
  othervariables <- othervariables %>%
    mutate(x = ifelse(.data$gid=="copenhagen-denmark-100700", 12.5973313, .data$x),
           y = ifelse(.data$gid=="copenhagen-denmark-100700", 55.6740572, .data$y))

  # Correct venue of 1988 Nottingham show
  othervariables <- othervariables %>%
    mutate(x = ifelse(.data$gid=="nottingham-england-112788", -1.1349991, .data$x),
           y = ifelse(.data$gid=="nottingham-england-112788", 52.9558396, .data$y))

  # Correct venue name and location for 1995 quebec city show
  othervariables <- othervariables %>%
    mutate(venue = ifelse(.data$gid=="quebec-city-qc-canada-92495", "C\u00e9gep Limoilou", .data$venue))

  othervariables <- othervariables %>%
    mutate(x = ifelse(.data$gid=="quebec-city-qc-canada-92495", -71.2283038, .data$x),
           y = ifelse(.data$gid=="quebec-city-qc-canada-92495", 46.8305332, .data$y))

  # Correct venue name https://www.dischord.com/fugazi_live_series/campinas-brazil-81997
  # Assampi = Associacao de amigos do Parque Industrial
  othervariables <- othervariables %>%
    mutate(venue = ifelse(.data$gid=="campinas-brazil-81997", "Assampi", .data$venue))

  # Correct venue name https://www.dischord.com/fugazi_live_series/joinville-brazil-81597
  # Liga da Sociedade Joinvilense
  othervariables <- othervariables %>%
    mutate(venue = ifelse(.data$gid=="joinville-brazil-81597", "Liga da Sociedade Joinvilense", .data$venue))

  # Correct venue name for 1998 quebec city show https://dischord.com/fugazi_live_series/quebec-city-qc-canada-72298
  othervariables <- othervariables %>%
    mutate(venue = ifelse(.data$gid=="quebec-city-qc-canada-72298", "Centre des Loisirs Saint-Sacrement", .data$venue))

  # impute values where they are missing
  meanattendance <- othervariables %>%
    filter(is.na(.data$tour)==FALSE) %>%
    filter(is.na(.data$attendance)==FALSE) %>%
    group_by(year) %>%
    summarise(meanattendance = mean(.data$attendance)) %>%
    ungroup()

  othervariables <- othervariables %>%
    filter(is.na(.data$tour)==FALSE) %>%
    left_join(meanattendance) %>%
    mutate(attendance = ifelse(is.na(.data$attendance)==TRUE,meanattendance,.data$attendance))

  othervariables <- othervariables %>%
    select(-meanattendance)

  othervariables <- othervariables %>%
    relocate(.data$checked, .after = year)

  # inst/extdata/fls_venue_geocoding_v2.csv is the source of truth for venue
  # coordinates (a periodically-refreshed local snapshot of a private
  # Google Sheet - not read live, since that sheet isn't reliably
  # available). Every coordinate in this table is treated as
  # checked/confirmed.
  fls_venue_geocoding_source <- if (is.null(myfls_venue_geocoding)) utils::read.csv(system.file("extdata", "fls_venue_geocoding_v2.csv", package = "Repeatr"), header = TRUE) else myfls_venue_geocoding

  fls_venue_geocoding_update <- fls_venue_geocoding_source %>%
    select(.data$country, .data$city, .data$venue, .data$x, .data$y) %>%
    rename(link_x = .data$x, link_y = .data$y) %>%
    filter(is.na(.data$link_x)==FALSE) %>%
    mutate(geocoding_check=1)

  othervariables <- othervariables %>%
    left_join(fls_venue_geocoding_update)

  othervariables <- othervariables %>%
    mutate(x = ifelse(is.na(.data$link_x)==FALSE, .data$link_x, .data$x),
           y = ifelse(is.na(.data$link_y)==FALSE, .data$link_y, .data$y),
           checked = ifelse(is.na(.data$geocoding_check)==FALSE, .data$geocoding_check, .data$checked))

  othervariables <- othervariables %>%
    select(-.data$link_x, -.data$link_y, -.data$geocoding_check)

  # The "City (ST)"/"City (Country)" disambiguation suffix injected above
  # (Portland, Columbia, Croydon, Oxford, Newcastle) exists only so the join
  # against fls_venue_geocoding_v2.csv above can find the right coordinates -
  # subdivision/country already carry the same disambiguating information
  # untouched, so strip the suffix back off now that its job is done. Oxford
  # and Newcastle (Australia) now rely on their (newly-populated) subdivision
  # for disambiguation instead of a permanent country suffix, same as the
  # others - see app.R's city/subdivision concatenation.
  othervariables <- othervariables %>%
    mutate(city = ifelse(.data$city=="Portland (OR)", "Portland", .data$city),
           city = ifelse(.data$city=="Portland (ME)", "Portland", .data$city),
           city = ifelse(.data$city=="Columbia (SC)", "Columbia", .data$city),
           city = ifelse(.data$city=="Columbia (MO)", "Columbia", .data$city),
           city = ifelse(.data$city=="Columbia (MD)", "Columbia", .data$city),
           city = ifelse(.data$city=="Croydon (Australia)", "Croydon", .data$city),
           city = ifelse(.data$city=="Oxford (USA)", "Oxford", .data$city),
           city = ifelse(.data$city=="Newcastle (Australia)", "Newcastle", .data$city),
           # "Springfield (MO)"/"Springfield (OR)" were disambiguated this way
           # in inst/extdata/fls_data.csv itself (for the same reason - matching
           # fls_venue_geocoding's join key) but are just as
           # subdivision-disambiguated as Portland, so strip them back here too.
           city = ifelse(.data$city=="Springfield (MO)", "Springfield", .data$city),
           city = ifelse(.data$city=="Springfield (OR)", "Springfield", .data$city))

  # This is the one place a show should actually be dropped for lacking
  # coordinates - after every hardcoded per-venue correction above and the
  # fls_venue_geocoding join have both had a chance to supply x/y, not before.
  othervariables <- othervariables %>%
    filter(is.na(.data$x)==FALSE)

  setwd(mydatadir)

  othervariables <- othervariables %>%
    group_by(.data$gid) %>%
    slice(1) %>%
    ungroup()

  save(othervariables, file="othervariables.rda")
  save(releasesdatalookup, file="releasesdatalookup.rda")
  save(Repeatr0, file="Repeatr0.rda")
  save(gid_sound_quality, file="gid_sound_quality.rda")

  setwd(mydir)


  # process tags data -------------------------------------------------------

  # The underlying MP3 tag data (track/album/song names) is sourced from the
  # Fugazi Live Series itself, not personal data - it's the FLS site's own
  # naming for each show/track, exported via kid3 from the personally-tagged
  # MP3 collection. What follows is the maintainer's own work: a consistent
  # album-name format applied uniformly, plus a handful of one-off track-title
  # corrections for known typos/spelling variants (a one-time cleanup, see
  # vignette("Rebuilding-the-Data")) baked into inst/extdata/fls_tags.txt -
  # str_to_lower() below is a generic normalization applied uniformly, not
  # tied to that correction.
  fls_tags <- if (is.null(myfls_tags)) fls_tags_importer(myfilename = system.file("extdata", "fls_tags.txt", package = "Repeatr")) else myfls_tags

  fls_tags <- fls_tags %>%
    mutate(name = str_to_lower(.data$name))

  fls_tags <- fls_tags %>%
    rename(title = .data$name)

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(.data$album == "20220218 40 Watt, Athens, GA, USA", "19930218 40 Watt, Athens, GA, USA", .data$album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(.data$album == "20010607 Archie Browning Centre, Victoria, BC, Canada", "20010706 Archie Browning Centre, Victoria, BC, Canada", .data$album))

  # Three more known tagging-date typos (found while tracing NA gid rows in
  # fugazibase's durations table back to their source): the tagged album date
  # doesn't match the FLS-listed show date, so the date-based gid join below
  # silently fails for these otherwise-real, correctly-listed shows.
  fls_tags <- fls_tags %>%
    mutate(album = ifelse(.data$album == "19880122 Eastern Michigan University, Ypsilanti, MI, USA", "19880119 Eastern Michigan University, Ypsilanti, MI, USA", .data$album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(.data$album == "19980726 Asylum, Portland, ME, USA", "19980727 Asylum, Portland, ME, USA", .data$album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(.data$album == "20000409 E9, El Paso, TX, USA", "20010409 E9, El Paso, TX, USA", .data$album))

  # A fourth tagging-date typo, found while tracing duplicate gid/track rows
  # in fugazibase's durations table: this block's tagged date (27th) collided
  # with the Portland, ME show's date (also the 27th, itself just corrected
  # above) once that fix went in - both shows' tags were merging onto
  # portland-me-usa-72698's gid. The FLS listing confirms Hoboken's real date
  # is the 28th (the very next tour stop after Portland).
  fls_tags <- fls_tags %>%
    mutate(album = ifelse(.data$album == "19980727 Maxwell's, Hoboken, NJ, USA", "19980728 Maxwell's, Hoboken, NJ, USA", .data$album))

  fls_tags <- fls_tags %>%
    mutate(year = str_sub(.data$album, 1, 4),
           month = str_sub(.data$album, 5, 6),
           day = str_sub(.data$album, 7, 8),
           datestring = paste0(day, "/", month, "/", year))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(.data$datestring == "11/02/1990" , "19900211 Studio 10, Baltimore, MD, USA", .data$album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(.data$datestring == "06/09/1991" , "19910906 Desert Fest, Jawbone Canyon, CA, USA", .data$album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(.data$datestring == "14/11/1998" , "19981114 University of Wisconsin, Fire Room, Eau Claire, WI, USA", .data$album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(.data$datestring == "03/03/1999" , "19990303 Cal State University Shurmer Gym, Chico, CA, USA", .data$album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(.data$datestring == "25/04/2001" , "20010425 9:30 Club, Washington, DC, USA", .data$album))

  fls_tags <- fls_tags %>%
    mutate(date = as.Date(.data$datestring, "%d/%m/%Y"))

  fls_tags <- fls_tags %>%
    rowwise() %>%
    mutate(firstcomma = unlist(gregexpr(',', .data$album))[1])

  fls_tags <- fls_tags %>%
    rowwise() %>%
    mutate(secondcomma = unlist(gregexpr(',', .data$album))[2])

  fls_tags <- fls_tags %>%
    rowwise() %>%
    mutate(lastcomma = utils::tail(unlist(gregexpr(',', .data$album)), n=1))

  fls_tags <- fls_tags %>%
    mutate(stringlength = nchar(.data$album))

  fls_tags <- fls_tags %>%
    mutate(venue = str_sub(.data$album, 10, .data$firstcomma-1))

  fls_tags <- fls_tags %>%
    filter(.data$venue!="Mayfaur")

  fls_tags <- fls_tags %>%
    mutate(city = str_sub(.data$album, .data$firstcomma + 2, .data$secondcomma-1))

  fls_tags <- fls_tags %>%
    mutate(country = str_sub(.data$album, .data$lastcomma + 2, .data$stringlength))

  fls_tags <- fls_tags %>%
    mutate(subdivision = ifelse(.data$country=="USA", str_sub(.data$album, .data$lastcomma-2, .data$lastcomma-1),""))

  fls_tags <- fls_tags %>%
    select(.data$track, .data$album, .data$title, .data$duration, .data$seconds, date, .data$venue, .data$city, .data$subdivision, .data$country)

  date_gid <- othervariables %>%
    select(date, .data$gid)

  fls_tags <- fls_tags %>%
    left_join(date_gid)

  fls_tags <- fls_tags %>%
    filter(.data$venue!="Van Hall" | .data$gid!="gent-belgium-101688")

  fls_tags <- fls_tags %>%
    filter(.data$venue!="Democrazy" | .data$gid!="amsterdam-netherlands-101688")

  # ypsilanti-mi-eastern-michigan-university-12288 is tagged twice under two
  # album-string spellings of the same recording (identical songs/durations
  # at every track) - one with the short venue text "Eastern Michigan
  # University" and a date typo (already corrected above), one with the
  # fuller venue text "McKenny Union Ballroom, Eastern Michigan University"
  # and the correct date already. Drop the short-venue copy as a duplicate.
  fls_tags <- fls_tags %>%
    filter(!(.data$gid=="ypsilanti-mi-eastern-michigan-university-12288" & .data$venue=="Eastern Michigan University"))

  fls_tags <- fls_tags %>%
    mutate(title = ifelse(.data$gid=="peoria-il-usa-100995" & .data$title=="dance rap", "interlude 4", .data$title))

  # Two single-track mistagged track numbers, found via the same duplicate
  # gid/track trace and confirmed against each show's official FLS tracklist
  # page: each collides with a different song at the wrong track number,
  # leaving a gap at the track number they should actually have.
  fls_tags <- fls_tags %>%
    mutate(track = ifelse(.data$gid=="groningen-netherlands-90390" & .data$title=="repeater", "23", .data$track))

  fls_tags <- fls_tags %>%
    mutate(track = ifelse(.data$gid=="washington-dc-usa-72089" & .data$title=="two beats off", "16", .data$track))

  # Grouped by (gid, album) - album (not just gid) is kept as a grouping key
  # so that two distinct tag batches sharing a gid (e.g. an earlier recording
  # later superseded by an official release) still produce two rows here
  # rather than silently summing their durations together; album itself is
  # dropped from the saved table below since shows_data (joined via gid) is
  # the sole authoritative source for venue/city/subdivision/country, and
  # nothing reads fls_tags_show$album.
  fls_tags_show <- fls_tags %>%
    group_by(.data$gid, .data$album) %>%
    summarize(seconds = sum(.data$seconds)) %>%
    mutate(duration = seconds_to_period(.data$seconds)) %>%
    ungroup()

  fls_tags_show <- fls_tags_show %>%
    select(.data$gid, .data$duration, .data$seconds)

  # venue/city/subdivision/country/album are dropped from the saved table -
  # they were only ever needed transiently above (the two mistagged-track
  # filters, and fls_tags_show's group_by(gid, album)). shows_data (joined
  # via gid) is the sole authoritative source for venue/city/subdivision/
  # country, and nothing downstream reads fls_tags$album.
  fls_tags <- fls_tags %>%
    select(-.data$venue, -.data$city, -.data$subdivision, -.data$country, -.data$album)

  setwd(mydatadir)

  save(fls_tags, file = "fls_tags.rda")

  save(fls_tags_show, file = "fls_tags_show.rda")

  setwd(mydir)


  # Select the most relevant columns -------

  Repeatr1 <- Repeatr0 %>%
    select(.data$gid, date = .data$show_date, dplyr::starts_with("track_"))

  # Define date variables ----------------------------------------------------

  Repeatr1 <- Repeatr1 %>%
    mutate(date = as.Date(date, "%d/%m/%Y"))

  Repeatr1 <- Repeatr1 %>%
    mutate(year = year(date)) %>%
    relocate(year, .after=date)

  Repeatr1 <- Repeatr1 %>%
    mutate(month = month(date)) %>%
    relocate(month, .after=year)

  Repeatr1 <- Repeatr1 %>%
    mutate(day = day(date)) %>%
    relocate(day, .after=month)

  # Reshape to long format with 1 row per song -------------------------------
  # (replaces the old fixed-width V10:V53/song.1:song.44 reshape() - the
  # number of track_N columns now varies from run to run depending on the
  # longest tracklist scraped, so this must not hardcode a song count)

  Repeatr1 <- Repeatr1 %>%
    tidyr::pivot_longer(
      cols = dplyr::starts_with("track_"),
      names_to = "song_number",
      names_prefix = "track_",
      values_to = "title"
    ) %>%
    mutate(song_number = as.integer(.data$song_number))


# check list of songs with minimal changes to the names ------------------------

  raw_fls_song_list <- Repeatr1 %>%
    mutate(title = ifelse(.data$title=="And the Same", "And The Same", .data$title)) %>%
    mutate(title = ifelse(.data$title=="Back To Base", "Back to Base", .data$title)) %>%
    mutate(title = ifelse(.data$title=="Bed For The Scraping (continued)", "Bed For The Scraping", .data$title)) %>%
    mutate(title = ifelse(.data$title=="Bed for the Scraping", "Bed For The Scraping", .data$title)) %>%
    mutate(title = ifelse(.data$title=="Bed for the Scraping", "Bed For The Scraping", .data$title)) %>%
    mutate(title = ifelse(.data$title=="Give Me the Cure", "Give Me The Cure", .data$title)) %>%
    mutate(title = ifelse(.data$title=="Give me the Cure", "Give Me The Cure", .data$title)) %>%
    mutate(title = ifelse(.data$title=="In Defense of Humans", "In Defense Of Humans", .data$title)) %>%
    mutate(title = ifelse(.data$title=="Last Chance For a Slow Dance", "Last Chance For A Slow Dance", .data$title)) %>%
    mutate(title = ifelse(.data$title=="Last Chance for a Slow Dance", "Last Chance For A Slow Dance", .data$title)) %>%
    mutate(title = ifelse(.data$title=="Life And Limb", "Life and Limb", .data$title)) %>%
    mutate(title = ifelse(.data$title=="Life And Limb", "Life and Limb", .data$title)) %>%
    mutate(title = ifelse(.data$title=="Rend it", "Rend It", .data$title)) %>%
    mutate(title = ifelse(.data$title=="Returning the Screw", "Returning The Screw", .data$title)) %>%
    mutate(title = ifelse(.data$title=="Shut The Door", "Shut the Door", .data$title)) %>%
    mutate(title = ifelse(.data$title=="Sieve-Fisted FInd", "Sieve-Fisted Find", .data$title)) %>%
    mutate(title = ifelse(.data$title=="Sweet and Low", "Sweet And Low", .data$title))

  raw_fls_song_list <- raw_fls_song_list %>%
    filter(is.na(.data$title)==FALSE) %>%
    group_by(.data$title) %>%
    summarize(count = n()) %>%
    ungroup() %>%
    arrange(.data$title)

  raw_fls_song_list$tracktype <- 1

  raw_fls_song_list$title2 <- str_to_lower(raw_fls_song_list$title)

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("interlude", .data$title2)==TRUE, 0, .data$tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("encore", .data$title2)==TRUE, 0, .data$tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("intro", .data$title2)==TRUE, 0, .data$tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("track", .data$title2)==TRUE, 0, .data$tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("remarks", .data$title2)==TRUE, 0, .data$tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("crowd", .data$title2)==TRUE, 0, .data$tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("outro", .data$title2)==TRUE, 0, .data$tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("untitled", .data$title2)==TRUE, 0, .data$tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("instrumental interlude", .data$title2)==TRUE, 1, .data$tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("comedy of life", .data$title2)==TRUE, 1, .data$tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("link track", .data$title2)==TRUE, 1, .data$tracktype))

  raw_fls_song_list$title2 <- NULL

  Repeatr1 <- Repeatr1 %>%
    arrange(.data$gid, .data$song_number)

  Repeatr1 <- Repeatr1 %>%
    mutate(title = str_to_lower(.data$title))

  Repeatr1$nchar <- nchar(Repeatr1$title)

  Repeatr1 <- Repeatr1 %>%
    filter(nchar>0)

  Repeatr1$nchar <- NULL

  # add on outros

  Repeatr1_outro <- fls_tags %>%
    filter(.data$title=="outro") %>%
    select(.data$gid, date, .data$track, .data$title) %>%
    rename(song_number = .data$track) %>%
    mutate(song_number = as.numeric(.data$song_number))

  Repeatr1_outro <- Repeatr1_outro %>%
    mutate(date = as.Date(date, "%d/%m/%Y"))

  Repeatr1_outro <- Repeatr1_outro %>%
    mutate(year = year(date)) %>%
    relocate(year, .after=date)

  Repeatr1_outro <- Repeatr1_outro %>%
    mutate(month = month(date)) %>%
    relocate(month, .after=year)

  Repeatr1_outro <- Repeatr1_outro %>%
    mutate(day = day(date)) %>%
    relocate(day, .after=month)

  Repeatr1 <- rbind.data.frame(Repeatr1, Repeatr1_outro)

  # Recode variants of song titles to the main song title only in cases where there is ambiguity or inconsistency -------------------

  # keep the original title as a different variable title_original before any changes are made, so no information is lost
  Repeatr1 <- Repeatr1 %>%
    mutate(title_original = .data$title)

  Repeatr1 <- Repeatr1 %>%
    mutate(title = str_replace(.data$title, " instrumental", ""))

  Repeatr1 <- Repeatr1 %>%
    mutate(title = str_replace(.data$title, " acapella", ""))

  Repeatr1 <- Repeatr1 %>%
    mutate(title = str_replace(.data$title, " drum and bass jam", ""))

  Repeatr1 <- Repeatr1 %>%
    mutate(title = ifelse(.data$title=="bed for the scraping (continued)", "bed for the scraping", .data$title))

  Repeatr1 <- Repeatr1 %>%
    mutate(title = ifelse(.data$title=="the argument", "argument", .data$title))

  # 'promises bit' and 'promises coda' refer to the same thing but it is only the end part of promises, not the whole song.

  Repeatr1 <- Repeatr1 %>%
    mutate(title = ifelse(.data$title=="promises bit soundcheck", "promises coda", .data$title))

  Repeatr1 <- Repeatr1 %>%
    mutate(title = ifelse(.data$title=="promises coda instrumental", "promises coda", .data$title))

  Repeatr1 <- Repeatr1 %>%
    mutate(title = ifelse(.data$title=="promises bit", "promises coda", .data$title))


  # define track types: intros, interludes, sound checks -----------------------------------------------------------------

  # track types
  # 0 soundchecks, intros, interludes, encores
  # 1 released songs
  # 2 unreleased songs

  Repeatr1$tracktype <- 1

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("interlude", .data$title)==TRUE, 0, .data$tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("encore", .data$title)==TRUE, 0, .data$tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("intro", .data$title)==TRUE, 0, .data$tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("track", .data$title)==TRUE, 0, .data$tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("remarks", .data$title)==TRUE, 0, .data$tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("outside", .data$title)==TRUE, 0, .data$tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("sound check", .data$title)==TRUE, 0, .data$tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("soundcheck", .data$title)==TRUE, 0, .data$tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("crowd", .data$title)==TRUE, 0, .data$tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("outro", .data$title)==TRUE, 0, .data$tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("untitled", .data$title)==TRUE, 0, .data$tracktype))

  # Filter to remove unreleased songs or improvised one-offs ---------------------------------------

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("heart on my chest", .data$title)==TRUE, 2, .data$tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("lock dug", .data$title)==TRUE, 2, .data$tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("nedcars", .data$title)==TRUE, 2, .data$tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("noisy dub", .data$title)==TRUE, 2, .data$tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("nsa", .data$title)==TRUE, 2, .data$tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("set the charges", .data$title)==TRUE, 2, .data$tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("she is blind", .data$title)==TRUE, 2, .data$tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("surf tune", .data$title)==TRUE, 2, .data$tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("world beat", .data$title)==TRUE, 2, .data$tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("preprovisional", .data$title)==TRUE, 2, .data$tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("hello morning seed", .data$title)==TRUE, 2, .data$tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("i spent it all", .data$title)==TRUE, 2, .data$tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("strange disclosure", .data$title)==TRUE, 2, .data$tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("promises coda", .data$title)==TRUE, 2, .data$tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("ice cream", .data$title)==TRUE, 2, .data$tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("provisional medley", .data$title)==TRUE, 2, .data$tracktype))

  # Summarise the data to check frequency counts for all songs --------------

  mycount <- Repeatr1 %>%
    filter(.data$tracktype==1) %>%
    group_by(.data$title) %>%
    summarise(count= n()) %>%
    ungroup()

  # songid identifies every classified song, including one-off performances
  # and rarities - it is the stable identity used by songvarslookup and
  # everywhere else that needs to refer to "this song", not just the
  # modelling-eligible subset. Songs performed too few times can't support
  # a stable alternative-specific intercept in the choice model (Repeatr_4),
  # but that eligibility decision is a choice-model concern, not a question
  # of song identity - it's applied downstream, via `min_song_count`, in
  # Repeatr_2(), which builds the modelling-only `alt` index from this
  # songid. Keeping the two decisions separate means one-off songs still
  # get an id and Wikipedia metadata (via songvarslookup) even though they
  # can't compete as a choice-model alternative.
  mycount <- mycount %>%
    arrange((.data$title))

  mycount <- mycount %>% mutate(songid = row_number())
  mycount <- mycount %>% relocate(.data$songid)

  # Create lookup table to go from song id to song title --------------

  songidlookup <- mycount
  setwd(mydatadir)
  save(songidlookup, file="songidlookup.rda")
  setwd(mydir)

  # Redefine song index in terms of the included songs ----------------------

  Repeatr1 <- Repeatr1 %>%
    arrange(.data$gid, .data$song_number)

  Repeatr1a <- Repeatr1 %>%
    filter(.data$tracktype==1) %>%
    group_by(.data$gid) %>%
    mutate(song_number = row_number()) %>%
    ungroup()

  Repeatr1a <- Repeatr1a %>%
    mutate(first_song = ifelse(.data$song_number==1, 1, 0))

  Repeatr1a <- Repeatr1a %>%
    group_by(.data$gid) %>%
    mutate(number_songs = n()) %>%
    mutate(last_song = ifelse(.data$song_number==.data$number_songs, 1, 0)) %>%
    ungroup()

  Repeatr1a <- Repeatr1a %>%
    select(.data$gid, .data$title, .data$number_songs, .data$first_song, .data$last_song)

  Repeatr1b <- Repeatr1a %>%
    group_by(.data$gid) %>%
    slice(1) %>%
    select(.data$gid, .data$number_songs) %>%
    ungroup()

  Repeatr1a <- Repeatr1a %>%
    select(-.data$number_songs)

  Repeatr1 <- Repeatr1 %>%
    left_join(Repeatr1b)

  Repeatr1 <- Repeatr1 %>%
    left_join(Repeatr1a)

  Repeatr1 <- Repeatr1 %>%
    left_join(songidlookup)


  # add additional variables for potential use in the choice modelling.
  # Joined by song title text, not by a hardcoded songid column - the
  # hand-maintained CSV behind songvarslookup no longer carries its own
  # songid, precisely so it can't silently drift out of sync with the
  # songid computed above (see the reconciliation check just below).
  songvarslookup <- songvarslookup %>% select(.data$title, .data$rid, .data$track_number, .data$instrumental, .data$vocals_picciotto, .data$vocals_mackaye, .data$vocals_lally, .data$duration_seconds)

  Repeatr1 <- Repeatr1 %>%
    left_join(songvarslookup)

  # Reconciliation check: warn (don't stop - a new song can legitimately
  # lag the hand-maintained CSV for a while) if the live classified song
  # set and the Wikipedia CSV's song names have drifted apart, so a future
  # change to the classification rules above can't silently misattribute
  # release/duration/vocalist metadata the way it once did.
  #
  # The two directions are NOT symmetric. songvarslookup can legitimately
  # describe a song that's tracktype 0/2 (e.g. a catalogued-but-unreleased
  # rarity like "world beat"/"preprovisional" - see the "Filter to remove
  # unreleased songs or improvised one-offs" block above) and so never gets
  # a songid at all - that's expected, not drift, so this direction is
  # checked against every classified song regardless of tracktype, not just
  # songidlookup's tracktype==1 subset.
  all_classified_songs <- Repeatr1 %>% distinct(.data$title)

  songs_missing_from_songvarslookup <- anti_join(songidlookup, songvarslookup, by = "title")$title
  songs_missing_from_songidlookup <- anti_join(songvarslookup, all_classified_songs, by = "title")$title

  if (length(songs_missing_from_songvarslookup) > 0) {
    warning("Repeatr_1(): song(s) classified in the live data have no matching row in songvarslookup: ",
            paste(songs_missing_from_songvarslookup, collapse = ", "))
  }

  if (length(songs_missing_from_songidlookup) > 0) {
    warning("Repeatr_1(): song(s) in songvarslookup have no matching row anywhere in the live classified data (not even as a non-tracktype-1 rarity) - this row may be stale: ",
            paste(songs_missing_from_songidlookup, collapse = ", "))
  }

  Repeatr1 <- Repeatr1 %>% left_join(releasesdatalookup)

  # Save disaggregate data -----------------------------------

  Repeatr1 <- Repeatr1 %>%
    select(.data$gid, date, year, month, day, .data$tracktype, .data$song_number, .data$songid, .data$title, .data$number_songs, .data$first_song, .data$last_song, .data$rid,	.data$release_title, .data$track_number, .data$instrumental,	.data$vocals_picciotto,	.data$vocals_mackaye,	.data$vocals_lally,	.data$duration_seconds) %>%
    arrange(date, .data$song_number)

  # remove duplicates

  Repeatr1 <- Repeatr1 %>%
    group_by(.data$gid, .data$song_number) %>%
    slice(1) %>%
    ungroup()

  setwd(mydatadir)

  save(Repeatr1, file = "Repeatr1.rda")

  setwd(mydir)


# calculate cumulative rendition counts -----------------------------------


  mydf <- Repeatr1 %>%
    filter(.data$tracktype==1) %>%
    select(date, .data$title)

  mydf <- mydf %>%
    group_by(date, .data$title) %>%
    summarize(count=n()) %>%
    ungroup()

  mydf_wide <- mydf %>%
    pivot_wider(names_from = .data$title, values_from = count, values_fill = 0)

  mydf_wide2 <- mydf_wide

  number_columns <- ncol(mydf_wide2)

  for(colindex in 2:number_columns) {

    mydf_wide2[,colindex] <- cumsum(mydf_wide2[,colindex])

  }

  mydf_long <- mydf_wide2 %>%
    pivot_longer(!date, names_to = "title", values_to = "count") %>%
    filter(count>0)

  releases_lookup <- Repeatr1 %>%
    group_by(.data$title, .data$release_title) %>%
    summarize(count = n()) %>%
    ungroup() %>%
    select(.data$title, .data$release_title)

  mydf_long <- mydf_long %>%
    left_join(releases_lookup)

  cumulative_song_counts <- mydf_long %>%
    select(date, .data$title, .data$release_title, count)

  cumulative_song_counts <- cumulative_song_counts %>%
    mutate(release_title = tolower(.data$release_title)) %>%
    left_join(releasesdatalookup) %>%
    select(date, .data$title, .data$release_title, count, .data$release_date)

  setwd(mydatadir)

  save(cumulative_song_counts, file = "cumulative_song_counts.rda")

  setwd(mydir)


  # calculate cumulative duration counts -----------------------------------

  song_songid <- Repeatr1 %>%
    filter(.data$tracktype==1) %>%
    group_by(.data$title, .data$songid) %>%
    slice(1) %>%
    select(.data$title, .data$songid) %>%
    ungroup()

  mydf <- fls_tags %>%
    select(.data$title, .data$seconds) %>%
    mutate(minutes = round(.data$seconds/60, digits = 2)) %>%
    select(-.data$seconds) %>%
    left_join(song_songid) %>%
    filter(is.na(.data$songid)==FALSE) %>%
    select(-.data$songid)

  mydf <- mydf %>%
    group_by(.data$minutes, .data$title) %>%
    summarize(count=n()) %>% ungroup()

  mydf_wide <- mydf %>%
    pivot_wider(names_from = .data$title, values_from = count, values_fill = 0)

  mydf_wide2 <- mydf_wide

  number_columns <- ncol(mydf_wide2)

  for(colindex in 2:number_columns) {

    mydf_wide2[,colindex] <- cumsum(mydf_wide2[,colindex])

  }

  mydf_long <- mydf_wide2 %>%
    pivot_longer(!.data$minutes, names_to = "title", values_to = "count") %>%
    filter(count>0)

  releases_lookup <- Repeatr1 %>%
    group_by(.data$title, .data$release_title) %>%
    summarize(count = n()) %>%
    ungroup() %>%
    select(.data$title, .data$release_title) %>%
    filter(.data$title!="crowd")

  mydf_long <- mydf_long %>%
    left_join(releases_lookup)

  cumulative_duration_counts <- mydf_long %>%
    select(.data$minutes, .data$title, .data$release_title, count) %>%
    mutate(release_title = ifelse(is.na(.data$release_title)==TRUE, "unreleased", .data$release_title))

  setwd(mydatadir)

  save(cumulative_duration_counts, file = "cumulative_duration_counts.rda")

  setwd(mydir)

  # duration_summary is calculated later, alongside position_summary, once
  # duration_data_da exists - both are now derived from the same table (see
  # the comment there) rather than duration_summary being computed
  # separately from raw fls_tags, which used to let the two silently diverge.

# Played with data --------------------------------------------------------

    played_with <- Repeatr0 %>%
      select(.data$gid, .data$fls_id, played_with) %>%
      filter(is.na(played_with)==FALSE)

    played_with <- played_with %>%
      mutate_if(is.character, utf8::utf8_encode)

    played_with <- played_with %>%
      mutate(played_with = ifelse(.data$gid=="bielefeld-germany-103188", "Pygmies", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(.data$gid=="rome-italy-102790", "Ratos de Por\u00e3o", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(.data$gid=="ann-arbor-mi-usa-62390", "Ward, Ph\u00fcnh\u00f6gg", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(.data$gid=="bergara-spainbasque-101099", "Half Foot Outside, Lisab\u00f6", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(.data$gid=="jawbone-canyon-ca-usa-90691", "Pop Defect, Sandy Duncan\u2019s Eye, The Paper Tulips, The Offspring, The Fumes, This Great Religion, TVTV$", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(.data$gid=="washington-dc-usa-101589", "Fidelity Jones, Tiik, Lungfish, Juliana Experience, Weatherhead, Moss Icon, Dog Born Society, Choke, Cabal, All White Jury, Daryl Stover, Caroline Ely, 200 Stitches, Transilience, Neverman", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(.data$gid=="belo-horizonte-brazil-81594", "Stigmata, Jorge Cabeleira, Daizy Down, Oz, Intense Manner of Living, Virna Lisi", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(.data$gid=="winnipeg-mb-canada-81491", "Carpe Diem, Propagandhi", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(.data$gid=="savannah-ga-usa-11400", "Faraquet, The Flam", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(.data$gid=="buenos-aires-argentina-82297", "Massacre, Dixie Dynamite, Cienfuegos, Slam Up, Hiram Walker", played_with))

    played_with<-played_with %>%
      separate_rows(played_with, sep=",")

    played_with<-played_with %>%
      separate_rows(played_with, sep="&amp;")

    played_with<-played_with %>%
      separate_rows(played_with, sep="amp;")

    played_with <- played_with %>%
      mutate(played_with = str_trim(played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Shudder To Think", "Shudder to Think", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Adventures of Immortality", "Adventures In Immortality", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Assault Frontali", "Assalti Frontali", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Assaulti Frontali", "Assalti Frontali", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Darkness At Noon", "Darkness at Noon", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Dirty Districts", "Dirty District", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Genbaku Onanisu", "Genbaku Onanies", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="God Is My Co-Pulot", "God Is My Co-Pilot", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Metamatix", "Metamatics", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Missonarios", "Missionarios", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Nation Of Ulysses", "Nation of Ulysses", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Sandy Duncan's Eye", "Sandy Duncan\u2019s Eye", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Seven Souix", "Seven Sioux", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Thatcher On Acid", "Thatcher on Acid", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Vampire Lesbos", "Vampire Lezbos", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Int. Noise Conspiracy", "The International Noise Conspiracy", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Victim s Family", "Victim's Family", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Offspring", "The Offspring", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(played_with=="Boom", "The Boom", played_with))

    played_with <- played_with %>%
      filter(played_with!="?")

    played_with <- played_with %>%
      filter(played_with!="plus others")

    played_with <- played_with %>%
      group_by(.data$gid, .data$fls_id, played_with) %>%
      summarize(count = n()) %>%
      ungroup()

    played_with <- played_with %>%
      select(.data$gid, .data$fls_id, played_with)

    played_with <- played_with %>%
      arrange(.data$fls_id, played_with)

    setwd(mydatadir)

    save(played_with, file = "played_with.rda")

    setwd(mydir)

# prepare input data for Fugazetteer --------------------------------------

    setwd(mydatadir)

    releaseid_variable_colour_code <- releasesdatalookup %>%
      select(.data$rid, .data$variable, colour_code)

    save(releaseid_variable_colour_code, file = "releaseid_variable_colour_code.rda")

    transitions_data_da1 <- Repeatr1 %>%
      filter(.data$tracktype==1) %>%
      select(.data$gid,date,.data$song_number,.data$title) %>%
      rename(title1 = .data$title)

    transitions_data_da2 <- Repeatr1 %>%
      filter(.data$tracktype==1) %>%
      select(.data$gid,date,.data$song_number,.data$title) %>%
      mutate(song_number = .data$song_number-1) %>%
      rename(title2 = .data$title)

    transitions_data_da <- transitions_data_da1 %>%
      left_join(transitions_data_da2) %>%
      filter(is.na(.data$title2)==FALSE) %>%
      rename(transition = .data$song_number) %>%
      mutate(url = paste0("https://www.dischord.com/fugazi_live_series/", .data$gid)) %>%
      mutate(fls_link = paste0("<a href='",  url, "' target='_blank'>", .data$gid, "</a>")) %>%
      select(.data$gid, url, .data$fls_link, date, .data$transition, .data$title1, .data$title2) %>%
      mutate(transition = as.integer(.data$transition))

    transitions_data_da$date <- format(transitions_data_da$date,'%Y-%m-%d')

    save(transitions_data_da, file = "transitions_data_da.rda")

    rm(transitions_data_da1, transitions_data_da2)

    show_sequence <- Repeatr1 %>%
      group_by(date) %>%
      summarize(songs = n()) %>%
      ungroup() %>%
      arrange(date) %>%
      mutate(show_num = row_number(),
             last_show = max(.data$show_num))

    releases_menu_list <- releasesdatalookup %>%
      arrange(.data$rid) %>%
      filter(.data$rid!=12 & .data$rid!=14 & .data$rid!=15)

    save(releases_menu_list, file = "releases_menu_list.rda")

    colour_code <- releasesdatalookup %>%
      arrange(.data$rid) %>%
      filter(.data$rid>0) %>%
      select(.data$rid, colour_code)

    releases_data_input <- Repeatr1 %>%
      left_join(show_sequence) %>%
      left_join(colour_code) %>%
      group_by(.data$rid, .data$release_title, .data$track_number, .data$title, .data$last_show, colour_code) %>%
      summarize(count = n(),
                date=min(date),
                show_num = min(.data$show_num)) %>%
      ungroup()

    releases_data_input <- releases_data_input %>%
      arrange(desc(.data$rid), desc(.data$track_number)) %>%
      mutate(title = factor(.data$title, levels=unique(.data$title))) %>%
      mutate(release_title = factor(.data$release_title, levels=rev(unique(.data$release_title)))) %>%
      mutate(shows = .data$last_show-.data$show_num+1,
             intensity = round(count / .data$shows, digits=4)) %>%
      filter(.data$rid>0)

    save(releases_data_input, file = "releases_data_input.rda")

    releases_summary <- releases_data_input %>%
      group_by(.data$rid, .data$release_title, .data$last_show) %>%
      summarize(count = sum(count),
                songs=n(),
                first_debut=min(date),
                last_debut=max(date),
                first_show = min(.data$show_num),
                shows = round(mean(.data$shows), digits=0),
                intensity = round(mean(.data$intensity), digits = 4)) %>%
      ungroup()

    # Named distinctly (not reassigned to `releasesdatalookup`) so this
    # local date-only trim doesn't clobber the full `releasesdatalookup`
    # that gets saved to data/ and returned from this function - Repeatr_5()
    # needs the full version (release_title, rym_rating, etc.), not just these
    # two columns.
    releasesdatalookup_dates <- releasesdatalookup %>%
      select(.data$rid, .data$release_date)

    releases_summary <- releases_summary %>%
      left_join(releasesdatalookup_dates) %>%
      select(.data$rid, .data$release_title, .data$first_debut, .data$last_debut, .data$release_date, .data$songs, count, .data$shows, .data$intensity) %>%
      filter(.data$rid>0)

    save(releases_summary, file = "releases_summary.rda")

    gid_minutes <- fls_tags_show %>%
      select(.data$gid, .data$seconds) %>%
      mutate(minutes = round(.data$seconds/60, digits = 2)) %>%
      select(-.data$seconds)

    # occurrence: within-show rank of each tagged appearance of a title, by
    # tag/track order - needed so a song repeated within one show (e.g. two
    # "interlude"-style or reprised tracks) pairs up with the matching
    # Repeatr1 occurrence below instead of joining ambiguously on (gid,
    # title) alone, which either cross-multiplies rows (when both sides
    # repeat) or silently duplicates one duration onto every repeat (when
    # only Repeatr1's side does).
    gid_song_minutes <- fls_tags %>%
      mutate(minutes = round(.data$seconds/60, digits = 2)) %>%
      arrange(.data$gid, .data$title, as.numeric(.data$track)) %>%
      group_by(.data$gid, .data$title) %>%
      mutate(occurrence = row_number()) %>%
      ungroup() %>%
      select(.data$gid, .data$title, .data$occurrence, .data$minutes)

    checkmatch <- Repeatr1 %>%
      full_join(gid_song_minutes) %>%
      filter(is.na(.data$minutes)==TRUE | is.na(year)==TRUE) %>%
      arrange(date, .data$song_number)

    tour_lookup <- othervariables %>% select(.data$gid, .data$tour) %>%
      group_by(.data$gid) %>%
      slice(1) %>%
      ungroup()

    shows_data <- othervariables %>%
      filter(is.na(.data$attendance)==FALSE) %>%
      filter(is.na(.data$tour)==FALSE) %>%
      mutate(attendance = as.integer(.data$attendance)) %>%
      mutate(date = as.Date(date, "%d-%m-%Y")) %>%
      mutate(year = lubridate::year(date)) %>%
      rename(latitude = .data$y) %>%
      rename(longitude = .data$x) %>%
      select(.data$gid, .data$tour, year, date, .data$venue, .data$city, .data$subdivision, .data$country, .data$attendance, .data$price, .data$currency, .data$latitude, .data$longitude, .data$fls_notes) %>%
      mutate(urls = paste0("https://www.dischord.com/fugazi_live_series/", .data$gid)) %>%
      mutate(fls_link = paste0("<a href='",  .data$urls, "' target='_blank'>", .data$gid, "</a>")) %>%
      left_join(gid_minutes) %>%
      left_join(gid_sound_quality)

    # Safety net, matching othervariables above: gid_minutes comes from
    # fls_tags_show, which is grouped by (gid, album) - two tag batches for
    # the same show under slightly different album text (e.g. an earlier
    # recording later superseded by an official release) produce two rows
    # sharing one gid there, which would otherwise silently duplicate that
    # gid here too.
    shows_data <- shows_data %>%
      group_by(.data$gid) %>%
      slice(1) %>%
      ungroup()

    # Distances in km (issue #259) - see classify_show_trips() in R/recap.R
    # for the full home-based/tour classification. home_lat/home_lon are the
    # coordinates of the earliest-dated show (the Wilson Center, 1987 -
    # Fugazi's first ever show), used as the "home" reference point.
    home_lat <- shows_data$latitude[which.min(shows_data$date)]
    home_lon <- shows_data$longitude[which.min(shows_data$date)]

    trip_distances <- classify_show_trips(shows_data, home_lat, home_lon) %>%
      select(.data$gid, .data$distance_home_km, .data$distance_to_km, .data$distance_back_km)

    shows_data <- shows_data %>%
      left_join(trip_distances, by = "gid") %>%
      arrange(date)

    save(shows_data, file = "shows_data.rda")

    last_performance_data <- Repeatr1 %>%
      filter(.data$tracktype==1) %>%
      select(date, .data$title)%>%
      group_by(.data$title) %>%
      summarize(last_performance=max(date)) %>%
      ungroup()

    save(last_performance_data, file = "last_performance_data.rda")

    xray <- Repeatr1 %>%
      left_join(tour_lookup)

    xray <- xray %>%
      left_join(releasesdatalookup)

    xray <- xray %>%
      mutate(unreleased = ifelse(.data$tracktype==2 | (.data$tracktype==1 & date<.data$release_date),1,0))

    xray2 <- Repeatr::summary %>%
      select(.data$songid, .data$launchdate)

    xray <- xray %>%
      left_join(xray2)

    xray <- xray %>%
      mutate(debut = ifelse(date==.data$launchdate,1,0)) %>%
      mutate(debut = ifelse(is.na(.data$debut)==TRUE,0,.data$debut))

    xray <- xray %>%
      left_join(last_performance_data)

    xray <- xray %>%
      mutate(last_performance=ifelse(date==.data$last_performance,1,0)) %>%
      mutate(last_performance = ifelse(is.na(.data$last_performance)==TRUE,0,.data$last_performance))

    # occurrence: matches gid_song_minutes's own within-(gid,title) rank (see
    # its construction above) so a title repeated within one show pairs up
    # with the correct tagged occurrence, same reasoning as duration_data_da.
    xray <- xray %>%
      arrange(.data$gid, .data$title, .data$song_number) %>%
      group_by(.data$gid, .data$title) %>%
      mutate(occurrence = row_number()) %>%
      ungroup() %>%
      left_join(gid_song_minutes, by = c("gid", "title", "occurrence")) %>%
      select(-.data$occurrence)

    # remove tracks from front-end data that were not actually included in the MP3 download

    xray <- xray %>%
      filter(.data$gid!="washington-dc-usa-80793" | .data$tracktype!=0 | is.na(.data$minutes)==FALSE)

    xray <- xray %>%
      mutate(track = 1,
             songtrack = ifelse(.data$tracktype==1, 1, 0))

    xray <- xray %>%
      mutate(release_title = ifelse(is.na(.data$release_title)==TRUE, "other", .data$release_title))

    xray_tracks <- xray %>%
      mutate(units = "tracks") %>%
      mutate(year = lubridate::year(date)) %>%
      mutate(fugazi = ifelse(.data$release_title=="fugazi",1,0),
             margin_walker = ifelse(.data$release_title=="margin walker",1,0),
             three_songs = ifelse(.data$release_title=="3 songs",1,0),
             repeater = ifelse(.data$release_title=="repeater",1,0),
             steady_diet_of_nothing = ifelse(.data$release_title=="steady diet of nothing",1,0),
             in_on_the_killtaker = ifelse(.data$release_title=="in on the killtaker",1,0),
             red_medicine = ifelse(.data$release_title=="red medicine",1,0),
             end_hits = ifelse(.data$release_title=="end hits",1,0),
             the_argument = ifelse(.data$release_title=="the argument",1,0),
             furniture = ifelse(.data$release_title=="furniture",1,0),
             first_demo = ifelse(.data$release_title=="first demo",1,0),
             other = ifelse(.data$release_title=="other",1,0),
             unreleased = ifelse(.data$unreleased==1,1,0),
             songs = ifelse(.data$songtrack==1,1,0))


    xray_tracks <- xray_tracks %>%
      group_by(.data$gid, date, year, .data$tour, units) %>%
      summarize(unreleased = sum(.data$unreleased),
                debut = sum(.data$debut),
                farewell = sum(.data$last_performance),
                fugazi = sum(.data$fugazi),
                margin_walker = sum(.data$margin_walker),
                three_songs = sum(.data$three_songs),
                repeater = sum(.data$repeater),
                steady_diet_of_nothing = sum(.data$steady_diet_of_nothing),
                in_on_the_killtaker = sum(.data$in_on_the_killtaker),
                red_medicine = sum(.data$red_medicine),
                end_hits = sum(.data$end_hits),
                the_argument = sum(.data$the_argument),
                furniture = sum(.data$furniture),
                first_demo = sum(.data$first_demo),
                other = sum(.data$other),
                unreleased = sum(.data$unreleased),
                songs = sum(.data$songs)) %>%
      arrange(date) %>%
      ungroup()



    xray_minutes <- xray %>%
      mutate(units = "minutes") %>%
      mutate(year = lubridate::year(date)) %>%
      mutate(fugazi = ifelse(.data$release_title=="fugazi",ifelse(is.na(.data$minutes)==TRUE, 0, .data$minutes),0),
             margin_walker = ifelse(.data$release_title=="margin walker",ifelse(is.na(.data$minutes)==TRUE, 0, .data$minutes),0),
             three_songs = ifelse(.data$release_title=="3 songs",ifelse(is.na(.data$minutes)==TRUE, 0, .data$minutes),0),
             repeater = ifelse(.data$release_title=="repeater",ifelse(is.na(.data$minutes)==TRUE, 0, .data$minutes),0),
             steady_diet_of_nothing = ifelse(.data$release_title=="steady diet of nothing",ifelse(is.na(.data$minutes)==TRUE, 0, .data$minutes),0),
             in_on_the_killtaker = ifelse(.data$release_title=="in on the killtaker",ifelse(is.na(.data$minutes)==TRUE, 0, .data$minutes),0),
             red_medicine = ifelse(.data$release_title=="red medicine",ifelse(is.na(.data$minutes)==TRUE, 0, .data$minutes),0),
             end_hits = ifelse(.data$release_title=="end hits",ifelse(is.na(.data$minutes)==TRUE, 0, .data$minutes),0),
             the_argument = ifelse(.data$release_title=="the argument",ifelse(is.na(.data$minutes)==TRUE, 0, .data$minutes),0),
             furniture = ifelse(.data$release_title=="furniture",ifelse(is.na(.data$minutes)==TRUE, 0, .data$minutes),0),
             first_demo = ifelse(.data$release_title=="first demo",ifelse(is.na(.data$minutes)==TRUE, 0, .data$minutes),0),
             other = ifelse(.data$release_title=="other",ifelse(is.na(.data$minutes)==TRUE, 0, .data$minutes),0),
             unreleased = ifelse(.data$unreleased==1,ifelse(is.na(.data$minutes)==TRUE, 0, .data$minutes),0),
             songs = ifelse(.data$songtrack==1,ifelse(is.na(.data$minutes)==TRUE, 0, .data$minutes),0))

    xray_minutes <- xray_minutes %>%
      group_by(.data$gid, date, year, .data$tour, units) %>%
      summarize(unreleased = sum(.data$unreleased),
                debut = sum(.data$debut),
                farewell = sum(.data$last_performance),
                fugazi = sum(.data$fugazi),
                margin_walker = sum(.data$margin_walker),
                three_songs = sum(.data$three_songs),
                repeater = sum(.data$repeater),
                steady_diet_of_nothing = sum(.data$steady_diet_of_nothing),
                in_on_the_killtaker = sum(.data$in_on_the_killtaker),
                red_medicine = sum(.data$red_medicine),
                end_hits = sum(.data$end_hits),
                the_argument = sum(.data$the_argument),
                furniture = sum(.data$furniture),
                first_demo = sum(.data$first_demo),
                other = sum(.data$other),
                unreleased = sum(.data$unreleased),
                songs = sum(.data$songs)) %>%
      arrange(date) %>%
      ungroup()

    xray <- rbind.data.frame(xray_tracks, xray_minutes)

    xray <- xray %>%
      arrange(units, date)

    # `other`'s per-track minutes rely on a (gid, title, occurrence) join to
    # gid_song_minutes that fails for hand-relabeled non-song titles (e.g.
    # "interlude 1") not matching the raw tag text, silently undercounting
    # other by up to 30+ minutes on some shows. songs' own join is reliable
    # (verified: matches sum(duration_data_da$minutes) exactly on every
    # show), so redefine other as the residual instead, which is correct by
    # construction and only applies to the minutes rows (tracks rows count
    # tracktype directly and aren't affected by this join at all).
    xray <- xray %>%
      left_join(gid_minutes %>% rename(total_minutes = .data$minutes), by = "gid") %>%
      mutate(other = ifelse(units=="minutes", .data$total_minutes - .data$songs, .data$other)) %>%
      select(-.data$total_minutes)

    xray <- xray %>%
      mutate(released = .data$songs - .data$unreleased,
             incumbent = .data$songs - .data$debut - .data$farewell)

    xray <- xray %>%
      mutate(url = paste0("https://www.dischord.com/fugazi_live_series/", .data$gid)) %>%
      mutate(fls_link = paste0("<a href='",  url, "' target='_blank'>", .data$gid, "</a>"))

    xray <- xray %>%
      relocate(.data$gid, url, .data$fls_link, year, .data$tour, date, units, .data$songs, .data$released, .data$unreleased, .data$other, .data$debut, .data$farewell, .data$incumbent, .data$other)

    rm(xray_minutes, xray_tracks, xray2)

    save(xray, file = "xray.rda")

    # occurrence: within-show rank of each song_number by title, matched
    # against gid_song_minutes's own by-tag-order rank (see its own comment
    # above) - pairs repeated performances of the same song within a show up
    # correctly instead of joining ambiguously on (gid, title) alone. This
    # replaces what used to be five hardcoded per-gid/song_number filters
    # patching a handful of "fake duplicates" the old (gid, title)-only join
    # produced - no longer needed once the join itself is unambiguous.
    duration_data_da <- Repeatr1 %>%
      filter(.data$tracktype==1) %>%
      select(.data$gid,date, .data$song_number, .data$title) %>%
      mutate(urls = paste0("https://www.dischord.com/fugazi_live_series/", .data$gid)) %>%
      mutate(fls_link = paste0("<a href='",  .data$urls, "' target='_blank'>", .data$gid, "</a>")) %>%
      arrange(.data$gid, .data$title, .data$song_number) %>%
      group_by(.data$gid, .data$title) %>%
      mutate(occurrence = row_number()) %>%
      ungroup() %>%
      left_join(gid_song_minutes, by = c("gid", "title", "occurrence")) %>%
      select(-.data$occurrence)

    # A gid with no recording at all (every row above unmatched) shouldn't
    # appear here as a phantom all-NA "recording" - e.g.
    # washington-dc-usa-100688 is a real show per the FLS site's own flyer,
    # but its page comments confirm no recording survives for it (the audio
    # posted there is a mislabeled copy of washington-dc-usa-61588's).
    # Besides being wrong on its own terms, leaving such rows in would
    # occupy real slots in the rendition-count ranking downstream (recap())
    # for every title involved.
    duration_data_da <- duration_data_da %>%
      group_by(.data$gid) %>%
      filter(any(is.na(.data$minutes)==FALSE)) %>%
      ungroup()

    duration_data_da <- duration_data_da %>%
      group_by(.data$gid) %>%
      mutate(first_song_number = min(.data$song_number),
             last_song_number = max(.data$song_number),
             position = ifelse(.data$last_song_number > .data$first_song_number,
                                round((.data$song_number - .data$first_song_number) / (.data$last_song_number - .data$first_song_number), digits = 2),
                                0)) %>%
      ungroup() %>%
      select(-.data$first_song_number, -.data$last_song_number)

    save(duration_data_da, file = "duration_data_da.rda")

    mydf_pos <- duration_data_da %>%
      select(.data$position, .data$title) %>%
      group_by(.data$position, .data$title) %>%
      summarize(count = n()) %>%
      ungroup()

    mydf_pos_wide <- mydf_pos %>%
      pivot_wider(names_from = .data$title, values_from = count, values_fill = 0)

    mydf_pos_wide2 <- mydf_pos_wide
    number_columns_pos <- ncol(mydf_pos_wide2)
    for (colindex in 2:number_columns_pos) {
      mydf_pos_wide2[,colindex] <- cumsum(mydf_pos_wide2[,colindex])
    }

    mydf_pos_long <- mydf_pos_wide2 %>%
      pivot_longer(!.data$position, names_to = "title", values_to = "count") %>%
      filter(count>0) %>%
      left_join(releases_lookup)

    cumulative_position_counts <- mydf_pos_long %>%
      select(.data$position, .data$title, .data$release_title, count) %>%
      mutate(release_title = ifelse(is.na(.data$release_title)==TRUE, "unreleased", .data$release_title))

    save(cumulative_position_counts, file = "cumulative_position_counts.rda")

    position_summary <- duration_data_da %>%
      group_by(.data$title) %>%
      summarize(renditions = n(),
                position_min = round(min(.data$position), digits = 2),
                position_median = round(stats::median(.data$position), digits = 2),
                position_max = round(max(.data$position), digits = 2),
                position_mean = round(mean(.data$position), digits = 2),
                position_sd = round(stats::sd(.data$position), digits = 2)) %>%
      ungroup()

    save(position_summary, file = "position_summary.rda")

    # duration_summary used to be calculated straight from raw fls_tags,
    # independently of duration_data_da/position_summary - the two tables'
    # renditions counts would then silently diverge whenever fls_tags and
    # Repeatr1's tracktype==1 classification disagreed on how many times a
    # song was recorded (repeated-within-show mismatches, mainly). Deriving
    # it from duration_data_da instead, the same way position_summary is
    # built just above, means the two are consistent by construction. A
    # handful of individual occurrences have no matched duration (fls_tags
    # tagged fewer repeats of a title than Repeatr1 classified within that
    # show - a real, pre-existing data gap) - na.rm=TRUE skips only those
    # rows' minutes, not the whole title, and they still count toward
    # renditions since the performance itself is real.
    duration_summary <- duration_data_da %>%
      group_by(.data$title) %>%
      summarize(renditions = n(),
                minutes_min = round(min(.data$minutes, na.rm = TRUE), digits = 2),
                minutes_median = round(stats::median(.data$minutes, na.rm = TRUE), digits = 2),
                minutes_max = round(max(.data$minutes, na.rm = TRUE), digits = 2),
                minutes_mean = round(mean(.data$minutes, na.rm = TRUE), digits = 2),
                minutes_sd = round(stats::sd(.data$minutes, na.rm = TRUE), digits = 2)) %>%
      ungroup() %>%
      mutate(minutes_total = round(.data$renditions*.data$minutes_mean, digits = 2))

    save(duration_summary, file = "duration_summary.rda")

    othervariables <- othervariables %>%
      left_join(gid_sound_quality) %>%
      mutate(urls = paste0("https://www.dischord.com/fugazi_live_series/", .data$gid)) %>%
      mutate(fls_link = paste0("<a href='",  .data$urls, "' target='_blank'>", .data$gid, "</a>"))

    played_with <- played_with %>%
      select(.data$gid, played_with)

    played_with_data <- othervariables %>%
      left_join(played_with)

    played_with_data <- played_with_data %>%
      rename(latitude = .data$y, longitude = .data$x) %>%
      mutate(attendance = round(.data$attendance, 0))

    played_with_data <- played_with_data %>%
      select(.data$gid, .data$fls_link, year, .data$tour, date, .data$venue, .data$city, .data$country, played_with, .data$attendance, .data$sound_quality, .data$latitude, .data$longitude)

    played_with_summary <- played_with_data %>%
      group_by(year, .data$tour, played_with) %>%
      summarize(shows = n()) %>%
      arrange(desc(.data$shows)) %>%
      ungroup()

    save(played_with_summary, file = "played_with_summary.rda")

    setwd(mydir)


# finishing up ------------------------------------------------------------



  myreturnlist <- list(Repeatr0, Repeatr1, songidlookup, mycount, songvarslookup, releasesdatalookup, othervariables, cumulative_song_counts, fls_tags, fls_tags_show, cumulative_duration_counts, releases_data_input, raw_fls_song_list)

  return(myreturnlist)

}


