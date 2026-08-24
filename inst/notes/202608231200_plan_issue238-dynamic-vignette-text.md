# Plan: Address issue #238 (stale hardcoded numbers in vignettes)

## Context

GitHub issue #238 ("update vignettes / articles - use dynamic text based
on data wherever possible so numbers don't go stale when data changes")
was triggered by a concrete bug: several vignettes say Fugazi played
"94 songs" that were performed live at least twice, but the actual
current count (`nrow(songidlookup)`, `nrow(fugazi_song_counts)`, etc.)
is 92. The root cause is that most of the essay/article vignettes type
dataset-derived numbers as literal prose text instead of computing them
from the package data, so every time the underlying data is
re-extracted/re-verified (new shows, corrected setlists, etc.) these
numbers silently drift out of sync with reality.

Two research passes (an Explore agent scanning every vignette for
hardcoded numeric claims, and a Plan agent that read the flagged files,
checked `R/data.R` for the authoritative meaning of each data object,
and ran live `Rscript` checks against current package data) confirmed
this is not an isolated typo: several essay vignettes contain counts
that have already drifted further since they were written (e.g. "Nice
New Outfit was played 114 times" is now 119; "Two Beats Off ... 371
times" is now 392), and `Fugazetteer.Rmd` documents the Fugazetteer
Shiny app with several stale worked-example numbers ("899 shows",
"9-12 show stacks", a "three Swedish shows" walkthrough that's now
four shows). `LinkTracks.Rmd` additionally has a real bug of the same
root cause: a `for(colindex in 2:94)` loop meant to cover all song
columns, now covering only 93 of the 139 columns that actually exist.

Decisions already confirmed with the user:
- **Maximal scope**: convert essentially every package-data-derived
  number across all vignettes to dynamic inline R, including in the
  personal-essay articles — but leave numbers that are genuinely not
  derivable from package data (personal anecdotes, quiz scores,
  historical/political facts, direct quotes, illustrative made-up
  examples) as static text.
- **README.md / index.md**: manual literal fix only (94→92). These are
  plain Markdown (not knitted), so true dynamic text isn't possible
  there without adding new build tooling (a README.Rmd + build step),
  which is out of scope for this pass.
- **Include all three related findings**: the LinkTracks.Rmd loop bug,
  the Fugazetteer.Rmd stale worked-example numbers (899/9-12/glueman
  25-131), and the Fugazetteer.Rmd "three Swedish shows" walkthrough
  rewrite (which changes the specific example numbers/framing, not
  just swaps a literal for a dynamic reference).

**Rendering behavior**: inline `` `r expression` `` in prose is
invisible in the knitted output — it renders as plain text exactly
like a hand-typed number, matching the convention already used in
`Ninety-Two-Songs.Rmd` and `CombinationLock.Rmd`. Converting hardcoded
numbers this way does **not** change the visual appearance of any
vignette. The one exception is the `LinkTracks.Rmd` loop-bound bug fix,
which could change which songs get correct cumulative counts in the
two `ggplot2` plots further down that same vignette (a genuine
correctness fix, not merely cosmetic) — this was called out to the
user explicitly and approved.

## Approach

Work vignette-by-vignette. For each hardcoded number:
1. Determine whether it's derivable from package data (check
   `R/data.R` roxygen docs to confirm the semantically correct source
   object — e.g. "songs played live at least twice" = `songidlookup`
   / `fugazi_song_counts` / `summary`, all 92 rows, since
   `min(songidlookup$count) == 2`).
2. If derivable and a chunk already computes the needed value nearby
   (the most common case — LinkTracks.Rmd, Ratings.Rmd), reference the
   existing variable inline instead of retyping the literal.
3. If derivable but no chunk computes it yet (Fugazetteer.Rmd has zero
   executed chunks today), add a small `include=FALSE` computation
   chunk near the paragraph and reference it inline.
4. If not derivable from package data (personal anecdotes, quotes,
   illustrative examples, statistical constants, a different artist's
   release info), leave the text unchanged.
5. Never wrap replacements in visible code chunks — always use inline
   `` `r ` `` in prose, or (only where the file already does this)
   extend an existing `cat(paste0(...))` chunk that has `echo=FALSE`.

### File-by-file changes

**`vignettes/CombinationLock.Rmd`**
- Line 196: replace the two literal `92`s with `` `r nrow(songidlookup)` ``.
- Line 255: "16 possible transitions" → `` `r nrow(checkvocals)^2` ``;
  "approximately 80%" → compute a `mp_proportion` value from the
  already-built `transitions_by_group`/`totaltransitions` objects and
  reference it inline (currently renders ~79%).
- Line 33 (illustrative "20 songs → 19 transitions" example): leave static.

**`vignettes/AllAccess.Rmd`**
- Line 32: keep "915 shows in 812 days" static (author's personal
  listening-project stats, not in package data); convert only the
  FLS0001/FLS1045 dates to `` `r format(min(shows_data$date))` `` /
  `` `r format(max(shows_data$date))` ``.
