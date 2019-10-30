test_that("scrape_rule_id works", {
  # check inputs
  expect_error(scrape_rule_id())
  expect_error(scrape_rule_id("a"))
  expect_error(scrape_rule_id("http"))

  # test if returns what's expected
  # define inputs
  rule_url <-
    "http://www.prarulebook.co.uk/rulebook/Content/Rule/216147/16-11-2007#216147"
  rule_no <-
    "#216147+ .div-row .rule-number"
  rule_text <-
    "#216147+ .div-row .col3"
  # function call
  rule_id <-
    scrape_rule_id(rule_url, rule_no, rule_text)
  expect_s3_class(rule_id, "data.frame")
  # assign NAs when blank url
  rule_id_blank <-
    scrape_rule_id(NA, rule_no, rule_text)
  expect_s3_class(rule_id_blank, "data.frame")
  returned_names_blank <- names(rule_id_blank)
  # check the names
  expected_names <- c("rule_number", "rule_text", "rule_url" )
  returned_names <- names(rule_id)
  expect_identical(expected_names, returned_names)
  expect_identical(expected_names, returned_names_blank)
})
