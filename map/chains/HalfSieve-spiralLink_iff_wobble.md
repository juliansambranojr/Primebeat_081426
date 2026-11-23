# What `HalfSieve.spiralLink_iff_wobble` rests on

[`HalfSieve.spiralLink_iff_wobble`](../lean_stage3/HalfSieve.md#HalfSieve-spiralLink_iff_wobble) in `lean_stage3/Stage3/HalfSieve.lean`, line 330.

**Why.** The loop is the sieve's wobble. The spiral link holds exactly when the sieve's roundings, measured from one half and less their smooth part, stay at square-root size.

**Proves**

```lean
SpiralLink.SpiralLink ↔ WobbleSqrt
```

Behind it: 117 theorems and 22 definitions in 12 files. Every one is listed below; Lean recorded each step.

## The files it passes through

```mermaid
flowchart LR
  f0["<b>ClosedLoopJoin</b><br/>2 used"]:::thm
  f1["<b>JensenCount</b><br/>12 used"]:::thm
  f2["<b>PsiToPi</b><br/>3 used"]:::thm
  f3["<b>LineBound</b><br/>54 used"]:::thm
  f4["<b>RowLeaves</b><br/>2 used"]:::thm
  f5["<b>SieveExact</b><br/>15 used"]:::thm
  f6["<b>SieveResidual</b><br/>3 used"]:::thm
  f7["<b>SpiralLink</b><br/>1 used"]:::thm
  f8["<b>Statement</b><br/>1 used"]:::thm
  f9["<b>VonKochScaffold</b><br/>24 used"]:::thm
  f10["<b>PiToPsi</b><br/>12 used"]:::thm
  f11["<b>HalfSieve</b><br/>spiralLink_iff_wobble"]:::end_
  f1 --> f3
  f2 --> f3
  f2 --> f4
  f2 --> f6
  f5 --> f6
  f0 --> f7
  f3 --> f9
  f4 --> f10
  f8 --> f10
  f9 --> f10
  f6 --> f11
  f7 --> f11
  f10 --> f11
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

### [`ClosedLoopJoin`](../lean_stage3/ClosedLoopJoin.md) — 2

- [`ClosedLoopJoin.primeWeight`](../lean_stage3/ClosedLoopJoin.md#ClosedLoopJoin-primeWeight) — *def*
- [`ClosedLoopJoin.isHermitianHandshake`](../lean_stage3/ClosedLoopJoin.md#ClosedLoopJoin-isHermitianHandshake) — *def*

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

### [`PsiToPi`](../lean_stage3/PsiToPi.md) — 3

- [`Stage3.Li`](../lean_stage3/PsiToPi.md#Stage3-Li) — *def*
- [`Stage3.integral_A_rpow_le`](../lean_stage3/PsiToPi.md#Stage3-integral_A_rpow_le) — `` (∫ t in a..x, A * t ^ (-(1 : ℝ) / 2)) ≤ 2 * A * Real.sqrt x ``
- [`Stage3.StmtPsiWeak`](../lean_stage3/PsiToPi.md#Stage3-StmtPsiWeak) — *def*

### [`LineBound`](../lean_stage3/LineBound.md) — 54

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
- [`RHPull.pull_at_RH_abscissa`](../lean_stage3/LineBound.md#RHPull-pull_at_RH_abscissa) — `` SmoothedChebyshev SmoothingF ε X = I₁ SmoothingF ε X T - I₂ SmoothingF ε T X (1 / 2 + 1 / Real.log X) + I₃₇ SmoothingF ε T X (1 / 2 + 1 / Real.log X) + I₈ Smoot… ``
- [`RHPull.σRH`](../lean_stage3/LineBound.md#RHPull--RH) — *def*
- [`RHPull.σRH_re`](../lean_stage3/LineBound.md#RHPull--RH_re) — `` ((σRH X : ℂ) + I * (t : ℂ)).re = σRH X ``
- [`RHPull.integrand_norm_le`](../lean_stage3/LineBound.md#RHPull-integrand_norm_le) — `` ‖SmoothedChebyshevIntegrand ν ε X ((σRH X : ℂ) + I * (t : ℂ))‖ ≤ 11100 * (Real.log X) ^ 2 * M * X ^ (σRH X) ``
- [`RHPull.integrand_norm_le_horiz`](../lean_stage3/LineBound.md#RHPull-integrand_norm_le_horiz) — `` ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) + I * (t : ℂ))‖ ≤ (1996 * Real.log (84 * t) + (29 * Real.log t + 129) * Real.log X) * M * X ^ σ ``
- [`RHPull.horiz_length`](../lean_stage3/LineBound.md#RHPull-horiz_length) — `` (1 + 1 / Real.log X) - σRH X = 1 / 2 ``
- [`RHPull.I8_norm_le`](../lean_stage3/LineBound.md#RHPull-I8_norm_le) — `` ‖I₈ ν ε T X (σRH X)‖ ≤ (1 / (2 * Real.pi)) * (1 / 2) * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ (1 + 1 / Real.log X)) ``
- [`RHPull.integrand_norm_le_horiz_neg`](../lean_stage3/LineBound.md#RHPull-integrand_norm_le_horiz_neg) — `` ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) - (T : ℂ) * I)‖ ≤ (1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ σ ``
- [`RHPull.I2_norm_le`](../lean_stage3/LineBound.md#RHPull-I2_norm_le) — `` ‖I₂ ν ε T X (σRH X)‖ ≤ (1 / (2 * Real.pi)) * (1 / 2) * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ (1 + 1 / Real.log X)) ``
- [`RHPull.norm_sq_line`](../lean_stage3/LineBound.md#RHPull-norm_sq_line) — `` ‖((σ : ℂ) + I * (t : ℂ))‖ ^ 2 = σ ^ 2 + t ^ 2 ``
- [`RHPull.half_lt_σRH`](../lean_stage3/LineBound.md#RHPull-half_lt_-RH) — `` (1:ℝ)/2 < σRH X ``
- [`RHPull.rpow_σRH`](../lean_stage3/LineBound.md#RHPull-rpow_-RH) — `` X ^ (σRH X) = Real.exp 1 * Real.sqrt X ``
- [`RHPull.kernel_modulus_le`](../lean_stage3/LineBound.md#RHPull-kernel_modulus_le) — `` ‖((x : ℂ)) ^ (w - 1)‖ ≤ 2 ``
- [`RHPull.mellin_bump_bounded`](../lean_stage3/LineBound.md#RHPull-mellin_bump_bounded) — `` ∃ B > 0, ∀ w : ℂ, 0 < w.re → w.re ≤ 2 → ‖mellin (fun x ↦ (ν x : ℂ)) w‖ ≤ B ``
- [`RHPull.mellin_smooth1_le`](../lean_stage3/LineBound.md#RHPull-mellin_smooth1_le) — `` ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) s‖ ≤ B * ‖s‖⁻¹ ``
- [`RHPull.norm_line_ge`](../lean_stage3/LineBound.md#RHPull-norm_line_ge) — `` (1 + |t|) / 3 ≤ ‖((σRH X : ℂ)) + I * (t : ℂ)‖ ``
- [`RHPull.integral_shift_inv`](../lean_stage3/LineBound.md#RHPull-integral_shift_inv) — `` ∫ t in (0:ℝ)..T, (1 + t)⁻¹ = Real.log (1 + T) ``
- [`RHPull.integral_abs_kernel`](../lean_stage3/LineBound.md#RHPull-integral_abs_kernel) — `` ∫ t in (-T)..T, (1 + |t|)⁻¹ = 2 * Real.log (1 + T) ``
- [`RHPull.I37_norm_le_epsfree`](../lean_stage3/LineBound.md#RHPull-I37_norm_le_epsfree) — `` ‖I₃₇ ν ε T X (σRH X)‖ ≤ (1 / (2 * Real.pi)) * (6 * Real.log (1 + T)) * (11100 * (Real.log X) ^ 2 * B * X ^ (σRH X)) ``
- [`RHPull.I37_sqrt_log3`](../lean_stage3/LineBound.md#RHPull-I37_sqrt_log3) — `` ‖I₃₇ ν ε T X (σRH X)‖ ≤ (66600 * Real.exp 1 * B / Real.pi) * Real.sqrt X * (Real.log X) ^ 3 ``
- [`RHPull.psi_sub_self_le`](../lean_stage3/LineBound.md#RHPull-psi_sub_self_le) — `` |ψ X - X| ≤ E₁ + E₂ + E₃ ``
- [`RHPull.bump_exists`](../lean_stage3/LineBound.md#RHPull-bump_exists) — `` ∃ ν : ℝ → ℝ, ContDiff ℝ 1 ν ∧ (∀ x > 0, 0 ≤ ν x) ∧ ν.support ⊆ Set.Icc (1/2 : ℝ) 2 ∧ ∫ x in Set.Ioi (0:ℝ), ν x / x = 1 ``
- [`RHPull.norm_ge_height`](../lean_stage3/LineBound.md#RHPull-norm_ge_height) — `` T ≤ ‖((σ : ℂ)) + I * (T : ℂ)‖ ``
- [`RHPull.mellin_horiz_le`](../lean_stage3/LineBound.md#RHPull-mellin_horiz_le) — `` ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) + I * (T : ℂ))‖ ≤ B / T ``
- [`RHPull.inv_sqrt_mul_self`](../lean_stage3/LineBound.md#RHPull-inv_sqrt_mul_self) — `` (Real.sqrt X)⁻¹ * X = Real.sqrt X ``
- [`RHPull.instantiation_arithmetic`](../lean_stage3/LineBound.md#RHPull-instantiation_arithmetic) — `` c * (Real.sqrt X)⁻¹ * X * Real.log X ≤ c * Real.sqrt X * (Real.log X) ^ 3 ∧ c * X * Real.log X / Real.sqrt X ≤ c * Real.sqrt X * (Real.log X) ^ 3 ∧ c * ((Real.s… ``
- [`RHPull.horiz_small`](../lean_stage3/LineBound.md#RHPull-horiz_small) — `` (1 / (2 * Real.pi)) * (1 / 2) * ((1996 * Real.log (84 * X) + (29 * Real.log X + 129) * Real.log X) * (B / X) * (Real.exp 1 * X)) ≤ (900 * Real.exp 1 * B / Real.… ``
- [`RHPull.mellin_main_const`](../lean_stage3/LineBound.md#RHPull-mellin_main_const) — `` ∃ Cmain > 0, ∃ ε₀ > 0, ∀ ε : ℝ, 0 < ε → ε < ε₀ → ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 - 1‖ ≤ Cmain * ε ``
- [`RHPull.contour_at_instantiation`](../lean_stage3/LineBound.md#RHPull-contour_at_instantiation) — `` ‖SmoothedChebyshev ν ε X - mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 * X‖ ≤ B₁ + B₉ + (66600 * Real.exp 1 * B / Real.pi) * Real.sqrt X * (Real.log X) ^ 3 + (1 / (2… ``
- [`RHPull.norm_ge_height_neg`](../lean_stage3/LineBound.md#RHPull-norm_ge_height_neg) — `` T ≤ ‖((σ : ℂ)) - (T : ℂ) * I‖ ``
- [`RHPull.mellin_horiz_le_neg`](../lean_stage3/LineBound.md#RHPull-mellin_horiz_le_neg) — `` ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) - (T : ℂ) * I)‖ ≤ B / T ``
- [`RHPull.mellin_vert_le`](../lean_stage3/LineBound.md#RHPull-mellin_vert_le) — `` ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σRH X : ℂ) + I * (t : ℂ))‖ ≤ B * ‖((σRH X : ℂ)) + I * (t : ℂ)‖⁻¹ ``
- [`RHPull.rpow_one_add`](../lean_stage3/LineBound.md#RHPull-rpow_one_add) — `` X ^ (1 + 1 / Real.log X) = Real.exp 1 * X ``
- [`RHPull.psi_weak_of_RH`](../lean_stage3/LineBound.md#RHPull-psi_weak_of_RH) — `` ∃ C > 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t → |ψ t - t| ≤ C * Real.sqrt t * (Real.log t) ^ 3 ``
- [`RHPull.stmtPsiWeak_of_RH`](../lean_stage3/LineBound.md#RHPull-stmtPsiWeak_of_RH) — `` ∃ C > 0, ∃ x₀ : ℝ, Stage3.StmtPsiWeak C 3 x₀ ``

### [`RowLeaves`](../lean_stage3/RowLeaves.md) — 2

- [`Stage3.continuousOn_inv_log_sq_Ioi`](../lean_stage3/RowLeaves.md#Stage3-continuousOn_inv_log_sq_Ioi) — `` ContinuousOn (fun t : ℝ => 1 / Real.log t ^ 2) (Ioi 1) ``
- [`Stage3.hasDerivAt_Li`](../lean_stage3/RowLeaves.md#Stage3-hasDerivAt_Li) — `` HasDerivAt Li (1 / Real.log y) y ``

### [`SieveExact`](../lean_stage3/SieveExact.md) — 15

- [`SieveExact.smallPrimes`](../lean_stage3/SieveExact.md#SieveExact-smallPrimes) — *def*
- [`SieveExact.survivors`](../lean_stage3/SieveExact.md#SieveExact-survivors) — *def*
- [`SieveExact.prime_of_mem_smallPrimes`](../lean_stage3/SieveExact.md#SieveExact-prime_of_mem_smallPrimes) — `` p.Prime ``
- [`SieveExact.forall_dvd_iff_prod_dvd`](../lean_stage3/SieveExact.md#SieveExact-forall_dvd_iff_prod_dvd) — `` (∀ p ∈ T, p ∣ n) ↔ (∏ p ∈ T, p) ∣ n ``
- [`SieveExact.card_filter_not_dvd`](../lean_stage3/SieveExact.md#SieveExact-card_filter_not_dvd) — `` ((A.filter (fun n => ∀ p ∈ s, ¬ p ∣ n)).card : ℤ) = ∑ T ∈ s.powerset, (-1 : ℤ) ^ T.card * ((A.filter (fun n => (∏ p ∈ T, p) ∣ n)).card : ℤ) ``
- [`SieveExact.card_multiples`](../lean_stage3/SieveExact.md#SieveExact-card_multiples) — `` ((Finset.Icc 1 N).filter (fun n => d ∣ n)).card = N / d ``
- [`SieveExact.sieve_sum`](../lean_stage3/SieveExact.md#SieveExact-sieve_sum) — `` ((survivors N).card : ℤ) = ∑ T ∈ (smallPrimes N).powerset, (-1 : ℤ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℤ) ``
- [`SieveExact.survivors_eq`](../lean_stage3/SieveExact.md#SieveExact-survivors_eq) — `` survivors N = insert 1 ((Finset.Icc 1 N).filter (fun n => Nat.Prime n ∧ Nat.sqrt N < n)) ``
- [`SieveExact.card_survivors`](../lean_stage3/SieveExact.md#SieveExact-card_survivors) — `` (survivors N).card + Nat.primeCounting (Nat.sqrt N) = 1 + Nat.primeCounting N ``
- [`SieveExact.smoothPart`](../lean_stage3/SieveExact.md#SieveExact-smoothPart) — *def*
- [`SieveExact.netRounding`](../lean_stage3/SieveExact.md#SieveExact-netRounding) — *def*
- [`SieveExact.natDiv_eq_sub_fract`](../lean_stage3/SieveExact.md#SieveExact-natDiv_eq_sub_fract) — `` ((n / d : ℕ) : ℚ) = (n : ℚ) / (d : ℚ) - Int.fract ((n : ℚ) / (d : ℚ)) ``
- [`SieveExact.sieve_split`](../lean_stage3/SieveExact.md#SieveExact-sieve_split) — `` ((survivors N).card : ℚ) = smoothPart N - netRounding N ``
- [`SieveExact.smoothPart_eq_prod`](../lean_stage3/SieveExact.md#SieveExact-smoothPart_eq_prod) — `` smoothPart N = (N : ℚ) * ∏ p ∈ smallPrimes N, (1 - 1 / (p : ℚ)) ``
- [`SieveExact.netRounding_eq`](../lean_stage3/SieveExact.md#SieveExact-netRounding_eq) — `` netRounding N = (N : ℚ) * ∏ p ∈ smallPrimes N, (1 - 1 / (p : ℚ)) - (1 + (Nat.primeCounting N : ℚ) - (Nat.primeCounting (Nat.sqrt N) : ℚ)) ``

### [`SieveResidual`](../lean_stage3/SieveResidual.md) — 3

- [`SieveResidual.smoothNet`](../lean_stage3/SieveResidual.md#SieveResidual-smoothNet) — *def*
- [`SieveResidual.cast_netRounding`](../lean_stage3/SieveResidual.md#SieveResidual-cast_netRounding) — `` ((netRounding N : ℚ) : ℝ) = (N : ℝ) * ∏ p ∈ smallPrimes N, (1 - 1 / (p : ℝ)) - (1 + (Nat.primeCounting N : ℝ) - (Nat.primeCounting (Nat.sqrt N) : ℝ)) ``
- [`SieveResidual.net_wobble`](../lean_stage3/SieveResidual.md#SieveResidual-net_wobble) — `` ((netRounding N : ℚ) : ℝ) - smoothNet N = -(((Nat.primeCounting N : ℝ) - Stage3.Li (N : ℝ)) - ((Nat.primeCounting (Nat.sqrt N) : ℝ) - Stage3.Li ((Nat.sqrt N : ℕ… ``

### [`SpiralLink`](../lean_stage3/SpiralLink.md) — 1

- ★ [`SpiralLink.SpiralLink`](../lean_stage3/SpiralLink.md#SpiralLink-SpiralLink) — *def*

### [`Statement`](../lean_stage3/Statement.md) — 1

- [`Stage3.StmtSchoenfeldWeak`](../lean_stage3/Statement.md#Stage3-StmtSchoenfeldWeak) — *def*

### [`VonKochScaffold`](../lean_stage3/VonKochScaffold.md) — 24

- [`VonKoch.E`](../lean_stage3/VonKochScaffold.md#VonKoch-E) — *def*
- [`VonKoch.F`](../lean_stage3/VonKochScaffold.md#VonKoch-F) — *def*
- [`VonKoch.Etr`](../lean_stage3/VonKochScaffold.md#VonKoch-Etr) — *def*
- [`VonKoch.measurable_psi'`](../lean_stage3/VonKochScaffold.md#VonKoch-measurable_psi-) — `` Measurable (fun t : ℝ ↦ ψ t) ``
- [`VonKoch.Etr_measurable`](../lean_stage3/VonKochScaffold.md#VonKoch-Etr_measurable) — `` Measurable Etr ``
- [`VonKoch.E_le_linear`](../lean_stage3/VonKochScaffold.md#VonKoch-E_le_linear) — `` ‖(E t : ℝ)‖ ≤ (Real.log 4 + 5) * t ``
- [`VonKoch.E_integral_eq_mellin`](../lean_stage3/VonKochScaffold.md#VonKoch-E_integral_eq_mellin) — `` ∫ x in Set.Ioi (1:ℝ), (E x : ℂ) * (x : ℂ) ^ (-s - 1) = mellin Etr (-s) ``
- [`VonKoch.Etr_locallyIntegrable`](../lean_stage3/VonKochScaffold.md#VonKoch-Etr_locallyIntegrable) — `` MeasureTheory.LocallyIntegrableOn Etr (Set.Ioi 0) ``
- [`VonKoch.F_differentiableAt`](../lean_stage3/VonKochScaffold.md#VonKoch-F_differentiableAt) — `` DifferentiableAt ℂ F s ``
- [`VonKoch.sum_Icc_vonMangoldt`](../lean_stage3/VonKochScaffold.md#VonKoch-sum_Icc_vonMangoldt) — `` ∑ k ∈ Finset.Icc 1 n, ArithmeticFunction.vonMangoldt k = ψ n ``
- [`VonKoch.psi_partial_bigO`](../lean_stage3/VonKochScaffold.md#VonKoch-psi_partial_bigO) — `` (fun n : ℕ ↦ ∑ k ∈ Finset.Icc 1 n, ArithmeticFunction.vonMangoldt k) =O[Filter.atTop] fun n : ℕ ↦ (n : ℝ) ^ (1:ℝ) ``
- [`VonKoch.measurable_psi`](../lean_stage3/VonKochScaffold.md#VonKoch-measurable_psi) — `` Measurable (fun t : ℝ ↦ ψ t) ``
- [`VonKoch.integrable_psi_cpow`](../lean_stage3/VonKochScaffold.md#VonKoch-integrable_psi_cpow) — `` IntegrableOn (fun t : ℝ ↦ ((ψ t : ℝ) : ℂ) * (t : ℂ) ^ (-(s + 1))) (Set.Ioi (1:ℝ)) ``
- [`VonKoch.F_eq_neg_logDeriv`](../lean_stage3/VonKochScaffold.md#VonKoch-F_eq_neg_logDeriv) — `` F s = -deriv riemannZeta s / riemannZeta s ``
- [`VonKoch.region`](../lean_stage3/VonKochScaffold.md#VonKoch-region) — *def*
- [`VonKoch.isOpen_region`](../lean_stage3/VonKochScaffold.md#VonKoch-isOpen_region) — `` IsOpen region ``
- [`VonKoch.preconnected_region`](../lean_stage3/VonKochScaffold.md#VonKoch-preconnected_region) — `` IsPreconnected region ``
- [`VonKoch.zeta_analyticOnNhd`](../lean_stage3/VonKochScaffold.md#VonKoch-zeta_analyticOnNhd) — `` AnalyticOnNhd ℂ riemannZeta region ``
- [`VonKoch.F_analyticOnNhd`](../lean_stage3/VonKochScaffold.md#VonKoch-F_analyticOnNhd) — `` AnalyticOnNhd ℂ F region ``
- [`VonKoch.F_mul_zeta_add_deriv_eqOn_zero`](../lean_stage3/VonKochScaffold.md#VonKoch-F_mul_zeta_add_deriv_eqOn_zero) — `` Set.EqOn (fun s : ℂ ↦ F s * riemannZeta s + deriv riemannZeta s) 0 region ``
- [`VonKoch.no_zero_right_of_half`](../lean_stage3/VonKochScaffold.md#VonKoch-no_zero_right_of_half) — `` riemannZeta ρ ≠ 0 ``
- [`VonKoch.RH_of_no_zero_right_of_half`](../lean_stage3/VonKochScaffold.md#VonKoch-RH_of_no_zero_right_of_half) — `` RiemannHypothesis ``
- [`VonKoch.RH_of_psiWeak`](../lean_stage3/VonKochScaffold.md#VonKoch-RH_of_psiWeak) — `` RiemannHypothesis ``
- [`VonKoch.RH_iff_psiWeak`](../lean_stage3/VonKochScaffold.md#VonKoch-RH_iff_psiWeak) — `` RiemannHypothesis ↔ ∃ C > 0, ∃ x₀ : ℝ, Stage3.StmtPsiWeak C 3 x₀ ``

### [`PiToPsi`](../lean_stage3/PiToPsi.md) — 12

- [`PiToPsi.Li_two`](../lean_stage3/PiToPsi.md#PiToPsi-Li_two) — `` Stage3.Li 2 = 2 / Real.log 2 ``
- [`PiToPsi.continuousOn_Li`](../lean_stage3/PiToPsi.md#PiToPsi-continuousOn_Li) — `` ContinuousOn Stage3.Li (Ioi 1) ``
- [`PiToPsi.uIcc_two_subset`](../lean_stage3/PiToPsi.md#PiToPsi-uIcc_two_subset) — `` uIcc (2 : ℝ) x ⊆ Ioi 1 ``
- [`PiToPsi.intervalIntegrable_Li_div`](../lean_stage3/PiToPsi.md#PiToPsi-intervalIntegrable_Li_div) — `` IntervalIntegrable (fun t : ℝ => Stage3.Li t / t) volume 2 x ``
- [`PiToPsi.intervalIntegrable_pi_div`](../lean_stage3/PiToPsi.md#PiToPsi-intervalIntegrable_pi_div) — `` IntervalIntegrable (fun t : ℝ => (Nat.primeCounting ⌊t⌋₊ : ℝ) / t) volume 2 x ``
- [`PiToPsi.Li_mul_log_sub_integral`](../lean_stage3/PiToPsi.md#PiToPsi-Li_mul_log_sub_integral) — `` Stage3.Li x * Real.log x - ∫ t in (2 : ℝ)..x, Stage3.Li t / t = x ``
- [`PiToPsi.relRes`](../lean_stage3/PiToPsi.md#PiToPsi-relRes) — *def*
- [`PiToPsi.intervalIntegrable_relRes`](../lean_stage3/PiToPsi.md#PiToPsi-intervalIntegrable_relRes) — `` IntervalIntegrable relRes volume 2 x ``
- [`PiToPsi.theta_sub_id_eq`](../lean_stage3/PiToPsi.md#PiToPsi-theta_sub_id_eq) — `` θ x - x = ((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x) * Real.log x - ∫ t in (2 : ℝ)..x, relRes t ``
- [`PiToPsi.relRes_tail_le`](../lean_stage3/PiToPsi.md#PiToPsi-relRes_tail_le) — `` (∫ t in x₀..x, |relRes t|) ≤ 2 * (C * Real.log x) * Real.sqrt x ``
- [`PiToPsi.psiWeak_of_schoenfeldWeak`](../lean_stage3/PiToPsi.md#PiToPsi-psiWeak_of_schoenfeldWeak) — `` ∃ C' > 0, ∃ x₁ : ℝ, StmtPsiWeak C' 3 x₁ ``
- [`PiToPsi.RH_of_schoenfeldWeak`](../lean_stage3/PiToPsi.md#PiToPsi-RH_of_schoenfeldWeak) — `` RiemannHypothesis ``

### [`HalfSieve`](../lean_stage3/HalfSieve.md) — 10

- [`HalfSieve.wobble`](../lean_stage3/HalfSieve.md#HalfSieve-wobble) — *def*
- [`HalfSieve.resid`](../lean_stage3/HalfSieve.md#HalfSieve-resid) — *def*
- [`HalfSieve.resid_step`](../lean_stage3/HalfSieve.md#HalfSieve-resid_step) — `` resid N = resid (Nat.sqrt N) - wobble N ``
- [`HalfSieve.resid_of_wobble`](../lean_stage3/HalfSieve.md#HalfSieve-resid_of_wobble) — `` ∃ K : ℝ, 0 ≤ K ∧ ∀ N : ℕ, 2 ≤ N → |resid N| ≤ K * Real.sqrt (N : ℝ) * Real.log (N : ℝ) ``
- [`HalfSieve.Li_floor_close`](../lean_stage3/HalfSieve.md#HalfSieve-Li_floor_close) — `` |Stage3.Li x - Stage3.Li (n : ℝ)| ≤ 2 ``
- [`HalfSieve.schoenfeld_of_wobble`](../lean_stage3/HalfSieve.md#HalfSieve-schoenfeld_of_wobble) — `` ∃ K : ℝ, StmtSchoenfeldWeak K 1 2 (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li ``
- ★ [`HalfSieve.WobbleSqrt`](../lean_stage3/HalfSieve.md#HalfSieve-WobbleSqrt) — *def*
- [`HalfSieve.wobble_all`](../lean_stage3/HalfSieve.md#HalfSieve-wobble_all) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ N : ℕ, 2 ≤ N → |wobble N| ≤ C * Real.sqrt (N : ℝ) * Real.log (N : ℝ) ``
- ★ [`HalfSieve.spiralLink_of_wobble`](../lean_stage3/HalfSieve.md#HalfSieve-spiralLink_of_wobble) — `` SpiralLink.SpiralLink ``
- ★ [`HalfSieve.wobble_of_spiralLink`](../lean_stage3/HalfSieve.md#HalfSieve-wobble_of_spiralLink) — `` WobbleSqrt ``

