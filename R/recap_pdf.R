# Never called directly - registered purely so NAMESPACE/R CMD check record
# it as a used Import. The recap.qmd itself is the actual caller, indirectly
# via knitr's htmlwidget-to-PDF screenshot fallback (that qmd runs in a
# separate R process spawned by the Quarto CLI, so it can't pick up a
# NAMESPACE import declared here - this is only about satisfying the
# "all declared Imports should be used" check for a package this file's own
# code never references directly, see the chromote::find_chrome() guard and
# chromote::set_chrome_args() call below/in the qmd for the real usage).
#' @importFrom webshot2 webshot
NULL

# Renders inst/shiny/Fugazetteer/recap_template.qmd to a PDF via Quarto +
# Typst for a single show. Not exported: internal to the Shiny app's
# recap-download button (see output$downloadRecapDoc in app.R).
render_recap_pdf <- function(gid, output_dir, file_stub = "recap") {
  if (!requireNamespace("quarto", quietly = TRUE)) {
    stop("The 'quarto' package is required to export the recap as PDF; ",
         "install it with install.packages('quarto').")
  }
  quarto_bin <- tryCatch(quarto::quarto_path(), error = function(e) "")
  if (!nzchar(quarto_bin)) {
    stop("The Quarto CLI was not found; it is required to export the recap ",
         "as PDF. See https://quarto.org/docs/get-started/.")
  }
  # webshot2 itself isn't called directly here - knitr's own htmlwidget-to-
  # PDF fallback uses it internally to rasterize the recap's Leaflet map for
  # a non-HTML render target, and it's guaranteed installed since it's a
  # hard Import. What isn't guaranteed is the Chrome/Chromium binary
  # webshot2's chromote backend needs at runtime, so that's checked
  # explicitly - a missing browser fails clearly up front instead of a
  # broken/missing map partway through the Quarto render.
  chrome_bin <- tryCatch(chromote::find_chrome(), error = function(e) NA_character_)
  if (is.na(chrome_bin) || !nzchar(chrome_bin)) {
    stop("A Chrome/Chromium binary was not found; webshot2 needs one to ",
         "render the recap map as a static image for the PDF. See ",
         "https://rstudio.github.io/chromote/ for installation options.")
  }

  template_src <- system.file("shiny", "Fugazetteer", "recap_template.qmd",
                               package = "Repeatr")
  qmd_lines <- readLines(template_src)
  # font-paths needs an absolute path baked in at render time (a relative
  # "." didn't reliably resolve to the qmd's own directory); substituted
  # into the copied qmd rather than passed via execute_params since
  # font-paths is a static format option, not a knitr param.
  font_dir <- normalizePath(output_dir, winslash = "/")
  qmd_lines <- gsub("__FONT_DIR__", font_dir, qmd_lines, fixed = TRUE)
  qmd_path <- file.path(output_dir, paste0(file_stub, ".qmd"))
  writeLines(qmd_lines, qmd_path)

  # Font files copied alongside the qmd (rather than referenced at their
  # installed package path) since cvmachine's Quarto+Typst PDF work hit
  # font-loading failures on shinyapps.io when Typst tried to read fonts
  # from the installed-package path directly, even though the parent R
  # process could read it fine. Permissions forced explicitly and
  # TYPST_FONT_PATHS set as a redundant second path to the same directory
  # (belt-and-braces, matching cvmachine's fix for the same symptom -
  # PDF renders fine but silently falls back to Typst's default font) since
  # the font-paths: YAML key alone wasn't enough on Posit Connect Cloud.
  fonts_src <- system.file("shiny", "Fugazetteer", "fonts", package = "Repeatr")
  font_files <- list.files(fonts_src, full.names = TRUE)
  file.copy(font_files, output_dir, overwrite = TRUE)
  Sys.chmod(file.path(output_dir, basename(font_files)), mode = "0644")
  Sys.setenv(TYPST_FONT_PATHS = font_dir)

  quarto::quarto_render(
    input = qmd_path,
    output_format = "typst",
    execute_params = list(gid = gid),
    output_file = paste0(file_stub, ".pdf"),
    quiet = FALSE
  )

  pdf_path <- file.path(output_dir, paste0(file_stub, ".pdf"))
  if (!file.exists(pdf_path)) {
    stop("Quarto render completed but no PDF was produced.")
  }
  pdf_path
}
