#' Add results from Dunn's non-parametric test to plot
#'
#' Uses [PMCMRplus::kwAllPairsDunnTest()] to perform Dunn's non-parametric
#' all-pairs comparison test for Kruskal-type ranked data and adds the
#' resulting p-values to the plot.
#' Only works if the x-axis is a discrete scale.
#'
#' @inheritParams ggplot2::layer
#' @param geom he geometric object to use display the data. Set to `GeomStat` and usually no need to change.
#' @param size Fontsize for the annotation
#' @param na.rm If `FALSE`, the default, missing values are removed with a warning. If `TRUE`, missing values are silently removed.
#' @param hide.ns Should p-values lower than 0.05 be removed? Default TRUE
#' @param tick.length Length of the ticks in the p-value brackets. Default 0.02
#' @param format.fun A function used to format the p value. Default `scales::pvalue`
#' @param step.increase Amount of increase between two brackets. Default 0.05
#' @param vjust A numeric vector specifying vertical justification. Passed on to textGrob.
#' @param ... Further arguments passed on to the layer in params
#'
#' @return A ggplot layer
#' @export
#'
#' @import ggplot2
#' @importFrom scales pvalue
#'
#' @examples
#' library(ggplot2)
#' library(ggsimplestats)
#'
#' theme_set(ggthemes::theme_few())
#'
#' ggplot(PlantGrowth, aes(group, weight, fill = group)) +
#'   geom_boxplot() +
#'   stat_kwAllPairsDunnTest()
stat_kwAllPairsDunnTest <- function(mapping = NULL, data = NULL, geom = GeomStat,
                                    position = "identity", na.rm = FALSE, show.legend = NA,
                                    size = 10, hide.ns = TRUE, tick.length = 0.02,
                                    format.fun = pvalue, vjust = 0,
                                    step.increase = 0.05,
                                    inherit.aes = TRUE, ...) {
  layer(
    stat = StatKwAllPairsDunnTest, data = data, mapping = mapping, geom = geom,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(
      size = size, hide.ns = hide.ns, tick.length = tick.length,
      vjust = vjust, step.increase = step.increase,
      format.fun = format.fun, ...
    )
  )
}


#' StatKwAllPairsDunnTest
#'
#' Stat layer for calculating statistics
#' Uses `StatKwAllPairsDunnTest` from `PMCMRplus`
#'
#' @import ggplot2
#' @import grid
#' @noRd
StatKwAllPairsDunnTest <- ggproto(
  "StatKwAllPairsDunnTest",
  Stat,
  compute_panel = function(data, scales) {
    if (!requireNamespace("PMCMRplus", quietly = TRUE)) {
      stop(
        "Package \"PMCMRplus\" must be installed to use this function."
      )
    }
    if (!scales$x$is_discrete()) {
      rlang::abort(
        "x-Axis needs to be discrete."
      )
    }



    res <- PMCMRplus::kwAllPairsDunnTest(
      x = data$y,
      g = data$x
    )
    res <- formatPMCMRPlusResults(res, y = max(data$y))

    return(res)
  },
  required_aes = c("x", "y")
)
