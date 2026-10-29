
test_that("S1 maps to fluvial family", {
  m <- metaphorMatrix("S1", "continuous")
  expect_equal(m$family, "fluvial")
  expect_equal(m$signal_name, "Large effect / high certainty")
  expect_true(nzchar(m$forbidden))
  expect_equal(m$data_type, "continuous")
})

test_that("S7 maps to fluvial family (mortality / health)", {
  m <- metaphorMatrix("S7", "survival")
  expect_equal(m$family, "fluvial")
  expect_equal(m$signal_name, "Mortality / health risk")
  expect_match(m$forbidden, "gamification", fixed = TRUE)
})

test_that("all twelve signals resolve to a valid family", {
  for (i in 1:12) {
    m <- metaphorMatrix(sprintf("S%d", i), "continuous")
    expect_true(m$family %in% c("fluvial", "arboreal", "celestial"))
    expect_false(is.null(m$forbidden) || is.na(m$forbidden))
  }
})

test_that("signal_id is case-insensitive and trimmed", {
  expect_equal(metaphorMatrix("s7", "survival")$family, "fluvial")
  expect_equal(metaphorMatrix("  S7  ", "survival")$family, "fluvial")
})

test_that("data_type is case-insensitive and trimmed", {
  expect_equal(metaphorMatrix("S1", "CONTINUOUS")$data_type, "continuous")
  expect_equal(metaphorMatrix("S1", "  count  ")$data_type, "count")
})

test_that("all valid data types are accepted", {
  for (dt in c("continuous", "binary", "count", "survival")) {
    expect_equal(metaphorMatrix("S1", dt)$data_type, dt)
  }
})

test_that("invalid signal raises an informative English error", {
  expect_error(metaphorMatrix("S99", "continuous"),
               "Invalid signal_id")
  expect_error(metaphorMatrix("X1", "continuous"),
               "Invalid signal_id")
})

test_that("invalid data_type raises an informative English error", {
  expect_error(metaphorMatrix("S1", "ordinal"),
               "Invalid data_type")
})

