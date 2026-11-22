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

- from the primes: it is `∫₀^∞ G(e^u) u^k e^(−σ₀u) du` (block 2c). On the window `G ≤ C e^(θu)`,
  so that part is at most `|C|·k!/(σ₀−θ)^(k+1)`. Outside the window a crude
  bound `|G(e^u)| ≤ 8(u+1)e^u` (block 5b) leaves a tail, and for `k` with
  `(k+1)/(σ₀−1)` at the middle of the window the tail is at most
  `k!/(σ₀−1)^(k+1) · e^(−cδ²k)` (blocks 4b, 5b);
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

Searched again 2026-11-22 for blocks 2b, 2c and 3, after block 2 was proved:

    block 2b  have: `LandauMellin.mellin_rampSum`; Mathlib `integral_Ioi_cpow_of_lt`.
              to build: `∫₁^∞ log y · y^(−s) dy = 1/(s−1)²`, in no tree, from
              Mathlib `integral_Ioi_of_hasDerivAt_of_tendsto` and
              `isLittleO_log_rpow_atTop`; the integrability of
              `rampSum · y^(−s−1)`, which follows from the summability inside
              the proof of `mellin_rampSum`
    block 2c  Mathlib `mellin_hasDerivAt_of_isBigO_rpow` gives one derivative
              of a Mellin transform; nothing gives all of them
    block 3   near 1: Mathlib `riemannZeta₁` (entire, `(s−1)ζ(s)`),
              `deriv_riemannZeta₁_one` (its derivative at 1 is `γ`),
              `deriv_riemannZeta_eq_neg_inv_sub_sq_mul_add` (all `lemma`s);
              upstream `riemannZetaLogDerivResidueBigO` bounds
              `−ζ'/ζ − 1/(s−1)` near 1 and does not give the constant.
              at a zero: upstream
              `kadiri_logDeriv_analytic_zero_principal_part_remainder_bound`;
              Stage 3 `ContourShift.zeta_order_ne_top`, `one_le_zeta_order`,
              `order_bridge`.
              finitely many: upstream `riemannZeta.zeroes_on_Compact_finite'`.
              subtracting finitely many simple poles: the construction is
              inside the proof of Stage 3 `ContourShift.residue_rectangle_of_local`,
              for a rectangle, and is not exported; restate it for a disc.
              the remainder: Mathlib `norm_iteratedDeriv_le_of_forall_mem_sphere_norm_le`.

Signs checked by hand the same day: the principal part of `Φ` at a zero `ρ`
of multiplicity `m` is `m/(ρ(1−ρ))/(s−ρ)` and its Taylor coefficient at `σ₀`
is `−m/(ρ(1−ρ))·(ρ−σ₀)^(−(k+1))`, as section 0 has them; at `s = 1`,
`−ζ'/ζ(s)/(s(s−1)) = 1/(s−1)² − (1+γ)/(s−1) +` analytic, which is what `Φ`
subtracts.

Searched a third time 2026-11-22, after blocks 2b, 5 and 5b were proved, for
blocks 2c, 4, 6 and 7. By name over `theorem` and `lemma` headers, in Mathlib,
upstream, Stage 3, the bench's `lean/`, `lean_bridge/` and the zeta23 clone
(`anthropics/formal-math`, another toolchain: nothing in it can be imported
here). A piece stated under an unrelated name is not found by such a search.

    block 2c  Mathlib `hasSum_integral_of_summable_integral_norm` (a `lemma`,
              used in block 2), `hasSum_taylorSeries_on_ball` (a `lemma`),
              `HasFPowerSeriesAt.eq_formalMultilinearSeries`; the bound
              `LandauChebyshev.abs_G_le_log`. Missing: the exact integral of
              block 4a, which the absolute convergence needs.
    block 4a  Mathlib `integral_rpow_mul_exp_neg_mul_Ioi` (a `lemma`),
              `Real.Gamma_nat_eq_factorial`, `intervalIntegral_pow_mul_exp_neg_le`
              (a `lemma`). No lemma changes variables by `y = e^u`; the
              general one is `integral_image_eq_integral_abs_deriv_smul`.
    block 4b  in no tree. Near it: zeta23 `pow_mul_exp_neg_le`
              (`Zeta23/Taper/Gevrey.lean`), `u^k e^(−u) ≤ (k/e)^k`, the
              pointwise maximum of the integrand; to be re-proved here if used.
    block 6   Stage 3 `WeilPowerGeom.geom_Ico`, `norm_geom_le`. Mathlib has
              Dirichlet's approximation for one frequency only
              (`exists_int_int_abs_mul_sub_le`), none for several at once.
              The lemma itself is in no tree.
    block 7   Mathlib `norm_iteratedDeriv_le_of_forall_mem_sphere_norm_le`,
              `riemannZeta_conj`; Stage 3 `ContourShift.zeta_order_conj`.
    our own   Stage 3's `mellin_*` theorems (`LineBound.lean`) are about a
              smoothing bump on vertical lines, another object; `lean/` and
              `lean_bridge/` hold nothing for these blocks.

