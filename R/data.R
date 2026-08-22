# Documentation for all the datasets shipped with the Repeatr package.
# See vignette("Updating the Data") for how each of these gets rebuilt.

# Core show data --------------------------------------------------------

#' Fugazi Live Series data
#'
#' This data was originally scraped from the Fugazi Live Series website by Carni Klirs for his project "Visualizing the History of Fugazi", and is now kept up to date via \code{\link{scrape_fls_shows}}.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each show.
#' \describe{
#' \item{gid}{show id}
#' \item{fls_id}{Fugazi Live Series id}
#' \item{show_date}{Show date}
#' \item{venue}{Venue}
#' \item{door_price}{Door price}
#' \item{attendance}{Attendance}
#' \item{recorded_by}{Recorded by}
#' \item{mastered_by}{Mastered by}
#' \item{original_source}{Original source}
#' \item{sound_quality}{Sound quality rating: Excellent, Very Good, Good, or Poor}
#' \item{played_with}{Bands played with, comma-separated}
#' \item{fls_notes}{Any official note shown on the show's page (e.g. "Previously released on CD (FLS29)"), NA when the show has none}
#' \item{tour}{The touring period the show belongs to (e.g. "1988 Fall European Tour"), scraped from the FLS listing pages' own tour headings - see \code{\link{scrape_fls_listing_data}}.}
#' \item{city}{City, scraped from the FLS listing pages - see \code{\link{scrape_fls_listing_data}}. Not yet disambiguated for cities that share a name with another tour stop (Portland, Columbia, etc.) - see \code{\link{othervariables}} for the disambiguated version.}
#' \item{subdivision}{Subnational administrative unit (US state, DC, Canadian province, or Australian state/territory), where applicable (`NA` outside those three countries) - see \code{\link{scrape_fls_listing_data}}.}
#' \item{country}{Country, scraped from the FLS listing pages - see \code{\link{scrape_fls_listing_data}}.}
#' \item{track_1-track_n}{Tracks, one column per track slot up to the widest tracklist in the data}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}} from the raw scrape (\code{\link{scrape_fls_shows}}); typed/cleaned, no song classification yet.
#' @examples
#' # How many people did Fugazi perform for, across the shows available in
#' # the Fugazi Live Series data?
#' test <- Repeatr0
#' test <- dplyr::mutate(test, attendancedata = nchar(attendance))
#' test <- dplyr::filter(test, attendancedata>0)
#' test <- dplyr::mutate(test, attendance = as.numeric(attendance))
#' test <- dplyr::filter(test, is.na(attendance)==FALSE)
#' totalpeople <- sum(test$attendance)
#' totalpeople
"Repeatr0"

#' Fugazi Live Series data - other variables
#'
#' some of this data was scraped from the Fugazi Live Series website by Carni Klirs for his project "Visualizing the History of Fugazi".
#' The original data on coordinates, cities and tours data came from The D-I-Y Data of Fugazi by Matthew Conlen.
#' Rows with checked==1 were updated by Alex Mitrani, in particular making sure that the coordinates indicated the actual locations of the venues for city-level mapping.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each show.
#' \describe{
#' \item{gid}{show id}
#' \item{flsid}{Fugazi Live Series id}
#' \item{venue}{Venue}
#' \item{price}{Numeric ticket price, split from the raw scraped door-price text via `inst/extdata/fls_doorprice_currency_lookup.csv` (`NA` where the raw text is blank, ~33% of shows); `0` for shows marked "Free".}
#' \item{currency}{ISO 4217 currency code for `price` (`NA` alongside a missing `price`); "Free" shows are `USD` except one 1995 Italy show (`ITL`).}
#' \item{attendance}{Attendance}
#' \item{recorded_by}{Recorded by}
#' \item{mastered_by}{Mastered by. A handful of typo'd values ("Warren Russell Smith" missing its hyphen) are corrected here.}
#' \item{original_source}{Original source. A handful of terse raw values ("?", "VHS", "VHS Tape") are standardized here to "Unknown"/"VHS audio".}
#' \item{x}{longitude}
#' \item{y}{latitude}
#' \item{city}{city - plain city name (e.g. "Portland", "Columbia", "Croydon"); see `subdivision`/`country` to disambiguate cities that share a name with another Fugazi tour stop. Internally, \code{\link{Repeatr_1}} temporarily suffixes these as "City (ST/Country)" to match the venue-coordinate lookup's join key, then strips the suffix back off once coordinates are resolved - the suffix never persists to this exposed column.}
#' \item{subdivision}{Subnational administrative unit (US state, DC, Canadian province, Australian state/territory, or Brazilian state), where applicable (`NA` elsewhere) - scraped directly for the US/Canada/Australia (see \code{\link{Repeatr0}}/\code{\link{scrape_fls_listing_data}}); Brazilian state codes are filled in by \code{\link{Repeatr_1}} from a hand-verified city lookup, since the FLS site's own scrape never populates a subdivision outside the US/Canada/Australia. Any remaining blank (a pre-existing mix of `NA` and `""`) is standardized to `NA`.}
#' \item{country}{country}
#' \item{tour}{The touring period the show belongs to, scraped directly from the FLS listing pages (see \code{\link{Repeatr0}}/\code{\link{scrape_fls_listing_data}}).}
#' \item{year}{year}
#' \item{checked}{checked==1 indicates that the data was checked and updated by Alex Mitrani, in particular making sure that the coordinates indicate as closely as possible the actual locations of the venues.}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}} by joining `inst/extdata/fls_data.csv` with `inst/extdata/fls_venue_geocoding_v2.csv`. Actively consumed directly by `inst/shiny/Fugazetteer/app.R` (e.g. its attendance/tour reactives). Exported as-is (minus `fls_notes`, `year`, `checked`, `x`, `y` - venue coordinates live in fugazibase's `locations` table instead; plus `sound_quality` joined in) as fugazibase's `shows` table by \code{\link{export_fugazibase_data}}.
#' @examples
#' othervariables
"othervariables"

