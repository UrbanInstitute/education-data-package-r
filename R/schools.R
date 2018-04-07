validate_school_sources <- function(source) {
  valid_sources <- c('ccd')

  if (!(source %in% valid_sources) || is.null(source)) {
    stop('Invalid source. Valid sources are: ',
         paste(valid_sources, collapse = ', ')
    )
  }
}

validate_school_topics <- function(source, topic) {
  valid_topics <- c('directory', 'enrollment')

  if (!(topic %in% valid_topics) | is.null(topic)) {
    stop('Invalid topic for source ', source, '. Valid topics are: ',
          paste(valid_topics)
    )
  }
}