The order the dependencies give: 4a, then 2c; 4b; 6; 3; 7 last. Block 3 is
the largest. The new mathematics is 4b and 6.

### 2 The Mellin transform of the ramp sum — PROVED (unit 0385: `LandauMellin.rampK_integrable`,
`rampK_integral`, `rampK_integral_norm`, `rampSum_eq_tsum`, `mellin_rampSum`)
Objects.   `rampK s n y = max(y/n − 1, 0)·y^(−s−1)`, the ramp kernel of one `n`;
           its integral over `(1, ∞)` is `n^(−s)/(s(s−1))`, of modulus
           `n^(−σ)/|s(s−1)|`, `σ = Re s`. `rampSum y = Σ_n Λ(n)·max(y/n − 1, 0)`
           (`LandauWindow.rampSum`; the sum is finite, the terms with `n > y`
           vanish).
Sizes.     the interchange of sum and integral is by absolute summability:
           `Σ_n Λ(n)·∫₁^∞ |rampK s n| = Σ_n Λ(n) n^(−σ) / (σ(σ−1))`, finite for
           `σ > 1`. An identity, nothing bounded against anything. Lost
           factor: none.
Regime.    R1 `1 < Re s`.
Defs.      `rampK (s : ℂ) (n : ℕ) (y : ℝ) : ℂ := ((max (y / n - 1) 0 : ℝ) : ℂ) * (y : ℂ) ^ (-s - 1)`. One.
Theorems.  `theorem rampK_integrable {s : ℂ} (hs : 1 < s.re) {n : ℕ} (hn : 1 ≤ n) :
               IntegrableOn (rampK s n) (Set.Ioi 1)`
           `theorem rampK_integral {s : ℂ} (hs : 1 < s.re) {n : ℕ} (hn : 1 ≤ n) :
               ∫ y in Set.Ioi (1 : ℝ), rampK s n y = (n : ℂ) ^ (-s) / (s * (s - 1))`
             (on `(1, ∞)` the kernel is the indicator of `(n, ∞)` times
             `y^(−s)/n − y^(−s−1)`; two power integrals; R1.)
           `theorem rampK_integral_norm {s : ℂ} (hs : 1 < s.re) {n : ℕ} (hn : 1 ≤ n) :
               ∫ y in Set.Ioi (1 : ℝ), ‖rampK s n y‖ = (n : ℝ) ^ (-s.re) / (s.re * (s.re - 1))`
             (the norm is the kernel at the real point `σ`, for `y > 0`; R1.)
           `theorem rampSum_eq_tsum (y : ℝ) :
               rampSum y = ∑' n : ℕ, ArithmeticFunction.vonMangoldt n * max (y / n - 1) 0`
           `theorem mellin_rampSum {s : ℂ} (hs : 1 < s.re) :
               ∫ y in Set.Ioi (1 : ℝ), (rampSum y : ℂ) * (y : ℂ) ^ (-s - 1)
                 = -deriv riemannZeta s / riemannZeta s / (s * (s - 1))`
