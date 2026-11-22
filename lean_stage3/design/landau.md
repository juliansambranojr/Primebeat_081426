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

### 3 The poles of `Φ` and its Taylor coefficients — split 2026-11-22 into 3a and 3b

### 3a `Phi` near a zero and near `1` — PROVED (unit 0393: `LandauPoleLocal.differentiableAt_Phi`,
`Phi_principal_part`, `Phi_regular_at_one`)
Objects.   `Phi` (`LandauMellinG.Phi`). At a zero `ρ ≠ 0, 1` of order `m`:
           `ζ(s) = (s−ρ)^m·g(s)`, `g` analytic, `g(ρ) ≠ 0`, so
           `−ζ'/ζ = −m/(s−ρ) − g'/g`. And
           `1/(s(s−1)) − 1/(ρ(ρ−1)) = −(s−ρ)(s+ρ−1)/(s(s−1)ρ(ρ−1))`. Hence
           `Phi s = A/(s−ρ) + h(s)`, `A = m/(ρ(1−ρ))`,
           `h(s) = −(g'/g)/(s(s−1)) + m(s+ρ−1)/(s(s−1)ρ(ρ−1)) − 1/(s−1)² + (1+γ)/(s−1)`.
           At `1`: `ζ(s) = ζ₁(s)/(s−1)` with `ζ₁` entire (`riemannZeta₁`),
           `ζ₁(1) = 1`, `ζ₁'(1) = γ`; `−ζ'/ζ = 1/(s−1) − ζ₁'/ζ₁`, and
           `Phi s = N(s)/(s(s−1))` with `N(s) = −1 − ζ₁'(s)/ζ₁(s) + (1+γ)s`,
           `N(1) = 0`. So `Phi s = dslope N 1 s / s` off `1`.
Sizes.     identities. Lost factor: none.
Regime.    P0 `ρ ≠ 0`. P1 `ρ ≠ 1`. PZ `ζ(ρ) = 0`.
Defs.      none.
Theorems.  `theorem differentiableAt_Phi {s : ℂ} (h0 : s ≠ 0) (h1 : s ≠ 1)
               (hz : riemannZeta s ≠ 0) : DifferentiableAt ℂ LandauMellinG.Phi s`
           `theorem Phi_principal_part {ρ : ℂ} (h0 : ρ ≠ 0) (h1 : ρ ≠ 1) (hz : riemannZeta ρ = 0) :
               ∃ h : ℂ → ℂ, AnalyticAt ℂ h ρ ∧ ∀ᶠ s in 𝓝[≠] ρ, LandauMellinG.Phi s
                 = h s + (analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ)) / (s - ρ)`
           `theorem Phi_regular_at_one :
               ∃ h : ℂ → ℂ, AnalyticAt ℂ h 1 ∧ ∀ᶠ s in 𝓝[≠] 1, LandauMellinG.Phi s = h s`
Composes.  Stage 3 `ContourShift.zeta_analyticAt`, `zeta_order_ne_top`,
           `one_le_zeta_order`. Mathlib: `AnalyticAt.analyticOrderAt_eq_natCast`
           (a `lemma`), `Nat.cast_analyticOrderNatAt` (a `lemma`),
           `riemannZeta_eq_inv_sub_mul` (a `lemma`),
           `deriv_riemannZeta_eq_neg_inv_sub_sq_mul_add` (a `lemma`),
           `deriv_riemannZeta₁_one`, `riemannZeta₁_one`,
           `riemannZeta₁_ne_zero_of_near_one` (`lemma`s),
           `Complex.differentiableOn_dslope`, `DifferentiableOn.analyticAt`.
Module.    `Stage3/LandauPoleLocal.lean`, namespace `LandauPoleLocal`. Pinned: all three.
Open.      block 3b.

### 3b The poles subtracted, and the Taylor coefficients — split 2026-11-22 into 3b1 and 3b2

### 3b1 Simple poles subtracted on an open set; the Taylor coefficients — PROVED (unit 0394:
`LandauPoleSub.iteratedDeriv_inv_sub`, `exists_differentiableOn_sub_poles`, `taylor_coeff_sub_poles`)
Nothing about `ζ`: a function `f`, an open set `U`, a finite set `P`, numbers `A p`.
Objects.   `g = f − Σ_{q ∈ P} A q/(s − q)`, glued at the points of `P` (the
           construction of Stage 3 `ContourShift.residue_rectangle_of_local`,
           there on a rectangle). The `k`-th derivative of `(s − q)^(−1)` at `c`
           is `(−1)^k·k!·(c − q)^(−1−k)`.
