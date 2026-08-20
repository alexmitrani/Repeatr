# Session notes: issue #259 — distances between shows, data-driven tour classification

## What changed

`shows_data` gains three new columns, computed once in `Repeatr_1()` and
**not exported to fugazibase** (internal to Repeatr only):

- `distance_home_km` — great-circle distance (`geosphere::distGeo`) from the
  show to "home" (the earliest-dated show in the series — the Wilson Center,
  1987). Always populated.
- `distance_to_km` — distance traveled *to* this show: from the previous show
  if this show is part of the same tour chain as it, otherwise from home.
  Always populated.
- `distance_back_km` — distance traveled *back home* afterward. Populated
  only for a home-based show or the last stop of a tour chain.

`recap()` now always states a show's distance from home (appended to its own
location text) and, for shows classified as part of a tour chain, the
distance to the previous/next show.

## Why data-driven, not the `tour` field

An earlier draft of this plan classified "tour vs. regional" by
hand-correcting three mis-labeled values in the existing `tour` text field.
That was rejected during planning: the `tour` field's own tour/regional-dates
labelling isn't reliable enough to build a feature on. The final design
derives home-based/tour-chain classification purely from geography and
dates, via a new (internal, not exported) `classify_show_trips()` helper in
`R/recap.R`:

- A show within `home_radius_km` (default 200) of home is always treated as
  home-based, regardless of anything else - this specifically prevents
  Washington DC-area shows from getting spuriously strung into "tour chains"
  with each other (their mutual distance and their distance from home are
  both near zero, which is numerically unstable to compare directly).
- Otherwise, a show is linked to the chronologically previous show when it's
  geographically closer to that show than to home, and the gap between them
  is at most `max_gap_days` (default 21 - a loose sanity bound, not a strict
  "1-2 days" rule, since real tours sometimes pause for several days).
- A show linked to either neighbor is part of a tour chain; linked to
  neither is home-based.

The existing `tour` field is completely untouched by this feature - no
values were changed. It's used only as an independent sanity check (see
below), never as an input to the classification.

## Cross-check against the `tour` field

Comparing the new `is_tour` classification's majority vote against every
distinct `tour` value (76 total): only **one** mismatch - the
`1988 Winter Michigan Dates` group (3 shows, Ypsilanti/Lansing/Flint,
Jan 1988) - which is named as "...Dates" but classifies entirely as a tour
chain. This is exactly the case flagged by hand in the earlier (superseded)
draft of this plan as mis-labeled - the data-driven algorithm arrived at the
same conclusion independently, with zero special-casing, which is a good
sign the default parameters are reasonable.

Also specifically checked: the two Hollywood Palladium LA shows
(`los-angeles-ca-usa-12492`/`-12592`, Jan 24-25 1992), sitting inside the
large `1992 Winter/Spring Regional Dates` bucket, correctly classify as a
2-show tour chain (`is_tour = TRUE` for both) despite the bucket's name -
individual-show classification is independent of whatever bucket a show
happens to sit in. The San Francisco Mission Dolores Park show
(`san-francisco-ca-usa-60400`, a single very-far show with no shows nearby in
time) classifies as home-based, which is correct under the new philosophy:
it's a genuine "band flew out and back without joining it into a tour" case
(this is different from what the superseded draft's plan proposed - that
draft manually forced this into a "1-show tour", but the current, purely
data-driven design doesn't do manual overrides at all).

Every Washington DC-area show (67 total) classified `is_tour == FALSE`, as
did every show in a "Regional Dates"/"...Dates"-named bucket within 200km of
home (83 shows) - no adjustment to `home_radius_km` was needed.

No parameter changes were made from the plan's starting defaults
(`max_gap_days = 21`, `home_radius_km = 200`) - the cross-check came back
clean enough on the first rebuild that tuning wasn't necessary.

## A bug caught during verification: stale coordinates in the Shiny app

`inst/shiny/Fugazetteer/app.R` re-fetches venue coordinates live from a
Google Sheet at startup and overwrites `shows_data`'s `latitude`/`longitude`
columns, without touching `distance_home_km`/`distance_to_km`/
`distance_back_km`. If `recap()` had read those three columns directly from
the passed-in `shows_data`, the app could show a distance figure computed
from stale, pre-refresh coordinates whenever the live sheet had a location
correction since the last package rebuild.

Fixed by having `recap()` always recompute all three distance values fresh
via `classify_show_trips()`, using whatever `latitude`/`longitude` the passed
`shows_data` actually carries, rather than trusting persisted columns. Verified
with a throwaway script that moves one show's coordinates and confirms
`recap()`'s reported distance changes accordingly rather than showing the
old persisted value.

## Other implementation notes

- `recap()`'s "previous show"/"following show" clause was changed from being
  grouped by the `tour` field to strict chronological adjacency across the
  whole series (per an explicit decision during planning) - so it always
  names the actual nearest-in-date show. `tour_position`/`tour_total`/
  `tour_clause` ("show 14 of 24 of the 1988 Spring USA Tour") remain a
  separate, unchanged computation still grouped by `tour`.
- Distance from home is shown inline in the show's own location text (e.g.
  "Gilman Street, Berkeley, CA, USA (3914 km from home)"), not folded into
  `tour_clause`.