#' Fugazi Live Series data in long format with related discography data
#'
#' Song data from the Fugazi discography pages on Wikipedia. The variables attributing lead vocals are simplifications in some cases where lead vocals were shared.
#' The variables song_number, first_song and last_song were defined after data cleaning, so intros, outros, sound checks, interludes and one-offs are not included.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @source https://web.archive.org/web/20201112000517/http://en.wikipedia.org/wiki/Fugazi_discography
#' @format dataframe with one row for show and each song performed in all the Fugazi Live Series shows with data.
#' \describe{
#' \item{gid}{gig id.  This is a concatenation of city, country, and date}
#' \item{date}{Show date}
#' \item{year}{Year}
#' \item{month}{Month, as a number}
#' \item{day}{Day, as a number}
#' \item{tracktype}{0 = interlude, 1 = song, 2 = other music}
#' \item{song_number}{The number of the song in the sequence of songs that were performed as part of that show}
#' \item{songid}{numeric id for each song}
#' \item{title}{The name of the song}
#' \item{number_songs}{The number of songs that were performed as part of that show}
#' \item{first_song}{Identifies the first song of the set}
#' \item{last_song}{Identifies the last song of the set}
#' \item{rid}{numeric id in ascending chronological order}
#' \item{release_title}{name of album or EP}
#' \item{track_number}{The track number for the song on the release}
#' \item{instrumental}{Indicates whether or not the piece is an instrumental}
#' \item{vocals_picciotto}{indicates whether or not Guy Picciotto sang lead vocals on this track}
#' \item{vocals_mackaye}{indicates whether or not Ian Mackaye sang lead vocals on this track}
#' \item{vocals_lally}{indicates whether or not Joe Lally sang lead vocals on this track}
#' \item{duration_seconds}{The duration of the song in seconds}
#' }
#' @section Provenance: Derived-classified. Produced by \code{\link{Repeatr_1}}: mechanically joined, but shaped by the hand-written `grepl()`-based song-title recoding and `tracktype` classification rules in `R/Repeatr_1.R` - the layer whose edits can shift which songs get a `songid` (see \code{\link{songidlookup}}).
#' @examples
#' Repeatr1
"Repeatr1"

#' Fugazi Live Series choice data in long format with related discography data
#'
#' Song data from the Fugazi discography pages on Wikipedia. The variables attributing lead vocals are simplifications in some cases where lead vocals were shared.
#' The variables song_number, first_song and last_song were defined after data cleaning, so intros, outros, sound checks, interludes and one-offs are not included.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @source https://web.archive.org/web/20201112000517/http://en.wikipedia.org/wiki/Fugazi_discography
#' @format dataframe with one row for each show, each song performed and each song available in all the Fugazi Live Series shows with data.
#' \describe{
#' \item{case}{This is a numerical id with unique values for each combination of gid and song_number}
#' \item{gid}{gig id.  This is a concatenation of city, country, and date}
#' \item{date}{Show date}
#' \item{year}{Year}
#' \item{launchdate}{The date on which the song was first performed according to the data}
#' \item{yearsold}{The difference between the date of the show and the launchdate of the song, measured in years}
#' \item{song_number}{The number of the song in the sequence of songs that were performed as part of that show}
#' \item{alt}{A dense 1..n index over the `min_song_count`-eligible songs only, in `songid` order - this is the alternative-specific index `mlogit`/\code{\link{Repeatr_4}} actually sees. See `songid` below for the stable song identity this is derived from.}
#' \item{songid}{The stable, full song identity from \code{\link{songidlookup}}, kept alongside `alt` rather than overwritten by it.}
#' \item{title}{The name of the song}
#' \item{choice}{1 if the song was performed at that point in the show, 0 otherwise}
#' \item{played}{1 if the song was performed at or before that point in the show, 0 otherwise}
#' \item{available_rl}{Repertoire-level availability: 1 if the song was available in the repertoire for this show, 0 otherwise}
#' \item{available_gl}{Gig-level availability: 1 if the song was available in the repertoire and was available to be played at this point in this show, 0 otherwise}
#' \item{first_song}{Identifies the first song of the set}
#' \item{last_song}{Identifies the last song of the set}
#' \item{rid}{numeric id in ascending chronological order}
#' \item{release_title}{name of album or EP}
#' \item{track_number}{The track number for the song on the release}
#' \item{instrumental}{Indicates whether or not the piece is an instrumental}
#' \item{vocals_picciotto}{indicates whether or not Guy Picciotto sang lead vocals on this track}
#' \item{vocals_mackaye}{indicates whether or not Ian Mackaye sang lead vocals on this track}
#' \item{vocals_lally}{indicates whether or not Joe Lally sang lead vocals on this track}
#' \item{duration_seconds}{The duration of the song in seconds}
#' \item{first_song_instrumental}{1 if first song of the show and instrumental, 0 otherwise}
#' }
#' @section Provenance: Derived-modeled. Produced by \code{\link{Repeatr_2}}: this is where the `min_song_count` modelling-eligibility filter is applied and the dense `alt` choice-model index is constructed from the stable `songid` in \code{\link{songidlookup}} - the analysis-side counterpart to `Repeatr1`'s full, unfiltered song set.
#' @examples
#' Repeatr2
"Repeatr2"

