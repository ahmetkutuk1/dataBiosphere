#' Render Auditable Video with Truth Overlay
#' @param data A data.frame.
#' @param time_col Character. Name of time column.
#' @param value_col Character. Name of value column.
#' @param signal_id Character. S1-S12.
#' @param overlay_args List. Arguments for truthOverlay().
#' @param output_file Character. Path to save MP4.
#' @param transparent_bg Logical. Use green screen?
#' @return Invisible NULL.
#' @export
renderAuditableVideo <- function(data, time_col, value_col, signal_id, overlay_args, output_file = 'output.mp4', transparent_bg = FALSE) {
  overlay <- do.call(truthOverlay, overlay_args)
  anim <- renderMetaphor(data, time_col, value_col, signal_id, transparent_bg)
  x_min <- min(data[[time_col]])
  y_max <- max(data[[value_col]])
  anim <- anim + ggplot2::annotate('label', x = x_min, y = y_max * 0.9, label = overlay$badge, hjust = 0, fill = 'white', color = 'black', fontface = 'bold', alpha = 0.9)
  anim <- anim + ggplot2::labs(caption = overlay$closing_card) +
    ggplot2::theme(plot.caption = ggplot2::element_text(size = 8, hjust = 0, color = ifelse(transparent_bg, 'white', 'gray40')))
  gganimate::anim_save(filename = output_file, animation = anim, nframes = 60, fps = 10, renderer = gganimate::av_renderer())
  invisible(NULL)
}
