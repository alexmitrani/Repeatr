#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom bslib bs_theme
#' @importFrom cols4all c4a
#' @importFrom crayon yellow
#' @importFrom dplyr %>%
#' @importFrom dplyr .data across anti_join arrange case_when count desc distinct filter full_join group_by inner_join left_join mutate mutate_all mutate_if n pull relocate rename row_number rowwise select semi_join slice summarise summarize ungroup where
#' @importFrom rlang :=
#' @importFrom DT datatable
#' @importFrom fastDummies dummy_cols
#' @importFrom ggplot2 ggplot
#' @importFrom gsheet gsheet2tbl
#' @importFrom leaflet leaflet
#' @importFrom lubridate %--%
#' @importFrom lubridate as.duration day dyears month period_to_seconds seconds_to_period year
#' @importFrom mlogit dfidx mlogit
#' @importFrom plotly plot_ly
#' @importFrom readr parse_number read_delim write_csv
#' @importFrom rlang parse_expr
#' @importFrom rmarkdown render
#' @importFrom rvest html_element html_elements html_text2 read_html
#' @importFrom scales comma
#' @importFrom shiny shinyApp
#' @importFrom stringr str_replace str_sub str_to_lower str_trim
#' @importFrom thematic thematic_shiny
#' @importFrom tidyr pivot_longer pivot_wider separate_rows
#' @importFrom viridis scale_fill_viridis
## usethis namespace: end
NULL

# magrittr's `.` pipe placeholder (used standalone, e.g. inside replace())
# isn't resolvable via the .data pronoun (it isn't a column) and isn't a
# real undeclared dependency - the standard tidyverse-package idiom is to
# declare it here. spotifyOAuth/searchArtist/getAlbums are Rspotify
# functions: fugazi_spotify_data() is a documented, `\dontrun{}`-only
# helper that requires the user to `library(Rspotify)` themselves (Rspotify
# isn't on CRAN, so it isn't declared as a package dependency).
utils::globalVariables(c(".", "spotifyOAuth", "searchArtist", "getAlbums"))
