#' GeomStat
#'
#' Geom layer for plotting statistics
#'
#' @import ggplot2
#' @noRd
GeomStat <- ggproto(
  "GeomStat",
  Geom,
  required_aes = c("x", "xend", "p", "y"),
  default_aes = aes(
    xend = xend
  ),
  setup_data = function(data, params) {
    data <- formatPValues(data, hide.ns = params$hide.ns, step.increase = params$step.increase)
    data
  },
  draw_panel = function(data, panel_params, coord, size, hide.ns, tick.length, format.fun, vjust, step.increase, colour) {

    # the actial y position adation takes place here
    data <- adjustYPosition(data, step.increase = (panel_params$y$limits[2]-panel_params$y$limits[1]) * step.increase )
    coords <-
      coord$transform(data, panel_params)

    # calc the lower end of the tick
    coords$ymin <- coords$y - tick.length

    # create the label for the p value
    coords$label <- format.fun(coords$p)

    label <- grid::textGrob(
      label = coords$label,
      vjust = vjust,
      x = rowMeans(cbind(coords$x, coords$xend)),
      y = coords$y,
      gp = grid::gpar(
        col = colour,
        fontsize = size
      )
    )

    bracket <- data.frame(
      x = c(coords$x, coords$x, coords$xend),
      xend = c(coords$x, coords$xend, coords$xend),
      y = c(coords$ymin, coords$y, coords$y),
      yend = c(coords$y, coords$y, coords$ymin)
    )

    bracket <- grid::segmentsGrob(
      x0 = bracket$x,
      x1 = bracket$xend,
      y0 = bracket$y,
      y1 = bracket$yend,
      gp = grid::gpar(
        col = colour
      )
    )
    return(grid::gList(label, bracket))
  },
  draw_key=NULL
)
