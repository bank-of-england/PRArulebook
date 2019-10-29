test_that("recode_layer works", {
  # harcoded output of get_structure("16-11-2017")
  # only first three rows for simplicity
  rulebook_structure_head <-
    structure(
      list(
        chapter_name = c(
          "1 Application and Definitions",
          "2 Fundamental Rules",
          "3 Restrictions"
        ),
        chapter_url = c(
          "http://www.prarulebook.co.uk/rulebook/Content/Chapter/211140/16-11-2017",
          "http://www.prarulebook.co.uk/rulebook/Content/Chapter/211141/16-11-2017",
          "http://www.prarulebook.co.uk/rulebook/Content/Chapter/211142/16-11-2017"
        ),
        part_url = c(
          "http://www.prarulebook.co.uk/rulebook/Content/Part/211136/16-11-2017",
          "http://www.prarulebook.co.uk/rulebook/Content/Part/211136/16-11-2017",
          "http://www.prarulebook.co.uk/rulebook/Content/Part/211136/16-11-2017"
        ),
        part_name = c("Fundamental Rules", "Fundamental Rules", "Fundamental Rules"),
        sector_url = c(
          "http://www.prarulebook.co.uk/rulebook/Content/Sector/211131/16-11-2017",
          "http://www.prarulebook.co.uk/rulebook/Content/Sector/211131/16-11-2017",
          "http://www.prarulebook.co.uk/rulebook/Content/Sector/211131/16-11-2017"
        ),
        sector_name = c("CRR Firms", "CRR Firms", "CRR Firms"),
        rulebook_url = c(
          "http://www.prarulebook.co.uk/rulebook/Home/Rulebook/16-11-2017",
          "http://www.prarulebook.co.uk/rulebook/Home/Rulebook/16-11-2017",
          "http://www.prarulebook.co.uk/rulebook/Home/Rulebook/16-11-2017"
        )
      ),
      row.names = c(NA, 3L),
      class = "data.frame"
    )

  # test input validation
  expect_error(recode_layer(
    rulebook_structure_head$part_url[1],
    "part",
    rulebook_structure_head
  ))

  # returns data frame?
  recoded_df <- recode_layer(rulebook_structure_head$part_url[1],
                             "part_name",
                             rulebook_structure_head)

  expect_s3_class(recoded_df, "data.frame")

})
