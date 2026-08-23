# Bundle Inconsolata font locally to remove Google Fonts network dependency

## Context

User reported the Fugazetteer Shiny app sometimes takes a long time to
load, and recalled a prior mention that a Google Fonts fetch could be the
cause. Investigated and confirmed: `app.R` built its `bs_theme()` with
`base_font = font_google("Inconsolata")`, which triggers a network call
from the R process to Google Fonts (fonts.googleapis.com/fonts.gstatic.com)
at app startup, during Sass theme compilation. This had already been
flagged as a known, unaddressed issue in two earlier sessions:
- `inst/notes/202608202100_plan_issue263-code-quality.md:104` — listed as
  an optional/stretch item.
- `inst/notes/202608212152_notes_issue263-phase4-shiny-precompute.md:75-77`
  — explicitly skipped for scope/time.

Key point clarified for the user: `font_google()`'s cache lives on the
*server process*, not the visitor's browser, so a cold/ephemeral app
instance (redeploy, container restart, etc.) re-pays the download cost —
this isn't just a "first run on my machine" issue, it can recur for real
users depending on hosting/restart behavior.

## Change

Replaced the Google Fonts dependency with a fully self-contained,
locally-bundled font, embedded as base64 data URIs so there is **zero
network dependency**, at any point (build or runtime), regardless of
hosting layout (subpath, subdomain, ephemeral containers, etc.) — data URIs
sidestep any asset-path resolution concerns entirely.

1. Downloaded the exact same Inconsolata weight-400 subset files that
   `font_google("Inconsolata")` was already fetching (extracted via
   `bslib::font_google("Inconsolata")$html_deps()` to guarantee an
   identical visual match — 3 unicode-range subsets: latin, latin-ext,
   vietnamese). Saved as static assets:
   `inst/shiny/Fugazetteer/www/fonts/inconsolata/inconsolata-{latin,latin-ext,vietnamese}.woff2`.
2. `app.R`: replaced `font_google("Inconsolata")` with a small
   `inconsolata_face()` helper + `font_collection()` that reads each local
   `.woff2` file and embeds it as a `data:font/woff2;base64,...` URI via
   `base64enc::dataURI()`, building the same three `font_face()` rules
   Google's stylesheet used (matching weight/style/unicode-range).
3. Added `base64enc` to `DESCRIPTION` `Imports` (new dependency,
   already installed transitively via other packages, so no new install
   burden).
4. Bumped version to `0.0.0.9274`.

## Verification

- `sass::sass()`-compiled the new theme directly (no Shiny needed) and
  confirmed: `Inconsolata` appears as the body font, the embedded
  dependency stylesheets contain `data:font/woff2;base64,...` sources, and
  there are zero references to `fonts.googleapis`/`fonts.gstatic` anywhere.
- Launched the real app (`shiny::runApp()` on a local port) and curl'd the
  rendered page and the served `font.css`: confirmed 0 Google Fonts
  references anywhere in the served HTML/CSS, one `@font-face` rule
  serving an embedded `data:font/woff2;base64` URI, no errors/warnings in
  the startup log.

## Note on a pre-existing (unrelated) quirk found during verification

`htmltools`/`bslib` dependency resolution deduplicates the three
`font_face()`-per-subset dependencies by `name`+`version` (all three are
named `"Inconsolata"`, version `"0.4.10"`), so in practice only **one** of
the three subset files (the "latin" one, since it was declared first) ends
up actually served — the other two are silently dropped by the dependency
resolver. This is not a regression: the exact same collapsing happens with
the original `font_google("Inconsolata")` call (it also produces three
same-name/version dependencies), so behavior is unchanged from before.
Since "latin" covers all the actual text this app renders (English tour
data), this has no visible effect either way. Not fixing this — it would
require bypassing `bslib`'s dependency mechanism for no practical benefit,
and would go beyond the scope of "stop the Google Fonts network call."

Separately, the `sass` package (v0.4.10) has an unrelated CSS-output bug:
`font_face(unicode_range = ...)` is emitted literally as `unicode_range:`
(underscore) instead of the valid CSS property `unicode-range` (hyphen),
so the descriptor is dropped by browsers. This bug also exists in the
original `font_google()` code path (same underlying `sass::font_face()`),
so it's pre-existing, not introduced by this change, and harmless in
practice: browsers still resolve the correct glyphs across
same-family/weight `@font-face` rules by testing actual font-resource
glyph coverage, falling through in declaration order.

## Files changed

- `inst/shiny/Fugazetteer/app.R`
- `inst/shiny/Fugazetteer/www/fonts/inconsolata/*.woff2` (new)
- `DESCRIPTION` (added `base64enc` import, version bump)
