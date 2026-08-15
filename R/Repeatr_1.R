
#' @name Repeatr_1
#' @title imports raw data (1 row per show), cleans the data, and reshapes it long so that the rows are identified by combinations of gid and song_number.
#' @description Reads its raw inputs from this package's own `inst/extdata/` by default: `fls_data.csv` (one row per show, produced by \code{\link{scrape_fls_shows}}; `tour`, `city`, `subdivision`, and `country` all come from the FLS listing pages' own filter links/tour headings - see \code{\link{scrape_fls_listing_data}}), `releases_songs_durations_wikipedia.csv` (Wikipedia discography metadata), `releases.csv` (release metadata), `fls_venue_geocoding_v2.csv` (venue coordinates), and `fls_tags.txt` (tag/duration data, via \code{\link{fls_tags_importer}}). Each can be overridden with an explicit data frame instead - see the parameters below.
#' @description "gid" is short for "gig id"
#' @description `songvarslookup` (read from `inst/extdata/releases_songs_durations_wikipedia.csv`) contains the following variables: rid	track_number	title	instrumental	vocals_picciotto	vocals_mackaye	vocals_lally	duration_seconds. It is joined onto the live, classified song set by `title` text, not by a hardcoded id column - see `songid` below.

#'
#' @import dplyr
#' @import tidyr
#' @import stringr
#' @import lubridate
#' @import fastDummies
#' @import rlang
#' @import knitr
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

  Repeatr0 <- if (is.null(myfls_data)) read.csv(system.file("extdata", "fls_data.csv", package = "Repeatr"), header = TRUE) else myfls_data

  # gid_sound_quality used to be a static dataset with no regeneration path -
  # it's now rebuilt live from Repeatr0 every run, same gid/sound_quality
  # shape as before, so the left_join(gid_sound_quality) calls further down
  # need no other change.

  gid_sound_quality <- Repeatr0 %>%
    select(gid, sound_quality) %>%
    filter(is.na(sound_quality)==FALSE)

  # washington-dc-usa-100688 (10/6/88) has no surviving recording - the FLS
  # site's own page comments confirm this, and the audio posted there is
  # actually a mislabeled copy of the 6/15/88 recording (gid
  # washington-dc-usa-61588, correctly dated in fls_tags). Its sound_quality
  # rating describes that other recording, not a real one for this date.
  gid_sound_quality <- gid_sound_quality %>%
    filter(gid!="washington-dc-usa-100688")

  songvarslookup <- if (is.null(mysongvarslookup)) read.csv(system.file("extdata", "releases_songs_durations_wikipedia.csv", package = "Repeatr"), header = TRUE) else mysongvarslookup
  songvarslookup <- songvarslookup %>%
    rename(title = song, rid = releaseid)

  save(songvarslookup, file = file.path(mydatadir, "songvarslookup.rda"))

  song_tempo_bpm_data <- read.csv(system.file("extdata", "song_tempo_bpm_data.csv", package = "Repeatr"), header = TRUE)
  song_tempo_bpm_data <- song_tempo_bpm_data %>%
    rename(title = song)
  save(song_tempo_bpm_data, file = file.path(mydatadir, "song_tempo_bpm_data.rda"))

  releasesdatalookup <- if (is.null(myreleases)) read.csv(system.file("extdata", "releases.csv", package = "Repeatr"), header = TRUE) else myreleases
  releasesdatalookup$X <- NULL
  releasesdatalookup <- releasesdatalookup %>%
    rename(rid = releaseid, release_title = release, release_date = releasedate) %>%
    mutate(release_date = as.Date(release_date, "%d/%m/%Y"))

  othervariables <- Repeatr0 %>%
    select(gid, fls_id, show_date, venue, door_price, attendance, recorded_by, mastered_by, original_source, fls_notes, tour, city, subdivision, country)

  othervariables <- othervariables %>%
    rename(flsid = fls_id, date = show_date, doorprice = door_price)

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
    mutate(attendance = as.numeric(attendance))

  othervariables <- othervariables %>%
    mutate(country = ifelse(flsid=="FLS0970", "USA", country),
           country = ifelse(city=="Ljubljana" & year>=1991, "Slovenia", country),
           country = ifelse(city=="Prague" & year<=1992, "Czechoslovakia", country),
           city = ifelse(flsid=="FLS0970", "San Francisco", city),
           x = ifelse(flsid=="FLS0970", -122.4272376, x),
           y = ifelse(flsid=="FLS0970", 37.760407, y),
           tour = ifelse(flsid=="FLS0970", "2000 Summer/Fall Regional Dates", tour),
           tour = ifelse(tour=="1993 Fall USA/Canda Tour", "1993 Fall USA/Canada Tour", tour),
           year = ifelse(flsid=="FLS0970", 2000, year),
           recorded_by = ifelse(flsid=="FLS0970", "Stephen Kozlowski", recorded_by),
           checked = ifelse(flsid=="FLS0970", 1, checked))

  othervariables <- othervariables %>%
    mutate(city = ifelse(city=="Wesleyan", "Middletown", city))

  # mastered_by/original_source cleanup: a handful of raw scraped values are
  # a typo (missing hyphen) or too terse to be useful downstream.
  othervariables <- othervariables %>%
    mutate(mastered_by = ifelse(mastered_by=="Warren Russell Smith", "Warren Russell-Smith", mastered_by),
           original_source = case_when(
             original_source == "?" ~ "Unknown",
             original_source == "VHS" ~ "VHS audio",
             original_source == "VHS Tape" ~ "VHS audio",
             TRUE ~ original_source
           ))

  # washington-dc-usa-100688 (10/6/88) is a real, distinct show (confirmed
  # against the site's own flyer - date/venue/played_with/door
  # price/attendance are untouched), but the page's own comments confirm no
  # recording survives for this date - the audio posted there is actually a
  # mislabeled copy of the 6/15/88 recording. These three fields describe
  # that other recording, not one that exists for this show.
  othervariables <- othervariables %>%
    mutate(recorded_by = ifelse(gid=="washington-dc-usa-100688", NA_character_, recorded_by),
           mastered_by = ifelse(gid=="washington-dc-usa-100688", NA_character_, mastered_by),
           original_source = ifelse(gid=="washington-dc-usa-100688", NA_character_, original_source))

  # One-off data-entry error on the site: this Hobart show's own "State"
  # filter link reads "TZ", while every other Hobart/Launceston show says
  # "TAS" - not a real distinct designation, just a typo to correct.
  othervariables <- othervariables %>%
    mutate(subdivision = ifelse(city=="Hobart" & country=="Australia" & subdivision=="TZ", "TAS", subdivision))

  # The FLS site's own "State" filter link is blank for a number of
  # Australian shows (and wrong - "NSW" - for every Canberra show, which is
  # actually in the Australian Capital Territory) even though every one of
  # these cities is unambiguously in a single state/territory. Fill/correct
  # them here rather than leaving subdivision blank, since app.R uses
  # subdivision to disambiguate city names (e.g. "Newcastle, NSW" vs
  # "Newcastle-Upon-Tyne"). Verified against each venue's own coordinates in
  # fls_venue_geocoding_v2.csv.
  othervariables <- othervariables %>%
    mutate(subdivision = ifelse(country=="Australia" & city=="Adelaide", "SA", subdivision),
           subdivision = ifelse(country=="Australia" & city=="Ballarat", "VIC", subdivision),
           subdivision = ifelse(country=="Australia" & city=="Brisbane", "QLD", subdivision),
           subdivision = ifelse(country=="Australia" & city=="Canberra", "ACT", subdivision),
           subdivision = ifelse(country=="Australia" & city=="Darwin", "NT", subdivision),
           subdivision = ifelse(country=="Australia" & city=="Geelong", "VIC", subdivision),
           subdivision = ifelse(country=="Australia" & city=="Lismore", "NSW", subdivision),
           subdivision = ifelse(country=="Australia" & city=="Manly", "NSW", subdivision),
           subdivision = ifelse(country=="Australia" & city=="Melbourne", "VIC", subdivision),
           subdivision = ifelse(country=="Australia" & city=="Newcastle", "NSW", subdivision),
           subdivision = ifelse(country=="Australia" & city=="Perth", "WA", subdivision),
           subdivision = ifelse(country=="Australia" & city=="Sydney", "NSW", subdivision),
           subdivision = ifelse(country=="Australia" & city=="Wollongong", "NSW", subdivision))

  # The FLS site's own scrape never populates subdivision outside the US/
  # Canada/Australia, so Brazil's 12 tour cities are filled in here from a
  # hand-verified city lookup (checked against each city's own coordinates in
  # fls_venue_geocoding_v2.csv).
  othervariables <- othervariables %>%
    mutate(subdivision = case_when(
      country == "Brazil" & city == "Belo Horizonte" ~ "MG",
      country == "Brazil" & city == "Brasilia" ~ "DF",
      country == "Brazil" & city == "Campinas" ~ "SP",
      country == "Brazil" & city == "Curitiba" ~ "PR",
      country == "Brazil" & city == "Itaborai" ~ "RJ",
      country == "Brazil" & city == "Joinville" ~ "SC",
      country == "Brazil" & city == "Londrina" ~ "PR",
      country == "Brazil" & city == "Piracicaba" ~ "SP",
      country == "Brazil" & city == "Rio De Janeiro" ~ "RJ",
      country == "Brazil" & city == "Santos" ~ "SP",
      country == "Brazil" & city == "Sao Paulo" ~ "SP",
      country == "Brazil" & city == "Vitoria" ~ "ES",
      TRUE ~ subdivision
    ))

  # Any subdivision still blank at this point is a pre-existing mix of NA and
  # "" for shows outside the US/Canada/Australia/Brazil - standardize to NA.
  othervariables <- othervariables %>%
    mutate(subdivision = ifelse(subdivision == "", NA_character_, subdivision))

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
  doorprice_lookup <- read.csv(system.file("extdata", "fls_doorprice_currency_lookup.csv", package = "Repeatr"), header = TRUE, colClasses = c(doorprice = "character", price = "numeric", currency = "character", note = "character"))

  othervariables <- othervariables %>%
    left_join(doorprice_lookup, by = "doorprice") %>%
    mutate(
      price = ifelse(doorprice == "Free", 0, price),
      currency = case_when(
        doorprice == "Free" & country == "Italy" ~ "ITL",
        doorprice == "Free" ~ "USD",
        TRUE ~ currency
      )
    ) %>%
    select(-doorprice, -note)

  # Do NOT filter out rows with no x/y here - a show's coordinates may only
  # come from a later source (the disambiguation-corrected city match, the
  # many hardcoded per-venue x/y corrections below, or the
  # fls_venue_geocoding join near the end of this function). The filter runs
  # at the very end, after every coordinate source has had its turn.

  # Disambiguation

  othervariables <- othervariables %>%
    mutate(city = ifelse(country=="England" & city=="Newcastle", "Newcastle-Upon-Tyne", city),
           city = ifelse(country=="USA" & city=="Oxford", "Oxford (USA)", city),
           city = ifelse(country=="Australia" & city=="Croydon", "Croydon (Australia)", city),
           city = ifelse(country=="Australia" & city=="Newcastle", "Newcastle (Australia)", city),
           # Portland and Columbia each cover multiple, differently-located
           # US cities of the same name - fls_venue_geocoding_v2.csv
           # disambiguates them as "City (ST)", so match that convention
           # using the subdivision scraped alongside city/country, or these
           # venues' coordinates can never be found there.
           city = ifelse(country=="USA" & city=="Portland" & is.na(subdivision)==FALSE, paste0("Portland (", subdivision, ")"), city),
           city = ifelse(country=="USA" & city=="Columbia" & is.na(subdivision)==FALSE, paste0("Columbia (", subdivision, ")"), city))

  othervariables <- othervariables %>%
    mutate(venue = ifelse(country=="USA" & city=="Washington" & venue=="9:30 Club" & year<=1995, "9:30 Club (1980-1995)", venue),
           x = ifelse(country=="USA" & city=="Washington" & venue=="9:30 Club (1980-1995)" & year<=1995, -77.0255867, x),
           y = ifelse(country=="USA" & city=="Washington" & venue=="9:30 Club (1980-1995)" & year<=1995, 38.8971517, y))


  othervariables <- othervariables %>%
    mutate(venue = ifelse(flsid=="FLS0050", "Frankford YWCA", venue))

  othervariables <- othervariables %>%
    mutate(venue = ifelse(flsid=="FLS0478", "Tempodrom", venue))

  # correct values where necessary

  othervariables <- othervariables %>%
    mutate(x = ifelse(city=="Newcastle-Upon-Tyne" & venue=="Riverside", -1.6051, x),
           y = ifelse(city=="Newcastle-Upon-Tyne" & venue=="Riverside", 54.9717, y),
           checked = ifelse(city=="Newcastle-Upon-Tyne" & venue=="Riverside", 1, checked),
           x = ifelse(city=="Lisbon" & venue=="Gartejo", -9.1755975, x),
           y = ifelse(city=="Lisbon" & venue=="Gartejo", 38.7042177, y),
           checked = ifelse(city=="Lisbon" & venue=="Gartejo", 1, checked),
           x = ifelse(country == "Japan" & city=="Osaka" & venue=="AM Hall", 135.4995612, x),
           y = ifelse(country == "Japan" & city=="Osaka" & venue=="AM Hall", 34.7012144, y),
           checked = ifelse(country == "Japan" & city=="Osaka" & venue=="AM Hall", 1, checked),
           x = ifelse(country == "Japan" & city=="Osaka" & venue=="Sun Hall", 135.4808578, x),
           y = ifelse(country == "Japan" & city=="Osaka" & venue=="Sun Hall", 34.6709861, y),
           checked = ifelse(country == "Japan" & city=="Osaka" & venue=="Sun Hall", 1, checked),
           x = ifelse(country == "Japan" & city=="Nagoya" & venue=="Club Quattro", 136.9082324, x),
           y = ifelse(country == "Japan" & city=="Nagoya" & venue=="Club Quattro", 35.1637276, y),
           checked = ifelse(country == "Japan" & city=="Nagoya" & venue=="Club Quattro", 1, checked),
           x = ifelse(country == "Japan" & city=="Nagoya" & venue=="Heartland", 136.9192034, x),
           y = ifelse(country == "Japan" & city=="Nagoya" & venue=="Heartland", 35.1693198, y),
           checked = ifelse(country == "Japan" & city=="Nagoya" & venue=="Heartland", 1, checked),
           x = ifelse(country == "USA" & city=="San Francisco" & venue=="Women's Building", -122.4228365, x),
           y = ifelse(country == "USA" & city=="San Francisco" & venue=="Women's Building", 37.7614483, y),
           checked = ifelse(country == "USA" & city=="San Francisco" & venue=="Women's Building", 1, checked),
           x = ifelse(country == "USA" & city=="San Francisco" & venue=="Russian Theater", -122.4413234, x),
           y = ifelse(country == "USA" & city=="San Francisco" & venue=="Russian Theater", 37.7854355, y),
           checked = ifelse(country == "USA" & city=="San Francisco" & venue=="Russian Theater", 1, checked),
           x = ifelse(country == "USA" & city=="San Francisco" & venue=="Fort Mason Pier C", -122.4314681, x),
           y = ifelse(country == "USA" & city=="San Francisco" & venue=="Fort Mason Pier C", 37.8067481, y),
           checked = ifelse(country == "USA" & city=="San Francisco" & venue=="Fort Mason Pier C", 1, checked),
           x = ifelse(country == "USA" & city=="San Francisco" & venue=="Trocadero Transfer", -122.3982015, x),
           y = ifelse(country == "USA" & city=="San Francisco" & venue=="Trocadero Transfer", 37.7790623, y),
           checked = ifelse(country == "USA" & city=="San Francisco" & venue=="Trocadero Transfer", 1, checked),
           x = ifelse(country == "USA" & city=="San Francisco" & venue=="Maritime", -122.3936571, x),
           y = ifelse(country == "USA" & city=="San Francisco" & venue=="Maritime", 37.7864189, y),
           checked = ifelse(country == "USA" & city=="San Francisco" & venue=="Maritime", 1, checked),
           x = ifelse(country == "Germany" & city=="Bremen" & venue=="Schlachthof", 8.8099035, x),
           y = ifelse(country == "Germany" & city=="Bremen" & venue=="Schlachthof", 53.0884866, y),
           checked = ifelse(country == "Germany" & city=="Bremen" & venue=="Schlachthof", 1, checked),
           x = ifelse(country == "Canada" & city=="Ottawa" & venue=="Carleton University Porter Hall", -75.6978497, x),
           y = ifelse(country == "Canada" & city=="Ottawa" & venue=="Carleton University Porter Hall", 45.3840001, y),
           checked = ifelse(country == "Canada" & city=="Ottawa" & venue=="Carleton University Porter Hall", 1, checked),
           x = ifelse(country == "Australia" & city=="Sydney" & (venue=="Metro Theatre" | venue=="Metro"), 151.2066274, x),
           y = ifelse(country == "Australia" & city=="Sydney" & (venue=="Metro Theatre" | venue=="Metro"), -33.8756943, y),
           checked = ifelse(country == "Australia" & city=="Sydney" & (venue=="Metro Theatre" | venue=="Metro"), 1, checked),
           x = ifelse(country == "USA" & city=="Watsonville" & venue=="Veteran's Memorial Hall", -121.7545246, x),
           y = ifelse(country == "USA" & city=="Watsonville" & venue=="Veteran's Memorial Hall", 36.9126013, y),
           checked = ifelse(country == "USA" & city=="Watsonville" & venue=="Veteran's Memorial Hall", 1, checked),
           x = ifelse(country == "Australia" & city=="Wollongong" & venue=="Youth Centre", 150.8928958, x),
           y = ifelse(country == "Australia" & city=="Wollongong" & venue=="Youth Centre", -34.4264333, y),
           checked = ifelse(country == "Australia" & city=="Wollongong" & venue=="Youth Centre", 1, checked),
           x = ifelse(country == "USA" & city=="Fayetteville" & venue=="Studio 225", -94.1667044, x),
           y = ifelse(country == "USA" & city=="Fayetteville" & venue=="Studio 225", 36.0657152, y),
           checked = ifelse(country == "USA" & city=="Fayetteville" & venue=="Studio 225", 1, checked),
           x = ifelse(country == "USA" & city=="Columbia (SC)" & venue=="Dance Graphics", -81.0175133, x),
           y = ifelse(country == "USA" & city=="Columbia (SC)" & venue=="Dance Graphics", 34.0032201, y),
           checked = ifelse(country == "USA" & city=="Columbia (SC)" & venue=="Dance Graphics", 1, checked),
           x = ifelse(country == "Brazil" & city=="Sao Paulo" & venue=="Aeroanta", -46.6949865, x),
           y = ifelse(country == "Brazil" & city=="Sao Paulo" & venue=="Aeroanta", -23.5651133, y),
           checked = ifelse(country == "Brazil" & city=="Sao Paulo" & venue=="Aeroanta", 1, checked),
           venue = ifelse(venue=="Zepplin Rock", "Zeppelin Rock", venue),
           city = ifelse(city=="San.De Campostela", "Santiago de Compostela", city),
           x = ifelse(city=="Huntington" & venue=="Stone Monkey", -82.4201034, x),
           y = ifelse(city=="Huntington" & venue=="Stone Monkey", 38.4272709, y),
           checked = ifelse(city=="Huntington" & venue=="Stone Monkey", 1, checked))

  # Correct country
  othervariables <- othervariables %>%
    mutate(country = ifelse((city=="Belfast" | city=="Derry"), "Northern Ireland", country),
           country = ifelse(flsid=="FLS0970", "USA", country))

  # Correct location of Queen's Hall, Belfast
  othervariables <- othervariables %>%
    mutate(x = ifelse(country == "Northern Ireland" & city=="Belfast" & (venue=="Queen's Hall" | venue=="Queen's University Mandela Hall"), -5.9374134, x),
           y = ifelse(country == "Northern Ireland" & city=="Belfast" & (venue=="Queen's Hall" | venue=="Queen's University Mandela Hall"), 54.5846991, y),
           checked = ifelse(country == "Northern Ireland" & city=="Belfast" & (venue=="Queen's Hall" | venue=="Queen's University Mandela Hall"), 1, checked))

  # Correct location of Rototom
  othervariables <- othervariables %>%
    mutate(city = ifelse(venue=="Rototom", "Gaio di Spilimbergo", city))

  # Correct venue of 1995 Copenhagen show
  othervariables <- othervariables %>%
    mutate(venue = ifelse(gid=="copenhagen-denmark-71095", "Rockmaskinen", venue),
           x = ifelse(gid=="copenhagen-denmark-71095", 12.5994855, x),
           y = ifelse(gid=="copenhagen-denmark-71095", 55.6737142, y))

  # Correct venue of Loppen
  othervariables <- othervariables %>%
    mutate(x = ifelse(gid=="copenhagen-denmark-100700", 12.5973313, x),
           y = ifelse(gid=="copenhagen-denmark-100700", 55.6740572, y))

  # Correct venue of 1988 Nottingham show
  othervariables <- othervariables %>%
    mutate(x = ifelse(gid=="nottingham-england-112788", -1.1349991, x),
           y = ifelse(gid=="nottingham-england-112788", 52.9558396, y))

  # Correct venue name and location for 1995 quebec city show
  othervariables <- othervariables %>%
    mutate(venue = ifelse(gid=="quebec-city-qc-canada-92495", "Cégep Limoilou", venue))

  othervariables <- othervariables %>%
    mutate(x = ifelse(gid=="quebec-city-qc-canada-92495", -71.2283038, x),
           y = ifelse(gid=="quebec-city-qc-canada-92495", 46.8305332, y))

  # Correct venue name https://www.dischord.com/fugazi_live_series/campinas-brazil-81997
  # Assampi = Associação de amigos do Parque Industrial
  othervariables <- othervariables %>%
    mutate(venue = ifelse(gid=="campinas-brazil-81997", "Assampi", venue))

  # Correct venue name https://www.dischord.com/fugazi_live_series/joinville-brazil-81597
  # Liga da Sociedade Joinvilense
  othervariables <- othervariables %>%
    mutate(venue = ifelse(gid=="joinville-brazil-81597", "Liga da Sociedade Joinvilense", venue))

  # Correct venue name for 1998 quebec city show https://dischord.com/fugazi_live_series/quebec-city-qc-canada-72298
  othervariables <- othervariables %>%
    mutate(venue = ifelse(gid=="quebec-city-qc-canada-72298", "Centre des Loisirs Saint-Sacrement", venue))

  # impute values where they are missing
  meanattendance <- othervariables %>%
    filter(is.na(tour)==FALSE) %>%
    filter(is.na(attendance)==FALSE) %>%
    group_by(year) %>%
    summarise(meanattendance = mean(attendance)) %>%
    ungroup()

  othervariables <- othervariables %>%
    filter(is.na(tour)==FALSE) %>%
    left_join(meanattendance) %>%
    mutate(attendance = ifelse(is.na(attendance)==TRUE,meanattendance,attendance))

  othervariables <- othervariables %>%
    select(-meanattendance)

  othervariables <- othervariables %>%
    relocate(checked, .after = year)

  # inst/extdata/fls_venue_geocoding_v2.csv is the source of truth for venue
  # coordinates (a periodically-refreshed local snapshot of a private
  # Google Sheet - not read live, since that sheet isn't reliably
  # available). Every coordinate in this table is treated as
  # checked/confirmed.
  fls_venue_geocoding_source <- if (is.null(myfls_venue_geocoding)) read.csv(system.file("extdata", "fls_venue_geocoding_v2.csv", package = "Repeatr"), header = TRUE) else myfls_venue_geocoding

  fls_venue_geocoding_update <- fls_venue_geocoding_source %>%
    select(country, city, venue, x, y) %>%
    rename(link_x = x, link_y = y) %>%
    filter(is.na(link_x)==FALSE) %>%
    mutate(geocoding_check=1)

  othervariables <- othervariables %>%
    left_join(fls_venue_geocoding_update)

  othervariables <- othervariables %>%
    mutate(x = ifelse(is.na(link_x)==FALSE, link_x, x),
           y = ifelse(is.na(link_y)==FALSE, link_y, y),
           checked = ifelse(is.na(geocoding_check)==FALSE, geocoding_check, checked))

  othervariables <- othervariables %>%
    select(-link_x, -link_y, -geocoding_check)

  # The "City (ST)"/"City (Country)" disambiguation suffix injected above
  # (Portland, Columbia, Croydon, Oxford, Newcastle) exists only so the join
  # against fls_venue_geocoding_v2.csv above can find the right coordinates -
  # subdivision/country already carry the same disambiguating information
  # untouched, so strip the suffix back off now that its job is done. Oxford
  # and Newcastle (Australia) now rely on their (newly-populated) subdivision
  # for disambiguation instead of a permanent country suffix, same as the
  # others - see app.R's city/subdivision concatenation.
  othervariables <- othervariables %>%
    mutate(city = ifelse(city=="Portland (OR)", "Portland", city),
           city = ifelse(city=="Portland (ME)", "Portland", city),
           city = ifelse(city=="Columbia (SC)", "Columbia", city),
           city = ifelse(city=="Columbia (MO)", "Columbia", city),
           city = ifelse(city=="Columbia (MD)", "Columbia", city),
           city = ifelse(city=="Croydon (Australia)", "Croydon", city),
           city = ifelse(city=="Oxford (USA)", "Oxford", city),
           city = ifelse(city=="Newcastle (Australia)", "Newcastle", city),
           # "Springfield (MO)"/"Springfield (OR)" were disambiguated this way
           # in inst/extdata/fls_data.csv itself (for the same reason - matching
           # fls_venue_geocoding's join key) but are just as
           # subdivision-disambiguated as Portland, so strip them back here too.
           city = ifelse(city=="Springfield (MO)", "Springfield", city),
           city = ifelse(city=="Springfield (OR)", "Springfield", city))

  # This is the one place a show should actually be dropped for lacking
  # coordinates - after every hardcoded per-venue correction above and the
  # fls_venue_geocoding join have both had a chance to supply x/y, not before.
  othervariables <- othervariables %>%
    filter(is.na(x)==FALSE)

  setwd(mydatadir)

  othervariables <- othervariables %>%
    group_by(gid) %>%
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
    mutate(name = str_to_lower(name))

  fls_tags <- fls_tags %>%
    rename(title = name)

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(album == "20220218 40 Watt, Athens, GA, USA", "19930218 40 Watt, Athens, GA, USA", album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(album == "20010607 Archie Browning Centre, Victoria, BC, Canada", "20010706 Archie Browning Centre, Victoria, BC, Canada", album))

  # Three more known tagging-date typos (found while tracing NA gid rows in
  # fugazibase's durations table back to their source): the tagged album date
  # doesn't match the FLS-listed show date, so the date-based gid join below
  # silently fails for these otherwise-real, correctly-listed shows.
  fls_tags <- fls_tags %>%
    mutate(album = ifelse(album == "19880122 Eastern Michigan University, Ypsilanti, MI, USA", "19880119 Eastern Michigan University, Ypsilanti, MI, USA", album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(album == "19980726 Asylum, Portland, ME, USA", "19980727 Asylum, Portland, ME, USA", album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(album == "20000409 E9, El Paso, TX, USA", "20010409 E9, El Paso, TX, USA", album))

  # A fourth tagging-date typo, found while tracing duplicate gid/track rows
  # in fugazibase's durations table: this block's tagged date (27th) collided
  # with the Portland, ME show's date (also the 27th, itself just corrected
  # above) once that fix went in - both shows' tags were merging onto
  # portland-me-usa-72698's gid. The FLS listing confirms Hoboken's real date
  # is the 28th (the very next tour stop after Portland).
  fls_tags <- fls_tags %>%
    mutate(album = ifelse(album == "19980727 Maxwell's, Hoboken, NJ, USA", "19980728 Maxwell's, Hoboken, NJ, USA", album))

  fls_tags <- fls_tags %>%
    mutate(year = str_sub(album, 1, 4),
           month = str_sub(album, 5, 6),
           day = str_sub(album, 7, 8),
           datestring = paste0(day, "/", month, "/", year))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(datestring == "11/02/1990" , "19900211 Studio 10, Baltimore, MD, USA", album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(datestring == "06/09/1991" , "19910906 Desert Fest, Jawbone Canyon, CA, USA", album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(datestring == "14/11/1998" , "19981114 University of Wisconsin, Fire Room, Eau Claire, WI, USA", album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(datestring == "03/03/1999" , "19990303 Cal State University Shurmer Gym, Chico, CA, USA", album))

  fls_tags <- fls_tags %>%
    mutate(album = ifelse(datestring == "25/04/2001" , "20010425 9:30 Club, Washington, DC, USA", album))

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
    filter(venue!="Mayfaur")

  fls_tags <- fls_tags %>%
    mutate(city = str_sub(album, firstcomma + 2, secondcomma-1))

  fls_tags <- fls_tags %>%
    mutate(country = str_sub(album, lastcomma + 2, stringlength))

  fls_tags <- fls_tags %>%
    mutate(subdivision = ifelse(country=="USA", str_sub(album, lastcomma-2, lastcomma-1),""))

  fls_tags <- fls_tags %>%
    select(track, album, title, duration, seconds, date, venue, city, subdivision, country)

  date_gid <- othervariables %>%
    select(date, gid)

  fls_tags <- fls_tags %>%
    left_join(date_gid)

  fls_tags <- fls_tags %>%
    filter(venue!="Van Hall" | gid!="gent-belgium-101688")

  fls_tags <- fls_tags %>%
    filter(venue!="Democrazy" | gid!="amsterdam-netherlands-101688")

  # ypsilanti-mi-eastern-michigan-university-12288 is tagged twice under two
  # album-string spellings of the same recording (identical songs/durations
  # at every track) - one with the short venue text "Eastern Michigan
  # University" and a date typo (already corrected above), one with the
  # fuller venue text "McKenny Union Ballroom, Eastern Michigan University"
  # and the correct date already. Drop the short-venue copy as a duplicate.
  fls_tags <- fls_tags %>%
    filter(!(gid=="ypsilanti-mi-eastern-michigan-university-12288" & venue=="Eastern Michigan University"))

  fls_tags <- fls_tags %>%
    mutate(title = ifelse(gid=="peoria-il-usa-100995" & title=="dance rap", "interlude 4", title))

  # Two single-track mistagged track numbers, found via the same duplicate
  # gid/track trace and confirmed against each show's official FLS tracklist
  # page: each collides with a different song at the wrong track number,
  # leaving a gap at the track number they should actually have.
  fls_tags <- fls_tags %>%
    mutate(track = ifelse(gid=="groningen-netherlands-90390" & title=="repeater", "23", track))

  fls_tags <- fls_tags %>%
    mutate(track = ifelse(gid=="washington-dc-usa-72089" & title=="two beats off", "16", track))

  # Grouped by (gid, album) - album (not just gid) is kept as a grouping key
  # so that two distinct tag batches sharing a gid (e.g. an earlier recording
  # later superseded by an official release) still produce two rows here
  # rather than silently summing their durations together; album itself is
  # dropped from the saved table below since shows_data (joined via gid) is
  # the sole authoritative source for venue/city/subdivision/country, and
  # nothing reads fls_tags_show$album.
  fls_tags_show <- fls_tags %>%
    group_by(gid, album) %>%
    summarize(seconds = sum(seconds)) %>%
    mutate(duration = seconds_to_period(seconds)) %>%
    ungroup()

  fls_tags_show <- fls_tags_show %>%
    select(gid, duration, seconds)

  # venue/city/subdivision/country/album are dropped from the saved table -
  # they were only ever needed transiently above (the two mistagged-track
  # filters, and fls_tags_show's group_by(gid, album)). shows_data (joined
  # via gid) is the sole authoritative source for venue/city/subdivision/
  # country, and nothing downstream reads fls_tags$album.
  fls_tags <- fls_tags %>%
    select(-venue, -city, -subdivision, -country, -album)

  setwd(mydatadir)

  save(fls_tags, file = "fls_tags.rda")

  save(fls_tags_show, file = "fls_tags_show.rda")

  setwd(mydir)


  # Select the most relevant columns -------

  Repeatr1 <- Repeatr0 %>%
    select(gid, date = show_date, dplyr::starts_with("track_"))

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
    mutate(song_number = as.integer(song_number))


# check list of songs with minimal changes to the names ------------------------

  raw_fls_song_list <- Repeatr1 %>%
    mutate(title = ifelse(title=="And the Same", "And The Same", title)) %>%
    mutate(title = ifelse(title=="Back To Base", "Back to Base", title)) %>%
    mutate(title = ifelse(title=="Bed For The Scraping (continued)", "Bed For The Scraping", title)) %>%
    mutate(title = ifelse(title=="Bed for the Scraping", "Bed For The Scraping", title)) %>%
    mutate(title = ifelse(title=="Bed for the Scraping", "Bed For The Scraping", title)) %>%
    mutate(title = ifelse(title=="Give Me the Cure", "Give Me The Cure", title)) %>%
    mutate(title = ifelse(title=="Give me the Cure", "Give Me The Cure", title)) %>%
    mutate(title = ifelse(title=="In Defense of Humans", "In Defense Of Humans", title)) %>%
    mutate(title = ifelse(title=="Last Chance For a Slow Dance", "Last Chance For A Slow Dance", title)) %>%
    mutate(title = ifelse(title=="Last Chance for a Slow Dance", "Last Chance For A Slow Dance", title)) %>%
    mutate(title = ifelse(title=="Life And Limb", "Life and Limb", title)) %>%
    mutate(title = ifelse(title=="Life And Limb", "Life and Limb", title)) %>%
    mutate(title = ifelse(title=="Rend it", "Rend It", title)) %>%
    mutate(title = ifelse(title=="Returning the Screw", "Returning The Screw", title)) %>%
    mutate(title = ifelse(title=="Shut The Door", "Shut the Door", title)) %>%
    mutate(title = ifelse(title=="Sieve-Fisted FInd", "Sieve-Fisted Find", title)) %>%
    mutate(title = ifelse(title=="Sweet and Low", "Sweet And Low", title))

  raw_fls_song_list <- raw_fls_song_list %>%
    filter(is.na(title)==FALSE) %>%
    group_by(title) %>%
    summarize(count = n()) %>%
    ungroup() %>%
    arrange(title)

  raw_fls_song_list$tracktype <- 1

  raw_fls_song_list$title2 <- str_to_lower(raw_fls_song_list$title)

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("interlude", title2)==TRUE, 0, tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("encore", title2)==TRUE, 0, tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("intro", title2)==TRUE, 0, tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("track", title2)==TRUE, 0, tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("remarks", title2)==TRUE, 0, tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("crowd", title2)==TRUE, 0, tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("outro", title2)==TRUE, 0, tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("untitled", title2)==TRUE, 0, tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("instrumental interlude", title2)==TRUE, 1, tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("comedy of life", title2)==TRUE, 1, tracktype))

  raw_fls_song_list <- raw_fls_song_list %>%
    mutate(tracktype=ifelse(grepl("link track", title2)==TRUE, 1, tracktype))

  raw_fls_song_list$title2 <- NULL

  Repeatr1 <- Repeatr1 %>%
    arrange(gid, song_number)

  Repeatr1 <- Repeatr1 %>%
    mutate(title = str_to_lower(title))

  Repeatr1$nchar <- nchar(Repeatr1$title)

  Repeatr1 <- Repeatr1 %>%
    filter(nchar>0)

  Repeatr1$nchar <- NULL

  # add on outros

  Repeatr1_outro <- fls_tags %>%
    filter(title=="outro") %>%
    select(gid, date, track, title) %>%
    rename(song_number = track) %>%
    mutate(song_number = as.numeric(song_number))

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
    mutate(title_original = title)

  Repeatr1 <- Repeatr1 %>%
    mutate(title = str_replace(title, " instrumental", ""))

  Repeatr1 <- Repeatr1 %>%
    mutate(title = str_replace(title, " acapella", ""))

  Repeatr1 <- Repeatr1 %>%
    mutate(title = str_replace(title, " drum and bass jam", ""))

  Repeatr1 <- Repeatr1 %>%
    mutate(title = ifelse(title=="bed for the scraping (continued)", "bed for the scraping", title))

  Repeatr1 <- Repeatr1 %>%
    mutate(title = ifelse(title=="the argument", "argument", title))

  # 'promises bit' and 'promises coda' refer to the same thing but it is only the end part of promises, not the whole song.

  Repeatr1 <- Repeatr1 %>%
    mutate(title = ifelse(title=="promises bit soundcheck", "promises coda", title))

  Repeatr1 <- Repeatr1 %>%
    mutate(title = ifelse(title=="promises coda instrumental", "promises coda", title))

  Repeatr1 <- Repeatr1 %>%
    mutate(title = ifelse(title=="promises bit", "promises coda", title))


  # define track types: intros, interludes, sound checks -----------------------------------------------------------------

  # track types
  # 0 soundchecks, intros, interludes, encores
  # 1 released songs
  # 2 unreleased songs

  Repeatr1$tracktype <- 1

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("interlude", title)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("encore", title)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("intro", title)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("track", title)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("remarks", title)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("outside", title)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("sound check", title)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("soundcheck", title)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("crowd", title)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("outro", title)==TRUE, 0, tracktype))

  Repeatr1 <- Repeatr1 %>%
    mutate(tracktype=ifelse(grepl("untitled", title)==TRUE, 0, tracktype))

  # Filter to remove unreleased songs or improvised one-offs ---------------------------------------

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("heart on my chest", title)==TRUE, 2, tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("lock dug", title)==TRUE, 2, tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("nedcars", title)==TRUE, 2, tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("noisy dub", title)==TRUE, 2, tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("nsa", title)==TRUE, 2, tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("set the charges", title)==TRUE, 2, tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("she is blind", title)==TRUE, 2, tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("surf tune", title)==TRUE, 2, tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("world beat", title)==TRUE, 2, tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("preprovisional", title)==TRUE, 2, tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("hello morning seed", title)==TRUE, 2, tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("i spent it all", title)==TRUE, 2, tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("strange disclosure", title)==TRUE, 2, tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("promises coda", title)==TRUE, 2, tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("ice cream", title)==TRUE, 2, tracktype))

    Repeatr1 <- Repeatr1 %>%
      mutate(tracktype=ifelse(grepl("provisional medley", title)==TRUE, 2, tracktype))

  # Summarise the data to check frequency counts for all songs --------------

  mycount <- Repeatr1 %>%
    filter(tracktype==1) %>%
    group_by(title) %>%
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
    arrange((title))

  mycount <- mycount %>% mutate(songid = row_number())
  mycount <- mycount %>% relocate(songid)

  # Create lookup table to go from song id to song title --------------

  songidlookup <- mycount
  setwd(mydatadir)
  save(songidlookup, file="songidlookup.rda")
  setwd(mydir)

  # Redefine song index in terms of the included songs ----------------------

  Repeatr1 <- Repeatr1 %>%
    arrange(gid, song_number)

  Repeatr1a <- Repeatr1 %>%
    filter(tracktype==1) %>%
    group_by(gid) %>%
    mutate(song_number = row_number()) %>%
    ungroup()

  Repeatr1a <- Repeatr1a %>%
    mutate(first_song = ifelse(song_number==1, 1, 0))

  Repeatr1a <- Repeatr1a %>%
    group_by(gid) %>%
    mutate(number_songs = n()) %>%
    mutate(last_song = ifelse(song_number==number_songs, 1, 0)) %>%
    ungroup()

  Repeatr1a <- Repeatr1a %>%
    select(gid, title, number_songs, first_song, last_song)

  Repeatr1b <- Repeatr1a %>%
    group_by(gid) %>%
    slice(1) %>%
    select(gid, number_songs) %>%
    ungroup()

  Repeatr1a <- Repeatr1a %>%
    select(-number_songs)

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
  songvarslookup <- songvarslookup %>% select(title, rid, track_number, instrumental, vocals_picciotto, vocals_mackaye, vocals_lally, duration_seconds)

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
  all_classified_songs <- Repeatr1 %>% distinct(title)

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
    select(gid, date, year, month, day, tracktype, song_number, songid, title, number_songs, first_song, last_song, rid,	release_title, track_number, instrumental,	vocals_picciotto,	vocals_mackaye,	vocals_lally,	duration_seconds) %>%
    arrange(date, song_number)

  # remove duplicates

  Repeatr1 <- Repeatr1 %>%
    group_by(gid, song_number) %>%
    slice(1) %>%
    ungroup()

  setwd(mydatadir)

  save(Repeatr1, file = "Repeatr1.rda")

  setwd(mydir)


