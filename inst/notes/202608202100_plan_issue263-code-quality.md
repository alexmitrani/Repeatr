# Plan: Address issue #263 (code quality / R CMD check / Shiny perf)

## Context

Issue #263 asks for a general code-quality pass on Repeatr:
1. Pass `R CMD check` clean (currently **0 errors, 6 warnings, 2 notes** per a fresh local run — see below; the issue text says 4 notes, likely from a run with different flags/environment, but the underlying problems are the same).
2. Stop dumping ~29 packages into `Depends` — move them to `Imports` (or `Suggests`), and qualify function calls properly.
3. Look for ways to speed up / improve responsiveness of the Fugazetteer Shiny app.
4. Delete unused files from `vignettes/images`.

This is a large, multi-concern cleanup. Per user decision, it will be split across **multiple work sessions**, each independently verifiable, each ending with a version bump and session notes per `CLAUDE.md`. This document lays out all phases so later sessions have the full roadmap, but each phase should be executed (and committed) separately.

**Confirmed via a local `rcmdcheck::rcmdcheck()` run** (R 4.5.3, pandoc from the bundled RStudio/Quarto install):

```
0 errors | 6 warnings | 2 notes
```

Warnings:
1. Non-portable file name: `vignettes/images/Screenshot_20240212_000515_Spiral Player.png`
2. Package install warning — namespace conflicts from broad `@import` tags: `crayon::chr`/`rlang::chr`, `readr::guess_encoding`/`rvest::guess_encoding`, `rlang::as_list`/`xml2::as_list`
3. `inst/doc` contains invalid file names: `92songs.Rmd`, `92songs.html` (vignette basename starts with a digit)
4. Non-ASCII characters in `R/Repeatr_1.R` (accented venue/band names)
5. Dependencies in R code: `httr`/`purrr`/`utf8` used via `::` but not declared; 16 `Depends` packages never imported in NAMESPACE
6. Data files would compress much better (`R CMD build --resave-data`)

Notes:
1. `knitr` and `rmarkdown` listed in both `Depends` and `Suggests`
2. ~470 "no visible binding for global variable" (NSE column names in dplyr/tidyr pipes across ~15 files in `R/`)

User decisions locked in for later phases:
- NSE note → fix by converting to the **`.data$col` pronoun** in the dplyr/tidyr pipes (not `utils::globalVariables()`).
- Shiny perf → **precompute what can be precomputed, but the three `gsheet2tbl()` live Google-Sheets reads must stay live/runtime** — that's intentional so edits to the sheets show up without redeploying the app. Only non-sheet-dependent computation should move to build time.

---

## Phase 1 — Low-risk cleanup (recommended first session)

No dependency/NAMESPACE changes, no data-pipeline changes. Safe, mechanical, directly resolves 4 of the 6 warnings + fixes the note about size/ package listing duplication.

- **Delete unused vignette images.** Confirmed via full-repo search: only 6 of the 145 files in `vignettes/images` are referenced anywhere (`AllAccess.Rmd` uses `descarga.png`, `paste-784A0D87-01.png`, `paste-DD62F29A.png`, `paste-9F100001.png`; `Fugazetteer.Rmd` uses `paste-784A0D87.png`, `paste-5C2D1B16.png`). Delete the other 139 files (~20MB), including `Screenshot_20240212_000515_Spiral Player.png` — this also fixes WARNING #1 (non-portable filename) for free. Double-check `plot1`/`plot2`/`plot3` (no extension) are actually images before deleting.
- **Resave data with better compression.** Run `tools::resaveRdaFiles("data", compress = "auto")` (or `R CMD build --resave-data`) and commit the recompressed `.rda` files — fixes WARNING #6. Add a note to `data-raw/build_data.R` (or a comment) so future data rebuilds keep using efficient compression.
- **Remove the `knitr`/`rmarkdown` Suggests duplication** in `DESCRIPTION` — they're actually used (Depends today, Imports later), not just suggested, so drop them from `Suggests:`. Fixes NOTE #1.
- **Rename the `92songs.Rmd` vignette** to a name that doesn't start with a digit (e.g. `92-Songs.Rmd` won't work either — must not start with a digit at all, e.g. `Ninety-Two-Songs.Rmd`). Fixes WARNING #3. Update the two known references: `README.md:31` and `index.md` (grep confirmed no `_pkgdown.yml` reference). Follow the existing project convention noted for vignette filenames (avoid special characters/apostrophes/spaces too).
- **Fix non-ASCII characters in `R/Repeatr_1.R`.** `tools::showNonASCIIfile()` located exactly 6 lines (360, 367, 1169, 1172, 1175, 1178, 1241) with accented characters in venue/band-name strings (Cégep, Associação, Porão, Phünhögg, Lisabö, curly apostrophe in "Duncan's"). Replace with `\uXXXX` escapes. Fixes WARNING #4.
- **Remove dead dependency `showtext`** from `DESCRIPTION` — confirmed unused anywhere (case-insensitive search across the whole repo). **Correction from the original audit: `SimDesign` is *not* dead** — `R/sweepstack.R` calls `SimDesign::quiet()` unqualified (bare `quiet(...)`), which the earlier grep-based audit missed since it only searched for qualified `SimDesign::` calls. Confirmed by running `R CMD check`'s examples: removing `SimDesign` from Depends broke `Repeatr_6()`'s example with `could not find function "quiet"`. `SimDesign` stays in `Depends` for Phase 1; Phase 2 should qualify the call as `SimDesign::quiet()` in `R/sweepstack.R` and move it to `Imports` properly rather than removing it.

