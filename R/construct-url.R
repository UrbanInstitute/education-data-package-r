# construct urls from a given endpoint, required variables, and filters
#
# takes an endpoint_url, validates year, adds required variables in the
# appropriate position, and adds any given filters
#
# returns a list of API urls to be queried
construct_url <- function(endpoints,
                          required_vars,
                          filters,
                          url_path) {

  required_vars <- parse_required_vars(required_vars, filters)

  required_vars <- parse_year(endpoints, required_vars)
  required_vars <- parse_grade(required_vars)
  required_vars <- parse_grade_edfacts(required_vars)
  required_vars <- parse_level_of_study(required_vars)
  validate_filters(endpoints, filters, url_path)

  url_stub = paste0(url_path,
                    endpoints$endpoint_url,
                    '?mode=R')
  url_stub <- parse_filters(url_stub, filters, required_vars)

  url_combos <- expand.grid(required_vars)
  urls <- glue::glue_data(url_combos, url_stub)

  return(urls)
}

# parse required vars from filters
#
# returns a list of required var arguments and their values
parse_required_vars <- function(required_vars, filters) {
  filters <- filters[names(filters) %in% names(required_vars)]

  for (i in seq_along(filters)){
    name = names(filters[i])
    required_vars[[name]] <- filters[[name]]
  }

  return(required_vars)

}


# validate filters
#
#
validate_filters <- function(endpoints, filters, url_path) {
  url <- paste0(
    url_path,
    '/api/v1/api-endpoint-varlist/?endpoint_id=',
    endpoints$endpoint_id,
    '&mode=R'
    )

  res <- httr::GET(url)
  if (res$status_code > 399) {
    stop('API currently unavailable. Please try again later.',
         call. = FALSE)
  }
  varlist <- jsonlite::fromJSON(rawToChar(res$content))$results

  filter_vars <- names(filters)

  lapply(
    filter_vars,
    function(x) if ((!(x %in% varlist$variable)) ||
                    varlist[varlist$variable == x, ]$is_filter != 1) {
      stop(x, ' is not a valid filter variable for this endpoint.',
           call. = FALSE)
    }
  )


}

# parse filters and add to url
#
# returns a url_stub with filters added
parse_filters <- function(url_stub, filters, required_vars) {

  filters <- filters[!(names(filters) %in% names(required_vars))]

  if(length(filters) == 0) {
    return(url_stub)
  } else {
    url_stub <- paste0(url_stub, '&')
  }

  filter_stub <- ''

  for (i in seq_along(filters)){
    name = names(filters[i])
    filter = paste0(filters[[i]], collapse = ',')
    filter_stub <- paste0(filter_stub, name, '=', filter, '&')
  }

  url_stub <- paste0(url_stub, filter_stub)
  url_stub <- substr(url_stub, 1, nchar(url_stub) - 1)
  return(url_stub)

}

# parse filters to catch csv/api differences
parse_filters_csv <- function(filters, required_vars) {
  index <- names(filters)[which(names(filters) %in% names(required_vars))]
  filters[index] <- required_vars[index]
  return(filters)
}

# validate year argument
#
# returns a list of required variables with validated years
parse_year <- function(endpoints, required_vars) {

  if(!'year' %in% names(required_vars)) stop('year is not a vaild variable.')

  valid_years <- unlist(unique(endpoints$parsed_years))
  year <- required_vars$year
  if (is.null(year)) year <- 'all'

  if (length(year) == 1 && year == 'all') year <- valid_years

  lapply(year,
         function(x) if(!(x %in% valid_years)) {
           stop(x, ' is not a valid year for the requested endpoint.',
                call. = FALSE)
           }
         )

  required_vars$year <- year

  return(required_vars)
}

