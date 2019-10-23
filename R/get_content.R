#' Scrape the Rulebook content
#'
#' Extract the full text or links from the PRA Rulebook given the URL.
#'
#' @param x String. URL to scrape.
#' @param type String. Type of information to scrape. "text" or "links".
#' @param single_rule_selector String. Optional. CSS selector for individual rules.
#'
#' @return Data frame with URLs and corresponding text.
#' @export
#'
#' @examples
#' \dontrun{
#' get_content("http://www.prarulebook.co.uk/rulebook/Content/Chapter/242047/16-11-2007")
#' get_content("http://www.prarulebook.co.uk/rulebook/Content/Chapter/242047/16-11-2007", "links")
#' get_content("http://www.prarulebook.co.uk/rulebook/Content/Rule/211145/18-06-2019#211145", "text", "yes")
#' }
get_content <- function(x, type = "text", single_rule_selector = NULL) {

  if (!startsWith(x, "http")) { # TODO or WWW / prarulebook.co.uk
    stop("Provide a valid URL.")
  }

  # # TODO fix the checks
  # if (type %in% c("text", "links")) {
  #   stop("Provide a valid type to scrape: 'text' or 'links'.")
  # }

  # TODO check the URL type?

  # CSS selectors
  #selector_rule <- ".rule-number"
  selector_rule <- ".col1"
  selector_text <- ".col3"
  selector_date <- ".effective-date"
  selector_label <- ".rule-label"

  # rules require specific selector
  if (is.null(single_rule_selector)) {
    selector_links <- ".col3 a"
  }

  if (!is.null(single_rule_selector) && single_rule_selector == "yes") {
    # get the rule ID
    # TODO write a more robust regex
    rule_id <- stringr::str_sub(x, start = -6)
    # create the selector
    selector_links <- paste0("#", rule_id, "+ .div-row a")
  }

  # TODO return NA when selectors are not present

  # wrap in a function
  pull_nodes <- function(node_to_pull) {

    nodes_only <- httr::GET(x) %>%
      xml2::read_html() %>%
      rvest::html_nodes(node_to_pull)

    return(nodes_only)
  }

  # pull text
  if (type == "text") {
    # works on a chapter level

    # display
    cat(".")
    cat("\n")

    # scrape
    nodes_only_text <- pull_nodes(selector_text)
    nodes_text <- nodes_only_text %>% rvest::html_text()

    # TODO pull rule names/turn into df/clean
    # pull rules
    nodes_only_rule <- pull_nodes(selector_rule)
    nodes_rule <- nodes_only_rule %>% rvest::html_text()
    # remove the first element to equalise the length of text and rules
    nodes_rule <- nodes_rule[-1]

    # test DATE and LABEL
    # TODO turn into a function
    nodes_only_date <- pull_nodes(selector_date)
    nodes_date <- nodes_only_date %>% rvest::html_text()
    nodes_date <- nodes_date[-1]

    # check if content is available, i.e. chapter/part was effective
    if (length(nodes_only_text) > 0) {

      if (length(nodes_text) == length(nodes_rule)) {

        rule_text_df <-
          data.frame(rule_number = trimws(nodes_rule),
                     rule_text = trimws(nodes_text),
                     rule_date = trimws(nodes_date),
                     url = x,
                     stringsAsFactors = FALSE)
        # TODO clean rule_text_df
        # TODO rename 'url' based on the input type: chapter/rule etc.

        # deleted rules
        # e.g. MAR 4.1.3 http://www.prarulebook.co.uk/rulebook/Content/Chapter/242047/16-11-2007#242057
        rule_text_df$active <- !stringr::str_detect(rule_text_df$rule_number, "Inactive date")

        # TODO split rule into date rule etc.
        return(rule_text_df)

        # TODO when NA or unequal return a list?
      }
    } else {
      rule_text_df <- data.frame(rule_number = NA,
                                 rule_text = NA,
                                 url = x)
      return(rule_text_df)
    }
  }

  # pull links
  if (type == "links") {

    # display
    cat(".")
    cat("\n")

    # extract the links
    nodes_only_links <- pull_nodes(selector_links)

    # assign NAs if there are no links
    if (length(nodes_only_links) == 0) {

      nodes_links_text <- NA
      nodes_links <- NA

    }

    if (length(nodes_only_links) != 0) {

      nodes_links_text <-
        nodes_only_links %>%
        rvest::html_text() %>%
        trimws()

      nodes_links <-
        nodes_only_links %>%
        rvest::html_attr("href")
    }

    # turn into a DF
    # checks are added to deal with empty XML (nodes_only_links)
    links_df <- data.frame(from = x,
                           to = nodes_links,
                           to_text = nodes_links_text,
                           stringsAsFactors = FALSE)

    ### assign link type - used in cleaning the links (network_cleaning.R)
    assign_link_type <- function(x) {
      ifelse(is.na(x), NA,
             ifelse(grepl("Content/Part", x), "Part",
                    ifelse(grepl("Content/Chapter", x), "Chapter",
                           ifelse(grepl("Content/Rule", x), "Rule",
                                  ifelse(grepl("Content/Sector", x), "Sector",
                                         ifelse(grepl("LegalInstrument", x), "Legal",
                                                ifelse(grepl("/Glossary", x), "Glossary",
                                                       "Other")))))))
    }
    # run the link type assignment
    links_df$to_type <- assign_link_type(links_df$to)

    # clean the links - append "http:" if it's a rulebook url
    clean_to_link <- function(url_to_clean) {
      cleaned_url <-
        ifelse(startsWith(url_to_clean, "/rulebook/"),
               paste0("http://www.prarulebook.co.uk", url_to_clean),
               url_to_clean)
      return(cleaned_url)
    }

    # apply the cleaning function only on non-NA url
    links_df$to <- ifelse(is.na(links_df$to),
                          links_df$to,
                          clean_to_link(links_df$to))


    # return data frame with links
    return(links_df)
  }
}
