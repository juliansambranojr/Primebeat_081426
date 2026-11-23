# What `StepsRate.rate_upper` rests on

[`StepsRate.rate_upper`](../lean_stage3/StepsRate.md#StepsRate-rate_upper) in `lean_stage3/Stage3/StepsRate.lean`, line 85.

**Why.** The size rate, from above. At a point `s` with `0 < Re s ≤ 1` that is not a zero, if every zero below the height `T` has real part at most `Θ` and `Re s ≤ Θ`, the turned steps to the cutoff `N` less their smooth term are at most a sum over the zeros below `T`, free of `N`, times `N^(Θ − Re s)`, plus the error of `peak_formula`.

**Proves**

```lean
‖S N s - K N s 1‖ ≤ (∑ ρ ∈ FiniteOffLine.ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) / ‖(ρ : ℂ)‖ * ((‖s‖ / ‖(ρ : ℂ) - s‖ + ‖s - 1‖ / ‖(ρ : ℂ) - s + 1‖) * 2)) * (N : ℝ) ^ (Θ - s.re) + (‖s‖ + ‖s - 1‖) * (ExplicitTwo.c1t * N * Real.log ((N:ℝ) * T) ^ 2 / T + C1 s.re)
```

**Needs** (its hypotheses)

  - `` hN : 2 ≤ N ``
  - `` hs : 0 < s.re ``
  - `` hs1 : s.re ≤ 1 ``
  - `` hT : 2 ≤ T ``
  - `` hsΘ : s.re ≤ Θ ``
  - `` hΘ : ∀ ρ ∈ FiniteOffLine.ZF T, (ρ : ℂ).re ≤ Θ ``
  - `` hne : ∀ ρ ∈ FiniteOffLine.ZF T, (ρ : ℂ) ≠ s ``

Behind it: 199 theorems and 41 definitions in 21 files. Every one is listed below; Lean recorded each step.

## The files it passes through

```mermaid
flowchart LR
  f0["<b>Assembly</b><br/>1 used"]:::thm
  f1["<b>FiniteOffLine</b><br/>4 used"]:::thm
  f2["<b>Glue</b><br/>1 used"]:::thm
  f3["<b>JensenCount</b><br/>17 used"]:::thm
  f4["<b>ContourShift</b><br/>28 used"]:::thm
  f5["<b>LeftKernel</b><br/>9 used"]:::thm
  f6["<b>LeftSmooth</b><br/>47 used"]:::thm
  f7["<b>CellFixedRow</b><br/>1 used"]:::thm
  f8["<b>LineBound</b><br/>4 used"]:::thm
  f9["<b>PerronKernel</b><br/>25 used"]:::thm
  f10["<b>PerronTwo</b><br/>10 used"]:::thm
  f11["<b>PiZeros</b><br/>3 used"]:::thm
  f12["<b>ZetaGrowth</b><br/>20 used"]:::thm
  f13["<b>BoxBounds</b><br/>3 used"]:::thm
  f14["<b>EdgeBound</b><br/>14 used"]:::thm
  f15["<b>EdgeNum</b><br/>9 used"]:::thm
  f16["<b>GlueNum</b><br/>6 used"]:::thm
  f17["<b>ExplicitTwo</b><br/>16 used"]:::thm
  f18["<b>FixedRowTwo</b><br/>3 used"]:::thm
  f19["<b>StepsPeak</b><br/>18 used"]:::thm
  f20["<b>StepsRate</b><br/>rate_upper"]:::end_
  f0 --> f4
  f3 --> f4
  f2 --> f6
  f4 --> f6
  f5 --> f6
  f6 --> f7
  f9 --> f10
  f0 --> f11
  f1 --> f11
  f4 --> f12
  f12 --> f13
  f12 --> f14
  f13 --> f15
  f14 --> f15
  f15 --> f16
  f6 --> f17
  f8 --> f17
  f10 --> f17
  f16 --> f17
  f7 --> f18
  f17 --> f18
  f11 --> f19
  f18 --> f19
  f19 --> f20
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

### [`Assembly`](../lean_stage3/Assembly.md) — 1

- [`Stage3.zeroPartialSum`](../lean_stage3/Assembly.md#Stage3-zeroPartialSum) — *def*

### [`FiniteOffLine`](../lean_stage3/FiniteOffLine.md) — 4

- ★ [`FiniteOffLine.ZF`](../lean_stage3/FiniteOffLine.md#FiniteOffLine-ZF) — *def*
- [`FiniteOffLine.mem_ZF`](../lean_stage3/FiniteOffLine.md#FiniteOffLine-mem_ZF) — `` ρ ∈ ZF T ↔ |(ρ : ℂ).im| < T ``
- [`FiniteOffLine.tsum_sub_eq_sum`](../lean_stage3/FiniteOffLine.md#FiniteOffLine-tsum_sub_eq_sum) — `` ∑' σ : {ρ : NontrivialZeros // |(ρ : ℂ).im| < T}, f σ.1 = ∑ ρ ∈ ZF T, f ρ ``
- ★ [`FiniteOffLine.order_nonneg`](../lean_stage3/FiniteOffLine.md#FiniteOffLine-order_nonneg) — `` (0 : ℝ) ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) ``

### [`Glue`](../lean_stage3/Glue.md) — 1

- [`Glue.Gf`](../lean_stage3/Glue.md#Glue-Gf) — *def*

### [`JensenCount`](../lean_stage3/JensenCount.md) — 17

- [`Stage3.zeta_centre_lower`](../lean_stage3/JensenCount.md#Stage3-zeta_centre_lower) — `` (1 : ℝ) / 3 ≤ ‖ζ (2 + Complex.I * T)‖ ``
- [`Stage3.zeta_disk_upper`](../lean_stage3/JensenCount.md#Stage3-zeta_disk_upper) — `` ‖ζ w‖ ≤ 28 * T ``
- [`Stage3.zeta_centre_ne_zero`](../lean_stage3/JensenCount.md#Stage3-zeta_centre_ne_zero) — `` ζ (2 + Complex.I * (T : ℂ)) ≠ 0 ``
- [`Stage3.pole_away`](../lean_stage3/JensenCount.md#Stage3-pole_away) — `` 2 * z + (2 + Complex.I * (T : ℂ)) ≠ 1 ``
- [`Stage3.pole_away_centre`](../lean_stage3/JensenCount.md#Stage3-pole_away_centre) — `` v ≠ 1 ``
- [`Stage3.zetaWindowTwo_finite`](../lean_stage3/JensenCount.md#Stage3-zetaWindowTwo_finite) — `` {ρ : ℂ | ζ ρ = 0 ∧ ‖ρ - (2 + Complex.I * (T : ℂ))‖ ≤ 2}.Finite ``
- [`Stage3.zetaWindow`](../lean_stage3/JensenCount.md#Stage3-zetaWindow) — *def*
- [`Stage3.zetaWindow_finite`](../lean_stage3/JensenCount.md#Stage3-zetaWindow_finite) — `` (zetaWindow T).Finite ``
- [`Stage3.jensenF`](../lean_stage3/JensenCount.md#Stage3-jensenF) — *def*
- [`Stage3.zeta_comp_analytic`](../lean_stage3/JensenCount.md#Stage3-zeta_comp_analytic) — `` AnalyticAt ℂ (fun z : ℂ => ζ (2 * z + (2 + Complex.I * (T : ℂ)))) w ``
- [`Stage3.jensenF_analytic`](../lean_stage3/JensenCount.md#Stage3-jensenF_analytic) — `` AnalyticOnNhd ℂ (jensenF T) (Metric.closedBall (0 : ℂ) 1) ``
- [`Stage3.jensenF_zero_eq_one`](../lean_stage3/JensenCount.md#Stage3-jensenF_zero_eq_one) — `` jensenF T 0 = 1 ``
- [`Stage3.jensenF_zeros_finite`](../lean_stage3/JensenCount.md#Stage3-jensenF_zeros_finite) — `` (SetOfZeros 1 (jensenF T)).Finite ``
- [`Stage3.jensenF_bound`](../lean_stage3/JensenCount.md#Stage3-jensenF_bound) — `` ‖jensenF T z‖ ≤ 84 * T ``
- [`Stage3.analyticOrderNatAt_fun_comp_affine`](../lean_stage3/JensenCount.md#Stage3-analyticOrderNatAt_fun_comp_affine) — `` analyticOrderNatAt (fun w : ℂ => g (a * w + b)) z = analyticOrderNatAt g (a * z + b) ``
- [`Stage3.jensenF_order`](../lean_stage3/JensenCount.md#Stage3-jensenF_order) — `` analyticOrderNatAt (jensenF T) w = analyticOrderNatAt ζ (2 * w + (2 + Complex.I * (T : ℂ))) ``
- [`Stage3.zeta_local_zero_count`](../lean_stage3/JensenCount.md#Stage3-zeta_local_zero_count) — `` ∑ ρ ∈ (zetaWindow_finite hT).toFinset, (analyticOrderNatAt ζ ρ : ℝ) ≤ 15 * Real.log T + 73 ``

### [`ContourShift`](../lean_stage3/ContourShift.md) — 28

- [`ContourShift.zeroGap`](../lean_stage3/ContourShift.md#ContourShift-zeroGap) — *def*
- [`ContourShift.zeroGap_pos`](../lean_stage3/ContourShift.md#ContourShift-zeroGap_pos) — `` 0 < zeroGap T ``
- [`ContourShift.zeroGap_le`](../lean_stage3/ContourShift.md#ContourShift-zeroGap_le) — `` zeroGap T ≤ 9/10 ``
- [`ContourShift.zeta_analyticAt`](../lean_stage3/ContourShift.md#ContourShift-zeta_analyticAt) — `` AnalyticAt ℂ riemannZeta ρ ``
- [`ContourShift.one_le_zeta_order`](../lean_stage3/ContourShift.md#ContourShift-one_le_zeta_order) — `` 1 ≤ analyticOrderNatAt riemannZeta ρ ``
- [`ContourShift.partner_zero`](../lean_stage3/ContourShift.md#ContourShift-partner_zero) — `` ∃ ρ' : ℂ, riemannZeta ρ' = 0 ∧ ρ'.im = ρ.im ∧ 1/2 ≤ ρ'.re ∧ ρ'.re < 1 ``
- [`ContourShift.mem_zetaWindow`](../lean_stage3/ContourShift.md#ContourShift-mem_zetaWindow) — `` ρ ∈ Stage3.zetaWindow T₀ ``
- [`ContourShift.goodT_exists`](../lean_stage3/ContourShift.md#ContourShift-goodT_exists) — `` ∃ T' ∈ Set.Icc T (T+1), ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → zeroGap T ≤ |ρ.im - T'| ``
- [`ContourShift.borderIntegrable_sum_poles`](../lean_stage3/ContourShift.md#ContourShift-borderIntegrable_sum_poles) — `` RectangleBorderIntegrable (fun s ↦ ∑ p ∈ P, A p / (s - p)) z w ``
- [`ContourShift.rectangleIntegral_sum_poles`](../lean_stage3/ContourShift.md#ContourShift-rectangleIntegral_sum_poles) — `` RectangleIntegral' (fun s ↦ ∑ p ∈ P, A p / (s - p)) z w = ∑ p ∈ P, A p ``
- [`ContourShift.residue_rectangle_multi`](../lean_stage3/ContourShift.md#ContourShift-residue_rectangle_multi) — `` RectangleIntegral' f z w = ∑ p ∈ P, A p ``
- [`ContourShift.residue_rectangle_of_local`](../lean_stage3/ContourShift.md#ContourShift-residue_rectangle_of_local) — `` RectangleIntegral' f z w = ∑ p ∈ P, A p ``
- [`ContourShift.analyticAt_dslope`](../lean_stage3/ContourShift.md#ContourShift-analyticAt_dslope) — `` AnalyticAt ℂ (dslope f p) p ``
- [`ContourShift.div_sub_eq_dslope`](../lean_stage3/ContourShift.md#ContourShift-div_sub_eq_dslope) — `` f s / (s - p) = f p / (s - p) + dslope f p s ``
- [`ContourShift.zeta_local_data`](../lean_stage3/ContourShift.md#ContourShift-zeta_local_data) — `` ∃ h : ℂ → ℂ, AnalyticAt ℂ h p ∧ ∀ᶠ s in nhdsWithin p {p}ᶜ, - deriv riemannZeta s / riemannZeta s * ((x:ℝ):ℂ) ^ s / s = h s + (-(n:ℂ) * ((x:ℝ):ℂ) ^ p / p) / (s -… ``
- [`ContourShift.zeta_order_ne_top`](../lean_stage3/ContourShift.md#ContourShift-zeta_order_ne_top) — `` analyticOrderAt riemannZeta ρ ≠ ⊤ ``
- [`ContourShift.zeta_local_data_zero`](../lean_stage3/ContourShift.md#ContourShift-zeta_local_data_zero) — `` ∃ h : ℂ → ℂ, AnalyticAt ℂ h ρ ∧ ∀ᶠ s in nhdsWithin ρ {ρ}ᶜ, - deriv riemannZeta s / riemannZeta s * ((x:ℝ):ℂ) ^ s / s = h s + (-(analyticOrderNatAt riemannZeta ρ… ``
- [`ContourShift.zeta_local_data_one`](../lean_stage3/ContourShift.md#ContourShift-zeta_local_data_one) — `` ∃ h : ℂ → ℂ, AnalyticAt ℂ h 1 ∧ ∀ᶠ s in nhdsWithin 1 {1}ᶜ, - deriv riemannZeta s / riemannZeta s * ((x:ℝ):ℂ) ^ s / s = h s + ((x:ℝ):ℂ) / (s - 1) ``
- [`ContourShift.zeta_local_data_origin`](../lean_stage3/ContourShift.md#ContourShift-zeta_local_data_origin) — `` ∃ h : ℂ → ℂ, AnalyticAt ℂ h 0 ∧ ∀ᶠ s in nhdsWithin 0 {0}ᶜ, - deriv riemannZeta s / riemannZeta s * ((x:ℝ):ℂ) ^ s / s = h s + (- deriv riemannZeta 0 / riemannZet… ``
- [`ContourShift.zeta_ne_zero_of_re_mem`](../lean_stage3/ContourShift.md#ContourShift-zeta_ne_zero_of_re_mem) — `` riemannZeta w ≠ 0 ``
- [`ContourShift.sq_mul_zeta_analyticAt_one`](../lean_stage3/ContourShift.md#ContourShift-sq_mul_zeta_analyticAt_one) — `` AnalyticAt ℂ (fun s ↦ (s - 1)^2 * riemannZeta s) 1 ``
- [`ContourShift.zeta_meromorphicOn`](../lean_stage3/ContourShift.md#ContourShift-zeta_meromorphicOn) — `` MeromorphicOn riemannZeta U ``
- [`ContourShift.zeta_zeros_rectangle_finite`](../lean_stage3/ContourShift.md#ContourShift-zeta_zeros_rectangle_finite) — `` {ρ : ℂ | riemannZeta ρ = 0 ∧ ρ ∈ Rectangle z w}.Finite ``
- [`ContourShift.order_bridge`](../lean_stage3/ContourShift.md#ContourShift-order_bridge) — `` ((riemannZeta.order ρ : ℤ) : ℂ) = ((analyticOrderNatAt riemannZeta ρ : ℕ) : ℂ) ``
- [`ContourShift.zeroPartialSum_eq_sum`](../lean_stage3/ContourShift.md#ContourShift-zeroPartialSum_eq_sum) — `` Stage3.zeroPartialSum x T' = ∑ p ∈ ZF, ((analyticOrderNatAt riemannZeta p : ℂ) * ((x : ℂ) ^ p / p)) ``
- [`ContourShift.analyticAt_conj_conj`](../lean_stage3/ContourShift.md#ContourShift-analyticAt_conj_conj) — `` AnalyticAt ℂ (fun w ↦ (starRingEnd ℂ) (g ((starRingEnd ℂ) w))) ((starRingEnd ℂ) p) ``
- [`ContourShift.zeta_order_conj`](../lean_stage3/ContourShift.md#ContourShift-zeta_order_conj) — `` analyticOrderNatAt riemannZeta ((starRingEnd ℂ) ρ) = analyticOrderNatAt riemannZeta ρ ``
- [`ContourShift.zeta_order_reflect`](../lean_stage3/ContourShift.md#ContourShift-zeta_order_reflect) — `` analyticOrderNatAt riemannZeta (1 - (starRingEnd ℂ) ρ) = analyticOrderNatAt riemannZeta ρ ``

### [`LeftKernel`](../lean_stage3/LeftKernel.md) — 9

- [`LeftKernel.cpow_tI`](../lean_stage3/LeftKernel.md#LeftKernel-cpow_tI) — `` (y:ℂ) ^ ((t:ℂ) * Complex.I) = Complex.exp ((Real.log y : ℂ) * ((t:ℂ) * Complex.I)) ``
- [`LeftKernel.norm_exp_tI`](../lean_stage3/LeftKernel.md#LeftKernel-norm_exp_tI) — `` ‖Complex.exp ((L:ℂ) * ((t:ℂ) * Complex.I))‖ = 1 ``
- [`LeftKernel.norm_cpow_tI`](../lean_stage3/LeftKernel.md#LeftKernel-norm_cpow_tI) — `` ‖(y:ℂ) ^ ((t:ℂ) * Complex.I)‖ = 1 ``
- [`LeftKernel.osc_by_parts`](../lean_stage3/LeftKernel.md#LeftKernel-osc_by_parts) — `` ‖∫ t in a..b, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) * h t‖ ≤ (‖h a‖ + ‖h b‖ + ∫ t in a..b, ‖h' t‖) / Real.log y ``
- [`LeftKernel.kernel_bound`](../lean_stage3/LeftKernel.md#LeftKernel-kernel_bound) — `` ‖∫ t in (-T)..T, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) / ((a:ℂ) + (t:ℂ) * Complex.I)‖ ≤ (2 / T + Real.pi / |a|) / Real.log y ``
- [`LeftKernel.vmTerm`](../lean_stage3/LeftKernel.md#LeftKernel-vmTerm) — *def*
- [`LeftKernel.vmTerm_nonneg`](../lean_stage3/LeftKernel.md#LeftKernel-vmTerm_nonneg) — `` 0 ≤ vmTerm n ``
- [`LeftKernel.Bser`](../lean_stage3/LeftKernel.md#LeftKernel-Bser) — *def*
- [`LeftKernel.series_side`](../lean_stage3/LeftKernel.md#LeftKernel-series_side) — `` ‖∫ t in (-T)..T, (deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I) / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)) * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)) … ``

### [`LeftSmooth`](../lean_stage3/LeftSmooth.md) — 47

- [`LeftSmooth.arctan_int_le`](../lean_stage3/LeftSmooth.md#LeftSmooth-arctan_int_le) — `` (∫ t in (-T)..T, 1 / (a ^ 2 + t ^ 2)) ≤ Real.pi / a ``
- [`LeftSmooth.kernel_conj`](../lean_stage3/LeftSmooth.md#LeftSmooth-kernel_conj) — `` ‖∫ t in (-T)..T, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) * ((c:ℂ) - (t:ℂ) * Complex.I)⁻¹‖ ≤ (2 + Real.pi) / (c * Real.log y) ``
- [`LeftSmooth.cos_sq_le_norm_cos`](../lean_stage3/LeftSmooth.md#LeftSmooth-cos_sq_le_norm_cos) — `` Real.cos a ^ 2 + b ^ 2 ≤ ‖Complex.cos ((a:ℂ) + (b:ℂ) * Complex.I)‖ ^ 2 ``
- [`LeftSmooth.cos_sq_mul_norm_sin_le`](../lean_stage3/LeftSmooth.md#LeftSmooth-cos_sq_mul_norm_sin_le) — `` Real.cos a ^ 2 * ‖Complex.sin ((a:ℂ) + (b:ℂ) * Complex.I)‖ ^ 2 ≤ ‖Complex.cos ((a:ℂ) + (b:ℂ) * Complex.I)‖ ^ 2 ``
- [`LeftSmooth.Gs`](../lean_stage3/LeftSmooth.md#LeftSmooth-Gs) — *def*
- [`LeftSmooth.logDeriv_sum`](../lean_stage3/LeftSmooth.md#LeftSmooth-logDeriv_sum) — `` riemannZeta (1 - w) ≠ 0 ∧ deriv riemannZeta (1 - w) / riemannZeta (1 - w) + deriv riemannZeta w / riemannZeta w = Gs w ``
- [`LeftSmooth.sL`](../lean_stage3/LeftSmooth.md#LeftSmooth-sL) — *def*
- [`LeftSmooth.wL`](../lean_stage3/LeftSmooth.md#LeftSmooth-wL) — *def*
- [`LeftSmooth.one_sub_wL`](../lean_stage3/LeftSmooth.md#LeftSmooth-one_sub_wL) — `` 1 - wL t = sL t ``
- [`LeftSmooth.wL_re`](../lean_stage3/LeftSmooth.md#LeftSmooth-wL_re) — `` (wL t).re = 5/4 ``
- [`LeftSmooth.norm_sL_sq`](../lean_stage3/LeftSmooth.md#LeftSmooth-norm_sL_sq) — `` ‖sL t‖ ^ 2 = 1/16 + t ^ 2 ``
- [`LeftSmooth.norm_sL_ge`](../lean_stage3/LeftSmooth.md#LeftSmooth-norm_sL_ge) — `` 1/4 ≤ ‖sL t‖ ``
- [`LeftSmooth.sL_ne`](../lean_stage3/LeftSmooth.md#LeftSmooth-sL_ne) — `` sL t ≠ 0 ``
- [`LeftSmooth.arg_wL`](../lean_stage3/LeftSmooth.md#LeftSmooth-arg_wL) — `` (Real.pi:ℂ) * wL t / 2 = ((5 * Real.pi / 8 : ℝ):ℂ) + ((-(Real.pi * t / 2)) : ℝ) * Complex.I ``
- [`LeftSmooth.kc`](../lean_stage3/LeftSmooth.md#LeftSmooth-kc) — *def*
- [`LeftSmooth.kc_pos`](../lean_stage3/LeftSmooth.md#LeftSmooth-kc_pos) — `` 0 < kc ``
- [`LeftSmooth.norm_cos_wL`](../lean_stage3/LeftSmooth.md#LeftSmooth-norm_cos_wL) — `` kc ^ 2 + t ^ 2 ≤ ‖Complex.cos ((Real.pi:ℂ) * wL t / 2)‖ ^ 2 ``
- [`LeftSmooth.cos_wL_ne`](../lean_stage3/LeftSmooth.md#LeftSmooth-cos_wL_ne) — `` Complex.cos ((Real.pi:ℂ) * wL t / 2) ≠ 0 ``
- [`LeftSmooth.norm_tan_wL`](../lean_stage3/LeftSmooth.md#LeftSmooth-norm_tan_wL) — `` ‖Complex.tan ((Real.pi:ℂ) * wL t / 2)‖ ≤ 1 / kc ``
- [`LeftSmooth.hasDerivAt_wL`](../lean_stage3/LeftSmooth.md#LeftSmooth-hasDerivAt_wL) — `` HasDerivAt wL (-Complex.I) t ``
- [`LeftSmooth.hasDerivAt_sL`](../lean_stage3/LeftSmooth.md#LeftSmooth-hasDerivAt_sL) — `` HasDerivAt sL Complex.I t ``
- [`LeftSmooth.continuous_sL`](../lean_stage3/LeftSmooth.md#LeftSmooth-continuous_sL) — `` Continuous sL ``
- [`LeftSmooth.continuous_wL`](../lean_stage3/LeftSmooth.md#LeftSmooth-continuous_wL) — `` Continuous wL ``
- [`LeftSmooth.tanPiece`](../lean_stage3/LeftSmooth.md#LeftSmooth-tanPiece) — *def*
- [`LeftSmooth.tanPiece'`](../lean_stage3/LeftSmooth.md#LeftSmooth-tanPiece-) — *def*
- [`LeftSmooth.hasDerivAt_tanPiece`](../lean_stage3/LeftSmooth.md#LeftSmooth-hasDerivAt_tanPiece) — `` HasDerivAt tanPiece (tanPiece' t) t ``
- [`LeftSmooth.norm_tanPiece'_le`](../lean_stage3/LeftSmooth.md#LeftSmooth-norm_tanPiece-_le) — `` ‖tanPiece' t‖ ≤ 2 * Real.pi * (1 / (kc ^ 2 + t ^ 2)) + (1 / kc) * (1 / ((1/4:ℝ) ^ 2 + t ^ 2)) ``
- [`LeftSmooth.tan_piece`](../lean_stage3/LeftSmooth.md#LeftSmooth-tan_piece) — `` ‖∫ t in (-T)..T, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) * tanPiece t‖ ≤ (8 + 2 * Real.pi ^ 2 + 4 * Real.pi) / (kc * Real.log y) ``
- [`LeftSmooth.dgTerm`](../lean_stage3/LeftSmooth.md#LeftSmooth-dgTerm) — *def*
- [`LeftSmooth.dgTerm_nonneg`](../lean_stage3/LeftSmooth.md#LeftSmooth-dgTerm_nonneg) — `` 0 ≤ dgTerm n ``
- [`LeftSmooth.dgTerm_summable`](../lean_stage3/LeftSmooth.md#LeftSmooth-dgTerm_summable) — `` Summable dgTerm ``
- [`LeftSmooth.continuous_cpow_tI`](../lean_stage3/LeftSmooth.md#LeftSmooth-continuous_cpow_tI) — `` Continuous fun t : ℝ => (y:ℂ) ^ ((t:ℂ) * Complex.I) ``
- [`LeftSmooth.digamma_piece`](../lean_stage3/LeftSmooth.md#LeftSmooth-digamma_piece) — `` ‖∫ t in (-T)..T, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) * ((-Complex.digamma (wL t) - (Real.eulerMascheroniConstant:ℂ)) * (sL t)⁻¹)‖ ≤ (∑' n : ℕ, dgTerm n) * ((2 + Real.… ``
- [`LeftSmooth.continuous_tanPiece`](../lean_stage3/LeftSmooth.md#LeftSmooth-continuous_tanPiece) — `` Continuous tanPiece ``
- [`LeftSmooth.cpow_sL`](../lean_stage3/LeftSmooth.md#LeftSmooth-cpow_sL) — `` (x:ℂ) ^ (sL t) = ((x ^ (-(1:ℝ)/4) : ℝ):ℂ) * (x:ℂ) ^ ((t:ℂ) * Complex.I) ``
- [`LeftSmooth.c0`](../lean_stage3/LeftSmooth.md#LeftSmooth-c0) — *def*
- [`LeftSmooth.Nsm`](../lean_stage3/LeftSmooth.md#LeftSmooth-Nsm) — *def*
- [`LeftSmooth.Nsm_nonneg`](../lean_stage3/LeftSmooth.md#LeftSmooth-Nsm_nonneg) — `` 0 ≤ Nsm ``
- [`LeftSmooth.Bsm`](../lean_stage3/LeftSmooth.md#LeftSmooth-Bsm) — *def*
- [`LeftSmooth.smooth_side`](../lean_stage3/LeftSmooth.md#LeftSmooth-smooth_side) — `` ‖∫ t in (-T)..T, (deriv riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I) / riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I) + deriv riemannZeta ((5/4:ℂ) - (t:ℂ)… ``
- [`LeftSmooth.continuous_logDeriv_path`](../lean_stage3/LeftSmooth.md#LeftSmooth-continuous_logDeriv_path) — `` Continuous fun t => deriv riemannZeta (p t) / riemannZeta (p t) ``
- [`LeftSmooth.zeta_sL_ne`](../lean_stage3/LeftSmooth.md#LeftSmooth-zeta_sL_ne) — `` riemannZeta (sL t) ≠ 0 ``
- [`LeftSmooth.zeta_wL_ne`](../lean_stage3/LeftSmooth.md#LeftSmooth-zeta_wL_ne) — `` riemannZeta (wL t) ≠ 0 ``
- [`LeftSmooth.sL_ne_one`](../lean_stage3/LeftSmooth.md#LeftSmooth-sL_ne_one) — `` sL t ≠ 1 ``
- [`LeftSmooth.wL_ne_one`](../lean_stage3/LeftSmooth.md#LeftSmooth-wL_ne_one) — `` wL t ≠ 1 ``
- [`LeftSmooth.Bleft`](../lean_stage3/LeftSmooth.md#LeftSmooth-Bleft) — *def*
- [`LeftSmooth.left_edge_bound`](../lean_stage3/LeftSmooth.md#LeftSmooth-left_edge_bound) — `` ‖VIntegral (Glue.Gf x) (-1/4) (-T) T‖ ≤ Bleft * x ^ (-(1:ℝ)/4) ``

### [`CellFixedRow`](../lean_stage3/CellFixedRow.md) — 1

- [`CellFixedRow.Bleft_nonneg`](../lean_stage3/CellFixedRow.md#CellFixedRow-Bleft_nonneg) — `` 0 ≤ LeftSmooth.Bleft ``

### [`LineBound`](../lean_stage3/LineBound.md) — 4

- [`Slice5.pseries_tail_le`](../lean_stage3/LineBound.md#Slice5-pseries_tail_le) — `` ∑' (n : ℕ), ((n + 1 + 1 : ℕ) : ℝ) ^ (-1 - b) ≤ 1 / b ``
- [`Slice5.pseries_le`](../lean_stage3/LineBound.md#Slice5-pseries_le) — `` ∑' (n : ℕ), ((n : ℝ)) ^ (-1 - b) ≤ 1 + 1 / b ``
- [`Slice5.vonMangoldt_term_le`](../lean_stage3/LineBound.md#Slice5-vonMangoldt_term_le) — `` ‖LSeries.term (fun k : ℕ => ((vonMangoldt k : ℝ) : ℂ)) ((1 + 2 * b : ℝ) : ℂ) n‖ ≤ (1 / b) * ((n : ℝ)) ^ (-1 - b) ``
- [`Slice5.norm_logDerivZeta_of_one_lt_re`](../lean_stage3/LineBound.md#Slice5-norm_logDerivZeta_of_one_lt_re) — `` ‖deriv ζ s / ζ s‖ ≤ 2 / (s.re - 1) + 4 / (s.re - 1) ^ 2 ``

### [`PerronKernel`](../lean_stage3/PerronKernel.md) — 25

- [`PerronKernel.perronI`](../lean_stage3/PerronKernel.md#PerronKernel-perronI) — *def*
- [`PerronKernel.perronδ`](../lean_stage3/PerronKernel.md#PerronKernel-perron-) — *def*
- [`PerronKernel.perronI_eq_VIntegral'`](../lean_stage3/PerronKernel.md#PerronKernel-perronI_eq_VIntegral-) — `` perronI y c T = VIntegral' (fun s : ℂ ↦ (y : ℂ) ^ s / s) c (-T) T ``
- [`PerronKernel.kernel_holo`](../lean_stage3/PerronKernel.md#PerronKernel-kernel_holo) — `` HolomorphicOn (fun s : ℂ ↦ (y : ℂ) ^ s / s) {s : ℂ | 0 < s.re} ``
- [`PerronKernel.rect_subset_right`](../lean_stage3/PerronKernel.md#PerronKernel-rect_subset_right) — `` Rectangle ((c : ℂ) - Complex.I * T) ((X : ℂ) + Complex.I * T) ⊆ {s : ℂ | 0 < s.re} ``
- [`PerronKernel.perron_kernel_coarse_lt`](../lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_coarse_lt) — `` ‖perronI y c T - perronδ y‖ ≤ y ^ c ``
- [`PerronKernel.horiz_bound`](../lean_stage3/PerronKernel.md#PerronKernel-horiz_bound) — `` ‖∫ σ in a..b, (y : ℂ) ^ ((σ : ℂ) + (T' : ℂ) * Complex.I) / ((σ : ℂ) + (T' : ℂ) * Complex.I)‖ ≤ max (y ^ a) (y ^ b) / (|T'| * |Real.log y|) ``
- [`PerronKernel.perron_kernel_decay_lt`](../lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_decay_lt) — `` ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * |Real.log y|) ``
- [`PerronKernel.dslope_kernel_diff`](../lean_stage3/PerronKernel.md#PerronKernel-dslope_kernel_diff) — `` Differentiable ℂ (dslope (fun s : ℂ ↦ (y : ℂ) ^ s) 0) ``
- [`PerronKernel.rect_residue`](../lean_stage3/PerronKernel.md#PerronKernel-rect_residue) — `` RectangleIntegral' (fun s : ℂ ↦ (y : ℂ) ^ s / s) (-(X:ℂ) - Complex.I * T) ((c:ℂ) + Complex.I * T) = 1 ``
- [`PerronKernel.perron_kernel_decay_gt`](../lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_decay_gt) — `` ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * |Real.log y|) ``
- [`PerronKernel.perron_kernel_decay`](../lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_decay) — `` ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * |Real.log y|) ``
- [`PerronKernel.coarse_gt_ineq`](../lean_stage3/PerronKernel.md#PerronKernel-coarse_gt_ineq) — `` v * Real.exp u + Real.pi - Real.arctan (v / u) ≤ Real.pi * Real.exp u ``
- [`PerronKernel.seg_inv_integral`](../lean_stage3/PerronKernel.md#PerronKernel-seg_inv_integral) — `` (∫ t in (-T)..T, ((c : ℂ) + Complex.I * t)⁻¹ * Complex.I) = 2 * Real.arctan (T / c) * Complex.I ``
- [`PerronKernel.cpow_sub_one_bound`](../lean_stage3/PerronKernel.md#PerronKernel-cpow_sub_one_bound) — `` ‖(y : ℂ) ^ s - 1‖ ≤ ‖s‖ * Real.log y * y ^ s.re ``
- [`PerronKernel.perron_kernel_coarse_gt`](../lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_coarse_gt) — `` ‖perronI y c T - perronδ y‖ ≤ y ^ c ``
- [`PerronKernel.perron_kernel_coarse`](../lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_coarse) — `` ‖perronI y c T - perronδ y‖ ≤ y ^ c ``
- [`PerronKernel.perron_kernel_truncated`](../lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_truncated) — `` ‖perronI y c T - perronδ y‖ ≤ y ^ c * min 1 (1 / (T * |Real.log y|)) ``
- [`PerronKernel.one_sub_two_neg_rpow`](../lean_stage3/PerronKernel.md#PerronKernel-one_sub_two_neg_rpow) — `` δ / 5 ≤ 1 - (2:ℝ) ^ (-δ) ``
- [`PerronKernel.vonMangoldt_rpow_partial`](../lean_stage3/PerronKernel.md#PerronKernel-vonMangoldt_rpow_partial) — `` ∑ n ∈ s, ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c) ≤ 2 * (Real.log 4 + 4) / (1 - (2:ℝ) ^ (1 - c)) ``
- [`PerronKernel.vonMangoldt_rpow_tsum`](../lean_stage3/PerronKernel.md#PerronKernel-vonMangoldt_rpow_tsum) — `` ∑' n : ℕ, ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c) ≤ 2 * (Real.log 4 + 4) / (1 - (2:ℝ) ^ (1 - c)) ``
- [`PerronKernel.vonMangoldt_rpow_summable`](../lean_stage3/PerronKernel.md#PerronKernel-vonMangoldt_rpow_summable) — `` Summable (fun n : ℕ ↦ ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c)) ``
- [`PerronKernel.abs_sub_one_le_two_abs_log`](../lean_stage3/PerronKernel.md#PerronKernel-abs_sub_one_le_two_abs_log) — `` |t - 1| / 2 ≤ |Real.log t| ``
- [`PerronKernel.perronI_one_norm`](../lean_stage3/PerronKernel.md#PerronKernel-perronI_one_norm) — `` ‖perronI 1 c T‖ ≤ 1/2 ``
- [`PerronKernel.tsum_vonMangoldt_div_cpow`](../lean_stage3/PerronKernel.md#PerronKernel-tsum_vonMangoldt_div_cpow) — `` (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * ((x / n : ℝ) : ℂ) ^ s) = (- deriv riemannZeta s / riemannZeta s) * ((x:ℝ):ℂ) ^ s ``

### [`PerronTwo`](../lean_stage3/PerronTwo.md) — 10

- [`PerronTwo.one_sub_two_neg_rpow'`](../lean_stage3/PerronTwo.md#PerronTwo-one_sub_two_neg_rpow-) — `` δ / 5 ≤ 1 - (2:ℝ) ^ (-δ) ``
- [`PerronTwo.inv_log_le_of_two_le`](../lean_stage3/PerronTwo.md#PerronTwo-inv_log_le_of_two_le) — `` 1 / Real.log x ≤ 3/2 ``
- [`PerronTwo.far_terms_sum_two`](../lean_stage3/PerronTwo.md#PerronTwo-far_terms_sum_two) — `` (∑' n : ℕ, if 1/2 ≤ |Real.log (x / n)| then ArithmeticFunction.vonMangoldt n * (x / n) ^ (1 + 1/Real.log x) / (T * |Real.log (x / n)|) else 0) ≤ 300 * x * Real.… ``
- [`PerronTwo.near_diagonal_sum_two`](../lean_stage3/PerronTwo.md#PerronTwo-near_diagonal_sum_two) — `` (∑' n : ℕ, if 0 < |Real.log (x / n)| ∧ |Real.log (x / n)| < 1/2 then ArithmeticFunction.vonMangoldt n * min 1 (1/(T * |Real.log (x / n)|)) else 0) ≤ 100 * x * R… ``
- [`PerronTwo.kernel_sum_bound_two`](../lean_stage3/PerronTwo.md#PerronTwo-kernel_sum_bound_two) — `` ‖(∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * (perronI (x/n) (1 + 1/Real.log x) T - perronδ (x/n)))‖ ≤ 700 * x * Real.log (x * T) ^ 2 / T + 17 * Real.log… ``
- [`PerronTwo.delta_sum_close_two`](../lean_stage3/PerronTwo.md#PerronTwo-delta_sum_close_two) — `` ‖(Chebyshev.psi x : ℂ) - ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronδ (x / n)‖ ≤ Real.log x ``
- [`PerronTwo.kernel_diff_summable_two`](../lean_stage3/PerronTwo.md#PerronTwo-kernel_diff_summable_two) — `` Summable (fun n : ℕ ↦ (ArithmeticFunction.vonMangoldt n : ℂ) * (perronI (x/n) (1 + 1/Real.log x) T - perronδ (x/n))) ``
- [`PerronTwo.perron_to_psi_two`](../lean_stage3/PerronTwo.md#PerronTwo-perron_to_psi_two) — `` ‖(Chebyshev.psi x : ℂ) - ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronI (x/n) (1 + 1/Real.log x) T‖ ≤ 700 * x * Real.log (x * T) ^ 2 / T + 18 * Real… ``
- [`PerronTwo.perron_sum_eq_integral_two`](../lean_stage3/PerronTwo.md#PerronTwo-perron_sum_eq_integral_two) — `` (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronI (x/n) (1 + 1/Real.log x) T) = (2 * (Real.pi:ℂ) * Complex.I)⁻¹ * ∫ t in (-T)..T, (- deriv riemannZeta… ``
- [`PerronTwo.explicit_formula_perron_two`](../lean_stage3/PerronTwo.md#PerronTwo-explicit_formula_perron_two) — `` ‖(Chebyshev.psi x : ℂ) - (2 * (Real.pi:ℂ) * Complex.I)⁻¹ * ∫ t in (-T)..T, (- deriv riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t) / riemannZeta (((1 … ``

### [`PiZeros`](../lean_stage3/PiZeros.md) — 3

- [`PiZeros.efRem`](../lean_stage3/PiZeros.md#PiZeros-efRem) — *def*
- [`PiZeros.zeroPartialSum_eq_sum`](../lean_stage3/PiZeros.md#PiZeros-zeroPartialSum_eq_sum) — `` Stage3.zeroPartialSum t T = ∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ)) ``
- [`PiZeros.integrable_ofReal_of_monotone`](../lean_stage3/PiZeros.md#PiZeros-integrable_ofReal_of_monotone) — `` IntervalIntegrable (fun t => ((f t : ℝ) : ℂ)) volume 2 x ``

### [`ZetaGrowth`](../lean_stage3/ZetaGrowth.md) — 20

- [`ZetaGrowth.emA`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-emA) — *def*
- [`ZetaGrowth.emA_nonneg`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-emA_nonneg) — `` 0 ≤ emA x ``
- [`ZetaGrowth.emA_le`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-emA_le) — `` emA x ≤ 1/8 ``
- [`ZetaGrowth.emA_natCast`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-emA_natCast) — `` emA n = 0 ``
- [`ZetaGrowth.emA_eq_poly`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-emA_eq_poly) — `` emA x = ((x - n) - (x - n)^2)/2 ``
- [`ZetaGrowth.integrable_emA_tail`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-integrable_emA_tail) — `` IntegrableOn (fun x : ℝ ↦ (emA x : ℂ) * (x : ℂ) ^ (-(s+2))) (Ioi (N:ℝ)) ``
- [`ZetaGrowth.interval_ibp`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-interval_ibp) — `` ∫ x in (n:ℝ)..((n:ℝ)+1), ((⌊x⌋ : ℂ) + 1/2 - (x:ℂ)) * (x:ℂ) ^ (-(s+1)) = (s+1) * ∫ x in (n:ℝ)..((n:ℝ)+1), (emA x : ℂ) * (x:ℂ) ^ (-(s+2)) ``
- [`ZetaGrowth.tail_ibp`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-tail_ibp) — `` ∫ x in Ioi (N:ℝ), ((⌊x⌋ : ℂ) + 1/2 - (x:ℂ)) * (x:ℂ) ^ (-(s+1)) = (s+1) * ∫ x in Ioi (N:ℝ), (emA x : ℂ) * (x:ℂ) ^ (-(s+2)) ``
- [`ZetaGrowth.zeta1`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta1) — *def*
- [`ZetaGrowth.zeta1_eq_zeta`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta1_eq_zeta) — `` zeta1 N s = riemannZeta s ``
- [`ZetaGrowth.tail_differentiableAt`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-tail_differentiableAt) — `` DifferentiableAt ℂ (fun w : ℂ ↦ ∫ x in Ioi (N:ℝ), (emA x : ℂ) * (x:ℂ) ^ (-(w+2))) z ``
- [`ZetaGrowth.stripRegion`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-stripRegion) — *def*
- [`ZetaGrowth.isOpen_stripRegion`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-isOpen_stripRegion) — `` IsOpen stripRegion ``
- [`ZetaGrowth.preconnected_stripRegion`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-preconnected_stripRegion) — `` IsPreconnected stripRegion ``
- [`ZetaGrowth.zeta1_analyticOnNhd`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta1_analyticOnNhd) — `` AnalyticOnNhd ℂ (zeta1 N) stripRegion ``
- [`ZetaGrowth.zeta1_eq_zeta_strip`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta1_eq_zeta_strip) — `` Set.EqOn (zeta1 N) riemannZeta stripRegion ``
- [`ZetaGrowth.tail_norm_le`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-tail_norm_le) — `` ‖∫ x in Ioi (N:ℝ), (emA x : ℂ) * (x:ℂ) ^ (-(s+2))‖ ≤ (1/4) * (N:ℝ) ^ (-s.re - 1) ``
- [`ZetaGrowth.sum_norm_le`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-sum_norm_le) — `` ‖∑ n ∈ Finset.range N, 1 / ((n:ℂ) + 1) ^ s‖ ≤ (N:ℝ) * (N:ℝ) ^ ((1:ℝ)/2) ``
- [`ZetaGrowth.zeta_growth_strip`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta_growth_strip) — `` ‖riemannZeta s‖ ≤ 15 * |s.im| ^ 2 ``
- [`ZetaGrowth.sq_mul_zeta_analytic`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-sq_mul_zeta_analytic) — `` AnalyticAt ℂ (fun z : ℂ ↦ (z - 1)^2 * riemannZeta z) s ``

### [`BoxBounds`](../lean_stage3/BoxBounds.md) — 3

- [`BoxBounds.norm_le_of_sq`](../lean_stage3/BoxBounds.md#BoxBounds-norm_le_of_sq) — `` ‖z‖ ≤ c ``
- [`BoxBounds.sq_zeta_box`](../lean_stage3/BoxBounds.md#BoxBounds-sq_zeta_box) — `` ‖(s - 1) ^ 2 * riemannZeta s‖ ≤ 135 ``
- [`BoxBounds.sq_zeta_band_explicit`](../lean_stage3/BoxBounds.md#BoxBounds-sq_zeta_band_explicit) — `` ‖(s - 1) ^ 2 * riemannZeta s‖ ≤ 135 * (2 + |s.im|) ^ 4 ``

### [`EdgeBound`](../lean_stage3/EdgeBound.md) — 14

- [`EdgeBound.c0`](../lean_stage3/EdgeBound.md#EdgeBound-c0) — *def*
- [`EdgeBound.gz`](../lean_stage3/EdgeBound.md#EdgeBound-gz) — *def*
- [`EdgeBound.gz_analytic`](../lean_stage3/EdgeBound.md#EdgeBound-gz_analytic) — `` AnalyticAt ℂ gz s ``
- [`EdgeBound.c0_im`](../lean_stage3/EdgeBound.md#EdgeBound-c0_im) — `` (c0 T').im = T' ``
- [`EdgeBound.c0_re`](../lean_stage3/EdgeBound.md#EdgeBound-c0_re) — `` (c0 T').re = 3/2 ``
- [`EdgeBound.gz_lower`](../lean_stage3/EdgeBound.md#EdgeBound-gz_lower) — `` 4 * ‖riemannZeta 3 / riemannZeta (3/2)‖ ≤ ‖gz (c0 T')‖ ``
- [`EdgeBound.zeta_ratio_pos`](../lean_stage3/EdgeBound.md#EdgeBound-zeta_ratio_pos) — `` (0:ℝ) < ‖riemannZeta 3 / riemannZeta (3/2)‖ ``
- [`EdgeBound.gz_c0_ne`](../lean_stage3/EdgeBound.md#EdgeBound-gz_c0_ne) — `` gz (c0 T') ≠ 0 ``
- [`EdgeBound.gz_zero_cases`](../lean_stage3/EdgeBound.md#EdgeBound-gz_zero_cases) — `` w = 1 ∨ riemannZeta w = 0 ``
- [`EdgeBound.gz_zeros_ball_finite`](../lean_stage3/EdgeBound.md#EdgeBound-gz_zeros_ball_finite) — `` {w : ℂ | gz w = 0 ∧ ‖w - c0 T'‖ ≤ ρ}.Finite ``
- [`EdgeBound.gz_order_eq`](../lean_stage3/EdgeBound.md#EdgeBound-gz_order_eq) — `` analyticOrderNatAt gz w = analyticOrderNatAt riemannZeta w ``
- [`EdgeBound.ball_zero_shape`](../lean_stage3/EdgeBound.md#EdgeBound-ball_zero_shape) — `` riemannZeta w = 0 ∧ (0 < w.re ∧ w.re < 1) ∧ |w.im - T'| ≤ 46/25 ``
- [`EdgeBound.gz_logderiv`](../lean_stage3/EdgeBound.md#EdgeBound-gz_logderiv) — `` deriv gz u / gz u = 2/(u - 1) + deriv riemannZeta u / riemannZeta u ``
- [`EdgeBound.deriv_zeta_conj`](../lean_stage3/EdgeBound.md#EdgeBound-deriv_zeta_conj) — `` deriv riemannZeta ((starRingEnd ℂ) s) = (starRingEnd ℂ) (deriv riemannZeta s) ``

### [`EdgeNum`](../lean_stage3/EdgeNum.md) — 9

- [`EdgeBound.C1n`](../lean_stage3/EdgeNum.md#EdgeBound-C1n) — *def*
- [`EdgeBound.C1n_pos`](../lean_stage3/EdgeNum.md#EdgeBound-C1n_pos) — `` 0 < C1n ``
- [`EdgeBound.gz_partial_fraction_num`](../lean_stage3/EdgeNum.md#EdgeBound-gz_partial_fraction_num) — `` ∀ T' : ℝ, 2 ≤ T' → ∀ u : ℂ, u.im = T' → -1/4 ≤ u.re → u.re ≤ 2 → gz u ≠ 0 → ‖deriv gz u / gz u - ∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).t… ``
- [`EdgeBound.C2n`](../lean_stage3/EdgeNum.md#EdgeBound-C2n) — *def*
- [`EdgeBound.C2n_pos`](../lean_stage3/EdgeNum.md#EdgeBound-C2n_pos) — `` 0 < C2n ``
- [`EdgeBound.ball_order_sum_le_num`](../lean_stage3/EdgeNum.md#EdgeBound-ball_order_sum_le_num) — `` ∀ T' : ℝ, 2 ≤ T' → (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, (analyticOrderNatAt gz w : ℝ)) ≤ C2n * Real.log T' ``
- [`EdgeBound.Cen`](../lean_stage3/EdgeNum.md#EdgeBound-Cen) — *def*
- [`EdgeBound.Cen_pos`](../lean_stage3/EdgeNum.md#EdgeBound-Cen_pos) — `` 0 < Cen ``
- [`EdgeBound.edge_bound_core_num`](../lean_stage3/EdgeNum.md#EdgeBound-edge_bound_core_num) — `` ∀ t : ℝ, 2 ≤ t → ∀ u : ℂ, u.im = t → -1/4 ≤ u.re → u.re ≤ 2 → riemannZeta u ≠ 0 → ∀ δ : ℝ, 0 < δ → δ ≤ 1 → (∀ w ∈ (gz_zeros_ball_finite t (by norm_num : (0:ℝ) ≤… ``

### [`GlueNum`](../lean_stage3/GlueNum.md) — 6

- [`Glue.Csn`](../lean_stage3/GlueNum.md#Glue-Csn) — *def*
- [`Glue.Csn_pos`](../lean_stage3/GlueNum.md#Glue-Csn_pos) — `` 0 < Csn ``
- [`Glue.Cpn`](../lean_stage3/GlueNum.md#Glue-Cpn) — *def*
- [`Glue.Cpn_pos`](../lean_stage3/GlueNum.md#Glue-Cpn_pos) — `` 0 < Cpn ``
- [`Glue.band_order_sum_le_num`](../lean_stage3/GlueNum.md#Glue-band_order_sum_le_num) — `` ∀ T : ℝ, 2 ≤ T → ∀ F : Finset ℂ, (∀ ρ ∈ F, riemannZeta ρ = 0 ∧ (0 < ρ.re ∧ ρ.re < 1) ∧ T ≤ |ρ.im| ∧ |ρ.im| ≤ T + 1) → (∑ ρ ∈ F, (analyticOrderNatAt riemannZeta … ``
- [`Glue.zeta_logderiv_good_bound_num`](../lean_stage3/GlueNum.md#Glue-zeta_logderiv_good_bound_num) — `` ∀ T T' : ℝ, 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → ContourShift.zeroGap T ≤ |ρ.im - T'|) → ∀ u : ℂ, |u.im| = T' → -1/4 ≤ u.re →… ``

### [`ExplicitTwo`](../lean_stage3/ExplicitTwo.md) — 16

- [`ExplicitTwo.residue_identity_two`](../lean_stage3/ExplicitTwo.md#ExplicitTwo-residue_identity_two) — `` RectangleIntegral' (fun s : ℂ ↦ (- deriv riemannZeta s / riemannZeta s) * ((x:ℝ):ℂ) ^ s / s) (((-1/4 : ℝ):ℂ) - Complex.I * T') (((1 + 1/Real.log x : ℝ):ℂ) + Com… ``
- [`ExplicitTwo.zeroPartialSum_swap_two`](../lean_stage3/ExplicitTwo.md#ExplicitTwo-zeroPartialSum_swap_two) — `` ∀ x T T' : ℝ, 1 ≤ x → 2 ≤ T → T ≤ T' → T' ≤ T + 1 → ‖Stage3.zeroPartialSum x T' - Stage3.zeroPartialSum x T‖ ≤ Glue.Csn * x * Real.log T / T ``
- [`ExplicitTwo.logDeriv_re_ge_two`](../lean_stage3/ExplicitTwo.md#ExplicitTwo-logDeriv_re_ge_two) — `` ‖deriv riemannZeta u / riemannZeta u‖ ≤ 6 ``
- [`ExplicitTwo.Cpn_ge`](../lean_stage3/ExplicitTwo.md#ExplicitTwo-Cpn_ge) — `` (360:ℝ) ≤ Glue.Cpn ``
- [`ExplicitTwo.logDeriv_good_ext`](../lean_stage3/ExplicitTwo.md#ExplicitTwo-logDeriv_good_ext) — `` ∀ T T' : ℝ, 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → ContourShift.zeroGap T ≤ |ρ.im - T'|) → ∀ u : ℂ, |u.im| = T' → -1/4 ≤ u.re →… ``
- [`ExplicitTwo.Cht`](../lean_stage3/ExplicitTwo.md#ExplicitTwo-Cht) — *def*
- [`ExplicitTwo.Cht_pos`](../lean_stage3/ExplicitTwo.md#ExplicitTwo-Cht_pos) — `` 0 < Cht ``
- [`ExplicitTwo.edge_horizontal_bound_two`](../lean_stage3/ExplicitTwo.md#ExplicitTwo-edge_horizontal_bound_two) — `` ∀ x T T' : ℝ, 2 ≤ x → 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → ContourShift.zeroGap T ≤ |ρ.im - T'|) → ∀ y : ℝ, |y| = T' → ‖HInte… ``
- ★ [`ExplicitTwo.c1t`](../lean_stage3/ExplicitTwo.md#ExplicitTwo-c1t) — *def*
- [`ExplicitTwo.c3t`](../lean_stage3/ExplicitTwo.md#ExplicitTwo-c3t) — *def*
- [`ExplicitTwo.explicit_formula_left_two`](../lean_stage3/ExplicitTwo.md#ExplicitTwo-explicit_formula_left_two) — `` ∃ T' : ℝ, T ≤ T' ∧ T' ≤ T + 1 ∧ ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖ ≤ c1t * x * Real.log (x*T)^2 / T + c3t * Real.log x + ‖VIntegral (Gl… ``
- [`ExplicitTwo.series_side_two`](../lean_stage3/ExplicitTwo.md#ExplicitTwo-series_side_two) — `` ‖∫ t in (-T)..T, (deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I) / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)) * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)) … ``
- [`ExplicitTwo.smooth_side_two`](../lean_stage3/ExplicitTwo.md#ExplicitTwo-smooth_side_two) — `` ‖∫ t in (-T)..T, (deriv riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I) / riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I) + deriv riemannZeta ((5/4:ℂ) - (t:ℂ)… ``
- [`ExplicitTwo.Bleft2`](../lean_stage3/ExplicitTwo.md#ExplicitTwo-Bleft2) — *def*
- [`ExplicitTwo.left_edge_bound_two`](../lean_stage3/ExplicitTwo.md#ExplicitTwo-left_edge_bound_two) — `` ‖VIntegral (Glue.Gf x) (-1/4) (-T) T‖ ≤ Bleft2 * x ^ (-(1:ℝ)/4) ``
- [`ExplicitTwo.explicit_formula_all_two`](../lean_stage3/ExplicitTwo.md#ExplicitTwo-explicit_formula_all_two) — `` ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖ ≤ c1t * x * Real.log (x*T)^2 / T + c3t * Real.log x + Bleft2 * x ^ (-(1:ℝ)/4) ``

### [`FixedRowTwo`](../lean_stage3/FixedRowTwo.md) — 3

- [`FixedRowTwo.c1t_nonneg`](../lean_stage3/FixedRowTwo.md#FixedRowTwo-c1t_nonneg) — `` 0 ≤ ExplicitTwo.c1t ``
- [`FixedRowTwo.c3t_nonneg`](../lean_stage3/FixedRowTwo.md#FixedRowTwo-c3t_nonneg) — `` 0 ≤ ExplicitTwo.c3t ``
- [`FixedRowTwo.Bleft2_nonneg`](../lean_stage3/FixedRowTwo.md#FixedRowTwo-Bleft2_nonneg) — `` 0 ≤ ExplicitTwo.Bleft2 ``

### [`StepsPeak`](../lean_stage3/StepsPeak.md) — 18

- [`StepsPeak.ramp`](../lean_stage3/StepsPeak.md#StepsPeak-ramp) — *def*
- [`StepsPeak.slope`](../lean_stage3/StepsPeak.md#StepsPeak-slope) — *def*
- ★ [`StepsPeak.S`](../lean_stage3/StepsPeak.md#StepsPeak-S) — *def*
- ★ [`StepsPeak.K`](../lean_stage3/StepsPeak.md#StepsPeak-K) — *def*
- [`StepsPeak.hasDerivAt_ramp`](../lean_stage3/StepsPeak.md#StepsPeak-hasDerivAt_ramp) — `` HasDerivAt (ramp N s) (-slope N s u) u ``
- [`StepsPeak.cont_cpow`](../lean_stage3/StepsPeak.md#StepsPeak-cont_cpow) — `` ContinuousOn (fun y : ℝ => (y : ℂ) ^ c) (Set.Ioi 0) ``
- [`StepsPeak.cont_slope`](../lean_stage3/StepsPeak.md#StepsPeak-cont_slope) — `` ContinuousOn (slope N s) (Set.Ioi 0) ``
- [`StepsPeak.uIcc_sub`](../lean_stage3/StepsPeak.md#StepsPeak-uIcc_sub) — `` Set.uIcc (2:ℝ) N ⊆ Set.Ioi 0 ``
- [`StepsPeak.S_eq_integral`](../lean_stage3/StepsPeak.md#StepsPeak-S_eq_integral) — `` S N s = ∫ u in (2:ℝ)..(N:ℝ), slope N s u * ((ψ u : ℝ) : ℂ) ``
- [`StepsPeak.peak_identity`](../lean_stage3/StepsPeak.md#StepsPeak-peak_identity) — `` S N s - K N s 1 + ∑ ρ ∈ FiniteOffLine.ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * K N s (ρ : ℂ) = ∫ u in (2:ℝ)..(N:ℝ), slope N s u * PiZeros.efRem T… ``
- [`StepsPeak.norm_slope_le`](../lean_stage3/StepsPeak.md#StepsPeak-norm_slope_le) — `` ‖slope N s u‖ ≤ (‖s‖ + ‖s - 1‖) * u ^ (-s.re - 1) ``
- ★ [`StepsPeak.C1`](../lean_stage3/StepsPeak.md#StepsPeak-C1) — *def*
- [`StepsPeak.norm_integrand_le`](../lean_stage3/StepsPeak.md#StepsPeak-norm_integrand_le) — `` ‖slope N s u * PiZeros.efRem T u‖ ≤ (‖s‖ + ‖s - 1‖) * (ExplicitTwo.c1t * Real.log ((N:ℝ) * T) ^ 2 / T + (ExplicitTwo.c3t * (2 / s.re) + ExplicitTwo.Bleft2) * u … ``
- [`StepsPeak.norm_error_le`](../lean_stage3/StepsPeak.md#StepsPeak-norm_error_le) — `` ‖∫ u in (2:ℝ)..(N:ℝ), slope N s u * PiZeros.efRem T u‖ ≤ (‖s‖ + ‖s - 1‖) * (ExplicitTwo.c1t * N * Real.log ((N:ℝ) * T) ^ 2 / T + C1 s.re) ``
- ★ [`StepsPeak.peak_formula`](../lean_stage3/StepsPeak.md#StepsPeak-peak_formula) — `` ‖S N s - K N s 1 + ∑ ρ ∈ FiniteOffLine.ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * K N s (ρ : ℂ)‖ ≤ (‖s‖ + ‖s - 1‖) * (ExplicitTwo.c1t * N * Real.lo… ``
- [`StepsPeak.h0_not_mem`](../lean_stage3/StepsPeak.md#StepsPeak-h0_not_mem) — `` (0:ℝ) ∉ Set.uIcc (2:ℝ) N ``
- [`StepsPeak.K_eq`](../lean_stage3/StepsPeak.md#StepsPeak-K_eq) — `` K N s a = s * ((N:ℂ) ^ (a - s) - 2 ^ (a - s)) / (a - s) - (s - 1) * ((N:ℂ) ^ (a - s + 1) - 2 ^ (a - s + 1)) / ((a - s + 1) * N) ``
- ★ [`StepsPeak.norm_order`](../lean_stage3/StepsPeak.md#StepsPeak-norm_order) — `` ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)‖ = ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) ``

### [`StepsRate`](../lean_stage3/StepsRate.md) — 1

- ★ [`StepsRate.norm_K_le_pow`](../lean_stage3/StepsRate.md#StepsRate-norm_K_le_pow) — `` ‖K N s a‖ ≤ (‖s‖ / ‖a - s‖ + ‖s - 1‖ / ‖a - s + 1‖) * 2 * (N : ℝ) ^ δ ``

