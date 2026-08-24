# Session notes: issue #238 — dynamic text in vignettes/articles

## What changed

Issue #238 was filed because several vignettes said Fugazi played "94
songs" that were performed live at least twice, when the actual current
figure is 92. Root cause: vignette prose hardcoded dataset-derived
numbers as literal text instead of computing them from package data, so
the numbers silently drift whenever the underlying data changes.

Confirmed via `Rscript` that `songidlookup`/`fugazi_song_counts`/
`summary`/`altlookup`/`songvarslookup` (all 92 rows) are exactly the set
of `tracktype==1` songs played live at least twice — i.e. 92 is the
correct current figure everywhere "songs played at least twice" is
mentioned. `Fugazetteer.Rmd` used to explain this as "92 discography
songs + two unreleased songs (Preprovisional, World Beat) = 94", but
those two are now `tracktype==2` ("other music"/unreleased), so they no
longer count toward the twice-played total under the same methodology
used everywhere else — that sentence was rewritten rather than just
having its number swapped (see below). A prior same-day session
(`202608230144_notes_issue232-untitled-tracktype2.md`) had already
touched this exact paragraph for an unrelated reason (Details/Search
scope) but left the underlying 92-vs-94 inconsistency across vignettes
unresolved, which is what this issue asked to fix.

Per user decision, scope was "maximal": convert essentially every
package-data-derived number across all 17 vignettes (including the
personal-essay articles) to dynamic inline R (`` `r expression` `` in
prose — the pattern already used in `Ninety-Two-Songs.Rmd` and
`CombinationLock.Rmd`), while leaving numbers that aren't derivable from
package data (personal anecdotes, quiz scores, historical facts, direct
quotes, illustrative examples) as static text. `README.md`/`index.md`
(plain Markdown, not knitted) got a manual "94→92" text fix only, since
true dynamic text there would need a new `README.Rmd` build step, which
was explicitly out of scope.

### A bigger finding than expected

Verifying each hardcoded number against live data (not just fixing
94→92) turned up a lot more drift than the issue reported — evidence
that the whole "hardcode a count in prose" pattern was the real problem:

- `LinkTracks.Rmd` had a **real bug**, not just stale prose: a
  `for(colindex in 2:94)` loop meant to cumsum every song column, but
  `Repeatr1` now has 139 distinct titles, so columns 95-139 were
  silently skipped. Fixed to `2:ncol(mydf_wide2)`.
- `Fugazetteer.Rmd`'s worked examples were stale: "899 shows with set
  lists" (now 952), "9-12 show stacks" (now 10-13), "glueman" from/to
  search counts 25/131 (now 32/145), and "three Swedish shows from the
  2000 tour" (now four — `jonkoping-sweden-100600` was added since the
  vignette was written). The "sets" walkthrough paragraph was rewritten
  to work generically for any number of compared shows rather than
  re-hardcoding for 3 vs 4.
- Essay vignettes had several drifted play/transition counts: Nice New
  Outfit 114→119, Two Beats Off 371→392, Two Beats Off→Repeater
  109→131, Forensic Scene 201→203, Forensic Scene→Promises 31→34,
  "By You" 1993 plays 5→6, "Fell, Destroyed" pre-vocals plays 10→14.
- `LinkTracks.Rmd`'s venue section had drifted further than just
  percentages: "Fort Reno and the 9:30 club... 2 venues with more than
  10 shows" is no longer true (only Fort Reno has >10 shows now; 9:30
  Club has 8) — rewritten generically rather than just updating numbers
  in the old sentence shape.

### Deliberately left static (verified NOT to cleanly derive)

- `The-Emperors-New-Outfit.Rmd` / `polish-with-a-small-p.Rmd`: "3 years
  and 3 months, October 1987 to January 1991" — the real
  `releases_data_input` date range for that album ends April 1991; the
  prose implicitly excludes several later-arriving songs discussed
  separately, so a single clean filter isn't safe to construct.
- `in-your-memory.Rmd`: "5th most played song from Red Medicine" —
  there is currently a tie at 203 plays with Birthday Pony, so a
  rank-based dynamic expression would silently pick an arbitrary winner
  depending on sort stability. Also left "one of 6 songs... launched on
  that 1994 tour of Brazil" static — a naive `release_title=="red
  medicine"` filter returns all 13 album tracks, not the 6-song subset
  specific to that tour leg, and correctly reconstructing that subset
  (accounting for instrumental vs. vocal debut dates) isn't safe to
  automate confidently.
- `The-Argument.Rmd`: "over 25 years later" — a `Sys.Date()`-relative
  computation would only be accurate as of package build time, not
  read time, so it wouldn't actually fix the staleness problem.
- Direct interview/press quotes (`Ratings.Rmd`, `in-your-memory.Rmd`)
  left verbatim even where now numerically imprecise ("over 100 songs").
- `The-Tyranny-of-Distance.Rmd`: no changes — all numbers concern a
  different artist's release, not Repeatr package data.
- `drafts/Head to Head.Rmd`: out of scope — unbuilt draft with `XX`
  placeholders, not part of the built vignette set.

## Files changed

- `vignettes/CombinationLock.Rmd`, `AllAccess.Rmd`, `LinkTracks.Rmd`,
  `Ratings.Rmd`, `The-Argument.Rmd`, `The-Emperors-New-Outfit.Rmd`,
  `au-clair-de-la-lune.Rmd`, `in-your-memory.Rmd` — targeted hardcoded
  numbers converted to inline `` `r ` `` referencing package data or
  already-computed chunk variables.
- `vignettes/Fugazetteer.Rmd` — added its first real computation chunk
  (previously had none) computing the values several paragraphs need;
  rewrote the "sets" walkthrough generically.
- `README.md`, `index.md` — manual "94 songs" → "92 songs" text fix.
- `polish-with-a-small-p.Rmd` — no changes needed (see "left static").
- No changes to `R/`, `data/`, or `R/export_fugazibase_data.R` — this
  only touches vignette prose/chunks and two plain-Markdown files, so
  fugazibase data consistency is unaffected.

## Verification

- Rendered every changed `.Rmd` individually with `rmarkdown::render()`
  (RStudio's bundled pandoc via `RSTUDIO_PANDOC`) — all 9 knit cleanly
  with no errors.
- Extracted and read the rendered prose from each output HTML to
  confirm the dynamic sentences read naturally and the numbers match
  what live `Rscript` checks against current package data predicted.
- Confirmed via `LinkTracks.html` that the loop-bound fix executes
  without error and both `ggplot2` plots in that vignette still render.
- Did not run `R CMD check` or launch the Shiny app for this session —
  no changes were made to `R/`, `data/`, or `app.R`, so both are
  expected to be unaffected; flagging this as unverified-by-me if the
  user wants an explicit check before merging.

## Version

Bumped `DESCRIPTION` from `0.0.0.9274` to `0.0.0.9275`.
