quarto_pdf_available <- function() {
  if (!requireNamespace("quarto", quietly = TRUE)) return(FALSE)
  nzchar(tryCatch(quarto::quarto_path(), error = function(e) ""))
}

test_that("render_recap_pdf() produces a non-empty PDF for a sample gid", {
  skip_on_cran()
  skip_if_not(quarto_pdf_available())

  out_dir <- tempfile("recap_test_")
  dir.create(out_dir)
  on.exit(unlink(out_dir, recursive = TRUE))

  pdf_path <- render_recap_pdf(gid = "washington-dc-usa-90387", output_dir = out_dir)

  expect_true(file.exists(pdf_path))
  expect_gt(file.size(pdf_path), 0)
})
