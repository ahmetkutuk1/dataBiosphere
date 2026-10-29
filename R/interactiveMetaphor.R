#' Render Interactive Metaphor (T2)
#'
#' Creates an interactive exploration widget using plotly.
#' Bakes the Truth Overlay badge into the plotly layout so it remains
#' visible at all zoom levels.
#'
#' @param data A data.frame.
#' @param time_col Character. Column name for time.
#' @param value_col Character. Column name for value.
#' @param signal_id Character. S1-S12.
#' @param overlay_args List. Arguments to pass to truthOverlay().
#' @return A plotly object.
#' @export
renderInteractiveMetaphor <- function(data, time_col, value_col, signal_id, overlay_args) {
  if (!requireNamespace('plotly', quietly = TRUE)) {
    stop('Package plotly is required. Run: install.packages("plotly")')
  }
  
  # 1. Get the Truth Overlay
  overlay <- do.call(truthOverlay, overlay_args)
  
  # 2. Get palette
  matrix_info <- metaphorMatrix(signal_id, 'continuous')
  family <- matrix_info$family
  pal <- visualPalette(family)
  
  # 3. Build base ggplot
  p <- ggplot2::ggplot(data, ggplot2::aes(x = .data[[time_col]], y = .data[[value_col]], text = paste0('Time: ', .data[[time_col]], '<br>Value: ', round(.data[[value_col]], 2)))) +
       ggplot2::geom_line(color = pal$primary_color, size = 1.5) +
       ggplot2::geom_point(color = pal$accent_color, size = 3) +
       ggplot2::theme_minimal() +
       ggplot2::theme(
         plot.background = ggplot2::element_rect(fill = pal$bg_color, color = NA),
         panel.grid = ggplot2::element_line(color = 'gray80', linetype = 'dotted')
       )
  
  # 4. Convert to plotly
  p_interactive <- plotly::ggplotly(p, tooltip = 'text')
  
  # 5. Add Truth Overlay as a persistent annotation (Kare Dondurma kuralı)
  p_interactive <- p_interactive %>%
    plotly::layout(
      annotations = list(
        list(
          text = overlay$badge,
          xref = 'paper', yref = 'paper',
          x = 0.05, y = 0.95,
          showarrow = FALSE,
          font = list(size = 14, color = 'black', family = 'Arial', weight = 'bold'),
          bgcolor = 'white',
          bordercolor = 'black',
          borderwidth = 1,
          opacity = 0.8
        )
      )
    )
  
  return(p_interactive)
}
