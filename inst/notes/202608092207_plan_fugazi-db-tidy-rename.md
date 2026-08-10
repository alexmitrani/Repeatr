# Tidy up fugazi.db: rename tables, split doorprice, rename coordinates

## Context

`fugazi.db` (`C:\Users\alemi\Documents\GitHub\fugazi.db`) is a data-only package generated entirely by Repeatr's `export_fugazidb_data()` (`C:\Users\alemi\Documents\GitHub\Repeatr\R\export_fugazidb_data.R`) — it has no processing code of its own, only roxygen docs, README, vignette, DESCRIPTION. The user wants several tidiness improvements ahead of wider use of the package: clearer table names (including swapping the meaning of `discography`/`releases` to match what those words actually describe), a proper numeric price/currency split (the current `doorprice` is raw, unparsed scrape text), clearer coordinate-column names, and documentation kept in sync in both repos.

**Verified against the actual data** (loaded `data/othervariables.rda` and `inst/extdata/fls_venue_geocoding_v2.csv` directly): `doorprice` has 58 distinct non-blank raw values across 700 of 1049 shows (349 blank/`NA`). Every value maps unambiguously to one currency once its country is known — full mapping built and verified below, including the one price range (`"3-5Pounds"`, 10 UK shows on the May 1992 tour, not the "4-6 pounds" in the request — confirmed against real data, user agreed to use the real value: price 4, GBP) and two shows in Yugoslavia (1990) priced in Deutsche Mark (`"12 Marks"`, `"15 Marks"`) rather than the Yugoslav dinar — a genuine case of "currency in the text points to something not obvious from the country," kept per the user's own instruction. `x`/`y` in the venue data are already clean decimal-degree numerics (e.g. `x=-58.377627, y=-34.60465` for Buenos Aires) — the same format Google Maps displays coordinates in, just not commonly called that.

Decisions confirmed with the user:
- Barrowland/UK-tour range: use the real raw value `"3-5Pounds"` → price `4`, currency `GBP` (not 5).
- The `bands` table's `played_with` column is renamed to `band` (avoids a table called "bands" having a column called "played_with").
- The current song-level table (`discography`) is renamed `songs`, and the current release-level table (`releases`) is renamed `discography` — so `discography` now means what it says (per-release metadata), and `songs` holds the per-song data.
- `fugazi.db`'s `DESCRIPTION` version bumps `0.1.4` → `0.1.5`, consistent with past schema-change sessions.
- `price` is numeric (not integer) — some raw values are non-integer (e.g. `"$1.99"`, `"12.50DM"`).

## Renames (table = file = lazy-loaded object name, since `write_table()` saves both under the same name)

| Old | New |
|---|---|
| `fls_shows` | `shows` |
| `fls_tags` | `durations` |
| `fls_venue_geocoding` | `locations` |
| `played_with` | `bands` (its `played_with` column → `band`) |
| `discography` (song-level table) | `songs` |
| `releases` (release-level table) | `discography` |

**Important consequence**: `data/discography.rda`/`man/discography.Rd` are not simply left alone — their *content* changes completely (old song-level data → new release-level data), because the new `discography` name lands on what used to be `releases`. `data/releases.rda`/`man/releases.Rd` become fully orphaned (that name stops existing) and must be deleted, not overwritten.

## The doorprice → price/currency lookup

