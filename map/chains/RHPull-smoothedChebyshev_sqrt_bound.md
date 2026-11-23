# What `RHPull.smoothedChebyshev_sqrt_bound` rests on

[`RHPull.smoothedChebyshev_sqrt_bound`](../lean_stage3/LineBound.md#RHPull-smoothedChebyshev_sqrt_bound) in `lean_stage3/Stage3/LineBound.lean`, line 1635.

**Why.** THE CAPSTONE — the smoothed Chebyshev error in `√X log²X` form. Every contour piece bounded at the RH abscissa, with the vertical segment carrying the `√X` through `X^σ₁ = e·√X` and the horizontals killed by the Mellin factor's `T⁻²` once `T ≥ √X`. No explicit formula, no zero sum.

**Proves**

```lean
‖SmoothedChebyshev ν ε X - mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 * X‖ ≤ B₁ + B₉ + (22200 * Real.exp 1 * C / ε) * Real.sqrt X * (Real.log X) ^ 2 + (1 / (2 * Real.pi)) * (1 / 2) * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M₈ * X ^ (1 + 1 / Real.log X)) + (1 / (2 * Real.pi)) * (1 / 2) * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M₂ * X ^ (1 + 1 / Real.log X))
```

**Needs** (its hypotheses)

  - `` hRH : RiemannHypothesis ``
  - `` ε_pos : 0 < ε ``
  - `` ε_lt_one : ε < 1 ``
  - `` X_gt : 3 < X ``
  - `` hX : 0 < X ``
  - `` hLX : 4 ≤ Real.log X ``
  - `` hT2 : 2 ≤ T ``
  - `` hTX : T ≤ X ``
  - `` hC : 0 < C ``
  - `` suppν : Function.support ν ⊆ Set.Icc (1 / 2) 2 ``
  - `` νnonneg : ∀ x > 0, 0 ≤ ν x ``
  - `` mass_one : ∫ x in Set.Ioi 0, ν x / x = 1 ``
  - `` diffν : ContDiff ℝ 1 ν ``
  - `` hB1 : ‖I₁ ν ε X T‖ ≤ B₁ ``
  - `` hB9 : ‖I₉ ν ε X T‖ ≤ B₉ ``
  - `` hMel37 : ∀ t : ℝ, ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σRH X : ℂ) + I * (t : ℂ))‖ ≤ C * (ε * ((σRH X) ^ 2 + t ^ 2))⁻¹ ``
  - `` hMel8 : ∀ σ : ℝ, σRH X ≤ σ → σ ≤ 1 + 1 / Real.log X → ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) + I * (T : ℂ))‖ ≤ M₈ ``
  - `` hMel2 : ∀ σ : ℝ, σRH X ≤ σ → σ ≤ 1 + 1 / Real.log X → ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) - (T : ℂ) * I)‖ ≤ M₂ ``

Behind it: 43 theorems and 3 definitions in 2 files. Every one is listed below; Lean recorded each step.

## The files it passes through

```mermaid
flowchart LR
  f0["<b>JensenCount</b><br/>12 used"]:::thm
  f1["<b>LineBound</b><br/>smoothedChebyshev_sqrt_bound"]:::end_
  f0 --> f1
  classDef cnt fill:#dff5ec,stroke:#17694a,color:#111
  classDef shp fill:#f1ecfb,stroke:#5b3fa0,color:#111
  classDef rh fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111
```

An arrow A → B reads "B uses something proved or defined in A"; indirect arrows are left out. Green: the theorem itself. Yellow: a file in the other tree. The number is how many of that file's declarations are on the way.

## Every declaration on the way

Files in dependency order. ★ marks what the theorem's own proof uses directly.

### [`JensenCount`](../lean_stage3/JensenCount.md) — 12

