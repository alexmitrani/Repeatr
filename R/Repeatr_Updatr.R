
#' @name Repeatr_Updatr
#' @title Runs the whole analysis process to update the site and Fugazetteer web app from the input data files.
#' @description This can take a while which is why the parameter "really" is "not_really" by default.
#' @description To run the full update: Repeatr_Updatr(really = "really")
#'
#' @param really set to "really" to actually run the update; any other value (the default, "not_really") does nothing.
#' @param min_song_count passed through to \code{\link{Repeatr_2}}: minimum number of performances a song needs to compete as an alternative in the choice model. Default 2. Does not affect `songid`/`songidlookup`, which cover every classified song regardless of this threshold.
#' @param update_stacks if TRUE, the gid_initial_gid_sound_quality data will be refreshed by re-generating a set of stacks considering the full available set of relevant data.
#' @param myfls_data,mysongvarslookup,myreleases,myfls_venue_geocoding,myfls_tags optional data frame overrides passed straight through to \code{\link{Repeatr_1}}. If omitted, \code{Repeatr_1} uses this package's own `inst/extdata/` sources - see its documentation for each.
#' @param input_dir passed through to \code{\link{Repeatr_2}}/\code{\link{Repeatr_5}}: where to write their output-export CSVs. If omitted, defaults to this package's own `inst/extdata`.
#' @param output_dir passed through to every stage: where to save the rebuilt `data/*.rda` objects. If omitted, defaults to `data/` under the current working directory.
#'
#' @return Invisibly, the list of results from the final `Repeatr_5()` call when `really = "really"`; `NULL` otherwise. The real effect is refreshing all of the package's `data/*.rda` objects in place, ready to be reinstalled.
#' @export
#'
#' @examples
#' Repeatr_Updatr(really = "not_really")
#'
Repeatr_Updatr <- function(really = "not_really", min_song_count = 2, update_stacks = FALSE,
                            myfls_data = NULL, mysongvarslookup = NULL, myreleases = NULL,
                            myfls_venue_geocoding = NULL, myfls_tags = NULL,
                            input_dir = NULL, output_dir = NULL) {

  if (really == "really") {

    Repeatr_1_results <- Repeatr_1(myfls_data = myfls_data, mysongvarslookup = mysongvarslookup,
                                    myreleases = myreleases, myfls_venue_geocoding = myfls_venue_geocoding,
                                    myfls_tags = myfls_tags, output_dir = output_dir)

    # Thread each stage's own return value into the next explicitly, rather
    # than relying on bare object names (which previously resolved to
    # whichever value of that name the package's lazy-loaded data had
    # bound *before* this function ran - stale as soon as an earlier stage
    # in this same call actually changes that data, since save()ing a new
    # .rda mid-session doesn't retroactively update an already-established
    # lazy binding).

    Repeatr_2_results <- Repeatr_2(mydf = Repeatr_1_results[[2]], mysongidlookup = Repeatr_1_results[[3]],
                                    min_song_count = min_song_count, input_dir = input_dir, output_dir = output_dir)

    Repeatr2 <- Repeatr_2_results[[1]]
    altlookup <- Repeatr_2_results[[2]]
    fugazi_song_performance_intensity <- Repeatr_2_results[[3]]

    Repeatr3 <- Repeatr_3(mydf = Repeatr2, output_dir = output_dir)

    ml_Repeatr4 <- Repeatr_4(mydf = Repeatr3, output_dir = output_dir)

    Repeatr_5_results <- Repeatr_5(mymodeldf = ml_Repeatr4,
                                    mysongidlookup = Repeatr_1_results[[3]],
                                    myaltlookup = altlookup,
                                    myfugazi_song_performance_intensity = fugazi_song_performance_intensity,
                                    mysongvarslookup = Repeatr_1_results[[5]],
                                    myreleasesdatalookup = Repeatr_1_results[[6]],
                                    myreleases_data_input = Repeatr_1_results[[12]],
                                    input_dir = input_dir, output_dir = output_dir)

    if(update_stacks == TRUE){

      # gid_sound_quality/duration_data_da/othervariables aren't available
      # fresh via Repeatr_1_results here the way songidlookup etc. are -
      # gid_sound_quality and duration_data_da are disk-only outputs of
      # Repeatr_1() (never part of its return list), and Repeatr_1_results[[7]]
      # (othervariables) is the dirtied post-join copy, not the clean one
      # stacks() expects. Repeatr_1() unconditionally just wrote fresh, clean
      # copies of all three to data/ earlier in this exact run - load() them
      # back rather than falling through to a stale lazy binding.
      mydatadir <- if (is.null(output_dir)) paste0(getwd(), "/data") else output_dir
      load(file.path(mydatadir, "gid_sound_quality.rda"))
      load(file.path(mydatadir, "duration_data_da.rda"))
      load(file.path(mydatadir, "othervariables.rda"))

      Repeatr_6(myduration_data_da = duration_data_da,
                mysummary = Repeatr_5_results[[3]],
                myothervariables = othervariables,
                mygidsoundquality = gid_sound_quality,
                output_dir = output_dir)

    }

  }

}
