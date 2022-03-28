#' Add results linear mixed model to plot
#'
#' Uses [lme4::lmer()] and [emmeans::emmeans()] to calcuate significanes.
#' First a mixed model is build with `lmer` using `y ~ x + (1|group)`.
#' In a second step, significanes are calcuated using `pairs(emmeans(model ~ x))`.
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
#'   stat_mixedModel(aes(group = patient))
stat_mixedModel <- function(mapping = NULL, data = NULL, geom = GeomStat,
                                        position = "identity", na.rm = FALSE, show.legend = NA,
                                        size = 10, hide.ns = TRUE, tick.length = 0.02,
                                        format.fun = pvalue, vjust = 0,
                                        step.increase = 0.05,colour='black',
                                        inherit.aes = TRUE, ...) {
  layer(
    stat = StatMixedModel, data = data, mapping = mapping, geom = geom,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(
      size = size, hide.ns = hide.ns, tick.length = tick.length,
      vjust = vjust, step.increase = step.increase, colour = colour,
      format.fun = format.fun, ...
    )
  )
}


#' StatMixedModel
#'
#' Stat layer for calculating statistics
#' Uses [lme4::lmer()] and [emmeans::emmeans()]
#'
#' @import ggplot2
#' @import grid
#' @noRd
StatMixedModel <- ggproto(
  "StatMixedModel",
  Stat,
  compute_panel = function(data, scales) {
    if (!requireNamespace("lme4", quietly = TRUE)) {
      stop(
        "Package \"lme4\" must be installed to use this function."
      )
    }
    if (!requireNamespace("emmeans", quietly = TRUE)) {
      stop(
        "Package \"emmeans\" must be installed to use this function."
      )
    }
    if (!requireNamespace("stringr", quietly = TRUE)) {
      stop(
        "Package \"stringr\" must be installed to use this function."
      )
    }
    if (!scales$x$is_discrete()) {
      rlang::abort(
        "x-Axis needs to be discrete."
      )
    }

    data$x <- as.factor(data$x)
    data$group <- as.factor(data$group)

    model <- lme4::lmer(y ~ x + (1|group), data = data)
    res <- pairs(emmeans::emmeans(model, ~ x)) %>%  as.data.frame()

    res <- res  %>%
      tidyr::separate(contrast, into = c("x", "xend"), sep = " - ") %>%
      dplyr::select(x, xend, p = `p.value`)

    res$x <- as.numeric(as.character(res$x))
    res$xend <- as.numeric(as.character(res$xend))
    res$y <- max(data$y)

    return(res)
  },
  required_aes = c("x", "y", "group")
)
