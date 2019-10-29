test_that("scrape_part_structure works", {
  # output of scrape_sector_structure
  # head only
  sector_structure <-
    structure(
      list(
        sector_name = c("High Level Standards", "Prudential Standards"),
        sector_url = c(
          "http://www.prarulebook.co.uk/rulebook/Content/Sector/216144/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Content/Sector/219456/16-11-2007"
        ),
        rulebook_url = c(
          "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007"
        )
      ),
      row.names = 1:2,
      class = "data.frame"
    )

  # check inputs
  expect_error(scrape_part_structure())

  # actual function call
  part_structure <-
    scrape_part_structure(sector_structure)

  # check if data frame is returned
  expect_s3_class(part_structure, "data.frame")

})
