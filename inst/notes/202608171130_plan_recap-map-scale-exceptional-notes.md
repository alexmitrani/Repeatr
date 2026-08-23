# Recap map fix (#250) + exceptional-notes paragraph (#251)

## Context

Continuing the "recap" issue cluster. #250: the recap tab's map marker grows
unfeasibly large when zoomed in, unlike the other maps in the app, and its
default zoom should show a ~100m scale instead of ~1km. #251: add a "notes"
paragraph below the recap tracklist flagging exceptional/noteworthy facts
about the show (rare tracks, out-of-position songs, record-setting rendition
durations, etc.), and remove the now-redundant `mins_max` tracklist column
since its purpose is covered by the new prose. The user commented on both
GitHub issues with detailed specs and concrete test cases, all verified
against the real data during planning (see below).

## 1. Issue #250 — map marker scale

**Root cause (confirmed via code, and clarified by the user):** `recap_map`
(`inst/shiny/Fugazetteer/app.R:3375-3403`) uses a *hardcoded fixed*
`addCircles(radius = 200, ...)` — 200 real-world meters regardless of the
show. `flow|shows`' map (`app.R:1802-1815`) uses the same `addCircles`
mechanism but scales its radius to each show's attendance
(`radius = sqrt(df$attendance/pi)`, typically ~5-30m for real attendance
figures) with `fillOpacity = 0.5`. Recap's flat 200m is roughly 10-40x
larger than what the other maps ever actually draw, which is why it reads
as "unfeasibly large" — not because of a fundamentally different
pixels-vs-meters rendering approach (both already use `addCircles`/meters),
but simply because recap never scaled its radius down like the other maps
do. The exact same map is duplicated in
`inst/shiny/Fugazetteer/recap_template.Rmd:45-65` (the downloadable
document) — both need the same fix to stay consistent.

Verified the "1km" scale-bar claim mathematically: Leaflet's scale bar
reflects `156543 * cos(latitude) / 2^zoom` meters/pixel; at zoom 13 and a
typical show latitude (~45°N), that works out to ≈1.35km over the bar's
default 100px width — matching the issue's own description of the current
default exactly. To reach a ~100m default reading, the map needs to be
roughly 2^3.3 ≈ 10x closer, i.e. **zoom ≈ 16**.

**Fix, in `app.R`'s `recap_map` (current lines 3375-3403):**

```r
  output$recap_map <- renderLeaflet({

    ctx <- recap_result()$context

    df <- data.frame(latitude = shows_data %>% filter(gid==ctx$gid) %>% pull(latitude),
                     longitude = shows_data %>% filter(gid==ctx$gid) %>% pull(longitude))

    marker_radius <- sqrt(ifelse(is.na(ctx$attendance), median(shows_data$attendance, na.rm = TRUE), ctx$attendance) / pi)

    leaflet(data = df, options = leafletOptions(zoomControl = FALSE)) %>%
      htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'bottomleft' }).addTo(this)
      }") %>%
      setView(lng = df$longitude, lat = df$latitude, zoom = 16) %>%
      addProviderTiles("OpenStreetMap.Mapnik") %>%
      addScaleBar() %>%
      addCircles(
        data = df,
        radius = marker_radius,
        color = "#c94040",
        fillColor = "#c94040",
        fillOpacity = 0.5,
        popup = paste0(
          "<strong>Date: </strong>", ctx$datestring, "<br>",
          "<strong>Venue: </strong>", ctx$venue, "<br>",
          "<strong>City: </strong>", ctx$city, "<br>",
          "<strong>Country: </strong>", ctx$country
        )
      )

  })
```

Only `radius`/`fillOpacity` (now matching `flow|shows` exactly) and
`zoom` (13→16) change; `color`/`fillColor` stay the existing fixed
`"#c94040"` since a recency palette has no meaning for a single point.

**Same fix in `recap_template.Rmd`'s map chunk (current lines 45-65)**,
adapted to that chunk's own `df` (which already has `attendance` directly,
being unfiltered `shows_data`, unlike `app.R`'s trimmed lat/long-only `df`):

