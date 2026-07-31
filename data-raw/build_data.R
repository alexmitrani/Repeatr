# Master recipe for rebuilding every dataset in data/ from source.
#
# This is the canonical, runnable version of the process described in
# vignette("Updating the Data") - read that first for the why behind each
# step. This script itself is not run automatically (data-raw/ is excluded
# from the built package via .Rbuildignore); run the sections you need by
# hand, in order, whenever source data changes.
#
# The three data sources are updated on independent schedules - you don't
# need to run every section every time, just whichever source has new
# material, followed by the final Repeatr_Updatr() rebuild.

library(Repeatr)

# 1. Show data --------------------------------------------------------------
#
# Refreshes inst/extdata/fls_data.csv from the live Fugazi Live Series
# listing: new shows, plus any existing show whose recording has newly gone
# from unavailable to available. Incremental by default (update_existing =
# TRUE here forces a full pass over every discovered show instead of only
# new ones - see ?scrape_fls_shows for the cheaper incremental default).
# Long-running (tens of minutes) and makes many requests to dischord.com, so
# run deliberately, not as part of routine package development.

fls_data <- scrape_fls_shows(
  update_existing = TRUE,
  sleepseconds = 2,
  mycsvfilename = "inst/extdata/fls_data.csv"
)

# 2. Venue coordinates -------------------------------------------------------
#
# nscmov() applies whatever coordinates are already confirmed in
# inst/extdata/fls_venue_geocoding.csv, saves an updated othervariables.rda,
# and writes fls_venue_geocoding_update.csv - a to-do list of every venue
# still unresolved (checked == 0). For each row: look the venue up on Google
# Maps, fill in googlemaps_hyperlink/link_x/link_y (and
# city_disambiguation/guess/unknown where relevant), then merge those rows
# back into inst/extdata/fls_venue_geocoding.csv by hand. Re-run nscmov() to
# confirm the new venues are picked up (checked should flip to 1).

othervariables <- nscmov()

# 3. Tags/duration data -------------------------------------------------------
#
# No R code here - inst/extdata/fls_tags.txt is exported directly from kid3
# (https://kid3.kde.org/) against the personally-tagged MP3 collection, in
# the "track; artist; album; name; duration" format fls_tags_importer()
# expects. Tag any new MP3s, re-export, and overwrite
# inst/extdata/fls_tags.txt - Repeatr_Updatr() (step 4) picks it up
# automatically via fls_tags_importer(). If a new show's album string
# doesn't parse cleanly, the hand-written corrections for specific
# albums/venues live in the "process tags data" section of R/Repeatr_1.R.

# 4. Rebuild everything -------------------------------------------------------
#
# Runs Repeatr_1() -> Repeatr_2() -> Repeatr_3() -> Repeatr_4() -> Repeatr_5()
# and saves every downstream dataset into data/ (othervariables, Repeatr0,
# Repeatr1, gid_sound_quality, played_with, shows_data, xray, fls_tags,
# fls_tags_show, the choice-model outputs, and more). Picks up whatever was
# updated in steps 1-3 above. really = "not_really" is the default precisely
# so this doesn't run by accident - always pass really = "really" explicitly.
# min_song_count (default 2) excludes songs performed fewer times from the
# choice model (Repeatr_4) - they still get a songid/songidlookup entry
# and appear in Repeatr1 by name, they just don't get an `alt` and can't
# compete as a choice-model alternative.

Repeatr_Updatr(really = "really", update_stacks = TRUE)

# From here: commit the updated inst/extdata/* source files and data/*.rda
# files, reinstall the package, and redeploy the Shiny app - see the
# "Reinstalling and redeploying" section of vignette("Updating the Data").
