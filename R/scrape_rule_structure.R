#' Scrape rule structure
#'
#' @param df Data frame with chapter URLs. Output of \code{"scrape_chapter_structure"}.
#' @param rulebook_date String. Date to scrape.
#'
#' @return Data frame with scraped rule structure.
#' @export
#'
#' @examples
#' \dontrun{
#' sectors <- scrape_sector_structure("http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007")
#' parts <- scrape_part_structure(sectors)
#' chapters <- scrape_chapter_structure(parts)
#' rules <- scrape_rule_structure(chapters, "16-11-2007")
#' }
scrape_rule_structure <- function(df, rulebook_date) {
  cat("\n")
  cat("--- Scraping RULES ---")
  cat("\n")

  # TODO add input validation

  # new method - extract IDs - allows getting rule URLs
  # get all rules and append to a data frame
  rules <-
    purrr::map_df(df$chapter_url, scrape_menu,
                  selector = "a", rulebook_date = rulebook_date)

  rules_chapters_parts_sectors <-
    dplyr::left_join(rules, df,
                     by = "chapter_url")

  return(rules_chapters_parts_sectors)
}