```r
df <- shows_data %>% filter(gid == ctx$gid)
marker_radius <- sqrt(ifelse(is.na(df$attendance), median(shows_data$attendance, na.rm = TRUE), df$attendance) / pi)

leaflet(data = df, options = leafletOptions(zoomControl = FALSE)) %>%
  setView(lng = df$longitude, lat = df$latitude, zoom = 16) %>%
  addProviderTiles("OpenStreetMap.Mapnik") %>%
  addScaleBar() %>%
  addCircles(
    data = df,
    radius = marker_radius,
    color = "#c94040",
    fillColor = "#c94040",
    fillOpacity = 0.5,
    popup = paste0(
      "<strong>Date: </strong>", ctx$datestring, "<br>",
      "<strong>Venue: </strong>", ctx$venue, "<br>",
      "<strong>City: </strong>", ctx$city, "<br>",
      "<strong>Country: </strong>", ctx$country
    )
  )
```

**Verification:** since this is a client-side rendering behavior that can't
be checked via Rscript, actually launch the Shiny app and visually confirm
in the browser (not just reasoned about): the default view shows a ~100m
scale bar, and the marker is now a reasonable, attendance-scaled size
(comparable to what `flow|shows` draws for a similar-attendance show)
instead of a flat 200m. Adjust the zoom level if the visual doesn't match
expectations.

## 2. Issue #251 — exceptional-notes paragraph

### Table change

Remove `mins_max` from the tracklist's final `select()`
(`R/recap.R:469-471`) — its purpose (flagging a record-setting duration) is
now covered by the new prose note instead of a bare number in the table.
`mins_mean` stays.

### Architecture

A set of small note-generator functions (matching the file's existing style
— `format_ordinal`, `oxford_join`, `fix_caps`, `describe_other_show`), each
returning either `NA_character_` (nothing to say) or one complete sentence.
Collected into a vector, NAs dropped, and space-joined into a new
`paragraph3`, matching how `paragraph1`/`paragraph2` are already assembled.
Empty string (not shown) when nothing is noteworthy. This structure is what
"facilitates future revisions" per the issue — adding a new note type later
is one more small function plus one more line in the collection vector.

All notes require `has_recording` (they depend on tracklist/duration data),
so `paragraph3` is built inside the existing `if (has_recording)` block,
pre-initialized to `""` alongside the other has_recording-only variables
(`R/recap.R:377-383`).

**Titles are shown as-stored (lowercase, e.g. "brendan #1"), matching the
existing convention already used in the tracklist and elsewhere in
`recap()`** — no title-casing helper needed. Where a note *starts* a
sentence with a title, the first letter is capitalized using the same
one-off technique already used for `recording_detail_sentence`
(`toupper(substr(x,1,1))` + rest unchanged) — sentence-case, not title-case.

**Any note phrasing that cites a count (e.g. "one of only N shows with a
recorded soundcheck") computes that count dynamically from the data at
call-time, never hardcodes it** — matching the project's existing
"keep prose numbers from going stale" principle (issue #238) and this
session's own established pattern (e.g. `music_proportion`).

### Note types (each verified against the data during planning)

1. **Rare tracks.** Any track in this show (song or other-music content,
   i.e. `Repeatr1$tracktype %in% c(1,2)`) with fewer than 20 total
   occurrences across the whole series. Verified: a unified
   `Repeatr1 %>% filter(tracktype %in% c(1,2)) %>% count(title)` count
   cleanly separates the issue's five named examples (Polish=6, Hello
   Morning=2, World Beat=2, Ned Cars=1, Ice-Cream Eating Motherfucker=1)
   from the bulk of the catalog (next-lowest regular song is 21). Using the
   same `<20` threshold the issue specifies for note type 4's exception
   below, for consistency. Example: *"This show features a rarely
   performed track: polish."*

2. **Song performed out of its usual set position.** `abs(this_show's
   position - position_summary$position_mean) > 0.8`. Verified exactly
   against the issue's own test case: glueman (`position_mean`=0.95, i.e.
   normally a closer) has exactly 3 historical instances over this
   threshold, all at position 0 (opener) —
   `nagold-germany-110488`, `st-louis-mo-usa-60491`,
   `washington-dc-usa-72888`. Phrasing derives "usual"/"actual" set timing
   from the position values (≥0.7 "near the end of the set", ≤0.3 "near
   the start of the set", else "mid-set"). Example: *"Glueman, normally
   performed near the end of the set, was performed near the start of the
   set this time."*

3. **Song performed twice in the show.** `tracktype==1` rows for this gid
   with a duplicate title (`count(title) >= 2`) — same method already
   prototyped in `vignettes/Linktracks.Rmd`'s "Three Repeats, but Only One
   Two for Tuesdays" section (confirmed working, e.g. `annapolis-md-usa-20688`
   for "Break In", `richmond-va-usa-51198` for "Great Cop"). The one example
   from that vignette section this *can't* catch generically — the actual
   "Two for Tuesdays" gag itself, "Greed" at `birmingham-al-usa-52191`
   (1991) — has its two renditions merged into a single track in the source
   data, so it never appears as a duplicate title. Per the user's direction,
   this is added as a curated one-off note instead (note type 9 below),
   alongside "Outside the Gig!", rather than left undetected.

