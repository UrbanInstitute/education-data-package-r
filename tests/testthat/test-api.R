context("api")

test_that("api returns consistent results", {

  ids <- c(234669 , 236610 , 236692)

  df <- get_education_data(
    level = "college-university",
    source = "ipeds",
    topic = "finance",
    filters = list(year = 2016, unitid = ids)
  )

  expect_equal(ids, unique(df$unitid))
})
