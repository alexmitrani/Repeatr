# Session notes: issue #263 phase 4 — Shiny load-time precomputation

## What changed

Fourth and final session addressing
[issue #263](https://github.com/alexmitrani/Repeatr/issues/263). Full
multi-phase plan at `inst/notes/202608202100_plan_issue263-code-quality.md`.
This session executed Phase 4: moving `inst/shiny/Fugazetteer/app.R`'s
sheet-independent preprocessing to package-build time, and deferring its two
non-coordinate live sheet reads until their tab is actually visited.
Phases 1–3 (already done, `R CMD check` at 0/0/0) were untouched.

**Constraint honored:** all three of `app.R`'s live Google Sheets reads
(`fls_venue_geocoding`, `quizdata`, `linktracksindexdata`) still run live, at
runtime - none of them were baked into a build-time `.rda`. Only computation
that never touches any of the three was moved.

### New build-time precomputation

- **`R/build_shiny_precompute.R`** (new, `@export`ed): `build_shiny_precompute()`
  mirrors, line for line, every join/aggregation `app.R` used to run inline
  that doesn't depend on a live sheet, and saves the result as 10 new
  `data/shiny_*.rda` objects:
  - `shiny_year_tour_release`, `shiny_fls_link_year_tour`,
    `shiny_transitions_data_da`, `shiny_duration_data_da` - the small joins
    that used to run at the very top of `app.R`.
  - `shiny_othervariables_base` - `othervariables` joined with
    `gid_sound_quality` plus its `urls`/`fls_link` columns, **up to but not
    including** the live coordinate join/disambiguation (that stays in
    `app.R`, since it depends on `fls_venue_geocoding`).
  - `shiny_year_tour_gid_song` - only `year`/`tour`/`gid`/`title` survive its
    final `select()`, so - unlike `shiny_othervariables_base` - this is safe
    to build from the *raw* (pre-live-join) `othervariables`; coordinates
    never enter the result. Verified this empirically (see Verification).
  - `shiny_discography`, `shiny_releases_data_input`, `shiny_releases_summary`,
    `shiny_shows_data_base` - the tempo/discography chain (joins in
    `song_tempo_bpm_data`/`songvarslookup` onto `releases_data_input`,
    `releases_summary`, and `shows_data`). This was the single biggest win:
    a `left_join` + `group_by`/`summarise` over `duration_data_da`'s ~18k
    rows, run twice (once per intermediate), now runs once at build time.
  - **Dropped, not carried forward:** `discography_tempo_bpm` and
    `shows_tempo_bpm` (single-row overall-average tempo objects `app.R` used
    to also compute in this chain) - confirmed by grepping the whole file
    that neither feeds any `output$`/reactive, i.e. they were dead code
    before this session touched them. Removing them is a side effect of
    consolidating the chain, not a scope-driven cleanup.
  - Documented in `R/data.R` under a new "Shiny-presentation-only cached
    views" section, and added as a new tier (alongside Raw/Derived-\*/
    Frozen-legacy) in `vignette("Data-Provenance")`, with each object's
    `@section Provenance` cross-linking to `build_shiny_precompute()`.
- **`data-raw/build_data.R`**: added stage B2 - `build_shiny_precompute()`
  runs right after `Repeatr_Updatr()` (stage B) and before the
  `tools::resaveRdaFiles()` recompression pass, so the new `shiny_*.rda`
  files get the same compression treatment as everything else in `data/`.

### `app.R` changes

- The blocks this session targeted (see the Phase 4 section of the plan
  doc for the original line-by-line dependency trace) now just assign from
  the precomputed object instead of recomputing it, e.g.
  `year_tour_release <- shiny_year_tour_release`,
  `shows_data <- shiny_shows_data_base`. The genuinely live-dependent code
  (the `fls_venue_geocoding` fetch itself, the Portland/Columbia/Croydon/
  Oxford/Newcastle disambiguation, the coordinate join, the gid-uniqueness
  safety nets) is untouched, byte-for-byte, from before this session.
- **`quizdata`/`linktracksindexdata` lazy-loading**: their `gsheet2tbl()`
  fetch + transform pipeline moved from top-level script code into the
  server's own `quiz_data()` reactive and a new shared `linktracksindex_raw()`
  reactive (feeding the existing `linktracksindex_data()`/`linktracksindex_data2()`).
  No `bindEvent`/tab-id wiring needed: Shiny suspends outputs on hidden tabs
  by default, so a `reactive()` that only a hidden tab's output depends on
  simply never executes until that tab is opened. Freshness is unchanged -
  still a live fetch, just deferred instead of running unconditionally at
  app start regardless of whether the session ever visits "quiz"/"index".
- Not done (marked optional/stretch in the plan, skipped for scope/time):
  bundling `font_google("Inconsotala")` locally, and `bindCache()` on the
  filter-driven `shows_data2`/`shows_data3` reactives.

## Verification

