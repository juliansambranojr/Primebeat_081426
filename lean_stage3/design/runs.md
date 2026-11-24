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

## R7 The number line bounded by itself — `Stage3/SelfBound.lean`

Julian: the table holds because it is bounded by itself. The exact form.
`log n = Σ_{d | n} Λ(d)` (`ArithmeticFunction.vonMangoldt_sum`). Summed over
`n ≤ N`, each step `Λ(d)` is counted `⌊N/d⌋` times, and
`Σ_{d≤N} Λ(d)·⌊N/d⌋ = Σ_{k≤N} ψ(N/k)`. So at every `N`

    Σ_{k≤N} ψ(N/k) = Σ_{n≤N} log n,
    Σ_{k≤N} (ψ(N/k) − N/k) = Σ_{n≤N} log n − N·Σ_{k≤N} 1/k.

The right side has no prime in it. The residuals at the scales `N, N/2, N/3, …`
are tied: an excess at one is paid back at the others.

What it does not give alone: a bound at one scale. Solving for `ψ(N) − N`
from the tie takes the Möbius signs, `ψ(N) = Σ_k μ(k)·T(N/k)`,
`T(y) = Σ_{n≤y} log n`, and the size of that sum is the size of the sums of
the Möbius signs. The same step as `HalfSieve.WobbleSqrt`: the Pascal signs
cancel the half of each rounding exactly (R6), and the part of each rounding
away from the half is weighed by the same signs.

## R8 The size rate, from above — `Stage3/StepsRate.lean`

The second size of unit 0472. From `StepsPeak.K_eq`, for `a ≠ s`, `a ≠ s − 1`
and `Re a − Re s ≤ δ`, `δ ≥ 0`: `‖N^(a−s)‖ ≤ N^δ`, `‖2^(a−s)‖ ≤ N^δ`, and the
second pair at most `N^δ·N`, so

    ‖K(a)‖ ≤ (‖s‖/‖a−s‖ + ‖s−1‖/‖a−s+1‖)·2·N^δ.

With `peak_formula`, at `s` not a zero, `0 < Re s ≤ 1`, every zero below `T`
of real part at most `Θ ≥ Re s`:

    ‖S − K(1)‖ ≤ (Σ_{|γ|<T} (m/‖ρ‖)·(‖s‖/‖ρ−s‖ + ‖s−1‖/‖ρ−s+1‖)·2)·N^(Θ − Re s) + error.

- `norm_K_le_pow`, `rate_upper`.

The rate the run read is at most the largest real part less the weight tried.
That it is no less is the lower half: some zero of the largest real part must
be seen in the sum and not cancelled by the others. Not stated here.

## R9 The rain comes — `Stage3/RateBelow.lean` (staircase) and `Stage3/StepsBelow.lean` (turned steps)

Julian, 2026-11-23: the zero need not be shown uncancelled at a given cutoff;
it is inferred from the trajectory. The pole fixes what the cutoffs do again
and again.

**Staircase.** `ThetaConverse.no_zero_right_of_theta`: a bound
`|ψ(x) − x| ≤ C·x^θ·log^k x` from `x₀` on leaves no zero right of `θ`. Read
the other way: at a zero `ρ₀` and any `θ < Re ρ₀`, for every `C`, `k`, `x₀`
there is `x ≥ x₀` with `|ψ(x) − x| > C·x^θ·log^k x`. `RateBelow.rain_psi`.

**Turned steps.** `a_n = Λ(n)·n^(−s)`, `σ = Re s > 0`,
`B(x) = Σ_{n≤x} a_n·(x − n)`, so `B(N) = N·S(N,s)`. For `Re w > 1 − σ`:

    Σ a_n·n^(−w) = −ζ'/ζ(s+w) = w(w+1)·∫_1^∞ B(x)·x^(−w−2) dx.

