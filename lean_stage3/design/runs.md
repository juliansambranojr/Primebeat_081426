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

## R5 The height of a finite peak — `Stage3/StepsPeak.lean`

The first size of unit 0472: the turned steps up to a cutoff `N`, with the ramp
`1 − n/N`, stand at height `m·log N` at a zero of order `m`.

`f(u) = u^(−s)·(1 − u/N)`, `S(N,s) = Σ_{n≤N} Λ(n)·f(n)`. `f(N) = 0`, so by
partial summation `S(N,s) = ∫_1^N ψ(u)·g(u) du` with
`g(u) = −f'(u) = s·u^(−s−1) − (s−1)·u^(−s)/N`. `ψ = 0` on `[1,2)`.

For a power `u^a` on `[2,N]`:

    K(a) = ∫_2^N u^a·g(u) du
         = s·(N^(a−s) − 2^(a−s))/(a−s) − (s−1)·(N^(a−s+1) − 2^(a−s+1))/((a−s+1)·N)   (a ≠ s, s−1)
    K(s) = s·(log N − log 2) − (s−1)·(N−2)/N.

`ExplicitTwo.explicit_formula_all_two` on `[2,N]`:
`ψ(u) = u − Σ_{|γ|<T} m·u^ρ/ρ + E(u,T)`,
`‖E‖ ≤ c1t·u·log²(uT)/T + c3t·log u + Bleft2·u^(−1/4)`. So

    S(N,s) = K(1) − Σ_{|γ|<T} (m/ρ)·K(ρ) + ∫_2^N E·g.

With `σ = Re s > 0` and `u ≤ N`: `‖g(u)‖ ≤ (‖s‖ + ‖s−1‖)·u^(−σ−1)`, so

    ‖∫_2^N E·g‖ ≤ (‖s‖+‖s−1‖)·(c1t·N·log²(NT)/T + c3t·A₁(σ) + Bleft2·A₂(σ)),

`A₁(σ) = ∫_2^∞ log u·u^(−σ−1) du`, `A₂(σ) = ∫_2^∞ u^(−σ−5/4) du`, both finite.

At `s = ρ₀`, a zero of order `m₀` below height `T`: its own term is
`−(m₀/ρ₀)·K(ρ₀) = −m₀·log N + m₀·log 2 + m₀·(ρ₀−1)·(N−2)/(ρ₀·N)`. Every other
zero carries `N^(ρ−ρ₀)`, of size `N^(β−β₀)`.

- `peak_formula`: the identity above with the error bound, every `N ≥ 2`,
  `T ≥ 2`, `s` with `Re s > 0`.
- `peak_at_zero`: at `s = ρ₀`, the `−m₀·log N` term split out.
- `peak_height` : if no zero below `T` lies right of `ρ₀`, the other zeros'
  terms are at most `Σ m/(‖ρ‖)·(‖ρ₀‖/‖ρ−ρ₀‖ + ‖ρ₀−1‖/‖ρ−ρ₀+1‖)·2`, free of `N`.
  The peak is `m₀·log N` plus the smooth term `K(1)` plus a part bounded by the
  sum over zeros to height `T` and the error.

## R6 The half in the sieve — `Stage3/HalfSieve.lean`

Julian's reason for the open link: the offset of one half at every doubling.
Three exact facts carry it into the sieve.

1. `Midpoint n − (2^n − 1) = 1/2 = −ζ(0)` (`riemannZeta_zero`).
2. Each rounding is a fractional part. The signs over the sieve's terms are
   the alternating sum of a Pascal row and add to `0` once `2` is among the
   primes (`N ≥ 4`). So `netRounding N = Σ_T (−1)^|T|·(fract(N/d_T) − 1/2)`:
   the half of every rounding cancels identically.
3. `resid N = resid √N − wobble N`, with `wobble = netRounding − smoothNet`
   (`SieveResidual.net_wobble`).

Induction down the square roots. With `|wobble N| ≤ C·√N·log N` for `N ≥ 2`
and `K = 2C + 2M`, `M = |resid 1| + |resid 2| + |resid 3|`: for `s = √N ≥ 4`,
`4s ≤ s² ≤ N` gives `2√s ≤ √N`, so `K·√s·log s ≤ (K/2)·√N·log N`, and
`(K/2) + C ≤ K`. For `s ≤ 3` the residual at `s` is at most `M ≤ 2M·√N·log N`.
No factor is lost at a step: the constant is the same at every `N`.

- `resid_of_wobble`, `schoenfeld_of_wobble` (integers to reals by `Li' = 1/log`).
- `spiralLink_iff_wobble`: `SpiralLink ↔ WobbleSqrt`, through
  `PiToPsi.RH_iff_schoenfeldWeak`.

What this leaves: `WobbleSqrt` itself. It is a statement about the fractional
parts of `N/d` over the squarefree `d` built from the primes up to `√N`,
measured from one half, less `smoothNet`.
