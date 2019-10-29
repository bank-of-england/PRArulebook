#' Scrape the Rulebook structure
#'
#' High-level function to scrape the rulebook structure.
#'
#' @param rulebook_date Date of the rulebook. Use dd-mm-yyyy format.
#' @param layer Text. Can be: all (default), sector, part, chapter, or rule.
#'
#' @return Data frame with the rulebook structure.
#' @export
#'
#' @examples
#' \dontrun{
#' get_structure("16-11-2007")
#' get_structure("16-11-2007", layer = "sector")
#' get_structure("16-11-2007", layer = "part")
#' get_structure("16-11-2007", layer = "chapter")
#' get_structure("16-11-2007", layer = "rule")
#' }
get_structure <- function(rulebook_date, layer = "chapter") {
  # assign the error message
  date_error_message <-
  "Provide a correct date in dd-mm-yyyy format.
  From '01-01-2005' till today."

  # check the arguments
  if (missing(rulebook_date)) {
    stop(date_error_message)
  }

  # validate the input format
  if (is.na(as.Date(rulebook_date,
                    format = "%d-%m-%Y"))) {
    stop(date_error_message)
  }

  # validate type
  if (!(layer %in%
        c("rule", "chapter", "part", "sector"))) {
    stop("Provide a layer to scrape.
         Available options: rule, chapter, part, sector.")
  }

  # full URL example: http://www.prarulebook.co.uk/rulebook/Content/Part/216145/16-11-2007
  # home: http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007

  # check date - if lower than x then change '/rulebook' to '/handbook'
  # first date of 'Rulebook': http://www.prarulebook.co.uk/rulebook/Home/Rulebook/29-08-2015
  cutoff_date <- as.Date("29-08-2015", format = "%d-%m-%Y")
  date_date <- as.Date(rulebook_date, format = "%d-%m-%Y")

  #regulation_type <-
  if (date_date < cutoff_date) {
    rule_type <- "Handbook"
  }
  if (date_date >= cutoff_date) {
    rule_type <- "Rulebook"
  }

  # validate available date ranges
  # first version of the handbook in the current form
  oldest_handbook <- as.Date("01-01-2005", format = "%d-%m-%Y")
  # today's date
  latest_handbook <- as.Date(Sys.Date(), format = "%d-%m-%Y")
  #
  if (date_date < oldest_handbook | date_date > latest_handbook) {
    stop(date_error_message)
  }

  # message
  cat(paste("You are requesting the", rule_type, "as of", rulebook_date))
  cat("\n")

  # top URL
  base_url <- "http://www.prarulebook.co.uk"
  top_url <- paste0(base_url, "/rulebook/Home/", rule_type, "/", rulebook_date)

  ################
  ### SECTORS ###
  ##############

  if (layer == "sector") {
    sector_structure <- scrape_sector_structure(top_url)
    return(sector_structure)
  }

  ##############
  ### PARTS ###
  ############

  if (layer == "part") {
    sector_structure <- scrape_sector_structure(top_url)
    part_structure <- scrape_part_structure(sector_structure)
    return(part_structure)
  }

  #################
  ### CHAPTERS ###
  ###############

  if (layer == "chapter") {
    sector_structure <- scrape_sector_structure(top_url)
    part_structure <- scrape_part_structure(sector_structure)
    chapter_structure <- scrape_chapter_structure(part_structure)
    return(chapter_structure)
  }

  ##############
  ### RULES ###
  ############

  if (layer == "rule") {
    sector_structure <- scrape_sector_structure(top_url)
    part_structure <- scrape_part_structure(sector_structure)
    chapter_structure <- scrape_chapter_structure(part_structure)
    rule_structure <- scrape_rule_structure(chapter_structure, rulebook_date = rulebook_date)
    return(rule_structure)
  }

}
