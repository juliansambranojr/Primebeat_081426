# What `LittlewoodSharp.littlewood_sharp` rests on

[`LittlewoodSharp.littlewood_sharp`](../lean_stage3/LittlewoodSharp.md#LittlewoodSharp-littlewood_sharp) in `lean_stage3/Stage3/LittlewoodSharp.lean`, line 46.

**Why.** Littlewood's bound on `∫ S`, sharper constants, unconditional.

**Proves**

```lean
Turing.StmtLittlewood ((3 / 2 + 113 / 4) / Real.pi) ((2 + (3 / 2) * Real.log 9 + 128) / Real.pi) 2
```

Behind it: 145 theorems and 25 definitions in 14 files. Every one is listed below; Lean recorded each step.

## The files it passes through

```mermaid
flowchart LR
  f0["<b>ArgCount</b><br/>2 used"]:::thm
  f1["<b>JensenCount</b><br/>12 used"]:::thm
  f2["<b>LevinsonEdge</b><br/>1 used"]:::thm
  f3["<b>Littlewood</b><br/>9 used"]:::thm
  f4["<b>LittlewoodSharpLog</b><br/>15 used"]:::thm
  f5["<b>LittlewoodSharpPoint</b><br/>9 used"]:::thm
  f6["<b>Stirling</b><br/>6 used"]:::thm
  f7["<b>ArgIdentity</b><br/>53 used"]:::thm
  f8["<b>TuringLWHoriz</b><br/>6 used"]:::thm
  f9["<b>TuringS</b><br/>15 used"]:::thm
  f10["<b>LittlewoodSharpHoriz</b><br/>9 used"]:::thm
  f11["<b>TuringLWSplitOsc</b><br/>26 used"]:::thm
  f12["<b>TuringLWSplit</b><br/>7 used"]:::thm
  f13["<b>LittlewoodSharp</b><br/>littlewood_sharp"]:::end_
  f1 --> f5
  f4 --> f5
  f6 --> f7
  f0 --> f9
  f2 --> f9
  f7 --> f9
  f5 --> f10
  f8 --> f10
  f9 --> f10
  f9 --> f11
  f3 --> f12
  f11 --> f12
  f10 --> f13
  f12 --> f13
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

### [`ArgCount`](../lean_stage3/ArgCount.md) — 2

- [`ArgCount.N_eq_sum`](../lean_stage3/ArgCount.md#ArgCount-N_eq_sum) — `` riemannZeta.N T = ∑ z ∈ (Kadiri.zeroes_rect_univ_positive_height_finite T).toFinset, (1 : ℝ) * (riemannZeta.order z : ℝ) ``
- [`ArgCount.N_mono`](../lean_stage3/ArgCount.md#ArgCount-N_mono) — `` riemannZeta.N T ≤ riemannZeta.N T' ``

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

### [`LevinsonEdge`](../lean_stage3/LevinsonEdge.md) — 1

- [`LevinsonEdge.zeta_norm_le`](../lean_stage3/LevinsonEdge.md#LevinsonEdge-zeta_norm_le) — `` ‖riemannZeta u‖ ≤ 2 + 4 * ‖u‖ ``

### [`Littlewood`](../lean_stage3/Littlewood.md) — 9

- [`Littlewood.mem_support_divisor`](../lean_stage3/Littlewood.md#Littlewood-mem_support_divisor) — `` p ∈ (MeromorphicOn.divisor f U).support ↔ p ∈ U ∧ f p = 0 ``
- [`Littlewood.locallyIntegrable_inv_norm_sub`](../lean_stage3/Littlewood.md#Littlewood-locallyIntegrable_inv_norm_sub) — `` LocallyIntegrable (fun s : ℂ => ‖s - x‖⁻¹) volume ``
- [`Littlewood.integrableAtFilter_logDeriv`](../lean_stage3/Littlewood.md#Littlewood-integrableAtFilter_logDeriv) — `` IntegrableAtFilter (logDeriv f) (𝓝[K] p) volume ``
- [`Littlewood.integrableOn_logDeriv`](../lean_stage3/Littlewood.md#Littlewood-integrableOn_logDeriv) — `` IntegrableOn (logDeriv f) (Rectangle z w) volume ``
- [`Littlewood.integrableOn_logDeriv_prod`](../lean_stage3/Littlewood.md#Littlewood-integrableOn_logDeriv_prod) — `` IntegrableOn (fun q : ℝ × ℝ => logDeriv f (↑q.1 + ↑q.2 * I)) ([[z.re, w.re]] ×ˢ [[z.im, w.im]]) volume ``
- [`Littlewood.hasDerivAt_log_norm`](../lean_stage3/Littlewood.md#Littlewood-hasDerivAt_log_norm) — `` HasDerivAt (fun y => Real.log ‖g y‖) (g' / g x).re x ``
- [`Littlewood.continuousAt_logDeriv`](../lean_stage3/Littlewood.md#Littlewood-continuousAt_logDeriv) — `` ContinuousAt (logDeriv f) s ``
- [`Littlewood.continuousOn_logDeriv_comp`](../lean_stage3/Littlewood.md#Littlewood-continuousOn_logDeriv_comp) — `` ContinuousOn (fun x => logDeriv f (γ x)) S ``
- [`Littlewood.horiz_mem`](../lean_stage3/Littlewood.md#Littlewood-horiz_mem) — `` (↑x + ↑t * I : ℂ) ∈ Rectangle z w ``

### [`LittlewoodSharpLog`](../lean_stage3/LittlewoodSharpLog.md) — 15

- [`LittlewoodSharp.mul_log_ge_tangent`](../lean_stage3/LittlewoodSharpLog.md#LittlewoodSharp-mul_log_ge_tangent) — `` x * Real.log c + x - c ≤ x * Real.log x ``
- [`LittlewoodSharp.sharp_of_nonneg`](../lean_stage3/LittlewoodSharpLog.md#LittlewoodSharp-sharp_of_nonneg) — `` (b - a) * Real.log ((b - a) / 2) ≤ b * Real.log b - a * Real.log a ``
- [`LittlewoodSharp.mul_log_sub_ge_sharp`](../lean_stage3/LittlewoodSharpLog.md#LittlewoodSharp-mul_log_sub_ge_sharp) — `` (b - a) * Real.log ((b - a) / 2) ≤ b * Real.log b - a * Real.log a ``
- [`LittlewoodSharp.intervalIntegrable_log_sub`](../lean_stage3/LittlewoodSharpLog.md#LittlewoodSharp-intervalIntegrable_log_sub) — `` IntervalIntegrable (fun x : ℝ => Real.log (x - β)) volume (1 / 2) 2 ``
- [`LittlewoodSharp.integral_log_sub_ge_sharp`](../lean_stage3/LittlewoodSharpLog.md#LittlewoodSharp-integral_log_sub_ge_sharp) — `` -((3 / 2) * (1 + Real.log (4 / 3))) ≤ ∫ x in (1 / 2 : ℝ)..2, Real.log (x - β) ``
- [`LittlewoodSharp.log43_le`](../lean_stage3/LittlewoodSharpLog.md#LittlewoodSharp-log43_le) — `` Real.log (4 / 3) ≤ 1 / 3 ``
- [`LittlewoodSharp.integral_log_sub_ge_two`](../lean_stage3/LittlewoodSharpLog.md#LittlewoodSharp-integral_log_sub_ge_two) — `` -2 ≤ ∫ x in (1 / 2 : ℝ)..2, Real.log (x - β) ``
- [`LittlewoodSharp.bcw`](../lean_stage3/LittlewoodSharpLog.md#LittlewoodSharp-bcw) — *def*
- [`LittlewoodSharp.integral_bcw`](../lean_stage3/LittlewoodSharpLog.md#LittlewoodSharp-integral_bcw) — `` ∫ x in (1 / 2 : ℝ)..2, bcw x = (25 / 16) * Real.log 25 - 3 / 2 ``
- [`LittlewoodSharp.exp2_ge`](../lean_stage3/LittlewoodSharpLog.md#LittlewoodSharp-exp2_ge) — `` (7389 / 1000 : ℝ) ≤ Real.exp 1 * Real.exp 1 ``
- [`LittlewoodSharp.log25_le`](../lean_stage3/LittlewoodSharpLog.md#LittlewoodSharp-log25_le) — `` Real.log 25 ≤ 13 / 4 ``
- [`LittlewoodSharp.log84_le'`](../lean_stage3/LittlewoodSharpLog.md#LittlewoodSharp-log84_le-) — `` Real.log 84 ≤ 89 / 20 ``
- [`LittlewoodSharp.log3_le'`](../lean_stage3/LittlewoodSharpLog.md#LittlewoodSharp-log3_le-) — `` Real.log 3 ≤ 11 / 10 ``
- [`LittlewoodSharp.log2516_le`](../lean_stage3/LittlewoodSharpLog.md#LittlewoodSharp-log2516_le) — `` Real.log (25 / 16) ≤ 1 / 2 ``
- [`LittlewoodSharp.log65_ge`](../lean_stage3/LittlewoodSharpLog.md#LittlewoodSharp-log65_ge) — `` (9 / 50 : ℝ) ≤ Real.log (6 / 5) ``

### [`LittlewoodSharpPoint`](../lean_stage3/LittlewoodSharpPoint.md) — 9

- [`LittlewoodSharp.h2532`](../lean_stage3/LittlewoodSharpPoint.md#LittlewoodSharp-h2532) — `` (25 : ℝ) / 32 < 1 ``
- [`LittlewoodSharp.zeroSet`](../lean_stage3/LittlewoodSharpPoint.md#LittlewoodSharp-zeroSet) — *def*
- [`LittlewoodSharp.zeroMass`](../lean_stage3/LittlewoodSharpPoint.md#LittlewoodSharp-zeroMass) — *def*
- [`LittlewoodSharp.log84T_pos`](../lean_stage3/LittlewoodSharpPoint.md#LittlewoodSharp-log84T_pos) — `` 0 < Real.log (84 * T) ``
- [`LittlewoodSharp.zeroMass_le`](../lean_stage3/LittlewoodSharpPoint.md#LittlewoodSharp-zeroMass_le) — `` zeroMass hT ≤ 50 / 9 * Real.log (84 * T) ``
- [`LittlewoodSharp.log_blaschke_ge`](../lean_stage3/LittlewoodSharpPoint.md#LittlewoodSharp-log_blaschke_ge) — `` -(2 * Real.log (84 * T) * ‖z‖ / (25 / 32 - ‖z‖)) ≤ Real.log ‖BlaschkeB (25 / 32) (15 / 16) (jensenF T) z‖ ``
- [`LittlewoodSharp.norm_numer_le`](../lean_stage3/LittlewoodSharpPoint.md#LittlewoodSharp-norm_numer_le) — `` ‖((15 / 16 : ℝ) : ℂ) - z * (starRingEnd ℂ) ρ / ((15 / 16 : ℝ) : ℂ)‖ ≤ 25 / 16 ``
- [`LittlewoodSharp.norm_blaschke_mul_le`](../lean_stage3/LittlewoodSharpPoint.md#LittlewoodSharp-norm_blaschke_mul_le) — `` ‖BlaschkeB (25 / 32) (15 / 16) (jensenF T) z‖ * ∏ ρ ∈ zeroSet hT, ‖z - ρ‖ ^ analyticOrderNatAt (jensenF T) ρ ≤ ‖jensenF T z‖ * (25 / 16) ^ (∑ ρ ∈ zeroSet hT, an… ``
- [`LittlewoodSharp.log_jensenF_ge`](../lean_stage3/LittlewoodSharpPoint.md#LittlewoodSharp-log_jensenF_ge) — `` -(2 * Real.log (84 * T) * ‖z‖ / (25 / 32 - ‖z‖)) - zeroMass hT * Real.log (25 / 16) + ∑ ρ ∈ zeroSet hT, (analyticOrderNatAt (jensenF T) ρ : ℝ) * Real.log ‖z - ρ… ``

### [`Stirling`](../lean_stage3/Stirling.md) — 6

- [`Stage3.phasePoint`](../lean_stage3/Stirling.md#Stage3-phasePoint) — *def*
- [`Stage3.phaseTheta`](../lean_stage3/Stirling.md#Stage3-phaseTheta) — *def*
- [`Stage3.continuous_phasePoint`](../lean_stage3/Stirling.md#Stage3-continuous_phasePoint) — `` Continuous phasePoint ``
- [`Stage3.intervalIntegrable_phasePoint`](../lean_stage3/Stirling.md#Stage3-intervalIntegrable_phasePoint) — `` IntervalIntegrable phasePoint MeasureTheory.volume a b ``
- [`Stage3.zq`](../lean_stage3/Stirling.md#Stage3-zq) — *def*
- [`Stage3.phasePoint_eq`](../lean_stage3/Stirling.md#Stage3-phasePoint_eq) — `` phasePoint t = (Complex.digamma (zq t)).re ``

### [`ArgIdentity`](../lean_stage3/ArgIdentity.md) — 53

- [`Stage3.xi`](../lean_stage3/ArgIdentity.md#Stage3-xi) — *def*
- [`Stage3.differentiable_xi`](../lean_stage3/ArgIdentity.md#Stage3-differentiable_xi) — `` Differentiable ℂ xi ``
- [`Stage3.xi_zero`](../lean_stage3/ArgIdentity.md#Stage3-xi_zero) — `` xi 0 = 1 ``
- [`Stage3.xi_one`](../lean_stage3/ArgIdentity.md#Stage3-xi_one) — `` xi 1 = 1 ``
- [`Stage3.xi_eq_completed`](../lean_stage3/ArgIdentity.md#Stage3-xi_eq_completed) — `` xi s = s * (s - 1) * completedRiemannZeta s ``
- [`Stage3.xi_one_sub`](../lean_stage3/ArgIdentity.md#Stage3-xi_one_sub) — `` xi (1 - s) = xi s ``
- [`Stage3.gammaR_conj`](../lean_stage3/ArgIdentity.md#Stage3-gammaR_conj) — `` Gammaℝ (conj s) = conj (Gammaℝ s) ``
- [`Stage3.completed_eq_gammaR_mul_zeta`](../lean_stage3/ArgIdentity.md#Stage3-completed_eq_gammaR_mul_zeta) — `` completedRiemannZeta s = Gammaℝ s * riemannZeta s ``
- [`Stage3.completedZeta₀_conj`](../lean_stage3/ArgIdentity.md#Stage3-completedZeta-_conj) — `` completedRiemannZeta₀ (conj s) = conj (completedRiemannZeta₀ s) ``
- [`Stage3.xi_conj`](../lean_stage3/ArgIdentity.md#Stage3-xi_conj) — `` xi (conj s) = conj (xi s) ``
- [`Stage3.zeta_re_neg_of_real_mem_Ioo`](../lean_stage3/ArgIdentity.md#Stage3-zeta_re_neg_of_real_mem_Ioo) — `` (riemannZeta (σ : ℂ)).re < 0 ``
- [`Stage3.zeta_ne_zero_of_real_mem_Ioo`](../lean_stage3/ArgIdentity.md#Stage3-zeta_ne_zero_of_real_mem_Ioo) — `` riemannZeta (σ : ℂ) ≠ 0 ``
- [`Stage3.completed_eq_gammaR_mul_zeta'`](../lean_stage3/ArgIdentity.md#Stage3-completed_eq_gammaR_mul_zeta-) — `` completedRiemannZeta s = Gammaℝ s * riemannZeta s ``
- [`Stage3.xi_eq_prod`](../lean_stage3/ArgIdentity.md#Stage3-xi_eq_prod) — `` xi s = s * (s - 1) * Gammaℝ s * riemannZeta s ``
- [`Stage3.xi_ne_zero_of_one_le_re`](../lean_stage3/ArgIdentity.md#Stage3-xi_ne_zero_of_one_le_re) — `` xi s ≠ 0 ``
- [`Stage3.xi_ne_zero_of_re_nonpos`](../lean_stage3/ArgIdentity.md#Stage3-xi_ne_zero_of_re_nonpos) — `` xi s ≠ 0 ``
- [`Stage3.xi_ne_zero_of_real`](../lean_stage3/ArgIdentity.md#Stage3-xi_ne_zero_of_real) — `` xi (σ : ℂ) ≠ 0 ``
- [`Stage3.xi_eq_zero_iff`](../lean_stage3/ArgIdentity.md#Stage3-xi_eq_zero_iff) — `` xi s = 0 ↔ riemannZeta s = 0 ∧ 0 < s.re ∧ s.re < 1 ``
- [`Stage3.meromorphicOrderAt_xi_eq_zeta`](../lean_stage3/ArgIdentity.md#Stage3-meromorphicOrderAt_xi_eq_zeta) — `` meromorphicOrderAt xi ρ = meromorphicOrderAt riemannZeta ρ ``
- [`Stage3.xi_analyticAt`](../lean_stage3/ArgIdentity.md#Stage3-xi_analyticAt) — `` AnalyticAt ℂ xi s ``
- [`Stage3.xi_meromorphicOrderAt_ne_top`](../lean_stage3/ArgIdentity.md#Stage3-xi_meromorphicOrderAt_ne_top) — `` meromorphicOrderAt xi p ≠ ⊤ ``
- [`Stage3.logDeriv_xi_meromorphicAt`](../lean_stage3/ArgIdentity.md#Stage3-logDeriv_xi_meromorphicAt) — `` MeromorphicAt (logDeriv xi) s ``
- [`Stage3.N_eq_sum`](../lean_stage3/ArgIdentity.md#Stage3-N_eq_sum) — `` riemannZeta.N T = ∑ ρ ∈ (Kadiri.zeroes_rect_univ_positive_height_finite T).toFinset, (riemannZeta.order ρ : ℝ) ``
- [`Stage3.xi_divisor_support_eq`](../lean_stage3/ArgIdentity.md#Stage3-xi_divisor_support_eq) — `` (MeromorphicOn.divisor xi (Rectangle (-1 : ℂ) (2 + Complex.I * T))).support = riemannZeta.zeroes_rect (Set.univ : Set ℝ) (Set.Ioo 0 T) ``
- [`Stage3.rectangleIntegral_logDeriv_xi_eq_N`](../lean_stage3/ArgIdentity.md#Stage3-rectangleIntegral_logDeriv_xi_eq_N) — `` RectangleIntegral' (logDeriv xi) (-1 : ℂ) (2 + Complex.I * T) = ((riemannZeta.N T : ℝ) : ℂ) ``
- [`Stage3.logDeriv_xi_one_sub`](../lean_stage3/ArgIdentity.md#Stage3-logDeriv_xi_one_sub) — `` logDeriv xi (1 - s) = -logDeriv xi s ``
- [`Stage3.logDeriv_xi_conj`](../lean_stage3/ArgIdentity.md#Stage3-logDeriv_xi_conj) — `` logDeriv xi (conj s) = conj (logDeriv xi s) ``
- [`Stage3.logDeriv_xi_continuousAt`](../lean_stage3/ArgIdentity.md#Stage3-logDeriv_xi_continuousAt) — `` ContinuousAt (logDeriv xi) p ``
- [`Stage3.xi_ne_zero_on_good_top`](../lean_stage3/ArgIdentity.md#Stage3-xi_ne_zero_on_good_top) — `` xi ((x : ℂ) + T * Complex.I) ≠ 0 ``
- [`Stage3.pi_mul_N_eq`](../lean_stage3/ArgIdentity.md#Stage3-pi_mul_N_eq) — `` Real.pi * riemannZeta.N T = (∫ t in (0:ℝ)..T, logDeriv xi (2 + (t : ℂ) * Complex.I)).re - (∫ x in (1/2:ℝ)..2, logDeriv xi ((x : ℂ) + T * Complex.I)).im ``
- [`Stage3.logDeriv_congr_of_eventuallyEq`](../lean_stage3/ArgIdentity.md#Stage3-logDeriv_congr_of_eventuallyEq) — `` logDeriv f x = logDeriv g x ``
- [`Stage3.gammaR_eq_exp_mul`](../lean_stage3/ArgIdentity.md#Stage3-gammaR_eq_exp_mul) — `` Gammaℝ s = Complex.exp (-(Real.log Real.pi : ℂ) / 2 * s) * Complex.Gamma (s / 2) ``
- [`Stage3.differentiableAt_gammaR`](../lean_stage3/ArgIdentity.md#Stage3-differentiableAt_gammaR) — `` DifferentiableAt ℂ Gammaℝ s ``
- [`Stage3.logDeriv_gammaR`](../lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR) — `` logDeriv Gammaℝ s = -(Real.log Real.pi : ℂ) / 2 + Complex.digamma (s / 2) / 2 ``
- [`Stage3.logDeriv_xi_split`](../lean_stage3/ArgIdentity.md#Stage3-logDeriv_xi_split) — `` logDeriv xi s = 1 / s + 1 / (s - 1) + logDeriv Gammaℝ s + logDeriv riemannZeta s ``
- [`Stage3.intervalIntegral_re`](../lean_stage3/ArgIdentity.md#Stage3-intervalIntegral_re) — `` (∫ t in a..b, f t).re = ∫ t in a..b, (f t).re ``
- [`Stage3.logDeriv_gammaR_conj`](../lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR_conj) — `` logDeriv Gammaℝ (conj s) = conj (logDeriv Gammaℝ s) ``
- [`Stage3.logDeriv_gammaR_im_eq_zero`](../lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR_im_eq_zero) — `` (logDeriv Gammaℝ ((x : ℝ) : ℂ)).im = 0 ``
- [`Stage3.integral_inv_vertical`](../lean_stage3/ArgIdentity.md#Stage3-integral_inv_vertical) — `` (∫ t in (0:ℝ)..T, ((c : ℂ) + t * Complex.I)⁻¹) = -Complex.I * (Complex.log ((c : ℂ) + T * Complex.I) - Complex.log (c : ℂ)) ``
- [`Stage3.integral_inv_horizontal`](../lean_stage3/ArgIdentity.md#Stage3-integral_inv_horizontal) — `` (∫ x in a..b, (((x : ℂ) - d) + T * Complex.I)⁻¹) = Complex.log (((b : ℂ) - d) + T * Complex.I) - Complex.log (((a : ℂ) - d) + T * Complex.I) ``
- [`Stage3.arg_sum_eq_pi`](../lean_stage3/ArgIdentity.md#Stage3-arg_sum_eq_pi) — `` Complex.arg ((1/2 : ℝ) + T * Complex.I) + Complex.arg ((-(1/2) : ℝ) + T * Complex.I) = Real.pi ``
- [`Stage3.elemLD`](../lean_stage3/ArgIdentity.md#Stage3-elemLD) — *def*
- [`Stage3.elem_fold_eq_pi`](../lean_stage3/ArgIdentity.md#Stage3-elem_fold_eq_pi) — `` (∫ t in (0:ℝ)..T, elemLD (2 + (t : ℂ) * Complex.I)).re - (∫ x in (1/2:ℝ)..2, elemLD ((x : ℂ) + T * Complex.I)).im = Real.pi ``
- [`Stage3.logDeriv_gammaR_analyticAt`](../lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR_analyticAt) — `` AnalyticAt ℂ (logDeriv Gammaℝ) z ``
- [`Stage3.logDeriv_gammaR_continuousAt`](../lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR_continuousAt) — `` ContinuousAt (logDeriv Gammaℝ) z ``
- [`Stage3.logDeriv_gammaR_holo`](../lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR_holo) — `` HolomorphicOn (logDeriv Gammaℝ) {s : ℂ | 0 < s.re} ``
- [`Stage3.logDeriv_gammaR_comp_continuous`](../lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR_comp_continuous) — `` Continuous fun x : ℝ => logDeriv Gammaℝ (g x) ``
- [`Stage3.gammaR_fold_eq_phaseTheta`](../lean_stage3/ArgIdentity.md#Stage3-gammaR_fold_eq_phaseTheta) — `` (∫ t in (0:ℝ)..T, logDeriv Gammaℝ (2 + (t : ℂ) * Complex.I)).re - (∫ x in (1/2:ℝ)..2, logDeriv Gammaℝ ((x : ℂ) + T * Complex.I)).im = phaseTheta T ``
- [`Stage3.argS`](../lean_stage3/ArgIdentity.md#Stage3-argS) — *def*
- [`Stage3.logDeriv_zeta_analyticAt`](../lean_stage3/ArgIdentity.md#Stage3-logDeriv_zeta_analyticAt) — `` AnalyticAt ℂ (logDeriv riemannZeta) z ``
- [`Stage3.logDeriv_zeta_continuousAt`](../lean_stage3/ArgIdentity.md#Stage3-logDeriv_zeta_continuousAt) — `` ContinuousAt (logDeriv riemannZeta) z ``
- [`Stage3.zetaArgContour`](../lean_stage3/ArgIdentity.md#Stage3-zetaArgContour) — *def*
- [`Stage3.argS_eq_zetaArgContour`](../lean_stage3/ArgIdentity.md#Stage3-argS_eq_zetaArgContour) — `` argS T = zetaArgContour T ``

### [`TuringLWHoriz`](../lean_stage3/TuringLWHoriz.md) — 6

- [`TuringLW.zx`](../lean_stage3/TuringLWHoriz.md#TuringLW-zx) — *def*
- [`TuringLW.beta`](../lean_stage3/TuringLWHoriz.md#TuringLW-beta) — *def*
- [`TuringLW.zx_arg`](../lean_stage3/TuringLWHoriz.md#TuringLW-zx_arg) — `` 2 * zx x + (2 + Complex.I * (t : ℂ)) = (x : ℂ) + (t : ℂ) * Complex.I ``
- [`TuringLW.norm_zx`](../lean_stage3/TuringLWHoriz.md#TuringLW-norm_zx) — `` ‖zx x‖ ≤ 3 / 4 ``
- [`TuringLW.log_sub_le`](../lean_stage3/TuringLWHoriz.md#TuringLW-log_sub_le) — `` Real.log (x - beta ρ) - Real.log 2 ≤ Real.log ‖zx x - ρ‖ ``
- [`TuringLW.intervalIntegrable_sum'`](../lean_stage3/TuringLWHoriz.md#TuringLW-intervalIntegrable_sum-) — `` IntervalIntegrable (fun x => ∑ i ∈ s, f i x) volume a b ``

### [`TuringS`](../lean_stage3/TuringS.md) — 15

- [`Turing.S`](../lean_stage3/TuringS.md#Turing-S) — *def*
- [`Turing.S₁`](../lean_stage3/TuringS.md#Turing-S-) — *def*
- [`Turing.F`](../lean_stage3/TuringS.md#Turing-F) — *def*
- ★ [`Turing.StmtLittlewood`](../lean_stage3/TuringS.md#Turing-StmtLittlewood) — *def*
- [`Turing.StmtSplit`](../lean_stage3/TuringS.md#Turing-StmtSplit) — *def*
- [`Turing.StmtOsc`](../lean_stage3/TuringS.md#Turing-StmtOsc) — *def*
- [`Turing.StmtHorizUpper`](../lean_stage3/TuringS.md#Turing-StmtHorizUpper) — *def*
- [`Turing.StmtHorizLower`](../lean_stage3/TuringS.md#Turing-StmtHorizLower) — *def*
- [`Turing.S_eq_argS`](../lean_stage3/TuringS.md#Turing-S_eq_argS) — `` S t = Stage3.argS t ``
- [`Turing.continuous_phaseTheta`](../lean_stage3/TuringS.md#Turing-continuous_phaseTheta) — `` Continuous Stage3.phaseTheta ``
- [`Turing.intervalIntegrable_S`](../lean_stage3/TuringS.md#Turing-intervalIntegrable_S) — `` IntervalIntegrable S volume a b ``
- [`Turing.S₁_sub`](../lean_stage3/TuringS.md#Turing-S-_sub) — `` S₁ t₂ - S₁ t₁ = ∫ t in t₁..t₂, S t ``
- [`Turing.log_zeta_le`](../lean_stage3/TuringS.md#Turing-log_zeta_le) — `` Real.log ‖riemannZeta ((x : ℂ) + (t : ℂ) * Complex.I)‖ ≤ Real.log 9 + Real.log t ``
- [`Turing.horizUpper_holds`](../lean_stage3/TuringS.md#Turing-horizUpper_holds) — `` StmtHorizUpper (3 / 2) ((3 / 2) * Real.log 9) ``
- [`Turing.littlewood_of_pieces`](../lean_stage3/TuringS.md#Turing-littlewood_of_pieces) — `` StmtLittlewood ((3 / 2 + a₂) / Real.pi) ((c₀ + (3 / 2) * Real.log 9 + b₂) / Real.pi) 2 ``

### [`LittlewoodSharpHoriz`](../lean_stage3/LittlewoodSharpHoriz.md) — 9

- [`LittlewoodSharp.gLow`](../lean_stage3/LittlewoodSharpHoriz.md#LittlewoodSharp-gLow) — *def*
- [`LittlewoodSharp.norm_zx_eq`](../lean_stage3/LittlewoodSharpHoriz.md#LittlewoodSharp-norm_zx_eq) — `` ‖TuringLW.zx x‖ = (2 - x) / 2 ``
- [`LittlewoodSharp.bc_eq`](../lean_stage3/LittlewoodSharpHoriz.md#LittlewoodSharp-bc_eq) — `` 2 * M * ‖TuringLW.zx x‖ / (25 / 32 - ‖TuringLW.zx x‖) = 2 * M * bcw x ``
- [`LittlewoodSharp.log_zeta_ge`](../lean_stage3/LittlewoodSharpHoriz.md#LittlewoodSharp-log_zeta_ge) — `` gLow ht x ≤ Real.log ‖riemannZeta ((x : ℂ) + (t : ℂ) * Complex.I)‖ ``
- [`LittlewoodSharp.intervalIntegrable_term`](../lean_stage3/LittlewoodSharpHoriz.md#LittlewoodSharp-intervalIntegrable_term) — `` IntervalIntegrable (fun x => (analyticOrderNatAt (jensenF t) ρ : ℝ) * (Real.log (x - TuringLW.beta ρ) - Real.log 2)) volume (1 / 2) 2 ``
- [`LittlewoodSharp.intervalIntegrable_sumTerm`](../lean_stage3/LittlewoodSharpHoriz.md#LittlewoodSharp-intervalIntegrable_sumTerm) — `` IntervalIntegrable (fun x => ∑ ρ ∈ zeroSet ht, (analyticOrderNatAt (jensenF t) ρ : ℝ) * (Real.log (x - TuringLW.beta ρ) - Real.log 2)) volume (1 / 2) 2 ``
- [`LittlewoodSharp.intervalIntegrable_gLow`](../lean_stage3/LittlewoodSharpHoriz.md#LittlewoodSharp-intervalIntegrable_gLow) — `` IntervalIntegrable (gLow ht) volume (1 / 2) 2 ``
- [`LittlewoodSharp.integral_g_ge`](../lean_stage3/LittlewoodSharpHoriz.md#LittlewoodSharp-integral_g_ge) — `` -(113 / 4 * Real.log t + 128) ≤ ∫ x in (1 / 2 : ℝ)..2, gLow ht x ``
- ★ [`LittlewoodSharp.horizLower_sharp`](../lean_stage3/LittlewoodSharpHoriz.md#LittlewoodSharp-horizLower_sharp) — `` Turing.StmtHorizLower (113 / 4) 128 ``

### [`TuringLWSplitOsc`](../lean_stage3/TuringLWSplitOsc.md) — 26

- [`TuringLW.vm`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-vm) — *def*
- [`TuringLW.E`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-E) — *def*
- [`TuringLW.H`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-H) — *def*
- [`TuringLW.vm_nonneg`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-vm_nonneg) — `` 0 ≤ vm n ``
- [`TuringLW.vm_le_log`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-vm_le_log) — `` vm n ≤ Real.log n ``
- [`TuringLW.vm_eq_zero_of_log`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-vm_eq_zero_of_log) — `` vm n = 0 ``
- [`TuringLW.vm_div_log_mul`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-vm_div_log_mul) — `` vm n / Real.log n * Real.log n = vm n ``
- [`TuringLW.vm_div_log_nonneg`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-vm_div_log_nonneg) — `` 0 ≤ vm n / Real.log n ``
- [`TuringLW.vm_div_log_le_one`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-vm_div_log_le_one) — `` vm n / Real.log n ≤ 1 ``
- [`TuringLW.vm_div_log_sq_nonneg`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-vm_div_log_sq_nonneg) — `` 0 ≤ vm n / Real.log n ^ 2 ``
- [`TuringLW.vm_div_log_sq_le`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-vm_div_log_sq_le) — `` vm n / Real.log n ^ 2 ≤ 1 / Real.log 2 ``
- [`TuringLW.hasDerivAt_E`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-hasDerivAt_E) — `` HasDerivAt (E n) (-(I * (Real.log n : ℂ)) * E n t) t ``
- [`TuringLW.norm_E`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-norm_E) — `` ‖E n t‖ = Real.exp (-2 * Real.log n) ``
- [`TuringLW.E_zero`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-E_zero) — `` E n 0 = ((Real.exp (-2 * Real.log n) : ℝ) : ℂ) ``
- [`TuringLW.term_eq`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-term_eq) — `` LSeries.term (fun n => ((ArithmeticFunction.vonMangoldt n : ℝ) : ℂ)) (2 + (t : ℂ) * I) n = (vm n : ℂ) * E n t ``
- [`TuringLW.summable_v`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-summable_v) — `` Summable fun n : ℕ => Real.exp (-2 * Real.log n) ``
- [`TuringLW.summable_u`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-summable_u) — `` Summable fun n : ℕ => vm n * Real.exp (-2 * Real.log n) ``
- [`TuringLW.logDeriv_eq_tsum`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-logDeriv_eq_tsum) — `` logDeriv riemannZeta (2 + (t : ℂ) * I) = ∑' n : ℕ, -(vm n : ℂ) * E n t ``
- [`TuringLW.hasDerivAt_H`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-hasDerivAt_H) — `` HasDerivAt H (∑' n : ℕ, -(vm n : ℂ) * E n t) t ``
- [`TuringLW.re_H_zero`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-re_H_zero) — `` (H 0).re = 0 ``
- [`TuringLW.F_eq_re_H`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-F_eq_re_H) — `` Turing.F t = (H t).re ``
- [`TuringLW.integral_F`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-integral_F) — `` ∫ t in t₁..t₂, Turing.F t = (Ψ t₂).re - (Ψ t₁).re ``
- [`TuringLW.coeff_le_w`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-coeff_le_w) — `` vm n / Real.log n ^ 2 * Real.exp (-2 * Real.log n) ≤ (1 / Real.log 2) * (1 / (n : ℝ) ^ 2 - if n = 1 then 1 else 0) ``
- [`TuringLW.stmtOsc_explicit`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-stmtOsc_explicit) — `` Turing.StmtOsc (2 * (Real.pi ^ 2 / 6 - 1) / Real.log 2) ``
- [`TuringLW.c₀_le_two`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-c-_le_two) — `` 2 * (Real.pi ^ 2 / 6 - 1) / Real.log 2 ≤ 2 ``
- [`TuringLW.stmtOsc_holds`](../lean_stage3/TuringLWSplitOsc.md#TuringLW-stmtOsc_holds) — `` Turing.StmtOsc 2 ``

### [`TuringLWSplit`](../lean_stage3/TuringLWSplit.md) — 7

- [`TuringLW.order_ne_top_of`](../lean_stage3/TuringLWSplit.md#TuringLW-order_ne_top_of) — `` ∀ p ∈ Rectangle z w, meromorphicOrderAt f p ≠ ⊤ ``
- [`TuringLW.far_mem`](../lean_stage3/TuringLWSplit.md#TuringLW-far_mem) — `` w ∈ Rectangle z w ``
- [`TuringLW.zeta_analyticOnNhd`](../lean_stage3/TuringLWSplit.md#TuringLW-zeta_analyticOnNhd) — `` AnalyticOnNhd ℂ riemannZeta (Rectangle z w) ``
- [`TuringLW.integral_im_logDeriv_vertical`](../lean_stage3/TuringLWSplit.md#TuringLW-integral_im_logDeriv_vertical) — `` ∫ t in z.im..w.im, (logDeriv f (↑x + ↑t * I)).im = Real.log ‖f (↑x + ↑z.im * I)‖ - Real.log ‖f (↑x + ↑w.im * I)‖ ``
- [`TuringLW.intervalIntegrable_log_zeta`](../lean_stage3/TuringLWSplit.md#TuringLW-intervalIntegrable_log_zeta) — `` IntervalIntegrable (fun x : ℝ => Real.log ‖riemannZeta ((x : ℂ) + (t : ℂ) * I)‖) volume a b ``
- [`TuringLW.stmtSplit_holds`](../lean_stage3/TuringLWSplit.md#TuringLW-stmtSplit_holds) — `` Turing.StmtSplit ``
- ★ [`TuringLW.littlewood_of_lower`](../lean_stage3/TuringLWSplit.md#TuringLW-littlewood_of_lower) — `` Turing.StmtLittlewood ((3 / 2 + a₂) / Real.pi) ((2 + (3 / 2) * Real.log 9 + b₂) / Real.pi) 2 ``