# calculate cumulative rendition counts -----------------------------------


  mydf <- Repeatr1 %>%
    filter(tracktype==1) %>%
    select(date, title)

  mydf <- mydf %>%
    group_by(date, title) %>%
    summarize(count=n()) %>%
    ungroup()

  mydf_wide <- mydf %>%
    pivot_wider(names_from = title, values_from = count, values_fill = 0)

  mydf_wide2 <- mydf_wide

  number_columns <- ncol(mydf_wide2)

  for(colindex in 2:number_columns) {

    mydf_wide2[,colindex] <- cumsum(mydf_wide2[,colindex])

  }

  mydf_long <- mydf_wide2 %>%
    pivot_longer(!date, names_to = "title", values_to = "count") %>%
    filter(count>0)

  releases_lookup <- Repeatr1 %>%
    group_by(title, release_title) %>%
    summarize(count = n()) %>%
    ungroup() %>%
    select(title, release_title)

  mydf_long <- mydf_long %>%
    left_join(releases_lookup)

  cumulative_song_counts <- mydf_long %>%
    select(date, title, release_title, count)

  cumulative_song_counts <- cumulative_song_counts %>%
    mutate(release_title = tolower(release_title)) %>%
    left_join(releasesdatalookup) %>%
    select(date, title, release_title, count, release_date)

  setwd(mydatadir)

  save(cumulative_song_counts, file = "cumulative_song_counts.rda")

  setwd(mydir)


  # calculate cumulative duration counts -----------------------------------

  song_songid <- Repeatr1 %>%
    filter(tracktype==1) %>%
    group_by(title, songid) %>%
    slice(1) %>%
    select(title, songid) %>%
    ungroup()

  mydf <- fls_tags %>%
    select(title, seconds) %>%
    mutate(minutes = round(seconds/60, digits = 2)) %>%
    select(-seconds) %>%
    left_join(song_songid) %>%
    filter(is.na(songid)==FALSE) %>%
    select(-songid)

  mydf <- mydf %>%
    group_by(minutes, title) %>%
    summarize(count=n()) %>% ungroup()

  mydf_wide <- mydf %>%
    pivot_wider(names_from = title, values_from = count, values_fill = 0)

  mydf_wide2 <- mydf_wide

  number_columns <- ncol(mydf_wide2)

  for(colindex in 2:number_columns) {

    mydf_wide2[,colindex] <- cumsum(mydf_wide2[,colindex])

  }

  mydf_long <- mydf_wide2 %>%
    pivot_longer(!minutes, names_to = "title", values_to = "count") %>%
    filter(count>0)

  releases_lookup <- Repeatr1 %>%
    group_by(title, release_title) %>%
    summarize(count = n()) %>%
    ungroup() %>%
    select(title, release_title) %>%
    filter(title!="crowd")

  mydf_long <- mydf_long %>%
    left_join(releases_lookup)

  cumulative_duration_counts <- mydf_long %>%
    select(minutes, title, release_title, count) %>%
    mutate(release_title = ifelse(is.na(release_title)==TRUE, "unreleased", release_title))

  setwd(mydatadir)

  save(cumulative_duration_counts, file = "cumulative_duration_counts.rda")

  setwd(mydir)

  # duration_summary is calculated later, alongside position_summary, once
  # duration_data_da exists - both are now derived from the same table (see
  # the comment there) rather than duration_summary being computed
  # separately from raw fls_tags, which used to let the two silently diverge.

