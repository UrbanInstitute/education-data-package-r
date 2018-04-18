#' Obtain data from the Urban Institute Education Data Portal API
#'
#' @param level API data level to query
#' @param source API data source to query
#' @param topic API data topic to query
#' @param ... Additional required parameters to pass to an API call
#' @param by Additional optional paramters to pass to an API call
#' @param filters Optional query values to filter an API call
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
                               filters = NULL) {
  url <- construct_url(level = level,
                       source = source,
                       topic = topic,
                       ...,
                       by = by,
                       filters = filters)

  message('Fetching ', url, ' ...')
  df <- get_data(url)
  return(df)
}
