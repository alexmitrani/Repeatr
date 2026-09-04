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

  # Pre-flight: confirm typst itself (not Quarto's translation of it) can
  # see Inconsolata at this exact path before spending time on the full
  # render. This also doubles as the mechanism the actual fix below relies
  # on - see the comment there for why.
  font_check <- tryCatch(
    system2(quarto_bin, c("typst", "fonts", "--font-path", font_dir,
                           "--ignore-system-fonts"),
            stdout = TRUE, stderr = TRUE),
    error = function(e) character(0)
  )
  if (!any(grepl("Inconsolata", font_check, fixed = TRUE))) {
    stop("Typst does not recognize the Inconsolata font at ", font_dir,
         " (checked via `typst fonts --font-path`); the bundled font ",
         "files may be missing or corrupted in this installation.")
  }

  quarto::quarto_render(
    input = qmd_path,
    output_format = "typst",
    execute_params = list(gid = gid),
    debug = TRUE,
    output_file = paste0(file_stub, ".pdf"),
    quiet = FALSE
  )

  # Quarto's own compile pass does not reliably forward font-paths/fontpaths
  # to the typst subprocess it spawns internally - confirmed on Posit
  # Connect Cloud: its own metadata dump showed font-paths correctly
  # resolved, yet the PDF it produced still logged "unknown font family",
  # while `typst fonts --font-path <same dir>` (the pre-flight check above)
  # correctly found Inconsolata at that exact path on the same host. So the
  # PDF quarto_render() itself writes is discarded, and typst is invoked
  # directly against the intermediate .typ file it leaves behind (kept
  # around via debug = TRUE above) with an explicit --font-path, which the
  # pre-flight check already proved actually works.
  typ_path <- file.path(output_dir, paste0(file_stub, ".typ"))
  if (!file.exists(typ_path)) {
    stop("Quarto did not leave behind an intermediate .typ file to ",
         "recompile with the correct font.")
  }
  pdf_path <- file.path(output_dir, paste0(file_stub, ".pdf"))
  recompile <- processx::run(
    quarto_bin,
    args = c("typst", "compile", typ_path, pdf_path, "--font-path", font_dir),
    error_on_status = FALSE
  )
  if (recompile$status != 0 || !file.exists(pdf_path)) {
    stop("Direct typst recompile failed: ", recompile$stderr)
  }
  pdf_path
}