Composes.  Mathlib: `integral_Ioi_cpow_of_lt`, `integrableOn_Ioi_cpow_of_lt`,
           `hasSum_integral_of_summable_integral_norm` (a `lemma`),
           `LSeriesSummable_vonMangoldt` (a `lemma`),
           `LSeries_vonMangoldt_eq_deriv_riemannZeta_div` (a `lemma`),
           `LSeries.term_def₀` (a `lemma`). `LandauWindow.rampSum`.
Module.    `Stage3/LandauMellin.lean`, namespace `LandauMellin`,
           `import Stage3.LandauWindow`. Pinned: `rampK_integral`,
           `rampK_integral_norm`, `mellin_rampSum`.
Open.      block 2b.

### 2b The Mellin transform of `G` — PROVED (unit 0386: `LandauMellinG.LSeries_vonMangoldt_real_ne_zero`,
`rampSum_mellin_integrable`, `log_cpow_integrable`, `log_cpow_integral`, `G_mellin_integrable`, `mellin_G`)
Objects.   `Phi s = −ζ'/ζ(s)/(s(s−1)) − 1/(s−1)² + (1+γ)/(s−1)`, the `Φ` of
           section 0. `G` is `LandauWindow.G`. The three pieces of
           `G(y)·y^(−s−1)` on `(1, ∞)`: `rampSum(y)·y^(−s−1)` (block 2),
           `log y · y^(−s)`, `y^(−s)`.
Sizes.     identities and integrability; nothing is bounded against anything
           that grows. `log y ≤ y^ε/ε` with `ε = (σ−1)/2` makes `log y · y^(−s)`
           integrable for every `σ > 1`. Lost factor: none.
Regime.    R1 `1 < Re s`.
Defs.      `Phi (s : ℂ) : ℂ := -deriv riemannZeta s / riemannZeta s / (s * (s - 1))
               - 1 / (s - 1) ^ 2 + (1 + (Real.eulerMascheroniConstant : ℂ)) / (s - 1)`. One.
Theorems.  `theorem LSeries_vonMangoldt_real_ne_zero {σ : ℝ} (hσ : 1 < σ) : L ↗Λ (σ : ℂ) ≠ 0`
             (its real part is a sum of nonnegative terms, the term at `2` positive.)
           `theorem rampSum_mellin_integrable {s : ℂ} (hs : 1 < s.re) :
               IntegrableOn (fun y : ℝ => (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1)) (Ioi 1)`
             (at the real point `σ` the integral is `L(Λ,σ)/(σ(σ−1)) ≠ 0` by block 2,
             and a Bochner integral that is not zero is the integral of an
             integrable function; for `s` the norm is the same and the function
             is the one at `σ` times a continuous power.)
           `theorem log_cpow_integrable {s : ℂ} (hs : 1 < s.re) :
               IntegrableOn (fun y : ℝ => (Real.log y : ℂ) * (y : ℂ) ^ (-s)) (Ioi 1)`
           `theorem log_cpow_integral {s : ℂ} (hs : 1 < s.re) :
               ∫ y in Ioi (1 : ℝ), (Real.log y : ℂ) * (y : ℂ) ^ (-s) = 1 / (s - 1) ^ 2`
             (the primitive `P·log − P/(1−s)`, `P(y) = y^(1−s)/(1−s)`, is `1/(1−s)²`
             below zero at `1` and tends to `0`.)
           `theorem G_mellin_integrable {s : ℂ} (hs : 1 < s.re) :
               IntegrableOn (fun y : ℝ => (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1)) (Ioi 1)`
           `theorem mellin_G {s : ℂ} (hs : 1 < s.re) :
               ∫ y in Ioi (1 : ℝ), (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1) = Phi s`
Composes.  `LandauMellin.mellin_rampSum`. Mathlib: `integral_undef`,
           `integral_Ioi_of_hasDerivAt_of_tendsto'`, `hasDerivAt_ofReal_cpow_const'`,
           `Real.log_le_rpow_div` (a `lemma`), `isLittleO_log_rpow_atTop`,
           `tendsto_rpow_neg_atTop`, `integral_Ioi_cpow_of_lt`,
           `integrableOn_Ioi_rpow_of_lt`, `LSeries_vonMangoldt_eq_deriv_riemannZeta_div`.
