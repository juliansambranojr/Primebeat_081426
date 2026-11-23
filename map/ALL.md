# Every declaration, one line each

Sorted by name. Search this file before saying something is missing.

| name | kind | layer | file | proves |
|---|---|---|---|---|
| [`WeilPowerBands.A`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-A) | def | shape | `WeilPowerBands` | ℝ |
| [`WeilSeries.A`](./lean_stage3/WeilSeries.md#WeilSeries-A) | def | shape | `WeilSeries` | ℝ |
| [`Chain.A1`](./lean/Chain.md#Chain-A1) | theorem | shape | `Chain` | StmtA1 b ρ |
| [`Chain.A2`](./lean/Chain.md#Chain-A2) | theorem | reads ζ | `Chain` | StmtA2 |
| [`Chain.A3`](./lean/Chain.md#Chain-A3) | theorem | reads ζ | `Chain` | StmtA3 |
| [`Chain.A4`](./lean/Chain.md#Chain-A4) | theorem | shape | `Chain` | StmtA4 b ρ |
| [`Chain.A4_of_A1`](./lean/Chain.md#Chain-A4_of_A1) | theorem | shape | `Chain` | StmtA4 b ρ |
| [`Superposition.A4_sum_of_A1`](./lean/Superposition.md#Superposition-A4_sum_of_A1) | theorem | shape | `Superposition` | ∀ (N : ℕ) (r : ℂ), (bdiff^[N]) (modeSum b ρ c s) r = ∑ i ∈ s, c i * (Sym b (ρ i)) ^ N * mode b (ρ i) r |
| [`WeilOnLine.A_le`](./lean_stage3/WeilOnLine.md#WeilOnLine-A_le) | theorem | shape | `WeilOnLine` | A h γ ≤ 88 * (γ + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2) |
| [`WeilPowerBands.A_le`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-A_le) | theorem | shape | `WeilPowerBands` | A h γ m ≤ 88 * (γ + r h m + 2) ^ 4 * (4 * h ^ 2 + cFarM m / h ^ 2) |
| [`WeilPowerBands.A_nonneg`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-A_nonneg) | theorem | shape | `WeilPowerBands` | 0 ≤ A h γ m |
| [`WeilSeries.A_nonneg`](./lean_stage3/WeilSeries.md#WeilSeries-A_nonneg) | theorem | shape | `WeilSeries` | 0 ≤ A h γ |
| [`Stage3.a_term_le`](./lean_stage3/Stirling.md#Stage3-a_term_le) | theorem | shape | `Stirling` | \|(((n : ℂ) + zq t)⁻¹).re - (Real.log ‖((n + 1 : ℕ) : ℂ) + zq t‖ - Real.log ‖(n : ℂ) + zq t‖)\| ≤ 8 * ((((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹) |
| [`ArgLegs.abs_arg_sub_le_pi`](./lean_stage3/ArgLegs.md#ArgLegs-abs_arg_sub_le_pi) | theorem | shape | `ArgLegs` | \|z.arg - w.arg\| ≤ Real.pi |
| [`ZetaEM.abs_bernoulliFun_fract_le`](./lean_stage3/ZetaEM.md#ZetaEM-abs_bernoulliFun_fract_le) | theorem | reads ζ | `ZetaEM` | \|bernoulliFun k (Int.fract x)\| ≤ bernBound k |
| [`Mollified.abs_coef_le`](./lean_stage3/Mollified.md#Mollified-abs_coef_le) | theorem | counting | `Mollified` | \|coef X N n\| ≤ tauBelow X n |
| [`LandauCrude.abs_G_le`](./lean_stage3/LandauCrude.md#LandauCrude-abs_G_le) | theorem | shape | `LandauCrude` | \|LandauWindow.G y\| ≤ 2 * y * (1 + Real.log y) ^ 2 |
| [`LandauChebyshev.abs_G_le_log`](./lean_stage3/LandauChebyshev.md#LandauChebyshev-abs_G_le_log) | theorem | reads ζ | `LandauChebyshev` | \|LandauWindow.G y\| ≤ 8 * y * (1 + Real.log y) |
| [`LandauTrig.abs_le_sum_norm`](./lean_stage3/LandauTrig.md#LandauTrig-abs_le_sum_norm) | theorem | shape | `LandauTrig` | \|T n\| ≤ ∑ j ∈ s, ‖c j‖ |
| [`Stage3.abs_mainterm_le`](./lean_stage3/ZeroSum.md#Stage3-abs_mainterm_le) | theorem | reads ζ | `ZeroSum` | \|zetaCountingMainTerm T\| ≤ T / (2 * Real.pi) * (Real.log T + 3) + 7 / 8 |
| [`Stage3.abs_pi_sub_Li_le`](./lean_stage3/PsiToPi.md#Stage3-abs_pi_sub_Li_le) | theorem | shape | `PsiToPi` | \|(Nat.primeCounting ⌊x⌋₊ : ℝ) - Li x\| ≤ \|θ x - x\| / Real.log x + ∫ t in (2 : ℝ)..x, env t / (t * Real.log t ^ 2) |
| [`WeilPowerBackground.abs_q_le_one`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-abs_q_le_one) | theorem | shape | `WeilPowerBackground` | \|q m x\| ≤ 1 |
| [`PerronKernel.abs_sub_one_le_two_abs_log`](./lean_stage3/PerronKernel.md#PerronKernel-abs_sub_one_le_two_abs_log) | theorem | shape | `PerronKernel` | \|t - 1\| / 2 ≤ \|Real.log t\| |
| [`Stage3.abs_theta_sub_le_linear`](./lean_stage3/PsiToPi.md#Stage3-abs_theta_sub_le_linear) | theorem | shape | `PsiToPi` | \|θ t - t\| ≤ (1 + Real.log 4) * t |
| [`PiFixedRow.abs_wd_le`](./lean_stage3/PiFixedRow.md#PiFixedRow-abs_wd_le) | theorem | shape | `PiFixedRow` | \|wd t\| ≤ 4 |
| [`Stage3.abscissa_gives_power`](./lean_stage3/Abscissa.md#Stage3-abscissa_gives_power) | theorem | shape | `Abscissa` | K * X ^ (σθ θ X) = (Real.exp 1 * K) * X ^ θ |
| [`Stage3.add_zq_ne_zero`](./lean_stage3/Stirling.md#Stage3-add_zq_ne_zero) | theorem | shape | `Stirling` | (n : ℂ) + zq t ≠ 0 |
| [`FilterLadder.Afl`](./lean_stage3/FilterLadder.md#FilterLadder-Afl) | def | reads ζ | `FilterLadder` | ℝ |
| [`Measured.agreement_elliptic`](./lean/Measured.md#Measured-agreement_elliptic) | theorem | shape | `Measured` | measured_elliptic_max_dev &lt; 1e-15 |
| [`Measured.agreement_offsets_match`](./lean/Measured.md#Measured-agreement_offsets_match) | theorem | shape | `Measured` | \|measured_offset_smooth - measured_offset_resid\| &lt; 0.001 |
| [`Measured.agreement_radius_smooth`](./lean/Measured.md#Measured-agreement_radius_smooth) | theorem | shape | `Measured` | \|measured_radius_smooth - 0.5 * (1 + measured_offset_smooth)\| &lt; 1e-9 |
| [`Measured.agreement_rank_11a1`](./lean/Measured.md#Measured-agreement_rank_11a1) | theorem | shape | `Measured` | \|measured_rank_11a1 - predicted_rank_11a1\| &lt; 0.05 |
| [`Measured.agreement_rank_37a1`](./lean/Measured.md#Measured-agreement_rank_37a1) | theorem | shape | `Measured` | \|measured_rank_37a1 - predicted_rank_37a1\| &lt; 0.3 |
| [`Measured.agreement_rank_389a1`](./lean/Measured.md#Measured-agreement_rank_389a1) | theorem | shape | `Measured` | \|measured_rank_389a1 - predicted_rank_389a1\| &lt; 0.01 |
| [`Measured.agreement_weil_balance`](./lean/Measured.md#Measured-agreement_weil_balance) | theorem | shape | `Measured` | \|measured_weil_arithmetic - measured_weil_spectral\| &lt; 1e-6 * measured_weil_arithmetic |
| [`ExplicitLeft.Aleft`](./lean_stage3/ExplicitLeft.md#ExplicitLeft-Aleft) | def | reads ζ | `ExplicitLeft` | ℝ |
| [`ExplicitLeft.Aleft_pos`](./lean_stage3/ExplicitLeft.md#ExplicitLeft-Aleft_pos) | theorem | reads ζ | `ExplicitLeft` | 0 &lt; Aleft |
| [`AliasClass.alias_weight`](./lean_stage3/AliasClass.md#AliasClass-alias_weight) | theorem | reads ζ | `AliasClass` | ∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (r : ℂ) = (∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)) * (1 - z⁻¹) ^ d * z ^… |
| [`AliasClass.alias_weight_ne_zero`](./lean_stage3/AliasClass.md#AliasClass-alias_weight_ne_zero) | theorem | reads ζ | `AliasClass` | ∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (r : ℂ) ≠ 0 |
| [`Nyquist.Aliases`](./lean/Nyquist.md#Nyquist-Aliases) | def | shape | `Nyquist` | Prop |
| [`Nyquist.aliases_of_offset`](./lean/Nyquist.md#Nyquist-aliases_of_offset) | theorem | shape | `Nyquist` | Aliases b γ (γ - 2 * π * k / Real.log b) |
| [`ZeroCells.all_four_have_length_four`](./lean/ZeroCells.md#ZeroCells-all_four_have_length_four) | theorem | counting | `ZeroCells` | Construction.measured_zeros.length = 4 ∧ SeedPerturbation.zero_cells.length = 4 ∧ PairIdentity.zero_cells.length = 4 ∧ Zeros.measured_zeros.length = 4 |
| [`ContourShift.analyticAt_conj_conj`](./lean_stage3/ContourShift.md#ContourShift-analyticAt_conj_conj) | theorem | shape | `ContourShift` | AnalyticAt ℂ (fun w ↦ (starRingEnd ℂ) (g ((starRingEnd ℂ) w))) ((starRingEnd ℂ) p) |
| [`ContourShift.analyticAt_dslope`](./lean_stage3/ContourShift.md#ContourShift-analyticAt_dslope) | theorem | shape | `ContourShift` | AnalyticAt ℂ (dslope f p) p |
| [`Stage3.analyticOrderNatAt_fun_comp_affine`](./lean_stage3/JensenCount.md#Stage3-analyticOrderNatAt_fun_comp_affine) | theorem | shape | `JensenCount` | analyticOrderNatAt (fun w : ℂ =&gt; g (a * w + b)) z = analyticOrderNatAt g (a * z + b) |
| [`Stage3.anchor_mem_regionθ`](./lean_stage3/ThetaConverse.md#Stage3-anchor_mem_region-) | theorem | shape | `ThetaConverse` | ((max θ 1 + 1 : ℝ) : ℂ) ∈ regionθ θ ∧ 1 &lt; ((max θ 1 + 1 : ℝ) : ℂ).re |
| [`Transform.annulus_modulus`](./lean/Transform.md#Transform-annulus_modulus) | theorem | shape | `Transform` | Real.log (b ^ (-(1:ℝ)/2) / b ^ (-(1:ℝ))) / (2 * Real.pi) = Real.log b / (4 * Real.pi) |
| [`PiFixedRow.Api`](./lean_stage3/PiFixedRow.md#PiFixedRow-Api) | def | reads ζ | `PiFixedRow` | ℝ |
| [`FixedRowTwo.Api2`](./lean_stage3/FixedRowTwo.md#FixedRowTwo-Api2) | def | reads ζ | `FixedRowTwo` | ℝ |
| [`FixedRowTwo.Api2_nonneg`](./lean_stage3/FixedRowTwo.md#FixedRowTwo-Api2_nonneg) | theorem | reads ζ | `FixedRowTwo` | 0 ≤ Api2 |
| [`PiFixedRow.Api_nonneg`](./lean_stage3/PiFixedRow.md#PiFixedRow-Api_nonneg) | theorem | reads ζ | `PiFixedRow` | 0 ≤ Api |
| [`LeftSmooth.arctan_int_le`](./lean_stage3/LeftSmooth.md#LeftSmooth-arctan_int_le) | theorem | shape | `LeftSmooth` | (∫ t in (-T)..T, 1 / (a ^ 2 + t ^ 2)) ≤ Real.pi / a |
| [`PiRemainder.Arem`](./lean_stage3/PiRemainder.md#PiRemainder-Arem) | def | reads ζ | `PiRemainder` | ℝ |
| [`PiRemainder.Arem_nonneg`](./lean_stage3/PiRemainder.md#PiRemainder-Arem_nonneg) | theorem | reads ζ | `PiRemainder` | 0 ≤ Arem |
| [`ReZetaCount.arg_ne_one`](./lean_stage3/ReZetaCount.md#ReZetaCount-arg_ne_one) | theorem | shape | `ReZetaCount` | 2 * z + 2 + Complex.I * (T : ℂ) ≠ 1 ∧ 2 * z + 2 - Complex.I * (T : ℂ) ≠ 1 |
| [`Stage3.arg_sum_eq_pi`](./lean_stage3/ArgIdentity.md#Stage3-arg_sum_eq_pi) | theorem | shape | `ArgIdentity` | Complex.arg ((1/2 : ℝ) + T * Complex.I) + Complex.arg ((-(1/2) : ℝ) + T * Complex.I) = Real.pi |
| [`LeftSmooth.arg_wL`](./lean_stage3/LeftSmooth.md#LeftSmooth-arg_wL) | theorem | shape | `LeftSmooth` | (Real.pi:ℂ) * wL t / 2 = ((5 * Real.pi / 8 : ℝ):ℂ) + ((-(Real.pi * t / 2)) : ℝ) * Complex.I |
| [`Stage3.argCrude_of_pieces`](./lean_stage3/ArgCrude.md#Stage3-argCrude_of_pieces) | theorem | reads ζ | `ArgCrude` | StmtBacklundArg θ (a * A₁) (a * A₃ + b) |
| [`Stage3.argS`](./lean_stage3/ArgIdentity.md#Stage3-argS) | def | reads ζ | `ArgIdentity` | ℝ |
| [`Stage3.argS_eq_zetaArgContour`](./lean_stage3/ArgIdentity.md#Stage3-argS_eq_zetaArgContour) | theorem | reads ζ | `ArgIdentity` | argS T = zetaArgContour T |
| [`ArgCount.argS_le_gt_two`](./lean_stage3/ArgCount.md#ArgCount-argS_le_gt_two) | theorem | reads ζ | `ArgCount` | \|Stage3.argS T\| ≤ 15 * Real.log T + 75 |
| [`ArgCount.argS_le_of_good`](./lean_stage3/ArgCount.md#ArgCount-argS_le_of_good) | theorem | reads ζ | `ArgCount` | \|Stage3.argS T\| ≤ 15 * Real.log T + 73 + 3 / 2 |
| [`ArgCount.argS_two_le`](./lean_stage3/ArgCount.md#ArgCount-argS_two_le) | theorem | reads ζ | `ArgCount` | \|Stage3.argS 2\| ≤ 15 * Real.log 2 + 600 |
| [`Stage3.assembly_arith`](./lean_stage3/Assembly.md#Stage3-assembly_arith) | theorem | shape | `Assembly` | A ≤ (9 * c₁ + c₂ + 28 + 16 * b₁ + 16 * b₂ + 8 * b₃ + 4 * W) * S * L ^ 2 |
| [`Crossover.at_most_one_crossover`](./lean/Crossover.md#Crossover-at_most_one_crossover) | theorem | shape | `Crossover` | i = j |
| [`AttainedPi.attained_off_line_pi`](./lean_stage3/AttainedPi.md#AttainedPi-attained_off_line_pi) | theorem | reads ζ | `AttainedPi` | RiemannHypothesis |
| [`FilterAttained.attained_psi`](./lean_stage3/FilterAttained.md#FilterAttained-attained_psi) | theorem | reads ζ | `FilterAttained` | RiemannHypothesis |
| [`Expansion.B`](./lean/Expansion.md#Expansion-B) | def | shape | `Expansion` | ℝ |
| [`MollifiedMean.b`](./lean_stage3/MollifiedMean.md#MollifiedMean-b) | def | shape | `MollifiedMean` | ℝ |
| [`WeilOnLine.B`](./lean_stage3/WeilOnLine.md#WeilOnLine-B) | def | shape | `WeilOnLine` | ℝ |
| [`WeilPowerOnLine.B`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-B) | def | shape | `WeilPowerOnLine` | ℝ |
| [`Chain.B4`](./lean/Chain.md#Chain-B4) | theorem | shape | `Chain` | StmtB4 b N |
| [`Chain.B5`](./lean/Chain.md#Chain-B5) | theorem | shape | `Chain` | StmtB5 b N |
| [`Chain.B5_of_A4_B4`](./lean/Chain.md#Chain-B5_of_A4_B4) | theorem | shape | `Chain` | h b N ((1 : ℂ)/2 + γ * I) = ((‖(Sym b ((1 : ℂ)/2 + γ * I)) ^ N‖ ^ 2 : ℝ) : ℂ) |
| [`Expansion.B_bounds`](./lean/Expansion.md#Expansion-B_bounds) | theorem | shape | `Expansion` | ∀ m k, k + m = d → 0 ≤ B d x k ∧ B d x k ≤ t d k x |
| [`Expansion.B_peel`](./lean/Expansion.md#Expansion-B_peel) | theorem | shape | `Expansion` | B d x k = t d k x - B d x (k + 1) |
| [`Stage3.backlundArg_of_identity`](./lean_stage3/ArgCrude.md#Stage3-backlundArg_of_identity) | theorem | reads ζ | `ArgCrude` | StmtBacklundArg θ B₁ B₃ |
| [`Stage3.backlundArg_of_sFromLocal`](./lean_stage3/ArgIdentity.md#Stage3-backlundArg_of_sFromLocal) | theorem | reads ζ | `ArgIdentity` | StmtBacklundArg phaseTheta (a * A₁) (a * A₃ + b) |
| [`Stage3.backlundPhase_holds`](./lean_stage3/Stirling.md#Stage3-backlundPhase_holds) | theorem | reads ζ | `Stirling` | StmtBacklundPhase phaseTheta 97 98 |
| [`Stage3.backlundPhase_of_digammaLog`](./lean_stage3/Stirling.md#Stage3-backlundPhase_of_digammaLog) | theorem | reads ζ | `Stirling` | StmtBacklundPhase phaseTheta C (C + 1) |
| [`PairIdentity.backward_difference_pow`](./lean/PairIdentity.md#PairIdentity-backward_difference_pow) | theorem | counting | `PairIdentity` | b ^ (r + 1) - b ^ r = (b - 1) * b ^ r |
| [`EdgeBound.ball_order_sum_le`](./lean_stage3/EdgeBound.md#EdgeBound-ball_order_sum_le) | theorem | reads ζ | `EdgeBound` | ∃ C : ℝ, 0 &lt; C ∧ ∀ T' : ℝ, 2 ≤ T' → (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, (analyticOrderNatAt gz w : ℝ)) ≤ C * Real.log T' |
| [`EdgeBound.ball_order_sum_le_num`](./lean_stage3/EdgeNum.md#EdgeBound-ball_order_sum_le_num) | theorem | reads ζ | `EdgeNum` | ∀ T' : ℝ, 2 ≤ T' → (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, (analyticOrderNatAt gz w : ℝ)) ≤ C2n * Real.log T' |
| [`SquareMean.ball_subset_sq`](./lean_stage3/SquareMean.md#SquareMean-ball_subset_sq) | theorem | shape | `SquareMean` | closedBall c δ ⊆ (Icc (c.re - δ) (c.re + δ)) ×ℂ (Icc (c.im - δ) (c.im + δ)) |
| [`EdgeBound.ball_zero_shape`](./lean_stage3/EdgeBound.md#EdgeBound-ball_zero_shape) | theorem | reads ζ | `EdgeBound` | riemannZeta w = 0 ∧ (0 &lt; w.re ∧ w.re &lt; 1) ∧ \|w.im - T'\| ≤ 46/25 |
| [`WeilBands.band_count`](./lean_stage3/WeilBands.md#WeilBands-band_count) | theorem | reads ζ | `WeilBands` | ∑ ρ ∈ S, (analyticOrderNatAt riemannZeta ρ : ℝ) ≤ 15 * Real.log T + 73 |
| [`DeepZeroBand.band_in_annulus`](./lean/DeepZeroBand.md#DeepZeroBand-band_in_annulus) | theorem | shape | `DeepZeroBand` | b ^ (-(1 : ℝ)) ≤ ‖(b : ℂ) ^ (-(x : ℂ))‖ ∧ ‖(b : ℂ) ^ (-(x : ℂ))‖ ≤ 1 |
| [`Glue.band_order_sum_le`](./lean_stage3/Glue.md#Glue-band_order_sum_le) | theorem | reads ζ | `Glue` | ∃ C : ℝ, 0 &lt; C ∧ ∀ T : ℝ, 2 ≤ T → ∀ F : Finset ℂ, (∀ ρ ∈ F, riemannZeta ρ = 0 ∧ (0 &lt; ρ.re ∧ ρ.re &lt; 1) ∧ T ≤ \|ρ.im\| ∧ \|ρ.im\| ≤ T + 1) → (∑ ρ ∈ F, (analyticOrderNatAt riemannZeta ρ : ℝ)) ≤ C * Real.log … |
| [`Glue.band_order_sum_le_num`](./lean_stage3/GlueNum.md#Glue-band_order_sum_le_num) | theorem | reads ζ | `GlueNum` | ∀ T : ℝ, 2 ≤ T → ∀ F : Finset ℂ, (∀ ρ ∈ F, riemannZeta ρ = 0 ∧ (0 &lt; ρ.re ∧ ρ.re &lt; 1) ∧ T ≤ \|ρ.im\| ∧ \|ρ.im\| ≤ T + 1) → (∑ ρ ∈ F, (analyticOrderNatAt riemannZeta ρ : ℝ)) ≤ Csn * Real.log T |
| [`AttainedPi.band_small`](./lean_stage3/AttainedPi.md#AttainedPi-band_small) | theorem | reads ζ | `AttainedPi` | ∃ η : ℝ, 0 &lt; η ∧ η ≤ (Θ - 1 / 2) / 2 ∧ ∀ F : Finset NontrivialZeros, (∀ ρ ∈ F, Θ - η &lt; (ρ : ℂ).re ∧ (ρ : ℂ).re &lt; Θ) → ∑ ρ ∈ F, ordR ρ * ‖(ρ : ℂ)‖⁻¹ ≤ ε |
| [`WeilBands.band_sum_le`](./lean_stage3/WeilBands.md#WeilBands-band_sum_le) | theorem | reads ζ | `WeilBands` | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ M * (15 * Real.log T + 73) |
| [`WeilPowerBands.band_sum_le`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-band_sum_le) | theorem | reads ζ | `WeilPowerBands` | ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ M * (15 * Real.log T + 73) |
| [`WeilPowerBands.bandSeries_le`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-bandSeries_le) | theorem | reads ζ | `WeilPowerBands` | ∑' k : ℕ, M h γ m k * (15 * Real.log (centre k) + 73) ≤ A h γ m * (Real.pi ^ 2 / 6) |
| [`WeilSeries.bandSeries_le`](./lean_stage3/WeilSeries.md#WeilSeries-bandSeries_le) | theorem | reads ζ | `WeilSeries` | ∑' k : ℕ, M h γ k * (15 * Real.log (centre k) + 73) ≤ A h γ * (Real.pi ^ 2 / 6) |
| [`WeilTiles.bandSeries_nonneg`](./lean_stage3/WeilTiles.md#WeilTiles-bandSeries_nonneg) | theorem | shape | `WeilTiles` | 0 ≤ M k * (15 * Real.log (centre k) + 73) |
| [`WeilPowerBands.bandSeries_summable`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-bandSeries_summable) | theorem | shape | `WeilPowerBands` | Summable (fun k : ℕ =&gt; M h γ m k * (15 * Real.log (centre k) + 73)) |
| [`WeilSeries.bandSeries_summable`](./lean_stage3/WeilSeries.md#WeilSeries-bandSeries_summable) | theorem | shape | `WeilSeries` | Summable (fun k : ℕ =&gt; M h γ k * (15 * Real.log (centre k) + 73)) |
| [`WeilPowerBands.bandTerm_le_A`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-bandTerm_le_A) | theorem | shape | `WeilPowerBands` | M h γ m k * (15 * Real.log (centre k) + 73) ≤ A h γ m / ((k : ℝ) + 1) ^ 3 |
| [`WeilSeries.bandTerm_le_A`](./lean_stage3/WeilSeries.md#WeilSeries-bandTerm_le_A) | theorem | shape | `WeilSeries` | M h γ k * (15 * Real.log (centre k) + 73) ≤ A h γ / ((k : ℝ) + 1) ^ 3 |
| [`CellResidual.base_bound`](./lean_stage3/CellResidual.md#CellResidual-base_bound) | theorem | shape | `CellResidual` | ∃ M : ℝ, ∀ a ∈ Set.Icc (1 : ℝ) 2, \|resid a r₀\| ≤ M |
| [`Nyquist.base_bound_of_resolvable`](./lean/Nyquist.md#Nyquist-base_bound_of_resolvable) | theorem | shape | `Nyquist` | b ≤ Real.exp (π / γ) |
| [`PairIdentity.base_four_carries_factor`](./lean/PairIdentity.md#PairIdentity-base_four_carries_factor) | theorem | counting | `PairIdentity` | ((4 : ℤ) - 1) ^ (d + 1) * 4 ^ e = 3 ^ (d + 1) * 4 ^ e |
| [`Zeros.base_of_meets_two`](./lean/ZerosStencil.md#Zeros-base_of_meets_two) | theorem | counting | `ZerosStencil` | ∃ i, b = 2 ^ i |
| [`PairIdentity.base_three_carries_factor`](./lean/PairIdentity.md#PairIdentity-base_three_carries_factor) | theorem | counting | `PairIdentity` | ((3 : ℤ) - 1) ^ (d + 1) * 3 ^ e = 2 ^ (d + 1) * 3 ^ e |
| [`Nyquist.base_two_fails_by_three`](./lean/Nyquist.md#Nyquist-base_two_fails_by_three) | theorem | shape | `Nyquist` | 3 * nyquist 2 &lt; 14 |
| [`Nyquist.base_two_past_nyquist`](./lean/Nyquist.md#Nyquist-base_two_past_nyquist) | theorem | shape | `Nyquist` | nyquist 2 &lt; γ |
| [`ZeroDensity.bConst`](./lean_stage3/ZeroDensity.md#ZeroDensity-bConst) | def | reads ζ | `ZeroDensity` | ℝ |
| [`ZeroDensity.bConst_nonneg`](./lean_stage3/ZeroDensity.md#ZeroDensity-bConst_nonneg) | theorem | reads ζ | `ZeroDensity` | 0 ≤ bConst δ k |
| [`Chain.bdiff`](./lean/Chain.md#Chain-bdiff) | def | shape | `Chain` | ℂ → ℂ |
| [`Elephant.bdiff`](./lean/Elephant.md#Elephant-bdiff) | def | shape | `Elephant` | ℤ → ℂ |
| [`CellBdiff.bdiff_iter_eq_bdZ`](./lean_stage3/CellBdiff.md#CellBdiff-bdiff_iter_eq_bdZ) | theorem | shape | `CellBdiff` | (Chain.bdiff^[d]) g (r : ℂ) = (bdZ^[d]) a r |
| [`Elephant.bdiff_iter_mode`](./lean/Elephant.md#Elephant-bdiff_iter_mode) | theorem | shape | `Elephant` | (bdiff^[d]) (mode b ρ) r = (Sym b ρ) ^ d * mode b ρ r |
| [`Elephant.bdiff_iter_modeSum`](./lean/Elephant.md#Elephant-bdiff_iter_modeSum) | theorem | shape | `Elephant` | (bdiff^[d]) (fun r =&gt; ∑ i ∈ s, c i * mode b (ρ i) r) r = ∑ i ∈ s, c i * (Sym b (ρ i)) ^ d * mode b (ρ i) r |
| [`Elephant.bdiff_mode`](./lean/Elephant.md#Elephant-bdiff_mode) | theorem | shape | `Elephant` | bdiff (mode b ρ) r = Sym b ρ * mode b ρ r |
| [`Chain.bdiff_smul`](./lean/Chain.md#Chain-bdiff_smul) | theorem | shape | `Chain` | bdiff (fun r =&gt; k * f r) = fun r =&gt; k * bdiff f r |
| [`Superposition.bdiff_sum`](./lean/Superposition.md#Superposition-bdiff_sum) | theorem | shape | `Superposition` | bdiff (fun r =&gt; ∑ i ∈ s, f i r) = fun r =&gt; ∑ i ∈ s, bdiff (f i) r |
| [`TransferOp.bdiffL`](./lean/TransferOp.md#TransferOp-bdiffL) | def | shape | `TransferOp` | Module.End ℂ (ℂ → ℂ) |
| [`TransferOp.bdiffL_apply`](./lean/TransferOp.md#TransferOp-bdiffL_apply) | theorem | shape | `TransferOp` | bdiffL f = bdiff f |
| [`MainTerm.bdiffR`](./lean/MainTerm.md#MainTerm-bdiffR) | def | shape | `MainTerm` | ℝ → ℝ |
| [`MainTerm.bdiffR_lb`](./lean/MainTerm.md#MainTerm-bdiffR_lb) | theorem | shape | `MainTerm` | m ≤ bdiffR g x |
| [`Nonvanishing.bdiffZ`](./lean/Nonvanishing.md#Nonvanishing-bdiffZ) | def | shape | `Nonvanishing` | ℤ → ℝ |
| [`CellBdiff.bdZ`](./lean_stage3/CellBdiff.md#CellBdiff-bdZ) | def | shape | `CellBdiff` | ℤ → ℂ |
| [`Covering.bench_is_selective`](./lean/Covering.md#Covering-bench_is_selective) | theorem | shape | `Covering` | (0.2 : ℝ) &lt; 0.34657 |
| [`Covering.bench_selects`](./lean/Covering.md#Covering-bench_selects) | theorem | counting | `Covering` | measured_contributing &lt; measured_in_support |
| [`ZetaEM.bernBound`](./lean_stage3/ZetaEM.md#ZetaEM-bernBound) | def | reads ζ | `ZetaEM` | ℝ |
| [`ZetaEM.bernBound_nonneg`](./lean_stage3/ZetaEM.md#ZetaEM-bernBound_nonneg) | theorem | reads ζ | `ZetaEM` | 0 ≤ bernBound k |
| [`LeftSmooth.Bleft`](./lean_stage3/LeftSmooth.md#LeftSmooth-Bleft) | def | shape | `LeftSmooth` | ℝ |
| [`ExplicitTwo.Bleft2`](./lean_stage3/ExplicitTwo.md#ExplicitTwo-Bleft2) | def | shape | `ExplicitTwo` | ℝ |
| [`FixedRowTwo.Bleft2_nonneg`](./lean_stage3/FixedRowTwo.md#FixedRowTwo-Bleft2_nonneg) | theorem | reads ζ | `FixedRowTwo` | 0 ≤ ExplicitTwo.Bleft2 |
| [`CellFixedRow.Bleft_nonneg`](./lean_stage3/CellFixedRow.md#CellFixedRow-Bleft_nonneg) | theorem | reads ζ | `CellFixedRow` | 0 ≤ LeftSmooth.Bleft |
| [`WeilPowerClean.blocked_card_le`](./lean_stage3/WeilPowerClean.md#WeilPowerClean-blocked_card_le) | theorem | shape | `WeilPowerClean` | B.card ≤ W + 1 |
| [`ContourShift.borderIntegrable_sum_poles`](./lean_stage3/ContourShift.md#ContourShift-borderIntegrable_sum_poles) | theorem | reads ζ | `ContourShift` | RectangleBorderIntegrable (fun s ↦ ∑ p ∈ P, A p / (s - p)) z w |
| [`LandauTaylor.bound_integrable`](./lean_stage3/LandauTaylor.md#LandauTaylor-bound_integrable) | theorem | shape | `LandauTaylor` | IntegrableOn (fun y : ℝ =&gt; 8 * (Real.log y ^ k * y ^ (-a - 1) + Real.log y ^ (k + 1) * y ^ (-a - 1))) (Ioi 1) |
| [`SeedPerturbation.boundary_can_move`](./lean/SeedPerturbation.md#SeedPerturbation-boundary_can_move) | theorem | counting | `SeedPerturbation` | tableFrom e r d ≠ 0 |
| [`NyquistPeak.boundary_is_smooth_stationary_maximum`](./lean/NyquistPeak.md#NyquistPeak-boundary_is_smooth_stationary_maximum) | theorem | shape | `NyquistPeak` | Nyquist.nyquist (boundaryBase γ) = γ ∧ HasDerivAt (fun b : ℝ =&gt; gain d (γ * Real.log b)) 0 (boundaryBase γ) ∧ (∀ b : ℝ, gain d (γ * Real.log b) ≤ gain d (γ * Real.log (boundaryBase γ))) ∧ (∀ b : ℝ, \|R… |
| [`NyquistPeak.boundaryBase`](./lean/NyquistPeak.md#NyquistPeak-boundaryBase) | def | shape | `NyquistPeak` | ℝ |
| [`NyquistPeak.boundaryBase_pos`](./lean/NyquistPeak.md#NyquistPeak-boundaryBase_pos) | theorem | shape | `NyquistPeak` | 0 &lt; boundaryBase γ |
| [`WeilDetect.box_empty_of_positive_of_detect`](./lean_stage3/WeilDetect.md#WeilDetect-box_empty_of_positive_of_detect) | theorem | reads ζ | `WeilDetect` | OffLineBox ε T = ∅ |
| [`WeilPowerNear.bracket_nonneg`](./lean_stage3/WeilPowerNear.md#WeilPowerNear-bracket_nonneg) | theorem | shape | `WeilPowerNear` | 0 ≤ (e' ^ 2 - D ^ 2) * Real.cos θ - 2 * e' * D * Real.sin θ |
| [`LeftKernel.Bser`](./lean_stage3/LeftKernel.md#LeftKernel-Bser) | def | shape | `LeftKernel` | ℝ |
| [`LeftSmooth.Bsm`](./lean_stage3/LeftSmooth.md#LeftSmooth-Bsm) | def | shape | `LeftSmooth` | ℝ |
| [`Stage3.bump`](./lean_stage3/ExplicitBump.md#Stage3-bump) | def | shape | `ExplicitBump` | ℝ |
| [`Stage3.bump_contDiff`](./lean_stage3/ExplicitBump.md#Stage3-bump_contDiff) | theorem | shape | `ExplicitBump` | ContDiff ℝ 1 bump |
| [`RHPull.bump_exists`](./lean_stage3/LineBound.md#RHPull-bump_exists) | theorem | reads ζ | `LineBound` | ∃ ν : ℝ → ℝ, ContDiff ℝ 1 ν ∧ (∀ x &gt; 0, 0 ≤ ν x) ∧ ν.support ⊆ Set.Icc (1/2 : ℝ) 2 ∧ ∫ x in Set.Ioi (0:ℝ), ν x / x = 1 |
| [`Stage3.bump_le`](./lean_stage3/ExplicitBump.md#Stage3-bump_le) | theorem | shape | `ExplicitBump` | bump x ≤ bumpC * (9/16) ^ 2 |
| [`Stage3.bump_le_numeral`](./lean_stage3/ExplicitBump.md#Stage3-bump_le_numeral) | theorem | shape | `ExplicitBump` | bump x ≤ 1.4757 |
| [`Stage3.bump_nonneg`](./lean_stage3/ExplicitBump.md#Stage3-bump_nonneg) | theorem | shape | `ExplicitBump` | 0 ≤ bump x |
| [`Stage3.bump_support`](./lean_stage3/ExplicitBump.md#Stage3-bump_support) | theorem | shape | `ExplicitBump` | Function.support bump ⊆ Set.Icc (1/2 : ℝ) 2 |
| [`Stage3.bumpC`](./lean_stage3/ExplicitBump.md#Stage3-bumpC) | def | shape | `ExplicitBump` | ℝ |
| [`Stage3.bumpC_pos`](./lean_stage3/ExplicitBump.md#Stage3-bumpC_pos) | theorem | shape | `ExplicitBump` | 0 &lt; bumpC |
| [`Stage3.bumpP`](./lean_stage3/ExplicitBump.md#Stage3-bumpP) | def | shape | `ExplicitBump` | ℝ |
| [`Stage3.bumpP_le`](./lean_stage3/ExplicitBump.md#Stage3-bumpP_le) | theorem | shape | `ExplicitBump` | bumpP x ≤ 9/16 |
| [`Stage3.bumpP_nonpos_of_ge`](./lean_stage3/ExplicitBump.md#Stage3-bumpP_nonpos_of_ge) | theorem | shape | `ExplicitBump` | bumpP x ≤ 0 |
| [`Stage3.bumpP_nonpos_of_le`](./lean_stage3/ExplicitBump.md#Stage3-bumpP_nonpos_of_le) | theorem | shape | `ExplicitBump` | bumpP x ≤ 0 |
| [`Expansion.c`](./lean/Expansion.md#Expansion-c) | def | shape | `Expansion` | ℝ |
| [`WeilPower.c`](./lean_stage3/WeilPower.md#WeilPower-c) | def | shape | `WeilPower` | ℝ |
| [`EdgeBound.c0`](./lean_stage3/EdgeBound.md#EdgeBound-c0) | def | shape | `EdgeBound` | ℂ |
| [`LeftSmooth.c0`](./lean_stage3/LeftSmooth.md#LeftSmooth-c0) | def | shape | `LeftSmooth` | ℂ |
| [`EdgeBound.c0_im`](./lean_stage3/EdgeBound.md#EdgeBound-c0_im) | theorem | shape | `EdgeBound` | (c0 T').im = T' |
| [`EdgeBound.c0_re`](./lean_stage3/EdgeBound.md#EdgeBound-c0_re) | theorem | shape | `EdgeBound` | (c0 T').re = 3/2 |
| [`Chain.C1`](./lean/Chain.md#Chain-C1) | theorem | shape | `Chain` | StmtC1 b |
| [`EdgeBound.C1n`](./lean_stage3/EdgeNum.md#EdgeBound-C1n) | def | reads ζ | `EdgeNum` | ℝ |
| [`Glue.c1n`](./lean_stage3/GlueNum.md#Glue-c1n) | def | reads ζ | `GlueNum` | ℝ |
| [`RouteNum.C1n_le`](./lean_stage3/RouteNum.md#RouteNum-C1n_le) | theorem | reads ζ | `RouteNum` | EdgeBound.C1n ≤ 1909224 |
| [`RouteNum.c1n_le`](./lean_stage3/RouteNum.md#RouteNum-c1n_le) | theorem | reads ζ | `RouteNum` | Glue.c1n ≤ 88216610000 |
| [`Glue.c1n_nonneg`](./lean_stage3/GlueNum.md#Glue-c1n_nonneg) | theorem | reads ζ | `GlueNum` | 0 ≤ c1n |
| [`EdgeBound.C1n_pos`](./lean_stage3/EdgeNum.md#EdgeBound-C1n_pos) | theorem | reads ζ | `EdgeNum` | 0 &lt; C1n |
| [`ExplicitTwo.c1t`](./lean_stage3/ExplicitTwo.md#ExplicitTwo-c1t) | def | reads ζ | `ExplicitTwo` | ℝ |
| [`FixedRowTwo.c1t_nonneg`](./lean_stage3/FixedRowTwo.md#FixedRowTwo-c1t_nonneg) | theorem | reads ζ | `FixedRowTwo` | 0 ≤ ExplicitTwo.c1t |
| [`Chain.C2`](./lean/Chain.md#Chain-C2) | theorem | shape | `Chain` | StmtC2 b |
| [`Chain.C2_ceiling_attained`](./lean/Chain.md#Chain-C2_ceiling_attained) | theorem | shape | `Chain` | ∃ γ : ℝ, ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ 2 = (1 + b ^ (-(1:ℝ)/2)) ^ 2 |
| [`Chain.C2_floor_attained`](./lean/Chain.md#Chain-C2_floor_attained) | theorem | shape | `Chain` | ‖Sym b ((1 : ℂ)/2 + (0 : ℝ) * I)‖ ^ 2 = (1 - b ^ (-(1:ℝ)/2)) ^ 2 |
| [`Chain.C2_of_C1`](./lean/Chain.md#Chain-C2_of_C1) | theorem | shape | `Chain` | StmtC2 b |
| [`EdgeBound.C2n`](./lean_stage3/EdgeNum.md#EdgeBound-C2n) | def | reads ζ | `EdgeNum` | ℝ |
| [`RouteNum.C2n_le`](./lean_stage3/RouteNum.md#RouteNum-C2n_le) | theorem | reads ζ | `RouteNum` | EdgeBound.C2n ≤ 2167 |
| [`EdgeBound.C2n_pos`](./lean_stage3/EdgeNum.md#EdgeBound-C2n_pos) | theorem | reads ζ | `EdgeNum` | 0 &lt; C2n |
| [`Chain.C3`](./lean/Chain.md#Chain-C3) | theorem | shape | `Chain` | StmtC3 b |
| [`Chain.C3_of_A4_C2`](./lean/Chain.md#Chain-C3_of_A4_C2) | theorem | shape | `Chain` | StmtC3 b |
| [`Chain.C3lower`](./lean/Chain.md#Chain-C3lower) | theorem | shape | `Chain` | StmtC3lower b |
| [`Chain.C3lower_of_A4_C2`](./lean/Chain.md#Chain-C3lower_of_A4_C2) | theorem | shape | `Chain` | StmtC3lower b |
| [`Glue.c3n`](./lean_stage3/GlueNum.md#Glue-c3n) | def | reads ζ | `GlueNum` | ℝ |
| [`RouteNum.c3n_le`](./lean_stage3/RouteNum.md#RouteNum-c3n_le) | theorem | reads ζ | `RouteNum` | Glue.c3n ≤ 15 |
| [`Glue.c3n_nonneg`](./lean_stage3/GlueNum.md#Glue-c3n_nonneg) | theorem | reads ζ | `GlueNum` | 0 ≤ c3n |
| [`ExplicitTwo.c3t`](./lean_stage3/ExplicitTwo.md#ExplicitTwo-c3t) | def | reads ζ | `ExplicitTwo` | ℝ |
| [`FixedRowTwo.c3t_nonneg`](./lean_stage3/FixedRowTwo.md#FixedRowTwo-c3t_nonneg) | theorem | reads ζ | `FixedRowTwo` | 0 ≤ ExplicitTwo.c3t |
| [`Glue.c4n`](./lean_stage3/GlueNum.md#Glue-c4n) | def | reads ζ | `GlueNum` | ℝ |
| [`RouteNum.c4n_le`](./lean_stage3/RouteNum.md#RouteNum-c4n_le) | theorem | reads ζ | `RouteNum` | Glue.c4n ≤ 6468930000 |
| [`Glue.c4n_nonneg`](./lean_stage3/GlueNum.md#Glue-c4n_nonneg) | theorem | reads ζ | `GlueNum` | 0 ≤ c4n |
| [`WeilPower.c_neg_one`](./lean_stage3/WeilPower.md#WeilPower-c_neg_one) | theorem | shape | `WeilPower` | c (-1) = 0 |
| [`WeilPower.c_one`](./lean_stage3/WeilPower.md#WeilPower-c_one) | theorem | shape | `WeilPower` | c 1 = 0 |
| [`WeilPower.c_pow_neg_one`](./lean_stage3/WeilPower.md#WeilPower-c_pow_neg_one) | theorem | shape | `WeilPower` | c (-1) ^ n = 0 |
| [`WeilPower.c_pow_one`](./lean_stage3/WeilPower.md#WeilPower-c_pow_one) | theorem | shape | `WeilPower` | c 1 ^ n = 0 |
| [`Expansion.c_rec`](./lean/Expansion.md#Expansion-c_rec) | theorem | shape | `Expansion` | c (d + 1) j = Real.log 2 * c d j + (-(j : ℝ)) * c d (j - 1) |
| [`ZeroSquares.card_fiber_le`](./lean_stage3/ZeroSquares.md#ZeroSquares-card_fiber_le) | theorem | reads ζ | `ZeroSquares` | (W.card : ℝ) ≤ 15 * Real.log T + 73 |
| [`Mollified.card_Icc_dvd`](./lean_stage3/Mollified.md#Mollified-card_Icc_dvd) | theorem | counting | `Mollified` | ((Icc 1 Y).filter (k ∣ ·)).card = Y / k |
| [`WeilPowerCount.card_le_of_leaf`](./lean_stage3/WeilPowerCount.md#WeilPowerCount-card_le_of_leaf) | theorem | shape | `WeilPowerCount` | (S.card : ℝ) ≤ c₁ * Real.log T + c₂ |
| [`ReZetaCount.card_reZeros_le`](./lean_stage3/ReZetaCount.md#ReZetaCount-card_reZeros_le) | theorem | reads ζ | `ReZetaCount` | ((reZeros hT).card : ℝ) ≤ 15 * Real.log T + 73 |
| [`ZeroSummable.card_shell_le`](./lean_stage3/ZeroSummable.md#ZeroSummable-card_shell_le) | theorem | reads ζ | `ZeroSummable` | (F.card : ℝ) ≤ 2 * (C * ((2 : ℝ) ^ (j + 1) + 2) ^ θ) |
| [`ZeroSquares.card_zeros_le`](./lean_stage3/ZeroSquares.md#ZeroSquares-card_zeros_le) | theorem | reads ζ | `ZeroSquares` | Real.pi * δ ^ 2 * (Z.card : ℝ) ≤ 3 * (15 * Real.log T + 73) * ∫ u in (σ - δ)..(1 + δ), ∫ t in (1:ℝ)..T, ‖MollifiedMean.f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2 |
| [`WeilPowerCompare.cE`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-cE) | def | shape | `WeilPowerCompare` | ℝ |
| [`WeilPowerCompare.cE_le_cP`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-cE_le_cP) | theorem | shape | `WeilPowerCompare` | cE m ≤ cP m |
| [`WeilPowerCompare.cE_pos`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-cE_pos) | theorem | shape | `WeilPowerCompare` | 0 &lt; cE m |
| [`ZeroDensity.ceil_bounds`](./lean_stage3/ZeroDensity.md#ZeroDensity-ceil_bounds) | theorem | shape | `ZeroDensity` | y ≤ (⌈y⌉₊ : ℝ) ∧ (⌈y⌉₊ : ℝ) ≤ 2 * y |
| [`Chain.ceiling_base`](./lean/Chain.md#Chain-ceiling_base) | theorem | shape | `Chain` | ‖Sym (Real.exp (Real.pi * (2 * k + 1) / γ)) ((1 : ℂ)/2 + γ * I)‖ ^ 2 = (1 + (Real.exp (Real.pi * (2 * k + 1) / γ)) ^ (-(1:ℝ)/2)) ^ 2 |
| [`Chain.ceiling_dominates_floor`](./lean/Chain.md#Chain-ceiling_dominates_floor) | theorem | shape | `Chain` | (1 - b ^ (-(1:ℝ)/2)) ^ 2 &lt; (1 + b ^ (-(1:ℝ)/2)) ^ 2 |
| [`CellModes.cell_eq_modeSum`](./lean_stage3/CellModes.md#CellModes-cell_eq_modeSum) | theorem | reads ζ | `CellModes` | ‖CellZeros.stencil d (fun n : ℤ =&gt; (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r - Chain.Sym 2 1 ^ d * Chain.mode 2 1 (r : ℂ) + Superposition.modeSum 2 (fun ρ : {ρ : Kadiri.NontrivialZeros // \|(ρ : ℂ).im\| &lt; T} =… |
| [`CellBdiff.cell_eq_modeSum_bdiff`](./lean_stage3/CellBdiff.md#CellBdiff-cell_eq_modeSum_bdiff) | theorem | reads ζ | `CellBdiff` | ‖(Chain.bdiff^[d]) psiRow (r : ℂ) - Chain.Sym 2 1 ^ d * Chain.mode 2 1 (r : ℂ) + Superposition.modeSum 2 (fun ρ : {ρ : Kadiri.NontrivialZeros // \|(ρ : ℂ).im\| &lt; T} =&gt; ((ρ : Kadiri.NontrivialZeros) : ℂ)… |
| [`SeedPerturbation.cell_eq_of_seed_perturbation`](./lean/SeedPerturbation.md#SeedPerturbation-cell_eq_of_seed_perturbation) | theorem | counting | `SeedPerturbation` | tableFrom (fun x =&gt; N x - e x) r d = tableFrom N r d |
| [`CellZeros.cell_eq_zero_sum`](./lean_stage3/CellZeros.md#CellZeros-cell_eq_zero_sum) | theorem | reads ζ | `CellZeros` | ‖stencil d (fun n : ℤ =&gt; (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d + ∑' ρ : {ρ : Kadiri.NontrivialZeros // \|(ρ : ℂ).im\| &lt; T}, ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros)… |
| [`CellFixedRow.cell_eq_zero_sum_all`](./lean_stage3/CellFixedRow.md#CellFixedRow-cell_eq_zero_sum_all) | theorem | reads ζ | `CellFixedRow` | ‖CellZeros.stencil d (fun n : ℤ =&gt; (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d + ∑' ρ : {ρ : Kadiri.NontrivialZeros // \|(ρ : ℂ).im\| &lt; T}, ((riemannZeta.order ((ρ : Kadiri.Nontri… |
| [`CellRows.cell_eq_zero_sum_rows`](./lean_stage3/CellRows.md#CellRows-cell_eq_zero_sum_rows) | theorem | reads ζ | `CellRows` | ‖CellZeros.stencil d (fun n : ℤ =&gt; (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ) - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d + ∑ ρ ∈ ZF ((2:ℝ) ^ (K + 1)), term d (r : ℤ) ρ‖ ≤ 2 ^ d * ((4 * 2 ^ d * Glue.c1n + Glu… |
| [`FixedRowTwo.cell_eq_zero_sum_two`](./lean_stage3/FixedRowTwo.md#FixedRowTwo-cell_eq_zero_sum_two) | theorem | reads ζ | `FixedRowTwo` | ‖CellZeros.stencil d (fun n : ℤ =&gt; (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d + ∑' ρ : {ρ : Kadiri.NontrivialZeros // \|(ρ : ℂ).im\| &lt; T}, ((riemannZeta.order ((ρ : Kadiri.Nontri… |
| [`CellFixedRow.cell_fixed_row`](./lean_stage3/CellFixedRow.md#CellFixedRow-cell_fixed_row) | theorem | reads ζ | `CellFixedRow` | ∀ ε : ℝ, 0 &lt; ε → ∀ᶠ T : ℝ in Filter.atTop, ‖CellZeros.stencil d (fun n : ℤ =&gt; (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ) - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d + ∑ ρ ∈ ZF T, term d (r : ℤ) ρ‖ ≤ 2 ^ d * (… |
| [`FixedRowTwo.cell_fixed_row_two`](./lean_stage3/FixedRowTwo.md#FixedRowTwo-cell_fixed_row_two) | theorem | reads ζ | `FixedRowTwo` | ∀ ε : ℝ, 0 &lt; ε → ∀ᶠ T : ℝ in Filter.atTop, ‖CellZeros.stencil d (fun n : ℤ =&gt; (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ) - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d + ∑ ρ ∈ FiniteOffLine.ZF T, FiniteOffLine.t… |
| [`SeedPerturbation.cell_ne_at_boundary`](./lean/SeedPerturbation.md#SeedPerturbation-cell_ne_at_boundary) | theorem | counting | `SeedPerturbation` | tableFrom (fun x =&gt; N x - e x) r d ≠ tableFrom N r d |
| [`TableDepths.cell_ne_zero_gen`](./lean_stage3/TableDepths.md#TableDepths-cell_ne_zero_gen) | theorem | reads ζ | `TableDepths` | Construction.tableFrom TableRoute.rowN r d ≠ 0 |
| [`TableRoute.cell_ne_zero_of_RH`](./lean_stage3/TableRoute.md#TableRoute-cell_ne_zero_of_RH) | theorem | reads ζ | `TableRoute` | Construction.tableFrom rowN r 6 ≠ 0 |
| [`RouteCell.cell_ne_zero_of_route`](./lean/RouteCell.md#RouteCell-cell_ne_zero_of_route) | theorem | shape | `RouteCell` | Construction.tableFrom N r 6 ≠ 0 |
| [`CellRows.cell_tail_tendsto`](./lean_stage3/CellRows.md#CellRows-cell_tail_tendsto) | theorem | reads ζ | `CellRows` | Tendsto (fun r : ℕ =&gt; ‖CellZeros.stencil d (fun n : ℤ =&gt; (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) (r : ℤ) - (2:ℂ) ^ (r : ℤ) * (1 - (2:ℂ)⁻¹) ^ d + ∑ ρ ∈ ZF ((2:ℝ) ^ (r - d)), term d (r : ℤ) ρ‖ / Real.sqrt 2 ^ … |
| [`FiniteOffLine.cell_zero_sum_finset`](./lean_stage3/FiniteOffLine.md#FiniteOffLine-cell_zero_sum_finset) | theorem | reads ζ | `FiniteOffLine` | ‖CellZeros.stencil d (fun n : ℤ =&gt; (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d + ∑ ρ ∈ ZF T, term d r ρ‖ ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ) * (Glue.c1n * (2:ℝ) ^ (r - (j : … |
| [`CellFixedRow.cell_zero_sum_finset_all`](./lean_stage3/CellFixedRow.md#CellFixedRow-cell_zero_sum_finset_all) | theorem | reads ζ | `CellFixedRow` | ‖CellZeros.stencil d (fun n : ℤ =&gt; (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d + ∑ ρ ∈ ZF T, term d r ρ‖ ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ) * (Glue.c1n * (2:ℝ) ^ (r - (j : … |
| [`FixedRowTwo.cell_zero_sum_finset_two`](./lean_stage3/FixedRowTwo.md#FixedRowTwo-cell_zero_sum_finset_two) | theorem | reads ζ | `FixedRowTwo` | ‖CellZeros.stencil d (fun n : ℤ =&gt; (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d + ∑ ρ ∈ ZF T, term d r ρ‖ ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ) * (ExplicitTwo.c1t * (2:ℝ) ^ (r … |
| [`CellResidual.cellResid`](./lean_stage3/CellResidual.md#CellResidual-cellResid) | def | shape | `CellResidual` | ℝ |
| [`CellResidual.cells_of_RH`](./lean_stage3/CellResidual.md#CellResidual-cells_of_RH) | theorem | reads ζ | `CellResidual` | ∃ (C : ℝ) (r₀ : ℤ), CellsSqrt C r₀ |
| [`CellResidual.cells_of_schoenfeldWeak`](./lean_stage3/CellResidual.md#CellResidual-cells_of_schoenfeldWeak) | theorem | shape | `CellResidual` | CellsSqrt (C * Real.sqrt 2 * Real.log 2) r₀ |
| [`CellResidual.cellSize`](./lean_stage3/CellResidual.md#CellResidual-cellSize) | def | shape | `CellResidual` | ℝ |
| [`CellResidual.CellsSqrt`](./lean_stage3/CellResidual.md#CellResidual-CellsSqrt) | def | shape | `CellResidual` | Prop |
| [`EdgeBound.Cen`](./lean_stage3/EdgeNum.md#EdgeBound-Cen) | def | reads ζ | `EdgeNum` | ℝ |
| [`RouteNum.Cen_le`](./lean_stage3/RouteNum.md#RouteNum-Cen_le) | theorem | reads ζ | `RouteNum` | EdgeBound.Cen ≤ 1911393 |
| [`EdgeBound.Cen_pos`](./lean_stage3/EdgeNum.md#EdgeBound-Cen_pos) | theorem | reads ζ | `EdgeNum` | 0 &lt; Cen |
| [`WeilTiles.centre`](./lean_stage3/WeilTiles.md#WeilTiles-centre) | def | shape | `WeilTiles` | ℝ |
| [`WeilSeries.cFar`](./lean_stage3/WeilSeries.md#WeilSeries-cFar) | def | shape | `WeilSeries` | ℝ |
| [`WeilSeries.cFar_nonneg`](./lean_stage3/WeilSeries.md#WeilSeries-cFar_nonneg) | theorem | shape | `WeilSeries` | 0 ≤ cFar |
| [`WeilPowerBands.cFarM`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-cFarM) | def | shape | `WeilPowerBands` | ℝ |
| [`WeilPowerBands.cFarM_le`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-cFarM_le) | theorem | shape | `WeilPowerBands` | cFarM m ≤ 1000 * ((m : ℝ) + 1) ^ 2 |
| [`WeilPowerBands.cFarM_nonneg`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-cFarM_nonneg) | theorem | shape | `WeilPowerBands` | 0 ≤ cFarM m |
| [`PiRemainder.Chigh`](./lean_stage3/PiRemainder.md#PiRemainder-Chigh) | def | reads ζ | `PiRemainder` | ℝ |
| [`PiRemainder.Chigh_nonneg`](./lean_stage3/PiRemainder.md#PiRemainder-Chigh_nonneg) | theorem | reads ζ | `PiRemainder` | 0 ≤ Chigh |
| [`Glue.Chn`](./lean_stage3/GlueNum.md#Glue-Chn) | def | reads ζ | `GlueNum` | ℝ |
| [`RouteNum.Chn_le`](./lean_stage3/RouteNum.md#RouteNum-Chn_le) | theorem | reads ζ | `RouteNum` | Glue.Chn ≤ 44108300000 |
| [`Glue.Chn_pos`](./lean_stage3/GlueNum.md#Glue-Chn_pos) | theorem | reads ζ | `GlueNum` | 0 &lt; Chn |
| [`Expansion.choose_factorial_step`](./lean/Expansion.md#Expansion-choose_factorial_step) | theorem | counting | `Expansion` | d.choose (j + 1) * (j + 1).factorial = d.choose j * j.factorial * (d - j) |
| [`ExplicitTwo.Cht`](./lean_stage3/ExplicitTwo.md#ExplicitTwo-Cht) | def | reads ζ | `ExplicitTwo` | ℝ |
| [`ExplicitTwo.Cht_pos`](./lean_stage3/ExplicitTwo.md#ExplicitTwo-Cht_pos) | theorem | reads ζ | `ExplicitTwo` | 0 &lt; Cht |
| [`SquareMean.circle_sq_mean`](./lean_stage3/SquareMean.md#SquareMean-circle_sq_mean) | theorem | shape | `SquareMean` | 2 * π * ‖f c‖ ^ 2 ≤ ∫ θ in Ioo (-π) π, ‖f (c + (r : ℂ) * ((Real.cos θ : ℂ) + (Real.sin θ : ℂ) * Complex.I))‖ ^ 2 |
| [`WeilPower.cK`](./lean_stage3/WeilPower.md#WeilPower-cK) | def | shape | `WeilPower` | ℝ |
| [`WeilPower.cK_one`](./lean_stage3/WeilPower.md#WeilPower-cK_one) | theorem | shape | `WeilPower` | cK 1 = Real.pi ^ 2 |
| [`WeilPower.cK_succ`](./lean_stage3/WeilPower.md#WeilPower-cK_succ) | theorem | shape | `WeilPower` | cK (m + 1) = ((m : ℝ) + 1) * (2 * (m : ℝ) + 1) * Real.pi ^ 2 / 2 * cK m |
| [`PiFixedRow.Clow`](./lean_stage3/PiFixedRow.md#PiFixedRow-Clow) | def | reads ζ | `PiFixedRow` | ℝ |
| [`PiFixedRow.Clow_nonneg`](./lean_stage3/PiFixedRow.md#PiFixedRow-Clow_nonneg) | theorem | reads ζ | `PiFixedRow` | 0 ≤ Clow |
| [`PerronKernel.coarse_gt_ineq`](./lean_stage3/PerronKernel.md#PerronKernel-coarse_gt_ineq) | theorem | shape | `PerronKernel` | v * Real.exp u + Real.pi - Real.arctan (v / u) ≤ Real.pi * Real.exp u |
| [`LadderMean.coef`](./lean_stage3/LadderMean.md#LadderMean-coef) | def | reads ζ | `LadderMean` | ℂ |
| [`Mollified.coef`](./lean_stage3/Mollified.md#Mollified-coef) | def | counting | `Mollified` | ℤ |
| [`WeilPowerShell.coef`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-coef) | def | shape | `WeilPowerShell` | ℂ |
| [`Mollified.coef_eq_zero`](./lean_stage3/Mollified.md#Mollified-coef_eq_zero) | theorem | counting | `Mollified` | coef X N n = 0 |
| [`Mollified.coef_one`](./lean_stage3/Mollified.md#Mollified-coef_one) | theorem | counting | `Mollified` | coef X N 1 = 1 |
| [`Mollified.coef_sq_le`](./lean_stage3/Mollified.md#Mollified-coef_sq_le) | theorem | shape | `Mollified` | (coef X N n : ℝ) ^ 2 ≤ (tauBelow X n : ℝ) ^ 2 |
| [`PairIdentity.coeff_eq_one_iff_base_two`](./lean/PairIdentity.md#PairIdentity-coeff_eq_one_iff_base_two) | theorem | counting | `PairIdentity` | (b - 1) ^ (d + 1) = 1 ↔ b = 2 |
| [`FilterLadder.coeff_posPoly`](./lean_stage3/FilterLadder.md#FilterLadder-coeff_posPoly) | theorem | counting | `FilterLadder` | (posPoly q).coeff i = ‖q.coeff i‖ |
| [`WeilPowerCompare.compare_le`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-compare_le) | theorem | shape | `WeilPowerCompare` | ‖S m w‖ ≤ (2 * (m : ℝ) + 3) * (‖w‖ / s) * Real.exp (Eup m w - Elow m s) * (S m (s : ℂ)).re |
| [`WeilPowerSharp.compare_sharp`](./lean_stage3/WeilPowerSharp.md#WeilPowerSharp-compare_sharp) | theorem | shape | `WeilPowerSharp` | ‖S m w‖ ≤ ‖w‖ / s * Real.exp (((w ^ 2).re - s ^ 2) / (Real.pi ^ 2 * ((m : ℝ) + 1)) + s ^ 2 / (Real.pi ^ 2 * ((m : ℝ) + 1) * ((m : ℝ) + 2)) + (‖w‖ ^ 4 + s ^ 4) / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) * (S… |
| [`WeilPowerCompare.compare_suppressed`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-compare_suppressed) | theorem | shape | `WeilPowerCompare` | ‖S m (wOf ε' Δ h)‖ ≤ (2 * (m : ℝ) + 3) * (‖wOf ε' Δ h‖ / (ε * h)) * Real.exp (rate m ε' Δ ε * h ^ 2 / 2) * (S m ((ε * h : ℝ) : ℂ)).re |
| [`Stage3.completed_eq_gammaR_mul_zeta`](./lean_stage3/ArgIdentity.md#Stage3-completed_eq_gammaR_mul_zeta) | theorem | reads ζ | `ArgIdentity` | completedRiemannZeta s = Gammaℝ s * riemannZeta s |
| [`Stage3.completed_eq_gammaR_mul_zeta'`](./lean_stage3/ArgIdentity.md#Stage3-completed_eq_gammaR_mul_zeta-) | theorem | reads ζ | `ArgIdentity` | completedRiemannZeta s = Gammaℝ s * riemannZeta s |
| [`Stage3.completedZeta₀_conj`](./lean_stage3/ArgIdentity.md#Stage3-completedZeta-_conj) | theorem | reads ζ | `ArgIdentity` | completedRiemannZeta₀ (conj s) = conj (completedRiemannZeta₀ s) |
| [`PairIdentity.composite_at_zero_20_6`](./lean/PairIdentity.md#PairIdentity-composite_at_zero_20_6) | theorem | counting | `PairIdentity` | tableFrom C 20 6 = 8192 |
| [`DeepZeroBand.composite_cell_20_6`](./lean/DeepZeroBand.md#DeepZeroBand-composite_cell_20_6) | theorem | counting | `DeepZeroBand` | tableFrom compRow 20 6 = 8192 |
| [`PairIdentity.composite_of_prime_zero`](./lean/PairIdentity.md#PairIdentity-composite_of_prime_zero) | theorem | counting | `PairIdentity` | tableFrom C r d = (b - 1) ^ (d + 1) * b ^ e |
| [`DeepZeroBand.compRow`](./lean/DeepZeroBand.md#DeepZeroBand-compRow) | def | counting | `DeepZeroBand` | ℤ → ℤ |
| [`Propagation.cone_filled`](./lean/Propagation.md#Propagation-cone_filled) | theorem | counting | `Propagation` | tableFrom (deltaRow s) (s + (k : ℤ)) d ≠ 0 |
| [`EulerFactorChain.conj_factor_on_critical_line`](./lean/EulerFactorChain.md#EulerFactorChain-conj_factor_on_critical_line) | theorem | shape | `EulerFactorChain` | (starRingEnd ℂ) (1 - (b : ℂ) ^ (-((1 : ℂ)/2 + t * I))) = 1 - (b : ℂ) ^ (((1 : ℂ)/2 + t * I) - 1) |
| [`WeilOnLine.conj_mem`](./lean_stage3/WeilOnLine.md#WeilOnLine-conj_mem) | theorem | reads ζ | `WeilOnLine` | (starRingEnd ℂ) (ρ : ℂ) ∈ Kadiri.NontrivialZeros |
| [`Bridge.conj_paperFT_conj`](./lean_bridge/WeilBridge.md#Bridge-conj_paperFT_conj) | theorem | shape | `WeilBridge` | conj (paperFT F (conj z)) = paperFT F (-z) |
| [`WeilOnLine.conjZ`](./lean_stage3/WeilOnLine.md#WeilOnLine-conjZ) | def | reads ζ | `WeilOnLine` | Kadiri.NontrivialZeros |
| [`WeilOnLine.conjZ_injective`](./lean_stage3/WeilOnLine.md#WeilOnLine-conjZ_injective) | theorem | reads ζ | `WeilOnLine` | Function.Injective conjZ |
| [`GeneratorPeak.const_of_eq`](./lean/GeneratorPeak.md#GeneratorPeak-const_of_eq) | theorem | shape | `GeneratorPeak` | score R P α β i = score R P α β j |
| [`ZeroCells.construction_all_vanish`](./lean/ZeroCells.md#ZeroCells-construction_all_vanish) | theorem | counting | `ZeroCells` | ∀ c ∈ Construction.measured_zeros, Construction.tableFrom Zeros.dyadicRow (c.1 : ℤ) c.2 = 0 |
| [`ZeroCells.construction_eq`](./lean/ZeroCells.md#ZeroCells-construction_eq) | theorem | counting | `ZeroCells` | Construction.measured_zeros = Zeros.measured_zeros |
| [`MainTerm.contDiff_bdiffR`](./lean/MainTerm.md#MainTerm-contDiff_bdiffR) | theorem | shape | `MainTerm` | ContDiff ℝ (⊤ : ℕ∞) (bdiffR g) |
| [`Bridge.contDiff_kOf`](./lean_bridge/WeilBridge.md#Bridge-contDiff_kOf) | theorem | shape | `WeilBridge` | ContDiff ℝ 2 (kOf G) |
| [`Stage3.contDiff_one_indicator_Icc`](./lean_stage3/IndicatorContDiff.md#Stage3-contDiff_one_indicator_Icc) | theorem | shape | `IndicatorContDiff` | ContDiff ℝ 1 (Set.indicator (Set.Icc a b) f) |
| [`Stage3.contDiff_sqPos`](./lean_stage3/ExplicitBump.md#Stage3-contDiff_sqPos) | theorem | shape | `ExplicitBump` | ContDiff ℝ 1 (fun t : ℝ =&gt; (max 0 t) ^ 2) |
| [`Bridge.contDiff_tilde`](./lean_bridge/WeilBridge.md#Bridge-contDiff_tilde) | theorem | shape | `WeilBridge` | ContDiff ℝ 1 (tilde g) |
| [`Bridge.contDiff_tiltF`](./lean_bridge/WeilBridge.md#Bridge-contDiff_tiltF) | theorem | shape | `WeilBridge` | ContDiff ℝ 1 (tiltF G) |
| [`Bridge.contDiff_two_convolution`](./lean_bridge/WeilBridge.md#Bridge-contDiff_two_convolution) | theorem | shape | `WeilBridge` | ContDiff ℝ 2 (f ⋆[ContinuousLinearMap.mul ℝ ℂ, volume] h) |
| [`ZetaEM.continuous_bernoulliFun_fract`](./lean_stage3/ZetaEM.md#ZetaEM-continuous_bernoulliFun_fract) | theorem | reads ζ | `ZetaEM` | Continuous (fun x : ℝ ↦ bernoulliFun k (Int.fract x)) |
| [`WeilPower.continuous_c`](./lean_stage3/WeilPower.md#WeilPower-continuous_c) | theorem | shape | `WeilPower` | Continuous c |
| [`LeftSmooth.continuous_cpow_tI`](./lean_stage3/LeftSmooth.md#LeftSmooth-continuous_cpow_tI) | theorem | shape | `LeftSmooth` | Continuous fun t : ℝ =&gt; (y:ℂ) ^ ((t:ℂ) * Complex.I) |
| [`LeftSmooth.continuous_digamma_wL`](./lean_stage3/LeftSmooth.md#LeftSmooth-continuous_digamma_wL) | theorem | shape | `LeftSmooth` | Continuous fun t : ℝ =&gt; Complex.digamma (wL t) |
| [`WeilPower.continuous_f1`](./lean_stage3/WeilPower.md#WeilPower-continuous_f1) | theorem | shape | `WeilPower` | Continuous (f1 k) |
| [`WeilPower.continuous_f2`](./lean_stage3/WeilPower.md#WeilPower-continuous_f2) | theorem | shape | `WeilPower` | Continuous (f2 k) |
| [`ZeroSquares.continuous_innerI`](./lean_stage3/ZeroSquares.md#ZeroSquares-continuous_innerI) | theorem | reads ζ | `ZeroSquares` | Continuous (innerI X a b) |
| [`LeftSmooth.continuous_logDeriv_path`](./lean_stage3/LeftSmooth.md#LeftSmooth-continuous_logDeriv_path) | theorem | reads ζ | `LeftSmooth` | Continuous fun t =&gt; deriv riemannZeta (p t) / riemannZeta (p t) |
| [`WeilWindow.continuous_P`](./lean_stage3/WeilWindow.md#WeilWindow-continuous_P) | theorem | shape | `WeilWindow` | Continuous P |
| [`Stage3.continuous_phasePoint`](./lean_stage3/Stirling.md#Stage3-continuous_phasePoint) | theorem | reads ζ | `Stirling` | Continuous phasePoint |
| [`WeilOddPower.continuous_q`](./lean_stage3/WeilOddPower.md#WeilOddPower-continuous_q) | theorem | shape | `WeilOddPower` | Continuous (q m) |
| [`WeilLobe.continuous_q1`](./lean_stage3/WeilLobe.md#WeilLobe-continuous_q1) | theorem | shape | `WeilLobe` | Continuous q1 |
| [`WeilLobe.continuous_q2`](./lean_stage3/WeilLobe.md#WeilLobe-continuous_q2) | theorem | shape | `WeilLobe` | Continuous q2 |
| [`LeftSmooth.continuous_sL`](./lean_stage3/LeftSmooth.md#LeftSmooth-continuous_sL) | theorem | shape | `LeftSmooth` | Continuous sL |
| [`ZeroSquares.continuous_sqG`](./lean_stage3/ZeroSquares.md#ZeroSquares-continuous_sqG) | theorem | reads ζ | `ZeroSquares` | Continuous (Function.uncurry (sqG X)) |
| [`ZeroSquares.continuous_sqG_slice`](./lean_stage3/ZeroSquares.md#ZeroSquares-continuous_sqG_slice) | theorem | reads ζ | `ZeroSquares` | Continuous (sqG X u) |
| [`LeftSmooth.continuous_tan_wL`](./lean_stage3/LeftSmooth.md#LeftSmooth-continuous_tan_wL) | theorem | shape | `LeftSmooth` | Continuous fun t : ℝ =&gt; Complex.tan ((Real.pi:ℂ) * wL t / 2) |
| [`LeftSmooth.continuous_tanPiece`](./lean_stage3/LeftSmooth.md#LeftSmooth-continuous_tanPiece) | theorem | shape | `LeftSmooth` | Continuous tanPiece |
| [`LeftSmooth.continuous_tanPiece'`](./lean_stage3/LeftSmooth.md#LeftSmooth-continuous_tanPiece-) | theorem | shape | `LeftSmooth` | Continuous tanPiece' |
| [`LeftSmooth.continuous_wL`](./lean_stage3/LeftSmooth.md#LeftSmooth-continuous_wL) | theorem | shape | `LeftSmooth` | Continuous wL |
| [`WeilWindow.continuous_x2P`](./lean_stage3/WeilWindow.md#WeilWindow-continuous_x2P) | theorem | shape | `WeilWindow` | Continuous fun x : ℝ =&gt; x ^ 2 * P x |
| [`WeilTransform.continuous_xP`](./lean_stage3/WeilTransform.md#WeilTransform-continuous_xP) | theorem | shape | `WeilTransform` | Continuous fun x : ℝ =&gt; x * P x |
| [`Stage3.continuousOn_exp_div`](./lean_stage3/RowLeaves.md#Stage3-continuousOn_exp_div) | theorem | shape | `RowLeaves` | ContinuousOn (fun t : ℝ =&gt; Real.exp (Real.log 2 * t) / t) (Ioi 0) |
| [`Stage3.continuousOn_inv_log_sq`](./lean_stage3/PsiToPi.md#Stage3-continuousOn_inv_log_sq) | theorem | shape | `PsiToPi` | ContinuousOn (fun t : ℝ =&gt; 1 / Real.log t ^ 2) (Set.uIcc a x) |
| [`Stage3.continuousOn_inv_log_sq_Ioi`](./lean_stage3/RowLeaves.md#Stage3-continuousOn_inv_log_sq_Ioi) | theorem | shape | `RowLeaves` | ContinuousOn (fun t : ℝ =&gt; 1 / Real.log t ^ 2) (Ioi 1) |
| [`Stage3.continuousOn_inv_mul_log_sq`](./lean_stage3/PsiToPi.md#Stage3-continuousOn_inv_mul_log_sq) | theorem | shape | `PsiToPi` | ContinuousOn (fun t : ℝ =&gt; (t * Real.log t ^ 2)⁻¹) (Set.uIcc a x) |
| [`PiToPsi.continuousOn_Li`](./lean_stage3/PiToPsi.md#PiToPsi-continuousOn_Li) | theorem | shape | `PiToPsi` | ContinuousOn Stage3.Li (Ioi 1) |
| [`PiFixedRow.continuousOn_wd`](./lean_stage3/PiFixedRow.md#PiFixedRow-continuousOn_wd) | theorem | shape | `PiFixedRow` | ContinuousOn wd (Set.uIcc 2 16) |
| [`RHPull.contour_at_instantiation`](./lean_stage3/LineBound.md#RHPull-contour_at_instantiation) | theorem | reads ζ | `LineBound` | ‖SmoothedChebyshev ν ε X - mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 * X‖ ≤ B₁ + B₉ + (66600 * Real.exp 1 * B / Real.pi) * Real.sqrt X * (Real.log X) ^ 3 + (1 / (2 * Real.pi)) * (1 / 2) * ((1996 * Real.l… |
| [`Stage3.contour_at_instantiation_theta`](./lean_stage3/ThetaPsi.md#Stage3-contour_at_instantiation_theta) | theorem | reads ζ | `ThetaPsi` | ‖SmoothedChebyshev ν ε X - mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 * X‖ ≤ B₁ + B₉ + (66600 * Real.exp 1 * B / Real.pi) * X ^ θ * (Real.log X) ^ 3 + (1 / (2 * Real.pi)) * (1 - θ) * ((1996 * Real.log (84… |
| [`LandauCriterion.contradiction`](./lean_stage3/LandauCriterion.md#LandauCriterion-contradiction) | theorem | reads ζ | `LandauCriterion` | False |
| [`WeilPowerNear.cos_ge_lin`](./lean_stage3/WeilPowerNear.md#WeilPowerNear-cos_ge_lin) | theorem | shape | `WeilPowerNear` | 1 - 2 * θ / Real.pi ≤ Real.cos θ |
| [`LeftSmooth.cos_sq_le_norm_cos`](./lean_stage3/LeftSmooth.md#LeftSmooth-cos_sq_le_norm_cos) | theorem | shape | `LeftSmooth` | Real.cos a ^ 2 + b ^ 2 ≤ ‖Complex.cos ((a:ℂ) + (b:ℂ) * Complex.I)‖ ^ 2 |
| [`LeftSmooth.cos_sq_mul_norm_sin_le`](./lean_stage3/LeftSmooth.md#LeftSmooth-cos_sq_mul_norm_sin_le) | theorem | shape | `LeftSmooth` | Real.cos a ^ 2 * ‖Complex.sin ((a:ℂ) + (b:ℂ) * Complex.I)‖ ^ 2 ≤ ‖Complex.cos ((a:ℂ) + (b:ℂ) * Complex.I)‖ ^ 2 |
| [`LeftSmooth.cos_wL_ne`](./lean_stage3/LeftSmooth.md#LeftSmooth-cos_wL_ne) | theorem | shape | `LeftSmooth` | Complex.cos ((Real.pi:ℂ) * wL t / 2) ≠ 0 |
| [`Crossover.count_does_not_determine_spread`](./lean/Crossover.md#Crossover-count_does_not_determine_spread) | theorem | shape | `Crossover` | (6.892378652639774e-07 : ℝ) &lt; 0.0736589 ∧ (0.0736589 : ℝ) / 6.892378652639774e-07 &gt; 100000 |
| [`WobbleCount.count_identity`](./lean_stage3/WobbleCount.md#WobbleCount-count_identity) | theorem | shape | `WobbleCount` | ∑ n ∈ Finset.Ioc 0 N, Real.log n = ∑ d ∈ Finset.Ioc 0 N, ∑ m ∈ Finset.Ioc 0 (N / d), Λ m |
| [`WeilPowerCount.count_lt_shells`](./lean_stage3/WeilPowerCount.md#WeilPowerCount-count_lt_shells) | theorem | shape | `WeilPowerCount` | N * (W + 1) &lt; K |
| [`Elephant.coupling_coeff`](./lean/Elephant.md#Elephant-coupling_coeff) | theorem | shape | `Elephant` | ∑ k ∈ Finset.Icc 1 d, ((d.choose k : ℝ) * (-1) ^ k * vonMangoldt (b ^ k) * ((b : ℝ)⁻¹) ^ k) = -(vonMangoldt b) * (1 - (1 - (b : ℝ)⁻¹) ^ d) |
| [`Covering.covered`](./lean/Covering.md#Covering-covered) | def | shape | `Covering` | Prop |
| [`Covering.covered_of_half_spacing`](./lean/Covering.md#Covering-covered_of_half_spacing) | theorem | shape | `Covering` | covered L eps u |
| [`Covering.covered_smul`](./lean/Covering.md#Covering-covered_smul) | theorem | shape | `Covering` | covered (c * L) (c * eps) (c * u) |
| [`Covering.covering_not_monotone`](./lean/Covering.md#Covering-covering_not_monotone) | theorem | shape | `Covering` | ∃ (L eps u v : ℝ), 0 &lt; L ∧ u &lt; v ∧ ¬ covered L eps u ∧ covered L eps v |
| [`WeilPowerCompare.cP`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-cP) | def | shape | `WeilPowerCompare` | ℝ |
| [`WeilPowerCompare.cP_pos`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-cP_pos) | theorem | shape | `WeilPowerCompare` | 0 &lt; cP m |
| [`Glue.Cpn`](./lean_stage3/GlueNum.md#Glue-Cpn) | def | reads ζ | `GlueNum` | ℝ |
| [`ExplicitTwo.Cpn_ge`](./lean_stage3/ExplicitTwo.md#ExplicitTwo-Cpn_ge) | theorem | reads ζ | `ExplicitTwo` | (360:ℝ) ≤ Glue.Cpn |
| [`RouteNum.Cpn_le`](./lean_stage3/RouteNum.md#RouteNum-Cpn_le) | theorem | reads ζ | `RouteNum` | Glue.Cpn ≤ 6534550000 |
| [`Glue.Cpn_pos`](./lean_stage3/GlueNum.md#Glue-Cpn_pos) | theorem | reads ζ | `GlueNum` | 0 &lt; Cpn |
| [`FiniteOffLinePi.cpow_doubling`](./lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-cpow_doubling) | theorem | shape | `FiniteOffLinePi` | (((2:ℝ) ^ r : ℝ) : ℂ) ^ ρ = ((2:ℂ) ^ ρ) ^ r |
| [`Elephant.cpow_neg_mul_lseries`](./lean/Elephant.md#Elephant-cpow_neg_mul_lseries) | theorem | reads ζ | `Elephant` | (b : ℂ) ^ (-s) * LSeries a s = LSeries (fun m =&gt; if b ∣ m then a (m / b) else 0) s |
| [`Elephant.cpow_neg_pow`](./lean/Elephant.md#Elephant-cpow_neg_pow) | theorem | shape | `Elephant` | ((b : ℂ) ^ (-ρ)) ^ k = (b : ℂ) ^ (-((k : ℂ) * ρ)) |
| [`EulerFactorChain.cpow_rect_on_critical_line`](./lean/EulerFactorChain.md#EulerFactorChain-cpow_rect_on_critical_line) | theorem | shape | `EulerFactorChain` | (b : ℂ) ^ (-((1 : ℂ)/2 + γ * I)) = ((b ^ (-(1:ℝ)/2) * Real.cos (γ * Real.log b) : ℝ) : ℂ) + ((-(b ^ (-(1:ℝ)/2) * Real.sin (γ * Real.log b)) : ℝ) : ℂ) * I |
| [`LeftSmooth.cpow_sL`](./lean_stage3/LeftSmooth.md#LeftSmooth-cpow_sL) | theorem | shape | `LeftSmooth` | (x:ℂ) ^ (sL t) = ((x ^ (-(1:ℝ)/4) : ℝ):ℂ) * (x:ℂ) ^ ((t:ℂ) * Complex.I) |
| [`PerronKernel.cpow_sub_one_bound`](./lean_stage3/PerronKernel.md#PerronKernel-cpow_sub_one_bound) | theorem | shape | `PerronKernel` | ‖(y : ℂ) ^ s - 1‖ ≤ ‖s‖ * Real.log y * y ^ s.re |
| [`LeftKernel.cpow_tI`](./lean_stage3/LeftKernel.md#LeftKernel-cpow_tI) | theorem | shape | `LeftKernel` | (y:ℂ) ^ ((t:ℂ) * Complex.I) = Complex.exp ((Real.log y : ℂ) * ((t:ℂ) * Complex.I)) |
| [`CellZeros.cpow_two_zpow`](./lean_stage3/CellZeros.md#CellZeros-cpow_two_zpow) | theorem | shape | `CellZeros` | (((2:ℝ) ^ n : ℝ) : ℂ) ^ ρ = ((2:ℂ) ^ ρ) ^ n |
| [`WeilPowerGauss.cprime_eq`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-cprime_eq) | theorem | shape | `WeilPowerGauss` | cS m / D m = ((Nat.centralBinom (m + 1) : ℕ) : ℝ) / (Real.pi * ((m : ℝ) + 1) * 4 ^ m) |
| [`WeilPowerGauss.cprime_ge`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-cprime_ge) | theorem | shape | `WeilPowerGauss` | 4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) ≤ cS m / D m |
| [`WeilPowerGauss.cprime_le`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-cprime_le) | theorem | shape | `WeilPowerGauss` | cS m / D m ≤ 4 / (Real.pi * ((m : ℝ) + 1)) |
| [`WeilPowerGauss.cprime_pos`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-cprime_pos) | theorem | shape | `WeilPowerGauss` | 0 &lt; cS m / D m |
| [`WeilPowerCompare.cQ`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-cQ) | def | shape | `WeilPowerCompare` | ℝ |
| [`WeilPowerCompare.cQ_pos`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-cQ_pos) | theorem | shape | `WeilPowerCompare` | 0 &lt; cQ m |
| [`Transform.critical_circle_is_lattice_inversion_mean`](./lean/Transform.md#Transform-critical_circle_is_lattice_inversion_mean) | theorem | shape | `Transform` | ‖(b : ℂ) ^ (-s)‖ * ‖(b : ℂ) ^ (-(1 - s))‖ = (b ^ (-(1 : ℝ) / 2)) ^ 2 |
| [`WeilOddPower.cS`](./lean_stage3/WeilOddPower.md#WeilOddPower-cS) | def | shape | `WeilOddPower` | ℝ |
| [`WeilOddPower.cS_eq`](./lean_stage3/WeilOddPower.md#WeilOddPower-cS_eq) | theorem | shape | `WeilOddPower` | cS m * (((m : ℝ) + 1) * Real.pi) = 2 * cK (m + 1) |
| [`WeilPowerBands.cS_le`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-cS_le) | theorem | shape | `WeilPowerBands` | cS m ≤ 4 * Real.pi ^ (2 * m + 1) * ((m : ℝ) + 1) ^ (2 * m + 1) |
| [`WeilPowerBounds.cS_pos`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-cS_pos) | theorem | shape | `WeilPowerBounds` | 0 &lt; cS m |
| [`Glue.Csn`](./lean_stage3/GlueNum.md#Glue-Csn) | def | shape | `GlueNum` | ℝ |
| [`RouteNum.Csn_le`](./lean_stage3/RouteNum.md#RouteNum-Csn_le) | theorem | shape | `RouteNum` | Glue.Csn ≤ 1136 |
| [`Glue.Csn_pos`](./lean_stage3/GlueNum.md#Glue-Csn_pos) | theorem | shape | `GlueNum` | 0 &lt; Csn |
| [`JointSymbol.cutG`](./lean_stage3/JointSymbol.md#JointSymbol-cutG) | def | shape | `JointSymbol` | ℂ |
| [`WeilPowerGauss.D`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-D) | def | shape | `WeilPowerGauss` | ℝ |
| [`JointLadder.d2`](./lean/JointLadder.md#JointLadder-d2) | def | shape | `JointLadder` | ℤ → ℤ → ℂ |
| [`JointLadder.d2_d3_comm`](./lean/JointLadder.md#JointLadder-d2_d3_comm) | theorem | shape | `JointLadder` | d2 (d3 f) = d3 (d2 f) |
| [`JointLadder.d2_iter_jmode`](./lean/JointLadder.md#JointLadder-d2_iter_jmode) | theorem | shape | `JointLadder` | (d2^[a]) (jmode ρ) = fun r m =&gt; (Chain.Sym 2 ρ) ^ a * jmode ρ r m |
| [`JointLadder.d2_jmode`](./lean/JointLadder.md#JointLadder-d2_jmode) | theorem | shape | `JointLadder` | d2 (jmode ρ) r m = Chain.Sym 2 ρ * jmode ρ r m |
| [`JointLadder.d3`](./lean/JointLadder.md#JointLadder-d3) | def | shape | `JointLadder` | ℤ → ℤ → ℂ |
| [`JointLadder.d3_iter_jmode`](./lean/JointLadder.md#JointLadder-d3_iter_jmode) | theorem | shape | `JointLadder` | (d3^[b]) (jmode ρ) = fun r m =&gt; (Chain.Sym 3 ρ) ^ b * jmode ρ r m |
| [`JointLadder.d3_jmode`](./lean/JointLadder.md#JointLadder-d3_jmode) | theorem | shape | `JointLadder` | d3 (jmode ρ) r m = Chain.Sym 3 ρ * jmode ρ r m |
| [`WeilPowerGauss.D_eq`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-D_eq) | theorem | shape | `WeilPowerGauss` | D m = Real.pi ^ (2 * (m + 1)) * (((m + 1).factorial : ℕ) : ℝ) ^ 2 |
| [`WeilPowerGauss.D_pos`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-D_pos) | theorem | shape | `WeilPowerGauss` | 0 &lt; D m |
| [`JointSymbol.dd`](./lean_stage3/JointSymbol.md#JointSymbol-dd) | def | shape | `JointSymbol` | ℝ → ℂ |
| [`JointSymbol.dd_iter_rule`](./lean_stage3/JointSymbol.md#JointSymbol-dd_iter_rule) | theorem | shape | `JointSymbol` | (dd^[d + 1] f) y = (dd^[d] f) y - (dd^[d] f) (y / 2) |
| [`DeepZeroBand.deep_cell_15_6`](./lean/DeepZeroBand.md#DeepZeroBand-deep_cell_15_6) | theorem | counting | `DeepZeroBand` | tableFrom Zeros.dyadicRow 15 6 = -112 |
| [`DeepZeroBand.deep_zero_inverse_on_inner_circle`](./lean/DeepZeroBand.md#DeepZeroBand-deep_zero_inverse_on_inner_circle) | theorem | shape | `DeepZeroBand` | ‖(b : ℂ) ^ (-((share compRow 20 6 13 : ℝ) : ℂ))‖ = b ^ (-(1 : ℝ)) |
| [`DeepZeroBand.deep_zero_inverse_share`](./lean/DeepZeroBand.md#DeepZeroBand-deep_zero_inverse_share) | theorem | shape | `DeepZeroBand` | share compRow 20 6 13 = 1 |
| [`DeepZeroBand.deep_zero_on_outer_circle`](./lean/DeepZeroBand.md#DeepZeroBand-deep_zero_on_outer_circle) | theorem | shape | `DeepZeroBand` | ‖(b : ℂ) ^ (-((share Zeros.dyadicRow 20 6 13 : ℝ) : ℂ))‖ = 1 |
| [`DeepZeroBand.deep_zero_share`](./lean/DeepZeroBand.md#DeepZeroBand-deep_zero_share) | theorem | shape | `DeepZeroBand` | share Zeros.dyadicRow 20 6 13 = 0 |
| [`WeilPowerPhase.delta`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-delta) | def | shape | `WeilPowerPhase` | ℂ |
| [`PerronKernel.delta_sum_close`](./lean_stage3/PerronKernel.md#PerronKernel-delta_sum_close) | theorem | shape | `PerronKernel` | ‖(Chebyshev.psi x : ℂ) - ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronδ (x / n)‖ ≤ Real.log x |
| [`PerronTwo.delta_sum_close_two`](./lean_stage3/PerronTwo.md#PerronTwo-delta_sum_close_two) | theorem | shape | `PerronTwo` | ‖(Chebyshev.psi x : ℂ) - ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronδ (x / n)‖ ≤ Real.log x |
| [`Propagation.deltaRow`](./lean/Propagation.md#Propagation-deltaRow) | def | counting | `Propagation` | ℤ → ℤ |
| [`TableDepths.depth_eight`](./lean_stage3/TableDepths.md#TableDepths-depth_eight) | theorem | reads ζ | `TableDepths` | Construction.tableFrom TableRoute.rowN r 8 ≠ 0 |
| [`TableDepths.depth_five`](./lean_stage3/TableDepths.md#TableDepths-depth_five) | theorem | reads ζ | `TableDepths` | Construction.tableFrom TableRoute.rowN r 5 ≠ 0 |
| [`TableDepths.depth_four`](./lean_stage3/TableDepths.md#TableDepths-depth_four) | theorem | reads ζ | `TableDepths` | Construction.tableFrom TableRoute.rowN r 4 ≠ 0 |
| [`TableDepths.depth_one`](./lean_stage3/TableDepths.md#TableDepths-depth_one) | theorem | reads ζ | `TableDepths` | Construction.tableFrom TableRoute.rowN r 1 ≠ 0 |
| [`Superposition.depth_reweights_each_mode`](./lean/Superposition.md#Superposition-depth_reweights_each_mode) | theorem | shape | `Superposition` | (bdiff^[N]) (modeSum b ρ c s) r = modeSum b ρ (fun i =&gt; c i * (Sym b (ρ i)) ^ N) s r |
| [`TableDepths.depth_seven`](./lean_stage3/TableDepths.md#TableDepths-depth_seven) | theorem | reads ζ | `TableDepths` | Construction.tableFrom TableRoute.rowN r 7 ≠ 0 |
| [`TableDepths.depth_six`](./lean_stage3/TableDepths.md#TableDepths-depth_six) | theorem | reads ζ | `TableDepths` | Construction.tableFrom TableRoute.rowN r 6 ≠ 0 |
| [`TableDepths.depth_three`](./lean_stage3/TableDepths.md#TableDepths-depth_three) | theorem | reads ζ | `TableDepths` | Construction.tableFrom TableRoute.rowN r 3 ≠ 0 |
| [`TableDepths.depth_two`](./lean_stage3/TableDepths.md#TableDepths-depth_two) | theorem | reads ζ | `TableDepths` | Construction.tableFrom TableRoute.rowN r 2 ≠ 0 |
| [`NyquistPeak.depth_zero_vacuous`](./lean/NyquistPeak.md#NyquistPeak-depth_zero_vacuous) | theorem | shape | `NyquistPeak` | gain 0 θ = 1 |
| [`MainTerm.deriv_bdiffR`](./lean/MainTerm.md#MainTerm-deriv_bdiffR) | theorem | shape | `MainTerm` | deriv (bdiffR g) = bdiffR (deriv g) |
| [`NyquistPeak.deriv_gain_pi`](./lean/NyquistPeak.md#NyquistPeak-deriv_gain_pi) | theorem | shape | `NyquistPeak` | deriv (gain d) Real.pi = 0 |
| [`EdgeBound.deriv_zeta_conj`](./lean_stage3/EdgeBound.md#EdgeBound-deriv_zeta_conj) | theorem | reads ζ | `EdgeBound` | deriv riemannZeta ((starRingEnd ℂ) s) = (starRingEnd ℂ) (deriv riemannZeta s) |
| [`WeilPowerAssembly.detect_gap_exists`](./lean_stage3/WeilPowerAssembly.md#WeilPowerAssembly-detect_gap_exists) | theorem | reads ζ | `WeilPowerAssembly` | ∃ L : ℝ, StmtDetectGap ε T δ L |
| [`LeftSmooth.dgTerm`](./lean_stage3/LeftSmooth.md#LeftSmooth-dgTerm) | def | counting | `LeftSmooth` | ℝ |
| [`LeftSmooth.dgTerm_nonneg`](./lean_stage3/LeftSmooth.md#LeftSmooth-dgTerm_nonneg) | theorem | counting | `LeftSmooth` | 0 ≤ dgTerm n |
| [`LeftSmooth.dgTerm_summable`](./lean_stage3/LeftSmooth.md#LeftSmooth-dgTerm_summable) | theorem | shape | `LeftSmooth` | Summable dgTerm |
| [`EulerFactorChain.diagonal_cell`](./lean/EulerFactorChain.md#EulerFactorChain-diagonal_cell) | theorem | shape | `EulerFactorChain` | (b : ℂ) ^ (((d : ℂ) + c) * ρ) * (sym b ρ) ^ d = (b : ℂ) ^ ((c : ℂ) * ρ) * ((b : ℂ) ^ ρ - 1) ^ d |
| [`EulerFactorChain.diagonal_gain`](./lean/EulerFactorChain.md#EulerFactorChain-diagonal_gain) | theorem | shape | `EulerFactorChain` | (b : ℂ) ^ ρ * sym b ρ = (b : ℂ) ^ ρ - 1 |
| [`EulerFactorChain.diagonal_over_column`](./lean/EulerFactorChain.md#EulerFactorChain-diagonal_over_column) | theorem | shape | `EulerFactorChain` | ((b : ℂ) ^ ρ - 1) / sym b ρ = (b : ℂ) ^ ρ |
| [`EulerFactorChain.diagonal_over_column_at_half`](./lean/EulerFactorChain.md#EulerFactorChain-diagonal_over_column_at_half) | theorem | shape | `EulerFactorChain` | (b : ℂ) ^ ((1 : ℂ) / 2) = (Real.sqrt b : ℂ) |
| [`ZeroSquares.differentiable_M`](./lean_stage3/ZeroSquares.md#ZeroSquares-differentiable_M) | theorem | shape | `ZeroSquares` | Differentiable ℂ (MollifiedMean.M X) |
| [`Stage3.differentiable_xi`](./lean_stage3/ArgIdentity.md#Stage3-differentiable_xi) | theorem | reads ζ | `ArgIdentity` | Differentiable ℂ xi |
| [`Stage3.differentiableAt_gammaR`](./lean_stage3/ArgIdentity.md#Stage3-differentiableAt_gammaR) | theorem | shape | `ArgIdentity` | DifferentiableAt ℂ Gammaℝ s |
| [`LandauPoleLocal.differentiableAt_Phi`](./lean_stage3/LandauPoleLocal.md#LandauPoleLocal-differentiableAt_Phi) | theorem | reads ζ | `LandauPoleLocal` | DifferentiableAt ℂ LandauMellinG.Phi s |
| [`ZeroSquares.differentiableOn_f`](./lean_stage3/ZeroSquares.md#ZeroSquares-differentiableOn_f) | theorem | reads ζ | `ZeroSquares` | DifferentiableOn ℂ (MollifiedMean.f X) ({(1:ℂ)}ᶜ : Set ℂ) |
| [`LeftSmooth.digamma_piece`](./lean_stage3/LeftSmooth.md#LeftSmooth-digamma_piece) | theorem | shape | `LeftSmooth` | ‖∫ t in (-T)..T, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) * ((-Complex.digamma (wL t) - (Real.eulerMascheroniConstant:ℂ)) * (sL t)⁻¹)‖ ≤ (∑' n : ℕ, dgTerm n) * ((2 + Real.pi) / Real.log y) |
| [`Stage3.digamma_term_norm_le`](./lean_stage3/Stirling.md#Stage3-digamma_term_norm_le) | theorem | reads ζ | `Stirling` | ‖1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + z)‖ ≤ 4 / ((n : ℝ) + 1) ^ 2 |
| [`DirichletMean.dirichlet_mean_value`](./lean_stage3/DirichletMean.md#DirichletMean-dirichlet_mean_value) | theorem | shape | `DirichletMean` | ∫ t in (0:ℝ)..T, ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ)))‖ ^ 2 ≤ (T + 8 * N * (1 + Real.log N)) * ∑ n ∈ Finset.Icc 1 N, ‖a n‖ ^ 2 |
| [`DirichletMean.dirichlet_mean_value_sigma`](./lean_stage3/DirichletMean.md#DirichletMean-dirichlet_mean_value_sigma) | theorem | shape | `DirichletMean` | ∫ t in (0:ℝ)..T, ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-((σ : ℂ) + Complex.I * (t : ℂ)))‖ ^ 2 ≤ (T + 8 * N * (1 + Real.log N)) * ∑ n ∈ Finset.Icc 1 N, ‖a n‖ ^ 2 * (n : ℝ) ^ (-2 * σ) |
| [`DirichletMeanW.dirichlet_mean_value_weighted`](./lean_stage3/DirichletMeanW.md#DirichletMeanW-dirichlet_mean_value_weighted) | theorem | shape | `DirichletMeanW` | ∫ t in T₁..T₂, ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ)))‖ ^ 2 ≤ ∑ n ∈ Finset.Icc 1 N, ‖a n‖ ^ 2 * ((T₂ - T₁) + 6 * n * (1 + Real.log N)) |
| [`DirichletMeanW.dirichlet_mean_value_weighted_sigma`](./lean_stage3/DirichletMeanW.md#DirichletMeanW-dirichlet_mean_value_weighted_sigma) | theorem | shape | `DirichletMeanW` | ∫ t in T₁..T₂, ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-((σ : ℂ) + Complex.I * (t : ℂ)))‖ ^ 2 ≤ ∑ n ∈ Finset.Icc 1 N, ‖a n‖ ^ 2 * (n : ℝ) ^ (-2 * σ) * ((T₂ - T₁) + 6 * n * (1 + Real.log N)) |
| [`DirichletMean.dirichlet_mean_value_window`](./lean_stage3/DirichletMean.md#DirichletMean-dirichlet_mean_value_window) | theorem | shape | `DirichletMean` | ∫ t in T₁..T₂, ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ)))‖ ^ 2 ≤ (T₂ - T₁ + 8 * N * (1 + Real.log N)) * ∑ n ∈ Finset.Icc 1 N, ‖a n‖ ^ 2 |
| [`SquareMean.disc_sq_mean`](./lean_stage3/SquareMean.md#SquareMean-disc_sq_mean) | theorem | shape | `SquareMean` | π * δ ^ 2 * ‖f c‖ ^ 2 ≤ ∫ z, (ball c δ).indicator (fun z =&gt; ‖f z‖ ^ 2) z |
| [`WeilSeries.dist_ge`](./lean_stage3/WeilSeries.md#WeilSeries-dist_ge) | theorem | shape | `WeilSeries` | 9 / 5 * \|(idx t : ℝ) - (idx γ : ℝ)\| - 9 / 5 ≤ \|t - γ\| |
| [`ContourShift.div_sub_eq_dslope`](./lean_stage3/ContourShift.md#ContourShift-div_sub_eq_dslope) | theorem | shape | `ContourShift` | f s / (s - p) = f p / (s - p) + dslope f p s |
| [`Glue.Dln`](./lean_stage3/GlueNum.md#Glue-Dln) | def | reads ζ | `GlueNum` | ℝ |
| [`RouteNum.Dln_le`](./lean_stage3/RouteNum.md#RouteNum-Dln_le) | theorem | reads ζ | `RouteNum` | Glue.Dln ≤ 89846200 |
| [`Glue.Dln_pos`](./lean_stage3/GlueNum.md#Glue-Dln_pos) | theorem | reads ζ | `GlueNum` | 0 &lt; Dln |
| [`Crossover.dominance_flips`](./lean/Crossover.md#Crossover-dominance_flips) | theorem | shape | `Crossover` | ratio A B x y i &lt; 1 ∧ 1 &lt; ratio A B x y j |
| [`PerronKernel.dslope_kernel_diff`](./lean_stage3/PerronKernel.md#PerronKernel-dslope_kernel_diff) | theorem | shape | `PerronKernel` | Differentiable ℂ (dslope (fun s : ℂ ↦ (y : ℂ) ^ s) 0) |
| [`Stage3.dyadic_abs_N_sum_le`](./lean_stage3/ZeroSum.md#Stage3-dyadic_abs_N_sum_le) | theorem | reads ζ | `ZeroSum` | (∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹ * \|riemannZeta.N ((2 : ℝ) ^ (j + 1))\|) ≤ Real.log 2 / (2 * Real.pi) * (K + 1) * (K + 2) + 3 * (K + 1) / Real.pi + 2 * (riemannZeta.RvM b₁ b₂ b₃ ((2 : ℝ) ^ (K + 1)… |
| [`JointLadder.dyadic_alias_resolved_jointly`](./lean/JointLadder.md#JointLadder-dyadic_alias_resolved_jointly) | theorem | shape | `JointLadder` | ∃ γ' : ℝ, γ' ≠ γ ∧ Nyquist.Aliases 2 γ γ' ∧ ¬ JointAliases γ γ' |
| [`FiniteOffLine.dyadic_count_le`](./lean_stage3/FiniteOffLine.md#FiniteOffLine-dyadic_count_le) | theorem | reads ζ | `FiniteOffLine` | ∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹ * (2 * \|riemannZeta.N ((2 : ℝ) ^ (j + 1))\| + weightedZeroHeightBucket) ≤ 3000 * ((K : ℝ) + 2) ^ 2 |
| [`ZeroSummable.dyadic_index`](./lean_stage3/ZeroSummable.md#ZeroSummable-dyadic_index) | theorem | shape | `ZeroSummable` | (2 : ℝ) ^ (Nat.log 2 ⌊x⌋₊) ≤ x ∧ x &lt; 2 ^ (Nat.log 2 ⌊x⌋₊ + 1) |
| [`Zeros.dyadicRow`](./lean/Zeros.md#Zeros-dyadicRow) | def | counting | `Zeros` | ℤ → ℤ |
| [`Isogeny.dyadicRow_eq_rowN`](./lean/Isogeny.md#Isogeny-dyadicRow_eq_rowN) | theorem | counting | `Isogeny` | Zeros.dyadicRow ((r : ℤ) + 1) = rowN Zeros.pi2 1 r |
| [`VonKoch.E`](./lean_stage3/VonKochScaffold.md#VonKoch-E) | def | reads ζ | `VonKochScaffold` | ℝ |
| [`VonKoch.E_integral_eq_mellin`](./lean_stage3/VonKochScaffold.md#VonKoch-E_integral_eq_mellin) | theorem | reads ζ | `VonKochScaffold` | ∫ x in Set.Ioi (1:ℝ), (E x : ℂ) * (x : ℂ) ^ (-s - 1) = mellin Etr (-s) |
| [`VonKoch.E_le_linear`](./lean_stage3/VonKochScaffold.md#VonKoch-E_le_linear) | theorem | reads ζ | `VonKochScaffold` | ‖(E t : ℝ)‖ ≤ (Real.log 4 + 5) * t |
| [`EdgeBound.edge_bound_core`](./lean_stage3/EdgeBound.md#EdgeBound-edge_bound_core) | theorem | reads ζ | `EdgeBound` | ∃ C : ℝ, 0 &lt; C ∧ ∀ t : ℝ, 2 ≤ t → ∀ u : ℂ, u.im = t → -1/4 ≤ u.re → u.re ≤ 2 → riemannZeta u ≠ 0 → ∀ δ : ℝ, 0 &lt; δ → δ ≤ 1 → (∀ w ∈ (gz_zeros_ball_finite t (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, δ ≤ … |
| [`EdgeBound.edge_bound_core_num`](./lean_stage3/EdgeNum.md#EdgeBound-edge_bound_core_num) | theorem | reads ζ | `EdgeNum` | ∀ t : ℝ, 2 ≤ t → ∀ u : ℂ, u.im = t → -1/4 ≤ u.re → u.re ≤ 2 → riemannZeta u ≠ 0 → ∀ δ : ℝ, 0 &lt; δ → δ ≤ 1 → (∀ w ∈ (gz_zeros_ball_finite t (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, δ ≤ ‖u - w‖) → ‖deriv… |
| [`Glue.edge_horizontal_bound`](./lean_stage3/Glue.md#Glue-edge_horizontal_bound) | theorem | reads ζ | `Glue` | ∃ C : ℝ, 0 &lt; C ∧ ∀ x T T' : ℝ, 16 ≤ x → 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 &lt; ρ.re → ContourShift.zeroGap T ≤ \|ρ.im - T'\|) → ∀ y : ℝ, \|y\| = T' → ‖HIntegral (Gf x) (-1/4) (1 … |
| [`Glue.edge_horizontal_bound_num`](./lean_stage3/GlueNum.md#Glue-edge_horizontal_bound_num) | theorem | reads ζ | `GlueNum` | ∀ x T T' : ℝ, 16 ≤ x → 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 &lt; ρ.re → ContourShift.zeroGap T ≤ \|ρ.im - T'\|) → ∀ y : ℝ, \|y\| = T' → ‖HIntegral (Gf x) (-1/4) (1 + 1/Real.log x) y… |
| [`ExplicitTwo.edge_horizontal_bound_two`](./lean_stage3/ExplicitTwo.md#ExplicitTwo-edge_horizontal_bound_two) | theorem | reads ζ | `ExplicitTwo` | ∀ x T T' : ℝ, 2 ≤ x → 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 &lt; ρ.re → ContourShift.zeroGap T ≤ \|ρ.im - T'\|) → ∀ y : ℝ, \|y\| = T' → ‖HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log … |
| [`ExplicitLeft.edge_left_any`](./lean_stage3/ExplicitLeft.md#ExplicitLeft-edge_left_any) | theorem | reads ζ | `ExplicitLeft` | ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖ ≤ Aleft * (Real.log T')^2 * x ^ (-(1:ℝ)/4) |
| [`Glue.edge_left_bound`](./lean_stage3/Glue.md#Glue-edge_left_bound) | theorem | reads ζ | `Glue` | ∃ C : ℝ, 0 &lt; C ∧ ∀ x T' : ℝ, 16 ≤ x → 2 ≤ T' → T' ≤ 2*x^2 → ‖VIntegral (Gf x) (-1/4) (-T') T'‖ ≤ C * Real.log x |
| [`Glue.edge_left_sharp`](./lean_stage3/GlueFloor.md#Glue-edge_left_sharp) | theorem | reads ζ | `GlueFloor` | ∃ D : ℝ, 0 &lt; D ∧ ∀ x T' : ℝ, 16 ≤ x → 2 ≤ T' → T' ≤ 2*x^2 → ‖VIntegral (Gf x) (-1/4) (-T') T'‖ ≤ 72 * D * ((Real.log x)^2 * x ^ (-(1:ℝ)/4)) |
| [`Glue.edge_left_sharp_num`](./lean_stage3/GlueNum.md#Glue-edge_left_sharp_num) | theorem | reads ζ | `GlueNum` | ∀ x T' : ℝ, 16 ≤ x → 2 ≤ T' → T' ≤ 2*x^2 → ‖VIntegral (Gf x) (-1/4) (-T') T'‖ ≤ 72 * Dln * ((Real.log x)^2 * x ^ (-(1:ℝ)/4)) |
| [`PiZeros.efRem`](./lean_stage3/PiZeros.md#PiZeros-efRem) | def | reads ζ | `PiZeros` | ℂ |
| [`Nonvanishing.Ehigh`](./lean/Nonvanishing.md#Nonvanishing-Ehigh) | def | shape | `Nonvanishing` | ℝ |
| [`RelativeGate.EhighRel`](./lean/RelativeGate.md#RelativeGate-EhighRel) | def | shape | `RelativeGate` | ℝ |
| [`TransferOp.eigenvalue_zero_iff_lattice`](./lean/TransferOp.md#TransferOp-eigenvalue_zero_iff_lattice) | theorem | shape | `TransferOp` | bdiffL (mode b ρ) = 0 ↔ ∃ k : ℤ, ρ = (k : ℂ) * (2 * Real.pi * I / Real.log b) |
| [`Stage3.elem_fold_eq_pi`](./lean_stage3/ArgIdentity.md#Stage3-elem_fold_eq_pi) | theorem | shape | `ArgIdentity` | (∫ t in (0:ℝ)..T, elemLD (2 + (t : ℂ) * Complex.I)).re - (∫ x in (1/2:ℝ)..2, elemLD ((x : ℂ) + T * Complex.I)).im = Real.pi |
| [`Stage3.elemLD`](./lean_stage3/ArgIdentity.md#Stage3-elemLD) | def | shape | `ArgIdentity` | ℂ |
| [`WeilPowerCompare.Elow`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-Elow) | def | shape | `WeilPowerCompare` | ℝ |
| [`ZetaGrowth.emA`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-emA) | def | shape | `ZetaGrowth` | ℝ |
| [`ZetaGrowth.emA_eq_poly`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-emA_eq_poly) | theorem | shape | `ZetaGrowth` | emA x = ((x - n) - (x - n)^2)/2 |
| [`ZetaGrowth.emA_le`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-emA_le) | theorem | shape | `ZetaGrowth` | emA x ≤ 1/8 |
| [`ZetaGrowth.emA_natCast`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-emA_natCast) | theorem | shape | `ZetaGrowth` | emA n = 0 |
| [`ZetaGrowth.emA_nonneg`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-emA_nonneg) | theorem | shape | `ZetaGrowth` | 0 ≤ emA x |
| [`ZetaEM.emBoundary`](./lean_stage3/ZetaEM.md#ZetaEM-emBoundary) | def | reads ζ | `ZetaEM` | ℂ |
| [`ZetaEM.emCoef`](./lean_stage3/ZetaEM.md#ZetaEM-emCoef) | def | shape | `ZetaEM` | ℂ |
| [`ZetaEM.emConst`](./lean_stage3/ZetaEM.md#ZetaEM-emConst) | def | reads ζ | `ZetaEM` | ℝ |
| [`MollifiedMean.emConst_nonneg`](./lean_stage3/MollifiedMean.md#MollifiedMean-emConst_nonneg) | theorem | reads ζ | `MollifiedMean` | 0 ≤ ZetaEM.emConst k |
| [`ZetaEM.emInt`](./lean_stage3/ZetaEM.md#ZetaEM-emInt) | def | reads ζ | `ZetaEM` | ℂ |
| [`ZetaEM.emInt_step`](./lean_stage3/ZetaEM.md#ZetaEM-emInt_step) | theorem | reads ζ | `ZetaEM` | ((k:ℂ) + 1) * emInt k N s = -((bernoulliFun (k+1) 0 : ℂ) * (N:ℂ) ^ (-(s + k))) + (s + k) * emInt (k+1) N s |
| [`SeedPerturbation.emptied_excess`](./lean/SeedPerturbation.md#SeedPerturbation-emptied_excess) | def | counting | `SeedPerturbation` | ℤ → ℤ |
| [`SeedPerturbation.emptied_protected_cells_fixed`](./lean/SeedPerturbation.md#SeedPerturbation-emptied_protected_cells_fixed) | theorem | counting | `SeedPerturbation` | tableFrom (fun x =&gt; N x - emptied_excess x) 4 1 = tableFrom N 4 1 ∧ tableFrom (fun x =&gt; N x - emptied_excess x) 8 3 = tableFrom N 8 3 ∧ tableFrom (fun x =&gt; N x - emptied_excess x) 20 6 = tableFrom N 2… |
| [`SeedPerturbation.emptied_vanishes_above_two`](./lean/SeedPerturbation.md#SeedPerturbation-emptied_vanishes_above_two) | theorem | counting | `SeedPerturbation` | ∀ s : ℤ, 2 &lt; s → emptied_excess s = 0 |
| [`ZetaEM.emRem`](./lean_stage3/ZetaEM.md#ZetaEM-emRem) | def | reads ζ | `ZetaEM` | ℂ |
| [`ZetaEM.emRem_step`](./lean_stage3/ZetaEM.md#ZetaEM-emRem_step) | theorem | reads ζ | `ZetaEM` | emRem k N s = emTerm k N s + emRem (k+1) N s |
| [`ZetaEM.emTerm`](./lean_stage3/ZetaEM.md#ZetaEM-emTerm) | def | reads ζ | `ZetaEM` | ℂ |
| [`RHPull.eps_choice_ok`](./lean_stage3/LineBound.md#RHPull-eps_choice_ok) | theorem | shape | `LineBound` | c * (Real.sqrt X)⁻¹ * X * Real.log X ≤ c * Real.sqrt X * (Real.log X) ^ 3 |
| [`Construction.eq_of_same_row`](./lean/Construction.md#Construction-eq_of_same_row) | theorem | counting | `Construction` | ∀ r d, f r d = g r d |
| [`FiniteOffLine.err_le`](./lean_stage3/FiniteOffLine.md#FiniteOffLine-err_le) | theorem | reads ζ | `FiniteOffLine` | ∑ j ∈ range (d + 1), (d.choose j : ℝ) * (Glue.c1n * (2:ℝ) ^ ((r : ℤ) - (j : ℤ)) * Real.log ((2:ℝ) ^ ((r : ℤ) - (j : ℤ)) * (2:ℝ) ^ (K + 1)) ^ 2 / (2:ℝ) ^ (K + 1) + Glue.c3n * Real.log ((2:ℝ) ^ ((r : ℤ)… |
| [`Nonvanishing.error_bound`](./lean/Nonvanishing.md#Nonvanishing-error_bound) | theorem | shape | `Nonvanishing` | \|stencilR n (fun x =&gt; f x - L x) r\| ≤ Ehigh r n |
| [`VonKoch.Etr`](./lean_stage3/VonKochScaffold.md#VonKoch-Etr) | def | reads ζ | `VonKochScaffold` | ℝ → ℂ |
| [`VonKoch.Etr_locallyIntegrable`](./lean_stage3/VonKochScaffold.md#VonKoch-Etr_locallyIntegrable) | theorem | reads ζ | `VonKochScaffold` | MeasureTheory.LocallyIntegrableOn Etr (Set.Ioi 0) |
| [`VonKoch.Etr_measurable`](./lean_stage3/VonKochScaffold.md#VonKoch-Etr_measurable) | theorem | reads ζ | `VonKochScaffold` | Measurable Etr |
| [`EulerFactorChain.euler_product_riemannZeta`](./lean/EulerFactorChain.md#EulerFactorChain-euler_product_riemannZeta) | theorem | reads ζ | `EulerFactorChain` | ∏' p : Nat.Primes, (1 - (p : ℂ) ^ (-s))⁻¹ = riemannZeta s |
| [`EulerFactorChain.euler_product_sym`](./lean/EulerFactorChain.md#EulerFactorChain-euler_product_sym) | theorem | reads ζ | `EulerFactorChain` | ∏' p : Nat.Primes, (sym ((p : ℕ) : ℝ) s)⁻¹ = riemannZeta s |
| [`WeilPowerGauss.euler_sinh`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-euler_sinh) | theorem | shape | `WeilPowerGauss` | Tendsto (fun n : ℕ =&gt; w * ∏ j ∈ Finset.range n, g w j) atTop (𝓝 (Complex.sinh w)) |
| [`WeilPowerCompare.Eup`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-Eup) | def | shape | `WeilPowerCompare` | ℝ |
| [`LandauRates.exists_centre`](./lean_stage3/LandauRates.md#LandauRates-exists_centre) | theorem | shape | `LandauRates` | ∃ σ₀ : ℝ, 1 &lt; σ₀ ∧ ‖(σ₀ : ℂ) - ρ₀‖ &lt; σ₀ - θ ∧ ‖(σ₀ : ℂ) - ρ₀‖ ≤ (σ₀ - 1) * (1 + δ ^ 2 / 240) |
| [`WeilPowerClean.exists_clean_shell`](./lean_stage3/WeilPowerClean.md#WeilPowerClean-exists_clean_shell) | theorem | shape | `WeilPowerClean` | ∃ k, k &lt; K ∧ ∀ j ∈ S, k ∉ B j |
| [`WeilPowerClean.exists_clean_shell_of_count`](./lean_stage3/WeilPowerClean.md#WeilPowerClean-exists_clean_shell_of_count) | theorem | shape | `WeilPowerClean` | ∃ k, k &lt; K ∧ ∀ j ∈ S, k ∉ B j |
| [`WeilPowerCount.exists_clean_shell_of_leaf`](./lean_stage3/WeilPowerCount.md#WeilPowerCount-exists_clean_shell_of_leaf) | theorem | shape | `WeilPowerCount` | ∃ k, k &lt; K ∧ ∀ j ∈ S, k ∉ B j |
| [`LandauPoleSub.exists_differentiableOn_sub_poles`](./lean_stage3/LandauPoleSub.md#LandauPoleSub-exists_differentiableOn_sub_poles) | theorem | shape | `LandauPoleSub` | ∃ g : ℂ → ℂ, DifferentiableOn ℂ g U ∧ ∀ s, s ∉ P → g s = f s - ∑ q ∈ P, A q / (s - q) |
| [`JointLadder.exists_dyadic_alias_ne`](./lean/JointLadder.md#JointLadder-exists_dyadic_alias_ne) | theorem | shape | `JointLadder` | ∃ γ' : ℝ, γ' ≠ γ ∧ Nyquist.Aliases 2 γ γ' |
| [`LandauZeroSide.exists_gap`](./lean_stage3/LandauZeroSide.md#LandauZeroSide-exists_gap) | theorem | shape | `LandauZeroSide` | ∃ R₂ : ℝ, r &lt; R₂ ∧ R₂ ≤ R₃ ∧ ∀ ρ ∈ F, ‖c - ρ‖ &lt; R₂ → ‖c - ρ‖ ≤ r |
| [`ArgCount.exists_good_below`](./lean_stage3/ArgCount.md#ArgCount-exists_good_below) | theorem | reads ζ | `ArgCount` | ∃ T : ℝ, a &lt; T ∧ T &lt; T₀ ∧ good T ∧ ∀ ρ : ℂ, riemannZeta ρ = 0 → ρ.im ∈ Set.Ico T T₀ → False |
| [`LandauTrig.exists_large_in_block`](./lean_stage3/LandauTrig.md#LandauTrig-exists_large_in_block) | theorem | shape | `LandauTrig` | ∃ τ : ℝ, 0 &lt; τ ∧ ∃ N₀ : ℕ, ∀ a N : ℕ, N₀ ≤ N → ∃ n ∈ Finset.Ico a (a + N), τ ≤ T n |
| [`Covering.exists_near_lattice`](./lean/Covering.md#Covering-exists_near_lattice) | theorem | shape | `Covering` | ∃ n : ℤ, \|u - n * L\| ≤ L / 2 |
| [`LandauRates.exists_pow_small`](./lean_stage3/LandauRates.md#LandauRates-exists_pow_small) | theorem | shape | `LandauRates` | ∃ K : ℕ, ∀ k : ℕ, K ≤ k → c * q ^ k &lt; ε |
| [`WeilPowerCount.exists_range_log`](./lean_stage3/WeilPowerCount.md#WeilPowerCount-exists_range_log) | theorem | shape | `WeilPowerCount` | ∃ L : ℝ, 0 ≤ L ∧ ∀ M : ℝ, 0 ≤ M → M ≤ D + L → (c₁ * M + c₂) * ((W : ℝ) + 1) * lρ + E ≤ L |
| [`WeilPowerSelect.exists_step_le`](./lean_stage3/WeilPowerSelect.md#WeilPowerSelect-exists_step_le) | theorem | shape | `WeilPowerSelect` | ∃ k &lt; N, f (k + 1) ≤ f k + δ |
| [`WeilPowerSelect.exists_target_step`](./lean_stage3/WeilPowerSelect.md#WeilPowerSelect-exists_target_step) | theorem | shape | `WeilPowerSelect` | ∃ k : ℕ, (k : ℝ) ≤ h / (4 * K' * Real.pi ^ 2 * lam) ∧ (E (k + 1)) ^ 2 ≤ (E k) ^ 2 + δSel K' lam h |
| [`WeilPowerClean.exists_unblocked`](./lean_stage3/WeilPowerClean.md#WeilPowerClean-exists_unblocked) | theorem | counting | `WeilPowerClean` | ∃ k, k &lt; K ∧ ∀ j ∈ S, k ∉ B j |
| [`WeilPowerShell.exp_end_le`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-exp_end_le) | theorem | shape | `WeilPowerShell` | Real.exp ((zOf e' D e).re * (1 / ((lam : ℝ) * Real.pi ^ 2) * (k : ℝ) + -1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2))) ≤ Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) |
| [`Expansion.exp_eq_rpow`](./lean/Expansion.md#Expansion-exp_eq_rpow) | theorem | shape | `Expansion` | Real.exp (Real.log 2 * x) = (2 : ℝ) ^ x |
| [`WeilPowerGauss.exp_le_one_add`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-exp_le_one_add) | theorem | shape | `WeilPowerGauss` | Real.exp (x - x ^ 2) ≤ 1 + x |
| [`WeilPowerGeom.exp_lin_le_Mab`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-exp_lin_le_Mab) | theorem | shape | `WeilPowerGeom` | Real.exp (z.re * ((m : ℝ) + 1 / 2) / Real.pi ^ 2) ≤ Mab z a b |
| [`WeilPowerGeomGen.exp_lin_le_MabGen`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-exp_lin_le_MabGen) | theorem | shape | `WeilPowerGeomGen` | Real.exp (z.re * (α * (h : ℝ) + β₀)) ≤ MabGen z α β₀ a b |
| [`WeilPowerGeom.exp_shift`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-exp_shift) | theorem | shape | `WeilPowerGeom` | Complex.exp (z * ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2) = Complex.exp (z / (2 * (Real.pi : ℂ) ^ 2)) * Complex.exp (z / (Real.pi : ℂ) ^ 2) ^ m |
| [`WeilPowerGeomGen.exp_shift_gen`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-exp_shift_gen) | theorem | shape | `WeilPowerGeomGen` | Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ)) = Complex.exp (z * ((β₀ : ℝ) : ℂ)) * Complex.exp (z * ((α : ℝ) : ℂ)) ^ h |
| [`LeftSmooth.explicit_formula_all`](./lean_stage3/LeftSmooth.md#LeftSmooth-explicit_formula_all) | theorem | reads ζ | `LeftSmooth` | ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖ ≤ Glue.c1n * x * Real.log (x*T)^2 / T + Glue.c3n * Real.log x + Bleft * x ^ (-(1:ℝ)/4) |
| [`ExplicitTwo.explicit_formula_all_two`](./lean_stage3/ExplicitTwo.md#ExplicitTwo-explicit_formula_all_two) | theorem | reads ζ | `ExplicitTwo` | ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖ ≤ c1t * x * Real.log (x*T)^2 / T + c3t * Real.log x + Bleft2 * x ^ (-(1:ℝ)/4) |
| [`ExplicitLeft.explicit_formula_any`](./lean_stage3/ExplicitLeft.md#ExplicitLeft-explicit_formula_any) | theorem | reads ζ | `ExplicitLeft` | ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖ ≤ Glue.c1n * x * Real.log (x*T)^2 / T + Glue.c3n * Real.log x + Aleft * (Real.log (T+1))^2 * x ^ (-(1:ℝ)/4) |
| [`ExplicitLeft.explicit_formula_left`](./lean_stage3/ExplicitLeft.md#ExplicitLeft-explicit_formula_left) | theorem | reads ζ | `ExplicitLeft` | ∃ T' : ℝ, T ≤ T' ∧ T' ≤ T + 1 ∧ ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖ ≤ Glue.c1n * x * Real.log (x*T)^2 / T + Glue.c3n * Real.log x + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖ |
| [`ExplicitTwo.explicit_formula_left_two`](./lean_stage3/ExplicitTwo.md#ExplicitTwo-explicit_formula_left_two) | theorem | reads ζ | `ExplicitTwo` | ∃ T' : ℝ, T ≤ T' ∧ T' ≤ T + 1 ∧ ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖ ≤ c1t * x * Real.log (x*T)^2 / T + c3t * Real.log x + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖ |
| [`PerronKernel.explicit_formula_perron`](./lean_stage3/PerronKernel.md#PerronKernel-explicit_formula_perron) | theorem | reads ζ | `PerronKernel` | ‖(Chebyshev.psi x : ℂ) - (2 * (Real.pi:ℂ) * Complex.I)⁻¹ * ∫ t in (-T)..T, (- deriv riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t) / riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t))… |
| [`PerronTwo.explicit_formula_perron_two`](./lean_stage3/PerronTwo.md#PerronTwo-explicit_formula_perron_two) | theorem | reads ζ | `PerronTwo` | ‖(Chebyshev.psi x : ℂ) - (2 * (Real.pi:ℂ) * Complex.I)⁻¹ * ∫ t in (-T)..T, (- deriv riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t) / riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t))… |
| [`Glue.explicit_formula_poly`](./lean_stage3/Glue.md#Glue-explicit_formula_poly) | theorem | reads ζ | `Glue` | ∃ c₁ c₂ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₂ ∧ ∀ x T : ℝ, 16 ≤ x → 2 ≤ T → T ≤ x^2 → ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖ ≤ c₁ * x * Real.log (x*T)^2 / T + c₂ * Real.log x |
| [`Glue.explicit_formula_split`](./lean_stage3/GlueFloor.md#Glue-explicit_formula_split) | theorem | reads ζ | `GlueFloor` | ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ ∀ x T : ℝ, 16 ≤ x → 2 ≤ T → T ≤ x^2 → ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖ ≤ c₁ * x * Real.log (x*T)^2 / T + c₃ * Real.log x + c₄ * ((… |
| [`Glue.explicit_formula_split_num`](./lean_stage3/GlueNum.md#Glue-explicit_formula_split_num) | theorem | reads ζ | `GlueNum` | ∀ x T : ℝ, 16 ≤ x → 2 ≤ T → T ≤ x^2 → ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖ ≤ c1n * x * Real.log (x*T)^2 / T + c3n * Real.log x + c4n * ((Real.log x)^2 * x ^ (-(1:ℝ)/4)) |
| [`PairIdentity.exponent_const_on_diagonal`](./lean/PairIdentity.md#PairIdentity-exponent_const_on_diagonal) | theorem | counting | `PairIdentity` | e₁ = e₂ |
| [`WeilPowerCompare.exponent_eq`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-exponent_eq) | theorem | shape | `WeilPowerCompare` | Eup m (wOf ε' Δ h) - Elow m (ε * h) = rate m ε' Δ ε * h ^ 2 + qerr m ε' Δ ε * h ^ 4 |
| [`Expansion.F`](./lean/Expansion.md#Expansion-F) | def | shape | `Expansion` | ℝ |
| [`Interpolant.F`](./lean/Interpolant.md#Interpolant-F) | def | shape | `Interpolant` | ℝ |
| [`MollifiedMean.f`](./lean_stage3/MollifiedMean.md#MollifiedMean-f) | def | reads ζ | `MollifiedMean` | ℂ |
| [`ReZetaCount.F`](./lean_stage3/ReZetaCount.md#ReZetaCount-F) | def | reads ζ | `ReZetaCount` | ℂ |
| [`VonKoch.F`](./lean_stage3/VonKochScaffold.md#VonKoch-F) | def | reads ζ | `VonKochScaffold` | ℂ |
| [`WeilPower.f1`](./lean_stage3/WeilPower.md#WeilPower-f1) | def | shape | `WeilPower` | ℝ |
| [`WeilPower.f1_neg_one`](./lean_stage3/WeilPower.md#WeilPower-f1_neg_one) | theorem | shape | `WeilPower` | f1 (k + 1) (-1) = 0 |
| [`WeilPower.f1_one`](./lean_stage3/WeilPower.md#WeilPower-f1_one) | theorem | shape | `WeilPower` | f1 (k + 1) 1 = 0 |
| [`WeilPower.f2`](./lean_stage3/WeilPower.md#WeilPower-f2) | def | shape | `WeilPower` | ℝ |
| [`Expansion.f2x`](./lean/Expansion.md#Expansion-f2x) | def | shape | `Expansion` | ℝ |
| [`Interpolant.f2x_contDiffOn`](./lean/Interpolant.md#Interpolant-f2x_contDiffOn) | theorem | shape | `Interpolant` | ContDiffOn ℝ (⊤ : ℕ∞) Expansion.f2x (Ioi 0) |
| [`Interpolant.f2x_continuousOn`](./lean/Interpolant.md#Interpolant-f2x_continuousOn) | theorem | shape | `Interpolant` | ContinuousOn Expansion.f2x (Ioi 0) |
| [`ReZetaCount.F_analytic`](./lean_stage3/ReZetaCount.md#ReZetaCount-F_analytic) | theorem | reads ζ | `ReZetaCount` | AnalyticOnNhd ℂ (F T) (Metric.closedBall (0 : ℂ) 1) |
| [`VonKoch.F_analyticOnNhd`](./lean_stage3/VonKochScaffold.md#VonKoch-F_analyticOnNhd) | theorem | reads ζ | `VonKochScaffold` | AnalyticOnNhd ℂ F region |
| [`Stage3.F_analyticOnNhd_theta`](./lean_stage3/ThetaConverse.md#Stage3-F_analyticOnNhd_theta) | theorem | reads ζ | `ThetaConverse` | AnalyticOnNhd ℂ VonKoch.F (regionθ θ) |
| [`ZeroSquares.f_at_zero`](./lean_stage3/ZeroSquares.md#ZeroSquares-f_at_zero) | theorem | reads ζ | `ZeroSquares` | MollifiedMean.f X ρ = -1 |
| [`ReZetaCount.F_bound`](./lean_stage3/ReZetaCount.md#ReZetaCount-F_bound) | theorem | reads ζ | `ReZetaCount` | ‖F T z‖ ≤ 80 * T |
| [`Interpolant.F_contDiffOn`](./lean/Interpolant.md#Interpolant-F_contDiffOn) | theorem | shape | `Interpolant` | ContDiffOn ℝ (⊤ : ℕ∞) F (Ioi 0) |
| [`ReZetaCount.F_count_le`](./lean_stage3/ReZetaCount.md#ReZetaCount-F_count_le) | theorem | reads ζ | `ReZetaCount` | ∑ ρ ∈ (finiteSetOfZeros_mono (by norm_num : (7:ℝ)/8 &lt; 1) (F_zeros_finite hT)).toFinset, (analyticOrderNatAt (F T) ρ : ℝ) ≤ 15 * Real.log T + 73 |
| [`VonKoch.F_differentiableAt`](./lean_stage3/VonKochScaffold.md#VonKoch-F_differentiableAt) | theorem | reads ζ | `VonKochScaffold` | DifferentiableAt ℂ F s |
| [`Stage3.F_differentiableAt_theta`](./lean_stage3/ThetaConverse.md#Stage3-F_differentiableAt_theta) | theorem | reads ζ | `ThetaConverse` | DifferentiableAt ℂ VonKoch.F s |
| [`MollifiedMean.f_eq`](./lean_stage3/MollifiedMean.md#MollifiedMean-f_eq) | theorem | reads ζ | `MollifiedMean` | f X s = ∑ n ∈ Icc 1 (N * X), (b X N n : ℂ) * (n : ℂ) ^ (-s) + (-((N : ℂ) ^ (1 - s) / (1 - s))) * M X s + (riemannZeta s - ∑ n ∈ Icc 1 N, (n : ℂ) ^ (-s) + (N : ℂ) ^ (1 - s) / (1 - s)) * M X s |
| [`VonKoch.F_eq_neg_logDeriv`](./lean_stage3/VonKochScaffold.md#VonKoch-F_eq_neg_logDeriv) | theorem | reads ζ | `VonKochScaffold` | F s = -deriv riemannZeta s / riemannZeta s |
| [`VonKoch.F_eq_neg_logDeriv_ext`](./lean_stage3/VonKochScaffold.md#VonKoch-F_eq_neg_logDeriv_ext) | theorem | reads ζ | `VonKochScaffold` | F s = -deriv riemannZeta s / riemannZeta s |
| [`Expansion.F_floor`](./lean/Expansion.md#Expansion-F_floor) | theorem | shape | `Expansion` | (2 : ℝ) ^ x * (Real.log 2 ^ d / (2 * x)) ≤ F d x |
| [`Interpolant.F_hasDerivAt`](./lean/Interpolant.md#Interpolant-F_hasDerivAt) | theorem | shape | `Interpolant` | HasDerivAt F (Expansion.f2x x) x |
| [`VonKoch.F_mul_zeta_add_deriv_eqOn_zero`](./lean_stage3/VonKochScaffold.md#VonKoch-F_mul_zeta_add_deriv_eqOn_zero) | theorem | reads ζ | `VonKochScaffold` | Set.EqOn (fun s : ℂ ↦ F s * riemannZeta s + deriv riemannZeta s) 0 region |
| [`Stage3.F_mul_zeta_add_deriv_eqOn_zero_theta`](./lean_stage3/ThetaConverse.md#Stage3-F_mul_zeta_add_deriv_eqOn_zero_theta) | theorem | reads ζ | `ThetaConverse` | Set.EqOn (fun s : ℂ ↦ VonKoch.F s * ζ s + deriv ζ s) 0 (regionθ θ) |
| [`Expansion.F_zero`](./lean/Expansion.md#Expansion-F_zero) | theorem | shape | `Expansion` | F 0 x = f2x x |
| [`ReZetaCount.F_zero_eq_one`](./lean_stage3/ReZetaCount.md#ReZetaCount-F_zero_eq_one) | theorem | reads ζ | `ReZetaCount` | F T 0 = 1 |
| [`ReZetaCount.F_zeros_finite`](./lean_stage3/ReZetaCount.md#ReZetaCount-F_zeros_finite) | theorem | reads ζ | `ReZetaCount` | (SetOfZeros 1 (F T)).Finite |
| [`WeilPowerBounds.factor_eq`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-factor_eq) | theorem | shape | `WeilPowerBounds` | w ^ 2 + (a : ℂ) ^ 2 = (w - Complex.I * (a : ℂ)) * (w + Complex.I * (a : ℂ)) |
| [`WeilPowerBands.factorial_odd_le`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-factorial_odd_le) | theorem | shape | `WeilPowerBands` | (((2 * m + 1).factorial : ℕ) : ℝ) ≤ 2 * 4 ^ m * ((m : ℝ) + 1) ^ (2 * m + 1) |
| [`Zeros.factorization_proportional`](./lean/ZerosStencil.md#Zeros-factorization_proportional) | theorem | counting | `ZerosStencil` | n * b.factorization p = m * c.factorization p |
| [`WeilPowerAssembly.far_large_le`](./lean_stage3/WeilPowerAssembly.md#WeilPowerAssembly-far_large_le) | theorem | reads ζ | `WeilPowerAssembly` | \|∑ ρ ∈ fl_set, WeilPowerBands.termW h γ m ρ\| ≤ (15 * Real.log T + 698) * ((h/2)^2 * U_far^2) |
| [`WeilPowerAssembly.far_moderate_le`](./lean_stage3/WeilPowerAssembly.md#WeilPowerAssembly-far_moderate_le) | theorem | reads ζ | `WeilPowerAssembly` | \|∑ ρ ∈ fm_set, WeilPowerBands.termW h γ m ρ\| ≤ (15 * Real.log T + 73) * ((h/2)^2 * U_mem^2) |
| [`WeilPowerBridge.far_sideband_le`](./lean_stage3/WeilPowerBridge.md#WeilPowerBridge-far_sideband_le) | theorem | shape | `WeilPowerBridge` | ‖S m (wp h γ ρ)‖ ≤ cS m * Real.cosh ((ρ.re - 1 / 2) * h) * (2 / ((ρ.im + γ) * h) ^ 2) ^ (m + 1) |
| [`PerronKernel.far_terms_sum`](./lean_stage3/PerronKernel.md#PerronKernel-far_terms_sum) | theorem | shape | `PerronKernel` | (∑' n : ℕ, if 1/2 ≤ \|Real.log (x / n)\| then ArithmeticFunction.vonMangoldt n * (x / n) ^ (1 + 1/Real.log x) / (T * \|Real.log (x / n)\|) else 0) ≤ 300 * x * Real.log (x * T) ^ 2 / T |
| [`PerronTwo.far_terms_sum_two`](./lean_stage3/PerronTwo.md#PerronTwo-far_terms_sum_two) | theorem | shape | `PerronTwo` | (∑' n : ℕ, if 1/2 ≤ \|Real.log (x / n)\| then ArithmeticFunction.vonMangoldt n * (x / n) ^ (1 + 1/Real.log x) / (T * \|Real.log (x / n)\|) else 0) ≤ 300 * x * Real.log (x * T) ^ 2 / T |
| [`WeilPowerSelect.farDelta_le`](./lean_stage3/WeilPowerSelect.md#WeilPowerSelect-farDelta_le) | theorem | shape | `WeilPowerSelect` | ε' ^ 2 - Δ ^ 2 ≤ 0 |
| [`FilterAttained.filter_attained_false`](./lean_stage3/FilterAttained.md#FilterAttained-filter_attained_false) | theorem | reads ζ | `FilterAttained` | False |
| [`Elephant.filter_couples_iff_isPrimePow`](./lean/Elephant.md#Elephant-filter_couples_iff_isPrimePow) | theorem | shape | `Elephant` | vonMangoldt (b ^ k) ≠ 0 ↔ IsPrimePow b |
| [`FilterLadder.filter_mode`](./lean_stage3/FilterLadder.md#FilterLadder-filter_mode) | theorem | counting | `FilterLadder` | ∑ j ∈ range (N + 1), (q ^ m).coeff j * z ^ (n - j) = z ^ n * (q.eval z⁻¹) ^ m |
| [`Elephant.filter_ne_zero_at_zeta_zero`](./lean/Elephant.md#Elephant-filter_ne_zero_at_zeta_zero) | theorem | reads ζ | `Elephant` | (Sym b ρ) ^ d ≠ 0 |
| [`FilterLadder.filtered_modes_small`](./lean_stage3/FilterLadder.md#FilterLadder-filtered_modes_small) | theorem | reads ζ | `FilterLadder` | ∃ A : ℝ, ∀ (q : Polynomial ℂ) (n m : ℕ), 2 ≤ n → m * q.natDegree &lt; n → ‖∑ ρ ∈ (FiniteOffLine.ZF ((2:ℝ)^n)).filter (fun ρ : NontrivialZeros =&gt; σ ≤ (ρ : ℂ).re), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (… |
| [`FilterLadder.filtered_modes_small_sq`](./lean_stage3/FilterLadder.md#FilterLadder-filtered_modes_small_sq) | theorem | reads ζ | `FilterLadder` | ‖∑ ρ ∈ (FiniteOffLine.ZF ((2:ℝ)^n)).filter (fun ρ : NontrivialZeros =&gt; σ ≤ (ρ : ℂ).re), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * (q.eval (((2:ℂ) ^ (ρ : ℂ))⁻¹)) ^ m * ((2:ℂ) ^ (ρ : ℂ)) ^ n‖ ≤ … |
| [`AttainedPi.fin_bound`](./lean_stage3/AttainedPi.md#AttainedPi-fin_bound) | theorem | reads ζ | `AttainedPi` | ‖∑ ρ ∈ topRow Θ r, LadderMean.coef ρ * ((2:ℂ) ^ (ρ : ℂ)) ^ r‖ ≤ slack Θ θ₁ C M ε r + 2 * ε * ((2:ℝ) ^ Θ) ^ r |
| [`AttainedPi.fin_eventually`](./lean_stage3/AttainedPi.md#AttainedPi-fin_eventually) | theorem | reads ζ | `AttainedPi` | ∀ᶠ r : ℕ in atTop, ‖∑ ρ ∈ topRow Θ r, LadderMean.coef ρ * ((2:ℂ) ^ (ρ : ℂ)) ^ r‖ ≤ ε * ((2:ℝ) ^ Θ) ^ r |
| [`Slice3.finalBoundConst_le`](./lean_stage3/LineBound.md#Slice3-finalBoundConst_le) | theorem | shape | `LineBound` | 16 * ((181:ℝ)/200) ^ 2 / ((181/200) - (3/4)) ^ 3 + 1 / (((15/16:ℝ) ^ 2 / (29/32) - 29/32) * Real.log ((15/16)/(29/32))) ≤ 3991 |
| [`Slice4.finalBoundConst_le`](./lean_stage3/LineBound.md#Slice4-finalBoundConst_le) | theorem | shape | `LineBound` | 16 * ((181:ℝ)/200) ^ 2 / ((181/200) - (3/4)) ^ 3 + 1 / (((15/16:ℝ) ^ 2 / (29/32) - 29/32) * Real.log ((15/16)/(29/32))) ≤ 3991 |
| [`FiniteOffLine.finite_off_line`](./lean_stage3/FiniteOffLine.md#FiniteOffLine-finite_off_line) | theorem | reads ζ | `FiniteOffLine` | RiemannHypothesis |
| [`FiniteOffLinePi.finite_off_line_pi`](./lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-finite_off_line_pi) | theorem | reads ζ | `FiniteOffLinePi` | RiemannHypothesis |
| [`FilterAttained.finite_part_le`](./lean_stage3/FilterAttained.md#FilterAttained-finite_part_le) | theorem | reads ζ | `FilterAttained` | ‖∑ ρ ∈ (ZF ((2:ℝ) ^ (b * k))).filter (fun ρ : NontrivialZeros =&gt; σ ≤ (ρ : ℂ).re), LadderMean.coef ρ * ratio q a b M ρ ^ k‖ ≤ FilterLadder.Afl C * (b:ℝ) ^ 2 * (k:ℝ) ^ 2 * ((2:ℝ) ^ (σ * b) * FilterLadde… |
| [`Stage3.floor_arith`](./lean_stage3/AssemblyFloor.md#Stage3-floor_arith) | theorem | shape | `AssemblyFloor` | A ≤ (4 + P / L₀ + Q / L₀ ^ 2 + 18 * c₁ / (x₀ * S₀) + c₂ / (S₀ * L₀)) * S * L ^ 2 |
| [`GateEval.floor_bound`](./lean_stage3/GateEval.md#GateEval-floor_bound) | theorem | shape | `GateEval` | 3 * (4 + (16 + 16 * 112 + 16 * 0) / ℓ + (8 * 698 + 8 + 4 * 0) / ℓ ^ 2 + 18 * c1 / ((2:ℝ) ^ (36:ℕ) * (2:ℝ) ^ (18:ℕ)) + c3 / ((2:ℝ) ^ (18:ℕ) * ℓ) + c4 * (1 / (2:ℝ) ^ (9:ℕ)) / (2:ℝ) ^ (18:ℕ)) + 13 ≤ 414 |
| [`Stage3.floorConst`](./lean_stage3/AssemblyFloor.md#Stage3-floorConst) | def | shape | `AssemblyFloor` | ℝ |
| [`Stage3.floorConst_nonneg`](./lean_stage3/AssemblyFloor.md#Stage3-floorConst_nonneg) | theorem | shape | `AssemblyFloor` | 0 ≤ floorConst c₁ c₂ b₁ b₂ b₃ W x₀ |
| [`Stage3.floorConstSplit`](./lean_stage3/GlueFloor.md#Stage3-floorConstSplit) | def | shape | `GlueFloor` | ℝ |
| [`Stage3.floorConstSplit_nonneg`](./lean_stage3/GlueFloor.md#Stage3-floorConstSplit_nonneg) | theorem | shape | `GlueFloor` | 0 ≤ floorConstSplit c₁ c₃ c₄ b₁ b₂ b₃ W x₀ |
| [`Propagation.flux_form`](./lean/Propagation.md#Propagation-flux_form) | theorem | counting | `Propagation` | tableFrom N r (d + 1) + tableFrom N (r - 1) d = tableFrom N r d |
| [`FilterLadder.formula_row`](./lean_stage3/FilterLadder.md#FilterLadder-formula_row) | theorem | reads ζ | `FilterLadder` | ‖ladder k + ∑ ρ ∈ ZF ((2:ℝ) ^ n), wz ρ * ((2:ℂ) ^ (ρ : ℂ)) ^ k‖ ≤ Kf * (n:ℝ) ^ 2 |
| [`WeilPowerBands.four_h_add_nonneg`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-four_h_add_nonneg) | theorem | shape | `WeilPowerBands` | 0 ≤ 4 * h ^ 2 + cFarM m / h ^ 2 |
| [`WeilSeries.four_h_add_nonneg`](./lean_stage3/WeilSeries.md#WeilSeries-four_h_add_nonneg) | theorem | shape | `WeilSeries` | 0 ≤ 4 * h ^ 2 + cFar / h ^ 2 |
| [`Stage3.four_le_log_of_theta`](./lean_stage3/ThetaPull.md#Stage3-four_le_log_of_theta) | theorem | shape | `ThetaPull` | (4:ℝ) ≤ Real.log X |
| [`Zeros.four_zeros_only`](./lean/Zeros.md#Zeros-four_zeros_only) | theorem | counting | `Zeros` | measured_zeros.length = 4 |
| [`Bridge.ft`](./lean_bridge/WeilBridge.md#Bridge-ft) | def | shape | `WeilBridge` | ℂ |
| [`WeilBridgeLeaf.ft`](./lean_stage3/WeilBridgeLeaf.md#WeilBridgeLeaf-ft) | def | shape | `WeilBridgeLeaf` | ℂ |
| [`LandauWindow.G`](./lean_stage3/LandauWindow.md#LandauWindow-G) | def | shape | `LandauWindow` | ℝ |
| [`ReZetaCount.G`](./lean_stage3/ReZetaCount.md#ReZetaCount-G) | def | reads ζ | `ReZetaCount` | ℂ |
| [`WeilPowerGauss.g`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-g) | def | shape | `WeilPowerGauss` | ℂ |
| [`WeilTransform.G`](./lean_stage3/WeilTransform.md#WeilTransform-G) | def | shape | `WeilTransform` | ℝ |
| [`WeilPowerPhase.g_eq`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-g_eq) | theorem | shape | `WeilPowerPhase` | g w j = 1 + x w j |
| [`LandauMellinG.G_integrand_eq`](./lean_stage3/LandauMellinG.md#LandauMellinG-G_integrand_eq) | theorem | shape | `LandauMellinG` | (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1) = (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1) - (Real.log y : ℂ) * (y : ℂ) ^ (-s) + (1 + (Real.eulerMascheroniConstant : ℂ)) * (y : ℂ) ^ (-s) |
| [`LandauChebyshev.G_le`](./lean_stage3/LandauChebyshev.md#LandauChebyshev-G_le) | theorem | reads ζ | `LandauChebyshev` | LandauWindow.G y ≤ 8 * y |
| [`LandauMellinG.G_mellin_integrable`](./lean_stage3/LandauMellinG.md#LandauMellinG-G_mellin_integrable) | theorem | reads ζ | `LandauMellinG` | IntegrableOn (fun y : ℝ =&gt; (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1)) (Ioi 1) |
| [`WeilPowerPhase.g_ne_zero`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-g_ne_zero) | theorem | shape | `WeilPowerPhase` | g w j ≠ 0 |
| [`ReZetaCount.G_real`](./lean_stage3/ReZetaCount.md#ReZetaCount-G_real) | theorem | reads ζ | `ReZetaCount` | G T (x : ℂ) = ((2 * (riemannZeta (2 * (x : ℂ) + 2 + Complex.I * (T : ℂ))).re : ℝ) : ℂ) |
| [`ReZetaCount.G_zero_eq`](./lean_stage3/ReZetaCount.md#ReZetaCount-G_zero_eq) | theorem | reads ζ | `ReZetaCount` | G T 0 = ((2 * (riemannZeta (2 + Complex.I * (T : ℂ))).re : ℝ) : ℂ) |
| [`ReZetaCount.G_zero_ne`](./lean_stage3/ReZetaCount.md#ReZetaCount-G_zero_ne) | theorem | reads ζ | `ReZetaCount` | G T 0 ≠ 0 |
| [`NyquistPeak.gain`](./lean/NyquistPeak.md#NyquistPeak-gain) | def | shape | `NyquistPeak` | ℝ |
| [`NyquistPeak.gain_continuousAt_boundaryBase`](./lean/NyquistPeak.md#NyquistPeak-gain_continuousAt_boundaryBase) | theorem | shape | `NyquistPeak` | ContinuousAt (fun b : ℝ =&gt; gain d (γ * Real.log b)) (boundaryBase γ) |
| [`NyquistPeak.gain_eq_norm_sym_pow`](./lean/NyquistPeak.md#NyquistPeak-gain_eq_norm_sym_pow) | theorem | shape | `NyquistPeak` | gain d (γ * Real.log b) = ‖Chain.Sym b (γ * Complex.I)‖ ^ d |
| [`NyquistPeak.gain_hasDerivAt_pi`](./lean/NyquistPeak.md#NyquistPeak-gain_hasDerivAt_pi) | theorem | shape | `NyquistPeak` | HasDerivAt (gain d) 0 Real.pi |
| [`NyquistPeak.gain_le_at_boundaryBase`](./lean/NyquistPeak.md#NyquistPeak-gain_le_at_boundaryBase) | theorem | shape | `NyquistPeak` | gain d (γ * Real.log b) ≤ gain d (γ * Real.log (boundaryBase γ)) |
| [`NyquistPeak.gain_le_gain_pi`](./lean/NyquistPeak.md#NyquistPeak-gain_le_gain_pi) | theorem | shape | `NyquistPeak` | gain d θ ≤ gain d Real.pi |
| [`NyquistPeak.gain_lt_gain_pi`](./lean/NyquistPeak.md#NyquistPeak-gain_lt_gain_pi) | theorem | shape | `NyquistPeak` | gain d θ &lt; gain d Real.pi |
| [`NyquistPeak.gain_pi`](./lean/NyquistPeak.md#NyquistPeak-gain_pi) | theorem | shape | `NyquistPeak` | gain d Real.pi = 2 ^ d |
| [`Chain.gain_sq_at_ceiling`](./lean/Chain.md#Chain-gain_sq_at_ceiling) | theorem | shape | `Chain` | ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ 2 = (1 + b ^ (-(1:ℝ)/2)) ^ 2 |
| [`Chain.gain_sq_at_floor`](./lean/Chain.md#Chain-gain_sq_at_floor) | theorem | shape | `Chain` | ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ 2 = (1 - b ^ (-(1:ℝ)/2)) ^ 2 |
| [`EulerFactorChain.gain_sq_on_critical_line`](./lean/EulerFactorChain.md#EulerFactorChain-gain_sq_on_critical_line) | theorem | shape | `EulerFactorChain` | ‖1 - (b : ℂ) ^ (-((1 : ℂ)/2 + γ * I))‖ ^ 2 = 1 - 2 * b ^ (-(1:ℝ)/2) * Real.cos (γ * Real.log b) + b ^ (-(1:ℝ)) |
| [`Chain.gain_sq_periodic`](./lean/Chain.md#Chain-gain_sq_periodic) | theorem | shape | `Chain` | Function.Periodic (fun γ : ℝ =&gt; ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ 2) (2 * Real.pi / Real.log b) |
| [`NyquistPeak.gain_stationary_in_base`](./lean/NyquistPeak.md#NyquistPeak-gain_stationary_in_base) | theorem | shape | `NyquistPeak` | HasDerivAt (fun b : ℝ =&gt; gain d (γ * Real.log b)) 0 (boundaryBase γ) |
| [`NyquistPeak.gain_zero_phase`](./lean/NyquistPeak.md#NyquistPeak-gain_zero_phase) | theorem | shape | `NyquistPeak` | gain d 0 = 0 |
| [`Stage3.gammaR_conj`](./lean_stage3/ArgIdentity.md#Stage3-gammaR_conj) | theorem | shape | `ArgIdentity` | Gammaℝ (conj s) = conj (Gammaℝ s) |
| [`Stage3.gammaR_eq_exp_mul`](./lean_stage3/ArgIdentity.md#Stage3-gammaR_eq_exp_mul) | theorem | shape | `ArgIdentity` | Gammaℝ s = Complex.exp (-(Real.log Real.pi : ℂ) / 2 * s) * Complex.Gamma (s / 2) |
| [`Stage3.gammaR_fold_eq_phaseTheta`](./lean_stage3/ArgIdentity.md#Stage3-gammaR_fold_eq_phaseTheta) | theorem | reads ζ | `ArgIdentity` | (∫ t in (0:ℝ)..T, logDeriv Gammaℝ (2 + (t : ℂ) * Complex.I)).re - (∫ x in (1/2:ℝ)..2, logDeriv Gammaℝ ((x : ℂ) + T * Complex.I)).im = phaseTheta T |
| [`GateEval.gate_hyp_of_RH`](./lean_stage3/GateEval.md#GateEval-gate_hyp_of_RH) | theorem | reads ζ | `GateEval` | ∃ ρ : ℝ, JointDialGate.StmtRelErrWindow (fun m : ℤ =&gt; (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ)) (fun m : ℤ =&gt; 2 / Real.log 2 + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r (6 + 1) ρ ∧… |
| [`GateEval.gate_ineq`](./lean_stage3/GateEval.md#GateEval-gate_ineq) | theorem | shape | `GateEval` | 414 * (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-((r - 7) / 2)) &lt; Real.log 2 ^ 6 / (2 * r * 3 ^ 7) |
| [`TableDepths.gate_ineq_gen`](./lean_stage3/TableDepths.md#TableDepths-gate_ineq_gen) | theorem | shape | `TableDepths` | 414 * (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-((r - ((d:ℝ) + 1)) / 2)) &lt; Real.log 2 ^ d / (2 * r * 3 ^ (d + 1)) |
| [`Transform.generators_indep`](./lean/Transform.md#Transform-generators_indep) | theorem | shape | `Transform` | a = 0 ∧ c = 0 |
| [`Transform.gens`](./lean/Transform.md#Transform-gens) | def | shape | `Transform` | Fin 2 → ℂ |
| [`Transform.gens_linearIndependent`](./lean/Transform.md#Transform-gens_linearIndependent) | theorem | shape | `Transform` | LinearIndependent ℝ (gens b) |
| [`WeilPowerGeom.geom_Ico`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-geom_Ico) | theorem | shape | `WeilPowerGeom` | ∑ m ∈ Finset.Ico a b, x ^ m = (x ^ b - x ^ a) / (x - 1) |
| [`LadderMean.geom_mean_norm_le`](./lean_stage3/LadderMean.md#LadderMean-geom_mean_norm_le) | theorem | shape | `LadderMean` | ‖((N : ℝ)⁻¹ : ℝ) • ∑ r ∈ range N, ξ ^ r‖ ≤ 1 |
| [`LadderMean.geom_mean_tendsto_zero`](./lean_stage3/LadderMean.md#LadderMean-geom_mean_tendsto_zero) | theorem | shape | `LadderMean` | Tendsto (fun N : ℕ =&gt; ((N : ℝ)⁻¹ : ℝ) • ∑ r ∈ range N, ξ ^ r) atTop (𝓝 0) |
| [`WeilPowerGeom.geomBound`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-geomBound) | def | shape | `WeilPowerGeom` | ℝ |
| [`WeilPowerShell.geomBound_le`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-geomBound_le) | theorem | shape | `WeilPowerShell` | WeilPowerGeomGen.geomBoundGen (zOf e' D e) (1 / ((lam : ℝ) * Real.pi ^ 2)) (-1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) a b ≤ Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) * (lam : ℝ) * Real.pi… |
| [`WeilPowerGeomGen.geomBoundGen`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-geomBoundGen) | def | shape | `WeilPowerGeomGen` | ℝ |
| [`Glue.Gf`](./lean_stage3/Glue.md#Glue-Gf) | def | reads ζ | `Glue` | ℂ → ℂ |
| [`Glue.Gf_norm_conj`](./lean_stage3/Glue.md#Glue-Gf_norm_conj) | theorem | reads ζ | `Glue` | ‖Gf x ((starRingEnd ℂ) u)‖ = ‖Gf x u‖ |
| [`WeilTransform.ghat`](./lean_stage3/WeilTransform.md#WeilTransform-ghat) | def | shape | `WeilTransform` | ℂ |
| [`WeilTransform.ghat_eq`](./lean_stage3/WeilTransform.md#WeilTransform-ghat_eq) | theorem | shape | `WeilTransform` | ghat h γ z = ((h : ℂ) / 2) * (SigmaC ((z + Complex.I * (γ : ℂ)) * (h : ℂ)) + SigmaC ((z - Complex.I * (γ : ℂ)) * (h : ℂ))) |
| [`WeilOffLine.ghat_neg`](./lean_stage3/WeilOffLine.md#WeilOffLine-ghat_neg) | theorem | shape | `WeilOffLine` | ghat h γ (-z) = -ghat h γ z |
| [`WeilTransform.ghat_offline`](./lean_stage3/WeilTransform.md#WeilTransform-ghat_offline) | theorem | shape | `WeilTransform` | ghat h γ ((ε : ℂ) + Complex.I * (γ : ℂ)) = ((h : ℂ) / 2) * (SigmaC (((ε : ℂ) + 2 * Complex.I * (γ : ℂ)) * (h : ℂ)) + (WeilWindow.Sigma (ε * h) : ℂ)) |
| [`WeilTransform.ghat_ofReal_I`](./lean_stage3/WeilTransform.md#WeilTransform-ghat_ofReal_I) | theorem | shape | `WeilTransform` | ghat h γ (Complex.I * (t : ℂ)) = Complex.I * ((h : ℂ) / 2) * ((Psi (h * (t + γ)) : ℂ) + (Psi (h * (t - γ)) : ℂ)) |
| [`ArgCount.good`](./lean_stage3/ArgCount.md#ArgCount-good) | def | reads ζ | `ArgCount` | Prop |
| [`ContourShift.goodT_exists`](./lean_stage3/ContourShift.md#ContourShift-goodT_exists) | theorem | reads ζ | `ContourShift` | ∃ T' ∈ Set.Icc T (T+1), ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 &lt; ρ.re → zeroGap T ≤ \|ρ.im - T'\| |
| [`LeftSmooth.Gs`](./lean_stage3/LeftSmooth.md#LeftSmooth-Gs) | def | shape | `LeftSmooth` | ℂ |
| [`EdgeBound.gz`](./lean_stage3/EdgeBound.md#EdgeBound-gz) | def | reads ζ | `EdgeBound` | ℂ |
| [`EdgeBound.gz_analytic`](./lean_stage3/EdgeBound.md#EdgeBound-gz_analytic) | theorem | reads ζ | `EdgeBound` | AnalyticAt ℂ gz s |
| [`EdgeBound.gz_c0_lower`](./lean_stage3/LowCount.md#EdgeBound-gz_c0_lower) | theorem | reads ζ | `LowCount` | 1 / 14 ≤ ‖gz (c0 T')‖ |
| [`EdgeBound.gz_c0_ne`](./lean_stage3/EdgeBound.md#EdgeBound-gz_c0_ne) | theorem | reads ζ | `EdgeBound` | gz (c0 T') ≠ 0 |
| [`EdgeBound.gz_logderiv`](./lean_stage3/EdgeBound.md#EdgeBound-gz_logderiv) | theorem | reads ζ | `EdgeBound` | deriv gz u / gz u = 2/(u - 1) + deriv riemannZeta u / riemannZeta u |
| [`EdgeBound.gz_lower`](./lean_stage3/EdgeBound.md#EdgeBound-gz_lower) | theorem | reads ζ | `EdgeBound` | 4 * ‖riemannZeta 3 / riemannZeta (3/2)‖ ≤ ‖gz (c0 T')‖ |
| [`EdgeBound.gz_order_eq`](./lean_stage3/EdgeBound.md#EdgeBound-gz_order_eq) | theorem | reads ζ | `EdgeBound` | analyticOrderNatAt gz w = analyticOrderNatAt riemannZeta w |
| [`EdgeBound.gz_partial_fraction`](./lean_stage3/EdgeBound.md#EdgeBound-gz_partial_fraction) | theorem | reads ζ | `EdgeBound` | ∃ C : ℝ, 0 &lt; C ∧ ∀ T' : ℝ, 2 ≤ T' → ∀ u : ℂ, u.im = T' → -1/4 ≤ u.re → u.re ≤ 2 → gz u ≠ 0 → ‖deriv gz u / gz u - ∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, (analyticOrder… |
| [`EdgeBound.gz_partial_fraction_low`](./lean_stage3/LowEdge.md#EdgeBound-gz_partial_fraction_low) | theorem | reads ζ | `LowEdge` | ‖deriv gz u / gz u - ∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, (analyticOrderNatAt gz w : ℂ) / (u - w)‖ ≤ 1617537 |
| [`EdgeBound.gz_partial_fraction_num`](./lean_stage3/EdgeNum.md#EdgeBound-gz_partial_fraction_num) | theorem | reads ζ | `EdgeNum` | ∀ T' : ℝ, 2 ≤ T' → ∀ u : ℂ, u.im = T' → -1/4 ≤ u.re → u.re ≤ 2 → gz u ≠ 0 → ‖deriv gz u / gz u - ∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, (analyticOrderNatAt gz w : ℂ) /… |
| [`EdgeBound.gz_zero_cases`](./lean_stage3/EdgeBound.md#EdgeBound-gz_zero_cases) | theorem | reads ζ | `EdgeBound` | w = 1 ∨ riemannZeta w = 0 |
| [`EdgeBound.gz_zeros_ball_finite`](./lean_stage3/EdgeBound.md#EdgeBound-gz_zeros_ball_finite) | theorem | reads ζ | `EdgeBound` | {w : ℂ \| gz w = 0 ∧ ‖w - c0 T'‖ ≤ ρ}.Finite |
| [`Chain.h`](./lean/Chain.md#Chain-h) | def | shape | `Chain` | ℂ |
| [`EulerFactorChain.h`](./lean/EulerFactorChain.md#EulerFactorChain-h) | def | shape | `EulerFactorChain` | ℂ |
| [`EulerFactorChain.h_eq_gain_pow_on_critical_line`](./lean/EulerFactorChain.md#EulerFactorChain-h_eq_gain_pow_on_critical_line) | theorem | shape | `EulerFactorChain` | h b N ((1 : ℂ)/2 + t * I) = ((‖1 - (b : ℂ) ^ (-((1 : ℂ)/2 + t * I))‖ : ℝ) ^ (2 * N) : ℝ) |
| [`EulerFactorChain.h_functional_equation`](./lean/EulerFactorChain.md#EulerFactorChain-h_functional_equation) | theorem | shape | `EulerFactorChain` | h b N (1 - s) = h b N s |
| [`EulerFactorChain.h_one`](./lean/EulerFactorChain.md#EulerFactorChain-h_one) | theorem | shape | `EulerFactorChain` | h b N 1 = 0 |
| [`EulerFactorChain.h_zero`](./lean/EulerFactorChain.md#EulerFactorChain-h_zero) | theorem | shape | `EulerFactorChain` | h b N 0 = 0 |
| [`Stage3.half_le_norm_of_RH`](./lean_stage3/Assembly.md#Stage3-half_le_norm_of_RH) | theorem | reads ζ | `Assembly` | 1 / 2 ≤ ‖(ρ : ℂ)‖ |
| [`RHPull.half_lt_σRH`](./lean_stage3/LineBound.md#RHPull-half_lt_-RH) | theorem | shape | `LineBound` | (1:ℝ)/2 &lt; σRH X |
| [`Stage3.half_lt_σθ`](./lean_stage3/ThetaPull.md#Stage3-half_lt_--) | theorem | shape | `ThetaPull` | (1:ℝ)/2 &lt; σθ θ X |
| [`StencilWeil.handshake_iff`](./lean_stage3/StencilWeil.md#StencilWeil-handshake_iff) | theorem | shape | `StencilWeil` | ‖(b : ℂ) ^ ρ‖ = ‖(b : ℂ) ^ (1 - ρ)‖ ↔ ρ.re = 1 / 2 |
| [`WeilPowerGeom.harmonic_quarter`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-harmonic_quarter) | theorem | shape | `WeilPowerGeom` | ∑ m ∈ Finset.Ico a b, 1 / (Real.pi ^ 2 * (4 * (m : ℝ) + 6)) ≤ (Real.log b - Real.log a) / (4 * Real.pi ^ 2) |
| [`Bridge.hasCompactSupport_kOf`](./lean_bridge/WeilBridge.md#Bridge-hasCompactSupport_kOf) | theorem | shape | `WeilBridge` | HasCompactSupport (kOf G) |
| [`Bridge.hasCompactSupport_tiltF`](./lean_bridge/WeilBridge.md#Bridge-hasCompactSupport_tiltF) | theorem | shape | `WeilBridge` | HasCompactSupport (tiltF G) |
| [`WeilPower.hasDerivAt_c`](./lean_stage3/WeilPower.md#WeilPower-hasDerivAt_c) | theorem | shape | `WeilPower` | HasDerivAt c (-(Real.pi / 2) * Real.sin (Real.pi * x / 2)) x |
| [`WeilLobe.hasDerivAt_cos_pi`](./lean_stage3/WeilLobe.md#WeilLobe-hasDerivAt_cos_pi) | theorem | shape | `WeilLobe` | HasDerivAt (fun y : ℝ =&gt; Real.cos (Real.pi * y)) (-Real.sin (Real.pi * x) * Real.pi) x |
| [`WeilPower.hasDerivAt_E`](./lean_stage3/WeilPower.md#WeilPower-hasDerivAt_E) | theorem | shape | `WeilPower` | HasDerivAt (fun y : ℝ =&gt; Complex.exp (w * (y : ℂ))) (w * Complex.exp (w * (x : ℂ))) x |
| [`Expansion.hasDerivAt_F`](./lean/Expansion.md#Expansion-hasDerivAt_F) | theorem | shape | `Expansion` | HasDerivAt (F d) (F (d + 1) x) x |
| [`WeilPower.hasDerivAt_f`](./lean_stage3/WeilPower.md#WeilPower-hasDerivAt_f) | theorem | shape | `WeilPower` | HasDerivAt (fun y : ℝ =&gt; c y ^ (k + 1)) (f1 k x) x |
| [`WeilPower.hasDerivAt_f1`](./lean_stage3/WeilPower.md#WeilPower-hasDerivAt_f1) | theorem | shape | `WeilPower` | HasDerivAt (f1 (k + 1)) (f2 k x) x |
| [`Stage3.hasDerivAt_Li`](./lean_stage3/RowLeaves.md#Stage3-hasDerivAt_Li) | theorem | shape | `RowLeaves` | HasDerivAt Li (1 / Real.log y) y |
| [`Stage3.hasDerivAt_Li_two_rpow`](./lean_stage3/RowLeaves.md#Stage3-hasDerivAt_Li_two_rpow) | theorem | shape | `RowLeaves` | HasDerivAt (fun u : ℝ =&gt; Li ((2 : ℝ) ^ u)) (Real.exp (Real.log 2 * x) / x) x |
| [`LandauMellinG.hasDerivAt_logPrim`](./lean_stage3/LandauMellinG.md#LandauMellinG-hasDerivAt_logPrim) | theorem | shape | `LandauMellinG` | HasDerivAt (logPrim s) ((Real.log y : ℂ) * (y : ℂ) ^ (-s)) y |
| [`LandauKernel.hasDerivAt_prim`](./lean_stage3/LandauKernel.md#LandauKernel-hasDerivAt_prim) | theorem | shape | `LandauKernel` | HasDerivAt (fun t : ℝ =&gt; -(Real.log t ^ (k + 1) * t ^ (-a)) / a) (Real.log y ^ (k + 1) * y ^ (-a - 1) - ((k : ℝ) + 1) / a * (Real.log y ^ k * y ^ (-a - 1))) y |
| [`WeilLobe.hasDerivAt_q`](./lean_stage3/WeilLobe.md#WeilLobe-hasDerivAt_q) | theorem | shape | `WeilLobe` | HasDerivAt q (q1 x) x |
| [`WeilLobe.hasDerivAt_q1`](./lean_stage3/WeilLobe.md#WeilLobe-hasDerivAt_q1) | theorem | shape | `WeilLobe` | HasDerivAt q1 (q2 x) x |
| [`Stage3.hasDerivAt_rowIntegral`](./lean_stage3/RowLeaves.md#Stage3-hasDerivAt_rowIntegral) | theorem | shape | `RowLeaves` | HasDerivAt (fun u : ℝ =&gt; 2 / Real.log 2 + ∫ t in (1 : ℝ)..u, Real.exp (Real.log 2 * t) / t) (Real.exp (Real.log 2 * x) / x) x |
| [`Expansion.hasDerivAt_S`](./lean/Expansion.md#Expansion-hasDerivAt_S) | theorem | shape | `Expansion` | HasDerivAt (S d) (∑ j ∈ range (d + 1), c d j * (-(j : ℝ) - 1) * x ^ (-(j + 2 : ℤ))) x |
| [`WeilPower.hasDerivAt_s`](./lean_stage3/WeilPower.md#WeilPower-hasDerivAt_s) | theorem | shape | `WeilPower` | HasDerivAt (fun y : ℝ =&gt; Real.sin (Real.pi * y / 2)) (Real.pi / 2 * c x) x |
| [`WeilLobe.hasDerivAt_sin_pi`](./lean_stage3/WeilLobe.md#WeilLobe-hasDerivAt_sin_pi) | theorem | shape | `WeilLobe` | HasDerivAt (fun y : ℝ =&gt; Real.sin (Real.pi * y)) (Real.cos (Real.pi * x) * Real.pi) x |
| [`LeftSmooth.hasDerivAt_sL`](./lean_stage3/LeftSmooth.md#LeftSmooth-hasDerivAt_sL) | theorem | shape | `LeftSmooth` | HasDerivAt sL Complex.I t |
| [`Stage3.hasDerivAt_sqPos`](./lean_stage3/ExplicitBump.md#Stage3-hasDerivAt_sqPos) | theorem | shape | `ExplicitBump` | HasDerivAt (fun t : ℝ =&gt; (max 0 t) ^ 2) (2 * max 0 u) u |
| [`LeftSmooth.hasDerivAt_tanPiece`](./lean_stage3/LeftSmooth.md#LeftSmooth-hasDerivAt_tanPiece) | theorem | shape | `LeftSmooth` | HasDerivAt tanPiece (tanPiece' t) t |
| [`PiFixedRow.hasDerivAt_w`](./lean_stage3/PiFixedRow.md#PiFixedRow-hasDerivAt_w) | theorem | shape | `PiFixedRow` | HasDerivAt w (wd t) t |
| [`LeftSmooth.hasDerivAt_wL`](./lean_stage3/LeftSmooth.md#LeftSmooth-hasDerivAt_wL) | theorem | shape | `LeftSmooth` | HasDerivAt wL (-Complex.I) t |
| [`PiFixedRow.hasDerivAt_wt`](./lean_stage3/PiFixedRow.md#PiFixedRow-hasDerivAt_wt) | theorem | shape | `PiFixedRow` | HasDerivAt wt ((wd t : ℝ) : ℂ) t |
| [`ZetaEM.hasDerivWithinAt_fract`](./lean_stage3/ZetaEM.md#ZetaEM-hasDerivWithinAt_fract) | theorem | shape | `ZetaEM` | HasDerivWithinAt Int.fract 1 (Ioi x) x |
| [`Expansion.hD_of_window`](./lean/Expansion.md#Expansion-hD_of_window) | theorem | shape | `Expansion` | ∀ y ∈ Icc ((r : ℝ) - (d + 1)) r, Nonvanishing.Mlow r d ≤ iteratedDeriv (d + 1) G y |
| [`RHPull.holo_logDerivZeta_of_RH`](./lean_stage3/LineBound.md#RHPull-holo_logDerivZeta_of_RH) | theorem | reads ζ | `LineBound` | HolomorphicOn (deriv riemannZeta / riemannZeta) (Set.Icc σ₁ 2 ×ℂ Set.Icc (-T) T \ {1}) |
| [`Stage3.holo_logDerivZeta_theta`](./lean_stage3/ThetaPsi.md#Stage3-holo_logDerivZeta_theta) | theorem | reads ζ | `ThetaPsi` | HolomorphicOn (deriv riemannZeta / riemannZeta) (Set.Icc σ₁ 2 ×ℂ Set.Icc (-T) T \ {1}) |
| [`PerronKernel.horiz_bound`](./lean_stage3/PerronKernel.md#PerronKernel-horiz_bound) | theorem | shape | `PerronKernel` | ‖∫ σ in a..b, (y : ℂ) ^ ((σ : ℂ) + (T' : ℂ) * Complex.I) / ((σ : ℂ) + (T' : ℂ) * Complex.I)‖ ≤ max (y ^ a) (y ^ b) / (\|T'\| * \|Real.log y\|) |
| [`RHPull.horiz_length`](./lean_stage3/LineBound.md#RHPull-horiz_length) | theorem | shape | `LineBound` | (1 + 1 / Real.log X) - σRH X = 1 / 2 |
| [`Stage3.horiz_length_theta`](./lean_stage3/ThetaPsi.md#Stage3-horiz_length_theta) | theorem | shape | `ThetaPsi` | (1 + 1 / Real.log X) - σθ θ X = 1 - θ |
| [`RHPull.horiz_small`](./lean_stage3/LineBound.md#RHPull-horiz_small) | theorem | shape | `LineBound` | (1 / (2 * Real.pi)) * (1 / 2) * ((1996 * Real.log (84 * X) + (29 * Real.log X + 129) * Real.log X) * (B / X) * (Real.exp 1 * X)) ≤ (900 * Real.exp 1 * B / Real.pi) * (Real.log X) ^ 2 |
| [`ArgLegs.horizontal_leg_le`](./lean_stage3/ArgLegs.md#ArgLegs-horizontal_leg_le) | theorem | reads ζ | `ArgLegs` | \|(∫ x in (1/2:ℝ)..2, logDeriv riemannZeta ((x : ℂ) + T * Complex.I)).im\| ≤ Real.pi * ((Z.card : ℝ) + 1) |
| [`WeilPowerPhase.hterm`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-hterm) | def | shape | `WeilPowerPhase` | ℝ |
| [`RHPull.I2_norm_le`](./lean_stage3/LineBound.md#RHPull-I2_norm_le) | theorem | reads ζ | `LineBound` | ‖I₂ ν ε T X (σRH X)‖ ≤ (1 / (2 * Real.pi)) * (1 / 2) * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ (1 + 1 / Real.log X)) |
| [`Stage3.I2_norm_le_theta`](./lean_stage3/ThetaPsi.md#Stage3-I2_norm_le_theta) | theorem | reads ζ | `ThetaPsi` | ‖I₂ ν ε T X (σθ θ X)‖ ≤ (1 / (2 * Real.pi)) * (1 - θ) * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ (1 + 1 / Real.log X)) |
| [`RHPull.I37_norm_le`](./lean_stage3/LineBound.md#RHPull-I37_norm_le) | theorem | reads ζ | `LineBound` | ‖I₃₇ ν ε T X (σRH X)‖ ≤ (1 / (2 * Real.pi)) * (2 * T) * (11100 * (Real.log X) ^ 2 * M * X ^ (σRH X)) |
| [`RHPull.I37_norm_le_decay`](./lean_stage3/LineBound.md#RHPull-I37_norm_le_decay) | theorem | reads ζ | `LineBound` | ‖I₃₇ ν ε T X (σRH X)‖ ≤ (1 / (2 * Real.pi)) * Real.pi * (11100 * (Real.log X) ^ 2 * (4 * C / ε) * X ^ (σRH X)) |
| [`Stage3.I37_norm_le_decay_theta`](./lean_stage3/ThetaPull.md#Stage3-I37_norm_le_decay_theta) | theorem | reads ζ | `ThetaPull` | ‖I₃₇ ν ε T X (σθ θ X)‖ ≤ (1 / (2 * Real.pi)) * Real.pi * (11100 * (Real.log X) ^ 2 * (4 * C / ε) * X ^ (σθ θ X)) |
| [`RHPull.I37_norm_le_epsfree`](./lean_stage3/LineBound.md#RHPull-I37_norm_le_epsfree) | theorem | reads ζ | `LineBound` | ‖I₃₇ ν ε T X (σRH X)‖ ≤ (1 / (2 * Real.pi)) * (6 * Real.log (1 + T)) * (11100 * (Real.log X) ^ 2 * B * X ^ (σRH X)) |
| [`Stage3.I37_norm_le_epsfree_theta`](./lean_stage3/ThetaPull.md#Stage3-I37_norm_le_epsfree_theta) | theorem | reads ζ | `ThetaPull` | ‖I₃₇ ν ε T X (σθ θ X)‖ ≤ (1 / (2 * Real.pi)) * (6 * Real.log (1 + T)) * (11100 * (Real.log X) ^ 2 * B * X ^ (σθ θ X)) |
| [`Stage3.I37_power_form_theta`](./lean_stage3/ThetaPull.md#Stage3-I37_power_form_theta) | theorem | reads ζ | `ThetaPull` | ‖I₃₇ ν ε T X (σθ θ X)‖ ≤ (22200 * Real.exp 1 * C / ε) * X ^ θ * (Real.log X) ^ 2 |
| [`Stage3.I37_power_log3_theta`](./lean_stage3/ThetaPull.md#Stage3-I37_power_log3_theta) | theorem | reads ζ | `ThetaPull` | ‖I₃₇ ν ε T X (σθ θ X)‖ ≤ (66600 * Real.exp 1 * B / Real.pi) * X ^ θ * (Real.log X) ^ 3 |
| [`RHPull.I37_sqrt_form`](./lean_stage3/LineBound.md#RHPull-I37_sqrt_form) | theorem | reads ζ | `LineBound` | ‖I₃₇ ν ε T X (σRH X)‖ ≤ (22200 * Real.exp 1 * C / ε) * Real.sqrt X * (Real.log X) ^ 2 |
| [`RHPull.I37_sqrt_log3`](./lean_stage3/LineBound.md#RHPull-I37_sqrt_log3) | theorem | reads ζ | `LineBound` | ‖I₃₇ ν ε T X (σRH X)‖ ≤ (66600 * Real.exp 1 * B / Real.pi) * Real.sqrt X * (Real.log X) ^ 3 |
| [`Stage3.I37_sqrt_log3_half`](./lean_stage3/ThetaPull.md#Stage3-I37_sqrt_log3_half) | theorem | reads ζ | `ThetaPull` | ‖I₃₇ ν ε T X (RHPull.σRH X)‖ ≤ (66600 * Real.exp 1 * B / Real.pi) * Real.sqrt X * (Real.log X) ^ 3 |
| [`RHPull.I8_norm_le`](./lean_stage3/LineBound.md#RHPull-I8_norm_le) | theorem | reads ζ | `LineBound` | ‖I₈ ν ε T X (σRH X)‖ ≤ (1 / (2 * Real.pi)) * (1 / 2) * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ (1 + 1 / Real.log X)) |
| [`Stage3.I8_norm_le_theta`](./lean_stage3/ThetaPsi.md#Stage3-I8_norm_le_theta) | theorem | reads ζ | `ThetaPsi` | ‖I₈ ν ε T X (σθ θ X)‖ ≤ (1 / (2 * Real.pi)) * (1 - θ) * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ (1 + 1 / Real.log X)) |
| [`WeilOddPower.ibp_once`](./lean_stage3/WeilOddPower.md#WeilOddPower-ibp_once) | theorem | shape | `WeilOddPower` | (∫ x in (-1 : ℝ)..1, ((f1 (k + 1) x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ))) = -(w * ∫ x in (-1 : ℝ)..1, ((c x ^ (k + 2) : ℝ) : ℂ) * Complex.exp (w * (x : ℂ))) |
| [`WeilPower.ibp_twice`](./lean_stage3/WeilPower.md#WeilPower-ibp_twice) | theorem | shape | `WeilPower` | w ^ 2 * ∫ x in (-1 : ℝ)..1, ((c x ^ (k + 2) : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)) = ∫ x in (-1 : ℝ)..1, ((f2 k x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)) |
| [`WeilTiles.idx`](./lean_stage3/WeilTiles.md#WeilTiles-idx) | def | shape | `WeilTiles` | ℕ |
| [`WeilSeries.idx_le`](./lean_stage3/WeilSeries.md#WeilSeries-idx_le) | theorem | shape | `WeilSeries` | (idx γ : ℝ) ≤ γ |
| [`WeilTiles.idx_spec`](./lean_stage3/WeilTiles.md#WeilTiles-idx_spec) | theorem | shape | `WeilTiles` | \|t - centre (idx t)\| ≤ 9 / 10 |
| [`LandauPrimeSide.Ik`](./lean_stage3/LandauPrimeSide.md#LandauPrimeSide-Ik) | def | shape | `LandauPrimeSide` | ℝ |
| [`LandauPrimeSide.Ik_integrable`](./lean_stage3/LandauPrimeSide.md#LandauPrimeSide-Ik_integrable) | theorem | reads ζ | `LandauPrimeSide` | IntegrableOn (fun y : ℝ =&gt; LandauWindow.G y * Real.log y ^ k * y ^ (-σ - 1)) (Ioi 1) |
| [`LandauPrimeSide.Ik_le`](./lean_stage3/LandauPrimeSide.md#LandauPrimeSide-Ik_le) | theorem | reads ζ | `LandauPrimeSide` | Ik σ k ≤ C * (k.factorial / (σ - θ) ^ (k + 1)) + 8 * (Y ^ b * (k.factorial / (σ - 1 + b) ^ (k + 1))) + 8 * ((Y ^ (1 + δ)) ^ (-b') * (k.factorial / (σ - 1 - b') ^ (k + 1))) |
| [`WeilPowerShell.im_alpha_le`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-im_alpha_le) | theorem | shape | `WeilPowerShell` | (zOf e' D e).im * (1 / ((lam : ℝ) * Real.pi ^ 2)) ≤ Real.pi / 2 |
| [`ArgLegs.im_integral_le_pi_of_re_nonneg`](./lean_stage3/ArgLegs.md#ArgLegs-im_integral_le_pi_of_re_nonneg) | theorem | shape | `ArgLegs` | \|(∫ x in a..b, g' x / g x).im\| ≤ Real.pi |
| [`ArgLegs.im_integral_le_pi_of_re_nonpos`](./lean_stage3/ArgLegs.md#ArgLegs-im_integral_le_pi_of_re_nonpos) | theorem | shape | `ArgLegs` | \|(∫ x in a..b, g' x / g x).im\| ≤ Real.pi |
| [`WeilPowerBridge.im_sq_sub_re_sq`](./lean_stage3/WeilPowerBridge.md#WeilPowerBridge-im_sq_sub_re_sq) | theorem | shape | `WeilPowerBridge` | z.im ^ 2 - z.re ^ 2 = -(z ^ 2).re |
| [`ZeroDensity.inner_le`](./lean_stage3/ZeroDensity.md#ZeroDensity-inner_le) | theorem | reads ζ | `ZeroDensity` | ∫ t in (1:ℝ)..T, ‖MollifiedMean.f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2 ≤ bConst δ k * T ^ (1 - 6 * δ ^ 2) * (1 + Real.log T) ^ 5 |
| [`ZeroSquares.innerI`](./lean_stage3/ZeroSquares.md#ZeroSquares-innerI) | def | reads ζ | `ZeroSquares` | ℝ |
| [`ZeroSquares.innerI_eq`](./lean_stage3/ZeroSquares.md#ZeroSquares-innerI_eq) | theorem | reads ζ | `ZeroSquares` | innerI X a b u = ∫ t in a..b, ‖MollifiedMean.f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2 |
| [`ZeroSquares.innerI_mono`](./lean_stage3/ZeroSquares.md#ZeroSquares-innerI_mono) | theorem | reads ζ | `ZeroSquares` | innerI X a b u ≤ innerI X c d u |
| [`ZeroSquares.innerI_nonneg`](./lean_stage3/ZeroSquares.md#ZeroSquares-innerI_nonneg) | theorem | reads ζ | `ZeroSquares` | 0 ≤ innerI X a b u |
| [`RHPull.instantiation_arithmetic`](./lean_stage3/LineBound.md#RHPull-instantiation_arithmetic) | theorem | shape | `LineBound` | c * (Real.sqrt X)⁻¹ * X * Real.log X ≤ c * Real.sqrt X * (Real.log X) ^ 3 ∧ c * X * Real.log X / Real.sqrt X ≤ c * Real.sqrt X * (Real.log X) ^ 3 ∧ c * ((Real.sqrt X)⁻¹ * X) ≤ c * Real.sqrt X * (Real.… |
| [`PiZeros.integrable_cpow`](./lean_stage3/PiZeros.md#PiZeros-integrable_cpow) | theorem | shape | `PiZeros` | IntervalIntegrable (fun t : ℝ =&gt; (t : ℂ) ^ ρ / ρ) volume 2 x |
| [`PiRemainder.integrable_efRem`](./lean_stage3/PiRemainder.md#PiRemainder-integrable_efRem) | theorem | reads ζ | `PiRemainder` | IntervalIntegrable (efRem T) volume 2 x |
| [`ZetaGrowth.integrable_emA_tail`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-integrable_emA_tail) | theorem | shape | `ZetaGrowth` | IntegrableOn (fun x : ℝ ↦ (emA x : ℂ) * (x : ℂ) ^ (-(s+2))) (Ioi (N:ℝ)) |
| [`Stage3.integrable_err_term`](./lean_stage3/PsiToPi.md#Stage3-integrable_err_term) | theorem | shape | `PsiToPi` | IntervalIntegrable (fun t =&gt; (θ t - t) / (t * Real.log t ^ 2)) volume a x |
| [`PiZeros.integrable_mul_wt`](./lean_stage3/PiZeros.md#PiZeros-integrable_mul_wt) | theorem | shape | `PiZeros` | IntervalIntegrable (fun t =&gt; f t * wt t) volume 2 x |
| [`PiZeros.integrable_ofReal_of_monotone`](./lean_stage3/PiZeros.md#PiZeros-integrable_ofReal_of_monotone) | theorem | shape | `PiZeros` | IntervalIntegrable (fun t =&gt; ((f t : ℝ) : ℂ)) volume 2 x |
| [`VonKoch.integrable_psi_cpow`](./lean_stage3/VonKochScaffold.md#VonKoch-integrable_psi_cpow) | theorem | reads ζ | `VonKochScaffold` | IntegrableOn (fun t : ℝ ↦ ((ψ t : ℝ) : ℂ) * (t : ℂ) ^ (-(s + 1))) (Set.Ioi (1:ℝ)) |
| [`StencilWeil.integrable_shift_term`](./lean_stage3/StencilWeil.md#StencilWeil-integrable_shift_term) | theorem | shape | `StencilWeil` | Integrable (fun u : ℝ =&gt; φ (u + a) * Complex.exp (-(z * (u : ℂ)))) |
| [`Stage3.integrable_theta_term`](./lean_stage3/PsiToPi.md#Stage3-integrable_theta_term) | theorem | shape | `PsiToPi` | IntervalIntegrable (fun t =&gt; θ t / (t * Real.log t ^ 2)) volume a x |
| [`ZetaEM.integrableOn_bern_cpow`](./lean_stage3/ZetaEM.md#ZetaEM-integrableOn_bern_cpow) | theorem | reads ζ | `ZetaEM` | IntegrableOn (fun x : ℝ ↦ ((bernoulliFun k (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ w) (Ioi a) |
| [`Stage3.integral_A_rpow_le`](./lean_stage3/PsiToPi.md#Stage3-integral_A_rpow_le) | theorem | shape | `PsiToPi` | (∫ t in a..x, A * t ^ (-(1 : ℝ) / 2)) ≤ 2 * A * Real.sqrt x |
| [`Stage3.integral_A_rpow_theta_le`](./lean_stage3/ThetaPi.md#Stage3-integral_A_rpow_theta_le) | theorem | shape | `ThetaPi` | (∫ t in a..x, A * t ^ (θ - 1)) ≤ 2 * A * x ^ θ |
| [`RHPull.integral_abs_kernel`](./lean_stage3/LineBound.md#RHPull-integral_abs_kernel) | theorem | shape | `LineBound` | ∫ t in (-T)..T, (1 + \|t\|)⁻¹ = 2 * Real.log (1 + T) |
| [`Stage3.integral_inv_horizontal`](./lean_stage3/ArgIdentity.md#Stage3-integral_inv_horizontal) | theorem | shape | `ArgIdentity` | (∫ x in a..b, (((x : ℂ) - d) + T * Complex.I)⁻¹) = Complex.log (((b : ℂ) - d) + T * Complex.I) - Complex.log (((a : ℂ) - d) + T * Complex.I) |
| [`MollifiedMean.integral_inv_sq_le`](./lean_stage3/MollifiedMean.md#MollifiedMean-integral_inv_sq_le) | theorem | shape | `MollifiedMean` | ∫ t in (1:ℝ)..T, (t ^ 2)⁻¹ ≤ 1 |
| [`Stage3.integral_inv_vertical`](./lean_stage3/ArgIdentity.md#Stage3-integral_inv_vertical) | theorem | shape | `ArgIdentity` | (∫ t in (0:ℝ)..T, ((c : ℂ) + t * Complex.I)⁻¹) = -Complex.I * (Complex.log ((c : ℂ) + T * Complex.I) - Complex.log (c : ℂ)) |
| [`RHPull.integral_kernel_le`](./lean_stage3/LineBound.md#RHPull-integral_kernel_le) | theorem | shape | `LineBound` | ∫ t in (-T)..T, ((1:ℝ) + t ^ 2)⁻¹ ≤ Real.pi |
| [`Stage3.integral_log_half`](./lean_stage3/Stirling.md#Stage3-integral_log_half) | theorem | shape | `Stirling` | (∫ t in (1 : ℝ)..T, Real.log (t / 2)) = T * Real.log (T / 2) - T + 1 + Real.log 2 |
| [`ArgLegs.integral_logDeriv_eq_log_sub`](./lean_stage3/ArgLegs.md#ArgLegs-integral_logDeriv_eq_log_sub) | theorem | shape | `ArgLegs` | ∫ x in a..b, g' x / g x = Complex.log (g b) - Complex.log (g a) |
| [`RHPull.integral_shift_inv`](./lean_stage3/LineBound.md#RHPull-integral_shift_inv) | theorem | shape | `LineBound` | ∫ t in (0:ℝ)..T, (1 + t)⁻¹ = Real.log (1 + T) |
| [`DirichletMean.integral_sq_norm_eq`](./lean_stage3/DirichletMean.md#DirichletMean-integral_sq_norm_eq) | theorem | shape | `DirichletMean` | ((∫ t in T₁..T₂, ‖∑ n ∈ Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ)))‖ ^ 2 : ℝ) : ℂ) = ∑ m ∈ Icc 1 N, ∑ n ∈ Icc 1 N, a m * (starRingEnd ℂ) (a n) * ∫ t in T₁..T₂, Complex.exp (Complex.I * ((Real.lo… |
| [`LandauTaylor.integrand_norm_le`](./lean_stage3/LandauTaylor.md#LandauTaylor-integrand_norm_le) | theorem | reads ζ | `LandauTaylor` | ‖(LandauWindow.G y : ℂ) * (-(Real.log y : ℂ)) ^ k * (y : ℂ) ^ (-s - 1)‖ ≤ 8 * (Real.log y ^ k * y ^ (-a - 1) + Real.log y ^ (k + 1) * y ^ (-a - 1)) |
| [`RHPull.integrand_norm_le`](./lean_stage3/LineBound.md#RHPull-integrand_norm_le) | theorem | reads ζ | `LineBound` | ‖SmoothedChebyshevIntegrand ν ε X ((σRH X : ℂ) + I * (t : ℂ))‖ ≤ 11100 * (Real.log X) ^ 2 * M * X ^ (σRH X) |
| [`RHPull.integrand_norm_le_horiz`](./lean_stage3/LineBound.md#RHPull-integrand_norm_le_horiz) | theorem | reads ζ | `LineBound` | ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) + I * (t : ℂ))‖ ≤ (1996 * Real.log (84 * t) + (29 * Real.log t + 129) * Real.log X) * M * X ^ σ |
| [`RHPull.integrand_norm_le_horiz_neg`](./lean_stage3/LineBound.md#RHPull-integrand_norm_le_horiz_neg) | theorem | reads ζ | `LineBound` | ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) - (T : ℂ) * I)‖ ≤ (1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ σ |
| [`Stage3.integrand_norm_le_horiz_neg_theta`](./lean_stage3/ThetaPsi.md#Stage3-integrand_norm_le_horiz_neg_theta) | theorem | reads ζ | `ThetaPsi` | ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) - (T : ℂ) * I)‖ ≤ (1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ σ |
| [`Stage3.integrand_norm_le_horiz_theta`](./lean_stage3/ThetaPsi.md#Stage3-integrand_norm_le_horiz_theta) | theorem | reads ζ | `ThetaPsi` | ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) + I * (t : ℂ))‖ ≤ (1996 * Real.log (84 * t) + (29 * Real.log t + 129) * Real.log X) * M * X ^ σ |
| [`Stage3.integrand_norm_le_theta`](./lean_stage3/ThetaPull.md#Stage3-integrand_norm_le_theta) | theorem | reads ζ | `ThetaPull` | ‖SmoothedChebyshevIntegrand ν ε X ((σθ θ X : ℂ) + I * (t : ℂ))‖ ≤ 11100 * (Real.log X) ^ 2 * M * X ^ (σθ θ X) |
| [`ZetaEM.interval_ibp`](./lean_stage3/ZetaEM.md#ZetaEM-interval_ibp) | theorem | reads ζ | `ZetaEM` | ((k:ℂ) + 1) * ∫ x in a..b, ((bernoulliFun k (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ (-(s + k)) = ((bernoulliFun (k+1) (Int.fract b) : ℝ) : ℂ) * (b:ℂ) ^ (-(s + k)) - ((bernoulliFun (k+1) (Int.fract a) : ℝ) :… |
| [`ZetaGrowth.interval_ibp`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-interval_ibp) | theorem | shape | `ZetaGrowth` | ∫ x in (n:ℝ)..((n:ℝ)+1), ((⌊x⌋ : ℂ) + 1/2 - (x:ℂ)) * (x:ℂ) ^ (-(s+1)) = (s+1) * ∫ x in (n:ℝ)..((n:ℝ)+1), (emA x : ℂ) * (x:ℂ) ^ (-(s+2)) |
| [`PiToPsi.intervalIntegrable_Li_div`](./lean_stage3/PiToPsi.md#PiToPsi-intervalIntegrable_Li_div) | theorem | shape | `PiToPsi` | IntervalIntegrable (fun t : ℝ =&gt; Stage3.Li t / t) volume 2 x |
| [`Stage3.intervalIntegrable_phasePoint`](./lean_stage3/Stirling.md#Stage3-intervalIntegrable_phasePoint) | theorem | reads ζ | `Stirling` | IntervalIntegrable phasePoint MeasureTheory.volume a b |
| [`PiToPsi.intervalIntegrable_pi_div`](./lean_stage3/PiToPsi.md#PiToPsi-intervalIntegrable_pi_div) | theorem | shape | `PiToPsi` | IntervalIntegrable (fun t : ℝ =&gt; (Nat.primeCounting ⌊t⌋₊ : ℝ) / t) volume 2 x |
| [`PiToPsi.intervalIntegrable_relRes`](./lean_stage3/PiToPsi.md#PiToPsi-intervalIntegrable_relRes) | theorem | shape | `PiToPsi` | IntervalIntegrable relRes volume 2 x |
| [`Stage3.intervalIntegral_im`](./lean_stage3/ArgIdentity.md#Stage3-intervalIntegral_im) | theorem | shape | `ArgIdentity` | (∫ t in a..b, f t).im = ∫ t in a..b, (f t).im |
| [`Stage3.intervalIntegral_re`](./lean_stage3/ArgIdentity.md#Stage3-intervalIntegral_re) | theorem | shape | `ArgIdentity` | (∫ t in a..b, f t).re = ∫ t in a..b, (f t).re |
| [`WeilPowerShell.inv_exp_le`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-inv_exp_le) | theorem | shape | `WeilPowerShell` | 1 / Real.exp ((zOf e' D e).re * (1 / ((lam : ℝ) * Real.pi ^ 2))) ≤ Real.exp (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (1 / ((lam : ℝ) * Real.pi ^ 2))) |
| [`Stage3.inv_le_dyadic_sum`](./lean_stage3/Assembly.md#Stage3-inv_le_dyadic_sum) | theorem | shape | `Assembly` | ∀ γ : ℝ, 1 ≤ γ → γ &lt; 2 ^ (K + 1) → γ⁻¹ ≤ ∑ j ∈ Finset.range (K + 1), ((2 : ℝ) ^ j)⁻¹ * (if γ &lt; 2 ^ (j + 1) then 1 else 0) |
| [`DirichletMean.inv_log_gap`](./lean_stage3/DirichletMean.md#DirichletMean-inv_log_gap) | theorem | shape | `DirichletMean` | 2 / \|Real.log n - Real.log m\| ≤ 2 * N * \|(m : ℝ) - n\|⁻¹ |
| [`PerronTwo.inv_log_le_of_two_le`](./lean_stage3/PerronTwo.md#PerronTwo-inv_log_le_of_two_le) | theorem | shape | `PerronTwo` | 1 / Real.log x ≤ 3/2 |
| [`Stage3.inv_log_le_theta`](./lean_stage3/ThetaPsi.md#Stage3-inv_log_le_theta) | theorem | shape | `ThetaPsi` | 1 / Real.log X ≤ (1 - θ) / 2 |
| [`RouteNum.inv_log_two_le`](./lean_stage3/RouteNum.md#RouteNum-inv_log_two_le) | theorem | shape | `RouteNum` | 1 / Real.log 2 ≤ 1.4428 |
| [`PiRemainder.inv_norm_le_dyadic`](./lean_stage3/PiRemainder.md#PiRemainder-inv_norm_le_dyadic) | theorem | reads ζ | `PiRemainder` | ‖(ρ : ℂ)‖⁻¹ ≤ Mlow * ∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹ * (if \|(ρ : ℂ).im\| &lt; 2 ^ (j + 1) then 1 else 0) |
| [`PiRemainder.inv_norm_le_Mlow`](./lean_stage3/PiRemainder.md#PiRemainder-inv_norm_le_Mlow) | theorem | reads ζ | `PiRemainder` | ‖(ρ : ℂ)‖⁻¹ ≤ Mlow |
| [`Stage3.inv_quadratic_tsum_le`](./lean_stage3/Stirling.md#Stage3-inv_quadratic_tsum_le) | theorem | reads ζ | `Stirling` | (∑' n : ℕ, (((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹) ≤ 12 / t |
| [`RHPull.inv_sqrt_mul_self`](./lean_stage3/LineBound.md#RHPull-inv_sqrt_mul_self) | theorem | shape | `LineBound` | (Real.sqrt X)⁻¹ * X = Real.sqrt X |
| [`Transform.inversion_fixes_circle`](./lean/Transform.md#Transform-inversion_fixes_circle) | theorem | shape | `Transform` | ‖(b : ℂ) ^ (-(1 : ℂ)) / z‖ = ‖z‖ ↔ ‖z‖ = b ^ (-(1 : ℝ) / 2) |
| [`WobbleCount.invisible_iff`](./lean_stage3/WobbleCount.md#WobbleCount-invisible_iff) | theorem | reads ζ | `WobbleCount` | (∃ C : ℝ, ∀ N : ℕ, 0 &lt; N → ‖wobbleSum ρ N - (N : ℂ) / (1 - ρ)‖ ≤ C) ↔ riemannZeta ρ = 0 |
| [`FiniteOffLinePi.ipart`](./lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-ipart) | def | shape | `FiniteOffLinePi` | ℂ |
| [`JointLadder.irrational_log_two_div_log_three`](./lean/JointLadder.md#JointLadder-irrational_log_two_div_log_three) | theorem | shape | `JointLadder` | Irrational (Real.log 2 / Real.log 3) |
| [`Stage3.isEmpty_zeroHeight`](./lean_stage3/RealSegment.md#Stage3-isEmpty_zeroHeight) | theorem | reads ζ | `RealSegment` | IsEmpty Kadiri.ZeroHeightNontrivialZeros |
| [`Elephant.IsModeRow`](./lean/Elephant.md#Elephant-IsModeRow) | def | shape | `Elephant` | Prop |
| [`VonKoch.isOpen_region`](./lean_stage3/VonKochScaffold.md#VonKoch-isOpen_region) | theorem | shape | `VonKochScaffold` | IsOpen region |
| [`Stage3.isOpen_regionθ`](./lean_stage3/ThetaConverse.md#Stage3-isOpen_region-) | theorem | shape | `ThetaConverse` | IsOpen (regionθ θ) |
| [`ZetaGrowth.isOpen_stripRegion`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-isOpen_stripRegion) | theorem | shape | `ZetaGrowth` | IsOpen stripRegion |
| [`Zeros.IsTable`](./lean/Zeros.md#Zeros-IsTable) | def | counting | `Zeros` | Prop |
| [`Construction.IsTableOf`](./lean/Construction.md#Construction-IsTableOf) | def | counting | `Construction` | Prop |
| [`Bridge.IsTest`](./lean_bridge/WeilBridge.md#Bridge-IsTest) | def | shape | `WeilBridge` | Prop |
| [`WeilDetect.IsTest`](./lean_stage3/WeilDetect.md#WeilDetect-IsTest) | def | shape | `WeilDetect` | Prop |
| [`WeilPowerAssembly.isTest_phiWC`](./lean_stage3/WeilPowerAssembly.md#WeilPowerAssembly-isTest_phiWC) | theorem | shape | `WeilPowerAssembly` | IsTest (2 * h) (WeilPowerBackground.phiWC h γ m) |
| [`StencilWeil.isTest_stencilTest`](./lean_stage3/StencilWeil.md#StencilWeil-isTest_stencilTest) | theorem | shape | `StencilWeil` | IsTest (L + 2 * (d * Real.log 2)) (stencilTest d φ) |
| [`MainTerm.iter_bdiffR_eq_fwdDiff`](./lean/MainTerm.md#MainTerm-iter_bdiffR_eq_fwdDiff) | theorem | shape | `MainTerm` | (bdiffR^[n]) g x = (-1 : ℝ) ^ n * (fwdDiff (-1 : ℝ))^[n] g x |
| [`MainTerm.iter_bdiffR_eq_sum`](./lean/MainTerm.md#MainTerm-iter_bdiffR_eq_sum) | theorem | shape | `MainTerm` | (bdiffR^[n]) g x = ∑ k ∈ range (n + 1), (-1 : ℝ) ^ k * (n.choose k) * g (x - k) |
| [`MainTerm.iter_bdiffR_lb`](./lean/MainTerm.md#MainTerm-iter_bdiffR_lb) | theorem | shape | `MainTerm` | m ≤ (bdiffR^[n]) g x |
| [`Nonvanishing.iter_bdiffZ_eq_fwdDiff`](./lean/Nonvanishing.md#Nonvanishing-iter_bdiffZ_eq_fwdDiff) | theorem | shape | `Nonvanishing` | (bdiffZ^[n]) g r = (-1 : ℝ) ^ n * (fwdDiff (-1 : ℤ))^[n] g r |
| [`Nonvanishing.iter_bdiffZ_eq_stencilR`](./lean/Nonvanishing.md#Nonvanishing-iter_bdiffZ_eq_stencilR) | theorem | shape | `Nonvanishing` | (bdiffZ^[n]) g r = stencilR n g r |
| [`CellBdiff.iter_bdZ_eq_fwdDiff`](./lean_stage3/CellBdiff.md#CellBdiff-iter_bdZ_eq_fwdDiff) | theorem | shape | `CellBdiff` | (bdZ^[n]) a r = (-1 : ℂ) ^ n * (fwdDiff (-1 : ℤ))^[n] a r |
| [`CellBdiff.iter_bdZ_eq_stencil`](./lean_stage3/CellBdiff.md#CellBdiff-iter_bdZ_eq_stencil) | theorem | shape | `CellBdiff` | (bdZ^[n]) a r = CellZeros.stencil n a r |
| [`MainTerm.iteratedDeriv_bdiffR`](./lean/MainTerm.md#MainTerm-iteratedDeriv_bdiffR) | theorem | shape | `MainTerm` | iteratedDeriv n (bdiffR g) = bdiffR (iteratedDeriv n g) |
| [`Expansion.iteratedDeriv_f2x`](./lean/Expansion.md#Expansion-iteratedDeriv_f2x) | theorem | shape | `Expansion` | ∀ x ∈ Ioi (0 : ℝ), iteratedDeriv d f2x x = F d x |
| [`LandauPoleSub.iteratedDeriv_inv_sub`](./lean_stage3/LandauPoleSub.md#LandauPoleSub-iteratedDeriv_inv_sub) | theorem | shape | `LandauPoleSub` | iteratedDeriv k (fun s : ℂ =&gt; (s - q)⁻¹) c = (-1) ^ k * (k.factorial : ℂ) * (c - q) ^ (-1 - (k : ℤ)) |
| [`LandauTaylor.iteratedDeriv_Phi`](./lean_stage3/LandauTaylor.md#LandauTaylor-iteratedDeriv_Phi) | theorem | reads ζ | `LandauTaylor` | iteratedDeriv k LandauMellinG.Phi s = mellinLog k s |
| [`LandauPrimeSide.iteratedDeriv_Phi_eq_Ik`](./lean_stage3/LandauPrimeSide.md#LandauPrimeSide-iteratedDeriv_Phi_eq_Ik) | theorem | reads ζ | `LandauPrimeSide` | iteratedDeriv k LandauMellinG.Phi (σ : ℂ) = (-1) ^ k * ((Ik σ k : ℝ) : ℂ) |
| [`Stage3.jensenF`](./lean_stage3/JensenCount.md#Stage3-jensenF) | def | reads ζ | `JensenCount` | ℂ → ℂ |
| [`Stage3.jensenF_analytic`](./lean_stage3/JensenCount.md#Stage3-jensenF_analytic) | theorem | reads ζ | `JensenCount` | AnalyticOnNhd ℂ (jensenF T) (Metric.closedBall (0 : ℂ) 1) |
| [`Stage3.jensenF_bound`](./lean_stage3/JensenCount.md#Stage3-jensenF_bound) | theorem | reads ζ | `JensenCount` | ‖jensenF T z‖ ≤ 84 * T |
| [`Stage3.jensenF_order`](./lean_stage3/JensenCount.md#Stage3-jensenF_order) | theorem | reads ζ | `JensenCount` | analyticOrderNatAt (jensenF T) w = analyticOrderNatAt ζ (2 * w + (2 + Complex.I * (T : ℂ))) |
| [`Stage3.jensenF_zero_eq_one`](./lean_stage3/JensenCount.md#Stage3-jensenF_zero_eq_one) | theorem | reads ζ | `JensenCount` | jensenF T 0 = 1 |
| [`Stage3.jensenF_zeros_finite`](./lean_stage3/JensenCount.md#Stage3-jensenF_zeros_finite) | theorem | reads ζ | `JensenCount` | (SetOfZeros 1 (jensenF T)).Finite |
| [`JointLadder.jmode`](./lean/JointLadder.md#JointLadder-jmode) | def | shape | `JointLadder` | ℤ → ℤ → ℂ |
| [`Chain.joint_gain_periodic_of_commensurate`](./lean/Chain.md#Chain-joint_gain_periodic_of_commensurate) | theorem | shape | `Chain` | Function.Periodic (fun γ : ℝ =&gt; ‖Sym b₁ ((1 : ℂ)/2 + γ * I)‖ ^ 2 * ‖Sym b₂ ((1 : ℂ)/2 + γ * I)‖ ^ 2) ((m : ℝ) * (2 * Real.pi / Real.log b₁)) |
| [`JointLadder.JointAliases`](./lean/JointLadder.md#JointLadder-JointAliases) | def | shape | `JointLadder` | Prop |
| [`JointLadder.jointAliases_iff_eq`](./lean/JointLadder.md#JointLadder-jointAliases_iff_eq) | theorem | shape | `JointLadder` | JointAliases γ γ' ↔ γ = γ' |
| [`JointLadder.jointSample`](./lean/JointLadder.md#JointLadder-jointSample) | def | shape | `JointLadder` | ℝ |
| [`WeilPower.K`](./lean_stage3/WeilPower.md#WeilPower-K) | def | shape | `WeilPower` | ℂ |
| [`WeilPower.K_mul_Q`](./lean_stage3/WeilPower.md#WeilPower-K_mul_Q) | theorem | shape | `WeilPower` | K m w * Q m w = (cK m : ℂ) * Complex.sinh w |
| [`WeilPower.K_one_mul`](./lean_stage3/WeilPower.md#WeilPower-K_one_mul) | theorem | shape | `WeilPower` | K 1 w * (w * (w ^ 2 + (Real.pi : ℂ) ^ 2)) = (Real.pi : ℂ) ^ 2 * Complex.sinh w |
| [`WeilPower.K_succ`](./lean_stage3/WeilPower.md#WeilPower-K_succ) | theorem | shape | `WeilPower` | K (m + 1) w * (w ^ 2 + (Real.pi : ℂ) ^ 2 * ((m : ℂ) + 1) ^ 2) = ((m : ℂ) + 1) * (2 * (m : ℂ) + 1) * (Real.pi : ℂ) ^ 2 / 2 * K m w |
| [`WeilPower.K_zero_mul`](./lean_stage3/WeilPower.md#WeilPower-K_zero_mul) | theorem | shape | `WeilPower` | K 0 w * w = 2 * Complex.sinh w |
| [`LeftSmooth.kc`](./lean_stage3/LeftSmooth.md#LeftSmooth-kc) | def | shape | `LeftSmooth` | ℝ |
| [`LeftSmooth.kc_pos`](./lean_stage3/LeftSmooth.md#LeftSmooth-kc_pos) | theorem | shape | `LeftSmooth` | 0 &lt; kc |
| [`LeftKernel.kernel_bound`](./lean_stage3/LeftKernel.md#LeftKernel-kernel_bound) | theorem | shape | `LeftKernel` | ‖∫ t in (-T)..T, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) / ((a:ℂ) + (t:ℂ) * Complex.I)‖ ≤ (2 / T + Real.pi / \|a\|) / Real.log y |
| [`LeftSmooth.kernel_conj`](./lean_stage3/LeftSmooth.md#LeftSmooth-kernel_conj) | theorem | shape | `LeftSmooth` | ‖∫ t in (-T)..T, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) * ((c:ℂ) - (t:ℂ) * Complex.I)⁻¹‖ ≤ (2 + Real.pi) / (c * Real.log y) |
| [`PerronKernel.kernel_diff_summable`](./lean_stage3/PerronKernel.md#PerronKernel-kernel_diff_summable) | theorem | reads ζ | `PerronKernel` | Summable (fun n : ℕ ↦ (ArithmeticFunction.vonMangoldt n : ℂ) * (perronI (x/n) (1 + 1/Real.log x) T - perronδ (x/n))) |
| [`PerronTwo.kernel_diff_summable_two`](./lean_stage3/PerronTwo.md#PerronTwo-kernel_diff_summable_two) | theorem | reads ζ | `PerronTwo` | Summable (fun n : ℕ ↦ (ArithmeticFunction.vonMangoldt n : ℂ) * (perronI (x/n) (1 + 1/Real.log x) T - perronδ (x/n))) |
| [`PerronKernel.kernel_holo`](./lean_stage3/PerronKernel.md#PerronKernel-kernel_holo) | theorem | reads ζ | `PerronKernel` | HolomorphicOn (fun s : ℂ ↦ (y : ℂ) ^ s / s) {s : ℂ \| 0 &lt; s.re} |
| [`LandauKernel.kernel_le`](./lean_stage3/LandauKernel.md#LandauKernel-kernel_le) | theorem | shape | `LandauKernel` | Real.log y ^ n * y ^ (-a - 1) ≤ y ^ (-(a / 2) - 1) / (a / (2 * (n + 1))) ^ n |
| [`RHPull.kernel_le`](./lean_stage3/LineBound.md#RHPull-kernel_le) | theorem | shape | `LineBound` | ((σRH X) ^ 2 + t ^ 2)⁻¹ ≤ 4 * (1 + t ^ 2)⁻¹ |
| [`Stage3.kernel_le_theta`](./lean_stage3/ThetaPull.md#Stage3-kernel_le_theta) | theorem | shape | `ThetaPull` | ((σθ θ X) ^ 2 + t ^ 2)⁻¹ ≤ 4 * (1 + t ^ 2)⁻¹ |
| [`RHPull.kernel_modulus_le`](./lean_stage3/LineBound.md#RHPull-kernel_modulus_le) | theorem | shape | `LineBound` | ‖((x : ℂ)) ^ (w - 1)‖ ≤ 2 |
| [`LandauTail.kernel_nonneg`](./lean_stage3/LandauTail.md#LandauTail-kernel_nonneg) | theorem | shape | `LandauTail` | 0 ≤ᵐ[volume.restrict (Ioi (1 : ℝ))] fun y : ℝ =&gt; Real.log y ^ k * y ^ (-a - 1) |
| [`PerronKernel.kernel_sum_bound`](./lean_stage3/PerronKernel.md#PerronKernel-kernel_sum_bound) | theorem | reads ζ | `PerronKernel` | ‖(∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * (perronI (x/n) (1 + 1/Real.log x) T - perronδ (x/n)))‖ ≤ 600 * x * Real.log (x * T) ^ 2 / T + 12 * Real.log x |
| [`PerronTwo.kernel_sum_bound_two`](./lean_stage3/PerronTwo.md#PerronTwo-kernel_sum_bound_two) | theorem | reads ζ | `PerronTwo` | ‖(∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * (perronI (x/n) (1 + 1/Real.log x) T - perronδ (x/n)))‖ ≤ 700 * x * Real.log (x * T) ^ 2 / T + 17 * Real.log x |
| [`LandauRates.key_ineq`](./lean_stage3/LandauRates.md#LandauRates-key_ineq) | theorem | shape | `LandauRates` | 4 * (lam - Real.log (1 - δ / 12)) &lt; (1 + δ) * (Real.log (1 + δ / 3) - lam) ∧ 0 &lt; Real.log (1 + δ / 3) - lam ∧ 0 &lt; lam - Real.log (1 - δ / 12) |
| [`FilterLadder.Kf`](./lean_stage3/FilterLadder.md#FilterLadder-Kf) | def | reads ζ | `FilterLadder` | ℝ |
| [`FilterLadder.Kf_nonneg`](./lean_stage3/FilterLadder.md#FilterLadder-Kf_nonneg) | theorem | reads ζ | `FilterLadder` | 0 ≤ Kf |
| [`Bridge.kOf`](./lean_bridge/WeilBridge.md#Bridge-kOf) | def | shape | `WeilBridge` | ℝ → ℂ |
| [`Bridge.kOfM`](./lean_bridge/WeilBridge.md#Bridge-kOfM) | def | shape | `WeilBridge` | ℝ → ℂ |
| [`WeilBridgeLeaf.kOfM`](./lean_stage3/WeilBridgeLeaf.md#WeilBridgeLeaf-kOfM) | def | shape | `WeilBridgeLeaf` | ℝ → ℂ |
| [`Bridge.kOfM_eq`](./lean_bridge/WeilBridge.md#Bridge-kOfM_eq) | theorem | shape | `WeilBridge` | kOfM G = kOf G |
| [`FilterLadder.ladder`](./lean_stage3/FilterLadder.md#FilterLadder-ladder) | def | counting | `FilterLadder` | ℂ |
| [`CellResidual.ladder_le`](./lean_stage3/CellResidual.md#CellResidual-ladder_le) | theorem | shape | `CellResidual` | \|resid a (r₀ + (n : ℤ))\| ≤ M + 4 * (\|C\| * (1 + (2 : ℝ) ^ (-(1 : ℝ) / 2))) * ((r₀ : ℝ) + n + 1) * (2 : ℝ) ^ (((r₀ : ℝ) + n) / 2) |
| [`Zeros.LaddersMeet`](./lean/ZerosStencil.md#Zeros-LaddersMeet) | def | counting | `ZerosStencil` | Prop |
| [`Bridge.laplace`](./lean_bridge/WeilBridge.md#Bridge-laplace) | def | shape | `WeilBridge` | ℂ |
| [`WeilDetect.laplace`](./lean_stage3/WeilDetect.md#WeilDetect-laplace) | def | shape | `WeilDetect` | ℂ |
| [`WeilDetect.laplace_conj`](./lean_stage3/WeilDetect.md#WeilDetect-laplace_conj) | theorem | shape | `WeilDetect` | laplace G ((starRingEnd ℂ) z) = (starRingEnd ℂ) (laplace G z) |
| [`Bridge.laplace_neg_eq`](./lean_bridge/WeilBridge.md#Bridge-laplace_neg_eq) | theorem | shape | `WeilBridge` | laplace G (-ρ) = paperFT (tiltF G) (gammaOf ρ) |
| [`WeilBackground.laplace_phi`](./lean_stage3/WeilBackground.md#WeilBackground-laplace_phi) | theorem | shape | `WeilBackground` | laplace (phiC h γ) z = ghat h γ (-z - 1 / 2) |
| [`WeilPowerBackground.laplace_phiW`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-laplace_phiW) | theorem | shape | `WeilPowerBackground` | laplace (phiWC h γ m) z = what h γ m (-z - 1 / 2) |
| [`Bridge.laplace_reflect_eq`](./lean_bridge/WeilBridge.md#Bridge-laplace_reflect_eq) | theorem | shape | `WeilBridge` | laplace G (-(1 - ρ)) = paperFT (tiltF G) (-gammaOf ρ) |
| [`StencilWeil.laplace_shift`](./lean_stage3/StencilWeil.md#StencilWeil-laplace_shift) | theorem | shape | `StencilWeil` | laplace (fun u =&gt; φ (u + a)) z = Complex.exp (z * (a : ℂ)) * laplace φ z |
| [`StencilWeil.laplace_stencilTest`](./lean_stage3/StencilWeil.md#StencilWeil-laplace_stencilTest) | theorem | shape | `StencilWeil` | laplace (stencilTest d φ) z = (1 - (2 : ℂ) ^ z) ^ d * laplace φ z |
| [`Elephant.lattice_step`](./lean/Elephant.md#Elephant-lattice_step) | theorem | shape | `Elephant` | Sym b ((k : ℂ) * (2 * Real.pi * Complex.I / Real.log b)) = 0 ∧ Sym b (((k + 1 : ℤ) : ℂ) * (2 * Real.pi * Complex.I / Real.log b)) = 0 ∧ ((k + 1 : ℤ) : ℂ) * (2 * Real.pi * Complex.I / Real.log b) - (k … |
| [`Transform.latticeBasis`](./lean/Transform.md#Transform-latticeBasis) | def | shape | `Transform` | Module.Basis (Fin 2) ℝ ℂ |
| [`LeftSmooth.left_edge_bound`](./lean_stage3/LeftSmooth.md#LeftSmooth-left_edge_bound) | theorem | reads ζ | `LeftSmooth` | ‖VIntegral (Glue.Gf x) (-1/4) (-T) T‖ ≤ Bleft * x ^ (-(1:ℝ)/4) |
| [`ExplicitTwo.left_edge_bound_two`](./lean_stage3/ExplicitTwo.md#ExplicitTwo-left_edge_bound_two) | theorem | reads ζ | `ExplicitTwo` | ‖VIntegral (Glue.Gf x) (-1/4) (-T) T‖ ≤ Bleft2 * x ^ (-(1:ℝ)/4) |
| [`Stage3.Li`](./lean_stage3/PsiToPi.md#Stage3-Li) | def | shape | `PsiToPi` | ℝ |
| [`PiToPsi.Li_mul_log_sub_integral`](./lean_stage3/PiToPsi.md#PiToPsi-Li_mul_log_sub_integral) | theorem | shape | `PiToPsi` | Stage3.Li x * Real.log x - ∫ t in (2 : ℝ)..x, Stage3.Li t / t = x |
| [`PiToPsi.Li_two`](./lean_stage3/PiToPsi.md#PiToPsi-Li_two) | theorem | shape | `PiToPsi` | Stage3.Li 2 = 2 / Real.log 2 |
| [`Stage3.Li_two_rpow`](./lean_stage3/RowLeaves.md#Stage3-Li_two_rpow) | theorem | shape | `RowLeaves` | Li ((2 : ℝ) ^ x) = 2 / Real.log 2 + ∫ t in (1 : ℝ)..x, Real.exp (Real.log 2 * t) / t |
| [`LadderFading.line_not_fading`](./lean_stage3/LadderFading.md#LadderFading-line_not_fading) | theorem | reads ζ | `LadderFading` | ¬ Tendsto (fun r : ℕ =&gt; (∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (((r : ℤ)) : ℂ)) / ((((2 : ℝ) ^ β : ℝ)) : ℂ) ^ r) atTop (𝓝 0) |
| [`LadderMean.line_not_fading_summable`](./lean_stage3/LadderMean.md#LadderMean-line_not_fading_summable) | theorem | reads ζ | `LadderMean` | ¬ Tendsto (fun r : ℕ =&gt; (∑' ρ : S, coef ρ * Chain.Sym 2 ((ρ : Kadiri.NontrivialZeros) : ℂ) ^ d * Chain.mode 2 ((ρ : Kadiri.NontrivialZeros) : ℂ) (((r : ℤ)) : ℂ)) / ((((2 : ℝ) ^ β : ℝ)) : ℂ) ^ r) atTop… |
| [`AttainedPi.lineSet`](./lean_stage3/AttainedPi.md#AttainedPi-lineSet) | def | reads ζ | `AttainedPi` | Set NontrivialZeros |
| [`Interpolant.liRow`](./lean/Interpolant.md#Interpolant-liRow) | def | shape | `Interpolant` | ℝ |
| [`Interpolant.liRow_contDiff`](./lean/Interpolant.md#Interpolant-liRow_contDiff) | theorem | shape | `Interpolant` | ContDiff ℝ (⊤ : ℕ∞) liRow |
| [`Interpolant.liRow_eq`](./lean/Interpolant.md#Interpolant-liRow_eq) | theorem | shape | `Interpolant` | liRow x = 2 / Real.log 2 + ∫ t in (1 : ℝ)..x, Expansion.f2x t |
| [`Interpolant.liRow_hasDerivAt`](./lean/Interpolant.md#Interpolant-liRow_hasDerivAt) | theorem | shape | `Interpolant` | HasDerivAt liRow (Expansion.f2x x) x |
| [`WeilLobe.lobe_bound`](./lean_stage3/WeilLobe.md#WeilLobe-lobe_bound) | theorem | shape | `WeilLobe` | ‖SigmaC (((ε : ℂ) + 2 * Complex.I * (γ : ℂ)) * (h : ℂ))‖ ≤ (2 * Real.pi + Real.pi ^ 2) * Real.cosh (ε * h) / (2 * γ * h) ^ 2 |
| [`Stage3.localCount_holds`](./lean_stage3/JensenCount.md#Stage3-localCount_holds) | theorem | reads ζ | `JensenCount` | StmtLocalCount zetaLocalCount 15 73 |
| [`Slice4.log_1300_le`](./lean_stage3/LineBound.md#Slice4-log_1300_le) | theorem | shape | `LineBound` | Real.log 1300 ≤ 7.28 |
| [`Slice3.log_3029_ge`](./lean_stage3/LineBound.md#Slice3-log_3029_ge) | theorem | shape | `LineBound` | (1:ℝ)/30 ≤ Real.log (30/29) |
| [`JointDialGate.log_absorbed`](./lean_stage3/JointDialGate.md#JointDialGate-log_absorbed) | theorem | shape | `JointDialGate` | C * x ^ θ * Real.log x ^ k ≤ C / (2 * (θ' - θ) / (2 * ((k : ℝ) + 1))) ^ k * x ^ θ' |
| [`LandauMellinG.log_cpow_integrable`](./lean_stage3/LandauMellinG.md#LandauMellinG-log_cpow_integrable) | theorem | shape | `LandauMellinG` | IntegrableOn (fun y : ℝ =&gt; (Real.log y : ℂ) * (y : ℂ) ^ (-s)) (Ioi 1) |
| [`LandauMellinG.log_cpow_integral`](./lean_stage3/LandauMellinG.md#LandauMellinG-log_cpow_integral) | theorem | shape | `LandauMellinG` | ∫ y in Ioi (1 : ℝ), (Real.log y : ℂ) * (y : ℂ) ^ (-s) = 1 / (s - 1) ^ 2 |
| [`LandauMellinG.log_cpow_norm_le`](./lean_stage3/LandauMellinG.md#LandauMellinG-log_cpow_norm_le) | theorem | shape | `LandauMellinG` | ‖(Real.log y : ℂ) * (y : ℂ) ^ (-s)‖ ≤ y ^ ((s.re - 1) / 2 - s.re) / ((s.re - 1) / 2) |
| [`LandauChebyshev.log_four_lt_two`](./lean_stage3/LandauChebyshev.md#LandauChebyshev-log_four_lt_two) | theorem | shape | `LandauChebyshev` | Real.log 4 &lt; 2 |
| [`DirichletMean.log_gap`](./lean_stage3/DirichletMean.md#DirichletMean-log_gap) | theorem | shape | `DirichletMean` | ((m : ℝ) - n) / N ≤ Real.log m - Real.log n |
| [`DirichletMeanW.log_gap_larger`](./lean_stage3/DirichletMeanW.md#DirichletMeanW-log_gap_larger) | theorem | shape | `DirichletMeanW` | ((q : ℝ) - p) / q ≤ Real.log q - Real.log p |
| [`JointLadder.log_indep`](./lean/JointLadder.md#JointLadder-log_indep) | theorem | shape | `JointLadder` | l = 0 ∧ k = 0 |
| [`Stage3.log_norm_z_le`](./lean_stage3/Stirling.md#Stage3-log_norm_z_le) | theorem | shape | `Stirling` | \|Real.log ‖(1 : ℂ) / 4 + (t : ℂ) / 2 * Complex.I‖ - Real.log (t / 2)\| ≤ 1 / (4 * t) |
| [`LandauKernel.log_pow_integrable`](./lean_stage3/LandauKernel.md#LandauKernel-log_pow_integrable) | theorem | shape | `LandauKernel` | IntegrableOn (fun y : ℝ =&gt; Real.log y ^ n * y ^ (-a - 1)) (Ioi 1) |
| [`LandauKernel.log_pow_integral`](./lean_stage3/LandauKernel.md#LandauKernel-log_pow_integral) | theorem | shape | `LandauKernel` | ∫ y in Ioi (1 : ℝ), Real.log y ^ k * y ^ (-a - 1) = k.factorial / a ^ (k + 1) |
| [`Stage3.log_pow_isBigO_rpow`](./lean_stage3/ThetaConverse.md#Stage3-log_pow_isBigO_rpow) | theorem | shape | `ThetaConverse` | (fun t : ℝ ↦ (Real.log t) ^ k) =O[Filter.atTop] (fun t : ℝ ↦ t ^ δ) |
| [`LandauKernel.log_pow_le`](./lean_stage3/LandauKernel.md#LandauKernel-log_pow_le) | theorem | shape | `LandauKernel` | Real.log y ^ n ≤ y ^ (a / 2) / (a / (2 * (n + 1))) ^ n |
| [`WeilPowerGeom.log_step`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-log_step) | theorem | shape | `WeilPowerGeom` | 1 / ((m : ℝ) + 1) ≤ Real.log ((m : ℝ) + 1) - Real.log m |
| [`WeilPowerGeom.log_telescope`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-log_telescope) | theorem | shape | `WeilPowerGeom` | ∀ b : ℕ, a ≤ b → ∑ m ∈ Finset.Ico a b, 1 / ((m : ℝ) + 1) ≤ Real.log b - Real.log a |
| [`Stage3.log_two_pi_le`](./lean_stage3/ZeroSum.md#Stage3-log_two_pi_le) | theorem | shape | `ZeroSum` | Real.log (2 * Real.pi) ≤ 2 |
| [`Stage3.logDeriv_congr_of_eventuallyEq`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_congr_of_eventuallyEq) | theorem | shape | `ArgIdentity` | logDeriv f x = logDeriv g x |
| [`Stage3.logDeriv_gammaR`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR) | theorem | shape | `ArgIdentity` | logDeriv Gammaℝ s = -(Real.log Real.pi : ℂ) / 2 + Complex.digamma (s / 2) / 2 |
| [`Stage3.logDeriv_gammaR_analyticAt`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR_analyticAt) | theorem | shape | `ArgIdentity` | AnalyticAt ℂ (logDeriv Gammaℝ) z |
| [`Stage3.logDeriv_gammaR_comp_continuous`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR_comp_continuous) | theorem | shape | `ArgIdentity` | Continuous fun x : ℝ =&gt; logDeriv Gammaℝ (g x) |
| [`Stage3.logDeriv_gammaR_conj`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR_conj) | theorem | reads ζ | `ArgIdentity` | logDeriv Gammaℝ (conj s) = conj (logDeriv Gammaℝ s) |
| [`Stage3.logDeriv_gammaR_continuousAt`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR_continuousAt) | theorem | shape | `ArgIdentity` | ContinuousAt (logDeriv Gammaℝ) z |
| [`Stage3.logDeriv_gammaR_holo`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR_holo) | theorem | reads ζ | `ArgIdentity` | HolomorphicOn (logDeriv Gammaℝ) {s : ℂ \| 0 &lt; s.re} |
| [`Stage3.logDeriv_gammaR_im_eq_zero`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR_im_eq_zero) | theorem | reads ζ | `ArgIdentity` | (logDeriv Gammaℝ ((x : ℝ) : ℂ)).im = 0 |
| [`ExplicitTwo.logDeriv_good_ext`](./lean_stage3/ExplicitTwo.md#ExplicitTwo-logDeriv_good_ext) | theorem | reads ζ | `ExplicitTwo` | ∀ T T' : ℝ, 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 &lt; ρ.re → ContourShift.zeroGap T ≤ \|ρ.im - T'\|) → ∀ u : ℂ, \|u.im\| = T' → -1/4 ≤ u.re → u.re ≤ 5/2 → ‖deriv riemannZeta u / rie… |
| [`ExplicitTwo.logDeriv_re_ge_two`](./lean_stage3/ExplicitTwo.md#ExplicitTwo-logDeriv_re_ge_two) | theorem | reads ζ | `ExplicitTwo` | ‖deriv riemannZeta u / riemannZeta u‖ ≤ 6 |
| [`LeftSmooth.logDeriv_sum`](./lean_stage3/LeftSmooth.md#LeftSmooth-logDeriv_sum) | theorem | reads ζ | `LeftSmooth` | riemannZeta (1 - w) ≠ 0 ∧ deriv riemannZeta (1 - w) / riemannZeta (1 - w) + deriv riemannZeta w / riemannZeta w = Gs w |
| [`Stage3.logDeriv_xi_conj`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_xi_conj) | theorem | reads ζ | `ArgIdentity` | logDeriv xi (conj s) = conj (logDeriv xi s) |
| [`Stage3.logDeriv_xi_continuousAt`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_xi_continuousAt) | theorem | reads ζ | `ArgIdentity` | ContinuousAt (logDeriv xi) p |
| [`Stage3.logDeriv_xi_meromorphicAt`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_xi_meromorphicAt) | theorem | reads ζ | `ArgIdentity` | MeromorphicAt (logDeriv xi) s |
| [`Stage3.logDeriv_xi_one_sub`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_xi_one_sub) | theorem | reads ζ | `ArgIdentity` | logDeriv xi (1 - s) = -logDeriv xi s |
| [`Stage3.logDeriv_xi_split`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_xi_split) | theorem | reads ζ | `ArgIdentity` | logDeriv xi s = 1 / s + 1 / (s - 1) + logDeriv Gammaℝ s + logDeriv riemannZeta s |
| [`Stage3.logDeriv_zeta_analyticAt`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_zeta_analyticAt) | theorem | reads ζ | `ArgIdentity` | AnalyticAt ℂ (logDeriv riemannZeta) z |
| [`Elephant.logDeriv_zeta_coeffs`](./lean/Elephant.md#Elephant-logDeriv_zeta_coeffs) | theorem | reads ζ | `Elephant` | LSeries (fun n =&gt; (vonMangoldt n : ℂ)) s = -deriv riemannZeta s / riemannZeta s |
| [`Stage3.logDeriv_zeta_continuousAt`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_zeta_continuousAt) | theorem | reads ζ | `ArgIdentity` | ContinuousAt (logDeriv riemannZeta) z |
| [`Slice4.logDeriv_zetaE`](./lean_stage3/LineBound.md#Slice4-logDeriv_zetaE) | theorem | reads ζ | `LineBound` | deriv zetaE s / zetaE s = 1 / (s - 1) + deriv ζ s / ζ s |
| [`Slice4.logDerivZeta_compact`](./lean_stage3/LineBound.md#Slice4-logDerivZeta_compact) | theorem | reads ζ | `LineBound` | ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖ ≤ 14535 + 212 / (σ₁ - 1/2) |
| [`Stage3.logDerivZeta_compact_theta`](./lean_stage3/ThetaLine.md#Stage3-logDerivZeta_compact_theta) | theorem | reads ζ | `ThetaLine` | ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖ ≤ 14530 + 2 / (1 - θ) + 212 / (σ₁ - θ) |
| [`Slice3.logDerivZeta_crude`](./lean_stage3/LineBound.md#Slice3-logDerivZeta_crude) | theorem | reads ζ | `LineBound` | ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖ ≤ 1996 * Real.log (84 * t) + (29 * Real.log t + 129) / (σ₁ - 1/2) |
| [`Stage3.logDerivZeta_crude_half`](./lean_stage3/Abscissa.md#Stage3-logDerivZeta_crude_half) | theorem | reads ζ | `Abscissa` | ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖ ≤ 1996 * Real.log (84 * t) + (29 * Real.log t + 129) / (σ₁ - 1/2) |
| [`Stage3.logDerivZeta_crude_theta`](./lean_stage3/Abscissa.md#Stage3-logDerivZeta_crude_theta) | theorem | reads ζ | `Abscissa` | ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖ ≤ 1996 * Real.log (84 * t) + (29 * Real.log t + 129) / (σ₁ - θ) |
| [`Slice4b.logDerivZeta_line`](./lean_stage3/LineBound.md#Slice4b-logDerivZeta_line) | theorem | reads ζ | `LineBound` | ‖deriv ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ)) / ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))‖ ≤ 11100 * (Real.log X) ^ 2 |
| [`Stage3.logDerivZeta_line_half`](./lean_stage3/ThetaLine.md#Stage3-logDerivZeta_line_half) | theorem | reads ζ | `ThetaLine` | ‖deriv ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ)) / ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))‖ ≤ 11100 * (Real.log X) ^ 2 |
| [`Stage3.logDerivZeta_line_theta`](./lean_stage3/ThetaLine.md#Stage3-logDerivZeta_line_theta) | theorem | reads ζ | `ThetaLine` | ‖deriv ζ (((θ + 1/Real.log X : ℝ)) + I * (t : ℂ)) / ζ (((θ + 1/Real.log X : ℝ)) + I * (t : ℂ))‖ ≤ 11100 * (Real.log X) ^ 2 |
| [`EdgeBound.logDerivZeta_low_edge`](./lean_stage3/LowEdge.md#EdgeBound-logDerivZeta_low_edge) | theorem | reads ζ | `LowEdge` | ‖deriv riemannZeta u / riemannZeta u‖ ≤ 1620000 |
| [`Slice4b.logDerivZeta_norm_neg`](./lean_stage3/LineBound.md#Slice4b-logDerivZeta_norm_neg) | theorem | reads ζ | `LineBound` | ‖deriv ζ ((σ : ℂ) + I * ((-t : ℝ) : ℂ)) / ζ ((σ : ℂ) + I * ((-t : ℝ) : ℂ))‖ = ‖deriv ζ ((σ : ℂ) + I * (t : ℂ)) / ζ ((σ : ℂ) + I * (t : ℂ))‖ |
| [`EdgeBound.logDerivZeta_short_segment`](./lean_stage3/LowEdge.md#EdgeBound-logDerivZeta_short_segment) | theorem | reads ζ | `LowEdge` | ‖deriv riemannZeta (((-1/4 : ℝ):ℂ) + t * Complex.I) / riemannZeta (((-1/4 : ℝ):ℂ) + t * Complex.I)‖ ≤ 1620000 |
| [`Slice3.logDerivZeta_sq_at_t`](./lean_stage3/LineBound.md#Slice3-logDerivZeta_sq_at_t) | theorem | reads ζ | `LineBound` | ‖deriv ζ (((1/2 + 1/Real.log t : ℝ)) + I * (t : ℂ)) / ζ (((1/2 + 1/Real.log t : ℝ)) + I * (t : ℂ))‖ ≤ 21600 * (Real.log t) ^ 2 |
| [`Slice3.logDerivZeta_sq_at_X`](./lean_stage3/LineBound.md#Slice3-logDerivZeta_sq_at_X) | theorem | reads ζ | `LineBound` | ‖deriv ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ)) / ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))‖ ≤ 11100 * (Real.log X) ^ 2 |
| [`Stage3.logDerivZeta_sq_at_X_theta`](./lean_stage3/ThetaLine.md#Stage3-logDerivZeta_sq_at_X_theta) | theorem | reads ζ | `ThetaLine` | ‖deriv ζ (((θ + 1/Real.log X : ℝ)) + I * (t : ℂ)) / ζ (((θ + 1/Real.log X : ℝ)) + I * (t : ℂ))‖ ≤ 11100 * (Real.log X) ^ 2 |
| [`LandauMellinG.logPrim`](./lean_stage3/LandauMellinG.md#LandauMellinG-logPrim) | def | shape | `LandauMellinG` | ℂ |
| [`MirrorArea.long_side_of_off_line`](./lean_stage3/MirrorArea.md#MirrorArea-long_side_of_off_line) | theorem | shape | `MirrorArea` | Real.sqrt b &lt; max ‖(b : ℂ) ^ ρ‖ ‖(b : ℂ) ^ (1 - ρ)‖ |
| [`EdgeBound.low_ball_count`](./lean_stage3/LowCount.md#EdgeBound-low_ball_count) | theorem | reads ζ | `LowCount` | (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0 : ℝ) ≤ 8 / 5)).toFinset, (analyticOrderNatAt gz w : ℝ)) ≤ 119 |
| [`EdgeBound.low_ball_count_wide`](./lean_stage3/LowEdge.md#EdgeBound-low_ball_count_wide) | theorem | reads ζ | `LowEdge` | (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0 : ℝ) ≤ 46 / 25)).toFinset, (analyticOrderNatAt gz w : ℝ)) ≤ 250 |
| [`EdgeBound.low_rect_count`](./lean_stage3/LowCount.md#EdgeBound-low_rect_count) | theorem | reads ζ | `LowCount` | (∑ ρ ∈ (ContourShift.zeta_zeros_rectangle_finite (0 : ℂ) ((1 : ℝ) + Complex.I * (6 : ℝ))).toFinset, (analyticOrderNatAt riemannZeta ρ : ℝ)) ≤ 714 |
| [`WeilOnLine.lowCount`](./lean_stage3/WeilOnLine.md#WeilOnLine-lowCount) | def | reads ζ | `WeilOnLine` | ℝ |
| [`WeilOnLine.lowCount_nonneg`](./lean_stage3/WeilOnLine.md#WeilOnLine-lowCount_nonneg) | theorem | reads ζ | `WeilOnLine` | 0 ≤ lowCount |
| [`LandauTail.lower_tail_le`](./lean_stage3/LandauTail.md#LandauTail-lower_tail_le) | theorem | shape | `LandauTail` | ∫ y in Ioc (1 : ℝ) Y, Real.log y ^ k * y ^ (-a - 1) ≤ Y ^ b * (k.factorial / (a + b) ^ (k + 1)) |
| [`WeilOnLine.lowSet`](./lean_stage3/WeilOnLine.md#WeilOnLine-lowSet) | def | reads ζ | `WeilOnLine` | Set ℂ |
| [`WeilOnLine.lowSet_finite`](./lean_stage3/WeilOnLine.md#WeilOnLine-lowSet_finite) | theorem | reads ζ | `WeilOnLine` | lowSet.Finite |
| [`WeilOnLine.lowU`](./lean_stage3/WeilOnLine.md#WeilOnLine-lowU) | def | shape | `WeilOnLine` | Set ℂ |
| [`WeilOnLine.lowU_analytic`](./lean_stage3/WeilOnLine.md#WeilOnLine-lowU_analytic) | theorem | reads ζ | `WeilOnLine` | AnalyticOnNhd ℂ riemannZeta lowU |
| [`WeilOnLine.lowU_preconnected`](./lean_stage3/WeilOnLine.md#WeilOnLine-lowU_preconnected) | theorem | shape | `WeilOnLine` | IsPreconnected lowU |
| [`LandauMellinG.LSeries_vonMangoldt_real_ne_zero`](./lean_stage3/LandauMellinG.md#LandauMellinG-LSeries_vonMangoldt_real_ne_zero) | theorem | reads ζ | `LandauMellinG` | L ↗Λ (σ : ℂ) ≠ 0 |
| [`Stage3.lt_σθ`](./lean_stage3/ThetaPsi.md#Stage3-lt_--) | theorem | shape | `ThetaPsi` | θ &lt; σθ θ X |
| [`MollifiedMean.M`](./lean_stage3/MollifiedMean.md#MollifiedMean-M) | def | shape | `MollifiedMean` | ℂ |
| [`WeilPowerBands.M`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-M) | def | shape | `WeilPowerBands` | ℝ |
| [`WeilSeries.M`](./lean_stage3/WeilSeries.md#WeilSeries-M) | def | shape | `WeilSeries` | ℝ |
| [`WeilWindow.m2`](./lean_stage3/WeilWindow.md#WeilWindow-m2) | def | shape | `WeilWindow` | ℝ |
| [`WeilWindow.m2_ge`](./lean_stage3/WeilWindow.md#WeilWindow-m2_ge) | theorem | shape | `WeilWindow` | 1 / 24 ≤ m2 |
| [`WeilWindow.m2_le`](./lean_stage3/WeilWindow.md#WeilWindow-m2_le) | theorem | shape | `WeilWindow` | m2 ≤ 2 / 3 |
| [`WeilPowerBands.M_nonneg`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-M_nonneg) | theorem | shape | `WeilPowerBands` | 0 ≤ M h γ m k |
| [`WeilSeries.M_nonneg`](./lean_stage3/WeilSeries.md#WeilSeries-M_nonneg) | theorem | shape | `WeilSeries` | 0 ≤ M h γ k |
| [`WeilPowerGeom.Mab`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-Mab) | def | shape | `WeilPowerGeom` | ℝ |
| [`WeilPowerGeomGen.MabGen`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-MabGen) | def | shape | `WeilPowerGeomGen` | ℝ |
| [`WeilPowerShell.MabGen_le`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-MabGen_le) | theorem | shape | `WeilPowerShell` | WeilPowerGeomGen.MabGen (zOf e' D e) (1 / ((lam : ℝ) * Real.pi ^ 2)) (-1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) a b ≤ Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) |
| [`ArgCount.mainTerm_abs_le`](./lean_stage3/ArgCount.md#ArgCount-mainTerm_abs_le) | theorem | reads ζ | `ArgCount` | \|Kadiri.zetaCountingMainTerm T\| ≤ 3 |
| [`LadderMean.mean_extract`](./lean_stage3/LadderMean.md#LadderMean-mean_extract) | theorem | shape | `LadderMean` | ∑' i, (if w i = w k then C i else 0) = 0 |
| [`MollifiedMean.mean_sq_f_le`](./lean_stage3/MollifiedMean.md#MollifiedMean-mean_sq_f_le) | theorem | reads ζ | `MollifiedMean` | ∫ t in (1:ℝ)..T, ‖f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2 ≤ 3 * (T * (2 / (1 - (2:ℝ) ^ (1 - 2 * u))) * (X:ℝ) ^ (1 - 2 * u) * (1 + Real.log X) ^ 3 + 24 * (1 + Real.log ((N * X : ℕ) : ℝ)) ^ 2 * (1 + Re… |
| [`MollifiedMean.mean_sq_main_le`](./lean_stage3/MollifiedMean.md#MollifiedMean-mean_sq_main_le) | theorem | shape | `MollifiedMean` | ∫ t in (1:ℝ)..T, ‖∑ n ∈ Icc 1 (N * X), (b X N n : ℂ) * (n : ℂ) ^ (-((u : ℂ) + Complex.I * (t : ℂ)))‖ ^ 2 ≤ T * (2 / (1 - (2:ℝ) ^ (1 - 2 * u))) * (X:ℝ) ^ (1 - 2 * u) * (1 + Real.log X) ^ 3 + 24 * (1 + … |
| [`ZetaEM.measurable_bern`](./lean_stage3/ZetaEM.md#ZetaEM-measurable_bern) | theorem | reads ζ | `ZetaEM` | Measurable (fun x : ℝ ↦ bernoulliFun k (Int.fract x)) |
| [`VonKoch.measurable_psi`](./lean_stage3/VonKochScaffold.md#VonKoch-measurable_psi) | theorem | reads ζ | `VonKochScaffold` | Measurable (fun t : ℝ ↦ ψ t) |
| [`VonKoch.measurable_psi'`](./lean_stage3/VonKochScaffold.md#VonKoch-measurable_psi-) | theorem | reads ζ | `VonKochScaffold` | Measurable (fun t : ℝ ↦ ψ t) |
| [`GeneratorPeak.measured`](./lean/GeneratorPeak.md#GeneratorPeak-measured) | def | shape | `GeneratorPeak` | List ℝ |
| [`Measured.measured_breakdown_prime`](./lean/Measured.md#Measured-measured_breakdown_prime) | def | counting | `Measured` | ℕ |
| [`Measured.measured_breakdown_resid`](./lean/Measured.md#Measured-measured_breakdown_resid) | def | counting | `Measured` | ℕ |
| [`Zeros.measured_centered_zero_count`](./lean/Zeros.md#Zeros-measured_centered_zero_count) | def | counting | `Zeros` | ℕ |
| [`SeedPerturbation.measured_composite`](./lean/SeedPerturbation.md#SeedPerturbation-measured_composite) | def | counting | `SeedPerturbation` | List ℤ |
| [`PairIdentity.measured_composite_at_zeros`](./lean/PairIdentity.md#PairIdentity-measured_composite_at_zeros) | def | counting | `PairIdentity` | List ℤ |
| [`SeedPerturbation.measured_composite_four`](./lean/SeedPerturbation.md#SeedPerturbation-measured_composite_four) | def | counting | `SeedPerturbation` | List ℤ |
| [`PairIdentity.measured_composite_matches_pair_identity`](./lean/PairIdentity.md#PairIdentity-measured_composite_matches_pair_identity) | theorem | counting | `PairIdentity` | zero_cells.map (fun c =&gt; ((2 : ℤ) - 1) ^ (c.2 + 1) * 2 ^ (c.1 - 1 - c.2)) = measured_composite_at_zeros |
| [`SeedPerturbation.measured_composite_silence46`](./lean/SeedPerturbation.md#SeedPerturbation-measured_composite_silence46) | def | counting | `SeedPerturbation` | List ℤ |
| [`Covering.measured_contributing`](./lean/Covering.md#Covering-measured_contributing) | def | counting | `Covering` | ℕ |
| [`Measured.measured_contributing_primes`](./lean/Measured.md#Measured-measured_contributing_primes) | def | counting | `Measured` | ℕ |
| [`Measured.measured_elliptic_max_dev`](./lean/Measured.md#Measured-measured_elliptic_max_dev) | def | shape | `Measured` | ℝ |
| [`SeedPerturbation.measured_emptied_four`](./lean/SeedPerturbation.md#SeedPerturbation-measured_emptied_four) | def | counting | `SeedPerturbation` | List ℤ |
| [`SeedPerturbation.measured_emptied_matches_shift`](./lean/SeedPerturbation.md#SeedPerturbation-measured_emptied_matches_shift) | theorem | counting | `SeedPerturbation` | [1 - tableFrom emptied_excess 2 1, 4 - tableFrom emptied_excess 4 1, 16 - tableFrom emptied_excess 8 3, 8192 - tableFrom emptied_excess 20 6] = measured_emptied_four |
| [`Covering.measured_eps`](./lean/Covering.md#Covering-measured_eps) | def | shape | `Covering` | ℝ |
| [`Measured.measured_exact_zeros`](./lean/Measured.md#Measured-measured_exact_zeros) | def | counting | `Measured` | List (ℕ × ℕ) |
| [`Measured.measured_G4_peak`](./lean/Measured.md#Measured-measured_G4_peak) | def | shape | `Measured` | List ℝ |
| [`GeneratorPeak.measured_has_interior_peak`](./lean/GeneratorPeak.md#GeneratorPeak-measured_has_interior_peak) | theorem | shape | `GeneratorPeak` | (23.628706 : ℝ) &lt; 38.299307 ∧ (27.061132 : ℝ) &lt; 38.299307 |
| [`Covering.measured_in_support`](./lean/Covering.md#Covering-measured_in_support) | def | counting | `Covering` | ℕ |
| [`Measured.measured_offset_resid`](./lean/Measured.md#Measured-measured_offset_resid) | def | shape | `Measured` | ℝ |
| [`Measured.measured_offset_smooth`](./lean/Measured.md#Measured-measured_offset_smooth) | def | shape | `Measured` | ℝ |
| [`Measured.measured_radius_resid`](./lean/Measured.md#Measured-measured_radius_resid) | def | shape | `Measured` | ℝ |
| [`Measured.measured_radius_smooth`](./lean/Measured.md#Measured-measured_radius_smooth) | def | shape | `Measured` | ℝ |
| [`Measured.measured_rank_11a1`](./lean/Measured.md#Measured-measured_rank_11a1) | def | shape | `Measured` | ℝ |
| [`Measured.measured_rank_37a1`](./lean/Measured.md#Measured-measured_rank_37a1) | def | shape | `Measured` | ℝ |
| [`Measured.measured_rank_389a1`](./lean/Measured.md#Measured-measured_rank_389a1) | def | shape | `Measured` | ℝ |
| [`Zeros.measured_repeat_20_6`](./lean/Zeros.md#Zeros-measured_repeat_20_6) | def | counting | `Zeros` | ℤ |
| [`Zeros.measured_repeat_8_3`](./lean/Zeros.md#Zeros-measured_repeat_8_3) | def | counting | `Zeros` | ℤ |
| [`Measured.measured_residual_from_zeros`](./lean/Measured.md#Measured-measured_residual_from_zeros) | def | shape | `Measured` | List ℝ |
| [`Isogeny.measured_row_eight`](./lean/Isogeny.md#Isogeny-measured_row_eight) | theorem | counting | `Isogeny` | (List.range 6).map (rowN Zeros.pi2 3) = [4, 14, 79, 467, 2948, 19488] |
| [`Isogeny.measured_row_four`](./lean/Isogeny.md#Isogeny-measured_row_four) | theorem | counting | `Isogeny` | (List.range 10).map (rowN Zeros.pi2 2) = [2, 4, 12, 36, 118, 392, 1336, 4642, 16458, 59025] |
| [`SeedPerturbation.measured_silence46_matches_shift`](./lean/SeedPerturbation.md#SeedPerturbation-measured_silence46_matches_shift) | theorem | counting | `SeedPerturbation` | [4 - tableFrom silence46_excess 4 1, 16 - tableFrom silence46_excess 8 3, 8192 - tableFrom silence46_excess 20 6] = measured_composite_silence46 |
| [`Covering.measured_spacing`](./lean/Covering.md#Covering-measured_spacing) | def | shape | `Covering` | ℝ |
| [`Measured.measured_weil_arithmetic`](./lean/Measured.md#Measured-measured_weil_arithmetic) | def | shape | `Measured` | ℝ |
| [`Measured.measured_weil_spectral`](./lean/Measured.md#Measured-measured_weil_spectral) | def | shape | `Measured` | ℝ |
| [`Construction.measured_zeros`](./lean/Construction.md#Construction-measured_zeros) | def | counting | `Construction` | List (ℕ × ℕ) |
| [`Zeros.measured_zeros`](./lean/Zeros.md#Zeros-measured_zeros) | def | counting | `Zeros` | List (ℕ × ℕ) |
| [`Zeros.measured_zeros_all_vanish`](./lean/Zeros.md#Zeros-measured_zeros_all_vanish) | theorem | counting | `Zeros` | ∀ c ∈ measured_zeros, Construction.tableFrom dyadicRow (c.1 : ℤ) c.2 = 0 |
| [`RHPull.mellin_bump_bounded`](./lean_stage3/LineBound.md#RHPull-mellin_bump_bounded) | theorem | shape | `LineBound` | ∃ B &gt; 0, ∀ w : ℂ, 0 &lt; w.re → w.re ≤ 2 → ‖mellin (fun x ↦ (ν x : ℂ)) w‖ ≤ B |
| [`JointSymbol.mellin_dd`](./lean_stage3/JointSymbol.md#JointSymbol-mellin_dd) | theorem | shape | `JointSymbol` | (∀ y : ℝ, y ≤ 1 → dd f y = 0) ∧ IntegrableOn (fun y : ℝ =&gt; dd f y * (y : ℂ) ^ (-s - 1)) (Ioi 1) ∧ ∫ y in Ioi (1 : ℝ), dd f y * (y : ℂ) ^ (-s - 1) = (1 - (2 : ℂ) ^ (-s)) * ∫ y in Ioi (1 : ℝ), f y * (y … |
| [`JointSymbol.mellin_dd_iter`](./lean_stage3/JointSymbol.md#JointSymbol-mellin_dd_iter) | theorem | reads ζ | `JointSymbol` | ∫ y in Ioi (1 : ℝ), (dd^[d] cutG) y * (y : ℂ) ^ (-s - 1) = (1 - (2 : ℂ) ^ (-s)) ^ d * LandauMellinG.Phi s |
| [`JointSymbol.mellin_dd_iter_aux`](./lean_stage3/JointSymbol.md#JointSymbol-mellin_dd_iter_aux) | theorem | shape | `JointSymbol` | (∀ y : ℝ, y ≤ 1 → (dd^[d] f) y = 0) ∧ IntegrableOn (fun y : ℝ =&gt; (dd^[d] f) y * (y : ℂ) ^ (-s - 1)) (Ioi 1) ∧ ∫ y in Ioi (1 : ℝ), (dd^[d] f) y * (y : ℂ) ^ (-s - 1) = (1 - (2 : ℂ) ^ (-s)) ^ d * ∫ y in … |
| [`LandauMellinG.mellin_G`](./lean_stage3/LandauMellinG.md#LandauMellinG-mellin_G) | theorem | reads ζ | `LandauMellinG` | ∫ y in Ioi (1 : ℝ), (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1) = Phi s |
| [`RHPull.mellin_horiz_le`](./lean_stage3/LineBound.md#RHPull-mellin_horiz_le) | theorem | reads ζ | `LineBound` | ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) + I * (T : ℂ))‖ ≤ B / T |
| [`RHPull.mellin_horiz_le_neg`](./lean_stage3/LineBound.md#RHPull-mellin_horiz_le_neg) | theorem | reads ζ | `LineBound` | ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) - (T : ℂ) * I)‖ ≤ B / T |
| [`RHPull.mellin_main_const`](./lean_stage3/LineBound.md#RHPull-mellin_main_const) | theorem | reads ζ | `LineBound` | ∃ Cmain &gt; 0, ∃ ε₀ &gt; 0, ∀ ε : ℝ, 0 &lt; ε → ε &lt; ε₀ → ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 - 1‖ ≤ Cmain * ε |
| [`LandauMellin.mellin_rampSum`](./lean_stage3/LandauMellin.md#LandauMellin-mellin_rampSum) | theorem | reads ζ | `LandauMellin` | ∫ y in Ioi (1 : ℝ), (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1) = -deriv riemannZeta s / riemannZeta s / (s * (s - 1)) |
| [`JointSymbol.mellin_shift`](./lean_stage3/JointSymbol.md#JointSymbol-mellin_shift) | theorem | shape | `JointSymbol` | IntegrableOn (fun y : ℝ =&gt; f (y / 2) * (y : ℂ) ^ (-s - 1)) (Ioi 1) ∧ ∫ y in Ioi (1 : ℝ), f (y / 2) * (y : ℂ) ^ (-s - 1) = (2 : ℂ) ^ (-s) * ∫ y in Ioi (1 : ℝ), f y * (y : ℂ) ^ (-s - 1) |
| [`RHPull.mellin_smooth1_le`](./lean_stage3/LineBound.md#RHPull-mellin_smooth1_le) | theorem | reads ζ | `LineBound` | ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) s‖ ≤ B * ‖s‖⁻¹ |
| [`RHPull.mellin_vert_le`](./lean_stage3/LineBound.md#RHPull-mellin_vert_le) | theorem | reads ζ | `LineBound` | ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σRH X : ℂ) + I * (t : ℂ))‖ ≤ B * ‖((σRH X : ℂ)) + I * (t : ℂ)‖⁻¹ |
| [`Stage3.mellin_vert_le_theta`](./lean_stage3/ThetaPsi.md#Stage3-mellin_vert_le_theta) | theorem | reads ζ | `ThetaPsi` | ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σθ θ X : ℂ) + I * (t : ℂ))‖ ≤ B * ‖((σθ θ X : ℂ)) + I * (t : ℂ)‖⁻¹ |
| [`LandauTaylor.mellinLog`](./lean_stage3/LandauTaylor.md#LandauTaylor-mellinLog) | def | shape | `LandauTaylor` | ℂ |
| [`LandauTaylor.mellinLog_hasDerivAt`](./lean_stage3/LandauTaylor.md#LandauTaylor-mellinLog_hasDerivAt) | theorem | reads ζ | `LandauTaylor` | HasDerivAt (mellinLog k) (mellinLog (k + 1) s) s |
| [`LandauTaylor.mellinLog_integrable`](./lean_stage3/LandauTaylor.md#LandauTaylor-mellinLog_integrable) | theorem | reads ζ | `LandauTaylor` | IntegrableOn (fun y : ℝ =&gt; (LandauWindow.G y : ℂ) * (-(Real.log y : ℂ)) ^ k * (y : ℂ) ^ (-s - 1)) (Ioi 1) |
| [`LandauTaylor.mellinLog_real`](./lean_stage3/LandauTaylor.md#LandauTaylor-mellinLog_real) | theorem | shape | `LandauTaylor` | mellinLog k (σ : ℂ) = (-1) ^ k * ((∫ y in Ioi (1 : ℝ), LandauWindow.G y * Real.log y ^ k * y ^ (-σ - 1) : ℝ) : ℂ) |
| [`AttainedPi.mem_lineSet`](./lean_stage3/AttainedPi.md#AttainedPi-mem_lineSet) | theorem | reads ζ | `AttainedPi` | ρ ∈ lineSet Θ ↔ (ρ : ℂ).re = Θ |
| [`ZeroSummable.mem_nt`](./lean_stage3/ZeroSummable.md#ZeroSummable-mem_nt) | theorem | reads ζ | `ZeroSummable` | riemannZeta (ρ : ℂ) = 0 ∧ 0 &lt; (ρ : ℂ).re ∧ (ρ : ℂ).re &lt; 1 |
| [`ReZetaCount.mem_reZeros`](./lean_stage3/ReZetaCount.md#ReZetaCount-mem_reZeros) | theorem | reads ζ | `ReZetaCount` | x ∈ reZeros hT ↔ x ∈ Set.Ioo (1/2 : ℝ) 2 ∧ (riemannZeta ((x : ℂ) + T * Complex.I)).re = 0 |
| [`ArgLegs.mem_slitPlane_of_re_nonneg`](./lean_stage3/ArgLegs.md#ArgLegs-mem_slitPlane_of_re_nonneg) | theorem | shape | `ArgLegs` | z ∈ Complex.slitPlane |
| [`ContourShift.mem_zetaWindow`](./lean_stage3/ContourShift.md#ContourShift-mem_zetaWindow) | theorem | reads ζ | `ContourShift` | ρ ∈ Stage3.zetaWindow T₀ |
| [`WeilBands.mem_zetaWindow_of_online`](./lean_stage3/WeilBands.md#WeilBands-mem_zetaWindow_of_online) | theorem | reads ζ | `WeilBands` | ρ ∈ Stage3.zetaWindow T |
| [`FiniteOffLine.mem_ZF`](./lean_stage3/FiniteOffLine.md#FiniteOffLine-mem_ZF) | theorem | reads ζ | `FiniteOffLine` | ρ ∈ ZF T ↔ \|(ρ : ℂ).im\| &lt; T |
| [`Stage3.meromorphicOrderAt_xi_eq_zeta`](./lean_stage3/ArgIdentity.md#Stage3-meromorphicOrderAt_xi_eq_zeta) | theorem | reads ζ | `ArgIdentity` | meromorphicOrderAt xi ρ = meromorphicOrderAt riemannZeta ρ |
| [`MirrorArea.mirror_area`](./lean_stage3/MirrorArea.md#MirrorArea-mirror_area) | theorem | shape | `MirrorArea` | ‖(b : ℂ) ^ ρ‖ * ‖(b : ℂ) ^ (1 - ρ)‖ = b |
| [`MirrorArea.mirror_side`](./lean_stage3/MirrorArea.md#MirrorArea-mirror_side) | theorem | shape | `MirrorArea` | ‖(b : ℂ) ^ (1 - ρ)‖ = b / ‖(b : ℂ) ^ ρ‖ |
| [`StencilWeil.mirror_symbol_on_line`](./lean_stage3/StencilWeil.md#StencilWeil-mirror_symbol_on_line) | theorem | shape | `StencilWeil` | (1 - (2 : ℂ) ^ (-ρ)) * (1 - (2 : ℂ) ^ (-(1 - ρ))) = ((‖1 - (2 : ℂ) ^ (-ρ)‖ ^ 2 : ℝ) : ℂ) |
| [`Nonvanishing.Mlow`](./lean/Nonvanishing.md#Nonvanishing-Mlow) | def | shape | `Nonvanishing` | ℝ |
| [`PiRemainder.Mlow`](./lean_stage3/PiRemainder.md#PiRemainder-Mlow) | def | reads ζ | `PiRemainder` | ℝ |
| [`Chain.mode`](./lean/Chain.md#Chain-mode) | def | shape | `Chain` | ℂ → ℂ |
| [`Elephant.mode`](./lean/Elephant.md#Elephant-mode) | def | shape | `Elephant` | ℤ → ℂ |
| [`AliasClass.mode_eq_of_alias`](./lean_stage3/AliasClass.md#AliasClass-mode_eq_of_alias) | theorem | shape | `AliasClass` | Chain.mode 2 ρ (r : ℂ) = Chain.mode 2 ρ' (r : ℂ) |
| [`TransferOp.mode_hasEigenvector`](./lean/TransferOp.md#TransferOp-mode_hasEigenvector) | theorem | shape | `TransferOp` | bdiffL.HasEigenvector (Sym b ρ) (mode b ρ) |
| [`TransferOp.mode_ne_zero`](./lean/TransferOp.md#TransferOp-mode_ne_zero) | theorem | shape | `TransferOp` | mode b ρ ≠ 0 |
| [`TransferOp.mode_ne_zero'`](./lean/TransferOp.md#TransferOp-mode_ne_zero-) | theorem | shape | `TransferOp` | mode b ρ r ≠ 0 |
| [`TransferOp.mode_pow`](./lean/TransferOp.md#TransferOp-mode_pow) | theorem | shape | `TransferOp` | (bdiffL ^ N) (mode b ρ) = (Sym b ρ) ^ N • mode b ρ |
| [`CellModes.mode_two_int`](./lean_stage3/CellModes.md#CellModes-mode_two_int) | theorem | shape | `CellModes` | Chain.mode 2 ρ (r : ℂ) = ((2:ℂ) ^ ρ) ^ r |
| [`Superposition.modeSum`](./lean/Superposition.md#Superposition-modeSum) | def | shape | `Superposition` | ℂ → ℂ |
| [`WeilWindow.mul_sinh_ge`](./lean_stage3/WeilWindow.md#WeilWindow-mul_sinh_ge) | theorem | shape | `WeilWindow` | s * x ^ 2 ≤ x * Real.sinh (s * x) |
| [`Stage3.N_abs_le`](./lean_stage3/ZeroSum.md#Stage3-N_abs_le) | theorem | reads ζ | `ZeroSum` | \|riemannZeta.N T\| ≤ T / (2 * Real.pi) * (Real.log T + 3) + riemannZeta.RvM b₁ b₂ b₃ T + 7 / 8 |
| [`ArgCount.N_eq_of_no_zero_between`](./lean_stage3/ArgCount.md#ArgCount-N_eq_of_no_zero_between) | theorem | reads ζ | `ArgCount` | riemannZeta.N T = riemannZeta.N T₀ |
| [`ArgCount.N_eq_sum`](./lean_stage3/ArgCount.md#ArgCount-N_eq_sum) | theorem | reads ζ | `ArgCount` | riemannZeta.N T = ∑ z ∈ (Kadiri.zeroes_rect_univ_positive_height_finite T).toFinset, (1 : ℝ) * (riemannZeta.order z : ℝ) |
| [`Stage3.N_eq_sum`](./lean_stage3/ArgIdentity.md#Stage3-N_eq_sum) | theorem | reads ζ | `ArgIdentity` | riemannZeta.N T = ∑ ρ ∈ (Kadiri.zeroes_rect_univ_positive_height_finite T).toFinset, (riemannZeta.order ρ : ℝ) |
| [`ArgCount.N_mono`](./lean_stage3/ArgCount.md#ArgCount-N_mono) | theorem | reads ζ | `ArgCount` | riemannZeta.N T ≤ riemannZeta.N T' |
| [`ArgCount.N_nonneg`](./lean_stage3/ArgCount.md#ArgCount-N_nonneg) | theorem | reads ζ | `ArgCount` | 0 ≤ riemannZeta.N T |
| [`JointLadder.nat_log_indep`](./lean/JointLadder.md#JointLadder-nat_log_indep) | theorem | shape | `JointLadder` | a = 0 ∧ b = 0 |
| [`DirichletMean.natCast_cpow_neg_I_mul`](./lean_stage3/DirichletMean.md#DirichletMean-natCast_cpow_neg_I_mul) | theorem | shape | `DirichletMean` | (n : ℂ) ^ (-(Complex.I * (t : ℂ))) = Complex.exp (Complex.I * ((-Real.log n : ℝ) : ℂ) * t) |
| [`Elephant.natCast_mul_cpow`](./lean/Elephant.md#Elephant-natCast_mul_cpow) | theorem | shape | `Elephant` | ((m * n : ℕ) : ℂ) ^ s = (m : ℂ) ^ s * (n : ℂ) ^ s |
| [`FilterLadder.natDegree_posPoly_le`](./lean_stage3/FilterLadder.md#FilterLadder-natDegree_posPoly_le) | theorem | counting | `FilterLadder` | (posPoly q).natDegree ≤ q.natDegree |
| [`PerronKernel.near_diagonal_sum`](./lean_stage3/PerronKernel.md#PerronKernel-near_diagonal_sum) | theorem | shape | `PerronKernel` | (∑' n : ℕ, if 0 &lt; \|Real.log (x / n)\| ∧ \|Real.log (x / n)\| &lt; 1/2 then ArithmeticFunction.vonMangoldt n * min 1 (1/(T * \|Real.log (x / n)\|)) else 0) ≤ 100 * x * Real.log (x * T) ^ 2 / T + 4 * Real.log x |
| [`PerronTwo.near_diagonal_sum_two`](./lean_stage3/PerronTwo.md#PerronTwo-near_diagonal_sum_two) | theorem | shape | `PerronTwo` | (∑' n : ℕ, if 0 &lt; \|Real.log (x / n)\| ∧ \|Real.log (x / n)\| &lt; 1/2 then ArithmeticFunction.vonMangoldt n * min 1 (1/(T * \|Real.log (x / n)\|)) else 0) ≤ 100 * x * Real.log (x * T) ^ 2 / T + 4 * Real.log x |
| [`WeilPowerAssembly.near_nonneg`](./lean_stage3/WeilPowerAssembly.md#WeilPowerAssembly-near_nonneg) | theorem | reads ζ | `WeilPowerAssembly` | 0 ≤ ∑ ρ ∈ near_set, WeilPowerBands.termW h γ m ρ |
| [`Zeros.neg_below_zero`](./lean/Zeros.md#Zeros-neg_below_zero) | theorem | counting | `Zeros` | Construction.tableFrom N r (d + 1) = -Construction.tableFrom N (r - 1) d |
| [`LandauChebyshev.neg_le_G`](./lean_stage3/LandauChebyshev.md#LandauChebyshev-neg_le_G) | theorem | shape | `LandauChebyshev` | -(y * Real.log y) ≤ LandauWindow.G y |
| [`Propagation.neg_one_pow`](./lean/Propagation.md#Propagation-neg_one_pow) | theorem | counting | `Propagation` | ((-1 : ℤ)) ^ m = 1 ∨ ((-1 : ℤ)) ^ m = -1 |
| [`Crossover.no_crossover_of_single`](./lean/Crossover.md#Crossover-no_crossover_of_single) | theorem | shape | `Crossover` | ratio A 0 x y j ≠ 1 |
| [`GeneratorPeak.no_interior_peak`](./lean/GeneratorPeak.md#GeneratorPeak-no_interior_peak) | theorem | shape | `GeneratorPeak` | False |
| [`VonKoch.no_zero_right_of_half`](./lean_stage3/VonKochScaffold.md#VonKoch-no_zero_right_of_half) | theorem | reads ζ | `VonKochScaffold` | riemannZeta ρ ≠ 0 |
| [`Stage3.no_zero_right_of_theta`](./lean_stage3/ThetaConverse.md#Stage3-no_zero_right_of_theta) | theorem | reads ζ | `ThetaConverse` | ζ ρ ≠ 0 |
| [`Nonvanishing.nonvanishing_of`](./lean/Nonvanishing.md#Nonvanishing-nonvanishing_of) | theorem | shape | `Nonvanishing` | stencilR (d + 1) f r ≠ 0 |
| [`RelativeGate.nonvanishing_of_relErr`](./lean/RelativeGate.md#RelativeGate-nonvanishing_of_relErr) | theorem | shape | `RelativeGate` | stencilR (d + 1) f r ≠ 0 |
| [`Zeros.nonzero_19_6`](./lean/Zeros.md#Zeros-nonzero_19_6) | theorem | counting | `Zeros` | Construction.tableFrom dyadicRow 19 6 = 343 |
| [`Zeros.nonzero_7_3`](./lean/Zeros.md#Zeros-nonzero_7_3) | theorem | counting | `Zeros` | Construction.tableFrom dyadicRow 7 3 = 5 |
| [`WeilPowerPhase.norm_A_sq`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-norm_A_sq) | theorem | shape | `WeilPowerPhase` | ‖((cS m / D m : ℝ) : ℂ) * w * P m w‖ ^ 2 = (cS m / D m) ^ 2 * ‖w‖ ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m) |
| [`WeilPowerShell.norm_coef`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-norm_coef) | theorem | shape | `WeilPowerShell` | ‖coef e' D e‖ = (e' ^ 2 + D ^ 2) / e ^ 2 |
| [`ZeroSummable.norm_coef`](./lean_stage3/ZeroSummable.md#ZeroSummable-norm_coef) | theorem | reads ζ | `ZeroSummable` | ‖LadderMean.coef ρ‖ = w ρ |
| [`WeilPowerGeom.norm_corr_le`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-norm_corr_le) | theorem | shape | `WeilPowerGeom` | ‖Complex.exp (z * (u m : ℂ)) - Complex.exp (z * ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2)‖ ≤ Real.exp (z.re * ((m : ℝ) + 1 / 2) / Real.pi ^ 2) * (2 * ‖z‖) * (u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2) |
| [`WeilPowerGeomGen.norm_corr_le_gen`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-norm_corr_le_gen) | theorem | shape | `WeilPowerGeomGen` | ‖Complex.exp (z * (u h : ℂ)) - Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ))‖ ≤ Real.exp (z.re * (α * (h : ℝ) + β₀)) * (2 * ‖z‖) * (c / ((h : ℝ) + 1)) |
| [`LeftSmooth.norm_cos_wL`](./lean_stage3/LeftSmooth.md#LeftSmooth-norm_cos_wL) | theorem | shape | `LeftSmooth` | kc ^ 2 + t ^ 2 ≤ ‖Complex.cos ((Real.pi:ℂ) * wL t / 2)‖ ^ 2 |
| [`Elephant.norm_cpow_neg`](./lean/Elephant.md#Elephant-norm_cpow_neg) | theorem | shape | `Elephant` | ‖(b : ℂ) ^ (-s)‖ = b ^ (-s.re) |
| [`Stage3.norm_cpow_of_RH`](./lean_stage3/Assembly.md#Stage3-norm_cpow_of_RH) | theorem | reads ζ | `Assembly` | ‖(x : ℂ) ^ (ρ : ℂ)‖ = Real.sqrt x |
| [`LeftKernel.norm_cpow_tI`](./lean_stage3/LeftKernel.md#LeftKernel-norm_cpow_tI) | theorem | shape | `LeftKernel` | ‖(y:ℂ) ^ ((t:ℂ) * Complex.I)‖ = 1 |
| [`WeilPowerPhase.norm_delta_le`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-norm_delta_le) | theorem | shape | `WeilPowerPhase` | ‖delta m w n‖ ≤ q m w |
| [`PiRemainder.norm_efRem_le_high`](./lean_stage3/PiRemainder.md#PiRemainder-norm_efRem_le_high) | theorem | reads ζ | `PiRemainder` | ‖efRem x t‖ ≤ Chigh * Real.log x ^ 2 |
| [`PiRemainder.norm_efRem_le_low`](./lean_stage3/PiRemainder.md#PiRemainder-norm_efRem_le_low) | theorem | reads ζ | `PiRemainder` | ‖efRem T t‖ ≤ (7 + zinv T) * t |
| [`ZetaEM.norm_emInt_le`](./lean_stage3/ZetaEM.md#ZetaEM-norm_emInt_le) | theorem | reads ζ | `ZetaEM` | ‖emInt k N s‖ ≤ bernBound k * ((N:ℝ) ^ (1 - s.re - k) / (s.re + k - 1)) |
| [`ZetaEM.norm_emTerm`](./lean_stage3/ZetaEM.md#ZetaEM-norm_emTerm) | theorem | reads ζ | `ZetaEM` | ‖emTerm j N s‖ = (∏ i ∈ Finset.range j, ‖s + i‖) * \|bernoulliFun (j+1) 0\| / (j+1).factorial * (N:ℝ) ^ (-s.re - j) |
| [`FilterLadder.norm_eval_le_Wb`](./lean_stage3/FilterLadder.md#FilterLadder-norm_eval_le_Wb) | theorem | counting | `FilterLadder` | ‖q.eval u‖ ≤ Wb ‖u‖ q |
| [`FilterLadder.norm_eval_le_Wn`](./lean_stage3/FilterLadder.md#FilterLadder-norm_eval_le_Wn) | theorem | shape | `FilterLadder` | ‖q.eval u‖ ≤ Wn q |
| [`WeilPowerPhase.norm_exp_delta_sub_one_le`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-norm_exp_delta_sub_one_le) | theorem | shape | `WeilPowerPhase` | ‖Complex.exp (delta m w n) - 1‖ ≤ 2 * q m w |
| [`LeftKernel.norm_exp_tI`](./lean_stage3/LeftKernel.md#LeftKernel-norm_exp_tI) | theorem | shape | `LeftKernel` | ‖Complex.exp ((L:ℂ) * ((t:ℂ) * Complex.I))‖ = 1 |
| [`WeilPowerBounds.norm_factor_ge`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_factor_ge) | theorem | shape | `WeilPowerBounds` | w.re ^ 2 ≤ ‖w ^ 2 + (a : ℂ) ^ 2‖ |
| [`WeilPowerBounds.norm_factor_ge_far`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_factor_ge_far) | theorem | shape | `WeilPowerBounds` | w.im ^ 2 / 2 ≤ ‖w ^ 2 + (a : ℂ) ^ 2‖ |
| [`WeilPowerTail.norm_g_le`](./lean_stage3/WeilPowerTail.md#WeilPowerTail-norm_g_le) | theorem | shape | `WeilPowerTail` | ‖g w j‖ ≤ Real.exp ((w ^ 2).re * hterm j + ‖w‖ ^ 4 * hterm j ^ 2 / 2) |
| [`RHPull.norm_ge_height`](./lean_stage3/LineBound.md#RHPull-norm_ge_height) | theorem | shape | `LineBound` | T ≤ ‖((σ : ℂ)) + I * (T : ℂ)‖ |
| [`RHPull.norm_ge_height_neg`](./lean_stage3/LineBound.md#RHPull-norm_ge_height_neg) | theorem | shape | `LineBound` | T ≤ ‖((σ : ℂ)) - (T : ℂ) * I‖ |
| [`LandauTrig.norm_geom_Ico_le`](./lean_stage3/LandauTrig.md#LandauTrig-norm_geom_Ico_le) | theorem | shape | `LandauTrig` | ‖∑ n ∈ Finset.Ico a (a + N), w ^ n‖ ≤ 2 / ‖w - 1‖ |
| [`WeilPowerGeom.norm_geom_le`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-norm_geom_le) | theorem | shape | `WeilPowerGeom` | ‖∑ m ∈ Finset.Ico a b, Complex.exp (z * ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2)‖ ≤ geomBound z a b |
| [`WeilPowerGeomGen.norm_geom_le_gen`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-norm_geom_le_gen) | theorem | shape | `WeilPowerGeomGen` | ‖∑ h ∈ Finset.Ico a b, Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ))‖ ≤ geomBoundGen z α β₀ a b |
| [`PiFixedRow.norm_high_integral_le`](./lean_stage3/PiFixedRow.md#PiFixedRow-norm_high_integral_le) | theorem | reads ζ | `PiFixedRow` | ‖∫ t in (16:ℝ)..x, efRem T t * wt t‖ ≤ (x - 16) * (Glue.c1n * Real.log (x * T) ^ 2 / T) + (Glue.c3n + LeftSmooth.Bleft) * Real.log (x / 16) |
| [`ZetaEM.norm_integral_bern_cpow_le`](./lean_stage3/ZetaEM.md#ZetaEM-norm_integral_bern_cpow_le) | theorem | reads ζ | `ZetaEM` | ‖∫ x in Ioi a, ((bernoulliFun k (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ w‖ ≤ bernBound k * (-a ^ (w.re + 1) / (w.re + 1)) |
| [`PiFixedRow.norm_integral_cpow_wt_le`](./lean_stage3/PiFixedRow.md#PiFixedRow-norm_integral_cpow_wt_le) | theorem | shape | `PiFixedRow` | ‖∫ t in (2:ℝ)..16, wt t * (t : ℂ) ^ ρ‖ ≤ 15360 * ‖ρ + 1‖⁻¹ |
| [`DirichletMean.norm_integral_exp_le`](./lean_stage3/DirichletMean.md#DirichletMean-norm_integral_exp_le) | theorem | shape | `DirichletMean` | ‖∫ t in T₁..T₂, Complex.exp (Complex.I * (θ : ℂ) * t)‖ ≤ 2 / \|θ\| |
| [`FixedRowTwo.norm_integral_two_le`](./lean_stage3/FixedRowTwo.md#FixedRowTwo-norm_integral_two_le) | theorem | reads ζ | `FixedRowTwo` | ‖∫ t in (2:ℝ)..x, efRem T t * wt t‖ ≤ (x - 2) * (9 / 4 * ExplicitTwo.c1t * Real.log (x * T) ^ 2 / T) + Api2 * Real.log (x / 2) |
| [`FiniteOffLinePi.norm_integrand`](./lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-norm_integrand) | theorem | shape | `FiniteOffLinePi` | ‖(t : ℂ) ^ ρ / ρ * wt t‖ = ‖ρ‖⁻¹ * (t ^ ρ.re * (t * Real.log t ^ 2)⁻¹) |
| [`FixedRowTwo.norm_integrand_two_le`](./lean_stage3/FixedRowTwo.md#FixedRowTwo-norm_integrand_two_le) | theorem | reads ζ | `FixedRowTwo` | ‖efRem T t * wt t‖ ≤ 9 / 4 * ExplicitTwo.c1t * Real.log (x * T) ^ 2 / T + Api2 * t⁻¹ |
| [`FiniteOffLinePi.norm_ipart_le`](./lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-norm_ipart_le) | theorem | shape | `FiniteOffLinePi` | ‖ipart ρ x‖ ≤ ‖ρ‖⁻¹ * (3 * Real.sqrt x + 4 * x ^ ρ.re / (ρ.re * Real.log x ^ 2)) |
| [`AttainedPi.norm_ipart_le_of_le`](./lean_stage3/AttainedPi.md#AttainedPi-norm_ipart_le_of_le) | theorem | shape | `AttainedPi` | ‖ipart ρ x‖ ≤ ‖ρ‖⁻¹ * (3 * Real.sqrt x + 4 * x ^ c / (c * Real.log x ^ 2)) |
| [`PiFixedRow.norm_le_norm_add_one`](./lean_stage3/PiFixedRow.md#PiFixedRow-norm_le_norm_add_one) | theorem | shape | `PiFixedRow` | ‖ρ‖ ≤ ‖ρ + 1‖ |
| [`BoxBounds.norm_le_of_sq`](./lean_stage3/BoxBounds.md#BoxBounds-norm_le_of_sq) | theorem | shape | `BoxBounds` | ‖z‖ ≤ c |
| [`RHPull.norm_line_ge`](./lean_stage3/LineBound.md#RHPull-norm_line_ge) | theorem | shape | `LineBound` | (1 + \|t\|) / 3 ≤ ‖((σRH X : ℂ)) + I * (t : ℂ)‖ |
| [`Stage3.norm_line_ge_theta`](./lean_stage3/ThetaPull.md#Stage3-norm_line_ge_theta) | theorem | shape | `ThetaPull` | (1 + \|t\|) / 3 ≤ ‖((σθ θ X : ℂ)) + I * (t : ℂ)‖ |
| [`AttainedPi.norm_log_ipart_le`](./lean_stage3/AttainedPi.md#AttainedPi-norm_log_ipart_le) | theorem | shape | `AttainedPi` | Real.log x * ‖ipart ρ x‖ ≤ ‖ρ‖⁻¹ * (3 * (Real.sqrt x * Real.log x) + 8 * (x ^ max ρ.re (1 / 2) / Real.log x)) |
| [`AttainedPi.norm_log_piMode_band`](./lean_stage3/AttainedPi.md#AttainedPi-norm_log_piMode_band) | theorem | shape | `AttainedPi` | Real.log x * ‖piMode ρ x‖ ≤ ‖ρ‖⁻¹ * (2 * x ^ Θ + 3 * (Real.sqrt x * Real.log x)) |
| [`AttainedPi.norm_log_piMode_le`](./lean_stage3/AttainedPi.md#AttainedPi-norm_log_piMode_le) | theorem | shape | `AttainedPi` | Real.log x * ‖piMode ρ x‖ ≤ ‖ρ‖⁻¹ * (x ^ ρ.re + 3 * (Real.sqrt x * Real.log x) + 8 * (x ^ max ρ.re (1 / 2) / Real.log x)) |
| [`AttainedPi.norm_log_piMode_low`](./lean_stage3/AttainedPi.md#AttainedPi-norm_log_piMode_low) | theorem | shape | `AttainedPi` | Real.log x * ‖piMode ρ x‖ ≤ ‖ρ‖⁻¹ * (9 * x ^ θ₁ + 3 * (Real.sqrt x * Real.log x)) |
| [`WeilPowerPhase.norm_log_sub_le`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-norm_log_sub_le) | theorem | shape | `WeilPowerPhase` | ‖Complex.log (g w j) - x w j‖ ≤ ‖x w j‖ ^ 2 |
| [`Slice5.norm_logDerivZeta_of_one_lt_re`](./lean_stage3/LineBound.md#Slice5-norm_logDerivZeta_of_one_lt_re) | theorem | reads ζ | `LineBound` | ‖deriv ζ s / ζ s‖ ≤ 2 / (s.re - 1) + 4 / (s.re - 1) ^ 2 |
| [`Slice5.norm_logDerivZeta_sigma0`](./lean_stage3/LineBound.md#Slice5-norm_logDerivZeta_sigma0) | theorem | reads ζ | `LineBound` | ‖deriv ζ (((1 + 1 / L : ℝ) : ℂ) + I * (t : ℂ)) / ζ (((1 + 1 / L : ℝ) : ℂ) + I * (t : ℂ))‖ ≤ 2 * L + 4 * L ^ 2 |
| [`Stage3.norm_logDerivZeta_zero`](./lean_stage3/RowLeaves.md#Stage3-norm_logDerivZeta_zero) | theorem | reads ζ | `RowLeaves` | ‖deriv riemannZeta 0 / riemannZeta 0‖ = Real.log (2 * Real.pi) |
| [`PiFixedRow.norm_low_integral_le`](./lean_stage3/PiFixedRow.md#PiFixedRow-norm_low_integral_le) | theorem | reads ζ | `PiFixedRow` | ‖∫ t in (2:ℝ)..16, efRem T t * wt t‖ ≤ Clow |
| [`MollifiedMean.norm_M_le`](./lean_stage3/MollifiedMean.md#MollifiedMean-norm_M_le) | theorem | shape | `MollifiedMean` | ‖M X s‖ ≤ X |
| [`WobbleCount.norm_natCast_cpow`](./lean_stage3/WobbleCount.md#WobbleCount-norm_natCast_cpow) | theorem | shape | `WobbleCount` | ‖(N : ℂ) ^ ρ‖ = (N : ℝ) ^ ρ.re |
| [`WeilPowerGauss.norm_one_add_le`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_one_add_le) | theorem | shape | `WeilPowerGauss` | ‖1 + x‖ ≤ Real.exp (x.re + ‖x‖ ^ 2) |
| [`WeilPowerTail.norm_one_add_le`](./lean_stage3/WeilPowerTail.md#WeilPowerTail-norm_one_add_le) | theorem | shape | `WeilPowerTail` | ‖1 + z‖ ≤ Real.exp (z.re + ‖z‖ ^ 2 / 2) |
| [`WeilPowerGeom.norm_one_sub_exp_ge`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-norm_one_sub_exp_ge) | theorem | shape | `WeilPowerGeom` | Real.exp w.re * \|Real.sin w.im\| ≤ ‖1 - Complex.exp w‖ |
| [`FiniteOffLinePi.norm_order_mul`](./lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-norm_order_mul) | theorem | reads ζ | `FiniteOffLinePi` | ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * w‖ = ordR ρ * ‖w‖ |
| [`FiniteOffLinePi.norm_piMode_half`](./lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-norm_piMode_half) | theorem | shape | `FiniteOffLinePi` | ‖piMode ρ x‖ ≤ ‖ρ‖⁻¹ * (12 * Real.sqrt x) |
| [`FiniteOffLinePi.norm_piMode_le`](./lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-norm_piMode_le) | theorem | shape | `FiniteOffLinePi` | ‖piMode ρ x‖ ≤ ‖ρ‖⁻¹ * ((1 + 4 / ρ.re) * x ^ ρ.re + 3 * Real.sqrt x) |
| [`SquareMean.norm_polar`](./lean_stage3/SquareMean.md#SquareMean-norm_polar) | theorem | shape | `SquareMean` | ‖(r : ℂ) * ((Real.cos θ : ℂ) + (Real.sin θ : ℂ) * Complex.I)‖ = \|r\| |
| [`PiRemainder.norm_psi_sub_le`](./lean_stage3/PiRemainder.md#PiRemainder-norm_psi_sub_le) | theorem | shape | `PiRemainder` | ‖((ψ t : ℝ) : ℂ) - (t : ℂ)‖ ≤ 7 * t |
| [`WeilPowerBounds.norm_QS_ge`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_QS_ge) | theorem | shape | `WeilPowerBounds` | (w.re ^ 2) ^ (m + 1) ≤ ‖QS m w‖ |
| [`WeilPowerBounds.norm_QS_ge_far`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_QS_ge_far) | theorem | shape | `WeilPowerBounds` | (w.im ^ 2 / 2) ^ (m + 1) ≤ ‖QS m w‖ |
| [`ZetaEM.norm_remainder_le`](./lean_stage3/ZetaEM.md#ZetaEM-norm_remainder_le) | theorem | reads ζ | `ZetaEM` | ‖emRem k N s‖ ≤ (∏ i ∈ Finset.range k, ‖s + i‖) / k.factorial * (bernBound k * ((N:ℝ) ^ (1 - s.re - k) / (s.re + k - 1))) |
| [`WeilPowerBounds.norm_S_le`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_S_le) | theorem | shape | `WeilPowerBounds` | ‖S m w‖ ≤ cS m * Real.cosh w.re / ‖QS m w‖ |
| [`WeilPowerBounds.norm_S_le'`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_S_le-) | theorem | shape | `WeilPowerBounds` | ‖S m w‖ ≤ cS m * Real.cosh w.re / ‖QS m w‖ |
| [`WeilPowerSharp.norm_S_le_c_neg`](./lean_stage3/WeilPowerSharp.md#WeilPowerSharp-norm_S_le_c_neg) | theorem | shape | `WeilPowerSharp` | ‖S m w‖ ≤ cS m / D m * ‖w‖ * Real.exp ((w ^ 2).re * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) |
| [`WeilPowerSharp.norm_S_le_c_pos`](./lean_stage3/WeilPowerSharp.md#WeilPowerSharp-norm_S_le_c_pos) | theorem | shape | `WeilPowerSharp` | ‖S m w‖ ≤ cS m / D m * ‖w‖ * Real.exp ((w ^ 2).re / (Real.pi ^ 2 * ((m : ℝ) + 1)) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) |
| [`WeilPowerBounds.norm_S_le_far`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_S_le_far) | theorem | shape | `WeilPowerBounds` | ‖S m w‖ ≤ cS m * Real.cosh w.re * (2 / w.im ^ 2) ^ (m + 1) |
| [`WeilPowerCompare.norm_S_le_gauss`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-norm_S_le_gauss) | theorem | shape | `WeilPowerCompare` | ‖S m w‖ ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖ * Real.exp (Eup m w) |
| [`WeilPowerGauss.norm_S_le_gauss_neg`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_S_le_gauss_neg) | theorem | shape | `WeilPowerGauss` | ‖S m w‖ ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖ * Real.exp ((w ^ 2).re * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) |
| [`WeilPowerGauss.norm_S_le_gauss_pos`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_S_le_gauss_pos) | theorem | shape | `WeilPowerGauss` | ‖S m w‖ ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖ * Real.exp ((w ^ 2).re / (Real.pi ^ 2 * ((m : ℝ) + 1)) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) |
| [`WeilPowerTail.norm_S_le_tail`](./lean_stage3/WeilPowerTail.md#WeilPowerTail-norm_S_le_tail) | theorem | shape | `WeilPowerTail` | ‖S m w‖ ≤ cS m / D m * ‖w‖ * Real.exp ((w ^ 2).re * sigma m + ‖w‖ ^ 4 / (6 * Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) |
| [`WeilPowerPhase.norm_S_sub_le`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-norm_S_sub_le) | theorem | shape | `WeilPowerPhase` | ‖S m w - ((cS m / D m : ℝ) : ℂ) * w * P m w‖ ≤ 2 * q m w * ‖((cS m / D m : ℝ) : ℂ) * w * P m w‖ |
| [`WeilLobe.norm_sinh_le`](./lean_stage3/WeilLobe.md#WeilLobe-norm_sinh_le) | theorem | shape | `WeilLobe` | ‖Complex.sinh z‖ ≤ Real.cosh z.re |
| [`LeftSmooth.norm_sL_ge`](./lean_stage3/LeftSmooth.md#LeftSmooth-norm_sL_ge) | theorem | shape | `LeftSmooth` | 1/4 ≤ ‖sL t‖ |
| [`LeftSmooth.norm_sL_sq`](./lean_stage3/LeftSmooth.md#LeftSmooth-norm_sL_sq) | theorem | shape | `LeftSmooth` | ‖sL t‖ ^ 2 = 1/16 + t ^ 2 |
| [`MollifiedMean.norm_smooth_le`](./lean_stage3/MollifiedMean.md#MollifiedMean-norm_smooth_le) | theorem | shape | `MollifiedMean` | ‖(N : ℂ) ^ (1 - ((u : ℂ) + Complex.I * (t : ℂ))) / (1 - ((u : ℂ) + Complex.I * (t : ℂ)))‖ ≤ (N : ℝ) ^ (1 - u) / t |
| [`MollifiedMean.norm_sq_add_three`](./lean_stage3/MollifiedMean.md#MollifiedMean-norm_sq_add_three) | theorem | shape | `MollifiedMean` | ‖x + y + z‖ ^ 2 ≤ 3 * (‖x‖ ^ 2 + ‖y‖ ^ 2 + ‖z‖ ^ 2) |
| [`RHPull.norm_sq_line`](./lean_stage3/LineBound.md#RHPull-norm_sq_line) | theorem | shape | `LineBound` | ‖((σ : ℂ) + I * (t : ℂ))‖ ^ 2 = σ ^ 2 + t ^ 2 |
| [`CellZeros.norm_stencil_le`](./lean_stage3/CellZeros.md#CellZeros-norm_stencil_le) | theorem | shape | `CellZeros` | ‖stencil d a r‖ ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ) * B j |
| [`WeilPowerGeom.norm_sum_exp_u_le`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-norm_sum_exp_u_le) | theorem | shape | `WeilPowerGeom` | ‖∑ m ∈ Finset.Ico a b, Complex.exp (z * (u m : ℂ))‖ ≤ geomBound z a b + 2 * ‖z‖ * Mab z a b * ((Real.log b - Real.log a) / (4 * Real.pi ^ 2)) |
| [`WeilPowerGeomGen.norm_sum_exp_u_le_gen`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-norm_sum_exp_u_le_gen) | theorem | shape | `WeilPowerGeomGen` | ‖∑ h ∈ Finset.Ico a b, Complex.exp (z * (u h : ℂ))‖ ≤ geomBoundGen z α β₀ a b + 2 * ‖z‖ * c * MabGen z α β₀ a b * (Real.log b - Real.log a) |
| [`Elephant.norm_sym_band`](./lean/Elephant.md#Elephant-norm_sym_band) | theorem | shape | `Elephant` | 1 - b ^ (-(1:ℝ)/2) ≤ ‖Sym b ((1:ℂ)/2 + γ * Complex.I)‖ ∧ ‖Sym b ((1:ℂ)/2 + γ * Complex.I)‖ ≤ 1 + b ^ (-(1:ℝ)/2) |
| [`Elephant.norm_sym_imaginary`](./lean/Elephant.md#Elephant-norm_sym_imaginary) | theorem | shape | `Elephant` | ‖Sym b ((γ : ℂ) * Complex.I)‖ = 2 * \|Real.sin (γ * Real.log b / 2)\| |
| [`NyquistPeak.norm_sym_on_imaginary_axis`](./lean/NyquistPeak.md#NyquistPeak-norm_sym_on_imaginary_axis) | theorem | shape | `NyquistPeak` | ‖Chain.Sym b (γ * Complex.I)‖ = 2 * \|Real.sin (γ * Real.log b / 2)\| |
| [`NyquistPeak.norm_sym_pow_at_boundaryBase`](./lean/NyquistPeak.md#NyquistPeak-norm_sym_pow_at_boundaryBase) | theorem | shape | `NyquistPeak` | ‖Chain.Sym (boundaryBase γ) (γ * Complex.I)‖ ^ d = 2 ^ d |
| [`WeilPowerGauss.norm_T_le`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_T_le) | theorem | shape | `WeilPowerGauss` | ‖T m w n‖ ≤ Real.exp ((w ^ 2).re / Real.pi ^ 2 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 + ‖w‖ ^ 4 / Real.pi ^ 4 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4) |
| [`WeilPowerGauss.norm_T_le_neg`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_T_le_neg) | theorem | shape | `WeilPowerGauss` | ‖T m w n‖ ≤ Real.exp ((w ^ 2).re * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) |
| [`WeilPowerGauss.norm_T_le_pos`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_T_le_pos) | theorem | shape | `WeilPowerGauss` | ‖T m w n‖ ≤ Real.exp ((w ^ 2).re / (Real.pi ^ 2 * ((m : ℝ) + 1)) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) |
| [`WeilPowerTail.norm_T_le_tail`](./lean_stage3/WeilPowerTail.md#WeilPowerTail-norm_T_le_tail) | theorem | shape | `WeilPowerTail` | ‖T m w n‖ ≤ Real.exp ((w ^ 2).re * sigmaN m n + ‖w‖ ^ 4 / (6 * Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) |
| [`FilterAttained.norm_tailT_le`](./lean_stage3/FilterAttained.md#FilterAttained-norm_tailT_le) | theorem | reads ζ | `FilterAttained` | ‖tailT q a b σ M k ρ‖ ≤ (S σ).indicator (fun ρ =&gt; ‖LadderMean.coef ρ‖) ρ |
| [`AttainedPi.norm_tailTerm_le`](./lean_stage3/AttainedPi.md#AttainedPi-norm_tailTerm_le) | theorem | reads ζ | `AttainedPi` | ‖tailTerm Θ r ρ‖ ≤ (lineSet Θ).indicator (fun ρ =&gt; ‖LadderMean.coef ρ‖) ρ |
| [`LeftSmooth.norm_tan_wL`](./lean_stage3/LeftSmooth.md#LeftSmooth-norm_tan_wL) | theorem | shape | `LeftSmooth` | ‖Complex.tan ((Real.pi:ℂ) * wL t / 2)‖ ≤ 1 / kc |
| [`LeftSmooth.norm_tanPiece'_le`](./lean_stage3/LeftSmooth.md#LeftSmooth-norm_tanPiece-_le) | theorem | shape | `LeftSmooth` | ‖tanPiece' t‖ ≤ 2 * Real.pi * (1 / (kc ^ 2 + t ^ 2)) + (1 / kc) * (1 / ((1/4:ℝ) ^ 2 + t ^ 2)) |
| [`AttainedPi.norm_term`](./lean_stage3/AttainedPi.md#AttainedPi-norm_term) | theorem | reads ζ | `AttainedPi` | ‖term Θ r ρ‖ = ‖LadderMean.coef ρ‖ |
| [`FiniteOffLine.norm_term_le`](./lean_stage3/FiniteOffLine.md#FiniteOffLine-norm_term_le) | theorem | reads ζ | `FiniteOffLine` | ‖term d (r : ℤ) ρ‖ ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * (2 ^ d * ((2:ℝ) ^ (ρ : ℂ).re) ^ r * ‖(ρ : ℂ)‖⁻¹) |
| [`Stage3.norm_term_le_dyadic`](./lean_stage3/Assembly.md#Stage3-norm_term_le_dyadic) | theorem | reads ζ | `Assembly` | ‖(x : ℂ) ^ (ρ : ℂ) / (ρ : ℂ)‖ ≤ 2 * Real.sqrt x * ∑ j ∈ Finset.range (K + 1), ((2 : ℝ) ^ j)⁻¹ * (if \|(ρ : ℂ).im\| &lt; 2 ^ (j + 1) then 1 else 0) |
| [`Stage3.norm_term_le_of_RH`](./lean_stage3/Assembly.md#Stage3-norm_term_le_of_RH) | theorem | reads ζ | `Assembly` | ‖(x : ℂ) ^ (ρ : ℂ) / (ρ : ℂ)‖ ≤ 2 * Real.sqrt x |
| [`PiRemainder.norm_tr_efRem_le`](./lean_stage3/PiRemainder.md#PiRemainder-norm_tr_efRem_le) | theorem | reads ζ | `PiRemainder` | ∃ A x₀ : ℝ, 0 ≤ A ∧ ∀ x : ℝ, x₀ ≤ x → ‖PiZeros.tr (PiZeros.efRem x) x‖ ≤ A * Real.sqrt x * Real.log x ^ 2 |
| [`PiFixedRow.norm_tr_efRem_le_height`](./lean_stage3/PiFixedRow.md#PiFixedRow-norm_tr_efRem_le_height) | theorem | reads ζ | `PiFixedRow` | ‖tr (efRem T) x‖ ≤ Api * Real.log x + 2 * Glue.c1n * x * Real.log (x * T) ^ 2 / T |
| [`FixedRowTwo.norm_tr_efRem_le_height_two`](./lean_stage3/FixedRowTwo.md#FixedRowTwo-norm_tr_efRem_le_height_two) | theorem | reads ζ | `FixedRowTwo` | ‖tr (efRem T) x‖ ≤ Api2 * (1 + Real.log x) + 4 * ExplicitTwo.c1t * x * Real.log (x * T) ^ 2 / T |
| [`PiRemainder.norm_tr_efRem_le_of`](./lean_stage3/PiRemainder.md#PiRemainder-norm_tr_efRem_le_of) | theorem | reads ζ | `PiRemainder` | ‖tr (efRem x) x‖ ≤ Arem * Real.sqrt x * Real.log x ^ 2 |
| [`PiZeros.norm_tr_psiTheta_le`](./lean_stage3/PiZeros.md#PiZeros-norm_tr_psiTheta_le) | theorem | shape | `PiZeros` | ‖tr psiTheta x‖ ≤ 8 * Real.sqrt x |
| [`FiniteOffLine.norm_two_cpow`](./lean_stage3/FiniteOffLine.md#FiniteOffLine-norm_two_cpow) | theorem | shape | `FiniteOffLine` | ‖(2:ℂ) ^ ρ‖ = (2:ℝ) ^ ρ.re |
| [`WeilPowerCompare.norm_wOf_pow4`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-norm_wOf_pow4) | theorem | shape | `WeilPowerCompare` | ‖wOf ε Δ h‖ ^ 4 = ((ε ^ 2 + Δ ^ 2) * h ^ 2) ^ 2 |
| [`WeilPowerCompare.norm_wOf_sq`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-norm_wOf_sq) | theorem | shape | `WeilPowerCompare` | ‖wOf ε Δ h‖ ^ 2 = (ε ^ 2 + Δ ^ 2) * h ^ 2 |
| [`WeilPowerGauss.norm_x_le`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_x_le) | theorem | shape | `WeilPowerGauss` | ‖w ^ 2 / ((Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2)‖ ≤ 1 / 2 |
| [`PiFixedRow.norm_zero_term_le`](./lean_stage3/PiFixedRow.md#PiFixedRow-norm_zero_term_le) | theorem | shape | `PiFixedRow` | ‖∫ t in (2:ℝ)..16, (t : ℂ) ^ ρ / ρ * wt t‖ ≤ 15360 * (‖ρ‖⁻¹) ^ 2 |
| [`PiRemainder.norm_zeroPartialSum_le`](./lean_stage3/PiRemainder.md#PiRemainder-norm_zeroPartialSum_le) | theorem | reads ζ | `PiRemainder` | ‖Stage3.zeroPartialSum t T‖ ≤ t * zinv T |
| [`Stage3.norm_zeroPartialSum_le`](./lean_stage3/Assembly.md#Stage3-norm_zeroPartialSum_le) | theorem | reads ζ | `Assembly` | ‖zeroPartialSum x ((2 : ℝ) ^ (K + 1))‖ ≤ 2 * Real.sqrt x * (2 * \|riemannZeta.N ((2 : ℝ) ^ (K + 1))\| + weightedZeroHeightBucket) |
| [`Stage3.norm_zeroPartialSum_le_logsq`](./lean_stage3/Assembly.md#Stage3-norm_zeroPartialSum_le_logsq) | theorem | reads ζ | `Assembly` | ‖zeroPartialSum x ((2 : ℝ) ^ (K + 1))‖ ≤ 2 * Real.sqrt x * (2 * (Real.log 2 / (2 * Real.pi) * (K + 1) * (K + 2) + 3 * (K + 1) / Real.pi + 2 * (riemannZeta.RvM b₁ b₂ b₃ ((2 : ℝ) ^ (K + 1)) + 7 / 8)) + … |
| [`Stage3.norm_zeroPartialSum_le_sharp`](./lean_stage3/Assembly.md#Stage3-norm_zeroPartialSum_le_sharp) | theorem | reads ζ | `Assembly` | ‖zeroPartialSum x ((2 : ℝ) ^ (K + 1))‖ ≤ 2 * Real.sqrt x * ∑ j ∈ Finset.range (K + 1), ((2 : ℝ) ^ j)⁻¹ * (2 * \|riemannZeta.N ((2 : ℝ) ^ (j + 1))\| + weightedZeroHeightBucket) |
| [`ReZetaCount.norm_zeta_sub_one_le`](./lean_stage3/ReZetaCount.md#ReZetaCount-norm_zeta_sub_one_le) | theorem | reads ζ | `ReZetaCount` | ‖riemannZeta s - 1‖ ≤ Real.pi ^ 2 / 6 - 1 |
| [`ZetaEM.norm_zeta_sub_partial_le`](./lean_stage3/ZetaEM.md#ZetaEM-norm_zeta_sub_partial_le) | theorem | reads ζ | `ZetaEM` | ‖riemannZeta s - ∑ n ∈ Finset.Icc 1 N, (n : ℂ) ^ (-s) + (N : ℂ) ^ (1 - s) / (1 - s)‖ ≤ emConst k * (N : ℝ) ^ (-s.re) * (1 + (‖s‖ + k) ^ k * (N : ℝ) ^ (1 - (k : ℝ))) |
| [`BoxBounds.norm_zeta_three_halves_le`](./lean_stage3/BoxBounds.md#BoxBounds-norm_zeta_three_halves_le) | theorem | reads ζ | `BoxBounds` | ‖riemannZeta (3 / 2)‖ ≤ 7 / 2 |
| [`Transform.norm_zmap`](./lean/Transform.md#Transform-norm_zmap) | theorem | shape | `Transform` | ‖(b : ℂ) ^ (-s)‖ = b ^ (-s.re) |
| [`Transform.norm_zmap_critical`](./lean/Transform.md#Transform-norm_zmap_critical) | theorem | shape | `Transform` | ‖(b : ℂ) ^ (-((1 : ℂ)/2 + γ * I))‖ = b ^ (-(1:ℝ)/2) |
| [`Transform.norm_zmap_zero_line`](./lean/Transform.md#Transform-norm_zmap_zero_line) | theorem | shape | `Transform` | ‖(b : ℂ) ^ (-s)‖ = 1 |
| [`WeilPowerShell.norm_zOf_c_le`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-norm_zOf_c_le) | theorem | shape | `WeilPowerShell` | ‖zOf e' D e‖ * (1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2)) ≤ (a : ℝ) + 1 |
| [`WeilPowerShell.norm_zOf_le`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-norm_zOf_le) | theorem | shape | `WeilPowerShell` | ‖zOf e' D e‖ ≤ 2 * (e' ^ 2 + D ^ 2 + e ^ 2) |
| [`Stage3.normSq_add_zq`](./lean_stage3/Stirling.md#Stage3-normSq_add_zq) | theorem | shape | `Stirling` | ‖(n : ℂ) + zq t‖ ^ 2 = ((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2 |
| [`LadderFading.not_tendsto_powerSum`](./lean_stage3/LadderFading.md#LadderFading-not_tendsto_powerSum) | theorem | shape | `LadderFading` | ∀ (n : ℕ) (Z : Finset ℂ) (c : ℂ → ℂ), Z.card = n → (∀ z ∈ Z, ‖z‖ = R) → (∃ z ∈ Z, c z ≠ 0) → ¬ Tendsto (fun r : ℕ =&gt; (∑ z ∈ Z, c z * z ^ r) / ((R : ℂ)) ^ r) atTop (𝓝 0) |
| [`LeftSmooth.Nsm`](./lean_stage3/LeftSmooth.md#LeftSmooth-Nsm) | def | shape | `LeftSmooth` | ℝ |
| [`LeftSmooth.Nsm_nonneg`](./lean_stage3/LeftSmooth.md#LeftSmooth-Nsm_nonneg) | theorem | shape | `LeftSmooth` | 0 ≤ Nsm |
| [`Nyquist.nyquist`](./lean/Nyquist.md#Nyquist-nyquist) | def | shape | `Nyquist` | ℝ |
| [`NyquistPeak.nyquist_boundaryBase`](./lean/NyquistPeak.md#NyquistPeak-nyquist_boundaryBase) | theorem | shape | `NyquistPeak` | Nyquist.nyquist (boundaryBase γ) = γ |
| [`Nyquist.nyquist_no_go`](./lean/Nyquist.md#Nyquist-nyquist_no_go) | theorem | shape | `Nyquist` | ∃ γ', \|γ'\| &lt; \|γ\| ∧ Aliases b γ γ' |
| [`WeilTransform.odd_integral_exp`](./lean_stage3/WeilTransform.md#WeilTransform-odd_integral_exp) | theorem | shape | `WeilTransform` | (∫ x in (-1 : ℝ)..1, ((q x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ))) = ∫ x in (-1 : ℝ)..1, ((q x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) |
| [`WeilOffLine.offline_term_le`](./lean_stage3/WeilOffLine.md#WeilOffLine-offline_term_le) | theorem | shape | `WeilOffLine` | (laplace (phiC h γ) (-offPt ε γ) * laplace (phiC h γ) (-(1 - offPt ε γ))).re ≤ -((h / 2) ^ 2 * (WeilWindow.Sigma (ε * h) * (WeilWindow.Sigma (ε * h) - 2 * ‖SigmaC (((ε : ℂ) + 2 * Complex.I * (γ : ℂ)) … |
| [`WeilOffLine.offline_term_le_explicit`](./lean_stage3/WeilOffLine.md#WeilOffLine-offline_term_le_explicit) | theorem | shape | `WeilOffLine` | (laplace (phiC h γ) (-offPt ε γ) * laplace (phiC h γ) (-(1 - offPt ε γ))).re ≤ -((h / 2) ^ 2 * (WeilWindow.Sigma (ε * h) * (WeilWindow.Sigma (ε * h) - 2 * ((2 * Real.pi + Real.pi ^ 2) * Real.cosh (ε *… |
| [`WeilDetect.OffLineBox`](./lean_stage3/WeilDetect.md#WeilDetect-OffLineBox) | def | reads ζ | `WeilDetect` | Set ℂ |
| [`Stage3.offLineBox_finite`](./lean_stage3/BoxFinite.md#Stage3-offLineBox_finite) | theorem | reads ζ | `BoxFinite` | (WeilDetect.OffLineBox ε T).Finite |
| [`WeilOffLine.offPt`](./lean_stage3/WeilOffLine.md#WeilOffLine-offPt) | def | shape | `WeilOffLine` | ℂ |
| [`WeilOffLine.offPt_sub_half`](./lean_stage3/WeilOffLine.md#WeilOffLine-offPt_sub_half) | theorem | shape | `WeilOffLine` | offPt ε γ - 1 / 2 = (ε : ℂ) + Complex.I * (γ : ℂ) |
| [`JointLadder.offset_of_aliases`](./lean/JointLadder.md#JointLadder-offset_of_aliases) | theorem | shape | `JointLadder` | ∃ j : ℤ, (γ - γ') * jointSample m n = 2 * Real.pi * j |
| [`Transform.on_critical_line_iff_inversion_fixed`](./lean/Transform.md#Transform-on_critical_line_iff_inversion_fixed) | theorem | shape | `Transform` | s.re = 1 / 2 ↔ ‖(b : ℂ) ^ (-(1 : ℂ)) / (b : ℂ) ^ (-s)‖ = ‖(b : ℂ) ^ (-s)‖ |
| [`Transform.on_critical_line_iff_norm`](./lean/Transform.md#Transform-on_critical_line_iff_norm) | theorem | shape | `Transform` | s.re = 1 / 2 ↔ ‖(b : ℂ) ^ (-s)‖ = b ^ (-(1 : ℝ) / 2) |
| [`WeilPowerAssembly.on_line_le`](./lean_stage3/WeilPowerAssembly.md#WeilPowerAssembly-on_line_le) | theorem | reads ζ | `WeilPowerAssembly` | WeilPowerOnLine.onLineBound h γ m ≤ 2 * (88 * (γ + WeilPowerBands.r h m + 2) ^ 4 * (4 * h ^ 2 + WeilPowerBands.cFarM m / h ^ 2) * (Real.pi ^ 2 / 6)) + 4 * h ^ 2 * WeilOnLine.lowCount |
| [`Stage3.one_add_log_four_le`](./lean_stage3/PsiToPi.md#Stage3-one_add_log_four_le) | theorem | shape | `PsiToPi` | 1 + Real.log 4 ≤ 5 * Real.log 2 ^ 2 |
| [`ZeroDensity.one_add_log_le`](./lean_stage3/ZeroDensity.md#ZeroDensity-one_add_log_le) | theorem | shape | `ZeroDensity` | 1 + Real.log T ≤ (1 + 1 / ε) * T ^ ε |
| [`AttainedPi.one_le_log`](./lean_stage3/AttainedPi.md#AttainedPi-one_le_log) | theorem | shape | `AttainedPi` | 1 ≤ Real.log x |
| [`PiFixedRow.one_le_log_of_16`](./lean_stage3/PiFixedRow.md#PiFixedRow-one_le_log_of_16) | theorem | shape | `PiFixedRow` | 1 ≤ Real.log x |
| [`BoxBounds.one_le_norm_zeta_three`](./lean_stage3/BoxBounds.md#BoxBounds-one_le_norm_zeta_three) | theorem | reads ζ | `BoxBounds` | 1 ≤ ‖riemannZeta 3‖ |
| [`WeilPowerBands.one_le_r`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-one_le_r) | theorem | shape | `WeilPowerBands` | 1 ≤ r h m |
| [`ContourShift.one_le_zeta_order`](./lean_stage3/ContourShift.md#ContourShift-one_le_zeta_order) | theorem | reads ζ | `ContourShift` | 1 ≤ analyticOrderNatAt riemannZeta ρ |
| [`ZeroSquares.one_le_zeta_order`](./lean_stage3/ZeroSquares.md#ZeroSquares-one_le_zeta_order) | theorem | reads ζ | `ZeroSquares` | 1 ≤ analyticOrderNatAt riemannZeta ρ |
| [`NyquistPeak.one_lt_boundaryBase`](./lean/NyquistPeak.md#NyquistPeak-one_lt_boundaryBase) | theorem | shape | `NyquistPeak` | 1 &lt; boundaryBase γ |
| [`Transform.one_mem_periodLattice`](./lean/Transform.md#Transform-one_mem_periodLattice) | theorem | shape | `Transform` | (1 : ℂ) ∈ periodLattice b |
| [`LadderFading.one_sub_inv_ne_zero`](./lean_stage3/LadderFading.md#LadderFading-one_sub_inv_ne_zero) | theorem | shape | `LadderFading` | (1 : ℂ) - z⁻¹ ≠ 0 |
| [`PerronKernel.one_sub_two_neg_rpow`](./lean_stage3/PerronKernel.md#PerronKernel-one_sub_two_neg_rpow) | theorem | shape | `PerronKernel` | δ / 5 ≤ 1 - (2:ℝ) ^ (-δ) |
| [`PerronTwo.one_sub_two_neg_rpow'`](./lean_stage3/PerronTwo.md#PerronTwo-one_sub_two_neg_rpow-) | theorem | shape | `PerronTwo` | δ / 5 ≤ 1 - (2:ℝ) ^ (-δ) |
| [`LeftSmooth.one_sub_wL`](./lean_stage3/LeftSmooth.md#LeftSmooth-one_sub_wL) | theorem | shape | `LeftSmooth` | 1 - wL t = sL t |
| [`WeilOnLine.OnLine`](./lean_stage3/WeilOnLine.md#WeilOnLine-OnLine) | abbrev | reads ζ | `WeilOnLine` | Type |
| [`WeilBackground.online_term_eq`](./lean_stage3/WeilBackground.md#WeilBackground-online_term_eq) | theorem | shape | `WeilBackground` | laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ)) = (((h / 2) ^ 2 * (WeilTransform.Psi (h * (ρ.im + γ)) + WeilTransform.Psi (h * (ρ.im - γ))) ^ 2 : ℝ) : ℂ) |
| [`WeilPowerBackground.online_term_eq`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-online_term_eq) | theorem | shape | `WeilPowerBackground` | laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ)) = (((h / 2) ^ 2 * (PsiW m (h * (ρ.im + γ)) + PsiW m (h * (ρ.im - γ))) ^ 2 : ℝ) : ℂ) |
| [`WeilBackground.online_term_le_far`](./lean_stage3/WeilBackground.md#WeilBackground-online_term_le_far) | theorem | shape | `WeilBackground` | (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re ≤ (h / 2) ^ 2 * ((2 * Real.pi + Real.pi ^ 2) / (h * (ρ.im - γ)) ^ 2 + (2 * Real.pi + Real.pi ^ 2) / (h * (ρ.im + γ)) ^ 2) ^ 2 |
| [`WeilPowerBackground.online_term_le_far`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-online_term_le_far) | theorem | shape | `WeilPowerBackground` | (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re ≤ (h / 2) ^ 2 * (cS m * (2 / (h * (ρ.im - γ)) ^ 2) ^ (m + 1) + cS m * (2 / (h * (ρ.im + γ)) ^ 2) ^ (m + 1)) ^ 2 |
| [`WeilBackground.online_term_le_near`](./lean_stage3/WeilBackground.md#WeilBackground-online_term_le_near) | theorem | shape | `WeilBackground` | (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re ≤ 4 * h ^ 2 |
| [`WeilPowerBackground.online_term_le_near`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-online_term_le_near) | theorem | shape | `WeilPowerBackground` | (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re ≤ 4 * h ^ 2 |
| [`WeilPowerBackground.online_term_nonneg`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-online_term_nonneg) | theorem | shape | `WeilPowerBackground` | 0 ≤ (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re |
| [`WeilTiles.online_term_nonneg`](./lean_stage3/WeilTiles.md#WeilTiles-online_term_nonneg) | theorem | shape | `WeilTiles` | 0 ≤ (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re |
| [`WeilOnLine.onLineBound`](./lean_stage3/WeilOnLine.md#WeilOnLine-onLineBound) | def | reads ζ | `WeilOnLine` | ℝ |
| [`WeilPowerOnLine.onLineBound`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-onLineBound) | def | reads ζ | `WeilPowerOnLine` | ℝ |
| [`WeilOnLine.onLineBound_le`](./lean_stage3/WeilOnLine.md#WeilOnLine-onLineBound_le) | theorem | reads ζ | `WeilOnLine` | onLineBound h γ ≤ 2 * (88 * (γ + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2) * (Real.pi ^ 2 / 6)) + 4 * h ^ 2 * lowCount |
| [`WeilPowerOnLine.onLineBound_le`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-onLineBound_le) | theorem | reads ζ | `WeilPowerOnLine` | onLineBound h γ m ≤ 2 * (88 * (γ + r h m + 2) ^ 4 * (4 * h ^ 2 + cFarM m / h ^ 2) * (Real.pi ^ 2 / 6)) + 4 * h ^ 2 * lowCount |
| [`FiniteOffLine.onLineInv`](./lean_stage3/FiniteOffLine.md#FiniteOffLine-onLineInv) | def | reads ζ | `FiniteOffLine` | ℝ |
| [`FiniteOffLine.onLineInv_le_dyadic`](./lean_stage3/FiniteOffLine.md#FiniteOffLine-onLineInv_le_dyadic) | theorem | reads ζ | `FiniteOffLine` | onLineInv ρ ≤ 2 * ∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹ * (if \|(ρ : ℂ).im\| &lt; 2 ^ (j + 1) then 1 else 0) |
| [`FiniteOffLine.onLineInv_nonneg`](./lean_stage3/FiniteOffLine.md#FiniteOffLine-onLineInv_nonneg) | theorem | reads ζ | `FiniteOffLine` | 0 ≤ onLineInv ρ |
| [`ContourShift.order_bridge`](./lean_stage3/ContourShift.md#ContourShift-order_bridge) | theorem | reads ζ | `ContourShift` | ((riemannZeta.order ρ : ℤ) : ℂ) = ((analyticOrderNatAt riemannZeta ρ : ℕ) : ℂ) |
| [`WeilBands.order_eq_analyticOrderNatAt`](./lean_stage3/WeilBands.md#WeilBands-order_eq_analyticOrderNatAt) | theorem | reads ζ | `WeilBands` | ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) = (analyticOrderNatAt riemannZeta (ρ : ℂ) : ℝ) |
| [`WeilBridgeLeaf.order_eq_toNat`](./lean_stage3/WeilBridgeLeaf.md#WeilBridgeLeaf-order_eq_toNat) | theorem | reads ζ | `WeilBridgeLeaf` | riemannZeta.order ρ = (((analyticOrderAt riemannZeta ρ).toNat : ℕ) : ℤ) |
| [`ZeroSummable.order_le_log`](./lean_stage3/ZeroSummable.md#ZeroSummable-order_le_log) | theorem | reads ζ | `ZeroSummable` | ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) ≤ 15 * Real.log (\|(ρ : ℂ).im\| + 1) + 73 |
| [`ZeroSummable.order_le_log_pos`](./lean_stage3/ZeroSummable.md#ZeroSummable-order_le_log_pos) | theorem | reads ζ | `ZeroSummable` | ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) ≤ 15 * Real.log ((ρ : ℂ).im + 1) + 73 |
| [`ZeroSummable.order_le_shell`](./lean_stage3/ZeroSummable.md#ZeroSummable-order_le_shell) | theorem | reads ζ | `ZeroSummable` | ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) ≤ 103 * ((j : ℝ) + 1) |
| [`FiniteOffLine.order_nonneg`](./lean_stage3/FiniteOffLine.md#FiniteOffLine-order_nonneg) | theorem | reads ζ | `FiniteOffLine` | (0 : ℝ) ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) |
| [`FiniteOffLinePi.ordR`](./lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-ordR) | def | reads ζ | `FiniteOffLinePi` | ℝ |
| [`FiniteOffLinePi.ordR_nonneg`](./lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-ordR_nonneg) | theorem | reads ζ | `FiniteOffLinePi` | 0 ≤ ordR ρ |
| [`LeftKernel.osc_by_parts`](./lean_stage3/LeftKernel.md#LeftKernel-osc_by_parts) | theorem | shape | `LeftKernel` | ‖∫ t in a..b, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) * h t‖ ≤ (‖h a‖ + ‖h b‖ + ∫ t in a..b, ‖h' t‖) / Real.log y |
| [`Propagation.outside_cone_zero`](./lean/Propagation.md#Propagation-outside_cone_zero) | theorem | counting | `Propagation` | tableFrom (deltaRow s) r d = 0 |
| [`WeilPowerPhase.P`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-P) | def | shape | `WeilPowerPhase` | ℂ |
| [`WeilWindow.P`](./lean_stage3/WeilWindow.md#WeilWindow-P) | def | shape | `WeilWindow` | ℝ |
| [`WeilLobe.P_eq`](./lean_stage3/WeilLobe.md#WeilLobe-P_eq) | theorem | shape | `WeilLobe` | P x = (1 + Real.cos (Real.pi * x)) / 2 |
| [`WeilPower.P_eq_c_sq`](./lean_stage3/WeilPower.md#WeilPower-P_eq_c_sq) | theorem | shape | `WeilPower` | P x = c x ^ 2 |
| [`WeilTransform.P_even`](./lean_stage3/WeilTransform.md#WeilTransform-P_even) | theorem | shape | `WeilTransform` | P (-x) = P x |
| [`WeilWindow.P_ge_half`](./lean_stage3/WeilWindow.md#WeilWindow-P_ge_half) | theorem | shape | `WeilWindow` | 1 / 2 ≤ P x |
| [`WeilWindow.P_le_one`](./lean_stage3/WeilWindow.md#WeilWindow-P_le_one) | theorem | shape | `WeilWindow` | P x ≤ 1 |
| [`WeilWindow.P_neg_one`](./lean_stage3/WeilWindow.md#WeilWindow-P_neg_one) | theorem | shape | `WeilWindow` | P (-1) = 0 |
| [`WeilWindow.P_nonneg`](./lean_stage3/WeilWindow.md#WeilWindow-P_nonneg) | theorem | shape | `WeilWindow` | 0 ≤ P x |
| [`WeilWindow.P_one`](./lean_stage3/WeilWindow.md#WeilWindow-P_one) | theorem | shape | `WeilWindow` | P 1 = 0 |
| [`WeilPower.P_pow`](./lean_stage3/WeilPower.md#WeilPower-P_pow) | theorem | shape | `WeilPower` | P x ^ m = c x ^ (2 * m) |
| [`WeilPowerPhase.P_tendsto`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-P_tendsto) | theorem | shape | `WeilPowerPhase` | Tendsto (fun n =&gt; Complex.exp (w ^ 2 * ((sigmaN m n : ℝ) : ℂ))) atTop (𝓝 (P m w)) |
| [`Transform.pair_collapses_iff_critical`](./lean/Transform.md#Transform-pair_collapses_iff_critical) | theorem | shape | `Transform` | ‖(b : ℂ) ^ (-s)‖ = ‖(b : ℂ) ^ (-(1 - s))‖ ↔ s.re = 1 / 2 |
| [`PairIdentity.pair_identity`](./lean/PairIdentity.md#PairIdentity-pair_identity) | theorem | counting | `PairIdentity` | tableFrom P r d + tableFrom C r d = (b - 1) ^ (d + 1) * b ^ e |
| [`Zeros.pair_shares_diagonal`](./lean/Zeros.md#Zeros-pair_shares_diagonal) | theorem | counting | `Zeros` | (r - 1) - (d : ℤ) = r - ((d + 1 : ℕ) : ℤ) |
| [`ZeroCells.pairIdentity_all_vanish`](./lean/ZeroCells.md#ZeroCells-pairIdentity_all_vanish) | theorem | counting | `ZeroCells` | ∀ c ∈ PairIdentity.zero_cells, Construction.tableFrom Zeros.dyadicRow (c.1 : ℤ) c.2 = 0 |
| [`ZeroCells.pairIdentity_eq`](./lean/ZeroCells.md#ZeroCells-pairIdentity_eq) | theorem | counting | `ZeroCells` | PairIdentity.zero_cells = Zeros.measured_zeros |
| [`Bridge.paperFT_kOf`](./lean_bridge/WeilBridge.md#Bridge-paperFT_kOf) | theorem | shape | `WeilBridge` | paperFT (kOf G) (gammaOf ρ) = laplace G (-ρ) * laplace G (-(1 - ρ)) |
| [`ContourShift.partner_zero`](./lean_stage3/ContourShift.md#ContourShift-partner_zero) | theorem | reads ζ | `ContourShift` | ∃ ρ' : ℂ, riemannZeta ρ' = 0 ∧ ρ'.im = ρ.im ∧ 1/2 ≤ ρ'.re ∧ ρ'.re &lt; 1 |
| [`Propagation.pasc`](./lean/Propagation.md#Propagation-pasc) | def | counting | `Propagation` | ℕ → ℕ → ℤ |
| [`Propagation.pasc_eq_zero`](./lean/Propagation.md#Propagation-pasc_eq_zero) | theorem | counting | `Propagation` | pasc n k = 0 |
| [`Propagation.pasc_pos`](./lean/Propagation.md#Propagation-pasc_pos) | theorem | counting | `Propagation` | 0 &lt; pasc n k |
| [`Propagation.pasc_succ`](./lean/Propagation.md#Propagation-pasc_succ) | theorem | counting | `Propagation` | pasc (n + 1) (k + 1) = pasc n k + pasc n (k + 1) |
| [`Propagation.pasc_zero`](./lean/Propagation.md#Propagation-pasc_zero) | theorem | counting | `Propagation` | pasc n 0 = 1 |
| [`GeneratorPeak.perBlock`](./lean/GeneratorPeak.md#GeneratorPeak-perBlock) | def | shape | `GeneratorPeak` | ℝ |
| [`Chain.period_vacuous_at_one`](./lean/Chain.md#Chain-period_vacuous_at_one) | theorem | shape | `Chain` | Function.Periodic f (2 * Real.pi / Real.log 1) |
| [`Transform.periodLattice`](./lean/Transform.md#Transform-periodLattice) | def | shape | `Transform` | AddSubgroup ℂ |
| [`Transform.periodLattice_discrete`](./lean/Transform.md#Transform-periodLattice_discrete) | theorem | shape | `Transform` | DiscreteTopology (periodLattice b) |
| [`Transform.periodLattice_eq_span`](./lean/Transform.md#Transform-periodLattice_eq_span) | theorem | shape | `Transform` | periodLattice b = (Submodule.span ℤ (Set.range (latticeBasis hb))).toAddSubgroup |
| [`PerronKernel.perron_kernel_coarse`](./lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_coarse) | theorem | reads ζ | `PerronKernel` | ‖perronI y c T - perronδ y‖ ≤ y ^ c |
| [`PerronKernel.perron_kernel_coarse_gt`](./lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_coarse_gt) | theorem | reads ζ | `PerronKernel` | ‖perronI y c T - perronδ y‖ ≤ y ^ c |
| [`PerronKernel.perron_kernel_coarse_lt`](./lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_coarse_lt) | theorem | reads ζ | `PerronKernel` | ‖perronI y c T - perronδ y‖ ≤ y ^ c |
| [`PerronKernel.perron_kernel_decay`](./lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_decay) | theorem | reads ζ | `PerronKernel` | ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * \|Real.log y\|) |
| [`PerronKernel.perron_kernel_decay_gt`](./lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_decay_gt) | theorem | reads ζ | `PerronKernel` | ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * \|Real.log y\|) |
| [`PerronKernel.perron_kernel_decay_lt`](./lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_decay_lt) | theorem | reads ζ | `PerronKernel` | ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * \|Real.log y\|) |
| [`PerronKernel.perron_kernel_truncated`](./lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_truncated) | theorem | reads ζ | `PerronKernel` | ‖perronI y c T - perronδ y‖ ≤ y ^ c * min 1 (1 / (T * \|Real.log y\|)) |
| [`PerronKernel.perron_sum_eq_integral`](./lean_stage3/PerronKernel.md#PerronKernel-perron_sum_eq_integral) | theorem | reads ζ | `PerronKernel` | (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronI (x/n) (1 + 1/Real.log x) T) = (2 * (Real.pi:ℂ) * Complex.I)⁻¹ * ∫ t in (-T)..T, (- deriv riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I… |
| [`PerronTwo.perron_sum_eq_integral_two`](./lean_stage3/PerronTwo.md#PerronTwo-perron_sum_eq_integral_two) | theorem | reads ζ | `PerronTwo` | (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronI (x/n) (1 + 1/Real.log x) T) = (2 * (Real.pi:ℂ) * Complex.I)⁻¹ * ∫ t in (-T)..T, (- deriv riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I… |
| [`PerronKernel.perron_to_psi`](./lean_stage3/PerronKernel.md#PerronKernel-perron_to_psi) | theorem | reads ζ | `PerronKernel` | ‖(Chebyshev.psi x : ℂ) - ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronI (x/n) (1 + 1/Real.log x) T‖ ≤ 600 * x * Real.log (x * T) ^ 2 / T + 13 * Real.log x |
| [`PerronTwo.perron_to_psi_two`](./lean_stage3/PerronTwo.md#PerronTwo-perron_to_psi_two) | theorem | reads ζ | `PerronTwo` | ‖(Chebyshev.psi x : ℂ) - ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronI (x/n) (1 + 1/Real.log x) T‖ ≤ 700 * x * Real.log (x * T) ^ 2 / T + 18 * Real.log x |
| [`PerronKernel.perronI`](./lean_stage3/PerronKernel.md#PerronKernel-perronI) | def | shape | `PerronKernel` | ℂ |
| [`PerronKernel.perronI_eq_VIntegral'`](./lean_stage3/PerronKernel.md#PerronKernel-perronI_eq_VIntegral-) | theorem | reads ζ | `PerronKernel` | perronI y c T = VIntegral' (fun s : ℂ ↦ (y : ℂ) ^ s / s) c (-T) T |
| [`PerronKernel.perronI_one_norm`](./lean_stage3/PerronKernel.md#PerronKernel-perronI_one_norm) | theorem | shape | `PerronKernel` | ‖perronI 1 c T‖ ≤ 1/2 |
| [`PerronKernel.perronδ`](./lean_stage3/PerronKernel.md#PerronKernel-perron-) | def | shape | `PerronKernel` | ℂ |
| [`NyquistPeak.phase_at_boundaryBase`](./lean/NyquistPeak.md#NyquistPeak-phase_at_boundaryBase) | theorem | shape | `NyquistPeak` | γ * Real.log (boundaryBase γ) = Real.pi |
| [`WeilPowerNear.phase_le`](./lean_stage3/WeilPowerNear.md#WeilPowerNear-phase_le) | theorem | shape | `WeilPowerNear` | 4 * e' * D * WeilPowerGeomGen.uLam lam h ≤ 4 * e' * D * ((b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) |
| [`Stage3.phasePoint`](./lean_stage3/Stirling.md#Stage3-phasePoint) | def | shape | `Stirling` | ℝ |
| [`ArgCount.phasePoint_bound_near`](./lean_stage3/ArgCount.md#ArgCount-phasePoint_bound_near) | theorem | reads ζ | `ArgCount` | ∃ M : ℝ, 0 ≤ M ∧ ∀ t ∈ Set.Icc (T₀ - 1) T₀, \|Stage3.phasePoint t\| ≤ M |
| [`Stage3.phasePoint_compact_le`](./lean_stage3/Stirling.md#Stage3-phasePoint_compact_le) | theorem | reads ζ | `Stirling` | ∀ t ∈ Set.Icc (0 : ℝ) 1, \|phasePoint t\| ≤ 8 |
| [`Stage3.phasePoint_eq`](./lean_stage3/Stirling.md#Stage3-phasePoint_eq) | theorem | shape | `Stirling` | phasePoint t = (Complex.digamma (zq t)).re |
| [`Stage3.phaseTheta`](./lean_stage3/Stirling.md#Stage3-phaseTheta) | def | shape | `Stirling` | ℝ |
| [`ArgCount.phaseTheta_sub_le`](./lean_stage3/ArgCount.md#ArgCount-phaseTheta_sub_le) | theorem | reads ζ | `ArgCount` | \|Stage3.phaseTheta T₀ - Stage3.phaseTheta T\| ≤ (T₀ - T) * (M / 2 + Real.log Real.pi / 2) |
| [`Stage3.phaseTheta_zero`](./lean_stage3/Stirling.md#Stage3-phaseTheta_zero) | theorem | shape | `Stirling` | phaseTheta 0 = 0 |
| [`LandauMellinG.Phi`](./lean_stage3/LandauMellinG.md#LandauMellinG-Phi) | def | reads ζ | `LandauMellinG` | ℂ |
| [`WeilBackground.phi`](./lean_stage3/WeilBackground.md#WeilBackground-phi) | def | shape | `WeilBackground` | ℝ |
| [`LandauPoleLocal.Phi_principal_part`](./lean_stage3/LandauPoleLocal.md#LandauPoleLocal-Phi_principal_part) | theorem | reads ζ | `LandauPoleLocal` | ∃ h : ℂ → ℂ, AnalyticAt ℂ h ρ ∧ ∀ᶠ s in 𝓝[≠] ρ, LandauMellinG.Phi s = h s + (analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ)) / (s - ρ) |
| [`LandauPoleLocal.Phi_regular_at_one`](./lean_stage3/LandauPoleLocal.md#LandauPoleLocal-Phi_regular_at_one) | theorem | reads ζ | `LandauPoleLocal` | ∃ h : ℂ → ℂ, AnalyticAt ℂ h 1 ∧ ∀ᶠ s in 𝓝[≠] 1, LandauMellinG.Phi s = h s |
| [`LandauPoleDisc.Phi_taylor_on_disc`](./lean_stage3/LandauPoleDisc.md#LandauPoleDisc-Phi_taylor_on_disc) | theorem | reads ζ | `LandauPoleDisc` | ∃ (P : Finset ℂ) (C : ℝ), (∀ ρ, ρ ∈ P ↔ ρ ∈ ball c R₂ ∧ ρ ≠ 1 ∧ riemannZeta ρ = 0) ∧ ∀ k : ℕ, ‖iteratedDeriv k LandauMellinG.Phi c - ∑ ρ ∈ P, (analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ)) * (… |
| [`WeilBackground.phiC`](./lean_stage3/WeilBackground.md#WeilBackground-phiC) | def | shape | `WeilBackground` | ℝ → ℂ |
| [`WeilBackground.phiC_real`](./lean_stage3/WeilBackground.md#WeilBackground-phiC_real) | theorem | shape | `WeilBackground` | (phiC h γ u).im = 0 |
| [`WeilPowerBackground.phiW`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-phiW) | def | shape | `WeilPowerBackground` | ℝ |
| [`WeilPowerAssembly.phiW_contDiff_one`](./lean_stage3/WeilPowerAssembly.md#WeilPowerAssembly-phiW_contDiff_one) | theorem | shape | `WeilPowerAssembly` | ContDiff ℝ 1 (WeilPowerBackground.phiW h γ m) |
| [`WeilPowerBackground.phiWC`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-phiWC) | def | shape | `WeilPowerBackground` | ℝ → ℂ |
| [`WeilPowerBackground.phiWC_real`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-phiWC_real) | theorem | shape | `WeilPowerBackground` | (phiWC h γ m u).im = 0 |
| [`Zeros.pi2`](./lean/Zeros.md#Zeros-pi2) | def | counting | `Zeros` | ℕ → ℤ |
| [`PiZeros.pi_eq_zero_sum`](./lean_stage3/PiZeros.md#PiZeros-pi_eq_zero_sum) | theorem | reads ζ | `PiZeros` | (((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x : ℝ) : ℂ) = -∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x + tr (efRem T) x - tr psiTheta x |
| [`PiFixedRow.pi_fixed_row`](./lean_stage3/PiFixedRow.md#PiFixedRow-pi_fixed_row) | theorem | reads ζ | `PiFixedRow` | ∀ ε : ℝ, 0 &lt; ε → ∀ᶠ T : ℝ in Filter.atTop, ‖(((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x : ℝ) : ℂ) + ∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x + tr psiTheta x‖ ≤ Api * Real.… |
| [`FixedRowTwo.pi_fixed_row_two`](./lean_stage3/FixedRowTwo.md#FixedRowTwo-pi_fixed_row_two) | theorem | reads ζ | `FixedRowTwo` | ∀ ε : ℝ, 0 &lt; ε → ∀ᶠ T : ℝ in Filter.atTop, ‖(((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x : ℝ) : ℂ) + ∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x + tr psiTheta x‖ ≤ Api2 * (1 +… |
| [`Stage3.pi_mul_N_eq`](./lean_stage3/ArgIdentity.md#Stage3-pi_mul_N_eq) | theorem | reads ζ | `ArgIdentity` | Real.pi * riemannZeta.N T = (∫ t in (0:ℝ)..T, logDeriv xi (2 + (t : ℂ) * Complex.I)).re - (∫ x in (1/2:ℝ)..2, logDeriv xi ((x : ℂ) + T * Complex.I)).im |
| [`Stage3.pi_sub_Li_eq`](./lean_stage3/PsiToPi.md#Stage3-pi_sub_Li_eq) | theorem | shape | `PsiToPi` | (Nat.primeCounting ⌊x⌋₊ : ℝ) - Li x = (θ x - x) / Real.log x + ∫ t in (2 : ℝ)..x, (θ t - t) / (t * Real.log t ^ 2) |
| [`PiZeros.pi_sub_Li_eq_tr`](./lean_stage3/PiZeros.md#PiZeros-pi_sub_Li_eq_tr) | theorem | shape | `PiZeros` | (((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x : ℝ) : ℂ) = tr (fun t =&gt; ((θ t - t : ℝ) : ℂ)) x |
| [`PiZeros.piMode`](./lean_stage3/PiZeros.md#PiZeros-piMode) | def | shape | `PiZeros` | ℂ |
| [`FiniteOffLinePi.piMode_eq`](./lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-piMode_eq) | theorem | shape | `FiniteOffLinePi` | piMode ρ x = (x : ℂ) ^ ρ / ρ / (Real.log x : ℂ) + ipart ρ x |
| [`MollifiedMean.PM_sub_one_eq`](./lean_stage3/MollifiedMean.md#MollifiedMean-PM_sub_one_eq) | theorem | shape | `MollifiedMean` | (∑ m ∈ Icc 1 N, (m : ℂ) ^ (-s)) * M X s - 1 = ∑ n ∈ Icc 1 (N * X), (b X N n : ℂ) * (n : ℂ) ^ (-s) |
| [`Stage3.pole_away`](./lean_stage3/JensenCount.md#Stage3-pole_away) | theorem | shape | `JensenCount` | 2 * z + (2 + Complex.I * (T : ℂ)) ≠ 1 |
| [`Stage3.pole_away_centre`](./lean_stage3/JensenCount.md#Stage3-pole_away_centre) | theorem | shape | `JensenCount` | v ≠ 1 |
| [`Transform.poleLattice`](./lean/Transform.md#Transform-poleLattice) | def | shape | `Transform` | AddSubgroup ℂ |
| [`FilterLadder.posPoly`](./lean_stage3/FilterLadder.md#FilterLadder-posPoly) | def | counting | `FilterLadder` | Polynomial ℝ |
| [`TableDepths.pow_lower`](./lean_stage3/TableDepths.md#TableDepths-pow_lower) | theorem | shape | `TableDepths` | (0.6931:ℝ) ^ k ≤ Real.log 2 ^ k |
| [`JointDialGate.powerSaving_relErr`](./lean_stage3/JointDialGate.md#JointDialGate-powerSaving_relErr) | theorem | shape | `JointDialGate` | StmtRelErrWindow f L r n (A * (2 : ℝ) ^ (((r : ℝ) - n) * (θ - 1))) |
| [`RelativeGate.powerSaving_relErr`](./lean/RelativeGate.md#RelativeGate-powerSaving_relErr) | theorem | shape | `RelativeGate` | StmtRelErrWindow f L r n (A * (2 : ℝ) ^ (((r : ℝ) - n) * (θ - 1))) |
| [`VonKoch.preconnected_region`](./lean_stage3/VonKochScaffold.md#VonKoch-preconnected_region) | theorem | shape | `VonKochScaffold` | IsPreconnected region |
| [`Stage3.preconnected_regionθ`](./lean_stage3/ThetaConverse.md#Stage3-preconnected_region-) | theorem | shape | `ThetaConverse` | IsPreconnected (regionθ θ) |
| [`ZetaGrowth.preconnected_stripRegion`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-preconnected_stripRegion) | theorem | shape | `ZetaGrowth` | IsPreconnected stripRegion |
| [`Measured.predicted_elliptic_re`](./lean/Measured.md#Measured-predicted_elliptic_re) | def | shape | `Measured` | ℝ |
| [`Measured.predicted_radius_resid`](./lean/Measured.md#Measured-predicted_radius_resid) | def | shape | `Measured` | ℝ |
| [`Measured.predicted_radius_smooth`](./lean/Measured.md#Measured-predicted_radius_smooth) | def | shape | `Measured` | ℝ |
| [`Measured.predicted_rank_11a1`](./lean/Measured.md#Measured-predicted_rank_11a1) | def | shape | `Measured` | ℝ |
| [`Measured.predicted_rank_37a1`](./lean/Measured.md#Measured-predicted_rank_37a1) | def | shape | `Measured` | ℝ |
| [`Measured.predicted_rank_389a1`](./lean/Measured.md#Measured-predicted_rank_389a1) | def | shape | `Measured` | ℝ |
| [`Elephant.primeCount_backward_diff`](./lean/Elephant.md#Elephant-primeCount_backward_diff) | theorem | shape | `Elephant` | ∑ m ∈ Finset.range (b ^ (r + 1) + 1), (primeIndicator m - (if b ∣ m then primeIndicator (m / b) else 0)) = (Nat.primeCounting (b ^ (r + 1)) : ℂ) - (Nat.primeCounting (b ^ r) : ℂ) |
| [`Zeros.primeFactors_eq_of_meets`](./lean/ZerosStencil.md#Zeros-primeFactors_eq_of_meets) | theorem | counting | `ZerosStencil` | b.primeFactors = c.primeFactors |
| [`Elephant.primeIndicator`](./lean/Elephant.md#Elephant-primeIndicator) | def | shape | `Elephant` | ℕ → ℂ |
| [`Elephant.primeRow`](./lean/Elephant.md#Elephant-primeRow) | def | counting | `Elephant` | ℕ → ℤ |
| [`Elephant.primeRowZ`](./lean/Elephant.md#Elephant-primeRowZ) | def | shape | `Elephant` | ℤ → ℂ |
| [`Bridge.primeSide`](./lean_bridge/WeilBridge.md#Bridge-primeSide) | def | shape | `WeilBridge` | ℂ |
| [`Bridge.primeSide_eq`](./lean_bridge/WeilBridge.md#Bridge-primeSide_eq) | theorem | shape | `WeilBridge` | primeSide k = literatureRHS k |
| [`Bridge.primeSideM`](./lean_bridge/WeilBridge.md#Bridge-primeSideM) | def | shape | `WeilBridge` | ℂ |
| [`WeilBridgeLeaf.primeSideM`](./lean_stage3/WeilBridgeLeaf.md#WeilBridgeLeaf-primeSideM) | def | shape | `WeilBridgeLeaf` | ℂ |
| [`Bridge.primeSideM_eq`](./lean_bridge/WeilBridge.md#Bridge-primeSideM_eq) | theorem | shape | `WeilBridge` | primeSideM k = primeSide k |
| [`Elephant.primeTable_eq_stencil`](./lean/Elephant.md#Elephant-primeTable_eq_stencil) | theorem | counting | `Elephant` | ((fwdDiff (1 : ℕ))^[d] (primeRow b)) r = ∑ k ∈ Finset.range (d + 1), ((-1 : ℤ) ^ (d - k) * d.choose k) • primeRow b (r + k • 1) |
| [`Elephant.primeTable_eq_sym_weighted`](./lean/Elephant.md#Elephant-primeTable_eq_sym_weighted) | theorem | shape | `Elephant` | (bdiff^[d]) (primeRowZ b) r = ∑ i ∈ s, c i * (Sym (b : ℝ) (ρ i)) ^ d * mode (b : ℝ) (ρ i) r |
| [`Mollified.prod_eq_sum`](./lean_stage3/Mollified.md#Mollified-prod_eq_sum) | theorem | shape | `Mollified` | (∑ m ∈ Icc 1 N, (m : ℂ) ^ (-s)) * (∑ d ∈ Ico 1 X, (ArithmeticFunction.moebius d : ℂ) * (d : ℂ) ^ (-s)) = ∑ n ∈ Icc 1 (N * X), (coef X N n : ℂ) * (n : ℂ) ^ (-s) |
| [`ZetaEM.prod_norm_le`](./lean_stage3/ZetaEM.md#ZetaEM-prod_norm_le) | theorem | shape | `ZetaEM` | ∏ i ∈ Finset.range j, ‖s + i‖ ≤ (‖s‖ + k) ^ j |
| [`Propagation.propagator`](./lean/Propagation.md#Propagation-propagator) | theorem | counting | `Propagation` | tableFrom (deltaRow s) (s + (k : ℤ)) d = (-1) ^ k * pasc d k |
| [`SeedPerturbation.protected_at_R_three`](./lean/SeedPerturbation.md#SeedPerturbation-protected_at_R_three) | theorem | counting | `SeedPerturbation` | zero_cells.map (fun c =&gt; decide (3 &lt; (c.1 : ℤ) - (c.2 : ℤ))) = [false, false, true, true] |
| [`SeedPerturbation.protected_at_R_two`](./lean/SeedPerturbation.md#SeedPerturbation-protected_at_R_two) | theorem | counting | `SeedPerturbation` | zero_cells.map (fun c =&gt; decide (2 &lt; (c.1 : ℤ) - (c.2 : ℤ))) = [false, true, true, true] |
| [`WeilPowerBounds.Ps`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-Ps) | def | shape | `WeilPowerBounds` | ℝ |
| [`WeilPowerBounds.Ps_le`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-Ps_le) | theorem | shape | `WeilPowerBounds` | Ps m s ≤ (s ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ^ (m + 1) |
| [`WeilPowerBounds.Ps_pos`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-Ps_pos) | theorem | shape | `WeilPowerBounds` | 0 &lt; Ps m s |
| [`Slice5.pseries_le`](./lean_stage3/LineBound.md#Slice5-pseries_le) | theorem | shape | `LineBound` | ∑' (n : ℕ), ((n : ℝ)) ^ (-1 - b) ≤ 1 + 1 / b |
| [`Slice5.pseries_tail_le`](./lean_stage3/LineBound.md#Slice5-pseries_tail_le) | theorem | shape | `LineBound` | ∑' (n : ℕ), ((n + 1 + 1 : ℕ) : ℝ) ^ (-1 - b) ≤ 1 / b |
| [`WeilTransform.Psi`](./lean_stage3/WeilTransform.md#WeilTransform-Psi) | def | shape | `WeilTransform` | ℝ |
| [`WeilBackground.Psi_bound`](./lean_stage3/WeilBackground.md#WeilBackground-Psi_bound) | theorem | shape | `WeilBackground` | \|WeilTransform.Psi s\| ≤ (2 * Real.pi + Real.pi ^ 2) / s ^ 2 |
| [`WeilBackground.Psi_le_two`](./lean_stage3/WeilBackground.md#WeilBackground-Psi_le_two) | theorem | shape | `WeilBackground` | \|WeilTransform.Psi s\| ≤ 2 |
| [`WeilOnLine.Psi_neg`](./lean_stage3/WeilOnLine.md#WeilOnLine-Psi_neg) | theorem | shape | `WeilOnLine` | WeilTransform.Psi (-s) = -WeilTransform.Psi s |
| [`VonKoch.psi_partial_bigO`](./lean_stage3/VonKochScaffold.md#VonKoch-psi_partial_bigO) | theorem | reads ζ | `VonKochScaffold` | (fun n : ℕ ↦ ∑ k ∈ Finset.Icc 1 n, ArithmeticFunction.vonMangoldt k) =O[Filter.atTop] fun n : ℕ ↦ (n : ℝ) ^ (1:ℝ) |
| [`RHPull.psi_sub_self_le`](./lean_stage3/LineBound.md#RHPull-psi_sub_self_le) | theorem | reads ζ | `LineBound` | \|ψ X - X\| ≤ E₁ + E₂ + E₃ |
| [`RHPull.psi_weak_at`](./lean_stage3/LineBound.md#RHPull-psi_weak_at) | theorem | reads ζ | `LineBound` | \|ψ X - X\| ≤ (c₁ + c₂ + c₃) * Real.sqrt X * (Real.log X) ^ 3 |
| [`RHPull.psi_weak_of_RH`](./lean_stage3/LineBound.md#RHPull-psi_weak_of_RH) | theorem | reads ζ | `LineBound` | ∃ C &gt; 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t → \|ψ t - t\| ≤ C * Real.sqrt t * (Real.log t) ^ 3 |
| [`Stage3.psi_weak_of_RH_half`](./lean_stage3/ThetaPsi.md#Stage3-psi_weak_of_RH_half) | theorem | reads ζ | `ThetaPsi` | ∃ C &gt; 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t → \|ψ t - t\| ≤ C * Real.sqrt t * (Real.log t) ^ 3 |
| [`Stage3.psi_weak_of_theta`](./lean_stage3/ThetaPsi.md#Stage3-psi_weak_of_theta) | theorem | reads ζ | `ThetaPsi` | ∃ C &gt; 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t → \|ψ t - t\| ≤ C * t ^ θ * (Real.log t) ^ 3 |
| [`CellBdiff.psiRow`](./lean_stage3/CellBdiff.md#CellBdiff-psiRow) | def | shape | `CellBdiff` | ℂ → ℂ |
| [`CellBdiff.psiRow_int`](./lean_stage3/CellBdiff.md#CellBdiff-psiRow_int) | theorem | shape | `CellBdiff` | psiRow (n : ℂ) = (Chebyshev.psi ((2:ℝ) ^ n) : ℂ) |
| [`PiZeros.psiTheta`](./lean_stage3/PiZeros.md#PiZeros-psiTheta) | def | shape | `PiZeros` | ℂ |
| [`WeilPowerBackground.PsiW`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-PsiW) | def | shape | `WeilPowerBackground` | ℝ |
| [`WeilPowerBackground.PsiW_le_far`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-PsiW_le_far) | theorem | shape | `WeilPowerBackground` | \|PsiW m t\| ≤ cS m * (2 / t ^ 2) ^ (m + 1) |
| [`WeilPowerBackground.PsiW_le_two`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-PsiW_le_two) | theorem | shape | `WeilPowerBackground` | \|PsiW m t\| ≤ 2 |
| [`WeilPowerOnLine.PsiW_neg`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-PsiW_neg) | theorem | shape | `WeilPowerOnLine` | PsiW m (-t) = -PsiW m t |
| [`Stage3.psiWeak_floor`](./lean_stage3/AssemblyFloor.md#Stage3-psiWeak_floor) | theorem | reads ζ | `AssemblyFloor` | StmtPsiWeak (floorConst c₁ c₂ b₁ b₂ b₃ W x₀) 2 x₀ |
| [`Stage3.psiWeak_floor_split`](./lean_stage3/GlueFloor.md#Stage3-psiWeak_floor_split) | theorem | reads ζ | `GlueFloor` | StmtPsiWeak (floorConstSplit c₁ c₃ c₄ b₁ b₂ b₃ W x₀) 2 x₀ |
| [`Stage3.psiWeak_of_RH_EF_NT`](./lean_stage3/Assembly.md#Stage3-psiWeak_of_RH_EF_NT) | theorem | reads ζ | `Assembly` | StmtPsiWeak (9 * c₁ + c₂ + 28 + 16 * b₁ + 16 * b₂ + 8 * b₃ + 4 * W) 2 (max x₁ 16) |
| [`PiToPsi.psiWeak_of_schoenfeldWeak`](./lean_stage3/PiToPsi.md#PiToPsi-psiWeak_of_schoenfeldWeak) | theorem | shape | `PiToPsi` | ∃ C' &gt; 0, ∃ x₁ : ℝ, StmtPsiWeak C' 3 x₁ |
| [`JointWindowDial.psiWeakTheta_of_window`](./lean_stage3/JointWindowDial.md#JointWindowDial-psiWeakTheta_of_window) | theorem | reads ζ | `JointWindowDial` | ∃ C' &gt; 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t → \|Chebyshev.psi t - t\| ≤ C' * t ^ θ * Real.log t ^ 3 |
| [`RHPull.pull_at_RH_abscissa`](./lean_stage3/LineBound.md#RHPull-pull_at_RH_abscissa) | theorem | reads ζ | `LineBound` | SmoothedChebyshev SmoothingF ε X = I₁ SmoothingF ε X T - I₂ SmoothingF ε T X (1 / 2 + 1 / Real.log X) + I₃₇ SmoothingF ε T X (1 / 2 + 1 / Real.log X) + I₈ SmoothingF ε T X (1 / 2 + 1 / Real.log X) + I… |
| [`Stage3.pull_at_theta_abscissa`](./lean_stage3/ThetaPsi.md#Stage3-pull_at_theta_abscissa) | theorem | reads ζ | `ThetaPsi` | SmoothedChebyshev SmoothingF ε X = I₁ SmoothingF ε X T - I₂ SmoothingF ε T X (σθ θ X) + I₃₇ SmoothingF ε T X (σθ θ X) + I₈ SmoothingF ε T X (σθ θ X) + I₉ SmoothingF ε X T + mellin (fun x ↦ (Smooth1 Sm… |
| [`WeilLobe.q`](./lean_stage3/WeilLobe.md#WeilLobe-q) | def | shape | `WeilLobe` | ℝ |
| [`WeilOddPower.q`](./lean_stage3/WeilOddPower.md#WeilOddPower-q) | def | shape | `WeilOddPower` | ℝ |
| [`WeilPower.Q`](./lean_stage3/WeilPower.md#WeilPower-Q) | def | shape | `WeilPower` | ℂ |
| [`WeilPowerPhase.q`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-q) | def | shape | `WeilPowerPhase` | ℝ |
| [`WeilLobe.q1`](./lean_stage3/WeilLobe.md#WeilLobe-q1) | def | shape | `WeilLobe` | ℝ |
| [`WeilLobe.q1_neg_one`](./lean_stage3/WeilLobe.md#WeilLobe-q1_neg_one) | theorem | shape | `WeilLobe` | q1 (-1) = 0 |
| [`WeilLobe.q1_one`](./lean_stage3/WeilLobe.md#WeilLobe-q1_one) | theorem | shape | `WeilLobe` | q1 1 = 0 |
| [`WeilLobe.q2`](./lean_stage3/WeilLobe.md#WeilLobe-q2) | def | shape | `WeilLobe` | ℝ |
| [`WeilLobe.q2_bound`](./lean_stage3/WeilLobe.md#WeilLobe-q2_bound) | theorem | shape | `WeilLobe` | \|q2 x\| ≤ Real.pi + Real.pi ^ 2 / 2 |
| [`WeilLobe.q_eq`](./lean_stage3/WeilLobe.md#WeilLobe-q_eq) | theorem | shape | `WeilLobe` | x * P x = q x |
| [`WeilOddPower.q_eq`](./lean_stage3/WeilOddPower.md#WeilOddPower-q_eq) | theorem | shape | `WeilOddPower` | q m x = -(2 / (((m : ℝ) + 1) * Real.pi)) * f1 (2 * m + 1) x |
| [`WeilLobe.q_neg_one`](./lean_stage3/WeilLobe.md#WeilLobe-q_neg_one) | theorem | shape | `WeilLobe` | q (-1) = 0 |
| [`WeilPowerPhase.q_nonneg`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-q_nonneg) | theorem | shape | `WeilPowerPhase` | 0 ≤ q m w |
| [`WeilOddPower.q_odd`](./lean_stage3/WeilOddPower.md#WeilOddPower-q_odd) | theorem | shape | `WeilOddPower` | q m (-x) = -q m x |
| [`WeilLobe.q_one`](./lean_stage3/WeilLobe.md#WeilLobe-q_one) | theorem | shape | `WeilLobe` | q 1 = 0 |
| [`WeilPower.Q_succ`](./lean_stage3/WeilPower.md#WeilPower-Q_succ) | theorem | shape | `WeilPower` | Q (m + 1) w = Q m w * (w ^ 2 + (Real.pi : ℂ) ^ 2 * ((m : ℂ) + 1) ^ 2) |
| [`WeilOddPower.Q_succ_eq`](./lean_stage3/WeilOddPower.md#WeilOddPower-Q_succ_eq) | theorem | shape | `WeilOddPower` | Q (m + 1) w = w * QS m w |
| [`WeilPowerCompare.qerr`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-qerr) | def | shape | `WeilPowerCompare` | ℝ |
| [`WeilPowerCompare.qerr_pos`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-qerr_pos) | theorem | shape | `WeilPowerCompare` | 0 &lt; qerr m ε' Δ ε |
| [`WeilOddPower.QS`](./lean_stage3/WeilOddPower.md#WeilOddPower-QS) | def | shape | `WeilOddPower` | ℂ |
| [`WeilPowerGauss.QS_eq_D_mul`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-QS_eq_D_mul) | theorem | shape | `WeilPowerGauss` | QS m w = (D m : ℂ) * ∏ j ∈ Finset.range (m + 1), g w j |
| [`WeilPowerBounds.QS_factor`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-QS_factor) | theorem | shape | `WeilPowerBounds` | QS m w = ∏ j ∈ Finset.range (m + 1), (w ^ 2 + ((Real.pi * ((j : ℝ) + 1) : ℝ) : ℂ) ^ 2) |
| [`WeilPowerBounds.QS_ne_zero`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-QS_ne_zero) | theorem | shape | `WeilPowerBounds` | QS m w ≠ 0 |
| [`WeilPowerCompare.QS_ne_zero_wOf`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-QS_ne_zero_wOf) | theorem | shape | `WeilPowerCompare` | QS m (wOf ε Δ h) ≠ 0 |
| [`WeilPowerBounds.QS_ofReal`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-QS_ofReal) | theorem | shape | `WeilPowerBounds` | QS m (s : ℂ) = ((Ps m s : ℝ) : ℂ) |
| [`WeilPowerBands.r`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-r) | def | shape | `WeilPowerBands` | ℝ |
| [`WeilPowerSigma.r_le`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-r_le) | theorem | shape | `WeilPowerSigma` | u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2 ≤ 1 / (Real.pi ^ 2 * (4 * (m : ℝ) + 6)) |
| [`WeilPowerSigma.r_pos`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-r_pos) | theorem | shape | `WeilPowerSigma` | 1 / (2 * Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2) ≤ u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2 |
| [`LandauMellin.rampK`](./lean_stage3/LandauMellin.md#LandauMellin-rampK) | def | shape | `LandauMellin` | ℂ |
| [`LandauMellin.rampK_eq_indicator`](./lean_stage3/LandauMellin.md#LandauMellin-rampK_eq_indicator) | theorem | shape | `LandauMellin` | rampK s n y = (Ioi (n : ℝ)).indicator (fun t : ℝ =&gt; (1 / (n : ℂ)) * (t : ℂ) ^ (-s) - (t : ℂ) ^ (-s - 1)) y |
| [`LandauMellin.rampK_integrable`](./lean_stage3/LandauMellin.md#LandauMellin-rampK_integrable) | theorem | shape | `LandauMellin` | IntegrableOn (rampK s n) (Ioi 1) |
| [`LandauMellin.rampK_integral`](./lean_stage3/LandauMellin.md#LandauMellin-rampK_integral) | theorem | shape | `LandauMellin` | ∫ y in Ioi (1 : ℝ), rampK s n y = (n : ℂ) ^ (-s) / (s * (s - 1)) |
| [`LandauMellin.rampK_integral_norm`](./lean_stage3/LandauMellin.md#LandauMellin-rampK_integral_norm) | theorem | shape | `LandauMellin` | ∫ y in Ioi (1 : ℝ), ‖rampK s n y‖ = (n : ℝ) ^ (-s.re) / (s.re * (s.re - 1)) |
| [`LandauWindow.rampSum`](./lean_stage3/LandauWindow.md#LandauWindow-rampSum) | def | shape | `LandauWindow` | ℝ |
| [`LandauMellin.rampSum_eq_tsum`](./lean_stage3/LandauMellin.md#LandauMellin-rampSum_eq_tsum) | theorem | shape | `LandauMellin` | LandauWindow.rampSum y = ∑' n : ℕ, Λ n * max (y / n - 1) 0 |
| [`LandauCrude.rampSum_le`](./lean_stage3/LandauCrude.md#LandauCrude-rampSum_le) | theorem | shape | `LandauCrude` | LandauWindow.rampSum y ≤ y * Real.log y * (1 + Real.log y) |
| [`LandauChebyshev.rampSum_le_log`](./lean_stage3/LandauChebyshev.md#LandauChebyshev-rampSum_le_log) | theorem | reads ζ | `LandauChebyshev` | LandauWindow.rampSum y ≤ y * (Real.log y + (Real.log 4 + 4)) |
| [`LandauMellinG.rampSum_mellin_integrable`](./lean_stage3/LandauMellinG.md#LandauMellinG-rampSum_mellin_integrable) | theorem | reads ζ | `LandauMellinG` | IntegrableOn (fun y : ℝ =&gt; (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1)) (Ioi 1) |
| [`LandauCrude.rampSum_nonneg`](./lean_stage3/LandauCrude.md#LandauCrude-rampSum_nonneg) | theorem | shape | `LandauCrude` | 0 ≤ LandauWindow.rampSum y |
| [`WeilPowerCompare.rate`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-rate) | def | shape | `WeilPowerCompare` | ℝ |
| [`WeilPowerCompare.rate_eq_of_le`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-rate_eq_of_le) | theorem | shape | `WeilPowerCompare` | rate m ε' Δ ε = -(cE m * (Δ ^ 2 + ε ^ 2 - ε' ^ 2)) |
| [`WeilPowerCompare.rate_neg_of_ge`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-rate_neg_of_ge) | theorem | shape | `WeilPowerCompare` | rate m ε' Δ ε &lt; 0 |
| [`WeilPowerCompare.rate_neg_of_le`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-rate_neg_of_le) | theorem | shape | `WeilPowerCompare` | rate m ε' Δ ε &lt; 0 |
| [`WeilPowerCompare.rate_neg_of_qerr`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-rate_neg_of_qerr) | theorem | shape | `WeilPowerCompare` | rate m ε' Δ ε &lt; 0 |
| [`Crossover.ratio`](./lean/Crossover.md#Crossover-ratio) | def | shape | `Crossover` | ℝ |
| [`FilterAttained.ratio`](./lean_stage3/FilterAttained.md#FilterAttained-ratio) | def | reads ζ | `FilterAttained` | ℂ |
| [`Crossover.ratio_strictMono`](./lean/Crossover.md#Crossover-ratio_strictMono) | theorem | shape | `Crossover` | StrictMono (ratio A B x y) |
| [`WeilPowerPhase.re_A_sq`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-re_A_sq) | theorem | shape | `WeilPowerPhase` | ((((cS m / D m : ℝ) : ℂ) * w * P m w) ^ 2).re = (cS m / D m) ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m) * ((w ^ 2).re * Real.cos (2 * (w ^ 2).im * sigma m) - (w ^ 2).im * Real.sin (2 * (w ^ 2).im * sig… |
| [`Stage3.re_digamma_sub_log_le`](./lean_stage3/Stirling.md#Stage3-re_digamma_sub_log_le) | theorem | reads ζ | `Stirling` | \|phasePoint t - Real.log ‖zq t‖\| ≤ 96 / t |
| [`Stage3.re_eq_half_of_RH`](./lean_stage3/Assembly.md#Stage3-re_eq_half_of_RH) | theorem | reads ζ | `Assembly` | (ρ : ℂ).re = 1 / 2 |
| [`WeilDetect.re_eq_half_of_RH`](./lean_stage3/WeilDetect.md#WeilDetect-re_eq_half_of_RH) | theorem | reads ζ | `WeilDetect` | (ρ : ℂ).re = 1 / 2 |
| [`AliasClass.re_inv_pos`](./lean_stage3/AliasClass.md#AliasClass-re_inv_pos) | theorem | shape | `AliasClass` | 0 &lt; (ρ⁻¹).re |
| [`LandauTrig.re_mul_geom_ge`](./lean_stage3/LandauTrig.md#LandauTrig-re_mul_geom_ge) | theorem | shape | `LandauTrig` | -(‖c‖ * (2 / ‖w - 1‖)) ≤ (c * ∑ n ∈ Finset.Ico a (a + N), w ^ n).re |
| [`AliasClass.re_order_div_pos`](./lean_stage3/AliasClass.md#AliasClass-re_order_div_pos) | theorem | reads ζ | `AliasClass` | 0 &lt; ((((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)).re |
| [`WeilPowerPhase.re_S_sq_ge`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-re_S_sq_ge) | theorem | shape | `WeilPowerPhase` | (cS m / D m) ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m) * ((w ^ 2).re * Real.cos (2 * (w ^ 2).im * sigma m) - (w ^ 2).im * Real.sin (2 * (w ^ 2).im * sigma m)) - (cS m / D m) ^ 2 * ‖w‖ ^ 2 * Real.exp (… |
| [`ArgLegs.re_sign_const`](./lean_stage3/ArgLegs.md#ArgLegs-re_sign_const) | theorem | shape | `ArgLegs` | (∀ x ∈ Set.Icc a b, 0 ≤ (g x).re) ∨ (∀ x ∈ Set.Icc a b, (g x).re ≤ 0) |
| [`WeilPowerPhase.re_sq_ge`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-re_sq_ge) | theorem | shape | `WeilPowerPhase` | ((((cS m / D m : ℝ) : ℂ) * w * P m w) ^ 2).re - ‖((cS m / D m : ℝ) : ℂ) * w * P m w‖ ^ 2 * (4 * q m w + 4 * q m w ^ 2) ≤ ((S m w) ^ 2).re |
| [`Stage3.re_sub_log_norm_le`](./lean_stage3/Stirling.md#Stage3-re_sub_log_norm_le) | theorem | shape | `Stirling` | \|w.re - Real.log ‖1 + w‖\| ≤ 8 * ‖w‖ ^ 2 |
| [`WeilPowerNear.re_term_eq`](./lean_stage3/WeilPowerNear.md#WeilPowerNear-re_term_eq) | theorem | shape | `WeilPowerNear` | (WeilPowerShell.coef e' D e * Complex.exp (WeilPowerShell.zOf e' D e * (u : ℂ))).re = Real.exp (2 * (e' ^ 2 - D ^ 2 - e ^ 2) * u) / e ^ 2 * ((e' ^ 2 - D ^ 2) * Real.cos (4 * e' * D * u) - 2 * e' * D *… |
| [`ReZetaCount.re_zeta_two_line_ge`](./lean_stage3/ReZetaCount.md#ReZetaCount-re_zeta_two_line_ge) | theorem | reads ζ | `ReZetaCount` | 2 - Real.pi ^ 2 / 6 ≤ (riemannZeta (2 + (t : ℂ) * Complex.I)).re |
| [`ReZetaCount.re_zeta_two_line_pos`](./lean_stage3/ReZetaCount.md#ReZetaCount-re_zeta_two_line_pos) | theorem | reads ζ | `ReZetaCount` | 0 &lt; (riemannZeta (2 + (t : ℂ) * Complex.I)).re |
| [`PerronKernel.rect_residue`](./lean_stage3/PerronKernel.md#PerronKernel-rect_residue) | theorem | reads ζ | `PerronKernel` | RectangleIntegral' (fun s : ℂ ↦ (y : ℂ) ^ s / s) (-(X:ℂ) - Complex.I * T) ((c:ℂ) + Complex.I * T) = 1 |
| [`PerronKernel.rect_subset_right`](./lean_stage3/PerronKernel.md#PerronKernel-rect_subset_right) | theorem | shape | `PerronKernel` | Rectangle ((c : ℂ) - Complex.I * T) ((X : ℂ) + Complex.I * T) ⊆ {s : ℂ \| 0 &lt; s.re} |
| [`Stage3.rectangleIntegral_logDeriv_xi_eq_N`](./lean_stage3/ArgIdentity.md#Stage3-rectangleIntegral_logDeriv_xi_eq_N) | theorem | reads ζ | `ArgIdentity` | RectangleIntegral' (logDeriv xi) (-1 : ℂ) (2 + Complex.I * T) = ((riemannZeta.N T : ℝ) : ℂ) |
| [`ContourShift.rectangleIntegral_sum_poles`](./lean_stage3/ContourShift.md#ContourShift-rectangleIntegral_sum_poles) | theorem | reads ζ | `ContourShift` | RectangleIntegral' (fun s ↦ ∑ p ∈ P, A p / (s - p)) z w = ∑ p ∈ P, A p |
| [`VonKoch.region`](./lean_stage3/VonKochScaffold.md#VonKoch-region) | def | shape | `VonKochScaffold` | Set ℂ |
| [`Stage3.regionθ`](./lean_stage3/ThetaConverse.md#Stage3-region-) | def | shape | `ThetaConverse` | Set ℂ |
| [`Stage3.regionθ_half`](./lean_stage3/ThetaConverse.md#Stage3-region-_half) | theorem | shape | `ThetaConverse` | regionθ (1/2) = VonKoch.region |
| [`RelativeGate.relError_bound`](./lean/RelativeGate.md#RelativeGate-relError_bound) | theorem | shape | `RelativeGate` | \|stencilR n (fun x =&gt; f x - L x) r\| ≤ EhighRel r n ρ |
| [`JointFloorGate.relErrWindow_floor_of_RH`](./lean_stage3/JointFloorGate.md#JointFloorGate-relErrWindow_floor_of_RH) | theorem | reads ζ | `JointFloorGate` | ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ ∀ x₀ : ℝ, 16 ≤ x₀ → ∀ (r : ℤ) (n : ℕ), x₀ ^ 2 ≤ (2 : ℝ) ^ ((r : ℝ) - n) → 0 ≤ (r : ℝ) - n → JointDialGate.StmtRelErrWindow (fun m : ℤ =&gt; (Nat.primeCounting ⌊… |
| [`JointDialGate.relErrWindow_of_theta`](./lean_stage3/JointDialGate.md#JointDialGate-relErrWindow_of_theta) | theorem | shape | `JointDialGate` | StmtRelErrWindow f L r n (C / (2 * (θ' - θ) / (2 * ((k : ℝ) + 1))) ^ k * (2 : ℝ) ^ (((r : ℝ) - n) * (θ' - 1))) |
| [`JointDialGate.relErrWindow_of_window`](./lean_stage3/JointDialGate.md#JointDialGate-relErrWindow_of_window) | theorem | reads ζ | `JointDialGate` | ∃ A x₀ : ℝ, 0 ≤ A ∧ ∀ (r : ℤ) (n : ℕ), x₀ ≤ (2 : ℝ) ^ ((r : ℝ) - n) → 0 ≤ (r : ℝ) - n → StmtRelErrWindow (fun m : ℤ =&gt; (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ)) (fun m : ℤ =&gt; Stage3.Li ((2 : ℝ) ^ … |
| [`RouteGate.relErrWindow_route`](./lean_stage3/RouteGate.md#RouteGate-relErrWindow_route) | theorem | reads ζ | `RouteGate` | ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ ∀ x₀ : ℝ, 16 ≤ x₀ → ∀ (r : ℤ) (n : ℕ), x₀ ^ 2 ≤ (2 : ℝ) ^ ((r : ℝ) - n) → JointDialGate.StmtRelErrWindow (fun m : ℤ =&gt; (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋… |
| [`RouteNum.relErrWindow_route_num`](./lean_stage3/RouteNum.md#RouteNum-relErrWindow_route_num) | theorem | reads ζ | `RouteNum` | JointDialGate.StmtRelErrWindow (fun m : ℤ =&gt; (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ)) (fun m : ℤ =&gt; 2 / Real.log 2 + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r n (Stage3.routeConst… |
| [`RelativeGate.relGate_eps`](./lean/RelativeGate.md#RelativeGate-relGate_eps) | theorem | shape | `RelativeGate` | Real.log 2 ^ d / (2 * r * 3 ^ (d + 1)) = ((1 / 2) * (Real.log 2 / 3) ^ (d + 1)) / ((r : ℝ) * Real.log 2) |
| [`RelativeGate.relGate_iff`](./lean/RelativeGate.md#RelativeGate-relGate_iff) | theorem | shape | `RelativeGate` | EhighRel r (d + 1) ρ &lt; Mlow r d ↔ ρ &lt; Real.log 2 ^ d / (2 * r * 3 ^ (d + 1)) |
| [`PiToPsi.relRes`](./lean_stage3/PiToPsi.md#PiToPsi-relRes) | def | shape | `PiToPsi` | ℝ |
| [`PiToPsi.relRes_tail_le`](./lean_stage3/PiToPsi.md#PiToPsi-relRes_tail_le) | theorem | shape | `PiToPsi` | (∫ t in x₀..x, \|relRes t\|) ≤ 2 * (C * Real.log x) * Real.sqrt x |
| [`RelativeGate.relWindow_term_le`](./lean/RelativeGate.md#RelativeGate-relWindow_term_le) | theorem | shape | `RelativeGate` | ρ * (2 : ℝ) ^ ((r : ℝ) - k) = ρ * (2 : ℝ) ^ (r : ℝ) * ((2 : ℝ) ^ (-(1 : ℝ))) ^ k |
| [`Stage3.rem_arith`](./lean_stage3/Assembly.md#Stage3-rem_arith) | theorem | shape | `Assembly` | c₁ * xx * G ^ 2 / TT + c₂ * L ≤ (9 * c₁ + c₂) * L ^ 2 |
| [`Stage3.rem_floor`](./lean_stage3/AssemblyFloor.md#Stage3-rem_floor) | theorem | shape | `AssemblyFloor` | c₁ * xx * G ^ 2 / TT ≤ 18 * c₁ * L ^ 2 / xx |
| [`Zeros.repeat_iff_wings`](./lean/ZerosStencil.md#Zeros-repeat_iff_wings) | theorem | counting | `ZerosStencil` | Construction.tableFrom N r d = Construction.tableFrom N (r - 1) d ↔ wingPlus (d + 1) (fun k =&gt; N (r - k)) = wingMinus (d + 1) (fun k =&gt; N (r - k)) |
| [`CellResidual.resid`](./lean_stage3/CellResidual.md#CellResidual-resid) | def | shape | `CellResidual` | ℝ |
| [`CellResidual.resid_le`](./lean_stage3/CellResidual.md#CellResidual-resid_le) | theorem | shape | `CellResidual` | \|resid a m\| ≤ (C * Real.sqrt 2 * Real.log 2) * (((m : ℝ) + 1) * (2 : ℝ) ^ ((m : ℝ) / 2)) |
| [`ContourShift.residue_identity`](./lean_stage3/ContourShift.md#ContourShift-residue_identity) | theorem | reads ζ | `ContourShift` | RectangleIntegral' (fun s : ℂ ↦ (- deriv riemannZeta s / riemannZeta s) * ((x:ℝ):ℂ) ^ s / s) (((-1/4 : ℝ):ℂ) - Complex.I * T') (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * T') = (x : ℂ) - deriv riemannZe… |
| [`ExplicitTwo.residue_identity_two`](./lean_stage3/ExplicitTwo.md#ExplicitTwo-residue_identity_two) | theorem | reads ζ | `ExplicitTwo` | RectangleIntegral' (fun s : ℂ ↦ (- deriv riemannZeta s / riemannZeta s) * ((x:ℝ):ℂ) ^ s / s) (((-1/4 : ℝ):ℂ) - Complex.I * T') (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * T') = (x : ℂ) - deriv riemannZe… |
| [`ContourShift.residue_rectangle_multi`](./lean_stage3/ContourShift.md#ContourShift-residue_rectangle_multi) | theorem | reads ζ | `ContourShift` | RectangleIntegral' f z w = ∑ p ∈ P, A p |
| [`ContourShift.residue_rectangle_of_local`](./lean_stage3/ContourShift.md#ContourShift-residue_rectangle_of_local) | theorem | reads ζ | `ContourShift` | RectangleIntegral' f z w = ∑ p ∈ P, A p |
| [`StencilWeil.restoringForce`](./lean_stage3/StencilWeil.md#StencilWeil-restoringForce) | def | shape | `StencilWeil` | ℝ |
| [`StencilWeil.restoringForce_eq`](./lean_stage3/StencilWeil.md#StencilWeil-restoringForce_eq) | theorem | shape | `StencilWeil` | restoringForce b ρ = 2 * \|ρ.re - 1 / 2\| * Real.log b |
| [`MirrorArea.restoringForce_eq_log_ratio`](./lean_stage3/MirrorArea.md#MirrorArea-restoringForce_eq_log_ratio) | theorem | shape | `MirrorArea` | restoringForce b ρ = \|Real.log (‖(b : ℂ) ^ ρ‖ / ‖(b : ℂ) ^ (1 - ρ)‖)\| |
| [`StencilWeil.restoringForce_eq_zero_iff`](./lean_stage3/StencilWeil.md#StencilWeil-restoringForce_eq_zero_iff) | theorem | shape | `StencilWeil` | restoringForce b ρ = 0 ↔ ρ.re = 1 / 2 |
| [`StencilWeil.restoringForce_mono`](./lean_stage3/StencilWeil.md#StencilWeil-restoringForce_mono) | theorem | shape | `StencilWeil` | restoringForce b ρ ≤ restoringForce c ρ |
| [`ReZetaCount.reZeros`](./lean_stage3/ReZetaCount.md#ReZetaCount-reZeros) | def | reads ζ | `ReZetaCount` | Finset ℝ |
| [`ReZetaCount.reZeroSet`](./lean_stage3/ReZetaCount.md#ReZetaCount-reZeroSet) | def | reads ζ | `ReZetaCount` | Set ℝ |
| [`ReZetaCount.reZeroSet_finite`](./lean_stage3/ReZetaCount.md#ReZetaCount-reZeroSet_finite) | theorem | reads ζ | `ReZetaCount` | (reZeroSet T).Finite |
| [`CellResidual.RH_iff_cells`](./lean_stage3/CellResidual.md#CellResidual-RH_iff_cells) | theorem | reads ζ | `CellResidual` | RiemannHypothesis ↔ ∃ (C : ℝ) (r₀ : ℤ), CellsSqrt C r₀ |
| [`VonKoch.RH_iff_psiWeak`](./lean_stage3/VonKochScaffold.md#VonKoch-RH_iff_psiWeak) | theorem | reads ζ | `VonKochScaffold` | RiemannHypothesis ↔ ∃ C &gt; 0, ∃ x₀ : ℝ, Stage3.StmtPsiWeak C 3 x₀ |
| [`PiToPsi.RH_iff_schoenfeldWeak`](./lean_stage3/PiToPsi.md#PiToPsi-RH_iff_schoenfeldWeak) | theorem | reads ζ | `PiToPsi` | RiemannHypothesis ↔ ∃ C x₀ : ℝ, StmtSchoenfeldWeak C 1 x₀ (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li |
| [`VonKoch.RH_of_no_zero_right_of_half`](./lean_stage3/VonKochScaffold.md#VonKoch-RH_of_no_zero_right_of_half) | theorem | reads ζ | `VonKochScaffold` | RiemannHypothesis |
| [`VonKoch.RH_of_psiWeak`](./lean_stage3/VonKochScaffold.md#VonKoch-RH_of_psiWeak) | theorem | reads ζ | `VonKochScaffold` | RiemannHypothesis |
| [`Stage3.RH_of_psiWeakTheta_half`](./lean_stage3/ThetaConverse.md#Stage3-RH_of_psiWeakTheta_half) | theorem | reads ζ | `ThetaConverse` | RiemannHypothesis |
| [`PiToPsi.RH_of_schoenfeldWeak`](./lean_stage3/PiToPsi.md#PiToPsi-RH_of_schoenfeldWeak) | theorem | reads ζ | `PiToPsi` | RiemannHypothesis |
| [`LandauWindow.rh_of_window`](./lean_stage3/LandauWindow.md#LandauWindow-rh_of_window) | theorem | reads ζ | `LandauWindow` | RiemannHypothesis |
| [`LandauCriterion.rh_of_windows`](./lean_stage3/LandauCriterion.md#LandauCriterion-rh_of_windows) | theorem | reads ζ | `LandauCriterion` | RiemannHypothesis |
| [`LandauWindow.rh_of_zeroFree_half`](./lean_stage3/LandauWindow.md#LandauWindow-rh_of_zeroFree_half) | theorem | reads ζ | `LandauWindow` | RiemannHypothesis |
| [`WeilPowerGeom.rho_ne_one`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-rho_ne_one) | theorem | shape | `WeilPowerGeom` | Complex.exp (z / (Real.pi : ℂ) ^ 2) ≠ 1 |
| [`WeilPowerGeomGen.rho_ne_one_gen`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-rho_ne_one_gen) | theorem | shape | `WeilPowerGeomGen` | Complex.exp (z * ((α : ℝ) : ℂ)) ≠ 1 |
| [`Transform.riemannHypothesis_iff_pair_collapses`](./lean/Transform.md#Transform-riemannHypothesis_iff_pair_collapses) | theorem | reads ζ | `Transform` | RiemannHypothesis ↔ ∀ (s : ℂ), riemannZeta s = 0 → ¬(∃ n : ℕ, s = -2 * (n + 1)) → s ≠ 1 → ‖(b : ℂ) ^ (-s)‖ = ‖(b : ℂ) ^ (-(1 - s))‖ |
| [`Transform.riemannHypothesis_iff_zeros_inversion_fixed`](./lean/Transform.md#Transform-riemannHypothesis_iff_zeros_inversion_fixed) | theorem | reads ζ | `Transform` | RiemannHypothesis ↔ ∀ (s : ℂ), riemannZeta s = 0 → ¬(∃ n : ℕ, s = -2 * (n + 1)) → s ≠ 1 → ‖(b : ℂ) ^ (-(1 : ℂ)) / (b : ℂ) ^ (-s)‖ = ‖(b : ℂ) ^ (-s)‖ |
| [`Transform.riemannHypothesis_iff_zeros_on_middle_circle`](./lean/Transform.md#Transform-riemannHypothesis_iff_zeros_on_middle_circle) | theorem | reads ζ | `Transform` | RiemannHypothesis ↔ ∀ (s : ℂ), riemannZeta s = 0 → ¬(∃ n : ℕ, s = -2 * (n + 1)) → s ≠ 1 → ‖(b : ℂ) ^ (-s)‖ = b ^ (-(1 : ℝ) / 2) |
| [`Stage3.routeConst`](./lean_stage3/RouteNum.md#Stage3-routeConst) | def | reads ζ | `RouteNum` | ℝ |
| [`GateEval.routeConst_le`](./lean_stage3/GateEval.md#GateEval-routeConst_le) | theorem | reads ζ | `GateEval` | Stage3.routeConst ((2:ℝ) ^ (36:ℕ)) ≤ 414 |
| [`FiniteOffLinePi.row_bound`](./lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-row_bound) | theorem | reads ζ | `FiniteOffLinePi` | ‖∑ ρ ∈ S, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * (((2:ℂ) ^ (ρ : ℂ)) ^ r / (ρ : ℂ))‖ ≤ rowBound F S β C r |
| [`Isogeny.row_three_eq_triple`](./lean/Isogeny.md#Isogeny-row_three_eq_triple) | theorem | counting | `Isogeny` | rowN Q 3 r = rowN Q 1 (3 * r) + rowN Q 1 (3 * r + 1) + rowN Q 1 (3 * r + 2) |
| [`Isogeny.row_two_eq_pair`](./lean/Isogeny.md#Isogeny-row_two_eq_pair) | theorem | counting | `Isogeny` | rowN Q 2 r = rowN Q 1 (2 * r) + rowN Q 1 (2 * r + 1) |
| [`FiniteOffLinePi.rowBound`](./lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-rowBound) | def | reads ζ | `FiniteOffLinePi` | ℝ |
| [`FiniteOffLinePi.rowBound_isLittleO`](./lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-rowBound_isLittleO) | theorem | reads ζ | `FiniteOffLinePi` | (fun r : ℕ =&gt; rowBound F S β C r) =o[atTop] fun r : ℕ =&gt; ((2:ℝ) ^ β) ^ r |
| [`Isogeny.rowN`](./lean/Isogeny.md#Isogeny-rowN) | def | counting | `Isogeny` | ℤ |
| [`TableRoute.rowN`](./lean_stage3/TableRoute.md#TableRoute-rowN) | def | shape | `TableRoute` | ℤ |
| [`Isogeny.rowN_comp`](./lean/Isogeny.md#Isogeny-rowN_comp) | theorem | counting | `Isogeny` | rowN Q (k * l) r = rowN (fun n =&gt; Q (k * n)) l r |
| [`Isogeny.rowN_eq_blockSum`](./lean/Isogeny.md#Isogeny-rowN_eq_blockSum) | theorem | counting | `Isogeny` | rowN Q k r = ∑ j ∈ range k, rowN Q 1 (k * r + j) |
| [`Isogeny.rowOf`](./lean/Isogeny.md#Isogeny-rowOf) | def | counting | `Isogeny` | ℤ |
| [`Isogeny.rowOf_eq_rowN`](./lean/Isogeny.md#Isogeny-rowOf_eq_rowN) | theorem | counting | `Isogeny` | rowOf P b r = rowN (fun n =&gt; P (b ^ n)) 1 r |
| [`FiniteOffLinePi.rpow_doubling`](./lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-rpow_doubling) | theorem | shape | `FiniteOffLinePi` | ((2:ℝ) ^ r) ^ b = ((2:ℝ) ^ b) ^ r |
| [`FilterLadder.rpow_half_eq`](./lean_stage3/FilterLadder.md#FilterLadder-rpow_half_eq) | theorem | shape | `FilterLadder` | (2:ℝ) ^ (-(j:ℝ) / 2) = (Real.sqrt 2)⁻¹ ^ j |
| [`Transform.rpow_left_inj`](./lean/Transform.md#Transform-rpow_left_inj) | theorem | shape | `Transform` | b ^ x = b ^ y ↔ x = y |
| [`Stage3.rpow_neg_half_mul`](./lean_stage3/PsiToPi.md#Stage3-rpow_neg_half_mul) | theorem | shape | `PsiToPi` | t ^ (-(1 : ℝ) / 2) * (t * Real.log t ^ 2) = Real.sqrt t * Real.log t ^ 2 |
| [`RHPull.rpow_one_add`](./lean_stage3/LineBound.md#RHPull-rpow_one_add) | theorem | shape | `LineBound` | X ^ (1 + 1 / Real.log X) = Real.exp 1 * X |
| [`MollifiedMean.rpow_sq`](./lean_stage3/MollifiedMean.md#MollifiedMean-rpow_sq) | theorem | shape | `MollifiedMean` | (x ^ a) ^ 2 = x ^ (2 * a) |
| [`Stage3.rpow_theta_sub_one_mul`](./lean_stage3/ThetaPi.md#Stage3-rpow_theta_sub_one_mul) | theorem | shape | `ThetaPi` | t ^ (θ - 1) * (t * Real.log t ^ 2) = t ^ θ * Real.log t ^ 2 |
| [`RHPull.rpow_σRH`](./lean_stage3/LineBound.md#RHPull-rpow_-RH) | theorem | shape | `LineBound` | X ^ (σRH X) = Real.exp 1 * Real.sqrt X |
| [`Stage3.rpow_σθ`](./lean_stage3/Abscissa.md#Stage3-rpow_--) | theorem | shape | `Abscissa` | X ^ (σθ θ X) = Real.exp 1 * X ^ θ |
| [`Stage3.rpow_σθ_half`](./lean_stage3/Abscissa.md#Stage3-rpow_--_half) | theorem | shape | `Abscissa` | X ^ (σθ (1/2) X) = Real.exp 1 * Real.sqrt X |
| [`ArgCount.rvM_crude`](./lean_stage3/ArgCount.md#ArgCount-rvM_crude) | theorem | reads ζ | `ArgCount` | riemannZeta.Riemann_vonMangoldt_bound 112 0 698 |
| [`ArgCount.rvM_crude_of_good_two`](./lean_stage3/ArgCount.md#ArgCount-rvM_crude_of_good_two) | theorem | reads ζ | `ArgCount` | riemannZeta.Riemann_vonMangoldt_bound 112 0 173 |
| [`Stage3.RvM_mono`](./lean_stage3/ZeroSum.md#Stage3-RvM_mono) | theorem | reads ζ | `ZeroSum` | riemannZeta.RvM b₁ b₂ b₃ T ≤ riemannZeta.RvM b₁ b₂ b₃ T' |
| [`Stage3.RvM_of_phase_arg`](./lean_stage3/RvMCrude.md#Stage3-RvM_of_phase_arg) | theorem | reads ζ | `RvMCrude` | riemannZeta.Riemann_vonMangoldt_bound (B₁ + B₁') 0 (B₃ + B₃') |
| [`Stage3.rvM_of_sFromLocal`](./lean_stage3/ArgIdentity.md#Stage3-rvM_of_sFromLocal) | theorem | reads ζ | `ArgIdentity` | riemannZeta.Riemann_vonMangoldt_bound (97 + a * 15) 0 (98 + (a * 73 + b)) |
| [`Stage3.rvM_of_stirling_and_pieces`](./lean_stage3/ArgCrude.md#Stage3-rvM_of_stirling_and_pieces) | theorem | reads ζ | `ArgCrude` | riemannZeta.Riemann_vonMangoldt_bound (B₁ + a * A₁) 0 (B₃ + (a * A₃ + b)) |
| [`Expansion.S`](./lean/Expansion.md#Expansion-S) | def | shape | `Expansion` | ℝ |
| [`FilterAttained.S`](./lean_stage3/FilterAttained.md#FilterAttained-S) | def | counting | `FilterAttained` | Set NontrivialZeros |
| [`WeilOddPower.S`](./lean_stage3/WeilOddPower.md#WeilOddPower-S) | def | shape | `WeilOddPower` | ℂ |
| [`WeilOddPower.S_eq`](./lean_stage3/WeilOddPower.md#WeilOddPower-S_eq) | theorem | shape | `WeilOddPower` | S m w = 2 * w * K (m + 1) w / (((m : ℂ) + 1) * (Real.pi : ℂ)) |
| [`Expansion.S_eq_alt`](./lean/Expansion.md#Expansion-S_eq_alt) | theorem | shape | `Expansion` | S d x = ∑ j ∈ range (d + 1), (-1 : ℝ) ^ j * t d j x |
| [`WeilPowerBounds.S_eq_div`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-S_eq_div) | theorem | shape | `WeilPowerBounds` | S m w = (cS m : ℂ) * Complex.sinh w / QS m w |
| [`WeilPowerBounds.S_eq_div'`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-S_eq_div-) | theorem | shape | `WeilPowerBounds` | S m w = (cS m : ℂ) * Complex.sinh w / QS m w |
| [`WeilPowerBackground.S_eq_sinh`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-S_eq_sinh) | theorem | shape | `WeilPowerBackground` | S m w = ∫ x in (-1 : ℝ)..1, ((q m x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) |
| [`Expansion.S_floor`](./lean/Expansion.md#Expansion-S_floor) | theorem | shape | `Expansion` | Real.log 2 ^ d / (2 * x) ≤ S d x |
| [`WeilPowerBackground.S_I_mul`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-S_I_mul) | theorem | shape | `WeilPowerBackground` | S m (Complex.I * (t : ℂ)) = Complex.I * (PsiW m t : ℂ) |
| [`WeilOddPower.S_mul_QS`](./lean_stage3/WeilOddPower.md#WeilOddPower-S_mul_QS) | theorem | shape | `WeilOddPower` | S m w * QS m w = (cS m : ℂ) * Complex.sinh w |
| [`WeilPowerBackground.S_neg`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-S_neg) | theorem | shape | `WeilPowerBackground` | S m (-w) = -S m w |
| [`WeilPowerBounds.S_real_eq`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-S_real_eq) | theorem | shape | `WeilPowerBounds` | S m (s : ℂ) = ((cS m * Real.sinh s / Ps m s : ℝ) : ℂ) |
| [`WeilPowerBounds.S_real_ge`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-S_real_ge) | theorem | shape | `WeilPowerBounds` | cS m * Real.exp s / (4 * (s ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ^ (m + 1)) ≤ (S m (s : ℂ)).re |
| [`WeilPowerGauss.S_real_ge_gauss`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-S_real_ge_gauss) | theorem | shape | `WeilPowerGauss` | 4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) * s * Real.exp (s ^ 2 * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2) - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ≤ (S m (s : ℂ)).re |
| [`WeilPowerCompare.S_real_ge_low`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-S_real_ge_low) | theorem | shape | `WeilPowerCompare` | 4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) * s * Real.exp (Elow m s) ≤ (S m (s : ℂ)).re |
| [`WeilPowerSharp.S_real_ge_sharp`](./lean_stage3/WeilPowerSharp.md#WeilPowerSharp-S_real_ge_sharp) | theorem | shape | `WeilPowerSharp` | cS m / D m * s * Real.exp (s ^ 2 / (Real.pi ^ 2 * ((m : ℝ) + 2)) - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ≤ (S m (s : ℂ)).re |
| [`WeilPowerCompare.S_real_pos`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-S_real_pos) | theorem | shape | `WeilPowerCompare` | 0 &lt; (S m (s : ℂ)).re |
| [`WeilOddPower.S_zero_mul`](./lean_stage3/WeilOddPower.md#WeilOddPower-S_zero_mul) | theorem | shape | `WeilOddPower` | S 0 w * (w ^ 2 + (Real.pi : ℂ) ^ 2) = 2 * (Real.pi : ℂ) * Complex.sinh w |
| [`Nyquist.sample`](./lean/Nyquist.md#Nyquist-sample) | def | shape | `Nyquist` | ℝ |
| [`Stage3.schoenfeld_iff_weak`](./lean_stage3/Statement.md#Stage3-schoenfeld_iff_weak) | theorem | shape | `Statement` | StmtSchoenfeld pi li ↔ StmtSchoenfeldWeak (1 / (8 * Real.pi)) 1 2657 pi li |
| [`Stage3.schoenfeldWeak_floor_of_RH`](./lean_stage3/AssemblyFloor.md#Stage3-schoenfeldWeak_floor_of_RH) | theorem | reads ζ | `AssemblyFloor` | ∃ c₁ c₂ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₂ ∧ ∀ x₀ : ℝ, 16 ≤ x₀ → StmtSchoenfeldWeak (3 * floorConst c₁ c₂ 112 0 698 weightedZeroHeightBucket x₀ + 13) 1 (max (x₀ ^ 2) 9) (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li |
| [`Stage3.schoenfeldWeak_floor_split_of_RH`](./lean_stage3/GlueFloor.md#Stage3-schoenfeldWeak_floor_split_of_RH) | theorem | reads ζ | `GlueFloor` | ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ ∀ x₀ : ℝ, 16 ≤ x₀ → StmtSchoenfeldWeak (3 * floorConstSplit c₁ c₃ c₄ 112 0 698 weightedZeroHeightBucket x₀ + 13) 1 (max (x₀ ^ 2) 9) (fun x =&gt; (Nat.primeCount… |
| [`CellResidual.schoenfeldWeak_of_cells`](./lean_stage3/CellResidual.md#CellResidual-schoenfeldWeak_of_cells) | theorem | shape | `CellResidual` | ∃ C' x₁ : ℝ, StmtSchoenfeldWeak C' 1 x₁ (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li |
| [`Stage3.schoenfeldWeak_of_psiWeak`](./lean_stage3/PsiToPi.md#Stage3-schoenfeldWeak_of_psiWeak) | theorem | shape | `PsiToPi` | StmtSchoenfeldWeak (3 * C + 13) (k - 1) (max (x₀ ^ 2) 9) (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li |
| [`Stage3.schoenfeldWeak_of_psiWeak_half`](./lean_stage3/ThetaPi.md#Stage3-schoenfeldWeak_of_psiWeak_half) | theorem | shape | `ThetaPi` | StmtSchoenfeldWeak (3 * C + 13) (k - 1) (max (x₀ ^ 2) 9) (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li |
| [`Slice8.schoenfeldWeak_of_psiWeak_three`](./lean_stage3/LineBound.md#Slice8-schoenfeldWeak_of_psiWeak_three) | theorem | shape | `LineBound` | Stage3.StmtSchoenfeldWeak (3 * C + 13) 2 (max (x₀ ^ 2) 9) (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li |
| [`Stage3.schoenfeldWeak_of_RH_half`](./lean_stage3/ThetaPi.md#Stage3-schoenfeldWeak_of_RH_half) | theorem | reads ζ | `ThetaPi` | ∃ C &gt; 0, ∃ x₀ : ℝ, StmtSchoenfeldWeak C 2 x₀ (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li |
| [`Stage3.schoenfeldWeak_route_num`](./lean_stage3/RouteNum.md#Stage3-schoenfeldWeak_route_num) | theorem | reads ζ | `RouteNum` | StmtSchoenfeldWeak (routeConst x₀) 1 (max (x₀ ^ 2) 9) (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li |
| [`Stage3.schoenfeldWeakTheta_of_psiWeakTheta`](./lean_stage3/ThetaPi.md#Stage3-schoenfeldWeakTheta_of_psiWeakTheta) | theorem | shape | `ThetaPi` | StmtSchoenfeldWeakTheta θ (3 * C + 13) (k - 1) (max (x₀ ^ 2) 9) (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li |
| [`JointWindowDial.schoenfeldWeakTheta_of_window`](./lean_stage3/JointWindowDial.md#JointWindowDial-schoenfeldWeakTheta_of_window) | theorem | reads ζ | `JointWindowDial` | ∃ C' &gt; 0, ∃ x₀ : ℝ, Stage3.StmtSchoenfeldWeakTheta θ C' 2 x₀ (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li |
| [`Stage3.schoenfeldWeakTheta_of_zeroFree`](./lean_stage3/ThetaPi.md#Stage3-schoenfeldWeakTheta_of_zeroFree) | theorem | reads ζ | `ThetaPi` | ∃ C &gt; 0, ∃ x₀ : ℝ, StmtSchoenfeldWeakTheta θ C 2 x₀ (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li |
| [`RelativeGate.schoenfeldWindow_relErr`](./lean/RelativeGate.md#RelativeGate-schoenfeldWindow_relErr) | theorem | shape | `RelativeGate` | StmtRelErrWindow f L r n ((Real.log 2 * r / (8 * Real.pi)) * (2 : ℝ) ^ (-((r : ℝ) - n) / 2)) |
| [`GeneratorPeak.score`](./lean/GeneratorPeak.md#GeneratorPeak-score) | def | shape | `GeneratorPeak` | ℝ |
| [`GeneratorPeak.score_eq`](./lean/GeneratorPeak.md#GeneratorPeak-score_eq) | theorem | shape | `GeneratorPeak` | score R P α β k = P ^ β * (R k) ^ (α - β) |
| [`ArgCount.sCrude_holds`](./lean_stage3/ArgCount.md#ArgCount-sCrude_holds) | theorem | reads ζ | `ArgCount` | Stage3.StmtSCrude Stage3.argS 15 600 |
| [`ArgCount.sCrude_holds_of_good_two`](./lean_stage3/ArgCount.md#ArgCount-sCrude_holds_of_good_two) | theorem | reads ζ | `ArgCount` | Stage3.StmtSCrude Stage3.argS 15 75 |
| [`Stage3.sCrude_of_local`](./lean_stage3/ArgCrude.md#Stage3-sCrude_of_local) | theorem | shape | `ArgCrude` | StmtSCrude S (a * A₁) (a * A₃ + b) |
| [`Chain.second_ladder_winds_densely`](./lean/Chain.md#Chain-second_ladder_winds_densely) | theorem | shape | `Chain` | DenseRange (fun k : ℤ =&gt; k • ((2 * Real.pi / Real.log b₂ : ℝ) : AddCircle (2 * Real.pi / Real.log b₁))) ↔ Irrational (Real.log b₁ / Real.log b₂) |
| [`ZeroCells.seedPerturbation_all_vanish`](./lean/ZeroCells.md#ZeroCells-seedPerturbation_all_vanish) | theorem | counting | `ZeroCells` | ∀ c ∈ SeedPerturbation.zero_cells, Construction.tableFrom Zeros.dyadicRow (c.1 : ℤ) c.2 = 0 |
| [`ZeroCells.seedPerturbation_eq`](./lean/ZeroCells.md#ZeroCells-seedPerturbation_eq) | theorem | counting | `ZeroCells` | SeedPerturbation.zero_cells = Zeros.measured_zeros |
| [`PerronKernel.seg_inv_integral`](./lean_stage3/PerronKernel.md#PerronKernel-seg_inv_integral) | theorem | shape | `PerronKernel` | (∫ t in (-T)..T, ((c : ℂ) + Complex.I * t)⁻¹ * Complex.I) = 2 * Real.arctan (T / c) * Complex.I |
| [`ArgLegs.segment_im_integral_le`](./lean_stage3/ArgLegs.md#ArgLegs-segment_im_integral_le) | theorem | shape | `ArgLegs` | \|(∫ x in a..b, g' x / g x).im\| ≤ Real.pi * ((Z.card : ℝ) + 1) |
| [`LeftKernel.series_side`](./lean_stage3/LeftKernel.md#LeftKernel-series_side) | theorem | reads ζ | `LeftKernel` | ‖∫ t in (-T)..T, (deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I) / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)) * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)) / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)‖ … |
| [`ExplicitTwo.series_side_two`](./lean_stage3/ExplicitTwo.md#ExplicitTwo-series_side_two) | theorem | reads ζ | `ExplicitTwo` | ‖∫ t in (-T)..T, (deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I) / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)) * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)) / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)‖ … |
| [`DeepZeroBand.share`](./lean/DeepZeroBand.md#DeepZeroBand-share) | def | shape | `DeepZeroBand` | ℝ |
| [`DeepZeroBand.share_15_6_neg`](./lean/DeepZeroBand.md#DeepZeroBand-share_15_6_neg) | theorem | shape | `DeepZeroBand` | share Zeros.dyadicRow 15 6 8 &lt; 0 |
| [`DeepZeroBand.share_add`](./lean/DeepZeroBand.md#DeepZeroBand-share_add) | theorem | shape | `DeepZeroBand` | share P r d e + share C r d e = 1 |
| [`DeepZeroBand.share_eq_iff_half`](./lean/DeepZeroBand.md#DeepZeroBand-share_eq_iff_half) | theorem | shape | `DeepZeroBand` | share P r d e = share C r d e ↔ share P r d e = 1 / 2 |
| [`DeepZeroBand.share_in_band`](./lean/DeepZeroBand.md#DeepZeroBand-share_in_band) | theorem | shape | `DeepZeroBand` | 0 ≤ (P : ℝ) / 2 ^ e ∧ (P : ℝ) / 2 ^ e ≤ 1 |
| [`DeepZeroBand.share_mirror`](./lean/DeepZeroBand.md#DeepZeroBand-share_mirror) | theorem | shape | `DeepZeroBand` | share C r d e = 1 - share P r d e |
| [`DeepZeroBand.share_on_middle_circle_iff`](./lean/DeepZeroBand.md#DeepZeroBand-share_on_middle_circle_iff) | theorem | shape | `DeepZeroBand` | ‖(b : ℂ) ^ (-(x : ℂ))‖ = b ^ (-(1 : ℝ) / 2) ↔ x = 1 / 2 |
| [`DeepZeroBand.share_pair_product`](./lean/DeepZeroBand.md#DeepZeroBand-share_pair_product) | theorem | shape | `DeepZeroBand` | ‖(b : ℂ) ^ (-((share P r d e : ℝ) : ℂ))‖ * ‖(b : ℂ) ^ (-((share C r d e : ℝ) : ℂ))‖ = b ^ (-(1 : ℝ)) |
| [`ZeroSummable.shell_bound_le`](./lean_stage3/ZeroSummable.md#ZeroSummable-shell_bound_le) | theorem | shape | `ZeroSummable` | 2 * (C * ((2 : ℝ) ^ (j + 1) + 2) ^ θ) * (103 * ((j : ℝ) + 1) / 2 ^ j) ≤ 206 * C * (4 : ℝ) ^ (max θ 0) * (((j : ℝ) + 1) * ((2 : ℝ) ^ (max θ 0) / 2) ^ j) |
| [`ZeroSummable.shell_sum_le`](./lean_stage3/ZeroSummable.md#ZeroSummable-shell_sum_le) | theorem | reads ζ | `ZeroSummable` | ∑ ρ ∈ F, w ρ ≤ 2 * (C * ((2 : ℝ) ^ (j + 1) + 2) ^ θ) * (103 * ((j : ℝ) + 1) / 2 ^ j) |
| [`WeilPowerShell.shellSum`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-shellSum) | def | shape | `WeilPowerShell` | ℝ |
| [`WeilPowerShell.shellSum_le`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-shellSum_le) | theorem | shape | `WeilPowerShell` | \|shellSum e' D e lam a b\| ≤ (e' ^ 2 + D ^ 2) / e ^ 2 * Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) * ((lam : ℝ) * Real.pi ^ 3 * Real.exp (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (1 / ((lam : ℝ) * … |
| [`WeilPowerShell.shellSum_le_abs`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-shellSum_le_abs) | theorem | shape | `WeilPowerShell` | \|shellSum e' D e lam a b\| ≤ (e' ^ 2 + \|D\| ^ 2) / e ^ 2 * Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) * ((lam : ℝ) * Real.pi ^ 3 * Real.exp (2 * (e' ^ 2 + \|D\| ^ 2 + e ^ 2) * (1 / ((lam : ℝ… |
| [`WeilPowerShell.shellSum_neg`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-shellSum_neg) | theorem | shape | `WeilPowerShell` | shellSum e' (-D) e lam a b = shellSum e' D e lam a b |
| [`WeilPowerNear.shellSum_nonneg`](./lean_stage3/WeilPowerNear.md#WeilPowerNear-shellSum_nonneg) | theorem | shape | `WeilPowerNear` | 0 ≤ WeilPowerShell.shellSum e' D e lam a b |
| [`WeilPowerNear.shellSum_nonneg_abs`](./lean_stage3/WeilPowerNear.md#WeilPowerNear-shellSum_nonneg_abs) | theorem | shape | `WeilPowerNear` | 0 ≤ WeilPowerShell.shellSum e' D e lam a b |
| [`MirrorArea.side_eq_sqrt_iff`](./lean_stage3/MirrorArea.md#MirrorArea-side_eq_sqrt_iff) | theorem | shape | `MirrorArea` | ‖(b : ℂ) ^ ρ‖ = Real.sqrt b ↔ ρ.re = 1 / 2 |
| [`WeilPowerPhase.sigma`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-sigma) | def | shape | `WeilPowerPhase` | ℝ |
| [`WeilWindow.Sigma`](./lean_stage3/WeilWindow.md#WeilWindow-Sigma) | def | shape | `WeilWindow` | ℝ |
| [`WeilPowerPhase.sigma_ge`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-sigma_ge) | theorem | shape | `WeilPowerPhase` | 1 / (Real.pi ^ 2 * ((m : ℝ) + 2)) ≤ sigma m |
| [`WeilWindow.Sigma_ge`](./lean_stage3/WeilWindow.md#WeilWindow-Sigma_ge) | theorem | shape | `WeilWindow` | s / 24 ≤ Sigma s |
| [`WeilPowerSigma.sigma_ge_amgm`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-sigma_ge_amgm) | theorem | shape | `WeilPowerSigma` | 1 / (Real.pi ^ 2 * ((m : ℝ) + 2)) + 1 / (2 * Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2) ≤ sigma m |
| [`WeilWindow.Sigma_ge_mul`](./lean_stage3/WeilWindow.md#WeilWindow-Sigma_ge_mul) | theorem | shape | `WeilWindow` | s * m2 ≤ Sigma s |
| [`WeilPowerPhase.sigma_le`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-sigma_le) | theorem | shape | `WeilPowerPhase` | sigma m ≤ 1 / (Real.pi ^ 2 * ((m : ℝ) + 1)) |
| [`WeilPowerSigma.sigma_le_half`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-sigma_le_half) | theorem | shape | `WeilPowerSigma` | sigma m ≤ 2 / (Real.pi ^ 2 * (2 * (m : ℝ) + 3)) |
| [`WeilTransform.SigmaC`](./lean_stage3/WeilTransform.md#WeilTransform-SigmaC) | def | shape | `WeilTransform` | ℂ |
| [`WeilLobe.SigmaC_bound`](./lean_stage3/WeilLobe.md#WeilLobe-SigmaC_bound) | theorem | shape | `WeilLobe` | ‖SigmaC w‖ ≤ (2 * Real.pi + Real.pi ^ 2) * Real.cosh w.re / ‖w‖ ^ 2 |
| [`WeilLobe.SigmaC_eq_ibp`](./lean_stage3/WeilLobe.md#WeilLobe-SigmaC_eq_ibp) | theorem | shape | `WeilLobe` | SigmaC w = (1 / w ^ 2) * ∫ x in (-1 : ℝ)..1, ((q2 x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) |
| [`WeilTransform.SigmaC_I_mul`](./lean_stage3/WeilTransform.md#WeilTransform-SigmaC_I_mul) | theorem | shape | `WeilTransform` | SigmaC (Complex.I * (s : ℂ)) = Complex.I * (Psi s : ℂ) |
| [`WeilOffLine.SigmaC_neg`](./lean_stage3/WeilOffLine.md#WeilOffLine-SigmaC_neg) | theorem | shape | `WeilOffLine` | SigmaC (-w) = -SigmaC w |
| [`WeilTransform.SigmaC_ofReal`](./lean_stage3/WeilTransform.md#WeilTransform-SigmaC_ofReal) | theorem | shape | `WeilTransform` | SigmaC (s : ℂ) = (WeilWindow.Sigma s : ℂ) |
| [`WeilPowerPhase.sigmaN`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-sigmaN) | def | shape | `WeilPowerPhase` | ℝ |
| [`WeilPowerPhase.sigmaN_eq`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-sigmaN_eq) | theorem | shape | `WeilPowerPhase` | sigmaN m n = 1 / Real.pi ^ 2 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 |
| [`WeilPowerPhase.sigmaN_tendsto`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-sigmaN_tendsto) | theorem | shape | `WeilPowerPhase` | Tendsto (fun n =&gt; sigmaN m n) atTop (𝓝 (sigma m)) |
| [`SeedPerturbation.silence46_alive_at_three`](./lean/SeedPerturbation.md#SeedPerturbation-silence46_alive_at_three) | theorem | counting | `SeedPerturbation` | silence46_excess 3 ≠ 0 |
| [`SeedPerturbation.silence46_cell_4_1_moves`](./lean/SeedPerturbation.md#SeedPerturbation-silence46_cell_4_1_moves) | theorem | counting | `SeedPerturbation` | tableFrom (fun x =&gt; N x - silence46_excess x) 4 1 ≠ tableFrom N 4 1 |
| [`SeedPerturbation.silence46_deep_cells_fixed`](./lean/SeedPerturbation.md#SeedPerturbation-silence46_deep_cells_fixed) | theorem | counting | `SeedPerturbation` | tableFrom (fun x =&gt; N x - silence46_excess x) 8 3 = tableFrom N 8 3 ∧ tableFrom (fun x =&gt; N x - silence46_excess x) 20 6 = tableFrom N 20 6 |
| [`SeedPerturbation.silence46_excess`](./lean/SeedPerturbation.md#SeedPerturbation-silence46_excess) | def | counting | `SeedPerturbation` | ℤ → ℤ |
| [`SeedPerturbation.silence46_vanishes_above_three`](./lean/SeedPerturbation.md#SeedPerturbation-silence46_vanishes_above_three) | theorem | counting | `SeedPerturbation` | ∀ s : ℤ, 3 &lt; s → silence46_excess s = 0 |
| [`WeilPowerGeom.sin_im_ge`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-sin_im_ge) | theorem | shape | `WeilPowerGeom` | 2 * z.im / Real.pi ^ 3 ≤ Real.sin (z.im / Real.pi ^ 2) |
| [`WeilPowerGeomGen.sin_im_ge_gen`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-sin_im_ge_gen) | theorem | shape | `WeilPowerGeomGen` | 2 * (z.im * α) / Real.pi ≤ Real.sin (z.im * α) |
| [`WeilOddPower.sin_pi_mul`](./lean_stage3/WeilOddPower.md#WeilOddPower-sin_pi_mul) | theorem | shape | `WeilOddPower` | Real.sin (Real.pi * x) = 2 * Real.sin (Real.pi * x / 2) * c x |
| [`WeilPowerBounds.sinh_ge`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-sinh_ge) | theorem | shape | `WeilPowerBounds` | Real.exp s / 4 ≤ Real.sinh s |
| [`LeftSmooth.sL`](./lean_stage3/LeftSmooth.md#LeftSmooth-sL) | def | shape | `LeftSmooth` | ℂ |
| [`LeftSmooth.sL_ne`](./lean_stage3/LeftSmooth.md#LeftSmooth-sL_ne) | theorem | shape | `LeftSmooth` | sL t ≠ 0 |
| [`LeftSmooth.sL_ne_one`](./lean_stage3/LeftSmooth.md#LeftSmooth-sL_ne_one) | theorem | shape | `LeftSmooth` | sL t ≠ 1 |
| [`AttainedPi.slack`](./lean_stage3/AttainedPi.md#AttainedPi-slack) | def | reads ζ | `AttainedPi` | ℝ |
| [`AttainedPi.slack_isLittleO`](./lean_stage3/AttainedPi.md#AttainedPi-slack_isLittleO) | theorem | reads ζ | `AttainedPi` | (fun r : ℕ =&gt; slack Θ θ₁ C M ε r) =o[atTop] fun r : ℕ =&gt; ((2:ℝ) ^ Θ) ^ r |
| [`LeftSmooth.smooth_side`](./lean_stage3/LeftSmooth.md#LeftSmooth-smooth_side) | theorem | reads ζ | `LeftSmooth` | ‖∫ t in (-T)..T, (deriv riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I) / riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I) + deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I) / riemannZeta ((5/4:ℂ) - (… |
| [`ExplicitTwo.smooth_side_two`](./lean_stage3/ExplicitTwo.md#ExplicitTwo-smooth_side_two) | theorem | reads ζ | `ExplicitTwo` | ‖∫ t in (-T)..T, (deriv riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I) / riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I) + deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I) / riemannZeta ((5/4:ℂ) - (… |
| [`RHPull.smoothedChebyshev_sqrt_bound`](./lean_stage3/LineBound.md#RHPull-smoothedChebyshev_sqrt_bound) | theorem | reads ζ | `LineBound` | ‖SmoothedChebyshev ν ε X - mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 * X‖ ≤ B₁ + B₉ + (22200 * Real.exp 1 * C / ε) * Real.sqrt X * (Real.log X) ^ 2 + (1 / (2 * Real.pi)) * (1 / 2) * ((1996 * Real.log (84… |
| [`RHPull.smoothedChebyshev_sub_main_norm_le`](./lean_stage3/LineBound.md#RHPull-smoothedChebyshev_sub_main_norm_le) | theorem | reads ζ | `LineBound` | ‖SmoothedChebyshev ν ε X - mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 * X‖ ≤ B₁ + B₉ + (1 / (2 * Real.pi)) * (2 * T) * (11100 * (Real.log X) ^ 2 * M₃₇ * X ^ (σRH X)) + (1 / (2 * Real.pi)) * (1 / 2) * ((19… |
| [`Crossover.spread_is_non_monotone`](./lean/Crossover.md#Crossover-spread_is_non_monotone) | theorem | shape | `Crossover` | (0.0591885 : ℝ) &lt; 0.3026405 ∧ (0.0219312 : ℝ) &lt; 0.3026405 |
| [`Crossover.spread_prime`](./lean/Crossover.md#Crossover-spread_prime) | def | shape | `Crossover` | List ℝ |
| [`Crossover.spread_smooth`](./lean/Crossover.md#Crossover-spread_smooth) | def | shape | `Crossover` | List ℝ |
| [`TableDepths.sq_le_gen`](./lean_stage3/TableDepths.md#TableDepths-sq_le_gen) | theorem | shape | `TableDepths` | r ^ 2 ≤ r₀ ^ 2 * (2:ℝ) ^ ((r - r₀) / 2) |
| [`GateEval.sq_le_two_rpow`](./lean_stage3/GateEval.md#GateEval-sq_le_two_rpow) | theorem | shape | `GateEval` | r ^ 2 ≤ 6400 * (2:ℝ) ^ ((r - 80) / 2) |
| [`SquareMean.sq_mean_lower`](./lean_stage3/SquareMean.md#SquareMean-sq_mean_lower) | theorem | shape | `SquareMean` | π * δ ^ 2 * ‖f c‖ ^ 2 ≤ ∫ u in (c.re - δ)..(c.re + δ), ∫ t in (c.im - δ)..(c.im + δ), ‖f ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2 |
| [`ZetaGrowth.sq_mul_zeta_analytic`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-sq_mul_zeta_analytic) | theorem | reads ζ | `ZetaGrowth` | AnalyticAt ℂ (fun z : ℂ ↦ (z - 1)^2 * riemannZeta z) s |
| [`ContourShift.sq_mul_zeta_analyticAt_one`](./lean_stage3/ContourShift.md#ContourShift-sq_mul_zeta_analyticAt_one) | theorem | reads ζ | `ContourShift` | AnalyticAt ℂ (fun s ↦ (s - 1)^2 * riemannZeta s) 1 |
| [`DirichletMean.sq_norm_sum_eq`](./lean_stage3/DirichletMean.md#DirichletMean-sq_norm_sum_eq) | theorem | shape | `DirichletMean` | ((‖∑ n ∈ Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ)))‖ ^ 2 : ℝ) : ℂ) = ∑ m ∈ Icc 1 N, ∑ n ∈ Icc 1 N, a m * (starRingEnd ℂ) (a n) * Complex.exp (Complex.I * ((Real.log n - Real.log m : ℝ) : ℂ) * t… |
| [`Chain.sq_rpow_half`](./lean/Chain.md#Chain-sq_rpow_half) | theorem | shape | `Chain` | (b ^ (-(1:ℝ)/2)) ^ 2 = b ^ (-(1:ℝ)) |
| [`ZeroDensity.sq_rpow_le`](./lean_stage3/ZeroDensity.md#ZeroDensity-sq_rpow_le) | theorem | shape | `ZeroDensity` | (X:ℝ) ^ 2 ≤ 4 * T ^ (2 * δ) |
| [`SquareMean.sq_set_integral`](./lean_stage3/SquareMean.md#SquareMean-sq_set_integral) | theorem | shape | `SquareMean` | ∫ z in (Icc (c.re - δ) (c.re + δ)) ×ℂ (Icc (c.im - δ) (c.im + δ)), F z = ∫ u in (c.re - δ)..(c.re + δ), ∫ t in (c.im - δ)..(c.im + δ), F ((u : ℂ) + Complex.I * (t : ℂ)) |
| [`ZetaGrowth.sq_zeta_band_bound`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-sq_zeta_band_bound) | theorem | reads ζ | `ZetaGrowth` | ∃ C : ℝ, 0 &lt; C ∧ ∀ s : ℂ, -1/2 ≤ s.re → s.re ≤ 4 → ‖(s - 1)^2 * riemannZeta s‖ ≤ C * (2 + \|s.im\|) ^ 4 |
| [`BoxBounds.sq_zeta_band_explicit`](./lean_stage3/BoxBounds.md#BoxBounds-sq_zeta_band_explicit) | theorem | reads ζ | `BoxBounds` | ‖(s - 1) ^ 2 * riemannZeta s‖ ≤ 135 * (2 + \|s.im\|) ^ 4 |
| [`BoxBounds.sq_zeta_box`](./lean_stage3/BoxBounds.md#BoxBounds-sq_zeta_box) | theorem | reads ζ | `BoxBounds` | ‖(s - 1) ^ 2 * riemannZeta s‖ ≤ 135 |
| [`ZeroSquares.sqG`](./lean_stage3/ZeroSquares.md#ZeroSquares-sqG) | def | reads ζ | `ZeroSquares` | ℝ |
| [`ZeroSquares.sqG_nonneg`](./lean_stage3/ZeroSquares.md#ZeroSquares-sqG_nonneg) | theorem | reads ζ | `ZeroSquares` | 0 ≤ sqG X u t |
| [`Stage3.sqPos_eq`](./lean_stage3/ExplicitBump.md#Stage3-sqPos_eq) | theorem | shape | `ExplicitBump` | (max 0 u) ^ 2 = if u ≤ 0 then 0 else u ^ 2 |
| [`FiniteOffLinePi.sqrt_doubling`](./lean_stage3/FiniteOffLinePi.md#FiniteOffLinePi-sqrt_doubling) | theorem | shape | `FiniteOffLinePi` | Real.sqrt ((2:ℝ) ^ r) = Real.sqrt 2 ^ r |
| [`Stage3.sqrt_le_rpow_theta`](./lean_stage3/ThetaPi.md#Stage3-sqrt_le_rpow_theta) | theorem | shape | `ThetaPi` | Real.sqrt x ≤ x ^ θ |
| [`FilterLadder.sqrt_split`](./lean_stage3/FilterLadder.md#FilterLadder-sqrt_split) | theorem | shape | `FilterLadder` | Real.sqrt 2 ^ n * (Real.sqrt 2)⁻¹ ^ j = Real.sqrt 2 ^ (n - j) |
| [`MirrorArea.square_iff`](./lean_stage3/MirrorArea.md#MirrorArea-square_iff) | theorem | shape | `MirrorArea` | (‖(b : ℂ) ^ ρ‖ = Real.sqrt b ∧ ‖(b : ℂ) ^ (1 - ρ)‖ = Real.sqrt b) ↔ ρ.re = 1 / 2 |
| [`ZeroSquares.square_lower`](./lean_stage3/ZeroSquares.md#ZeroSquares-square_lower) | theorem | reads ζ | `ZeroSquares` | Real.pi * δ ^ 2 ≤ ∫ u in (σ - δ)..(1 + δ), innerI X ((n : ℝ) + 7 / 4) ((n : ℝ) + 13 / 4) u |
| [`NyquistPeak.stationary_maximum`](./lean/NyquistPeak.md#NyquistPeak-stationary_maximum) | theorem | shape | `NyquistPeak` | HasDerivAt (gain d) 0 Real.pi ∧ (∀ θ : ℝ, gain d θ ≤ gain d Real.pi) ∧ (∀ θ : ℝ, \|Real.sin (θ / 2)\| ≠ 1 → gain d θ &lt; gain d Real.pi) |
| [`CellZeros.stencil`](./lean_stage3/CellZeros.md#CellZeros-stencil) | def | shape | `CellZeros` | ℂ |
| [`Zeros.stencil`](./lean/ZerosStencil.md#Zeros-stencil) | def | counting | `ZerosStencil` | ℤ |
| [`CellZeros.stencil_add`](./lean_stage3/CellZeros.md#CellZeros-stencil_add) | theorem | shape | `CellZeros` | stencil d (fun n =&gt; a n + b n) r = stencil d a r + stencil d b r |
| [`Zeros.stencil_add`](./lean/ZerosStencil.md#Zeros-stencil_add) | theorem | counting | `ZerosStencil` | stencil N (fun k =&gt; g k + h k) = stencil N g + stencil N h |
| [`Zeros.stencil_annihilates_const`](./lean/ZerosStencil.md#Zeros-stencil_annihilates_const) | theorem | counting | `ZerosStencil` | stencil N (fun _ =&gt; c) = 0 |
| [`Zeros.stencil_arm_doubled`](./lean/ZerosStencil.md#Zeros-stencil_arm_doubled) | theorem | counting | `ZerosStencil` | (∑ k ∈ Finset.range (N + 1), (1 + (-1 : ℤ) ^ k) * (N.choose k)) = 2 ^ N |
| [`Zeros.stencil_arms_eq`](./lean/ZerosStencil.md#Zeros-stencil_arms_eq) | theorem | counting | `ZerosStencil` | (∑ k ∈ Finset.range (N + 1), (1 + (-1 : ℤ) ^ k) * (N.choose k)) = ∑ k ∈ Finset.range (N + 1), (1 - (-1 : ℤ) ^ k) * (N.choose k) |
| [`PiZeros.stencil_congr`](./lean_stage3/PiZeros.md#PiZeros-stencil_congr) | theorem | shape | `PiZeros` | CellZeros.stencil n a r = CellZeros.stencil n b r |
| [`CellZeros.stencil_const_mul`](./lean_stage3/CellZeros.md#CellZeros-stencil_const_mul) | theorem | shape | `CellZeros` | stencil d (fun n =&gt; c * a n) r = c * stencil d a r |
| [`CellBdiff.stencil_eq_bdiff_iter`](./lean_stage3/CellBdiff.md#CellBdiff-stencil_eq_bdiff_iter) | theorem | shape | `CellBdiff` | CellZeros.stencil d a r = (Chain.bdiff^[d]) g (r : ℂ) |
| [`Zeros.stencil_eq_wings`](./lean/ZerosStencil.md#Zeros-stencil_eq_wings) | theorem | counting | `ZerosStencil` | stencil N g = wingPlus N g - wingMinus N g |
| [`Zeros.stencil_eq_zero_iff_wings`](./lean/ZerosStencil.md#Zeros-stencil_eq_zero_iff_wings) | theorem | counting | `ZerosStencil` | stencil N g = 0 ↔ wingPlus N g = wingMinus N g |
| [`CellZeros.stencil_mode`](./lean_stage3/CellZeros.md#CellZeros-stencil_mode) | theorem | shape | `CellZeros` | stencil d (fun n : ℤ =&gt; w ^ n) r = w ^ r * (1 - w⁻¹) ^ d |
| [`PiZeros.stencil_neg`](./lean_stage3/PiZeros.md#PiZeros-stencil_neg) | theorem | shape | `PiZeros` | CellZeros.stencil n (fun m =&gt; -a m) r = -CellZeros.stencil n a r |
| [`Zeros.stencil_smul`](./lean/ZerosStencil.md#Zeros-stencil_smul) | theorem | counting | `ZerosStencil` | stencil N (fun k =&gt; c * g k) = c * stencil N g |
| [`CellZeros.stencil_sub`](./lean_stage3/CellZeros.md#CellZeros-stencil_sub) | theorem | shape | `CellZeros` | stencil d (fun n =&gt; a n - b n) r = stencil d a r - stencil d b r |
| [`CellZeros.stencil_sum`](./lean_stage3/CellZeros.md#CellZeros-stencil_sum) | theorem | shape | `CellZeros` | stencil d (fun n =&gt; ∑ i ∈ s, f i n) r = ∑ i ∈ s, stencil d (f i) r |
| [`Zeros.stencil_weights_antisymm`](./lean/ZerosStencil.md#Zeros-stencil_weights_antisymm) | theorem | counting | `ZerosStencil` | ((-1 : ℤ)) ^ (N - k) * (N.choose (N - k)) = -(((-1 : ℤ)) ^ k * (N.choose k)) |
| [`CellZeros.stencil_zeroPartialSum`](./lean_stage3/CellZeros.md#CellZeros-stencil_zeroPartialSum) | theorem | reads ζ | `CellZeros` | stencil d (fun n : ℤ =&gt; Stage3.zeroPartialSum ((2:ℝ) ^ n) T) r = ∑' ρ : {ρ : Kadiri.NontrivialZeros // \|(ρ : ℂ).im\| &lt; T}, ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ) * (((2:ℂ) ^ (… |
| [`Nonvanishing.stencilR`](./lean/Nonvanishing.md#Nonvanishing-stencilR) | def | shape | `Nonvanishing` | ℝ |
| [`CellResidual.stencilR_abs_le`](./lean_stage3/CellResidual.md#CellResidual-stencilR_abs_le) | theorem | shape | `CellResidual` | \|stencilR n g r\| ≤ B * (1 + t) ^ n |
| [`PiZeros.stencilR_cast`](./lean_stage3/PiZeros.md#PiZeros-stencilR_cast) | theorem | shape | `PiZeros` | ((Nonvanishing.stencilR n g r : ℝ) : ℂ) = CellZeros.stencil n (fun m =&gt; ((g m : ℝ) : ℂ)) r |
| [`MainTerm.stencilR_eq_iter`](./lean/MainTerm.md#MainTerm-stencilR_eq_iter) | theorem | shape | `MainTerm` | Nonvanishing.stencilR n (fun k : ℤ =&gt; G k) r = (bdiffR^[n]) G r |
| [`MainTerm.stencilR_ge_of`](./lean/MainTerm.md#MainTerm-stencilR_ge_of) | theorem | shape | `MainTerm` | c ≤ \|Nonvanishing.stencilR (d + 1) (fun k : ℤ =&gt; G k) r\| |
| [`CellResidual.stencilR_one`](./lean_stage3/CellResidual.md#CellResidual-stencilR_one) | theorem | shape | `CellResidual` | stencilR 1 g r = g r - g (r - 1) |
| [`Nonvanishing.stencilR_row`](./lean/Nonvanishing.md#Nonvanishing-stencilR_row) | theorem | shape | `Nonvanishing` | stencilR d (bdiffZ g) r = stencilR (d + 1) g r |
| [`Nonvanishing.stencilR_sub`](./lean/Nonvanishing.md#Nonvanishing-stencilR_sub) | theorem | shape | `Nonvanishing` | stencilR n (fun x =&gt; f x - L x) r = stencilR n f r - stencilR n L r |
| [`StencilWeil.stencilTest`](./lean_stage3/StencilWeil.md#StencilWeil-stencilTest) | def | shape | `StencilWeil` | ℝ → ℂ |
| [`StencilWeil.stencilTest_zero_outside`](./lean_stage3/StencilWeil.md#StencilWeil-stencilTest_zero_outside) | theorem | shape | `StencilWeil` | stencilTest d φ u = 0 |
| [`CellResidual.step_le`](./lean_stage3/CellResidual.md#CellResidual-step_le) | theorem | shape | `CellResidual` | \|resid a r - resid a (r - 1)\| ≤ C * cellSize r 0 |
| [`Chain.StmtA1`](./lean/Chain.md#Chain-StmtA1) | def | shape | `Chain` | Prop |
| [`Chain.StmtA2`](./lean/Chain.md#Chain-StmtA2) | def | reads ζ | `Chain` | Prop |
| [`Chain.StmtA3`](./lean/Chain.md#Chain-StmtA3) | def | reads ζ | `Chain` | Prop |
| [`Chain.StmtA4`](./lean/Chain.md#Chain-StmtA4) | def | shape | `Chain` | Prop |
| [`Stage3.StmtArgIdentity`](./lean_stage3/ArgCrude.md#Stage3-StmtArgIdentity) | def | reads ζ | `ArgCrude` | Prop |
| [`Stage3.stmtArgIdentity_holds`](./lean_stage3/ArgIdentity.md#Stage3-stmtArgIdentity_holds) | theorem | reads ζ | `ArgIdentity` | StmtArgIdentity phaseTheta argS |
| [`Chain.StmtB4`](./lean/Chain.md#Chain-StmtB4) | def | shape | `Chain` | Prop |
| [`Chain.StmtB5`](./lean/Chain.md#Chain-StmtB5) | def | shape | `Chain` | Prop |
| [`Stage3.StmtBacklundArg`](./lean_stage3/RvMCrude.md#Stage3-StmtBacklundArg) | def | reads ζ | `RvMCrude` | Prop |
| [`Stage3.StmtBacklundPhase`](./lean_stage3/RvMCrude.md#Stage3-StmtBacklundPhase) | def | reads ζ | `RvMCrude` | Prop |
| [`Chain.StmtC1`](./lean/Chain.md#Chain-StmtC1) | def | shape | `Chain` | Prop |
| [`Chain.StmtC2`](./lean/Chain.md#Chain-StmtC2) | def | shape | `Chain` | Prop |
| [`Chain.StmtC3`](./lean/Chain.md#Chain-StmtC3) | def | shape | `Chain` | Prop |
| [`Chain.StmtC3lower`](./lean/Chain.md#Chain-StmtC3lower) | def | shape | `Chain` | Prop |
| [`WeilDetect.StmtDetect`](./lean_stage3/WeilDetect.md#WeilDetect-StmtDetect) | def | reads ζ | `WeilDetect` | Prop |
| [`WeilPowerAssembly.StmtDetectGap`](./lean_stage3/WeilPowerAssembly.md#WeilPowerAssembly-StmtDetectGap) | def | reads ζ | `WeilPowerAssembly` | Prop |
| [`Stage3.StmtDigammaLog`](./lean_stage3/Stirling.md#Stage3-StmtDigammaLog) | def | shape | `Stirling` | Prop |
| [`Stage3.stmtDigammaLog_holds`](./lean_stage3/Stirling.md#Stage3-stmtDigammaLog_holds) | theorem | reads ζ | `Stirling` | StmtDigammaLog 97 |
| [`Glue.stmtEF_poly`](./lean_stage3/Glue.md#Glue-stmtEF_poly) | theorem | reads ζ | `Glue` | ∃ c₁ c₂ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₂ ∧ Stage3.StmtExplicitFormulaPoly c₁ c₂ 16 |
| [`Stage3.stmtEF_split`](./lean_stage3/GlueFloor.md#Stage3-stmtEF_split) | theorem | reads ζ | `GlueFloor` | ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ StmtExplicitFormulaSplit c₁ c₃ c₄ 16 |
| [`Stage3.stmtEF_split_num`](./lean_stage3/RouteNum.md#Stage3-stmtEF_split_num) | theorem | reads ζ | `RouteNum` | StmtExplicitFormulaSplit Glue.c1n Glue.c3n Glue.c4n 16 |
| [`Stage3.StmtExplicitFormula`](./lean_stage3/Assembly.md#Stage3-StmtExplicitFormula) | def | reads ζ | `Assembly` | Prop |
| [`Stage3.StmtExplicitFormulaPoly`](./lean_stage3/Assembly.md#Stage3-StmtExplicitFormulaPoly) | def | reads ζ | `Assembly` | Prop |
| [`Stage3.StmtExplicitFormulaSplit`](./lean_stage3/GlueFloor.md#Stage3-StmtExplicitFormulaSplit) | def | reads ζ | `GlueFloor` | Prop |
| [`LandauCriterion.stmtLandauWindow`](./lean_stage3/LandauCriterion.md#LandauCriterion-stmtLandauWindow) | theorem | reads ζ | `LandauCriterion` | LandauWindow.StmtLandauWindow |
| [`LandauWindow.StmtLandauWindow`](./lean_stage3/LandauWindow.md#LandauWindow-StmtLandauWindow) | def | reads ζ | `LandauWindow` | Prop |
| [`Stage3.StmtLocalCount`](./lean_stage3/ArgCrude.md#Stage3-StmtLocalCount) | def | shape | `ArgCrude` | Prop |
| [`Stage3.StmtPsiWeak`](./lean_stage3/PsiToPi.md#Stage3-StmtPsiWeak) | def | shape | `PsiToPi` | Prop |
| [`Stage3.stmtPsiWeak_iff_theta_half`](./lean_stage3/ThetaPi.md#Stage3-stmtPsiWeak_iff_theta_half) | theorem | shape | `ThetaPi` | StmtPsiWeak C k x₀ ↔ StmtPsiWeakTheta (1/2) C k x₀ |
| [`RHPull.stmtPsiWeak_of_RH`](./lean_stage3/LineBound.md#RHPull-stmtPsiWeak_of_RH) | theorem | reads ζ | `LineBound` | ∃ C &gt; 0, ∃ x₀ : ℝ, Stage3.StmtPsiWeak C 3 x₀ |
| [`Stage3.stmtPsiWeak_of_RH_half`](./lean_stage3/ThetaPsi.md#Stage3-stmtPsiWeak_of_RH_half) | theorem | reads ζ | `ThetaPsi` | ∃ C &gt; 0, ∃ x₀ : ℝ, Stage3.StmtPsiWeak C 3 x₀ |
| [`Stage3.StmtPsiWeakTheta`](./lean_stage3/ThetaPi.md#Stage3-StmtPsiWeakTheta) | def | shape | `ThetaPi` | Prop |
| [`JointDialGate.StmtRelErrWindow`](./lean_stage3/JointDialGate.md#JointDialGate-StmtRelErrWindow) | def | shape | `JointDialGate` | Prop |
| [`RelativeGate.StmtRelErrWindow`](./lean/RelativeGate.md#RelativeGate-StmtRelErrWindow) | def | shape | `RelativeGate` | Prop |
| [`Schoenfeld.StmtSchoenfeld`](./lean/Schoenfeld.md#Schoenfeld-StmtSchoenfeld) | def | shape | `Schoenfeld` | Prop |
| [`Stage3.StmtSchoenfeld`](./lean_stage3/Statement.md#Stage3-StmtSchoenfeld) | def | shape | `Statement` | Prop |
| [`Stage3.StmtSchoenfeldWeak`](./lean_stage3/Statement.md#Stage3-StmtSchoenfeldWeak) | def | shape | `Statement` | Prop |
| [`Stage3.stmtSchoenfeldWeak_iff_theta_half`](./lean_stage3/ThetaPi.md#Stage3-stmtSchoenfeldWeak_iff_theta_half) | theorem | shape | `ThetaPi` | StmtSchoenfeldWeak C k x₀ pi li ↔ StmtSchoenfeldWeakTheta (1/2) C k x₀ pi li |
| [`Stage3.StmtSchoenfeldWeakTheta`](./lean_stage3/ThetaPi.md#Stage3-StmtSchoenfeldWeakTheta) | def | shape | `ThetaPi` | Prop |
| [`Nonvanishing.StmtSchoenfeldWindow`](./lean/Nonvanishing.md#Nonvanishing-StmtSchoenfeldWindow) | def | shape | `Nonvanishing` | Prop |
| [`Stage3.StmtSchoenfeldWindow`](./lean_stage3/Statement.md#Stage3-StmtSchoenfeldWindow) | def | shape | `Statement` | Prop |
| [`Stage3.StmtSCrude`](./lean_stage3/ArgCrude.md#Stage3-StmtSCrude) | def | shape | `ArgCrude` | Prop |
| [`Stage3.StmtSFromLocal`](./lean_stage3/ArgCrude.md#Stage3-StmtSFromLocal) | def | shape | `ArgCrude` | Prop |
| [`WeilPowerCount.StmtShortCount`](./lean_stage3/WeilPowerCount.md#WeilPowerCount-StmtShortCount) | def | shape | `WeilPowerCount` | Prop |
| [`Stage3.StmtWeakWindow`](./lean_stage3/Statement.md#Stage3-StmtWeakWindow) | def | shape | `Statement` | Prop |
| [`Bridge.StmtWeilBridge`](./lean_bridge/WeilBridge.md#Bridge-StmtWeilBridge) | def | reads ζ | `WeilBridge` | Prop |
| [`WeilBridgeLeaf.StmtWeilBridge`](./lean_stage3/WeilBridgeLeaf.md#WeilBridgeLeaf-StmtWeilBridge) | def | reads ζ | `WeilBridgeLeaf` | Prop |
| [`Bridge.stmtWeilBridge_holds`](./lean_bridge/WeilBridge.md#Bridge-stmtWeilBridge_holds) | theorem | reads ζ | `WeilBridge` | StmtWeilBridge |
| [`WeilDetect.StmtWeilPositive`](./lean_stage3/WeilDetect.md#WeilDetect-StmtWeilPositive) | def | reads ζ | `WeilDetect` | Prop |
| [`Stage3.StmtZeroFreeRight`](./lean_stage3/Abscissa.md#Stage3-StmtZeroFreeRight) | def | reads ζ | `Abscissa` | Prop |
| [`GeneratorPeak.strictAnti_of_lt`](./lean/GeneratorPeak.md#GeneratorPeak-strictAnti_of_lt) | theorem | shape | `GeneratorPeak` | StrictAnti (score R P α β) |
| [`GeneratorPeak.strictMono_of_lt`](./lean/GeneratorPeak.md#GeneratorPeak-strictMono_of_lt) | theorem | shape | `GeneratorPeak` | StrictMono (score R P α β) |
| [`Transform.strip_is_fundamental_domain`](./lean/Transform.md#Transform-strip_is_fundamental_domain) | theorem | shape | `Transform` | ‖(b : ℂ) ^ (-s)‖ = 1 ∧ (s + 1).re = 1 ∧ ‖(b : ℂ) ^ (-(s + 1))‖ = b ^ (-(1 : ℝ)) |
| [`ZetaGrowth.stripRegion`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-stripRegion) | def | shape | `ZetaGrowth` | Set ℂ |
| [`ZeroSquares.strips_le`](./lean_stage3/ZeroSquares.md#ZeroSquares-strips_le) | theorem | reads ζ | `ZeroSquares` | ∑ n ∈ Finset.range L, innerI X ((n : ℝ) + 7 / 4) ((n : ℝ) + 13 / 4) u ≤ 3 * innerI X 1 T u |
| [`MollifiedMean.sum_b_sq_eq`](./lean_stage3/MollifiedMean.md#MollifiedMean-sum_b_sq_eq) | theorem | shape | `MollifiedMean` | ∑ n ∈ Icc 1 Y, b X N n ^ 2 * w n = ∑ n ∈ Icc X Y, (Mollified.coef X N n : ℝ) ^ 2 * w n |
| [`LandauTrig.sum_block_ge`](./lean_stage3/LandauTrig.md#LandauTrig-sum_block_ge) | theorem | shape | `LandauTrig` | -(∑ j ∈ s, ‖c j‖ * (2 / ‖z j - 1‖)) ≤ ∑ n ∈ Finset.Ico a (a + N), T n |
| [`WeilPowerBands.sum_by_bands`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-sum_by_bands) | theorem | reads ζ | `WeilPowerBands` | ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ ∑ k ∈ S.image (fun ρ : Kadiri.NontrivialZeros =&gt; idx (ρ : ℂ).im), M k * (15 * Real.log (centre k) + 73) |
| [`WeilTiles.sum_by_bands`](./lean_stage3/WeilTiles.md#WeilTiles-sum_by_bands) | theorem | reads ζ | `WeilTiles` | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ ∑ k ∈ S.image (fun ρ : Kadiri.NontrivialZeros =&gt; idx (ρ : ℂ).im), M k * (15 * Real.log (centre k) + 73) |
| [`Mollified.sum_coef_sq_le`](./lean_stage3/Mollified.md#Mollified-sum_coef_sq_le) | theorem | shape | `Mollified` | ∑ n ∈ Icc 1 Y, (coef X N n : ℝ) ^ 2 ≤ Y * (1 + Real.log X) ^ 3 |
| [`MollifiedMean.sum_coef_sq_up_le`](./lean_stage3/MollifiedMean.md#MollifiedMean-sum_coef_sq_up_le) | theorem | shape | `MollifiedMean` | ∑ n ∈ Icc 1 Y, (Mollified.coef X N n : ℝ) ^ 2 * (n : ℝ) ^ (1 - 2 * u) ≤ 4 * (1 + Real.log X) ^ 3 * (1 + Real.log Y) * max 1 ((Y : ℝ) ^ (2 - 2 * u)) |
| [`Mollified.sum_coef_sq_weighted_le`](./lean_stage3/Mollified.md#Mollified-sum_coef_sq_weighted_le) | theorem | shape | `Mollified` | ∑ n ∈ Icc X Y, (coef X N n : ℝ) ^ 2 * (n : ℝ) ^ (-2 * u) ≤ 2 / (1 - (2 : ℝ) ^ (1 - 2 * u)) * (X : ℝ) ^ (1 - 2 * u) * (1 + Real.log X) ^ 3 |
| [`WeilPowerTail.sum_hterm_sq_le`](./lean_stage3/WeilPowerTail.md#WeilPowerTail-sum_hterm_sq_le) | theorem | shape | `WeilPowerTail` | ∑ j ∈ Finset.Ico (m + 1) n, hterm j ^ 2 ≤ 1 / (3 * Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3) |
| [`VonKoch.sum_Icc_vonMangoldt`](./lean_stage3/VonKochScaffold.md#VonKoch-sum_Icc_vonMangoldt) | theorem | reads ζ | `VonKochScaffold` | ∑ k ∈ Finset.Icc 1 n, ArithmeticFunction.vonMangoldt k = ψ n |
| [`Mollified.sum_Ico_dyadic`](./lean_stage3/Mollified.md#Mollified-sum_Ico_dyadic) | theorem | shape | `Mollified` | ∑ n ∈ Ico X (2 ^ J * X), f n = ∑ j ∈ range J, ∑ n ∈ Ico (2 ^ j * X) (2 ^ (j + 1) * X), f n |
| [`DirichletMean.sum_inv_dist_le`](./lean_stage3/DirichletMean.md#DirichletMean-sum_inv_dist_le) | theorem | shape | `DirichletMean` | ∑ n ∈ Icc 1 N, (if m = n then 0 else \|(m : ℝ) - n\|⁻¹) ≤ 2 * (1 + Real.log N) |
| [`DirichletMean.sum_inv_Icc_le`](./lean_stage3/DirichletMean.md#DirichletMean-sum_inv_Icc_le) | theorem | shape | `DirichletMean` | ∑ k ∈ Icc 1 N, (k : ℝ)⁻¹ ≤ 1 + Real.log N |
| [`Mollified.sum_inv_Ico_le`](./lean_stage3/Mollified.md#Mollified-sum_inv_Ico_le) | theorem | shape | `Mollified` | ∑ k ∈ Ico 1 X, ((k : ℝ))⁻¹ ≤ 1 + Real.log X |
| [`LandauCrude.sum_inv_le`](./lean_stage3/LandauCrude.md#LandauCrude-sum_inv_le) | theorem | shape | `LandauCrude` | ∑ n ∈ Finset.range (N + 1), ((n : ℝ))⁻¹ ≤ 1 + Real.log N |
| [`DirichletMean.sum_inv_le_harmonic`](./lean_stage3/DirichletMean.md#DirichletMean-sum_inv_le_harmonic) | theorem | shape | `DirichletMean` | ∑ n ∈ s, ((g n : ℕ) : ℝ)⁻¹ ≤ ∑ k ∈ Icc 1 N, (k : ℝ)⁻¹ |
| [`WeilPowerGauss.sum_inv_pow4_le`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-sum_inv_pow4_le) | theorem | shape | `WeilPowerGauss` | ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4 ≤ 1 / ((m : ℝ) + 1) ^ 3 |
| [`WeilPowerTail.sum_inv_pow4_le_third`](./lean_stage3/WeilPowerTail.md#WeilPowerTail-sum_inv_pow4_le_third) | theorem | shape | `WeilPowerTail` | ∀ n : ℕ, m + 1 ≤ n → ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4 ≤ 1 / 3 * (1 / ((m : ℝ) + 1) ^ 3 - 1 / (n : ℝ) ^ 3) |
| [`Stage3.sum_inv_pow_two_le`](./lean_stage3/ZeroSum.md#Stage3-sum_inv_pow_two_le) | theorem | shape | `ZeroSum` | (∑ j ∈ range n, ((2 : ℝ) ^ j)⁻¹) ≤ 2 |
| [`WeilPowerGauss.sum_inv_sq_ge`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-sum_inv_sq_ge) | theorem | shape | `WeilPowerGauss` | ((m : ℝ) + 2) / (2 * (m : ℝ) + 3) ^ 2 ≤ ∑ j ∈ Finset.Ico (m + 1) (2 * m + 3), 1 / ((j : ℝ) + 1) ^ 2 |
| [`WeilPowerSharp.sum_inv_sq_ge_sharp`](./lean_stage3/WeilPowerSharp.md#WeilPowerSharp-sum_inv_sq_ge_sharp) | theorem | shape | `WeilPowerSharp` | 1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1) ≤ ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 |
| [`WeilPowerGauss.sum_inv_sq_le`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-sum_inv_sq_le) | theorem | shape | `WeilPowerGauss` | ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 ≤ 1 / ((m : ℝ) + 1) |
| [`WeilPowerBands.sum_le_bandSeries`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-sum_le_bandSeries) | theorem | reads ζ | `WeilPowerBands` | ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ ∑' k : ℕ, M k * (15 * Real.log (centre k) + 73) |
| [`WeilTiles.sum_le_bandSeries`](./lean_stage3/WeilTiles.md#WeilTiles-sum_le_bandSeries) | theorem | reads ζ | `WeilTiles` | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ ∑' k : ℕ, M k * (15 * Real.log (centre k) + 73) |
| [`ZeroSummable.sum_le_const`](./lean_stage3/ZeroSummable.md#ZeroSummable-sum_le_const) | theorem | reads ζ | `ZeroSummable` | ∃ M : ℝ, ∀ v : Finset NontrivialZeros, (∀ ρ ∈ v, σ ≤ (ρ : ℂ).re) → ∑ ρ ∈ v, w ρ ≤ M |
| [`WeilOnLine.sum_low_le`](./lean_stage3/WeilOnLine.md#WeilOnLine-sum_low_le) | theorem | reads ζ | `WeilOnLine` | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ 4 * h ^ 2 * lowCount |
| [`WeilPowerOnLine.sum_low_le`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-sum_low_le) | theorem | reads ζ | `WeilPowerOnLine` | ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ 4 * h ^ 2 * lowCount |
| [`WeilPowerSigma.sum_lower_amgm`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-sum_lower_amgm) | theorem | shape | `WeilPowerSigma` | 1 / ((m : ℝ) + 2) + 1 / (2 * ((m : ℝ) + 2) ^ 2) - 1 / ((n : ℝ) + 1) - 1 / (2 * ((n : ℝ) + 1) ^ 2) ≤ ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 |
| [`WeilOnLine.sum_lower_le`](./lean_stage3/WeilOnLine.md#WeilOnLine-sum_lower_le) | theorem | reads ζ | `WeilOnLine` | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ B h γ |
| [`WeilPowerOnLine.sum_lower_le`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-sum_lower_le) | theorem | reads ζ | `WeilPowerOnLine` | ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ B h γ m |
| [`DirichletMean.sum_mul_mul_le`](./lean_stage3/DirichletMean.md#DirichletMean-sum_mul_mul_le) | theorem | shape | `DirichletMean` | ∑ m ∈ s, ∑ n ∈ s, A m * A n * K m n ≤ R * ∑ m ∈ s, A m ^ 2 |
| [`DirichletMeanW.sum_mul_mul_le_weighted`](./lean_stage3/DirichletMeanW.md#DirichletMeanW-sum_mul_mul_le_weighted) | theorem | shape | `DirichletMeanW` | ∑ m ∈ s, ∑ n ∈ s, A m * A n * K m n ≤ ∑ m ∈ s, A m ^ 2 * R m |
| [`ZetaGrowth.sum_norm_le`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-sum_norm_le) | theorem | shape | `ZetaGrowth` | ‖∑ n ∈ Finset.range N, 1 / ((n:ℂ) + 1) ^ s‖ ≤ (N:ℝ) * (N:ℝ) ^ ((1:ℝ)/2) |
| [`WeilOnLine.sum_onLine_le`](./lean_stage3/WeilOnLine.md#WeilOnLine-sum_onLine_le) | theorem | reads ζ | `WeilOnLine` | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ onLineBound h γ |
| [`WeilPowerOnLine.sum_onLine_le`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-sum_onLine_le) | theorem | reads ζ | `WeilPowerOnLine` | ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ onLineBound h γ m |
| [`WeilOnLine.sum_onLine_subtype_le`](./lean_stage3/WeilOnLine.md#WeilOnLine-sum_onLine_subtype_le) | theorem | reads ζ | `WeilOnLine` | ∑ ρ ∈ s, weightedTerm h γ ρ.1 ≤ onLineBound h γ |
| [`WeilPowerOnLine.sum_onLine_subtype_le`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-sum_onLine_subtype_le) | theorem | reads ζ | `WeilPowerOnLine` | ∑ ρ ∈ s, weightedTermW h γ m ρ.1 ≤ onLineBound h γ m |
| [`AliasClass.sum_order_div_ne_zero`](./lean_stage3/AliasClass.md#AliasClass-sum_order_div_ne_zero) | theorem | reads ζ | `AliasClass` | ∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) ≠ 0 |
| [`PiRemainder.sum_order_inv_le`](./lean_stage3/PiRemainder.md#PiRemainder-sum_order_inv_le) | theorem | reads ζ | `PiRemainder` | ∑ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹ ≤ Mlow * ∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹ * (2 * \|riemannZeta.N ((2 : ℝ) ^ (j + 1))\| + weightedZeroHeightBucket) |
| [`PiFixedRow.sum_order_inv_sq_le`](./lean_stage3/PiFixedRow.md#PiFixedRow-sum_order_inv_sq_le) | theorem | reads ζ | `PiFixedRow` | ∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * (‖(ρ : ℂ)‖⁻¹) ^ 2 ≤ Z2 |
| [`FiniteOffLine.sum_order_onLineInv_le`](./lean_stage3/FiniteOffLine.md#FiniteOffLine-sum_order_onLineInv_le) | theorem | reads ζ | `FiniteOffLine` | ∑ ρ ∈ ZF ((2 : ℝ) ^ (K + 1)), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * onLineInv ρ ≤ 2 * ∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹ * (2 * \|riemannZeta.N ((2 : ℝ) ^ (j + 1))\| + weightedZeroHeightBucket) |
| [`Elephant.sum_primeIndicator`](./lean/Elephant.md#Elephant-sum_primeIndicator) | theorem | shape | `Elephant` | ∑ m ∈ Finset.range (x + 1), primeIndicator m = (Nat.primeCounting x : ℂ) |
| [`Stage3.sum_range_add_one`](./lean_stage3/ZeroSum.md#Stage3-sum_range_add_one) | theorem | shape | `ZeroSum` | (∑ j ∈ range n, ((j : ℝ) + 1)) = n * (n + 1) / 2 |
| [`ZetaEM.sum_range_eq_sum_Icc`](./lean_stage3/ZetaEM.md#ZetaEM-sum_range_eq_sum_Icc) | theorem | reads ζ | `ZetaEM` | ∑ n ∈ Finset.range N, 1 / ((n:ℂ) + 1) ^ s = ∑ n ∈ Finset.Icc 1 N, (n : ℂ) ^ (-s) |
| [`ZetaEM.sum_range_succ_eq_sum_Icc`](./lean_stage3/ZetaEM.md#ZetaEM-sum_range_succ_eq_sum_Icc) | theorem | reads ζ | `ZetaEM` | ∑ n ∈ Finset.range (N + 1), 1 / (n : ℂ) ^ s = ∑ n ∈ Finset.Icc 1 N, (n : ℂ) ^ (-s) |
| [`Elephant.sum_shift`](./lean/Elephant.md#Elephant-sum_shift) | theorem | shape | `Elephant` | ∑ m ∈ Finset.range (x + 1), (if b ∣ m then a (m / b) else 0) = ∑ k ∈ Finset.range (x / b + 1), a k |
| [`LandauTrig.sum_sq_block_ge`](./lean_stage3/LandauTrig.md#LandauTrig-sum_sq_block_ge) | theorem | shape | `LandauTrig` | (N : ℝ) * ∑ j ∈ s, ‖c j‖ ^ 2 - ∑ j ∈ s, ∑ l ∈ s, (if j = l then 0 else ‖c j‖ * ‖c l‖ * (2 / ‖z j * conj (z l) - 1‖)) ≤ ∑ n ∈ Finset.Ico a (a + N), T n ^ 2 |
| [`PiFixedRow.sum_sq_div_pow_eq`](./lean_stage3/PiFixedRow.md#PiFixedRow-sum_sq_div_pow_eq) | theorem | counting | `PiFixedRow` | ∑ j ∈ range n, ((2:ℝ) ^ j)⁻¹ * ((j:ℝ) + 2) ^ 2 + (2 * (n:ℝ) ^ 2 + 12 * n + 22) * ((2:ℝ) ^ n)⁻¹ = 22 |
| [`PiFixedRow.sum_sq_div_pow_le`](./lean_stage3/PiFixedRow.md#PiFixedRow-sum_sq_div_pow_le) | theorem | counting | `PiFixedRow` | ∑ j ∈ range n, ((2:ℝ) ^ j)⁻¹ * ((j:ℝ) + 2) ^ 2 ≤ 22 |
| [`LadderFading.sum_sub_shift`](./lean_stage3/LadderFading.md#LadderFading-sum_sub_shift) | theorem | shape | `LadderFading` | (∑ z ∈ Z, c z * z ^ (r + 1)) - z₀ * ∑ z ∈ Z, c z * z ^ r = ∑ z ∈ Z.erase z₀, (c z * (z - z₀)) * z ^ r |
| [`Mollified.sum_tauBelow_sq_le`](./lean_stage3/Mollified.md#Mollified-sum_tauBelow_sq_le) | theorem | shape | `Mollified` | ∑ n ∈ Icc 1 Y, (tauBelow X n : ℝ) ^ 2 ≤ Y * (1 + Real.log X) ^ 3 |
| [`WeilPowerSharp.sum_telescope`](./lean_stage3/WeilPowerSharp.md#WeilPowerSharp-sum_telescope) | theorem | shape | `WeilPowerSharp` | ∀ n : ℕ, m + 1 ≤ n → ∑ j ∈ Finset.Ico (m + 1) n, 1 / (((j : ℝ) + 1) * ((j : ℝ) + 2)) = 1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1) |
| [`WeilPowerSigma.sum_telescope_amgm`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-sum_telescope_amgm) | theorem | shape | `WeilPowerSigma` | ∀ n : ℕ, m + 1 ≤ n → ∑ j ∈ Finset.Ico (m + 1) n, ((1 / ((j : ℝ) + 1) - 1 / ((j : ℝ) + 2)) + (1 / (2 * ((j : ℝ) + 1) ^ 2) - 1 / (2 * ((j : ℝ) + 2) ^ 2))) = (1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1)) + (1 … |
| [`WeilPowerSigma.sum_telescope_half`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-sum_telescope_half) | theorem | shape | `WeilPowerSigma` | ∀ n : ℕ, m + 1 ≤ n → ∑ j ∈ Finset.Ico (m + 1) n, (1 / ((j : ℝ) + 1 / 2) - 1 / ((j : ℝ) + 3 / 2)) = 1 / ((m : ℝ) + 3 / 2) - 1 / ((n : ℝ) + 1 / 2) |
| [`ZeroSquares.sum_unit_strips`](./lean_stage3/ZeroSquares.md#ZeroSquares-sum_unit_strips) | theorem | reads ζ | `ZeroSquares` | ∑ n ∈ Finset.range L, innerI X ((n : ℝ) + c) ((n : ℝ) + 1 + c) u = innerI X c ((L : ℝ) + c) u |
| [`WeilPowerSigma.sum_upper_half`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-sum_upper_half) | theorem | shape | `WeilPowerSigma` | ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 ≤ 2 / (2 * (m : ℝ) + 3) |
| [`WeilOnLine.sum_upper_le`](./lean_stage3/WeilOnLine.md#WeilOnLine-sum_upper_le) | theorem | reads ζ | `WeilOnLine` | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ B h γ |
| [`WeilPowerOnLine.sum_upper_le`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-sum_upper_le) | theorem | reads ζ | `WeilPowerOnLine` | ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ B h γ m |
| [`WeilPowerShell.sum_uSh_eq`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-sum_uSh_eq) | theorem | shape | `WeilPowerShell` | ∑ h ∈ Finset.Ico a b, coef e' D e * Complex.exp (zOf e' D e * ((WeilPowerGeomGen.uLam lam h : ℝ) : ℂ)) = ∑ h ∈ Finset.Ico a b, coef e' D e * Complex.exp (zOf e' D e * ((uSh lam h : ℝ) : ℂ)) |
| [`WeilPowerPhase.summable_hterm`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-summable_hterm) | theorem | shape | `WeilPowerPhase` | Summable hterm |
| [`AttainedPi.summable_line`](./lean_stage3/AttainedPi.md#AttainedPi-summable_line) | theorem | reads ζ | `AttainedPi` | Summable ((lineSet Θ).indicator fun ρ =&gt; ‖LadderMean.coef ρ‖) |
| [`ZeroSummable.summable_norm_coef`](./lean_stage3/ZeroSummable.md#ZeroSummable-summable_norm_coef) | theorem | reads ζ | `ZeroSummable` | Summable fun ρ : S =&gt; ‖LadderMean.coef ρ‖ |
| [`WeilOnLine.summable_onLine`](./lean_stage3/WeilOnLine.md#WeilOnLine-summable_onLine) | theorem | reads ζ | `WeilOnLine` | Summable (fun ρ : OnLine =&gt; weightedTerm h γ ρ.1) |
| [`WeilPowerOnLine.summable_onLine`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-summable_onLine) | theorem | reads ζ | `WeilPowerOnLine` | Summable (fun ρ : OnLine =&gt; weightedTermW h γ m ρ.1) |
| [`ZeroSummable.summable_order_div`](./lean_stage3/ZeroSummable.md#ZeroSummable-summable_order_div) | theorem | reads ζ | `ZeroSummable` | Summable fun ρ : {ρ : Kadiri.NontrivialZeros // σ ≤ ((ρ : Kadiri.NontrivialZeros) : ℂ).re} =&gt; ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℝ) / ‖((ρ : Kadiri.NontrivialZeros) : ℂ)‖ |
| [`FilterAttained.summable_S`](./lean_stage3/FilterAttained.md#FilterAttained-summable_S) | theorem | reads ζ | `FilterAttained` | Summable ((S σ).indicator fun ρ =&gt; ‖LadderMean.coef ρ‖) |
| [`ZeroSummable.summable_shell`](./lean_stage3/ZeroSummable.md#ZeroSummable-summable_shell) | theorem | shape | `ZeroSummable` | Summable fun j : ℕ =&gt; K * (((j : ℝ) + 1) * r ^ j) |
| [`WeilPowerPhase.summable_shift`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-summable_shift) | theorem | shape | `WeilPowerPhase` | Summable (fun k : ℕ =&gt; hterm (k + (m + 1))) |
| [`WeilSeries.summable_shift2`](./lean_stage3/WeilSeries.md#WeilSeries-summable_shift2) | theorem | shape | `WeilSeries` | Summable (fun k : ℕ =&gt; 1 / ((k : ℝ) + 1) ^ 2) |
| [`WeilSeries.summable_shift3`](./lean_stage3/WeilSeries.md#WeilSeries-summable_shift3) | theorem | shape | `WeilSeries` | Summable (fun k : ℕ =&gt; 1 / ((k : ℝ) + 1) ^ 3) |
| [`Elephant.summatory_sym`](./lean/Elephant.md#Elephant-summatory_sym) | theorem | shape | `Elephant` | ∑ m ∈ Finset.range (x + 1), (a m - (if b ∣ m then a (m / b) else 0)) = (∑ m ∈ Finset.range (x + 1), a m) - ∑ k ∈ Finset.range (x / b + 1), a k |
| [`Chain.Sym`](./lean/Chain.md#Chain-Sym) | def | shape | `Chain` | ℂ |
| [`Elephant.Sym`](./lean/Elephant.md#Elephant-Sym) | def | shape | `Elephant` | ℂ |
| [`EulerFactorChain.sym`](./lean/EulerFactorChain.md#EulerFactorChain-sym) | def | shape | `EulerFactorChain` | ℂ |
| [`AliasClass.sym_eq_of_alias`](./lean_stage3/AliasClass.md#AliasClass-sym_eq_of_alias) | theorem | shape | `AliasClass` | Chain.Sym 2 ρ = Chain.Sym 2 ρ' |
| [`Chain.sym_eq_zero_iff`](./lean/Chain.md#Chain-sym_eq_zero_iff) | theorem | shape | `Chain` | Sym b s = 0 ↔ ∃ k : ℤ, s = (k : ℂ) * (2 * Real.pi * I / Real.log b) |
| [`Elephant.sym_eq_zero_iff`](./lean/Elephant.md#Elephant-sym_eq_zero_iff) | theorem | shape | `Elephant` | Sym b s = 0 ↔ ∃ k : ℤ, s = (k : ℂ) * (2 * Real.pi * Complex.I / Real.log b) |
| [`TransferOp.sym_hasEigenvalue`](./lean/TransferOp.md#TransferOp-sym_hasEigenvalue) | theorem | shape | `TransferOp` | bdiffL.HasEigenvalue (Sym b ρ) |
| [`Elephant.sym_mul_logDeriv_zeta`](./lean/Elephant.md#Elephant-sym_mul_logDeriv_zeta) | theorem | reads ζ | `Elephant` | Sym (b : ℝ) s * (-deriv riemannZeta s / riemannZeta s) = LSeries (fun n =&gt; (vonMangoldt n : ℂ)) s - LSeries (fun m =&gt; if b ∣ m then (vonMangoldt (m / b) : ℂ) else 0) s |
| [`Elephant.sym_mul_lseries`](./lean/Elephant.md#Elephant-sym_mul_lseries) | theorem | reads ζ | `Elephant` | Sym ((b : ℕ) : ℝ) s * LSeries a s = LSeries a s - LSeries (fun m =&gt; if b ∣ m then a (m / b) else 0) s |
| [`EulerFactorChain.sym_natCast`](./lean/EulerFactorChain.md#EulerFactorChain-sym_natCast) | theorem | shape | `EulerFactorChain` | sym (n : ℝ) s = 1 - (n : ℂ) ^ (-s) |
| [`Elephant.sym_ne_zero_on_critical_line`](./lean/Elephant.md#Elephant-sym_ne_zero_on_critical_line) | theorem | shape | `Elephant` | Sym b ((1 : ℂ)/2 + γ * Complex.I) ≠ 0 |
| [`NyquistPeak.sym_on_imaginary_axis`](./lean/NyquistPeak.md#NyquistPeak-sym_on_imaginary_axis) | theorem | shape | `NyquistPeak` | Chain.Sym b (γ * Complex.I) = 1 - Complex.exp (((-(γ * Real.log b) : ℝ) : ℂ) * Complex.I) |
| [`Chain.sym_periodic`](./lean/Chain.md#Chain-sym_periodic) | theorem | shape | `Chain` | Sym b (s + 2 * Real.pi * I / Real.log b) = Sym b s |
| [`Elephant.sym_pow_expand`](./lean/Elephant.md#Elephant-sym_pow_expand) | theorem | shape | `Elephant` | (Sym b ρ) ^ d = ∑ k ∈ Finset.range (d + 1), (-1 : ℂ) ^ k * (d.choose k : ℂ) * ((b : ℂ) ^ (-ρ)) ^ k |
| [`Elephant.sym_tprod_eq_zeta`](./lean/Elephant.md#Elephant-sym_tprod_eq_zeta) | theorem | reads ζ | `Elephant` | ∏' p : Nat.Primes, (Sym ((p : ℕ) : ℝ) s)⁻¹ = riemannZeta s |
| [`CellModes.sym_two`](./lean_stage3/CellModes.md#CellModes-sym_two) | theorem | shape | `CellModes` | Chain.Sym 2 ρ = 1 - ((2:ℂ) ^ ρ)⁻¹ |
| [`Transform.sym_zero_on_outer_circle`](./lean/Transform.md#Transform-sym_zero_on_outer_circle) | theorem | shape | `Transform` | ‖(b : ℂ) ^ (-s)‖ = 1 |
| [`Transform.sym_zero_partner_on_inner_circle`](./lean/Transform.md#Transform-sym_zero_partner_on_inner_circle) | theorem | shape | `Transform` | ‖(b : ℂ) ^ (-(1 - s))‖ = b ^ (-(1 : ℝ)) |
| [`EulerFactorChain.symbol_at_one`](./lean/EulerFactorChain.md#EulerFactorChain-symbol_at_one) | theorem | shape | `EulerFactorChain` | (b : ℂ) ^ (r * 1) - (b : ℂ) ^ ((r - 1) * 1) = sym b 1 * (b : ℂ) ^ (r * 1) |
| [`EulerFactorChain.symbol_of_backward_difference`](./lean/EulerFactorChain.md#EulerFactorChain-symbol_of_backward_difference) | theorem | shape | `EulerFactorChain` | (b : ℂ) ^ (r * ρ) - (b : ℂ) ^ ((r - 1) * ρ) = sym b ρ * (b : ℂ) ^ (r * ρ) |
| [`Elephant.symbol_of_difference`](./lean/Elephant.md#Elephant-symbol_of_difference) | theorem | shape | `Elephant` | (b : ℂ) ^ (r * ρ) - (b : ℂ) ^ ((r - 1) * ρ) = Sym b ρ * (b : ℂ) ^ (r * ρ) |
| [`JointSymbol.symPhi_principal_part`](./lean_stage3/JointSymbol.md#JointSymbol-symPhi_principal_part) | theorem | reads ζ | `JointSymbol` | ∃ h : ℂ → ℂ, AnalyticAt ℂ h ρ ∧ ∀ᶠ s in 𝓝[≠] ρ, (1 - (2 : ℂ) ^ (-s)) ^ d * LandauMellinG.Phi s = h s + (1 - (2 : ℂ) ^ (-ρ)) ^ d * ((analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ))) / (s - ρ) |
| [`Expansion.t`](./lean/Expansion.md#Expansion-t) | def | shape | `Expansion` | ℝ |
| [`WeilPowerGauss.T`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-T) | def | shape | `WeilPowerGauss` | ℂ |
| [`WeilPowerPhase.T_eq_exp`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-T_eq_exp) | theorem | shape | `WeilPowerPhase` | T m w n = Complex.exp (∑ j ∈ Finset.Ico (m + 1) n, Complex.log (g w j)) |
| [`WeilPowerPhase.T_eq_mul`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-T_eq_mul) | theorem | shape | `WeilPowerPhase` | T m w n = Complex.exp (w ^ 2 * ((sigmaN m n : ℝ) : ℂ)) * Complex.exp (delta m w n) |
| [`Expansion.t_halves`](./lean/Expansion.md#Expansion-t_halves) | theorem | shape | `Expansion` | t d (j + 1) x ≤ t d j x / 2 |
| [`Expansion.t_nonneg`](./lean/Expansion.md#Expansion-t_nonneg) | theorem | shape | `Expansion` | 0 ≤ t d j x |
| [`WeilPowerGauss.T_ofReal`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-T_ofReal) | theorem | shape | `WeilPowerGauss` | T m (s : ℂ) n = ((Tr m s n : ℝ) : ℂ) |
| [`Expansion.t_zero`](./lean/Expansion.md#Expansion-t_zero) | theorem | shape | `Expansion` | t d 0 x = Real.log 2 ^ d * x⁻¹ |
| [`CellResidual.table_cell_eq`](./lean_stage3/CellResidual.md#CellResidual-table_cell_eq) | theorem | shape | `CellResidual` | ((Construction.tableFrom TableRoute.rowN r d : ℤ) : ℝ) - stencilR (d + 1) (fun m : ℤ =&gt; Stage3.Li ((2 : ℝ) ^ (m : ℝ))) r = cellResid 1 r d |
| [`PiZeros.table_cell_eq_zero_sum`](./lean_stage3/PiZeros.md#PiZeros-table_cell_eq_zero_sum) | theorem | reads ζ | `PiZeros` | ((((Construction.tableFrom TableRoute.rowN r d : ℤ) : ℝ) - Nonvanishing.stencilR (d + 1) (fun m : ℤ =&gt; Stage3.Li ((2 : ℝ) ^ (m : ℝ))) r : ℝ) : ℂ) = -∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) *… |
| [`PiFixedRow.table_cell_fixed_row`](./lean_stage3/PiFixedRow.md#PiFixedRow-table_cell_fixed_row) | theorem | reads ζ | `PiFixedRow` | ∀ ε : ℝ, 0 &lt; ε → ∀ᶠ T : ℝ in Filter.atTop, ‖((((Construction.tableFrom TableRoute.rowN (r : ℤ) d : ℤ) : ℝ) - Nonvanishing.stencilR (d + 1) (fun m : ℤ =&gt; Stage3.Li ((2 : ℝ) ^ (m : ℝ))) (r : ℤ) : ℝ) : ℂ… |
| [`FixedRowTwo.table_cell_fixed_row_two`](./lean_stage3/FixedRowTwo.md#FixedRowTwo-table_cell_fixed_row_two) | theorem | reads ζ | `FixedRowTwo` | ∀ ε : ℝ, 0 &lt; ε → ∀ᶠ T : ℝ in Filter.atTop, ‖((((Construction.tableFrom TableRoute.rowN (r : ℤ) d : ℤ) : ℝ) - Nonvanishing.stencilR (d + 1) (fun m : ℤ =&gt; Stage3.Li ((2 : ℝ) ^ (m : ℝ))) (r : ℤ) : ℝ) : ℂ… |
| [`CellResidual.table_cell_resid`](./lean_stage3/CellResidual.md#CellResidual-table_cell_resid) | theorem | reads ζ | `CellResidual` | ∃ (C : ℝ) (r₀ : ℤ), ∀ (d : ℕ) (r : ℤ), r₀ + ((d + 1 : ℕ) : ℤ) ≤ r → \|((Construction.tableFrom TableRoute.rowN r d : ℤ) : ℝ) - stencilR (d + 1) (fun m : ℤ =&gt; Stage3.Li ((2 : ℝ) ^ (m : ℝ))) r\| ≤ C * cel… |
| [`Construction.tableFrom`](./lean/Construction.md#Construction-tableFrom) | def | counting | `Construction` | ℤ → ℕ → ℤ |
| [`Construction.tableFrom_add`](./lean/Construction.md#Construction-tableFrom_add) | theorem | counting | `Construction` | tableFrom (fun x =&gt; N x + M x) r d = tableFrom N r d + tableFrom M r d |
| [`PairIdentity.tableFrom_add_window`](./lean/PairIdentity.md#PairIdentity-tableFrom_add_window) | theorem | counting | `PairIdentity` | tableFrom P r d + tableFrom C r d = tableFrom T r d |
| [`SeedPerturbation.tableFrom_at_boundary`](./lean/SeedPerturbation.md#SeedPerturbation-tableFrom_at_boundary) | theorem | counting | `SeedPerturbation` | tableFrom e r d = (-1) ^ d * e R |
| [`CellResidual.tableFrom_cast`](./lean_stage3/CellResidual.md#CellResidual-tableFrom_cast) | theorem | shape | `CellResidual` | ((Construction.tableFrom N r d : ℤ) : ℝ) = stencilR (d + 1) f r |
| [`Chain.tableFrom_eq_bdiff_iter`](./lean/Chain.md#Chain-tableFrom_eq_bdiff_iter) | theorem | shape | `Chain` | ((Construction.tableFrom N r d : ℤ) : ℂ) = (bdiff^[d]) g (r : ℂ) |
| [`Zeros.tableFrom_eq_fwdDiff`](./lean/ZerosStencil.md#Zeros-tableFrom_eq_fwdDiff) | theorem | counting | `ZerosStencil` | Construction.tableFrom N r d = (-1 : ℤ) ^ d * (fwdDiff (-1 : ℤ))^[d] N r |
| [`Superposition.tableFrom_eq_modeSum_reweighted`](./lean/Superposition.md#Superposition-tableFrom_eq_modeSum_reweighted) | theorem | shape | `Superposition` | ((Construction.tableFrom N r d : ℤ) : ℂ) = modeSum b ρ (fun i =&gt; c i * (Sym b (ρ i)) ^ d) s (r : ℂ) |
| [`Zeros.tableFrom_eq_stencil`](./lean/ZerosStencil.md#Zeros-tableFrom_eq_stencil) | theorem | counting | `ZerosStencil` | Construction.tableFrom N r d = stencil d (fun k =&gt; N (r - k)) |
| [`Zeros.tableFrom_eq_zero_iff_wings`](./lean/ZerosStencil.md#Zeros-tableFrom_eq_zero_iff_wings) | theorem | counting | `ZerosStencil` | Construction.tableFrom N r d = 0 ↔ wingPlus d (fun k =&gt; N (r - k)) = wingMinus d (fun k =&gt; N (r - k)) |
| [`SeedPerturbation.tableFrom_eq_zero_of_vanishing_above`](./lean/SeedPerturbation.md#SeedPerturbation-tableFrom_eq_zero_of_vanishing_above) | theorem | counting | `SeedPerturbation` | tableFrom e r d = 0 |
| [`Zeros.tableFrom_isTable`](./lean/Zeros.md#Zeros-tableFrom_isTable) | theorem | counting | `Zeros` | IsTable (Construction.tableFrom N) |
| [`Construction.tableFrom_isTableOf`](./lean/Construction.md#Construction-tableFrom_isTableOf) | theorem | counting | `Construction` | IsTableOf N (tableFrom N) |
| [`Chain.tableFrom_mode`](./lean/Chain.md#Chain-tableFrom_mode) | theorem | shape | `Chain` | ((Construction.tableFrom N r d : ℤ) : ℂ) = (Sym b ρ) ^ d * mode b ρ (r : ℂ) |
| [`Nonvanishing.tableFrom_ne_zero_of`](./lean/Nonvanishing.md#Nonvanishing-tableFrom_ne_zero_of) | theorem | shape | `Nonvanishing` | Construction.tableFrom N r d ≠ 0 |
| [`MainTerm.tableFrom_ne_zero_of_deriv`](./lean/MainTerm.md#MainTerm-tableFrom_ne_zero_of_deriv) | theorem | shape | `MainTerm` | Construction.tableFrom N r d ≠ 0 |
| [`Expansion.tableFrom_ne_zero_of_li`](./lean/Expansion.md#Expansion-tableFrom_ne_zero_of_li) | theorem | shape | `Expansion` | Construction.tableFrom N r d ≠ 0 |
| [`RelativeLi.tableFrom_ne_zero_of_powerSaving`](./lean/RelativeLi.md#RelativeLi-tableFrom_ne_zero_of_powerSaving) | theorem | shape | `RelativeLi` | Construction.tableFrom N r d ≠ 0 |
| [`RelativeGate.tableFrom_ne_zero_of_relErr`](./lean/RelativeGate.md#RelativeGate-tableFrom_ne_zero_of_relErr) | theorem | shape | `RelativeGate` | Construction.tableFrom N r d ≠ 0 |
| [`RelativeLi.tableFrom_ne_zero_of_relErr_li`](./lean/RelativeLi.md#RelativeLi-tableFrom_ne_zero_of_relErr_li) | theorem | shape | `RelativeLi` | Construction.tableFrom N r d ≠ 0 |
| [`RelativeLi.tableFrom_ne_zero_of_relErr_li'`](./lean/RelativeLi.md#RelativeLi-tableFrom_ne_zero_of_relErr_li-) | theorem | shape | `RelativeLi` | Construction.tableFrom N r d ≠ 0 |
| [`Interpolant.tableFrom_ne_zero_of_relErr_liRow`](./lean/Interpolant.md#Interpolant-tableFrom_ne_zero_of_relErr_liRow) | theorem | shape | `Interpolant` | Construction.tableFrom N r d ≠ 0 |
| [`Schoenfeld.tableFrom_ne_zero_of_schoenfeld`](./lean/Schoenfeld.md#Schoenfeld-tableFrom_ne_zero_of_schoenfeld) | theorem | shape | `Schoenfeld` | Construction.tableFrom N r d ≠ 0 |
| [`Chain.tableFrom_norm_on_critical_line`](./lean/Chain.md#Chain-tableFrom_norm_on_critical_line) | theorem | shape | `Chain` | ‖((Construction.tableFrom N r d : ℤ) : ℂ)‖ = ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ d * ‖mode b ((1 : ℂ)/2 + γ * I) (r : ℂ)‖ |
| [`PairIdentity.tableFrom_of_geometric`](./lean/PairIdentity.md#PairIdentity-tableFrom_of_geometric) | theorem | counting | `PairIdentity` | tableFrom G r d = (b - 1) ^ d * G (r - d) |
| [`Construction.tableFrom_smul`](./lean/Construction.md#Construction-tableFrom_smul) | theorem | counting | `Construction` | tableFrom (fun x =&gt; c * N x) r d = c * tableFrom N r d |
| [`SeedPerturbation.tableFrom_sub`](./lean/SeedPerturbation.md#SeedPerturbation-tableFrom_sub) | theorem | counting | `SeedPerturbation` | tableFrom (fun x =&gt; N x - e x) r d = tableFrom N r d - tableFrom e r d |
| [`SeedPerturbation.tableFrom_zero`](./lean/SeedPerturbation.md#SeedPerturbation-tableFrom_zero) | theorem | counting | `SeedPerturbation` | tableFrom (fun _ : ℤ =&gt; (0 : ℤ)) r d = 0 |
| [`ZetaGrowth.tail_differentiableAt`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-tail_differentiableAt) | theorem | shape | `ZetaGrowth` | DifferentiableAt ℂ (fun w : ℂ ↦ ∫ x in Ioi (N:ℝ), (emA x : ℂ) * (x:ℂ) ^ (-(w+2))) z |
| [`ZetaEM.tail_ibp`](./lean_stage3/ZetaEM.md#ZetaEM-tail_ibp) | theorem | reads ζ | `ZetaEM` | ((k:ℂ) + 1) * ∫ x in Ioi a, ((bernoulliFun k (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ (-(s + k)) = -(((bernoulliFun (k+1) (Int.fract a) : ℝ) : ℂ) * (a:ℂ) ^ (-(s + k))) + (s + k) * ∫ x in Ioi a, ((bernoulliFu… |
| [`ZetaGrowth.tail_ibp`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-tail_ibp) | theorem | reads ζ | `ZetaGrowth` | ∫ x in Ioi (N:ℝ), ((⌊x⌋ : ℂ) + 1/2 - (x:ℂ)) * (x:ℂ) ^ (-(s+1)) = (s+1) * ∫ x in Ioi (N:ℝ), (emA x : ℂ) * (x:ℂ) ^ (-(s+2)) |
| [`ZetaGrowth.tail_norm_le`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-tail_norm_le) | theorem | shape | `ZetaGrowth` | ‖∫ x in Ioi (N:ℝ), (emA x : ℂ) * (x:ℂ) ^ (-(s+2))‖ ≤ (1/4) * (N:ℝ) ^ (-s.re - 1) |
| [`FilterAttained.tailT`](./lean_stage3/FilterAttained.md#FilterAttained-tailT) | def | reads ζ | `FilterAttained` | ℂ |
| [`AttainedPi.tailTerm`](./lean_stage3/AttainedPi.md#AttainedPi-tailTerm) | def | reads ζ | `AttainedPi` | ℂ |
| [`LeftSmooth.tan_piece`](./lean_stage3/LeftSmooth.md#LeftSmooth-tan_piece) | theorem | shape | `LeftSmooth` | ‖∫ t in (-T)..T, ((y:ℂ) ^ ((t:ℂ) * Complex.I)) * tanPiece t‖ ≤ (8 + 2 * Real.pi ^ 2 + 4 * Real.pi) / (kc * Real.log y) |
| [`LeftSmooth.tanPiece`](./lean_stage3/LeftSmooth.md#LeftSmooth-tanPiece) | def | shape | `LeftSmooth` | ℂ |
| [`LeftSmooth.tanPiece'`](./lean_stage3/LeftSmooth.md#LeftSmooth-tanPiece-) | def | shape | `LeftSmooth` | ℂ |
| [`WeilPowerSelect.target_bound`](./lean_stage3/WeilPowerSelect.md#WeilPowerSelect-target_bound) | theorem | shape | `WeilPowerSelect` | ∃ k : ℕ, (k : ℝ) ≤ h / (4 * K' * Real.pi ^ 2 * lam) ∧ ∀ ε', 0 ≤ ε' → ε' ≤ E (k + 1) → ε' ^ 2 ≤ (E k) ^ 2 + δSel K' lam h |
| [`WeilPowerSelect.target_ge_box`](./lean_stage3/WeilPowerSelect.md#WeilPowerSelect-target_ge_box) | theorem | shape | `WeilPowerSelect` | E 0 ≤ E k |
| [`WeilPowerSelect.target_height_le`](./lean_stage3/WeilPowerSelect.md#WeilPowerSelect-target_height_le) | theorem | shape | `WeilPowerSelect` | T + (k : ℝ) / 2 ≤ T + h / (8 * K' * Real.pi ^ 2 * lam) |
| [`WeilPowerAssembly.target_lower`](./lean_stage3/WeilPowerAssembly.md#WeilPowerAssembly-target_lower) | theorem | reads ζ | `WeilPowerAssembly` | WeilPowerBands.termW h γ m (ρ : ℂ) ≤ -((h / 2) ^ 2 * ((cS m / D m) ^ 2 * Real.exp (2 * ((wm h γ (ρ : ℂ)) ^ 2).re * sigma m) * (((wm h γ (ρ : ℂ)) ^ 2).re * Real.cos (2 * ((wm h γ (ρ : ℂ)) ^ 2).im * sig… |
| [`Transform.tau`](./lean/Transform.md#Transform-tau) | def | shape | `Transform` | ℝ |
| [`Transform.tau_pos`](./lean/Transform.md#Transform-tau_pos) | theorem | shape | `Transform` | 0 &lt; tau b |
| [`Transform.tau_pow`](./lean/Transform.md#Transform-tau_pow) | theorem | shape | `Transform` | tau (b ^ n) = tau b / n |
| [`Transform.tau_ratio_of_meet`](./lean/Transform.md#Transform-tau_ratio_of_meet) | theorem | shape | `Transform` | tau b / tau c = n / m |
| [`Mollified.tauBelow`](./lean_stage3/Mollified.md#Mollified-tauBelow) | def | counting | `Mollified` | ℕ |
| [`Mollified.tauBelow_sq_le`](./lean_stage3/Mollified.md#Mollified-tauBelow_sq_le) | theorem | counting | `Mollified` | tauBelow X n ^ 2 ≤ ((triples X).filter (fun t =&gt; t.1 * t.2.1 * t.2.2 ∣ n)).card |
| [`Transform.tauI_mem_periodLattice`](./lean/Transform.md#Transform-tauI_mem_periodLattice) | theorem | shape | `Transform` | ((tau b : ℂ) * I) ∈ periodLattice b |
| [`LandauPoleSub.taylor_coeff_sub_poles`](./lean_stage3/LandauPoleSub.md#LandauPoleSub-taylor_coeff_sub_poles) | theorem | shape | `LandauPoleSub` | ∃ C : ℝ, ∀ k : ℕ, ‖iteratedDeriv k f c - ∑ q ∈ P, A q * ((-1) ^ k * (k.factorial : ℂ) * (c - q) ^ (-1 - (k : ℤ)))‖ ≤ k.factorial * C / R ^ k |
| [`Isogeny.telescope`](./lean/Isogeny.md#Isogeny-telescope) | theorem | counting | `Isogeny` | ∑ j ∈ range k, (g (m + j + 1) - g (m + j)) = g (m + k) - g m |
| [`FilterAttained.tendsto_full`](./lean_stage3/FilterAttained.md#FilterAttained-tendsto_full) | theorem | reads ζ | `FilterAttained` | Tendsto (fun k : ℕ =&gt; ∑' ρ, (S σ).indicator (fun ρ =&gt; LadderMean.coef ρ * ratio q a b M ρ ^ k) ρ) atTop (𝓝 0) |
| [`LandauKernel.tendsto_log_pow_mul`](./lean_stage3/LandauKernel.md#LandauKernel-tendsto_log_pow_mul) | theorem | shape | `LandauKernel` | Tendsto (fun y : ℝ =&gt; Real.log y ^ n * y ^ (-a)) atTop (𝓝 0) |
| [`CellFixedRow.tendsto_log_sq_div`](./lean_stage3/CellFixedRow.md#CellFixedRow-tendsto_log_sq_div) | theorem | shape | `CellFixedRow` | Tendsto (fun T : ℝ =&gt; a * c * Real.log (c * T) ^ 2 / T) atTop (𝓝 0) |
| [`LandauMellinG.tendsto_logPrim`](./lean_stage3/LandauMellinG.md#LandauMellinG-tendsto_logPrim) | theorem | shape | `LandauMellinG` | Tendsto (logPrim s) atTop (𝓝 0) |
| [`WeilPowerGauss.tendsto_S`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-tendsto_S) | theorem | shape | `WeilPowerGauss` | Tendsto (fun n : ℕ =&gt; ((cS m / D m : ℝ) : ℂ) * w * T m w n) atTop (𝓝 (S m w)) |
| [`AttainedPi.tendsto_tail`](./lean_stage3/AttainedPi.md#AttainedPi-tendsto_tail) | theorem | reads ζ | `AttainedPi` | Tendsto (fun r : ℕ =&gt; ∑' ρ, tailTerm Θ r ρ) atTop (𝓝 0) |
| [`FilterAttained.tendsto_tailT`](./lean_stage3/FilterAttained.md#FilterAttained-tendsto_tailT) | theorem | reads ζ | `FilterAttained` | Tendsto (fun k : ℕ =&gt; ∑' ρ, tailT q a b σ M k ρ) atTop (𝓝 0) |
| [`AttainedPi.term`](./lean_stage3/AttainedPi.md#AttainedPi-term) | def | reads ζ | `AttainedPi` | ℂ |
| [`FiniteOffLine.term`](./lean_stage3/FiniteOffLine.md#FiniteOffLine-term) | def | reads ζ | `FiniteOffLine` | ℂ |
| [`ZeroDensity.term1_le`](./lean_stage3/ZeroDensity.md#ZeroDensity-term1_le) | theorem | shape | `ZeroDensity` | T * (2 / (1 - (2:ℝ) ^ (1 - 2 * u))) * (X:ℝ) ^ (1 - 2 * u) * (1 + Real.log X) ^ 3 ≤ T * (2 / (1 - (2:ℝ) ^ (-(6 * δ)))) * T ^ (-(6 * δ ^ 2)) * L ^ 3 |
| [`ZeroDensity.term2_le`](./lean_stage3/ZeroDensity.md#ZeroDensity-term2_le) | theorem | shape | `ZeroDensity` | 24 * (1 + Real.log ((N * X : ℕ) : ℝ)) ^ 2 * (1 + Real.log X) ^ 3 * max 1 (((N * X : ℕ) : ℝ) ^ (2 - 2 * u)) ≤ 24 * (4 * L) ^ 2 * (2 * L) ^ 3 * (4 * T ^ (1 - 4 * δ)) |
| [`ZeroDensity.term3_le`](./lean_stage3/ZeroDensity.md#ZeroDensity-term3_le) | theorem | shape | `ZeroDensity` | (X:ℝ) ^ 2 * (N:ℝ) ^ (2 - 2 * u) ≤ 8 * T ^ (1 - 3 * δ) |
| [`ZeroDensity.term4_le`](./lean_stage3/ZeroDensity.md#ZeroDensity-term4_le) | theorem | shape | `ZeroDensity` | T * (X:ℝ) ^ 2 * E ^ 2 * (N:ℝ) ^ (-2 * u) * (1 + (T + 2 + k) ^ k * (N:ℝ) ^ (1 - (k:ℝ))) ^ 2 ≤ 4 * E ^ 2 * (1 + 2 ^ k) ^ 2 * T ^ δ |
| [`WeilOnLine.term_conj`](./lean_stage3/WeilOnLine.md#WeilOnLine-term_conj) | theorem | shape | `WeilOnLine` | (laplace (phiC h γ) (-(starRingEnd ℂ) ρ) * laplace (phiC h γ) (-(1 - (starRingEnd ℂ) ρ))).re = (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re |
| [`WeilPowerOnLine.term_conj`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-term_conj) | theorem | shape | `WeilPowerOnLine` | termW h γ m ((starRingEnd ℂ) ρ) = termW h γ m ρ |
| [`WeilOffLine.term_eq_neg_sq`](./lean_stage3/WeilOffLine.md#WeilOffLine-term_eq_neg_sq) | theorem | shape | `WeilOffLine` | laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ)) = -(ghat h γ (ρ - 1 / 2)) ^ 2 |
| [`WeilPowerBackground.term_eq_neg_sq`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-term_eq_neg_sq) | theorem | shape | `WeilPowerBackground` | laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ)) = -(what h γ m (ρ - 1 / 2)) ^ 2 |
| [`WeilPowerBridge.term_eq_sidebands`](./lean_stage3/WeilPowerBridge.md#WeilPowerBridge-term_eq_sidebands) | theorem | shape | `WeilPowerBridge` | WeilPowerBands.termW h γ m ρ = -((h / 2) ^ 2 * (((S m (wm h γ ρ)) ^ 2).re + 2 * (S m (wp h γ ρ) * S m (wm h γ ρ)).re + ((S m (wp h γ ρ)) ^ 2).re)) |
| [`WeilPowerBridge.term_le_at_zero`](./lean_stage3/WeilPowerBridge.md#WeilPowerBridge-term_le_at_zero) | theorem | reads ζ | `WeilPowerBridge` | WeilPowerBands.termW h γ m (ρ : ℂ) ≤ -((h / 2) ^ 2 * ((cS m / D m) ^ 2 * Real.exp (2 * ((wm h γ (ρ : ℂ)) ^ 2).re * sigma m) * (((wm h γ (ρ : ℂ)) ^ 2).re * Real.cos (2 * ((wm h γ (ρ : ℂ)) ^ 2).im * sig… |
| [`WeilPowerBands.term_le_M`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-term_le_M) | theorem | reads ζ | `WeilPowerBands` | termW h γ m ρ ≤ M h γ m (idx (ρ : ℂ).im) |
| [`WeilSeries.term_le_M`](./lean_stage3/WeilSeries.md#WeilSeries-term_le_M) | theorem | reads ζ | `WeilSeries` | (laplace (phiC h γ) (-(ρ : ℂ)) * laplace (phiC h γ) (-(1 - (ρ : ℂ)))).re ≤ M h γ (idx (ρ : ℂ).im) |
| [`WeilPowerBridge.term_le_sidebands`](./lean_stage3/WeilPowerBridge.md#WeilPowerBridge-term_le_sidebands) | theorem | shape | `WeilPowerBridge` | WeilPowerBands.termW h γ m ρ ≤ -((h / 2) ^ 2 * (((S m (wm h γ ρ)) ^ 2).re - 2 * ‖S m (wp h γ ρ)‖ * ‖S m (wm h γ ρ)‖ - ‖S m (wp h γ ρ)‖ ^ 2)) |
| [`WeilPowerNear.term_nonneg`](./lean_stage3/WeilPowerNear.md#WeilPowerNear-term_nonneg) | theorem | shape | `WeilPowerNear` | 0 ≤ (WeilPowerShell.coef e' D e * Complex.exp (WeilPowerShell.zOf e' D e * ((WeilPowerGeomGen.uLam lam h : ℝ) : ℂ))).re |
| [`WeilOffLine.term_re_eq`](./lean_stage3/WeilOffLine.md#WeilOffLine-term_re_eq) | theorem | shape | `WeilOffLine` | (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re = (ghat h γ (ρ - 1 / 2)).im ^ 2 - (ghat h γ (ρ - 1 / 2)).re ^ 2 |
| [`WeilPowerBackground.term_re_eq`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-term_re_eq) | theorem | shape | `WeilPowerBackground` | (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re = (what h γ m (ρ - 1 / 2)).im ^ 2 - (what h γ m (ρ - 1 / 2)).re ^ 2 |
| [`WeilPowerBands.termW`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-termW) | def | shape | `WeilPowerBands` | ℝ |
| [`WeilPowerBands.termW_nonneg`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-termW_nonneg) | theorem | shape | `WeilPowerBands` | 0 ≤ termW h γ m ρ |
| [`Stage3.theta_err_of_psi`](./lean_stage3/PsiToPi.md#Stage3-theta_err_of_psi) | theorem | shape | `PsiToPi` | \|θ x - x\| ≤ E + 2 * Real.sqrt x * Real.log x |
| [`Stage3.theta_err_of_psi_theta`](./lean_stage3/ThetaPi.md#Stage3-theta_err_of_psi_theta) | theorem | shape | `ThetaPi` | \|ϑ x - x\| ≤ E + 2 * x ^ θ * Real.log x |
| [`Stage3.theta_instantiation_arithmetic`](./lean_stage3/ThetaPsi.md#Stage3-theta_instantiation_arithmetic) | theorem | shape | `ThetaPsi` | c * (X ^ (1 - θ))⁻¹ * X * Real.log X ≤ c * X ^ θ * (Real.log X) ^ 3 ∧ c * X * Real.log X / ((X ^ (1 - θ))⁻¹ * X) ≤ c * X ^ θ * (Real.log X) ^ 3 ∧ c * ((X ^ (1 - θ))⁻¹ * X) ≤ c * X ^ θ * (Real.log X) ^… |
| [`PiToPsi.theta_sub_id_eq`](./lean_stage3/PiToPsi.md#PiToPsi-theta_sub_id_eq) | theorem | shape | `PiToPsi` | θ x - x = ((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x) * Real.log x - ∫ t in (2 : ℝ)..x, relRes t |
| [`JointDialGate.thetaWindow_of_global`](./lean_stage3/JointDialGate.md#JointDialGate-thetaWindow_of_global) | theorem | shape | `JointDialGate` | ∀ j ∈ range (n + 1), \|f (r - j) - L (r - j)\| ≤ C * ((2 : ℝ) ^ ((r : ℝ) - j)) ^ θ * Real.log ((2 : ℝ) ^ ((r : ℝ) - j)) ^ k |
| [`TwinLattice.three_five_exceptional`](./lean/TwinLattice.md#TwinLattice-three_five_exceptional) | theorem | counting | `TwinLattice` | (3 : ℕ).Prime ∧ (5 : ℕ).Prime ∧ (3 + 1) % 6 ≠ 0 |
| [`Bridge.tiltF`](./lean_bridge/WeilBridge.md#Bridge-tiltF) | def | shape | `WeilBridge` | ℝ → ℂ |
| [`WeilBridgeLeaf.tiltF`](./lean_stage3/WeilBridgeLeaf.md#WeilBridgeLeaf-tiltF) | def | shape | `WeilBridgeLeaf` | ℝ → ℂ |
| [`Bridge.tiltF_im`](./lean_bridge/WeilBridge.md#Bridge-tiltF_im) | theorem | shape | `WeilBridge` | (tiltF G u).im = 0 |
| [`AttainedPi.topRow`](./lean_stage3/AttainedPi.md#AttainedPi-topRow) | def | reads ζ | `AttainedPi` | Finset NontrivialZeros |
| [`Transform.Torus`](./lean/Transform.md#Transform-Torus) | abbrev | shape | `Transform` | Type |
| [`Transform.torus_period`](./lean/Transform.md#Transform-torus_period) | theorem | shape | `Transform` | ((s + (tau b : ℂ) * I : ℂ) : Torus b) = (s : Torus b) |
| [`Transform.torus_shift`](./lean/Transform.md#Transform-torus_shift) | theorem | shape | `Transform` | ((s + 1 : ℂ) : Torus b) = (s : Torus b) |
| [`PairIdentity.total_const_on_diagonal`](./lean/PairIdentity.md#PairIdentity-total_const_on_diagonal) | theorem | counting | `PairIdentity` | (∀ d₁ d₂ : ℕ, (b - 1) ^ (d₁ + 1) * b ^ e = (b - 1) ^ (d₂ + 1) * b ^ e) ↔ b = 2 |
| [`PairIdentity.total_eq_pow_iff_base_two`](./lean/PairIdentity.md#PairIdentity-total_eq_pow_iff_base_two) | theorem | counting | `PairIdentity` | (b - 1) ^ (d + 1) * b ^ e = b ^ e ↔ b = 2 |
| [`PiZeros.tr`](./lean_stage3/PiZeros.md#PiZeros-tr) | def | shape | `PiZeros` | ℂ |
| [`WeilPowerGauss.Tr`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-Tr) | def | shape | `WeilPowerGauss` | ℝ |
| [`PiZeros.tr_const_mul`](./lean_stage3/PiZeros.md#PiZeros-tr_const_mul) | theorem | shape | `PiZeros` | tr (fun t =&gt; c * f t) x = c * tr f x |
| [`PiFixedRow.tr_efRem_fixed`](./lean_stage3/PiFixedRow.md#PiFixedRow-tr_efRem_fixed) | theorem | reads ζ | `PiFixedRow` | ∀ ε : ℝ, 0 &lt; ε → ∀ᶠ T : ℝ in Filter.atTop, ‖tr (efRem T) x‖ ≤ Api * Real.log x + ε |
| [`FixedRowTwo.tr_efRem_fixed_two`](./lean_stage3/FixedRowTwo.md#FixedRowTwo-tr_efRem_fixed_two) | theorem | reads ζ | `FixedRowTwo` | ∀ ε : ℝ, 0 &lt; ε → ∀ᶠ T : ℝ in Filter.atTop, ‖PiZeros.tr (PiZeros.efRem T) x‖ ≤ Api2 * (1 + Real.log x) + ε |
| [`WeilPowerGauss.Tr_ge`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-Tr_ge) | theorem | shape | `WeilPowerGauss` | Real.exp (s ^ 2 * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2) - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ≤ Tr m s n |
| [`WeilPowerSharp.Tr_ge_sharp`](./lean_stage3/WeilPowerSharp.md#WeilPowerSharp-Tr_ge_sharp) | theorem | shape | `WeilPowerSharp` | Real.exp (s ^ 2 / Real.pi ^ 2 * (1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1)) - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ≤ Tr m s n |
| [`PiZeros.tr_sub`](./lean_stage3/PiZeros.md#PiZeros-tr_sub) | theorem | shape | `PiZeros` | tr (fun t =&gt; f t - g t) x = tr f x - tr g x |
| [`PiZeros.tr_sum`](./lean_stage3/PiZeros.md#PiZeros-tr_sum) | theorem | shape | `PiZeros` | tr (fun t =&gt; ∑ i ∈ s, f i t) x = ∑ i ∈ s, tr (f i) x |
| [`JointLadder.triadic_winds_densely_on_dyadic`](./lean/JointLadder.md#JointLadder-triadic_winds_densely_on_dyadic) | theorem | shape | `JointLadder` | DenseRange (fun k : ℤ =&gt; k • ((2 * Real.pi / Real.log 3 : ℝ) : AddCircle (2 * Real.pi / Real.log 2))) |
| [`Mollified.triples`](./lean_stage3/Mollified.md#Mollified-triples) | def | counting | `Mollified` | Finset (ℕ × ℕ × ℕ) |
| [`WeilOnLine.tsum_onLine_le`](./lean_stage3/WeilOnLine.md#WeilOnLine-tsum_onLine_le) | theorem | reads ζ | `WeilOnLine` | ∑' ρ : OnLine, weightedTerm h γ ρ.1 ≤ onLineBound h γ |
| [`WeilPowerOnLine.tsum_onLine_le`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-tsum_onLine_le) | theorem | reads ζ | `WeilPowerOnLine` | ∑' ρ : OnLine, weightedTermW h γ m ρ.1 ≤ onLineBound h γ m |
| [`WeilSeries.tsum_shift2`](./lean_stage3/WeilSeries.md#WeilSeries-tsum_shift2) | theorem | reads ζ | `WeilSeries` | ∑' k : ℕ, 1 / ((k : ℝ) + 1) ^ 2 = Real.pi ^ 2 / 6 |
| [`AttainedPi.tsum_split`](./lean_stage3/AttainedPi.md#AttainedPi-tsum_split) | theorem | reads ζ | `AttainedPi` | ∑' ρ : lineSet Θ, term Θ r ρ = (∑ ρ ∈ topRow Θ r, LadderMean.coef ρ * ((2:ℂ) ^ (ρ : ℂ)) ^ r) / ((((2:ℝ) ^ Θ : ℝ)) : ℂ) ^ r + ∑' ρ, tailTerm Θ r ρ |
| [`FilterAttained.tsum_split`](./lean_stage3/FilterAttained.md#FilterAttained-tsum_split) | theorem | reads ζ | `FilterAttained` | ∑' ρ, (S σ).indicator (fun ρ =&gt; LadderMean.coef ρ * ratio q a b M ρ ^ k) ρ = ∑ ρ ∈ (ZF ((2:ℝ) ^ (b * k))).filter (fun ρ : NontrivialZeros =&gt; σ ≤ (ρ : ℂ).re), LadderMean.coef ρ * ratio q a b M ρ ^ k + … |
| [`FiniteOffLine.tsum_sub_eq_sum`](./lean_stage3/FiniteOffLine.md#FiniteOffLine-tsum_sub_eq_sum) | theorem | reads ζ | `FiniteOffLine` | ∑' σ : {ρ : NontrivialZeros // \|(ρ : ℂ).im\| &lt; T}, f σ.1 = ∑ ρ ∈ ZF T, f ρ |
| [`WeilPowerBands.tsum_upper_le`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-tsum_upper_le) | theorem | reads ζ | `WeilPowerBands` | ∑' ρ : Upper, weightedTermW h γ m ρ.1 ≤ ∑' k : ℕ, M k * (15 * Real.log (centre k) + 73) |
| [`WeilTiles.tsum_upper_le`](./lean_stage3/WeilTiles.md#WeilTiles-tsum_upper_le) | theorem | reads ζ | `WeilTiles` | ∑' ρ : Upper, weightedTerm h γ ρ.1 ≤ ∑' k : ℕ, M k * (15 * Real.log (centre k) + 73) |
| [`WeilPowerBands.tsum_upper_le_explicit`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-tsum_upper_le_explicit) | theorem | reads ζ | `WeilPowerBands` | ∑' ρ : Upper, weightedTermW h γ m ρ.1 ≤ A h γ m * (Real.pi ^ 2 / 6) |
| [`WeilSeries.tsum_upper_le_explicit`](./lean_stage3/WeilSeries.md#WeilSeries-tsum_upper_le_explicit) | theorem | reads ζ | `WeilSeries` | ∑' ρ : Upper, weightedTerm h γ ρ.1 ≤ A h γ * (Real.pi ^ 2 / 6) |
| [`WeilPowerBands.tsum_upper_le_explicit'`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-tsum_upper_le_explicit-) | theorem | reads ζ | `WeilPowerBands` | ∑' ρ : Upper, weightedTermW h γ m ρ.1 ≤ 88 * (γ + r h m + 2) ^ 4 * (4 * h ^ 2 + cFarM m / h ^ 2) * (Real.pi ^ 2 / 6) |
| [`WeilSeries.tsum_upper_le_explicit'`](./lean_stage3/WeilSeries.md#WeilSeries-tsum_upper_le_explicit-) | theorem | reads ζ | `WeilSeries` | ∑' ρ : Upper, weightedTerm h γ ρ.1 ≤ 88 * (γ + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2) * (Real.pi ^ 2 / 6) |
| [`PerronKernel.tsum_vonMangoldt_div_cpow`](./lean_stage3/PerronKernel.md#PerronKernel-tsum_vonMangoldt_div_cpow) | theorem | reads ζ | `PerronKernel` | (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * ((x / n : ℝ) : ℂ) ^ s) = (- deriv riemannZeta s / riemannZeta s) * ((x:ℝ):ℂ) ^ s |
| [`TwinLattice.twin_lower_mod_six`](./lean/TwinLattice.md#TwinLattice-twin_lower_mod_six) | theorem | counting | `TwinLattice` | p % 6 = 5 |
| [`TwinLattice.twin_pocket`](./lean/TwinLattice.md#TwinLattice-twin_pocket) | theorem | counting | `TwinLattice` | (p + 1) % 6 = 0 |
| [`CellZeros.two_cpow_ne_zero`](./lean_stage3/CellZeros.md#CellZeros-two_cpow_ne_zero) | theorem | shape | `CellZeros` | (2:ℂ) ^ ρ ≠ 0 |
| [`WeilTiles.two_le_centre`](./lean_stage3/WeilTiles.md#WeilTiles-two_le_centre) | theorem | shape | `WeilTiles` | 2 ≤ centre k |
| [`PiRemainder.two_le_Mlow`](./lean_stage3/PiRemainder.md#PiRemainder-two_le_Mlow) | theorem | reads ζ | `PiRemainder` | 2 ≤ Mlow |
| [`WeilSeries.two_le_of_one_lt`](./lean_stage3/WeilSeries.md#WeilSeries-two_le_of_one_lt) | theorem | shape | `WeilSeries` | 2 ≤ \|(k : ℝ) - (k0 : ℝ)\| |
| [`JointLadder.two_pow_ne_three_pow`](./lean/JointLadder.md#JointLadder-two_pow_ne_three_pow) | theorem | counting | `JointLadder` | (2 : ℕ) ^ l ≠ 3 ^ k |
| [`LandauMellin.two_powers_integrableOn`](./lean_stage3/LandauMellin.md#LandauMellin-two_powers_integrableOn) | theorem | shape | `LandauMellin` | IntegrableOn (fun t : ℝ =&gt; (1 / (n : ℂ)) * (t : ℂ) ^ (-s) - (t : ℂ) ^ (-s - 1)) (Ioi (n : ℝ)) |
| [`CellResidual.two_rpow_half_ge`](./lean_stage3/CellResidual.md#CellResidual-two_rpow_half_ge) | theorem | shape | `CellResidual` | (4 : ℝ) / 3 ≤ (2 : ℝ) ^ ((1 : ℝ) / 2) |
| [`TableDepths.two_rpow_neg_nat`](./lean_stage3/TableDepths.md#TableDepths-two_rpow_neg_nat) | theorem | shape | `TableDepths` | (2:ℝ) ^ (-(n:ℝ)) = 1 / (2:ℝ) ^ n |
| [`TableDepths.two_rpow_neg_nat_half`](./lean_stage3/TableDepths.md#TableDepths-two_rpow_neg_nat_half) | theorem | shape | `TableDepths` | (2:ℝ) ^ (-(n:ℝ) + 1 / 2) ≤ 1.4143 / (2:ℝ) ^ n |
| [`WeilPowerSigma.u`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-u) | def | shape | `WeilPowerSigma` | ℝ |
| [`WeilPowerSigma.u_def`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-u_def) | theorem | shape | `WeilPowerSigma` | u m = ((m : ℝ) + 1) ^ 2 * sigma m |
| [`WeilPowerSigma.u_mono`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-u_mono) | theorem | shape | `WeilPowerSigma` | u m ≤ u (m + 1) |
| [`PiToPsi.uIcc_two_subset`](./lean_stage3/PiToPsi.md#PiToPsi-uIcc_two_subset) | theorem | shape | `PiToPsi` | uIcc (2 : ℝ) x ⊆ Ioi 1 |
| [`WeilPowerGeomGen.uLam`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-uLam) | def | shape | `WeilPowerGeomGen` | ℝ |
| [`WeilPowerGeomGen.uLam_bracket`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-uLam_bracket) | theorem | shape | `WeilPowerGeomGen` | 0 ≤ uLam lam h - ((h : ℝ) / ((lam : ℝ) * Real.pi ^ 2) - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) ∧ uLam lam h - ((h : ℝ) / ((lam : ℝ) * Real.pi ^ 2) - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) ≤ 1 / (2 * (… |
| [`WeilPowerGeomGen.uLam_eq`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-uLam_eq) | theorem | shape | `WeilPowerGeomGen` | uLam lam h = WeilPowerSigma.u (lam * h - 1) / (lam : ℝ) ^ 2 |
| [`WeilPowerNear.uLam_le`](./lean_stage3/WeilPowerNear.md#WeilPowerNear-uLam_le) | theorem | shape | `WeilPowerNear` | WeilPowerGeomGen.uLam lam h ≤ (h : ℝ) / ((lam : ℝ) * Real.pi ^ 2) |
| [`WeilPowerNear.uLam_nonneg`](./lean_stage3/WeilPowerNear.md#WeilPowerNear-uLam_nonneg) | theorem | shape | `WeilPowerNear` | 0 ≤ WeilPowerGeomGen.uLam lam h |
| [`Construction.unique_of_isTableOf`](./lean/Construction.md#Construction-unique_of_isTableOf) | theorem | counting | `Construction` | ∀ r d, f r d = tableFrom N r d |
| [`WeilTiles.Upper`](./lean_stage3/WeilTiles.md#WeilTiles-Upper) | abbrev | reads ζ | `WeilTiles` | Type |
| [`LandauTail.upper_tail_le`](./lean_stage3/LandauTail.md#LandauTail-upper_tail_le) | theorem | shape | `LandauTail` | ∫ y in Ioi Z, Real.log y ^ k * y ^ (-a - 1) ≤ Z ^ (-b) * (k.factorial / (a - b) ^ (k + 1)) |
| [`WeilPowerShell.uSh`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-uSh) | def | shape | `WeilPowerShell` | ℝ |
| [`WeilPowerShell.uSh_bracket`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-uSh_bracket) | theorem | shape | `WeilPowerShell` | ∀ k : ℕ, 0 ≤ uSh lam k - ((k : ℝ) / ((lam : ℝ) * Real.pi ^ 2) - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) ∧ uSh lam k - ((k : ℝ) / ((lam : ℝ) * Real.pi ^ 2) - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) ≤ 1 /… |
| [`ArgLegs.vertical_leg_le`](./lean_stage3/ArgLegs.md#ArgLegs-vertical_leg_le) | theorem | reads ζ | `ArgLegs` | \|(∫ t in (0:ℝ)..T, logDeriv riemannZeta (2 + (t : ℂ) * Complex.I)).re\| ≤ Real.pi / 2 |
| [`LeftKernel.vmTerm`](./lean_stage3/LeftKernel.md#LeftKernel-vmTerm) | def | counting | `LeftKernel` | ℝ |
| [`LeftKernel.vmTerm_nonneg`](./lean_stage3/LeftKernel.md#LeftKernel-vmTerm_nonneg) | theorem | shape | `LeftKernel` | 0 ≤ vmTerm n |
| [`LeftKernel.vmTerm_summable`](./lean_stage3/LeftKernel.md#LeftKernel-vmTerm_summable) | theorem | reads ζ | `LeftKernel` | Summable vmTerm |
| [`PerronKernel.vonMangoldt_rpow_partial`](./lean_stage3/PerronKernel.md#PerronKernel-vonMangoldt_rpow_partial) | theorem | shape | `PerronKernel` | ∑ n ∈ s, ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c) ≤ 2 * (Real.log 4 + 4) / (1 - (2:ℝ) ^ (1 - c)) |
| [`PerronKernel.vonMangoldt_rpow_summable`](./lean_stage3/PerronKernel.md#PerronKernel-vonMangoldt_rpow_summable) | theorem | shape | `PerronKernel` | Summable (fun n : ℕ ↦ ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c)) |
| [`PerronKernel.vonMangoldt_rpow_tsum`](./lean_stage3/PerronKernel.md#PerronKernel-vonMangoldt_rpow_tsum) | theorem | shape | `PerronKernel` | ∑' n : ℕ, ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c) ≤ 2 * (Real.log 4 + 4) / (1 - (2:ℝ) ^ (1 - c)) |
| [`Slice5.vonMangoldt_term_le`](./lean_stage3/LineBound.md#Slice5-vonMangoldt_term_le) | theorem | reads ζ | `LineBound` | ‖LSeries.term (fun k : ℕ =&gt; ((vonMangoldt k : ℝ) : ℂ)) ((1 + 2 * b : ℝ) : ℂ) n‖ ≤ (1 / b) * ((n : ℝ)) ^ (-1 - b) |
| [`PiFixedRow.w`](./lean_stage3/PiFixedRow.md#PiFixedRow-w) | def | shape | `PiFixedRow` | ℝ |
| [`WeilOddPower.W`](./lean_stage3/WeilOddPower.md#WeilOddPower-W) | def | shape | `WeilOddPower` | ℝ |
| [`ZeroSummable.w`](./lean_stage3/ZeroSummable.md#ZeroSummable-w) | def | reads ζ | `ZeroSummable` | ℝ |
| [`PiFixedRow.w_le_two`](./lean_stage3/PiFixedRow.md#PiFixedRow-w_le_two) | theorem | shape | `PiFixedRow` | w t ≤ 2 |
| [`ZeroSummable.w_nonneg`](./lean_stage3/ZeroSummable.md#ZeroSummable-w_nonneg) | theorem | reads ζ | `ZeroSummable` | 0 ≤ w ρ |
| [`PiFixedRow.w_pos`](./lean_stage3/PiFixedRow.md#PiFixedRow-w_pos) | theorem | shape | `PiFixedRow` | 0 &lt; w t |
| [`FilterLadder.Wb`](./lean_stage3/FilterLadder.md#FilterLadder-Wb) | def | counting | `FilterLadder` | ℝ |
| [`FilterLadder.Wb_eq_eval`](./lean_stage3/FilterLadder.md#FilterLadder-Wb_eq_eval) | theorem | counting | `FilterLadder` | Wb t q = (posPoly q).eval t |
| [`FilterLadder.Wb_eq_range`](./lean_stage3/FilterLadder.md#FilterLadder-Wb_eq_range) | theorem | counting | `FilterLadder` | Wb t q = ∑ j ∈ range N, ‖q.coeff j‖ * t ^ j |
| [`FilterLadder.Wb_mono`](./lean_stage3/FilterLadder.md#FilterLadder-Wb_mono) | theorem | counting | `FilterLadder` | Wb t q ≤ Wb t' q |
| [`FilterLadder.Wb_mul_le`](./lean_stage3/FilterLadder.md#FilterLadder-Wb_mul_le) | theorem | counting | `FilterLadder` | Wb t (p * q) ≤ Wb t p * Wb t q |
| [`FilterLadder.Wb_nonneg`](./lean_stage3/FilterLadder.md#FilterLadder-Wb_nonneg) | theorem | counting | `FilterLadder` | 0 ≤ Wb t q |
| [`FilterLadder.Wb_one`](./lean_stage3/FilterLadder.md#FilterLadder-Wb_one) | theorem | counting | `FilterLadder` | Wb t (1 : Polynomial ℂ) = 1 |
| [`FilterLadder.Wb_pow_le`](./lean_stage3/FilterLadder.md#FilterLadder-Wb_pow_le) | theorem | counting | `FilterLadder` | Wb t (q ^ m) ≤ Wb t q ^ m |
| [`PiFixedRow.wd`](./lean_stage3/PiFixedRow.md#PiFixedRow-wd) | def | shape | `PiFixedRow` | ℝ |
| [`Stage3.weak_anti_x₀`](./lean_stage3/Statement.md#Stage3-weak_anti_x-) | theorem | shape | `Statement` | StmtSchoenfeldWeak C k x₀' pi li |
| [`Stage3.weak_mono`](./lean_stage3/Statement.md#Stage3-weak_mono) | theorem | shape | `Statement` | StmtSchoenfeldWeak C' k x₀ pi li |
| [`CellResidual.weak_nonneg`](./lean_stage3/CellResidual.md#CellResidual-weak_nonneg) | theorem | shape | `CellResidual` | StmtSchoenfeldWeak (max C 0) 1 (max x₀ 2) (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li |
| [`Stage3.weakWindow_at_schoenfeld`](./lean_stage3/Statement.md#Stage3-weakWindow_at_schoenfeld) | theorem | shape | `Statement` | StmtWeakWindow (1 / (8 * Real.pi)) 1 f L r n ↔ StmtSchoenfeldWindow f L r n |
| [`Stage3.weakWindow_of_global`](./lean_stage3/Statement.md#Stage3-weakWindow_of_global) | theorem | shape | `Statement` | StmtWeakWindow C k f L r n |
| [`JointFloorGate.weakWindow_relErr`](./lean_stage3/JointFloorGate.md#JointFloorGate-weakWindow_relErr) | theorem | shape | `JointFloorGate` | JointDialGate.StmtRelErrWindow f L r n (C * (Real.log 2 * r) ^ k * (2 : ℝ) ^ (-(((r : ℝ) - n) / 2))) |
| [`WeilSeries.weight_le`](./lean_stage3/WeilSeries.md#WeilSeries-weight_le) | theorem | shape | `WeilSeries` | 15 * Real.log (centre k) + 73 ≤ 88 * ((k : ℝ) + 1) |
| [`WeilSeries.weight_nonneg`](./lean_stage3/WeilSeries.md#WeilSeries-weight_nonneg) | theorem | shape | `WeilSeries` | 0 ≤ 15 * Real.log (centre k) + 73 |
| [`DirichletMeanW.weighted_gap`](./lean_stage3/DirichletMeanW.md#DirichletMeanW-weighted_gap) | theorem | shape | `DirichletMeanW` | 2 / \|Real.log n - Real.log m\| * ((m : ℝ) / n) ≤ 2 * m * (\|(m : ℝ) - n\|⁻¹ + (n : ℝ)⁻¹) |
| [`WeilBands.weightedTerm`](./lean_stage3/WeilBands.md#WeilBands-weightedTerm) | def | reads ζ | `WeilBands` | ℝ |
| [`WeilOnLine.weightedTerm_conjZ`](./lean_stage3/WeilOnLine.md#WeilOnLine-weightedTerm_conjZ) | theorem | reads ζ | `WeilOnLine` | weightedTerm h γ (conjZ ρ) = weightedTerm h γ ρ |
| [`WeilTiles.weightedTerm_nonneg`](./lean_stage3/WeilTiles.md#WeilTiles-weightedTerm_nonneg) | theorem | reads ζ | `WeilTiles` | 0 ≤ weightedTerm h γ ρ |
| [`WeilPowerBands.weightedTermW`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-weightedTermW) | def | reads ζ | `WeilPowerBands` | ℝ |
| [`WeilPowerOnLine.weightedTermW_conjZ`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-weightedTermW_conjZ) | theorem | reads ζ | `WeilPowerOnLine` | weightedTermW h γ m (conjZ ρ) = weightedTermW h γ m ρ |
| [`WeilPowerBands.weightedTermW_nonneg`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-weightedTermW_nonneg) | theorem | reads ζ | `WeilPowerBands` | 0 ≤ weightedTermW h γ m ρ |
| [`Stage3.weightedZeroHeightBucket_eq_zero`](./lean_stage3/RealSegment.md#Stage3-weightedZeroHeightBucket_eq_zero) | theorem | reads ζ | `RealSegment` | Kadiri.weightedZeroHeightBucket = 0 |
| [`Bridge.weil_bridge`](./lean_bridge/WeilBridge.md#Bridge-weil_bridge) | theorem | reads ζ | `WeilBridge` | Summable (fun ρ : {ρ : ℂ \| riemannZeta ρ = 0 ∧ 0 &lt; ρ.re ∧ ρ.re &lt; 1} =&gt; (((analyticOrderAt riemannZeta (ρ : ℂ)).toNat : ℕ) : ℂ) * (laplace G (-(ρ : ℂ)) * laplace G (-(1 - (ρ : ℂ))))) ∧ ∑' ρ : {ρ : ℂ \| … |
| [`WeilDetect.weilPositive_of_RH`](./lean_stage3/WeilDetect.md#WeilDetect-weilPositive_of_RH) | theorem | reads ζ | `WeilDetect` | StmtWeilPositive L |
| [`WeilOddPower.what`](./lean_stage3/WeilOddPower.md#WeilOddPower-what) | def | shape | `WeilOddPower` | ℂ |
| [`WeilOddPower.what_eq`](./lean_stage3/WeilOddPower.md#WeilOddPower-what_eq) | theorem | shape | `WeilOddPower` | what h γ m z = ((h : ℂ) / 2) * (S m ((z + Complex.I * (γ : ℂ)) * (h : ℂ)) + S m ((z - Complex.I * (γ : ℂ)) * (h : ℂ))) |
| [`WeilPowerBackground.what_I`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-what_I) | theorem | shape | `WeilPowerBackground` | what h γ m (Complex.I * (t : ℂ)) = Complex.I * ((h : ℂ) / 2) * ((PsiW m (h * (t + γ)) : ℂ) + (PsiW m (h * (t - γ)) : ℂ)) |
| [`WeilPowerBackground.what_neg`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-what_neg) | theorem | shape | `WeilPowerBackground` | what h γ m (-z) = -what h γ m z |
| [`SeedPerturbation.window_bottoms_correct`](./lean/SeedPerturbation.md#SeedPerturbation-window_bottoms_correct) | theorem | counting | `SeedPerturbation` | zero_cells.map (fun c =&gt; (c.1 : ℤ) - (c.2 : ℤ)) = zero_window_bottoms |
| [`Zeros.window_exclusive_of_prime_exponent`](./lean/ZerosStencil.md#Zeros-window_exclusive_of_prime_exponent) | theorem | counting | `ZerosStencil` | b = 2 ∧ k = 7 |
| [`ZeroSquares.window_mem`](./lean_stage3/ZeroSquares.md#ZeroSquares-window_mem) | theorem | reads ζ | `ZeroSquares` | ρ ∈ Stage3.zetaWindow ((n : ℝ) + 5 / 2) |
| [`Schoenfeld.window_of_global`](./lean/Schoenfeld.md#Schoenfeld-window_of_global) | theorem | shape | `Schoenfeld` | Nonvanishing.StmtSchoenfeldWindow f L r n |
| [`Stage3.window_of_global`](./lean_stage3/Statement.md#Stage3-window_of_global) | theorem | shape | `Statement` | StmtSchoenfeldWindow f L r n |
| [`Zeros.window_shared_of_composite_exponent`](./lean/Zeros.md#Zeros-window_shared_of_composite_exponent) | theorem | counting | `Zeros` | (4 : ℕ) ^ 2 = 2 ^ 4 |
| [`Nonvanishing.window_term_le`](./lean/Nonvanishing.md#Nonvanishing-window_term_le) | theorem | shape | `Nonvanishing` | (Real.log 2 * ((r : ℝ) - k) / (8 * Real.pi)) * (2 : ℝ) ^ (((r : ℝ) - k) / 2) ≤ (Real.log 2 * r / (8 * Real.pi)) * (2 : ℝ) ^ ((r : ℝ) / 2) * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k |
| [`LandauWindow.WindowBound`](./lean_stage3/LandauWindow.md#LandauWindow-WindowBound) | def | shape | `LandauWindow` | Prop |
| [`Zeros.wingMinus`](./lean/ZerosStencil.md#Zeros-wingMinus) | def | counting | `ZerosStencil` | ℤ |
| [`Zeros.wingPlus`](./lean/ZerosStencil.md#Zeros-wingPlus) | def | counting | `ZerosStencil` | ℤ |
| [`LeftSmooth.wL`](./lean_stage3/LeftSmooth.md#LeftSmooth-wL) | def | shape | `LeftSmooth` | ℂ |
| [`LeftSmooth.wL_ne_one`](./lean_stage3/LeftSmooth.md#LeftSmooth-wL_ne_one) | theorem | shape | `LeftSmooth` | wL t ≠ 1 |
| [`LeftSmooth.wL_re`](./lean_stage3/LeftSmooth.md#LeftSmooth-wL_re) | theorem | shape | `LeftSmooth` | (wL t).re = 5/4 |
| [`WeilPowerBridge.wm`](./lean_stage3/WeilPowerBridge.md#WeilPowerBridge-wm) | def | shape | `WeilPowerBridge` | ℂ |
| [`FilterLadder.Wn`](./lean_stage3/FilterLadder.md#FilterLadder-Wn) | def | counting | `FilterLadder` | ℝ |
| [`FilterLadder.Wn_eq_Wb`](./lean_stage3/FilterLadder.md#FilterLadder-Wn_eq_Wb) | theorem | shape | `FilterLadder` | Wn q = Wb (Real.sqrt 2)⁻¹ q |
| [`FilterLadder.Wn_nonneg`](./lean_stage3/FilterLadder.md#FilterLadder-Wn_nonneg) | theorem | shape | `FilterLadder` | 0 ≤ Wn q |
| [`FilterLadder.Wn_pow_le`](./lean_stage3/FilterLadder.md#FilterLadder-Wn_pow_le) | theorem | shape | `FilterLadder` | Wn (q ^ m) ≤ Wn q ^ m |
| [`WobbleCount.wobbleSum`](./lean_stage3/WobbleCount.md#WobbleCount-wobbleSum) | def | shape | `WobbleCount` | ℂ |
| [`WobbleCount.wobbleSum_expansion`](./lean_stage3/WobbleCount.md#WobbleCount-wobbleSum_expansion) | theorem | reads ζ | `WobbleCount` | ∃ E : ℂ, ‖E‖ ≤ ‖ρ‖ * ‖ρ + 1‖ / 4 ∧ wobbleSum ρ N = riemannZeta ρ * (N : ℂ) ^ ρ + (N : ℂ) / (1 - ρ) + 1 / 2 + E |
| [`WeilPowerCompare.wOf`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-wOf) | def | shape | `WeilPowerCompare` | ℂ |
| [`WeilPowerCompare.wOf_im`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-wOf_im) | theorem | shape | `WeilPowerCompare` | (wOf ε Δ h).im = Δ * h |
| [`WeilPowerCompare.wOf_re`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-wOf_re) | theorem | shape | `WeilPowerCompare` | (wOf ε Δ h).re = ε * h |
| [`WeilPowerCompare.wOf_sq_re`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-wOf_sq_re) | theorem | shape | `WeilPowerCompare` | ((wOf ε Δ h) ^ 2).re = (ε ^ 2 - Δ ^ 2) * h ^ 2 |
| [`WeilPowerBridge.wp`](./lean_stage3/WeilPowerBridge.md#WeilPowerBridge-wp) | def | shape | `WeilPowerBridge` | ℂ |
| [`WeilPowerBridge.wp_im`](./lean_stage3/WeilPowerBridge.md#WeilPowerBridge-wp_im) | theorem | shape | `WeilPowerBridge` | (wp h γ ρ).im = (ρ.im + γ) * h |
| [`WeilPowerBridge.wp_re`](./lean_stage3/WeilPowerBridge.md#WeilPowerBridge-wp_re) | theorem | shape | `WeilPowerBridge` | (wp h γ ρ).re = (ρ.re - 1 / 2) * h |
| [`PiZeros.wt`](./lean_stage3/PiZeros.md#PiZeros-wt) | def | shape | `PiZeros` | ℂ |
| [`PiZeros.wt_continuousOn`](./lean_stage3/PiZeros.md#PiZeros-wt_continuousOn) | theorem | shape | `PiZeros` | ContinuousOn wt (Set.uIcc 2 x) |
| [`FilterLadder.wz`](./lean_stage3/FilterLadder.md#FilterLadder-wz) | def | reads ζ | `FilterLadder` | ℂ |
| [`WeilPowerPhase.x`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-x) | def | shape | `WeilPowerPhase` | ℂ |
| [`WeilPowerPhase.x_eq_mul`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-x_eq_mul) | theorem | shape | `WeilPowerPhase` | x w j = w ^ 2 * ((hterm j : ℝ) : ℂ) |
| [`WeilPowerGauss.x_norm`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-x_norm) | theorem | shape | `WeilPowerGauss` | ‖w ^ 2 / ((Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2)‖ = ‖w‖ ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2) |
| [`WeilPowerGauss.x_re`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-x_re) | theorem | shape | `WeilPowerGauss` | (w ^ 2 / ((Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2)).re = (w ^ 2).re / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2) |
| [`FilterAttained.xi`](./lean_stage3/FilterAttained.md#FilterAttained-xi) | def | reads ζ | `FilterAttained` | ℂ |
| [`Stage3.xi`](./lean_stage3/ArgIdentity.md#Stage3-xi) | def | reads ζ | `ArgIdentity` | ℂ |
| [`Stage3.xi_analyticAt`](./lean_stage3/ArgIdentity.md#Stage3-xi_analyticAt) | theorem | reads ζ | `ArgIdentity` | AnalyticAt ℂ xi s |
| [`Stage3.xi_conj`](./lean_stage3/ArgIdentity.md#Stage3-xi_conj) | theorem | reads ζ | `ArgIdentity` | xi (conj s) = conj (xi s) |
| [`Stage3.xi_divisor_support_eq`](./lean_stage3/ArgIdentity.md#Stage3-xi_divisor_support_eq) | theorem | reads ζ | `ArgIdentity` | (MeromorphicOn.divisor xi (Rectangle (-1 : ℂ) (2 + Complex.I * T))).support = riemannZeta.zeroes_rect (Set.univ : Set ℝ) (Set.Ioo 0 T) |
| [`Stage3.xi_eq_completed`](./lean_stage3/ArgIdentity.md#Stage3-xi_eq_completed) | theorem | reads ζ | `ArgIdentity` | xi s = s * (s - 1) * completedRiemannZeta s |
| [`Stage3.xi_eq_prod`](./lean_stage3/ArgIdentity.md#Stage3-xi_eq_prod) | theorem | reads ζ | `ArgIdentity` | xi s = s * (s - 1) * Gammaℝ s * riemannZeta s |
| [`Stage3.xi_eq_zero_iff`](./lean_stage3/ArgIdentity.md#Stage3-xi_eq_zero_iff) | theorem | reads ζ | `ArgIdentity` | xi s = 0 ↔ riemannZeta s = 0 ∧ 0 &lt; s.re ∧ s.re &lt; 1 |
| [`Stage3.xi_meromorphicOrderAt_ne_top`](./lean_stage3/ArgIdentity.md#Stage3-xi_meromorphicOrderAt_ne_top) | theorem | reads ζ | `ArgIdentity` | meromorphicOrderAt xi p ≠ ⊤ |
| [`Stage3.xi_ne_zero_of_one_le_re`](./lean_stage3/ArgIdentity.md#Stage3-xi_ne_zero_of_one_le_re) | theorem | reads ζ | `ArgIdentity` | xi s ≠ 0 |
| [`Stage3.xi_ne_zero_of_re_nonpos`](./lean_stage3/ArgIdentity.md#Stage3-xi_ne_zero_of_re_nonpos) | theorem | reads ζ | `ArgIdentity` | xi s ≠ 0 |
| [`Stage3.xi_ne_zero_of_real`](./lean_stage3/ArgIdentity.md#Stage3-xi_ne_zero_of_real) | theorem | reads ζ | `ArgIdentity` | xi (σ : ℂ) ≠ 0 |
| [`Stage3.xi_ne_zero_on_good_top`](./lean_stage3/ArgIdentity.md#Stage3-xi_ne_zero_on_good_top) | theorem | reads ζ | `ArgIdentity` | xi ((x : ℂ) + T * Complex.I) ≠ 0 |
| [`Stage3.xi_one`](./lean_stage3/ArgIdentity.md#Stage3-xi_one) | theorem | reads ζ | `ArgIdentity` | xi 1 = 1 |
| [`Stage3.xi_one_sub`](./lean_stage3/ArgIdentity.md#Stage3-xi_one_sub) | theorem | reads ζ | `ArgIdentity` | xi (1 - s) = xi s |
| [`FilterAttained.xi_pow`](./lean_stage3/FilterAttained.md#FilterAttained-xi_pow) | theorem | reads ζ | `FilterAttained` | xi q a b ρ ^ k = (q.eval (((2:ℂ) ^ (ρ : ℂ))⁻¹)) ^ (a * k) * ((2:ℂ) ^ (ρ : ℂ)) ^ (b * k) |
| [`Stage3.xi_zero`](./lean_stage3/ArgIdentity.md#Stage3-xi_zero) | theorem | reads ζ | `ArgIdentity` | xi 0 = 1 |
| [`WeilTransform.xP_odd`](./lean_stage3/WeilTransform.md#WeilTransform-xP_odd) | theorem | shape | `WeilTransform` | (-x) * P (-x) = -(x * P x) |
| [`Crossover.xterm`](./lean/Crossover.md#Crossover-xterm) | def | shape | `Crossover` | ℝ |
| [`Crossover.yterm`](./lean/Crossover.md#Crossover-yterm) | def | shape | `Crossover` | ℝ |
| [`PiFixedRow.Z2`](./lean_stage3/PiFixedRow.md#PiFixedRow-Z2) | def | reads ζ | `PiFixedRow` | ℝ |
| [`PiFixedRow.Z2_nonneg`](./lean_stage3/PiFixedRow.md#PiFixedRow-Z2_nonneg) | theorem | reads ζ | `PiFixedRow` | 0 ≤ Z2 |
| [`Zeros.zero_20_6`](./lean/Zeros.md#Zeros-zero_20_6) | theorem | counting | `Zeros` | Construction.tableFrom dyadicRow 20 6 = 0 |
| [`Zeros.zero_2_1`](./lean/Zeros.md#Zeros-zero_2_1) | theorem | counting | `Zeros` | Construction.tableFrom dyadicRow 2 1 = 0 |
| [`Zeros.zero_4_1`](./lean/Zeros.md#Zeros-zero_4_1) | theorem | counting | `Zeros` | Construction.tableFrom dyadicRow 4 1 = 0 |
| [`Zeros.zero_8_3`](./lean/Zeros.md#Zeros-zero_8_3) | theorem | counting | `Zeros` | Construction.tableFrom dyadicRow 8 3 = 0 |
| [`Zeros.zero_at_20_6_of_repeat`](./lean/Zeros.md#Zeros-zero_at_20_6_of_repeat) | theorem | counting | `Zeros` | Construction.tableFrom N 20 6 = 0 |
| [`Zeros.zero_at_8_3_of_repeat`](./lean/Zeros.md#Zeros-zero_at_8_3_of_repeat) | theorem | counting | `Zeros` | Construction.tableFrom N 8 3 = 0 |
| [`PairIdentity.zero_cells`](./lean/PairIdentity.md#PairIdentity-zero_cells) | def | counting | `PairIdentity` | List (ℕ × ℕ) |
| [`SeedPerturbation.zero_cells`](./lean/SeedPerturbation.md#SeedPerturbation-zero_cells) | def | counting | `SeedPerturbation` | List (ℕ × ℕ) |
| [`ZeroDensity.zero_density`](./lean_stage3/ZeroDensity.md#ZeroDensity-zero_density) | theorem | reads ζ | `ZeroDensity` | ∃ θ C T₀ : ℝ, θ &lt; 1 ∧ 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ Z : Finset ℂ, (∀ ρ ∈ Z, riemannZeta ρ = 0 ∧ σ ≤ ρ.re ∧ ρ.re &lt; 1 ∧ 2 ≤ ρ.im ∧ ρ.im ≤ T - 2) → (Z.card : ℝ) ≤ C * T ^ θ |
| [`Construction.zero_determined_by_row`](./lean/Construction.md#Construction-zero_determined_by_row) | theorem | counting | `Construction` | tableFrom N r d = tableFrom M r d |
| [`SeedPerturbation.zero_iff_of_seed_perturbation`](./lean/SeedPerturbation.md#SeedPerturbation-zero_iff_of_seed_perturbation) | theorem | counting | `SeedPerturbation` | tableFrom (fun x =&gt; N x - e x) r d = 0 ↔ tableFrom N r d = 0 |
| [`Zeros.zero_iff_repeat`](./lean/Zeros.md#Zeros-zero_iff_repeat) | theorem | counting | `Zeros` | f r (d + 1) = 0 ↔ f r d = f (r - 1) d |
| [`AliasClass.zero_re_pos`](./lean_stage3/AliasClass.md#AliasClass-zero_re_pos) | theorem | reads ζ | `AliasClass` | 0 &lt; (ρ : ℂ).re |
| [`LandauZeroSide.zero_side`](./lean_stage3/LandauZeroSide.md#LandauZeroSide-zero_side) | theorem | reads ζ | `LandauZeroSide` | ∃ r R τ C₁ : ℝ, ∃ N₀ : ℕ, σ₀ - 1 &lt; r ∧ r ≤ ‖(σ₀ : ℂ) - ρ₀‖ ∧ r &lt; R ∧ 0 &lt; τ ∧ 0 ≤ C₁ ∧ ∀ a N : ℕ, N₀ ≤ N → ∃ k ∈ Finset.Ico a (a + N), τ / r ^ (k + 1) - C₁ / R ^ k ≤ LandauPrimeSide.Ik σ₀ k / k.factori… |
| [`SeedPerturbation.zero_stable_of_seed_perturbation`](./lean/SeedPerturbation.md#SeedPerturbation-zero_stable_of_seed_perturbation) | theorem | counting | `SeedPerturbation` | tableFrom (fun x =&gt; N x - e x) r d = 0 |
| [`SeedPerturbation.zero_window_bottoms`](./lean/SeedPerturbation.md#SeedPerturbation-zero_window_bottoms) | def | counting | `SeedPerturbation` | List ℤ |
| [`WeilBridgeLeaf.zeroes_rect_strip`](./lean_stage3/WeilBridgeLeaf.md#WeilBridgeLeaf-zeroes_rect_strip) | theorem | reads ζ | `WeilBridgeLeaf` | riemannZeta.zeroes_rect (Set.Ioo 0 1) Set.univ = {ρ : ℂ \| riemannZeta ρ = 0 ∧ 0 &lt; ρ.re ∧ ρ.re &lt; 1} |
| [`WeilDetect.zeroForm`](./lean_stage3/WeilDetect.md#WeilDetect-zeroForm) | def | reads ζ | `WeilDetect` | ℂ |
| [`WeilBridgeLeaf.zeroForm_eq_primeSide`](./lean_stage3/WeilBridgeLeaf.md#WeilBridgeLeaf-zeroForm_eq_primeSide) | theorem | reads ζ | `WeilBridgeLeaf` | zeroForm G = primeSideM (kOfM G) |
| [`WeilBridgeLeaf.zeroForm_eq_strip`](./lean_stage3/WeilBridgeLeaf.md#WeilBridgeLeaf-zeroForm_eq_strip) | theorem | reads ζ | `WeilBridgeLeaf` | zeroForm G = ∑' ρ : {ρ : ℂ \| riemannZeta ρ = 0 ∧ 0 &lt; ρ.re ∧ ρ.re &lt; 1}, (((analyticOrderAt riemannZeta (ρ : ℂ)).toNat : ℕ) : ℂ) * (laplace G (-(ρ : ℂ)) * laplace G (-(1 - (ρ : ℂ)))) |
| [`WeilDetect.zeroForm_nonneg_of_RH`](./lean_stage3/WeilDetect.md#WeilDetect-zeroForm_nonneg_of_RH) | theorem | reads ζ | `WeilDetect` | 0 ≤ (zeroForm G).re |
| [`StencilWeil.zeroForm_stencilTest`](./lean_stage3/StencilWeil.md#StencilWeil-zeroForm_stencilTest) | theorem | reads ζ | `StencilWeil` | zeroForm (stencilTest d φ) = riemannZeta.zeroes_sum (Set.Ioo 0 1) (Set.univ : Set ℝ) (fun ρ =&gt; ((1 - (2 : ℂ) ^ (-ρ)) * (1 - (2 : ℂ) ^ (-(1 - ρ)))) ^ d * (laplace φ (-ρ) * laplace φ (-(1 - ρ)))) |
| [`StencilWeil.zeroForm_stencilTest_eq_primeSide`](./lean_stage3/StencilWeil.md#StencilWeil-zeroForm_stencilTest_eq_primeSide) | theorem | reads ζ | `StencilWeil` | zeroForm (stencilTest d φ) = WeilBridgeLeaf.primeSideM (WeilBridgeLeaf.kOfM (stencilTest d φ)) |
| [`StencilWeil.zeroForm_stencilTest_nonneg_of_RH`](./lean_stage3/StencilWeil.md#StencilWeil-zeroForm_stencilTest_nonneg_of_RH) | theorem | reads ζ | `StencilWeil` | 0 ≤ (zeroForm (stencilTest d φ)).re |
| [`LandauWindow.zeroFree_half_of_window`](./lean_stage3/LandauWindow.md#LandauWindow-zeroFree_half_of_window) | theorem | reads ζ | `LandauWindow` | ∀ s : ℂ, 1 / 2 &lt; s.re → riemannZeta s ≠ 0 |
| [`Stage3.zeroFreeRight_iff_psiWeakTheta`](./lean_stage3/ThetaConverse.md#Stage3-zeroFreeRight_iff_psiWeakTheta) | theorem | reads ζ | `ThetaConverse` | StmtZeroFreeRight θ ↔ ∃ C &gt; 0, ∃ x₀ : ℝ, StmtPsiWeakTheta θ C 3 x₀ |
| [`Stage3.zeroFreeRight_mono`](./lean_stage3/Abscissa.md#Stage3-zeroFreeRight_mono) | theorem | reads ζ | `Abscissa` | StmtZeroFreeRight θ' |
| [`Stage3.zeroFreeRight_of_psiWeakTheta`](./lean_stage3/ThetaConverse.md#Stage3-zeroFreeRight_of_psiWeakTheta) | theorem | reads ζ | `ThetaConverse` | StmtZeroFreeRight θ |
| [`Stage3.zeroFreeRight_of_RH`](./lean_stage3/Abscissa.md#Stage3-zeroFreeRight_of_RH) | theorem | reads ζ | `Abscissa` | StmtZeroFreeRight (1/2) |
| [`JointWindowDial.zeroFreeRight_of_window`](./lean_stage3/JointWindowDial.md#JointWindowDial-zeroFreeRight_of_window) | theorem | reads ζ | `JointWindowDial` | Stage3.StmtZeroFreeRight θ |
| [`Stage3.zeroFreeRight_one`](./lean_stage3/Abscissa.md#Stage3-zeroFreeRight_one) | theorem | reads ζ | `Abscissa` | StmtZeroFreeRight 1 |
| [`Stage3.zeroFreeRight_one_of_chebyshev`](./lean_stage3/ThetaConverse.md#Stage3-zeroFreeRight_one_of_chebyshev) | theorem | reads ζ | `ThetaConverse` | StmtZeroFreeRight 1 |
| [`ContourShift.zeroGap`](./lean_stage3/ContourShift.md#ContourShift-zeroGap) | def | shape | `ContourShift` | ℝ |
| [`ContourShift.zeroGap_le`](./lean_stage3/ContourShift.md#ContourShift-zeroGap_le) | theorem | shape | `ContourShift` | zeroGap T ≤ 9/10 |
| [`ContourShift.zeroGap_pos`](./lean_stage3/ContourShift.md#ContourShift-zeroGap_pos) | theorem | shape | `ContourShift` | 0 &lt; zeroGap T |
| [`Stage3.zeroinner_arith`](./lean_stage3/Assembly.md#Stage3-zeroinner_arith) | theorem | shape | `Assembly` | 2 * (Real.log 2 / (2 * Real.pi) * (KK + 1) * (KK + 2) + 3 * (KK + 1) / Real.pi + 2 * (R + 7 / 8)) + 2 * W ≤ 2 * (7 + 4 * b₁ + 4 * b₂ + 2 * b₃) * L ^ 2 + 2 * W |
| [`Stage3.zeroinner_floor`](./lean_stage3/AssemblyFloor.md#Stage3-zeroinner_floor) | theorem | shape | `AssemblyFloor` | 2 * (Real.log 2 / (2 * Real.pi) * (KK + 1) * (KK + 2) + 3 * (KK + 1) / Real.pi + 2 * (R + 7 / 8)) + 2 * W ≤ 2 * (L ^ 2 + (4 + 4 * b₁ + 4 * b₂) * L + 2 * b₃ + 2) + 2 * W |
| [`Stage3.zeroPartialSum`](./lean_stage3/Assembly.md#Stage3-zeroPartialSum) | def | reads ζ | `Assembly` | ℂ |
| [`ContourShift.zeroPartialSum_eq_sum`](./lean_stage3/ContourShift.md#ContourShift-zeroPartialSum_eq_sum) | theorem | reads ζ | `ContourShift` | Stage3.zeroPartialSum x T' = ∑ p ∈ ZF, ((analyticOrderNatAt riemannZeta p : ℂ) * ((x : ℂ) ^ p / p)) |
| [`PiZeros.zeroPartialSum_eq_sum`](./lean_stage3/PiZeros.md#PiZeros-zeroPartialSum_eq_sum) | theorem | reads ζ | `PiZeros` | Stage3.zeroPartialSum t T = ∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ)) |
| [`Glue.zeroPartialSum_swap`](./lean_stage3/Glue.md#Glue-zeroPartialSum_swap) | theorem | reads ζ | `Glue` | ∃ C : ℝ, 0 &lt; C ∧ ∀ x T T' : ℝ, 16 ≤ x → 2 ≤ T → T ≤ T' → T' ≤ T + 1 → ‖Stage3.zeroPartialSum x T' - Stage3.zeroPartialSum x T‖ ≤ C * x * Real.log T / T |
| [`Glue.zeroPartialSum_swap_num`](./lean_stage3/GlueNum.md#Glue-zeroPartialSum_swap_num) | theorem | reads ζ | `GlueNum` | ∀ x T T' : ℝ, 16 ≤ x → 2 ≤ T → T ≤ T' → T' ≤ T + 1 → ‖Stage3.zeroPartialSum x T' - Stage3.zeroPartialSum x T‖ ≤ Csn * x * Real.log T / T |
| [`ExplicitTwo.zeroPartialSum_swap_two`](./lean_stage3/ExplicitTwo.md#ExplicitTwo-zeroPartialSum_swap_two) | theorem | reads ζ | `ExplicitTwo` | ∀ x T T' : ℝ, 1 ≤ x → 2 ≤ T → T ≤ T' → T' ≤ T + 1 → ‖Stage3.zeroPartialSum x T' - Stage3.zeroPartialSum x T‖ ≤ Glue.Csn * x * Real.log T / T |
| [`Transform.zeros_in_fundamental_annulus`](./lean/Transform.md#Transform-zeros_in_fundamental_annulus) | theorem | reads ζ | `Transform` | b ^ (-(1 : ℝ)) &lt; ‖(b : ℂ) ^ (-s)‖ ∧ ‖(b : ℂ) ^ (-s)‖ &lt; 1 |
| [`Transform.zeros_outside_inner_circle`](./lean/Transform.md#Transform-zeros_outside_inner_circle) | theorem | reads ζ | `Transform` | b ^ (-(1 : ℝ)) &lt; ‖(b : ℂ) ^ (-s)‖ |
| [`Transform.zeros_re_lt_one`](./lean/Transform.md#Transform-zeros_re_lt_one) | theorem | reads ζ | `Transform` | s.re &lt; 1 |
| [`Transform.zeros_re_pos`](./lean/Transform.md#Transform-zeros_re_pos) | theorem | reads ζ | `Transform` | 0 &lt; s.re |
| [`ZetaGrowth.zeta1`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta1) | def | shape | `ZetaGrowth` | ℂ |
| [`ZetaGrowth.zeta1_analyticOnNhd`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta1_analyticOnNhd) | theorem | reads ζ | `ZetaGrowth` | AnalyticOnNhd ℂ (zeta1 N) stripRegion |
| [`ZetaGrowth.zeta1_eq_zeta`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta1_eq_zeta) | theorem | reads ζ | `ZetaGrowth` | zeta1 N s = riemannZeta s |
| [`ZetaGrowth.zeta1_eq_zeta_strip`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta1_eq_zeta_strip) | theorem | reads ζ | `ZetaGrowth` | Set.EqOn (zeta1 N) riemannZeta stripRegion |
| [`ContourShift.zeta_analyticAt`](./lean_stage3/ContourShift.md#ContourShift-zeta_analyticAt) | theorem | reads ζ | `ContourShift` | AnalyticAt ℂ riemannZeta ρ |
| [`VonKoch.zeta_analyticOnNhd`](./lean_stage3/VonKochScaffold.md#VonKoch-zeta_analyticOnNhd) | theorem | reads ζ | `VonKochScaffold` | AnalyticOnNhd ℂ riemannZeta region |
| [`Stage3.zeta_analyticOnNhd_regionθ`](./lean_stage3/ThetaConverse.md#Stage3-zeta_analyticOnNhd_region-) | theorem | reads ζ | `ThetaConverse` | AnalyticOnNhd ℂ ζ (regionθ θ) |
| [`Stage3.zeta_centre_lower`](./lean_stage3/JensenCount.md#Stage3-zeta_centre_lower) | theorem | reads ζ | `JensenCount` | (1 : ℝ) / 3 ≤ ‖ζ (2 + Complex.I * T)‖ |
| [`Stage3.zeta_centre_ne_zero`](./lean_stage3/JensenCount.md#Stage3-zeta_centre_ne_zero) | theorem | reads ζ | `JensenCount` | ζ (2 + Complex.I * (T : ℂ)) ≠ 0 |
| [`Stage3.zeta_comp_analytic`](./lean_stage3/JensenCount.md#Stage3-zeta_comp_analytic) | theorem | reads ζ | `JensenCount` | AnalyticAt ℂ (fun z : ℂ =&gt; ζ (2 * z + (2 + Complex.I * (T : ℂ)))) w |
| [`Stage3.zeta_disk_upper`](./lean_stage3/JensenCount.md#Stage3-zeta_disk_upper) | theorem | reads ζ | `JensenCount` | ‖ζ w‖ ≤ 28 * T |
| [`ZetaEM.zeta_eq_em`](./lean_stage3/ZetaEM.md#ZetaEM-zeta_eq_em) | theorem | reads ζ | `ZetaEM` | riemannZeta s = ∑ n ∈ Finset.Icc 1 N, (n : ℂ) ^ (-s) - (N:ℂ) ^ (1 - s) / (1 - s) - (N:ℂ) ^ (-s) / 2 + emBoundary k N s + emRem k N s |
| [`ZetaEM.zeta_eq_em_one`](./lean_stage3/ZetaEM.md#ZetaEM-zeta_eq_em_one) | theorem | reads ζ | `ZetaEM` | riemannZeta s = ∑ n ∈ Finset.Icc 1 N, (n : ℂ) ^ (-s) - (N:ℂ) ^ (1 - s) / (1 - s) - (N:ℂ) ^ (-s) / 2 - s * emInt 1 N s |
| [`ZetaGrowth.zeta_growth_strip`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta_growth_strip) | theorem | reads ζ | `ZetaGrowth` | ‖riemannZeta s‖ ≤ 15 * \|s.im\| ^ 2 |
| [`ContourShift.zeta_local_data`](./lean_stage3/ContourShift.md#ContourShift-zeta_local_data) | theorem | reads ζ | `ContourShift` | ∃ h : ℂ → ℂ, AnalyticAt ℂ h p ∧ ∀ᶠ s in nhdsWithin p {p}ᶜ, - deriv riemannZeta s / riemannZeta s * ((x:ℝ):ℂ) ^ s / s = h s + (-(n:ℂ) * ((x:ℝ):ℂ) ^ p / p) / (s - p) |
| [`ContourShift.zeta_local_data_one`](./lean_stage3/ContourShift.md#ContourShift-zeta_local_data_one) | theorem | reads ζ | `ContourShift` | ∃ h : ℂ → ℂ, AnalyticAt ℂ h 1 ∧ ∀ᶠ s in nhdsWithin 1 {1}ᶜ, - deriv riemannZeta s / riemannZeta s * ((x:ℝ):ℂ) ^ s / s = h s + ((x:ℝ):ℂ) / (s - 1) |
| [`ContourShift.zeta_local_data_origin`](./lean_stage3/ContourShift.md#ContourShift-zeta_local_data_origin) | theorem | reads ζ | `ContourShift` | ∃ h : ℂ → ℂ, AnalyticAt ℂ h 0 ∧ ∀ᶠ s in nhdsWithin 0 {0}ᶜ, - deriv riemannZeta s / riemannZeta s * ((x:ℝ):ℂ) ^ s / s = h s + (- deriv riemannZeta 0 / riemannZeta 0) / (s - 0) |
| [`ContourShift.zeta_local_data_zero`](./lean_stage3/ContourShift.md#ContourShift-zeta_local_data_zero) | theorem | reads ζ | `ContourShift` | ∃ h : ℂ → ℂ, AnalyticAt ℂ h ρ ∧ ∀ᶠ s in nhdsWithin ρ {ρ}ᶜ, - deriv riemannZeta s / riemannZeta s * ((x:ℝ):ℂ) ^ s / s = h s + (-(analyticOrderNatAt riemannZeta ρ : ℂ) * ((x:ℝ):ℂ) ^ ρ / ρ) / (s - ρ) |
| [`Stage3.zeta_local_zero_count`](./lean_stage3/JensenCount.md#Stage3-zeta_local_zero_count) | theorem | reads ζ | `JensenCount` | ∑ ρ ∈ (zetaWindow_finite hT).toFinset, (analyticOrderNatAt ζ ρ : ℝ) ≤ 15 * Real.log T + 73 |
| [`Glue.zeta_logderiv_good_bound`](./lean_stage3/Glue.md#Glue-zeta_logderiv_good_bound) | theorem | reads ζ | `Glue` | ∃ C : ℝ, 0 &lt; C ∧ ∀ T T' : ℝ, 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 &lt; ρ.re → ContourShift.zeroGap T ≤ \|ρ.im - T'\|) → ∀ u : ℂ, \|u.im\| = T' → -1/4 ≤ u.re → u.re ≤ 2 → ‖deriv riem… |
| [`Glue.zeta_logderiv_good_bound_num`](./lean_stage3/GlueNum.md#Glue-zeta_logderiv_good_bound_num) | theorem | reads ζ | `GlueNum` | ∀ T T' : ℝ, 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 &lt; ρ.re → ContourShift.zeroGap T ≤ \|ρ.im - T'\|) → ∀ u : ℂ, \|u.im\| = T' → -1/4 ≤ u.re → u.re ≤ 2 → ‖deriv riemannZeta u / riema… |
| [`ContourShift.zeta_meromorphicOn`](./lean_stage3/ContourShift.md#ContourShift-zeta_meromorphicOn) | theorem | reads ζ | `ContourShift` | MeromorphicOn riemannZeta U |
| [`Elephant.zeta_ne_zero_of_re_eq_zero`](./lean/Elephant.md#Elephant-zeta_ne_zero_of_re_eq_zero) | theorem | reads ζ | `Elephant` | riemannZeta ρ ≠ 0 |
| [`ContourShift.zeta_ne_zero_of_re_mem`](./lean_stage3/ContourShift.md#ContourShift-zeta_ne_zero_of_re_mem) | theorem | reads ζ | `ContourShift` | riemannZeta w ≠ 0 |
| [`Stage3.zeta_ne_zero_of_real_mem_Ioo`](./lean_stage3/ArgIdentity.md#Stage3-zeta_ne_zero_of_real_mem_Ioo) | theorem | reads ζ | `ArgIdentity` | riemannZeta (σ : ℂ) ≠ 0 |
| [`RHPull.zeta_ne_zero_of_RH`](./lean_stage3/LineBound.md#RHPull-zeta_ne_zero_of_RH) | theorem | reads ζ | `LineBound` | ζ s ≠ 0 |
| [`Slice3.zeta_ne_zero_of_RH`](./lean_stage3/LineBound.md#Slice3-zeta_ne_zero_of_RH) | theorem | reads ζ | `LineBound` | ζ s ≠ 0 |
| [`Slice4.zeta_ne_zero_of_RH`](./lean_stage3/LineBound.md#Slice4-zeta_ne_zero_of_RH) | theorem | reads ζ | `LineBound` | ζ s ≠ 0 |
| [`Stage3.zeta_ne_zero_right_of`](./lean_stage3/Abscissa.md#Stage3-zeta_ne_zero_right_of) | theorem | reads ζ | `Abscissa` | ζ s ≠ 0 |
| [`LandauWindow.zeta_neg_nat_ne_zero`](./lean_stage3/LandauWindow.md#LandauWindow-zeta_neg_nat_ne_zero) | theorem | reads ζ | `LandauWindow` | riemannZeta (-(n : ℂ)) ≠ 0 |
| [`ContourShift.zeta_order_conj`](./lean_stage3/ContourShift.md#ContourShift-zeta_order_conj) | theorem | reads ζ | `ContourShift` | analyticOrderNatAt riemannZeta ((starRingEnd ℂ) ρ) = analyticOrderNatAt riemannZeta ρ |
| [`ContourShift.zeta_order_ne_top`](./lean_stage3/ContourShift.md#ContourShift-zeta_order_ne_top) | theorem | reads ζ | `ContourShift` | analyticOrderAt riemannZeta ρ ≠ ⊤ |
| [`ContourShift.zeta_order_reflect`](./lean_stage3/ContourShift.md#ContourShift-zeta_order_reflect) | theorem | reads ζ | `ContourShift` | analyticOrderNatAt riemannZeta (1 - (starRingEnd ℂ) ρ) = analyticOrderNatAt riemannZeta ρ |
| [`BoxBounds.zeta_ratio_ge`](./lean_stage3/BoxBounds.md#BoxBounds-zeta_ratio_ge) | theorem | reads ζ | `BoxBounds` | 2 / 7 ≤ ‖riemannZeta 3 / riemannZeta (3 / 2)‖ |
| [`EdgeBound.zeta_ratio_pos`](./lean_stage3/EdgeBound.md#EdgeBound-zeta_ratio_pos) | theorem | reads ζ | `EdgeBound` | (0:ℝ) &lt; ‖riemannZeta 3 / riemannZeta (3/2)‖ |
| [`Stage3.zeta_re_neg_of_real_mem_Ioo`](./lean_stage3/ArgIdentity.md#Stage3-zeta_re_neg_of_real_mem_Ioo) | theorem | reads ζ | `ArgIdentity` | (riemannZeta (σ : ℂ)).re &lt; 0 |
| [`Stage3.zeta_real_ne_zero`](./lean_stage3/RealSegment.md#Stage3-zeta_real_ne_zero) | theorem | reads ζ | `RealSegment` | riemannZeta (σ : ℂ) ≠ 0 |
| [`Stage3.zeta_real_ne_zero_upper`](./lean_stage3/RealSegment.md#Stage3-zeta_real_ne_zero_upper) | theorem | reads ζ | `RealSegment` | riemannZeta (σ : ℂ) ≠ 0 |
| [`LeftSmooth.zeta_sL_ne`](./lean_stage3/LeftSmooth.md#LeftSmooth-zeta_sL_ne) | theorem | reads ζ | `LeftSmooth` | riemannZeta (sL t) ≠ 0 |
| [`LeftSmooth.zeta_wL_ne`](./lean_stage3/LeftSmooth.md#LeftSmooth-zeta_wL_ne) | theorem | reads ζ | `LeftSmooth` | riemannZeta (wL t) ≠ 0 |
| [`Elephant.zeta_zero_weight_band`](./lean/Elephant.md#Elephant-zeta_zero_weight_band) | theorem | reads ζ | `Elephant` | (1 - b ^ (-(1:ℝ)/2)) ^ d ≤ ‖Sym b ρ‖ ^ d ∧ ‖Sym b ρ‖ ^ d ≤ (1 + b ^ (-(1:ℝ)/2)) ^ d |
| [`ContourShift.zeta_zeros_rectangle_finite`](./lean_stage3/ContourShift.md#ContourShift-zeta_zeros_rectangle_finite) | theorem | reads ζ | `ContourShift` | {ρ : ℂ \| riemannZeta ρ = 0 ∧ ρ ∈ Rectangle z w}.Finite |
| [`Stage3.zetaArgContour`](./lean_stage3/ArgIdentity.md#Stage3-zetaArgContour) | def | reads ζ | `ArgIdentity` | ℝ |
| [`ArgLegs.zetaArgContour_le`](./lean_stage3/ArgLegs.md#ArgLegs-zetaArgContour_le) | theorem | reads ζ | `ArgLegs` | \|Stage3.zetaArgContour T\| ≤ (Z.card : ℝ) + 3 / 2 |
| [`Slice4.zetaE`](./lean_stage3/LineBound.md#Slice4-zetaE) | def | reads ζ | `LineBound` | ℂ → ℂ |
| [`Slice4.zetaE_differentiable`](./lean_stage3/LineBound.md#Slice4-zetaE_differentiable) | theorem | reads ζ | `LineBound` | Differentiable ℂ zetaE |
| [`Slice4.zetaE_differentiableAt_of_ne`](./lean_stage3/LineBound.md#Slice4-zetaE_differentiableAt_of_ne) | theorem | reads ζ | `LineBound` | DifferentiableAt ℂ zetaE s |
| [`Slice4.zetaE_disk_upper`](./lean_stage3/LineBound.md#Slice4-zetaE_disk_upper) | theorem | reads ζ | `LineBound` | ‖zetaE w‖ ≤ 430 |
| [`Slice4.zetaE_eq`](./lean_stage3/LineBound.md#Slice4-zetaE_eq) | theorem | reads ζ | `LineBound` | zetaE s = (s - 1) * ζ s |
| [`Slice4.zetaE_ne_zero_of_RH`](./lean_stage3/LineBound.md#Slice4-zetaE_ne_zero_of_RH) | theorem | reads ζ | `LineBound` | zetaE s ≠ 0 |
| [`Slice4.zetaE_one`](./lean_stage3/LineBound.md#Slice4-zetaE_one) | theorem | reads ζ | `LineBound` | zetaE 1 = 1 |
| [`Stage3.zetaLocalCount`](./lean_stage3/JensenCount.md#Stage3-zetaLocalCount) | def | reads ζ | `JensenCount` | ℝ |
| [`Stage3.zetaLocalCount_eq`](./lean_stage3/JensenCount.md#Stage3-zetaLocalCount_eq) | theorem | reads ζ | `JensenCount` | zetaLocalCount T = ∑ ρ ∈ (zetaWindow_finite hT).toFinset, (analyticOrderNatAt ζ ρ : ℝ) |
| [`Stage3.zetaWindow`](./lean_stage3/JensenCount.md#Stage3-zetaWindow) | def | reads ζ | `JensenCount` | Set ℂ |
| [`Stage3.zetaWindow_finite`](./lean_stage3/JensenCount.md#Stage3-zetaWindow_finite) | theorem | reads ζ | `JensenCount` | (zetaWindow T).Finite |
| [`Stage3.zetaWindowTwo_finite`](./lean_stage3/JensenCount.md#Stage3-zetaWindowTwo_finite) | theorem | reads ζ | `JensenCount` | {ρ : ℂ \| ζ ρ = 0 ∧ ‖ρ - (2 + Complex.I * (T : ℂ))‖ ≤ 2}.Finite |
| [`FiniteOffLine.ZF`](./lean_stage3/FiniteOffLine.md#FiniteOffLine-ZF) | def | reads ζ | `FiniteOffLine` | Finset NontrivialZeros |
| [`PiRemainder.zinv`](./lean_stage3/PiRemainder.md#PiRemainder-zinv) | def | reads ζ | `PiRemainder` | ℝ |
| [`PiFixedRow.zinv_dyadic_le`](./lean_stage3/PiFixedRow.md#PiFixedRow-zinv_dyadic_le) | theorem | reads ζ | `PiFixedRow` | ∑ ρ ∈ ZF ((2 : ℝ) ^ (j + 1)), ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) * ‖(ρ : ℂ)‖⁻¹ ≤ Mlow * (3000 * ((j : ℝ) + 2) ^ 2) |
| [`PiRemainder.zinv_le_log`](./lean_stage3/PiRemainder.md#PiRemainder-zinv_le_log) | theorem | reads ζ | `PiRemainder` | zinv x ≤ Mlow * 39000 * Real.log x ^ 2 |
| [`PiRemainder.zinv_nonneg`](./lean_stage3/PiRemainder.md#PiRemainder-zinv_nonneg) | theorem | reads ζ | `PiRemainder` | 0 ≤ zinv T |
| [`Transform.zmap_functional_equation`](./lean/Transform.md#Transform-zmap_functional_equation) | theorem | shape | `Transform` | (b : ℂ) ^ (-((1 : ℂ) - s)) = (b : ℂ) ^ (-(1 : ℂ)) / (b : ℂ) ^ (-s) |
| [`Transform.zmap_ne_zero`](./lean/Transform.md#Transform-zmap_ne_zero) | theorem | shape | `Transform` | (b : ℂ) ^ (-s) ≠ 0 |
| [`Transform.zmap_pair_product`](./lean/Transform.md#Transform-zmap_pair_product) | theorem | shape | `Transform` | ‖(b : ℂ) ^ (-s)‖ * ‖(b : ℂ) ^ (-(1 - s))‖ = b ^ (-(1 : ℝ)) |
| [`Transform.zmap_period`](./lean/Transform.md#Transform-zmap_period) | theorem | shape | `Transform` | (b : ℂ) ^ (-(s + 2 * Real.pi * I / Real.log b)) = (b : ℂ) ^ (-s) |
| [`Transform.zmap_period_tau`](./lean/Transform.md#Transform-zmap_period_tau) | theorem | shape | `Transform` | (b : ℂ) ^ (-(s + (tau b : ℂ) * I)) = (b : ℂ) ^ (-s) |
| [`Transform.zmap_period_zsmul`](./lean/Transform.md#Transform-zmap_period_zsmul) | theorem | shape | `Transform` | (b : ℂ) ^ (-(s + (n : ℂ) * ((tau b : ℂ) * I))) = (b : ℂ) ^ (-s) |
| [`Transform.zmap_shift`](./lean/Transform.md#Transform-zmap_shift) | theorem | shape | `Transform` | (b : ℂ) ^ (-(s + 1)) = (b : ℂ) ^ (-s) / (b : ℂ) |
| [`Transform.zmap_shift_modulus`](./lean/Transform.md#Transform-zmap_shift_modulus) | theorem | shape | `Transform` | ‖(b : ℂ) ^ (-(s + n))‖ = ‖(b : ℂ) ^ (-s)‖ / b ^ n |
| [`LadderMean.zOf`](./lean_stage3/LadderMean.md#LadderMean-zOf) | def | reads ζ | `LadderMean` | ℂ |
| [`WeilPowerShell.zOf`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-zOf) | def | shape | `WeilPowerShell` | ℂ |
| [`WeilPowerShell.zOf_im`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-zOf_im) | theorem | shape | `WeilPowerShell` | (zOf e' D e).im = 4 * e' * D |
| [`WeilPowerShell.zOf_re`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-zOf_re) | theorem | shape | `WeilPowerShell` | (zOf e' D e).re = 2 * (e' ^ 2 - D ^ 2 - e ^ 2) |
| [`Stage3.zq`](./lean_stage3/Stirling.md#Stage3-zq) | def | shape | `Stirling` | ℂ |
| [`WeilPowerSelect.δSel`](./lean_stage3/WeilPowerSelect.md#WeilPowerSelect--Sel) | def | shape | `WeilPowerSelect` | ℝ |
| [`WeilPowerSelect.δSel_pos`](./lean_stage3/WeilPowerSelect.md#WeilPowerSelect--Sel_pos) | theorem | shape | `WeilPowerSelect` | 0 &lt; δSel K' lam h |
| [`RHPull.σRH`](./lean_stage3/LineBound.md#RHPull--RH) | def | shape | `LineBound` | ℝ |
| [`RHPull.σRH_re`](./lean_stage3/LineBound.md#RHPull--RH_re) | theorem | shape | `LineBound` | ((σRH X : ℂ) + I * (t : ℂ)).re = σRH X |
| [`Stage3.σθ`](./lean_stage3/Abscissa.md#Stage3---) | def | shape | `Abscissa` | ℝ |
| [`Stage3.σθ_half`](./lean_stage3/Abscissa.md#Stage3---_half) | theorem | shape | `Abscissa` | σθ (1/2) X = RHPull.σRH X |
| [`Stage3.σθ_lt_one`](./lean_stage3/ThetaPsi.md#Stage3---_lt_one) | theorem | shape | `ThetaPsi` | σθ θ X &lt; 1 |
| [`Stage3.σθ_re`](./lean_stage3/Abscissa.md#Stage3---_re) | theorem | shape | `Abscissa` | ((σθ θ X : ℂ) + I * (t : ℂ)).re = σθ θ X |