Sizes.     `iteratedDeriv k f c − Σ_q A q·(−1)^k·k!·(c − q)^(−1−k)` is the `k`-th
           derivative of `g` at `c`, at most `k!·C/R^k` with `C` a bound for
           `g` on the circle of radius `R` (Cauchy). `C` does not depend on
           `k`. Lost factor: none.
Regime.    `f` differentiable at the points of `U` off `P` (the gluing needs no
           openness of `U`: the first writing asked for it, the build showed it
           unused; the coefficients do need `U` open); at each
           `p ∈ P` a local form `f = h + A p/(s − p)`, `h` analytic at `p`;
           for the coefficients, `closedBall c R ⊆ U`, `0 < R`, `c ∉ P`.
Defs.      none.
Theorems.  `theorem iteratedDeriv_inv_sub (k : ℕ) (q c : ℂ) :
               iteratedDeriv k (fun s : ℂ => (s - q)⁻¹) c
                 = (-1) ^ k * (k.factorial : ℂ) * (c - q) ^ (-1 - (k : ℤ))`
           `theorem exists_differentiableOn_sub_poles {U : Set ℂ} {P : Finset ℂ}
               {f A : ℂ → ℂ} (hf : ∀ s ∈ U, s ∉ P → DifferentiableAt ℂ f s)
               (hloc : ∀ p ∈ P, ∃ h : ℂ → ℂ, AnalyticAt ℂ h p ∧
                 ∀ᶠ s in 𝓝[≠] p, f s = h s + A p / (s - p)) :
               ∃ g : ℂ → ℂ, DifferentiableOn ℂ g U ∧
                 ∀ s, s ∉ P → g s = f s - ∑ q ∈ P, A q / (s - q)`
           `theorem taylor_coeff_sub_poles {c : ℂ} {R : ℝ} (hR : 0 < R) {U : Set ℂ} (hU : IsOpen U)
               (hball : Metric.closedBall c R ⊆ U) {P : Finset ℂ} {f A g : ℂ → ℂ} (hcP : c ∉ P)
               (hg : DifferentiableOn ℂ g U)
               (hgf : ∀ s, s ∉ P → g s = f s - ∑ q ∈ P, A q / (s - q)) :
               ∃ C : ℝ, ∀ k : ℕ, ‖iteratedDeriv k f c
                 - ∑ q ∈ P, A q * ((-1) ^ k * (k.factorial : ℂ) * (c - q) ^ (-1 - (k : ℤ)))‖
                   ≤ k.factorial * C / R ^ k`
Composes.  Mathlib: `iter_deriv_inv`, `iteratedDeriv_comp_sub_const` (a `lemma`),
           (the Cauchy estimate's full name is
           `Complex.norm_iteratedDeriv_le_of_forall_mem_sphere_norm_le`)
           `iteratedDeriv_eq_iterate`, `iteratedDeriv_add` (a `lemma`),
           `iteratedDeriv_fun_sum` (a `lemma`), `iteratedDeriv_const_mul_field`,
           `Filter.EventuallyEq.iteratedDeriv_eq` (a `lemma`),
           `norm_iteratedDeriv_le_of_forall_mem_sphere_norm_le`,
           `DifferentiableOn.diffContOnCl_ball`.
Module.    `Stage3/LandauPoleSub.lean`, namespace `LandauPoleSub`, `import Mathlib`.
           Pinned: all three.
Open.      block 3b2.

### 3b2 `Phi` on a disc — PROVED (unit 0395: `LandauPoleDisc.Phi_taylor_on_disc`)
Objects.   centre `c`, radii `R < R₂`, `closedBall c R₂` inside `Re s > 0`.
           `P`: the zeros of `ζ` in the open disc of radius `R₂`, other than
           the point `1` (where Mathlib's `riemannZeta` takes a value that is
           not asked to be nonzero here). Residue `m_ρ/(ρ(1−ρ))`,
           `m_ρ = analyticOrderNatAt riemannZeta ρ`.
