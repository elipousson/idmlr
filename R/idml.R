#' S3 object functions for idml class objects
#'
#' @name idml
NULL

#' @rdname idml
#' @name new_idml
#' @param file File name for input IDML file.
#' @param path Path to location of unzipped IDML file. This is the directory
#'   where the XML files are located.
#' @param contents A named list of `xml_document` objects.
#' @export
#' @importFrom vctrs new_vctr
new_idml <- function(file,
                     path,
                     contents) {
  idml <- vctrs::new_vctr(
    .data = list(
      file = file,
      path = path,
      contents = contents
    ),
    class = "idml"
  )

  validate_idml(idml)

  idml
}

#' @rdname idml
#' @name validate_idml
#' @param idml A object to validate as an `idml` class object.
#' @param type MIMETYPE value to use in validating `idml` objects.
#' @export
validate_idml <- function(idml,
                          type = "application/vnd.adobe.indesign-idml-package") {
  stopifnot(
    inherits(idml, "idml"),
    all(has_name(idml, c("file", "path", "contents"))),
    has_name(idml[["contents"]], "mimetype"),
    idml[["contents"]][["mimetype"]] == type
  )

  invisible(idml)
}
