#' Obtain data from the Urban Institute Education Data Portal API
#'
#' @param level API data level to query
#' @param source API data source to query
#' @param topic API data topic to query
#' @param ... Additional required and optional parameters to pass to an API call
#'
#' @return A data.frame of education data
#'
#' @examples \dontrun{
#' library(educationdata)
#' df <- get_education_data(level = 'school-districts', source = 'ccd', topic = 'finance', year = 2004)
#' }
#'
#' @export
get_education_data <- function(level = NULL, source = NULL, topic = NULL, ...) {
  url <- construct_url(level, source, topic, ...)
  df <- get_data_old(url)
  return(df)
}
