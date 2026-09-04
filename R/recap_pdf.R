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
  # Not called directly - knitr's own htmlwidget-to-PDF fallback uses
  # webshot2 internally to rasterize the recap's Leaflet map for a non-HTML
  # render target. Checked explicitly here so a missing webshot2 fails with
  # a clear message up front instead of a broken/missing map partway
  # through the render.
  if (!requireNamespace("webshot2", quietly = TRUE)) {
    stop("The 'webshot2' package is required to export the recap as PDF ",
         "(used to render the map as a static image); install it with ",
         "install.packages('webshot2').")
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
  # process could read it fine.
  fonts_src <- system.file("shiny", "Fugazetteer", "fonts", package = "Repeatr")
  file.copy(list.files(fonts_src, full.names = TRUE), output_dir, overwrite = TRUE)

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
