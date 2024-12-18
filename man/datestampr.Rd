% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datestampr.R
\name{datestampr}
\alias{datestampr}
\title{production of date stamps}
\usage{
datestampr(
  dateonly = FALSE,
  houronly = FALSE,
  minuteonly = FALSE,
  myusername = FALSE
)
}
\arguments{
\item{dateonly}{requests a simplified timestamp with only the date (no time).}

\item{houronly}{requests a simplified timestamp with only the date and the hour (no minutes or seconds).}

\item{minuteonly}{requests a simplified timestamp with only the date, the hour and the minutes (no seconds).}

\item{myusername}{adds the active username to the timestamp.}
}
\description{
datestampr is used to create the datestamps used to produce unique filenames for the output files.
}
\details{
datestampr is used internally by the fsm package.
}
\examples{
datestring <- datestampr(myusername=TRUE)
cat(yellow(paste0("\n \n", "Hello world, have a datestamp: ", datestring, "\n \n")))

}
