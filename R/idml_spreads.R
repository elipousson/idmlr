#' Get spreads from an IDML object
#'
#' @name idml_spreads
NULL

#' [get_idml_spreads()] extracts a list of xml documents for spreads or a data
#' frame from a `idml` object.
#'
#' @rdname idml_spreads
#' @name get_idml_spreads
#' @inheritParams get_idml_contents
#' @inheritParams purrr::list_rbind
#' @inheritDotParams get_idml_contents -dir -file
#' @inheritParams check_idml
#' @export
#' @importFrom purrr list_rbind
get_idml_spreads <- function(idml,
                             format = "list",
                             names_to = "Spread",
                             ...,
                             .error_call = caller_env()) {
  spreads <- get_idml_contents(
    idml,
    dir = "Spreads"
  )

  if (format == "list") {
    return(spreads)
  }

  if (format == "data.frame") {
    spread_list <- lapply(
      spreads,
      function(x) {
        xml_doc_to_df(x, parent_nm = "Spread")
      }
    )

    purrr::list_rbind(spread_list, ..., names_to = "Spread")
  }
}
