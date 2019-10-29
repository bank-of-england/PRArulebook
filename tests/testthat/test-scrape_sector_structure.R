test_that("scrape_sector_structure works", {

  # working call
  sector_str_df <-
    scrape_sector_structure(
      "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007")
  # the expected result of the above call
  sector_str_df_hc <-
    structure(
      list(
        sector_name = c(
          "High Level Standards",
          "Prudential Standards",
          "Business Standards",
          "Regulatory Processes",
          "Redress",
          "Specialist sourcebooks",
          "Listing, Prospectus and Disclosure",
          "Handbook Guides",
          "Regulatory Guides"
        ),
        sector_url = c(
          "http://www.prarulebook.co.uk/rulebook/Content/Sector/216144/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Content/Sector/219456/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Content/Sector/229795/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Content/Sector/242676/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Content/Sector/250525/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Content/Sector/252705/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Content/Sector/261407/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Content/Sector/263932/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Content/Sector/265928/16-11-2007"
        ),
        rulebook_url = c(
          "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007",
          "http://www.prarulebook.co.uk/rulebook/Home/Handbook/16-11-2007"
        )
      ),
      class = "data.frame",
      row.names = c(NA,-9L)
    )

  # expected colummns
  expected_columns <- c("sector_name", "sector_url", "rulebook_url")
  actual_columns <- names(sector_str_df)

  # check if the expected column names are correct
  expect_identical(expected_columns, actual_columns)
  # check if the expected output is correct
  expect_identical(sector_str_df, sector_str_df_hc)
  # check if data frame is returned
  expect_s3_class(sector_str_df, "data.frame")
  # check if validates url
  expect_error(
    scrape_sector_structure(
      "rulebook/Home/Handbook/16-11-2007"))

})
