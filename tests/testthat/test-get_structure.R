test_that("get_structure works", {
  expect_error(get_structure("16-11-200"))
  expect_error(get_structure("16-11-20100"))
  expect_error(get_structure("16-11-2007", layer = "paart"))
})
