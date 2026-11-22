# `lean_stage3/Stage3/ThetaPsi.lean`

**What it does** (its own header): ThetaPsi — `|ψ(X) − X| ≤ C·X^θ·log³X` from a zero-free half-plane `re > θ`. WHAT THIS PORTS. The last stretch of `RHPull` (`LineBound.lean`):

**Imports:** [`ThetaPull`](../lean_stage3/ThetaPull.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`ThetaPi`](../lean_stage3/ThetaPi.md).

```mermaid
flowchart LR
  n0["inv_log_le_theta<br/>⊢ 1 / Real.log X ≤ (1 - θ) / 2"]:::thm
  n1["σθ_lt_one<br/>⊢ σθ θ X ＜ 1"]:::end_
  n2["lt_σθ<br/>⊢ θ ＜ σθ θ X"]:::lone
  n3["horiz_length_theta<br/>⊢ (1 + 1 / Real.log X) - σθ θ X = 1 - θ"]:::thm
  n4["holo_logDerivZeta_theta<br/>⊢ HolomorphicOn (deriv riemannZeta / riemannZeta) (Set.Icc σ₁ 2 ×ℂ Set.I…"]:::thm
  n5["pull_at_theta_abscissa<br/>⊢ SmoothedChebyshev SmoothingF ε X = I₁ SmoothingF ε X T - I₂ SmoothingF…"]:::thm
  n6["integrand_norm_le_horiz_theta<br/>⊢ ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) + I * (t : ℂ))‖ ≤ (1996 * R…"]:::thm
  n7["integrand_norm_le_horiz_neg_theta<br/>⊢ ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) - (T : ℂ) * I)‖ ≤ (1996 * R…"]:::thm
  n8["I8_norm_le_theta<br/>⊢ ‖I₈ ν ε T X (σθ θ X)‖ ≤ (1 / (2 * Real.pi)) * (1 - θ) * ((1996 * Real.…"]:::thm
  n9["I2_norm_le_theta<br/>⊢ ‖I₂ ν ε T X (σθ θ X)‖ ≤ (1 / (2 * Real.pi)) * (1 - θ) * ((1996 * Real.…"]:::thm
  n10["mellin_vert_le_theta<br/>⊢ ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σθ θ X : ℂ) + I * (t : ℂ))‖ ≤ …"]:::thm
  n11["contour_at_instantiation_theta<br/>⊢ ‖SmoothedChebyshev ν ε X - mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 * X‖…"]:::thm
  n12["theta_instantiation_arithmetic<br/>⊢ c * (X ^ (1 - θ))⁻¹ * X * Real.log X ≤ c * X ^ θ * (Real.log X) ^ 3 ∧ …"]:::thm
  n13["psi_weak_of_theta<br/>⊢ ∃ C ＞ 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t → |ψ t - t| ≤ C * t ^ θ * (Real.log…"]:::thm
  n14["psi_weak_of_RH_half<br/>⊢ ∃ C ＞ 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t → |ψ t - t| ≤ C * Real.sqrt t * (Re…"]:::thm
  n15["stmtPsiWeak_of_RH_half<br/>⊢ ∃ C ＞ 0, ∃ x₀ : ℝ, Stage3.StmtPsiWeak C 3 x₀"]:::end_
  x0(["Abscissa · StmtZeroFreeRight"]):::ext
  x1(["Abscissa · logDerivZeta_crude_theta"]):::ext
  x2(["Abscissa · zeroFreeRight_of_RH"]):::ext
  x3(["Abscissa · zeta_ne_zero_right_of"]):::ext
  x4(["JointWindowDial · psiWeakTheta_of_window"]):::ext
  x5(["LineBound · bump_exists"]):::ext
  x6(["LineBound · horiz_small"]):::ext
  x7(["LineBound · mellin_bump_bounded"]):::ext
  x8(["LineBound · mellin_horiz_le"]):::ext
  x9(["LineBound · mellin_horiz_le_neg"]):::ext
  x10(["LineBound · mellin_main_const"]):::ext
  x11(["LineBound · mellin_smooth1_le"]):::ext
  x12(["LineBound · psi_sub_self_le"]):::ext
  x13(["LineBound · rpow_one_add"]):::ext
  x14(["LineBound · logDerivZeta_norm_neg"]):::ext
  x15(["PsiToPi · StmtPsiWeak"]):::ext
  x16(["ThetaConverse · zeroFreeRight_iff_psiWeakTheta"]):::ext
  x17(["ThetaPi · schoenfeldWeakTheta_of_zeroFree"]):::ext
  x18(["ThetaPull · I37_power_log3_theta"]):::ext
  x19(["ThetaPull · four_le_log_of_theta"]):::ext
  n0 --> n1
  n10 --> n13
  n11 --> n13
  n12 --> n13
  n13 --> n14
  n13 --> x16
  n13 --> x17
  n13 --> x4
  n14 --> n15
  n3 --> n8
  n3 --> n9
  n4 --> n5
  n5 --> n11
  n6 --> n8
  n7 --> n9
  n8 --> n11
  n9 --> n11
  x0 --> n11
  x0 --> n13
  x0 --> n4
  x0 --> n5
  x0 --> n6
  x0 --> n7
  x0 --> n8
  x0 --> n9
  x1 --> n6
  x1 --> n7
  x10 --> n13
  x11 --> n10
  x12 --> n13
  x13 --> n13
  x14 --> n7
  x15 --> n15
  x18 --> n11
  x19 --> n10
  x19 --> n13
  x19 --> n5
  x19 --> n6
  x19 --> n7
  x19 --> n8
  x19 --> n9
  x2 --> n14
  x3 --> n4
  x5 --> n13
  x6 --> n13
  x7 --> n13
  x8 --> n13
  x9 --> n13
  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef dfn fill:#f2f2f2,stroke:#777,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111,stroke-dasharray:2 2
```

