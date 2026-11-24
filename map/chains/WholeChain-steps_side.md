# What `WholeChain.steps_side` rests on

[`WholeChain.steps_side`](../lean_stage3/WholeChain.md#WholeChain-steps_side) in `lean_stage3/Stage3/WholeChain.lean`, line 99.

**Why.** The steps' side. What a zero does: it carries weight that is not zero, it makes the staircase leave every bound below its rate, and it makes the turned steps to a cutoff do the same.

**Proves**

```lean
(∀ ρ : NontrivialZeros, -(analyticOrderNatAt riemannZeta (ρ : ℂ) : ℂ) / (ρ : ℂ) ≠ 0) ∧ (∀ (ρ₀ : NontrivialZeros) (θ : ℝ), θ < (ρ₀ : ℂ).re → ∀ (C : ℝ) (k : ℕ) (x₀ : ℝ), ∃ x : ℝ, x₀ ≤ x ∧ C * x ^ θ * Real.log x ^ k < |Chebyshev.psi x - x|) ∧ (∀ (ρ₀ : NontrivialZeros) (s : ℂ), 0 < s.re → (ρ₀ : ℂ) ≠ s → ∀ δ : ℝ, 0 ≤ δ → δ < (ρ₀ : ℂ).re - s.re → ∀ (C : ℝ) (N₀ : ℕ), ∃ N : ℕ, N₀ ≤ N ∧ 2 ≤ N ∧ C * (N : ℝ) ^ δ < ‖StepsPeak.S N s - StepsPeak.K N s 1‖)
```

Behind it: 69 theorems and 19 definitions in 9 files. Every one is listed below; Lean recorded each step.

## The files it passes through

```mermaid
flowchart LR
  f0["<b>ContourShift</b><br/>2 used"]:::thm
  f1["<b>StepsPeak</b><br/>7 used"]:::thm
  f2["<b>StepsPole</b><br/>3 used"]:::thm
  f3["<b>StepsBelow</b><br/>51 used"]:::thm
  f4["<b>ThetaPi</b><br/>1 used"]:::thm
  f5["<b>VonKochScaffold</b><br/>13 used"]:::thm
  f6["<b>ThetaConverse</b><br/>10 used"]:::thm
  f7["<b>RateBelow</b><br/>1 used"]:::thm
  f8["<b>WholeChain</b><br/>steps_side"]:::end_
  f0 --> f2
  f1 --> f3
  f2 --> f3
  f4 --> f6
  f5 --> f6
  f6 --> f7
  f3 --> f8
  f7 --> f8
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

### [`ContourShift`](../lean_stage3/ContourShift.md) — 2

- [`ContourShift.zeta_analyticAt`](../lean_stage3/ContourShift.md#ContourShift-zeta_analyticAt) — `` AnalyticAt ℂ riemannZeta ρ ``
- [`ContourShift.zeta_order_ne_top`](../lean_stage3/ContourShift.md#ContourShift-zeta_order_ne_top) — `` analyticOrderAt riemannZeta ρ ≠ ⊤ ``

### [`StepsPeak`](../lean_stage3/StepsPeak.md) — 7

- [`StepsPeak.ramp`](../lean_stage3/StepsPeak.md#StepsPeak-ramp) — *def*
- [`StepsPeak.slope`](../lean_stage3/StepsPeak.md#StepsPeak-slope) — *def*
- ★ [`StepsPeak.S`](../lean_stage3/StepsPeak.md#StepsPeak-S) — *def*
- ★ [`StepsPeak.K`](../lean_stage3/StepsPeak.md#StepsPeak-K) — *def*
- [`StepsPeak.cont_cpow`](../lean_stage3/StepsPeak.md#StepsPeak-cont_cpow) — `` ContinuousOn (fun y : ℝ => (y : ℂ) ^ c) (Set.Ioi 0) ``
- [`StepsPeak.h0_not_mem`](../lean_stage3/StepsPeak.md#StepsPeak-h0_not_mem) — `` (0:ℝ) ∉ Set.uIcc (2:ℝ) N ``
- [`StepsPeak.K_eq`](../lean_stage3/StepsPeak.md#StepsPeak-K_eq) — `` K N s a = s * ((N:ℂ) ^ (a - s) - 2 ^ (a - s)) / (a - s) - (s - 1) * ((N:ℂ) ^ (a - s + 1) - 2 ^ (a - s + 1)) / ((a - s + 1) * N) ``

### [`StepsPole`](../lean_stage3/StepsPole.md) — 3

- [`StepsPole.steps_sum`](../lean_stage3/StepsPole.md#StepsPole-steps_sum) — `` LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) s = - deriv riemannZeta s / riemannZeta s ``
- [`StepsPole.order_pos`](../lean_stage3/StepsPole.md#StepsPole-order_pos) — `` 0 < analyticOrderNatAt riemannZeta (ρ : ℂ) ``
- ★ [`StepsPole.steps_pole_ne_zero`](../lean_stage3/StepsPole.md#StepsPole-steps_pole_ne_zero) — `` -(analyticOrderNatAt riemannZeta (ρ : ℂ) : ℂ) / (ρ : ℂ) ≠ 0 ``

### [`StepsBelow`](../lean_stage3/StepsBelow.md) — 51

- [`StepsBelow.coef`](../lean_stage3/StepsBelow.md#StepsBelow-coef) — *def*
- [`StepsBelow.tent`](../lean_stage3/StepsBelow.md#StepsBelow-tent) — *def*
- [`StepsBelow.Bk`](../lean_stage3/StepsBelow.md#StepsBelow-Bk) — *def*
- [`StepsBelow.B`](../lean_stage3/StepsBelow.md#StepsBelow-B) — *def*
- [`StepsBelow.coef_zero`](../lean_stage3/StepsBelow.md#StepsBelow-coef_zero) — `` coef s 0 = 0 ``
- [`StepsBelow.tent_nonneg`](../lean_stage3/StepsBelow.md#StepsBelow-tent_nonneg) — `` 0 ≤ tent n x ``
- [`StepsBelow.tent_eq_zero`](../lean_stage3/StepsBelow.md#StepsBelow-tent_eq_zero) — `` tent n x = 0 ``
- [`StepsBelow.tent_eq`](../lean_stage3/StepsBelow.md#StepsBelow-tent_eq) — `` tent n x = x - n ``
- [`StepsBelow.Bk_eq`](../lean_stage3/StepsBelow.md#StepsBelow-Bk_eq) — `` Bk s K' x = Bk s K x ``
- [`StepsBelow.lt_floor_succ`](../lean_stage3/StepsBelow.md#StepsBelow-lt_floor_succ) — `` x < ((⌊x⌋₊ + 1 : ℕ) : ℝ) ``
- [`StepsBelow.B_eq_Bk`](../lean_stage3/StepsBelow.md#StepsBelow-B_eq_Bk) — `` B s x = Bk s K x ``
- [`StepsBelow.Bk_continuous`](../lean_stage3/StepsBelow.md#StepsBelow-Bk_continuous) — `` Continuous (Bk s K) ``
- [`StepsBelow.B_continuous`](../lean_stage3/StepsBelow.md#StepsBelow-B_continuous) — `` Continuous (B s) ``
- [`StepsBelow.B_nat`](../lean_stage3/StepsBelow.md#StepsBelow-B_nat) — `` B s N = (N : ℂ) * S N s ``
- [`StepsBelow.B_interp`](../lean_stage3/StepsBelow.md#StepsBelow-B_interp) — `` B s x = ((1 - (x - N) : ℝ) : ℂ) * B s N + ((x - N : ℝ) : ℂ) * B s ((N + 1 : ℕ) : ℝ) ``
- [`StepsBelow.kap`](../lean_stage3/StepsBelow.md#StepsBelow-kap) — *def*
- [`StepsBelow.c0`](../lean_stage3/StepsBelow.md#StepsBelow-c0) — *def*
- [`StepsBelow.c1`](../lean_stage3/StepsBelow.md#StepsBelow-c1) — *def*
- [`StepsBelow.natC_ne_zero`](../lean_stage3/StepsBelow.md#StepsBelow-natC_ne_zero) — `` (N:ℂ) ≠ 0 ``
- [`StepsBelow.natC_cpow_two_sub`](../lean_stage3/StepsBelow.md#StepsBelow-natC_cpow_two_sub) — `` (N:ℂ) ^ (2 - s) = (N:ℂ) ^ (1 - s) * N ``
- [`StepsBelow.K_one`](../lean_stage3/StepsBelow.md#StepsBelow-K_one) — `` K N s 1 = kap s * (N:ℂ) ^ (1 - s) + c0 s + c1 s / N ``
- [`StepsBelow.D`](../lean_stage3/StepsBelow.md#StepsBelow-D) — *def*
- [`StepsBelow.D_nat`](../lean_stage3/StepsBelow.md#StepsBelow-D_nat) — `` D s N = (N:ℂ) * (S N s - K N s 1) + (N:ℂ) * c0 s + c1 s ``
- [`StepsBelow.D_nat_le`](../lean_stage3/StepsBelow.md#StepsBelow-D_nat_le) — `` ‖D s N‖ ≤ (|C| + ‖c0 s‖ + ‖c1 s‖) * (N:ℝ) ^ (1 + δ) ``
- [`StepsBelow.pow_diff_le`](../lean_stage3/StepsBelow.md#StepsBelow-pow_diff_le) — `` ‖(y:ℂ) ^ (2 - s) - (x:ℂ) ^ (2 - s)‖ ≤ ‖2 - s‖ * (y * (y - x)) ``
- [`StepsBelow.D_le`](../lean_stage3/StepsBelow.md#StepsBelow-D_le) — `` ‖D s x‖ ≤ ((|C| + ‖c0 s‖ + ‖c1 s‖) * 2 ^ (1 + δ) + 2 * (‖kap s‖ * ‖2 - s‖)) * x ^ (1 + δ) ``
- [`StepsBelow.Rtr`](../lean_stage3/StepsBelow.md#StepsBelow-Rtr) — *def*
- [`StepsBelow.D_continuousOn`](../lean_stage3/StepsBelow.md#StepsBelow-D_continuousOn) — `` ContinuousOn (D s) (Ioi 0) ``
- [`StepsBelow.Rtr_locallyIntegrable`](../lean_stage3/StepsBelow.md#StepsBelow-Rtr_locallyIntegrable) — `` LocallyIntegrableOn (Rtr s) (Ioi 0) ``
- [`StepsBelow.Rtr_bot`](../lean_stage3/StepsBelow.md#StepsBelow-Rtr_bot) — `` Rtr s =O[𝓝[>] 0] (fun x : ℝ => x ^ (-b)) ``
- [`StepsBelow.Rtr_top`](../lean_stage3/StepsBelow.md#StepsBelow-Rtr_top) — `` Rtr s =O[atTop] (fun x : ℝ => x ^ (-(-(1 + δ)))) ``
- [`StepsBelow.tent_mul_eq`](../lean_stage3/StepsBelow.md#StepsBelow-tent_mul_eq) — `` c * (tent n x : ℂ) * (x:ℂ) ^ (-w - 2) = Set.indicator (Set.Ioi (n:ℝ)) (fun x : ℝ => c * ((x:ℂ) ^ (-w - 1) - n * (x:ℂ) ^ (-w - 2))) x ``
- [`StepsBelow.tent_mul_eq_real`](../lean_stage3/StepsBelow.md#StepsBelow-tent_mul_eq_real) — `` c * tent n x * x ^ (-r - 2) = Set.indicator (Set.Ioi (n:ℝ)) (fun x : ℝ => c * (x ^ (-r - 1) - n * x ^ (-r - 2))) x ``
- [`StepsBelow.re_lt_one`](../lean_stage3/StepsBelow.md#StepsBelow-re_lt_one) — `` (-w - 1).re < -1 ∧ (-w - 2).re < -1 ``
- [`StepsBelow.term_integrableOn`](../lean_stage3/StepsBelow.md#StepsBelow-term_integrableOn) — `` IntegrableOn (fun x : ℝ => c * (tent n x : ℂ) * (x:ℂ) ^ (-w - 2)) (Ioi 1) ``
- [`StepsBelow.term_integral`](../lean_stage3/StepsBelow.md#StepsBelow-term_integral) — `` ∫ x in Ioi (1:ℝ), c * (tent n x : ℂ) * (x:ℂ) ^ (-w - 2) = c * (n:ℂ) ^ (-w) / (w * (w + 1)) ``
- [`StepsBelow.term_integral_real`](../lean_stage3/StepsBelow.md#StepsBelow-term_integral_real) — `` ∫ x in Ioi (1:ℝ), c * tent n x * x ^ (-r - 2) = c * (n:ℝ) ^ (-r) / (r * (r + 1)) ``
- [`StepsBelow.term_norm_integral`](../lean_stage3/StepsBelow.md#StepsBelow-term_norm_integral) — `` ∫ x in Ioi (1:ℝ), ‖coef s n * (tent n x : ℂ) * (x:ℂ) ^ (-w - 2)‖ = ‖coef s n‖ * (n:ℝ) ^ (-w.re) / (w.re * (w.re + 1)) ``
- [`StepsBelow.summable_norm_integrals`](../lean_stage3/StepsBelow.md#StepsBelow-summable_norm_integrals) — `` Summable (fun n : ℕ => ∫ x in Ioi (1:ℝ), ‖coef s n * (tent n x : ℂ) * (x:ℂ) ^ (-w - 2)‖) ``
- [`StepsBelow.term_integral_eq`](../lean_stage3/StepsBelow.md#StepsBelow-term_integral_eq) — `` ∫ x in Ioi (1:ℝ), coef s n * (tent n x : ℂ) * (x:ℂ) ^ (-w - 2) = LSeries.term (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (s + w) n / (w * (w + 1)) ``
- [`StepsBelow.tsum_terms`](../lean_stage3/StepsBelow.md#StepsBelow-tsum_terms) — `` ∑' n : ℕ, coef s n * (tent n x : ℂ) * (x:ℂ) ^ (-w - 2) = B s x * (x:ℂ) ^ (-w - 2) ``
- [`StepsBelow.D_integral_eq_mellin`](../lean_stage3/StepsBelow.md#StepsBelow-D_integral_eq_mellin) — `` ∫ x in Ioi (1:ℝ), D s x * (x:ℂ) ^ (-w - 2) = mellin (Rtr s) (-w - 1) ``
- [`StepsBelow.mellin_identity`](../lean_stage3/StepsBelow.md#StepsBelow-mellin_identity) — `` -deriv ζ (s + w) / ζ (s + w) = w * (w + 1) * (mellin (Rtr s) (-w - 1) + kap s / (s + w - 1)) ``
- [`StepsBelow.Fz`](../lean_stage3/StepsBelow.md#StepsBelow-Fz) — *def*
- [`StepsBelow.Fz_eq`](../lean_stage3/StepsBelow.md#StepsBelow-Fz_eq) — `` Fz s z = -deriv ζ z / ζ z ``
- [`StepsBelow.Fz_differentiableAt`](../lean_stage3/StepsBelow.md#StepsBelow-Fz_differentiableAt) — `` DifferentiableAt ℂ (Fz s) z ``
- [`StepsBelow.anchor_mem`](../lean_stage3/StepsBelow.md#StepsBelow-anchor_mem) — `` ((max θ X + 1 : ℝ) : ℂ) ∈ Stage3.regionθ θ ∧ X < ((max θ X + 1 : ℝ) : ℂ).re ``
- [`StepsBelow.eqOn_zero_of_agree`](../lean_stage3/StepsBelow.md#StepsBelow-eqOn_zero_of_agree) — `` Set.EqOn (fun z : ℂ ↦ F z * ζ z + deriv ζ z) 0 (Stage3.regionθ θ) ``
- [`StepsBelow.zeta_ne_zero_of_agree`](../lean_stage3/StepsBelow.md#StepsBelow-zeta_ne_zero_of_agree) — `` ζ ρ ≠ 0 ``
- [`StepsBelow.zeta_ne_zero_of_steps_bound`](../lean_stage3/StepsBelow.md#StepsBelow-zeta_ne_zero_of_steps_bound) — `` ζ ρ ≠ 0 ``
- ★ [`StepsBelow.rain_steps`](../lean_stage3/StepsBelow.md#StepsBelow-rain_steps) — `` ∃ N : ℕ, N₀ ≤ N ∧ 2 ≤ N ∧ C * (N : ℝ) ^ δ < ‖StepsPeak.S N s - StepsPeak.K N s 1‖ ``

### [`ThetaPi`](../lean_stage3/ThetaPi.md) — 1

- [`Stage3.StmtPsiWeakTheta`](../lean_stage3/ThetaPi.md#Stage3-StmtPsiWeakTheta) — *def*

### [`VonKochScaffold`](../lean_stage3/VonKochScaffold.md) — 13

- [`VonKoch.E`](../lean_stage3/VonKochScaffold.md#VonKoch-E) — *def*
- [`VonKoch.F`](../lean_stage3/VonKochScaffold.md#VonKoch-F) — *def*
- [`VonKoch.Etr`](../lean_stage3/VonKochScaffold.md#VonKoch-Etr) — *def*
- [`VonKoch.measurable_psi'`](../lean_stage3/VonKochScaffold.md#VonKoch-measurable_psi-) — `` Measurable (fun t : ℝ ↦ ψ t) ``
- [`VonKoch.Etr_measurable`](../lean_stage3/VonKochScaffold.md#VonKoch-Etr_measurable) — `` Measurable Etr ``
- [`VonKoch.E_le_linear`](../lean_stage3/VonKochScaffold.md#VonKoch-E_le_linear) — `` ‖(E t : ℝ)‖ ≤ (Real.log 4 + 5) * t ``
- [`VonKoch.E_integral_eq_mellin`](../lean_stage3/VonKochScaffold.md#VonKoch-E_integral_eq_mellin) — `` ∫ x in Set.Ioi (1:ℝ), (E x : ℂ) * (x : ℂ) ^ (-s - 1) = mellin Etr (-s) ``
- [`VonKoch.Etr_locallyIntegrable`](../lean_stage3/VonKochScaffold.md#VonKoch-Etr_locallyIntegrable) — `` MeasureTheory.LocallyIntegrableOn Etr (Set.Ioi 0) ``
- [`VonKoch.sum_Icc_vonMangoldt`](../lean_stage3/VonKochScaffold.md#VonKoch-sum_Icc_vonMangoldt) — `` ∑ k ∈ Finset.Icc 1 n, ArithmeticFunction.vonMangoldt k = ψ n ``
- [`VonKoch.psi_partial_bigO`](../lean_stage3/VonKochScaffold.md#VonKoch-psi_partial_bigO) — `` (fun n : ℕ ↦ ∑ k ∈ Finset.Icc 1 n, ArithmeticFunction.vonMangoldt k) =O[Filter.atTop] fun n : ℕ ↦ (n : ℝ) ^ (1:ℝ) ``
- [`VonKoch.measurable_psi`](../lean_stage3/VonKochScaffold.md#VonKoch-measurable_psi) — `` Measurable (fun t : ℝ ↦ ψ t) ``
- [`VonKoch.integrable_psi_cpow`](../lean_stage3/VonKochScaffold.md#VonKoch-integrable_psi_cpow) — `` IntegrableOn (fun t : ℝ ↦ ((ψ t : ℝ) : ℂ) * (t : ℂ) ^ (-(s + 1))) (Set.Ioi (1:ℝ)) ``
- [`VonKoch.F_eq_neg_logDeriv`](../lean_stage3/VonKochScaffold.md#VonKoch-F_eq_neg_logDeriv) — `` F s = -deriv riemannZeta s / riemannZeta s ``

### [`ThetaConverse`](../lean_stage3/ThetaConverse.md) — 10

- [`Stage3.regionθ`](../lean_stage3/ThetaConverse.md#Stage3-region-) — *def*
- [`Stage3.isOpen_regionθ`](../lean_stage3/ThetaConverse.md#Stage3-isOpen_region-) — `` IsOpen (regionθ θ) ``
- [`Stage3.preconnected_regionθ`](../lean_stage3/ThetaConverse.md#Stage3-preconnected_region-) — `` IsPreconnected (regionθ θ) ``
- [`Stage3.zeta_analyticOnNhd_regionθ`](../lean_stage3/ThetaConverse.md#Stage3-zeta_analyticOnNhd_region-) — `` AnalyticOnNhd ℂ ζ (regionθ θ) ``
- [`Stage3.log_pow_isBigO_rpow`](../lean_stage3/ThetaConverse.md#Stage3-log_pow_isBigO_rpow) — `` (fun t : ℝ ↦ (Real.log t) ^ k) =O[Filter.atTop] (fun t : ℝ ↦ t ^ δ) ``
- [`Stage3.F_differentiableAt_theta`](../lean_stage3/ThetaConverse.md#Stage3-F_differentiableAt_theta) — `` DifferentiableAt ℂ VonKoch.F s ``
- [`Stage3.F_analyticOnNhd_theta`](../lean_stage3/ThetaConverse.md#Stage3-F_analyticOnNhd_theta) — `` AnalyticOnNhd ℂ VonKoch.F (regionθ θ) ``
- [`Stage3.anchor_mem_regionθ`](../lean_stage3/ThetaConverse.md#Stage3-anchor_mem_region-) — `` ((max θ 1 + 1 : ℝ) : ℂ) ∈ regionθ θ ∧ 1 < ((max θ 1 + 1 : ℝ) : ℂ).re ``
- [`Stage3.F_mul_zeta_add_deriv_eqOn_zero_theta`](../lean_stage3/ThetaConverse.md#Stage3-F_mul_zeta_add_deriv_eqOn_zero_theta) — `` Set.EqOn (fun s : ℂ ↦ VonKoch.F s * ζ s + deriv ζ s) 0 (regionθ θ) ``
- [`Stage3.no_zero_right_of_theta`](../lean_stage3/ThetaConverse.md#Stage3-no_zero_right_of_theta) — `` ζ ρ ≠ 0 ``

### [`RateBelow`](../lean_stage3/RateBelow.md) — 1

- ★ [`RateBelow.rain_psi`](../lean_stage3/RateBelow.md#RateBelow-rain_psi) — `` ∃ x : ℝ, x₀ ≤ x ∧ C * x ^ θ * Real.log x ^ k < |Chebyshev.psi x - x| ``

