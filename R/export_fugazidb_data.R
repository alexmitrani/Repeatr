
#' @name export_fugazidb_data
#' @title Exports fugazi.db's data/*.rda objects from Repeatr's own cleaned data
#' @description Composes fugazi.db's six published tables from Repeatr's own
#' already-saved `data/*.rda` objects (the "Derived-cleaned" tier produced by
#' \code{\link{Repeatr_1}}) and from `inst/extdata/fls_venue_geocoding_v2.csv`
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

  # fls_shows - one row per gid; corrections/sound_quality already joined in
  # by Repeatr_1(); fls_notes dropped (copyright), year/checked (maintainer
  # workflow only), x/y (duplicated by fls_venue_geocoding) also dropped.
  othervariables <- load_obj("othervariables")
  gid_sound_quality <- load_obj("gid_sound_quality")

  fls_shows <- othervariables %>%
    left_join(gid_sound_quality, by = "gid") %>%
    select(-fls_notes, -year, -checked, -x, -y)

  fls_shows <- write_table(fls_shows, "fls_shows")

  # fls_venue_geocoding - exact mirror of the hand-maintained Google Sheet
  # export, minus its Google-Maps-lookup helper columns.
  fls_venue_geocoding <- read.csv(system.file("extdata", "fls_venue_geocoding_v2.csv", package = "Repeatr"), header = TRUE) %>%
    select(country, city, venue, y, x)
  fls_venue_geocoding <- write_table(fls_venue_geocoding, "fls_venue_geocoding")

  # fls_tags - already carries gid (joined in Repeatr_1()'s tag-processing
  # section); date dropped (join fls_shows on gid instead), seconds dropped
  # (duplicates duration), track normalized from character to integer.
  fls_tags <- load_obj("fls_tags") %>%
    select(gid, track, song, duration) %>%
    mutate(track = as.integer(track))
  fls_tags <- write_table(fls_tags, "fls_tags")

  # releases - drop colour_code (UI-only, stays in Repeatr's
  # releaseid_variable_colour_code), variable (snake_case UI name), and
  # rym_rating, plus the four synthetic UI-bucket rows (12-15:
  # released/unreleased/songs/other) that aren't real releases.
  releases <- load_obj("releasesdatalookup") %>%
    filter(!releaseid %in% c(12, 13, 14, 15)) %>%
    select(releaseid, release, releasedate, release_date_source)
  releases <- write_table(releases, "releases")

  # songs - Raw-hand-curated discography metadata, as-is. songidlookup isn't
  # joined in - its only columns (songid, count) are calculated/summary
  # values, excluded from fugazi.db by design.
  songs <- load_obj("songvarslookup")
  songs <- write_table(songs, "songs")

  # played_with - one row per real show+co-billed act.
  played_with <- load_obj("played_with") %>% select(gid, played_with)
  played_with <- write_table(played_with, "played_with")

  invisible(list(
    fls_shows = fls_shows,
    fls_venue_geocoding = fls_venue_geocoding,
    fls_tags = fls_tags,
    releases = releases,
    songs = songs,
    played_with = played_with
  ))

}