The smooth term: `K(1) = N^(1−s)/((1−s)(2−s)) + O(1)`; its part of the
integral is `1/((1−s)(2−s)(w−(1−s)))`, a pole at `w = 1 − s` only. If
`‖S(N,s) − K(1)‖ ≤ C·N^δ` from `N₀` on, `δ ≥ 0`, then
`B(x) − x^(2−s)/((1−s)(2−s)) = O(x^(1+δ))` and the rest of the integral is
analytic on `Re w > δ` (`mellin_differentiableAt_of_isBigO_rpow`, as V1 of
`ThetaConverse`). Then `−ζ'/ζ(s+w)/(w(w+1))` less the pole at `1 − s` extends
analytically to `Re w > δ`, by the identity theorem as V3. A zero `ρ₀` with
`Re ρ₀ − σ > δ`, `ρ₀ ≠ s`, gives a pole at `w = ρ₀ − s` (V4,
`StepsPole.steps_pole`). Contradiction.

- `StepsBelow.rain_steps`: at a zero `ρ₀`, a point `s` with `0 < Re s`,
  `ρ₀ ≠ s`, and `0 ≤ δ < Re ρ₀ − Re s`: for every `C`, `N₀` there is
  `N ≥ N₀` with `‖S(N,s) − K(1)‖ > C·N^δ`.

## R10 The composite table has no signs — `Stage3/CompositeSplit.lean`

Julian, 2026-11-23: look at the composite table for the open link.
`lean/PairIdentity.lean`: the prime cell and the composite cell add to a power
of two, so the two residuals are the same with the sign changed.

Every term `⌊N/d⌋` of the sieve counts composites, the multiples of `d`, and
the Pascal signs correct the repeats. Each `n ≥ 2` has exactly one least prime.
`n` has least prime `p` exactly when `n = p·m` with `m ≤ N/p` and no prime
below `p` dividing `m`. A composite `n ≤ N` has least prime at most `√N`.

    rough N p = #{m ≤ N/p : no prime below p divides m}
    #{composites ≤ N} + #{primes ≤ √N} = Σ_{p ≤ √N} rough N p.

Every term is a count. `rough N p` is the table at the scale `N/p` sieved by
the primes below `p`. The open step in this form: the residual at `N` is tied
to the residuals of the same counts at the scales `N/p`, all with one sign.
Not derived here: a bound from that tie.

- `card_least_prime`, `composites_by_least_prime`, `composite_part`,
  `composites_no_signs`.

## R11 The primes as the compression of the composites — `Stage3/Compression.lean`

Julian, 2026-11-23: the primes are the compression of the composites up to
that step; the composites exhaust their combinations and demand a prime, or
they would repeat.

Exact form at the step `√N → N`. `smooth N`: the `n ≤ N` all of whose primes
are at most `√N`, the combinations of the primes so far. A number `n ≤ N`
with two different primes `p, q > √N` would have `pq ≤ n ≤ N < (√N+1)²`, so
it has at most one. The `n ≤ N` that are not combinations are the multiples
of the new primes, each under exactly one new prime:

    N = smooth N + Σ_{√N < p ≤ N} ⌊N/p⌋.

No signs, nothing counted twice. Read for the open step: the new primes with
their multiples are exactly what the combinations leave. The residual of the
right-hand sum is minus the residual of `smooth N`.

- `unique_new_prime`, `nonSmooth_eq_biUnion`, `compression`.

Not derived: a size for the residual of `smooth N`.

## R12 The sieve's step is idempotent — `Stage3/SieveIdem.lean`

Julian, 2026-11-23: the settling happens one slot at a time because of
idempotence; every step is the same `f`, and it scales at any `x`.

