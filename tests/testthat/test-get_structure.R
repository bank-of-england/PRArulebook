test_that("get_structure works", {
  expect_error(get_structure("16-11-200"))
  expect_error(get_structure("16-11-20100"))
  expect_error(get_structure("16-11-2007", layer = "paart"))

  # test if returns a data frame
  sector_structure <-
    get_structure("16-11-2007",
                  layer = "sector")
  expect_s3_class(sector_structure, "data.frame")
  part_structure <-
    get_structure("16-11-2007",
                  layer = "part")
  expect_s3_class(part_structure, "data.frame")
  chapter_structure <-
    get_structure("16-11-2007",
                  layer = "chapter")
  expect_s3_class(chapter_structure, "data.frame")

  # check if column names are correct
  expected_names <- c("sector_name", "sector_url", "rulebook_url")
  returned_names <- names(sector_structure)
  expect_identical(expected_names, returned_names)
})
