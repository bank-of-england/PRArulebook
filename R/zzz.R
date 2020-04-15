# helper functions
#' @importFrom httr GET
#' @importFrom httr warn_for_status
#' @importFrom httr status_code
#'
# extract nodes - used in get_content
pull_nodes <- function(x, node_to_pull) {

  nodes_only_get <- httr::GET(x)

  # check if part is effective
  if (httr::status_code(nodes_only_get) == 200) {

    nodes_only <- nodes_only_get %>%
      xml2::read_html() %>%
      rvest::html_nodes(node_to_pull)

    return(nodes_only)
  }
  # if not 200 then return NA
  # e.g. http://www.prarulebook.co.uk/rulebook/Content/Part/229754/16-11-2007
  nodes_only <- NA
  return(nodes_only)
}
# function to extract text - used in get_content
extract_node_text <- function(y) {

  nodes_text <-
    ifelse(is.na(y) | length(y) == 0,
           NA,
           y %>% rvest::html_text() %>% trimws())
  return(nodes_text)
}
# extact results if page is active
extract_results <- function(x) {
  httr::warn_for_status(x)
  # if response is correct then return the page
  if (httr::status_code(x) == 200) {
    return(x)
  }
  # otherwise display the page and status code
  else {
    print(x)
    return(NULL)
  }
}
# used in 'get_content'
# TODO reorder to speed up checks
assign_link_type <- function(x) {
  ifelse(is.na(x), NA,
         ifelse(
           grepl("Content/Part", x),
           "Part",
           ifelse(
             grepl("Content/Chapter", x),
             "Chapter",
             ifelse(
               grepl("Content/Rule", x),
               "Rule",
               ifelse(
                 grepl("Content/Sector", x),
                 "Sector",
                 ifelse(
                   grepl("LegalInstrument", x),
                   "Legal",
                   ifelse(grepl("/Glossary", x), "Glossary",
                          "Other")
                 )
               )
             )
           )
         ))
}

# clean the links - append "http:" if it's a rulebook url
clean_to_link <- function(url_to_clean) {
  cleaned_url <-
    ifelse(
      startsWith(url_to_clean, "/rulebook/"),
      paste0("http://www.prarulebook.co.uk", url_to_clean),
      url_to_clean
    )
  return(cleaned_url)
}
