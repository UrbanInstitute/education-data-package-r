#' Obtain data from the Urban Institute Education Data Portal API
#'
#' @param level API data level to query
#' @param source API data source to query
#' @param topic API data topic to query
#' @param by Optional 'list' of grouping parameters to pass to an API call
#' @param filters Optional 'list' of query values to filter an API call
#' @param add_labels Add variable labels (when applicable)? Defaults to FALSE.
#' @param csv Download the full csv file? Defaults to FALSE.
#'
#' @return A `data.frame` of education data
#'
#' @examples \dontrun{
#' library(educationdata)
#' df <- get_education_data(level = 'school-districts', source = 'ccd', topic = 'finance')
#' }
#'
#' @export
get_education_data <- function(level = NULL,
                               source = NULL,
                               topic = NULL,
                               by = NULL,
                               filters = NULL,
                               add_labels = FALSE,
                               csv = FALSE) {

  if (csv) {
    df <- get_education_data_csv(level, source, topic, by, filters, add_labels)
  } else {
    df <- get_education_data_json(level, source, topic, by, filters, add_labels)
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

  endpoints <- validate_function_args(level = level,
                                      source = source,
                                      topic = topic,
                                      by = by)

  required_vars <- get_required_varlist(endpoints)

  urls <- construct_url(endpoints = endpoints,
                        required_vars = required_vars,
                        filters  = filters)

  df <- get_all_data(urls)

  if(add_labels & nrow(df) != 0) {
    df <- add_variable_labels(endpoints, df)
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

  endpoints <- validate_function_args(level = level,
                                      source = source,
                                      topic = topic,
                                      by = by)

  required_vars <- get_required_varlist(endpoints)

  urls <- construct_url_csv(endpoints = endpoints,
                            required_vars = required_vars,
                            filters  = filters)

  cols <- get_csv_cols(endpoints, urls)

  df <- get_csv_data(urls, cols, filters)

  if(add_labels & nrow(df) != 0) {
    df <- add_variable_labels(endpoints, df)
  }

  return(df)
}

