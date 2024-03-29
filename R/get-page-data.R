# retrieve results from all pages of an api query for a single year
#
# returns data.frame, or an error if query fails
get_year_data <- function(url, verbose = TRUE) {

  if (!grepl("stg", url)) {
    fetch <- gsub("https://educationdata.urban.org/api/v1/", "", url)

  } else {
    fetch <- gsub("https://educationdata-stg.urban.org/api/v1/", "staging ", url)
  }
  fetch <- gsub('\\mode=R&', '', fetch)
  fetch <- gsub('\\mode=R', '', fetch)
  if (verbose) {
    message('\nFetching data for ', fetch, ' ...')
  }
  request <- httr::GET(url)

  if (request$status_code == 504) {
    stop('The endpoint you are trying to reach is currently unavailable.\n',
         'Please try your query again later.\n',
         'Consider filing an issue with the development team if this issue persists.',
         call. = FALSE
         )
  }

  if (request$status_code != 200) {
    stop('Query page not found.\n',
         'Please double-check your arguments (especially filters).\n',
         'Consider filing an issue with the development team if this issue persists.',
         call. = FALSE)
  }

  resp <- jsonlite::fromJSON(rawToChar(request$content))
  expected_rows <- resp$count

  if (expected_rows == 0) {
    if (verbose) {
      warning('Query ', url, ' returned no results.', call. = FALSE)
    }
    df <- data.frame()
    return(df)
  }

  pages <- ceiling(expected_rows / nrow(resp$results))
  dfs <- vector('list', pages)
  count = 1

  dfs[[count]] <- resp$results
  url <- resp[['next']]

  while (!(is.null(url))) {
    count = count + 1
    if (verbose) {
      message(paste("Processing page", count, 'out of', pages))
    }
    request <- httr::GET(url)

    if (request$status_code == 504) {
      stop('The endpoint you are trying to reach is currently unavailable.\n',
           'Please try your query again later.\n',
           'Consider filing an issue with the development team if this issue persists.',
           call. = FALSE
      )
    }

    if (request$status_code != 200) {
      stop('Query page not found.\n',
           'Please double-check your arguments (especially filters).\n',
           'Consider filing an issue with the development team if this issue persists.',
           call. = FALSE)
    }

    resp <- jsonlite::fromJSON(rawToChar(request$content))
    dfs[[count]] <- resp$results
    url <- resp[['next']]
  }

  df <- do.call(rbind, dfs)

  if (nrow(df) != expected_rows & verbose) {
    warning('API call expected ', expected_rows, ' results but received ',
            nrow(df), '. Consider filing an issue with the development team.',
            call. = FALSE)
  }

  return(df)
}

# retrieve results from all pages of an api query across all given years
#
# returns data.frame
get_all_data <- function(urls, verbose = TRUE) {
  dfs <- lapply(urls, function(x) get_year_data(x, verbose))
  df <- do.call(rbind, dfs)
  return(df)
}
