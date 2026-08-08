
#' @name export_fugazidb_data
#' @title Exports fugazi.db's data-raw/*.csv and data/*.rda objects from Repeatr's own cleaned data
#' @description Composes fugazi.db's nine published tables from Repeatr's own
#' already-saved `data/*.rda` objects (the "Derived-cleaned" tier produced by
#' \code{\link{Repeatr_1}}) and from `inst/extdata/fls_venue_geocoding_v2.csv`
#' directly - no re-derivation, no new business logic. Writes each table as
#' both a `data-raw/*.csv` (plain, human-readable) and a `data/*.rda`
#' (lazy-loadable) file directly into a local `fugazi.db` checkout. Does not
#' commit or push anything in that checkout - review and commit fugazi.db's
#' changes separately.
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
#' @return Invisibly, a named list of the nine objects written. As a side
#' effect, writes `fugazidb_dir/data-raw/*.csv` and `fugazidb_dir/data/*.rda`.
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

  raw_dir <- file.path(fugazidb_dir, "data-raw")
  out_dir <- file.path(fugazidb_dir, "data")

  load_obj <- function(name) {
    e <- new.env()
    load(file.path(mydatadir, paste0(name, ".rda")), envir = e)
    get(name, envir = e)
  }

  write_table <- function(df, name) {
    write.csv(df, file.path(raw_dir, paste0(name, ".csv")), row.names = FALSE)
    assign(name, df)
    save(list = name, file = file.path(out_dir, paste0(name, ".rda")), envir = environment())
    df
  }

  # fls_shows - one row per gid, corrections/coordinates/sound_quality/
  # duration already joined in by Repeatr_1(); fls_notes dropped (copyright).
  othervariables <- load_obj("othervariables")
  gid_sound_quality <- load_obj("gid_sound_quality")
  fls_tags_show <- load_obj("fls_tags_show")

  fls_shows <- othervariables %>%
    left_join(gid_sound_quality, by = "gid") %>%
    left_join(fls_tags_show %>% select(gid, seconds), by = "gid") %>%
    select(-fls_notes)

  write_table(fls_shows, "fls_shows")

  # fls_venue_geocoding - exact mirror of the hand-maintained Google Sheet
  # export, not the app's own coordinate corrections/fallbacks.
  fls_venue_geocoding <- read.csv(system.file("extdata", "fls_venue_geocoding_v2.csv", package = "Repeatr"), header = TRUE)
  write_table(fls_venue_geocoding, "fls_venue_geocoding")

  # fls_tags - already carries gid (joined in Repeatr_1()'s tag-processing
  # section) and the album-format/track-title corrections applied there.
  fls_tags <- load_obj("fls_tags") %>%
    select(gid, date, track, song, duration, seconds)
  write_table(fls_tags, "fls_tags")

  # releases - drop colour_code (UI-only, stays in Repeatr's
  # releaseid_variable_colour_code) and the four synthetic UI-bucket rows
  # (12-15: released/unreleased/songs/other) that aren't real releases.
  releases <- load_obj("releasesdatalookup") %>%
    filter(!releaseid %in% c(12, 13, 14, 15)) %>%
    select(releaseid, release, variable, releasedate, release_date_source, rym_rating)
  write_table(releases, "releases")

  # songvarslookup / song_tempo_bpm_data - pass through as-is.
  songvarslookup <- load_obj("songvarslookup")
  write_table(songvarslookup, "songvarslookup")

  song_tempo_bpm_data <- load_obj("song_tempo_bpm_data")
  write_table(song_tempo_bpm_data, "song_tempo_bpm_data")

  # songidlookup - pure songid <-> song title join-key infrastructure, no
  # tracktype/classification detail.
  songidlookup <- load_obj("songidlookup")
  write_table(songidlookup, "songidlookup")

  # played_with / played_with_data - one row per real show+co-billed act,
  # not an aggregate.
  played_with <- load_obj("played_with")
  write_table(played_with, "played_with")

  played_with_data <- load_obj("played_with_data")
  write_table(played_with_data, "played_with_data")

  invisible(list(
    fls_shows = fls_shows,
    fls_venue_geocoding = fls_venue_geocoding,
    fls_tags = fls_tags,
    releases = releases,
    songvarslookup = songvarslookup,
    song_tempo_bpm_data = song_tempo_bpm_data,
    songidlookup = songidlookup,
    played_with = played_with,
    played_with_data = played_with_data
  ))

}
