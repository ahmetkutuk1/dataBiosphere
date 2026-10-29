
test_that("positive case returns badge with literal finding", {
  out <- truthOverlay("HR", 0.72, 0.61, 0.85, 1200,
                      "Treatment X vs placebo",
                      risk_tier = 1, contains_mortality = TRUE)

  expect_equal(out$badge, "HR = 0.72 (95% CI 0.61-0.85; n = 1,200)")
  expect_equal(out$risk_tier, 1L)
  expect_true(out$tier_allowed)
})

test_that("closing card contains badge, tier, and severity note", {
  out <- truthOverlay("HR", 0.72, 0.61, 0.85, 1200,
                      "Treatment X vs placebo",
                      risk_tier = 1, contains_mortality = TRUE)

  expect_match(out$closing_card, "Treatment X vs placebo", fixed = TRUE)
  expect_match(out$closing_card, "HR = 0.72", fixed = TRUE)
  expect_match(out$closing_card, "Tier: T1", fixed = TRUE)
  expect_match(out$closing_card, "no gamification", fixed = TRUE)
  expect_match(out$closing_card, "embedded in the video", fixed = TRUE)
})

test_that("Severity Threshold blocks Tier 3 when mortality is TRUE", {
  expect_error(
    truthOverlay("HR", 1.2, 1.0, 1.4, 500, "Mortality finding",
                 risk_tier = 3, contains_mortality = TRUE),
    "Severity Threshold violation"
  )
})

test_that("Tier 3 is allowed when mortality is FALSE", {
  out <- truthOverlay("OR", 0.65, 0.50, 0.84, 842,
                      "Exposure Y vs control",
                      risk_tier = 3, contains_mortality = FALSE)
  expect_equal(out$risk_tier, 3L)
  expect_true(out$tier_allowed)
  expect_false(grepl("no gamification", out$closing_card, fixed = TRUE))
})

test_that("effect_type must be HR or OR", {
  expect_error(truthOverlay("RR", 1.1, 1.0, 1.2, 100, "x"),
               "effect_type must be 'HR' or 'OR'")
})

test_that("effect_type is case-insensitive", {
  out <- truthOverlay("hr", 0.72, 0.61, 0.85, 1200, "x",
                      risk_tier = 1, contains_mortality = TRUE)
  expect_match(out$badge, "^HR = ", fixed = FALSE)
})

test_that("CI must contain the point estimate", {
  expect_error(truthOverlay("HR", 1.5, 1.0, 1.4, 100, "x"),
               "CI bounds do not contain the point estimate")
  expect_error(truthOverlay("HR", 0.5, 0.6, 0.9, 100, "x"),
               "CI bounds do not contain the point estimate")
})

test_that("n must be a positive integer", {
  expect_error(truthOverlay("HR", 1.1, 1.0, 1.2, 0, "x"),
               "n must be a positive integer")
  expect_error(truthOverlay("HR", 1.1, 1.0, 1.2, -5, "x"),
               "n must be a positive integer")
})

test_that("risk_tier must be 1, 2, or 3", {
  expect_error(truthOverlay("HR", 1.1, 1.0, 1.2, 100, "x", risk_tier = 0),
               "risk_tier must be 1, 2, or 3")
  expect_error(truthOverlay("HR", 1.1, 1.0, 1.2, 100, "x", risk_tier = 4),
               "risk_tier must be 1, 2, or 3")
})

test_that("badge formats large n with thousands separator", {
  out <- truthOverlay("HR", 0.85, 0.78, 0.93, 1234567, "Large cohort",
                      risk_tier = 1, contains_mortality = TRUE)
  expect_match(out$badge, "n = 1,234,567", fixed = TRUE)
})

