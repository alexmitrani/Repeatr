# Tidying up fugazi.db documentation

## Context

`fugazi.db` (`C:\Users\alemi\Documents\GitHub\fugazi.db`) is a **separate
sibling repository** to `Repeatr` (not nested inside it) — a data-only R
package with six lazy-loaded tables and no processing code of its own.
Right now its docs describe *how the data was built* by naming Repeatr's
internal objects and functions (`Repeatr::Repeatr_1()`,
`Repeatr::export_fugazidb_data()`, `othervariables`, etc.) and link to
Repeatr-only vignettes a standalone reader can't open. Ahead of wider use
(and a possible future CRAN submission), the user wants the package's own
docs to read as a self-contained, polished, beginner-friendly data package:
no Repeatr internals, clear crediting of Dischord Records/the Fugazi Live
Series as the primary data source, a first-timer-friendly install guide,
CRAN-conformant DESCRIPTION/LICENSE/Rd text, and WGS 84 (not "Google Maps
format") as the stated coordinate system.

Two substantive decisions were confirmed with the user before finalizing
this plan:
- **License gap**: the LICENSE file says Dischord Records' permission to
  redistribute the underlying show data is still pending. The user isn't
  submitting to CRAN until that's resolved — the point of this pass is to
  get the package as polished and ready as possible in the meantime, partly
  *because* a well-documented, professional-looking package is itself part
  of the case for asking Dischord Records for permission. Per the user's
  choice, this plan **fixes the LICENSE/DESCRIPTION file structure**
  (proper copyright-holder header, clear terms) while **honestly keeping
  the "pending" status** — it does not invent a license grant that doesn't
  exist. The plan's verification section flags this as an open blocker.
- **CRAN clear-cut fixes**: per the user's choice, this plan also fixes (not
  just reports) two CRAN issues found during research: a malformed
  `\title{}` in the `bands` Rd doc (title/description text run together
  across lines with no blank separator), and a `Description:` field that
  starts with the package name, which CRAN policy asks authors to avoid.

## Files to change (all in `C:\Users\alemi\Documents\GitHub\fugazi.db\`)

### `DESCRIPTION`
- Rewrite `Description:` as a single paragraph that doesn't start with the
  package name/"This package" (current text opens with `'fugazi.db' is a
  package of...`, which CRAN policy flags): lead with what the data *is*,
  then its primary source (Dischord Records/FLS, linked), then note
  LICENSE governs the underlying data's copyright status.
- Bump `Version: 0.1.5` → `0.1.6` (package-level DESCRIPTION/LICENSE content
  changed materially — consistent with this repo's existing convention of
  bumping on meaningful non-code changes, confirmed in prior session notes
  at `Repeatr/inst/notes/202608092207_notes_fugazi-db-tidy-rename.md`).
- Leave `License: file LICENSE`, `Authors@R`, `URL`, `BugReports`,
  `Encoding`, `Roxygen`, `RoxygenNote`, `LazyData`, `Depends`, `Imports`,
  `VignetteBuilder`, `Suggests` untouched — already correct.

### `LICENSE`
Restructure with an explicit copyright-holder/year header (the structural
element CRAN checks for in a `file LICENSE` package) and a clearer
"license terms" statement, while keeping the underlying facts unchanged
(source, "permission requested and pending", who to contact). Do not add
an SPDX license or dual-license the maintainer's own code — that's a real
licensing decision outside "fix format, flag substance," left to the user.

