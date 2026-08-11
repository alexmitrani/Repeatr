# Rename `fugazi.db` → `fugazibase`

## Context

`Repeatr` (this repo) is upstream of a companion data-only package that ships six tidy tables (`shows`, `locations`, `durations`, `discography`, `songs`, `bands`) derived from Repeatr's own cleaned data. That companion package's folder and GitHub remote have already been renamed from `fugazi.db` to `fugazibase` (confirmed: `C:\Users\alemi\Documents\GitHub\fugazibase`, remote `https://github.com/alexmitrani/fugazibase.git`), but nothing inside either package has been updated to match — `fugazibase`'s own `DESCRIPTION`/docs/vignette/README still say `fugazi.db` everywhere, and Repeatr's exported function, docs, vignettes, and build script still reference the old name and a `"../fugazi.db"` sibling-folder path.

A prior session (`Repeatr/inst/notes/202608100017_plan_fugazi-db-standalone-docs.md`) explicitly decided *not* to rename the package (dots are CRAN-legal). That decision is being deliberately reversed now per explicit instruction — not a mistake, just superseded.

**Confirmed with user:** the Repeatr-side function `export_fugazidb_data(fugazidb_dir = ...)` will also be renamed to `export_fugazibase_data(fugazibase_dir = ...)` for naming consistency, since Repeatr is still pre-1.0 (`0.0.0.9xxx`, never tagged/released) so there's no external contract to preserve, and every call site is already being touched to fix the path literal.

Goal: fully rename the package everywhere in both repos, get both passing `R CMD check`, bump both versions, and leave plan/session notes on disk.

## Tooling notes (verified this session)

- R 4.5.3 at `C:\Program Files\R\R-4.5.3\bin\x64\Rscript.exe` (not on PATH — invoke by full path).
- `devtools`, `roxygen2`, `rcmdcheck` are installed.
- Pandoc is not on PATH by default, but a working copy exists at `C:\Program Files\RStudio\resources\app\bin\quarto\bin\tools\pandoc.exe` (v3.8.3). Set `Sys.setenv(RSTUDIO_PANDOC = "C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools")` before running `devtools::document()`/`devtools::check()` so vignette rebuilding works non-interactively. This resolves the Pandoc blocker noted in earlier sessions.
- All `fugazi.db`/`fugazidb`-referencing code chunks in vignettes are `eval=FALSE` (illustrative only), so `R CMD check`'s vignette-knit step doesn't need a live sibling checkout or a specific install name.

## Version bumps (grounded in each repo's own history)

- **fugazibase**: `0.2.02` → **`0.2.03`** (plain patch bump per its own `0.MAJOR.PP` convention; this is a metadata-only change, no schema change).
- **Repeatr**: `0.0.0.9221` → **`0.0.0.9222`** (one bump for the whole rename change set, per its monotonic dev-counter convention — not per file).

## Phase A — `fugazibase` repo (`C:\Users\alemi\Documents\GitHub\fugazibase`)

