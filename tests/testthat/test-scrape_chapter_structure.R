test_that("scrape_chapter_structure works", {
  # parts is hardcoded output of
  # sectors <-
  #   scrape_sector_structure(
  #     "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007")
  # parts <- scrape_part_structure(sectors)
  # parts_hc <- head(parts, 3)

  parts_hc <-
    structure(
      list(
        part_name = c(
          "PRIN Principles for Businesses",
          "SYSC Senior Management Arrangements, Systems and Controls sourcebook",
          "COND Threshold Conditions"
        ),
        part_url = c(
          "http://www.prarulebook.co.uk/rulebook/Content/Part/216145/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Content/Part/216242/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Content/Part/217545/16-11-2007"
        ),
        sector_url = c(
          "http://www.prarulebook.co.uk/rulebook/Content/Sector/216144/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Content/Sector/216144/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Content/Sector/216144/16-11-2007"
        ),
        sector_name = c(
          "High Level Standards",
          "High Level Standards",
          "High Level Standards"
        ),
        rulebook_url = c(
          "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007"
        )
      ),
      row.names = c(NA, 3L),
      class = "data.frame"
    )

  # actual function call
  chapters <- scrape_chapter_structure(parts_hc)
  # check if returns a data frame
  expect_s3_class(chapters, "data.frame")
  # check inputs
  expect_error(scrape_chapter_structure())
  expect_error(scrape_chapter_structure("chapters"))
})
