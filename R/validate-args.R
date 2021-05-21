# validate the various arguments passed to the main get_education_data call
#
# each argument is validated and the enpoints data frame is subset
# the endpoints data frame should contain only one row once this validation
# is complete
#
# returns a subset of the endpoints df matching the specified endpoint call
validate_function_args <- function(level,
                                   source,
                                   topic,
                                   by,
                                   url_path) {

  endpoints <- get_endpoint_info(url_path)
  endpoints <- validate_level(endpoints, level)
  endpoints <- validate_source(endpoints, source)
  endpoints <- validate_topic(endpoints, source, topic)
  #endpoints <- validate_required_variables(endpoints, ...)
  endpoints <- validate_optional_variables(endpoints, by)

  if (nrow(endpoints) != 1) {
    stop('Error validating API endpoints.')
  }

  return(endpoints)
}

# validate a given level argument for an API call
#
# stops execution if given level not within valid levels of current API
# endpoints
#
# returns a subset of the endpoints df
validate_level <- function(endpoints, level) {
  valid_levels <- unique(endpoints$section)

  if (is.null(level)) {
    stop('"level" argument must be specified.\nValid levels are:\n\t',
         paste(valid_levels,
               collapse = ', '),
         call. = FALSE)
  } else if (!(level %in% valid_levels) || is.null(level)) {
    stop('"level" argument "', level, '" is invalid.\nValid levels are:\n\t',
         paste(valid_levels,
               collapse = '\n\t'),
         call. = FALSE)
  } else {
    endpoints <- endpoints[endpoints$section == level, ]
  }

  return(endpoints)
}

# validate a given source argument for an API call
#
# stops execution if a given source not within valid sources of a given level
# of current API endpoints
#
# returns a subset of the endpoints df
validate_source <- function(endpoints, source) {
  valid_sources <- unique(endpoints$class_name)

  if (is.null(source)) {
    stop('"source" argument must be specified.\nValid sources are:\n\t',
         paste(valid_sources,
               collapse = '\n\t'),
         call. = FALSE)
  } else if (!(source %in% valid_sources)) {
    stop('"source" argument "', source, '" is invalid.\nValid sources are:\n\t',
         paste(valid_sources,
               collapse = '\n\t'),
         call. = FALSE)
  } else {
    endpoints <- endpoints[endpoints$class_name == source, ]
  }

  return(endpoints)
}

# validate a given topic argument for an API call
#
# stops execution if a given topic not within valid topics for a given level and
# source of current API endpoints
#
# returns a subset of the endpoints df
validate_topic <- function(endpoints, source, topic) {
  valid_topics <- unique(endpoints$topic)

  if (source == 'saipe') {
    if (!is.null(topic)) {
      stop('Data source "saipe" does not accept a "topic" argument.',
           call. = FALSE)
    } else {
      return(endpoints)
    }
  }

  if(is.null(topic)) {
    stop('"topic" argument must be specified.\nValid topics are:\n\t',
         paste(valid_topics,
               collapse = '\n\t'),
         call. = FALSE)
  } else if (!(topic %in% valid_topics)) {
    stop('"topic" argument "', topic, '" is invalid.\nValid topics are:\n\t',
         paste(valid_topics,
               collapse = '\n\t'),
         call. = FALSE)
  } else {
    endpoints <- endpoints[endpoints$topic == topic, ]
  }

  return(endpoints)
}

# validate required variables
#
# stops execution if a non-valid combination of required variables is passed
#
# return a subset of endpoints
validate_required_variables <- function(endpoints, ...) {
  reqs <- endpoints$required_vars
  vars <- names(list(...))
  subs <- lapply(reqs, function(x) (all(x %in% vars) & all(vars %in% x)))
  subs <- unlist(subs)

  if (sum(subs) == 0) {
    vars <- paste(vars, collapse = '/')
    reqs <- paste(unlist(unique(reqs)), collapse = '" & "')
    stop('Requested endpoint requires that "', reqs, '" be specified.',
         call. = F)
  }

  endpoints <- endpoints[subs, ]

  return(endpoints)
}

get_required_varlist <- function(endpoints) {
  reqs <- unlist(endpoints$required_vars)
  required_vars <- vector('list', length(reqs))
  names(required_vars) <- reqs

  return(required_vars)
}

# validate optional variables
#
# stops execution if a non-valid combination of optional variables is passed
#
# return a subset of endpoints
validate_optional_variables <- function(endpoints, by) {
  opts <- endpoints$optional_vars
  subs <- lapply(opts, function(x) ((all(x %in% by) & all(by %in% x)) | (is.null(by) && all(is.na(x)))))
  subs <- unlist(subs)

  if (sum(subs) != 1) {
    stop(paste(by, collapse = '/'), ' is not a valid endpoint option.\n',
         'Valid endpoint options are:\n\t',
         paste(opts[!is.na(opts)], collapse = '\n\t'),
         call. = F)
  }

  endpoints <- endpoints[subs, ]

  return(endpoints)
}