- Line 68 (primary bug): "all 94 songs" → `` all `r nrow(songidlookup)` songs``.
- Lines 44, 62, 88, 92, 120, 130, 134: leave static — verified not
  cleanly derivable from a single data object/filter (editorially
  curated lists, personal counts, quiz content, disk space).

**`vignettes/Fugazetteer.Rmd`** (currently has zero executed chunks —
add one small `include=FALSE` computation chunk after setup)
- Lines 49, 464, 484: "92 songs" (3x) → `` `r nrow(songidlookup)` ``.
- Lines 100/104: "792 weeks" → `` `r round(as.numeric(diff(range(shows_data$date)))/7)` `` (verified = 792, exact match today).
- Line 292: "25 shows" / "131 results" (glueman) → `` `r sum(transitions_data_da$title1=="glueman")` `` / `` `r sum(transitions_data_da$title2=="glueman")` `` (currently renders 32/145 — confirms this was already stale).
- Line 308: "three Swedish shows from the 2000 North European tour" → compute `swedish_2000_tour` dynamically via `shows_data` filter and reference `` `r nrow(swedish_2000_tour)` `` (currently 4, not 3).
- Line 314/316: rewrite the "sets" walkthrough to be generic over N shows using the exported `sets()` function fed `swedish_2000_tour$gid`, replacing the hardcoded 52/32/12/8/80 breakdown with dynamic references (numbers will change to reflect 4 shows, not 3 — this is the approved narrative rewrite).
- Line 322: "899 shows with set lists" → `` `r length(unique(gid_initial_gid_sound_quality$gid_initial))` `` (verified = 952); "9-12 shows" → dynamic min/max of per-stack size (verified range = 10-13); "94 songs" → `` `r nrow(songidlookup)` ``.
- Lines 29-35, 108, 334: app UI structure/parameter defaults, not data — leave static.
- Line 506 ("3 different link tracks"): no backing data object found for this curated index — leave static.

**`vignettes/LinkTracks.Rmd`**
- Line 49: "15000 people" → `` `r maxattendance` `` (already computed above).
- Line 93: tour attendance/duration numbers → reference existing `toursdata` rows for the two named tours (confirm exact tour label strings before editing).
- Line 124: Styrofoam/Foreman's Dog lag-day numbers → reference the already-computed `mysummary$lead` values for those songs.
- Line 147: "2 years / 360 days" → reference the existing `mean()`/`median()` lead-time chunk results.
- Lines 168/181: top-venue and overseas-venue numbers → reference the already-computed `venuesdata`/`overseas_venuesdata` tables.
- Line 201: extend the existing `cat(paste0(...))` pattern to interpolate `number_venues` and `overview_venuesdata$percentage` instead of retyping the literals (798/79.4%/12.7%/3.4%/2.3%/2.2%).
- Line 222: top-3 cities → `` `r venues_per_city$city[1]` ``, `[2]`, `[3]`.
- **Line 249 (bug fix)**: `for(colindex in 2:94)` → `for(colindex in 2:ncol(mydf_wide2))`.

**`vignettes/Ratings.Rmd`**
- Lines 96, 118: direct interview quotes — leave verbatim even though imprecise.
- Line 145: statistical constants (95% / 1.96) — leave static.
- Line 148 (bug fix, in R code not prose): `slice(seq(from=1, to=92, by=8))` → `slice(seq(from=1, to=nrow(summary), by=8))`.
- Lines ~31/69 chunk-output `nrow()` calls: already live/non-stale, no change needed.

**`vignettes/The-Argument.Rmd`**
- Add `library(dplyr)` to the setup chunk (matches convention used in the other essay vignettes).
- Line 29: "Six ... The other four songs" → compute `n_pre`/`n_post` from `summary %>% filter(release_title=="the argument")` split on a `recording_cutoff` date, referenced inline (verified: 6/4, matches the four named songs exactly).
- Line 37: "10 songs" → `` `r nrow(argument_songs)` ``; FLS0998/FLS1041 per-show counts → dynamic `Repeatr1` filters (verified 7 and 8 respectively).
- Line 41 ("over 25 years later"): leave static — a `Sys.Date()`-relative computation would only be accurate as of build time, not read time, so it doesn't actually solve the staleness problem and reads awkwardly.

**`vignettes/The-Emperors-New-Outfit.Rmd`**
- Line 63: "114 times" → `` `r fugazi_song_counts$count[fugazi_song_counts$title=="nice new outfit"]` `` (currently 119 — confirms drift).
- Lines 34, 51 ("3 years and 3 months, October 1987 to January 1991" / "19 days of January"): leave static — verified this does NOT match a clean `range()` filter (the real song-debut range ends April 1991; the prose implicitly excludes several later songs discussed separately), so a dynamic version would be fragile/misleading.

**`vignettes/polish-with-a-small-p.Rmd`**
- Same "3 years and 3 months" / "19 days of January" text as above — leave static, same rationale.
- Line 91 (unit conversion): leave static.

