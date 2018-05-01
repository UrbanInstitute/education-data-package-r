add_variable_labels <- function(endpoints, df) {
  varlist <- get_endpoint_varlist(endpoints)
  df <- apply_label_text(df, varlist)
  return(df)
}


# get endpoint varlist from an endpoint id
#
# returns a data frame of variable metadata
get_endpoint_varlist <- function(endpoints) {
  url <- paste0('https://ed-data-portal.urban.org/',
                'api/v1/api-endpoint-varlist/?endpoint_id=',
                endpoints$endpoint_id)

  request <- httr::GET(url)
  varlist <- jsonlite::fromJSON(rawToChar(request$content))$results

  varlist <- varlist[(varlist$format != 'string' & varlist$format != 'numeric'), ]

  return(varlist)
}

# retrieve and parse label text for a given variable
#
# returns a data frame of variable values and their corresponding label
get_label_text <- function(varlist, var) {
  text <- varlist$values[varlist$variable == var]
  # print(var)
  # print(text)
  text <- gsub('"', '', text)
  text <- gsub(' : ', '\t', text)
  text <- gsub(', ', ' ', text)
  text <- gsub(",(\\d{3})", ';\\1', text)
  text <- unlist(strsplit(text, ','))
  text <- unlist(lapply(text, function(x) gsub(';',',', x)))

  mapping <- utils::read.delim(text=text, header = FALSE, sep = '\t')
  mapping <- unique(mapping)

  return(mapping)
}

# add labels to all variables in a data frame (where applicable)
#
# returns a df with variable labels added
apply_label_text <- function(df, varlist) {
  for (var in varlist$variable) {
    mapping <- get_label_text(varlist, var)
    df[[var]] <- factor(df[[var]], levels = mapping$V1, labels = mapping$V2)
  }
  return(df)
}
