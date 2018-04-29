construct_url <- function(endpoints,
                          required_vars,
                          filters) {

  required_vars <- parse_year(endpoints, required_vars)

  url_stub = paste0('https://ed-data-portal.urban.org', endpoints$endpoint_url)
  url_stub <- parse_filters(url_stub, filters)
  urls <- do.call(glue::glue, c(url_stub , required_vars))
  return(urls)
}

# parse filters
#
#
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
  return(url_stub)

}

# parse year
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