New file `Repeatr/inst/extdata/fls_doorprice_currency_lookup.csv`, one row per distinct raw `doorprice` string (57 rows — `"Free"` handled separately, see below), columns `doorprice, price, currency, note`. Full contents (verified against every row's actual `country`/`year` in `othervariables`):

```
doorprice,price,currency,note
$1.99,1.99,USD,
$3,3,USD,
$3.50,3.50,USD,
$4,4,USD,
$5,5,USD,
$6,6,USD,
$6cn,6,CAD,
10 (can),10,CAD,
10 Gilders,10,NLG,pre-euro Dutch guilder
10 SW FR,10,CHF,
10(can),10,CAD,
"10,000 Lira",10000,ITL,pre-euro Italian lira
100 AS,100,ATS,pre-euro Austrian schilling
11 (can),11,CAD,
12 (can),12,CAD,
12 DM,12,DEM,pre-euro German mark
12 Marks,12,DEM,Yugoslavia show priced in hard currency (Deutsche Mark) rather than the Yugoslav dinar
12.50DM,12.50,DEM,pre-euro German mark
12DM,12,DEM,pre-euro German mark
14DM,14,DEM,pre-euro German mark
15,15,AUD,
15 Marks,15,DEM,Yugoslavia show priced in hard currency (Deutsche Mark) rather than the Yugoslav dinar
2.50 Pounds,2.50,GBP,
3,3,USD,
3-5Pounds,4,GBP,range in source text (3 to 5); price is the average
3 Irish Punts,3,IEP,pre-euro Irish punt
3 Pounds,3,GBP,
3.5 (Gilders),3.5,NLG,pre-euro Dutch guilder
3.50 Pounds,3.50,GBP,
330 BF,330,BEF,pre-euro Belgian franc
35 D.Kroner,35,DKK,
35 N Kroner,35,NOK,
3500 yen,3500,JPY,
3500yen,3500,JPY,
4,4,USD,
4000 yen,4000,JPY,
40FR,40,FRF,pre-euro French franc
5,5,USD,
50,50,SEK,
50 S Kroner,50,SEK,
5000 Lira,5000,ITL,pre-euro Italian lira
500PS,500,ESP,pre-euro Spanish peseta
50FR,50,FRF,pre-euro French franc
6,6,USD,
6 (ca),6,CAD,
6 (canadian),6,CAD,
6(pounds),6,GBP,
6000 Lira,6000,ITL,pre-euro Italian lira
7,7,USD,
7(can),7,CAD,
7(punts),7,IEP,pre-euro Irish punt
7.50 Gilders,7.50,NLG,pre-euro Dutch guilder
7000 Lira,7000,ITL,pre-euro Italian lira
8,8,USD,
8DM,8,DEM,pre-euro German mark
9 (can),9,CAD,
9(can),9,CAD,
```

`"Free"` (30 shows: 29 USA, 1 Italy in 1995) is **not** in the CSV, since the same raw text maps to different currencies depending on the show's own country — handled with a small `mutate()` override after the join instead (price 0; currency `USD` for the USA shows, `ITL` for the 1995 Italy show).

## Changes to `Repeatr/R/export_fugazidb_data.R`

Rewrite the six `write_table()` blocks (renaming locals to match new output names, keeping the existing `load_obj`/`write_table` helpers unchanged):

```r
  # shows (was fls_shows) - doorprice split into numeric price + ISO 4217
  # currency via a hand-built lookup of its ~58 distinct raw values (currency
  # symbols/abbreviations/ranges/"Free" - see inst/extdata/
  # fls_doorprice_currency_lookup.csv), since currency isn't otherwise
  # recorded and several countries' shows predate that country's euro
  # adoption. "Free" isn't in the lookup (same text, different currency by
  # country) - handled by the mutate() below instead.
  othervariables <- load_obj("othervariables")
  gid_sound_quality <- load_obj("gid_sound_quality")
  doorprice_lookup <- read.csv(system.file("extdata", "fls_doorprice_currency_lookup.csv", package = "Repeatr"), header = TRUE, colClasses = c(doorprice = "character", price = "numeric", currency = "character", note = "character"))

  shows <- othervariables %>%
    left_join(gid_sound_quality, by = "gid") %>%
    left_join(doorprice_lookup, by = "doorprice") %>%
    mutate(
      price = ifelse(doorprice == "Free", 0, price),
      currency = case_when(
        doorprice == "Free" & country == "Italy" ~ "ITL",
        doorprice == "Free" ~ "USD",
        TRUE ~ currency
      )
    ) %>%
    select(gid, flsid, date, venue, price, currency, attendance, recorded_by,
           mastered_by, original_source, tour, city, subdivision, country, sound_quality)

  shows <- write_table(shows, "shows")

  # locations (was fls_venue_geocoding) - exact mirror of the hand-maintained
  # Google Sheet export, minus its Google-Maps-lookup helper columns; y/x
  # renamed latitude/longitude.
  locations <- read.csv(system.file("extdata", "fls_venue_geocoding_v2.csv", package = "Repeatr"), header = TRUE) %>%
    select(country, city, venue, latitude = y, longitude = x)
  locations <- write_table(locations, "locations")

  # durations (was fls_tags) - date dropped (join shows on gid instead),
  # seconds dropped (duplicates duration), track normalized character -> integer.
  durations <- load_obj("fls_tags") %>%
    select(gid, track, song, duration) %>%
    mutate(track = as.integer(track))
  durations <- write_table(durations, "durations")

  # discography (was releases) - unchanged columns/logic, table renamed so
  # "discography" means what it says (per-release metadata).
  discography <- load_obj("releasesdatalookup") %>%
    filter(!releaseid %in% c(12, 13, 14, 15)) %>%
    select(releaseid, release, releasedate, release_date_source)
  discography <- write_table(discography, "discography")

  # songs (was discography) - unchanged columns/logic, table renamed now
  # that "discography" refers to the release-level table instead.
  songs <- load_obj("songvarslookup") %>%
    rename(release_track = track_number, release_duration = duration_seconds) %>%
    mutate(release_duration = seconds_to_period(release_duration))
  songs <- write_table(songs, "songs")

  # bands (was played_with) - played_with column renamed band, now that the
  # table itself is called bands.
  bands <- load_obj("played_with") %>% select(gid, band = played_with)
  bands <- write_table(bands, "bands")

  invisible(list(
    shows = shows,
    locations = locations,
    durations = durations,
    discography = discography,
    songs = songs,
    bands = bands
  ))
```

No change needed to the `load_obj`/`write_table` helper definitions or the function signature (still six tables, still `data/*.rda` only) — only mention the new price/currency split, the `latitude`/`longitude` rename, and the `discography`/`songs` swap in the roxygen `@description`/comments.

## Changes to `Repeatr/R/data.R`

Update `@section Provenance:` text (object names/columns unchanged, only the prose describing what `export_fugazidb_data()` does with them):
- `othervariables`: "... venue coordinates live in fugazi.db's `locations` table instead" (was `fls_venue_geocoding`); add a sentence noting `doorprice` is split into `price`/`currency` via the new lookup CSV. Exported table name: `shows` (was `fls_shows`).
- `played_with`: "Exported (trimmed to `gid`/`played_with`, `played_with` renamed `band`) as fugazi.db's `bands` table" (was `played_with` table).
- `fls_tags` (Repeatr's own internal object, name unchanged): update only the trailing "... as fugazi.db's `fls_tags` table" → "... as fugazi.db's `durations` table".
- `releasesdatalookup`: update "... as fugazi.db's `releases` table" → "... as fugazi.db's `discography` table".
- `songvarslookup`: update "... as fugazi.db's `discography` table" → "... as fugazi.db's `songs` table" (its `\code{\link{fls_tags}}` reference for the duration-format match stays as-is — Repeatr's own internal `fls_tags` object, unrenamed).

## Changes to `Repeatr/vignettes/Data-Provenance.Rmd` and `Rebuilding-the-Data.Rmd`

- `Data-Provenance.Rmd` line ~69-70 (tree diagram) and line ~102 (table list): `fls_shows, fls_venue_geocoding, fls_tags, releases, discography, played_with` → `shows, locations, durations, discography, songs, bands`.
- `Rebuilding-the-Data.Rmd` line ~63: same rename in its six-table list; add a short clause noting `doorprice` is now split into `price`/`currency`, venue coordinates are named `latitude`/`longitude`, and `discography`/`songs` have swapped meanings from the old `releases`/`discography`.

## Incidental fixes while touching this documentation (found during research, unrelated to the rename itself but directly adjacent)

- `Repeatr/README.md` and `Repeatr/index.md` (identical text, line 15): currently says primary/raw data "lives in the companion data package fugazi.db, which Repeatr depends on" — backwards; fugazi.db is generated **from** Repeatr, Repeatr has no dependency on it (confirmed in `DESCRIPTION` and correctly stated in `vignette("Rebuilding-the-Data")`). Fix the direction of this sentence in both files.
- `Repeatr/data-raw/build_data.R` lines ~82-88: stale comment left over from the earlier data-raw-removal cleanup — still says "Composes fugazi.db's **nine** tables ... into a local fugazi.db checkout's **`data-raw/*.csv`** and `data/*.rda`". Update to "six tables" and drop the `data-raw/*.csv` mention, matching `export_fugazidb_data()`'s current behavior/roxygen.

## Changes to `fugazi.db/R/data.R` (source of truth for `man/*.Rd`, regenerated via `devtools::document()`)

- Rename the `fls_shows` doc block to `shows`: replace the `\item{doorprice}{Door price}` entry with `\item{price}{Door price, numeric}` and `\item{currency}{Door price's currency, an ISO 4217 three-letter code (e.g. "USD", "GBP") - NA when the door price is unknown. Reflects the currency in use in that country at the time of the show, which may differ from its currency today (several countries' shows predate that country's adoption of the euro).}`; update `@examples`/object name; update Provenance text's `\code{\link{fls_venue_geocoding}}` → `\code{\link{locations}}` and mention the price/currency split.
- Rename the `fls_venue_geocoding` doc block to `locations`: `\item{y}{Latitude}`/`\item{x}{Longitude}` → `\item{latitude}{Latitude}`/`\item{longitude}{Longitude}`, each noting "decimal degrees - the same coordinate format Google Maps displays, though that isn't its formal name"; update object name/`@examples`.
- Rename the `fls_tags` doc block to `durations`: update `\item{gid}{...references \code{\link{fls_shows}}}` → `\code{\link{shows}}`, and `\item{song}{...references \code{\link{discography}}}` → `\code{\link{songs}}` (the song-level table's new name); object name/`@examples`.
- Rename the current `discography` doc block (song-level) to `songs`: update `\item{song}{...(and \code{\link{fls_tags}})...}` → `\code{\link{durations}}`; update `\item{releaseid}{...references \code{\link{releases}}}` → `\code{\link{discography}}` (the release-level table's new name); update `\item{release_duration}{...same format as \code{\link{fls_tags}}'s duration}` → `\code{\link{durations}}`; Provenance text "as fugazi.db's `discography` table" → "as fugazi.db's `songs` table"; object name/`@examples` → `songs`.
- Rename the current `releases` doc block (release-level) to `discography`: update `\item{releaseid}{...references \code{\link{discography}}}` → `\code{\link{songs}}` (the song-level table's new name); object name/`@examples` → `discography`. Descriptive title/text ("Fugazi releases data" / "Metadata for the Fugazi discography.") can stay as-is — still accurate content, only the object identifier changes.
- Rename the `played_with` doc block to `bands`: `\item{gid}{...references \code{\link{fls_shows}}}` → `\code{\link{shows}}`; `\item{played_with}{Band name}` → `\item{band}{Band name}`; object name/`@examples`.
- Run `devtools::document()` afterward; confirm `fls_shows.Rd`, `fls_venue_geocoding.Rd`, `fls_tags.Rd`, `played_with.Rd`, `releases.Rd` are auto-deleted, `discography.Rd` is regenerated **with entirely new (release-level) content**, and `shows.Rd`, `locations.Rd`, `durations.Rd`, `bands.Rd`, `songs.Rd` are newly written. Delete stale `.Rd`/`.rda` files by hand first if `document()`/the export doesn't clean them up (matching the pattern noted in the prior cleanup session).

## Changes to `fugazi.db/README.md`

Update the six-row object table: `fls_shows`→`shows` (mention price/currency in its blurb), `fls_venue_geocoding`→`locations` (mention latitude/longitude), `fls_tags`→`durations`, `played_with`→`bands`, old `discography`→`songs` ("Per-song studio discography metadata (release, vocals, instrumental)"), old `releases`→`discography` ("Per-release metadata (release date)").

## Changes to `fugazi.db/vignettes/Data-Catalogue.Rmd`

- "The tables" summary table: rename all rows to the new names (`shows`, `locations`, `durations`, `discography`, `songs`, `bands`), keeping each row's actual description/keys attached to its *content*, not its old name (e.g. the row that was `discography` | song | ... now reads `songs` | song | ...; the row that was `releases` | release (album/EP) | `releaseid` now reads `discography` | release (album/EP) | `releaseid`).
- `### gid` section: rename `fls_shows`→`shows`, `fls_tags`→`durations`, `played_with`→`bands` in prose and in the runnable example (`shows %>% left_join(durations, by = "gid")`).
- `### country + city + venue` section: rename to `locations`; update prose and examples, including the `x`/`y` → `longitude`/`latitude` rename (e.g. `locations %>% filter(is.na(longitude) | is.na(latitude))`, `shows %>% left_join(locations, by = c("country", "city", "venue"))`).
- `### song - discography metadata` section: rename to reflect `songs` (e.g. "### song - song metadata" or similar); update prose ("`songs` is keyed by `song`...") and its example: `durations %>% left_join(songs, by = "song")`.
- `### releaseid` section: update prose ("`discography` is keyed by `releaseid`, referenced by `songs$releaseid`") and its example: `songs %>% left_join(discography, by = "releaseid") %>% select(song, release, releasedate)`.

## `fugazi.db/DESCRIPTION`

Bump `Version: 0.1.4` → `0.1.5`.

## Execution sequence

1. Add `Repeatr/inst/extdata/fls_doorprice_currency_lookup.csv` (57 rows, above).
2. Edit `Repeatr/R/export_fugazidb_data.R` (rewrite per above), `Repeatr/R/data.R` (Provenance text), `Repeatr/vignettes/Data-Provenance.Rmd`, `Repeatr/vignettes/Rebuilding-the-Data.Rmd`; fix `Repeatr/README.md` + `index.md` + `data-raw/build_data.R` (incidental staleness). Run `devtools::document()` on Repeatr (no `.Rd` changes expected, but keeps it current).
3. Delete the five stale files from `fugazi.db/data/` (`fls_shows.rda`, `fls_venue_geocoding.rda`, `fls_tags.rda`, `played_with.rda`, `releases.rda`) and `fugazi.db/man/` (`fls_shows.Rd`, `fls_venue_geocoding.Rd`, `fls_tags.Rd`, `played_with.Rd`, `releases.Rd`). Do **not** delete `discography.rda`/`discography.Rd` — they get overwritten in place with the new (release-level) content in the next steps.
4. `devtools::load_all()` the updated Repeatr, then run `export_fugazidb_data(fugazidb_dir = "path/to/fugazi.db")` to regenerate all six `.rda` files under their new names/content.
5. Edit `fugazi.db/R/data.R`, `README.md`, `vignettes/Data-Catalogue.Rmd`, `DESCRIPTION` (version bump).
6. Run `devtools::document()` on fugazi.db; confirm the five stale `.Rd` files are gone, `discography.Rd` now documents release-level columns (`releaseid, release, releasedate, release_date_source`), and `shows.Rd`/`locations.Rd`/`durations.Rd`/`bands.Rd`/`songs.Rd` exist.
7. Verify: `shows$price` is numeric with 700 non-NA values (30 of them 0, for `"Free"`) and 349 `NA`; `shows$currency` non-NA exactly where `price` is non-NA, all values valid ISO 4217 codes; spot-check the Barrowland/UK-tour rows (price 4, GBP) and the two Yugoslavia rows (price 12/15, DEM); `locations` has `latitude`/`longitude` (not `x`/`y`), same 754 rows, same value ranges as before; `bands` has `band` (not `played_with`); `discography` now has release-level columns (not song-level); `songs` has the old discography's song-level columns. Every documented join still resolves as before under the new names: `shows`↔`durations`/`bands` on `gid`; `shows`↔`locations` on `country`+`city`+`venue`; `durations`↔`songs` on `song`; `songs`↔`discography` on `releaseid`.
8. `devtools::check()` both packages - expect 0 errors, no new warnings/notes beyond Repeatr's pre-existing backlog (documented in the prior session's notes).
9. Leave both repos' changes uncommitted for review, per standing repo convention.

R is at `C:\Program Files\R\R-4.5.3\bin\Rscript.exe` (not on PATH). For anything beyond a one-line `Rscript -e`, write a `.R` script file and run it.
