#' Visual Palette for Metaphor Families
#'
#' Maps a metaphor family (fluvial, arboreal, celestial) to specific
#' ggplot2 aesthetics (colors, geometry, animation speed).
#'
#' @param family Character. 'fluvial', 'arboreal', or 'celestial'.
#' @return A list of aesthetic parameters.
#' @export
visualPalette <- function(family) {
  if (!family %in% c('fluvial', 'arboreal', 'celestial')) {
    stop("Invalid family. Must be 'fluvial', 'arboreal', or 'celestial'.")
  }
  
  palettes <- list(
    fluvial = list(
      primary_color = '#1f78b4',  # Deep water blue
      accent_color  = '#a6cee3',  # Light water
      bg_color      = '#f7f7f7',
      geom          = 'line',     # Flowing paths
      motion        = 'continuous'
    ),
    arboreal = list(
      primary_color = '#33a02c',  # Forest green
      accent_color  = '#b2df8a',  # Leaf green
      bg_color      = '#f4f9f4',
      geom          = 'point',    # Nodes / leaves
      motion        = 'growing'
    ),
    celestial = list(
      primary_color = '#ff7f00',  # Star gold
      accent_color  = '#cab2d6',  # Nebula purple
      bg_color      = '#1a1a1a',  # Dark space
      geom          = 'point',    # Orbits
      motion        = 'orbiting'
    )
  )
  
  return(palettes[[family]])
}