Blue: theorem. Green: a theorem nothing else uses (an end). Dashed white: connects to nothing. Grey: definition. Red: contains `sorry`. Yellow: in another file. An arrow A → B reads "A is used by B".

## Every declaration

| declaration | proves (output) | needs (input) | why (its own docstring) | uses | used by |
|---|---|---|---|---|---|
| `Stage3.inv_log_le_theta`<br/>theorem, line 62 | 1 / Real.log X ≤ (1 - θ) / 2 | hθhi : θ &lt; 1; hLX : 2 / (1 - θ) ≤ Real.log X | — | — | `Stage3.σθ_lt_one` |
| `Stage3.σθ_lt_one`<br/>theorem, line 72 | σθ θ X &lt; 1 | hθhi : θ &lt; 1; hLX : 2 / (1 - θ) ≤ Real.log X | — | `Stage3.inv_log_le_theta` | — |
| `Stage3.lt_σθ`<br/>theorem, line 77 | θ &lt; σθ θ X | hLX : 0 &lt; Real.log X | — | — | — |
| `Stage3.horiz_length_theta`<br/>theorem, line 82 | (1 + 1 / Real.log X) - σθ θ X = 1 - θ | θ X : ℝ | The horizontal segment has length exactly `1 − θ`. | — | `Stage3.I2_norm_le_theta`, `Stage3.I8_norm_le_theta` |
| `Stage3.holo_logDerivZeta_theta`<br/>theorem, line 88 | HolomorphicOn (deriv riemannZeta / riemannZeta) (Set.Icc σ₁ 2 ×ℂ Set.Icc (-T) T \ {1}) | hθ : StmtZeroFreeRight θ; hσ : θ &lt; σ₁ | The holomorphy hypothesis is free right of a zero-free abscissa. | `Stage3.StmtZeroFreeRight`, `Stage3.zeta_ne_zero_right_of` | `Stage3.pull_at_theta_abscissa` |
| `Stage3.pull_at_theta_abscissa`<br/>theorem, line 103 | SmoothedChebyshev SmoothingF ε X = I₁ SmoothingF ε X T - I₂ SmoothingF ε T X (σθ θ X) + I₃₇ SmoothingF ε T X (σθ θ X) + I₈ SmoothingF ε T X (σθ θ X) + I₉ SmoothingF ε X T + mellin (fun x ↦ (Smooth1 SmoothingF ε x : ℂ)) 1 * X | hθ : StmtZeroFreeRight θ; hθlo : 1/2 ≤ θ; hθhi : θ &lt; 1; ε_pos : 0 &lt; ε; ε_lt_one : ε &lt; 1; X : ℝ; X_gt : 3 &lt; X; T_pos : 0 &lt; T; hLX : 2 / (1 - θ) ≤ Real.log X; suppSmoothingF : Function.support SmoothingF ⊆ Set.Icc (1 / 2) 2; SmoothingFnonneg : ∀ x &gt; 0, 0 ≤ SmoothingF x; mass_one : ∫ x in Set.Ioi 0, SmoothingF x / x = 1; ContDiffSmoothingF : ContDiff ℝ 1 SmoothingF | The pull, instantiated at abscissa `θ`. `RHPull.pull_at_RH_abscissa` with `σθ θ X` for `σRH X`. | `Stage3.StmtZeroFreeRight`, `Stage3.holo_logDerivZeta_theta`, `Stage3.four_le_log_of_theta` | `Stage3.contour_at_instantiation_theta` |
| `Stage3.integrand_norm_le_horiz_theta`<br/>theorem, line 131 | ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) + I * (t : ℂ))‖ ≤ (1996 * Real.log (84 * t) + (29 * Real.log t + 129) * Real.log X) * M * X ^ σ | hθ : StmtZeroFreeRight θ; hθlo : 1/2 ≤ θ; hθhi : θ &lt; 1; hX : 0 &lt; X; hLX : 2 / (1 - θ) ≤ Real.log X; ht : 2 ≤ t; hσlo : σθ θ X ≤ σ; hσhi : σ ≤ 1 + 1 / Real.log X; hMel : ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) + I * (t : ℂ))‖ ≤ M | Pointwise bound on the upper horizontal segment, from the crude bound at `θ`. Every numeral is `RHPull.integrand_norm_le_horiz`'s. | `Stage3.StmtZeroFreeRight`, `Stage3.logDerivZeta_crude_theta`, `Stage3.four_le_log_of_theta` | `Stage3.I8_norm_le_theta` |
| `Stage3.integrand_norm_le_horiz_neg_theta`<br/>theorem, line 178 | ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) - (T : ℂ) * I)‖ ≤ (1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ σ | hθ : StmtZeroFreeRight θ; hθlo : 1/2 ≤ θ; hθhi : θ &lt; 1; hX : 0 &lt; X; hLX : 2 / (1 - θ) ≤ Real.log X; hT : 2 ≤ T; hσlo : σθ θ X ≤ σ; hσhi : σ ≤ 1 + 1 / Real.log X; hMel : ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) - (T : ℂ) * I)‖ ≤ M | Pointwise bound on the lower horizontal segment, through the conjugate symmetry `Slice4b.logDerivZeta_norm_neg`. | `Stage3.StmtZeroFreeRight`, `Stage3.logDerivZeta_crude_theta`, `Slice4b.logDerivZeta_norm_neg`, `Stage3.four_le_log_of_theta` | `Stage3.I2_norm_le_theta` |
| `Stage3.I8_norm_le_theta`<br/>theorem, line 227 | ‖I₈ ν ε T X (σθ θ X)‖ ≤ (1 / (2 * Real.pi)) * (1 - θ) * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ (1 + 1 / Real.log X)) | hθ : StmtZeroFreeRight θ; hθlo : 1/2 ≤ θ; hθhi : θ &lt; 1; hX : 0 &lt; X; hLX : 2 / (1 - θ) ≤ Real.log X; hT : 2 ≤ T; hMel : ∀ σ : ℝ, σθ θ X ≤ σ → σ ≤ 1 + 1 / Real.log X → ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) + I * (T : ℂ))‖ ≤ M | I₈ bounded at abscissa `θ` — the upper horizontal segment, length `1 − θ`. | `Stage3.StmtZeroFreeRight`, `Stage3.horiz_length_theta`, `Stage3.integrand_norm_le_horiz_theta`, `Stage3.four_le_log_of_theta` | `Stage3.contour_at_instantiation_theta` |
| `Stage3.I2_norm_le_theta`<br/>theorem, line 282 | ‖I₂ ν ε T X (σθ θ X)‖ ≤ (1 / (2 * Real.pi)) * (1 - θ) * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ (1 + 1 / Real.log X)) | hθ : StmtZeroFreeRight θ; hθlo : 1/2 ≤ θ; hθhi : θ &lt; 1; hX : 0 &lt; X; hLX : 2 / (1 - θ) ≤ Real.log X; hT : 2 ≤ T; hMel : ∀ σ : ℝ, σθ θ X ≤ σ → σ ≤ 1 + 1 / Real.log X → ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) - (T : ℂ) * I)‖ ≤ M | I₂ bounded at abscissa `θ` — the lower horizontal segment, length `1 − θ`. | `Stage3.StmtZeroFreeRight`, `Stage3.horiz_length_theta`, `Stage3.integrand_norm_le_horiz_neg_theta`, `Stage3.four_le_log_of_theta` | `Stage3.contour_at_instantiation_theta` |
| `Stage3.mellin_vert_le_theta`<br/>theorem, line 337 | ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σθ θ X : ℂ) + I * (t : ℂ))‖ ≤ B * ‖((σθ θ X : ℂ)) + I * (t : ℂ)‖⁻¹ | hθlo : 1/2 ≤ θ; hθhi : θ &lt; 1; diffν : ContDiff ℝ 1 ν; suppν : ν.support ⊆ Set.Icc (1/2 : ℝ) 2; hB : ∀ w : ℂ, 0 &lt; w.re → w.re ≤ 2 → ‖mellin (fun x ↦ (ν x : ℂ)) w‖ ≤ B; hε : 0 &lt; ε; hε1 : ε &lt; 1; hLX : 2 / (1 - θ) ≤ Real.log X; t : ℝ | — | `RHPull.mellin_smooth1_le`, `Stage3.four_le_log_of_theta` | `Stage3.psi_weak_of_theta` |
| `Stage3.contour_at_instantiation_theta`<br/>theorem, line 359 | ‖SmoothedChebyshev ν ε X - mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 * X‖ ≤ B₁ + B₉ + (66600 * Real.exp 1 * B / Real.pi) * X ^ θ * (Real.log X) ^ 3 + (1 / (2 * Real.pi)) * (1 - θ) * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M₈ * X ^ (1 + 1 / Real.log X)) + (1 / (2 * Real.pi)) * (1 - θ) * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M₂ * X ^ (1 + 1 / Real.log X)) | hθ : StmtZeroFreeRight θ; hθlo : 1/2 ≤ θ; hθhi : θ &lt; 1; ε_pos : 0 &lt; ε; ε_lt_one : ε &lt; 1; X_gt : 3 &lt; X; hX : 0 &lt; X; hLX : 2 / (1 - θ) ≤ Real.log X; hT2 : 2 ≤ T; hTX : T ≤ X; hB : 0 ≤ B; suppν : Function.support ν ⊆ Set.Icc (1 / 2) 2; νnonneg : ∀ x &gt; 0, 0 ≤ ν x; mass_one : ∫ x in Set.Ioi 0, ν x / x = 1; diffν : ContDiff ℝ 1 ν; hB1 : ‖I₁ ν ε X T‖ ≤ B₁; hB9 : ‖I₉ ν ε X T‖ ≤ B₉; hMel37 : ∀ t : ℝ, ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σθ θ X : ℂ) + I * (t : ℂ))‖ ≤ B * ‖((σθ θ X : ℂ)) + I * (t : ℂ)‖⁻¹; hMel8 : ∀ σ : ℝ, σθ θ X ≤ σ → σ ≤ 1 + 1 / Real.log X → ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) + I * (T : ℂ))‖ ≤ M₈; hMel2 : ∀ σ : ℝ, σθ θ X ≤ σ → σ ≤ 1 + 1 / Real.log X → ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) - (T : ℂ) * I)‖ ≤ M₂ | Every contour piece summed at abscissa `θ`. `RHPull.contour_at_instantiation` with `X^θ` for `√X` on the vertical piece and `1 − θ` for `1/2` on the horizontal lengths. | `Stage3.StmtZeroFreeRight`, `Stage3.I2_norm_le_theta`, `Stage3.I8_norm_le_theta`, `Stage3.pull_at_theta_abscissa`, `Stage3.I37_power_log3_theta` | `Stage3.psi_weak_of_theta` |
| `Stage3.theta_instantiation_arithmetic`<br/>theorem, line 415 | c * (X ^ (1 - θ))⁻¹ * X * Real.log X ≤ c * X ^ θ * (Real.log X) ^ 3 ∧ c * X * Real.log X / ((X ^ (1 - θ))⁻¹ * X) ≤ c * X ^ θ * (Real.log X) ^ 3 ∧ c * ((X ^ (1 - θ))⁻¹ * X) ≤ c * X ^ θ * (Real.log X) ^ 3 | hX1 : 1 &lt; X; hθlo : 1/2 ≤ θ; hθhi : θ ≤ 1; hLX : 1 ≤ Real.log X; hc : 0 ≤ c | The instantiation arithmetic at `θ`. With `ε = X^(θ−1)` and `T = X`, `ε·X = X^θ`, and every error piece lands under `c·X^θ·log³X`: | — | `Stage3.psi_weak_of_theta` |
| `Stage3.psi_weak_of_theta`<br/>theorem, line 454 | ∃ C &gt; 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t → \|ψ t - t\| ≤ C * t ^ θ * (Real.log t) ^ 3 | hθ : StmtZeroFreeRight θ; hθlo : 1/2 ≤ θ; hθhi : θ &lt; 1 | `\|ψ X − X\| ≤ C·X^θ·log³X` from a zero-free half-plane `re &gt; θ`. `RHPull.psi_weak_of_RH` with `StmtZeroFreeRight θ` for RH, `ε = X^(θ−1)` for `X^(−1/2)`, `T = X` as before. Every constant is obtained: `B` from `mellin_bump_bounded`, `Cclose` from `SmoothedChebyshevClose`, `C₁`/`C₉` from `I1Bound`/`I9Bound`, `Cmain` from `MellinOfSmooth1c`. | `Stage3.StmtZeroFreeRight`, `RHPull.bump_exists`, `RHPull.horiz_small`, `RHPull.mellin_bump_bounded`, `RHPull.mellin_horiz_le`, `RHPull.mellin_horiz_le_neg`, `RHPull.mellin_main_const`, `RHPull.psi_sub_self_le`, `RHPull.rpow_one_add`, `Stage3.contour_at_instantiation_theta`, `Stage3.mellin_vert_le_theta`, `Stage3.theta_instantiation_arithmetic`, `Stage3.four_le_log_of_theta` | `JointWindowDial.psiWeakTheta_of_window`, `Stage3.zeroFreeRight_iff_psiWeakTheta`, `Stage3.schoenfeldWeakTheta_of_zeroFree`, `Stage3.psi_weak_of_RH_half` |
| `Stage3.psi_weak_of_RH_half`<br/>theorem, line 607 | ∃ C &gt; 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t → \|ψ t - t\| ≤ C * Real.sqrt t * (Real.log t) ^ 3 | hRH : RiemannHypothesis | `psi_weak_of_RH` recovered. At `θ = 1/2` under RH, the general bound is `RHPull.psi_weak_of_RH`'s statement, `√t` included. | `Stage3.zeroFreeRight_of_RH`, `Stage3.psi_weak_of_theta` | `Stage3.stmtPsiWeak_of_RH_half` |
| `Stage3.stmtPsiWeak_of_RH_half`<br/>theorem, line 618 | ∃ C &gt; 0, ∃ x₀ : ℝ, Stage3.StmtPsiWeak C 3 x₀ | hRH : RiemannHypothesis | `StmtPsiWeak` at `k = 3` from RH, through the `θ`-dial. Same statement as `RHPull.stmtPsiWeak_of_RH`. | `Stage3.StmtPsiWeak`, `Stage3.psi_weak_of_RH_half` | — |