Sizes.     `‖iteratedDeriv k Phi c − Σ_{ρ ∈ P} m_ρ/(ρ(1−ρ))·(−1)^k·k!·(c − ρ)^(−1−k)‖
           ≤ k!·C/R^k`, `C` independent of `k`: block 3b1 applied to `Phi` with
           poles `P ∪ {1}`, the coefficient at `1` being `0` (block 3a). Every
           zero inside the disc of radius `R₂` is in the sum, so the remainder
           has the rate of `R`, for any `R < R₂`. Lost factor: none.
Regime.    D1 `0 < R`. D2 `R < R₂`. D3 `closedBall c R₂ ⊆ {s | 0 < s.re}`.
           C1 `c ≠ 1`. C2 `ζ(c) ≠ 0`.
Defs.      none.
Theorems.  `theorem Phi_taylor_on_disc {c : ℂ} {R R₂ : ℝ} (hR : 0 < R) (hRR : R < R₂)
               (hpos : closedBall c R₂ ⊆ {s : ℂ | 0 < s.re}) (hc1 : c ≠ 1)
               (hcz : riemannZeta c ≠ 0) :
               ∃ (P : Finset ℂ) (C : ℝ),
                 (∀ ρ, ρ ∈ P ↔ ρ ∈ ball c R₂ ∧ ρ ≠ 1 ∧ riemannZeta ρ = 0) ∧
                 ∀ k : ℕ, ‖iteratedDeriv k LandauMellinG.Phi c
                   - ∑ ρ ∈ P, (analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ))
                       * ((-1) ^ k * (k.factorial : ℂ) * (c - ρ) ^ (-1 - (k : ℤ)))‖
                   ≤ k.factorial * C / R ^ k`
Composes.  `LandauPoleLocal.differentiableAt_Phi`, `Phi_principal_part`,
           `Phi_regular_at_one`; `LandauPoleSub.exists_differentiableOn_sub_poles`,
           `taylor_coeff_sub_poles`; upstream `riemannZeta.zeroes_on_Compact_finite'`
           (a `lemma`).
Module.    `Stage3/LandauPoleDisc.lean`, namespace `LandauPoleDisc`. Pinned: the one.
Open.      none.

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

### 6 A real exponential sum is large somewhere in every long block — PROVED (unit 0392:
`LandauTrig.norm_geom_Ico_le`, `sum_block_ge`, `sum_sq_block_ge`, `abs_le_sum_norm`, `exists_large_in_block`)
Objects.   a finite index set `s`; `z_j` complex of modulus one, distinct;
           `c_j` complex, some `c_j ≠ 0`; `T(n) = Σ_j c_j z_j^n`, real for every
           `n`. `B = Σ|c_j|`, `S = Σ|c_j|²`. In block 7, `z_j = e^(−iφ_j)` with
           `σ₀ − ρ_j = r·e^(iφ_j)` and `c_j = m_j/(ρ_j(1−ρ_j))`.
Sizes.     over a block of `N` consecutive `n`:
           the sum of `T` is at least `−E₁`, `E₁ = Σ_{z_j ≠ 1} 2|c_j|/|z_j − 1|`,
           the frequency `1` contributing `N·Re c_j ≥ 0`;
           the sum of `T²`, computed as `|T|²`, is at least `N·S − E₂`,
           `E₂ = Σ_{j ≠ l} 2|c_j||c_l|/|z_j z̄_l − 1|`;
           `|T| ≤ B`. If `T < τ` on the whole block then
           `T² ≤ B·(2τ − T)` at each point, so `N·S − E₂ ≤ B·(2τN + E₁)`; with
           `τ = S/(4B)` this is `N·S/2 ≤ E₂ + B·E₁`. So every block longer than
           `2(E₂ + B·E₁)/S` holds an `n` with `T(n) ≥ S/(4B)`. THE LOST-FACTOR
           CHECK: `τ` and the block length depend on the `c_j` and `z_j` only,
           and on neither the block's position nor `n`. None.
           THE CONJUGATE PAIRS. The note of 2026-11-22 squared `T` as `T·T`,
           where the pair `z, z̄` gives a cross term of ratio `z·z̄ = 1`. As
           `|T|² = T·T̄` the cross term of `j ≠ l` has ratio `z_j·z̄_l`, which
           is `1` only when `z_j = z_l`. Distinct frequencies are all the
           lemma needs; pairs are not combined.