A prime's step `f_p` removes its multiples. `f_p ∘ f_p = f_p`; `f_p ∘ f_q =
f_q ∘ f_p`; membership reads `m ∈ A ∧ ¬ p ∣ m`, with no size in it. The sieve
below `p` grows by one prime's step past each prime and is unchanged past each
number that is not prime. Its counts on `[1, N/p]` are `CompositeSplit.rough`.
The first number no earlier prime divides is prime.

- `sieveStep_idem`, `sieveStep_comm`, `mem_sieveStep`, `sieveBelow_idem`,
  `sieveBelow_succ`, `sieveBelow_succ_of_not_prime`, `rough_eq_card`,
  `settles_on_prime`.

Not derived: idempotence fixes which numbers are left; it gives no size for
the roundings `⌊N/p⌋` the counts carry.

## R13 The integers have no holes — `Stage3/NoHoles.lean`

Julian, 2026-11-24, "Do it": a made-up prime system (Beurling) can sieve
idempotently and still have zeros off the line; what the real primes have is
the integers 1, 2, 3, … with nothing missing. Use it.

`SelfBound.self_bound`: `Σ_{k≤N} ψ(N/k) = log N!`. Inverted by the Möbius
signs: `ψ(N) = Σ_{k≤N} μ(k)·log⌊N/k⌋!`. The integers enter only through
`log M!`, which is `M log M − M` within a logarithm (no holes, an error of
size `log M` at every `M`). So

    ψ(N) = Σ_{k≤N} μ(k)·S(N/k) + Σ_{k≤N} μ(k)·e(N/k),
    S(M) = M log M − M,   |e(M)| ≤ C·(log M + 1).

- `moebius_floor_inversion`: `F(M) = Σ_{j≤M} f(⌊M/j⌋)` gives
  `Σ_{k≤N} μ(k)·F(⌊N/k⌋) = f(N)`.
- `psi_by_integers`, `log_factorial_close`, `holes_resid`.

**The size of what is added.** The second sum has `N` terms, each at most a
logarithm, with signs `μ(k)`. Without the signs cancelling, its bound is
`N·log N`: a factor `N/√N` lost, growing with `N`. By the rule on a lost
factor this is a design failure of the route unless the signs cancel. The
cancellation is the Möbius string `μ(1), μ(2), …` in `{−1, 0, 1}` staying
within `√N`, Mertens' statement.

## R14 The perfect fit — `Stage3/PerfectFit.lean`

Julian, 2026-11-24: the harmonic carries the cancellation; the sign it has to
absorb is a perfect fit because the harmonic already carries the signs'
absence. For the counts it is exact: `NoHoles.moebius_floor_inversion` with
`f = 1` on the positive integers gives

    Σ_{k≤N} μ(k)·⌊N/k⌋ = 1.

- `perfect_fit`.

**Not here.** The log-weighted harmonic `Σ μ(k)·log⌊N/k⌋!` is the staircase
(`NoHoles.psi_by_integers`); its staying within `√N` of `N` is `NoRunaway`.

## R15 The doubling, push and pull — `Stage3/Doubling.lean`

Julian, 2026-11-24: "let's try it", `NoRunaway`. Route from his pieces: no
holes and the dyadic doubling. `self_bound` at `N` less twice `self_bound`
at `⌊N/2⌋` keeps the odd scales and subtracts the even:

    Σ_{k≤N} (−1)^(k+1) ψ(N/k) = log N! − 2·log⌊N/2⌋!.

By `log_factorial_close` the right side is `N log 2` within `O(log N)`; the
alternating sum of `N/k` is `N log 2` within a constant. So

    Σ_{k≤N} (−1)^(k+1) R(N/k) = O(log N),   R(x) = ψ(x) − x.

- `alt_scales`, `alt_resid_small`.

**The induction.** `R(N) = R(N/2) − R(N/3) + … + O(log N)`. Assume
`|R(y)| ≤ C√y` below `N`. The sizes alone give `C√N·Σ_{2≤k≤N} k^(−1/2)`,
which grows like `2C·N`: the number of scales is a lost factor growing with
`N`. Closing it needs the alternating residuals to cancel among themselves.
