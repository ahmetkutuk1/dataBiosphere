#' Render Auditable Video with Truth Overlay
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
