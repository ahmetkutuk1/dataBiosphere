# Deterministic Metaphor Matrix

Selects a metaphor family (fluvial, arboreal, celestial) from the signal
ID and data type, and returns the implications forbidden by the
Faithfulness Constraint. The LLM is not the director; this matrix
decides.

## Usage

``` r
metaphorMatrix(signal_id, data_type)
```

## Arguments

- signal_id:

  Character. One of `"S1"` to `"S12"`.

- data_type:

  Character. One of `"continuous"`, `"binary"`, `"count"`, `"survival"`.

## Value

A list with `family`, `signal_name`, `forbidden`, `data_type`.

## Examples

``` r
metaphorMatrix("S7", "survival")
#> $family
#> [1] "fluvial"
#> 
#> $signal_name
#> [1] "Mortality / health risk"
#> 
#> $forbidden
#> [1] "gamification, lightness, entertainment"
#> 
#> $data_type
#> [1] "survival"
#> 
```
