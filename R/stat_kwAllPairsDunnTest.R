#' stat_kwAllPairsDunnTest
#'
#' @param mapping mapping
#' @param data Usually no need to change this
#' @param geom Geom used to render the brackets (default: GeomStat)
#' @param position Default: identity
#' @param na.rm Default: FALSE
#' @param show.legend Has no effect.
#' @param size Fontsize for the annotation
#' @param inherit.aes TRUE
#' @param hide.ns Should p-values lower than 0.05 be removed? Default TRUE
#' @param tick.length Length of the ticks in the p-value brackets. Default 0.02
#' @param ... Further arguments passed on to the layer in params
#'
#' @return A ggplot layer
#' @export
#'
#' @import ggplot2
#'
#' @examples
#' library(ggplot2)
#' ggplot(mpg, aes(class, cty)) +
#'   geom_boxplot()  +
#'   stat_kwAllPairsDunnTest()
stat_kwAllPairsDunnTest <- function(mapping = NULL, data = NULL, geom = GeomStat,
                     position = "identity", na.rm = FALSE, show.legend = NA,
                     size = 10, hide.ns = TRUE, tick.length=0.02,
                     inherit.aes = TRUE, ...) {
  layer(
    stat = StatKwAllPairsDunnTest, data = data, mapping = mapping, geom = geom,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(size = size, hide.ns=hide.ns, tick.length=tick.length, ...)
  )
}


#' StatKwAllPairsDunnTest
#'
#' Stat layer for calculating statistics
#' Uses `StatKwAllPairsDunnTest` from `PMCMRplus`
#'
#' @import ggplot2
#' @import grid
#' @NoRd
StatKwAllPairsDunnTest <- ggproto(
  "StatKwAllPairsDunnTest",
  Stat,
  compute_panel = function(data, scales) {
    if (!requireNamespace("PMCMRplus", quietly = TRUE)) {
      stop(
        "Package \"PMCMRplus\" must be installed to use this function."
      )
    }
    if(! scales$x$is_discrete()) {
      rlang::abort(
        "x-Axis needs to be discrete."
      )
    }



    res <- PMCMRplus::kwAllPairsDunnTest(
        x = data$y,
        g = data$x
    )
    res <- formatPMCMRPlusResults(res, y=max(data$y))

    return(res)

  },



  required_aes = c("x", "y")
)
