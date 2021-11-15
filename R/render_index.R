library(rmarkdown)
code_dir <- "vignettes"
index_filename <- "index.Rmd"
index_filename <- file.path(code_dir, report_filename)
output_dir <- "docs"
output <- file.path("..",output_dir)
render(index_filename, output_dir = output_dir, params = list(output_dir = output))