#' Fugazi Live Series choice data in long format with related discography data and dummy variables for age categories of songs.
#'
#' Song data from the Fugazi discography pages on Wikipedia. The variables attributing lead vocals are simplifications in some cases where lead vocals were shared.
#' The variables song_number, first_song and last_song were defined after data cleaning, so intros, outros, sound checks, interludes and one-offs are not included.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @source https://web.archive.org/web/20201112000517/http://en.wikipedia.org/wiki/Fugazi_discography
#' @format dataframe with one row for each show, each song performed and each song available in all the Fugazi Live Series shows with data.
#' \describe{
#' \item{gid}{gig id. This is a concatenation of city, country, and date}
#' \item{case}{This is a numerical id with unique values for each combination of gid and song_number}
#' \item{song_number}{The number of the song in the sequence of songs that were performed as part of that show}
#' \item{alt}{A dense 1..n index over the `min_song_count`-eligible songs only, in `songid` order - this is the alternative-specific index `mlogit`/\code{\link{Repeatr_4}} actually sees. See \code{\link{altlookup}} to translate back to song identity.}
#' \item{choice}{1 if the song was performed at that point in the show, 0 otherwise}
#' \item{yearsold}{The difference between the date of the show and the launchdate of the song, measured in years}
#' \item{vocals_picciotto}{indicates whether or not Guy Picciotto sang lead vocals on this track}
#' \item{vocals_mackaye}{indicates whether or not Ian Mackaye sang lead vocals on this track}
#' \item{vocals_lally}{indicates whether or not Joe Lally sang lead vocals on this track}
#' \item{instrumental}{Indicates whether or not the piece is an instrumental}
#' \item{first_song}{Identifies the first song of the set}
#' \item{last_song}{Identifies the last song of the set}
#' \item{duration_seconds}{The duration of the song in seconds}
#' \item{yearsold_0}{0 < age < 1}
#' \item{yearsold_1}{1 <= age < 2}
#' \item{yearsold_2}{2 <= age < 3}
#' \item{yearsold_3}{3 <= age < 4}
#' \item{yearsold_4}{4 <= age < 5}
#' \item{yearsold_5}{5 <= age < 6}
#' \item{yearsold_6}{6 <= age < 7}
#' \item{yearsold_7}{7 <= age < 8}
#' \item{yearsold_8}{8 <= age}
#' \item{yearsold_1_vp}{1 <= age < 2 and vocals Picciotto}
#' \item{yearsold_2_vp}{2 <= age < 3 and vocals Picciotto}
#' \item{yearsold_3_vp}{3 <= age < 4 and vocals Picciotto}
#' \item{yearsold_4_vp}{4 <= age < 5 and vocals Picciotto}
#' \item{yearsold_5_vp}{5 <= age < 6 and vocals Picciotto}
#' \item{yearsold_6_vp}{6 <= age < 7 and vocals Picciotto}
#' \item{yearsold_7_vp}{7 <= age < 8 and vocals Picciotto}
#' \item{yearsold_8_vp}{8 <= age and vocals Picciotto}
#' \item{first_song_instrumental}{1 if first song of the show and instrumental, 0 otherwise}
#' \item{vocals_picciotto_sum}{running total of songs with lead vocals by Guy Picciotto in this show}
#' \item{vocals_mackaye_sum}{running total of songs with lead vocals by Ian Mackaye in this show}
#' \item{vocals_lally_sum}{running total of songs with lead vocals by Joe Lally in this show}
#' }
#' @section Provenance: Derived-modeled. Produced by \code{\link{Repeatr_3}} from `Repeatr2`: variable selection and integer compression, ready for \code{\link{Repeatr_4}}'s `mlogit` fit.
#' @examples
#' Repeatr3
"Repeatr3"


# Sound quality and played-with -------------------------------------------

#' Sound quality data, one record per show
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each show in the Fugazi Live Series data.
#' \describe{
#' \item{gid}{show id}
#' \item{sound_quality}{Sound quality rating: Excellent, Very Good, Good, or Poor.}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}}.
#' @examples
#' gid_sound_quality
"gid_sound_quality"

#' 952 stacks of 10-13 shows covering the whole Fugazi repertoire (92 songs), one for each show in the Fugazi Live Series.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each combination of initial show and stacked show.
#' \describe{
#' \item{gid_initial}{show id of the initial show, used to identify each stack of shows}
#' \item{gid}{show id of each show contained within each stack}
#' \item{sound_quality}{Sound quality rating: Excellent, Very Good, Good, or Poor.}
#' }
#' @section Provenance: Derived-modeled. Generated by \code{\link{Repeatr_6}} (via \code{\link{sweepstack}}/\code{\link{stacks}}) whenever \code{\link{Repeatr_Updatr}} is run with `update_stacks = TRUE` - threads that run's fresh `duration_data_da`, `gid_sound_quality`, `othervariables`, and `summary` through explicitly, the same way every other pipeline stage does. Actively consumed directly by `inst/shiny/Fugazetteer/app.R` for the "stock" pages.
#' @examples
#' gid_initial_gid_sound_quality
"gid_initial_gid_sound_quality"

#' Fugazi Live Series data on bands that fugazi played with in long format
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @source https://arquivomotor.wordpress.com/1994/08/12/bhrif-programacao/
#' @format dataframe with one row for show and each band that Fugazi played with in the Fugazi Live Series shows with data.
#' \describe{
#' \item{gid}{gig id.  This is a concatenation of city, country, and date}
#' \item{fls_id}{Fugazi Live Series ID}
#' \item{played_with}{Band name}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}}. Exported (trimmed to `gid`/`played_with`, `played_with` renamed `band`) as fugazibase's `bands` table by \code{\link{export_fugazibase_data}}.
#' @examples
#' played_with
"played_with"

#' Fugazi Live Series summary data on bands that fugazi played with, one row per combination of year, tour and band, with corresponding number of shows.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @source https://arquivomotor.wordpress.com/1994/08/12/bhrif-programacao/
#' @format dataframe with one row for each band that Fugazi played with in the Fugazi Live Series shows with data.
#' \describe{
#' \item{year}{year}
#' \item{tour}{tour}
#' \item{played_with}{band name}
#' \item{shows}{number of shows}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}}.
#' @examples
#' played_with_summary
"played_with_summary"


# Shows, venues, tours, attendance ----------------------------------------

#' Shows Data
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each show in the Fugazi Live Series data.
#' \describe{
#' \item{gid}{Unique identifier for the show}
#' \item{tour}{The tour that the show belongs to.}
#' \item{year}{The year of the show,}
#' \item{date}{The date of the show.}
#' \item{venue}{the venue,}
#' \item{city}{the city.}
#' \item{subdivision}{Subnational administrative unit (US state, DC, Canadian province, Australian state/territory, or Brazilian state), where applicable (`NA` elsewhere) - see \code{\link{othervariables}} for how Brazilian codes are filled in.}
#' \item{country}{The country.}
#' \item{attendance}{The number of people who attended.}
#' \item{price}{Numeric ticket price (`NA` where unknown, `0` for free shows) - see \code{\link{othervariables}} for how this is split from the raw scraped door-price text.}
#' \item{currency}{ISO 4217 currency code for `price`.}
#' \item{latitude}{The latitude of the show location.}
#' \item{longitude}{The longitude of the show location.}
#' \item{urls}{A string used to form the URLs of the corresponding page on the Fugazi Live series site.}
#' \item{fls_link}{a link to the corresponding page of the Fugazi Live Series site.}
#' \item{minutes}{duration of the show in minutes if a recording is available}
#' \item{sound_quality}{Sound quality rating: Excellent, Very Good, Good, or Poor.}
#' \item{distance_home_km}{Great-circle distance (km, via \code{geosphere::distGeo}) from this show to "home" - the location of the earliest-dated show in the series (the Wilson Center, Fugazi's first ever show in 1987). Always populated.}
#' \item{distance_to_km}{Distance (km) traveled *to* this show: from the previous show, if this show is classified as part of the same tour chain as it (see `Provenance` below), otherwise from home (i.e. equal to `distance_home_km`, for a home-based show or the first stop of a tour chain). Always populated.}
#' \item{distance_back_km}{Distance (km) traveled *back home* after this show. Populated only for a home-based show or the last stop of a tour chain (`NA` for every other tour stop, since the band hadn't returned home yet).}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}}. Actively consumed directly by `inst/shiny/Fugazetteer/app.R`. The three `distance_*_km` columns (issue #259) are computed by `classify_show_trips()` in `R/recap.R`, which classifies each show as home-based or part of a moving tour chain purely from geography and dates (whether it's geographically closer to the previous show than to home, and within a plausible date gap of it) - a show within `home_radius_km` of home is always treated as home-based. This classification is deliberately independent of the `tour` column above, whose own tour/regional-dates labelling isn't reliable enough to build on; `tour` is used only as an informal sanity check against it (see `inst/notes` for the cross-check from when this was added), never as an input. These three columns are internal to Repeatr and are not exported to fugazibase.
#' @examples
#' shows_data
"shows_data"



