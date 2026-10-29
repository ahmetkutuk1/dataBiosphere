library(plumber)
pkgload::load_all(quiet = TRUE)

#* @apiTitle dataBiosphere SaaS API
#* @apiDescription Endpoint for generating Auditable Cinematic Metaphors

#* Generate Truth Overlay Badge
#* @param effect_value Numeric effect size
#* @param ci_lower Numeric CI lower bound
#* @param ci_upper Numeric CI upper bound
#* @param n Integer sample size
#* @get /overlay
function(effect_value = 0.72, ci_lower = 0.61, ci_upper = 0.85, n = 1200) {
  res <- truthOverlay('HR', as.numeric(effect_value), as.numeric(ci_lower), as.numeric(ci_upper), as.numeric(n), 'API Upload', 1, TRUE)
  return(res)
}

#* Generate Metaphor Matrix Mapping
#* @param signal_id Signal ID (S1-S12)
#* @get /matrix
function(signal_id = 'S7') {
  res <- metaphorMatrix(signal_id, 'continuous')
  return(res)
}

#* Generate AI Prompt for Video
#* @param signal_id Signal ID (S1-S12)
#* @get /ai_prompt
function(signal_id = 'S7') {
  res <- generateAIPrompt(signal_id, 'API Upload')
  return(list(prompt = res))
}

#* Generate Auditable Video (Returns MP4 file)
#* @param signal_id Signal ID
#* @get /video
#* @serializer contentType list(type='video/mp4')
function(signal_id = 'S7') {
  # Gecici bir dosya yolu olustur
  temp_video <- tempfile(fileext = '.mp4')
  df <- data.frame(time = 1:20, value = 100 * exp(-0.1 * (1:20)))
  overlay_args <- list(effect_type = 'HR', effect_value = 0.72, ci_lower = 0.61, ci_upper = 0.85, n = 1200, finding_label = 'API Generated', risk_tier = 1, contains_mortality = TRUE)
  
  # Videoyu olustur
  renderAuditableVideo(df, 'time', 'value', signal_id, overlay_args, temp_video, transparent_bg = FALSE)
  
  # Dosyayi API uzerinden geri dondur
  readBin(temp_video, 'raw', n = file.info(temp_video)$size)
}
