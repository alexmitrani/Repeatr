
#' @name export_fugazidb_data
#' @title Exports fugazi.db's data/*.rda objects from Repeatr's own cleaned data
#' @description Composes fugazi.db's six published tables (`shows`,
#' `locations`, `durations`, `discography`, `songs`, `bands`) from Repeatr's
#' own already-saved `data/*.rda` objects (the "Derived-cleaned" tier
#' produced by \code{\link{Repeatr_1}}, which already includes the
#' `price`/`currency` split and the Brazilian/`NA`-standardized `subdivision`
#' values) and from `inst/extdata/fls_venue_geocoding_v2.csv` directly - no
#' re-derivation or new business logic, just selecting, renaming, and
#' joining columns Repeatr itself already computed. Also runs basic
#' integrity checks (no missing/duplicate id columns) on each table just
#' before it's written, aborting the export if any fail. Writes each table
#' as a `data/*.rda` (lazy-loadable) file directly into a local `fugazi.db`
#' checkout. Does not commit or push anything in that checkout - review and
#' commit fugazi.db's changes separately.
#'
#' Excludes anything joined/summarized/modeled (e.g. `xray`,
#' `duration_summary`, `Repeatr1`, and everything from \code{\link{Repeatr_2}}
#' onward) and the copyrighted free-text show notes (`fls_notes`, scraped
#' from the Fugazi Live Series site - see fugazi.db's own `LICENSE`) - see
#' `vignette("Data-Provenance")` for the full tier catalogue.
#'
#' @import dplyr
#'
#' @param fugazidb_dir Path to a local `fugazi.db` checkout. Required - there
#' is no default, so a caller's own local path is never hardcoded here.
#' @param repeatr_data_dir Optional directory to read Repeatr's own already-
#' saved `data/*.rda` objects from. If omitted, defaults to `data/` under the
#' current working directory (the package root, after a
#' \code{\link{Repeatr_Updatr}} run).
#'
#' @return Invisibly, a named list of the six objects written. As a side
#' effect, writes `fugazidb_dir/data/*.rda`.
#' @export
#'
#' @examples
#' \dontrun{
#' export_fugazidb_data(fugazidb_dir = "../fugazi.db")
#' }
#'
export_fugazidb_data <- function(fugazidb_dir, repeatr_data_dir = NULL) {

  mydir <- getwd()
  mydatadir <- if (is.null(repeatr_data_dir)) file.path(mydir, "data") else repeatr_data_dir

  out_dir <- file.path(fugazidb_dir, "data")

  load_obj <- function(name) {
    e <- new.env()
    load(file.path(mydatadir, paste0(name, ".rda")), envir = e)
    get(name, envir = e)
  }

  write_table <- function(df, name) {
    df <- dplyr::as_tibble(df) %>% dplyr::ungroup()
    assign(name, df)
    save(list = name, file = file.path(out_dir, paste0(name, ".rda")), envir = environment())
    df
  }

  check_no_na <- function(df, col, table_name) {
    if (anyNA(df[[col]])) stop(sprintf("%s$%s has missing values", table_name, col), call. = FALSE)
  }

  check_unique <- function(df, cols, table_name) {
    key <- if (length(cols) == 1) df[[cols]] else do.call(paste, df[cols])
    if (anyDuplicated(key) > 0) stop(sprintf("%s has duplicate %s", table_name, paste(cols, collapse = "+")), call. = FALSE)
  }

  # shows (was fls_shows) - one row per gid; corrections/sound_quality,
  # price/currency (split from raw doorprice text), and Brazilian/
  # NA-standardized subdivision are already computed by Repeatr_1() on
  # othervariables - this just selects/renames/joins, no re-derivation.
  # fls_notes dropped (copyright), year/checked (maintainer workflow only),
  # x/y (duplicated by locations) also dropped.
  othervariables <- load_obj("othervariables")
  gid_sound_quality <- load_obj("gid_sound_quality")

  shows <- othervariables %>%
    left_join(gid_sound_quality, by = "gid") %>%
    select(gid, flsid, date, venue, price, currency, attendance, recorded_by,
           mastered_by, original_source, tour, city, subdivision, country, sound_quality)

  check_no_na(shows, "gid", "shows")
  check_unique(shows, "gid", "shows")
  shows <- write_table(shows, "shows")

  # locations (was fls_venue_geocoding) - mirror of the hand-maintained
  # Google Sheet export, minus its Google-Maps-lookup helper columns; y/x
  # renamed latitude/longitude for clarity. The raw sheet suffixes a
  # handful of cities that share a name with another tour stop (Portland,
  # Columbia, Croydon, Newcastle, Oxford, Springfield) as "City (ST)"/
  # "City (Country)", purely so it can be joined by city text - the same
  # trick Repeatr_1() uses internally, temporarily, for the same reason.
  # shows$city (via othervariables) is always the plain city name, so left
  # in place that suffix silently broke the shows/locations join for these
  # venues. Stripped back off here, same as Repeatr_1() already does for
  # othervariables/shows - country/venue (not city alone) are what actually
  # keep these rows unique.
  locations <- read.csv(system.file("extdata", "fls_venue_geocoding_v2.csv", package = "Repeatr"), header = TRUE) %>%
    mutate(city = trimws(gsub("\\s*\\([^)]*\\)$", "", city))) %>%
    select(country, city, venue, latitude = y, longitude = x)
  locations <- write_table(locations, "locations")

  # durations (was fls_tags) - already carries gid (joined in Repeatr_1()'s
  # tag-processing section); date dropped (join shows on gid instead),
  # seconds dropped (duplicates duration), track normalized from character
  # to integer.
  durations <- load_obj("fls_tags") %>%
    select(gid, track, song, duration) %>%
    mutate(track = as.integer(track))
  check_no_na(durations, "gid", "durations")
  check_no_na(durations, "track", "durations")
  check_unique(durations, c("gid", "track"), "durations")
  durations <- write_table(durations, "durations")

  # discography (was releases) - drop colour_code (UI-only, stays in
  # Repeatr's releaseid_variable_colour_code), variable (snake_case UI
  # name), and rym_rating, plus the four synthetic UI-bucket rows (12-15:
  # released/unreleased/songs/other) that aren't real releases. Table
  # renamed from "releases" to "discography" so the name matches what it
  # actually holds now that the old "discography" (song-level) table is
  # renamed "songs" below. release_date_source also dropped - it's a
  # per-release citation, not a value analysts join on, so it's documented
  # in fugazi.db's own Roxygen docs instead of shipped as a column.
  discography <- load_obj("releasesdatalookup") %>%
    filter(!releaseid %in% c(12, 13, 14, 15)) %>%
    select(releaseid, release, releasedate)
  check_no_na(discography, "releaseid", "discography")
  check_unique(discography, "releaseid", "discography")
  discography <- write_table(discography, "discography")

  # songs (was discography) - Raw-hand-curated studio discography metadata.
  # songidlookup isn't joined in - its only columns (songid, count) are
  # calculated/summary values, excluded from fugazi.db by design.
  # track_number/duration_seconds renamed to release_track/release_duration
  # (this is the studio release's own track/duration, distinct from
  # durations's live-tagged track/duration); release_duration converted to a
  # Period to match durations$duration's format.
  songs <- load_obj("songvarslookup") %>%
    rename(release_track = track_number, release_duration = duration_seconds) %>%
    mutate(release_duration = seconds_to_period(release_duration))
  check_no_na(songs, "song", "songs")
  check_unique(songs, "song", "songs")
  songs <- write_table(songs, "songs")

  # bands (was played_with) - one row per real show+co-billed act;
  # played_with column renamed band now that the table itself is bands.
  bands <- load_obj("played_with") %>% select(gid, band = played_with)
  check_no_na(bands, "gid", "bands")
  bands <- write_table(bands, "bands")

  invisible(list(
    shows = shows,
    locations = locations,
    durations = durations,
    discography = discography,
    songs = songs,
    bands = bands
  ))

}
