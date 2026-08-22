#' @name build_shiny_precompute
#' @title Precompute Fugazetteer's build-time-only Shiny inputs
#' @description Builds and saves the handful of `data/*.rda` objects that
#'   exist purely so `inst/shiny/Fugazetteer/app.R` doesn't have to redo, on
#'   every app start, joins/aggregations that never touch the app's three
#'   live Google Sheets reads (`fls_venue_geocoding`, `quizdata`,
#'   `linktracksindexdata`). These are Shiny-presentation-only cached views,
#'   not part of Repeatr's canonical data model and not exported to
#'   fugazibase - see `vignette("Data-Provenance")` and the `Provenance`
#'   section on each object's own help page (e.g. `?shiny_shows_data_base`).
#'   Mirrors the exact joins `app.R` used to run inline; if `app.R`'s
#'   sheet-independent preprocessing ever changes, update both together.
#' @param output_dir where to save the rebuilt `data/*.rda` objects. If
#'   omitted, defaults to `data/` under the current working directory.
#' @return Invisibly, `NULL`. The real effect is writing the `shiny_*.rda`
#'   files.
#' @export
#'
#' @examples
#' \dontrun{
#' build_shiny_precompute()
#' }
build_shiny_precompute <- function(output_dir = NULL) {

  mydatadir <- if (is.null(output_dir)) file.path(getwd(), "data") else output_dir

  # mirrors app.R's year_tour_release ----------------------------------------
  shiny_year_tour_release <- Repeatr::Repeatr1 %>%
    select(.data$year, .data$gid, .data$release_title) %>%
    group_by(.data$year, .data$gid, .data$release_title) %>%
    filter(is.na(.data$release_title) == FALSE) %>%
    summarize(count = n()) %>%
    ungroup() %>%
    left_join(Repeatr::othervariables) %>%
    select(.data$year, .data$gid, .data$release_title, .data$tour, .data$count)

  # mirrors app.R's fls_link_year_tour ---------------------------------------
  shiny_fls_link_year_tour <- Repeatr::shows_data %>%
    select(.data$fls_link, .data$year, .data$tour)

  # mirrors app.R's transitions_data_da re-join ------------------------------
  shiny_transitions_data_da <- Repeatr::transitions_data_da %>%
    left_join(shiny_fls_link_year_tour)

  # mirrors app.R's duration_data_da re-join ---------------------------------
  song_release <- Repeatr::summary %>%
    select(.data$title, .data$release_title)

  shiny_duration_data_da <- Repeatr::duration_data_da %>%
    left_join(song_release)

  # mirrors app.R's othervariables pre-processing, up to (not including) the
  # live fls_venue_geocoding coordinate join/disambiguation - that part must
  # stay in app.R itself, at runtime -----------------------------------------
  shiny_othervariables_base <- Repeatr::othervariables %>%
    left_join(Repeatr::gid_sound_quality) %>%
    mutate(urls = paste0("https://www.dischord.com/fugazi_live_series/", .data$gid)) %>%
    mutate(fls_link = paste0("<a href='",  .data$urls, "' target='_blank'>", .data$gid, "</a>"))

  # mirrors app.R's year_tour_gid_song - only year/tour/gid/title survive the
  # final select, so this is safe to build from the raw (pre-live-join)
  # othervariables rather than the live-coordinate-joined copy app.R builds
  # at runtime; the join key (gid) and result are identical either way ------
  shiny_year_tour_gid_song <- Repeatr::duration_data_da %>%
    left_join(Repeatr::othervariables) %>%
    select(.data$year, .data$tour, .data$gid, .data$title)

  # mirrors app.R's tempo/discography chain (discography, releases_data_input,
  # releases_summary, and the gid_tempo_bpm used to enrich shows_data) - none
  # of this touches any live sheet. discography_tempo_bpm/shows_tempo_bpm
  # (single-row overall averages app.R used to also compute here) are dropped:
  # confirmed unused by any app.R output/reactive ----------------------------
  shiny_discography <- Repeatr::summary %>%
    select(.data$title, .data$release_title)

  song_duration_seconds <- Repeatr::songvarslookup %>%
    select(.data$title, .data$duration_seconds)

  shiny_releases_data_input <- Repeatr::releases_data_input %>%
    left_join(Repeatr::song_tempo_bpm_data) %>%
    left_join(song_duration_seconds) %>%
    arrange(desc(.data$rid), desc(.data$track_number)) %>%
    mutate(minutes = round(.data$duration_seconds/60, 3)) %>%
    mutate(title = factor(.data$title, levels = unique(.data$title)))

  release_tempo_bpm_minutes <- shiny_releases_data_input %>%
    mutate(tempo_bpm_minutes = .data$tempo_bpm*.data$minutes) %>%
    group_by(.data$release_title) %>%
    summarise(tempo_bpm_minutes = sum(.data$tempo_bpm_minutes),
              minutes = sum(.data$minutes)) %>%
    ungroup() %>%
    mutate(tempo_bpm = round(.data$tempo_bpm_minutes/.data$minutes, 3)) %>%
    mutate(release_title = as.character(.data$release_title)) %>%
    mutate(minutes = round(.data$minutes, 3)) %>%
    select(.data$release_title, .data$tempo_bpm, .data$minutes)

  shiny_releases_summary <- Repeatr::releases_summary %>%
    left_join(release_tempo_bpm_minutes)

  gid_tempo_bpm_minutes <- shiny_duration_data_da %>%
    left_join(Repeatr::song_tempo_bpm_data) %>%
    mutate(tempo_bpm_minutes = .data$tempo_bpm*.data$minutes) %>%
    filter(is.na(.data$minutes) == FALSE) %>%
    group_by(.data$gid) %>%
    summarise(tempo_bpm_minutes = sum(.data$tempo_bpm_minutes),
              minutes = sum(.data$minutes)) %>%
    ungroup() %>%
    mutate(tempo_bpm = round(.data$tempo_bpm_minutes/.data$minutes, 3)) %>%
    select(.data$gid, .data$tempo_bpm, .data$minutes)

  gid_tempo_bpm <- gid_tempo_bpm_minutes %>%
    select(.data$gid, .data$tempo_bpm)

  # mirrors app.R's shows_data <- Repeatr::shows_data %>% left_join(gid_tempo_bpm),
  # i.e. shows_data with tempo added but *before* the live geocoding join,
  # disambiguation, and gid-uniqueness safety net - those stay in app.R -----
  shiny_shows_data_base <- Repeatr::shows_data %>%
    left_join(gid_tempo_bpm)

  save(shiny_year_tour_release, file = file.path(mydatadir, "shiny_year_tour_release.rda"))
  save(shiny_fls_link_year_tour, file = file.path(mydatadir, "shiny_fls_link_year_tour.rda"))
  save(shiny_transitions_data_da, file = file.path(mydatadir, "shiny_transitions_data_da.rda"))
  save(shiny_duration_data_da, file = file.path(mydatadir, "shiny_duration_data_da.rda"))
  save(shiny_othervariables_base, file = file.path(mydatadir, "shiny_othervariables_base.rda"))
  save(shiny_year_tour_gid_song, file = file.path(mydatadir, "shiny_year_tour_gid_song.rda"))
  save(shiny_discography, file = file.path(mydatadir, "shiny_discography.rda"))
  save(shiny_releases_data_input, file = file.path(mydatadir, "shiny_releases_data_input.rda"))
  save(shiny_releases_summary, file = file.path(mydatadir, "shiny_releases_summary.rda"))
  save(shiny_shows_data_base, file = file.path(mydatadir, "shiny_shows_data_base.rda"))

  invisible(NULL)
}