# Song lookups and discography --------------------------------------------

#' Fugazi song id lookup table
#'
#' @format dataframe with one row for each song in the Fugazi discography, except those which never appear in the Fugazi Live Series data.
#' \describe{
#' \item{songid}{numeric id for each song, based on the alphabetical order of the song names. Assigned to every classified song, including one-off performances and rarities below `min_song_count`.}
#' \item{title}{The name of the song}
#' \item{count}{The number of times the song was performed according to the data. Used by \code{\link{Repeatr_2}} to apply the `min_song_count` choice-model eligibility filter.}
#' }
#' @section Provenance: Derived-classified. Computed live in \code{\link{Repeatr_1}} from `Repeatr1`; the single source of truth for song identity - not hand-edited, and (after the songid fix) assigned to every classified song including one-offs, not just those meeting `min_song_count`. Not exported to fugazibase - `songid` and `count` are calculated/summary values, kept internal to `Repeatr` by design; fugazibase's `songs` table is \code{\link{songvarslookup}} alone, joined by `title` text where needed.
#' @examples
#' songidlookup
"songidlookup"

#' Fugazi alt id lookup table (choice-model alternative index)
#'
#' @format dataframe with one row for each song meeting `min_song_count` in \code{\link{Repeatr_2}} - i.e. every song that competes as a `mlogit` alternative.
#' \describe{
#' \item{alt}{Dense 1..n index over the `min_song_count`-eligible songs, in `songid` order. The alternative-specific index `mlogit`/\code{\link{Repeatr_4}} actually sees - not the same as `songid`, which spans every classified song.}
#' \item{songid}{The stable, full song identity from \code{\link{songidlookup}}.}
#' \item{title}{The name of the song}
#' \item{count}{The number of times the song was performed according to the data}
#' }
#' @section Provenance: Derived-modeled. Computed live in \code{\link{Repeatr_2}}; the translation table between `alt` (what the choice model sees) and `songid`/`title` (stable identity) used by \code{\link{Repeatr_5}} and \code{\link{rankr}}.
#' @examples
#' altlookup
"altlookup"

#' Fugazi releases data
#'
#' @format dataframe with one row for each release.
#' \describe{
#' \item{rid}{numeric id in ascending chronological order}
#' \item{release_title}{release name}
#' \item{variable}{release names for use as variable names}
#' \item{release_date}{release date}
#' \item{release_date_source}{source of the release date}
#' \item{colour_code}{hex colour code to be used for the release in graphs}
#' \item{rym_rating}{RYM rating scaled to the interval between 0 and 1}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}} from `inst/extdata/releases.csv` (which itself carries a manually-assigned `colour_code` and an `rym_rating` sourced from rateyourmusic.com); `releaseid`/`release`/`releasedate` renamed `rid`/`release_title`/`release_date` at read time. Exported (minus `colour_code`, `variable`, `rym_rating`, minus the four synthetic UI-bucket rows) as fugazibase's `discography` table by \code{\link{export_fugazibase_data}}.
#' @examples
#' releasesdatalookup
"releasesdatalookup"

#' Song discography metadata (Wikipedia)
#'
#' @source https://web.archive.org/web/20201112000517/http://en.wikipedia.org/wiki/Fugazi_discography
#' @format dataframe with one row for each song in the Fugazi discography.
#' \describe{
#' \item{rid}{numeric id of the release the song appears on, references \code{\link{releasesdatalookup}}}
#' \item{track_number}{The track number for the song on the release}
#' \item{title}{The name of the song}
#' \item{instrumental}{Indicates whether or not the piece is an instrumental}
#' \item{vocals_picciotto}{indicates whether or not Guy Picciotto sang lead vocals on this track}
#' \item{vocals_mackaye}{indicates whether or not Ian Mackaye sang lead vocals on this track}
#' \item{vocals_lally}{indicates whether or not Joe Lally sang lead vocals on this track}
#' \item{duration_seconds}{duration of the studio recording, in seconds}
#' }
#' @section Provenance: Raw-hand-curated, from `inst/extdata/releases_songs_durations_wikipedia.csv`; `releaseid`/`song` renamed `rid`/`title` at read time. Read by \code{\link{Repeatr_1}} and joined onto the live, classified song set by `title` text, not by a hardcoded id column - see `songid`/\code{\link{songidlookup}}. Exported (renamed `track_number`→`release_track`, `duration_seconds`→`release_duration` converted to a `Period` matching \code{\link{fls_tags}}'s `duration`) as fugazibase's `songs` table by \code{\link{export_fugazibase_data}}.
#' @examples
#' songvarslookup
"songvarslookup"

#' Releases data input
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each song in the Fugazi discography, except those which never appear in the Fugazi Live Series data.
#' \describe{
#' \item{rid}{numeric id in ascending chronological order}
#' \item{release_title}{release name}
#' \item{track_number}{The track number for the song on the release}
#' \item{title}{The name of the song}
#' \item{last_show}{The number of the last show in the series}
#' \item{colour_code}{The hex colour code used for the corresponding release}
#' \item{count}{The number of times the song was performed according to the data}
#' \item{date}{The debut date of the song}
#' \item{show_num}{The show number of the debut of the song}
#' \item{shows}{The number of shows in which the song could have been performed}
#' \item{intensity}{The rate at which the song was played - this is count / shows}
#' \item{rating}{The rating calculated for the song based on preferences implied by the choices of which songs to play.}
#' }
#' @section Provenance: Derived-modeled. Produced twice: an intermediate version in \code{\link{Repeatr_1}}, finalized by \code{\link{Repeatr_5}} once the choice-model `rating` column is available.
#' @examples
#' releases_data_input
"releases_data_input"