4. **Record-setting rendition duration.** For each song in this show, if
   its duration equals `duration_summary$minutes_max` (longest ever) or
   `minutes_min` (shortest ever) for that title — but only when that
   title's `duration_summary$renditions >= 20` (skip the note entirely
   below that, per the issue's explicit exception; note this is
   independent of note type 1's rare-track note, not a substitute for it).
   `duration_summary` already has `minutes_min` — confirmed at
   `R/Repeatr_1.R:1711-1720`, no pipeline change needed, just add it to the
   existing `duration_summary %>% select(...)` join at `R/recap.R:464`
   (already joined for `minutes_mean`/`minutes_max`/`renditions`). Verified
   exactly against both issue examples: longest "suggestion" is
   `chicago-il-usa-61490` at 13.9 min (matches `minutes_max` exactly);
   shortest "repeater" is `belo-horizonte-brazil-81697` at 0.27 min
   (matches `minutes_min` exactly). Only the *shortest* case gets the
   extra "may indicate the recording is incomplete" caveat, matching the
   issue's own framing (longest doesn't carry that implication). Example:
   *"This show includes the shortest rendition of repeater recorded
   anywhere in the Fugazi Live Series, which may indicate the recording is
   incomplete."*

5. **Record-setting full recording duration.** This show's `minutes`
   compared against the full range of `shows_data$minutes` restricted to
   shows with a recording (`semi_join` against `duration_data_da`).
   Verified: longest is `victoria-bc-canada-70601` (~124 min), shortest is
   `virginia-beach-va-usa-71688` (~10.0 min).

6. **Untracked-interlude duration caveat.** Reuses the exact condition
   already computed for `music_bracket` (`R/recap.R:482`, `round(music_minutes,
   2) >= round(minutes, 2)`) — when the bracket is *omitted* because no
   non-song content was tracked separately, add an explicit note instead
   of just silently dropping the parenthetical, per the issue's first
   example. Example: *"Interludes and other non-song content were not
   tracked separately for this recording, so song durations shown may be
   slightly over-estimated."*

7. **Soundcheck.** Generic detector (not hardcoded, despite there
   currently being exactly 3): this show has a `tracktype==0` track whose
   title matches `sound.?check` (case-insensitive) in `Repeatr1`. The
   "only N shows" count in the phrasing is computed dynamically (currently
   3, verified: `eindhoven-netherlands-90590`, `herne-bay-england-92090`,
   `stuttgart-germany-101390`) so it won't go stale as data changes.