### `README.md` — full rewrite
Restructure top-to-bottom as: title/intro (data-only, no functions) →
**"Data source and copyright"** moved up right after the intro, crediting
Dischord Records/the Fugazi Live Series prominently as the primary source,
with the "permission pending" note and a `LICENSE` link → **"Installation"**
with two subsections: a quick `remotes::install_github()` snippet for
existing R users, and a numbered **"New to R?"** walkthrough for someone
computer-literate but new to R (download R from CRAN
[cran.r-project.org](https://cran.r-project.org/), download RStudio Desktop
from [posit.co/download/rstudio-desktop](https://posit.co/download/rstudio-desktop/),
open RStudio, install `remotes`, install `fugazi.db`, `library()` + try
`shows`) → **"What's here"** (the existing six-row table, `locations`' row
updated to say "WGS 84", a link to the public Fugazetteer Shiny app kept as
a plain URL with no mention of Repeatr, since it's independently useful
orientation for a standalone reader). All "companion package Repeatr..."
language and the `Repeatr::export_fugazidb_data()`/`vignette("Rebuilding-the-Data")`
sentence are removed — replaced with a plain "data is refreshed
periodically by the maintainer" note that doesn't name any internal tool.

### `R/data.R` (source of truth for all `man/*.Rd` files)
For every one of the six data doc blocks plus the package-level doc:
- Remove every `Repeatr::…()` / bare `Repeatr` / internal-object-name
  mention (`othervariables`, `fls_tags`, `releasesdatalookup`,
  `songvarslookup`, `played_with`, `Repeatr_1()`, `scrape_fls_shows()`,
  `export_fugazidb_data()`) from descriptions and `@section Provenance:`
  blocks.
- Where a Provenance note carries a genuinely useful caveat for a data
  consumer (e.g. `shows` only covers shows with resolvable tour/coordinates;
  `durations`' `gid` shouldn't be hand-re-parsed from the album tag; a
  handful of venues in `locations` are resolved outside this table), keep
  that caveat but reworded generically ("the package maintainer", no
  function/object names).
- Where a Provenance note is pure internal build trivia with nothing
  actionable for a reader (`discography`'s dropped `colour_code`/`variable`/
  `rym_rating` columns and synthetic rows; `songs`' column-rename history;
  `bands`' "trimmed to gid/played_with" detail) — drop the section entirely
  rather than generalize it into vague filler.
- `locations`: change `latitude`/`longitude` item descriptions from "the
  same coordinate format Google Maps displays" to "decimal degrees, using
  the WGS 84 datum"; remove "minus its Google-Maps-lookup helper columns"
  from Provenance.
- `bands`: insert the missing blank `#'` line between the title and
  description (currently one run-on block, producing a malformed multi-line
  `\title{}` in the generated Rd) — fixes both the CRAN issue and, as a
  side effect, the block being covered by this same rewrite anyway.
- Update the package-level `"_PACKAGE"` doc to name Dischord Records as the
  primary source, mirroring the new README wording.
- `@source` tags (Dischord/FLS URL, Wikipedia archive link, kid3 URL) are
  already correct and package/source-specific — leave unchanged.

### `vignettes/Data-Catalogue.Rmd`
- Introduction: remove the `[Repeatr](...)`'s `export_fugazidb_data()`
  sentence and the `vignette("Data-Provenance")` cross-reference (a
  Repeatr-only vignette unreachable from this package); replace with a
  generic "cleaned by the package maintainer... refreshed periodically"
  sentence, consistent with the README.
- `### country + city + venue` section: replace the
  `Repeatr::Repeatr_1()` sentence about hardcoded per-venue corrections with
  a generic "additional maintainer corrections" phrasing; add a one-line
  note that coordinates use the WGS 84 datum.
- Closing line: replace `Repeatr::export_fugazidb_data()`/
  `vignette("Rebuilding-the-Data")` with the same generic "refreshed
  periodically" phrasing used elsewhere, no tool names.
- Table-of-tables, `gid`/`song`/`releaseid` sections, and all code examples
  are already accurate and Repeatr-free — leave unchanged.

### `man/*.Rd` (regenerated, not hand-edited)
After `R/data.R` is rewritten, run `devtools::document()` (R at
`C:\Program Files\R\R-4.5.3\bin\Rscript.exe`, per prior sessions) to
regenerate `shows.Rd`, `locations.Rd`, `durations.Rd`, `discography.Rd`,
`songs.Rd`, `bands.Rd`, and `fugazi.db-package.Rd` from the new source.
Hand-editing these directly would just be overwritten and violates their
own "do not edit by hand" header.

## Not doing (flagged, not in scope)

- **Not resolving the Dischord Records permission status** — this is a
  real-world licensing negotiation, not a documentation fix; CRAN
  submission remains blocked until it's resolved regardless of how well
  the files are worded.
- **Not adding a `NEWS.md`** — good practice for a package with schema
  history, but not requested and not a hard CRAN requirement; noted here in
  case the user wants it in a future session.
- **Not renaming the package** (dots in `fugazi.db` are CRAN-allowed,
  `data.table` precedent) and **not touching `NAMESPACE`,
  `.Rbuildignore`, `fugazi.db.Rproj`** — nothing found there needs changing.
- **Not running a full `R CMD check --as-cran`** as part of this pass
  (Pandoc has been unavailable in this environment in past sessions, which
  blocks vignette-build checks) — `devtools::document()` plus a manual
  grep-based verification (below) is the check this plan performs; a full
  `check()` is recommended as a follow-up once Pandoc is available.

## Verification

1. After editing `R/data.R`, run `devtools::document()` and confirm all
   seven `man/*.Rd` files regenerate without new warnings.
2. Read the regenerated `bands.Rd` to confirm `\title{}` is now a single
   clean line (the CRAN-triggering bug is fixed).
3. Grep the whole `fugazi.db` repo (excluding `.git`) for `Repeatr` and
   `Google Maps` — expect zero matches outside this plan's own record of
   the change (i.e., truly zero in the package files).
4. Grep for `WGS` / `WGS 84` — expect matches in `R/data.R` (→ regenerated
   into `locations.Rd`), `README.md`, and `vignettes/Data-Catalogue.Rmd`.
5. Re-read the final `README.md` end-to-end as if a first-time R user,
   confirming the install sequence is complete and in the right order (R →
   RStudio → open RStudio → install `remotes` → install `fugazi.db` →
   `library()`), with working links to CRAN and Posit's RStudio download
   page.
6. Re-read `DESCRIPTION`'s `Description:` field to confirm it no longer
   opens with the package name and reads as one coherent paragraph.
7. Leave all changes **uncommitted** in the `fugazi.db` repo for the user
   to review, per this repo's established convention (confirmed in prior
   session notes) — do not commit or push.
