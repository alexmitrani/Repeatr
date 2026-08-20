# Plan: Issue #259 — distances (km) between shows, data-driven tour/home-based classification

## Context

GitHub issue #259 asks the "recap" tab (`R/recap.R`) to show the great-circle
distance in km between a show and its previous/next show, and from "home" (the
Wilson Center, venue of the first-ever 1987 Fugazi show), but only for shows
that were genuinely part of a touring trip — not for one-off shows the band
reached from home and returned from the same way.

**This plan supersedes an earlier draft**, which classified "tour vs.
regional" by correcting mis-labeled values in the `tour` text field. That
approach was rejected: the `tour` field's own tour/regional-dates
distinctions "don't seem very reliable" and must not be relied on. Instead,
whether a show was reached as a home-based trip or as part of a moving tour is
**derived purely from geography and dates** (show coordinates, distance
from home, distance to/from neighboring shows, and the calendar gap between
them) — computed once during the data build. The existing `tour` field is left
completely untouched; it's used only as an after-the-fact sanity check against
the new classification, never as an input to it.

## Classification algorithm

Computed once in `Repeatr_1()`, on `shows_data` sorted by `date`, with
`home_lat`/`home_lon` = the coordinates of the earliest-dated show (Wilson
Center, 1987).

For every show `i` (in chronological order), first compute (transiently, not
persisted):
- `distance_home_km[i]` = great-circle distance from show `i` to home.
- `dist_to_prev_km[i]` = great-circle distance from show `i-1` to show `i`
  (`NA` for the first show ever).
- `days_since_prev[i]` = `date[i] - date[i-1]` (`NA` for the first show).

**Home-radius override** — a show within easy day-trip range of home is
always home-based, full stop, regardless of what the edge test below would
say:
```
near_home[i] <- distance_home_km[i] <= home_radius_km
```
This matters because without it, two shows that are both close to home (e.g.
two Washington DC-area shows a few days apart, or a DC show followed by a
nearby regional date) can end up geographically closer to *each other* than
either is to home in the strict sense the edge test uses below — which would
wrongly string them into a "tour chain" even though neither involved the band
leaving home for more than a day. It's also numerically fragile right at
home itself: two DC shows have `dist_to_prev_km` and `distance_home_km` both
≈ 0, so which is technically smaller can flip on rounding alone. Starting
default: **`home_radius_km = 200`** (roughly the range of a there-and-back
same-day drive with equipment — e.g. DC to Richmond or Philadelphia).

**Edge test** — was show `i` more plausibly reached directly from the previous
show than from a return trip home first? Only asked at all when *neither*
show is a near-home day trip:
```
linked_to_prev[i] <- !is.na(dist_to_prev_km[i]) &
  !near_home[i] & !near_home[i-1] &
  dist_to_prev_km[i] < distance_home_km[i] &
  days_since_prev[i] <= max_gap_days
```
Starting default `max_gap_days = 21` (a loose sanity bound, not a tight "1-2
days" rule — real tours sometimes pause for several days).

`linked_to_next[i] <- linked_to_prev[i+1]` (the same edge, other side).
`is_tour[i] <- linked_to_prev[i] | linked_to_next[i]`.

## The three persisted columns

Added to `shows_data` in `Repeatr_1()`, not exported to fugazibase:
- **`distance_home_km`** — always populated.
- **`distance_to_km`** — always populated: distance from the previous show if
  linked, else `distance_home_km`.
- **`distance_back_km`** — populated only for a home-based show or a tour
  chain's last stop, else `NA`.

No 4th classification column is persisted — `is_tour`/`linked_to_prev`/
`linked_to_next` are recomputed on demand by the shared `classify_show_trips()`
helper (`R/recap.R`), reused by the data build, `recap()`, and verification.

## Implementation

1. `DESCRIPTION`: add `geosphere` to `Depends:`.
2. `R/recap.R`: new helpers `distance_km_vec()` and `classify_show_trips()`.
3. `R/Repeatr_1.R`: compute and persist the 3 columns after `shows_data` is
   fully assembled/deduped, before `save(shows_data, ...)`.
4. `R/recap.R`:
   - Distance from home appended to `where_played` for every show.
   - Previous/next-show clause switched from `group_by(tour)` to strict
     chronological adjacency; `tour_position`/`tour_total`/`tour_clause`
     stay a separate, unchanged computation still grouped by `tour`.
   - `describe_other_show()` gains a `distance_km` param, shown only when
     the neighbor is tour-linked to this show.
   - `context` list gains `is_tour`, `distance_home_km`, `distance_to_km`,
     `distance_back_km`.
5. `man/shows_data.Rd` / `R/data.R` / `vignettes/Data-Provenance.Rmd`:
   document the three columns and the classification method.
6. `vignettes/Fugazetteer.Rmd`: extend the `## recap` section.
7. `R/export_fugazibase_data.R`: no changes (already builds `shows` from
   `othervariables` with an explicit `select()`, not `shows_data`).
8. Version bump.
9. Session notes (this file's companion `_notes_` file).

## Verification

1. Rebuild via `Repeatr_Updatr(really = 'really')`.
2. Cross-check `is_tour` against the `tour` field, including a specific
   check that every Washington DC-area show lands `is_tour == FALSE`.
3. Inspect boundary cases (home-based round trip, first/last/interior tour
   stops).
4. Total-distance sums (per tour chain, all home-based shows, whole series).
5. `recap()` spot checks, including the May 1988 Berkeley show example.
6. Launch the Shiny app locally and check the recap tab.
