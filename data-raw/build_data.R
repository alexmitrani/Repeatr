# Master recipe for rebuilding every dataset in data/ from source.
#
# This is the canonical, runnable version of the process described in
# vignette("Rebuilding the Data") - read that first for the why behind each
# step. This script itself is not run automatically (data-raw/ is excluded
# from the built package via .Rbuildignore); run the sections you need by
# hand, in order, whenever source data changes.
#
# Primary data (raw sources) now lives in the companion package fugazi.db,
# not in this package's own inst/extdata - see vignette("Data-Catalogue",
# package = "fugazi.db") for what each object is and its refresh process.
# This script has three stages instead of the old single rebuild call:
#
#   A. Refresh fugazi.db's data-raw/ sources (scraping/hand-curation)
#   B. Convert fugazi.db's data-raw/ into its data/*.rda objects, then
#      commit/push fugazi.db and reinstall it
#   C. Rebuild Repeatr's own derived data/*.rda from the reinstalled
#      fugazi.db
#
# None of stage A's five sources need to be refreshed together - run
# whichever one has new material, then B and C.

library(Repeatr)

fugazidb_dir <- "../fugazi.db"   # sibling checkout, adjust as needed

# A. Refresh fugazi.db's raw sources ------------------------------------
#
# A1. Show data - refreshes fugazi.db/data-raw/fls_data.csv from the live
# Fugazi Live Series listing: new shows, plus any existing show whose
# recording has newly gone from unavailable to available. Incremental by
# default (update_existing = TRUE here forces a full pass over every
# discovered show instead of only new ones - see ?scrape_fls_shows for the
# cheaper incremental default). Long-running (tens of minutes) and makes
# many requests to dischord.com, so run deliberately, not as part of
# routine package development.

fls_data <- scrape_fls_shows(
  update_existing = TRUE,
  sleepseconds = 2,
  mycsvfilename = file.path(fugazidb_dir, "data-raw", "fls_data.csv")
)

# A2. Venue coordinates - overwrite fugazi.db/data-raw/fls_venue_geocoding.csv
# directly from the current export of the private Google Sheet used to look
# up/confirm venue locations on Google Maps. There is no separate
# to-do-list/fallback-file workflow any more (nscmov()/fugazi-small.csv are
# retired) - the sheet export is the single source of truth for coordinates.

# A3. Tags/duration data - no R code here - fugazi.db/data-raw/fls_tags.txt
# is exported directly from kid3 (https://kid3.kde.org/) against the
# personally-tagged MP3 collection, in the "track; artist; album; name;
# duration" format fls_tags_importer() expects. Tag any new MP3s, re-export,
# and overwrite fugazi.db/data-raw/fls_tags.txt. If a new show's album
# string doesn't parse cleanly, the hand-written corrections for specific
# albums/venues live in the "process tags data" section of R/Repeatr_1.R.

# A4. Song/release/duration and tempo data - hand-maintain
# fugazi.db/data-raw/releases_songs_durations_wikipedia.csv,
# fugazi.db/data-raw/releases.csv, and fugazi.db/data-raw/song_tempo_bpm_data.csv
# directly against their sources (Wikipedia, rateyourmusic.com, personal BPM
# readings) - see vignette("Data-Catalogue", package = "fugazi.db").

# B. Build fugazi.db's data/*.rda, then commit/push/reinstall ------------

build_fugazidb_data(fugazidb_dir = fugazidb_dir)

# From here: commit and push fugazi.db's updated data-raw/*.csv|txt and
# data/*.rda, then reinstall it so Repeatr_1()'s defaults (which resolve
# against the *installed* fugazi.db, not this source checkout) pick up the
# refresh:
# devtools::install_github("alexmitrani/fugazi.db")
#
# For quick local iteration without a reinstall, load fugazi.db's rebuilt
# objects directly and pass them into Repeatr_1()/Repeatr_Updatr() as
# explicit overrides instead (e.g. myfls_data = ..., see their docs).

# C. Rebuild Repeatr's derived data ---------------------------------------
#
# Runs Repeatr_1() -> Repeatr_2() -> Repeatr_3() -> Repeatr_4() -> Repeatr_5()
# and saves every downstream dataset into data/ (othervariables, Repeatr0,
# Repeatr1, gid_sound_quality, played_with, shows_data, xray, fls_tags,
# fls_tags_show, the choice-model outputs, and more). really = "not_really"
# is the default precisely so this doesn't run by accident - always pass
# really = "really" explicitly. min_song_count (default 2) excludes songs
# performed fewer times from the choice model (Repeatr_4) - they still get
# a songid/songidlookup entry and appear in Repeatr1 by name, they just
# don't get an `alt` and can't compete as a choice-model alternative.

Repeatr_Updatr(really = "really", update_stacks = TRUE)

# From here: commit the updated data/*.rda files, reinstall the package, and
# redeploy the Shiny app - see the "Reinstalling and redeploying" section of
# vignette("Rebuilding the Data").
