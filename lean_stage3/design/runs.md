# The runs as theorems

Read first after any compaction. 2026-11-23.

Units 0472 to 0475 measured four patterns on a stretch of rows. Julian: the
runs should be theorems, so that the pattern is proved for every cell and the
table need not be computed. Each run has a core that is exact at every row,
and a part that is a size.

| run | exact core, a theorem at every row | the part that is a size |
|---|---|---|
| 0473 the table's residuals, folded | a height shows on the ladder only up to `2π/log 2` | which folded heights dominate |
| 0474 neighbouring zeros beat | two modes together carry a term turning at the difference of their heights | how large the sway is |
| 0475 the half carries the row | the sieve's sum from the primes up to `√x` is the count, exactly | how far the roundings cancel |
| 0472 the steps line up at the zeros | the logarithmic derivative has a pole at each zero | the height and place of a finite peak |

## R1 The fold and the beat — `Stage3/RunTheorems.lean`

- `mode_fold`: `2^(ρ + 2πi·k/log 2) = 2^ρ` for every integer `k`.
- `mode_cross`: `2^ρ₁·conj(2^ρ₂) = exp((β₁+β₂)·log 2 + i·(γ₁−γ₂)·log 2)`.
- `two_mode_beat`: `‖c₁z₁^k + c₂z₂^k‖² = ‖c₁z₁^k‖² + ‖c₂z₂^k‖²
  + 2·Re(c₁·conj c₂·(z₁·conj z₂)^k)`.
- `zero_pair_beat`: for two zeros the turning term is
  `2^((β₁+β₂)k)·exp(i·k·(γ₁−γ₂)·log 2)` times the weights.

## R2 The sieve, exactly — PROVED (unit 0481: `SieveExact.pi_by_sieve`, `row_by_sieve`, `sieve_by_level`, `level_card`, `sieve_split`, `smoothPart_eq_prod`, `abs_netRounding_le`)

`π(x) − π(√x) + 1 = Σ_{d | P(√x)} μ(d)·⌊x/d⌋` for every `x`. The sizes of
units 0472 to 0475 that are of the strength of the Riemann hypothesis stay
measurements.

## R3 The roundings and the residual — `Stage3/SieveResidual.lean`

The net rounding is of the order of the count (unit 0475, corrected), so
"the roundings cancel to square-root size" is false for the sieve's sum. Its
true form: take from the net rounding its own smooth part
`smoothNet N = N·Π(1 − 1/p) − 1 − Li N + Li √N`. Then, exactly,

    netRounding N − smoothNet N = −((π N − Li N) − (π √N − Li √N)).

- `net_wobble (hN : 2 ≤ N)`, and `net_wobble_rows (hm : 1 ≤ m)` at `N = 2^(2m)`
  with `√N = 2^m`: the residual at row `2m` less the residual at row `m`.

## R4 The steps' pole at a zero — `Stage3/StepsPole.lean`

The exact core of unit 0472. `steps_sum`: for `Re s > 1` the turned steps
`Σ Λ(n)·n^(−s)` are `−ζ'/ζ(s)`. `steps_pole`: at a nontrivial zero `ρ` of
order `m`, `(s − ρ)·(−ζ'/ζ(s)/s) → −m/ρ`; `steps_pole_ne_zero`, `order_pos`.
`steps_regular`: away from the zeros and from `1` the logarithmic derivative
is analytic. From `ContourShift.zeta_local_data_zero` at `x = 1`.

The weight of the pole, `m/ρ`, is the weight the zero carries in the table's
residual (`FilterLadder.wz`).