#' Releases menu list
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each release in the Fugazi discography, except those which never appear in the Fugazi Live Series data.
#' \describe{
#' \item{rid}{A unique identifier for the release based on the alphabetical order of the titles.}
#' \item{release_title}{The name of the release.}
#' \item{variable}{The name of the release in snake case.}
#' \item{first_debut}{the date of the first debut from this release}
#' \item{release_date}{this is an assumption based on the available evidence. Actual release dates will have been different in different places.}
#' \item{release_date_source}{The source of the release date assumption}
#' \item{colour code}{Hex code of the colour used for this release in graphs.}
#' \item{rym}{The rate your music rating of the release - November 2021.}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}}.
#' @examples
#' releases_menu_list
"releases_menu_list"

#' Releases Summary
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each release in the Fugazi discography.
#' \describe{
#' \item{release_title}{The name of the release.}
#' \item{first_debut}{the date of the first debut from this release}
#' \item{last_debut}{the date of the last debut from this release}
#' \item{release_date}{this is an assumption based on the available evidence. Actual release dates will have been different in different places.}
#' \item{songs}{number of songs on the release}
#' \item{count}{total number of performances of the songs on the release}
#' \item{shows}{number of shows at which songs from the release were performed}
#' \item{rate}{the average of the rates for the songs on the release}
#' }
#' @section Provenance: Derived-modeled. Produced by \code{\link{Repeatr_5}}: its `rate` column is the average of the choice-model-derived song ratings on each release.
#' @examples
#' releases_summary
"releases_summary"

#' Release ID, variable, colour code
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each release in the Fugazi discography, except those which never appear in the Fugazi Live Series data.
#' \describe{
#' \item{rid}{A unique identifier for the release based on the alphabetical order of the titles.}
#' \item{variable}{The name of the release in snake case.}
#' \item{colour code}{Hex code of the colour used for this release in graphs.}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}}.
#' @examples
#' releaseid_variable_colour_code
"releaseid_variable_colour_code"

# Tags and duration data (from MP3 tags) ----------------------------------

#' Tags data
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each track in the Fugazi Live Series data, including data from the audio file tags.
#' \describe{
#' \item{track}{track number}
#' \item{title}{track name}
#' \item{duration}{duration in period format (lubridate)}
#' \item{seconds}{duration in seconds}
#' \item{date}{date}
#' \item{gid}{show id}
#' }
#' @section Provenance: Derived-cleaned. Parsed by \code{\link{Repeatr_1}} (via \code{\link{fls_tags_importer}}) from the raw `inst/extdata/fls_tags.txt` kid3 MP3-tag export; the raw tag's `name` field is renamed `title` at read time. The underlying track/album/song names themselves are sourced from the Fugazi Live Series site, not personal data - Alex Mitrani applied a consistent album-name format and a handful of one-off track-title corrections on top (see the "process tags data" section of \code{\link{Repeatr_1}}). The raw `album` tag text (`YYYYMMDD Venue, City, State, Country`) is used internally to parse `venue`/`city`/`subdivision`/`country` for a couple of mistagged-track filters and to derive \code{\link{fls_tags_show}}, but those fields (and `album` itself) are dropped before saving, since parsing them by counting commas silently misparses whenever a venue or city name itself contains a comma (e.g. Ypsilanti, Flint, Eau Claire, Osaka), and \code{\link{shows_data}} (joined via `gid`) is the sole authoritative source for them. Exported (minus `date` - join fugazibase's `shows` on `gid` instead - and `seconds`, which duplicated `duration`; `track` converted from character to integer) as fugazibase's `durations` table by \code{\link{export_fugazibase_data}}.
#' @examples
#' fls_tags
"fls_tags"

#' Tags data, one record per show
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each show in the Fugazi Live Series data, including data from the audio file tags.
#' \describe{
#' \item{gid}{show id}
#' \item{duration}{duration in period format (lubridate)}
#' \item{seconds}{duration in seconds}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}} from `fls_tags`, grouped by `(gid, album)` so that two distinct tag batches sharing a `gid` (e.g. an earlier recording later superseded by an official release) produce two rows rather than silently summing their durations together - `album` itself is dropped before saving, since nothing reads it. Deliberately does not carry its own venue/city/subdivision/country/date - those are independently re-parsed from the album tag text by counting commas, which silently misparses whenever a venue or city name itself contains a comma (e.g. Ypsilanti, Flint, Eau Claire, Osaka). \code{\link{shows_data}} (joined via `gid`) is the sole authoritative source for those fields. Not exported to fugazibase.
#' @examples
#' fls_tags_show
"fls_tags_show"

#' Song tempo (BPM) data
#'
#' @format dataframe with one row for each song with a personally-measured tempo reading.
#' \describe{
#' \item{title}{The name of the song}
#' \item{tempo_bpm}{Tempo, in beats per minute, measured personally by Alex Mitrani}
#' }
#' @section Provenance: Raw-hand-curated, from `inst/extdata/song_tempo_bpm_data.csv`. Read as-is by \code{\link{Repeatr_1}}, no transformation. Not exported to fugazibase - kept in `Repeatr` only, for its own Shiny app.
#' @examples
#' song_tempo_bpm_data
"song_tempo_bpm_data"

#' Duration Data
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each rendition of each song in the Fugazi Live Series data.
#' \describe{
#' \item{gid}{Unique identifier for the show}
#' \item{date}{The date of the show.}
#' \item{song_number}{this is the number of the song in the set, where 1 is the first song in that show. Larger numbers will indicate that the song was played later in the set,}
#' \item{title}{the name of the song}
#' \item{urls}{A string used to form the URLs of the corresponding page on the Fugazi Live series site.}
#' \item{fls_link}{a link to the corresponding page of the Fugazi Live Series site.}
#' \item{minutes}{duration of the song in minutes}
#' \item{position}{normalized position of the song within the show's setlist, from 0 (first song) to 1 (last song), rounded to 2 decimal places}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}}. Also a direct input to \code{\link{sweepstack}}/\code{\link{stacks}}.
#' @examples
#' duration_data_da
"duration_data_da"

#' Fugazi song duration summary data
#'
#' Summary data on the song durations in the Fugazi Live Series.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each song in the Fugazi discography, except those which never appear in the Fugazi Live Series data.
#' \describe{
#' \item{title}{Name of the song}
#' \item{renditions}{The number of times the song was played live according to the available recordings.}
#' \item{minutes_min}{The minimum duration. In many cases this will be as short as it is because the recording was cut off, not because the band played the song really fast.}
#' \item{minutes_median}{The median duration: if all the renditions were lined up in order from shortest to longest this would be the middle one.}
#' \item{minutes_max}{The maximum duration.}
#' \item{minutes_mean}{The average duration.}
#' \item{minutes_sd}{The standard deviation of the duration - this is a measure of spread, it indicates how much variation there is across all of the renditions.}
#' \item{minutes_total}{The total duration of all the times the song was played.}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}}.
#' @examples
#' duration_summary
"duration_summary"

