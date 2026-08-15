# Shiny app: rename Duration→Details, add Position metric to Variation

## Context

The "stock" section of the Fugazetteer Shiny app (`inst/shiny/Fugazetteer/app.R`) has two tabs about song-rendition durations: **variation** (cumulative distributions + summary stats) and **duration** (a per-rendition details table). The user wants:

1. The "duration" tab renamed to "details" (a more general name, since it will soon show more than just duration).
2. The "variation" tab to support a second metric, **position** — a song's normalized position within a show's setlist (`p = (n-m)/(N-m)`, where `n` is the song's own track number, `m` is the track number of the first song in the show, and `N` is the track number of the last song) — as an alternative to duration, selectable via a new dropdown next to the existing "songs" selector.
3. The renamed "details" tab to gain a `position` column (2 dp) next to `song_number`.
4. Both tabs' CSV downloads to reflect these changes (renamed file, new column).
5. `vignettes/Fugazetteer.Rmd` updated to match.

**Key data-provenance finding (confirmed with user):** `position` cannot be derived from `fls_tags` alone — `fls_tags` has no `tracktype` classification, so it can't tell real songs apart from intros/interludes/encore banter. Per user's explicit direction, `duration_data_da`'s existing structure is being kept as-is (row population from `Repeatr1` filtered to `tracktype==1`; `minutes` values joined in from `fls_tags` — this is already how it works today). `position` will be computed on top of that existing structure, not by restructuring it.

`duration_data_da` is already filtered to `tracktype==1` (real songs only) and already carries `song_number` and `gid` per row — exactly what the user's formula (`p = (n-m)/(N-m)`, where `m`/`N` are the *track numbers* of the first/last song in the show, not a count of songs) needs. So `position` can be computed directly on `duration_data_da` with `m = min(song_number)` and `N = max(song_number)` per `gid` — no need to reach back into `Repeatr1`/`Repeatr1a`'s contiguous-rank logic at all.

Also confirmed with user:
- The variation/position toggle is a `selectInput` dropdown (matches existing app style).
- Internal Shiny IDs/reactive names get renamed too (`duration_song` → `details_song`, etc.), not just the visible label.
- The "total" column removal is display/download-only in the app; `duration_summary$minutes_total` stays in the underlying data object.

## 1. `R/Repeatr_1.R` — new `position` column + two new data objects

**1a. Add `position` to `duration_data_da`** — insert right after the existing duplicate-cleanup filters, before `save(duration_data_da, file = "duration_data_da.rda")` (currently line 1625):

```r
duration_data_da <- duration_data_da %>%
  group_by(gid) %>%
  mutate(first_song_number = min(song_number),
         last_song_number = max(song_number),
         position = ifelse(last_song_number > first_song_number,
                            round((song_number - first_song_number) / (last_song_number - first_song_number), digits = 2),
                            0)) %>%
  ungroup() %>%
  select(-first_song_number, -last_song_number)
```

This uses the existing `song_number` values directly (`m`/`N` = per-show min/max), matching the user's formula exactly — no re-ranking needed, since `duration_data_da` is already filtered to `tracktype==1`. Any non-song tracks (`tracktype` 0/2) between the first and last song just create uneven spacing between consecutive songs' `position` values, which is consistent with the formula as specified (it's a rescaling of raw track number, not a count-based rank). Single-song shows get `position = 0` rather than `NaN`.

**1b. Add `cumulative_position_counts`** — a new data object mirroring `cumulative_duration_counts` (built at lines 1083-1128) but keyed on `position` instead of `minutes`, built from `duration_data_da` (now that it carries `position`). Insert after the `duration_data_da` save block, reusing the already-in-scope `releases_lookup` (built earlier at lines 1112-1117):

```r
mydf_pos <- duration_data_da %>%
  select(position, title) %>%
  group_by(position, title) %>%
  summarize(count = n()) %>%
  ungroup()

mydf_pos_wide <- mydf_pos %>%
  pivot_wider(names_from = title, values_from = count, values_fill = 0)

mydf_pos_wide2 <- mydf_pos_wide
number_columns_pos <- ncol(mydf_pos_wide2)
for (colindex in 2:number_columns_pos) {
  mydf_pos_wide2[,colindex] <- cumsum(mydf_pos_wide2[,colindex])
}

mydf_pos_long <- mydf_pos_wide2 %>%
  pivot_longer(!position, names_to = "title", values_to = "count") %>%
  filter(count>0) %>%
  left_join(releases_lookup)

cumulative_position_counts <- mydf_pos_long %>%
  select(position, title, release_title, count) %>%
  mutate(release_title = ifelse(is.na(release_title)==TRUE, "unreleased", release_title))

setwd(mydatadir)
save(cumulative_position_counts, file = "cumulative_position_counts.rda")
setwd(mydir)
```

**1c. Add `position_summary`** — mirrors `duration_summary` (lines 1142-1160) but from `duration_data_da`'s population, no `*_total` column (summing a normalized position isn't meaningful):

```r
position_summary <- duration_data_da %>%
  group_by(title) %>%
  summarize(renditions = n(),
            position_min = round(min(position), digits = 2),
            position_median = round(median(position), digits = 2),
            position_max = round(max(position), digits = 2),
            position_mean = round(mean(position), digits = 2),
            position_sd = round(sd(position), digits = 2)) %>%
  ungroup()

setwd(mydatadir)
save(position_summary, file = "position_summary.rda")
setwd(mydir)
```

Note: `cumulative_position_counts`/`position_summary`'s population (from `duration_data_da`, i.e. `Repeatr1` `tracktype==1`) differs slightly from `cumulative_duration_counts`/`duration_summary`'s population (from `fls_tags` matched via `song_songid`) — this mirrors a pre-existing divergence already present between these two families of tables and is not being newly introduced or fixed here.

Verified safe: `sweepstack()` (`R/sweepstack.R:27`) and `stacks()` (`R/stacks.R:41`) both consume `duration_data_da` via name-based `select()`/`group_by()`, unaffected by the added column.

## 2. `R/data.R` — roxygen docs

- `duration_data_da` doc block (lines 478-494): add `\item{position}{normalized position of the song within the show's setlist, from 0 (first song) to 1 (last song), rounded to 2 decimal places}`.
- Add two new `@format`/`\describe` blocks (mirroring `cumulative_duration_counts`, lines 517-530, and `duration_summary`, lines 496-515) documenting `cumulative_position_counts` and `position_summary`.

Run `devtools::document()` afterward to regenerate `man/duration_data_da.Rd` and create `man/cumulative_position_counts.Rd`, `man/position_summary.Rd`.

## 3. Rebuild the data

Run `Repeatr_Updatr(really = "really")` (default `update_stacks = FALSE`) to regenerate `data/*.rda` from the updated `R/Repeatr_1.R` — this runs `Repeatr_1()` through `Repeatr_5()` and produces `duration_data_da.rda`, `cumulative_position_counts.rda`, and `position_summary.rda`, which is everything this change needs. Deliberately **not** passing `update_stacks = TRUE`: `sweepstack()`/`stacks()` only consume `duration_data_da` via `select(gid, title)`/`group_by(gid)` (verified below), so they're unaffected by `position` either way, and `sweepstack()` draws a fresh `runif()` random seed on every run (`R/sweepstack.R:34`) — rerunning it here would just produce unrelated, non-deterministic churn in the stacks output with no bearing on this change. Then reinstall the package (`devtools::install()` or `devtools::load_all()` for local testing) so the Shiny app picks up the new/changed data objects.

Per `CLAUDE.md`'s fugazibase-consistency requirement: no changes needed to `R/export_fugazibase_data.R`. It already explicitly excludes "anything joined/summarized/modeled (e.g. `duration_summary`...)" — `position`, `cumulative_position_counts`, and `position_summary` fall in that same excluded category as their sibling duration objects, so the existing exclusion pattern already covers them correctly.

## 4. `inst/shiny/Fugazetteer/app.R` — rename "duration" tab to "details"

Rename throughout (UI at lines 1090-1113, server at lines 3571-3649):

| Old | New |
|---|---|
| `tabPanel("duration", ...)` | `tabPanel("details", ...)` |
| `menuOptions_duration_song` (UI output + renderUI) | `menuOptions_details_song` |
| `duration_song` (selectizeInput id) | `details_song` |
| `duration_shows_data` reactive | `details_data` |
| `duration_shows_data2` reactive | `details_data2` |
| `duration_shows_data3` reactive | `details_data3` |
| `duration_shows_datatable` output | `details_datatable` |
| `downloadDurationData` output | `downloadDetailsData` |
| filename `"_Fugazetteer_Duration.csv"` | `"_Fugazetteer_Details.csv"` |

Confirmed via grep this is the complete set of `"duration"`-tab-related identifiers in `app.R` — no other tab-switching/bookmarking logic references the old names.

**Add `position` column** to both the on-screen table and the CSV, immediately right of `song_number`:
- `details_data2` (was `duration_shows_data2`, line 3609-3617): `select(fls_link, date, song_number, position, title, minutes)`.
- `details_data3` (was `duration_shows_data3`, line 3619-3632): `select(url, date, song_number, position, title, minutes)`.

(`position` is already rounded to 2 dp at the data-build stage, so no extra rounding needed here.)

## 5. `inst/shiny/Fugazetteer/app.R` — Variation tab metric toggle

**UI** (lines 1039-1084): restructure the top `fluidRow` to add a `metric` dropdown between the songs selector and the download button:

```r
fluidRow(
  column(7, uiOutput("variation_songInput")),
  column(3, selectInput("variation_metric", "metric:",
                         choices = c("duration", "position"), selected = "duration")),
  column(2, style = "margin-top: 29px;", downloadButton("downloadVariationData", ""))
)
```

**Server** (lines 3447-3565): branch the existing reactive chain on `input$variation_metric`, switching between the duration-based objects (`cumulative_duration_counts`, `duration_summary`, column `minutes`/`minutes_sd`) and the new position-based ones (`cumulative_position_counts`, `position_summary`, column `position`/`position_sd`):

- `variation_data`: pick `cumulative_position_counts` or `cumulative_duration_counts` as the base table before applying the existing release/song filters. (Leave `variation_songInput`'s choice-list sourced from `cumulative_duration_counts` as today — the song population is effectively the same either way, and this avoids adding a second server-rendered UI element that could desync from the plot.)
- `variation_data2` (ranking by variability, drives the `max_songs_variation` slider): join `position_summary`/`duration_summary` and rank by `position_sd`/`minutes_sd` depending on mode.
- `variation_data3`: unchanged (mode-agnostic — operates on whatever `variation_data()`/`variation_data2()` produced).
- `variation_data4` (the summary table + basis for CSV): join `position_summary`/`duration_summary` depending on mode, and drop `minutes_total` from the result if present (`if ("minutes_total" %in% colnames(mydf)) mydf <- mydf %>% select(-minutes_total)`) — no equivalent column exists for `position_summary`, so this naturally handles "no total column" in both modes.
- `variation_data5`: unchanged (generic footer-wrapping for CSV).
- `output$variation_count_plot`: x-axis becomes `minutes` or `position` depending on `input$variation_metric`, with a matching `xlab()`. Use `aes(x = .data[[xvar]], y = count, color = title)` with `xvar <- if (input$variation_metric == "position") "position" else "minutes"`.

## 6. `vignettes/Fugazetteer.Rmd`

- `## duration` (lines 538-552) → rename to `## details`; add a bullet documenting the new `position` column (mirroring the existing `song_number` bullet's style, e.g. "position - the song's normalized position in the set, from 0 (first song) to 1 (last song)").
- `## variation` (lines 512-536): document the new `duration`/`position` dropdown next to the songs selector, and add a second column-list for when `position` is selected (`renditions, position_min, position_median, position_max, position_mean, position_sd` — no total), alongside the existing `minutes_*` list. Note that both lists no longer include a total column in the app (mention `minutes_total` is dropped from display only if worth flagging).
- Add a CSV-download-location sentence to both sections if consistent with the `renditions`/`sets`/`stacks` sections' existing pattern (per prior research, `variation`/`duration` currently lack this sentence while other pages have it) — optional polish, include if it fits naturally.
- Any screenshots referenced in these sections will be stale after the UI change; note this but don't attempt to regenerate images as part of this plan (out of scope / needs a live app).

## 7. Session notes

Per `CLAUDE.md`, write `inst/notes/202608151400_notes_variation-position-details-rename.md` (adjust timestamp to actual completion time) summarizing what changed and why, referencing this plan file.

## Verification

1. `devtools::document()` — confirm new `.Rd` files generate cleanly, no roxygen errors.
2. Run `Repeatr_Updatr(really = "really")` from a local console — confirm `data/duration_data_da.rda`, `data/cumulative_position_counts.rda`, `data/position_summary.rda` are written, and check `duration_data_da$position` ranges from 0 to 1 with no `NA`/`NaN`.
3. `devtools::load_all()`, then run the Shiny app locally (`shiny::runApp("inst/shiny/Fugazetteer")`):
   - "details" tab shows in the stock section with the renamed label; table has `position` next to `song_number`, rounded to 2 dp; CSV downloads as `..._Fugazetteer_Details.csv` with the same column.
   - "variation" tab: default (duration) view is pixel-identical in behavior to before; switching the new dropdown to "position" changes the plot's x-axis and the table's columns to `position_*`, with no total column in either mode; CSV download reflects the selected mode.
   - Songs/releases filters still work in both modes; `max_songs_variation` slider still works in both modes.
4. Spot-check a couple of `position` values by hand against a known show's setlist (e.g. pick a `gid`, confirm first song is `position == 0`, last is `position == 1`).

---

*Note: this plan was executed with one addition discovered during implementation/review — `vignettes/Data-Provenance.Rmd`'s pipeline diagram and dataset catalogue table were also updated to list the two new data objects (`position_summary`, `cumulative_position_counts`), which this plan's Section 6 didn't originally call out. See the companion session notes file for the full account of what was actually done.*
