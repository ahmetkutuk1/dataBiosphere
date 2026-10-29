# dataBiosphere

**Auditable cinematic metaphors for high-risk research findings.**

`dataBiosphere` converts high-risk findings (health, finance,
regulation) into auditable cinematic video and interactive simulation.
It enforces three non-negotiable rules:

- **Literal core + metaphorical shell** — metaphor encodes the
  *qualities* of a number (large/small, certain/uncertain), never
  replaces it.
- **Freeze-frame test** — if a finding (effect size / CI / n) is not
  recoverable from any single frame, that scene is manipulation and
  forbidden.
- **Faithfulness constraint** — metaphor may not imply what the data
  does not support.

## Installation

``` r

devtools::install_github("ahmetkutuk1/dataBiosphere")
```

## Usage

``` r

library(dataBiosphere)

m <- metaphorMatrix("S7", "survival")
m$family       # "fluvial"

overlay <- truthOverlay(
  effect_type = "HR", effect_value = 0.72, ci_lower = 0.61, ci_upper = 0.85,
  n = 1200, finding_label = "Treatment X vs placebo", risk_tier = 1, contains_mortality = TRUE
)
overlay$badge
# "HR = 0.72 (95% CI 0.61-0.85; n = 1,200)"
```

## Severity threshold

Findings involving death, illness, or trauma
(`contains_mortality = TRUE`) **cannot** be delivered as Tier 3 (game).
[`truthOverlay()`](https://ahmetkutuk1.github.io/dataBiosphere/reference/truthOverlay.md)
errors out if you try.

| Tier | Format                  | When          |
|------|-------------------------|---------------|
| T1   | Cinematic video         | High risk     |
| T2   | Interactive exploration | Medium risk   |
| T3   | Serious game            | Low risk only |

## Documentation

Full reference: <https://ahmetkutuk1.github.io/dataBiosphere/>

## License

MIT (c) Ahmet Kutuk
