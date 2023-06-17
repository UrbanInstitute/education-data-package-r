context('validation')

test_that('invalid api arguments return an error message', {
  skip_on_cran()
  expect_error(get_education_data(level = 'fake',
                                  source = 'ccd',
                                  topic = 'enrollment'))
  expect_error(get_education_data(level = 'schools',
                                  source = 'fake',
                                  topic = 'enrollment'))
  expect_error(get_education_data(level = 'schools',
                                  source = 'ccd',
                                  topic = 'fake'))
  expect_error(get_education_data(level = 'schools',
                                  source = 'ccd',
                                  topic = 'enrollment',
                                  subtopic = list('fake')))
  expect_error(get_education_data(level = 'schools',
                                  source = 'ccd',
                                  topic = 'enrollment',
                                  filters = list(fake = 'value')))
  expect_error(get_education_data(level = 'schools',
                                  source = 'ccd',
                                  topic = 'enrollment',
                                  filters = list(year = 1899)))
  expect_error(get_education_data(level = 'schools',
                                  source = 'ccd',
                                  topic = 'enrollment',
                                  filters = list(grade = 16)))
  expect_warning(get_education_data(level = 'schools',
                                    source = 'ccd',
                                    topic = 'directory',
                                    filters = list(year = 2014,
                                                   fips = 100)))
  expect_warning(get_education_data(level = "college-university",
                                    source = "ipeds",
                                    topic = "fall-enrollment",
                                    filters = list(year = 2001,
                                                   level_of_study = "undergraduate",
                                                   class_level = 99,
                                                   fips = 1),
                                    by = list("race", "sex")))
})


test_that('can quiet api messages with verbose = FALSE', {
  skip_on_cran()

  expect_warning(
    get_education_data(level = 'schools',
                       source = 'ccd',
                       topic = 'directory',
                       filters = list(year = 2014,
                                      fips = 100),
                       verbose = FALSE),
    regexp = NA
  )
})