- **Row-for-row equality check** (`phase4_full_verify.R`, scratchpad only):
  sourced the *pre-edit* `app.R`'s full preprocessing block (through
  `ui <- fluidPage(`) live - including its real `gsheet2tbl()` calls - into
  an isolated environment, and compared every one of the 8 objects that
  don't touch coordinates (`year_tour_release`, `fls_link_year_tour`,
  `transitions_data_da`, `duration_data_da`, `year_tour_gid_song`,
  `discography`, `releases_data_input`, `releases_summary`) against the
  corresponding new `shiny_*` object via `all.equal()`: **all matched
  exactly**. For the two coordinate-dependent objects
  (`othervariables`/`shows_data`), confirmed `shiny_othervariables_base`'s
  and `shiny_shows_data_base`'s column sets match the old code's live-final
  versions minus exactly `x`/`y` (added back by the live join, as expected),
  and that `tempo_bpm` values match exactly.
- Separately confirmed the `shiny_year_tour_gid_song` join key assumption:
  the *live-processed* `othervariables` (with `urls`/`fls_link` added)
  shares `gid`/`date`/`urls`/`fls_link` with `duration_data_da`, not just
  `gid`, so its natural join actually matches on all four - but since
  `urls`/`fls_link` are pure functions of `gid` in both tables, the join
  result is identical either way. Verified this directly: building
  `year_tour_gid_song` from the *live* othervariables vs. the *raw* one
  produced `identical` (`all.equal` `TRUE`) 18,273-row results.
- `devtools::test()`: `PASS 8, FAIL 0, WARN 0, SKIP 0` (unchanged from
  Phase 3).
- `rcmdcheck::rcmdcheck(args = c("--no-manual"), error_on = "never")`:
  **0 errors, 0 warnings, 0 notes**.
- **Launched the Shiny app locally** (`shiny::runApp()` after
  `devtools::load_all()`) and drove it with `claude-in-chrome` through every
  tab: `today` (correct show count for the date); `flow → shows`/`with`
  (Leaflet maps render with live-geocoded markers scattered correctly
  across the actual venue locations - confirms the coordinate join off
  `shiny_othervariables_base`/`shiny_shows_data_base` still works);
  `flow → recap` (selected the first-ever Fugazi show,
  `washington-dc-usa-90387` - prose output matches Phase 3's own
  verification of the same show exactly); `stock → discography` (bar chart
  renders, confirms `shiny_discography`/`shiny_releases_data_input`); `stock
  → details` (DT table of song renditions renders); `quiz` (High Scores
  table populated - confirms the lazy `quiz_data()` fetch fires on tab
  visit); `index` (Link Track Index table populated - confirms
  `linktracksindex_raw()`). No browser console errors; no new R-side
  errors/warnings in the app's log (only the pre-existing, Phase-3-noted
  `search_shows_recap` selectize-size performance note).
- **Cold-start timing**: isolated just the sheet-independent preprocessing
  block (everything before `ui <- fluidPage(`, run via `sys.source()` in a
  fresh environment after `devtools::load_all()`) and timed it end-to-end,
  including the app's own three real `gsheet2tbl()` calls in the pre-edit
  version. Pre-edit `app.R` (from `git show HEAD:...`, 3 runs): **4.06s,
  4.28s, 4.41s**. Post-edit `app.R` (3 runs): **1.85s, 1.96s, 2.10s** - a
  ~52% reduction in this block alone, even though it *still* includes the
  one live sheet fetch (`fls_venue_geocoding`) that must stay at startup.
  The other two sheets (`quizdata`, `linktracksindexdata`) are no longer in
  this critical path at all, now that they're deferred to their own tabs -
  their fetch time (not separately measured here, but each is a
  `gsheet2tbl()` network round-trip) is removed from cold start entirely
  for any session that never opens those tabs.

## Bookkeeping

- Bumped `DESCRIPTION` version `0.0.0.9267` → `0.0.0.9268`.
- `devtools::document()` regenerated `NAMESPACE` (new
  `export(build_shiny_precompute)`) and 10 new `man/shiny_*.Rd` files.
- **fugazibase**: no changes needed or made. Confirmed
  `build_shiny_precompute()`'s outputs are Shiny-presentation-only cached
  views of data `export_fugazibase_data()` already reads from elsewhere
  (`othervariables`, `shows_data`, `summary`, `releases_data_input`,
  `releases_summary`, `duration_data_da`, `transitions_data_da`,
  `song_tempo_bpm_data`, `songvarslookup`) - nothing new was introduced at
  the data-*value* level, only new build-time-cached *views* consumed
  solely by `app.R`. `vignette("Data-Provenance")` updated to document this
  explicitly (new "Shiny-presentation-only" tier, table row, provenance
  diagram branch).
- This closes out all four phases of
  `inst/notes/202608202100_plan_issue263-code-quality.md` - issue #263's
  `R CMD check`/dependency-hygiene/NSE goals were completed in Phases 1–3
  (0 errors, 0 warnings, 0 notes, unchanged by this session); this session
  completed the remaining Shiny-perf goal. The plan's "delete unused
  vignette images" item was also done back in Phase 1.
