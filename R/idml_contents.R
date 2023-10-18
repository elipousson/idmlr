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
#' @param dir,file Directory and file name from IDML contents to return. If
#'   `file` is `NULL`,
#' @inheritParams xml2::as_list
#' @inheritParams xml_doc_to_df
#' @inheritParams rlang::args_error_context
#' @returns A list, XML document, data frame, or data frame list depending on
#'   format and the input idml object.
#' @export
get_idml_contents <- function(idml,
                              dir = NULL,
                              file = NULL,
                              format = "xml_document",
                              ns = character(),
                              parent_nm = NULL,
                              unique_nm = TRUE,
                              type = "attr",
                              ...,
                              error_call = caller_env()) {
  validate_idml(idml, error_call = error_call)

  if (is.null(dir) && is.null(file)) {
    cli_abort(
      "One of {.arg dir} or {.arg file} must be supplied.",
      call = error_call
    )
  }

  contents <- idml[["contents"]]

  if (!is.null(dir) && !is.null(file)) {
    content <- contents[[dir]][[file]]
  } else if (!is.null(file) && is.null(dir)) {
    content <- contents[[file]]
  } else {
    content <- contents[[dir]]
  }

  format_idml_content(
    content = content,
    format = format,
    ns = ns,
    parent_nm = parent_nm,
    unique_nm = unique_nm,
    type = type,
    ...,
    error_call = error_call
  )
}

#' @rdname idml_contents
#' @name format_idml_content
#' @param format "list", "xml_document", or "data.frame". If "list", contents
#'   are converted with [xml2::as_list()] using the supplied `ns` parameter.
#' @export
#' @importFrom purrr list_rbind
format_idml_content <- function(content,
                                format = "xml_document",
                                ns = character(),
                                parent_nm = NULL,
                                unique_nm = TRUE,
                                type = "attr",
                                names_to = zap(),
                                allow_list = TRUE,
                                ...,
                                error_call = caller_env()) {
  format <- tolower(format)

  format <- arg_match(
    format,
    c("list", "xml_document", "data.frame"),
    error_call = error_call
  )

  if (allow_list && is_bare_list(content) && (format == "data.frame")) {
    content <- lapply(
      content,
      function(x) {
        xml_doc_to_df(
          doc = x,
          parent_nm = parent_nm,
          unique_nm = unique_nm,
          type = type,
          ...
          )
      }
    )

    return(purrr::list_rbind(content, names_to = names_to))
  }

  switch(format,
    "xml_document" = content,
    # FIXME: If I add as_list to the imports, it creates a conflict with
    # rlang::as_list
    "list" = xml2::as_list(content, ns = ns),
    "data.frame" = xml_doc_to_df(
      doc = content,
      parent_nm = parent_nm,
      unique_nm = unique_nm,
      type = type,
      ...
    )
  )
}
