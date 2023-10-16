#' Check IDML objects
#'
#' [check_idml_resource()] helps check if an `idml` object contains the expected
#' resource file.
#'
#' @param idml A `idml` class object created with [read_idml()].
#' @name check_idml
#' @keywords internal
NULL

#' @rdname check_idml
#' @name check_idml_resource
#' @param resource One or more resource names: "Graphic.xml", "Fonts.xml",
#'   or "Styles.xml"
#' @keywords internal
check_idml_resource <- function(idml,
                                resource = NULL,
                                arg = caller_arg(idml),
                                call = caller_env()) {
  validate_idml(idml)

  resources <- idml[["contents"]][["Resources"]]

  stopifnot(!is.null(resources))

  if (!all(has_name(resources, resource))) {
    cli_abort(
      "{.arg {arg}} is missing expected resources: {.val {resource}}",
      call = call
    )
  }
}