# validate grade argument
#
# returns a list of required variables with validated grade
parse_grade <- function(required_vars, csv = FALSE) {

  if (!('grade' %in% names(required_vars))) {
    return(required_vars)
  } else {
    grade <- as.character(required_vars$grade)
  }

  if (length(grade) == 0) grade <- 'all'

  if (csv) {

    valid_grades <- list(
      '-1' = c('grade-pk', 'pk', 'pre-k'),
      '0' = c('grade-k', 'k'),
      '1' = c('grade-1', '1'),
      '2' = c('grade-2', '2'),
      '3' = c('grade-3', '3'),
      '4' = c('grade-4', '4'),
      '5' = c('grade-5', '5'),
      '6' = c('grade-6', '6'),
      '7' = c('grade-7', '7'),
      '8' = c('grade-8', '8'),
      '9' = c('grade-9', '9'),
      '10' = c('grade-10', '10'),
      '11' = c('grade-11', '11'),
      '12' = c('grade-12', '12'),
      '13' = c('grade-13', '13'),
      '14' = c('grade-14', '14', 'adult-education'),
      '15' = c('grade-15', '15', 'ungraded'),
      '99' = c('grade-99', '99', 'total')
    )

  } else {
    valid_grades <- list(
      'grade-pk' = c('grade-pk', 'pk', 'pre-k'),
      'grade-k' = c('grade-k', 'k'),
      'grade-1' = c('grade-1', '1'),
      'grade-2' = c('grade-2', '2'),
      'grade-3' = c('grade-3', '3'),
      'grade-4' = c('grade-4', '4'),
      'grade-5' = c('grade-5', '5'),
      'grade-6' = c('grade-6', '6'),
      'grade-7' = c('grade-7', '7'),
      'grade-8' = c('grade-8', '8'),
      'grade-9' = c('grade-9', '9'),
      'grade-10' = c('grade-10', '10'),
      'grade-11' = c('grade-11', '11'),
      'grade-12' = c('grade-12', '12'),
      'grade-13' = c('grade-13', '13'),
      'grade-14' = c('grade-14', '14', 'adult-education'),
      'grade-15' = c('grade-15', '15', 'ungraded'),
      'grade-99' = c('grade-99', '99', 'total')
    )
  }

  if (length(grade) == 1 && grade == 'all') grade <- names(valid_grades)

  match <- lapply(names(valid_grades), function(x) grade %in% valid_grades[[x]])
  match <- lapply(match, function(x) as.logical(sum(x)))
  match <- unlist(match)

  if (sum(match) == 0) {
    stop(grade, ' is not a valid grade level. Valid grade levels are:\n\t',
         paste(names(valid_grades), collapse='\n\t'),
         call. = FALSE)
  } else{
    grade <- names(valid_grades[match])
    required_vars$grade <- grade
  }

  return(required_vars)
}

# validate grade_edfacts argument
#
# returns a list of required variables with validated grade_edfacts
parse_grade_edfacts <- function(required_vars, csv = FALSE) {

  if (!('grade_edfacts' %in% names(required_vars))) {
    return(required_vars)
  } else {
    grade <- as.character(required_vars$grade_edfacts)
  }

  if (length(grade) == 0) grade <- 'all'

  if (csv) {

    valid_grades <- list(
      '3' = c('grade-3', '3'),
      '4' = c('grade-4', '4'),
      '5' = c('grade-5', '5'),
      '6' = c('grade-6', '6'),
      '7' = c('grade-7', '7'),
      '8' = c('grade-8', '8'),
      '9' = c('grade-9', '9', '9-12'),
      '99' = c('grade-99', '99', 'total')
    )

  } else {

    valid_grades <- list(
      'grade-3' = c('grade-3', '3'),
      'grade-4' = c('grade-4', '4'),
      'grade-5' = c('grade-5', '5'),
      'grade-6' = c('grade-6', '6'),
      'grade-7' = c('grade-7', '7'),
      'grade-8' = c('grade-8', '8'),
      'grade-9' = c('grade-9', '9', '9-12'),
      'grade-99' = c('grade-99', '99', 'total')
    )

  }



  if (length(grade) == 1 && grade == 'all') grade <- names(valid_grades)

  match <- lapply(names(valid_grades), function(x) grade %in% valid_grades[[x]])
  match <- lapply(match, function(x) as.logical(sum(x)))
  match <- unlist(match)

  if (sum(match) == 0) {
    stop(grade, ' is not a valid grade_edfacts level. Valid grade levels are:\n\t',
         paste(names(valid_grades), collapse='\n\t'),
         call. = FALSE)
  } else{
    grade <- names(valid_grades[match])
    required_vars$grade_edfacts <- grade
  }

  return(required_vars)
}


# validate level_of_study argument
#
# returns a list of required variables with validated level_of_study
parse_level_of_study <- function(required_vars, csv = FALSE) {

  if (!('level_of_study' %in% names(required_vars))) {
    return(required_vars)
  } else {
    level_of_study <- as.character(required_vars$level_of_study)
  }

  if (length(level_of_study) == 0) level_of_study <- 'all'

  if (csv) {
    valid_study <- list('1' = c('1', 'undergraduate', 'undergrad'),
                        '2' = c('2','graduate', 'grad'),
                        '3' = c('3','first-professional'),
                        '4' = c('4', 'post-baccalaureate', 'post-bac', 'postbac'),
                        '99' = c('99', 'total'))

  } else {
    valid_study <- list('undergraduate' = c('undergraduate', 'undergrad'),
                        'graduate' = c('graduate', 'grad'),
                        'first-professional' = c('first-professional'),
                        'post-baccalaureate' = c('post-baccalaureate',
                                                 'post-bac',
                                                 'postbac'),
                        '99' = c('99', 'total'))
  }

  if (length(level_of_study) == 1 && level_of_study == 'all') {
    level_of_study <- names(valid_study)
  }

  match <- lapply(names(valid_study), function(x) level_of_study %in% valid_study[[x]])
  match <- lapply(match, function(x) as.logical(sum(x)))
  match <- unlist(match)

  if (sum(match) == 0) {
    stop(level_of_study, ' is not a valid level of study. Valid levels are:\n\t',
         paste(names(valid_study), collapse='\n\t'),
         call. = FALSE)
  } else{
    level_of_study <- names(valid_study[match])
    if (csv) level_of_study <- as.integer(level_of_study)
    required_vars$level_of_study <- level_of_study
  }

  return(required_vars)
}
