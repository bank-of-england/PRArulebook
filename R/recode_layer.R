#' Recode layer of the rulebook
#'
#' @param from Source layer. Rule, chapter, part, sector.
#' @param to Target layer. Available options: rule_url, rule_name,
#' chapter_url, chapter_name, part_url, part_name, sector_url, sector_name, all
#' @param structure_file Data frame. Output of \code{"get_structure"}.
#'
#' @return Data frame with recoded layers.
#' @export
#'
#' @examples
#' \dontrun{
#' rulebook_structure <- get_structure("16-11-2017")
#'
#' recode_layer("http://www.prarulebook.co.uk/rulebook/Content/Chapter/211140/16-11-2017",
#' to = "all", structure_file = rulebook_structure)
#'
#' recode_layer(rulebook_structure$part_url[2], "part_name", rulebook_structure)
#' }
recode_layer <- function(from, to = "all", structure_file) {

  # validate 'to' type
  if (!(
    to %in% c(
      "rule_url",
      "rule_name",
      "chapter_url",
      "chapter_name",
      "part_url",
      "part_name",
      "sector_url",
      "sector_name",
      "all"
    )
  )) {
    stop(
      "Provide correct 'to' argument.
      Available options: rule_url, rule_name,
      chapter_url, chapter_name, part_url, part_name,
      sector_url, sector_name, all."
    )
  }

  # extract link type from the url
  assign_link_type <- function(x) {
    ifelse(is.na(x), stop("Provide correct 'from' URL"),
           ifelse(
             grepl("Content/Part", x),
             "Part",
             ifelse(
               grepl("Content/Chapter", x),
               "Chapter",
               ifelse(
                 grepl("Content/Rule", x),
                 "Rule",
                 ifelse(grepl("Content/Sector", x), "Sector",
                        "Other")
               )
             )
           ))
  }
  # check the type of a 'from' link
  from_type <- assign_link_type(from)
  # assign appropriate variable name
  from_type_url <- ifelse(from_type == "Sector",
                          "sector_url",
                          ifelse(
                            from_type == "Part",
                            "part_url",
                            ifelse(
                              from_type == "Chapter",
                              "chapter_url",
                              ifelse(from_type == "Rule", "rule_url",
                                     stop("Incorrect URL"))
                            )
                          ))

  # check if 'from' column is in the structure file
  if (!(from_type_url %in% names(structure_file))) {
    stop("Check if 'from' argument was can be found in the 'structure_file'.")
  }

  from_df <- data.frame(from, stringsAsFactors = FALSE)
  # rename the column to match the structure file
  colnames(from_df) <- from_type_url

  # pull all columns from the structure file
  if (to == "all") {
    joined_layers <-
      dplyr::left_join(from_df, structure_file)

  } else {
    # choose columns to subset
    cols2select <- c(from_type_url, to)
    # subset the df to keep only from-to columns
    df_selected <- structure_file[, cols2select]

    joined_layers <-
      dplyr::left_join(from_df, df_selected)
  }

  return(joined_layers)
}
