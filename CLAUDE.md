# Repeatr project notes

- R package including Shiny app
- R code is in `./R`
- .rda files are in `./data`
- the Shiny app is in `./inst/shiny`. 
- vignettes are in `./vignettes`
- a note on data provenance is in `./vignettes/Data-Provenance.Rmd`
- a script for re-building all the data files is in `./data-raw`
- there is an external package called fugazibase that contains data files shared with Repeatr, the data for fugazibase is exported using `./R/export_fugazibase_data.R`. Changes to the data should be made upstream of this point so the data used by both packages stays consistent. 
- it is important that whatever is exported to fugazibase is also consistent with the data used in Repeatr
- when making changes, make sure the documentation stays up to date both in Repeatr and in fugazibase
- when making changes, make sure the Shiny app continues to work and produces consistent results with the initial version, unless differences are expected
- when making changes, make sure that the data in fugazibase and the data in Repeatr stay consistent - changes to the data used by one package should affect the other package. 
- bump version by a small increment every time implementation of changes is completed (should be once per work session unless no changes are made). 

# Session notes

Keep a written summary/record of each work session (what changed, why,
key decisions), save it as a markdown file in `./inst/notes`, named
`YYYYMMDDHHMM_notes_short-description.md` (e.g.
`202607312024_notes_myshortdescription.md`). The timestamp prefix keeps
multiple session notes sorting in chronological order in a plain file listing.

# Plans

Save copies of plans in the same folder as the session notes (`./inst/notes`) but with 
a slightly different naming convention so that the session notes and the plans 
can be distinguished from each other: 
`YYYYMMDDHHMM_plan_short-description.md` (e.g.
`202607311323_plan_myshortdescription.md`).

