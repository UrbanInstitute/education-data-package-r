#' Obtain data from the Urban Institute Education Data Portal API
#'
#' @param level API data level to query
#' @param source API data source to query
#' @param topic API data topic to query
#' @param ... Additional required parameters to pass to an API call
#' @param by Additional optional paramters to pass to an API call
#' @param filters Optional query values to filter an API call
#' @param add_labels Add variable labels (when applicable)?
#'
#' @return A `data.frame` of education data
#'
#' @examples \dontrun{
#' library(educationdata)
#' df <- get_education_data(level = 'school-districts', source = 'ccd', topic = 'finance', year = 2004)
#' }
#'
#' @export
get_education_data <- function(level = NULL,
                               source = NULL,
                               topic = NULL,
                               ...,
                               by = NULL,
                               filters = NULL,
                               add_labels = FALSE) {

  required_vars = list(...)

  endpoints <- validate_function_args(level = level,
                                      source = source,
                                      topic = topic,
                                      ... = ...,
                                      by = by)

  urls <- construct_url(endpoints = endpoints,
                        required_vars = required_vars,
                        filters  = filters)

  df <- get_all_data(urls)

  if(add_labels & nrow(df) != 0) {
    df <- add_variable_labels(endpoints, df)
  }

  return(df)
}
