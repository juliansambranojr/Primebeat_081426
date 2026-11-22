# Landau worksheet — the window criterion

The statement this worksheet targets, copied from `Stage3/LandauWindow.lean`
and restated nowhere else:

    def StmtLandauWindow : Prop :=
      ∀ θ δ C : ℝ, 0 < θ → θ < 1 → 0 < δ → WindowBound θ δ C →
        ∀ s : ℂ, θ < s.re → riemannZeta s ≠ 0

with `WindowBound θ δ C := ∀ Y₀, ∃ Y, Y₀ ≤ Y ∧ ∀ y ∈ Icc Y (Y^(1+δ)), G y ≤ C * y^θ`
and `G y = rampSum y − y log y + (1 + γ) y`, `rampSum y = Σ_{n ≤ y} Λ(n)(y/n − 1)`.

Provenance. The shape is read from the archive Levent Alpöge released on
2026-11-20 (`Deduction.zeroFree_of_rpow_window`, for families of Dirichlet
characters; opened 2026-11-22, five steps down from its `riemannHypothesis`).
That archive has no licence file, so no code is taken from it, and of its
proof only the statement, the definitions and the eight lines that call its
`landau_window` were read. The plan below is this worksheet's own. Whether it
is the archive's argument is not known.

Unit 0383 measured `G` to `10⁸`: `|G(y) − log 2π + T(y)| ≤ K√y` throughout,
`K = 0.0461914`, and the bench's zeros reproduce it.

## 0. The plan, and what beats what

Suppose `WindowBound θ δ C` and a zero `ρ₀ = β₀ + iγ₀` with `β₀ > θ`. By
block 1's facts take `β₀ < 1`.

`Φ(s) := −ζ'/ζ(s)/(s(s−1)) − 1/(s−1)² + (1+γ)/(s−1)` is the Mellin transform
`∫₁^∞ G(y) y^(−s−1) dy` on `Re s > 1` (slice 2). It is analytic at `s = 1`
and meromorphic on `Re s > 0`, where its poles are the zeros of `ζ`, the
principal part at a zero `ρ` of multiplicity `m` being `m/(ρ(1−ρ)) · 1/(s−ρ)`
(slice 3).

Fix a real `σ₀ > 1`, large. Two readings of `(−1)^k Φ^(k)(σ₀)`:

- from the primes: it is `∫₀^∞ G(e^u) u^k e^(−σ₀u) du`. On the window `G ≤ C e^(θu)`,
  so that part is at most `|C|·k!/(σ₀−θ)^(k+1)`. Outside the window a crude
  bound `|G(e^u)| ≤ A(u+1)e^u` leaves a tail, and for `k` with
  `(k+1)/(σ₀−1)` at the middle of the window the tail is at most
  `k!/(σ₀−1)^(k+1) · e^(−cδ²k)` (slices 4, 5);
- from the zeros: the Taylor coefficient of `Φ` at `σ₀` is the sum over the
  poles nearest `σ₀` of `−m/(ρ(1−ρ)) · (ρ−σ₀)^(−(k+1))`, up to a term with a
  smaller exponential rate. That sum is `r^(−(k+1))` times a real
  trigonometric polynomial in `k` with no constant term, `r` the least
  distance from `σ₀` to a pole (slice 3).

Sizes, per unit `k`, in the exponent:

    zeros      −log r,            r ≤ |σ₀ − ρ₀|
    window     −log(σ₀ − θ)
    tail       −log(σ₀ − 1) − cδ²

The zeros win over the window when `|σ₀ − ρ₀| < σ₀ − θ`, which is
`γ₀² < (β₀ − θ)(2σ₀ − β₀ − θ)`: true for `σ₀` large. They win over the tail
when `log(|σ₀ − ρ₀|/(σ₀ − 1)) < cδ²`; the left side is about `(1 − β₀)/σ₀`:
true for `σ₀` large. So `σ₀ = σ₀(ρ₀, θ, δ)` is explicit and both gaps are
strict. THE LOST-FACTOR CHECK: nothing here grows with `k` except through
these three rates, and the zeros' rate is strictly the largest. The one
place a factor could hide is the trigonometric polynomial, which has mean
zero: it must be shown to be at least a positive constant for some `k` in
every long block, with the sign `(−1)^k` folded in (slice 6). After that
sign its frequencies are `arg(ρ − σ₀) + π`, which is `0` modulo `2π` exactly
for a real pole. A real zero of `ζ` to the right of `θ` would therefore add
a constant term, and that term is positive (`m/(ρ(1−ρ)) > 0` for real `ρ` in
`(0, 1)`): it helps. So slice 6 is stated for a constant term `≥ 0` plus
oscillating terms, and the plan does not need `ζ` to be free of real zeros
in `(0, 1)`. (The first writing of this paragraph said it did. Checked
2026-11-22: the dependencies have that fact only on `(−1, 0]`, and the plan
turned out not to use it.)

Then for the window at `Y`, any block of admissible `k` near
`σ₀(1 + δ/2)·log Y` holds a `k` where the zeros' reading exceeds the primes'
reading. Contradiction (slice 7).