#' Fugazi song position summary data
#'
#' Summary data on each song's normalized position within the setlist, across the Fugazi Live Series.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each song in the Fugazi discography that appears in \code{\link{duration_data_da}}.
#' \describe{
#' \item{title}{Name of the song}
#' \item{renditions}{The number of times the song was played live according to the available recordings.}
#' \item{position_min}{The minimum normalized position (0 = first song in the set).}
#' \item{position_median}{The median normalized position: if all the renditions were lined up in order from earliest to latest in the set this would be the middle one.}
#' \item{position_max}{The maximum normalized position (1 = last song in the set).}
#' \item{position_mean}{The average normalized position.}
#' \item{position_sd}{The standard deviation of the normalized position - this is a measure of spread, it indicates how much variation there is in where the song falls in the set across all of the renditions.}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}}.
#' @examples
#' position_summary
"position_summary"

#' Cumulative Duration Counts
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each combination of song and duration in the Fugazi Live Series data.
#' \describe{
#' \item{minutes}{Duration of the show in minutes}
#' \item{title}{Name of the song}
#' \item{release_title}{Name of the corresponding discographical release}
#' \item{count}{The cumulative count of the number of times the song had been performed up to and including this duration.}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}}.
#' @examples
#' cumulative_duration_counts
"cumulative_duration_counts"

#' Cumulative Position Counts
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each combination of song and normalized setlist position in the Fugazi Live Series data.
#' \describe{
#' \item{position}{Normalized position of the song within the show's setlist, from 0 (first song) to 1 (last song)}
#' \item{title}{Name of the song}
#' \item{release_title}{Name of the corresponding discographical release}
#' \item{count}{The cumulative count of the number of times the song had been performed up to and including this position.}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}}.
#' @examples
#' cumulative_position_counts
"cumulative_position_counts"

#' Cumulative Song Counts
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each combination of song and date in the Fugazi Live Series data.
#' \describe{
#' \item{date}{Date of the show}
#' \item{title}{Name of the song}
#' \item{release_title}{Name of the corresponding discographical release}
#' \item{count}{The cumulative count of the number of times the song had been performed up to and including this performance.}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}}.
#' @examples
#' cumulative_song_counts
"cumulative_song_counts"

#' Fugazi song performance counts
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each song in the Fugazi discography, except those which never appear in the Fugazi Live Series data.
#' \describe{
#' \item{songid}{numeric id for each song}
#' \item{title}{The name of the song}
#' \item{launchdate}{The date on which the song was first performed according to the data}
#' \item{count}{The number of times the song was performed according to the data}
#' }
#' @section Provenance: Derived-modeled. Produced by \code{\link{Repeatr_2}}, but covers every classified song, not just the `min_song_count`-eligible subset used to build `alt` - one-off performances and rarities appear here too.
#' @examples
#' fugazi_song_counts
"fugazi_song_counts"

#' Fugazi song performance intensity data
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each song in the Fugazi discography, except those which never appear in the Fugazi Live Series data.
#' \describe{
#' \item{songid}{numeric id for each song}
#' \item{title}{The name of the song}
#' \item{launchdate}{The date on which the song was first performed according to the data}
#' \item{chosen}{The number of times the song was performed according to the data}
#' \item{available_rl}{The number of shows for which the song was available in the band's repertoire}
#' \item{intensity}{The performance intensity is the ratio of chosen/available_rl}
#' }
#' @section Provenance: Derived-modeled. Produced by \code{\link{Repeatr_2}} from the `min_song_count`-eligible subset only (it needs `available_rl`, which is only tracked for songs that got an `alt`) - unlike `fugazi_song_counts`, one-off/rare songs are not included here.
#' @examples
#' fugazi_song_performance_intensity
"fugazi_song_performance_intensity"

#' Last Performance Data
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each song that was performed at least twice in the Fugazi Live Series data.
#' \describe{
#' \item{title}{name of the song}
#' \item{last_performance}{date of the last performance.}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}}.
#' @examples
#' last_performance_data
"last_performance_data"


# Choice model outputs -----------------------------------------------------

#' Estimated coefficients and related statistics from the model ml.Repeatr4
#'
#' Basic choice model
#'
#' This model was estimated with mlogit on all of the data.
#'
#' The utility formula was as follows:
#'
#' choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5 + yearsold_6 + yearsold_7 + yearsold_8 + song2 + ... + song92
#'
#' @format dataframe with one row for each coefficient in the model.
#' \describe{
#' \item{Estimate}{The coefficient value}
#' \item{Std. Error}{The standard error of the coefficient}
#' \item{z-value}{The z-value of the coefficient}
#' \item{Pr(>|z|)}{The P value of the coefficient}
#' }
#' @section Provenance: Derived-modeled. Produced by \code{\link{Repeatr_4}} (`mlogit` fit on `Repeatr3`).
#' @examples
#' results_ml_Repeatr4
"results_ml_Repeatr4"

#' Variance-covariance matrix from the model ml.Repeatr4
#'
#' The variance-covariance matrix of the coefficients estimated in the basic choice model (see \code{\link{results_ml_Repeatr4}}), typically produced via `vcov(ml.Repeatr4)`. Used by \code{\link{diffr}}/\code{\link{rankr}} to test whether pairs of coefficients differ significantly.
#'
#' @format a square matrix with one row and one column per model coefficient, in the same order as \code{\link{results_ml_Repeatr4}}.
#' @section Provenance: Derived-modeled. Produced by \code{\link{Repeatr_4}} via `vcov()` on the fitted model, saved in the same call as `results_ml_Repeatr4` so the two can never describe different fits.
#' @examples
#' vcovmat_ml_Repeatr4
"vcovmat_ml_Repeatr4"