**Verification:** re-run `rcmdcheck::rcmdcheck()` and confirm those 4 warnings + the DESCRIPTION note are gone (expect `~2 warnings, ~1 note` remaining — the Depends/NAMESPACE warning and the NSE note, both deferred to later phases). Spot-check the renamed vignette still builds and `pkgdown::build_site()` (or at least the affected page) still resolves.

---

## Phase 2 — Dependency restructuring (Depends → Imports/Suggests)

This is the part that risks breaking the Shiny app, since `inst/shiny/Fugazetteer/app.R` has **only `library(Repeatr)`** at the top and relies entirely on all 29 `Depends` packages being attached to the search path (confirmed: ~218 unqualified `shiny` calls, ~64 unqualified `ggplot2` calls, plus unqualified `leaflet`, `scales`, `viridis`, `bslib`, `thematic`, `cols4all`, `gsheet` calls).

Findings (from full dependency audit):

| Package(s) | Where used | Action |
|---|---|---|
| crayon, dplyr, tidyr, fastDummies, knitr, lubridate, rlang, stringr, readr, mlogit, rvest, xml2 | `R/` (already `@import`ed in NAMESPACE, mostly already `pkg::`-qualified) | Move to `Imports`; convert the scattered `@import pkg` roxygen tags (currently duplicated across ~15 files: `Repeatr_1.R` … `Repeatr_6.R`, `Repeatr_Updatr.R`, `compressr.R`, `diffr.R`, `rankr.R`, `scrape_fls_*.R`, `export_fugazibase_data.R`) to selective `@importFrom pkg fun1 fun2 …`, consolidated into one place (e.g. a new `R/Repeatr-package.R` roxygen block) — this also **fixes the 3 namespace conflicts** (`crayon::chr`/`rlang::chr`, `readr::guess_encoding`/`rvest::guess_encoding`, `rlang::as_list`/`xml2::as_list`) since broad `@import` is what causes them |
| geosphere | `R/recap.R`, `R/data.R` — already fully qualified | Move to `Imports`, add `@importFrom` |
| shiny, ggplot2, DT, leaflet, plotly, scales, viridis, bslib, thematic, cols4all, gsheet, rmarkdown | `inst/shiny/Fugazetteer/app.R` only, mostly unqualified | Move to `Imports` (package-level, so `R CMD check` is satisfied); **add explicit `library(...)` calls at the top of `app.R`** for each so the deployed Shiny app keeps working exactly as before (Shiny apps are conventionally run with packages attached, not `pkg::`-qualified everywhere — qualifying ~280+ call sites would be a much larger, riskier diff for no real benefit in an app entry point) |
| heatmaply | `vignettes/CombinationLock.Rmd` only | Move to `Suggests`, guard the vignette chunk with `requireNamespace("heatmaply")` if not already |
| httr, purrr, utf8 | `R/` — already `::`-qualified but undeclared | Add to `Imports` in `DESCRIPTION` |
| showtext | nowhere | Already removed in Phase 1 |
| SimDesign | `R/sweepstack.R` (`quiet()`, called unqualified — **not** dead, see Phase 1 correction above) | Move to `Imports`; qualify as `SimDesign::quiet()` in `R/sweepstack.R` |

