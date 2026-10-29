# Truth Overlay Badge and Closing Card

Generates the in-frame badge and closing card text that keep the literal
finding (effect size, 95% CI, n) recoverable in every frame. Enforces
the Freeze-Frame Test and the Severity Threshold.

## Usage

``` r
truthOverlay(
  effect_type,
  effect_value,
  ci_lower,
  ci_upper,
  n,
  finding_label,
  risk_tier = 1L,
  contains_mortality = FALSE
)
```

## Arguments

- effect_type:

  Character. `"HR"` or `"OR"`.

- effect_value:

  Numeric. Point estimate.

- ci_lower, ci_upper:

  Numeric. 95% confidence interval bounds.

- n:

  Integer. Sample size.

- finding_label:

  Character. Short finding label.

- risk_tier:

  Integer. 1 (high), 2 (medium), 3 (low).

- contains_mortality:

  Logical. `TRUE` if the finding involves death, illness, or trauma.

## Value

A list with `badge`, `closing_card`, `risk_tier`, `tier_allowed`.

## Examples

``` r
truthOverlay("HR", 0.72, 0.61, 0.85, 1200, "Treatment X vs placebo",
             risk_tier = 1, contains_mortality = TRUE)
#> $badge
#> [1] "HR = 0.72 (95% CI 0.61-0.85; n = 1,200)"
#> 
#> $closing_card
#> [1] "Treatment X vs placebo\nHR = 0.72 (95% CI 0.61-0.85; n = 1,200)\nTier: T1  |  Contains mortality/illness/trauma - no gamification\nThis card is embedded in the video (Truth Overlay)."
#> 
#> $risk_tier
#> [1] 1
#> 
#> $tier_allowed
#> [1] TRUE
#> 
```
