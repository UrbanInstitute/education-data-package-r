context('validation')

test_that('invalid api arguments return an error message', {
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
                                  by = list('fake')))
  expect_error(get_education_data(level = 'schools',
                                  source = 'ccd',
                                  topic = 'enrollment',
                                  filters = list(fake = 'value')))
  expect_error(get_education_data(level = 'schools',
                                  source = 'ccd',
                                  topic = 'enrollment',
                                  filters = list(year = 1899)))
  expect_warning(get_education_data(level = 'schools',
                                    source = 'ccd',
                                    topic = 'directory',
                                    filters = list(year = 2014,
                                                   fips = 100)))
})
