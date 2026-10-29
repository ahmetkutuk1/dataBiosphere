#' Truth Overlay Badge and Closing Card
#'
#' Generates the in-frame badge and closing card text that keep the literal
#' finding (effect size, 95% CI, n) recoverable in every frame. Enforces the
#' Freeze-Frame Test and the Severity Threshold.
#'
#' @param effect_type Character. `"HR"` or `"OR"`.
#' @param effect_value Numeric. Point estimate.
#' @param ci_lower,ci_upper Numeric. 95% confidence interval bounds.
#' @param n Integer. Sample size.
#' @param finding_label Character. Short finding label.
#' @param risk_tier Integer. 1 (high), 2 (medium), 3 (low).
#' @param contains_mortality Logical. `TRUE` if the finding involves death,
#'   illness, or trauma.
#' @return A list with `badge`, `closing_card`, `risk_tier`, `tier_allowed`.
#' @export
#' @examples
#' truthOverlay("HR", 0.72, 0.61, 0.85, 1200, "Treatment X vs placebo",
#'              risk_tier = 1, contains_mortality = TRUE)
truthOverlay <- function(effect_type,
                         effect_value,
                         ci_lower,
                         ci_upper,
                         n,
                         finding_label,
                         risk_tier = 1L,
                         contains_mortality = FALSE) {

  effect_type <- toupper(trimws(effect_type))
  if (!effect_type %in% c("HR", "OR")) {
    stop("effect_type must be 'HR' or 'OR'.", call. = FALSE)
  }
  if (!is.numeric(effect_value) || !is.numeric(ci_lower) || !is.numeric(ci_upper)) {
    stop("effect_value, ci_lower, ci_upper must be numeric.", call. = FALSE)
  }
  if (ci_lower > effect_value || effect_value > ci_upper) {
    stop("CI bounds do not contain the point estimate.", call. = FALSE)
  }
  n <- as.integer(n)
  if (is.na(n) || n <= 0) stop("n must be a positive integer.", call. = FALSE)
  risk_tier <- as.integer(risk_tier)
  if (!risk_tier %in% 1:3) stop("risk_tier must be 1, 2, or 3.", call. = FALSE)

  tier_allowed <- !(contains_mortality && risk_tier == 3L)
  if (!tier_allowed) {
    stop("Severity Threshold violation: mortality/illness/trauma findings ",
         "cannot be Tier 3 (game). Use risk_tier = 1 or 2.", call. = FALSE)
  }

  badge <- sprintf("%s = %.2f (95%% CI %.2f-%.2f; n = %s)",
                   effect_type, effect_value, ci_lower, ci_upper,
                   format(n, big.mark = ",", scientific = FALSE))

  closing_card <- paste0(
    finding_label, "\n",
    badge, "\n",
    "Tier: T", risk_tier,
    if (contains_mortality) "  |  Contains mortality/illness/trauma - no gamification" else "",
    "\nThis card is embedded in the video (Truth Overlay)."
  )

  list(
    badge        = badge,
    closing_card = closing_card,
    risk_tier    = risk_tier,
    tier_allowed = tier_allowed
  )
}
