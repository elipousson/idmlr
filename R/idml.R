#' S3 object functions for idml class objects
#'
#' [new_idml()] creates a idml class object from a file path and contents.
#' [validate_idml()] checks idml objects. Used by [read_idml()] to create idml
#' objects from a file and by other functions to validate input idml objects.
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
                     contents,
                     error_call = caller_env()) {
  idml <- vctrs::new_vctr(
    .data = list(
      file = file,
      path = path,
      contents = contents
    ),
    class = "idml"
  )

  validate_idml(idml, error_call = error_call)

  idml
}

#' @rdname idml
#' @name validate_idml
#' @param idml An `idml` class object.
#' @param type MIMETYPE value to use in validating `idml` objects.
#' @inheritParams rlang::args_error_context
#' @export
validate_idml <- function(idml,
                          what = "idml",
                          nm = c("file", "path", "contents"),
                          type = "application/vnd.adobe.indesign-idml-package",
                          arg = caller_arg(idml),
                          error_call = caller_env()) {
  if (is_string(idml) && file.exists(idml)) {
    cli_abort(
      c(
        "{.arg {arg}} must be an {.cls {what}} object, not a file path.",
        "i" = "Use {.fn read_idml} to create an {.cls idml} object from a file."
      ),
      call = error_call
    )
  }

  rules <- c(
    inherits(idml, what),
    all(has_name(idml, nm)),
    has_name(idml[["contents"]], "mimetype"),
    idml[["contents"]][["mimetype"]] == type
  )

  if (all(rules)) {
    return(invisible(idml))
  }

  msgs <- c(
    "must be a {.cls {what}} object",
    "must have the names {.val {nm}}",
    "contents must have a {.val mimetype} value",
    "and mimetype must be {.val {type}}"
  )

  msg <- paste0(
    "{.arg {arg}} ", paste0(msgs[!rules], collapse = ", "),
    "."
  )

  cli_abort(
    msg,
    call = error_call
  )
}
