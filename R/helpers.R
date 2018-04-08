get_data_old <- function(url) {
  request <- httr::GET(url)
  resp <- jsonlite::fromJSON(rawToChar(request$content))
  pages <- ceiling(resp$count / 100)
  count = 1

  df <- resp$results
  url <- resp[['next']]

  while (!(is.null(url))) {
    count = count + 1
    message(paste("Processing page", count, 'out of', pages))
    request <- httr::GET(url)
    resp <- jsonlite::fromJSON(rawToChar(request$content))
    df <- rbind(df, resp$results)
    url <- resp[['next']]
  }

  return(df)

}

get_page_data <- function(page_url) {
  print(page_url)
  request <- httr::GET(page_url)
  resp <- jsonlite::fromJSON(rawToChar(request$content))
  df <- resp$results
  return(df)
}

get_data <- function(url) {
  request <- httr::GET(url)
  resp <- jsonlite::fromJSON(rawToChar(request$content))
  pages <- ceiling(resp$count / 100)

  if (pages > 2) {
    page_urls <- paste0(url, '?page=', 2:pages)
    page_urls <- c(url, page_urls)
  } else {
    return(resp$results)
  }

  dfs <- lapply(page_urls, get_page_data)
  df <- do.call(rbind, dfs)
  return(df)
}

get_data_parallel <- function(url) {
  request <- httr::GET(url)
  resp <- jsonlite::fromJSON(rawToChar(request$content))
  pages <- ceiling(resp$count / 100)

  if (pages > 2) {
    page_urls <- paste0(url, '?page=', 2:pages)
    page_urls <- c(url, page_urls)
  } else {
    return(resp$results)
  }

  cl <- parallel::makeCluster(6)
  dfs <- parallel::parLapply(cl, page_urls, get_page_data)
  parallel::stopCluster(cl)

  df<- do.call(rbind, dfs)
  return(df)
}
