# construct urls from a given endpoint, required variables, and filters
#
# takes an endpoint_url, validates year, adds required variables in the
# appropriate position, and adds any given filters
#
# returns a list of API urls to be queried
construct_url <- function(endpoints,
                          required_vars,
                          filters) {

  required_vars <- parse_year(endpoints, required_vars)
  required_vars <- parse_grade(required_vars)

  url_stub = paste0('https://ed-data-portal.urban.org', endpoints$endpoint_url)
  url_stub <- parse_filters(url_stub, filters)
  urls <- do.call(glue::glue, c(url_stub , required_vars))
  return(urls)
}

# parse filters and add to url
#
# returns a url_stub with filters added
parse_filters <- function(url_stub, filters) {
  if(is.null(filters)) {
    return(url_stub)
  } else {
    url_stub <- paste0(url_stub, '?')
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

# validate year argument
#
# returns a list of required variables with validated years
parse_year <- function(endpoints, required_vars) {

  if(!'year' %in% names(required_vars)) stop('year is not a vaild variable.')

  valid_years <- unlist(unique(endpoints$parsed_years))
  year <- required_vars$year

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
#
parse_grade <- function(required_vars) {

  if (!('grade' %in% names(required_vars))) {
    return(required_vars)
  } else {
    grade <- as.character(required_vars$grade)
  }

  valid_grades <- list('grade-pk' = c('grade-pk', 'pk', 'pre-k'),
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
                    'grade-16' = c('grade-16', '16', 'k-12'),
                    'grade-20' = c('grade-20', '20', '7-8'),
                    'grade-21' = c('grade-21', '21', '9-10'),
                    'grade-22' = c('grade-22', '22', '11-12'),
                    'grade-99' = c('grade-99', '99', 'total'))

  match <- lapply(names(valid_grades), function(x) grade %in% valid_grades[[x]])
  match <- unlist(match)

  if (sum(match) != 1) {
    stop(grade, ' is not a valid grade level. Valid grade levels are:\n\t',
         paste(names(valid_grades), collapse='\n\t'),
         call. = FALSE)
  } else{
    grade <- names(valid_grades[match])
    required_vars$grade <- grade
  }

  return(required_vars)
}
