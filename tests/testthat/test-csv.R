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
