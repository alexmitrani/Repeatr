% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fls_tags_importer.R
\name{fls_tags_importer}
\alias{fls_tags_importer}
\title{imports a .txt file of duration data, converts the duration variable to hh:mm:ss (hms) format, and exports the resulting data to an rda file.}
\usage{
fls_tags_importer(myfilename = NULL)
}
\arguments{
\item{myfilename}{the full path and filename of the file to be imported and converted.}
}
\description{
fls_tags_importer is used to import a .txt file of duration data generated with kid3 audio tagger (https://kid3.kde.org/)
}
\details{
fls_tags_importer
}
\examples{
fls_tags_importer(myfilename = "C:/Users/alexm/Music/fls_tags.txt")


}