Module.    `Stage3/LandauMellinG.lean`, namespace `LandauMellinG`,
           `import Stage3.LandauMellin`. Pinned: `rampSum_mellin_integrable`,
           `log_cpow_integral`, `mellin_G`.
Open.      none.

### 2c The Taylor coefficients of the transform, from the primes — PROVED (unit 0390:
`LandauTaylor.mellinLog_integrable`, `mellinLog_hasDerivAt`, `iteratedDeriv_Phi`, `mellinLog_real`)
Section 0 reads `(−1)^k Φ^(k)(σ₀)` as `∫₁^∞ G(y)(log y)^k y^(−σ₀−1) dy`. Found
missing on 2026-11-22: no block proved it. The first sketch went through a
power series and uniqueness of coefficients. The route built is shorter:
differentiate under the integral once, with a domination uniform on a disc,
and induct on `k`.
Objects.   `mellinLog k s = ∫₁^∞ G(y)·(−log y)^k·y^(−s−1) dy`. `mellinLog 0 = Phi`
           on `Re s > 1` (`LandauMellinG.mellin_G`). `L = log y`.
Sizes.     for `Re s ≥ 1 + a`, `a > 0`, `y > 1`: the integrand of `mellinLog k`
           has norm `|G|·L^k·y^(−σ−1) ≤ 8y(1+L)·L^k·y^(−σ−1)
           ≤ 8(L^k + L^(k+1))·y^(−a−1)`, integrable by block 4a. A domination,
           uniform in `s` on the half-plane; nothing is kept from it but
           integrability. Lost factor: none.
Regime.    R1 `1 < Re s`. The disc: centre `s`, radius `a = (Re s − 1)/2`, on
           which `Re ≥ 1 + a`.
Defs.      `mellinLog (k : ℕ) (s : ℂ) : ℂ := ∫ y in Ioi (1 : ℝ),
               (LandauWindow.G y : ℂ) * (-(Real.log y : ℂ)) ^ k * (y : ℂ) ^ (-s - 1)`. One.
Theorems.  `theorem mellinLog_integrable {s : ℂ} (hs : 1 < s.re) (k : ℕ) :
               IntegrableOn (fun y : ℝ =>
                 (LandauWindow.G y : ℂ) * (-(Real.log y : ℂ)) ^ k * (y : ℂ) ^ (-s - 1)) (Ioi 1)`
           `theorem mellinLog_hasDerivAt {s : ℂ} (hs : 1 < s.re) (k : ℕ) :
               HasDerivAt (mellinLog k) (mellinLog (k + 1) s) s`
           `theorem iteratedDeriv_Phi (k : ℕ) {s : ℂ} (hs : 1 < s.re) :
               iteratedDeriv k LandauMellinG.Phi s = mellinLog k s`
           `theorem mellinLog_real (σ : ℝ) (k : ℕ) :
               mellinLog k (σ : ℂ) = (-1) ^ k *
                 ((∫ y in Ioi (1 : ℝ), LandauWindow.G y * Real.log y ^ k * y ^ (-σ - 1) : ℝ) : ℂ)`
             (no hypothesis on `σ`: the two integrands agree pointwise, so the
             identity holds whether or not they are integrable. The first
             writing asked for `1 < σ`; the build showed it unused.)
Composes.  `LandauMellinG.mellin_G`, `G_mellin_integrable`;
           `LandauChebyshev.abs_G_le_log`; `LandauKernel.log_pow_integrable`.
           Mathlib: `hasDerivAt_integral_of_dominated_loc_of_deriv_le`,
           `HasDerivAt.const_cpow`, `iteratedDeriv_succ`,
           `Filter.EventuallyEq.deriv_eq`, `integral_complex_ofReal`.
Module.    `Stage3/LandauTaylor.lean`, namespace `LandauTaylor`. Pinned:
           `mellinLog_hasDerivAt`, `iteratedDeriv_Phi`, `mellinLog_real`.
Open.      none.

