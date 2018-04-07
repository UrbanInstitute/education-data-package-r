validate_district_sources <- function(source) {
  valid_sources <- c('saipe', 'ccd')

  if (!(source %in% valid_sources) || is.null(source)) {
    stop('Invalid source. Valid sources are: ',
         paste(valid_sources, collapse = ', ')
    )
  }
}

validate_district_topics <- function(source, topic) {
  valid_topics <- c('finance')

  if (source == 'saipe') {
    if (!is.null(topic)) {
      stop('Data source saipe does not accept a "topic" argument.')
    }
  } else {
    if (!(topic %in% valid_topics) | is.null(topic)) {
      stop('Invalid topic for source ', source, '. Valid topics are: ',
           paste(valid_topics)
           )
    }
  }
}

validate_district_years <- function(source, topic, year) {

  if (is.null(year)) {
    stop('Error: missing year argument.')
  } else {
    year <- as.integer(year)
  }

  if (source == 'saipe') {
    endpoint_url <- paste('/api/v1', 'school-districts', source, '{year}/', sep = '/')
  } else {
    endpoint_url <- paste('/api/v1', 'school-districts', source, topic, '{year}/', sep = '/')
  }

  endpoints_url <- 'https://ed-data-portal.urban.org/api/v1/api-endpoints/'
  endpoints <- jsonlite::fromJSON(endpoints_url)$results

  unparsed_years <- endpoints$years_available[endpoints$endpoint_url == endpoint_url]
  unparsed_years <- gsub('and', '', unparsed_years)
  unparsed_years <- gsub(' ', '', unparsed_years)

  valid_years <- unlist(lapply(unparsed_years, parse_years))

  if (!(year %in% valid_years)) {
    stop('Invalid year argument.')
  }

}

parse_years <- function(unparsed_year) {
  if (nchar(unparsed_year) == 4) {
    as.integer(unparsed_year)
  }
  else if (nchar(unparsed_year) == 8) {
    start <- as.integer(substr(unparsed_year, 1, 4))
    end <- as.integer(substr(unparsed_year, 5, 8))
    start:end
  } else {
    stop('Error in year parsing...')
  }
}

construct_district_url <- function(source, topic, year) {
  if (source == 'saipe') {
    url <- paste('https://ed-data-portal.urban.org/api/v1',
                 'school-districts',
                 source,
                 year,
                 sep = '/')
  } else {
    url <- paste('https://ed-data-portal.urban.org/api/v1',
                 'school-districts',
                 source,
                 topic,
                 year,
                 sep = '/')
  }

  url
}


get_district_data <- function(source = NULL, topic = NULL, year = NULL) {
  validate_district_sources(source)
  validate_district_topics(source, topic)
  validate_district_years(source, topic, year)

  url <- construct_district_url(source, topic, year)
  get_data(url)
}



