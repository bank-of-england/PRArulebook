#' Scrape rules within the scrape_menu function
#'
#' Helper function
#'
#' @param url String. URL to scrape.
#' @param nodes_only XML nodes. Output of \code{"scrape_menu"}
#' @param rulebook_date String. Date to scrape.
#'
#' @return Data frame
#' @export
#'
#' @examples
#' \dontrun{
#' has_rules_url <- "http://www.prarulebook.co.uk/rulebook/Content/Chapter/218624/22-03-2006"
#' no_rules_url <- "http://www.prarulebook.co.uk/rulebook/Content/Chapter/219425/22-03-2006"
#' nodes_only <- httr::GET(no_rules_url) %>% PRArulebook:::extract_results()
#' nodes_only <-
#' nodes_only %>%
#'   xml2::read_html() %>%
#'   rvest::html_nodes("a")
#' scrape_menu_rule()
#' }
scrape_menu_rule <- function(url, nodes_only, rulebook_date) {
  IDs <- nodes_only %>% rvest::html_attr("id") %>% stats::na.omit()

  # TODO test if empty
  # e.g. http://www.prarulebook.co.uk/rulebook/Content/Chapter/302933/16-11-2017

  if (length(IDs) > 0) {
    # keep only the entries with numbers
    IDs <- ifelse(nchar(IDs) == 6, IDs, NA)
    IDs <- IDs[!is.na(IDs)]
    # TODO fix warning - suppressMessages() didn't work
    # .Warning message:
    IDs <- as.numeric(IDs)
    # if there were any characters then forcing them into numeric will turn them into NAs
    IDs <- IDs[!is.na(IDs)]

    # create actual URLs
    rule_urls <-
      paste0(
        "http://www.prarulebook.co.uk/rulebook/Content/Rule/",
        IDs,
        "/",
        rulebook_date,
        "#",
        IDs
      )

    # create selectors for rules
    rule_no_selector <-
      paste0("#", IDs, "+ .div-row .rule-number")
    rule_text_selector <-
      paste0("#", IDs, "+ .div-row .col3")
    rule_link_selector <-
      paste0("#", IDs, "+ .div-row a")

  } else {
    IDs <- NA
    rule_urls <- NA
    rule_no_selector <- NA
    rule_text_selector <- NA
    rule_link_selector <- NA

  }

  # make a df with rule URLs and add IDs
  rule_IDs <-
    data.frame(
      rule_url = rule_urls,
      rule_id = IDs,
      rule_number_sel = rule_no_selector,
      rule_text_sel = rule_text_selector,
      rule_link_sel = rule_link_selector,
      chapter_url = url,
      stringsAsFactors = FALSE
    )

  # assign the IDs
  nodes_df <- rule_IDs
  return(nodes_df)
}
