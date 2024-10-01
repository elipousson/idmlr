#' Get fonts, styles, and graphics from an IDML object
#'
#' @name idml_resource
NULL

#' [get_idml_resource()] extracts a resource from an `idml` object in the
#' supplied format. [get_idml_fonts()], [get_idml_styles()],
#' [get_idml_graphic()], and [get_idml_preferences()] are helpers for extracting
#' the Fonts.xml, Styles.xml, Graphic.xml, and Preferences.xml files.
#'
#' By default, if `format = "data.frame"`, [get_idml_fonts()] returns a single
#' data.frame and [get_idml_styles()], [get_idml_graphic()], and
#' [get_idml_preferences()] returns a list of data.frame objects values present
#' in the input `idml` object. This format option is still under development and
#' does not return all available data from the `xml_document`. Note, for the
#' [get_idml_styles()], the `parent_nm` argument is ignored and may be removed.
#'
#' @name get_idml_resource
#' @inheritParams check_idml
#' @inheritParams get_idml_contents
#' @inheritDotParams get_idml_contents -dir -file
#' @inheritParams rlang::args_error_context
#' @rdname idml_resource
#' @export
get_idml_resource <- function(idml,
                              resource,
                              format = "xml_document",
                              ...,
                              error_call = caller_env()) {
  check_idml_resource(idml, resource, call = error_call)

  get_idml_contents(
    idml,
    dir = "Resources",
    file = resource,
    format = format,
    ...,
    error_call = error_call
  )
}

#' @name get_idml_fonts
#' @rdname idml_resource
#' @export
get_idml_fonts <- function(idml,
                           format = "xml_document",
                           parent_nm = NULL,
                           ...) {
  parent_nm <- parent_nm %||%
    "FontFamily"

  get_idml_resource(
    idml,
    "Fonts.xml",
    format = format,
    parent_nm = parent_nm,
    ...
  )
}

#' @name get_idml_styles
#' @rdname idml_resource
#' @export
get_idml_styles <- function(idml,
                            format = "xml_document",
                            type = NULL,
                            parent_nm = NULL,
                            ...) {
  # TODO: Remove the parent_nm argument if it is not used.
  # parent_nm <- parent_nm %||%
  #   c(
  #     "RootCharacterStyleGroup", "RootParagraphStyleGroup", "TOCStyle",
  #     "RootCellStyleGroup", "RootTableStyleGroup", "RootObjectStyleGroup",
  #     "TrapPreset"
  #   )

  styles <- get_idml_resource(
    idml,
    "Styles.xml",
    format = format,
    ...
  )

  if (is.null(type)) {
    return(styles)
  }

  child_nm <- switch(type,
    "character" = "RootCharacterStyleGroup",
    "paragraph" = "RootParagraphStyleGroup",
    "toc" = "TOCStyle",
    "cell" = "RootCellStyleGroup",
    "table" = "RootTableStyleGroup",
    "object" = "RootObjectStyleGroup"
  )

  xml2::xml_child(styles, child_nm)
}

#' @name get_idml_graphic
#' @rdname idml_resource
#' @export
get_idml_graphic <- function(idml, format = "xml_document", parent_nm = NULL, ...) {
  parent_nm <- parent_nm %||%
    c(
      "Color", "Ink", "PastedSmoothShade",
      "Swatch", "Gradient", "StrokeStyle"
    )

  get_idml_resource(
    idml,
    "Graphic.xml",
    format = format,
    parent_nm = parent_nm,
    ...
  )
}

#' @name get_idml_preferences
#' @rdname idml_resource
#' @export
get_idml_preferences <- function(idml, format = "xml_document", parent_nm = NULL, ...) {
  parent_nm <- parent_nm %||%
    c(
      "ButtonPreference", "PrintPreference", "PrintBookletOption",
      "PrintBookletPrintPreference", "FrameFittingOption", "StoryPreference",
      "TextFramePreference", "TextPreference", "TextDefault", "DictionaryPreference",
      "AnchoredObjectDefault", "BaselineFrameGridOption", "FootnoteOption", "TextWrapPreference",
      "MojikumiUiPreference", "XMLImportPreference", "XMLExportPreference", "XMLPreference"
    )

  get_idml_resource(idml, "Preferences.xml", format = format, parent_nm = parent_nm, ...)
}

#' List styles from an idml object
#'
#' [idml_list_styles()] takes an idml object and returns a bare list with names,
#' properties, attributes, and content from the XML nodes definition the
#' paragraph, character, or other styles of the specified type.
#'
#' @inheritParams get_idml_styles
#' @param format Output format must be "list"
#' @inheritDotParams get_idml_styles
#' @examples
#' \dontrun{
#' if(interactive()){
#'   path <- system.file("idml/letter_portrait_standard.idml", package = "idmlr")
#'
#'   idml_obj <- read_idml(path)
#'
#'   idml_list_styles(idml_obj)
#'  }
#' }
#' @returns A bare list with four elements: a named list of style attributes
#'   (names are style names), properties for the style XML nodes, attributes for
#'   the style XML nodes, and the contents of each XML node.
#' @export
#' @importFrom xml2 xml_children xml_attrs xml_child xml_contents
idml_list_styles <- function(...,
                             type = "paragraph",
                             format = "list") {
  stopifnot(format == "list")
  styles <- get_idml_styles(..., format = "xml_document", type = type)

  child_styles <- styles |>
    # get paragraph styles
    xml_children()

  child_styles_attr <- child_styles |>
    xml_attrs()

  child_styles_props <- child_styles |>
    xml_children()

  child_styles_props_attr <- child_styles_props |>
    seq_along() |>
    map(
      \(i) {
        child_styles_props |>
          xml_child(i) |>
          xml_attrs()
      }
    )

  child_styles_props_children <- child_styles_props |>
    seq_along() |>
    map(
      \(i) {
        child_styles_props |>
          xml_child(i) |>
          xml_contents()
      }
    )


  list(
    set_names(
      child_styles_attr,
      map(child_styles_attr, "Name")
    ),
    child_styles_props,
    child_styles_props_attr,
    child_styles_props_children
  )
}