Regime.    Z1 `‖z_j‖ = 1`. Z2 `z` injective on `s`. C1 `0 ≤ Re c_j` when
           `z_j = 1`. C2 some `c_j ≠ 0`. T1 `T n = Σ_j c_j z_j^n` as complex
           numbers, `T` real-valued.
Defs.      none.
Theorems.  `theorem norm_geom_Ico_le {w : ℂ} (hw : ‖w‖ = 1) (hw1 : w ≠ 1) (a N : ℕ) :
               ‖∑ n ∈ Finset.Ico a (a + N), w ^ n‖ ≤ 2 / ‖w - 1‖`
           `theorem sum_block_ge` — Z1, C1, T1 — `−E₁ ≤ Σ_{n ∈ block} T n`
           `theorem sum_sq_block_ge` — Z1, Z2, T1 — `N·S − E₂ ≤ Σ_{n ∈ block} (T n)²`
           `theorem abs_le_sum_norm` — Z1, T1 — `|T n| ≤ B`
           `theorem exists_large_in_block {ι : Type*} [DecidableEq ι] (s : Finset ι) (c z : ι → ℂ)
               (hz : ∀ j ∈ s, ‖z j‖ = 1) (hinj : Set.InjOn z s)
               (hconst : ∀ j ∈ s, z j = 1 → 0 ≤ (c j).re) (hne : ∃ j ∈ s, c j ≠ 0)
               (T : ℕ → ℝ) (hT : ∀ n, (T n : ℂ) = ∑ j ∈ s, c j * z j ^ n) :
               ∃ τ : ℝ, 0 < τ ∧ ∃ N₀ : ℕ, ∀ a N : ℕ, N₀ ≤ N →
                 ∃ n ∈ Finset.Ico a (a + N), τ ≤ T n`
Composes.  Mathlib: `geom_sum_Ico` (a `lemma`), `Finset.sum_mul_sum` (a `lemma`),
           `Complex.mul_conj'` (a `lemma`), `Complex.conj_ofReal`, `Complex.re_sum`,
           `Finset.sum_comm`.
Module.    `Stage3/LandauTrig.lean`, namespace `LandauTrig`, `import Mathlib`.
           Pinned: `sum_block_ge`, `sum_sq_block_ge`, `exists_large_in_block`.
Open.      none.

### 7 The assembly — split 2026-11-22 into 7a, 7b, 7c, 7d
The design, written before any of it is built. Read this first after a
compaction.

Given `0 < θ < 1`, `δ > 0`, `C`, `WindowBound θ δ C`, and a zero `ρ₀ = β₀ + iγ₀`
with `β₀ > θ`. Reductions: `β₀ < 1` (Mathlib: no zero on `Re s ≥ 1`); `δ ≤ 1`
(a window `[Y, Y^(1+δ)]` with `Y ≥ 1` contains `[Y, Y²]`... so replace `δ` by
`min δ 1`); `C ≥ 0` (replace `C` by `max C 0`).

Parameters. `σ₀ > 1` real, `a = σ₀ − 1`, `r₀ = |σ₀ − ρ₀|`. Three conditions,
each true for `σ₀` large:
    S1  r₀ < σ₀ − θ       ⇐ σ₀ ≥ γ₀²/(β₀−θ) + 1
    S2  r₀ < σ₀           ⇐ S1
    S3  log(r₀/a) ≤ δ²/240 ⇐ a ≥ 240(1+|γ₀|)/δ², by r₀ ≤ a + 1 + |γ₀| and log x ≤ x − 1
`r` = the least `|σ₀ − ρ|` over zeros `ρ`; `a < r ≤ r₀` (zeros have `Re < 1`).
`P` = the zeros at distance exactly `r`; `R₂ > r` with no other zero in the
open disc of radius `R₂`, `R₂ < σ₀`; `R = (r + R₂)/2`. `λ = log(r/a) ∈ (0, δ²/240]`.

