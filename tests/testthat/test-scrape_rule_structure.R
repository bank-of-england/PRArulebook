test_that("scrape_rule_structure works", {
  expect_error(scrape_rule_structure())
  expect_error(scrape_rule_structure("a"))
})