#' Fugazi song choice model results, with song names substituted in for intercept terms
#'
#' Produced by \code{\link{Repeatr_5}} from \code{\link{results_ml_Repeatr4}}: the raw model `variable` names for the per-song intercept terms (e.g. `(Intercept):5`) are replaced with the corresponding song name, using \code{\link{songidlookup}}.
#'
#' @format dataframe with one row for each coefficient in the model.
#' \describe{
#' \item{variable}{The name of the model covariate, or the song name for intercept terms}
#' \item{Estimate}{The coefficient value}
#' \item{Std. Error}{The standard error of the coefficient}
#' \item{z-value}{The z-value of the coefficient}
#' \item{Pr(>|z|)}{The P value of the coefficient}
#' }
#' @section Provenance: Derived-modeled. Produced by \code{\link{Repeatr_5}} from `results_ml_Repeatr4`.
#' @examples
#' fugazi_song_choice_model
"fugazi_song_choice_model"

#' Fugazi song preferences, ranked by estimated intercept (implied preference)
#'
#' Produced by \code{\link{Repeatr_5}} from the per-song intercept terms of \code{\link{results_ml_Repeatr4}} (the omitted reference song - whichever has the smallest `alt` in \code{\link{altlookup}} - is added back in with an estimate of 0), ranked from most to least preferred.
#'
#' @format dataframe with one row for each song, ranked by estimated preference.
#' \describe{
#' \item{rank_rating}{Rank of the song by estimated preference, 1 = most preferred}
#' \item{songid}{numeric id for each song}
#' \item{title}{The name of the song}
#' \item{Estimate}{The estimated intercept for this song (0 for the omitted reference song)}
#' \item{z-value}{The z-value of the estimate (NA for the omitted reference song)}
#' }
#' @section Provenance: Derived-modeled. Produced by \code{\link{Repeatr_5}} from `results_ml_Repeatr4`.
#' @examples
#' fugazi_song_preferences
"fugazi_song_preferences"

#' Average estimated song rating by release
#'
#' Produced by \code{\link{Repeatr_5}}: average of the estimated \code{\link{summary}} rating across the songs on each release (excluding First Demo and Unreleased, which aren't comparable to the others).
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each release.
#' \describe{
#' \item{release_title}{The name of the release.}
#' \item{rid}{numeric id in ascending chronological order}
#' \item{release_date}{The date of the release}
#' \item{songs_rated}{The number of songs on the release that were rated}
#' \item{rating}{The average rating across the rated songs on the release}
#' }
#' @section Provenance: Derived-modeled. Produced by \code{\link{Repeatr_5}}.
#' @examples
#' releases_rated
"releases_rated"

#' Summary
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each song in the Fugazi discography, except those which never appear in the Fugazi Live Series data.
#' \describe{
#' \item{rank_rating}{The rank of the song in terms of the rating derived from the choice modelling, with the highest-rated song in the first position.}
#' \item{songid}{numeric id for each song}
#' \item{title}{The name of the song}
#' \item{launchdate}{The date on which the song was first performed according to the data}
#' \item{duration_seconds}{The duration of the song in seconds}
#' \item{chosen}{The number of times the song was performed according to the data}
#' \item{available_rl}{The number of shows for which the song was available in the band's repertoire}
#' \item{intensity}{The performance intensity is the ratio of chosen/available_rl}
#' \item{rating}{Rating on the interval between 0 and 1 where 1 is the highest rating and 0 the lowest.}
#' \item{rid}{numeric id in ascending chronological order}
#' \item{release_title}{release name}
#' \item{track_number}{The track number for the song on the release}
#' \item{instrumental}{Indicates whether or not the piece is an instrumental}
#' \item{vocals_picciotto}{indicates whether or not Guy Picciotto sang lead vocals on this track}
#' \item{vocals_mackaye}{indicates whether or not Ian Mackaye sang lead vocals on this track}
#' \item{vocals_lally}{indicates whether or not Joe Lally sang lead vocals on this track}
#' \item{release_date}{The date of the corresponding release}
#' \item{lead}{The number of days between the launch date and the release date}
#' \item{launchyear}{The year in which the song was first performed}
#' \item{releaseyear}{The year in which the song was released}
#' }
#' @section Provenance: Derived-modeled. Produced by \code{\link{Repeatr_5}}, the final combined song-level output of the whole pipeline. Actively consumed directly by `inst/shiny/Fugazetteer/app.R`.
#' @examples
#' summary
"summary"


# Transitions and xray -----------------------------------------------------

#' Transitions Data
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each combination of show, first song and second song in the Fugazi Live Series data.
#' \describe{
#' \item{gid}{gig id.  This is a concatenation of city, country, and date}
#' \item{url}{url to the corresponding page of the Fugazi Live Series site.}
#' \item{fls_link}{provides a link to the corresponding page of the Fugazi Live Series site}
#' \item{date}{date of the show}
#' \item{transition}{Number of the transition in the show}
#' \item{title1}{Name of the first song}
#' \item{title2}{Name of the second song}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}}. Not to be confused with the orphaned `transitions` object.
#' @examples
#' transitions_data_da
"transitions_data_da"

#' xray
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each rendition of each show in the Fugazi Live Series data and each type of units (tracks and minutes)
#' \describe{
#' \item{gid}{gig id.  This is a concatenation of city, country, and date}
#' \item{url}{url to the corresponding page of the Fugazi Live Series site.}
#' \item{fls_link}{a link to the corresponding page of the Fugazi Live Series site.}
#' \item{year}{The year of the show,}
#' \item{tour}{The tour that the show belongs to.}
#' \item{date}{The date of the show.}
#' \item{units}{The units can be either tracks or minutes.  The remaining columns on any given row will be in these units}
#' \item{songs}{songs that were performed at least twice}
#' \item{released}{songs that had been released before the date of the show}
#' \item{unreleased}{songs that had not been released before the date of the show}
#' \item{debut}{songs that were performed for the first time at this show}
#' \item{farewell}{songs that were performed for the last time at this show}
#' \item{incumbent}{songs that were neither performed for the first time or the last at this show}
#' \item{other}{tracks that are something else, for instance: intro, opening remarks, interlude, encore, outro, interruptions, and one-offs.}
#' \item{...}{The remaining columns correspond to specific releases in the band's catalogue.}
#' }
#' @section Provenance: Derived-cleaned. Produced by \code{\link{Repeatr_1}}.
#' @examples
#' xray
"xray"


# Shiny-presentation-only cached views -------------------------------------
#
# The objects below exist purely to save inst/shiny/Fugazetteer/app.R from
# recomputing, on every app start, joins/aggregations that don't depend on
# any of its three live Google Sheets reads (fls_venue_geocoding, quizdata,
# linktracksindexdata). Produced by build_shiny_precompute(), which mirrors
# the exact code app.R itself used to run inline - see that function's own
# documentation. Not part of Repeatr's canonical data model, not consumed by
# any R/ function, and not exported to fugazibase (see
# vignette("Data-Provenance")).

