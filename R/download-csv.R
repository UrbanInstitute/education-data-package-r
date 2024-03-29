# construct csv urls from a given endpoint and required variables
#
# retrieves and parses endpoint data from api-downloads
#
# returns a list of download urls to be queried
construct_url_csv <- function(endpoints,
                              required_vars,
                              filters,
                              url_path) {

  required_vars <- parse_required_vars(required_vars, filters)

  required_vars <- parse_year(endpoints, required_vars)
  required_vars <- parse_grade(required_vars, csv = TRUE)
  required_vars <- parse_grade_edfacts(required_vars, csv = TRUE)
  required_vars <- parse_level_of_study(required_vars, csv = TRUE)
  filters <- parse_filters_csv(filters, required_vars)
  validate_filters(endpoints, filters, url_path)

  download_url <- paste0(
    url_path,
    '/api/v1/api-downloads/?endpoint_id=',
    endpoints$endpoint_id,
    '&mode=R')

  request <- httr::GET(download_url)

  if (request$status_code > 399) {
    stop('API currently unavailable. Please try again later.',
         call. = FALSE)
  }

  resp <- jsonlite::fromJSON(rawToChar(request$content))$results
  files <- resp$file_name[grepl('.csv', resp$file_name)]

  urls <- paste(url_path,
                "csv",
                endpoints$class_name,
                files,
                sep = '/')
  urls <- gsub(' ', '', urls)

  if ((length(urls) > 1) && ('year' %in% names(filters))) {
    urls <- urls[grepl(paste(filters$year, collapse = '|'), urls)]
  }

  if (length(files) < 1) {
    stop('no csv file found for the requested endpoint.',
         call. = FALSE)
  }

  return(list(urls = urls, required_vars = required_vars, filters = filters))
}

# match csv variables to their correct data type for parsing
#
# returns a string of col specs to be passed to readr::read_csv
get_csv_cols <- function(endpoints, urls, url_path) {
  varlist_url <- paste0(
    url_path,
    '/api/v1/api-endpoint-varlist/?endpoint_id=',
    endpoints$endpoint_id,
    '&mode=R'
  )
  request <- httr::GET(varlist_url)
  if (request$status_code > 399) {
    stop('API currently unavailable. Please try again later.',
         call. = FALSE)
  }
  varlist <- jsonlite::fromJSON(rawToChar(request$content))$results

  con <- file(urls[1], open = 'r')
  vars <- readLines(con, n = 1)
  vars <- unlist(strsplit(vars, ','))
  close(con)

  types <- varlist$data_type[match(vars, varlist$variable)]
  cols <- paste0(substr(types, 1, 1), collapse = '')
  cols <- gsub('s', 'c', cols)
  cols <- gsub('f', 'd', cols)
  cols <- gsub('i', 'n', cols)

  return(cols)
}

# retrieve and read in a single csv file from a download url
#
# returns a data.frame for a single csv file
download_csv <- function(url, cols, filters, verbose = TRUE) {
  if (verbose) {
    message('\nFetching data for ', basename(url), ' ...')
  }
  df <- readr::read_csv(url, col_types = cols, na = c('', '.'))
  df <- apply_csv_filters(df, filters)
  return(df)
}

# retrieve and combine all csv files for an api endpoint
#
# returns a full data.frame for an api endpoint
get_csv_data <- function(urls, cols, filters, verbose) {
  dfs <- lapply(urls, function(x) download_csv(x, cols, filters, verbose))
  df <- do.call(rbind, dfs)
  return(df)
}

# subset csv data.frame by filters
#
# returns a subsetted data.frame
apply_csv_filters <- function(df, filters) {

  for (filter in names(filters)) {
    conditions <- df[[filter]] %in% filters[[filter]]
    df <- df[conditions, ]
  }

  return(df)

}