- [`Stage3.zeta_centre_lower`](../lean_stage3/JensenCount.md#Stage3-zeta_centre_lower) — `` (1 : ℝ) / 3 ≤ ‖ζ (2 + Complex.I * T)‖ ``
- [`Stage3.zeta_disk_upper`](../lean_stage3/JensenCount.md#Stage3-zeta_disk_upper) — `` ‖ζ w‖ ≤ 28 * T ``
- [`Stage3.zeta_centre_ne_zero`](../lean_stage3/JensenCount.md#Stage3-zeta_centre_ne_zero) — `` ζ (2 + Complex.I * (T : ℂ)) ≠ 0 ``
- [`Stage3.pole_away`](../lean_stage3/JensenCount.md#Stage3-pole_away) — `` 2 * z + (2 + Complex.I * (T : ℂ)) ≠ 1 ``
- [`Stage3.pole_away_centre`](../lean_stage3/JensenCount.md#Stage3-pole_away_centre) — `` v ≠ 1 ``
- [`Stage3.zetaWindowTwo_finite`](../lean_stage3/JensenCount.md#Stage3-zetaWindowTwo_finite) — `` {ρ : ℂ | ζ ρ = 0 ∧ ‖ρ - (2 + Complex.I * (T : ℂ))‖ ≤ 2}.Finite ``
- [`Stage3.jensenF`](../lean_stage3/JensenCount.md#Stage3-jensenF) — *def*
- [`Stage3.zeta_comp_analytic`](../lean_stage3/JensenCount.md#Stage3-zeta_comp_analytic) — `` AnalyticAt ℂ (fun z : ℂ => ζ (2 * z + (2 + Complex.I * (T : ℂ)))) w ``
- [`Stage3.jensenF_analytic`](../lean_stage3/JensenCount.md#Stage3-jensenF_analytic) — `` AnalyticOnNhd ℂ (jensenF T) (Metric.closedBall (0 : ℂ) 1) ``
- [`Stage3.jensenF_zero_eq_one`](../lean_stage3/JensenCount.md#Stage3-jensenF_zero_eq_one) — `` jensenF T 0 = 1 ``
- [`Stage3.jensenF_zeros_finite`](../lean_stage3/JensenCount.md#Stage3-jensenF_zeros_finite) — `` (SetOfZeros 1 (jensenF T)).Finite ``
- [`Stage3.jensenF_bound`](../lean_stage3/JensenCount.md#Stage3-jensenF_bound) — `` ‖jensenF T z‖ ≤ 84 * T ``

### [`LineBound`](../lean_stage3/LineBound.md) — 34

- [`Slice3.zeta_ne_zero_of_RH`](../lean_stage3/LineBound.md#Slice3-zeta_ne_zero_of_RH) — `` ζ s ≠ 0 ``
- [`Slice3.finalBoundConst_le`](../lean_stage3/LineBound.md#Slice3-finalBoundConst_le) — `` 16 * ((181:ℝ)/200) ^ 2 / ((181/200) - (3/4)) ^ 3 + 1 / (((15/16:ℝ) ^ 2 / (29/32) - 29/32) * Real.log ((15/16)/(29/32))) ≤ 3991 ``
- [`Slice3.logDerivZeta_crude`](../lean_stage3/LineBound.md#Slice3-logDerivZeta_crude) — `` ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖ ≤ 1996 * Real.log (84 * t) + (29 * Real.log t + 129) / (σ₁ - 1/2) ``
- [`Slice3.logDerivZeta_sq_at_X`](../lean_stage3/LineBound.md#Slice3-logDerivZeta_sq_at_X) — `` ‖deriv ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ)) / ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))‖ ≤ 11100 * (Real.log X) ^ 2 ``
- [`Slice4.zeta_ne_zero_of_RH`](../lean_stage3/LineBound.md#Slice4-zeta_ne_zero_of_RH) — `` ζ s ≠ 0 ``
- [`Slice4.zetaE`](../lean_stage3/LineBound.md#Slice4-zetaE) — *def*
- [`Slice4.zetaE_eq`](../lean_stage3/LineBound.md#Slice4-zetaE_eq) — `` zetaE s = (s - 1) * ζ s ``
- [`Slice4.zetaE_one`](../lean_stage3/LineBound.md#Slice4-zetaE_one) — `` zetaE 1 = 1 ``
- [`Slice4.zetaE_differentiableAt_of_ne`](../lean_stage3/LineBound.md#Slice4-zetaE_differentiableAt_of_ne) — `` DifferentiableAt ℂ zetaE s ``
- [`Slice4.zetaE_differentiable`](../lean_stage3/LineBound.md#Slice4-zetaE_differentiable) — `` Differentiable ℂ zetaE ``
- [`Slice4.logDeriv_zetaE`](../lean_stage3/LineBound.md#Slice4-logDeriv_zetaE) — `` deriv zetaE s / zetaE s = 1 / (s - 1) + deriv ζ s / ζ s ``
- [`Slice4.zetaE_disk_upper`](../lean_stage3/LineBound.md#Slice4-zetaE_disk_upper) — `` ‖zetaE w‖ ≤ 430 ``
- [`Slice4.log_1300_le`](../lean_stage3/LineBound.md#Slice4-log_1300_le) — `` Real.log 1300 ≤ 7.28 ``
- [`Slice4.finalBoundConst_le`](../lean_stage3/LineBound.md#Slice4-finalBoundConst_le) — `` 16 * ((181:ℝ)/200) ^ 2 / ((181/200) - (3/4)) ^ 3 + 1 / (((15/16:ℝ) ^ 2 / (29/32) - 29/32) * Real.log ((15/16)/(29/32))) ≤ 3991 ``
- [`Slice4.logDerivZeta_compact`](../lean_stage3/LineBound.md#Slice4-logDerivZeta_compact) — `` ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖ ≤ 14535 + 212 / (σ₁ - 1/2) ``
- [`Slice4b.logDerivZeta_norm_neg`](../lean_stage3/LineBound.md#Slice4b-logDerivZeta_norm_neg) — `` ‖deriv ζ ((σ : ℂ) + I * ((-t : ℝ) : ℂ)) / ζ ((σ : ℂ) + I * ((-t : ℝ) : ℂ))‖ = ‖deriv ζ ((σ : ℂ) + I * (t : ℂ)) / ζ ((σ : ℂ) + I * (t : ℂ))‖ ``
- [`Slice4b.logDerivZeta_line`](../lean_stage3/LineBound.md#Slice4b-logDerivZeta_line) — `` ‖deriv ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ)) / ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))‖ ≤ 11100 * (Real.log X) ^ 2 ``
- [`RHPull.zeta_ne_zero_of_RH`](../lean_stage3/LineBound.md#RHPull-zeta_ne_zero_of_RH) — `` ζ s ≠ 0 ``
- [`RHPull.holo_logDerivZeta_of_RH`](../lean_stage3/LineBound.md#RHPull-holo_logDerivZeta_of_RH) — `` HolomorphicOn (deriv riemannZeta / riemannZeta) (Set.Icc σ₁ 2 ×ℂ Set.Icc (-T) T \ {1}) ``
- ★ [`RHPull.pull_at_RH_abscissa`](../lean_stage3/LineBound.md#RHPull-pull_at_RH_abscissa) — `` SmoothedChebyshev SmoothingF ε X = I₁ SmoothingF ε X T - I₂ SmoothingF ε T X (1 / 2 + 1 / Real.log X) + I₃₇ SmoothingF ε T X (1 / 2 + 1 / Real.log X) + I₈ Smoot… ``
- ★ [`RHPull.σRH`](../lean_stage3/LineBound.md#RHPull--RH) — *def*
- [`RHPull.σRH_re`](../lean_stage3/LineBound.md#RHPull--RH_re) — `` ((σRH X : ℂ) + I * (t : ℂ)).re = σRH X ``
- [`RHPull.integrand_norm_le`](../lean_stage3/LineBound.md#RHPull-integrand_norm_le) — `` ‖SmoothedChebyshevIntegrand ν ε X ((σRH X : ℂ) + I * (t : ℂ))‖ ≤ 11100 * (Real.log X) ^ 2 * M * X ^ (σRH X) ``
- [`RHPull.integrand_norm_le_horiz`](../lean_stage3/LineBound.md#RHPull-integrand_norm_le_horiz) — `` ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) + I * (t : ℂ))‖ ≤ (1996 * Real.log (84 * t) + (29 * Real.log t + 129) * Real.log X) * M * X ^ σ ``
- [`RHPull.horiz_length`](../lean_stage3/LineBound.md#RHPull-horiz_length) — `` (1 + 1 / Real.log X) - σRH X = 1 / 2 ``
- ★ [`RHPull.I8_norm_le`](../lean_stage3/LineBound.md#RHPull-I8_norm_le) — `` ‖I₈ ν ε T X (σRH X)‖ ≤ (1 / (2 * Real.pi)) * (1 / 2) * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ (1 + 1 / Real.log X)) ``
- [`RHPull.integrand_norm_le_horiz_neg`](../lean_stage3/LineBound.md#RHPull-integrand_norm_le_horiz_neg) — `` ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) - (T : ℂ) * I)‖ ≤ (1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ σ ``
- ★ [`RHPull.I2_norm_le`](../lean_stage3/LineBound.md#RHPull-I2_norm_le) — `` ‖I₂ ν ε T X (σRH X)‖ ≤ (1 / (2 * Real.pi)) * (1 / 2) * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ (1 + 1 / Real.log X)) ``
- [`RHPull.half_lt_σRH`](../lean_stage3/LineBound.md#RHPull-half_lt_-RH) — `` (1:ℝ)/2 < σRH X ``
- [`RHPull.kernel_le`](../lean_stage3/LineBound.md#RHPull-kernel_le) — `` ((σRH X) ^ 2 + t ^ 2)⁻¹ ≤ 4 * (1 + t ^ 2)⁻¹ ``
- [`RHPull.integral_kernel_le`](../lean_stage3/LineBound.md#RHPull-integral_kernel_le) — `` ∫ t in (-T)..T, ((1:ℝ) + t ^ 2)⁻¹ ≤ Real.pi ``
- [`RHPull.I37_norm_le_decay`](../lean_stage3/LineBound.md#RHPull-I37_norm_le_decay) — `` ‖I₃₇ ν ε T X (σRH X)‖ ≤ (1 / (2 * Real.pi)) * Real.pi * (11100 * (Real.log X) ^ 2 * (4 * C / ε) * X ^ (σRH X)) ``
- [`RHPull.rpow_σRH`](../lean_stage3/LineBound.md#RHPull-rpow_-RH) — `` X ^ (σRH X) = Real.exp 1 * Real.sqrt X ``
- ★ [`RHPull.I37_sqrt_form`](../lean_stage3/LineBound.md#RHPull-I37_sqrt_form) — `` ‖I₃₇ ν ε T X (σRH X)‖ ≤ (22200 * Real.exp 1 * C / ε) * Real.sqrt X * (Real.log X) ^ 2 ``