1. **`DESCRIPTION`**: `Package: fugazi.db` → `fugazibase`; `Version:` → `0.2.03`; `URL:` → `https://github.com/alexmitrani/fugazibase`; `BugReports:` → `https://github.com/alexmitrani/fugazibase/issues`. Leave every other field as-is.
2. **`R/data.R`** (lines 1–12, the `"_PACKAGE"` roxygen block): replace the two `fugazi.db` mentions (package title line, and the `vignette(..., package = "fugazi.db")` reference) with `fugazibase`. Rest of file untouched.
3. **`vignettes/Data-Catalogue.Rmd`**: replace all 3 `fugazi.db` occurrences (2 prose, 1 `library(fugazi.db)` code chunk — chunk is `eval=FALSE`) with `fugazibase`.
4. **`README.md`**: replace all 7 occurrences (title, prose, both `remotes::install_github("alexmitrani/fugazi.db")` calls, `library(fugazi.db)`, the `vignette(..., package = "fugazi.db")` reference) with `fugazibase` equivalents.
5. **Rename file**: `fugazi.db.Rproj` → `fugazibase.Rproj` (contents are generic RStudio settings, no internal text change needed).
6. **Leave untouched**: `LICENSE`, `NAMESPACE` (only `import(lubridate)`), `.Rhistory` (gitignored scratch).
7. **Regenerate docs**: run `devtools::document()`. This produces `man/fugazibase-package.Rd` (roxygen names the package-doc file after `DESCRIPTION`'s `Package:`) and re-touches the 6 dataset `.Rd` files.
8. **Delete the stale file**: `man/fugazi.db-package.Rd` — `devtools::document()` does not delete files it no longer generates.
9. **Run `R CMD check`** — target 0 errors/warnings.

## Phase B — Repeatr repo (`C:\Users\alemi\Documents\GitHub\Repeatr`)

10. **`DESCRIPTION`**: bump `Version:` `0.0.0.9221` → `0.0.0.9222` (do this last, once all other edits are in place). No `Imports`/`Depends`/`Remotes` changes needed — Repeatr has no package dependency on fugazibase.
11. **`R/export_fugazidb_data.R`** — rename throughout: function `export_fugazidb_data` → `export_fugazibase_data`; parameter `fugazidb_dir` → `fugazibase_dir`. Replace all roxygen-prose and comment mentions of "fugazi.db" → "fugazibase". Rename the file itself to `R/export_fugazibase_data.R`.
12. **`R/data.R`** — in the 8 `@section Provenance` blocks that mention the companion package, replace "fugazi.db" → "fugazibase" and `\link{export_fugazidb_data}` → `\link{export_fugazibase_data}`.
13. **`R/Repeatr_1.R`** — update the 2 comments mentioning "fugazi.db's durations table" → "fugazibase's durations table".
14. **`data-raw/build_data.R`** — update all comment mentions of "fugazi.db" → "fugazibase", and the one executable line:
    `export_fugazidb_data(fugazidb_dir = "../fugazi.db")` → `export_fugazibase_data(fugazibase_dir = "../fugazibase")`.
15. **`vignettes/Data-Provenance.Rmd`** — update prose, the GitHub link, the ASCII pipeline diagram, and any `\link{export_fugazidb_data}` cross-refs.
16. **`vignettes/Rebuilding-the-Data.Rmd`** — update prose, section heading, the GitHub link, and the code chunk (chunk is `eval=FALSE`, must still stay textually correct).
17. **`README.md`** and **`index.md`** (identical sentence): update the `[fugazi.db](...)` link/name and `export_fugazidb_data()` → `export_fugazibase_data()`.
18. **Leave untouched**: `inst/notes/*.md` (historical session record); `_pkgdown.yml`/`.github/workflows/pkgdown.yaml` (no fugazi.db references); `.Rhistory` (gitignored); `tests/testthat/test-songid.R` (no references).
19. **Regenerate docs**: run `devtools::document()`. Auto-updates `NAMESPACE:14` and regenerates `man/export_fugazibase_data.Rd` plus every `.Rd` whose source doc block changed in step 12.
20. **Delete the stale file**: `man/export_fugazidb_data.Rd`.
21. **Run `R CMD check`** — target 0 errors.

## Exact R commands

```powershell
& "C:\Program Files\R\R-4.5.3\bin\x64\Rscript.exe" -e "Sys.setenv(RSTUDIO_PANDOC='C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools'); setwd('C:/Users/alemi/Documents/GitHub/fugazibase'); devtools::document(); devtools::check()"

& "C:\Program Files\R\R-4.5.3\bin\x64\Rscript.exe" -e "Sys.setenv(RSTUDIO_PANDOC='C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools'); setwd('C:/Users/alemi/Documents/GitHub/Repeatr'); devtools::document(); devtools::check()"
```

## Verification

1. `devtools::check()` on `fugazibase` → 0 errors, 0 warnings.
2. `devtools::check()` on Repeatr → 0 errors (pre-existing warning/note backlog acceptable, see notes file).
3. Repo-wide case-insensitive grep for `fugazi\.db|fugazidb` in both repos, excluding `inst/notes/`, `.Rhistory`, `.Rproj.user` → zero matches outside auto-generated `man/`/`NAMESPACE` (which regenerate clean).
4. Stale `.Rd` files deleted, new ones present.
5. `.Rproj` renamed.
6. `data-raw/build_data.R`'s call matches the new function signature exactly.
7. Version numbers bumped as above.
8. Changes left uncommitted in both repos for review.
