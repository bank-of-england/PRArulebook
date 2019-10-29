test_that("get_content works", {
  expect_error(get_content("rulebook/Content/Chapter/242047/16-11-2007"))

  # check if data frame is returned
  one_rule <-
    get_content("http://www.prarulebook.co.uk/rulebook/Content/Rule/211145/18-06-2019#211145",
                "text",
                "yes")
  expect_s3_class(one_rule, "data.frame")

  # check if the names are as expected
  expected_names <-
    c("rule_number", "rule_text", "rule_date", "url", "active")
  returned_names <- names(one_rule)
  expect_identical(expected_names, returned_names)

  # test if links are scraped
  links_content <-
    get_content(
    "http://www.prarulebook.co.uk/rulebook/Content/Chapter/242047/16-11-2007",
    "links")
  expect_s3_class(links_content, "data.frame")
  # test the column names
  expected_names_links <- c("from", "to", "to_text", "to_type")
  returned_names_links <- names(links_content)
  expect_identical(expected_names_links, returned_names_links)
})
