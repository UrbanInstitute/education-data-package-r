#' Obtain data from the Urban Institute Education Data Portal API
#'
#' @param level API data level to query
#' @param source API data source to query
#' @param topic API data topic to query
#' @param subtopic Optional 'list' of grouping parameters to pass to an API call
#' @param by DEPRECATED in favor of `subtopic`
#' @param filters Optional 'list' of query values to filter an API call
#' @param add_labels Add variable labels (when applicable)? Defaults to FALSE.
#' @param csv Download the full csv file? Defaults to FALSE.
#'
#' @return A `data.frame` of education data
#'
#' @export
get_education_data <- function(level = NULL,
                               source = NULL,
                               topic = NULL,
                               subtopic = NULL,
                               by = NULL,
                               filters = NULL,
                               add_labels = FALSE,
                               csv = FALSE) {

  if (!is.null(by)) {
    warning("The `by` argument has been deprecated in favor of `subtopic`.\n",
            "Please update your script to use `subtopic` instead.")
    subtopic <- by
  }



  if (csv) {
    df <- get_education_data_csv(level, source, topic, subtopic, filters, add_labels)
  } else {
    df <- get_education_data_json(level, source, topic, subtopic, filters, add_labels)
  }

  return(df)

}


# retrieve education data via the json api endpoints
#
# returns a data.frame
get_education_data_json <- function(level = NULL,
                                    source = NULL,
                                    topic = NULL,
                                    by = NULL,
                                    filters = NULL,
                                    add_labels = FALSE) {

  url_path <- "https://educationdata.urban.org"

  endpoints <- validate_function_args(level = level,
                                      source = source,
                                      topic = topic,
                                      by = by,
                                      url_path = url_path)

  required_vars <- get_required_varlist(endpoints)

  urls <- construct_url(endpoints = endpoints,
                        required_vars = required_vars,
                        filters  = filters,
                        url_path)

  df <- get_all_data(urls)

  if(add_labels & nrow(df) != 0) {
    df <- add_variable_labels(endpoints, df, url_path)
  }

  return(df)
}

# retrieve education data via the csv api endpoints
#
# returns a data.frame
get_education_data_csv <- function(level = NULL,
                                   source = NULL,
                                   topic = NULL,
                                   by = NULL,
                                   filters = NULL,
                                   add_labels = FALSE) {

  url_path <- "https://educationdata.urban.org"

  endpoints <- validate_function_args(level = level,
                                      source = source,
                                      topic = topic,
                                      by = by,
                                      url_path)

  required_vars <- get_required_varlist(endpoints)

  resp <- construct_url_csv(endpoints = endpoints,
                            required_vars = required_vars,
                            filters  = filters,
                            url_path)

  urls <- resp$urls
  required_vars <- resp$required_vars
  filters <- resp$filters

  cols <- get_csv_cols(endpoints, urls, url_path)

  df <- get_csv_data(urls, cols, filters)

  if(add_labels & nrow(df) != 0) {
    df <- add_variable_labels(endpoints, df, url_path)
  }

  return(df)
}

