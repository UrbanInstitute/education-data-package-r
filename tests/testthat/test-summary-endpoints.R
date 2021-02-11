context("summary endpoints")

test_that("basic summary endpoints function call returns results", {

  df <- get_education_data_summary(
    level = "schools",
    source = "ccd",
    topic = "enrollment",
    stat = "sum",
    var = "enrollment",
    by = "fips",
    staging = TRUE
  )

  expect_is(df, "data.frame")
  expect_gt(nrow(df), 0)
  expect_gt(ncol(df), 0)

})

test_that("summary endpoints function call handles subtopics", {

  df <- get_education_data_summary(
    level = "schools",
    source = "crdc",
    topic = "harassment-or-bullying",
    subtopic = "allegations",
    stat = "sum",
    var = "allegations_harass_sex",
    by = "fips",
    staging = TRUE
  )

  expect_is(df, "data.frame")
  expect_gt(nrow(df), 0)
  expect_gt(ncol(df), 0)

})

test_that("summary endpoints function handles multiple group_by vars", {

  by <- c("fips", "race")

  df <- get_education_data_summary(
    level = "schools",
    source = "ccd",
    topic = "enrollment",
    stat = "sum",
    var = "enrollment",
    by = by,
    staging = TRUE
  )

  expect_is(df, "data.frame")
  expect_gt(nrow(df), 0)
  expect_gt(ncol(df), 0)
  expect_true(all(by %in% colnames(df)))

})

test_that("summary endpoints function handles filters correctly", {

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
    filters = filters,
    staging = TRUE
  )

  expect_is(df, "data.frame")
  expect_gt(nrow(df), 0)
  expect_gt(ncol(df), 0)
  expect_true(all(filters$year %in% unique(df$year)))
  expect_true(all(filters$fips %in% unique(df$fips)))

})

test_that("summary endpoints function returns expected errors", {


  expect_error(

    df <- get_education_data_summary(
      level = "schools",
      source = "ccd",
      topic = "enrollment",
      stat = "fake",
      by = "fips",
      var = "enrollment",
      staging = TRUE
    )

  )

  expect_error(

    df <- get_education_data_summary(
      level = "schools",
      source = "ccd",
      topic = "enrollment",
      stat = "sum",
      by = "fake",
      var = "enrollment",
      staging = TRUE
    )

  )


})
