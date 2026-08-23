# Plan: Issue #232 — keep "untitled" performances as tracktype 2, surface them in stock | details and stock | search

## Context

GitHub issue #232 ("find a way to keep as many as possible of the original track names"):

> change song titles including "untitled" to tracktype=2 (at present these have tracktype=0)
>
> in the Shiny app, include songs that have tracktype=2 in stock | details and stock | search. that includes the "song" select box only for these tabs.
>
> make sure this doesn't interfere with the functionality of stock | discography or stock | variation.

Today, any track whose title contains "untitled" is classified `tracktype = 0` — the same bucket as soundchecks, intros, interludes, encores, crowd noise, etc. — so it's treated as "not a song" and discarded from every song-level view. The package already has a `tracktype = 2` ("unreleased songs") bucket for exactly this kind of case: ~17 one-off/unreleased tracks (e.g. "heart on my chest", "lock dug") are already explicitly reclassified from 1 to 2 in `R/Repeatr_1.R`, and stay visible as real songs, just excluded from the choice-model/discography-eligible set. Moving "untitled" into that same bucket keeps the original track names/performances instead of erasing them, and the issue asks that Details/Search (song browsing tools) expose them while Discography/Variation (built around the release-eligible/choice-model song set) stay exactly as they are today.

Clarified with the user: no special-casing needed in `R/recap.R`'s rare-track narrative — once "untitled" is tracktype 2, it should flow into `note_rare_tracks()` exactly like any other tracktype-2 song, with no code change there.

## Key existing facts (verified in code)

