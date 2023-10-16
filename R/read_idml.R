#' @noRd
has_xml_ext <- function(string, ignore.case = TRUE) {
  if (!is_string(string)) {
    return(FALSE)
  }

  grepl("\\.xml$(?!\\.)", string, ignore.case = ignore.case, perl = TRUE)
}

#' Read an InDesign Markup Language (IDML) file to a `idml` object
#'
#' [read_idml()] takes a file path for an `idml` file and returns an `idml`
#' object: a list containing a file name, file path, and the contents of the
#' file as a list of `xml_document` objects and character vectors (for the
#' MIMETYPE file only).
#'
#' @param file Path to a file ending in a `.idml` file extension.
#' @param exdir Directory to extract files to when using [base::unzip()],
#'   Default: `tempdir()`.
#' @param ... Additional parameters passed to [xml2::read_xml()]
#' @returns A `idml` class object.
#' @seealso
#'  [xml2::read_xml()]
#' @rdname read_idml
#' @export
#' @importFrom utils unzip
#' @importFrom cli cli_abort
#' @importFrom fs dir_ls
#' @importFrom purrr map
read_idml <- function(file,
                      ...,
                      exdir = tempdir()) {
  if (is_url(file)) {
    url <- file
    file <- file.path(tempdir(), basename(url))

    download.file(
      url = url,
      destfile = file,
      quiet = TRUE
    )
  }

  if (!file.exists(file)) {
    cli::cli_abort(
      "{.arg file} must be an existing file or valid URL."
    )
  }

  try_fetch(
    utils::unzip(
      zipfile = file,
      exdir = exdir
    ),
    warning = function(cnd) {
      cli_abort(
        cnd$message
      )
    }
  )

  contents_list <- fs::dir_ls(exdir, recurse = FALSE)

  contents <- purrr::map(
    contents_list,
    function(path) {
      read_idml_xml_document(path, ...)
    }
  )

  contents <- set_names(contents, basename(contents_list))

  new_idml(
    file = basename(file),
    path = file.path(exdir, basename(file)),
    contents = contents
  )
}

#' Read a list of xml_document objects from a directory or file path
#'
#' [read_idml_xml_document()] uses [purrr::map()] and [xml2::read_xml()] to read
#' a list of `xml_document` from the files and directories created by an
#' unzipped IDML file.
#'
#' @noRd
#' @importFrom fs dir_ls
#' @importFrom xml2 read_xml
#' @importFrom purrr map
read_idml_xml_document <- function(path, ..., glob = "*.xml", recurse = FALSE) {
  if (dir.exists(path)) {
    files <- fs::dir_ls(path, glob = glob, recurse = recurse)
  } else {
    stopifnot(file.exists(path))

    if (basename(path) == "mimetype") {
      return(suppressWarnings(readLines(path)))
    }

    if (has_xml_ext(path)) {
      return(xml2::read_xml(path, ...))
    }

    return(NULL)
  }

  file_list <- purrr::map(
    files,
    function(file) {
      xml2::read_xml(file, ...)
    }
  )

  set_names(file_list, basename(files))
}
