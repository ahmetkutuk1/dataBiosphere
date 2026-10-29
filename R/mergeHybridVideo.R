#' Merge R Video with AI Video using Green Screen
#' @param r_video Character. Path to R video.
#' @param ai_video Character. Path to AI video.
#' @param output_file Character. Path to output MP4.
#' @return Invisible NULL.
#' @export
mergeHybridVideo <- function(r_video, ai_video, output_file = 'hybrid_output.mp4') {
  if (Sys.which('ffmpeg') == '') stop('FFmpeg not found.')
  cmd <- sprintf('ffmpeg -y -i "%s" -i "%s" -filter_complex "[1:v]chromakey=0x00FF00:0.2:0.1[fg];[0:v][fg]overlay=shortest=1" -c:v libx264 -pix_fmt yuv420p "%s"', ai_video, r_video, output_file)
  system(cmd)
  invisible(NULL)
}
