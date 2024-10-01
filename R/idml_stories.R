#' Pull the stories element from an idml object
#'
#' [idml_stories()] pulls the "Stories" elements from the "contents" of an idml
#' object.
#' @inheritParams validate_idml
#' @export
#' @keywords internal
idml_stories <- function(idml, error_call = caller_env()) {

  # TODO: Consider if this flexibility is going to be an issue later
  # If the flexibility below is removed, input validation should be added
  # validate_idml(idml, error_call = error_call)
  if (has_name(idml, "contents")) {
    stories <- idml[["contents"]][["Stories"]]
  } else if (has_name(idml, "Stories")) {
    stories <- idml[["Stories"]]
  }

  stories
}

#' List stories from the content of an idml object
#'
#' [idml_list_stories()] lists stories and related elements from a idml object.
#' [idml_list_story_paras()] returns just the ParagraphStyleRange element of the
#' stories.
#'
#' @inheritParams idml_stories
#' @param format Format of output to return. Must be "contents"
#' @returns A bare named list with four elements: Stories, StoryPreference,
#'   InCopyExportOption, and ParagraphStyleRange.
#' @examples
#' \dontrun{
#' if(interactive()){
#'   path <- system.file("idml/letter_portrait_standard.idml", package = "idmlr")
#'
#'   idml_obj <- read_idml(path)
#'
#'   idml_list_stories(idml_obj)
#'  }
#' }
#' @export
idml_list_stories <- function(idml, format = "contents") {
  stories <- idml_stories(idml)

  stopifnot(
    is_list_of_xml_documents(stories),
    format == "contents"
  )

  story_contents <- map(
    stories,
    \(x) {
      xml2::xml_contents(xml2::xml_contents(x))
    }
  )

  story_incopy_options <- map(
    story_contents,
    \(x) {
      xml2::xml_find_first(x, "//InCopyExportOption")
    }
  )

  story_preferences <- map(
    story_contents,
    \(x) {
      xml2::xml_find_first(x, "//StoryPreference")
    }
  )

  story_paras <- map(
    story_contents,
    \(x) {
      xml2::xml_find_first(x, "//ParagraphStyleRange")
    }
  )

  list(
    "Stories" = story_contents,
    "StoryPreference" = story_preferences,
    "InCopyExportOption" = story_incopy_options,
    "ParagraphStyleRange" = story_paras
  )
}

#' @rdname idml_list_stories
#' @name idml_list_story_paras
#' @export
idml_list_story_paras <- function(idml, ...) {
  story_contents <- idml_story_contents(idml, ...)

  story_contents[["ParagraphStyleRange"]]
}