- `tracktype` meaning (`R/Repeatr_1.R:808-811`): `0` = soundchecks/intros/interludes/encores, `1` = released songs, `2` = unreleased songs. The `R/data.R:90` roxygen dictionary entry (`{0 = interlude, 1 = song, 2 = other music}`) is already stale relative to this and should be corrected as part of this change.
- The "untitled" rule lives in two near-duplicate `grepl()` classification passes in `R/Repeatr_1.R`:
  - `R/Repeatr_1.R:722` — `raw_fls_song_list` (confirmed unused outside `R/Repeatr_1.R`; keep it consistent anyway, per the issue's own wording).
  - `R/Repeatr_1.R:846` — the main `Repeatr1$tracktype` pass. This is the one that matters; sits right above the existing tracktype-2 block (`R/Repeatr_1.R:850-896`) that already reclassifies other one-off/unreleased titles from 1 → 2.
- Every downstream table that feeds `songidlookup`, Discography, and Variation filters on `tracktype==1` specifically (not `tracktype!=0`): `songidlookup` (`R/Repeatr_1.R:900-901`), `cumulative_duration_counts`/`cumulative_position_counts` (`R/Repeatr_1.R:1087-1088, 1133-1139, 1697-1701`), `duration_summary`/`position_summary` (built from `duration_data_da`, `R/Repeatr_1.R:1640-1641, 1703-1738`), and the whole `Repeatr_2`→`Repeatr_5` choice-model/discography chain. **Because these already key off `tracktype==1` and not `tracktype!=0`, simply moving "untitled" from 0 to 2 is a no-op for all of them — Discography and Variation are automatically unaffected**, since tracktype 2 was already excluded by every one of these filters before this change (the ~17 existing tracktype-2 songs already prove this).
- Details/Search currently source from the *same* `tracktype==1`-only objects: their song-select boxes (`app.R:3746-3760` details, `app.R:3831-3845` search) both read `cumulative_duration_counts$title` — the exact same object Variation's song-select (`app.R:3579-3593`) uses — and their row data (`details_data` `app.R:3763-3782`, `search_shows_data` `app.R:3847-3889`) both read `duration_data_da`, which is also consumed as-is by Recap (`R/recap.R:665`) and Stacks (`R/sweepstack.R`, `R/stacks.R`, `R/Repeatr_6.R`). **This means reclassifying "untitled" alone does not make it appear in Details/Search either** — new, separate data plumbing is needed so Details/Search can read a `tracktype %in% c(1,2)` song list/row-set without touching the shared `tracktype==1` objects Variation, Discography, Recap, and Stacks depend on.
- `tracktype` is not exported to fugazibase (`R/export_fugazibase_data.R` explicitly excludes `Repeatr1`/`songidlookup`-derived data; the `songs` table comes from `songvarslookup`, Wikipedia-sourced, not from `Repeatr1`). No fugazibase export changes are needed, but this should be noted in session notes per the project's data-consistency guidance.
- The shared `Input_releases` filter at the top of the "stock" tabset (`app.R:963-965`) is populated from `releases_menu_list` (real album/EP titles only, `R/Repeatr_1.R:1332-1336`) — "unreleased" is never a selectable option there, it's only an internal label `cumulative_duration_counts` uses for `NA` release titles (`R/Repeatr_1.R:1135`). So tracktype-2 "untitled" songs will behave exactly like today's other tracktype-2/unreleased songs under that filter: visible when no release filter is applied, filtered out when a specific release is selected — no special-casing needed there.

## Implementation

### 1. Data reclassification — `R/Repeatr_1.R`

- Remove the "untitled" rule from the tracktype-0 block at both `R/Repeatr_1.R:722` (`raw_fls_song_list`) and `R/Repeatr_1.R:846` (main `Repeatr1` pass).
- Add an equivalent `grepl("untitled", .data$title)` rule to the existing tracktype-2 block (`R/Repeatr_1.R:850-896`), matching the style of the other one-off entries there (e.g. lines 851, 854).
- No change needed to `songidlookup`'s construction (`R/Repeatr_1.R:900-925`) — it stays `tracktype==1`-only by design (per the `songid` comment at lines 906-916 and `tests/testthat/test-songid.R:24-30`), so untitled/tracktype-2 songs correctly still don't get a `songid`, same as the other 17 existing tracktype-2 titles.

### 2. New tracktype-1-and-2 data path for Details/Search only

Add a package data object parallel to `duration_data_da` but including tracktype 2, without touching `duration_data_da` itself (Recap, Stacks, Variation's `duration_summary`/`position_summary` all keep reading the original, unchanged object).

- In `R/Repeatr_1.R`, factor the `duration_data_da` construction (currently `R/Repeatr_1.R:1640-1675`, the `filter(.data$tracktype==1)` → `occurrence`/`position` build) into a small internal helper taking the tracktype filter as a parameter, and call it twice:
  - `duration_data_da <- ...(tracktype_values = 1)` — existing object, byte-identical output.
  - `duration_data_da_song <- ...(tracktype_values = c(1, 2))` — new object, same shape, `save(duration_data_da_song, file = "duration_data_da_song.rda")`.
- Document the new object in `R/data.R`, mirroring `duration_data_da`'s existing roxygen entry, noting it additionally includes tracktype-2 (unreleased/one-off, including "untitled") performances and is intended for Details/Search's broader song-browsing use.
- In `R/build_shiny_precompute.R`, add `shiny_duration_data_da_song <- Repeatr::duration_data_da_song %>% left_join(song_release)` (mirroring lines 49-50) and `save(shiny_duration_data_da_song, file = file.path(mydatadir, "shiny_duration_data_da_song.rda"))` (mirroring line 123). Update the function's own roxygen `@description` list of precomputed objects if it enumerates them.

No changes needed to `data-raw/build_data.R` — `Repeatr_Updatr()` and `build_shiny_precompute()` already pick up any new `save()` calls automatically.

### 3. Shiny app — `inst/shiny/Fugazetteer/app.R`

- Near line 46 (alongside `duration_data_da <- shiny_duration_data_da`), add `duration_data_da_song <- shiny_duration_data_da_song`.
- `output$menuOptions_details_song` (`app.R:3746-3760`) and `output$menuOptions_search_songs` (`app.R:3831-3845`): build `menudata` from `duration_data_da_song` (distinct `title`/`release_title`, with the same `NA → "unreleased"` coalescing `cumulative_duration_counts` uses at `R/Repeatr_1.R:1135`, for consistent behavior under the shared `Input_releases` filter) instead of `cumulative_duration_counts`.
- `details_data` (`app.R:3763-3782`) and `search_shows_data` (`app.R:3847-3889`): filter `duration_data_da_song` instead of `duration_data_da`.
- Leave everything else untouched: Variation (`app.R:3579-3740`) keeps using `cumulative_duration_counts`/`cumulative_position_counts`/`duration_summary`/`position_summary`; Discography (`app.R:3377-3574`) keeps using `releases_data_input`/`releases_summary`, which never reference `tracktype` at all; Recap and Stacks keep reading the original `duration_data_da`.

### 4. Documentation

- Fix the stale `R/data.R:90` dictionary line (`{0 = interlude, 1 = song, 2 = other music}`) to match the accurate in-code comment at `R/Repeatr_1.R:808-811` (0 = soundchecks/intros/interludes/encores, 1 = released songs, 2 = unreleased songs).
- Add the new `duration_data_da_song` roxygen doc block per step 2.
- No changes needed to `vignettes/Data-Provenance.Rmd`'s tier definitions (the "Derived-classified" description already generically covers `tracktype` rule changes) — don't add change-specific narrative there, per this project's existing convention of keeping docs state-only, not historical.

## Verification

1. Rebuild: run stage B of `data-raw/build_data.R` (`Repeatr_Updatr(really = "really", update_stacks = TRUE)` then `build_shiny_precompute()`) to regenerate `Repeatr1.rda`, `songidlookup.rda`, the new `duration_data_da_song.rda`/`shiny_duration_data_da_song.rda`, and confirm `duration_data_da.rda`/`cumulative_duration_counts.rda`/`cumulative_position_counts.rda`/`songidlookup.rda` are otherwise unchanged (diff row counts before/after — they should only lose the reclassified "untitled" rows, which they already excluded from `tracktype==1` views since those rows only ever mattered for tracktype 0's separate consumers, e.g. `R/recap.R:494`'s soundcheck detection — confirm no "untitled" titles were relied on there).
2. `devtools::document()` to regenerate `.Rd` files for the new data object and the corrected `Repeatr1` dictionary entry; `devtools::check()` / run the `testthat` suite, in particular `tests/testthat/test-songid.R` (its comment describing tracktype 0/2 exclusion from `songidlookup` should stay accurate — no assertion changes expected).
3. Run the Shiny app (`shiny::runApp("inst/shiny/Fugazetteer")` or the `run` skill) and check:
   - stock | details: song select box now includes "untitled" (and the existing 17 tracktype-2 titles); selecting it returns rows with correct dates/links.
   - stock | search: same song select box behavior; searching by an untitled/tracktype-2 song returns the right shows.
   - stock | variation: song select box does **not** include "untitled" or any tracktype-2 title — unchanged from current behavior.
   - stock | discography: unaffected (no tracktype dependency at all).
   - flow | recap: open a show with an "untitled" performance and confirm the rare-track sentence names it like any other rare tracktype-2 song, with no errors.
4. Confirm `R/export_fugazibase_data.R` needs no changes (tracktype/`Repeatr1`/`songidlookup` are already excluded from the export) and note this explicitly in the session notes for data-consistency traceability.
5. Bump the package version and write session notes to `./inst/notes/` per this project's conventions once implementation is complete.

## Outcome (see session notes)

Implemented as planned, with one deviation discovered during verification:
the source data currently contains zero tracks literally titled
"untitled" (confirmed with the user this is expected — the rule
future-proofs for tags not yet re-exported into `inst/extdata/`).
Verification therefore exercised the identical code path via the
pre-existing tracktype-2 songs. Full details in
`202608230144_notes_issue232-untitled-tracktype2.md`.
