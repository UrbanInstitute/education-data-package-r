context("summary endpoints")

test_that("basic summary endpoints function call returns results", {
  skip_on_cran()

  df <- get_education_data_summary(
    level = "schools",
    source = "ccd",
    topic = "enrollment",
    stat = "sum",
    var = "enrollment",
    by = "fips"
  )

  expect_is(df, "data.frame")
  expect_gt(nrow(df), 0)
  expect_gt(ncol(df), 0)

})

test_that("summary endpoints function call handles subtopics", {
  skip_on_cran()

  df <- get_education_data_summary(
    level = "schools",
    source = "crdc",
    topic = "harassment-or-bullying",
    subtopic = "allegations",
    stat = "sum",
    var = "allegations_harass_sex",
    by = "fips"
  )

  expect_is(df, "data.frame")
  expect_gt(nrow(df), 0)
  expect_gt(ncol(df), 0)

})

test_that("summary endpoints function handles multiple group_by vars", {
  skip_on_cran()

  by <- c("fips", "race")

  df <- get_education_data_summary(
    level = "schools",
    source = "ccd",
    topic = "enrollment",
    stat = "sum",
    var = "enrollment",
    by = by
  )

  expect_is(df, "data.frame")
  expect_gt(nrow(df), 0)
  expect_gt(ncol(df), 0)
  expect_true(all(by %in% colnames(df)))

})

test_that("summary endpoints function handles filters correctly", {
  skip_on_cran()

  filters = list(
    fips = 6,
    year = 2004:2008
  )

  df <- get_education_data_summary(
    level = "schools",
    source = "ccd",
    topic = "enrollment",
    stat = "sum",
    var = "enrollment",
    by = "fips",
    filters = filters
  )

  expect_is(df, "data.frame")
  expect_gt(nrow(df), 0)
  expect_gt(ncol(df), 0)
  expect_true(all(filters$year %in% unique(df$year)))
  expect_true(all(filters$fips %in% unique(df$fips)))

})

test_that("summary endpoints function returns expected errors", {
  skip_on_cran()


  expect_error(

    df <- get_education_data_summary(
      level = "schools",
      source = "ccd",
      topic = "enrollment",
      stat = "fake",
      by = "fips",
      var = "enrollment"
    )

  )

  expect_error(

    df <- get_education_data_summary(
      level = "schools",
      source = "ccd",
      topic = "enrollment",
      stat = "sum",
      by = "fake",
      var = "enrollment"
    )

  )


})