The two readings of `q_k := (−1)^k Φ^(k)(σ₀)/k!`, with `n = k + 1`:
    zeros (unit 0395):   q_k = r^(−n)·T(n) + e_k,  |e_k| ≤ C₁/R^k,
                         T(n) = Σ_{ρ ∈ P} A_ρ z_ρ^n,  z_ρ = r/(σ₀ − ρ),  A_ρ = m_ρ/(ρ(1−ρ))
    primes (unit 0390):  q_k = I_k/k!,  I_k = ∫₁^∞ G(y)(log y)^k y^(−σ₀−1) dy   (real)
`T(n)` is real: `P` is closed under conjugation (`σ₀` real, `riemannZeta_conj`,
`ContourShift.zeta_order_conj`), `A_ρ̄ = conj A_ρ`, `z_ρ̄ = conj z_ρ`. The `z_ρ` are
unimodular and distinct. `z_ρ = 1` only for a real zero `ρ = σ₀ − r ∈ (0, 1)`,
where `A_ρ > 0`. So block 6 gives `τ > 0`, `N₀`: every `N₀` consecutive `n` hold
one with `T(n) ≥ τ`.

The primes, from above, for a window at `Y ≥ 1`, `Z = Y^(1+δ)`, any `b > 0`,
`0 < b' < a` (the integrand's kernel is nonnegative, so only UPPER bounds on
`G` are used: `G ≤ C·y^θ` on the window, `G ≤ 8y` off it, unit 0388):
    I_k/k! ≤ C/(σ₀−θ)^n + 8·Y^b/(a+b)^n + 8·Z^(−b')/(a−b')^n
So at an `n` with `T(n) ≥ τ`, multiplying by `r^n`:
    τ ≤ C₁·R·(r/R)^n + C·(r/(σ₀−θ))^n + 8·Y^b·(r/(a+b))^n + 8·Z^(−b')·(r/(a−b'))^n
        t1                t2                 t3                    t4
`t1, t2 → 0` as `n → ∞` (`r < R`; `r ≤ r₀ < σ₀ − θ` by S1).
With `U = log Y`, `b = a·δ/3`, `b' = a·δ/12`, and `n` in
`[a(1+δ/3)·U, a(1+2δ/3)·U]`:
    t3 = 8·exp(bU + n(λ − log(1+δ/3)))        the coefficient of n is negative
       ≤ 8·exp(aU[δ/3 − (1+δ/3)(log(1+δ/3) − λ)]) ≤ 8·exp(aU[−δ²/27 + 4λ/3])
       by log(1+t) ≥ t − t²/2
    t4 = 8·exp(−b'(1+δ)U + n(λ − log(1−δ/12)))  the coefficient of n is positive
       ≤ 8·exp(aU[−(δ/12)(1+δ) + (1+2δ/3)(λ − log(1−δ/12))]) ≤ 8·exp(aU[−δ²/72 + 5λ/3])
       by −log(1−x) ≤ x/(1−x) ≤ x(1 + 6x/5) for x ≤ 1/6
With `λ ≤ δ²/240`: the brackets are at most `−δ²(1/27 − 1/180)` and `−δ²/144`.
Checked numerically on a grid of `δ` in `(0, 1]` at `λ = 0` and `λ = δ²/240`,
2026-11-22. So `t3, t4 → 0` as `U → ∞`. The range of `n` has length `aδU/3`,
which exceeds `N₀` for `U` large. Take `Y₀` so large that all four terms are
below `τ/4` on the range and the range holds `N₀` integers; `WindowBound` gives
a window at some `Y ≥ Y₀`; contradiction.
THE LOST-FACTOR CHECK: four exponential rates in `n` or `U`, each strictly
negative, and constants `C₁, C, 8, τ, N₀` that depend on `σ₀` and `ρ₀` only.
The rates of unit 0391's hand check (`δ²/12`, `δ²/48`) were for a different
choice of `b` and of the range; the ones above supersede them.

### 7a The primes' reading, from above — PROVED (unit 0396: `LandauPrimeSide.Ik_integrable`,
`iteratedDeriv_Phi_eq_Ik`, `Ik_le`)
`Ik σ k := ∫ y in Ioi 1, G y · (log y)^k · y^(−σ−1)`. For `1 < σ`, `θ < σ`, `0 ≤ C`,
`1 ≤ Y`, `0 ≤ δ`, `G y ≤ C·y^θ` on `Icc Y (Y^(1+δ))`, `0 < b`, `0 < b' < σ − 1`:
`Ik σ k ≤ C·k!/(σ−θ)^(k+1) + 8·Y^b·k!/(σ−1+b)^(k+1) + 8·(Y^(1+δ))^(−b')·k!/(σ−1−b')^(k+1)`.
And `iteratedDeriv k Phi σ = (−1)^k·Ik σ k`.