### 1 The statement and the reduction to RH — PROVED (unit 0384: `LandauWindow.zeta_neg_nat_ne_zero`,
`rh_of_zeroFree_half`, `zeroFree_half_of_window`, `rh_of_window`)

Objects.   `rampSum`, `G`, `WindowBound`, `StmtLandauWindow` as above. No size:
           this block is logic and the functional equation.
Sizes.     none. Lost factor: none.
Regime.    none.
Defs.      `rampSum`, `G`, `WindowBound`, `StmtLandauWindow`. Four.
Theorems.  `theorem zeta_neg_nat_ne_zero (n : ℕ) (hn : ¬∃ k : ℕ, n = 2 * (k + 1)) :
               riemannZeta (-(n : ℂ)) ≠ 0`
             (`n = 0` is `riemannZeta_zero`; `n` odd is the functional equation
             at `n + 1`, every factor nonzero.)
           `theorem rh_of_zeroFree_half (h : ∀ s : ℂ, 1 / 2 < s.re → riemannZeta s ≠ 0) :
               RiemannHypothesis`
           `theorem zeroFree_half_of_window (hL : StmtLandauWindow)
               (hW : ∀ θ : ℝ, 1 / 2 < θ → θ < 1 → ∃ δ C : ℝ, 0 < δ ∧ WindowBound θ δ C) :
               ∀ s : ℂ, 1 / 2 < s.re → riemannZeta s ≠ 0`
           `theorem rh_of_window (hL : StmtLandauWindow) (hW : …) : RiemannHypothesis`
Composes.  Mathlib: `riemannZeta_one_sub`, `riemannZeta_zero`,
           `riemannZeta_ne_zero_of_one_lt_re` (a `lemma`),
           `riemannZeta_ne_zero_of_one_le_re` (a `lemma`), `Complex.Gamma_ne_zero`,
           `Complex.cpow_ne_zero_iff`, `Real.cos_nat_mul_pi`, `Complex.ofReal_cos`.
Module.    `Stage3/LandauWindow.lean`, namespace `LandauWindow`, `import Mathlib`.
Open.      the leaf `StmtLandauWindow` itself: slices 2 to 7.

## 0b. What the trees already hold, searched 2026-11-22

Statements only were read; hypotheses may still need adapting.

    slice 2   Mathlib `LSeries_vonMangoldt_eq_deriv_riemannZeta_div` (a `lemma`);
              models: `Stage3/PerronKernel.lean`, upstream `SmoothedChebyshevDirichlet`
    slice 3   upstream `kadiri_logDeriv_analytic_zero_principal_part_remainder_bound`
              (`IEANTN/KadiriEq12Foundations.lean`), `logDeriv_residue_eq_meromorphicOrderAt`
              (`RectangleArgumentPrinciple.lean`, already imported by Stage 3),
              `riemannZeta.zeroes_on_Compact_finite'`; Mathlib
              `norm_iteratedDeriv_le_of_forall_mem_sphere_norm_le`
    slice 4   Mathlib `Real.Gamma_eq_integral`, `Real.Gamma_nat_eq_factorial`;
              no tail bound in any tree
    slice 5   Mathlib `Chebyshev.psi_le`; upstream `mertens_first_theorem`
    slice 6   nothing; `Stage3/WeilPowerGeom.lean` has `geom_Ico`, `norm_geom_le`

So slice 3 is assembly, slice 5 is nearly free, and the new analysis is the
ramp kernel of slice 2, the tail of slice 4 and the lemma of slice 6.

### 2 The Mellin transform of the ramp sum — SKETCH
For `Re s > 1`: `∫₁^∞ rampSum(y) y^(−s−1) dy = −ζ'/ζ(s)/(s(s−1))`. Termwise,
`∫_n^∞ (y/n − 1) y^(−s−1) dy = n^(−s)/(s(s−1))`, and Mathlib has the L-series of
`Λ` as `−ζ'/ζ`. The interchange is monotone convergence at real `s`, then
domination. Then `∫₁^∞ G(y) y^(−s−1) dy = Φ(s)`.

### 3 The poles of `Φ` and its Taylor coefficients — SKETCH
`Φ` analytic at `1`; meromorphic on `Re s > 0`; principal part
`m/(ρ(1−ρ))/(s−ρ)` at a zero of multiplicity `m`; finitely many poles in a
closed disc inside `Re s > 0`; no real zero of `ζ` in `(0, 1)`; the Taylor
coefficient at `σ₀` as the nearest poles' sum plus a remainder of smaller
rate, by Cauchy's estimate on a circle through no pole. The largest slice.

### 4 The kernel on and off the window — SKETCH
`∫₀^∞ u^k e^(−au) du = k!/a^(k+1)`, and the two-sided tail of that integral
away from `k/a`, as an explicit `e^(−cδ²k)`.

### 5 A crude bound on `G` — SKETCH
`|G(y)| ≤ A·y·(log y + 1)` for `y ≥ 1`, from Chebyshev; upstream may have it.

### 6 A trigonometric polynomial with no constant term is positive somewhere in every long block — SKETCH
Elementary and self-contained: mean zero, mean square positive, bounded.

### 7 The assembly — SKETCH
`StmtLandauWindow` from slices 2 to 6.
