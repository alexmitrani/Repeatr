
#' @name export_fugazidb_data
#' @title Exports fugazi.db's data/*.rda objects from Repeatr's own cleaned data
#' @description Composes fugazi.db's six published tables (`shows`,
#' `locations`, `durations`, `discography`, `songs`, `bands`) from Repeatr's
#' own already-saved `data/*.rda` objects (the "Derived-cleaned" tier
#' produced by \code{\link{Repeatr_1}}) and from
#' `inst/extdata/fls_venue_geocoding_v2.csv`/`fls_doorprice_currency_lookup.csv`
#' directly - no re-derivation, no new business logic. Writes each table as a
#' `data/*.rda` (lazy-loadable) file directly into a local `fugazi.db`
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

  # shows (was fls_shows) - one row per gid; corrections/sound_quality
  # already joined in by Repeatr_1(); fls_notes dropped (copyright),
  # year/checked (maintainer workflow only), x/y (duplicated by locations)
  # also dropped. doorprice is raw scraped text (currency symbols, foreign-
  # currency abbreviations, one price range, "Free", ~33% missing) - split
  # into a numeric price + ISO 4217 currency via a hand-built lookup of its
  # ~58 distinct raw values (fls_doorprice_currency_lookup.csv), since
  # currency isn't otherwise recorded and several countries' shows predate
  # that country's euro adoption. "Free" isn't in the lookup (same text,
  # different currency depending on the show's own country) - handled by the
  # mutate() below instead.
  othervariables <- load_obj("othervariables")
  gid_sound_quality <- load_obj("gid_sound_quality")
  doorprice_lookup <- read.csv(system.file("extdata", "fls_doorprice_currency_lookup.csv", package = "Repeatr"), header = TRUE, colClasses = c(doorprice = "character", price = "numeric", currency = "character", note = "character"))

  shows <- othervariables %>%
    left_join(gid_sound_quality, by = "gid") %>%
    left_join(doorprice_lookup, by = "doorprice") %>%
    mutate(
      price = ifelse(doorprice == "Free", 0, price),
      currency = case_when(
        doorprice == "Free" & country == "Italy" ~ "ITL",
        doorprice == "Free" ~ "USD",
        TRUE ~ currency
      )
    ) %>%
    select(gid, flsid, date, venue, price, currency, attendance, recorded_by,
           mastered_by, original_source, tour, city, subdivision, country, sound_quality)

  shows <- write_table(shows, "shows")

  # locations (was fls_venue_geocoding) - exact mirror of the hand-maintained
  # Google Sheet export, minus its Google-Maps-lookup helper columns; y/x
  # renamed latitude/longitude for clarity.
  locations <- read.csv(system.file("extdata", "fls_venue_geocoding_v2.csv", package = "Repeatr"), header = TRUE) %>%
    select(country, city, venue, latitude = y, longitude = x)
  locations <- write_table(locations, "locations")

  # durations (was fls_tags) - already carries gid (joined in Repeatr_1()'s
  # tag-processing section); date dropped (join shows on gid instead),
  # seconds dropped (duplicates duration), track normalized from character
  # to integer.
  durations <- load_obj("fls_tags") %>%
    select(gid, track, song, duration) %>%
    mutate(track = as.integer(track))
  durations <- write_table(durations, "durations")

  # discography (was releases) - drop colour_code (UI-only, stays in
  # Repeatr's releaseid_variable_colour_code), variable (snake_case UI
  # name), and rym_rating, plus the four synthetic UI-bucket rows (12-15:
  # released/unreleased/songs/other) that aren't real releases. Table
  # renamed from "releases" to "discography" so the name matches what it
  # actually holds now that the old "discography" (song-level) table is
  # renamed "songs" below.
  discography <- load_obj("releasesdatalookup") %>%
    filter(!releaseid %in% c(12, 13, 14, 15)) %>%
    select(releaseid, release, releasedate, release_date_source)
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
  songs <- write_table(songs, "songs")

  # bands (was played_with) - one row per real show+co-billed act;
  # played_with column renamed band now that the table itself is bands.
  bands <- load_obj("played_with") %>% select(gid, band = played_with)
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
