#' Get contents from an IDML object
#'
#' [get_idml_contents()] is a helper for extracting or converting `xml_document`
#' objects from the `idml` list object.
#'
#' @inheritParams check_idml
#' @name idml_contents
NULL

#' @name get_idml_contents
#' @rdname idml_contents
#' @param dir,file Directory and file name from IDML contents to return.
#' @param format "list" or "xml_document". If "list", contents are converted
#'   with [xml2::as_list()] using the supplied `ns` parameter.
#' @inheritParams xml2::as_list
#' @inheritParams rlang::args_error_context
#' @export
get_idml_contents <- function(idml,
                              dir = NULL,
                              file = NULL,
                              format = "xml_document",
                              ns = character(),
                              error_call = caller_env()) {
  validate_idml(idml)

  if (is.null(dir) && is.null(file)) {
    cli::cli_abort(
      "One of {.arg dir} or {.arg file} must be supplied.",
      call = error_call
    )
  }

  contents <- idml[["contents"]]

  if (!is.null(dir) && !is.null(file)) {
    content <- contents[[dir]][[file]]
  } else if (!is.null(file)) {
    content <- contents[[file]]
  } else if (!is.null(dir)) {
    return(contents[[dir]])
  }

  format <- arg_match(format, c("list", "xml_document"), error_call = error_call)

  switch(format,
    "xml_document" = content,
    # FIXME: If I add as_list to the imports, it creates a conflict with
    # rlang::as_list
    "list" = xml2::as_list(content, ns = ns)
  )
}
