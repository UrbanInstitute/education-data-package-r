# retrieve information on available API endpoints
#
# returns a parsed data.frame of endpoint information
get_endpoint_info <- function(url_path) {
  url <- paste0(url_path, '/api/v1/api-endpoints/?mode=R')
  res <- httr::GET(url)
  if (res$status_code > 399) {
    stop('API currently unavailable. Please try again later.',
         call. = FALSE)
  }
  endpoints <- jsonlite::fromJSON(rawToChar(res$content))$results

  vars <- c('endpoint_id',
            'endpoint_url',
            'years_available',
            'section',
            'class_name',
            'topic',
            'sub_topic',
            'var_list_id')
  endpoints <- endpoints[vars]

  endpoints$section <- tolower(endpoints$section)
  endpoints$section <- gsub('_', '-', endpoints$section)

  endpoints$class_name <- tolower(endpoints$class_name)

  endpoints$topic <- unlist(lapply(endpoints$endpoint_url, get_topic))

  endpoints$required_vars <- lapply(endpoints$endpoint_url, get_required_vars)
  endpoints$optional_vars <- lapply(endpoints$endpoint_url, get_optional_vars)

  endpoints$parsed_years <- lapply(endpoints$years_available, get_available_years)

  return(endpoints)
}

# retrieve the required variables for a given API endpoint
#
# returns a vector of requried variables
get_required_vars <- function(endpoint_url) {
  args <- unlist(strsplit(endpoint_url, '/'))

  req_args <- args[grepl('\\{.*\\}', args)]
  req_args <- gsub('\\W', '', req_args)

  return(req_args)
}

# retrieve the optional variables for a given API endpoint
#
# returns a vector of optional variables
get_optional_vars <- function(endpoint_url) {
  args <- unlist(strsplit(endpoint_url, '/'))
  pos <- grep('\\{year\\}', args)
  args <- args[pos:length(args)]

  opt_args <- args[!(grepl('\\{.*\\}', args))]

  if (length(opt_args) == 0) {
    opt_args <- NA
  }

  return(opt_args)
}

# retrieve and parse the available years for a given API endpoint
#
# returns a vector of available years
get_available_years <- function(unparsed_years) {
  unparsed_years <- gsub('and', '', unparsed_years)
  unparsed_years <- gsub(' ', '', unparsed_years)
  unparsed_years <- gsub('-', '', unparsed_years)
  unparsed_years <- unlist(strsplit(unparsed_years, ','))

  parse_years <- function(unparsed_year) {
    if (nchar(unparsed_year) == 4) {
      as.integer(unparsed_year)
    } else {
      i = nchar(unparsed_year)
      start <- as.integer(substr(unparsed_year, 1, 4))
      end <- as.integer(substr(unparsed_year, i-3, i))
      start:end
    }
  }

  parsed_years <- unlist(lapply(unparsed_years, parse_years))
  return(parsed_years)
}

# Retrieve the topic of a given API endpoint
get_topic <- function(endpoint_url) {
  topic <- unlist(strsplit(endpoint_url, '/'))[6]
  if (grepl('\\{.*\\}', topic)) topic <- NA
  return(topic)
}
