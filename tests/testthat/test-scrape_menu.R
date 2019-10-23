test_that("scrape_menu works", {
  # url
  expect_error(
    scrape_menu(
      "rulebook/Home/Handbook/16-11-2007",
      ".nav-child a"))
  # selector
  expect_error(
    scrape_menu(
      "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007"))
  expect_error(
    scrape_menu(
      "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007",
      NULL))
})
