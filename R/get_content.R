#' Scrape the Rulebook content
#'
#' Extract the full text or links from the PRA Rulebook given the URL.
#'
#' @param x String. URL to scrape.
#' @param type String. Type of information to scrape.
#' Valid arguments: "text" or "links".
#' @param single_rule_selector String. Optional.
#' Is CSS there a selector for individual rules? If "yes" then provide
#' rule-level URLs to scrape. Leave blank for levels levels
#' above rule (e.g. chapter, part or sector).
#'
#' @return Data frame with URLs and corresponding text.
#' @export
#'
#' @examples
#' \dontrun{
#' get_content(
#' "http://www.prarulebook.co.uk/rulebook/Content/Chapter/242047/16-11-2007")
#' get_content(
#' "http://www.prarulebook.co.uk/rulebook/Content/Chapter/242047/16-11-2007",
#' "links")
#' get_content(
#' "http://www.prarulebook.co.uk/rulebook/Content/Rule/211145/18-06-2019#211145",
#' "text",
#' single_rule_selector = "yes")
#' }
get_content <- function(x, type = "text", single_rule_selector = NULL) {

  if (!startsWith(x, "http")) { # TODO or WWW / prarulebook.co.uk
    stop("Provide a valid URL.")
  }

  # CSS selectors
  #selector_rule <- ".rule-number"
  selector_rule <- ".col1"
  selector_text <- ".col3"
  #selector_date <- ".effective-date"
  #selector_label <- ".rule-labels li"
  selector_links <- ".col3 a"

  # check correct argument
  if (!is.null(single_rule_selector)) {
    if (single_rule_selector != "yes") {
      stop("Use 'single_rule_selector' set to 'yes' if you want to scrape single rules.")
    }
    # check if URL is correct
    if (!grepl("Content/Rule", x)) {
      stop("Use rule-level URLs.")
    }
    # get the rule ID
    rule_id <- sub(".*#", "", x)
    # create a selector for rule text
    selector_text <- paste0("#", rule_id, "+ .div-row .col3")
    # rule column
    selector_rule <- paste0("#", rule_id, "+ .div-row .col1")
    # links
    selector_links <- paste0("#", rule_id, "+ .div-row .col3 a")
  }

  # check if url is a glossary. if so, use glossary-specific selectors
  if (grepl("Glossary", x)) {
    selector_text <- ".GlossaryPara"
    selector_rule <- ".glossary-term"
    selector_links <- ".GlossaryPara a"
  }

  # pull text
  if (type == "text") {

    # display
    cat(x)
    cat("\n")

    # scrape
    nodes_only_text <- PRArulebook:::pull_nodes(x, selector_text)
    nodes_text <- PRArulebook:::extract_node_text(nodes_only_text)
    # check the length
    if (length(nodes_only_text) == 0) {
      nodes_only_text <- NA
    }

    # pull rules
    nodes_only_rule <- PRArulebook:::pull_nodes(x, selector_rule)
    nodes_rule <- PRArulebook:::extract_node_text(nodes_only_rule)
    # remove the first element to equalise the length of text and rules
    # run it only for non-rules (i.e. higher levels like chapter etc.)
    if (is.null(single_rule_selector) & length(nodes_rule) > 1) {
      nodes_rule <- nodes_rule[2:length(nodes_rule)]
    }

    # check if content is available, i.e. chapter/part was effective
    if (length(nodes_only_text) > 0 & !is.na(nodes_only_text)) {

      # check if length if equal
      if (length(nodes_text) == length(nodes_rule)) {

        rule_text_df <-
          data.frame(rule_number = nodes_rule,
                     rule_text = nodes_text,
                     url = x,
                     stringsAsFactors = FALSE)
        # TODO clean rule_text_df
        # TODO rename 'url' based on the input type: chapter/rule etc.

        # deleted rules
        # e.g. MAR 4.1.3 http://www.prarulebook.co.uk/rulebook/Content/Chapter/242047/16-11-2007#242057
        rule_text_df$active <-
          !stringr::str_detect(rule_text_df$rule_number, "Inactive date")

        # TODO split rule into date rule etc.
        return(rule_text_df)
      }
    }
    else {
      #display info
      print(paste0("Check the quality of ", x))

      rule_text_df <- data.frame(rule_number = NA,
                                 rule_text = NA,
                                 url = x,
                                 active = NA,
                                 stringsAsFactors = FALSE)
      return(rule_text_df)
    }
  }

  # pull links
  if (type == "links") {

    # display the URL - useful for debugging
    cat(x)
    cat("\n")

    # extract the links
    nodes_only_links <- PRArulebook:::pull_nodes(x, selector_links)

    # assign NAs if there are no links
    # e.g. http://www.prarulebook.co.uk/rulebook/Glossary/FullDefinition/64738/16-05-2005
    empty_nodes_only_links <- any(length(nodes_only_links) == 0, is.na(nodes_only_links))

    if (empty_nodes_only_links) {

      nodes_links_text <- NA
      nodes_links <- NA
      }

    if (!empty_nodes_only_links) {

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

    # run the link type assignment
    links_df$to_type <- PRArulebook:::assign_link_type(links_df$to)

    # apply the cleaning function only on non-NA url
    links_df$to <- ifelse(is.na(links_df$to),
                          links_df$to,
                          PRArulebook:::clean_to_link(links_df$to))

    # return data frame with links
    return(links_df)
  }
}