### 3 The poles of `Φ` and its Taylor coefficients — SKETCH
`Φ` analytic at `1`; meromorphic on `Re s > 0`; principal part
`m/(ρ(1−ρ))/(s−ρ)` at a zero of multiplicity `m`; finitely many poles in a
closed disc inside `Re s > 0`; the Taylor
coefficient at `σ₀` as the nearest poles' sum plus a remainder of smaller
rate, by Cauchy's estimate on a circle through no pole. The largest slice.
A real zero in `(0, 1)` is allowed (section 0). The pieces are in section 0b;
what is new is the disc form of the pole subtraction.

### 4a The kernel's integral — PROVED (unit 0389: `LandauKernel.log_pow_le`, `log_pow_integrable`,
`log_pow_integral`)
Objects.   `L = log y`, `a > 0` real, `k` a natural number. The kernel
           `L^k·y^(−a−1)` on `(1, ∞)`: it is `u^k e^(−au)` after `y = e^u`, kept
           in the variable `y`, where blocks 2b and 2c live.
Sizes.     an identity: `∫₁^∞ L^k y^(−a−1) dy = k!/a^(k+1)`. For integrability
           and the limit at infinity, `L^n ≤ y^(a/2)/ε^n` with
           `ε = a/(2(n+1))`, from `log y ≤ y^ε/ε`; the constant `ε^(−n)` grows
           with `n` and is used for integrability and a limit only, never in
           a bound that is kept. Lost factor: none.
Regime.    A1 `0 < a`. Y1 `1 ≤ y` where a pointwise bound is stated.
Defs.      none.
Theorems.  `theorem log_pow_le {a : ℝ} (ha : 0 < a) (n : ℕ) {y : ℝ} (hy : 1 ≤ y) :
               Real.log y ^ n ≤ y ^ (a / 2) / (a / (2 * (n + 1))) ^ n`
           `theorem log_pow_integrable {a : ℝ} (ha : 0 < a) (n : ℕ) :
               IntegrableOn (fun y : ℝ => Real.log y ^ n * y ^ (-a - 1)) (Ioi 1)`
           `theorem log_pow_integral {a : ℝ} (ha : 0 < a) (k : ℕ) :
               ∫ y in Ioi (1 : ℝ), Real.log y ^ k * y ^ (-a - 1) = k.factorial / a ^ (k + 1)`
             (induction on `k`: `F(y) = −L^(k+1) y^(−a)/a` has derivative
             `L^(k+1) y^(−a−1) − ((k+1)/a)·L^k y^(−a−1)`, vanishes at `1` and
             tends to `0`; A1.)
Composes.  Mathlib: `Real.log_le_rpow_div` (a `lemma`), `integrableOn_Ioi_rpow_of_lt`,
           `integral_Ioi_rpow_of_lt`, `integral_Ioi_of_hasDerivAt_of_tendsto'`,
           `tendsto_rpow_neg_atTop`, `Real.hasDerivAt_rpow_const`, `Real.hasDerivAt_log`.
Module.    `Stage3/LandauKernel.lean`, namespace `LandauKernel`, `import Mathlib`.
           Pinned: all three.
Open.      none.

### 4b The kernel off the window — PROVED (unit 0391: `LandauTail.lower_tail_le`, `upper_tail_le`)
Objects.   the kernel `L^k·y^(−a−1)` of block 4a, `L = log y`, total
           `k!/a^(k+1)`. Two tails: `(1, Y]` and `(Z, ∞)`.
Sizes.     a shift of the exponent, one free parameter `b` on each side.
           Below `Y`: `y^(−a−1) = y^b·y^(−(a+b)−1) ≤ Y^b·y^(−(a+b)−1)`, so the
           tail is at most `Y^b·k!/(a+b)^(k+1)`. Above `Z`:
           `y^(−a−1) = y^(−b)·y^(−(a−b)−1) ≤ Z^(−b)·y^(−(a−b)−1)`, `0 < b < a`, so
           the tail is at most `Z^(−b)·k!/(a−b)^(k+1)`. Against the total the
           ratios are `e^(bU)·(a/(a+b))^(k+1)` and `e^(−bV)·(a/(a−b))^(k+1)`,
           `U = log Y`, `V = log Z`.
           THE LOST-FACTOR CHECK, by hand, with `k + 1 = a(1+δ/2)U` and
           `V = (1+δ)U`, `δ ≤ 1`. Below, `b = a·δ/2`: the exponent is
           `aU[t − (1+t)·log(1+t)]` at `t = δ/2`, and
           `(1+t)·log(1+t) ≥ t + t²/3` on `[0, 1]`, so the ratio is at most
           `e^(−aUδ²/12)`. Above, `b = a·δ/12`: with `−log(1−t) ≤ t + 2t²` for
           `t ≤ 1/2` the exponent is at most `aU[−tδ/2 + 2t²(1+δ/2)] ≤ −aUδ²/48`.
           Both ratios decay like `e^(−cδ²k)`: nothing grows with `k`. The
           choice of `b` belongs to block 7, where `U` and `k` are tied; this
           block proves the two bounds with `b` free.