- `R/export_fugazibase_data.R` needed no changes - it already builds its
  `shows` table from `othervariables` (not `shows_data`) with an explicit
  `select()`, so the new columns were never at risk of leaking there, and
  the (untouched) `tour` field stays consistent between the two packages
  automatically.
- `man/shows_data.Rd` was regenerated via `devtools::document()` from the
  updated roxygen block in `R/data.R`; `vignettes/Data-Provenance.Rmd` and
  `vignettes/Fugazetteer.Rmd` were updated to describe the new columns and
  the geography/date-based classification method.
- Full data rebuild via `Repeatr_Updatr(really = "really")` completed
  without errors; only `data/shows_data.rda` changed (confirmed via `git
  diff --stat data/`) - no other dataset was affected, as expected.
- The Shiny app was launched locally and confirmed to start and serve its
  root page (HTTP 200) with the rebuilt data. Full interactive
  browser-driven verification of the recap tab's rendered HTML wasn't
  possible in this session (the Chrome automation extension wasn't
  connected) - confidence instead comes from the extensive direct
  `recap()`/`shows_data` checks above, since `app.R`'s recap tab does
  nothing more than render `recap()`'s returned `paragraph1`/`paragraph2`/
  `paragraph3` strings verbatim (confirmed by reading `app.R`'s server code).

## Follow-up fix: the edge test was asymmetric and missed "return leg" shows

After initial delivery, spot-checking the Oberlin, OH show
(`oberlin-oh-usa-50588`, 1988 Spring USA Tour, May 5 1988) turned up a real
bug in the classification rule. Oberlin sits 514km from home - nowhere near
`home_radius_km` - so it wasn't force-classified home-based by that override.
Instead it landed as `is_tour = FALSE` because the edge test to its *next*
show (Morgantown, WV, May 6) compared:

- `dist(Oberlin, Morgantown)` = 266.6km, against
- Morgantown's own `distance_home_km` = 263.9km alone

...missing by 2.7km (~1%). The original rule (`dist(prev, this) <
distance_home(this)`) only ever compared against the *arriving* show's own
distance from home, so it systematically missed "return leg" shows: a stop
that's closer to home than the previous stop was, but still much nearer to
that previous stop than a full round trip home would cost.

Fixed by comparing against the round-trip cost of the whole two-city leg
instead of just one city's distance from home:
`dist(prev, this) < distance_home(prev) + distance_home(this)`. For Oberlin:
is going home→Oberlin→Morgantown (514+267=781km) cheaper than a separate
round trip to Oberlin plus a separate trip to Morgantown
(514+514+264=1292km)? Yes, by a wide margin - now correctly linked.

Re-ran the full verification after this change:
- 11 shows across the whole series flip from `FALSE` to `TRUE` (none the
  other way) - all the same "return leg" pattern as Oberlin.
- The tour-field cross-check still comes back with only the same one
  mismatch (`1988 Winter Michigan Dates`) - no regressions introduced.
- DC-area shows are still 100% home-based (the `home_radius_km` override is
  independent of this change).
- The "home-based shows interrupting a named tour" analysis (see chat) drops
  from 10 to 8 interior-interruption shows across the same 5 named tours, as
  Oberlin and a similar 1989 Spring USA Tour case (Morgantown, WV again,
  `morgantown-wv-usa-42889`) both correctly reclassify as tour.

## Version

Bumped `0.0.0.9260` -> `0.0.0.9261` (initial delivery) -> `0.0.0.9262`
(edge-test fix above).
