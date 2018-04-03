get_data <- function(url) {
  resp <- jsonlite::fromJSON(url)
  pages <- ceiling(resp$count / 100)
  count = 1

  df <- resp$results
  url <- resp[['next']]

  while (!(is.null(url))) {
    count = count + 1
    message(paste("Processing page", count, 'out of', pages))
    resp <- jsonlite::fromJSON(url)
    df <- rbind(df, resp$results)
    url <- resp[['next']]
  }

  return(df)

}
