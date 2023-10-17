#' Create a data frame from an XML document
#'
#' Based on https://rud.is/rpubs/xml2power/
#'
#' @param doc A XML document.
#' @param parent_nm Name of top-level parent node. If parent_nm is a
#'   character vector, [extract_doc_df()] returns a data frame list.
#' @param parent_node A XML document, node, or node set.
#' @param node_names Node names to iterate over. Default `NULL`. Typically
#'   created from children of parent node.
#' @param unique_nm If `TRUE`, ensure that parent_node names are unique before
#'   using them to extract data from the `xml_document`. Ignored if `node_names`
#'   is supplied.
#' @param nested If `TRUE`, use `parent_nm` to extract a parent node from doc.
#'   If `FALSE`, `parent_node` defaults to doc (unless `parent_node` is supplied).
#' @param type Type of data to extract from chlildren nodes: "attr" (attributes)
#'   or "text".
#' @inheritDotParams readr::type_convert
#' @keywords internal
#' @importFrom vctrs list_drop_empty
#' @importFrom xml2 xml_find_first xml_children xml_name
#' @importFrom purrr map flatten_df
#' @importFrom readr type_convert
xml_doc_to_df <- function(doc = NULL,
                          parent_nm = NULL,
                          parent_node = NULL,
                          node_names = NULL,
                          unique_nm = TRUE,
                          nested = TRUE,
                          type = "attr",
                          ...) {
  # if (is.character(parent_node)) {
  #   parent_nm <- parent_node
  #   parent_node <- NULL
  # }

  if (length(parent_nm) > 1) {
    doc_df_list <- lapply(
      parent_nm,
      function(x) {
        xml_doc_to_df(doc, parent_nm = x, unique_nm = unique_nm, type = type, ...)
      }
    )

    return(vctrs::list_drop_empty(set_names(doc_df_list, parent_nm)))
  }

  if (nested) {
    # FIXME: Could [xml2::xml_length()] be used handle things automatically
    # without needing the nested option or try_fetch() for error handling?
    parent_node <- parent_node %||% try_fetch(
      xml2::xml_find_first(doc, sprintf(".//%s", parent_nm)),
      error = function(cnd) {
        # warn on error and return NULL
        cli_warn(cnd$message)
        return(NULL)
      }
    )
  } else {
    # If not nested parent_node defaults to doc
    parent_node <- parent_node %||% doc
  }


  if (is.null(node_names)) {
    # FIXME: Should this use [xml2::xml_contents()] in some cases?
    children_nodes <- xml2::xml_children(parent_node)

    node_names <- children_nodes |>
      xml2::xml_name()

    if (unique_nm) {
      # FIXME: How to handle cases with not unique node names
      node_names <- unique(node_names)
    }
  }

  purrr::map(
    node_names,
    function(x) {
      content <- switch(type,
        attr = as.list(extract_node_attr(doc, sprintf(".//%s/%s", parent_nm, x))),
        text = list(extract_node_text(doc, sprintf(".//%s/%s", parent_nm, x)))
      )

      # content
      set_names(
        content,
        tolower(x)
      )
    }
  ) |>
    # flatten_df is superseded
    purrr::flatten_df() |>
    suppressMessages(readr::type_convert(...))
}

#' @noRd
extract_node_text <- function(doc, target_node) {
  xml2::xml_find_all(doc, target_node) |>
    xml2::xml_text() |>
    trimws()
}

#' @noRd
extract_node_attr <- function(doc, target_node) {
  xml2::xml_find_all(doc, target_node) |>
    xml2::xml_attrs()
}
