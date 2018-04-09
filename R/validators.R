# validate a given level argument for an API call
#
# stops execution if given level not within valid levels of current API endpoints
validate_level <- function(endpoints, level) {
  valid_levels <- unique(endpoints$section)
  if (!(level %in% valid_levels)) {
    stop('Invalid API level. Valid levels are: ', paste(valid_levels, collapse = ', '))
  }
}

# validate a given source argument for an API call
#
# stops execution if a given source not within valid sources of a given level
# of current API endpoints
validate_source <- function(endpoints, level, source) {
  valid_sources <- unique(endpoints$class_name[endpoints$section == level])

  if (!(source %in% valid_sources)) {
    stop('Invalid data source. Valid sources are: ', paste(valid_sources, collapse = ', '))
  }
}

# validate a given topic argument for an API call
#
# stops execution if a given topic not within valid topics for a iven level and
# source of current API endpoints
validate_topic <- function(endpoints, level, source, topic) {
  topics <- endpoints$topic[endpoints$section == level & endpoints$class_name == source]
  valid_topics <- unique(topics)

  if (source == 'saipe') {
    if (!is.null(topic)) {
      stop('Data source saipe does not accept a "topic" argument.')
    } else {
      return()
    }
  }

  if (!(topic %in% valid_topics) | is.null(topic)) {
    stop('Invalid topic. Valid topics are: ', paste(valid_topics, collapse = ', '))
  }
}

validate_required_args <- function(endpoints, level, source, topic, ...) {
  if (is.null(topic)) {
    url_stub <- paste('/api/v1', level, source, sep = '/')
  } else {
    url_stub <- paste('/api/v1', level, source, topic, sep = '/')
  }

  valid_endpoints <- endpoints[startsWith(endpoints$endpoint_url, url_stub), ]
  required_vars <- unique(unlist(valid_endpoints$required_vars))
  additional_args <- list(...)

  parse_additional_args <- function(required_var, additional_args) {
    if (required_var %in% names(additional_args)) {
      url_stub <<- paste(url_stub, additional_args[[required_var]], sep = '/')
    } else {
      stop('Argument ', required_var, ' is required.', call. = FALSE)
    }
  }

  lapply(required_vars, parse_additional_args, additional_args)
  return(url_stub)
}

construct_url <- function(level = NULL, source = NULL, topic = NULL, ...) {
  endpoints <- get_endpoint_info()
  validate_level(endpoints, level)
  validate_source(endpoints, level, source)
  validate_topic(endpoints, level, source, topic)

  url_stub <- validate_required_args(endpoints, level, source, topic, ...)
  #return(unique(valid_endpoints$required_vars))
  url <- paste0('https://ed-data-portal.urban.org', url_stub)
  return(url)
}
