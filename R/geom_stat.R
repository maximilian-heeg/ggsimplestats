#' GeomStat
#'
#' Geom layer for plotting statistics
#'
#' @import ggplot2
#' @NoRd
GeomStat <- ggproto(
  "GeomStat",
  Geom,
  required_aes = c("x", "xend", "p", "y"),

  default_aes = aes(xend = xend,
                    colour = 'black'),

  setup_data = function(data, params) {
    data <- formatPValues(data, hide.ns = params$hide.ns)
    data
  },


  draw_panel = function(data, panel_params, coord, size, hide.ns, tick.length) {

    coords <-
      coord$transform(data, panel_params)

    coords$ymin <- coords$y - tick.length

    label <- grid::textGrob(
      label = coords$p,
      vjust = -.1,
      x = rowMeans(cbind(coords$x, coords$xend)),
      y = coords$y,
      gp = grid::gpar(col = coords$colour,
                      fontsize = size)
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
      y1 = bracket$yend

    )
    return(grid::gList(label, bracket))
  }
)