Steps:
1. Rewrite `DESCRIPTION`: `Depends: R (>= 3.5.0)` only; move everything else into `Imports:` (except `heatmaply` → `Suggests:`).
2. Consolidate/rewrite roxygen import tags per the table above; run `devtools::document()` to regenerate `NAMESPACE`.
3. Add the `library()` block to `inst/shiny/Fugazetteer/app.R` for the app-only packages.
4. Re-run `rcmdcheck::rcmdcheck()` — expect the "Depends field not imported" / "undeclared ::" warning and the "listed in more than one field" class of notes to be gone.

**Verification:** `R CMD check` warning about dependencies gone; load the package fresh (`devtools::load_all()` / restart R) and confirm `R/` functions still work; **launch the Shiny app locally and click through every tab** (map, shows, songs, quiz, index/linktracks, recap, today) to confirm nothing silently broke from the `Depends`→`Imports` switch — this is the step most likely to surface a missed unqualified call.

---

## Phase 3 — NSE note (`.data$` pronoun conversion)

Convert the ~470 flagged "no visible binding for global variable" symbols across `R/Repeatr_1.R` … `R/Repeatr_6.R`, `R/Repeatr_Updatr.R`, `R/compressr.R`, `R/diffr.R`, `R/export_fugazibase_data.R`, `R/rankr.R`, `R/recap.R`, `R/scrape_fls_data.R`, `R/scrape_fls_dtdd.R`, `R/nscmov.R`, `R/sets.R`, `R/stacks.R`, `R/sweepstack.R`, `R/note_*.R` to use `.data$col` (via `rlang::.data`) instead of bare column names inside `dplyr`/`tidyr` verbs (`mutate`, `filter`, `select`, `summarize`, `group_by`, etc.). Also handle the handful of base-R "no visible global function" hits (`read.csv`, `tail`, `write.csv`, `object.size` → qualify as `utils::`; `median`, `sd`, `reshape`, `runif`, `time`, `vcov`, `pnorm` → `stats::`; `title` → `graphics::`) by adding proper `@importFrom`/`Imports` entries rather than `.data$`.

Given the size (~15 files), do this file-by-file with a check-and-commit per file (or small group of related files) rather than one giant diff, so a regression is easy to bisect. Re-run `rcmdcheck::rcmdcheck()` after each batch to confirm the note's symbol list is shrinking and nothing else broke.

**Verification:** run `devtools::test()` / `testthat` suite after each file; run the full `data-raw/build_data.R` pipeline end-to-end at least once at the end of this phase (these functions are exactly what builds the package data, so a subtle `.data$` mistake would show up as wrong/missing columns); re-run `rcmdcheck::rcmdcheck()` for a final `0 notes`.

---

## Phase 4 — Shiny load-time / responsiveness

**Constraint (user-specified): all three `gsheet2tbl()` calls in `app.R` must stay live, runtime reads** — `fls_venue_geocoding` (line 44), `quizdata` (line 114), `linktracksindexdata` (line 275). This is intentional so sheet edits appear without redeploying. Everything else that doesn't depend on the fetched sheet content is fair game to precompute.

Traced `app.R` lines 22–289 line-by-line against what actually depends on the live sheets:

- **Lines 22–42** (`year_tour_release`, `fls_link_year_tour`, `transitions_data_da` re-join, `song_release`, `duration_data_da` re-join) — built entirely from package data (`Repeatr1`, `othervariables`, `shows_data`, `summary`, `transitions_data_da`, `duration_data_da`), **zero dependency on any live sheet**. Fully precomputable.
- **Lines 110–112** (`year_tour_gid_song`) — joins `duration_data_da`/`othervariables` and selects `year, tour, gid, title` only — doesn't touch coordinates, so it can be built from the raw (pre-live-join) `Repeatr::othervariables`. Precomputable.
- **Lines 140–198** (`discography`, `song_duration_seconds`, `releases_data_input`, `release_tempo_bpm_minutes`, `discography_tempo_bpm`, `releases_summary`, `gid_tempo_bpm_minutes`, `shows_tempo_bpm`, `gid_tempo_bpm`) — this whole tempo/discography chain is built purely from static package data (`Repeatr::summary`, `Repeatr::songvarslookup`, `Repeatr::releases_data_input`, `song_tempo_bpm_data`, `Repeatr::releases_summary`, `duration_data_da`) with **no live-sheet dependency at all**. This is the single biggest precompute win (~60 lines of joins/`group_by`+`summarise` collapsed to one lazy-loaded object).
- **Lines 46–95, 200–241** (the `othervariables`/`shows_data` coordinate join + Portland/Columbia/Croydon/Oxford/Newcastle disambiguation + gid-uniqueness safety net) — genuinely depends on the live `fls_venue_geocoding` fetch. **Must stay at runtime**, but it's cheap (a handful of `mutate`s + one join on a small sheet-sized table), so leave as-is.
- **Lines 97–108, 264–273** (`played_with`, `played_with_flat`, `today_data`) — downstream of the live-joined `othervariables`/`shows_data`, so must run after the fetch, but are themselves cheap selects/joins, not the bottleneck.

