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
  qmd_path <- file.path(output_dir, paste0(file_stub, ".qmd"))
  file.copy(template_src, qmd_path, overwrite = TRUE)

  # Fonts copied into their own subdirectory of output_dir (not output_dir
  # itself) with copy.mode = FALSE (discard the source file's own
  # permission bits rather than preserve them) plus an explicit chmod, and
  # TYPST_FONT_PATHS set directly - this mirrors cvmachine's Quarto+Typst
  # PDF export exactly (down to the subdirectory structure), which is
  # confirmed working in a live deployed Shiny app on a cloud host, unlike
  # the previous attempts here. cvmachine's own notes admit they never
  # fully isolated which piece of this combination was the actual fix
  # (their leading theory is TYPST_FONT_PATHS, with the copy/chmod dance
  # possibly addressing a theory that wasn't the real cause) - kept as one
  # unit here for the same reason: matching their confirmed-working
  # structure exactly is a stronger bet than re-deriving a minimal fix from
  # scratch.
  fonts_src <- system.file("shiny", "Fugazetteer", "fonts", package = "Repeatr")
  font_dir_raw <- file.path(output_dir, "fonts")
  dir.create(font_dir_raw, showWarnings = FALSE)
  font_files <- list.files(fonts_src, pattern = "[.](ttf|otf|ttc)$", full.names = TRUE)
  file.copy(font_files, font_dir_raw, overwrite = TRUE, copy.mode = FALSE)
  Sys.chmod(list.files(font_dir_raw, full.names = TRUE), mode = "0644")
  font_dir <- normalizePath(font_dir_raw, winslash = "/")
  Sys.setenv(TYPST_FONT_PATHS = font_dir)

  # Diagnostic only (three rounds of font-path fixes didn't resolve this on
  # Posit Connect Cloud, so log what's actually on disk plus the deployed
  # typst version right before the render instead of guessing further) -
  # remove once the font issue is confirmed fixed.
  message("recap PDF font diagnostics:")
  message("  fonts_src = ", fonts_src, " (nzchar: ", nzchar(fonts_src), ")")
  message("  font_dir = ", font_dir)
  for (f in list.files(font_dir_raw, full.names = TRUE)) {
    message(sprintf("  %s exists=%s readable=%s size=%s", f,
                     file.exists(f), file.access(f, mode = 4) == 0,
                     if (file.exists(f)) file.size(f) else NA))
  }
  typst_version <- tryCatch(
    system2(quarto_bin, c("typst", "--version"), stdout = TRUE, stderr = TRUE),
    error = function(e) paste("error:", conditionMessage(e))
  )
  message("  typst version: ", paste(typst_version, collapse = " "))
  # Decisive test: ask the actual typst binary directly whether it sees
  # Inconsolata at this exact path, bypassing Quarto's metadata-to-CLI
  # translation entirely. If this also fails to list "Inconsolata", the
  # problem is typst/the font file on this host, not quarto's plumbing; if
  # it succeeds, quarto itself isn't forwarding font-paths to the typst
  # subprocess correctly despite what its own metadata dump claims.
  typst_fonts_check <- tryCatch(
    system2(quarto_bin, c("typst", "fonts", "--font-path", font_dir,
                           "--ignore-system-fonts"),
            stdout = TRUE, stderr = TRUE),
    error = function(e) paste("error:", conditionMessage(e))
  )
  message("  typst fonts --font-path ", font_dir, " --ignore-system-fonts:")
  message("    ", paste(typst_fonts_check, collapse = " | "))

  quarto::quarto_render(
    input = qmd_path,
    output_format = "typst",
    execute_params = list(gid = gid),
    metadata = list(format = list(typst = list(`font-paths` = font_dir))),
    output_file = paste0(file_stub, ".pdf"),
    quiet = FALSE
  )

  pdf_path <- file.path(output_dir, paste0(file_stub, ".pdf"))
  if (!file.exists(pdf_path)) {
    stop("Quarto render completed but no PDF was produced.")
  }
  pdf_path
}
