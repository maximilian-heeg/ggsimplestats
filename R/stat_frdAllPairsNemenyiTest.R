#' Add results Nemenyi's All-Pairs Comparisons test to plot
#'
#' Uses [PMCMRplus::frdAllPairsNemenyiTest()] to perform Nemenyi's all-pairs
#' comparisons tests of Friedman-type ranked data and adds the
#' resulting p-values to the plot. The grouping aesthetics will be used as the
#' block for `frdAllPairsNemenyiTest`.
#' Only works if the x-axis is a discrete scale.
#'
#' @inheritParams ggplot2::layer
#' @param geom the geometric object to use display the data. Set to `GeomStat` and usually no need to change.
#' @param size Fontsize for the annotation
#' @param na.rm If `FALSE`, the default, missing values are removed with a warning. If `TRUE`, missing values are silently removed.
#' @param hide.ns Should p-values lower than 0.05 be removed? Default TRUE
#' @param tick.length Length of the ticks in the p-value brackets. Default 0.02
#' @param format.fun A function used to format the p value. Default `scales::pvalue`
#' @param step.increase Amount of increase between two brackets. Default 0.05
#' @param vjust A numeric vector specifying vertical justification. Passed on to textGrob.
#' @param colour Colour of the bracket and label
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
#' df <- data.frame(patient=as.factor(rep(1:5, each=4)),
#'                  drug=as.factor(rep(1:4, times=5)),
#'                  response=c(30, 28, 16, 34,
#'                             14, 18, 10, 22,
#'                             24, 20, 18, 30,
#'                             38, 34, 20, 44,
#'                             26, 28, 14, 30))
#' ggplot(df, aes(x=drug, y=response, color=patient)) +
#'   geom_point(position = position_dodge(width = .2)) +
#'   stat_frdAllPairsNemenyiTest(aes(group = patient))
stat_frdAllPairsNemenyiTest <- function(mapping = NULL, data = NULL, geom = GeomStat,
                                    position = "identity", na.rm = FALSE, show.legend = NA,
                                    size = 10, hide.ns = TRUE, tick.length = 0.02,
                                    format.fun = pvalue, vjust = 0,
                                    step.increase = 0.05,colour='black',
                                    inherit.aes = TRUE, ...) {
  layer(
    stat = StatFrdAllPairsNemenyiTest, data = data, mapping = mapping, geom = geom,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(
      size = size, hide.ns = hide.ns, tick.length = tick.length,
      vjust = vjust, step.increase = step.increase, colour = colour,
      format.fun = format.fun, ...
    )
  )
}


#' StatFrdAllPairsNemenyiTest
#'
#' Stat layer for calculating statistics
#' Uses `frdAllPairsNemenyiTest` from `PMCMRplus`
#'
#' @import ggplot2
#' @import grid
#' @noRd
StatFrdAllPairsNemenyiTest <- ggproto(
  "StatFrdAllPairsNemenyiTest",
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



    res <- PMCMRplus::frdAllPairsNemenyiTest(
      y = data$y,
      g = data$x,
      blocks = data$group
    )
    res <- formatPMCMRPlusResults(res, y = max(data$y))

    return(res)
  },
  required_aes = c("x", "y", "group")
)
