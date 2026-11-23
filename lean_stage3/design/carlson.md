# carlson.md — a zero-density bound with a power saving, built in the tree

Written 2026-11-23 on Julian's word: "Prove Carlson's bound ourselves, which is
a large project". Read first after any compaction; do not re-derive what is here.

## What is wanted

For every `σ > 1/2` there are `δ > 0`, `C` and `T₀` with

    N(σ, T) ≤ C·T^(1−δ)   for T ≥ T₀,

`N(σ, T)` the number of zeros of ζ with `Re ρ ≥ σ` and `|Im ρ| < T`. Carlson's
exponent is `4σ(1−σ)`; joint 10 needs only some saving at every `σ > 1/2`. The
saving gives `Σ_{Re ρ ≥ σ} m(ρ)/|ρ| < ∞`, the input unit 0431 names.

Upstream holds the structure `zero_density_bound` and the Fiori–Kadiri–
Swidinsky statement with its proof left out; its exponent is below one only
for `σ > 5/8`. Opened 2026-11-23:
`PrimeNumberTheoremAnd/IEANTN/ZetaDefinitions.lean`, `FioriKadiriSwidinsky.lean`.

## The route

`M_X(s) = Σ_{n < X} μ(n)·n^(−s)`, `f = ζ·M_X − 1`. At a zero `ρ` of ζ,
`f(ρ) = −1`.

### C1 Mean value of a finite Dirichlet sum — PROVED (unit 0446: `DirichletMean.dirichlet_mean_value`, `dirichlet_mean_value_window`, `dirichlet_mean_value_sigma`), `c = 8`

    ∫₀ᵀ |Σ_{n ≤ N} a_n·n^(−it)|² dt ≤ (T + c·N·(1 + log N))·Σ |a_n|².

Diagonal `T·Σ|a_n|²`. Off the diagonal `|∫ e^(−itθ)| ≤ 2/|θ|`,
`|log m − log n| ≥ |m − n|/N`, harmonic sum. Elementary; the sharper form
without the logarithm is not needed.

### C1b The same with each term charged its own index — PROVED (unit 0450: `DirichletMeanW.dirichlet_mean_value_weighted`, `_sigma`), `c = 6`; decision: unit 0449

C1 charges the length `N` to every term. In C4 the sum has length `N·X` and
coefficients that decay, and the uniform charge gives `N·X^(2−2u)`, above `T`
at every `u`. Wanted:

    ∫ |Σ_{n ≤ N} a_n·n^(−it)|² dt ≤ Σ |a_n|²·((T₂ − T₁) + c·n·(1 + log N)).

Weighted Schur test with weights `1/n`: the row cost of `m` is
`m·Σ_{n ≠ m} K(m,n)/n ≤ 6m(1 + log N)`, from
`log(larger) − log(smaller) ≥ (larger − smaller)/larger`.

### C2 The mollified finite sum — PROVED (unit 0447: `Mollified.prod_eq_sum`, `coef_eq_zero`, `sum_coef_sq_le`, `sum_coef_sq_weighted_le`)

`P_N(s) = Σ_{n ≤ N} n^(−s)`. `P_N·M_X = Σ_n c_n·n^(−s)`,
`c_n = Σ_{d | n, d < X, n/d ≤ N} μ(d)`. For `n < X` and `n ≤ N` every divisor
is allowed and `c_n = [n = 1]`. For all `n`, `|c_n| ≤ #{d | n, d < X}`, and

    Σ_{n ≤ Y} (#{d | n, d < X})² ≤ Y·Σ_{d₁,d₂ < X} 1/lcm(d₁,d₂) ≤ Y·(1 + log X)³,

by `1/lcm = gcd/(d₁d₂)` and summing over the gcd. No multiplicativity of the
divisor function is used.

### C2b The coefficients weighted upward — inside C4's file

`Σ_{n ≤ Y} c_n²·n^(1−2u) ≤ C·(1 + log X)³·(1 + log Y)·Y^(max(2−2u, 0))`, by dyadic
blocks and `Mollified.sum_coef_sq_le`. This is what C1b's `n`-term meets.

### C3 ζ as a finite sum to any order — PROVED (unit 0448: `ZetaEM.zeta_eq_em`, `norm_remainder_le`, `norm_zeta_sub_partial_le`), every order by induction

For `Re s ≥ 1/2`, `|Im s| ≤ T` and `N ≥ T^(1+ε)`:

    ζ(s) = P_N(s) + N^(1−s)/(s−1) + (boundary terms in N^(−s−j)) + R_k,
    |R_k| ≤ C_k·|s|^k·N^(1−σ−k).

Euler–Maclaurin of order `k`, by induction with the periodic Bernoulli
functions. The tree's `ZetaGrowth` has order two. Order `k` large is what lets
`N` be `T^(1+ε)`: at order two `N` must be `T^(4/3)` and the saving is lost for
`σ ≤ 5/8`. This is the stage where a lost factor would be a design failure.

### C4 The mean square of `f` on a vertical line — PROVED (unit 0451: `MollifiedMean.mean_sq_f_le`, with C2b `sum_coef_sq_up_le`); window `[1, T]`, `u ∈ (1/2, 2]`, `2 ≤ X ≤ N`, `T + 3 + k ≤ N`

For `1/2 < u ≤ 2`, from C1–C3 with `N = T^(1+ε)`:

    ∫₀ᵀ |f(u + it)|² dt ≪ (T + N·X·log)·X^(1−2u)·log³ + (small).

### C5 Zeros from the mean square — PROVED (unit 0452: `SquareMean.sq_mean_lower`; unit 0453: `ZeroSquares.card_zeros_le`, `π·δ²·#Z ≤ 3·(15 log T + 73)·∬`, squares in the place of discs)

`|f|²` is subharmonic, so `1 = |f(ρ)|² ≤` the mean of `|f|²` over a disc of
radius `r` about `ρ`. Summing over the zeros with `Re ρ ≥ σ`, `|Im ρ| < T`:
the discs lie in `σ − r ≤ u`, and a point is in at most `C·log T` of them (the
zeros in a box of height two, from the zero count). So

    N(σ, T) ≤ (C·log T / r²)·∫_{σ−r}^{2} ∫ |f(u + it)|² dt du + (zeros right of 2: none).

This stands in for Littlewood's lemma; no logarithm of `f` appears.

### C6 The bound, and summability — the bound PROVED (unit 0454: `ZeroDensity.zero_density`, `θ = 1 − 5δ²`, `δ = (σ − 1/2)/4`, `X = ⌈T^δ⌉`, `N = ⌈T^(1+δ)⌉`, `k = ⌈1/δ⌉ + 1`); summability PROVED (unit 0455: `ZeroSummable.summable_order_div`, `summable_norm_coef`)

`X = T^a`, `N = T^(1+ε)`, `r = (σ − 1/2)/2`: both `1 − a(2u−1)` and
`(1 + ε + a)(2 − 2u)` are below one on `u ≥ σ − r` for small `a`, `ε`. Then
dyadic blocks in `T` give `Σ_{Re ρ ≥ σ} m(ρ)/|ρ| < ∞`.

### C7 Joint 10 when the largest real part is attained — PROVED on the count (unit 0456: `AttainedPi.attained_off_line_pi`)

With C6, `LadderMean.line_not_fading_summable` and the splitting of unit 0431:
the top line is a summable sum of modes; the zeros with real part within `η`
of the top carry weight tending to zero with `η`; the rest are smaller by a
fixed ratio per row.

## Not in this plan

The case where the real parts approach a line and do not reach it.