Plan:
1. Add a new precomputation step to `data-raw/build_data.R` (or a new sourced script) that builds and saves as `.rda` (lazy-loaded like everything else in `data/`) the objects identified above as sheet-independent: e.g. `year_tour_release`, `fls_link_year_tour`, `duration_data_da_with_release`, `year_tour_gid_song`, and the tempo/discography chain result (e.g. `shows_data_with_tempo` = `Repeatr::shows_data %>% left_join(gid_tempo_bpm)`, computed once at build time). These are **Shiny-presentation-only aggregates, not part of the fugazibase export** (`R/export_fugazibase_data.R`) — confirm and note in `Data-Provenance.Rmd` that they're derived/cached views, not new source-of-truth data, so no fugazibase changes are required for this phase.
2. Rewrite the corresponding block in `app.R` to just reference the precomputed object instead of recomputing it every app start.
3. **Lazy-load `quizdata` and `linktracksindexdata`.** Wrap each in a `reactive()`/`eventReactive()` triggered on first visit to its tab (e.g. `bindEvent(input$tabs == "quiz")` or an `observeEvent` on tab change with a "loaded" flag) instead of running at top level before `ui`/`server` exist. This doesn't change freshness — the fetch still happens live, just deferred until a user actually opens that tab, so a cold start doesn't pay for sheets nobody visits this session.
4. (Optional, smaller) Bundle the `font_google("Inconsolata")` font locally or fall back to a system font in `bs_theme()` to avoid a Google Fonts network round-trip on every app start.
5. (Optional, stretch — separate from load time, affects interaction responsiveness) Add `bindCache()` to the filter-driven reactives that currently recompute from scratch on every input change (no caching found anywhere in `app.R` today) — e.g. `shows_data2`/`shows_data3` around `app.R:1658-1726`, and the leaflet-bounds math duplicated between `renderLeaflet` (`:1730`) and an `observe` (`:1766`, worth deduplicating regardless of caching).

**Verification:** launch the app locally, time cold start before/after (e.g. wall-clock from `runApp()` to first paint); click through every tab and confirm identical output to a pre-change run (map markers/coordinates, quiz leaderboard, link-tracks index, recap downloads) — per `CLAUDE.md`, results must stay consistent with the current version; specifically verify that editing the live Google Sheets (or at least confirming the fetch still fires) still updates the app without a redeploy.

---

## General verification (every phase)

- `Rscript -e "rcmdcheck::rcmdcheck()"` (needs `RSTUDIO_PANDOC` env var pointed at a pandoc install, e.g. `C:\Program Files\RStudio\resources\app\bin\quarto\bin\tools`, since no standalone pandoc is on PATH) — confirm warning/note count is trending to 0.
- `devtools::test()` for the `testthat` suite.
- Launch `inst/shiny/Fugazetteer/app.R` locally and manually exercise every tab.
- Bump `Version:` in `DESCRIPTION` by a small increment once a phase's changes are complete, per `CLAUDE.md`.
- Write a session-notes file in `inst/notes/` (`YYYYMMDDHHMM_notes_*.md`) summarizing what changed and why for that phase.
- Keep `fugazibase` data export (`R/export_fugazibase_data.R`) and its downstream package consistent — none of Phases 1–4 change source data or exported columns, only packaging/import hygiene and Shiny-internal caching, so no fugazibase-side changes are expected, but re-confirm at the end of Phase 4 since that's the phase closest to data plumbing.
