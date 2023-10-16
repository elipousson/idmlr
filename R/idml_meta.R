#' Get metadata from an IDML object
#'
#' @name idml_meta
NULL

#' [get_idml_meta()] extracts a metadata elements from an `idml` object in the
#' supplied format.
#'
#' @name get_idml_meta
#' @inheritParams check_idml
#' @inheritParams get_idml_contents
#' @inheritDotParams get_idml_contents -dir -file
#' @inheritParams rlang::args_error_context
#' @rdname idml_meta
#' @export
get_idml_meta <- function(idml,
                          format = "xml_document",
                          ...,
                          error_call = caller_env()) {
  get_idml_contents(
    idml,
    dir = "META-INF",
    file = "metadata.xml",
    format = format,
    ...,
    error_call = error_call
  )
}
