# Regression tests for the songid/alt identity-vs-eligibility fix.
#
# These check the package's lazy-loaded data/*.rda objects as currently
# installed, not a live pipeline run - they're meant to catch exactly the
# kind of drift that made releases_songs_durations_wikipedia.csv go stale
# in the first place (see vignette("Data Provenance")), not to re-verify
# the whole scrape/model pipeline.

test_that("songid in songidlookup is dense 1:n over every classified song", {
  expect_equal(sort(songidlookup$songid), seq_len(nrow(songidlookup)))
})

test_that("every song in songidlookup has a matching row in songvarslookup", {
  # Every tracktype==1 song (i.e. everything in songidlookup) should have
  # Wikipedia metadata - a gap here means a song is missing release/
  # duration/vocalist data downstream.
  missing_from_songvarslookup <- dplyr::anti_join(songidlookup, songvarslookup, by = "song")

  expect_equal(nrow(missing_from_songvarslookup), 0,
               info = paste("song(s) with no match in songvarslookup:",
                             paste(missing_from_songvarslookup$song, collapse = ", ")))
})

test_that("every song in songvarslookup matches some classified song, of any tracktype", {
  # Not the mirror image of the test above: songvarslookup can legitimately
  # describe a tracktype 0/2 song (e.g. a catalogued-but-unreleased rarity)
  # that never appears in songidlookup - that's expected, not drift - so
  # this checks against every classified song in Repeatr1, not just
  # songidlookup's tracktype==1 subset. See the matching comment in
  # R/Repeatr_1.R's reconciliation check.
  all_classified_songs <- dplyr::distinct(Repeatr1, song)
  missing_from_classified_songs <- dplyr::anti_join(songvarslookup, all_classified_songs, by = "song")

  expect_equal(nrow(missing_from_classified_songs), 0,
               info = paste("song(s) in songvarslookup with no match anywhere in the live classified data:",
                             paste(missing_from_classified_songs$song, collapse = ", ")))
})

test_that("alt in Repeatr2 is dense 1:n over the min_song_count-eligible songs", {
  expect_equal(sort(unique(Repeatr2$alt)), seq_len(dplyr::n_distinct(Repeatr2$alt)))
})

test_that("alt in Repeatr3 is dense 1:n over the min_song_count-eligible songs", {
  expect_equal(sort(unique(Repeatr3$alt)), seq_len(dplyr::n_distinct(Repeatr3$alt)))
})

test_that("results_ml_Repeatr4's intercept rows match the eligible song count minus the omitted reference", {
  n_intercepts <- sum(grepl("(Intercept)", rownames(results_ml_Repeatr4), fixed = TRUE))
  n_eligible_songs <- dplyr::n_distinct(Repeatr2$alt)

  expect_equal(n_intercepts, n_eligible_songs - 1)
})

test_that("vcovmat_ml_Repeatr4 matches results_ml_Repeatr4's dimensions (not a stale leftover fit)", {
  expect_equal(nrow(vcovmat_ml_Repeatr4), nrow(results_ml_Repeatr4))
  expect_equal(ncol(vcovmat_ml_Repeatr4), nrow(results_ml_Repeatr4))
})
