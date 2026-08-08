
#' @name build_fugazidb_data
#' @title Builds fugazi.db's data/*.rda objects from its data-raw/ sources
#' @description Reads the six plain, human-editable source files in a local
#' `fugazi.db` checkout's `data-raw/` (`fls_data.csv`, `fls_tags.txt`,
#' `releases.csv`, `releases_songs_durations_wikipedia.csv`,
#' `song_tempo_bpm_data.csv`, `fls_venue_geocoding.csv`) and writes the
#' corresponding lazy-loadable `.rda` objects into `data/` - the ongoing,
#' repeatable counterpart to the one-time bake-ins that removed
#' `othervariables_patch.csv`/`venue_name_corrections.csv`/`fls_tags_name_recoded.csv`.
#' Run this (from Repeatr, since `fugazi.db` itself contains no code) whenever
#' any of `fugazi.db`'s `data-raw/` sources change - a fresh scrape, a synced
#' geocoding sheet, a new tempo reading, a re-exported tag file - before
#' committing `fugazi.db` and reinstalling it for \code{\link{Repeatr_Updatr}}
#' to pick up.
#'
#' @import readr
#' @import lubridate
#' @import dplyr
#'
#' @param fugazidb_dir path to a local `fugazi.db` checkout.
#'
#' @return Invisibly, a named list of the six objects built. As a side
#' effect, writes `fugazidb_dir/data/*.rda`.
#' @export
#'
#' @examples
#' \dontrun{
#' build_fugazidb_data(fugazidb_dir = "../fugazi.db")
#' }
#'
build_fugazidb_data <- function(fugazidb_dir) {

  raw_dir <- file.path(fugazidb_dir, "data-raw")
  out_dir <- file.path(fugazidb_dir, "data")

  fls_data <- read.csv(file.path(raw_dir, "fls_data.csv"), header = TRUE)
  save(fls_data, file = file.path(out_dir, "fls_data.rda"))

  fls_tags_raw <- fls_tags_importer(myfilename = file.path(raw_dir, "fls_tags.txt"))
  save(fls_tags_raw, file = file.path(out_dir, "fls_tags_raw.rda"))

  songvarslookup <- read.csv(file.path(raw_dir, "releases_songs_durations_wikipedia.csv"), header = TRUE)
  save(songvarslookup, file = file.path(out_dir, "songvarslookup.rda"))

  releases <- read.csv(file.path(raw_dir, "releases.csv"), header = TRUE)
  save(releases, file = file.path(out_dir, "releases.rda"))

  song_tempo_bpm_data <- read.csv(file.path(raw_dir, "song_tempo_bpm_data.csv"), header = TRUE)
  save(song_tempo_bpm_data, file = file.path(out_dir, "song_tempo_bpm_data.rda"))

  fls_venue_geocoding <- read.csv(file.path(raw_dir, "fls_venue_geocoding.csv"), header = TRUE)
  save(fls_venue_geocoding, file = file.path(out_dir, "fls_venue_geocoding.rda"))

  invisible(list(
    fls_data = fls_data,
    fls_tags_raw = fls_tags_raw,
    songvarslookup = songvarslookup,
    releases = releases,
    song_tempo_bpm_data = song_tempo_bpm_data,
    fls_venue_geocoding = fls_venue_geocoding
  ))

}
