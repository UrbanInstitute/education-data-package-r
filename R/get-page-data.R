# retrieve results from all pages of an api query for a single year
#
# returns data.frame, or an error if count != nrow(data.frame)
get_year_data <- function(url) {
  message('\nFetching data for ', substring(url, 41), ' ...')
  request <- httr::GET(url)

  if (request$status_code != 200) {
    stop('Query page not found.\n',
         'Please double-check your arguments (especially filters).\n',
         'Consider filing an issue with the development team if this issue persists.',
         call. = FALSE)
  }

  resp <- jsonlite::fromJSON(rawToChar(request$content))
  expected_rows <- resp$count

  if (expected_rows == 0) {
    stop('Query returned no results.', call. = FALSE)
  }

  pages <- ceiling(expected_rows / nrow(resp$results))
  dfs <- vector('list', pages)
  count = 1

  dfs[[count]] <- resp$results
  url <- resp[['next']]

  while (!(is.null(url))) {
    count = count + 1
    message(paste("Processing page", count, 'out of', pages))
    request <- httr::GET(url)
    resp <- jsonlite::fromJSON(rawToChar(request$content))
    dfs[[count]] <- resp$results
    url <- resp[['next']]
  }

  df <- do.call(rbind, dfs)

  if (nrow(df) != expected_rows) {
    warning('API call expected ', expected_rows, ' results but received ',
            nrow(df), '. Consider filing an issue with the development team.',
            call. = FALSE)
  }

  return(df)
}

# retrieve results from all pages of an api query across all given years
#
# returns data.frame
get_all_data <- function(urls) {
  dfs <- lapply(urls, get_year_data)
  df <- do.call(rbind, dfs)
  return(df)
}
