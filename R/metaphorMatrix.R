.metaphor_lookup <- data.frame(
  signal_id = sprintf("S%d", 1:12),
  signal_name = c(
    "Large effect / high certainty",
    "Large effect / low certainty",
    "Small effect / high certainty",
    "Small effect / low certainty",
    "Reversible outcome",
    "Irreversible outcome",
    "Mortality / health risk",
    "Financial risk",
    "Regulatory risk",
    "Positive direction",
    "Negative direction",
    "Null / uncertain"
  ),
  family = c(
    "fluvial",   "arboreal",  "celestial", "fluvial",
    "arboreal",  "celestial", "fluvial",   "arboreal",
    "celestial", "fluvial",   "arboreal",  "celestial"
  ),
  forbidden = c(
    "chaos, collapse, irreversibility",
    "certainty, closure, completed flow",
    "dramatic climax, explosion",
    "certain direction, fixed fate",
    "coldness, rupture, extinction",
    "cyclicality, renewal, return",
    "gamification, lightness, entertainment",
    "safety, insurance, protection",
    "rule-breaking, escape",
    "expectation, promise, guarantee",
    "apocalypse, inevitability, fate",
    "certain outcome, victory or defeat"
  ),
  stringsAsFactors = FALSE
)

.valid_data_types <- c("continuous", "binary", "count", "survival")

#' Deterministic Metaphor Matrix
#'
#' Selects a metaphor family (fluvial, arboreal, celestial) from the signal
#' ID and data type, and returns the implications forbidden by the
#' Faithfulness Constraint. The LLM is not the director; this matrix decides.
#'
#' @param signal_id Character. One of `"S1"` to `"S12"`.
#' @param data_type Character. One of `"continuous"`, `"binary"`, `"count"`,
#'   `"survival"`.
#' @return A list with `family`, `signal_name`, `forbidden`, `data_type`.
#' @export
#' @examples
#' metaphorMatrix("S7", "survival")
metaphorMatrix <- function(signal_id, data_type) {
  signal_id <- toupper(trimws(signal_id))
  data_type <- tolower(trimws(data_type))

  if (!signal_id %in% .metaphor_lookup$signal_id) {
    stop("Invalid signal_id: '", signal_id, "'. Must be S1-S12.", call. = FALSE)
  }
  if (!data_type %in% .valid_data_types) {
    stop("Invalid data_type: '", data_type, "'. Must be one of: ",
         paste(.valid_data_types, collapse = ", "), call. = FALSE)
  }

  row <- .metaphor_lookup[.metaphor_lookup$signal_id == signal_id, ]

  list(
    family      = row$family,
    signal_name = row$signal_name,
    forbidden   = row$forbidden,
    data_type   = data_type
  )
}
