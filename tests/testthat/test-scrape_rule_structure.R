test_that("scrape_rule_structure works", {
  expect_error(scrape_rule_structure())
  expect_error(scrape_rule_structure("a"))

  # test the output
  chapters_test <-
    structure(
      list(
        chapter_name = "PRIN 1 Introduction",
        chapter_url = "http://www.prarulebook.co.uk/rulebook/Content/Chapter/216146/16-11-2007",
        part_url = "http://www.prarulebook.co.uk/rulebook/Content/Part/216145/16-11-2007",
        part_name = "PRIN Principles for Businesses",
        sector_url = "http://www.prarulebook.co.uk/rulebook/Content/Sector/216144/16-11-2007",
        sector_name = "High Level Standards",
        rulebook_url = "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007"
      ),
      row.names = 1L,
      class = "data.frame"
    )
  rules_test <-
    scrape_rule_structure(chapters_test, "16-11-2007")
  expect_s3_class(rules_test, "data.frame")
  # check the names
  expected_names <-
    c(
      "rule_url",
      "rule_id",
      "rule_number_sel",
      "rule_text_sel",
      "rule_link_sel",
      "chapter_url",
      "chapter_name",
      "part_url",
      "part_name",
      "sector_url",
      "sector_name",
      "rulebook_url"
    )
  returned_names <- names(rules_test)
  expect_identical(expected_names, returned_names)
  # check the expected dimensions
  expect_equal(c(31, 12), dim(rules_test))
})
