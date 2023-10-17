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
#' does not return all available data from the `xml_document`.
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
                            parent_nm = NULL,
                            ...) {
  parent_nm <- parent_nm %||%
    c(
      "RootCharacterStyleGroup", "RootParagraphStyleGroup", "TOCStyle",
      "RootCellStyleGroup", "RootTableStyleGroup", "RootObjectStyleGroup",
      "TrapPreset"
    )

  get_idml_resource(
    idml,
    "Styles.xml",
    format = format,
    parent_nm = parent_nm,
    ...
  )
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