# Played with data --------------------------------------------------------

    played_with <- Repeatr0 %>%
      select(gid, fls_id, played_with) %>%
      filter(is.na(played_with)==FALSE)

    played_with <- played_with %>%
      mutate_if(is.character, utf8::utf8_encode)

    played_with <- played_with %>%
      mutate(played_with = ifelse(gid=="bielefeld-germany-103188", "Pygmies", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(gid=="rome-italy-102790", "Ratos de Porão", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(gid=="ann-arbor-mi-usa-62390", "Ward, Phünhögg", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(gid=="bergara-spainbasque-101099", "Half Foot Outside, Lisabö", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(gid=="jawbone-canyon-ca-usa-90691", "Pop Defect, Sandy Duncan’s Eye, The Paper Tulips, The Offspring, The Fumes, This Great Religion, TVTV$", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(gid=="washington-dc-usa-101589", "Fidelity Jones, Tiik, Lungfish, Juliana Experience, Weatherhead, Moss Icon, Dog Born Society, Choke, Cabal, All White Jury, Daryl Stover, Caroline Ely, 200 Stitches, Transilience, Neverman", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(gid=="belo-horizonte-brazil-81594", "Stigmata, Jorge Cabeleira, Daizy Down, Oz, Intense Manner of Living, Virna Lisi", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(gid=="winnipeg-mb-canada-81491", "Carpe Diem, Propagandhi", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(gid=="savannah-ga-usa-11400", "Faraquet, The Flam", played_with))

    played_with <- played_with %>%
      mutate(played_with = ifelse(gid=="buenos-aires-argentina-82297", "Massacre, Dixie Dynamite, Cienfuegos, Slam Up, Hiram Walker", played_with))

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
      mutate(played_with = ifelse(played_with=="Sandy Duncan's Eye", "Sandy Duncan’s Eye", played_with))

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
      group_by(gid, fls_id, played_with) %>%
      summarize(count = n()) %>%
      ungroup()

    played_with <- played_with %>%
      select(gid, fls_id, played_with)

    played_with <- played_with %>%
      arrange(fls_id, played_with)

    setwd(mydatadir)

    save(played_with, file = "played_with.rda")

    setwd(mydir)

# prepare input data for Fugazetteer --------------------------------------

    setwd(mydatadir)

    releaseid_variable_colour_code <- releasesdatalookup %>%
      select(rid, variable, colour_code)

    save(releaseid_variable_colour_code, file = "releaseid_variable_colour_code.rda")

    transitions_data_da1 <- Repeatr1 %>%
      filter(tracktype==1) %>%
      select(gid,date,song_number,title) %>%
      rename(title1 = title)

    transitions_data_da2 <- Repeatr1 %>%
      filter(tracktype==1) %>%
      select(gid,date,song_number,title) %>%
      mutate(song_number = song_number-1) %>%
      rename(title2 = title)

    transitions_data_da <- transitions_data_da1 %>%
      left_join(transitions_data_da2) %>%
      filter(is.na(title2)==FALSE) %>%
      rename(transition = song_number) %>%
      mutate(url = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
      mutate(fls_link = paste0("<a href='",  url, "' target='_blank'>", gid, "</a>")) %>%
      select(gid, url, fls_link, date, transition, title1, title2) %>%
      mutate(transition = as.integer(transition))

    transitions_data_da$date <- format(transitions_data_da$date,'%Y-%m-%d')

    save(transitions_data_da, file = "transitions_data_da.rda")

    rm(transitions_data_da1, transitions_data_da2)

    show_sequence <- Repeatr1 %>%
      group_by(date) %>%
      summarize(songs = n()) %>%
      ungroup() %>%
      arrange(date) %>%
      mutate(show_num = row_number(),
             last_show = max(show_num))

    releases_menu_list <- releasesdatalookup %>%
      arrange(rid) %>%
      filter(rid!=12 & rid!=14 & rid!=15)

    save(releases_menu_list, file = "releases_menu_list.rda")

    colour_code <- releasesdatalookup %>%
      arrange(rid) %>%
      filter(rid>0) %>%
      select(rid, colour_code)

    releases_data_input <- Repeatr1 %>%
      left_join(show_sequence) %>%
      left_join(colour_code) %>%
      group_by(rid, release_title, track_number, title, last_show, colour_code) %>%
      summarize(count = n(),
                date=min(date),
                show_num = min(show_num)) %>%
      ungroup()

    releases_data_input <- releases_data_input %>%
      arrange(desc(rid), desc(track_number)) %>%
      mutate(title = factor(title, levels=unique(title))) %>%
      mutate(release_title = factor(release_title, levels=rev(unique(release_title)))) %>%
      mutate(shows = last_show-show_num+1,
             intensity = round(count / shows, digits=4)) %>%
      filter(rid>0)

    save(releases_data_input, file = "releases_data_input.rda")

    releases_summary <- releases_data_input %>%
      group_by(rid, release_title, last_show) %>%
      summarize(count = sum(count),
                songs=n(),
                first_debut=min(date),
                last_debut=max(date),
                first_show = min(show_num),
                shows = round(mean(shows), digits=0),
                intensity = round(mean(intensity), digits = 4)) %>%
      ungroup()

    # Named distinctly (not reassigned to `releasesdatalookup`) so this
    # local date-only trim doesn't clobber the full `releasesdatalookup`
    # that gets saved to data/ and returned from this function - Repeatr_5()
    # needs the full version (release_title, rym_rating, etc.), not just these
    # two columns.
    releasesdatalookup_dates <- releasesdatalookup %>%
      select(rid, release_date)

    releases_summary <- releases_summary %>%
      left_join(releasesdatalookup_dates) %>%
      select(rid, release_title, first_debut, last_debut, release_date, songs, count, shows, intensity) %>%
      filter(rid>0)

    save(releases_summary, file = "releases_summary.rda")

    gid_minutes <- fls_tags_show %>%
      select(gid, seconds) %>%
      mutate(minutes = round(seconds/60, digits = 2)) %>%
      select(-seconds)

    # occurrence: within-show rank of each tagged appearance of a title, by
    # tag/track order - needed so a song repeated within one show (e.g. two
    # "interlude"-style or reprised tracks) pairs up with the matching
    # Repeatr1 occurrence below instead of joining ambiguously on (gid,
    # title) alone, which either cross-multiplies rows (when both sides
    # repeat) or silently duplicates one duration onto every repeat (when
    # only Repeatr1's side does).
    gid_song_minutes <- fls_tags %>%
      mutate(minutes = round(seconds/60, digits = 2)) %>%
      arrange(gid, title, as.numeric(track)) %>%
      group_by(gid, title) %>%
      mutate(occurrence = row_number()) %>%
      ungroup() %>%
      select(gid, title, occurrence, minutes)

    checkmatch <- Repeatr1 %>%
      full_join(gid_song_minutes) %>%
      filter(is.na(minutes)==TRUE | is.na(year)==TRUE) %>%
      arrange(date, song_number)

    tour_lookup <- othervariables %>% select(gid, tour) %>%
      group_by(gid) %>%
      slice(1) %>%
      ungroup()

    shows_data <- othervariables %>%
      filter(is.na(attendance)==FALSE) %>%
      filter(is.na(tour)==FALSE) %>%
      mutate(attendance = as.integer(attendance)) %>%
      mutate(date = as.Date(date, "%d-%m-%Y")) %>%
      mutate(year = lubridate::year(date)) %>%
      rename(latitude = y) %>%
      rename(longitude = x) %>%
      select(gid, tour, year, date, venue, city, subdivision, country, attendance, price, currency, latitude, longitude, fls_notes) %>%
      mutate(urls = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
      mutate(fls_link = paste0("<a href='",  urls, "' target='_blank'>", gid, "</a>")) %>%
      left_join(gid_minutes) %>%
      left_join(gid_sound_quality)

    # Safety net, matching othervariables above: gid_minutes comes from
    # fls_tags_show, which is grouped by (gid, album) - two tag batches for
    # the same show under slightly different album text (e.g. an earlier
    # recording later superseded by an official release) produce two rows
    # sharing one gid there, which would otherwise silently duplicate that
    # gid here too.
    shows_data <- shows_data %>%
      group_by(gid) %>%
      slice(1) %>%
      ungroup()

    save(shows_data, file = "shows_data.rda")

    last_performance_data <- Repeatr1 %>%
      filter(tracktype==1) %>%
      select(date, title)%>%
      group_by(title) %>%
      summarize(last_performance=max(date)) %>%
      ungroup()

    save(last_performance_data, file = "last_performance_data.rda")

    xray <- Repeatr1 %>%
      left_join(tour_lookup)

    xray <- xray %>%
      left_join(releasesdatalookup)

    xray <- xray %>%
      mutate(unreleased = ifelse(tracktype==2 | (tracktype==1 & date<release_date),1,0))

    xray2 <- Repeatr::summary %>%
      select(songid, launchdate)

    xray <- xray %>%
      left_join(xray2)

    xray <- xray %>%
      mutate(debut = ifelse(date==launchdate,1,0)) %>%
      mutate(debut = ifelse(is.na(debut)==TRUE,0,debut))

    xray <- xray %>%
      left_join(last_performance_data)

    xray <- xray %>%
      mutate(last_performance=ifelse(date==last_performance,1,0)) %>%
      mutate(last_performance = ifelse(is.na(last_performance)==TRUE,0,last_performance))

    # occurrence: matches gid_song_minutes's own within-(gid,title) rank (see
    # its construction above) so a title repeated within one show pairs up
    # with the correct tagged occurrence, same reasoning as duration_data_da.
    xray <- xray %>%
      arrange(gid, title, song_number) %>%
      group_by(gid, title) %>%
      mutate(occurrence = row_number()) %>%
      ungroup() %>%
      left_join(gid_song_minutes, by = c("gid", "title", "occurrence")) %>%
      select(-occurrence)

    # remove tracks from front-end data that were not actually included in the MP3 download

    xray <- xray %>%
      filter(gid!="washington-dc-usa-80793" | tracktype!=0 | is.na(minutes)==FALSE)

    xray <- xray %>%
      mutate(track = 1,
             songtrack = ifelse(tracktype==1, 1, 0))

    xray <- xray %>%
      mutate(release_title = ifelse(is.na(release_title)==TRUE, "other", release_title))

    xray_tracks <- xray %>%
      mutate(units = "tracks") %>%
      mutate(year = lubridate::year(date)) %>%
      mutate(fugazi = ifelse(release_title=="fugazi",1,0),
             margin_walker = ifelse(release_title=="margin walker",1,0),
             three_songs = ifelse(release_title=="3 songs",1,0),
             repeater = ifelse(release_title=="repeater",1,0),
             steady_diet_of_nothing = ifelse(release_title=="steady diet of nothing",1,0),
             in_on_the_killtaker = ifelse(release_title=="in on the killtaker",1,0),
             red_medicine = ifelse(release_title=="red medicine",1,0),
             end_hits = ifelse(release_title=="end hits",1,0),
             the_argument = ifelse(release_title=="the argument",1,0),
             furniture = ifelse(release_title=="furniture",1,0),
             first_demo = ifelse(release_title=="first demo",1,0),
             other = ifelse(release_title=="other",1,0),
             unreleased = ifelse(unreleased==1,1,0),
             songs = ifelse(songtrack==1,1,0))


    xray_tracks <- xray_tracks %>%
      group_by(gid, date, year, tour, units) %>%
      summarize(unreleased = sum(unreleased),
                debut = sum(debut),
                farewell = sum(last_performance),
                fugazi = sum(fugazi),
                margin_walker = sum(margin_walker),
                three_songs = sum(three_songs),
                repeater = sum(repeater),
                steady_diet_of_nothing = sum(steady_diet_of_nothing),
                in_on_the_killtaker = sum(in_on_the_killtaker),
                red_medicine = sum(red_medicine),
                end_hits = sum(end_hits),
                the_argument = sum(the_argument),
                furniture = sum(furniture),
                first_demo = sum(first_demo),
                other = sum(other),
                unreleased = sum(unreleased),
                songs = sum(songs)) %>%
      arrange(date) %>%
      ungroup()



    xray_minutes <- xray %>%
      mutate(units = "minutes") %>%
      mutate(year = lubridate::year(date)) %>%
      mutate(fugazi = ifelse(release_title=="fugazi",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             margin_walker = ifelse(release_title=="margin walker",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             three_songs = ifelse(release_title=="3 songs",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             repeater = ifelse(release_title=="repeater",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             steady_diet_of_nothing = ifelse(release_title=="steady diet of nothing",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             in_on_the_killtaker = ifelse(release_title=="in on the killtaker",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             red_medicine = ifelse(release_title=="red medicine",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             end_hits = ifelse(release_title=="end hits",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             the_argument = ifelse(release_title=="the argument",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             furniture = ifelse(release_title=="furniture",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             first_demo = ifelse(release_title=="first demo",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             other = ifelse(release_title=="other",ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             unreleased = ifelse(unreleased==1,ifelse(is.na(minutes)==TRUE, 0, minutes),0),
             songs = ifelse(songtrack==1,ifelse(is.na(minutes)==TRUE, 0, minutes),0))

    xray_minutes <- xray_minutes %>%
      group_by(gid, date, year, tour, units) %>%
      summarize(unreleased = sum(unreleased),
                debut = sum(debut),
                farewell = sum(last_performance),
                fugazi = sum(fugazi),
                margin_walker = sum(margin_walker),
                three_songs = sum(three_songs),
                repeater = sum(repeater),
                steady_diet_of_nothing = sum(steady_diet_of_nothing),
                in_on_the_killtaker = sum(in_on_the_killtaker),
                red_medicine = sum(red_medicine),
                end_hits = sum(end_hits),
                the_argument = sum(the_argument),
                furniture = sum(furniture),
                first_demo = sum(first_demo),
                other = sum(other),
                unreleased = sum(unreleased),
                songs = sum(songs)) %>%
      arrange(date) %>%
      ungroup()

    xray <- rbind.data.frame(xray_tracks, xray_minutes)

    xray <- xray %>%
      arrange(units, date)

    xray <- xray %>%
      mutate(released = songs - unreleased,
             incumbent = songs - debut - farewell)

    xray <- xray %>%
      mutate(url = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
      mutate(fls_link = paste0("<a href='",  url, "' target='_blank'>", gid, "</a>"))

    xray <- xray %>%
      relocate(gid, url, fls_link, year, tour, date, units, songs, released, unreleased, other, debut, farewell, incumbent, other)

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
      filter(tracktype==1) %>%
      select(gid,date, song_number, title) %>%
      mutate(urls = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
      mutate(fls_link = paste0("<a href='",  urls, "' target='_blank'>", gid, "</a>")) %>%
      arrange(gid, title, song_number) %>%
      group_by(gid, title) %>%
      mutate(occurrence = row_number()) %>%
      ungroup() %>%
      left_join(gid_song_minutes, by = c("gid", "title", "occurrence")) %>%
      select(-occurrence)

    # A gid with no recording at all (every row above unmatched) shouldn't
    # appear here as a phantom all-NA "recording" - e.g.
    # washington-dc-usa-100688 is a real show per the FLS site's own flyer,
    # but its page comments confirm no recording survives for it (the audio
    # posted there is a mislabeled copy of washington-dc-usa-61588's).
    # Besides being wrong on its own terms, leaving such rows in would
    # occupy real slots in the rendition-count ranking downstream (recap())
    # for every title involved.
    duration_data_da <- duration_data_da %>%
      group_by(gid) %>%
      filter(any(is.na(minutes)==FALSE)) %>%
      ungroup()

    duration_data_da <- duration_data_da %>%
      group_by(gid) %>%
      mutate(first_song_number = min(song_number),
             last_song_number = max(song_number),
             position = ifelse(last_song_number > first_song_number,
                                round((song_number - first_song_number) / (last_song_number - first_song_number), digits = 2),
                                0)) %>%
      ungroup() %>%
      select(-first_song_number, -last_song_number)

    save(duration_data_da, file = "duration_data_da.rda")

    mydf_pos <- duration_data_da %>%
      select(position, title) %>%
      group_by(position, title) %>%
      summarize(count = n()) %>%
      ungroup()

    mydf_pos_wide <- mydf_pos %>%
      pivot_wider(names_from = title, values_from = count, values_fill = 0)

    mydf_pos_wide2 <- mydf_pos_wide
    number_columns_pos <- ncol(mydf_pos_wide2)
    for (colindex in 2:number_columns_pos) {
      mydf_pos_wide2[,colindex] <- cumsum(mydf_pos_wide2[,colindex])
    }

    mydf_pos_long <- mydf_pos_wide2 %>%
      pivot_longer(!position, names_to = "title", values_to = "count") %>%
      filter(count>0) %>%
      left_join(releases_lookup)

    cumulative_position_counts <- mydf_pos_long %>%
      select(position, title, release_title, count) %>%
      mutate(release_title = ifelse(is.na(release_title)==TRUE, "unreleased", release_title))

    save(cumulative_position_counts, file = "cumulative_position_counts.rda")

    position_summary <- duration_data_da %>%
      group_by(title) %>%
      summarize(renditions = n(),
                position_min = round(min(position), digits = 2),
                position_median = round(median(position), digits = 2),
                position_max = round(max(position), digits = 2),
                position_mean = round(mean(position), digits = 2),
                position_sd = round(sd(position), digits = 2)) %>%
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
      group_by(title) %>%
      summarize(renditions = n(),
                minutes_min = round(min(minutes, na.rm = TRUE), digits = 2),
                minutes_median = round(median(minutes, na.rm = TRUE), digits = 2),
                minutes_max = round(max(minutes, na.rm = TRUE), digits = 2),
                minutes_mean = round(mean(minutes, na.rm = TRUE), digits = 2),
                minutes_sd = round(sd(minutes, na.rm = TRUE), digits = 2)) %>%
      ungroup() %>%
      mutate(minutes_total = round(renditions*minutes_mean, digits = 2))

    save(duration_summary, file = "duration_summary.rda")

    othervariables <- othervariables %>%
      left_join(gid_sound_quality) %>%
      mutate(urls = paste0("https://www.dischord.com/fugazi_live_series/", gid)) %>%
      mutate(fls_link = paste0("<a href='",  urls, "' target='_blank'>", gid, "</a>"))

    played_with <- played_with %>%
      select(gid, played_with)

    played_with_data <- othervariables %>%
      left_join(played_with)

    played_with_data <- played_with_data %>%
      rename(latitude = y, longitude = x) %>%
      mutate(attendance = round(attendance, 0))

    played_with_data <- played_with_data %>%
      select(gid, fls_link, year, tour, date, venue, city, country, played_with, attendance, sound_quality, latitude, longitude)

    played_with_summary <- played_with_data %>%
      group_by(year, tour, played_with) %>%
      summarize(shows = n()) %>%
      arrange(desc(shows)) %>%
      ungroup()

    save(played_with_summary, file = "played_with_summary.rda")

    setwd(mydir)


# finishing up ------------------------------------------------------------



  myreturnlist <- list(Repeatr0, Repeatr1, songidlookup, mycount, songvarslookup, releasesdatalookup, othervariables, cumulative_song_counts, fls_tags, fls_tags_show, cumulative_duration_counts, releases_data_input, raw_fls_song_list)

  return(myreturnlist)

}