#' `Repeatr1`, summarized by year/gid/release and joined with `othervariables`
#'
#' @format dataframe with one row for each combination of year, `gid`, and
#'   `release_title` that appears in \code{\link{Repeatr1}}.
#' \describe{
#' \item{year}{year}
#' \item{gid}{show id}
#' \item{release_title}{name of album or EP}
#' \item{tour}{the touring period the show belongs to, from \code{\link{othervariables}}}
#' \item{count}{number of songs from this release performed at this show}
#' }
#' @section Provenance: Shiny-presentation-only. Produced by \code{\link{build_shiny_precompute}} from \code{\link{Repeatr1}} and \code{\link{othervariables}}.
#' @examples
#' shiny_year_tour_release
"shiny_year_tour_release"

#' `shows_data`, trimmed to `fls_link`/`year`/`tour`
#'
#' @format dataframe with one row for each show in \code{\link{shows_data}}.
#' \describe{
#' \item{fls_link}{a link to the corresponding page of the Fugazi Live Series site}
#' \item{year}{year}
#' \item{tour}{the touring period the show belongs to}
#' }
#' @section Provenance: Shiny-presentation-only. Produced by \code{\link{build_shiny_precompute}} from \code{\link{shows_data}}.
#' @examples
#' shiny_fls_link_year_tour
"shiny_fls_link_year_tour"

#' `transitions_data_da` joined with `shiny_fls_link_year_tour`
#'
#' @format dataframe with the same rows as \code{\link{transitions_data_da}}, plus `year`/`tour`.
#' @section Provenance: Shiny-presentation-only. Produced by \code{\link{build_shiny_precompute}} from \code{\link{transitions_data_da}} and \code{\link{shiny_fls_link_year_tour}}. Not to be confused with the package's own `transitions_data_da`, which this does not overwrite.
#' @examples
#' shiny_transitions_data_da
"shiny_transitions_data_da"

#' `duration_data_da` joined with each song's `release_title`
#'
#' @format dataframe with the same rows as \code{\link{duration_data_da}}, plus `release_title`.
#' @section Provenance: Shiny-presentation-only. Produced by \code{\link{build_shiny_precompute}} from \code{\link{duration_data_da}} and \code{\link{summary}}. Not to be confused with the package's own `duration_data_da`, which this does not overwrite.
#' @examples
#' shiny_duration_data_da
"shiny_duration_data_da"

#' `othervariables` joined with sound quality and dischord.com link columns
#'
#' The base app.R builds its own runtime `othervariables` from: joins in the
#' live `fls_venue_geocoding` sheet for coordinates, disambiguates
#' same-named cities, and de-duplicates by `gid`. Coordinates change if the
#' sheet is edited, so that part must stay a live, runtime join - this
#' object is everything upstream of it.
#'
#' @format dataframe with the same rows as \code{\link{othervariables}}, plus `sound_quality`, `urls`, `fls_link`.
#' @section Provenance: Shiny-presentation-only. Produced by \code{\link{build_shiny_precompute}} from \code{\link{othervariables}} and \code{\link{gid_sound_quality}}.
#' @examples
#' shiny_othervariables_base
"shiny_othervariables_base"

#' `duration_data_da` joined with `othervariables`, trimmed to `year`/`tour`/`gid`/`title`
#'
#' @format dataframe with one row for each rendition of each song in \code{\link{duration_data_da}}.
#' \describe{
#' \item{year}{year}
#' \item{tour}{the touring period the show belongs to}
#' \item{gid}{show id}
#' \item{title}{the name of the song}
#' }
#' @section Provenance: Shiny-presentation-only. Produced by \code{\link{build_shiny_precompute}} from \code{\link{duration_data_da}} and \code{\link{othervariables}}. Built from the raw (pre-live-coordinate-join) `othervariables`, since only `year`/`tour` are kept and those don't depend on the live sheet.
#' @examples
#' shiny_year_tour_gid_song
"shiny_year_tour_gid_song"

#' `summary`, trimmed to `title`/`release_title`
#'
#' @format dataframe with one row for each song in \code{\link{summary}}.
#' \describe{
#' \item{title}{the name of the song}
#' \item{release_title}{name of album or EP}
#' }
#' @section Provenance: Shiny-presentation-only. Produced by \code{\link{build_shiny_precompute}} from \code{\link{summary}}.
#' @examples
#' shiny_discography
"shiny_discography"

#' `releases_data_input` enriched with tempo (BPM) and duration
#'
#' @format dataframe with the same rows as \code{\link{releases_data_input}}, plus `tempo_bpm`, `duration_seconds`, `minutes` (`title` becomes a factor, ordered as returned by the underlying `arrange()`).
#' @section Provenance: Shiny-presentation-only. Produced by \code{\link{build_shiny_precompute}} from \code{\link{releases_data_input}}, \code{\link{song_tempo_bpm_data}}, and \code{\link{songvarslookup}}. Not to be confused with the package's own `releases_data_input`, which this does not overwrite.
#' @examples
#' shiny_releases_data_input
"shiny_releases_data_input"

#' `releases_summary` enriched with average tempo (BPM) and duration
#'
#' @format dataframe with the same rows as \code{\link{releases_summary}}, plus `tempo_bpm`, `minutes`.
#' @section Provenance: Shiny-presentation-only. Produced by \code{\link{build_shiny_precompute}} from \code{\link{releases_summary}} and \code{\link{shiny_releases_data_input}}. Not to be confused with the package's own `releases_summary`, which this does not overwrite.
#' @examples
#' shiny_releases_summary
"shiny_releases_summary"

#' `shows_data` enriched with average tempo (BPM), before the live venue-coordinate join
#'
#' The base app.R builds its own runtime `shows_data` from: joins in the
#' live `fls_venue_geocoding` sheet for coordinates, disambiguates
#' same-named cities, and de-duplicates by `gid`. Coordinates change if the
#' sheet is edited, so that part must stay a live, runtime join - this
#' object is everything upstream of it.
#'
#' @format dataframe with the same rows as \code{\link{shows_data}}, plus `tempo_bpm`.
#' @section Provenance: Shiny-presentation-only. Produced by \code{\link{build_shiny_precompute}} from \code{\link{shows_data}}, \code{\link{duration_data_da}}, and \code{\link{song_tempo_bpm_data}}. Not to be confused with the package's own `shows_data`, which this does not overwrite.
#' @examples
#' shiny_shows_data_base
"shiny_shows_data_base"