### 7b The zeros' reading, from below — PROVED (unit 0397: `LandauZeroSide.zero_side`)
Objects.   `c = σ₀`, `R₃ = (|σ₀ − ρ₀| + σ₀)/2 < σ₀`, so the closed disc of radius
           `R₃` lies in `Re s > 0`; `F` its zeros, finite, containing `ρ₀`;
           `ρ₁ ∈ F` nearest to `σ₀`, `r = |σ₀ − ρ₁|`; `R₂ ∈ (r, R₃]` with every
           zero in the open disc of radius `R₂` at distance at most `r`
           (finiteness), hence exactly `r`; `R = (r + R₂)/2`. `P` and `C₀` from
           unit 0395. `A ρ = m_ρ/(ρ(1−ρ))`, `z ρ = r/(σ₀ − ρ)`,
           `S k = Σ_{ρ ∈ P} (A ρ·z ρ)·(z ρ)^k`.
Sizes.     `(σ₀ − ρ)^(−1−k) = (z ρ)^(k+1)/r^(k+1)`, so unit 0395 reads
           `|Φ^(k)(σ₀) − (−1)^k·k!/r^(k+1)·S k| ≤ k!·C₀/R^k`, and with
           `Φ^(k)(σ₀) = (−1)^k·Ik` (unit 0396) and `S k` real:
           `Ik/k! ≥ S k/r^(k+1) − C₀/R^k`. Block 6 on `S`, with coefficients
           `A ρ·z ρ`: `S k ≥ τ` for some `k` in every `N₀` consecutive. Lost
           factor: none; `τ, N₀, C₀` depend on `σ₀` and the zeros only.
Regime.    Z0 `ζ(ρ₀) = 0`. H1 `1 < σ₀`. S2 `‖σ₀ − ρ₀‖ < σ₀` (which gives `0 < Re ρ₀`:
           the first writing listed that as a hypothesis, the build showed it unused).
Defs.      none.
Theorems.  `theorem zero_side {ρ₀ : ℂ} (hz : riemannZeta ρ₀ = 0)
               {σ₀ : ℝ} (hσ : 1 < σ₀) (hS2 : ‖(σ₀ : ℂ) - ρ₀‖ < σ₀) :
               ∃ r R τ C₁ : ℝ, ∃ N₀ : ℕ, σ₀ - 1 < r ∧ r ≤ ‖(σ₀ : ℂ) - ρ₀‖ ∧ r < R ∧
                 0 < τ ∧ 0 ≤ C₁ ∧ ∀ a N : ℕ, N₀ ≤ N → ∃ k ∈ Finset.Ico a (a + N),
                   τ / r ^ (k + 1) - C₁ / R ^ k ≤ LandauPrimeSide.Ik σ₀ k / k.factorial`
Composes.  `LandauPoleDisc.Phi_taylor_on_disc`, `LandauTrig.exists_large_in_block`,
           `LandauPrimeSide.iteratedDeriv_Phi_eq_Ik`; `ContourShift.zeta_order_conj`,
           `one_le_zeta_order`; Mathlib `riemannZeta_conj`,
           `riemannZeta_ne_zero_of_one_le_re` (a `lemma`),
           `riemannZeta_ne_zero_of_one_lt_re` (a `lemma`), `Finset.exists_min_image`,
           `Finset.sum_nbij'`; upstream `riemannZeta.zeroes_on_Compact_finite'`.
Module.    `Stage3/LandauZeroSide.lean`, namespace `LandauZeroSide`. Pinned: the one.
Open.      none.

### 7c The rates — SKETCH
The scalar inequalities above: S1 to S3 for `σ₀` large; the two brackets; the
four terms below `τ/4` for `U` large.

### 7d `StmtLandauWindow` — SKETCH
From 7a, 7b, 7c and `WindowBound`. With unit 0384's `rh_of_window`, the chain
"a window bound at every `θ > 1/2` implies `RiemannHypothesis`" then has no
leaf between its hypothesis and its conclusion.
