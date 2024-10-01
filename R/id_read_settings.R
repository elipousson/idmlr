#' Read exported Adobe InDesign user application settings
#'
#' Adobe InDesign user application settings can be exported to a SQLite database
#' containing XML files. This function reads the
#'
#' @param path Path to existing file with exported user application settings.
#' @param format Output format. Must be "data.frame"
#' @keywords internal
id_read_settings <- function(path, format = "data.frame") {
  check_installed(c("DBI", "RSQLite"))

  stopifnot(
    file.exists(path),
    format == "data.frame"
  )

  # Based on https://stackoverflow.com/a/9805131
  # Connect to settings file
  con <- DBI::dbConnect(
    drv = RSQLite::SQLite(),
    dbname = path
  )

  # List tables
  tables <- DBI::dbListTables(con)

  # Drop sqlite_sequence table (contains table list)
  tables <- tables[tables != "sqlite_sequence"]

  table_df <- list()

  ## create a data.frame for each table
  for (i in seq_along(tables)) {
    table_df[[i]] <- dbGetQuery(
      conn = con,
      statement = paste("SELECT * FROM '", tables[[i]], "'", sep = "")
    )
  }

  # TODO: table data frame contains a blob column with the XML files containing
  # the settings
  # See https://stackoverflow.com/questions/20547956/how-to-write-binary-data-into-sqlite-with-r-dbis-dbwritetable
  table_df
}
