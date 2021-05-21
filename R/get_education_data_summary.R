#' Obtain data from the Urban Institute Education Data Portal API summary
#' endpoint functionality.
#'
#' @param level API data level to query
#' @param source API data source to query
#' @param topic API data topic to query
#' @param subtopic Optional additional parameters to pass to an API call. Only
#' applicable to certain endpoints.
#' @param stat Summary statistic to be calculated. Valid options
#' @param var Variable to be summarized.
#' @param by Variable(s) to group results by.
#' @param filters Optional 'list' of query values to filter an API call
#'
#' @return A `data.frame` of aggregated education data
#'
#' @export
get_education_data_summary <- function(level,
                                       source,
                                       topic = NULL,
                                       subtopic = NULL,
                                       stat = NULL,
                                       var = NULL,
                                       by = NULL,
                                       filters = NULL) {

  # set api path
  url_path <- "https://educationdata.urban.org/api/v1/"

  # set table
  endpoint <- paste(level, source, sep = "/")

  if (!is.null(topic)) {
    endpoint <- paste(endpoint, topic, sep = "/")
  }

  if (!is.null(subtopic)) {
    endpoint <- paste(endpoint, paste(subtopic, collapse = "/"), "summaries", sep = "/")
  } else {
    endpoint <- paste(endpoint, "summaries", sep = "/")
  }

  # set query string parameters
  query_params <- paste0(
    "?stat=", stat, "&",
    "var=", var, "&",
    "by=", paste(by, collapse = ",")
  )

  # set url
  url <- paste0(url_path, endpoint, query_params)

  # parse filters
  if(!is.null(filters)) {

    filters <- lapply(
      seq_along(filters),
      function(i) {
        paste(names(filters[i]), paste(filters[[i]], collapse = ","), sep = "=")
      }
    )

    filters <- paste(filters, collapse = "&")

    url <- paste(url, filters, sep = "&")

  }

  # add mode
  url <- paste0(url, "&mode=R")

  # call api
  response <- httr::GET(url)

  # parse response
  if (response$status_code == 200) {

    df <- jsonlite::fromJSON(rawToChar(response$content))$results

  } else if (response$status_code == 400) {

    stop(jsonlite::fromJSON(rawToChar(response$content)))

  } else if (response$status_code == 404) {

    stop("Sorry, but the requested page could not be found.",
         "This often happens when `level`, `source`, or `topic` are misspecified."
         )

  } else if (response$status_code == 413) {

    stop("Your requested query returned too many records.",
         "Consider limiting the scope of your query."
         )

  } else {

    stop("Sorry, but there was an error processing your request.")

  }

  return(df)

}
