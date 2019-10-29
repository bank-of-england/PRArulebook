test_that("scrape_menu works", {
  # url
  expect_error(scrape_menu("rulebook/Home/Handbook/16-11-2007",
                           ".nav-child a"))
  # selector
  expect_error(
    scrape_menu(
      "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007"
    )
  )
  expect_error(
    scrape_menu(
      "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007",
      NULL
    )
  )
  # check outputs
  rule_menu <-
    scrape_menu(
      "http://www.prarulebook.co.uk/rulebook/Content/Chapter/242047/16-11-2007",
      "a",
      rulebook_date = "16-11-2007"
    )
  # does it return a data frame?
  expect_s3_class(rule_menu, "data.frame")
  # are the names correct?
  expected_names <-
    c(
      "rule_url",
      "rule_id",
      "rule_number_sel",
      "rule_text_sel",
      "rule_link_sel",
      "chapter_url"
    )
  returned_names <- names(rule_menu)
  expect_identical(expected_names, returned_names)
})