Regime.    A1 `0 < a`. B1 `0 < b`. B2 `b < a` (above only). Y1 `1 ≤ Y`, Z1 `1 ≤ Z`.
Defs.      none.
Theorems.  `theorem lower_tail_le {a b : ℝ} (ha : 0 < a) (hb : 0 < b) (k : ℕ) {Y : ℝ} (hY : 1 ≤ Y) :
               ∫ y in Ioc (1 : ℝ) Y, Real.log y ^ k * y ^ (-a - 1)
                 ≤ Y ^ b * (k.factorial / (a + b) ^ (k + 1))`
           `theorem upper_tail_le {a b : ℝ} (hb : 0 < b) (hba : b < a) (k : ℕ) {Z : ℝ} (hZ : 1 ≤ Z) :
               ∫ y in Ioi Z, Real.log y ^ k * y ^ (-a - 1)
                 ≤ Z ^ (-b) * (k.factorial / (a - b) ^ (k + 1))`
Composes.  `LandauKernel.log_pow_integral`, `log_pow_integrable`. Mathlib:
           `setIntegral_mono_on`, `setIntegral_mono_set`, `Real.rpow_le_rpow`.
Module.    `Stage3/LandauTail.lean`, namespace `LandauTail`,
           `import Stage3.LandauKernel`. Pinned: both.
Open.      none.

### 5 A crude bound on `G` — PROVED (unit 0387: `LandauCrude.rampSum_nonneg`, `rampSum_le`, `abs_G_le`)
Objects.   `rampSum`, `G` (`LandauWindow`). `L = log y`.
Sizes.     `0 ≤ rampSum y ≤ y·L·(1+L)`: each `Λ(n) ≤ log n ≤ L`, each ramp
           `≤ y/n`, and `Σ_{n ≤ y} 1/n ≤ 1 + L`. Then
           `|G| ≤ y·L·(1+L) + y·L + 2y ≤ 2y(1+L)²`, since
           `L² + 2L + 2 ≤ 2L² + 4L + 2`. THE LOST-FACTOR CHECK: the first
           writing of this block asked for `A·y·(1+L)`, from Chebyshev; this
           bound carries one more factor `(1+L)`. In the tail of block 4 that
           is one more power of `u`, a factor polynomial in `k`, against a gap
           between the tail's rate and the zeros' rate that is strict and
           exponential in `k` (section 0). Named here; it does not move the
           size comparison. The sharper bound costs a summation by parts or
           `log N!` and buys nothing the plan uses.
Regime.    Y1 `1 ≤ y`.
Defs.      none.
Theorems.  `theorem rampSum_nonneg (y : ℝ) : 0 ≤ LandauWindow.rampSum y`
           `theorem rampSum_le {y : ℝ} (hy : 1 ≤ y) :
               LandauWindow.rampSum y ≤ y * Real.log y * (1 + Real.log y)`
           `theorem abs_G_le {y : ℝ} (hy : 1 ≤ y) :
               |LandauWindow.G y| ≤ 2 * y * (1 + Real.log y) ^ 2`
             (`γ ≤ 1`: `Real.eulerMascheroniConstant_lt_two_thirds`; `0 < γ`:
             `Real.one_half_lt_eulerMascheroniConstant`; Y1.)
