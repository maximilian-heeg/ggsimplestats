

#' Helper function to formats the results of PMCMRPlus
#'
#'
#' @param res Result from a test from formatPMCMRPlusResults
#' @param y the y position of the bracket
#'
#' @return A tibble
#' @importFrom rlang .data
formatPMCMRPlusResults <- function(res, y){
  res <- res$p.value %>%
    as.table() %>%
    as.data.frame() %>%
    # rename colums for use in ggplot
    dplyr::select(x = .data$Var1,
           xend = .data$Var2,
           p = .data$Freq) %>%
    dplyr::mutate(y = y,
                  x = as.numeric(as.character(.data$x)),
                  xend = as.numeric(as.character(.data$xend))) %>%
    dplyr::filter(!is.na(.data$p))
  return(res)
}



formatPValues <- function(data, step.increase=0.05, hide.ns=TRUE) {
  if(hide.ns)
    data = data[data$p < 0.05, ]

  data$y = data$y  + data$y * step.increase * 1:nrow(data)
  return(data)
}
