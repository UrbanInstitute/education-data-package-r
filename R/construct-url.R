# construct urls from a given endpoint, required variables, and filters
#
# takes an endpoint_url, validates year, adds required variables in the
# appropriate position, and adds any given filters
#
# returns a list of API urls to be queried
construct_url <- function(endpoints,
                          required_vars,
                          filters) {

  required_vars <- parse_year(endpoints, required_vars)

  url_stub = paste0('https://ed-data-portal.urban.org', endpoints$endpoint_url)
  url_stub <- parse_filters(url_stub, filters)
  urls <- do.call(glue::glue, c(url_stub , required_vars))
  return(urls)
}

# parse filters and add to url
#
# returns a url_stub with filters added
parse_filters <- function(url_stub, filters) {
  if(is.null(filters)) {
    return(url_stub)
  } else {
    url_stub <- paste0(url_stub, '?')
  }

  filter_stub <- ''

  for (i in seq_along(filters)){
    name = names(filters[i])
    filter = paste0(filters[[i]], collapse = ',')
    filter_stub <- paste0(filter_stub, name, '=', filter, '&')
  }

  url_stub <- paste0(url_stub, filter_stub)
  url_stub <- substr(url_stub, 1, nchar(url_stub) - 1)
  return(url_stub)

}

# validate year argument
#
# returns a list of required variables with validated years
parse_year <- function(endpoints, required_vars) {

  if(!'year' %in% names(required_vars)) stop('year is not a vaild variable.')

  valid_years <- unlist(unique(endpoints$parsed_years))
  year <- required_vars$year

  if (length(year) == 1 && year == 'all') year <- valid_years

  lapply(year,
         function(x) if(!(x %in% valid_years)) {
           stop(x, ' is not a valid year for the requested endpoint.',
                call. = FALSE)
           }
         )

  required_vars$year <- year

  return(required_vars)
}
