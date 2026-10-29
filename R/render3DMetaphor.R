#' Render 3D Metaphor using rayshader
#' @export
render3DMetaphor <- function(data, time_col, value_col, signal_id, output_file = '3d_output.png') {
  if (!requireNamespace('rayshader', quietly = TRUE)) stop('rayshader paketi gerekli.')
  
  matrix_info <- metaphorMatrix(signal_id, 'continuous')
  pal <- visualPalette(matrix_info$family)
  
  # 3D mesh oluşturmak için verinin sıfırdan başlayan bir alan (area) olması gerekir
  p <- ggplot2::ggplot(data, ggplot2::aes(x = .data[[time_col]], y = .data[[value_col]])) +
       ggplot2::geom_area(fill = pal$primary_color, alpha = 0.8, stat = 'identity') +
       ggplot2::geom_line(color = pal$accent_color, size = 1.5) +
       ggplot2::theme_void()
  
  message('3D Landscape hesaplaniyor, lutfen bekleyin...')
  
  # 3D'yi oluştur ve kaydet
  rayshader::plot_gg(
    p, width = 5, height = 5, scale = 300, 
    windowsize = c(800, 600), phi = 30, theta = 45, zoom = 0.7
  )
  
  rayshader::render_snapshot(output_file, clear = TRUE)
  message('3D Render basariyla kaydedildi: ', output_file)
}
