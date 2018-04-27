# validate a given level argument for an API call
#
# stops execution if given level not within valid levels of current API endpoints
validate_level <- function(endpoints, level) {
  valid_levels <- unique(endpoints$section)

  if (!(level %in% valid_levels)) {
    stop('Invalid API level. Valid levels are: ',
         paste(valid_levels, collapse = ', '))
  } else {
    endpoints <- endpoints[endpoints$section == level, ]
  }

  return(endpoints)
}

# validate a given source argument for an API call
#
# stops execution if a given source not within valid sources of a given level
# of current API endpoints
validate_source <- function(endpoints, source) {
  valid_sources <- unique(endpoints$class_name)

  if (!(source %in% valid_sources)) {
    stop('Invalid data source. Valid sources are: ',
         paste(valid_sources, collapse = ', '))
  } else {
    endpoints <- endpoints[endpoints$class_name == source, ]
  }

  return(endpoints)
}

# validate a given topic argument for an API call
#
# stops execution if a given topic not within valid topics for a iven level and
# source of current API endpoints
validate_topic <- function(endpoints, source, topic) {
  valid_topics <- unique(endpoints$topic)

  if (source == 'saipe') {
    if (!is.null(topic)) {
      stop('Data source saipe does not accept a "topic" argument.')
    } else {
      return()
    }
  }

  if (!(topic %in% valid_topics) | is.null(topic)) {
    stop('Invalid topic. Valid topics are: ',
         paste(valid_topics, collapse = ', '))
  } else {
    endpoints <- endpoints[endpoints$topic == topic, ]
  }

  return(endpoints)
}

validate_year <- function(endpoints, level, source, topic, year) {
  if (source == 'saipe') {
    years <- endpoints$parsed_years[endpoints$section == level & endpoints$class_name == source]
  } else {
    years <- endpoints$parsed_years[endpoints$section == level & endpoints$class_name == source & endpoints$topic == topic]
  }
  valid_years <- unlist(unique(years))

  if (!(year %in% valid_years)) {
    stop(paste(year, 'is not a valid year for the requested endpoint.'),
         call. = FALSE)
  }
}

# validate required arguments for an API call
validate_vars <- function(endpoints, level, source, topic, ..., by) {
  if (is.null(topic)) {
    url_stub <- paste('/api/v1', level, source, sep = '/')
  } else {
    url_stub <- paste('/api/v1', level, source, topic, sep = '/')
  }

  valid_endpoints <- endpoints[startsWith(endpoints$endpoint_url, url_stub), ]
  required_vars <- unique(unlist(valid_endpoints$required_vars))
  additional_args <- list(...)
  by <- unlist(by)
  optional_vars <- valid_endpoints$optional_vars

  parse_required_args <- function(required_var, additional_args) {
    if (required_var %in% names(additional_args)) {
      if (required_var == 'year') {
        year <- additional_args[['year']]
        validate_year(endpoints, level, source, topic, year)
      }
      url_stub <<- paste(url_stub, additional_args[[required_var]], sep = '/')
      additional_args[[required_var]] <<- NULL
    } else {
      stop('Argument ', required_var, ' is required.', call. = FALSE)
    }
  }

  check_optional_vars <- function(by) {
    all_optional_vars <- unlist(valid_endpoints$optional_vars)
    lapply(by, function (x) if (!(x %in% all_optional_vars)) stop(x, ' is not a valid endpoint option', call. = F))

  }

  parse_optional_vars <- function(optional_vars, by) {
    if (length(by) == 0) {
      return()
    }

    matches <- unlist(lapply(optional_vars, function(x) all(by %in% x) & all(x %in% by)))
    valid_endpoints <- valid_endpoints[matches, ]
    if (nrow(valid_endpoints) == 0) {
      stop(paste(by, collapse = '/'),
           ' is an invalid endpoint combination.',
           call. = F)
    }

    matched_vars <- unlist(valid_endpoints$optional_vars)
    lapply(matched_vars, function(x)  url_stub <<- paste(url_stub, x, sep = '/'))
    url_stub <<- paste0(url_stub, '/')
  }


  lapply(required_vars, parse_required_args, additional_args)
  check_optional_vars(by)
  parse_optional_vars(optional_vars, by)
  return(url_stub)
}

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
  return(url_stub)

}

# construct full url from given arguments
construct_url <- function(level,
                          source,
                          topic,
                          ...,
                          by,
                          filters) {

  endpoints <- get_endpoint_info()
  endpoints <- validate_level(endpoints, level)
  endpoints <- validate_source(endpoints, source)
  endpoints <- validate_topic(endpoints, source, topic)

  View(endpoints)

  url_stub <- validate_vars(endpoints, level, source, topic, ..., by = by)
  url_stub <- parse_filters(url_stub, filters)
  url <- paste0('https://ed-data-portal.urban.org', url_stub)
  url <- sub('\\&$', '', url)
  return(url)
}
