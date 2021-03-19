context('csv')

test_that('csv returns same results as api', {
  df1 <- get_education_data(level = 'college-university',
                            source = 'ipeds',
                            topic = 'student-faculty-ratio',
                            filters = list(year = 2009,
                                           unitid = c(100654,
                                                      100663,
                                                      100690,
                                                      100706 ,
                                                      100724)))
  df2 <- get_education_data(level = 'college-university',
                            source = 'ipeds',
                            topic = 'student-faculty-ratio',
                            filters = list(year = 2009,
                                           unitid = c(100654,
                                                      100663,
                                                      100690,
                                                      100706 ,
                                                      100724)),
                            csv = TRUE)

  expect_equal(nrow(df1), nrow(df2))
  expect_equal(ncol(df1), ncol(df2))
  expect_equal(sort(names(df1)), sort(names(df2)))
})

test_that("ipeds filters properly parsed when pulling from csv", {
  df1 <- get_education_data(level = "college-university",
                            source = "ipeds",
                            topic = "fall-enrollment",
                            filters = list(year = 2001,
                                           level_of_study = "undergraduate",
                                           class_level = 99,
                                           fips = 1),
                            subtopic = list("race", "sex"),
                            add_labels = TRUE,
                            csv = TRUE)

  df2 <- get_education_data(level = "college-university",
                            source = "ipeds",
                            topic = "fall-enrollment",
                            filters = list(year = 2001,
                                           level_of_study = "undergraduate",
                                           class_level = 99,
                                           fips = 1),
                            subtopic = list("race", "sex"),
                            add_labels = TRUE,
                            csv = FALSE)

  expect_gt(nrow(df1), 0)
  expect_equal(dim(df1), dim(df2))
})

test_that("ccd filters properly parsed when pulling from csv", {
  df1 <- get_education_data(
    level = 'schools',
    source = 'ccd',
    topic = 'enrollment',
    by = list('race', 'sex'),
    filters = list(year = 1986, grade = 'grade-99', fips = 1),
    add_labels = TRUE,
    csv = FALSE
  )

  df2 <- get_education_data(
    level = 'schools',
    source = 'ccd',
    topic = 'enrollment',
    by = list('race', 'sex'),
    filters = list(year = 1986, grade = "grade-99", fips = 1),
    add_labels = TRUE,
    csv = TRUE
  )

  expect_gt(nrow(df1), 0)
  expect_equal(dim(df1), dim(df2))
})

test_that("edfacts filters properly parsed when pulling from csv", {
  df1 <- get_education_data(
    level = 'schools',
    source = 'edfacts',
    topic = 'grad-rates',
    filters = list(year = 2017, fips = 56),
    add_labels = TRUE,
    csv = FALSE
  )

  df2 <- get_education_data(
    level = 'schools',
    source = 'edfacts',
    topic = 'grad-rates',
    filters = list(year = 2017, fips = 56),
    add_labels = TRUE,
    csv = TRUE
  )

  expect_gt(nrow(df1), 0)
  expect_equal(dim(df1), dim(df2))
})

