# What `ResidueRoute.isolated_boundary_mode_false` rests on

[`ResidueRoute.isolated_boundary_mode_false`](../lean_stage3/ResidueRoute.md#ResidueRoute-isolated_boundary_mode_false) in `lean_stage3/Stage3/ResidueRoute.lean`, line 372.

**Why.** An isolated mode on the boundary of the origin's component. Let `|ψ(2^k) − 2^k| ≤ C·k²·√2^k` for `k ≥ 1`, let `1/2 < σ₀ < Θ ≤ 1` and let every zero have real part at most `Θ`. Then there is `E` with `σ₀ ≤ E < Θ` such that for every `σ ≥ E` no zero `ρ₁` with real part above `σ` has its mode `u₁ = 2^(−ρ₁)` isolated in `K = closure {2^(−ρ) : Re ρ ≥ σ}` and on the frontier of the connected component of `{|u| < 2^(−σ)} ∖ K` that holds `0`.

**Proves**

```lean
∃ E : ℝ, σ₀ ≤ E ∧ E < Θ ∧ ∀ σ : ℝ, E ≤ σ → ∀ ρ₁ : Kadiri.NontrivialZeros, σ < (ρ₁ : ℂ).re → (∃ ε : ℝ, 0 < ε ∧ ∀ u ∈ K σ, ‖u - (2:ℂ) ^ (-(ρ₁ : ℂ))‖ < ε → u = (2:ℂ) ^ (-(ρ₁ : ℂ))) → (2:ℂ) ^ (-(ρ₁ : ℂ)) ∈ frontier (connectedComponentIn (Metric.ball (0:ℂ) ((2:ℝ) ^ (-σ)) \ K σ) 0) → False
```

**Needs** (its hypotheses)

  - `` hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖ ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k ``
  - `` hσ₀ : 1 / 2 < σ₀ ``
  - `` hσ₀Θ : σ₀ < Θ ``
  - `` hΘ1 : Θ ≤ 1 ``
  - `` hΘ : ∀ ρ : Kadiri.NontrivialZeros, (ρ : ℂ).re ≤ Θ ``

Behind it: 459 theorems and 90 definitions in 49 files. Every one is listed below; Lean recorded each step.

## The files it passes through

```mermaid
flowchart LR
  f0["<b>AliasClass</b><br/>3 used"]:::thm
  f1["<b>Assembly</b><br/>2 used"]:::thm
  f2["<b>CellZeros</b><br/>1 used"]:::thm
  f3["<b>DirichletMean</b><br/>7 used"]:::thm
  f4["<b>DirichletMeanW</b><br/>5 used"]:::thm
  f5["<b>Glue</b><br/>1 used"]:::thm
  f6["<b>JensenCount</b><br/>17 used"]:::thm
  f7["<b>ContourShift</b><br/>28 used"]:::thm
  f8["<b>LadderMean</b><br/>1 used"]:::thm
  f9["<b>LeftKernel</b><br/>9 used"]:::thm
  f10["<b>LeftSmooth</b><br/>47 used"]:::thm
  f11["<b>CellFixedRow</b><br/>1 used"]:::thm
  f12["<b>LineBound</b><br/>4 used"]:::thm
  f13["<b>Mollified</b><br/>15 used"]:::thm
  f14["<b>PerronKernel</b><br/>25 used"]:::thm
  f15["<b>PerronTwo</b><br/>10 used"]:::thm
  f16["<b>ReZetaCount</b><br/>19 used"]:::thm
  f17["<b>RealSegment</b><br/>4 used"]:::thm
  f18["<b>RvMCrude</b><br/>3 used"]:::thm
  f19["<b>ArgCrude</b><br/>3 used"]:::thm
  f20["<b>SquareMean</b><br/>6 used"]:::thm
  f21["<b>Stirling</b><br/>20 used"]:::thm
  f22["<b>ArgIdentity</b><br/>54 used"]:::thm
  f23["<b>ArgLegs</b><br/>10 used"]:::thm
  f24["<b>ArgCount</b><br/>14 used"]:::thm
  f25["<b>WeilBands</b><br/>1 used"]:::thm
  f26["<b>WeilOnLine</b><br/>3 used"]:::thm
  f27["<b>ZeroSum</b><br/>7 used"]:::thm
  f28["<b>FiniteOffLine</b><br/>6 used"]:::thm
  f29["<b>FilterAccum</b><br/>2 used"]:::thm
  f30["<b>FiniteOffLinePi</b><br/>3 used"]:::thm
  f31["<b>PiRemainder</b><br/>7 used"]:::thm
  f32["<b>PiZeros</b><br/>1 used"]:::thm
  f33["<b>ZetaEM</b><br/>26 used"]:::thm
  f34["<b>MollifiedMean</b><br/>15 used"]:::thm
  f35["<b>ZeroSquares</b><br/>19 used"]:::thm
  f36["<b>ZeroDensity</b><br/>11 used"]:::thm
  f37["<b>ZeroSummable</b><br/>14 used"]:::thm
  f38["<b>CountReduction</b><br/>3 used"]:::thm
  f39["<b>ZetaGrowth</b><br/>20 used"]:::thm
  f40["<b>BoxBounds</b><br/>3 used"]:::thm
  f41["<b>EdgeBound</b><br/>14 used"]:::thm
  f42["<b>EdgeNum</b><br/>9 used"]:::thm
  f43["<b>GlueNum</b><br/>6 used"]:::thm
  f44["<b>ExplicitTwo</b><br/>16 used"]:::thm
  f45["<b>FixedRowTwo</b><br/>3 used"]:::thm
  f46["<b>FilterLadder</b><br/>23 used"]:::thm
  f47["<b>FilterAttained</b><br/>9 used"]:::thm
  f48["<b>ResidueRoute</b><br/>isolated_boundary_mode_false"]:::end_
  f3 --> f4
  f1 --> f7
  f6 --> f7
  f5 --> f10
  f7 --> f10
  f9 --> f10
  f10 --> f11
  f14 --> f15
  f6 --> f16
  f18 --> f19
  f18 --> f21
  f19 --> f22
  f21 --> f22
  f22 --> f23
  f16 --> f24
  f23 --> f24
  f17 --> f28
  f24 --> f28
  f27 --> f28
  f28 --> f29
  f2 --> f30
  f28 --> f30
  f1 --> f31
  f28 --> f31
  f1 --> f32
  f28 --> f32
  f4 --> f34
  f13 --> f34
  f33 --> f34
  f6 --> f35
  f20 --> f35
  f34 --> f35
  f35 --> f36
  f8 --> f37
  f25 --> f37
  f26 --> f37
  f28 --> f37
  f36 --> f37
  f37 --> f38
  f7 --> f39
  f39 --> f40
  f39 --> f41
  f40 --> f42
  f41 --> f42
  f42 --> f43
  f10 --> f44
  f12 --> f44
  f15 --> f44
  f43 --> f44
  f11 --> f45
  f44 --> f45
  f30 --> f46
  f31 --> f46
  f32 --> f46
  f45 --> f46
  f37 --> f47
  f46 --> f47
  f0 --> f48
  f29 --> f48
  f38 --> f48
  f47 --> f48
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

### [`AliasClass`](../lean_stage3/AliasClass.md) — 3

- [`AliasClass.re_inv_pos`](../lean_stage3/AliasClass.md#AliasClass-re_inv_pos) — `` 0 < (ρ⁻¹).re ``
- [`AliasClass.zero_re_pos`](../lean_stage3/AliasClass.md#AliasClass-zero_re_pos) — `` 0 < (ρ : ℂ).re ``
- ★ [`AliasClass.re_order_div_pos`](../lean_stage3/AliasClass.md#AliasClass-re_order_div_pos) — `` 0 < ((((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)).re ``

### [`Assembly`](../lean_stage3/Assembly.md) — 2

- [`Stage3.zeroPartialSum`](../lean_stage3/Assembly.md#Stage3-zeroPartialSum) — *def*
- [`Stage3.inv_le_dyadic_sum`](../lean_stage3/Assembly.md#Stage3-inv_le_dyadic_sum) — `` ∀ γ : ℝ, 1 ≤ γ → γ < 2 ^ (K + 1) → γ⁻¹ ≤ ∑ j ∈ Finset.range (K + 1), ((2 : ℝ) ^ j)⁻¹ * (if γ < 2 ^ (j + 1) then 1 else 0) ``

### [`CellZeros`](../lean_stage3/CellZeros.md) — 1

- [`CellZeros.cpow_two_zpow`](../lean_stage3/CellZeros.md#CellZeros-cpow_two_zpow) — `` (((2:ℝ) ^ n : ℝ) : ℂ) ^ ρ = ((2:ℂ) ^ ρ) ^ n ``

### [`DirichletMean`](../lean_stage3/DirichletMean.md) — 7

- [`DirichletMean.natCast_cpow_neg_I_mul`](../lean_stage3/DirichletMean.md#DirichletMean-natCast_cpow_neg_I_mul) — `` (n : ℂ) ^ (-(Complex.I * (t : ℂ))) = Complex.exp (Complex.I * ((-Real.log n : ℝ) : ℂ) * t) ``
- [`DirichletMean.sq_norm_sum_eq`](../lean_stage3/DirichletMean.md#DirichletMean-sq_norm_sum_eq) — `` ((‖∑ n ∈ Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ)))‖ ^ 2 : ℝ) : ℂ) = ∑ m ∈ Icc 1 N, ∑ n ∈ Icc 1 N, a m * (starRingEnd ℂ) (a n) * Complex.exp (Complex.I *… ``
- [`DirichletMean.integral_sq_norm_eq`](../lean_stage3/DirichletMean.md#DirichletMean-integral_sq_norm_eq) — `` ((∫ t in T₁..T₂, ‖∑ n ∈ Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ)))‖ ^ 2 : ℝ) : ℂ) = ∑ m ∈ Icc 1 N, ∑ n ∈ Icc 1 N, a m * (starRingEnd ℂ) (a n) * ∫ t in T₁… ``
- [`DirichletMean.norm_integral_exp_le`](../lean_stage3/DirichletMean.md#DirichletMean-norm_integral_exp_le) — `` ‖∫ t in T₁..T₂, Complex.exp (Complex.I * (θ : ℂ) * t)‖ ≤ 2 / |θ| ``
- [`DirichletMean.sum_inv_le_harmonic`](../lean_stage3/DirichletMean.md#DirichletMean-sum_inv_le_harmonic) — `` ∑ n ∈ s, ((g n : ℕ) : ℝ)⁻¹ ≤ ∑ k ∈ Icc 1 N, (k : ℝ)⁻¹ ``
- [`DirichletMean.sum_inv_Icc_le`](../lean_stage3/DirichletMean.md#DirichletMean-sum_inv_Icc_le) — `` ∑ k ∈ Icc 1 N, (k : ℝ)⁻¹ ≤ 1 + Real.log N ``
- [`DirichletMean.sum_inv_dist_le`](../lean_stage3/DirichletMean.md#DirichletMean-sum_inv_dist_le) — `` ∑ n ∈ Icc 1 N, (if m = n then 0 else |(m : ℝ) - n|⁻¹) ≤ 2 * (1 + Real.log N) ``

### [`DirichletMeanW`](../lean_stage3/DirichletMeanW.md) — 5

- [`DirichletMeanW.log_gap_larger`](../lean_stage3/DirichletMeanW.md#DirichletMeanW-log_gap_larger) — `` ((q : ℝ) - p) / q ≤ Real.log q - Real.log p ``
- [`DirichletMeanW.weighted_gap`](../lean_stage3/DirichletMeanW.md#DirichletMeanW-weighted_gap) — `` 2 / |Real.log n - Real.log m| * ((m : ℝ) / n) ≤ 2 * m * (|(m : ℝ) - n|⁻¹ + (n : ℝ)⁻¹) ``
- [`DirichletMeanW.sum_mul_mul_le_weighted`](../lean_stage3/DirichletMeanW.md#DirichletMeanW-sum_mul_mul_le_weighted) — `` ∑ m ∈ s, ∑ n ∈ s, A m * A n * K m n ≤ ∑ m ∈ s, A m ^ 2 * R m ``
- [`DirichletMeanW.dirichlet_mean_value_weighted`](../lean_stage3/DirichletMeanW.md#DirichletMeanW-dirichlet_mean_value_weighted) — `` ∫ t in T₁..T₂, ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ)))‖ ^ 2 ≤ ∑ n ∈ Finset.Icc 1 N, ‖a n‖ ^ 2 * ((T₂ - T₁) + 6 * n * (1 + Real.log N)) ``
- [`DirichletMeanW.dirichlet_mean_value_weighted_sigma`](../lean_stage3/DirichletMeanW.md#DirichletMeanW-dirichlet_mean_value_weighted_sigma) — `` ∫ t in T₁..T₂, ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-((σ : ℂ) + Complex.I * (t : ℂ)))‖ ^ 2 ≤ ∑ n ∈ Finset.Icc 1 N, ‖a n‖ ^ 2 * (n : ℝ) ^ (-2 * σ) * ((T₂ - T₁… ``

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

### [`LadderMean`](../lean_stage3/LadderMean.md) — 1

- ★ [`LadderMean.coef`](../lean_stage3/LadderMean.md#LadderMean-coef) — *def*

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

### [`Mollified`](../lean_stage3/Mollified.md) — 15

- [`Mollified.tauBelow`](../lean_stage3/Mollified.md#Mollified-tauBelow) — *def*
- [`Mollified.coef`](../lean_stage3/Mollified.md#Mollified-coef) — *def*
- [`Mollified.prod_eq_sum`](../lean_stage3/Mollified.md#Mollified-prod_eq_sum) — `` (∑ m ∈ Icc 1 N, (m : ℂ) ^ (-s)) * (∑ d ∈ Ico 1 X, (ArithmeticFunction.moebius d : ℂ) * (d : ℂ) ^ (-s)) = ∑ n ∈ Icc 1 (N * X), (coef X N n : ℂ) * (n : ℂ) ^ (-s) ``
- [`Mollified.coef_one`](../lean_stage3/Mollified.md#Mollified-coef_one) — `` coef X N 1 = 1 ``
- [`Mollified.coef_eq_zero`](../lean_stage3/Mollified.md#Mollified-coef_eq_zero) — `` coef X N n = 0 ``
- [`Mollified.abs_coef_le`](../lean_stage3/Mollified.md#Mollified-abs_coef_le) — `` |coef X N n| ≤ tauBelow X n ``
- [`Mollified.card_Icc_dvd`](../lean_stage3/Mollified.md#Mollified-card_Icc_dvd) — `` ((Icc 1 Y).filter (k ∣ ·)).card = Y / k ``
- [`Mollified.triples`](../lean_stage3/Mollified.md#Mollified-triples) — *def*
- [`Mollified.tauBelow_sq_le`](../lean_stage3/Mollified.md#Mollified-tauBelow_sq_le) — `` tauBelow X n ^ 2 ≤ ((triples X).filter (fun t => t.1 * t.2.1 * t.2.2 ∣ n)).card ``
- [`Mollified.sum_inv_Ico_le`](../lean_stage3/Mollified.md#Mollified-sum_inv_Ico_le) — `` ∑ k ∈ Ico 1 X, ((k : ℝ))⁻¹ ≤ 1 + Real.log X ``
- [`Mollified.sum_tauBelow_sq_le`](../lean_stage3/Mollified.md#Mollified-sum_tauBelow_sq_le) — `` ∑ n ∈ Icc 1 Y, (tauBelow X n : ℝ) ^ 2 ≤ Y * (1 + Real.log X) ^ 3 ``
- [`Mollified.coef_sq_le`](../lean_stage3/Mollified.md#Mollified-coef_sq_le) — `` (coef X N n : ℝ) ^ 2 ≤ (tauBelow X n : ℝ) ^ 2 ``
- [`Mollified.sum_coef_sq_le`](../lean_stage3/Mollified.md#Mollified-sum_coef_sq_le) — `` ∑ n ∈ Icc 1 Y, (coef X N n : ℝ) ^ 2 ≤ Y * (1 + Real.log X) ^ 3 ``
- [`Mollified.sum_Ico_dyadic`](../lean_stage3/Mollified.md#Mollified-sum_Ico_dyadic) — `` ∑ n ∈ Ico X (2 ^ J * X), f n = ∑ j ∈ range J, ∑ n ∈ Ico (2 ^ j * X) (2 ^ (j + 1) * X), f n ``
- [`Mollified.sum_coef_sq_weighted_le`](../lean_stage3/Mollified.md#Mollified-sum_coef_sq_weighted_le) — `` ∑ n ∈ Icc X Y, (coef X N n : ℝ) ^ 2 * (n : ℝ) ^ (-2 * u) ≤ 2 / (1 - (2 : ℝ) ^ (1 - 2 * u)) * (X : ℝ) ^ (1 - 2 * u) * (1 + Real.log X) ^ 3 ``

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

### [`ReZetaCount`](../lean_stage3/ReZetaCount.md) — 19

- [`ReZetaCount.G`](../lean_stage3/ReZetaCount.md#ReZetaCount-G) — *def*
- [`ReZetaCount.F`](../lean_stage3/ReZetaCount.md#ReZetaCount-F) — *def*
- [`ReZetaCount.reZeroSet`](../lean_stage3/ReZetaCount.md#ReZetaCount-reZeroSet) — *def*
- [`ReZetaCount.norm_zeta_sub_one_le`](../lean_stage3/ReZetaCount.md#ReZetaCount-norm_zeta_sub_one_le) — `` ‖riemannZeta s - 1‖ ≤ Real.pi ^ 2 / 6 - 1 ``
- [`ReZetaCount.re_zeta_two_line_ge`](../lean_stage3/ReZetaCount.md#ReZetaCount-re_zeta_two_line_ge) — `` 2 - Real.pi ^ 2 / 6 ≤ (riemannZeta (2 + (t : ℂ) * Complex.I)).re ``
- [`ReZetaCount.re_zeta_two_line_pos`](../lean_stage3/ReZetaCount.md#ReZetaCount-re_zeta_two_line_pos) — `` 0 < (riemannZeta (2 + (t : ℂ) * Complex.I)).re ``
- [`ReZetaCount.G_zero_eq`](../lean_stage3/ReZetaCount.md#ReZetaCount-G_zero_eq) — `` G T 0 = ((2 * (riemannZeta (2 + Complex.I * (T : ℂ))).re : ℝ) : ℂ) ``
- [`ReZetaCount.G_real`](../lean_stage3/ReZetaCount.md#ReZetaCount-G_real) — `` G T (x : ℂ) = ((2 * (riemannZeta (2 * (x : ℂ) + 2 + Complex.I * (T : ℂ))).re : ℝ) : ℂ) ``
- [`ReZetaCount.G_zero_ne`](../lean_stage3/ReZetaCount.md#ReZetaCount-G_zero_ne) — `` G T 0 ≠ 0 ``
- [`ReZetaCount.F_zero_eq_one`](../lean_stage3/ReZetaCount.md#ReZetaCount-F_zero_eq_one) — `` F T 0 = 1 ``
- [`ReZetaCount.arg_ne_one`](../lean_stage3/ReZetaCount.md#ReZetaCount-arg_ne_one) — `` 2 * z + 2 + Complex.I * (T : ℂ) ≠ 1 ∧ 2 * z + 2 - Complex.I * (T : ℂ) ≠ 1 ``
- [`ReZetaCount.F_analytic`](../lean_stage3/ReZetaCount.md#ReZetaCount-F_analytic) — `` AnalyticOnNhd ℂ (F T) (Metric.closedBall (0 : ℂ) 1) ``
- [`ReZetaCount.F_bound`](../lean_stage3/ReZetaCount.md#ReZetaCount-F_bound) — `` ‖F T z‖ ≤ 80 * T ``
- [`ReZetaCount.F_zeros_finite`](../lean_stage3/ReZetaCount.md#ReZetaCount-F_zeros_finite) — `` (SetOfZeros 1 (F T)).Finite ``
- [`ReZetaCount.F_count_le`](../lean_stage3/ReZetaCount.md#ReZetaCount-F_count_le) — `` ∑ ρ ∈ (finiteSetOfZeros_mono (by norm_num : (7:ℝ)/8 < 1) (F_zeros_finite hT)).toFinset, (analyticOrderNatAt (F T) ρ : ℝ) ≤ 15 * Real.log T + 73 ``
- [`ReZetaCount.reZeroSet_finite`](../lean_stage3/ReZetaCount.md#ReZetaCount-reZeroSet_finite) — `` (reZeroSet T).Finite ``
- [`ReZetaCount.reZeros`](../lean_stage3/ReZetaCount.md#ReZetaCount-reZeros) — *def*
- [`ReZetaCount.mem_reZeros`](../lean_stage3/ReZetaCount.md#ReZetaCount-mem_reZeros) — `` x ∈ reZeros hT ↔ x ∈ Set.Ioo (1/2 : ℝ) 2 ∧ (riemannZeta ((x : ℂ) + T * Complex.I)).re = 0 ``
- [`ReZetaCount.card_reZeros_le`](../lean_stage3/ReZetaCount.md#ReZetaCount-card_reZeros_le) — `` ((reZeros hT).card : ℝ) ≤ 15 * Real.log T + 73 ``

### [`RealSegment`](../lean_stage3/RealSegment.md) — 4

- [`Stage3.zeta_real_ne_zero_upper`](../lean_stage3/RealSegment.md#Stage3-zeta_real_ne_zero_upper) — `` riemannZeta (σ : ℂ) ≠ 0 ``
- [`Stage3.zeta_real_ne_zero`](../lean_stage3/RealSegment.md#Stage3-zeta_real_ne_zero) — `` riemannZeta (σ : ℂ) ≠ 0 ``
- [`Stage3.isEmpty_zeroHeight`](../lean_stage3/RealSegment.md#Stage3-isEmpty_zeroHeight) — `` IsEmpty Kadiri.ZeroHeightNontrivialZeros ``
- [`Stage3.weightedZeroHeightBucket_eq_zero`](../lean_stage3/RealSegment.md#Stage3-weightedZeroHeightBucket_eq_zero) — `` Kadiri.weightedZeroHeightBucket = 0 ``

### [`RvMCrude`](../lean_stage3/RvMCrude.md) — 3

- [`Stage3.StmtBacklundPhase`](../lean_stage3/RvMCrude.md#Stage3-StmtBacklundPhase) — *def*
- [`Stage3.StmtBacklundArg`](../lean_stage3/RvMCrude.md#Stage3-StmtBacklundArg) — *def*
- [`Stage3.RvM_of_phase_arg`](../lean_stage3/RvMCrude.md#Stage3-RvM_of_phase_arg) — `` riemannZeta.Riemann_vonMangoldt_bound (B₁ + B₁') 0 (B₃ + B₃') ``

### [`ArgCrude`](../lean_stage3/ArgCrude.md) — 3

- [`Stage3.StmtArgIdentity`](../lean_stage3/ArgCrude.md#Stage3-StmtArgIdentity) — *def*
- [`Stage3.StmtSCrude`](../lean_stage3/ArgCrude.md#Stage3-StmtSCrude) — *def*
- [`Stage3.backlundArg_of_identity`](../lean_stage3/ArgCrude.md#Stage3-backlundArg_of_identity) — `` StmtBacklundArg θ B₁ B₃ ``

### [`SquareMean`](../lean_stage3/SquareMean.md) — 6

- [`SquareMean.circle_sq_mean`](../lean_stage3/SquareMean.md#SquareMean-circle_sq_mean) — `` 2 * π * ‖f c‖ ^ 2 ≤ ∫ θ in Ioo (-π) π, ‖f (c + (r : ℂ) * ((Real.cos θ : ℂ) + (Real.sin θ : ℂ) * Complex.I))‖ ^ 2 ``
- [`SquareMean.ball_subset_sq`](../lean_stage3/SquareMean.md#SquareMean-ball_subset_sq) — `` closedBall c δ ⊆ (Icc (c.re - δ) (c.re + δ)) ×ℂ (Icc (c.im - δ) (c.im + δ)) ``
- [`SquareMean.norm_polar`](../lean_stage3/SquareMean.md#SquareMean-norm_polar) — `` ‖(r : ℂ) * ((Real.cos θ : ℂ) + (Real.sin θ : ℂ) * Complex.I)‖ = |r| ``
- [`SquareMean.disc_sq_mean`](../lean_stage3/SquareMean.md#SquareMean-disc_sq_mean) — `` π * δ ^ 2 * ‖f c‖ ^ 2 ≤ ∫ z, (ball c δ).indicator (fun z => ‖f z‖ ^ 2) z ``
- [`SquareMean.sq_set_integral`](../lean_stage3/SquareMean.md#SquareMean-sq_set_integral) — `` ∫ z in (Icc (c.re - δ) (c.re + δ)) ×ℂ (Icc (c.im - δ) (c.im + δ)), F z = ∫ u in (c.re - δ)..(c.re + δ), ∫ t in (c.im - δ)..(c.im + δ), F ((u : ℂ) + Complex.I * … ``
- [`SquareMean.sq_mean_lower`](../lean_stage3/SquareMean.md#SquareMean-sq_mean_lower) — `` π * δ ^ 2 * ‖f c‖ ^ 2 ≤ ∫ u in (c.re - δ)..(c.re + δ), ∫ t in (c.im - δ)..(c.im + δ), ‖f ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2 ``

### [`Stirling`](../lean_stage3/Stirling.md) — 20

- [`Stage3.phasePoint`](../lean_stage3/Stirling.md#Stage3-phasePoint) — *def*
- [`Stage3.phaseTheta`](../lean_stage3/Stirling.md#Stage3-phaseTheta) — *def*
- [`Stage3.continuous_phasePoint`](../lean_stage3/Stirling.md#Stage3-continuous_phasePoint) — `` Continuous phasePoint ``
- [`Stage3.intervalIntegrable_phasePoint`](../lean_stage3/Stirling.md#Stage3-intervalIntegrable_phasePoint) — `` IntervalIntegrable phasePoint MeasureTheory.volume a b ``
- [`Stage3.integral_log_half`](../lean_stage3/Stirling.md#Stage3-integral_log_half) — `` (∫ t in (1 : ℝ)..T, Real.log (t / 2)) = T * Real.log (T / 2) - T + 1 + Real.log 2 ``
- [`Stage3.StmtDigammaLog`](../lean_stage3/Stirling.md#Stage3-StmtDigammaLog) — *def*
- [`Stage3.backlundPhase_of_digammaLog`](../lean_stage3/Stirling.md#Stage3-backlundPhase_of_digammaLog) — `` StmtBacklundPhase phaseTheta C (C + 1) ``
- [`Stage3.digamma_term_norm_le`](../lean_stage3/Stirling.md#Stage3-digamma_term_norm_le) — `` ‖1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + z)‖ ≤ 4 / ((n : ℝ) + 1) ^ 2 ``
- [`Stage3.phasePoint_compact_le`](../lean_stage3/Stirling.md#Stage3-phasePoint_compact_le) — `` ∀ t ∈ Set.Icc (0 : ℝ) 1, |phasePoint t| ≤ 8 ``
- [`Stage3.log_norm_z_le`](../lean_stage3/Stirling.md#Stage3-log_norm_z_le) — `` |Real.log ‖(1 : ℂ) / 4 + (t : ℂ) / 2 * Complex.I‖ - Real.log (t / 2)| ≤ 1 / (4 * t) ``
- [`Stage3.inv_quadratic_tsum_le`](../lean_stage3/Stirling.md#Stage3-inv_quadratic_tsum_le) — `` (∑' n : ℕ, (((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹) ≤ 12 / t ``
- [`Stage3.re_sub_log_norm_le`](../lean_stage3/Stirling.md#Stage3-re_sub_log_norm_le) — `` |w.re - Real.log ‖1 + w‖| ≤ 8 * ‖w‖ ^ 2 ``
- [`Stage3.zq`](../lean_stage3/Stirling.md#Stage3-zq) — *def*
- [`Stage3.phasePoint_eq`](../lean_stage3/Stirling.md#Stage3-phasePoint_eq) — `` phasePoint t = (Complex.digamma (zq t)).re ``
- [`Stage3.normSq_add_zq`](../lean_stage3/Stirling.md#Stage3-normSq_add_zq) — `` ‖(n : ℂ) + zq t‖ ^ 2 = ((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2 ``
- [`Stage3.add_zq_ne_zero`](../lean_stage3/Stirling.md#Stage3-add_zq_ne_zero) — `` (n : ℂ) + zq t ≠ 0 ``
- [`Stage3.a_term_le`](../lean_stage3/Stirling.md#Stage3-a_term_le) — `` |(((n : ℂ) + zq t)⁻¹).re - (Real.log ‖((n + 1 : ℕ) : ℂ) + zq t‖ - Real.log ‖(n : ℂ) + zq t‖)| ≤ 8 * ((((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹) ``
- [`Stage3.re_digamma_sub_log_le`](../lean_stage3/Stirling.md#Stage3-re_digamma_sub_log_le) — `` |phasePoint t - Real.log ‖zq t‖| ≤ 96 / t ``
- [`Stage3.stmtDigammaLog_holds`](../lean_stage3/Stirling.md#Stage3-stmtDigammaLog_holds) — `` StmtDigammaLog 97 ``
- [`Stage3.backlundPhase_holds`](../lean_stage3/Stirling.md#Stage3-backlundPhase_holds) — `` StmtBacklundPhase phaseTheta 97 98 ``

### [`ArgIdentity`](../lean_stage3/ArgIdentity.md) — 54

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
- [`Stage3.stmtArgIdentity_holds`](../lean_stage3/ArgIdentity.md#Stage3-stmtArgIdentity_holds) — `` StmtArgIdentity phaseTheta argS ``
- [`Stage3.logDeriv_zeta_analyticAt`](../lean_stage3/ArgIdentity.md#Stage3-logDeriv_zeta_analyticAt) — `` AnalyticAt ℂ (logDeriv riemannZeta) z ``
- [`Stage3.logDeriv_zeta_continuousAt`](../lean_stage3/ArgIdentity.md#Stage3-logDeriv_zeta_continuousAt) — `` ContinuousAt (logDeriv riemannZeta) z ``
- [`Stage3.zetaArgContour`](../lean_stage3/ArgIdentity.md#Stage3-zetaArgContour) — *def*
- [`Stage3.argS_eq_zetaArgContour`](../lean_stage3/ArgIdentity.md#Stage3-argS_eq_zetaArgContour) — `` argS T = zetaArgContour T ``

### [`ArgLegs`](../lean_stage3/ArgLegs.md) — 10

- [`ArgLegs.abs_arg_sub_le_pi`](../lean_stage3/ArgLegs.md#ArgLegs-abs_arg_sub_le_pi) — `` |z.arg - w.arg| ≤ Real.pi ``
- [`ArgLegs.mem_slitPlane_of_re_nonneg`](../lean_stage3/ArgLegs.md#ArgLegs-mem_slitPlane_of_re_nonneg) — `` z ∈ Complex.slitPlane ``
- [`ArgLegs.integral_logDeriv_eq_log_sub`](../lean_stage3/ArgLegs.md#ArgLegs-integral_logDeriv_eq_log_sub) — `` ∫ x in a..b, g' x / g x = Complex.log (g b) - Complex.log (g a) ``
- [`ArgLegs.im_integral_le_pi_of_re_nonneg`](../lean_stage3/ArgLegs.md#ArgLegs-im_integral_le_pi_of_re_nonneg) — `` |(∫ x in a..b, g' x / g x).im| ≤ Real.pi ``
- [`ArgLegs.im_integral_le_pi_of_re_nonpos`](../lean_stage3/ArgLegs.md#ArgLegs-im_integral_le_pi_of_re_nonpos) — `` |(∫ x in a..b, g' x / g x).im| ≤ Real.pi ``
- [`ArgLegs.re_sign_const`](../lean_stage3/ArgLegs.md#ArgLegs-re_sign_const) — `` (∀ x ∈ Set.Icc a b, 0 ≤ (g x).re) ∨ (∀ x ∈ Set.Icc a b, (g x).re ≤ 0) ``
- [`ArgLegs.segment_im_integral_le`](../lean_stage3/ArgLegs.md#ArgLegs-segment_im_integral_le) — `` |(∫ x in a..b, g' x / g x).im| ≤ Real.pi * ((Z.card : ℝ) + 1) ``
- [`ArgLegs.vertical_leg_le`](../lean_stage3/ArgLegs.md#ArgLegs-vertical_leg_le) — `` |(∫ t in (0:ℝ)..T, logDeriv riemannZeta (2 + (t : ℂ) * Complex.I)).re| ≤ Real.pi / 2 ``
- [`ArgLegs.horizontal_leg_le`](../lean_stage3/ArgLegs.md#ArgLegs-horizontal_leg_le) — `` |(∫ x in (1/2:ℝ)..2, logDeriv riemannZeta ((x : ℂ) + T * Complex.I)).im| ≤ Real.pi * ((Z.card : ℝ) + 1) ``
- [`ArgLegs.zetaArgContour_le`](../lean_stage3/ArgLegs.md#ArgLegs-zetaArgContour_le) — `` |Stage3.zetaArgContour T| ≤ (Z.card : ℝ) + 3 / 2 ``

### [`ArgCount`](../lean_stage3/ArgCount.md) — 14

- [`ArgCount.good`](../lean_stage3/ArgCount.md#ArgCount-good) — *def*
- [`ArgCount.argS_le_of_good`](../lean_stage3/ArgCount.md#ArgCount-argS_le_of_good) — `` |Stage3.argS T| ≤ 15 * Real.log T + 73 + 3 / 2 ``
- [`ArgCount.N_eq_sum`](../lean_stage3/ArgCount.md#ArgCount-N_eq_sum) — `` riemannZeta.N T = ∑ z ∈ (Kadiri.zeroes_rect_univ_positive_height_finite T).toFinset, (1 : ℝ) * (riemannZeta.order z : ℝ) ``
- [`ArgCount.N_nonneg`](../lean_stage3/ArgCount.md#ArgCount-N_nonneg) — `` 0 ≤ riemannZeta.N T ``
- [`ArgCount.N_mono`](../lean_stage3/ArgCount.md#ArgCount-N_mono) — `` riemannZeta.N T ≤ riemannZeta.N T' ``
- [`ArgCount.N_eq_of_no_zero_between`](../lean_stage3/ArgCount.md#ArgCount-N_eq_of_no_zero_between) — `` riemannZeta.N T = riemannZeta.N T₀ ``
- [`ArgCount.exists_good_below`](../lean_stage3/ArgCount.md#ArgCount-exists_good_below) — `` ∃ T : ℝ, a < T ∧ T < T₀ ∧ good T ∧ ∀ ρ : ℂ, riemannZeta ρ = 0 → ρ.im ∈ Set.Ico T T₀ → False ``
- [`ArgCount.phasePoint_bound_near`](../lean_stage3/ArgCount.md#ArgCount-phasePoint_bound_near) — `` ∃ M : ℝ, 0 ≤ M ∧ ∀ t ∈ Set.Icc (T₀ - 1) T₀, |Stage3.phasePoint t| ≤ M ``
- [`ArgCount.phaseTheta_sub_le`](../lean_stage3/ArgCount.md#ArgCount-phaseTheta_sub_le) — `` |Stage3.phaseTheta T₀ - Stage3.phaseTheta T| ≤ (T₀ - T) * (M / 2 + Real.log Real.pi / 2) ``
- [`ArgCount.argS_le_gt_two`](../lean_stage3/ArgCount.md#ArgCount-argS_le_gt_two) — `` |Stage3.argS T| ≤ 15 * Real.log T + 75 ``
- [`ArgCount.mainTerm_abs_le`](../lean_stage3/ArgCount.md#ArgCount-mainTerm_abs_le) — `` |Kadiri.zetaCountingMainTerm T| ≤ 3 ``
- [`ArgCount.argS_two_le`](../lean_stage3/ArgCount.md#ArgCount-argS_two_le) — `` |Stage3.argS 2| ≤ 15 * Real.log 2 + 600 ``
- [`ArgCount.sCrude_holds`](../lean_stage3/ArgCount.md#ArgCount-sCrude_holds) — `` Stage3.StmtSCrude Stage3.argS 15 600 ``
- [`ArgCount.rvM_crude`](../lean_stage3/ArgCount.md#ArgCount-rvM_crude) — `` riemannZeta.Riemann_vonMangoldt_bound 112 0 698 ``

### [`WeilBands`](../lean_stage3/WeilBands.md) — 1

- [`WeilBands.order_eq_analyticOrderNatAt`](../lean_stage3/WeilBands.md#WeilBands-order_eq_analyticOrderNatAt) — `` ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) = (analyticOrderNatAt riemannZeta (ρ : ℂ) : ℝ) ``

### [`WeilOnLine`](../lean_stage3/WeilOnLine.md) — 3

- [`WeilOnLine.conj_mem`](../lean_stage3/WeilOnLine.md#WeilOnLine-conj_mem) — `` (starRingEnd ℂ) (ρ : ℂ) ∈ Kadiri.NontrivialZeros ``
- [`WeilOnLine.conjZ`](../lean_stage3/WeilOnLine.md#WeilOnLine-conjZ) — *def*
- [`WeilOnLine.conjZ_injective`](../lean_stage3/WeilOnLine.md#WeilOnLine-conjZ_injective) — `` Function.Injective conjZ ``

### [`ZeroSum`](../lean_stage3/ZeroSum.md) — 7

- [`Stage3.log_two_pi_le`](../lean_stage3/ZeroSum.md#Stage3-log_two_pi_le) — `` Real.log (2 * Real.pi) ≤ 2 ``
- [`Stage3.RvM_mono`](../lean_stage3/ZeroSum.md#Stage3-RvM_mono) — `` riemannZeta.RvM b₁ b₂ b₃ T ≤ riemannZeta.RvM b₁ b₂ b₃ T' ``
- [`Stage3.abs_mainterm_le`](../lean_stage3/ZeroSum.md#Stage3-abs_mainterm_le) — `` |zetaCountingMainTerm T| ≤ T / (2 * Real.pi) * (Real.log T + 3) + 7 / 8 ``
- [`Stage3.N_abs_le`](../lean_stage3/ZeroSum.md#Stage3-N_abs_le) — `` |riemannZeta.N T| ≤ T / (2 * Real.pi) * (Real.log T + 3) + riemannZeta.RvM b₁ b₂ b₃ T + 7 / 8 ``
- [`Stage3.sum_range_add_one`](../lean_stage3/ZeroSum.md#Stage3-sum_range_add_one) — `` (∑ j ∈ range n, ((j : ℝ) + 1)) = n * (n + 1) / 2 ``
- [`Stage3.sum_inv_pow_two_le`](../lean_stage3/ZeroSum.md#Stage3-sum_inv_pow_two_le) — `` (∑ j ∈ range n, ((2 : ℝ) ^ j)⁻¹) ≤ 2 ``
- [`Stage3.dyadic_abs_N_sum_le`](../lean_stage3/ZeroSum.md#Stage3-dyadic_abs_N_sum_le) — `` (∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹ * |riemannZeta.N ((2 : ℝ) ^ (j + 1))|) ≤ Real.log 2 / (2 * Real.pi) * (K + 1) * (K + 2) + 3 * (K + 1) / Real.pi + 2 * (rie… ``

### [`FiniteOffLine`](../lean_stage3/FiniteOffLine.md) — 6

- [`FiniteOffLine.ZF`](../lean_stage3/FiniteOffLine.md#FiniteOffLine-ZF) — *def*
- [`FiniteOffLine.mem_ZF`](../lean_stage3/FiniteOffLine.md#FiniteOffLine-mem_ZF) — `` ρ ∈ ZF T ↔ |(ρ : ℂ).im| < T ``
- [`FiniteOffLine.tsum_sub_eq_sum`](../lean_stage3/FiniteOffLine.md#FiniteOffLine-tsum_sub_eq_sum) — `` ∑' σ : {ρ : NontrivialZeros // |(ρ : ℂ).im| < T}, f σ.1 = ∑ ρ ∈ ZF T, f ρ ``
- [`FiniteOffLine.order_nonneg`](../lean_stage3/FiniteOffLine.md#FiniteOffLine-order_nonneg) — `` (0 : ℝ) ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) ``
- [`FiniteOffLine.dyadic_count_le`](../lean_stage3/FiniteOffLine.md#FiniteOffLine-dyadic_count_le) — `` ∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹ * (2 * |riemannZeta.N ((2 : ℝ) ^ (j + 1))| + weightedZeroHeightBucket) ≤ 3000 * ((K : ℝ) + 2) ^ 2 ``
- [`FiniteOffLine.norm_two_cpow`](../lean_stage3/FiniteOffLine.md#FiniteOffLine-norm_two_cpow) — `` ‖(2:ℂ) ^ ρ‖ = (2:ℝ) ^ ρ.re ``

### [`FilterAccum`](../lean_stage3/FilterAccum.md) — 2

- [`FilterAccum.one_le_norm_mode`](../lean_stage3/FilterAccum.md#FilterAccum-one_le_norm_mode) — `` 1 ≤ ‖(2:ℂ) ^ (ρ : ℂ)‖ ``
- [`FilterAccum.norm_mode_le_two`](../lean_stage3/FilterAccum.md#FilterAccum-norm_mode_le_two) — `` ‖(2:ℂ) ^ (ρ : ℂ)‖ ≤ 2 ``

### [`FiniteOffLinePi`](../lean_stage3/FiniteOffLinePi.md) — 3

- [`FiniteOffLinePi.cpow_doubling`](../lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-cpow_doubling) — `` (((2:ℝ) ^ r : ℝ) : ℂ) ^ ρ = ((2:ℂ) ^ ρ) ^ r ``
- [`FiniteOffLinePi.ordR`](../lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-ordR) — *def*
- [`FiniteOffLinePi.ordR_nonneg`](../lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-ordR_nonneg) — `` 0 ≤ ordR ρ ``

### [`PiRemainder`](../lean_stage3/PiRemainder.md) — 7

- [`PiRemainder.Mlow`](../lean_stage3/PiRemainder.md#PiRemainder-Mlow) — *def*
- [`PiRemainder.two_le_Mlow`](../lean_stage3/PiRemainder.md#PiRemainder-two_le_Mlow) — `` 2 ≤ Mlow ``
- [`PiRemainder.inv_norm_le_Mlow`](../lean_stage3/PiRemainder.md#PiRemainder-inv_norm_le_Mlow) — `` ‖(ρ : ℂ)‖⁻¹ ≤ Mlow ``
- [`PiRemainder.inv_norm_le_dyadic`](../lean_stage3/PiRemainder.md#PiRemainder-inv_norm_le_dyadic) — `` ‖(ρ : ℂ)‖⁻¹ ≤ Mlow * ∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹ * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0) ``
- [`PiRemainder.sum_order_inv_le`](../lean_stage3/PiRemainder.md#PiRemainder-sum_order_inv_le) — `` ∑ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹ ≤ Mlow * ∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹ * (2 * |riemannZeta.N ((2 : ℝ) ^… ``
- [`PiRemainder.zinv`](../lean_stage3/PiRemainder.md#PiRemainder-zinv) — *def*
- [`PiRemainder.zinv_le_log`](../lean_stage3/PiRemainder.md#PiRemainder-zinv_le_log) — `` zinv x ≤ Mlow * 39000 * Real.log x ^ 2 ``

### [`PiZeros`](../lean_stage3/PiZeros.md) — 1

- [`PiZeros.zeroPartialSum_eq_sum`](../lean_stage3/PiZeros.md#PiZeros-zeroPartialSum_eq_sum) — `` Stage3.zeroPartialSum t T = ∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ)) ``

### [`ZetaEM`](../lean_stage3/ZetaEM.md) — 26

- [`ZetaEM.emInt`](../lean_stage3/ZetaEM.md#ZetaEM-emInt) — *def*
- [`ZetaEM.emCoef`](../lean_stage3/ZetaEM.md#ZetaEM-emCoef) — *def*
- [`ZetaEM.emTerm`](../lean_stage3/ZetaEM.md#ZetaEM-emTerm) — *def*
- [`ZetaEM.emBoundary`](../lean_stage3/ZetaEM.md#ZetaEM-emBoundary) — *def*
- [`ZetaEM.emRem`](../lean_stage3/ZetaEM.md#ZetaEM-emRem) — *def*
- [`ZetaEM.bernBound`](../lean_stage3/ZetaEM.md#ZetaEM-bernBound) — *def*
- [`ZetaEM.hasDerivWithinAt_fract`](../lean_stage3/ZetaEM.md#ZetaEM-hasDerivWithinAt_fract) — `` HasDerivWithinAt Int.fract 1 (Ioi x) x ``
- [`ZetaEM.continuous_bernoulliFun_fract`](../lean_stage3/ZetaEM.md#ZetaEM-continuous_bernoulliFun_fract) — `` Continuous (fun x : ℝ ↦ bernoulliFun k (Int.fract x)) ``
- [`ZetaEM.abs_bernoulliFun_fract_le`](../lean_stage3/ZetaEM.md#ZetaEM-abs_bernoulliFun_fract_le) — `` |bernoulliFun k (Int.fract x)| ≤ bernBound k ``
- [`ZetaEM.bernBound_nonneg`](../lean_stage3/ZetaEM.md#ZetaEM-bernBound_nonneg) — `` 0 ≤ bernBound k ``
- [`ZetaEM.measurable_bern`](../lean_stage3/ZetaEM.md#ZetaEM-measurable_bern) — `` Measurable (fun x : ℝ ↦ bernoulliFun k (Int.fract x)) ``
- [`ZetaEM.integrableOn_bern_cpow`](../lean_stage3/ZetaEM.md#ZetaEM-integrableOn_bern_cpow) — `` IntegrableOn (fun x : ℝ ↦ ((bernoulliFun k (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ w) (Ioi a) ``
- [`ZetaEM.norm_integral_bern_cpow_le`](../lean_stage3/ZetaEM.md#ZetaEM-norm_integral_bern_cpow_le) — `` ‖∫ x in Ioi a, ((bernoulliFun k (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ w‖ ≤ bernBound k * (-a ^ (w.re + 1) / (w.re + 1)) ``
- [`ZetaEM.interval_ibp`](../lean_stage3/ZetaEM.md#ZetaEM-interval_ibp) — `` ((k:ℂ) + 1) * ∫ x in a..b, ((bernoulliFun k (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ (-(s + k)) = ((bernoulliFun (k+1) (Int.fract b) : ℝ) : ℂ) * (b:ℂ) ^ (-(s + k)) - (… ``
- [`ZetaEM.tail_ibp`](../lean_stage3/ZetaEM.md#ZetaEM-tail_ibp) — `` ((k:ℂ) + 1) * ∫ x in Ioi a, ((bernoulliFun k (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ (-(s + k)) = -(((bernoulliFun (k+1) (Int.fract a) : ℝ) : ℂ) * (a:ℂ) ^ (-(s + k)))… ``
- [`ZetaEM.emInt_step`](../lean_stage3/ZetaEM.md#ZetaEM-emInt_step) — `` ((k:ℂ) + 1) * emInt k N s = -((bernoulliFun (k+1) 0 : ℂ) * (N:ℂ) ^ (-(s + k))) + (s + k) * emInt (k+1) N s ``
- [`ZetaEM.emRem_step`](../lean_stage3/ZetaEM.md#ZetaEM-emRem_step) — `` emRem k N s = emTerm k N s + emRem (k+1) N s ``
- [`ZetaEM.sum_range_succ_eq_sum_Icc`](../lean_stage3/ZetaEM.md#ZetaEM-sum_range_succ_eq_sum_Icc) — `` ∑ n ∈ Finset.range (N + 1), 1 / (n : ℂ) ^ s = ∑ n ∈ Finset.Icc 1 N, (n : ℂ) ^ (-s) ``
- [`ZetaEM.zeta_eq_em_one`](../lean_stage3/ZetaEM.md#ZetaEM-zeta_eq_em_one) — `` riemannZeta s = ∑ n ∈ Finset.Icc 1 N, (n : ℂ) ^ (-s) - (N:ℂ) ^ (1 - s) / (1 - s) - (N:ℂ) ^ (-s) / 2 - s * emInt 1 N s ``
- [`ZetaEM.zeta_eq_em`](../lean_stage3/ZetaEM.md#ZetaEM-zeta_eq_em) — `` riemannZeta s = ∑ n ∈ Finset.Icc 1 N, (n : ℂ) ^ (-s) - (N:ℂ) ^ (1 - s) / (1 - s) - (N:ℂ) ^ (-s) / 2 + emBoundary k N s + emRem k N s ``
- [`ZetaEM.norm_emInt_le`](../lean_stage3/ZetaEM.md#ZetaEM-norm_emInt_le) — `` ‖emInt k N s‖ ≤ bernBound k * ((N:ℝ) ^ (1 - s.re - k) / (s.re + k - 1)) ``
- [`ZetaEM.norm_remainder_le`](../lean_stage3/ZetaEM.md#ZetaEM-norm_remainder_le) — `` ‖emRem k N s‖ ≤ (∏ i ∈ Finset.range k, ‖s + i‖) / k.factorial * (bernBound k * ((N:ℝ) ^ (1 - s.re - k) / (s.re + k - 1))) ``
- [`ZetaEM.norm_emTerm`](../lean_stage3/ZetaEM.md#ZetaEM-norm_emTerm) — `` ‖emTerm j N s‖ = (∏ i ∈ Finset.range j, ‖s + i‖) * |bernoulliFun (j+1) 0| / (j+1).factorial * (N:ℝ) ^ (-s.re - j) ``
- [`ZetaEM.prod_norm_le`](../lean_stage3/ZetaEM.md#ZetaEM-prod_norm_le) — `` ∏ i ∈ Finset.range j, ‖s + i‖ ≤ (‖s‖ + k) ^ j ``
- [`ZetaEM.emConst`](../lean_stage3/ZetaEM.md#ZetaEM-emConst) — *def*
- [`ZetaEM.norm_zeta_sub_partial_le`](../lean_stage3/ZetaEM.md#ZetaEM-norm_zeta_sub_partial_le) — `` ‖riemannZeta s - ∑ n ∈ Finset.Icc 1 N, (n : ℂ) ^ (-s) + (N : ℂ) ^ (1 - s) / (1 - s)‖ ≤ emConst k * (N : ℝ) ^ (-s.re) * (1 + (‖s‖ + k) ^ k * (N : ℝ) ^ (1 - (k : … ``

### [`MollifiedMean`](../lean_stage3/MollifiedMean.md) — 15

- [`MollifiedMean.M`](../lean_stage3/MollifiedMean.md#MollifiedMean-M) — *def*
- [`MollifiedMean.f`](../lean_stage3/MollifiedMean.md#MollifiedMean-f) — *def*
- [`MollifiedMean.b`](../lean_stage3/MollifiedMean.md#MollifiedMean-b) — *def*
- [`MollifiedMean.emConst_nonneg`](../lean_stage3/MollifiedMean.md#MollifiedMean-emConst_nonneg) — `` 0 ≤ ZetaEM.emConst k ``
- [`MollifiedMean.norm_M_le`](../lean_stage3/MollifiedMean.md#MollifiedMean-norm_M_le) — `` ‖M X s‖ ≤ X ``
- [`MollifiedMean.norm_smooth_le`](../lean_stage3/MollifiedMean.md#MollifiedMean-norm_smooth_le) — `` ‖(N : ℂ) ^ (1 - ((u : ℂ) + Complex.I * (t : ℂ))) / (1 - ((u : ℂ) + Complex.I * (t : ℂ)))‖ ≤ (N : ℝ) ^ (1 - u) / t ``
- [`MollifiedMean.PM_sub_one_eq`](../lean_stage3/MollifiedMean.md#MollifiedMean-PM_sub_one_eq) — `` (∑ m ∈ Icc 1 N, (m : ℂ) ^ (-s)) * M X s - 1 = ∑ n ∈ Icc 1 (N * X), (b X N n : ℂ) * (n : ℂ) ^ (-s) ``
- [`MollifiedMean.f_eq`](../lean_stage3/MollifiedMean.md#MollifiedMean-f_eq) — `` f X s = ∑ n ∈ Icc 1 (N * X), (b X N n : ℂ) * (n : ℂ) ^ (-s) + (-((N : ℂ) ^ (1 - s) / (1 - s))) * M X s + (riemannZeta s - ∑ n ∈ Icc 1 N, (n : ℂ) ^ (-s) + (N : ℂ… ``
- [`MollifiedMean.norm_sq_add_three`](../lean_stage3/MollifiedMean.md#MollifiedMean-norm_sq_add_three) — `` ‖x + y + z‖ ^ 2 ≤ 3 * (‖x‖ ^ 2 + ‖y‖ ^ 2 + ‖z‖ ^ 2) ``
- [`MollifiedMean.rpow_sq`](../lean_stage3/MollifiedMean.md#MollifiedMean-rpow_sq) — `` (x ^ a) ^ 2 = x ^ (2 * a) ``
- [`MollifiedMean.sum_b_sq_eq`](../lean_stage3/MollifiedMean.md#MollifiedMean-sum_b_sq_eq) — `` ∑ n ∈ Icc 1 Y, b X N n ^ 2 * w n = ∑ n ∈ Icc X Y, (Mollified.coef X N n : ℝ) ^ 2 * w n ``
- [`MollifiedMean.sum_coef_sq_up_le`](../lean_stage3/MollifiedMean.md#MollifiedMean-sum_coef_sq_up_le) — `` ∑ n ∈ Icc 1 Y, (Mollified.coef X N n : ℝ) ^ 2 * (n : ℝ) ^ (1 - 2 * u) ≤ 4 * (1 + Real.log X) ^ 3 * (1 + Real.log Y) * max 1 ((Y : ℝ) ^ (2 - 2 * u)) ``
- [`MollifiedMean.integral_inv_sq_le`](../lean_stage3/MollifiedMean.md#MollifiedMean-integral_inv_sq_le) — `` ∫ t in (1:ℝ)..T, (t ^ 2)⁻¹ ≤ 1 ``
- [`MollifiedMean.mean_sq_main_le`](../lean_stage3/MollifiedMean.md#MollifiedMean-mean_sq_main_le) — `` ∫ t in (1:ℝ)..T, ‖∑ n ∈ Icc 1 (N * X), (b X N n : ℂ) * (n : ℂ) ^ (-((u : ℂ) + Complex.I * (t : ℂ)))‖ ^ 2 ≤ T * (2 / (1 - (2:ℝ) ^ (1 - 2 * u))) * (X:ℝ) ^ (1 - 2 … ``
- [`MollifiedMean.mean_sq_f_le`](../lean_stage3/MollifiedMean.md#MollifiedMean-mean_sq_f_le) — `` ∫ t in (1:ℝ)..T, ‖f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2 ≤ 3 * (T * (2 / (1 - (2:ℝ) ^ (1 - 2 * u))) * (X:ℝ) ^ (1 - 2 * u) * (1 + Real.log X) ^ 3 + 24 * (1 + R… ``

### [`ZeroSquares`](../lean_stage3/ZeroSquares.md) — 19

- [`ZeroSquares.one_le_zeta_order`](../lean_stage3/ZeroSquares.md#ZeroSquares-one_le_zeta_order) — `` 1 ≤ analyticOrderNatAt riemannZeta ρ ``
- [`ZeroSquares.differentiable_M`](../lean_stage3/ZeroSquares.md#ZeroSquares-differentiable_M) — `` Differentiable ℂ (MollifiedMean.M X) ``
- [`ZeroSquares.differentiableOn_f`](../lean_stage3/ZeroSquares.md#ZeroSquares-differentiableOn_f) — `` DifferentiableOn ℂ (MollifiedMean.f X) ({(1:ℂ)}ᶜ : Set ℂ) ``
- [`ZeroSquares.f_at_zero`](../lean_stage3/ZeroSquares.md#ZeroSquares-f_at_zero) — `` MollifiedMean.f X ρ = -1 ``
- [`ZeroSquares.sqG`](../lean_stage3/ZeroSquares.md#ZeroSquares-sqG) — *def*
- [`ZeroSquares.continuous_sqG`](../lean_stage3/ZeroSquares.md#ZeroSquares-continuous_sqG) — `` Continuous (Function.uncurry (sqG X)) ``
- [`ZeroSquares.sqG_nonneg`](../lean_stage3/ZeroSquares.md#ZeroSquares-sqG_nonneg) — `` 0 ≤ sqG X u t ``
- [`ZeroSquares.innerI`](../lean_stage3/ZeroSquares.md#ZeroSquares-innerI) — *def*
- [`ZeroSquares.continuous_sqG_slice`](../lean_stage3/ZeroSquares.md#ZeroSquares-continuous_sqG_slice) — `` Continuous (sqG X u) ``
- [`ZeroSquares.continuous_innerI`](../lean_stage3/ZeroSquares.md#ZeroSquares-continuous_innerI) — `` Continuous (innerI X a b) ``
- [`ZeroSquares.innerI_nonneg`](../lean_stage3/ZeroSquares.md#ZeroSquares-innerI_nonneg) — `` 0 ≤ innerI X a b u ``
- [`ZeroSquares.innerI_mono`](../lean_stage3/ZeroSquares.md#ZeroSquares-innerI_mono) — `` innerI X a b u ≤ innerI X c d u ``
- [`ZeroSquares.innerI_eq`](../lean_stage3/ZeroSquares.md#ZeroSquares-innerI_eq) — `` innerI X a b u = ∫ t in a..b, ‖MollifiedMean.f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2 ``
- [`ZeroSquares.square_lower`](../lean_stage3/ZeroSquares.md#ZeroSquares-square_lower) — `` Real.pi * δ ^ 2 ≤ ∫ u in (σ - δ)..(1 + δ), innerI X ((n : ℝ) + 7 / 4) ((n : ℝ) + 13 / 4) u ``
- [`ZeroSquares.window_mem`](../lean_stage3/ZeroSquares.md#ZeroSquares-window_mem) — `` ρ ∈ Stage3.zetaWindow ((n : ℝ) + 5 / 2) ``
- [`ZeroSquares.card_fiber_le`](../lean_stage3/ZeroSquares.md#ZeroSquares-card_fiber_le) — `` (W.card : ℝ) ≤ 15 * Real.log T + 73 ``
- [`ZeroSquares.sum_unit_strips`](../lean_stage3/ZeroSquares.md#ZeroSquares-sum_unit_strips) — `` ∑ n ∈ Finset.range L, innerI X ((n : ℝ) + c) ((n : ℝ) + 1 + c) u = innerI X c ((L : ℝ) + c) u ``
- [`ZeroSquares.strips_le`](../lean_stage3/ZeroSquares.md#ZeroSquares-strips_le) — `` ∑ n ∈ Finset.range L, innerI X ((n : ℝ) + 7 / 4) ((n : ℝ) + 13 / 4) u ≤ 3 * innerI X 1 T u ``
- [`ZeroSquares.card_zeros_le`](../lean_stage3/ZeroSquares.md#ZeroSquares-card_zeros_le) — `` Real.pi * δ ^ 2 * (Z.card : ℝ) ≤ 3 * (15 * Real.log T + 73) * ∫ u in (σ - δ)..(1 + δ), ∫ t in (1:ℝ)..T, ‖MollifiedMean.f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2 ``

### [`ZeroDensity`](../lean_stage3/ZeroDensity.md) — 11

- [`ZeroDensity.ceil_bounds`](../lean_stage3/ZeroDensity.md#ZeroDensity-ceil_bounds) — `` y ≤ (⌈y⌉₊ : ℝ) ∧ (⌈y⌉₊ : ℝ) ≤ 2 * y ``
- [`ZeroDensity.one_add_log_le`](../lean_stage3/ZeroDensity.md#ZeroDensity-one_add_log_le) — `` 1 + Real.log T ≤ (1 + 1 / ε) * T ^ ε ``
- [`ZeroDensity.sq_rpow_le`](../lean_stage3/ZeroDensity.md#ZeroDensity-sq_rpow_le) — `` (X:ℝ) ^ 2 ≤ 4 * T ^ (2 * δ) ``
- [`ZeroDensity.term1_le`](../lean_stage3/ZeroDensity.md#ZeroDensity-term1_le) — `` T * (2 / (1 - (2:ℝ) ^ (1 - 2 * u))) * (X:ℝ) ^ (1 - 2 * u) * (1 + Real.log X) ^ 3 ≤ T * (2 / (1 - (2:ℝ) ^ (-(6 * δ)))) * T ^ (-(6 * δ ^ 2)) * L ^ 3 ``
- [`ZeroDensity.term2_le`](../lean_stage3/ZeroDensity.md#ZeroDensity-term2_le) — `` 24 * (1 + Real.log ((N * X : ℕ) : ℝ)) ^ 2 * (1 + Real.log X) ^ 3 * max 1 (((N * X : ℕ) : ℝ) ^ (2 - 2 * u)) ≤ 24 * (4 * L) ^ 2 * (2 * L) ^ 3 * (4 * T ^ (1 - 4 * … ``
- [`ZeroDensity.term3_le`](../lean_stage3/ZeroDensity.md#ZeroDensity-term3_le) — `` (X:ℝ) ^ 2 * (N:ℝ) ^ (2 - 2 * u) ≤ 8 * T ^ (1 - 3 * δ) ``
- [`ZeroDensity.term4_le`](../lean_stage3/ZeroDensity.md#ZeroDensity-term4_le) — `` T * (X:ℝ) ^ 2 * E ^ 2 * (N:ℝ) ^ (-2 * u) * (1 + (T + 2 + k) ^ k * (N:ℝ) ^ (1 - (k:ℝ))) ^ 2 ≤ 4 * E ^ 2 * (1 + 2 ^ k) ^ 2 * T ^ δ ``
- [`ZeroDensity.bConst`](../lean_stage3/ZeroDensity.md#ZeroDensity-bConst) — *def*
- [`ZeroDensity.bConst_nonneg`](../lean_stage3/ZeroDensity.md#ZeroDensity-bConst_nonneg) — `` 0 ≤ bConst δ k ``
- [`ZeroDensity.inner_le`](../lean_stage3/ZeroDensity.md#ZeroDensity-inner_le) — `` ∫ t in (1:ℝ)..T, ‖MollifiedMean.f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2 ≤ bConst δ k * T ^ (1 - 6 * δ ^ 2) * (1 + Real.log T) ^ 5 ``
- [`ZeroDensity.zero_density`](../lean_stage3/ZeroDensity.md#ZeroDensity-zero_density) — `` ∃ θ C T₀ : ℝ, θ < 1 ∧ 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ Z : Finset ℂ, (∀ ρ ∈ Z, riemannZeta ρ = 0 ∧ σ ≤ ρ.re ∧ ρ.re < 1 ∧ 2 ≤ ρ.im ∧ ρ.im ≤ T - 2) → (Z.card : ℝ) ≤ C … ``

### [`ZeroSummable`](../lean_stage3/ZeroSummable.md) — 14

- [`ZeroSummable.w`](../lean_stage3/ZeroSummable.md#ZeroSummable-w) — *def*
- [`ZeroSummable.w_nonneg`](../lean_stage3/ZeroSummable.md#ZeroSummable-w_nonneg) — `` 0 ≤ w ρ ``
- [`ZeroSummable.mem_nt`](../lean_stage3/ZeroSummable.md#ZeroSummable-mem_nt) — `` riemannZeta (ρ : ℂ) = 0 ∧ 0 < (ρ : ℂ).re ∧ (ρ : ℂ).re < 1 ``
- [`ZeroSummable.order_le_log_pos`](../lean_stage3/ZeroSummable.md#ZeroSummable-order_le_log_pos) — `` ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) ≤ 15 * Real.log ((ρ : ℂ).im + 1) + 73 ``
- [`ZeroSummable.order_le_log`](../lean_stage3/ZeroSummable.md#ZeroSummable-order_le_log) — `` ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) ≤ 15 * Real.log (|(ρ : ℂ).im| + 1) + 73 ``
- [`ZeroSummable.order_le_shell`](../lean_stage3/ZeroSummable.md#ZeroSummable-order_le_shell) — `` ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) ≤ 103 * ((j : ℝ) + 1) ``
- [`ZeroSummable.card_shell_le`](../lean_stage3/ZeroSummable.md#ZeroSummable-card_shell_le) — `` (F.card : ℝ) ≤ 2 * (C * ((2 : ℝ) ^ (j + 1) + 2) ^ θ) ``
- [`ZeroSummable.shell_sum_le`](../lean_stage3/ZeroSummable.md#ZeroSummable-shell_sum_le) — `` ∑ ρ ∈ F, w ρ ≤ 2 * (C * ((2 : ℝ) ^ (j + 1) + 2) ^ θ) * (103 * ((j : ℝ) + 1) / 2 ^ j) ``
- [`ZeroSummable.shell_bound_le`](../lean_stage3/ZeroSummable.md#ZeroSummable-shell_bound_le) — `` 2 * (C * ((2 : ℝ) ^ (j + 1) + 2) ^ θ) * (103 * ((j : ℝ) + 1) / 2 ^ j) ≤ 206 * C * (4 : ℝ) ^ (max θ 0) * (((j : ℝ) + 1) * ((2 : ℝ) ^ (max θ 0) / 2) ^ j) ``
- [`ZeroSummable.summable_shell`](../lean_stage3/ZeroSummable.md#ZeroSummable-summable_shell) — `` Summable fun j : ℕ => K * (((j : ℝ) + 1) * r ^ j) ``
- [`ZeroSummable.dyadic_index`](../lean_stage3/ZeroSummable.md#ZeroSummable-dyadic_index) — `` (2 : ℝ) ^ (Nat.log 2 ⌊x⌋₊) ≤ x ∧ x < 2 ^ (Nat.log 2 ⌊x⌋₊ + 1) ``
- [`ZeroSummable.sum_le_const`](../lean_stage3/ZeroSummable.md#ZeroSummable-sum_le_const) — `` ∃ M : ℝ, ∀ v : Finset NontrivialZeros, (∀ ρ ∈ v, σ ≤ (ρ : ℂ).re) → ∑ ρ ∈ v, w ρ ≤ M ``
- [`ZeroSummable.norm_coef`](../lean_stage3/ZeroSummable.md#ZeroSummable-norm_coef) — `` ‖LadderMean.coef ρ‖ = w ρ ``
- [`ZeroSummable.summable_norm_coef`](../lean_stage3/ZeroSummable.md#ZeroSummable-summable_norm_coef) — `` Summable fun ρ : S => ‖LadderMean.coef ρ‖ ``

### [`CountReduction`](../lean_stage3/CountReduction.md) — 3

- [`CountReduction.ratio_pow`](../lean_stage3/CountReduction.md#CountReduction-ratio_pow) — `` ((2:ℝ) ^ θ' / 2) ^ k = (2:ℝ) ^ (-(k:ℝ) * (1 - θ')) ``
- [`CountReduction.sum_tail_le`](../lean_stage3/CountReduction.md#CountReduction-sum_tail_le) — `` ∑ j ∈ s, ((j:ℝ) + 1) * r ^ j ≤ ((k:ℝ) + 1) * r ^ k * ∑' i : ℕ, ((i:ℝ) + 1) * r ^ i ``
- [`CountReduction.tail_rate`](../lean_stage3/CountReduction.md#CountReduction-tail_rate) — `` ∃ θ' Ct : ℝ, 0 ≤ θ' ∧ θ' < 1 ∧ 0 ≤ Ct ∧ ∀ (k : ℕ), 1 ≤ k → ∀ v : Finset Kadiri.NontrivialZeros, (∀ ρ ∈ v, σ ≤ (ρ:ℂ).re ∧ (2:ℝ)^k ≤ |(ρ:ℂ).im|) → ∑ ρ ∈ v, ((riem… ``

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
- [`ExplicitTwo.c1t`](../lean_stage3/ExplicitTwo.md#ExplicitTwo-c1t) — *def*
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

### [`FilterLadder`](../lean_stage3/FilterLadder.md) — 23

- [`FilterLadder.Wb`](../lean_stage3/FilterLadder.md#FilterLadder-Wb) — *def*
- [`FilterLadder.Wn`](../lean_stage3/FilterLadder.md#FilterLadder-Wn) — *def*
- [`FilterLadder.rpow_half_eq`](../lean_stage3/FilterLadder.md#FilterLadder-rpow_half_eq) — `` (2:ℝ) ^ (-(j:ℝ) / 2) = (Real.sqrt 2)⁻¹ ^ j ``
- [`FilterLadder.Wn_eq_Wb`](../lean_stage3/FilterLadder.md#FilterLadder-Wn_eq_Wb) — `` Wn q = Wb (Real.sqrt 2)⁻¹ q ``
- [`FilterLadder.Wb_eq_range`](../lean_stage3/FilterLadder.md#FilterLadder-Wb_eq_range) — `` Wb t q = ∑ j ∈ range N, ‖q.coeff j‖ * t ^ j ``
- [`FilterLadder.Wb_nonneg`](../lean_stage3/FilterLadder.md#FilterLadder-Wb_nonneg) — `` 0 ≤ Wb t q ``
- [`FilterLadder.posPoly`](../lean_stage3/FilterLadder.md#FilterLadder-posPoly) — *def*
- [`FilterLadder.coeff_posPoly`](../lean_stage3/FilterLadder.md#FilterLadder-coeff_posPoly) — `` (posPoly q).coeff i = ‖q.coeff i‖ ``
- [`FilterLadder.Wb_eq_eval`](../lean_stage3/FilterLadder.md#FilterLadder-Wb_eq_eval) — `` Wb t q = (posPoly q).eval t ``
- [`FilterLadder.natDegree_posPoly_le`](../lean_stage3/FilterLadder.md#FilterLadder-natDegree_posPoly_le) — `` (posPoly q).natDegree ≤ q.natDegree ``
- [`FilterLadder.Wb_mul_le`](../lean_stage3/FilterLadder.md#FilterLadder-Wb_mul_le) — `` Wb t (p * q) ≤ Wb t p * Wb t q ``
- [`FilterLadder.Wb_one`](../lean_stage3/FilterLadder.md#FilterLadder-Wb_one) — `` Wb t (1 : Polynomial ℂ) = 1 ``
- [`FilterLadder.Wb_pow_le`](../lean_stage3/FilterLadder.md#FilterLadder-Wb_pow_le) — `` Wb t (q ^ m) ≤ Wb t q ^ m ``
- [`FilterLadder.Wn_pow_le`](../lean_stage3/FilterLadder.md#FilterLadder-Wn_pow_le) — `` Wn (q ^ m) ≤ Wn q ^ m ``
- [`FilterLadder.filter_mode`](../lean_stage3/FilterLadder.md#FilterLadder-filter_mode) — `` ∑ j ∈ range (N + 1), (q ^ m).coeff j * z ^ (n - j) = z ^ n * (q.eval z⁻¹) ^ m ``
- [`FilterLadder.ladder`](../lean_stage3/FilterLadder.md#FilterLadder-ladder) — *def*
- [`FilterLadder.Kf`](../lean_stage3/FilterLadder.md#FilterLadder-Kf) — *def*
- [`FilterLadder.Kf_nonneg`](../lean_stage3/FilterLadder.md#FilterLadder-Kf_nonneg) — `` 0 ≤ Kf ``
- [`FilterLadder.wz`](../lean_stage3/FilterLadder.md#FilterLadder-wz) — *def*
- [`FilterLadder.formula_row`](../lean_stage3/FilterLadder.md#FilterLadder-formula_row) — `` ‖ladder k + ∑ ρ ∈ ZF ((2:ℝ) ^ n), wz ρ * ((2:ℂ) ^ (ρ : ℂ)) ^ k‖ ≤ Kf * (n:ℝ) ^ 2 ``
- [`FilterLadder.Afl`](../lean_stage3/FilterLadder.md#FilterLadder-Afl) — *def*
- [`FilterLadder.sqrt_split`](../lean_stage3/FilterLadder.md#FilterLadder-sqrt_split) — `` Real.sqrt 2 ^ n * (Real.sqrt 2)⁻¹ ^ j = Real.sqrt 2 ^ (n - j) ``
- [`FilterLadder.filtered_modes_small_sq`](../lean_stage3/FilterLadder.md#FilterLadder-filtered_modes_small_sq) — `` ‖∑ ρ ∈ (FiniteOffLine.ZF ((2:ℝ)^n)).filter (fun ρ : NontrivialZeros => σ ≤ (ρ : ℂ).re), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * (q.eval (((2:ℂ) ^ (ρ :… ``

### [`FilterAttained`](../lean_stage3/FilterAttained.md) — 9

- [`FilterAttained.xi`](../lean_stage3/FilterAttained.md#FilterAttained-xi) — *def*
- ★ [`FilterAttained.S`](../lean_stage3/FilterAttained.md#FilterAttained-S) — *def*
- [`FilterAttained.ratio`](../lean_stage3/FilterAttained.md#FilterAttained-ratio) — *def*
- [`FilterAttained.xi_pow`](../lean_stage3/FilterAttained.md#FilterAttained-xi_pow) — `` xi q a b ρ ^ k = (q.eval (((2:ℂ) ^ (ρ : ℂ))⁻¹)) ^ (a * k) * ((2:ℂ) ^ (ρ : ℂ)) ^ (b * k) ``
- [`FilterAttained.summable_S`](../lean_stage3/FilterAttained.md#FilterAttained-summable_S) — `` Summable ((S σ).indicator fun ρ => ‖LadderMean.coef ρ‖) ``
- [`FilterAttained.finite_part_le`](../lean_stage3/FilterAttained.md#FilterAttained-finite_part_le) — `` ‖∑ ρ ∈ (ZF ((2:ℝ) ^ (b * k))).filter (fun ρ : NontrivialZeros => σ ≤ (ρ : ℂ).re), LadderMean.coef ρ * ratio q a b M ρ ^ k‖ ≤ FilterLadder.Afl C * (b:ℝ) ^ 2 * (k… ``
- [`FilterAttained.tailT`](../lean_stage3/FilterAttained.md#FilterAttained-tailT) — *def*
- [`FilterAttained.norm_tailT_le`](../lean_stage3/FilterAttained.md#FilterAttained-norm_tailT_le) — `` ‖tailT q a b σ M k ρ‖ ≤ (S σ).indicator (fun ρ => ‖LadderMean.coef ρ‖) ρ ``
- [`FilterAttained.tsum_split`](../lean_stage3/FilterAttained.md#FilterAttained-tsum_split) — `` ∑' ρ, (S σ).indicator (fun ρ => LadderMean.coef ρ * ratio q a b M ρ ^ k) ρ = ∑ ρ ∈ (ZF ((2:ℝ) ^ (b * k))).filter (fun ρ : NontrivialZeros => σ ≤ (ρ : ℂ).re), La… ``

### [`ResidueRoute`](../lean_stage3/ResidueRoute.md) — 19

- ★ [`ResidueRoute.um`](../lean_stage3/ResidueRoute.md#ResidueRoute-um) — *def*
- ★ [`ResidueRoute.K`](../lean_stage3/ResidueRoute.md#ResidueRoute-K) — *def*
- [`ResidueRoute.P`](../lean_stage3/ResidueRoute.md#ResidueRoute-P) — *def*
- ★ [`ResidueRoute.G`](../lean_stage3/ResidueRoute.md#ResidueRoute-G) — *def*
- ★ [`ResidueRoute.F`](../lean_stage3/ResidueRoute.md#ResidueRoute-F) — *def*
- ★ [`ResidueRoute.isClosed_K`](../lean_stage3/ResidueRoute.md#ResidueRoute-isClosed_K) — `` IsClosed (K σ) ``
- ★ [`ResidueRoute.um_mem_K`](../lean_stage3/ResidueRoute.md#ResidueRoute-um_mem_K) — `` um ρ ∈ K σ ``
- ★ [`ResidueRoute.um_eq`](../lean_stage3/ResidueRoute.md#ResidueRoute-um_eq) — `` um ρ = ((2:ℂ) ^ (ρ : ℂ))⁻¹ ``
- ★ [`ResidueRoute.norm_um`](../lean_stage3/ResidueRoute.md#ResidueRoute-norm_um) — `` ‖um ρ‖ = (2:ℝ) ^ (-(ρ : ℂ).re) ``
- ★ [`ResidueRoute.mode_ne_zero`](../lean_stage3/ResidueRoute.md#ResidueRoute-mode_ne_zero) — `` (2:ℂ) ^ (ρ : ℂ) ≠ 0 ``
- ★ [`ResidueRoute.one_sub_eq`](../lean_stage3/ResidueRoute.md#ResidueRoute-one_sub_eq) — `` 1 - (2:ℂ) ^ (ρ : ℂ) * u = (2:ℂ) ^ (ρ : ℂ) * (um ρ - u) ``
- ★ [`ResidueRoute.norm_sub_le`](../lean_stage3/ResidueRoute.md#ResidueRoute-norm_sub_le) — `` ‖um ρ - u‖ ≤ ‖1 - (2:ℂ) ^ (ρ : ℂ) * u‖ ``
- ★ [`ResidueRoute.K_subset`](../lean_stage3/ResidueRoute.md#ResidueRoute-K_subset) — `` K σ ⊆ {u : ℂ | 1 / 2 ≤ ‖u‖} ``
- ★ [`ResidueRoute.summable_coef`](../lean_stage3/ResidueRoute.md#ResidueRoute-summable_coef) — `` Summable fun ρ : FilterAttained.S σ => ‖LadderMean.coef ρ.1‖ ``
- ★ [`ResidueRoute.differentiableAt_F`](../lean_stage3/ResidueRoute.md#ResidueRoute-differentiableAt_F) — `` DifferentiableAt ℂ (F σ) v ``
- ★ [`ResidueRoute.P_bound`](../lean_stage3/ResidueRoute.md#ResidueRoute-P_bound) — `` ∃ θ' Ct : ℝ, θ' < 1 ∧ 0 ≤ Ct ∧ ∀ σ : ℝ, σ₀ ≤ σ → Θ ≤ σ + (1 - θ') → ∀ k : ℕ, 2 ≤ k → ‖P σ k‖ ≤ (|FilterLadder.Afl C| + Ct) * (k:ℝ) ^ 2 * ((2:ℝ) ^ σ) ^ k ``
- ★ [`ResidueRoute.differentiableAt_G`](../lean_stage3/ResidueRoute.md#ResidueRoute-differentiableAt_G) — `` DifferentiableAt ℂ (G σ) v ``
- ★ [`ResidueRoute.G_eq_F`](../lean_stage3/ResidueRoute.md#ResidueRoute-G_eq_F) — `` G σ u = F σ u ``
- ★ [`ResidueRoute.fibre_term`](../lean_stage3/ResidueRoute.md#ResidueRoute-fibre_term) — `` a * (c / (z * a)) = c * z⁻¹ ``