Composes.  Mathlib: `ArithmeticFunction.vonMangoldt_le_log`,
           `ArithmeticFunction.vonMangoldt_nonneg`, `harmonic_le_one_add_log`,
           `harmonic_eq_sum_Icc` (a `lemma`), `Nat.floor_le`.
Module.    `Stage3/LandauCrude.lean`, namespace `LandauCrude`,
           `import Stage3.LandauWindow`. Pinned: all three.
Open.      none.

### 5b The bound of Chebyshev's order — PROVED (unit 0388: `LandauChebyshev.rampSum_le_log`, `G_le`,
`neg_le_G`, `abs_G_le_log`)
Asked for by Julian on 2026-11-22 after block 5: the bound without the extra
factor `(1 + log y)`.
Objects.   `rampSum`, `G` (`LandauWindow`). `E₁Λ x = Σ_{0 < d ≤ x} Λ(d)/d − log x`
           (upstream, `Mertens.E₁Λ`, an `abbrev`), at most `log 4 + 4` for
           `x ≥ 1` (`Mertens.E₁Λ.le`).
Sizes.     each ramp is at most `y/n`, so `rampSum y ≤ y·Σ_{n ≤ y} Λ(n)/n
           = y·(log y + E₁Λ y) ≤ y·(log y + log 4 + 4)`. Then
           `G y ≤ y(log 4 + 4) + (1+γ)y ≤ 8y`, with `log 4 < 2` and `γ < 1`:
           the `y·log y` cancels and the upper bound has no logarithm. From
           below `G y ≥ −y·log y`, the ramp sum being nonnegative. So
           `|G y| ≤ 8y(1 + log y)`. Lost factor: none; this is the order the
           first sketch of block 5 asked for.
Regime.    Y1 `1 ≤ y`.
Defs.      none.
Theorems.  `theorem rampSum_le_log {y : ℝ} (hy : 1 ≤ y) :
               LandauWindow.rampSum y ≤ y * (Real.log y + (Real.log 4 + 4))`
           `theorem G_le {y : ℝ} (hy : 1 ≤ y) : LandauWindow.G y ≤ 8 * y`
           `theorem neg_le_G {y : ℝ} (hy : 1 ≤ y) : -(y * Real.log y) ≤ LandauWindow.G y`
           `theorem abs_G_le_log {y : ℝ} (hy : 1 ≤ y) :
               |LandauWindow.G y| ≤ 8 * y * (1 + Real.log y)`
Composes.  upstream `Mertens.E₁Λ.le` (`IEANTN/Mertens.lean`, not imported by
           Stage 3 before this block); `LandauCrude.rampSum_nonneg`; Mathlib
           `Real.log_two_lt_d9`, `Real.eulerMascheroniConstant_lt_two_thirds`.
Module.    `Stage3/LandauChebyshev.lean`, namespace `LandauChebyshev`,
           `import Stage3.LandauCrude`, `import PrimeNumberTheoremAnd.IEANTN.Mertens`.
           Pinned: `rampSum_le_log`, `G_le`, `abs_G_le_log`.
Open.      none.

### 6 A trigonometric polynomial with no constant term is positive somewhere in every long block — SKETCH
Elementary and self-contained: mean at least zero, mean square positive,
bounded. With mean `≥ 0`, mean square `≥ m² > 0` and `|T| ≤ B` over a block,
the positive part has mean at least `m²/(2B)`, so some `k` in the block has
`T(k) ≥ m²/(2B)`. Means over a block are geometric sums (section 0b).

THE CONJUGATE PAIRS, found 2026-11-22. The zeros nearest `σ₀` come as `ρ` and
`ρ̄`, with equal order, and their terms are complex conjugates: the
frequencies are `+φ` and `−φ`. In the square of `T` the cross term of such a
pair has frequency `φ − φ = 0` and does not average out. So the lemma is
stated on the combined form: one real term `Re(a_j e^(ikφ_j))` per pair, the
`φ_j` distinct in `(0, π]`, plus the constant term `≥ 0` from real poles.
A frequency `φ_j = π` gives `a_j(−1)^k`, whose square has mean `a_j²` and not
half of it; the bound below on the mean square holds either way.

### 7 The assembly — SKETCH
`StmtLandauWindow` from slices 2 to 6.
