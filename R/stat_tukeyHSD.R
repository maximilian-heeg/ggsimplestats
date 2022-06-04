#' Add results from TukeyHSD to plot
#'
#' Uses [stats::TukeyHSD()] to calculate p values for each panel. Only works if the x-axis is a discrete scale.
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
#' ggplot(PlantGrowth, aes(group, weight, fill = group)) +
#'   geom_boxplot() +
#'   stat_tukeyHSD()
stat_tukeyHSD <- function(mapping = NULL, data = NULL, geom = GeomStat,
                          position = "identity", na.rm = FALSE, show.legend = NA,
                          size = 10, hide.ns = TRUE, tick.length = 0.02,
                          format.fun = pvalue, vjust = 0,
                          step.increase = 0.05, colour='black',
                          inherit.aes = TRUE, ...) {
  layer(
    stat = StatTukeyHSD, data = data, mapping = mapping, geom = geom,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(
      size = size, hide.ns = hide.ns, tick.length = tick.length,
      vjust = vjust, step.increase = step.increase, colour = colour,
      format.fun = format.fun, ...
    )
  )
}


#' StatTukeyHSD
#'
#' Stat layer for calculating statistics
#' Uses `TukeyHSD` from `stats`
#'
#' @import ggplot2
#' @import grid
#' @import stats
#' @import tibble
#' @importFrom tidyr separate
#' @noRd
StatTukeyHSD <- ggproto(
  "StatTukeyHSD",
  Stat,
  compute_panel = function(data, scales) {
    if (!requireNamespace("stats", quietly = TRUE)) {
      stop(
        "Package \"stats\" must be installed to use this function."
      )
    }
    if (!scales$x$is_discrete()) {
      rlang::abort(
        "x-Axis needs to be discrete."
      )
    }

    data$x <- as.factor(data$x)
    a <- aov(y ~ x, data = data)
    res <- TukeyHSD(a, "x")$x
    res <- as.data.frame(res) %>%
      tibble::rownames_to_column() %>%
      tidyr::separate(rowname, into = c("x", "xend"), sep = "-") %>%
      dplyr::select(x, xend, p = `p adj`)


    res$x <- as.numeric(as.character(res$x))
    res$xend <- as.numeric(as.character(res$xend))
    res$y <- max(data$y)
    res$range <- max(data$y) - min(data$y)

    return(res)
  },
  required_aes = c("x", "y")
)
