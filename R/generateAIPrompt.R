#' Generate AI Cinematic Prompt
#'
#' Creates a text prompt for AI video generators (e.g., Sora, Runway)
#' based on the metaphor matrix. Ensures forbidden implications are respected.
#'
#' @param signal_id Character. S1-S12.
#' @param finding_label Character. The context of the finding.
#' @return A character string prompt.
#' @export
generateAIPrompt <- function(signal_id, finding_label) {
  matrix_info <- metaphorMatrix(signal_id, 'continuous')
  family <- matrix_info$family
  forbidden <- matrix_info$forbidden
  
  base_prompts <- list(
    fluvial = 'Cinematic aerial drone shot of a flowing river, dark blue tones, smooth fluid dynamics, medical documentary style, 8k resolution.',
    arboreal = 'Cinematic macro shot of a branching bioluminescent tree, growing roots and nodes, dark green tones, scientific documentary style, 8k resolution.',
    celestial = 'Cinematic deep space shot of glowing celestial orbits, stellar nebulae, dark gold and purple tones, ethereal physics, 8k resolution.'
  )
  
  prompt <- paste0(
    base_prompts[[family]],
    ' Context: ', finding_label, '. ',
    'CRITICAL CONSTRAINT: Do NOT include any elements of ', forbidden, '.',
    ' Maintain a serious, objective, and trustworthy atmosphere.'
  )
  
  return(prompt)
}
