% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/idml.R
\name{idml}
\alias{idml}
\alias{new_idml}
\alias{validate_idml}
\title{S3 object functions for idml class objects}
\usage{
new_idml(file, path, contents)

validate_idml(
  idml,
  what = "idml",
  nm = c("file", "path", "contents"),
  type = "application/vnd.adobe.indesign-idml-package",
  error_call = caller_env()
)
}
\arguments{
\item{file}{File name for input IDML file.}

\item{path}{Path to location of unzipped IDML file. This is the directory
where the XML files are located.}

\item{contents}{A named list of \code{xml_document} objects.}

\item{idml}{A object to validate as an \code{idml} class object.}

\item{type}{MIMETYPE value to use in validating \code{idml} objects.}
}
\description{
S3 object functions for idml class objects
}