8. **Exceptional attendance and price — placed in `paragraph1`, not
   `paragraph3`.** This show's `attendance` compared against the full range
   of `shows_data$attendance` (all 1049 shows, no `NA`s in that column), and
   separately (per the user's follow-up) this show's `price` compared
   against other **USD-denominated** shows only (foreign currencies aren't
   directly comparable without conversion, and the user only asked for the
   USD case). Verified: largest attendance is `san-francisco-ca-usa-60400`
   (2000-06-04, Mission Dolores Park, 15000 - the Food Not Bombs benefit
   show, matches the user's example exactly), smallest is
   `bethesda-md-usa-120287` (1987-12-02, BCC High School, 10). Most
   expensive in USD is `anchorage-ak-usa-110195` (1995-11-01, Egan Center,
   **$8** - consistent with Fugazi's well-known low-ticket-price ethos).
   `shows_data$currency` has many values (USD, GBP, DEM, CAD, etc.) plus
   `NA`; the price-record check only fires when this show's own currency is
   `"USD"`, comparing against `shows_data %>% filter(currency=="USD")`.

   Unlike every other note type here, both of these are **independent of
   `has_recording`** - attendance/price exist for every show regardless of
   whether a recording survives, and checking confirms the
   smallest-attendance show specifically has no recording at all (the
   largest-attendance and most-expensive shows both do, but that won't
   always be true). Gating these inside `paragraph3` (which only builds
   when `has_recording`) would silently hide them for shows with no
   recording. So both are implemented as their own `note_record_attendance()`/
   `note_record_price()` functions (same style as the others, for
   consistency and future reuse) but *called from `paragraph1`'s assembly*
   instead of collected into `paragraph3` - appended as two more optional
   trailing clauses, the same pattern `tour_context_sentence`/
   `last_show_sentence` already use there.

9. **Festival show — placed in `paragraph1`, alongside attendance/price.**
   Fugazi played very few festivals; the `venue` field itself names them
   (there's no separate "festival" flag/tour field). Verified:
   `grepl("festival", shows_data$venue, ignore.case = TRUE)` matches
   exactly 4 shows across the whole series -
   `belo-horizonte-brazil-81594` (Belo Horizonte Independent Music
   Festival - matches the user's own memory exactly),
   `bologna-italy-61695` (Kactus Radio Festival Castel Maggiore),
   `hohenems-austria-61792` (Transmitter Festival), and
   `washington-dc-usa-62700` (Smithsonian Folklife Festival / National
   Mall). Same reasoning as note 8: this is a fact about the show
   (independent of `has_recording`), so `note_festival()` is also called
   from `paragraph1`'s assembly, not collected into `paragraph3`. The
   "only N festival shows" count is computed dynamically, same principle
   as note 7's soundcheck count.

10. **Curated one-off notes.** A small internal named lookup (`gid` →
   note text) inside `recap()`, for cases with no generic detection signal
   — confirmed via research that a show having bonus/alternate material
   doesn't correlate with any measurable property (track count, etc.), so
   this has to be a short curated list, not a formula. Seeded with two
   entries: `dallas-tx-usa-50490` → note about the "Outside the Gig!"
   alternate-recording track, and `birmingham-al-usa-52191` → note about
   the real "Two for Tuesdays" performance of "Greed" (undetectable
   generically per note type 3 above, since its two renditions are merged
   into one track in the source data). Extensible: future one-offs just
   add another entry to this list.

### Exact implementation

**Insert 11 note-generator functions** immediately after `describe_other_show`
(currently ends at R/recap.R:109), before the `recap()` roxygen block. Eight
of them (`note_rare_tracks` through `note_curated`, per note types 1-7 and
10 above) are collected into `paragraph3` inside the `has_recording` block;
three (`note_record_attendance`, `note_record_price`, `note_festival`, note
types 8-9 above) are called from `paragraph1`'s assembly instead, since
they're independent of `has_recording`:

```r
# paragraph3 note-generators -----------------------------------------------------------------------------------------------
# Each note_* function inspects one specific kind of noteworthy fact about a
# single show's recording and returns either NA_character_ ("nothing to
# say") or one or more complete, capitalized, period-terminated sentences as
# a single string. recap() collects whichever of these apply, drops the
# NAs, and space-joins what's left into paragraph3.

# Songs performed at this show that are rare across the whole series (fewer
# than 20 total recorded occurrences, tracktype 1/2 only - non-song
# tracktype 0 content like interludes/soundcheck is a different kind of
# rarity, handled by note_soundcheck() instead).
note_rare_tracks <- function(mygid, Repeatr1) {

  show_titles <- Repeatr1 %>%
    filter(gid==mygid, tracktype %in% c(1, 2)) %>%
    distinct(title) %>%
    pull(title)

  series_counts <- Repeatr1 %>%
    filter(tracktype %in% c(1, 2)) %>%
    count(title)

  rare_titles <- show_titles[show_titles %in% series_counts$title[series_counts$n<20]]

  if (length(rare_titles)==0) {
    NA_character_
  } else if (length(rare_titles)==1) {
    paste0("This show features a rarely performed song: ", rare_titles, ".")
  } else {
    paste0("This show features rarely performed songs: ", oxford_join(rare_titles), ".")
  }

}

# Songs performed noticeably earlier or later in the set than usual - more
# than 0.8 away (on the show's own 0-1 first-to-last scale) from the song's
# series-wide mean position. tracklist_full is the pre-select tracklist
# join (see recap()'s tracklist-building code), so non-song tracks (with no
# position_mean) are automatically excluded.
note_out_of_position <- function(tracklist_full) {

  position_bucket <- function(p) {
    if (p>=0.7) {
      "near the end of the set"
    } else if (p<=0.3) {
      "near the start of the set"
    } else {
      "mid-set"
    }
  }

  out_of_position <- tracklist_full %>%
    filter(is.na(position)==FALSE, is.na(position_mean)==FALSE, abs(position - position_mean)>0.8)

  if (nrow(out_of_position)==0) {
    return(NA_character_)
  }

  sentences <- vapply(seq_len(nrow(out_of_position)), function(i) {
    title <- out_of_position$title[i]
    usual <- position_bucket(out_of_position$position_mean[i])
    actual <- position_bucket(out_of_position$position[i])
    paste0(toupper(substr(title, 1, 1)), substr(title, 2, nchar(title)),
           ", normally performed ", usual, ", was performed ", actual, " this time.")
  }, character(1))

  paste(sentences, collapse = " ")

}

# Songs performed more than once within this show.
note_repeated_song <- function(mygid, Repeatr1) {

  repeat_counts <- Repeatr1 %>%
    filter(gid==mygid, tracktype==1) %>%
    count(title) %>%
    filter(n>=2)

  if (nrow(repeat_counts)==0) {
    return(NA_character_)
  }

  sentences <- vapply(seq_len(nrow(repeat_counts)), function(i) {
    title <- repeat_counts$title[i]
    times_word <- ifelse(repeat_counts$n[i]==2, "twice", paste0(repeat_counts$n[i], " times"))
    paste0(toupper(substr(title, 1, 1)), substr(title, 2, nchar(title)),
           " was performed ", times_word, " in this show.")
  }, character(1))

  paste(sentences, collapse = " ")

}

# Songs whose duration at this show set an all-time record (longest or
# shortest ever recorded rendition), restricted to songs with at least 20
# recorded renditions - below that a single show could shift the record
# without it being meaningfully "record-setting". tracklist_full already
# carries each title's series-wide minutes_min/minutes_max/renditions.
note_record_rendition <- function(tracklist_full) {

  eligible <- tracklist_full %>%
    filter(is.na(renditions)==FALSE, renditions>=20)

  longest_titles <- unique(eligible %>% filter(minutes==minutes_max) %>% pull(title))
  shortest_titles <- unique(eligible %>% filter(minutes==minutes_min) %>% pull(title))

  longest_sentences <- vapply(longest_titles, function(x) {
    paste0("This show includes the longest rendition of ", x, " recorded anywhere in the Fugazi Live Series.")
  }, character(1))

  shortest_sentences <- vapply(shortest_titles, function(x) {
    paste0("This show includes the shortest rendition of ", x,
           " recorded anywhere in the Fugazi Live Series, which may indicate the recording is incomplete.")
  }, character(1))

  all_sentences <- c(longest_sentences, shortest_sentences)

  if (length(all_sentences)==0) NA_character_ else paste(all_sentences, collapse = " ")

}

# Whether this show's own total recording duration is the longest or
# shortest of any Fugazi show with a surviving recording.
note_record_show_duration <- function(minutes, shows_data, duration_data_da) {

  recorded_shows <- shows_data %>% semi_join(duration_data_da, by = "gid")

  if (minutes==max(recorded_shows$minutes, na.rm = TRUE)) {
    "This is the longest Fugazi recording in the Fugazi Live Series."
  } else if (minutes==min(recorded_shows$minutes, na.rm = TRUE)) {
    "This is the shortest Fugazi recording in the Fugazi Live Series."
  } else {
    NA_character_
  }

}

# When this recording's non-song content (interludes, banter, crowd noise,
# etc.) wasn't tagged separately, song durations shown may run slightly
# long - the same condition already used to omit music_bracket, just above.
note_untracked_interludes <- function(music_minutes, minutes) {

  if (round(music_minutes, digits = 2) < round(minutes, digits = 2)) {
    NA_character_
  } else {
    "Interludes and other non-song content were not tracked separately for this recording, so song durations shown may be slightly over-estimated."
  }

}

# Whether this show's recording includes a soundcheck - rare enough across
# the whole series to flag, with the "only N shows" count computed live so
# it stays correct as new soundcheck recordings are added.
note_soundcheck <- function(mygid, Repeatr1) {

  soundcheck_gids <- Repeatr1 %>%
    filter(tracktype==0, grepl("sound.?check", title, ignore.case = TRUE)) %>%
    distinct(gid) %>%
    pull(gid)

  if (mygid %in% soundcheck_gids==FALSE) {
    NA_character_
  } else {
    paste0("This is one of only ", length(soundcheck_gids), " Fugazi Live Series recordings that include a soundcheck.")
  }

}

# Curated one-off notes for shows whose noteworthy fact has no generic
# detection signal elsewhere in this file (e.g. bonus/alternate material
# included in the download, which doesn't correlate with any measurable
# property of the recording itself). One more line here is all a new case
# needs - no other code changes required.
note_curated <- function(mygid) {

  curated_notes <- c(
    "dallas-tx-usa-50490" = "This show's download also includes an alternate recording, \"Outside the Gig!\", of the crowd outside the venue after the police forced the audience out of the building.",
    "birmingham-al-usa-52191" = "Greed was performed twice at this show, in the actual \"Two for Tuesdays\" bit that gave the phrase its name - but the two renditions are merged into a single track in this recording, so they don't appear as separate rows in the tracklist above."
  )

  if (mygid %in% names(curated_notes)) {
    unname(curated_notes[mygid])
  } else {
    NA_character_
  }

}

# Whether this show's attendance is the largest or smallest of any Fugazi
# show (independent of has_recording - called from paragraph1, not
# collected into paragraph3).
note_record_attendance <- function(attendance, shows_data) {

  if (attendance==max(shows_data$attendance, na.rm = TRUE)) {
    "This show had the largest attendance of any Fugazi show."
  } else if (attendance==min(shows_data$attendance, na.rm = TRUE)) {
    "This show had the smallest attendance of any Fugazi show."
  } else {
    NA_character_
  }

}

# Whether this show's ticket price is the highest of any USD-denominated
# Fugazi show - restricted to USD since foreign-currency prices aren't
# directly comparable without conversion (independent of has_recording -
# called from paragraph1, not collected into paragraph3).
note_record_price <- function(price, currency, shows_data) {

  if (is.na(price) | is.na(currency) | currency!="USD") {
    return(NA_character_)
  }

  usd_prices <- shows_data$price[is.na(shows_data$currency)==FALSE & shows_data$currency=="USD" & is.na(shows_data$price)==FALSE]

  if (price==max(usd_prices)) {
    "This was the most expensive Fugazi show (in USD)."
  } else {
    NA_character_
  }

}

# Whether this show was a festival - Fugazi played very few, and there's no
# separate flag for it in the data, so it's detected from the venue name
# itself (independent of has_recording - called from paragraph1, not
# collected into paragraph3). The "only N" count is computed live, same
# principle as note_soundcheck().
note_festival <- function(venue, shows_data) {

  if (grepl("festival", venue, ignore.case = TRUE)==FALSE) {
    return(NA_character_)
  }

  n_festivals <- sum(grepl("festival", shows_data$venue, ignore.case = TRUE))

  paste0("This was one of only ", n_festivals, " festival shows Fugazi ever played.")

}
```

(The `dallas-tx-usa-50490` note text is a draft, worth double-checking against
`inst/extdata/fls_data.csv`'s `fls_notes` for that gid during implementation
- confirmed by name/gid, exact wording is a one-line tweak either way.)

**Wire the three `has_recording`-independent notes into `paragraph1`**
(current R/recap.R:360-363) - `attendance`, `price`, `currency`, `shows_data`
are all already in scope at this point in `recap()`:

```r
  paragraph1 <- paste0("On ", datestring, ", ", attendance_clause, door_price_clause, " ",
                       location_sentence,
                       ifelse(tour_context_sentence=="", "", paste0(" ", tour_context_sentence)),
                       ifelse(last_show_sentence=="", "", paste0(" ", last_show_sentence)),
                       ifelse(is.na(attendance_record_note), "", paste0(" ", attendance_record_note)),
                       ifelse(is.na(price_record_note), "", paste0(" ", price_record_note)),
                       ifelse(is.na(festival_note), "", paste0(" ", festival_note)))
```

with `attendance_record_note <- note_record_attendance(attendance, shows_data)`,
`price_record_note <- note_record_price(price, currency, shows_data)`, and
`festival_note <- note_festival(this_show$venue, shows_data)` computed just
above it, alongside where `tour_context_sentence`/`last_show_sentence` are
already built.

**Pre-init `paragraph3`** alongside the other has_recording-only variables
(R/recap.R:377-383): add `paragraph3 <- ""` next to `paragraph2 <- ""`.

**Split tracklist-building into `tracklist_full` → `tracklist`** (current
R/recap.R:458-471) - `tracklist_full` keeps every joined column, including
`minutes_min` (added to the existing `duration_summary %>% select(...)`)
and `position_mean`, for the note-generators to inspect; `tracklist` trims
that down to the existing user-facing shape minus `mins_max`:

```r
    tracklist_full <- all_tracks %>%
      left_join(show_renditions %>% select(gid, song_number, minutes, position), by = c("gid", "song_number")) %>%
      left_join(track_minutes, by = c("gid", "song_number")) %>%
      mutate(minutes = ifelse(is.na(minutes), track_minutes, minutes)) %>%
      left_join(track_lookup, by = c("gid", "song_number")) %>%
      left_join(releasesdatalookup %>% select(rid, release_date), by = "rid") %>%
      left_join(duration_summary %>% select(title, minutes_mean, minutes_min, minutes_max, renditions), by = "title") %>%
      left_join(position_summary %>% select(title, position_mean), by = "title") %>%
      left_join(rendition_ranked, by = c("gid", "song_number")) %>%
      left_join(transition_ranked, by = c("gid", "song_number")) %>%
      arrange(song_number)

    tracklist <- tracklist_full %>%
      select(track = song_number, title, minutes, mins_mean = minutes_mean,
             position, pos_mean = position_mean, rendition = rendition_number, renditions,
             transition = transition_number, transitions = transition_count, release_date)
```

**Assemble `paragraph3`**, right after `paragraph2` is built (current
R/recap.R:518-524), content-notable notes first, technical caveat last:

```r
    note_pieces <- c(
      note_rare_tracks(mygid, Repeatr1),
      note_out_of_position(tracklist_full),
      note_repeated_song(mygid, Repeatr1),
      note_record_rendition(tracklist_full),
      note_record_show_duration(minutes, shows_data, duration_data_da),
      note_soundcheck(mygid, Repeatr1),
      note_curated(mygid),
      note_untracked_interludes(music_minutes, minutes)
    )

    note_pieces <- note_pieces[is.na(note_pieces)==FALSE]

    paragraph3 <- paste(note_pieces, collapse = " ")
```

**Add to `context` list** (current R/recap.R:558-560): `paragraph3 = paragraph3,`
alongside `paragraph1`/`paragraph2`. Also update the `@return` roxygen line
to mention `paragraph3`.

### UI wiring

- `context$paragraph3` added to the `context` list (`R/recap.R:526+`),
  alongside `paragraph1`/`paragraph2`.
- `app.R`: new `output$recap_summary_text3 <- renderText({
  recap_result()$context$paragraph3 })`, and a new `textOutput` placed
  after the `DT::dataTableOutput("recap_tracklist_datatable")` block
  (`app.R:997-1001`), inside the same `has_recording` `conditionalPanel`,
  only rendered when non-empty (wrap in its own
  `conditionalPanel(condition = "output.recap_summary_text3!= ''")` or
  equivalent, matching the "no header, blank if nothing noteworthy"
  requirement).
- `recap_template.Rmd`: new chunk after the `tracklist` chunk (line 70),
  `cat(ctx$paragraph3)` guarded on non-empty, mirroring the
  `summary-text-2` chunk's pattern.

## Verification

1. **#250**: launch the Shiny app in the browser, open the recap tab for
   any show with a recording, confirm the default scale bar reads ~100m
   and the marker doesn't visibly balloon when zooming in further than the
   default view. Re-check the downloaded HTML document's map too.
2. **#251**: call `recap(gid)$context$paragraph3` directly for each
   verified test-case gid and confirm the exact expected note appears:
   - `chicago-il-usa-61490` → longest-suggestion note
   - `belo-horizonte-brazil-81697` → shortest-repeater note (+ incomplete caveat)
   - `nagold-germany-110488` / `st-louis-mo-usa-60491` /
     `washington-dc-usa-72888` → glueman out-of-position note
   - `annapolis-md-usa-20688` → Break In performed-twice note
   - `victoria-bc-canada-70601` → longest-recording note
   - `virginia-beach-va-usa-71688` → shortest-recording note
   - `eindhoven-netherlands-90590` (or the other 2) → soundcheck note
   - `dallas-tx-usa-50490` → curated "Outside the Gig!" note
   - `birmingham-al-usa-52191` → curated "Two for Tuesdays"/Greed note
   - a show with no non-song content tracked separately (e.g. re-use
     `auckland-new-zealand-62797` from the earlier `music_bracket` check)
     → untracked-interludes caveat note
   - a show with none of the above → confirm `paragraph3==""`
3. **`paragraph1`'s three `has_recording`-independent notes** — call
   `recap(gid)$context$paragraph1` directly:
   - `san-francisco-ca-usa-60400` → largest-attendance note
   - `bethesda-md-usa-120287` → smallest-attendance note - **specifically
     confirm this appears even though this show has no recording**
     (`has_recording` should be `FALSE` for this gid), proving the fix for
     the gating problem identified during planning.
   - `anchorage-ak-usa-110195` → most-expensive-in-USD note
   - `belo-horizonte-brazil-81594` → festival note (and spot-check the
     other 3 known festival gids too:
     `bologna-italy-61695`, `hohenems-austria-61792`,
     `washington-dc-usa-62700`)
   - a typical show with none of these → confirm `paragraph1` is unchanged
     from before this session's edits (no stray trailing space/artifact
     from the new `ifelse()` clauses when all three are `NA`)
4. Confirm `mins_max` no longer appears in `tracklist` column names for any
   gid, `mins_mean` still does.
5. Regression-check a couple of `paragraph1`/`paragraph2` examples from
   earlier sessions (e.g. `el-paso-tx-usa-40901`, `jonkoping-sweden-100600`)
   to confirm this session's changes didn't disturb the #253/#254/#255
   prose fixes or #256/#249/#252's tracklist/duration work from earlier in
   this cluster.
6. `devtools::document()` safety check — expect a `man/recap.Rd` diff only
   if any parameter/return signature changed (it shouldn't, `paragraph3`
   is just a new `context` field, not a new parameter).

## Housekeeping (per CLAUDE.md)

- Bump `DESCRIPTION`'s version by a small increment once implementation is
  complete.
- Write a session-notes file (and matching plan copy) in `./inst/notes`
  covering both fixes, the verified test cases, and the map's estimated
  zoom level (flagged as needing visual confirmation, not just computed).
- No fugazibase changes needed — this is all `recap()`/Shiny presentation
  layer, not data pipeline (aside from possibly widening the existing
  `duration_summary` join to include `minutes_min`, which is reading an
  already-existing column, not a schema change).

## Outcome

Plan executed as written. `Repeatr1` (not `attendance`/`price`/`shows_data`
alone) was the correct source for tracktype-aware detection in the
`paragraph3` notes, exactly as designed. Both #250 and #251 were verified
live in the running Shiny app in addition to direct `recap()` calls - see
the matching session-notes file
`202608171130_notes_recap-map-scale-exceptional-notes.md` for full
verification results, including the live browser confirmation of the
100m scale bar and the `bethesda-md-usa-120287` smallest-attendance-note-
without-a-recording case that motivated moving three note types from
`paragraph3` into `paragraph1`. Also updated `vignettes/Fugazetteer.Rmd`'s
"recap" section to describe the new notes paragraph and drop the stale
"maximum recorded duration" mention (since `mins_max` was removed from the
tracklist).
