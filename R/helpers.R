get_data <- function(url) {
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
