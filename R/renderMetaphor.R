#' Render Deterministic Metaphor Animation
#' @param data A data.frame.
#' @param time_col Character. Name of the time column.
#' @param value_col Character. Name of the value column.
#' @param signal_id Character. S1-S12.
#' @param transparent_bg Logical. Use chromakey background?
#' @return A gganim object.
#' @export
renderMetaphor <- function(data, time_col, value_col, signal_id, transparent_bg = FALSE) {
  matrix_info <- metaphorMatrix(signal_id, 'continuous')
  family <- matrix_info$family
  pal <- visualPalette(family)
  bg_color <- if (transparent_bg) '#00FF00' else pal$bg_color
  p <- ggplot2::ggplot(data, ggplot2::aes(x = .data[[time_col]], y = .data[[value_col]]))
  if (family == 'fluvial') {
    p <- p + ggplot2::geom_area(fill = pal$accent_color, alpha = 0.4, stat = 'identity') +
             ggplot2::geom_line(color = pal$primary_color, size = 2, lineend = 'round') +
             ggplot2::geom_point(color = pal$primary_color, size = 4, shape = 21, fill = 'white')
  } else if (family == 'arboreal') {
    p <- p + ggplot2::geom_segment(ggplot2::aes(xend = .data[[time_col]], yend = 0), color = pal$accent_color, size = 1.5) +
             ggplot2::geom_point(color = pal$primary_color, size = 5, shape = 18)
  } else if (family == 'celestial') {
    p <- p + ggplot2::geom_line(color = pal$accent_color, size = 0.5, linetype = 'dotted') +
             ggplot2::geom_point(color = pal$primary_color, size = 6, alpha = 0.8) +
             ggplot2::geom_point(color = 'white', size = 2)
  }
  p <- p + ggplot2::theme_minimal() +
       ggplot2::theme(
         plot.background = ggplot2::element_rect(fill = bg_color, color = NA),
         panel.background = ggplot2::element_rect(fill = bg_color, color = NA),
         panel.grid = ggplot2::element_blank(),
         axis.text = ggplot2::element_blank(),
         axis.title = ggplot2::element_blank(),
         text = ggplot2::element_text(color = ifelse(family == 'celestial' && !transparent_bg, 'white', 'black'))
       )
  anim <- p + gganimate::transition_reveal(!!rlang::sym(time_col))
  return(anim)
}