**`vignettes/au-clair-de-la-lune.Rmd`**
- Line 44: "371 times" → `` `r fugazi_song_counts$count[fugazi_song_counts$title=="two beats off"]` `` (currently 392); "109 times" (transition to Repeater) → dynamic `transitions_data_da` filter (currently 131). Date/venue text in the same sentence already matches current data exactly and can be made dynamic too for future-proofing, using the same pattern as `in-your-memory.Rmd` below.

**`vignettes/in-your-memory.Rmd`**
- Line 33: "6 songs from Red Medicine" → `` `r nrow(red_medicine_debuts)` `` from a named `releases_data_input` filter; "5 times in 1993" → dynamic `Repeatr1` filter (currently 6); "at least 10 times" (Fell, Destroyed instrumental) → dynamic filter on pre-vocals-debut performances (currently 14).
- Line 44: "201 times" → dynamic `fugazi_song_counts` lookup (currently 203); date/venue of last performance → dynamic, matches current data exactly; "Promises (31 times)" → dynamic `transitions_data_da` filter (currently 34); "Long Division (21 times)" → dynamic filter for future-proofing (currently still 21).
- "5th most played song from Red Medicine": **leave static**. Verified there is currently a tie at 203 plays between Forensic Scene and Birthday Pony, so a rank-based dynamic expression would silently and unreliably pick a winner depending on sort stability — safer to keep this specific claim as static prose than to make it confidently wrong.
- Line 182: "80 beats per minute" → `` `r song_tempo_bpm_data$tempo_bpm[song_tempo_bpm_data$title=="forensic scene"]` `` (exact match).
- Press-cutting quotes: leave verbatim.

**`vignettes/The-Tyranny-of-Distance.Rmd`**: no changes (all numbers concern a different artist's release, not Repeatr package data).

**`vignettes/Data-Provenance.Rmd`, `Rebuilding-the-Data.Rmd`, `Repeatr.Rmd`, `Outsiders.Rmd`, `Playlist.Rmd`, `Ninety-Two-Songs.Rmd`**: no changes needed (already dynamic, or no stale dataset claims found).

**`README.md` / `index.md`**: manual literal edit, "94 songs" → "92 songs" (both files, line 31). No other changes.

**`drafts/Head to Head.Rmd`**: out of scope (unbuilt draft with `XX` placeholders, not part of the built vignette set) — not touched.

### Housekeeping (per CLAUDE.md)
- Bump the package version by a small increment once these changes are complete.
- Write a session note to `./inst/notes/` (format `YYYYMMDDHHMM_notes_issue238-dynamic-vignette-text.md`) summarizing what changed and why, including the list of numbers found to have already drifted (a useful record given several were wrong independent of the original 94/92 report).
- No changes to `R/`, `data/`, or `R/export_fugazibase_data.R` are needed — this issue only touches vignette prose/chunks and two plain-Markdown files, so fugazibase data consistency is unaffected.

## Critical files
- `vignettes/Fugazetteer.Rmd` — needs new computation chunks added (currently has none); largest single set of changes.
- `vignettes/LinkTracks.Rmd` — wire existing computed variables into prose; includes the loop-bound bug fix at line 249.
- `vignettes/AllAccess.Rmd`, `vignettes/CombinationLock.Rmd`, `vignettes/Ratings.Rmd`, `vignettes/The-Argument.Rmd`, `vignettes/The-Emperors-New-Outfit.Rmd`, `vignettes/polish-with-a-small-p.Rmd`, `vignettes/au-clair-de-la-lune.Rmd`, `vignettes/in-your-memory.Rmd` — targeted per-line fixes as listed above.
- `README.md`, `index.md` — manual 94→92 text fix.
- Reference only, no edits: `R/data.R` (confirms correct source object per claim), `R/export_fugazibase_data.R` (confirms no fugazibase impact).

## Verification
1. Knit each changed vignette individually (`rmarkdown::render()` or `devtools::build_vignettes()`) and confirm no errors, and that computed values match the "verified" numbers noted above (e.g. `nrow(songidlookup)` renders 92, `LinkTracks.Rmd`'s venue sentence renders the same percentages as today since the underlying data hasn't changed).
2. Diff the knitted HTML output of each changed vignette against the current (pre-change) HTML for the parts noted as "text-only, same rendering" — confirm no visual/formatting drift, only the numbers that were actually wrong changed.
3. For `LinkTracks.Rmd`'s loop-bound fix specifically: compare the two `ggplot2` plots (line ~278 selection-of-songs plot, line ~298 "steady diet of nothing" release plot) before and after the fix to see whether any of the plotted songs' cumulative-count lines change shape — report this explicitly since it's the one change that isn't guaranteed visually identical.
4. Run `R CMD check` (or at minimum `devtools::document()` + a vignette build) to make sure nothing is broken package-wide.
5. Spot-check the Shiny app (`inst/shiny/Fugazetteer`) isn't affected — none of these changes touch `app.R` or shared data objects, so this should be a no-op, but confirm the app still launches per CLAUDE.md's "Shiny app continues to work" requirement.
6. Manually confirm README.md and index.md both now read "92 songs" and are otherwise unchanged.
