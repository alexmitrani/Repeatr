# Master recipe for rebuilding every dataset in data/ from source.
#
# This is the canonical, runnable version of the process described in
# vignette("Rebuilding the Data") - read that first for the why behind each
# step. This script itself is not run automatically (data-raw/ is excluded
# from the built package via .Rbuildignore); run the sections you need by
# hand, in order, whenever source data changes.
#
# Primary data (raw sources) lives in this package's own inst/extdata, not
# in a separate package. The companion package fugazi.db is downstream of
# Repeatr, not upstream of it - stage C below generates it from Repeatr's
# own already-rebuilt data. This script has three stages:
#
#   A. Refresh inst/extdata's raw sources (scraping/hand-curation)
#   B. Rebuild Repeatr's own derived data/*.rda from those raw sources
#   C. Export the fugazi.db subset from Repeatr's own rebuilt data
#
# None of stage A's five sources need to be refreshed together - run
# whichever one has new material, then B and (optionally) C.

library(Repeatr)

# A. Refresh inst/extdata's raw sources ------------------------------------
#
# A1. Show data - refreshes inst/extdata/fls_data.csv from the live Fugazi
# Live Series listing: new shows, plus any existing show whose recording has
# newly gone from unavailable to available. Incremental by default
# (update_existing = TRUE here forces a full pass over every discovered show
# instead of only new ones - see ?scrape_fls_shows for the cheaper
# incremental default). Long-running (tens of minutes) and makes many
# requests to dischord.com, so run deliberately, not as part of routine
# package development.

fls_data <- scrape_fls_shows(
  update_existing = TRUE,
  sleepseconds = 2,
  mycsvfilename = system.file("extdata", "fls_data.csv", package = "Repeatr")
)

# A2. Venue coordinates - overwrite inst/extdata/fls_venue_geocoding_v2.csv
# directly from the current export of the private Google Sheet used to look
# up/confirm venue locations on Google Maps. There is no separate
# to-do-list/fallback-file workflow any more (nscmov() is retired) - the
# sheet export is the single source of truth for coordinates, used
# identically by Repeatr's own pipeline and by fugazi.db's export.

# A3. Tags/duration data - no R code here - inst/extdata/fls_tags.txt is
# exported directly from kid3 (https://kid3.kde.org/) against the
# personally-tagged MP3 collection, in the "track; artist; album; name;
# duration" format fls_tags_importer() expects. Tag any new MP3s, re-export,
# and overwrite inst/extdata/fls_tags.txt. If a new show's album string
# doesn't parse cleanly, the hand-written corrections for specific
# albums/venues live in the "process tags data" section of R/Repeatr_1.R.

# A4. Song/release/duration and tempo data - hand-maintain
# inst/extdata/releases_songs_durations_wikipedia.csv,
# inst/extdata/releases.csv, and inst/extdata/song_tempo_bpm_data.csv
# directly against their sources (Wikipedia, rateyourmusic.com, personal BPM
# readings).

# B. Rebuild Repeatr's derived data ---------------------------------------
#
# Runs Repeatr_1() -> Repeatr_2() -> Repeatr_3() -> Repeatr_4() -> Repeatr_5()
# and saves every downstream dataset into data/ (othervariables, Repeatr0,
# Repeatr1, gid_sound_quality, played_with, shows_data, xray, fls_tags,
# fls_tags_show, songvarslookup, song_tempo_bpm_data, the choice-model
# outputs, and more). really = "not_really" is the default precisely so
# this doesn't run by accident - always pass really = "really" explicitly.
# min_song_count (default 2) excludes songs performed fewer times from the
# choice model (Repeatr_4) - they still get a songid/songidlookup entry and
# appear in Repeatr1 by name, they just don't get an `alt` and can't compete
# as a choice-model alternative.

Repeatr_Updatr(really = "really", update_stacks = TRUE)

# From here: commit the updated data/*.rda files, reinstall the package, and
# redeploy the Shiny app - see the "Reinstalling and redeploying" section of
# vignette("Rebuilding the Data").

# C. Export fugazi.db's data ------------------------------------------------
#
# Composes fugazi.db's six tables from Repeatr's own already-rebuilt
# data/*.rda objects (stage B must have run first) plus
# inst/extdata/fls_venue_geocoding_v2.csv directly, and writes them into a
# local fugazi.db checkout's data/*.rda.
# Writes files only - does not commit, push, or reinstall anything in that
# checkout; review and commit fugazi.db's own changes separately, on its own
# schedule. Nothing in Repeatr's own pipeline depends on fugazi.db being
# refreshed.

export_fugazidb_data(fugazidb_dir = "../fugazi.db")
