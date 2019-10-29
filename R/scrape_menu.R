#' Scrape the menu
#'
#' Scrapes names and URLs from the PRA rulebook menu. The menu is on the left-hand side of the rulebook website.
#'
#' @param url String. URL to scrape.
#' @param selector String. CSS selector to scrape. Use Chrome with SelectorGadget to find the relevant selector.
#' @param rulebook_date String. Optional date. Needed only for rule ID scraping.
#'
#' @return Data frame with names and URLs of rulebook elements.
#' @export
#'
#' @examples
#' \dontrun{
#' scrape_menu("http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007", ".nav-child a")
#' scrape_menu("http://www.prarulebook.co.uk/rulebook/Content/Chapter/242047/16-11-2007", "a", rulebook_date = "16-11-2007")
#' }
scrape_menu <- function(url, selector, rulebook_date) {

  if (!startsWith(url, "http")) { # TODO or WWW / prarulebook.co.uk
    stop("Provide a valid URL.")
  }

  if (is.null(selector)) {
    stop("Provide a valid selector to scrape.")
  }

  # TODO add to zzz/onLoad (?)
  base_url <- "http://www.prarulebook.co.uk"

  # pull the html nodes
  # TODO add ua
  nodes_only <- httr::GET(url) %>% PRArulebook:::extract_results()

  if (is.null(nodes_only)) {
    # e.g. this URL can be returned as empty because it is not active anymore
    # http://www.prarulebook.co.uk/rulebook/Content/Part/229754/12-11-2012
    nodes_df <- data.frame(name = NA,
                           menu_url = NA,
                           provided_url = url,
                           stringsAsFactors = FALSE)
    return(nodes_df)
  }

  nodes_only <-
    nodes_only %>%
    xml2::read_html() %>%
    rvest::html_nodes(selector)

  # pull text
  nodes_text <-
    nodes_only %>%
    rvest::html_text() %>%
    # remove white spaces
    textclean::replace_white() %>%
    trimws()

  # check if element is effective
  # e.g. "http://www.prarulebook.co.uk/rulebook/Content/Part/229754/16-11-2007"
  if (length(nodes_text) == 0) {
    nodes_text <- NA
  }

  # pull url
  nodes_url <-
    nodes_only %>%
    rvest::html_attr("href") %>%
    paste0(base_url, .)
  # check if element is effective
  # nodes have no text then this element is not effective
  nodes_url <- ifelse(is.na(nodes_text), NA, nodes_url)

  # rules have no URLs when scraped from the chapter level
  if (selector == ".rule-number") {
    nodes_url <- NA
  }

  # scrape rule IDs and create URLs from them
  if (selector == "a") {
    nodes_df <- scrape_menu_rule(url, nodes_only, rulebook_date)
    return(nodes_df)
  }

  # combine vectors
  nodes_df <- data.frame(name = nodes_text,
                         menu_url = nodes_url,
                         provided_url = rep(url, length(nodes_text)),
                         stringsAsFactors = FALSE)

  return(nodes_df)
}
