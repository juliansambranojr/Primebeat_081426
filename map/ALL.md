# Every declaration, one line each

Sorted by name. Search this file before saying something is missing.

| name | kind | file | proves |
|---|---|---|---|
| [`WeilPowerBands.A`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-A) | def | `WeilPowerBands` | ℝ |
| [`WeilSeries.A`](./lean_stage3/WeilSeries.md#WeilSeries-A) | def | `WeilSeries` | ℝ |
| [`Chain.A1`](./lean/Chain.md#Chain-A1) | theorem | `Chain` | StmtA1 b ρ |
| [`Chain.A2`](./lean/Chain.md#Chain-A2) | theorem | `Chain` | StmtA2 |
| [`Chain.A3`](./lean/Chain.md#Chain-A3) | theorem | `Chain` | StmtA3 |
| [`Chain.A4`](./lean/Chain.md#Chain-A4) | theorem | `Chain` | StmtA4 b ρ |
| [`Chain.A4_of_A1`](./lean/Chain.md#Chain-A4_of_A1) | theorem | `Chain` | StmtA4 b ρ |
| [`Superposition.A4_sum_of_A1`](./lean/Superposition.md#Superposition-A4_sum_of_A1) | theorem | `Superposition` | ∀ (N : ℕ) (r : ℂ), (bdiff^[N]) (modeSum b ρ c s) r = ∑ i ∈ s, c i * (Sym b (ρ i)) ^ N * mode b (ρ i) r |
| [`WeilOnLine.A_le`](./lean_stage3/WeilOnLine.md#WeilOnLine-A_le) | theorem | `WeilOnLine` | A h γ ≤ 88 * (γ + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2) |
| [`WeilPowerBands.A_le`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-A_le) | theorem | `WeilPowerBands` | A h γ m ≤ 88 * (γ + r h m + 2) ^ 4 * (4 * h ^ 2 + cFarM m / h ^ 2) |
| [`WeilPowerBands.A_nonneg`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-A_nonneg) | theorem | `WeilPowerBands` | 0 ≤ A h γ m |
| [`WeilSeries.A_nonneg`](./lean_stage3/WeilSeries.md#WeilSeries-A_nonneg) | theorem | `WeilSeries` | 0 ≤ A h γ |
| [`Stage3.a_term_le`](./lean_stage3/Stirling.md#Stage3-a_term_le) | theorem | `Stirling` | \|(((n : ℂ) + zq t)⁻¹).re - (Real.log ‖((n + 1 : ℕ) : ℂ) + zq t‖ - Real.log ‖(n : ℂ) + zq t‖)\| ≤ 8 * ((((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹) |
| [`ArgLegs.abs_arg_sub_le_pi`](./lean_stage3/ArgLegs.md#ArgLegs-abs_arg_sub_le_pi) | theorem | `ArgLegs` | \|z.arg - w.arg\| ≤ Real.pi |
| [`LandauCrude.abs_G_le`](./lean_stage3/LandauCrude.md#LandauCrude-abs_G_le) | theorem | `LandauCrude` | \|LandauWindow.G y\| ≤ 2 * y * (1 + Real.log y) ^ 2 |
| [`LandauChebyshev.abs_G_le_log`](./lean_stage3/LandauChebyshev.md#LandauChebyshev-abs_G_le_log) | theorem | `LandauChebyshev` | \|LandauWindow.G y\| ≤ 8 * y * (1 + Real.log y) |
| [`LandauTrig.abs_le_sum_norm`](./lean_stage3/LandauTrig.md#LandauTrig-abs_le_sum_norm) | theorem | `LandauTrig` | \|T n\| ≤ ∑ j ∈ s, ‖c j‖ |
| [`Stage3.abs_mainterm_le`](./lean_stage3/ZeroSum.md#Stage3-abs_mainterm_le) | theorem | `ZeroSum` | \|zetaCountingMainTerm T\| ≤ T / (2 * Real.pi) * (Real.log T + 3) + 7 / 8 |
| [`Stage3.abs_pi_sub_Li_le`](./lean_stage3/PsiToPi.md#Stage3-abs_pi_sub_Li_le) | theorem | `PsiToPi` | \|(Nat.primeCounting ⌊x⌋₊ : ℝ) - Li x\| ≤ \|θ x - x\| / Real.log x + ∫ t in (2 : ℝ)..x, env t / (t * Real.log t ^ 2) |
| [`WeilPowerBackground.abs_q_le_one`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-abs_q_le_one) | theorem | `WeilPowerBackground` | \|q m x\| ≤ 1 |
| [`PerronKernel.abs_sub_one_le_two_abs_log`](./lean_stage3/PerronKernel.md#PerronKernel-abs_sub_one_le_two_abs_log) | theorem | `PerronKernel` | \|t - 1\| / 2 ≤ \|Real.log t\| |
| [`Stage3.abs_theta_sub_le_linear`](./lean_stage3/PsiToPi.md#Stage3-abs_theta_sub_le_linear) | theorem | `PsiToPi` | \|θ t - t\| ≤ (1 + Real.log 4) * t |
| [`Stage3.abscissa_gives_power`](./lean_stage3/Abscissa.md#Stage3-abscissa_gives_power) | theorem | `Abscissa` | K * X ^ (σθ θ X) = (Real.exp 1 * K) * X ^ θ |
| [`Stage3.add_zq_ne_zero`](./lean_stage3/Stirling.md#Stage3-add_zq_ne_zero) | theorem | `Stirling` | (n : ℂ) + zq t ≠ 0 |
| [`Measured.agreement_elliptic`](./lean/Measured.md#Measured-agreement_elliptic) | theorem | `Measured` | measured_elliptic_max_dev &lt; 1e-15 |
| [`Measured.agreement_offsets_match`](./lean/Measured.md#Measured-agreement_offsets_match) | theorem | `Measured` | \|measured_offset_smooth - measured_offset_resid\| &lt; 0.001 |
| [`Measured.agreement_radius_smooth`](./lean/Measured.md#Measured-agreement_radius_smooth) | theorem | `Measured` | \|measured_radius_smooth - 0.5 * (1 + measured_offset_smooth)\| &lt; 1e-9 |
| [`Measured.agreement_rank_11a1`](./lean/Measured.md#Measured-agreement_rank_11a1) | theorem | `Measured` | \|measured_rank_11a1 - predicted_rank_11a1\| &lt; 0.05 |
| [`Measured.agreement_rank_37a1`](./lean/Measured.md#Measured-agreement_rank_37a1) | theorem | `Measured` | \|measured_rank_37a1 - predicted_rank_37a1\| &lt; 0.3 |
| [`Measured.agreement_rank_389a1`](./lean/Measured.md#Measured-agreement_rank_389a1) | theorem | `Measured` | \|measured_rank_389a1 - predicted_rank_389a1\| &lt; 0.01 |
| [`Measured.agreement_weil_balance`](./lean/Measured.md#Measured-agreement_weil_balance) | theorem | `Measured` | \|measured_weil_arithmetic - measured_weil_spectral\| &lt; 1e-6 * measured_weil_arithmetic |
| [`Nyquist.Aliases`](./lean/Nyquist.md#Nyquist-Aliases) | def | `Nyquist` | Prop |
| [`Nyquist.aliases_of_offset`](./lean/Nyquist.md#Nyquist-aliases_of_offset) | theorem | `Nyquist` | Aliases b γ (γ - 2 * π * k / Real.log b) |
| [`ZeroCells.all_four_have_length_four`](./lean/ZeroCells.md#ZeroCells-all_four_have_length_four) | theorem | `ZeroCells` | Construction.measured_zeros.length = 4 ∧ SeedPerturbation.zero_cells.length = 4 ∧ PairIdentity.zero_cells.length = 4 ∧ Zeros.measured_zeros.length = 4 |
| [`ContourShift.analyticAt_conj_conj`](./lean_stage3/ContourShift.md#ContourShift-analyticAt_conj_conj) | theorem | `ContourShift` | AnalyticAt ℂ (fun w ↦ (starRingEnd ℂ) (g ((starRingEnd ℂ) w))) ((starRingEnd ℂ) p) |
| [`ContourShift.analyticAt_dslope`](./lean_stage3/ContourShift.md#ContourShift-analyticAt_dslope) | theorem | `ContourShift` | AnalyticAt ℂ (dslope f p) p |
| [`Stage3.analyticOrderNatAt_fun_comp_affine`](./lean_stage3/JensenCount.md#Stage3-analyticOrderNatAt_fun_comp_affine) | theorem | `JensenCount` | analyticOrderNatAt (fun w : ℂ =&gt; g (a * w + b)) z = analyticOrderNatAt g (a * z + b) |
| [`Stage3.anchor_mem_regionθ`](./lean_stage3/ThetaConverse.md#Stage3-anchor_mem_region-) | theorem | `ThetaConverse` | ((max θ 1 + 1 : ℝ) : ℂ) ∈ regionθ θ ∧ 1 &lt; ((max θ 1 + 1 : ℝ) : ℂ).re |
| [`Transform.annulus_modulus`](./lean/Transform.md#Transform-annulus_modulus) | theorem | `Transform` | Real.log (b ^ (-(1:ℝ)/2) / b ^ (-(1:ℝ))) / (2 * Real.pi) = Real.log b / (4 * Real.pi) |
| [`ReZetaCount.arg_ne_one`](./lean_stage3/ReZetaCount.md#ReZetaCount-arg_ne_one) | theorem | `ReZetaCount` | 2 * z + 2 + Complex.I * (T : ℂ) ≠ 1 ∧ 2 * z + 2 - Complex.I * (T : ℂ) ≠ 1 |
| [`Stage3.arg_sum_eq_pi`](./lean_stage3/ArgIdentity.md#Stage3-arg_sum_eq_pi) | theorem | `ArgIdentity` | Complex.arg ((1/2 : ℝ) + T * Complex.I) + Complex.arg ((-(1/2) : ℝ) + T * Complex.I) = Real.pi |
| [`Stage3.argCrude_of_pieces`](./lean_stage3/ArgCrude.md#Stage3-argCrude_of_pieces) | theorem | `ArgCrude` | StmtBacklundArg θ (a * A₁) (a * A₃ + b) |
| [`Stage3.argS`](./lean_stage3/ArgIdentity.md#Stage3-argS) | def | `ArgIdentity` | ℝ |
| [`Stage3.argS_eq_zetaArgContour`](./lean_stage3/ArgIdentity.md#Stage3-argS_eq_zetaArgContour) | theorem | `ArgIdentity` | argS T = zetaArgContour T |
| [`ArgCount.argS_le_gt_two`](./lean_stage3/ArgCount.md#ArgCount-argS_le_gt_two) | theorem | `ArgCount` | \|Stage3.argS T\| ≤ 15 * Real.log T + 75 |
| [`ArgCount.argS_le_of_good`](./lean_stage3/ArgCount.md#ArgCount-argS_le_of_good) | theorem | `ArgCount` | \|Stage3.argS T\| ≤ 15 * Real.log T + 73 + 3 / 2 |
| [`ArgCount.argS_two_le`](./lean_stage3/ArgCount.md#ArgCount-argS_two_le) | theorem | `ArgCount` | \|Stage3.argS 2\| ≤ 15 * Real.log 2 + 600 |
| [`Stage3.assembly_arith`](./lean_stage3/Assembly.md#Stage3-assembly_arith) | theorem | `Assembly` | A ≤ (9 * c₁ + c₂ + 28 + 16 * b₁ + 16 * b₂ + 8 * b₃ + 4 * W) * S * L ^ 2 |
| [`Crossover.at_most_one_crossover`](./lean/Crossover.md#Crossover-at_most_one_crossover) | theorem | `Crossover` | i = j |
| [`Expansion.B`](./lean/Expansion.md#Expansion-B) | def | `Expansion` | ℝ |
| [`WeilOnLine.B`](./lean_stage3/WeilOnLine.md#WeilOnLine-B) | def | `WeilOnLine` | ℝ |
| [`WeilPowerOnLine.B`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-B) | def | `WeilPowerOnLine` | ℝ |
| [`Chain.B4`](./lean/Chain.md#Chain-B4) | theorem | `Chain` | StmtB4 b N |
| [`Chain.B5`](./lean/Chain.md#Chain-B5) | theorem | `Chain` | StmtB5 b N |
| [`Chain.B5_of_A4_B4`](./lean/Chain.md#Chain-B5_of_A4_B4) | theorem | `Chain` | h b N ((1 : ℂ)/2 + γ * I) = ((‖(Sym b ((1 : ℂ)/2 + γ * I)) ^ N‖ ^ 2 : ℝ) : ℂ) |
| [`Expansion.B_bounds`](./lean/Expansion.md#Expansion-B_bounds) | theorem | `Expansion` | ∀ m k, k + m = d → 0 ≤ B d x k ∧ B d x k ≤ t d k x |
| [`Expansion.B_peel`](./lean/Expansion.md#Expansion-B_peel) | theorem | `Expansion` | B d x k = t d k x - B d x (k + 1) |
| [`Stage3.backlundArg_of_identity`](./lean_stage3/ArgCrude.md#Stage3-backlundArg_of_identity) | theorem | `ArgCrude` | StmtBacklundArg θ B₁ B₃ |
| [`Stage3.backlundArg_of_sFromLocal`](./lean_stage3/ArgIdentity.md#Stage3-backlundArg_of_sFromLocal) | theorem | `ArgIdentity` | StmtBacklundArg phaseTheta (a * A₁) (a * A₃ + b) |
| [`Stage3.backlundPhase_holds`](./lean_stage3/Stirling.md#Stage3-backlundPhase_holds) | theorem | `Stirling` | StmtBacklundPhase phaseTheta 97 98 |
| [`Stage3.backlundPhase_of_digammaLog`](./lean_stage3/Stirling.md#Stage3-backlundPhase_of_digammaLog) | theorem | `Stirling` | StmtBacklundPhase phaseTheta C (C + 1) |
| [`PairIdentity.backward_difference_pow`](./lean/PairIdentity.md#PairIdentity-backward_difference_pow) | theorem | `PairIdentity` | b ^ (r + 1) - b ^ r = (b - 1) * b ^ r |
| [`EdgeBound.ball_order_sum_le`](./lean_stage3/EdgeBound.md#EdgeBound-ball_order_sum_le) | theorem | `EdgeBound` | ∃ C : ℝ, 0 &lt; C ∧ ∀ T' : ℝ, 2 ≤ T' → (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, (analyticOrderNatAt gz w : ℝ)) ≤ C * Real.log T' |
| [`EdgeBound.ball_order_sum_le_num`](./lean_stage3/EdgeNum.md#EdgeBound-ball_order_sum_le_num) | theorem | `EdgeNum` | ∀ T' : ℝ, 2 ≤ T' → (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, (analyticOrderNatAt gz w : ℝ)) ≤ C2n * Real.log T' |
| [`EdgeBound.ball_zero_shape`](./lean_stage3/EdgeBound.md#EdgeBound-ball_zero_shape) | theorem | `EdgeBound` | riemannZeta w = 0 ∧ (0 &lt; w.re ∧ w.re &lt; 1) ∧ \|w.im - T'\| ≤ 46/25 |
| [`WeilBands.band_count`](./lean_stage3/WeilBands.md#WeilBands-band_count) | theorem | `WeilBands` | ∑ ρ ∈ S, (analyticOrderNatAt riemannZeta ρ : ℝ) ≤ 15 * Real.log T + 73 |
| [`Glue.band_order_sum_le`](./lean_stage3/Glue.md#Glue-band_order_sum_le) | theorem | `Glue` | ∃ C : ℝ, 0 &lt; C ∧ ∀ T : ℝ, 2 ≤ T → ∀ F : Finset ℂ, (∀ ρ ∈ F, riemannZeta ρ = 0 ∧ (0 &lt; ρ.re ∧ ρ.re &lt; 1) ∧ T ≤ \|ρ.im\| ∧ \|ρ.im\| ≤ T + 1) → (∑ ρ ∈ F, (analyticOrderNatAt riemannZeta ρ : ℝ)) ≤ C * Real.log … |
| [`Glue.band_order_sum_le_num`](./lean_stage3/GlueNum.md#Glue-band_order_sum_le_num) | theorem | `GlueNum` | ∀ T : ℝ, 2 ≤ T → ∀ F : Finset ℂ, (∀ ρ ∈ F, riemannZeta ρ = 0 ∧ (0 &lt; ρ.re ∧ ρ.re &lt; 1) ∧ T ≤ \|ρ.im\| ∧ \|ρ.im\| ≤ T + 1) → (∑ ρ ∈ F, (analyticOrderNatAt riemannZeta ρ : ℝ)) ≤ Csn * Real.log T |
| [`WeilBands.band_sum_le`](./lean_stage3/WeilBands.md#WeilBands-band_sum_le) | theorem | `WeilBands` | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ M * (15 * Real.log T + 73) |
| [`WeilPowerBands.band_sum_le`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-band_sum_le) | theorem | `WeilPowerBands` | ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ M * (15 * Real.log T + 73) |
| [`WeilPowerBands.bandSeries_le`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-bandSeries_le) | theorem | `WeilPowerBands` | ∑' k : ℕ, M h γ m k * (15 * Real.log (centre k) + 73) ≤ A h γ m * (Real.pi ^ 2 / 6) |
| [`WeilSeries.bandSeries_le`](./lean_stage3/WeilSeries.md#WeilSeries-bandSeries_le) | theorem | `WeilSeries` | ∑' k : ℕ, M h γ k * (15 * Real.log (centre k) + 73) ≤ A h γ * (Real.pi ^ 2 / 6) |
| [`WeilTiles.bandSeries_nonneg`](./lean_stage3/WeilTiles.md#WeilTiles-bandSeries_nonneg) | theorem | `WeilTiles` | 0 ≤ M k * (15 * Real.log (centre k) + 73) |
| [`WeilPowerBands.bandSeries_summable`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-bandSeries_summable) | theorem | `WeilPowerBands` | Summable (fun k : ℕ =&gt; M h γ m k * (15 * Real.log (centre k) + 73)) |
| [`WeilSeries.bandSeries_summable`](./lean_stage3/WeilSeries.md#WeilSeries-bandSeries_summable) | theorem | `WeilSeries` | Summable (fun k : ℕ =&gt; M h γ k * (15 * Real.log (centre k) + 73)) |
| [`WeilPowerBands.bandTerm_le_A`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-bandTerm_le_A) | theorem | `WeilPowerBands` | M h γ m k * (15 * Real.log (centre k) + 73) ≤ A h γ m / ((k : ℝ) + 1) ^ 3 |
| [`WeilSeries.bandTerm_le_A`](./lean_stage3/WeilSeries.md#WeilSeries-bandTerm_le_A) | theorem | `WeilSeries` | M h γ k * (15 * Real.log (centre k) + 73) ≤ A h γ / ((k : ℝ) + 1) ^ 3 |
| [`Nyquist.base_bound_of_resolvable`](./lean/Nyquist.md#Nyquist-base_bound_of_resolvable) | theorem | `Nyquist` | b ≤ Real.exp (π / γ) |
| [`PairIdentity.base_four_carries_factor`](./lean/PairIdentity.md#PairIdentity-base_four_carries_factor) | theorem | `PairIdentity` | ((4 : ℤ) - 1) ^ (d + 1) * 4 ^ e = 3 ^ (d + 1) * 4 ^ e |
| [`Zeros.base_of_meets_two`](./lean/ZerosStencil.md#Zeros-base_of_meets_two) | theorem | `ZerosStencil` | ∃ i, b = 2 ^ i |
| [`PairIdentity.base_three_carries_factor`](./lean/PairIdentity.md#PairIdentity-base_three_carries_factor) | theorem | `PairIdentity` | ((3 : ℤ) - 1) ^ (d + 1) * 3 ^ e = 2 ^ (d + 1) * 3 ^ e |
| [`Nyquist.base_two_fails_by_three`](./lean/Nyquist.md#Nyquist-base_two_fails_by_three) | theorem | `Nyquist` | 3 * nyquist 2 &lt; 14 |
| [`Nyquist.base_two_past_nyquist`](./lean/Nyquist.md#Nyquist-base_two_past_nyquist) | theorem | `Nyquist` | nyquist 2 &lt; γ |
| [`Chain.bdiff`](./lean/Chain.md#Chain-bdiff) | def | `Chain` | ℂ → ℂ |
| [`Elephant.bdiff`](./lean/Elephant.md#Elephant-bdiff) | def | `Elephant` | ℤ → ℂ |
| [`Elephant.bdiff_iter_mode`](./lean/Elephant.md#Elephant-bdiff_iter_mode) | theorem | `Elephant` | (bdiff^[d]) (mode b ρ) r = (Sym b ρ) ^ d * mode b ρ r |
| [`Elephant.bdiff_iter_modeSum`](./lean/Elephant.md#Elephant-bdiff_iter_modeSum) | theorem | `Elephant` | (bdiff^[d]) (fun r =&gt; ∑ i ∈ s, c i * mode b (ρ i) r) r = ∑ i ∈ s, c i * (Sym b (ρ i)) ^ d * mode b (ρ i) r |
| [`Elephant.bdiff_mode`](./lean/Elephant.md#Elephant-bdiff_mode) | theorem | `Elephant` | bdiff (mode b ρ) r = Sym b ρ * mode b ρ r |
| [`Chain.bdiff_smul`](./lean/Chain.md#Chain-bdiff_smul) | theorem | `Chain` | bdiff (fun r =&gt; k * f r) = fun r =&gt; k * bdiff f r |
| [`Superposition.bdiff_sum`](./lean/Superposition.md#Superposition-bdiff_sum) | theorem | `Superposition` | bdiff (fun r =&gt; ∑ i ∈ s, f i r) = fun r =&gt; ∑ i ∈ s, bdiff (f i) r |
| [`TransferOp.bdiffL`](./lean/TransferOp.md#TransferOp-bdiffL) | def | `TransferOp` | Module.End ℂ (ℂ → ℂ) |
| [`TransferOp.bdiffL_apply`](./lean/TransferOp.md#TransferOp-bdiffL_apply) | theorem | `TransferOp` | bdiffL f = bdiff f |
| [`MainTerm.bdiffR`](./lean/MainTerm.md#MainTerm-bdiffR) | def | `MainTerm` | ℝ → ℝ |
| [`MainTerm.bdiffR_lb`](./lean/MainTerm.md#MainTerm-bdiffR_lb) | theorem | `MainTerm` | m ≤ bdiffR g x |
| [`Nonvanishing.bdiffZ`](./lean/Nonvanishing.md#Nonvanishing-bdiffZ) | def | `Nonvanishing` | ℤ → ℝ |
| [`Covering.bench_is_selective`](./lean/Covering.md#Covering-bench_is_selective) | theorem | `Covering` | (0.2 : ℝ) &lt; 0.34657 |
| [`Covering.bench_selects`](./lean/Covering.md#Covering-bench_selects) | theorem | `Covering` | measured_contributing &lt; measured_in_support |
| [`WeilPowerClean.blocked_card_le`](./lean_stage3/WeilPowerClean.md#WeilPowerClean-blocked_card_le) | theorem | `WeilPowerClean` | B.card ≤ W + 1 |
| [`ContourShift.borderIntegrable_sum_poles`](./lean_stage3/ContourShift.md#ContourShift-borderIntegrable_sum_poles) | theorem | `ContourShift` | RectangleBorderIntegrable (fun s ↦ ∑ p ∈ P, A p / (s - p)) z w |
| [`LandauTaylor.bound_integrable`](./lean_stage3/LandauTaylor.md#LandauTaylor-bound_integrable) | theorem | `LandauTaylor` | IntegrableOn (fun y : ℝ =&gt; 8 * (Real.log y ^ k * y ^ (-a - 1) + Real.log y ^ (k + 1) * y ^ (-a - 1))) (Ioi 1) |
| [`SeedPerturbation.boundary_can_move`](./lean/SeedPerturbation.md#SeedPerturbation-boundary_can_move) | theorem | `SeedPerturbation` | tableFrom e r d ≠ 0 |
| [`NyquistPeak.boundary_is_smooth_stationary_maximum`](./lean/NyquistPeak.md#NyquistPeak-boundary_is_smooth_stationary_maximum) | theorem | `NyquistPeak` | Nyquist.nyquist (boundaryBase γ) = γ ∧ HasDerivAt (fun b : ℝ =&gt; gain d (γ * Real.log b)) 0 (boundaryBase γ) ∧ (∀ b : ℝ, gain d (γ * Real.log b) ≤ gain d (γ * Real.log (boundaryBase γ))) ∧ (∀ b : ℝ, \|R… |
| [`NyquistPeak.boundaryBase`](./lean/NyquistPeak.md#NyquistPeak-boundaryBase) | def | `NyquistPeak` | ℝ |
| [`NyquistPeak.boundaryBase_pos`](./lean/NyquistPeak.md#NyquistPeak-boundaryBase_pos) | theorem | `NyquistPeak` | 0 &lt; boundaryBase γ |
| [`WeilDetect.box_empty_of_positive_of_detect`](./lean_stage3/WeilDetect.md#WeilDetect-box_empty_of_positive_of_detect) | theorem | `WeilDetect` | OffLineBox ε T = ∅ |
| [`WeilPowerNear.bracket_nonneg`](./lean_stage3/WeilPowerNear.md#WeilPowerNear-bracket_nonneg) | theorem | `WeilPowerNear` | 0 ≤ (e' ^ 2 - D ^ 2) * Real.cos θ - 2 * e' * D * Real.sin θ |
| [`Stage3.bump`](./lean_stage3/ExplicitBump.md#Stage3-bump) | def | `ExplicitBump` | ℝ |
| [`Stage3.bump_contDiff`](./lean_stage3/ExplicitBump.md#Stage3-bump_contDiff) | theorem | `ExplicitBump` | ContDiff ℝ 1 bump |
| [`RHPull.bump_exists`](./lean_stage3/LineBound.md#RHPull-bump_exists) | theorem | `LineBound` | ∃ ν : ℝ → ℝ, ContDiff ℝ 1 ν ∧ (∀ x &gt; 0, 0 ≤ ν x) ∧ ν.support ⊆ Set.Icc (1/2 : ℝ) 2 ∧ ∫ x in Set.Ioi (0:ℝ), ν x / x = 1 |
| [`Stage3.bump_le`](./lean_stage3/ExplicitBump.md#Stage3-bump_le) | theorem | `ExplicitBump` | bump x ≤ bumpC * (9/16) ^ 2 |
| [`Stage3.bump_le_numeral`](./lean_stage3/ExplicitBump.md#Stage3-bump_le_numeral) | theorem | `ExplicitBump` | bump x ≤ 1.4757 |
| [`Stage3.bump_nonneg`](./lean_stage3/ExplicitBump.md#Stage3-bump_nonneg) | theorem | `ExplicitBump` | 0 ≤ bump x |
| [`Stage3.bump_support`](./lean_stage3/ExplicitBump.md#Stage3-bump_support) | theorem | `ExplicitBump` | Function.support bump ⊆ Set.Icc (1/2 : ℝ) 2 |
| [`Stage3.bumpC`](./lean_stage3/ExplicitBump.md#Stage3-bumpC) | def | `ExplicitBump` | ℝ |
| [`Stage3.bumpC_pos`](./lean_stage3/ExplicitBump.md#Stage3-bumpC_pos) | theorem | `ExplicitBump` | 0 &lt; bumpC |
| [`Stage3.bumpP`](./lean_stage3/ExplicitBump.md#Stage3-bumpP) | def | `ExplicitBump` | ℝ |
| [`Stage3.bumpP_le`](./lean_stage3/ExplicitBump.md#Stage3-bumpP_le) | theorem | `ExplicitBump` | bumpP x ≤ 9/16 |
| [`Stage3.bumpP_nonpos_of_ge`](./lean_stage3/ExplicitBump.md#Stage3-bumpP_nonpos_of_ge) | theorem | `ExplicitBump` | bumpP x ≤ 0 |
| [`Stage3.bumpP_nonpos_of_le`](./lean_stage3/ExplicitBump.md#Stage3-bumpP_nonpos_of_le) | theorem | `ExplicitBump` | bumpP x ≤ 0 |
| [`Expansion.c`](./lean/Expansion.md#Expansion-c) | def | `Expansion` | ℝ |
| [`WeilPower.c`](./lean_stage3/WeilPower.md#WeilPower-c) | def | `WeilPower` | ℝ |
| [`EdgeBound.c0`](./lean_stage3/EdgeBound.md#EdgeBound-c0) | def | `EdgeBound` | ℂ |
| [`EdgeBound.c0_im`](./lean_stage3/EdgeBound.md#EdgeBound-c0_im) | theorem | `EdgeBound` | (c0 T').im = T' |
| [`EdgeBound.c0_re`](./lean_stage3/EdgeBound.md#EdgeBound-c0_re) | theorem | `EdgeBound` | (c0 T').re = 3/2 |
| [`Chain.C1`](./lean/Chain.md#Chain-C1) | theorem | `Chain` | StmtC1 b |
| [`EdgeBound.C1n`](./lean_stage3/EdgeNum.md#EdgeBound-C1n) | def | `EdgeNum` | ℝ |
| [`Glue.c1n`](./lean_stage3/GlueNum.md#Glue-c1n) | def | `GlueNum` | ℝ |
| [`RouteNum.C1n_le`](./lean_stage3/RouteNum.md#RouteNum-C1n_le) | theorem | `RouteNum` | EdgeBound.C1n ≤ 1909224 |
| [`RouteNum.c1n_le`](./lean_stage3/RouteNum.md#RouteNum-c1n_le) | theorem | `RouteNum` | Glue.c1n ≤ 88216610000 |
| [`Glue.c1n_nonneg`](./lean_stage3/GlueNum.md#Glue-c1n_nonneg) | theorem | `GlueNum` | 0 ≤ c1n |
| [`EdgeBound.C1n_pos`](./lean_stage3/EdgeNum.md#EdgeBound-C1n_pos) | theorem | `EdgeNum` | 0 &lt; C1n |
| [`Chain.C2`](./lean/Chain.md#Chain-C2) | theorem | `Chain` | StmtC2 b |
| [`Chain.C2_ceiling_attained`](./lean/Chain.md#Chain-C2_ceiling_attained) | theorem | `Chain` | ∃ γ : ℝ, ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ 2 = (1 + b ^ (-(1:ℝ)/2)) ^ 2 |
| [`Chain.C2_floor_attained`](./lean/Chain.md#Chain-C2_floor_attained) | theorem | `Chain` | ‖Sym b ((1 : ℂ)/2 + (0 : ℝ) * I)‖ ^ 2 = (1 - b ^ (-(1:ℝ)/2)) ^ 2 |
| [`Chain.C2_of_C1`](./lean/Chain.md#Chain-C2_of_C1) | theorem | `Chain` | StmtC2 b |
| [`EdgeBound.C2n`](./lean_stage3/EdgeNum.md#EdgeBound-C2n) | def | `EdgeNum` | ℝ |
| [`RouteNum.C2n_le`](./lean_stage3/RouteNum.md#RouteNum-C2n_le) | theorem | `RouteNum` | EdgeBound.C2n ≤ 2167 |
| [`EdgeBound.C2n_pos`](./lean_stage3/EdgeNum.md#EdgeBound-C2n_pos) | theorem | `EdgeNum` | 0 &lt; C2n |
| [`Chain.C3`](./lean/Chain.md#Chain-C3) | theorem | `Chain` | StmtC3 b |
| [`Chain.C3_of_A4_C2`](./lean/Chain.md#Chain-C3_of_A4_C2) | theorem | `Chain` | StmtC3 b |
| [`Chain.C3lower`](./lean/Chain.md#Chain-C3lower) | theorem | `Chain` | StmtC3lower b |
| [`Chain.C3lower_of_A4_C2`](./lean/Chain.md#Chain-C3lower_of_A4_C2) | theorem | `Chain` | StmtC3lower b |
| [`Glue.c3n`](./lean_stage3/GlueNum.md#Glue-c3n) | def | `GlueNum` | ℝ |
| [`RouteNum.c3n_le`](./lean_stage3/RouteNum.md#RouteNum-c3n_le) | theorem | `RouteNum` | Glue.c3n ≤ 15 |
| [`Glue.c3n_nonneg`](./lean_stage3/GlueNum.md#Glue-c3n_nonneg) | theorem | `GlueNum` | 0 ≤ c3n |
| [`Glue.c4n`](./lean_stage3/GlueNum.md#Glue-c4n) | def | `GlueNum` | ℝ |
| [`RouteNum.c4n_le`](./lean_stage3/RouteNum.md#RouteNum-c4n_le) | theorem | `RouteNum` | Glue.c4n ≤ 6468930000 |
| [`Glue.c4n_nonneg`](./lean_stage3/GlueNum.md#Glue-c4n_nonneg) | theorem | `GlueNum` | 0 ≤ c4n |
| [`WeilPower.c_neg_one`](./lean_stage3/WeilPower.md#WeilPower-c_neg_one) | theorem | `WeilPower` | c (-1) = 0 |
| [`WeilPower.c_one`](./lean_stage3/WeilPower.md#WeilPower-c_one) | theorem | `WeilPower` | c 1 = 0 |
| [`WeilPower.c_pow_neg_one`](./lean_stage3/WeilPower.md#WeilPower-c_pow_neg_one) | theorem | `WeilPower` | c (-1) ^ n = 0 |
| [`WeilPower.c_pow_one`](./lean_stage3/WeilPower.md#WeilPower-c_pow_one) | theorem | `WeilPower` | c 1 ^ n = 0 |
| [`Expansion.c_rec`](./lean/Expansion.md#Expansion-c_rec) | theorem | `Expansion` | c (d + 1) j = Real.log 2 * c d j + (-(j : ℝ)) * c d (j - 1) |
| [`WeilPowerCount.card_le_of_leaf`](./lean_stage3/WeilPowerCount.md#WeilPowerCount-card_le_of_leaf) | theorem | `WeilPowerCount` | (S.card : ℝ) ≤ c₁ * Real.log T + c₂ |
| [`ReZetaCount.card_reZeros_le`](./lean_stage3/ReZetaCount.md#ReZetaCount-card_reZeros_le) | theorem | `ReZetaCount` | ((reZeros hT).card : ℝ) ≤ 15 * Real.log T + 73 |
| [`WeilPowerCompare.cE`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-cE) | def | `WeilPowerCompare` | ℝ |
| [`WeilPowerCompare.cE_le_cP`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-cE_le_cP) | theorem | `WeilPowerCompare` | cE m ≤ cP m |
| [`WeilPowerCompare.cE_pos`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-cE_pos) | theorem | `WeilPowerCompare` | 0 &lt; cE m |
| [`Chain.ceiling_base`](./lean/Chain.md#Chain-ceiling_base) | theorem | `Chain` | ‖Sym (Real.exp (Real.pi * (2 * k + 1) / γ)) ((1 : ℂ)/2 + γ * I)‖ ^ 2 = (1 + (Real.exp (Real.pi * (2 * k + 1) / γ)) ^ (-(1:ℝ)/2)) ^ 2 |
| [`Chain.ceiling_dominates_floor`](./lean/Chain.md#Chain-ceiling_dominates_floor) | theorem | `Chain` | (1 - b ^ (-(1:ℝ)/2)) ^ 2 &lt; (1 + b ^ (-(1:ℝ)/2)) ^ 2 |
| [`CellModes.cell_eq_modeSum`](./lean_stage3/CellModes.md#CellModes-cell_eq_modeSum) | theorem | `CellModes` | ‖CellZeros.stencil d (fun n : ℤ =&gt; (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r - Chain.Sym 2 1 ^ d * Chain.mode 2 1 (r : ℂ) + Superposition.modeSum 2 (fun ρ : {ρ : Kadiri.NontrivialZeros // \|(ρ : ℂ).im\| &lt; T} =… |
| [`SeedPerturbation.cell_eq_of_seed_perturbation`](./lean/SeedPerturbation.md#SeedPerturbation-cell_eq_of_seed_perturbation) | theorem | `SeedPerturbation` | tableFrom (fun x =&gt; N x - e x) r d = tableFrom N r d |
| [`CellZeros.cell_eq_zero_sum`](./lean_stage3/CellZeros.md#CellZeros-cell_eq_zero_sum) | theorem | `CellZeros` | ‖stencil d (fun n : ℤ =&gt; (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r - (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d + ∑' ρ : {ρ : Kadiri.NontrivialZeros // \|(ρ : ℂ).im\| &lt; T}, ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros)… |
| [`SeedPerturbation.cell_ne_at_boundary`](./lean/SeedPerturbation.md#SeedPerturbation-cell_ne_at_boundary) | theorem | `SeedPerturbation` | tableFrom (fun x =&gt; N x - e x) r d ≠ tableFrom N r d |
| [`TableDepths.cell_ne_zero_gen`](./lean_stage3/TableDepths.md#TableDepths-cell_ne_zero_gen) | theorem | `TableDepths` | Construction.tableFrom TableRoute.rowN r d ≠ 0 |
| [`TableRoute.cell_ne_zero_of_RH`](./lean_stage3/TableRoute.md#TableRoute-cell_ne_zero_of_RH) | theorem | `TableRoute` | Construction.tableFrom rowN r 6 ≠ 0 |
| [`RouteCell.cell_ne_zero_of_route`](./lean/RouteCell.md#RouteCell-cell_ne_zero_of_route) | theorem | `RouteCell` | Construction.tableFrom N r 6 ≠ 0 |
| [`EdgeBound.Cen`](./lean_stage3/EdgeNum.md#EdgeBound-Cen) | def | `EdgeNum` | ℝ |
| [`RouteNum.Cen_le`](./lean_stage3/RouteNum.md#RouteNum-Cen_le) | theorem | `RouteNum` | EdgeBound.Cen ≤ 1911393 |
| [`EdgeBound.Cen_pos`](./lean_stage3/EdgeNum.md#EdgeBound-Cen_pos) | theorem | `EdgeNum` | 0 &lt; Cen |
| [`WeilTiles.centre`](./lean_stage3/WeilTiles.md#WeilTiles-centre) | def | `WeilTiles` | ℝ |
| [`WeilSeries.cFar`](./lean_stage3/WeilSeries.md#WeilSeries-cFar) | def | `WeilSeries` | ℝ |
| [`WeilSeries.cFar_nonneg`](./lean_stage3/WeilSeries.md#WeilSeries-cFar_nonneg) | theorem | `WeilSeries` | 0 ≤ cFar |
| [`WeilPowerBands.cFarM`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-cFarM) | def | `WeilPowerBands` | ℝ |
| [`WeilPowerBands.cFarM_le`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-cFarM_le) | theorem | `WeilPowerBands` | cFarM m ≤ 1000 * ((m : ℝ) + 1) ^ 2 |
| [`WeilPowerBands.cFarM_nonneg`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-cFarM_nonneg) | theorem | `WeilPowerBands` | 0 ≤ cFarM m |
| [`Glue.Chn`](./lean_stage3/GlueNum.md#Glue-Chn) | def | `GlueNum` | ℝ |
| [`RouteNum.Chn_le`](./lean_stage3/RouteNum.md#RouteNum-Chn_le) | theorem | `RouteNum` | Glue.Chn ≤ 44108300000 |
| [`Glue.Chn_pos`](./lean_stage3/GlueNum.md#Glue-Chn_pos) | theorem | `GlueNum` | 0 &lt; Chn |
| [`Expansion.choose_factorial_step`](./lean/Expansion.md#Expansion-choose_factorial_step) | theorem | `Expansion` | d.choose (j + 1) * (j + 1).factorial = d.choose j * j.factorial * (d - j) |
| [`WeilPower.cK`](./lean_stage3/WeilPower.md#WeilPower-cK) | def | `WeilPower` | ℝ |
| [`WeilPower.cK_one`](./lean_stage3/WeilPower.md#WeilPower-cK_one) | theorem | `WeilPower` | cK 1 = Real.pi ^ 2 |
| [`WeilPower.cK_succ`](./lean_stage3/WeilPower.md#WeilPower-cK_succ) | theorem | `WeilPower` | cK (m + 1) = ((m : ℝ) + 1) * (2 * (m : ℝ) + 1) * Real.pi ^ 2 / 2 * cK m |
| [`PerronKernel.coarse_gt_ineq`](./lean_stage3/PerronKernel.md#PerronKernel-coarse_gt_ineq) | theorem | `PerronKernel` | v * Real.exp u + Real.pi - Real.arctan (v / u) ≤ Real.pi * Real.exp u |
| [`WeilPowerShell.coef`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-coef) | def | `WeilPowerShell` | ℂ |
| [`PairIdentity.coeff_eq_one_iff_base_two`](./lean/PairIdentity.md#PairIdentity-coeff_eq_one_iff_base_two) | theorem | `PairIdentity` | (b - 1) ^ (d + 1) = 1 ↔ b = 2 |
| [`WeilPowerCompare.compare_le`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-compare_le) | theorem | `WeilPowerCompare` | ‖S m w‖ ≤ (2 * (m : ℝ) + 3) * (‖w‖ / s) * Real.exp (Eup m w - Elow m s) * (S m (s : ℂ)).re |
| [`WeilPowerSharp.compare_sharp`](./lean_stage3/WeilPowerSharp.md#WeilPowerSharp-compare_sharp) | theorem | `WeilPowerSharp` | ‖S m w‖ ≤ ‖w‖ / s * Real.exp (((w ^ 2).re - s ^ 2) / (Real.pi ^ 2 * ((m : ℝ) + 1)) + s ^ 2 / (Real.pi ^ 2 * ((m : ℝ) + 1) * ((m : ℝ) + 2)) + (‖w‖ ^ 4 + s ^ 4) / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) * (S… |
| [`WeilPowerCompare.compare_suppressed`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-compare_suppressed) | theorem | `WeilPowerCompare` | ‖S m (wOf ε' Δ h)‖ ≤ (2 * (m : ℝ) + 3) * (‖wOf ε' Δ h‖ / (ε * h)) * Real.exp (rate m ε' Δ ε * h ^ 2 / 2) * (S m ((ε * h : ℝ) : ℂ)).re |
| [`Stage3.completed_eq_gammaR_mul_zeta`](./lean_stage3/ArgIdentity.md#Stage3-completed_eq_gammaR_mul_zeta) | theorem | `ArgIdentity` | completedRiemannZeta s = Gammaℝ s * riemannZeta s |
| [`Stage3.completed_eq_gammaR_mul_zeta'`](./lean_stage3/ArgIdentity.md#Stage3-completed_eq_gammaR_mul_zeta-) | theorem | `ArgIdentity` | completedRiemannZeta s = Gammaℝ s * riemannZeta s |
| [`Stage3.completedZeta₀_conj`](./lean_stage3/ArgIdentity.md#Stage3-completedZeta-_conj) | theorem | `ArgIdentity` | completedRiemannZeta₀ (conj s) = conj (completedRiemannZeta₀ s) |
| [`PairIdentity.composite_at_zero_20_6`](./lean/PairIdentity.md#PairIdentity-composite_at_zero_20_6) | theorem | `PairIdentity` | tableFrom C 20 6 = 8192 |
| [`PairIdentity.composite_of_prime_zero`](./lean/PairIdentity.md#PairIdentity-composite_of_prime_zero) | theorem | `PairIdentity` | tableFrom C r d = (b - 1) ^ (d + 1) * b ^ e |
| [`Propagation.cone_filled`](./lean/Propagation.md#Propagation-cone_filled) | theorem | `Propagation` | tableFrom (deltaRow s) (s + (k : ℤ)) d ≠ 0 |
| [`EulerFactorChain.conj_factor_on_critical_line`](./lean/EulerFactorChain.md#EulerFactorChain-conj_factor_on_critical_line) | theorem | `EulerFactorChain` | (starRingEnd ℂ) (1 - (b : ℂ) ^ (-((1 : ℂ)/2 + t * I))) = 1 - (b : ℂ) ^ (((1 : ℂ)/2 + t * I) - 1) |
| [`WeilOnLine.conj_mem`](./lean_stage3/WeilOnLine.md#WeilOnLine-conj_mem) | theorem | `WeilOnLine` | (starRingEnd ℂ) (ρ : ℂ) ∈ Kadiri.NontrivialZeros |
| [`Bridge.conj_paperFT_conj`](./lean_bridge/WeilBridge.md#Bridge-conj_paperFT_conj) | theorem | `WeilBridge` | conj (paperFT F (conj z)) = paperFT F (-z) |
| [`WeilOnLine.conjZ`](./lean_stage3/WeilOnLine.md#WeilOnLine-conjZ) | def | `WeilOnLine` | Kadiri.NontrivialZeros |
| [`WeilOnLine.conjZ_injective`](./lean_stage3/WeilOnLine.md#WeilOnLine-conjZ_injective) | theorem | `WeilOnLine` | Function.Injective conjZ |
| [`GeneratorPeak.const_of_eq`](./lean/GeneratorPeak.md#GeneratorPeak-const_of_eq) | theorem | `GeneratorPeak` | score R P α β i = score R P α β j |
| [`ZeroCells.construction_all_vanish`](./lean/ZeroCells.md#ZeroCells-construction_all_vanish) | theorem | `ZeroCells` | ∀ c ∈ Construction.measured_zeros, Construction.tableFrom Zeros.dyadicRow (c.1 : ℤ) c.2 = 0 |
| [`ZeroCells.construction_eq`](./lean/ZeroCells.md#ZeroCells-construction_eq) | theorem | `ZeroCells` | Construction.measured_zeros = Zeros.measured_zeros |
| [`MainTerm.contDiff_bdiffR`](./lean/MainTerm.md#MainTerm-contDiff_bdiffR) | theorem | `MainTerm` | ContDiff ℝ (⊤ : ℕ∞) (bdiffR g) |
| [`Bridge.contDiff_kOf`](./lean_bridge/WeilBridge.md#Bridge-contDiff_kOf) | theorem | `WeilBridge` | ContDiff ℝ 2 (kOf G) |
| [`Stage3.contDiff_one_indicator_Icc`](./lean_stage3/IndicatorContDiff.md#Stage3-contDiff_one_indicator_Icc) | theorem | `IndicatorContDiff` | ContDiff ℝ 1 (Set.indicator (Set.Icc a b) f) |
| [`Stage3.contDiff_sqPos`](./lean_stage3/ExplicitBump.md#Stage3-contDiff_sqPos) | theorem | `ExplicitBump` | ContDiff ℝ 1 (fun t : ℝ =&gt; (max 0 t) ^ 2) |
| [`Bridge.contDiff_tilde`](./lean_bridge/WeilBridge.md#Bridge-contDiff_tilde) | theorem | `WeilBridge` | ContDiff ℝ 1 (tilde g) |
| [`Bridge.contDiff_tiltF`](./lean_bridge/WeilBridge.md#Bridge-contDiff_tiltF) | theorem | `WeilBridge` | ContDiff ℝ 1 (tiltF G) |
| [`Bridge.contDiff_two_convolution`](./lean_bridge/WeilBridge.md#Bridge-contDiff_two_convolution) | theorem | `WeilBridge` | ContDiff ℝ 2 (f ⋆[ContinuousLinearMap.mul ℝ ℂ, volume] h) |
| [`WeilPower.continuous_c`](./lean_stage3/WeilPower.md#WeilPower-continuous_c) | theorem | `WeilPower` | Continuous c |
| [`WeilPower.continuous_f1`](./lean_stage3/WeilPower.md#WeilPower-continuous_f1) | theorem | `WeilPower` | Continuous (f1 k) |
| [`WeilPower.continuous_f2`](./lean_stage3/WeilPower.md#WeilPower-continuous_f2) | theorem | `WeilPower` | Continuous (f2 k) |
| [`WeilWindow.continuous_P`](./lean_stage3/WeilWindow.md#WeilWindow-continuous_P) | theorem | `WeilWindow` | Continuous P |
| [`Stage3.continuous_phasePoint`](./lean_stage3/Stirling.md#Stage3-continuous_phasePoint) | theorem | `Stirling` | Continuous phasePoint |
| [`WeilOddPower.continuous_q`](./lean_stage3/WeilOddPower.md#WeilOddPower-continuous_q) | theorem | `WeilOddPower` | Continuous (q m) |
| [`WeilLobe.continuous_q1`](./lean_stage3/WeilLobe.md#WeilLobe-continuous_q1) | theorem | `WeilLobe` | Continuous q1 |
| [`WeilLobe.continuous_q2`](./lean_stage3/WeilLobe.md#WeilLobe-continuous_q2) | theorem | `WeilLobe` | Continuous q2 |
| [`WeilWindow.continuous_x2P`](./lean_stage3/WeilWindow.md#WeilWindow-continuous_x2P) | theorem | `WeilWindow` | Continuous fun x : ℝ =&gt; x ^ 2 * P x |
| [`WeilTransform.continuous_xP`](./lean_stage3/WeilTransform.md#WeilTransform-continuous_xP) | theorem | `WeilTransform` | Continuous fun x : ℝ =&gt; x * P x |
| [`Stage3.continuousOn_exp_div`](./lean_stage3/RowLeaves.md#Stage3-continuousOn_exp_div) | theorem | `RowLeaves` | ContinuousOn (fun t : ℝ =&gt; Real.exp (Real.log 2 * t) / t) (Ioi 0) |
| [`Stage3.continuousOn_inv_log_sq`](./lean_stage3/PsiToPi.md#Stage3-continuousOn_inv_log_sq) | theorem | `PsiToPi` | ContinuousOn (fun t : ℝ =&gt; 1 / Real.log t ^ 2) (Set.uIcc a x) |
| [`Stage3.continuousOn_inv_log_sq_Ioi`](./lean_stage3/RowLeaves.md#Stage3-continuousOn_inv_log_sq_Ioi) | theorem | `RowLeaves` | ContinuousOn (fun t : ℝ =&gt; 1 / Real.log t ^ 2) (Ioi 1) |
| [`Stage3.continuousOn_inv_mul_log_sq`](./lean_stage3/PsiToPi.md#Stage3-continuousOn_inv_mul_log_sq) | theorem | `PsiToPi` | ContinuousOn (fun t : ℝ =&gt; (t * Real.log t ^ 2)⁻¹) (Set.uIcc a x) |
| [`RHPull.contour_at_instantiation`](./lean_stage3/LineBound.md#RHPull-contour_at_instantiation) | theorem | `LineBound` | ‖SmoothedChebyshev ν ε X - mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 * X‖ ≤ B₁ + B₉ + (66600 * Real.exp 1 * B / Real.pi) * Real.sqrt X * (Real.log X) ^ 3 + (1 / (2 * Real.pi)) * (1 / 2) * ((1996 * Real.l… |
| [`Stage3.contour_at_instantiation_theta`](./lean_stage3/ThetaPsi.md#Stage3-contour_at_instantiation_theta) | theorem | `ThetaPsi` | ‖SmoothedChebyshev ν ε X - mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 * X‖ ≤ B₁ + B₉ + (66600 * Real.exp 1 * B / Real.pi) * X ^ θ * (Real.log X) ^ 3 + (1 / (2 * Real.pi)) * (1 - θ) * ((1996 * Real.log (84… |
| [`LandauCriterion.contradiction`](./lean_stage3/LandauCriterion.md#LandauCriterion-contradiction) | theorem | `LandauCriterion` | False |
| [`WeilPowerNear.cos_ge_lin`](./lean_stage3/WeilPowerNear.md#WeilPowerNear-cos_ge_lin) | theorem | `WeilPowerNear` | 1 - 2 * θ / Real.pi ≤ Real.cos θ |
| [`Crossover.count_does_not_determine_spread`](./lean/Crossover.md#Crossover-count_does_not_determine_spread) | theorem | `Crossover` | (6.892378652639774e-07 : ℝ) &lt; 0.0736589 ∧ (0.0736589 : ℝ) / 6.892378652639774e-07 &gt; 100000 |
| [`WeilPowerCount.count_lt_shells`](./lean_stage3/WeilPowerCount.md#WeilPowerCount-count_lt_shells) | theorem | `WeilPowerCount` | N * (W + 1) &lt; K |
| [`Elephant.coupling_coeff`](./lean/Elephant.md#Elephant-coupling_coeff) | theorem | `Elephant` | ∑ k ∈ Finset.Icc 1 d, ((d.choose k : ℝ) * (-1) ^ k * vonMangoldt (b ^ k) * ((b : ℝ)⁻¹) ^ k) = -(vonMangoldt b) * (1 - (1 - (b : ℝ)⁻¹) ^ d) |
| [`Covering.covered`](./lean/Covering.md#Covering-covered) | def | `Covering` | Prop |
| [`Covering.covered_of_half_spacing`](./lean/Covering.md#Covering-covered_of_half_spacing) | theorem | `Covering` | covered L eps u |
| [`Covering.covered_smul`](./lean/Covering.md#Covering-covered_smul) | theorem | `Covering` | covered (c * L) (c * eps) (c * u) |
| [`Covering.covering_not_monotone`](./lean/Covering.md#Covering-covering_not_monotone) | theorem | `Covering` | ∃ (L eps u v : ℝ), 0 &lt; L ∧ u &lt; v ∧ ¬ covered L eps u ∧ covered L eps v |
| [`WeilPowerCompare.cP`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-cP) | def | `WeilPowerCompare` | ℝ |
| [`WeilPowerCompare.cP_pos`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-cP_pos) | theorem | `WeilPowerCompare` | 0 &lt; cP m |
| [`Glue.Cpn`](./lean_stage3/GlueNum.md#Glue-Cpn) | def | `GlueNum` | ℝ |
| [`RouteNum.Cpn_le`](./lean_stage3/RouteNum.md#RouteNum-Cpn_le) | theorem | `RouteNum` | Glue.Cpn ≤ 6534550000 |
| [`Glue.Cpn_pos`](./lean_stage3/GlueNum.md#Glue-Cpn_pos) | theorem | `GlueNum` | 0 &lt; Cpn |
| [`Elephant.cpow_neg_mul_lseries`](./lean/Elephant.md#Elephant-cpow_neg_mul_lseries) | theorem | `Elephant` | (b : ℂ) ^ (-s) * LSeries a s = LSeries (fun m =&gt; if b ∣ m then a (m / b) else 0) s |
| [`Elephant.cpow_neg_pow`](./lean/Elephant.md#Elephant-cpow_neg_pow) | theorem | `Elephant` | ((b : ℂ) ^ (-ρ)) ^ k = (b : ℂ) ^ (-((k : ℂ) * ρ)) |
| [`EulerFactorChain.cpow_rect_on_critical_line`](./lean/EulerFactorChain.md#EulerFactorChain-cpow_rect_on_critical_line) | theorem | `EulerFactorChain` | (b : ℂ) ^ (-((1 : ℂ)/2 + γ * I)) = ((b ^ (-(1:ℝ)/2) * Real.cos (γ * Real.log b) : ℝ) : ℂ) + ((-(b ^ (-(1:ℝ)/2) * Real.sin (γ * Real.log b)) : ℝ) : ℂ) * I |
| [`PerronKernel.cpow_sub_one_bound`](./lean_stage3/PerronKernel.md#PerronKernel-cpow_sub_one_bound) | theorem | `PerronKernel` | ‖(y : ℂ) ^ s - 1‖ ≤ ‖s‖ * Real.log y * y ^ s.re |
| [`CellZeros.cpow_two_zpow`](./lean_stage3/CellZeros.md#CellZeros-cpow_two_zpow) | theorem | `CellZeros` | (((2:ℝ) ^ n : ℝ) : ℂ) ^ ρ = ((2:ℂ) ^ ρ) ^ n |
| [`WeilPowerGauss.cprime_eq`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-cprime_eq) | theorem | `WeilPowerGauss` | cS m / D m = ((Nat.centralBinom (m + 1) : ℕ) : ℝ) / (Real.pi * ((m : ℝ) + 1) * 4 ^ m) |
| [`WeilPowerGauss.cprime_ge`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-cprime_ge) | theorem | `WeilPowerGauss` | 4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) ≤ cS m / D m |
| [`WeilPowerGauss.cprime_le`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-cprime_le) | theorem | `WeilPowerGauss` | cS m / D m ≤ 4 / (Real.pi * ((m : ℝ) + 1)) |
| [`WeilPowerGauss.cprime_pos`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-cprime_pos) | theorem | `WeilPowerGauss` | 0 &lt; cS m / D m |
| [`WeilPowerCompare.cQ`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-cQ) | def | `WeilPowerCompare` | ℝ |
| [`WeilPowerCompare.cQ_pos`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-cQ_pos) | theorem | `WeilPowerCompare` | 0 &lt; cQ m |
| [`Transform.critical_circle_is_lattice_inversion_mean`](./lean/Transform.md#Transform-critical_circle_is_lattice_inversion_mean) | theorem | `Transform` | ‖(b : ℂ) ^ (-s)‖ * ‖(b : ℂ) ^ (-(1 - s))‖ = (b ^ (-(1 : ℝ) / 2)) ^ 2 |
| [`WeilOddPower.cS`](./lean_stage3/WeilOddPower.md#WeilOddPower-cS) | def | `WeilOddPower` | ℝ |
| [`WeilOddPower.cS_eq`](./lean_stage3/WeilOddPower.md#WeilOddPower-cS_eq) | theorem | `WeilOddPower` | cS m * (((m : ℝ) + 1) * Real.pi) = 2 * cK (m + 1) |
| [`WeilPowerBands.cS_le`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-cS_le) | theorem | `WeilPowerBands` | cS m ≤ 4 * Real.pi ^ (2 * m + 1) * ((m : ℝ) + 1) ^ (2 * m + 1) |
| [`WeilPowerBounds.cS_pos`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-cS_pos) | theorem | `WeilPowerBounds` | 0 &lt; cS m |
| [`Glue.Csn`](./lean_stage3/GlueNum.md#Glue-Csn) | def | `GlueNum` | ℝ |
| [`RouteNum.Csn_le`](./lean_stage3/RouteNum.md#RouteNum-Csn_le) | theorem | `RouteNum` | Glue.Csn ≤ 1136 |
| [`Glue.Csn_pos`](./lean_stage3/GlueNum.md#Glue-Csn_pos) | theorem | `GlueNum` | 0 &lt; Csn |
| [`JointSymbol.cutG`](./lean_stage3/JointSymbol.md#JointSymbol-cutG) | def | `JointSymbol` | ℂ |
| [`WeilPowerGauss.D`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-D) | def | `WeilPowerGauss` | ℝ |
| [`JointLadder.d2`](./lean/JointLadder.md#JointLadder-d2) | def | `JointLadder` | ℤ → ℤ → ℂ |
| [`JointLadder.d2_d3_comm`](./lean/JointLadder.md#JointLadder-d2_d3_comm) | theorem | `JointLadder` | d2 (d3 f) = d3 (d2 f) |
| [`JointLadder.d2_iter_jmode`](./lean/JointLadder.md#JointLadder-d2_iter_jmode) | theorem | `JointLadder` | (d2^[a]) (jmode ρ) = fun r m =&gt; (Chain.Sym 2 ρ) ^ a * jmode ρ r m |
| [`JointLadder.d2_jmode`](./lean/JointLadder.md#JointLadder-d2_jmode) | theorem | `JointLadder` | d2 (jmode ρ) r m = Chain.Sym 2 ρ * jmode ρ r m |
| [`JointLadder.d3`](./lean/JointLadder.md#JointLadder-d3) | def | `JointLadder` | ℤ → ℤ → ℂ |
| [`JointLadder.d3_iter_jmode`](./lean/JointLadder.md#JointLadder-d3_iter_jmode) | theorem | `JointLadder` | (d3^[b]) (jmode ρ) = fun r m =&gt; (Chain.Sym 3 ρ) ^ b * jmode ρ r m |
| [`JointLadder.d3_jmode`](./lean/JointLadder.md#JointLadder-d3_jmode) | theorem | `JointLadder` | d3 (jmode ρ) r m = Chain.Sym 3 ρ * jmode ρ r m |
| [`WeilPowerGauss.D_eq`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-D_eq) | theorem | `WeilPowerGauss` | D m = Real.pi ^ (2 * (m + 1)) * (((m + 1).factorial : ℕ) : ℝ) ^ 2 |
| [`WeilPowerGauss.D_pos`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-D_pos) | theorem | `WeilPowerGauss` | 0 &lt; D m |
| [`JointSymbol.dd`](./lean_stage3/JointSymbol.md#JointSymbol-dd) | def | `JointSymbol` | ℝ → ℂ |
| [`JointSymbol.dd_iter_rule`](./lean_stage3/JointSymbol.md#JointSymbol-dd_iter_rule) | theorem | `JointSymbol` | (dd^[d + 1] f) y = (dd^[d] f) y - (dd^[d] f) (y / 2) |
| [`WeilPowerPhase.delta`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-delta) | def | `WeilPowerPhase` | ℂ |
| [`PerronKernel.delta_sum_close`](./lean_stage3/PerronKernel.md#PerronKernel-delta_sum_close) | theorem | `PerronKernel` | ‖(Chebyshev.psi x : ℂ) - ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronδ (x / n)‖ ≤ Real.log x |
| [`Propagation.deltaRow`](./lean/Propagation.md#Propagation-deltaRow) | def | `Propagation` | ℤ → ℤ |
| [`TableDepths.depth_eight`](./lean_stage3/TableDepths.md#TableDepths-depth_eight) | theorem | `TableDepths` | Construction.tableFrom TableRoute.rowN r 8 ≠ 0 |
| [`TableDepths.depth_five`](./lean_stage3/TableDepths.md#TableDepths-depth_five) | theorem | `TableDepths` | Construction.tableFrom TableRoute.rowN r 5 ≠ 0 |
| [`TableDepths.depth_four`](./lean_stage3/TableDepths.md#TableDepths-depth_four) | theorem | `TableDepths` | Construction.tableFrom TableRoute.rowN r 4 ≠ 0 |
| [`TableDepths.depth_one`](./lean_stage3/TableDepths.md#TableDepths-depth_one) | theorem | `TableDepths` | Construction.tableFrom TableRoute.rowN r 1 ≠ 0 |
| [`Superposition.depth_reweights_each_mode`](./lean/Superposition.md#Superposition-depth_reweights_each_mode) | theorem | `Superposition` | (bdiff^[N]) (modeSum b ρ c s) r = modeSum b ρ (fun i =&gt; c i * (Sym b (ρ i)) ^ N) s r |
| [`TableDepths.depth_seven`](./lean_stage3/TableDepths.md#TableDepths-depth_seven) | theorem | `TableDepths` | Construction.tableFrom TableRoute.rowN r 7 ≠ 0 |
| [`TableDepths.depth_six`](./lean_stage3/TableDepths.md#TableDepths-depth_six) | theorem | `TableDepths` | Construction.tableFrom TableRoute.rowN r 6 ≠ 0 |
| [`TableDepths.depth_three`](./lean_stage3/TableDepths.md#TableDepths-depth_three) | theorem | `TableDepths` | Construction.tableFrom TableRoute.rowN r 3 ≠ 0 |
| [`TableDepths.depth_two`](./lean_stage3/TableDepths.md#TableDepths-depth_two) | theorem | `TableDepths` | Construction.tableFrom TableRoute.rowN r 2 ≠ 0 |
| [`NyquistPeak.depth_zero_vacuous`](./lean/NyquistPeak.md#NyquistPeak-depth_zero_vacuous) | theorem | `NyquistPeak` | gain 0 θ = 1 |
| [`MainTerm.deriv_bdiffR`](./lean/MainTerm.md#MainTerm-deriv_bdiffR) | theorem | `MainTerm` | deriv (bdiffR g) = bdiffR (deriv g) |
| [`NyquistPeak.deriv_gain_pi`](./lean/NyquistPeak.md#NyquistPeak-deriv_gain_pi) | theorem | `NyquistPeak` | deriv (gain d) Real.pi = 0 |
| [`EdgeBound.deriv_zeta_conj`](./lean_stage3/EdgeBound.md#EdgeBound-deriv_zeta_conj) | theorem | `EdgeBound` | deriv riemannZeta ((starRingEnd ℂ) s) = (starRingEnd ℂ) (deriv riemannZeta s) |
| [`WeilPowerAssembly.detect_gap_exists`](./lean_stage3/WeilPowerAssembly.md#WeilPowerAssembly-detect_gap_exists) | theorem | `WeilPowerAssembly` | ∃ L : ℝ, StmtDetectGap ε T δ L |
| [`EulerFactorChain.diagonal_cell`](./lean/EulerFactorChain.md#EulerFactorChain-diagonal_cell) | theorem | `EulerFactorChain` | (b : ℂ) ^ (((d : ℂ) + c) * ρ) * (sym b ρ) ^ d = (b : ℂ) ^ ((c : ℂ) * ρ) * ((b : ℂ) ^ ρ - 1) ^ d |
| [`EulerFactorChain.diagonal_gain`](./lean/EulerFactorChain.md#EulerFactorChain-diagonal_gain) | theorem | `EulerFactorChain` | (b : ℂ) ^ ρ * sym b ρ = (b : ℂ) ^ ρ - 1 |
| [`EulerFactorChain.diagonal_over_column`](./lean/EulerFactorChain.md#EulerFactorChain-diagonal_over_column) | theorem | `EulerFactorChain` | ((b : ℂ) ^ ρ - 1) / sym b ρ = (b : ℂ) ^ ρ |
| [`EulerFactorChain.diagonal_over_column_at_half`](./lean/EulerFactorChain.md#EulerFactorChain-diagonal_over_column_at_half) | theorem | `EulerFactorChain` | (b : ℂ) ^ ((1 : ℂ) / 2) = (Real.sqrt b : ℂ) |
| [`Stage3.differentiable_xi`](./lean_stage3/ArgIdentity.md#Stage3-differentiable_xi) | theorem | `ArgIdentity` | Differentiable ℂ xi |
| [`Stage3.differentiableAt_gammaR`](./lean_stage3/ArgIdentity.md#Stage3-differentiableAt_gammaR) | theorem | `ArgIdentity` | DifferentiableAt ℂ Gammaℝ s |
| [`LandauPoleLocal.differentiableAt_Phi`](./lean_stage3/LandauPoleLocal.md#LandauPoleLocal-differentiableAt_Phi) | theorem | `LandauPoleLocal` | DifferentiableAt ℂ LandauMellinG.Phi s |
| [`Stage3.digamma_term_norm_le`](./lean_stage3/Stirling.md#Stage3-digamma_term_norm_le) | theorem | `Stirling` | ‖1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + z)‖ ≤ 4 / ((n : ℝ) + 1) ^ 2 |
| [`WeilSeries.dist_ge`](./lean_stage3/WeilSeries.md#WeilSeries-dist_ge) | theorem | `WeilSeries` | 9 / 5 * \|(idx t : ℝ) - (idx γ : ℝ)\| - 9 / 5 ≤ \|t - γ\| |
| [`ContourShift.div_sub_eq_dslope`](./lean_stage3/ContourShift.md#ContourShift-div_sub_eq_dslope) | theorem | `ContourShift` | f s / (s - p) = f p / (s - p) + dslope f p s |
| [`Glue.Dln`](./lean_stage3/GlueNum.md#Glue-Dln) | def | `GlueNum` | ℝ |
| [`RouteNum.Dln_le`](./lean_stage3/RouteNum.md#RouteNum-Dln_le) | theorem | `RouteNum` | Glue.Dln ≤ 89846200 |
| [`Glue.Dln_pos`](./lean_stage3/GlueNum.md#Glue-Dln_pos) | theorem | `GlueNum` | 0 &lt; Dln |
| [`Crossover.dominance_flips`](./lean/Crossover.md#Crossover-dominance_flips) | theorem | `Crossover` | ratio A B x y i &lt; 1 ∧ 1 &lt; ratio A B x y j |
| [`PerronKernel.dslope_kernel_diff`](./lean_stage3/PerronKernel.md#PerronKernel-dslope_kernel_diff) | theorem | `PerronKernel` | Differentiable ℂ (dslope (fun s : ℂ ↦ (y : ℂ) ^ s) 0) |
| [`Stage3.dyadic_abs_N_sum_le`](./lean_stage3/ZeroSum.md#Stage3-dyadic_abs_N_sum_le) | theorem | `ZeroSum` | (∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹ * \|riemannZeta.N ((2 : ℝ) ^ (j + 1))\|) ≤ Real.log 2 / (2 * Real.pi) * (K + 1) * (K + 2) + 3 * (K + 1) / Real.pi + 2 * (riemannZeta.RvM b₁ b₂ b₃ ((2 : ℝ) ^ (K + 1)… |
| [`JointLadder.dyadic_alias_resolved_jointly`](./lean/JointLadder.md#JointLadder-dyadic_alias_resolved_jointly) | theorem | `JointLadder` | ∃ γ' : ℝ, γ' ≠ γ ∧ Nyquist.Aliases 2 γ γ' ∧ ¬ JointAliases γ γ' |
| [`Zeros.dyadicRow`](./lean/Zeros.md#Zeros-dyadicRow) | def | `Zeros` | ℤ → ℤ |
| [`Isogeny.dyadicRow_eq_rowN`](./lean/Isogeny.md#Isogeny-dyadicRow_eq_rowN) | theorem | `Isogeny` | Zeros.dyadicRow ((r : ℤ) + 1) = rowN Zeros.pi2 1 r |
| [`VonKoch.E`](./lean_stage3/VonKochScaffold.md#VonKoch-E) | def | `VonKochScaffold` | ℝ |
| [`VonKoch.E_integral_eq_mellin`](./lean_stage3/VonKochScaffold.md#VonKoch-E_integral_eq_mellin) | theorem | `VonKochScaffold` | ∫ x in Set.Ioi (1:ℝ), (E x : ℂ) * (x : ℂ) ^ (-s - 1) = mellin Etr (-s) |
| [`VonKoch.E_le_linear`](./lean_stage3/VonKochScaffold.md#VonKoch-E_le_linear) | theorem | `VonKochScaffold` | ‖(E t : ℝ)‖ ≤ (Real.log 4 + 5) * t |
| [`EdgeBound.edge_bound_core`](./lean_stage3/EdgeBound.md#EdgeBound-edge_bound_core) | theorem | `EdgeBound` | ∃ C : ℝ, 0 &lt; C ∧ ∀ t : ℝ, 2 ≤ t → ∀ u : ℂ, u.im = t → -1/4 ≤ u.re → u.re ≤ 2 → riemannZeta u ≠ 0 → ∀ δ : ℝ, 0 &lt; δ → δ ≤ 1 → (∀ w ∈ (gz_zeros_ball_finite t (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, δ ≤ … |
| [`EdgeBound.edge_bound_core_num`](./lean_stage3/EdgeNum.md#EdgeBound-edge_bound_core_num) | theorem | `EdgeNum` | ∀ t : ℝ, 2 ≤ t → ∀ u : ℂ, u.im = t → -1/4 ≤ u.re → u.re ≤ 2 → riemannZeta u ≠ 0 → ∀ δ : ℝ, 0 &lt; δ → δ ≤ 1 → (∀ w ∈ (gz_zeros_ball_finite t (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, δ ≤ ‖u - w‖) → ‖deriv… |
| [`Glue.edge_horizontal_bound`](./lean_stage3/Glue.md#Glue-edge_horizontal_bound) | theorem | `Glue` | ∃ C : ℝ, 0 &lt; C ∧ ∀ x T T' : ℝ, 16 ≤ x → 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 &lt; ρ.re → ContourShift.zeroGap T ≤ \|ρ.im - T'\|) → ∀ y : ℝ, \|y\| = T' → ‖HIntegral (Gf x) (-1/4) (1 … |
| [`Glue.edge_horizontal_bound_num`](./lean_stage3/GlueNum.md#Glue-edge_horizontal_bound_num) | theorem | `GlueNum` | ∀ x T T' : ℝ, 16 ≤ x → 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 &lt; ρ.re → ContourShift.zeroGap T ≤ \|ρ.im - T'\|) → ∀ y : ℝ, \|y\| = T' → ‖HIntegral (Gf x) (-1/4) (1 + 1/Real.log x) y… |
| [`Glue.edge_left_bound`](./lean_stage3/Glue.md#Glue-edge_left_bound) | theorem | `Glue` | ∃ C : ℝ, 0 &lt; C ∧ ∀ x T' : ℝ, 16 ≤ x → 2 ≤ T' → T' ≤ 2*x^2 → ‖VIntegral (Gf x) (-1/4) (-T') T'‖ ≤ C * Real.log x |
| [`Glue.edge_left_sharp`](./lean_stage3/GlueFloor.md#Glue-edge_left_sharp) | theorem | `GlueFloor` | ∃ D : ℝ, 0 &lt; D ∧ ∀ x T' : ℝ, 16 ≤ x → 2 ≤ T' → T' ≤ 2*x^2 → ‖VIntegral (Gf x) (-1/4) (-T') T'‖ ≤ 72 * D * ((Real.log x)^2 * x ^ (-(1:ℝ)/4)) |
| [`Glue.edge_left_sharp_num`](./lean_stage3/GlueNum.md#Glue-edge_left_sharp_num) | theorem | `GlueNum` | ∀ x T' : ℝ, 16 ≤ x → 2 ≤ T' → T' ≤ 2*x^2 → ‖VIntegral (Gf x) (-1/4) (-T') T'‖ ≤ 72 * Dln * ((Real.log x)^2 * x ^ (-(1:ℝ)/4)) |
| [`Nonvanishing.Ehigh`](./lean/Nonvanishing.md#Nonvanishing-Ehigh) | def | `Nonvanishing` | ℝ |
| [`RelativeGate.EhighRel`](./lean/RelativeGate.md#RelativeGate-EhighRel) | def | `RelativeGate` | ℝ |
| [`TransferOp.eigenvalue_zero_iff_lattice`](./lean/TransferOp.md#TransferOp-eigenvalue_zero_iff_lattice) | theorem | `TransferOp` | bdiffL (mode b ρ) = 0 ↔ ∃ k : ℤ, ρ = (k : ℂ) * (2 * Real.pi * I / Real.log b) |
| [`Stage3.elem_fold_eq_pi`](./lean_stage3/ArgIdentity.md#Stage3-elem_fold_eq_pi) | theorem | `ArgIdentity` | (∫ t in (0:ℝ)..T, elemLD (2 + (t : ℂ) * Complex.I)).re - (∫ x in (1/2:ℝ)..2, elemLD ((x : ℂ) + T * Complex.I)).im = Real.pi |
| [`Stage3.elemLD`](./lean_stage3/ArgIdentity.md#Stage3-elemLD) | def | `ArgIdentity` | ℂ |
| [`WeilPowerCompare.Elow`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-Elow) | def | `WeilPowerCompare` | ℝ |
| [`ZetaGrowth.emA`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-emA) | def | `ZetaGrowth` | ℝ |
| [`ZetaGrowth.emA_eq_poly`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-emA_eq_poly) | theorem | `ZetaGrowth` | emA x = ((x - n) - (x - n)^2)/2 |
| [`ZetaGrowth.emA_le`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-emA_le) | theorem | `ZetaGrowth` | emA x ≤ 1/8 |
| [`ZetaGrowth.emA_natCast`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-emA_natCast) | theorem | `ZetaGrowth` | emA n = 0 |
| [`ZetaGrowth.emA_nonneg`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-emA_nonneg) | theorem | `ZetaGrowth` | 0 ≤ emA x |
| [`SeedPerturbation.emptied_excess`](./lean/SeedPerturbation.md#SeedPerturbation-emptied_excess) | def | `SeedPerturbation` | ℤ → ℤ |
| [`SeedPerturbation.emptied_protected_cells_fixed`](./lean/SeedPerturbation.md#SeedPerturbation-emptied_protected_cells_fixed) | theorem | `SeedPerturbation` | tableFrom (fun x =&gt; N x - emptied_excess x) 4 1 = tableFrom N 4 1 ∧ tableFrom (fun x =&gt; N x - emptied_excess x) 8 3 = tableFrom N 8 3 ∧ tableFrom (fun x =&gt; N x - emptied_excess x) 20 6 = tableFrom N 2… |
| [`SeedPerturbation.emptied_vanishes_above_two`](./lean/SeedPerturbation.md#SeedPerturbation-emptied_vanishes_above_two) | theorem | `SeedPerturbation` | ∀ s : ℤ, 2 &lt; s → emptied_excess s = 0 |
| [`RHPull.eps_choice_ok`](./lean_stage3/LineBound.md#RHPull-eps_choice_ok) | theorem | `LineBound` | c * (Real.sqrt X)⁻¹ * X * Real.log X ≤ c * Real.sqrt X * (Real.log X) ^ 3 |
| [`Construction.eq_of_same_row`](./lean/Construction.md#Construction-eq_of_same_row) | theorem | `Construction` | ∀ r d, f r d = g r d |
| [`Nonvanishing.error_bound`](./lean/Nonvanishing.md#Nonvanishing-error_bound) | theorem | `Nonvanishing` | \|stencilR n (fun x =&gt; f x - L x) r\| ≤ Ehigh r n |
| [`VonKoch.Etr`](./lean_stage3/VonKochScaffold.md#VonKoch-Etr) | def | `VonKochScaffold` | ℝ → ℂ |
| [`VonKoch.Etr_locallyIntegrable`](./lean_stage3/VonKochScaffold.md#VonKoch-Etr_locallyIntegrable) | theorem | `VonKochScaffold` | MeasureTheory.LocallyIntegrableOn Etr (Set.Ioi 0) |
| [`VonKoch.Etr_measurable`](./lean_stage3/VonKochScaffold.md#VonKoch-Etr_measurable) | theorem | `VonKochScaffold` | Measurable Etr |
| [`EulerFactorChain.euler_product_riemannZeta`](./lean/EulerFactorChain.md#EulerFactorChain-euler_product_riemannZeta) | theorem | `EulerFactorChain` | ∏' p : Nat.Primes, (1 - (p : ℂ) ^ (-s))⁻¹ = riemannZeta s |
| [`EulerFactorChain.euler_product_sym`](./lean/EulerFactorChain.md#EulerFactorChain-euler_product_sym) | theorem | `EulerFactorChain` | ∏' p : Nat.Primes, (sym ((p : ℕ) : ℝ) s)⁻¹ = riemannZeta s |
| [`WeilPowerGauss.euler_sinh`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-euler_sinh) | theorem | `WeilPowerGauss` | Tendsto (fun n : ℕ =&gt; w * ∏ j ∈ Finset.range n, g w j) atTop (𝓝 (Complex.sinh w)) |
| [`WeilPowerCompare.Eup`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-Eup) | def | `WeilPowerCompare` | ℝ |
| [`LandauRates.exists_centre`](./lean_stage3/LandauRates.md#LandauRates-exists_centre) | theorem | `LandauRates` | ∃ σ₀ : ℝ, 1 &lt; σ₀ ∧ ‖(σ₀ : ℂ) - ρ₀‖ &lt; σ₀ - θ ∧ ‖(σ₀ : ℂ) - ρ₀‖ ≤ (σ₀ - 1) * (1 + δ ^ 2 / 240) |
| [`WeilPowerClean.exists_clean_shell`](./lean_stage3/WeilPowerClean.md#WeilPowerClean-exists_clean_shell) | theorem | `WeilPowerClean` | ∃ k, k &lt; K ∧ ∀ j ∈ S, k ∉ B j |
| [`WeilPowerClean.exists_clean_shell_of_count`](./lean_stage3/WeilPowerClean.md#WeilPowerClean-exists_clean_shell_of_count) | theorem | `WeilPowerClean` | ∃ k, k &lt; K ∧ ∀ j ∈ S, k ∉ B j |
| [`WeilPowerCount.exists_clean_shell_of_leaf`](./lean_stage3/WeilPowerCount.md#WeilPowerCount-exists_clean_shell_of_leaf) | theorem | `WeilPowerCount` | ∃ k, k &lt; K ∧ ∀ j ∈ S, k ∉ B j |
| [`LandauPoleSub.exists_differentiableOn_sub_poles`](./lean_stage3/LandauPoleSub.md#LandauPoleSub-exists_differentiableOn_sub_poles) | theorem | `LandauPoleSub` | ∃ g : ℂ → ℂ, DifferentiableOn ℂ g U ∧ ∀ s, s ∉ P → g s = f s - ∑ q ∈ P, A q / (s - q) |
| [`JointLadder.exists_dyadic_alias_ne`](./lean/JointLadder.md#JointLadder-exists_dyadic_alias_ne) | theorem | `JointLadder` | ∃ γ' : ℝ, γ' ≠ γ ∧ Nyquist.Aliases 2 γ γ' |
| [`LandauZeroSide.exists_gap`](./lean_stage3/LandauZeroSide.md#LandauZeroSide-exists_gap) | theorem | `LandauZeroSide` | ∃ R₂ : ℝ, r &lt; R₂ ∧ R₂ ≤ R₃ ∧ ∀ ρ ∈ F, ‖c - ρ‖ &lt; R₂ → ‖c - ρ‖ ≤ r |
| [`ArgCount.exists_good_below`](./lean_stage3/ArgCount.md#ArgCount-exists_good_below) | theorem | `ArgCount` | ∃ T : ℝ, a &lt; T ∧ T &lt; T₀ ∧ good T ∧ ∀ ρ : ℂ, riemannZeta ρ = 0 → ρ.im ∈ Set.Ico T T₀ → False |
| [`LandauTrig.exists_large_in_block`](./lean_stage3/LandauTrig.md#LandauTrig-exists_large_in_block) | theorem | `LandauTrig` | ∃ τ : ℝ, 0 &lt; τ ∧ ∃ N₀ : ℕ, ∀ a N : ℕ, N₀ ≤ N → ∃ n ∈ Finset.Ico a (a + N), τ ≤ T n |
| [`Covering.exists_near_lattice`](./lean/Covering.md#Covering-exists_near_lattice) | theorem | `Covering` | ∃ n : ℤ, \|u - n * L\| ≤ L / 2 |
| [`LandauRates.exists_pow_small`](./lean_stage3/LandauRates.md#LandauRates-exists_pow_small) | theorem | `LandauRates` | ∃ K : ℕ, ∀ k : ℕ, K ≤ k → c * q ^ k &lt; ε |
| [`WeilPowerCount.exists_range_log`](./lean_stage3/WeilPowerCount.md#WeilPowerCount-exists_range_log) | theorem | `WeilPowerCount` | ∃ L : ℝ, 0 ≤ L ∧ ∀ M : ℝ, 0 ≤ M → M ≤ D + L → (c₁ * M + c₂) * ((W : ℝ) + 1) * lρ + E ≤ L |
| [`WeilPowerSelect.exists_step_le`](./lean_stage3/WeilPowerSelect.md#WeilPowerSelect-exists_step_le) | theorem | `WeilPowerSelect` | ∃ k &lt; N, f (k + 1) ≤ f k + δ |
| [`WeilPowerSelect.exists_target_step`](./lean_stage3/WeilPowerSelect.md#WeilPowerSelect-exists_target_step) | theorem | `WeilPowerSelect` | ∃ k : ℕ, (k : ℝ) ≤ h / (4 * K' * Real.pi ^ 2 * lam) ∧ (E (k + 1)) ^ 2 ≤ (E k) ^ 2 + δSel K' lam h |
| [`WeilPowerClean.exists_unblocked`](./lean_stage3/WeilPowerClean.md#WeilPowerClean-exists_unblocked) | theorem | `WeilPowerClean` | ∃ k, k &lt; K ∧ ∀ j ∈ S, k ∉ B j |
| [`WeilPowerShell.exp_end_le`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-exp_end_le) | theorem | `WeilPowerShell` | Real.exp ((zOf e' D e).re * (1 / ((lam : ℝ) * Real.pi ^ 2) * (k : ℝ) + -1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2))) ≤ Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) |
| [`Expansion.exp_eq_rpow`](./lean/Expansion.md#Expansion-exp_eq_rpow) | theorem | `Expansion` | Real.exp (Real.log 2 * x) = (2 : ℝ) ^ x |
| [`WeilPowerGauss.exp_le_one_add`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-exp_le_one_add) | theorem | `WeilPowerGauss` | Real.exp (x - x ^ 2) ≤ 1 + x |
| [`WeilPowerGeom.exp_lin_le_Mab`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-exp_lin_le_Mab) | theorem | `WeilPowerGeom` | Real.exp (z.re * ((m : ℝ) + 1 / 2) / Real.pi ^ 2) ≤ Mab z a b |
| [`WeilPowerGeomGen.exp_lin_le_MabGen`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-exp_lin_le_MabGen) | theorem | `WeilPowerGeomGen` | Real.exp (z.re * (α * (h : ℝ) + β₀)) ≤ MabGen z α β₀ a b |
| [`WeilPowerGeom.exp_shift`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-exp_shift) | theorem | `WeilPowerGeom` | Complex.exp (z * ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2) = Complex.exp (z / (2 * (Real.pi : ℂ) ^ 2)) * Complex.exp (z / (Real.pi : ℂ) ^ 2) ^ m |
| [`WeilPowerGeomGen.exp_shift_gen`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-exp_shift_gen) | theorem | `WeilPowerGeomGen` | Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ)) = Complex.exp (z * ((β₀ : ℝ) : ℂ)) * Complex.exp (z * ((α : ℝ) : ℂ)) ^ h |
| [`PerronKernel.explicit_formula_perron`](./lean_stage3/PerronKernel.md#PerronKernel-explicit_formula_perron) | theorem | `PerronKernel` | ‖(Chebyshev.psi x : ℂ) - (2 * (Real.pi:ℂ) * Complex.I)⁻¹ * ∫ t in (-T)..T, (- deriv riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t) / riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t))… |
| [`Glue.explicit_formula_poly`](./lean_stage3/Glue.md#Glue-explicit_formula_poly) | theorem | `Glue` | ∃ c₁ c₂ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₂ ∧ ∀ x T : ℝ, 16 ≤ x → 2 ≤ T → T ≤ x^2 → ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖ ≤ c₁ * x * Real.log (x*T)^2 / T + c₂ * Real.log x |
| [`Glue.explicit_formula_split`](./lean_stage3/GlueFloor.md#Glue-explicit_formula_split) | theorem | `GlueFloor` | ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ ∀ x T : ℝ, 16 ≤ x → 2 ≤ T → T ≤ x^2 → ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖ ≤ c₁ * x * Real.log (x*T)^2 / T + c₃ * Real.log x + c₄ * ((… |
| [`Glue.explicit_formula_split_num`](./lean_stage3/GlueNum.md#Glue-explicit_formula_split_num) | theorem | `GlueNum` | ∀ x T : ℝ, 16 ≤ x → 2 ≤ T → T ≤ x^2 → ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖ ≤ c1n * x * Real.log (x*T)^2 / T + c3n * Real.log x + c4n * ((Real.log x)^2 * x ^ (-(1:ℝ)/4)) |
| [`PairIdentity.exponent_const_on_diagonal`](./lean/PairIdentity.md#PairIdentity-exponent_const_on_diagonal) | theorem | `PairIdentity` | e₁ = e₂ |
| [`WeilPowerCompare.exponent_eq`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-exponent_eq) | theorem | `WeilPowerCompare` | Eup m (wOf ε' Δ h) - Elow m (ε * h) = rate m ε' Δ ε * h ^ 2 + qerr m ε' Δ ε * h ^ 4 |
| [`Expansion.F`](./lean/Expansion.md#Expansion-F) | def | `Expansion` | ℝ |
| [`Interpolant.F`](./lean/Interpolant.md#Interpolant-F) | def | `Interpolant` | ℝ |
| [`ReZetaCount.F`](./lean_stage3/ReZetaCount.md#ReZetaCount-F) | def | `ReZetaCount` | ℂ |
| [`VonKoch.F`](./lean_stage3/VonKochScaffold.md#VonKoch-F) | def | `VonKochScaffold` | ℂ |
| [`WeilPower.f1`](./lean_stage3/WeilPower.md#WeilPower-f1) | def | `WeilPower` | ℝ |
| [`WeilPower.f1_neg_one`](./lean_stage3/WeilPower.md#WeilPower-f1_neg_one) | theorem | `WeilPower` | f1 (k + 1) (-1) = 0 |
| [`WeilPower.f1_one`](./lean_stage3/WeilPower.md#WeilPower-f1_one) | theorem | `WeilPower` | f1 (k + 1) 1 = 0 |
| [`WeilPower.f2`](./lean_stage3/WeilPower.md#WeilPower-f2) | def | `WeilPower` | ℝ |
| [`Expansion.f2x`](./lean/Expansion.md#Expansion-f2x) | def | `Expansion` | ℝ |
| [`Interpolant.f2x_contDiffOn`](./lean/Interpolant.md#Interpolant-f2x_contDiffOn) | theorem | `Interpolant` | ContDiffOn ℝ (⊤ : ℕ∞) Expansion.f2x (Ioi 0) |
| [`Interpolant.f2x_continuousOn`](./lean/Interpolant.md#Interpolant-f2x_continuousOn) | theorem | `Interpolant` | ContinuousOn Expansion.f2x (Ioi 0) |
| [`ReZetaCount.F_analytic`](./lean_stage3/ReZetaCount.md#ReZetaCount-F_analytic) | theorem | `ReZetaCount` | AnalyticOnNhd ℂ (F T) (Metric.closedBall (0 : ℂ) 1) |
| [`VonKoch.F_analyticOnNhd`](./lean_stage3/VonKochScaffold.md#VonKoch-F_analyticOnNhd) | theorem | `VonKochScaffold` | AnalyticOnNhd ℂ F region |
| [`Stage3.F_analyticOnNhd_theta`](./lean_stage3/ThetaConverse.md#Stage3-F_analyticOnNhd_theta) | theorem | `ThetaConverse` | AnalyticOnNhd ℂ VonKoch.F (regionθ θ) |
| [`ReZetaCount.F_bound`](./lean_stage3/ReZetaCount.md#ReZetaCount-F_bound) | theorem | `ReZetaCount` | ‖F T z‖ ≤ 80 * T |
| [`Interpolant.F_contDiffOn`](./lean/Interpolant.md#Interpolant-F_contDiffOn) | theorem | `Interpolant` | ContDiffOn ℝ (⊤ : ℕ∞) F (Ioi 0) |
| [`ReZetaCount.F_count_le`](./lean_stage3/ReZetaCount.md#ReZetaCount-F_count_le) | theorem | `ReZetaCount` | ∑ ρ ∈ (finiteSetOfZeros_mono (by norm_num : (7:ℝ)/8 &lt; 1) (F_zeros_finite hT)).toFinset, (analyticOrderNatAt (F T) ρ : ℝ) ≤ 15 * Real.log T + 73 |
| [`VonKoch.F_differentiableAt`](./lean_stage3/VonKochScaffold.md#VonKoch-F_differentiableAt) | theorem | `VonKochScaffold` | DifferentiableAt ℂ F s |
| [`Stage3.F_differentiableAt_theta`](./lean_stage3/ThetaConverse.md#Stage3-F_differentiableAt_theta) | theorem | `ThetaConverse` | DifferentiableAt ℂ VonKoch.F s |
| [`VonKoch.F_eq_neg_logDeriv`](./lean_stage3/VonKochScaffold.md#VonKoch-F_eq_neg_logDeriv) | theorem | `VonKochScaffold` | F s = -deriv riemannZeta s / riemannZeta s |
| [`VonKoch.F_eq_neg_logDeriv_ext`](./lean_stage3/VonKochScaffold.md#VonKoch-F_eq_neg_logDeriv_ext) | theorem | `VonKochScaffold` | F s = -deriv riemannZeta s / riemannZeta s |
| [`Expansion.F_floor`](./lean/Expansion.md#Expansion-F_floor) | theorem | `Expansion` | (2 : ℝ) ^ x * (Real.log 2 ^ d / (2 * x)) ≤ F d x |
| [`Interpolant.F_hasDerivAt`](./lean/Interpolant.md#Interpolant-F_hasDerivAt) | theorem | `Interpolant` | HasDerivAt F (Expansion.f2x x) x |
| [`VonKoch.F_mul_zeta_add_deriv_eqOn_zero`](./lean_stage3/VonKochScaffold.md#VonKoch-F_mul_zeta_add_deriv_eqOn_zero) | theorem | `VonKochScaffold` | Set.EqOn (fun s : ℂ ↦ F s * riemannZeta s + deriv riemannZeta s) 0 region |
| [`Stage3.F_mul_zeta_add_deriv_eqOn_zero_theta`](./lean_stage3/ThetaConverse.md#Stage3-F_mul_zeta_add_deriv_eqOn_zero_theta) | theorem | `ThetaConverse` | Set.EqOn (fun s : ℂ ↦ VonKoch.F s * ζ s + deriv ζ s) 0 (regionθ θ) |
| [`Expansion.F_zero`](./lean/Expansion.md#Expansion-F_zero) | theorem | `Expansion` | F 0 x = f2x x |
| [`ReZetaCount.F_zero_eq_one`](./lean_stage3/ReZetaCount.md#ReZetaCount-F_zero_eq_one) | theorem | `ReZetaCount` | F T 0 = 1 |
| [`ReZetaCount.F_zeros_finite`](./lean_stage3/ReZetaCount.md#ReZetaCount-F_zeros_finite) | theorem | `ReZetaCount` | (SetOfZeros 1 (F T)).Finite |
| [`WeilPowerBounds.factor_eq`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-factor_eq) | theorem | `WeilPowerBounds` | w ^ 2 + (a : ℂ) ^ 2 = (w - Complex.I * (a : ℂ)) * (w + Complex.I * (a : ℂ)) |
| [`WeilPowerBands.factorial_odd_le`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-factorial_odd_le) | theorem | `WeilPowerBands` | (((2 * m + 1).factorial : ℕ) : ℝ) ≤ 2 * 4 ^ m * ((m : ℝ) + 1) ^ (2 * m + 1) |
| [`Zeros.factorization_proportional`](./lean/ZerosStencil.md#Zeros-factorization_proportional) | theorem | `ZerosStencil` | n * b.factorization p = m * c.factorization p |
| [`WeilPowerAssembly.far_large_le`](./lean_stage3/WeilPowerAssembly.md#WeilPowerAssembly-far_large_le) | theorem | `WeilPowerAssembly` | \|∑ ρ ∈ fl_set, WeilPowerBands.termW h γ m ρ\| ≤ (15 * Real.log T + 698) * ((h/2)^2 * U_far^2) |
| [`WeilPowerAssembly.far_moderate_le`](./lean_stage3/WeilPowerAssembly.md#WeilPowerAssembly-far_moderate_le) | theorem | `WeilPowerAssembly` | \|∑ ρ ∈ fm_set, WeilPowerBands.termW h γ m ρ\| ≤ (15 * Real.log T + 73) * ((h/2)^2 * U_mem^2) |
| [`WeilPowerBridge.far_sideband_le`](./lean_stage3/WeilPowerBridge.md#WeilPowerBridge-far_sideband_le) | theorem | `WeilPowerBridge` | ‖S m (wp h γ ρ)‖ ≤ cS m * Real.cosh ((ρ.re - 1 / 2) * h) * (2 / ((ρ.im + γ) * h) ^ 2) ^ (m + 1) |
| [`PerronKernel.far_terms_sum`](./lean_stage3/PerronKernel.md#PerronKernel-far_terms_sum) | theorem | `PerronKernel` | (∑' n : ℕ, if 1/2 ≤ \|Real.log (x / n)\| then ArithmeticFunction.vonMangoldt n * (x / n) ^ (1 + 1/Real.log x) / (T * \|Real.log (x / n)\|) else 0) ≤ 300 * x * Real.log (x * T) ^ 2 / T |
| [`WeilPowerSelect.farDelta_le`](./lean_stage3/WeilPowerSelect.md#WeilPowerSelect-farDelta_le) | theorem | `WeilPowerSelect` | ε' ^ 2 - Δ ^ 2 ≤ 0 |
| [`Elephant.filter_couples_iff_isPrimePow`](./lean/Elephant.md#Elephant-filter_couples_iff_isPrimePow) | theorem | `Elephant` | vonMangoldt (b ^ k) ≠ 0 ↔ IsPrimePow b |
| [`Elephant.filter_ne_zero_at_zeta_zero`](./lean/Elephant.md#Elephant-filter_ne_zero_at_zeta_zero) | theorem | `Elephant` | (Sym b ρ) ^ d ≠ 0 |
| [`Slice3.finalBoundConst_le`](./lean_stage3/LineBound.md#Slice3-finalBoundConst_le) | theorem | `LineBound` | 16 * ((181:ℝ)/200) ^ 2 / ((181/200) - (3/4)) ^ 3 + 1 / (((15/16:ℝ) ^ 2 / (29/32) - 29/32) * Real.log ((15/16)/(29/32))) ≤ 3991 |
| [`Slice4.finalBoundConst_le`](./lean_stage3/LineBound.md#Slice4-finalBoundConst_le) | theorem | `LineBound` | 16 * ((181:ℝ)/200) ^ 2 / ((181/200) - (3/4)) ^ 3 + 1 / (((15/16:ℝ) ^ 2 / (29/32) - 29/32) * Real.log ((15/16)/(29/32))) ≤ 3991 |
| [`Stage3.floor_arith`](./lean_stage3/AssemblyFloor.md#Stage3-floor_arith) | theorem | `AssemblyFloor` | A ≤ (4 + P / L₀ + Q / L₀ ^ 2 + 18 * c₁ / (x₀ * S₀) + c₂ / (S₀ * L₀)) * S * L ^ 2 |
| [`GateEval.floor_bound`](./lean_stage3/GateEval.md#GateEval-floor_bound) | theorem | `GateEval` | 3 * (4 + (16 + 16 * 112 + 16 * 0) / ℓ + (8 * 698 + 8 + 4 * 0) / ℓ ^ 2 + 18 * c1 / ((2:ℝ) ^ (36:ℕ) * (2:ℝ) ^ (18:ℕ)) + c3 / ((2:ℝ) ^ (18:ℕ) * ℓ) + c4 * (1 / (2:ℝ) ^ (9:ℕ)) / (2:ℝ) ^ (18:ℕ)) + 13 ≤ 414 |
| [`Stage3.floorConst`](./lean_stage3/AssemblyFloor.md#Stage3-floorConst) | def | `AssemblyFloor` | ℝ |
| [`Stage3.floorConst_nonneg`](./lean_stage3/AssemblyFloor.md#Stage3-floorConst_nonneg) | theorem | `AssemblyFloor` | 0 ≤ floorConst c₁ c₂ b₁ b₂ b₃ W x₀ |
| [`Stage3.floorConstSplit`](./lean_stage3/GlueFloor.md#Stage3-floorConstSplit) | def | `GlueFloor` | ℝ |
| [`Stage3.floorConstSplit_nonneg`](./lean_stage3/GlueFloor.md#Stage3-floorConstSplit_nonneg) | theorem | `GlueFloor` | 0 ≤ floorConstSplit c₁ c₃ c₄ b₁ b₂ b₃ W x₀ |
| [`Propagation.flux_form`](./lean/Propagation.md#Propagation-flux_form) | theorem | `Propagation` | tableFrom N r (d + 1) + tableFrom N (r - 1) d = tableFrom N r d |
| [`WeilPowerBands.four_h_add_nonneg`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-four_h_add_nonneg) | theorem | `WeilPowerBands` | 0 ≤ 4 * h ^ 2 + cFarM m / h ^ 2 |
| [`WeilSeries.four_h_add_nonneg`](./lean_stage3/WeilSeries.md#WeilSeries-four_h_add_nonneg) | theorem | `WeilSeries` | 0 ≤ 4 * h ^ 2 + cFar / h ^ 2 |
| [`Stage3.four_le_log_of_theta`](./lean_stage3/ThetaPull.md#Stage3-four_le_log_of_theta) | theorem | `ThetaPull` | (4:ℝ) ≤ Real.log X |
| [`Zeros.four_zeros_only`](./lean/Zeros.md#Zeros-four_zeros_only) | theorem | `Zeros` | measured_zeros.length = 4 |
| [`Bridge.ft`](./lean_bridge/WeilBridge.md#Bridge-ft) | def | `WeilBridge` | ℂ |
| [`WeilBridgeLeaf.ft`](./lean_stage3/WeilBridgeLeaf.md#WeilBridgeLeaf-ft) | def | `WeilBridgeLeaf` | ℂ |
| [`LandauWindow.G`](./lean_stage3/LandauWindow.md#LandauWindow-G) | def | `LandauWindow` | ℝ |
| [`ReZetaCount.G`](./lean_stage3/ReZetaCount.md#ReZetaCount-G) | def | `ReZetaCount` | ℂ |
| [`WeilPowerGauss.g`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-g) | def | `WeilPowerGauss` | ℂ |
| [`WeilTransform.G`](./lean_stage3/WeilTransform.md#WeilTransform-G) | def | `WeilTransform` | ℝ |
| [`WeilPowerPhase.g_eq`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-g_eq) | theorem | `WeilPowerPhase` | g w j = 1 + x w j |
| [`LandauMellinG.G_integrand_eq`](./lean_stage3/LandauMellinG.md#LandauMellinG-G_integrand_eq) | theorem | `LandauMellinG` | (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1) = (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1) - (Real.log y : ℂ) * (y : ℂ) ^ (-s) + (1 + (Real.eulerMascheroniConstant : ℂ)) * (y : ℂ) ^ (-s) |
| [`LandauChebyshev.G_le`](./lean_stage3/LandauChebyshev.md#LandauChebyshev-G_le) | theorem | `LandauChebyshev` | LandauWindow.G y ≤ 8 * y |
| [`LandauMellinG.G_mellin_integrable`](./lean_stage3/LandauMellinG.md#LandauMellinG-G_mellin_integrable) | theorem | `LandauMellinG` | IntegrableOn (fun y : ℝ =&gt; (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1)) (Ioi 1) |
| [`WeilPowerPhase.g_ne_zero`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-g_ne_zero) | theorem | `WeilPowerPhase` | g w j ≠ 0 |
| [`ReZetaCount.G_real`](./lean_stage3/ReZetaCount.md#ReZetaCount-G_real) | theorem | `ReZetaCount` | G T (x : ℂ) = ((2 * (riemannZeta (2 * (x : ℂ) + 2 + Complex.I * (T : ℂ))).re : ℝ) : ℂ) |
| [`ReZetaCount.G_zero_eq`](./lean_stage3/ReZetaCount.md#ReZetaCount-G_zero_eq) | theorem | `ReZetaCount` | G T 0 = ((2 * (riemannZeta (2 + Complex.I * (T : ℂ))).re : ℝ) : ℂ) |
| [`ReZetaCount.G_zero_ne`](./lean_stage3/ReZetaCount.md#ReZetaCount-G_zero_ne) | theorem | `ReZetaCount` | G T 0 ≠ 0 |
| [`NyquistPeak.gain`](./lean/NyquistPeak.md#NyquistPeak-gain) | def | `NyquistPeak` | ℝ |
| [`NyquistPeak.gain_continuousAt_boundaryBase`](./lean/NyquistPeak.md#NyquistPeak-gain_continuousAt_boundaryBase) | theorem | `NyquistPeak` | ContinuousAt (fun b : ℝ =&gt; gain d (γ * Real.log b)) (boundaryBase γ) |
| [`NyquistPeak.gain_eq_norm_sym_pow`](./lean/NyquistPeak.md#NyquistPeak-gain_eq_norm_sym_pow) | theorem | `NyquistPeak` | gain d (γ * Real.log b) = ‖Chain.Sym b (γ * Complex.I)‖ ^ d |
| [`NyquistPeak.gain_hasDerivAt_pi`](./lean/NyquistPeak.md#NyquistPeak-gain_hasDerivAt_pi) | theorem | `NyquistPeak` | HasDerivAt (gain d) 0 Real.pi |
| [`NyquistPeak.gain_le_at_boundaryBase`](./lean/NyquistPeak.md#NyquistPeak-gain_le_at_boundaryBase) | theorem | `NyquistPeak` | gain d (γ * Real.log b) ≤ gain d (γ * Real.log (boundaryBase γ)) |
| [`NyquistPeak.gain_le_gain_pi`](./lean/NyquistPeak.md#NyquistPeak-gain_le_gain_pi) | theorem | `NyquistPeak` | gain d θ ≤ gain d Real.pi |
| [`NyquistPeak.gain_lt_gain_pi`](./lean/NyquistPeak.md#NyquistPeak-gain_lt_gain_pi) | theorem | `NyquistPeak` | gain d θ &lt; gain d Real.pi |
| [`NyquistPeak.gain_pi`](./lean/NyquistPeak.md#NyquistPeak-gain_pi) | theorem | `NyquistPeak` | gain d Real.pi = 2 ^ d |
| [`Chain.gain_sq_at_ceiling`](./lean/Chain.md#Chain-gain_sq_at_ceiling) | theorem | `Chain` | ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ 2 = (1 + b ^ (-(1:ℝ)/2)) ^ 2 |
| [`Chain.gain_sq_at_floor`](./lean/Chain.md#Chain-gain_sq_at_floor) | theorem | `Chain` | ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ 2 = (1 - b ^ (-(1:ℝ)/2)) ^ 2 |
| [`EulerFactorChain.gain_sq_on_critical_line`](./lean/EulerFactorChain.md#EulerFactorChain-gain_sq_on_critical_line) | theorem | `EulerFactorChain` | ‖1 - (b : ℂ) ^ (-((1 : ℂ)/2 + γ * I))‖ ^ 2 = 1 - 2 * b ^ (-(1:ℝ)/2) * Real.cos (γ * Real.log b) + b ^ (-(1:ℝ)) |
| [`Chain.gain_sq_periodic`](./lean/Chain.md#Chain-gain_sq_periodic) | theorem | `Chain` | Function.Periodic (fun γ : ℝ =&gt; ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ 2) (2 * Real.pi / Real.log b) |
| [`NyquistPeak.gain_stationary_in_base`](./lean/NyquistPeak.md#NyquistPeak-gain_stationary_in_base) | theorem | `NyquistPeak` | HasDerivAt (fun b : ℝ =&gt; gain d (γ * Real.log b)) 0 (boundaryBase γ) |
| [`NyquistPeak.gain_zero_phase`](./lean/NyquistPeak.md#NyquistPeak-gain_zero_phase) | theorem | `NyquistPeak` | gain d 0 = 0 |
| [`Stage3.gammaR_conj`](./lean_stage3/ArgIdentity.md#Stage3-gammaR_conj) | theorem | `ArgIdentity` | Gammaℝ (conj s) = conj (Gammaℝ s) |
| [`Stage3.gammaR_eq_exp_mul`](./lean_stage3/ArgIdentity.md#Stage3-gammaR_eq_exp_mul) | theorem | `ArgIdentity` | Gammaℝ s = Complex.exp (-(Real.log Real.pi : ℂ) / 2 * s) * Complex.Gamma (s / 2) |
| [`Stage3.gammaR_fold_eq_phaseTheta`](./lean_stage3/ArgIdentity.md#Stage3-gammaR_fold_eq_phaseTheta) | theorem | `ArgIdentity` | (∫ t in (0:ℝ)..T, logDeriv Gammaℝ (2 + (t : ℂ) * Complex.I)).re - (∫ x in (1/2:ℝ)..2, logDeriv Gammaℝ ((x : ℂ) + T * Complex.I)).im = phaseTheta T |
| [`GateEval.gate_hyp_of_RH`](./lean_stage3/GateEval.md#GateEval-gate_hyp_of_RH) | theorem | `GateEval` | ∃ ρ : ℝ, JointDialGate.StmtRelErrWindow (fun m : ℤ =&gt; (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ)) (fun m : ℤ =&gt; 2 / Real.log 2 + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r (6 + 1) ρ ∧… |
| [`GateEval.gate_ineq`](./lean_stage3/GateEval.md#GateEval-gate_ineq) | theorem | `GateEval` | 414 * (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-((r - 7) / 2)) &lt; Real.log 2 ^ 6 / (2 * r * 3 ^ 7) |
| [`TableDepths.gate_ineq_gen`](./lean_stage3/TableDepths.md#TableDepths-gate_ineq_gen) | theorem | `TableDepths` | 414 * (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-((r - ((d:ℝ) + 1)) / 2)) &lt; Real.log 2 ^ d / (2 * r * 3 ^ (d + 1)) |
| [`Transform.generators_indep`](./lean/Transform.md#Transform-generators_indep) | theorem | `Transform` | a = 0 ∧ c = 0 |
| [`Transform.gens`](./lean/Transform.md#Transform-gens) | def | `Transform` | Fin 2 → ℂ |
| [`Transform.gens_linearIndependent`](./lean/Transform.md#Transform-gens_linearIndependent) | theorem | `Transform` | LinearIndependent ℝ (gens b) |
| [`WeilPowerGeom.geom_Ico`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-geom_Ico) | theorem | `WeilPowerGeom` | ∑ m ∈ Finset.Ico a b, x ^ m = (x ^ b - x ^ a) / (x - 1) |
| [`WeilPowerGeom.geomBound`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-geomBound) | def | `WeilPowerGeom` | ℝ |
| [`WeilPowerShell.geomBound_le`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-geomBound_le) | theorem | `WeilPowerShell` | WeilPowerGeomGen.geomBoundGen (zOf e' D e) (1 / ((lam : ℝ) * Real.pi ^ 2)) (-1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) a b ≤ Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) * (lam : ℝ) * Real.pi… |
| [`WeilPowerGeomGen.geomBoundGen`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-geomBoundGen) | def | `WeilPowerGeomGen` | ℝ |
| [`Glue.Gf`](./lean_stage3/Glue.md#Glue-Gf) | def | `Glue` | ℂ → ℂ |
| [`Glue.Gf_norm_conj`](./lean_stage3/Glue.md#Glue-Gf_norm_conj) | theorem | `Glue` | ‖Gf x ((starRingEnd ℂ) u)‖ = ‖Gf x u‖ |
| [`WeilTransform.ghat`](./lean_stage3/WeilTransform.md#WeilTransform-ghat) | def | `WeilTransform` | ℂ |
| [`WeilTransform.ghat_eq`](./lean_stage3/WeilTransform.md#WeilTransform-ghat_eq) | theorem | `WeilTransform` | ghat h γ z = ((h : ℂ) / 2) * (SigmaC ((z + Complex.I * (γ : ℂ)) * (h : ℂ)) + SigmaC ((z - Complex.I * (γ : ℂ)) * (h : ℂ))) |
| [`WeilOffLine.ghat_neg`](./lean_stage3/WeilOffLine.md#WeilOffLine-ghat_neg) | theorem | `WeilOffLine` | ghat h γ (-z) = -ghat h γ z |
| [`WeilTransform.ghat_offline`](./lean_stage3/WeilTransform.md#WeilTransform-ghat_offline) | theorem | `WeilTransform` | ghat h γ ((ε : ℂ) + Complex.I * (γ : ℂ)) = ((h : ℂ) / 2) * (SigmaC (((ε : ℂ) + 2 * Complex.I * (γ : ℂ)) * (h : ℂ)) + (WeilWindow.Sigma (ε * h) : ℂ)) |
| [`WeilTransform.ghat_ofReal_I`](./lean_stage3/WeilTransform.md#WeilTransform-ghat_ofReal_I) | theorem | `WeilTransform` | ghat h γ (Complex.I * (t : ℂ)) = Complex.I * ((h : ℂ) / 2) * ((Psi (h * (t + γ)) : ℂ) + (Psi (h * (t - γ)) : ℂ)) |
| [`ArgCount.good`](./lean_stage3/ArgCount.md#ArgCount-good) | def | `ArgCount` | Prop |
| [`ContourShift.goodT_exists`](./lean_stage3/ContourShift.md#ContourShift-goodT_exists) | theorem | `ContourShift` | ∃ T' ∈ Set.Icc T (T+1), ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 &lt; ρ.re → zeroGap T ≤ \|ρ.im - T'\| |
| [`EdgeBound.gz`](./lean_stage3/EdgeBound.md#EdgeBound-gz) | def | `EdgeBound` | ℂ |
| [`EdgeBound.gz_analytic`](./lean_stage3/EdgeBound.md#EdgeBound-gz_analytic) | theorem | `EdgeBound` | AnalyticAt ℂ gz s |
| [`EdgeBound.gz_c0_lower`](./lean_stage3/LowCount.md#EdgeBound-gz_c0_lower) | theorem | `LowCount` | 1 / 14 ≤ ‖gz (c0 T')‖ |
| [`EdgeBound.gz_c0_ne`](./lean_stage3/EdgeBound.md#EdgeBound-gz_c0_ne) | theorem | `EdgeBound` | gz (c0 T') ≠ 0 |
| [`EdgeBound.gz_logderiv`](./lean_stage3/EdgeBound.md#EdgeBound-gz_logderiv) | theorem | `EdgeBound` | deriv gz u / gz u = 2/(u - 1) + deriv riemannZeta u / riemannZeta u |
| [`EdgeBound.gz_lower`](./lean_stage3/EdgeBound.md#EdgeBound-gz_lower) | theorem | `EdgeBound` | 4 * ‖riemannZeta 3 / riemannZeta (3/2)‖ ≤ ‖gz (c0 T')‖ |
| [`EdgeBound.gz_order_eq`](./lean_stage3/EdgeBound.md#EdgeBound-gz_order_eq) | theorem | `EdgeBound` | analyticOrderNatAt gz w = analyticOrderNatAt riemannZeta w |
| [`EdgeBound.gz_partial_fraction`](./lean_stage3/EdgeBound.md#EdgeBound-gz_partial_fraction) | theorem | `EdgeBound` | ∃ C : ℝ, 0 &lt; C ∧ ∀ T' : ℝ, 2 ≤ T' → ∀ u : ℂ, u.im = T' → -1/4 ≤ u.re → u.re ≤ 2 → gz u ≠ 0 → ‖deriv gz u / gz u - ∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, (analyticOrder… |
| [`EdgeBound.gz_partial_fraction_low`](./lean_stage3/LowEdge.md#EdgeBound-gz_partial_fraction_low) | theorem | `LowEdge` | ‖deriv gz u / gz u - ∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, (analyticOrderNatAt gz w : ℂ) / (u - w)‖ ≤ 1617537 |
| [`EdgeBound.gz_partial_fraction_num`](./lean_stage3/EdgeNum.md#EdgeBound-gz_partial_fraction_num) | theorem | `EdgeNum` | ∀ T' : ℝ, 2 ≤ T' → ∀ u : ℂ, u.im = T' → -1/4 ≤ u.re → u.re ≤ 2 → gz u ≠ 0 → ‖deriv gz u / gz u - ∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, (analyticOrderNatAt gz w : ℂ) /… |
| [`EdgeBound.gz_zero_cases`](./lean_stage3/EdgeBound.md#EdgeBound-gz_zero_cases) | theorem | `EdgeBound` | w = 1 ∨ riemannZeta w = 0 |
| [`EdgeBound.gz_zeros_ball_finite`](./lean_stage3/EdgeBound.md#EdgeBound-gz_zeros_ball_finite) | theorem | `EdgeBound` | {w : ℂ \| gz w = 0 ∧ ‖w - c0 T'‖ ≤ ρ}.Finite |
| [`Chain.h`](./lean/Chain.md#Chain-h) | def | `Chain` | ℂ |
| [`EulerFactorChain.h`](./lean/EulerFactorChain.md#EulerFactorChain-h) | def | `EulerFactorChain` | ℂ |
| [`EulerFactorChain.h_eq_gain_pow_on_critical_line`](./lean/EulerFactorChain.md#EulerFactorChain-h_eq_gain_pow_on_critical_line) | theorem | `EulerFactorChain` | h b N ((1 : ℂ)/2 + t * I) = ((‖1 - (b : ℂ) ^ (-((1 : ℂ)/2 + t * I))‖ : ℝ) ^ (2 * N) : ℝ) |
| [`EulerFactorChain.h_functional_equation`](./lean/EulerFactorChain.md#EulerFactorChain-h_functional_equation) | theorem | `EulerFactorChain` | h b N (1 - s) = h b N s |
| [`EulerFactorChain.h_one`](./lean/EulerFactorChain.md#EulerFactorChain-h_one) | theorem | `EulerFactorChain` | h b N 1 = 0 |
| [`EulerFactorChain.h_zero`](./lean/EulerFactorChain.md#EulerFactorChain-h_zero) | theorem | `EulerFactorChain` | h b N 0 = 0 |
| [`Stage3.half_le_norm_of_RH`](./lean_stage3/Assembly.md#Stage3-half_le_norm_of_RH) | theorem | `Assembly` | 1 / 2 ≤ ‖(ρ : ℂ)‖ |
| [`RHPull.half_lt_σRH`](./lean_stage3/LineBound.md#RHPull-half_lt_-RH) | theorem | `LineBound` | (1:ℝ)/2 &lt; σRH X |
| [`Stage3.half_lt_σθ`](./lean_stage3/ThetaPull.md#Stage3-half_lt_--) | theorem | `ThetaPull` | (1:ℝ)/2 &lt; σθ θ X |
| [`WeilPowerGeom.harmonic_quarter`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-harmonic_quarter) | theorem | `WeilPowerGeom` | ∑ m ∈ Finset.Ico a b, 1 / (Real.pi ^ 2 * (4 * (m : ℝ) + 6)) ≤ (Real.log b - Real.log a) / (4 * Real.pi ^ 2) |
| [`Bridge.hasCompactSupport_kOf`](./lean_bridge/WeilBridge.md#Bridge-hasCompactSupport_kOf) | theorem | `WeilBridge` | HasCompactSupport (kOf G) |
| [`Bridge.hasCompactSupport_tiltF`](./lean_bridge/WeilBridge.md#Bridge-hasCompactSupport_tiltF) | theorem | `WeilBridge` | HasCompactSupport (tiltF G) |
| [`WeilPower.hasDerivAt_c`](./lean_stage3/WeilPower.md#WeilPower-hasDerivAt_c) | theorem | `WeilPower` | HasDerivAt c (-(Real.pi / 2) * Real.sin (Real.pi * x / 2)) x |
| [`WeilLobe.hasDerivAt_cos_pi`](./lean_stage3/WeilLobe.md#WeilLobe-hasDerivAt_cos_pi) | theorem | `WeilLobe` | HasDerivAt (fun y : ℝ =&gt; Real.cos (Real.pi * y)) (-Real.sin (Real.pi * x) * Real.pi) x |
| [`WeilPower.hasDerivAt_E`](./lean_stage3/WeilPower.md#WeilPower-hasDerivAt_E) | theorem | `WeilPower` | HasDerivAt (fun y : ℝ =&gt; Complex.exp (w * (y : ℂ))) (w * Complex.exp (w * (x : ℂ))) x |
| [`Expansion.hasDerivAt_F`](./lean/Expansion.md#Expansion-hasDerivAt_F) | theorem | `Expansion` | HasDerivAt (F d) (F (d + 1) x) x |
| [`WeilPower.hasDerivAt_f`](./lean_stage3/WeilPower.md#WeilPower-hasDerivAt_f) | theorem | `WeilPower` | HasDerivAt (fun y : ℝ =&gt; c y ^ (k + 1)) (f1 k x) x |
| [`WeilPower.hasDerivAt_f1`](./lean_stage3/WeilPower.md#WeilPower-hasDerivAt_f1) | theorem | `WeilPower` | HasDerivAt (f1 (k + 1)) (f2 k x) x |
| [`Stage3.hasDerivAt_Li`](./lean_stage3/RowLeaves.md#Stage3-hasDerivAt_Li) | theorem | `RowLeaves` | HasDerivAt Li (1 / Real.log y) y |
| [`Stage3.hasDerivAt_Li_two_rpow`](./lean_stage3/RowLeaves.md#Stage3-hasDerivAt_Li_two_rpow) | theorem | `RowLeaves` | HasDerivAt (fun u : ℝ =&gt; Li ((2 : ℝ) ^ u)) (Real.exp (Real.log 2 * x) / x) x |
| [`LandauMellinG.hasDerivAt_logPrim`](./lean_stage3/LandauMellinG.md#LandauMellinG-hasDerivAt_logPrim) | theorem | `LandauMellinG` | HasDerivAt (logPrim s) ((Real.log y : ℂ) * (y : ℂ) ^ (-s)) y |
| [`LandauKernel.hasDerivAt_prim`](./lean_stage3/LandauKernel.md#LandauKernel-hasDerivAt_prim) | theorem | `LandauKernel` | HasDerivAt (fun t : ℝ =&gt; -(Real.log t ^ (k + 1) * t ^ (-a)) / a) (Real.log y ^ (k + 1) * y ^ (-a - 1) - ((k : ℝ) + 1) / a * (Real.log y ^ k * y ^ (-a - 1))) y |
| [`WeilLobe.hasDerivAt_q`](./lean_stage3/WeilLobe.md#WeilLobe-hasDerivAt_q) | theorem | `WeilLobe` | HasDerivAt q (q1 x) x |
| [`WeilLobe.hasDerivAt_q1`](./lean_stage3/WeilLobe.md#WeilLobe-hasDerivAt_q1) | theorem | `WeilLobe` | HasDerivAt q1 (q2 x) x |
| [`Stage3.hasDerivAt_rowIntegral`](./lean_stage3/RowLeaves.md#Stage3-hasDerivAt_rowIntegral) | theorem | `RowLeaves` | HasDerivAt (fun u : ℝ =&gt; 2 / Real.log 2 + ∫ t in (1 : ℝ)..u, Real.exp (Real.log 2 * t) / t) (Real.exp (Real.log 2 * x) / x) x |
| [`Expansion.hasDerivAt_S`](./lean/Expansion.md#Expansion-hasDerivAt_S) | theorem | `Expansion` | HasDerivAt (S d) (∑ j ∈ range (d + 1), c d j * (-(j : ℝ) - 1) * x ^ (-(j + 2 : ℤ))) x |
| [`WeilPower.hasDerivAt_s`](./lean_stage3/WeilPower.md#WeilPower-hasDerivAt_s) | theorem | `WeilPower` | HasDerivAt (fun y : ℝ =&gt; Real.sin (Real.pi * y / 2)) (Real.pi / 2 * c x) x |
| [`WeilLobe.hasDerivAt_sin_pi`](./lean_stage3/WeilLobe.md#WeilLobe-hasDerivAt_sin_pi) | theorem | `WeilLobe` | HasDerivAt (fun y : ℝ =&gt; Real.sin (Real.pi * y)) (Real.cos (Real.pi * x) * Real.pi) x |
| [`Stage3.hasDerivAt_sqPos`](./lean_stage3/ExplicitBump.md#Stage3-hasDerivAt_sqPos) | theorem | `ExplicitBump` | HasDerivAt (fun t : ℝ =&gt; (max 0 t) ^ 2) (2 * max 0 u) u |
| [`Expansion.hD_of_window`](./lean/Expansion.md#Expansion-hD_of_window) | theorem | `Expansion` | ∀ y ∈ Icc ((r : ℝ) - (d + 1)) r, Nonvanishing.Mlow r d ≤ iteratedDeriv (d + 1) G y |
| [`RHPull.holo_logDerivZeta_of_RH`](./lean_stage3/LineBound.md#RHPull-holo_logDerivZeta_of_RH) | theorem | `LineBound` | HolomorphicOn (deriv riemannZeta / riemannZeta) (Set.Icc σ₁ 2 ×ℂ Set.Icc (-T) T \ {1}) |
| [`Stage3.holo_logDerivZeta_theta`](./lean_stage3/ThetaPsi.md#Stage3-holo_logDerivZeta_theta) | theorem | `ThetaPsi` | HolomorphicOn (deriv riemannZeta / riemannZeta) (Set.Icc σ₁ 2 ×ℂ Set.Icc (-T) T \ {1}) |
| [`PerronKernel.horiz_bound`](./lean_stage3/PerronKernel.md#PerronKernel-horiz_bound) | theorem | `PerronKernel` | ‖∫ σ in a..b, (y : ℂ) ^ ((σ : ℂ) + (T' : ℂ) * Complex.I) / ((σ : ℂ) + (T' : ℂ) * Complex.I)‖ ≤ max (y ^ a) (y ^ b) / (\|T'\| * \|Real.log y\|) |
| [`RHPull.horiz_length`](./lean_stage3/LineBound.md#RHPull-horiz_length) | theorem | `LineBound` | (1 + 1 / Real.log X) - σRH X = 1 / 2 |
| [`Stage3.horiz_length_theta`](./lean_stage3/ThetaPsi.md#Stage3-horiz_length_theta) | theorem | `ThetaPsi` | (1 + 1 / Real.log X) - σθ θ X = 1 - θ |
| [`RHPull.horiz_small`](./lean_stage3/LineBound.md#RHPull-horiz_small) | theorem | `LineBound` | (1 / (2 * Real.pi)) * (1 / 2) * ((1996 * Real.log (84 * X) + (29 * Real.log X + 129) * Real.log X) * (B / X) * (Real.exp 1 * X)) ≤ (900 * Real.exp 1 * B / Real.pi) * (Real.log X) ^ 2 |
| [`ArgLegs.horizontal_leg_le`](./lean_stage3/ArgLegs.md#ArgLegs-horizontal_leg_le) | theorem | `ArgLegs` | \|(∫ x in (1/2:ℝ)..2, logDeriv riemannZeta ((x : ℂ) + T * Complex.I)).im\| ≤ Real.pi * ((Z.card : ℝ) + 1) |
| [`WeilPowerPhase.hterm`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-hterm) | def | `WeilPowerPhase` | ℝ |
| [`RHPull.I2_norm_le`](./lean_stage3/LineBound.md#RHPull-I2_norm_le) | theorem | `LineBound` | ‖I₂ ν ε T X (σRH X)‖ ≤ (1 / (2 * Real.pi)) * (1 / 2) * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ (1 + 1 / Real.log X)) |
| [`Stage3.I2_norm_le_theta`](./lean_stage3/ThetaPsi.md#Stage3-I2_norm_le_theta) | theorem | `ThetaPsi` | ‖I₂ ν ε T X (σθ θ X)‖ ≤ (1 / (2 * Real.pi)) * (1 - θ) * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ (1 + 1 / Real.log X)) |
| [`RHPull.I37_norm_le`](./lean_stage3/LineBound.md#RHPull-I37_norm_le) | theorem | `LineBound` | ‖I₃₇ ν ε T X (σRH X)‖ ≤ (1 / (2 * Real.pi)) * (2 * T) * (11100 * (Real.log X) ^ 2 * M * X ^ (σRH X)) |
| [`RHPull.I37_norm_le_decay`](./lean_stage3/LineBound.md#RHPull-I37_norm_le_decay) | theorem | `LineBound` | ‖I₃₇ ν ε T X (σRH X)‖ ≤ (1 / (2 * Real.pi)) * Real.pi * (11100 * (Real.log X) ^ 2 * (4 * C / ε) * X ^ (σRH X)) |
| [`Stage3.I37_norm_le_decay_theta`](./lean_stage3/ThetaPull.md#Stage3-I37_norm_le_decay_theta) | theorem | `ThetaPull` | ‖I₃₇ ν ε T X (σθ θ X)‖ ≤ (1 / (2 * Real.pi)) * Real.pi * (11100 * (Real.log X) ^ 2 * (4 * C / ε) * X ^ (σθ θ X)) |
| [`RHPull.I37_norm_le_epsfree`](./lean_stage3/LineBound.md#RHPull-I37_norm_le_epsfree) | theorem | `LineBound` | ‖I₃₇ ν ε T X (σRH X)‖ ≤ (1 / (2 * Real.pi)) * (6 * Real.log (1 + T)) * (11100 * (Real.log X) ^ 2 * B * X ^ (σRH X)) |
| [`Stage3.I37_norm_le_epsfree_theta`](./lean_stage3/ThetaPull.md#Stage3-I37_norm_le_epsfree_theta) | theorem | `ThetaPull` | ‖I₃₇ ν ε T X (σθ θ X)‖ ≤ (1 / (2 * Real.pi)) * (6 * Real.log (1 + T)) * (11100 * (Real.log X) ^ 2 * B * X ^ (σθ θ X)) |
| [`Stage3.I37_power_form_theta`](./lean_stage3/ThetaPull.md#Stage3-I37_power_form_theta) | theorem | `ThetaPull` | ‖I₃₇ ν ε T X (σθ θ X)‖ ≤ (22200 * Real.exp 1 * C / ε) * X ^ θ * (Real.log X) ^ 2 |
| [`Stage3.I37_power_log3_theta`](./lean_stage3/ThetaPull.md#Stage3-I37_power_log3_theta) | theorem | `ThetaPull` | ‖I₃₇ ν ε T X (σθ θ X)‖ ≤ (66600 * Real.exp 1 * B / Real.pi) * X ^ θ * (Real.log X) ^ 3 |
| [`RHPull.I37_sqrt_form`](./lean_stage3/LineBound.md#RHPull-I37_sqrt_form) | theorem | `LineBound` | ‖I₃₇ ν ε T X (σRH X)‖ ≤ (22200 * Real.exp 1 * C / ε) * Real.sqrt X * (Real.log X) ^ 2 |
| [`RHPull.I37_sqrt_log3`](./lean_stage3/LineBound.md#RHPull-I37_sqrt_log3) | theorem | `LineBound` | ‖I₃₇ ν ε T X (σRH X)‖ ≤ (66600 * Real.exp 1 * B / Real.pi) * Real.sqrt X * (Real.log X) ^ 3 |
| [`Stage3.I37_sqrt_log3_half`](./lean_stage3/ThetaPull.md#Stage3-I37_sqrt_log3_half) | theorem | `ThetaPull` | ‖I₃₇ ν ε T X (RHPull.σRH X)‖ ≤ (66600 * Real.exp 1 * B / Real.pi) * Real.sqrt X * (Real.log X) ^ 3 |
| [`RHPull.I8_norm_le`](./lean_stage3/LineBound.md#RHPull-I8_norm_le) | theorem | `LineBound` | ‖I₈ ν ε T X (σRH X)‖ ≤ (1 / (2 * Real.pi)) * (1 / 2) * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ (1 + 1 / Real.log X)) |
| [`Stage3.I8_norm_le_theta`](./lean_stage3/ThetaPsi.md#Stage3-I8_norm_le_theta) | theorem | `ThetaPsi` | ‖I₈ ν ε T X (σθ θ X)‖ ≤ (1 / (2 * Real.pi)) * (1 - θ) * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ (1 + 1 / Real.log X)) |
| [`WeilOddPower.ibp_once`](./lean_stage3/WeilOddPower.md#WeilOddPower-ibp_once) | theorem | `WeilOddPower` | (∫ x in (-1 : ℝ)..1, ((f1 (k + 1) x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ))) = -(w * ∫ x in (-1 : ℝ)..1, ((c x ^ (k + 2) : ℝ) : ℂ) * Complex.exp (w * (x : ℂ))) |
| [`WeilPower.ibp_twice`](./lean_stage3/WeilPower.md#WeilPower-ibp_twice) | theorem | `WeilPower` | w ^ 2 * ∫ x in (-1 : ℝ)..1, ((c x ^ (k + 2) : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)) = ∫ x in (-1 : ℝ)..1, ((f2 k x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)) |
| [`WeilTiles.idx`](./lean_stage3/WeilTiles.md#WeilTiles-idx) | def | `WeilTiles` | ℕ |
| [`WeilSeries.idx_le`](./lean_stage3/WeilSeries.md#WeilSeries-idx_le) | theorem | `WeilSeries` | (idx γ : ℝ) ≤ γ |
| [`WeilTiles.idx_spec`](./lean_stage3/WeilTiles.md#WeilTiles-idx_spec) | theorem | `WeilTiles` | \|t - centre (idx t)\| ≤ 9 / 10 |
| [`LandauPrimeSide.Ik`](./lean_stage3/LandauPrimeSide.md#LandauPrimeSide-Ik) | def | `LandauPrimeSide` | ℝ |
| [`LandauPrimeSide.Ik_integrable`](./lean_stage3/LandauPrimeSide.md#LandauPrimeSide-Ik_integrable) | theorem | `LandauPrimeSide` | IntegrableOn (fun y : ℝ =&gt; LandauWindow.G y * Real.log y ^ k * y ^ (-σ - 1)) (Ioi 1) |
| [`LandauPrimeSide.Ik_le`](./lean_stage3/LandauPrimeSide.md#LandauPrimeSide-Ik_le) | theorem | `LandauPrimeSide` | Ik σ k ≤ C * (k.factorial / (σ - θ) ^ (k + 1)) + 8 * (Y ^ b * (k.factorial / (σ - 1 + b) ^ (k + 1))) + 8 * ((Y ^ (1 + δ)) ^ (-b') * (k.factorial / (σ - 1 - b') ^ (k + 1))) |
| [`WeilPowerShell.im_alpha_le`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-im_alpha_le) | theorem | `WeilPowerShell` | (zOf e' D e).im * (1 / ((lam : ℝ) * Real.pi ^ 2)) ≤ Real.pi / 2 |
| [`ArgLegs.im_integral_le_pi_of_re_nonneg`](./lean_stage3/ArgLegs.md#ArgLegs-im_integral_le_pi_of_re_nonneg) | theorem | `ArgLegs` | \|(∫ x in a..b, g' x / g x).im\| ≤ Real.pi |
| [`ArgLegs.im_integral_le_pi_of_re_nonpos`](./lean_stage3/ArgLegs.md#ArgLegs-im_integral_le_pi_of_re_nonpos) | theorem | `ArgLegs` | \|(∫ x in a..b, g' x / g x).im\| ≤ Real.pi |
| [`WeilPowerBridge.im_sq_sub_re_sq`](./lean_stage3/WeilPowerBridge.md#WeilPowerBridge-im_sq_sub_re_sq) | theorem | `WeilPowerBridge` | z.im ^ 2 - z.re ^ 2 = -(z ^ 2).re |
| [`RHPull.instantiation_arithmetic`](./lean_stage3/LineBound.md#RHPull-instantiation_arithmetic) | theorem | `LineBound` | c * (Real.sqrt X)⁻¹ * X * Real.log X ≤ c * Real.sqrt X * (Real.log X) ^ 3 ∧ c * X * Real.log X / Real.sqrt X ≤ c * Real.sqrt X * (Real.log X) ^ 3 ∧ c * ((Real.sqrt X)⁻¹ * X) ≤ c * Real.sqrt X * (Real.… |
| [`ZetaGrowth.integrable_emA_tail`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-integrable_emA_tail) | theorem | `ZetaGrowth` | IntegrableOn (fun x : ℝ ↦ (emA x : ℂ) * (x : ℂ) ^ (-(s+2))) (Ioi (N:ℝ)) |
| [`Stage3.integrable_err_term`](./lean_stage3/PsiToPi.md#Stage3-integrable_err_term) | theorem | `PsiToPi` | IntervalIntegrable (fun t =&gt; (θ t - t) / (t * Real.log t ^ 2)) volume a x |
| [`VonKoch.integrable_psi_cpow`](./lean_stage3/VonKochScaffold.md#VonKoch-integrable_psi_cpow) | theorem | `VonKochScaffold` | IntegrableOn (fun t : ℝ ↦ ((ψ t : ℝ) : ℂ) * (t : ℂ) ^ (-(s + 1))) (Set.Ioi (1:ℝ)) |
| [`Stage3.integrable_theta_term`](./lean_stage3/PsiToPi.md#Stage3-integrable_theta_term) | theorem | `PsiToPi` | IntervalIntegrable (fun t =&gt; θ t / (t * Real.log t ^ 2)) volume a x |
| [`Stage3.integral_A_rpow_le`](./lean_stage3/PsiToPi.md#Stage3-integral_A_rpow_le) | theorem | `PsiToPi` | (∫ t in a..x, A * t ^ (-(1 : ℝ) / 2)) ≤ 2 * A * Real.sqrt x |
| [`Stage3.integral_A_rpow_theta_le`](./lean_stage3/ThetaPi.md#Stage3-integral_A_rpow_theta_le) | theorem | `ThetaPi` | (∫ t in a..x, A * t ^ (θ - 1)) ≤ 2 * A * x ^ θ |
| [`RHPull.integral_abs_kernel`](./lean_stage3/LineBound.md#RHPull-integral_abs_kernel) | theorem | `LineBound` | ∫ t in (-T)..T, (1 + \|t\|)⁻¹ = 2 * Real.log (1 + T) |
| [`Stage3.integral_inv_horizontal`](./lean_stage3/ArgIdentity.md#Stage3-integral_inv_horizontal) | theorem | `ArgIdentity` | (∫ x in a..b, (((x : ℂ) - d) + T * Complex.I)⁻¹) = Complex.log (((b : ℂ) - d) + T * Complex.I) - Complex.log (((a : ℂ) - d) + T * Complex.I) |
| [`Stage3.integral_inv_vertical`](./lean_stage3/ArgIdentity.md#Stage3-integral_inv_vertical) | theorem | `ArgIdentity` | (∫ t in (0:ℝ)..T, ((c : ℂ) + t * Complex.I)⁻¹) = -Complex.I * (Complex.log ((c : ℂ) + T * Complex.I) - Complex.log (c : ℂ)) |
| [`RHPull.integral_kernel_le`](./lean_stage3/LineBound.md#RHPull-integral_kernel_le) | theorem | `LineBound` | ∫ t in (-T)..T, ((1:ℝ) + t ^ 2)⁻¹ ≤ Real.pi |
| [`Stage3.integral_log_half`](./lean_stage3/Stirling.md#Stage3-integral_log_half) | theorem | `Stirling` | (∫ t in (1 : ℝ)..T, Real.log (t / 2)) = T * Real.log (T / 2) - T + 1 + Real.log 2 |
| [`ArgLegs.integral_logDeriv_eq_log_sub`](./lean_stage3/ArgLegs.md#ArgLegs-integral_logDeriv_eq_log_sub) | theorem | `ArgLegs` | ∫ x in a..b, g' x / g x = Complex.log (g b) - Complex.log (g a) |
| [`RHPull.integral_shift_inv`](./lean_stage3/LineBound.md#RHPull-integral_shift_inv) | theorem | `LineBound` | ∫ t in (0:ℝ)..T, (1 + t)⁻¹ = Real.log (1 + T) |
| [`LandauTaylor.integrand_norm_le`](./lean_stage3/LandauTaylor.md#LandauTaylor-integrand_norm_le) | theorem | `LandauTaylor` | ‖(LandauWindow.G y : ℂ) * (-(Real.log y : ℂ)) ^ k * (y : ℂ) ^ (-s - 1)‖ ≤ 8 * (Real.log y ^ k * y ^ (-a - 1) + Real.log y ^ (k + 1) * y ^ (-a - 1)) |
| [`RHPull.integrand_norm_le`](./lean_stage3/LineBound.md#RHPull-integrand_norm_le) | theorem | `LineBound` | ‖SmoothedChebyshevIntegrand ν ε X ((σRH X : ℂ) + I * (t : ℂ))‖ ≤ 11100 * (Real.log X) ^ 2 * M * X ^ (σRH X) |
| [`RHPull.integrand_norm_le_horiz`](./lean_stage3/LineBound.md#RHPull-integrand_norm_le_horiz) | theorem | `LineBound` | ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) + I * (t : ℂ))‖ ≤ (1996 * Real.log (84 * t) + (29 * Real.log t + 129) * Real.log X) * M * X ^ σ |
| [`RHPull.integrand_norm_le_horiz_neg`](./lean_stage3/LineBound.md#RHPull-integrand_norm_le_horiz_neg) | theorem | `LineBound` | ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) - (T : ℂ) * I)‖ ≤ (1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ σ |
| [`Stage3.integrand_norm_le_horiz_neg_theta`](./lean_stage3/ThetaPsi.md#Stage3-integrand_norm_le_horiz_neg_theta) | theorem | `ThetaPsi` | ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) - (T : ℂ) * I)‖ ≤ (1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ σ |
| [`Stage3.integrand_norm_le_horiz_theta`](./lean_stage3/ThetaPsi.md#Stage3-integrand_norm_le_horiz_theta) | theorem | `ThetaPsi` | ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) + I * (t : ℂ))‖ ≤ (1996 * Real.log (84 * t) + (29 * Real.log t + 129) * Real.log X) * M * X ^ σ |
| [`Stage3.integrand_norm_le_theta`](./lean_stage3/ThetaPull.md#Stage3-integrand_norm_le_theta) | theorem | `ThetaPull` | ‖SmoothedChebyshevIntegrand ν ε X ((σθ θ X : ℂ) + I * (t : ℂ))‖ ≤ 11100 * (Real.log X) ^ 2 * M * X ^ (σθ θ X) |
| [`ZetaGrowth.interval_ibp`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-interval_ibp) | theorem | `ZetaGrowth` | ∫ x in (n:ℝ)..((n:ℝ)+1), ((⌊x⌋ : ℂ) + 1/2 - (x:ℂ)) * (x:ℂ) ^ (-(s+1)) = (s+1) * ∫ x in (n:ℝ)..((n:ℝ)+1), (emA x : ℂ) * (x:ℂ) ^ (-(s+2)) |
| [`Stage3.intervalIntegrable_phasePoint`](./lean_stage3/Stirling.md#Stage3-intervalIntegrable_phasePoint) | theorem | `Stirling` | IntervalIntegrable phasePoint MeasureTheory.volume a b |
| [`Stage3.intervalIntegral_im`](./lean_stage3/ArgIdentity.md#Stage3-intervalIntegral_im) | theorem | `ArgIdentity` | (∫ t in a..b, f t).im = ∫ t in a..b, (f t).im |
| [`Stage3.intervalIntegral_re`](./lean_stage3/ArgIdentity.md#Stage3-intervalIntegral_re) | theorem | `ArgIdentity` | (∫ t in a..b, f t).re = ∫ t in a..b, (f t).re |
| [`WeilPowerShell.inv_exp_le`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-inv_exp_le) | theorem | `WeilPowerShell` | 1 / Real.exp ((zOf e' D e).re * (1 / ((lam : ℝ) * Real.pi ^ 2))) ≤ Real.exp (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (1 / ((lam : ℝ) * Real.pi ^ 2))) |
| [`Stage3.inv_le_dyadic_sum`](./lean_stage3/Assembly.md#Stage3-inv_le_dyadic_sum) | theorem | `Assembly` | ∀ γ : ℝ, 1 ≤ γ → γ &lt; 2 ^ (K + 1) → γ⁻¹ ≤ ∑ j ∈ Finset.range (K + 1), ((2 : ℝ) ^ j)⁻¹ * (if γ &lt; 2 ^ (j + 1) then 1 else 0) |
| [`Stage3.inv_log_le_theta`](./lean_stage3/ThetaPsi.md#Stage3-inv_log_le_theta) | theorem | `ThetaPsi` | 1 / Real.log X ≤ (1 - θ) / 2 |
| [`RouteNum.inv_log_two_le`](./lean_stage3/RouteNum.md#RouteNum-inv_log_two_le) | theorem | `RouteNum` | 1 / Real.log 2 ≤ 1.4428 |
| [`Stage3.inv_quadratic_tsum_le`](./lean_stage3/Stirling.md#Stage3-inv_quadratic_tsum_le) | theorem | `Stirling` | (∑' n : ℕ, (((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹) ≤ 12 / t |
| [`RHPull.inv_sqrt_mul_self`](./lean_stage3/LineBound.md#RHPull-inv_sqrt_mul_self) | theorem | `LineBound` | (Real.sqrt X)⁻¹ * X = Real.sqrt X |
| [`Transform.inversion_fixes_circle`](./lean/Transform.md#Transform-inversion_fixes_circle) | theorem | `Transform` | ‖(b : ℂ) ^ (-(1 : ℂ)) / z‖ = ‖z‖ ↔ ‖z‖ = b ^ (-(1 : ℝ) / 2) |
| [`JointLadder.irrational_log_two_div_log_three`](./lean/JointLadder.md#JointLadder-irrational_log_two_div_log_three) | theorem | `JointLadder` | Irrational (Real.log 2 / Real.log 3) |
| [`Stage3.isEmpty_zeroHeight`](./lean_stage3/RealSegment.md#Stage3-isEmpty_zeroHeight) | theorem | `RealSegment` | IsEmpty Kadiri.ZeroHeightNontrivialZeros |
| [`Elephant.IsModeRow`](./lean/Elephant.md#Elephant-IsModeRow) | def | `Elephant` | Prop |
| [`VonKoch.isOpen_region`](./lean_stage3/VonKochScaffold.md#VonKoch-isOpen_region) | theorem | `VonKochScaffold` | IsOpen region |
| [`Stage3.isOpen_regionθ`](./lean_stage3/ThetaConverse.md#Stage3-isOpen_region-) | theorem | `ThetaConverse` | IsOpen (regionθ θ) |
| [`ZetaGrowth.isOpen_stripRegion`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-isOpen_stripRegion) | theorem | `ZetaGrowth` | IsOpen stripRegion |
| [`Zeros.IsTable`](./lean/Zeros.md#Zeros-IsTable) | def | `Zeros` | Prop |
| [`Construction.IsTableOf`](./lean/Construction.md#Construction-IsTableOf) | def | `Construction` | Prop |
| [`Bridge.IsTest`](./lean_bridge/WeilBridge.md#Bridge-IsTest) | def | `WeilBridge` | Prop |
| [`WeilDetect.IsTest`](./lean_stage3/WeilDetect.md#WeilDetect-IsTest) | def | `WeilDetect` | Prop |
| [`WeilPowerAssembly.isTest_phiWC`](./lean_stage3/WeilPowerAssembly.md#WeilPowerAssembly-isTest_phiWC) | theorem | `WeilPowerAssembly` | IsTest (2 * h) (WeilPowerBackground.phiWC h γ m) |
| [`MainTerm.iter_bdiffR_eq_fwdDiff`](./lean/MainTerm.md#MainTerm-iter_bdiffR_eq_fwdDiff) | theorem | `MainTerm` | (bdiffR^[n]) g x = (-1 : ℝ) ^ n * (fwdDiff (-1 : ℝ))^[n] g x |
| [`MainTerm.iter_bdiffR_eq_sum`](./lean/MainTerm.md#MainTerm-iter_bdiffR_eq_sum) | theorem | `MainTerm` | (bdiffR^[n]) g x = ∑ k ∈ range (n + 1), (-1 : ℝ) ^ k * (n.choose k) * g (x - k) |
| [`MainTerm.iter_bdiffR_lb`](./lean/MainTerm.md#MainTerm-iter_bdiffR_lb) | theorem | `MainTerm` | m ≤ (bdiffR^[n]) g x |
| [`Nonvanishing.iter_bdiffZ_eq_fwdDiff`](./lean/Nonvanishing.md#Nonvanishing-iter_bdiffZ_eq_fwdDiff) | theorem | `Nonvanishing` | (bdiffZ^[n]) g r = (-1 : ℝ) ^ n * (fwdDiff (-1 : ℤ))^[n] g r |
| [`Nonvanishing.iter_bdiffZ_eq_stencilR`](./lean/Nonvanishing.md#Nonvanishing-iter_bdiffZ_eq_stencilR) | theorem | `Nonvanishing` | (bdiffZ^[n]) g r = stencilR n g r |
| [`MainTerm.iteratedDeriv_bdiffR`](./lean/MainTerm.md#MainTerm-iteratedDeriv_bdiffR) | theorem | `MainTerm` | iteratedDeriv n (bdiffR g) = bdiffR (iteratedDeriv n g) |
| [`Expansion.iteratedDeriv_f2x`](./lean/Expansion.md#Expansion-iteratedDeriv_f2x) | theorem | `Expansion` | ∀ x ∈ Ioi (0 : ℝ), iteratedDeriv d f2x x = F d x |
| [`LandauPoleSub.iteratedDeriv_inv_sub`](./lean_stage3/LandauPoleSub.md#LandauPoleSub-iteratedDeriv_inv_sub) | theorem | `LandauPoleSub` | iteratedDeriv k (fun s : ℂ =&gt; (s - q)⁻¹) c = (-1) ^ k * (k.factorial : ℂ) * (c - q) ^ (-1 - (k : ℤ)) |
| [`LandauTaylor.iteratedDeriv_Phi`](./lean_stage3/LandauTaylor.md#LandauTaylor-iteratedDeriv_Phi) | theorem | `LandauTaylor` | iteratedDeriv k LandauMellinG.Phi s = mellinLog k s |
| [`LandauPrimeSide.iteratedDeriv_Phi_eq_Ik`](./lean_stage3/LandauPrimeSide.md#LandauPrimeSide-iteratedDeriv_Phi_eq_Ik) | theorem | `LandauPrimeSide` | iteratedDeriv k LandauMellinG.Phi (σ : ℂ) = (-1) ^ k * ((Ik σ k : ℝ) : ℂ) |
| [`Stage3.jensenF`](./lean_stage3/JensenCount.md#Stage3-jensenF) | def | `JensenCount` | ℂ → ℂ |
| [`Stage3.jensenF_analytic`](./lean_stage3/JensenCount.md#Stage3-jensenF_analytic) | theorem | `JensenCount` | AnalyticOnNhd ℂ (jensenF T) (Metric.closedBall (0 : ℂ) 1) |
| [`Stage3.jensenF_bound`](./lean_stage3/JensenCount.md#Stage3-jensenF_bound) | theorem | `JensenCount` | ‖jensenF T z‖ ≤ 84 * T |
| [`Stage3.jensenF_order`](./lean_stage3/JensenCount.md#Stage3-jensenF_order) | theorem | `JensenCount` | analyticOrderNatAt (jensenF T) w = analyticOrderNatAt ζ (2 * w + (2 + Complex.I * (T : ℂ))) |
| [`Stage3.jensenF_zero_eq_one`](./lean_stage3/JensenCount.md#Stage3-jensenF_zero_eq_one) | theorem | `JensenCount` | jensenF T 0 = 1 |
| [`Stage3.jensenF_zeros_finite`](./lean_stage3/JensenCount.md#Stage3-jensenF_zeros_finite) | theorem | `JensenCount` | (SetOfZeros 1 (jensenF T)).Finite |
| [`JointLadder.jmode`](./lean/JointLadder.md#JointLadder-jmode) | def | `JointLadder` | ℤ → ℤ → ℂ |
| [`Chain.joint_gain_periodic_of_commensurate`](./lean/Chain.md#Chain-joint_gain_periodic_of_commensurate) | theorem | `Chain` | Function.Periodic (fun γ : ℝ =&gt; ‖Sym b₁ ((1 : ℂ)/2 + γ * I)‖ ^ 2 * ‖Sym b₂ ((1 : ℂ)/2 + γ * I)‖ ^ 2) ((m : ℝ) * (2 * Real.pi / Real.log b₁)) |
| [`JointLadder.JointAliases`](./lean/JointLadder.md#JointLadder-JointAliases) | def | `JointLadder` | Prop |
| [`JointLadder.jointAliases_iff_eq`](./lean/JointLadder.md#JointLadder-jointAliases_iff_eq) | theorem | `JointLadder` | JointAliases γ γ' ↔ γ = γ' |
| [`JointLadder.jointSample`](./lean/JointLadder.md#JointLadder-jointSample) | def | `JointLadder` | ℝ |
| [`WeilPower.K`](./lean_stage3/WeilPower.md#WeilPower-K) | def | `WeilPower` | ℂ |
| [`WeilPower.K_mul_Q`](./lean_stage3/WeilPower.md#WeilPower-K_mul_Q) | theorem | `WeilPower` | K m w * Q m w = (cK m : ℂ) * Complex.sinh w |
| [`WeilPower.K_one_mul`](./lean_stage3/WeilPower.md#WeilPower-K_one_mul) | theorem | `WeilPower` | K 1 w * (w * (w ^ 2 + (Real.pi : ℂ) ^ 2)) = (Real.pi : ℂ) ^ 2 * Complex.sinh w |
| [`WeilPower.K_succ`](./lean_stage3/WeilPower.md#WeilPower-K_succ) | theorem | `WeilPower` | K (m + 1) w * (w ^ 2 + (Real.pi : ℂ) ^ 2 * ((m : ℂ) + 1) ^ 2) = ((m : ℂ) + 1) * (2 * (m : ℂ) + 1) * (Real.pi : ℂ) ^ 2 / 2 * K m w |
| [`WeilPower.K_zero_mul`](./lean_stage3/WeilPower.md#WeilPower-K_zero_mul) | theorem | `WeilPower` | K 0 w * w = 2 * Complex.sinh w |
| [`PerronKernel.kernel_diff_summable`](./lean_stage3/PerronKernel.md#PerronKernel-kernel_diff_summable) | theorem | `PerronKernel` | Summable (fun n : ℕ ↦ (ArithmeticFunction.vonMangoldt n : ℂ) * (perronI (x/n) (1 + 1/Real.log x) T - perronδ (x/n))) |
| [`PerronKernel.kernel_holo`](./lean_stage3/PerronKernel.md#PerronKernel-kernel_holo) | theorem | `PerronKernel` | HolomorphicOn (fun s : ℂ ↦ (y : ℂ) ^ s / s) {s : ℂ \| 0 &lt; s.re} |
| [`LandauKernel.kernel_le`](./lean_stage3/LandauKernel.md#LandauKernel-kernel_le) | theorem | `LandauKernel` | Real.log y ^ n * y ^ (-a - 1) ≤ y ^ (-(a / 2) - 1) / (a / (2 * (n + 1))) ^ n |
| [`RHPull.kernel_le`](./lean_stage3/LineBound.md#RHPull-kernel_le) | theorem | `LineBound` | ((σRH X) ^ 2 + t ^ 2)⁻¹ ≤ 4 * (1 + t ^ 2)⁻¹ |
| [`Stage3.kernel_le_theta`](./lean_stage3/ThetaPull.md#Stage3-kernel_le_theta) | theorem | `ThetaPull` | ((σθ θ X) ^ 2 + t ^ 2)⁻¹ ≤ 4 * (1 + t ^ 2)⁻¹ |
| [`RHPull.kernel_modulus_le`](./lean_stage3/LineBound.md#RHPull-kernel_modulus_le) | theorem | `LineBound` | ‖((x : ℂ)) ^ (w - 1)‖ ≤ 2 |
| [`LandauTail.kernel_nonneg`](./lean_stage3/LandauTail.md#LandauTail-kernel_nonneg) | theorem | `LandauTail` | 0 ≤ᵐ[volume.restrict (Ioi (1 : ℝ))] fun y : ℝ =&gt; Real.log y ^ k * y ^ (-a - 1) |
| [`PerronKernel.kernel_sum_bound`](./lean_stage3/PerronKernel.md#PerronKernel-kernel_sum_bound) | theorem | `PerronKernel` | ‖(∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * (perronI (x/n) (1 + 1/Real.log x) T - perronδ (x/n)))‖ ≤ 600 * x * Real.log (x * T) ^ 2 / T + 12 * Real.log x |
| [`LandauRates.key_ineq`](./lean_stage3/LandauRates.md#LandauRates-key_ineq) | theorem | `LandauRates` | 4 * (lam - Real.log (1 - δ / 12)) &lt; (1 + δ) * (Real.log (1 + δ / 3) - lam) ∧ 0 &lt; Real.log (1 + δ / 3) - lam ∧ 0 &lt; lam - Real.log (1 - δ / 12) |
| [`Bridge.kOf`](./lean_bridge/WeilBridge.md#Bridge-kOf) | def | `WeilBridge` | ℝ → ℂ |
| [`Bridge.kOfM`](./lean_bridge/WeilBridge.md#Bridge-kOfM) | def | `WeilBridge` | ℝ → ℂ |
| [`WeilBridgeLeaf.kOfM`](./lean_stage3/WeilBridgeLeaf.md#WeilBridgeLeaf-kOfM) | def | `WeilBridgeLeaf` | ℝ → ℂ |
| [`Bridge.kOfM_eq`](./lean_bridge/WeilBridge.md#Bridge-kOfM_eq) | theorem | `WeilBridge` | kOfM G = kOf G |
| [`Zeros.LaddersMeet`](./lean/ZerosStencil.md#Zeros-LaddersMeet) | def | `ZerosStencil` | Prop |
| [`Bridge.laplace`](./lean_bridge/WeilBridge.md#Bridge-laplace) | def | `WeilBridge` | ℂ |
| [`WeilDetect.laplace`](./lean_stage3/WeilDetect.md#WeilDetect-laplace) | def | `WeilDetect` | ℂ |
| [`WeilDetect.laplace_conj`](./lean_stage3/WeilDetect.md#WeilDetect-laplace_conj) | theorem | `WeilDetect` | laplace G ((starRingEnd ℂ) z) = (starRingEnd ℂ) (laplace G z) |
| [`Bridge.laplace_neg_eq`](./lean_bridge/WeilBridge.md#Bridge-laplace_neg_eq) | theorem | `WeilBridge` | laplace G (-ρ) = paperFT (tiltF G) (gammaOf ρ) |
| [`WeilBackground.laplace_phi`](./lean_stage3/WeilBackground.md#WeilBackground-laplace_phi) | theorem | `WeilBackground` | laplace (phiC h γ) z = ghat h γ (-z - 1 / 2) |
| [`WeilPowerBackground.laplace_phiW`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-laplace_phiW) | theorem | `WeilPowerBackground` | laplace (phiWC h γ m) z = what h γ m (-z - 1 / 2) |
| [`Bridge.laplace_reflect_eq`](./lean_bridge/WeilBridge.md#Bridge-laplace_reflect_eq) | theorem | `WeilBridge` | laplace G (-(1 - ρ)) = paperFT (tiltF G) (-gammaOf ρ) |
| [`Elephant.lattice_step`](./lean/Elephant.md#Elephant-lattice_step) | theorem | `Elephant` | Sym b ((k : ℂ) * (2 * Real.pi * Complex.I / Real.log b)) = 0 ∧ Sym b (((k + 1 : ℤ) : ℂ) * (2 * Real.pi * Complex.I / Real.log b)) = 0 ∧ ((k + 1 : ℤ) : ℂ) * (2 * Real.pi * Complex.I / Real.log b) - (k … |
| [`Transform.latticeBasis`](./lean/Transform.md#Transform-latticeBasis) | def | `Transform` | Module.Basis (Fin 2) ℝ ℂ |
| [`Stage3.Li`](./lean_stage3/PsiToPi.md#Stage3-Li) | def | `PsiToPi` | ℝ |
| [`Stage3.Li_two_rpow`](./lean_stage3/RowLeaves.md#Stage3-Li_two_rpow) | theorem | `RowLeaves` | Li ((2 : ℝ) ^ x) = 2 / Real.log 2 + ∫ t in (1 : ℝ)..x, Real.exp (Real.log 2 * t) / t |
| [`Interpolant.liRow`](./lean/Interpolant.md#Interpolant-liRow) | def | `Interpolant` | ℝ |
| [`Interpolant.liRow_contDiff`](./lean/Interpolant.md#Interpolant-liRow_contDiff) | theorem | `Interpolant` | ContDiff ℝ (⊤ : ℕ∞) liRow |
| [`Interpolant.liRow_eq`](./lean/Interpolant.md#Interpolant-liRow_eq) | theorem | `Interpolant` | liRow x = 2 / Real.log 2 + ∫ t in (1 : ℝ)..x, Expansion.f2x t |
| [`Interpolant.liRow_hasDerivAt`](./lean/Interpolant.md#Interpolant-liRow_hasDerivAt) | theorem | `Interpolant` | HasDerivAt liRow (Expansion.f2x x) x |
| [`WeilLobe.lobe_bound`](./lean_stage3/WeilLobe.md#WeilLobe-lobe_bound) | theorem | `WeilLobe` | ‖SigmaC (((ε : ℂ) + 2 * Complex.I * (γ : ℂ)) * (h : ℂ))‖ ≤ (2 * Real.pi + Real.pi ^ 2) * Real.cosh (ε * h) / (2 * γ * h) ^ 2 |
| [`Stage3.localCount_holds`](./lean_stage3/JensenCount.md#Stage3-localCount_holds) | theorem | `JensenCount` | StmtLocalCount zetaLocalCount 15 73 |
| [`Slice4.log_1300_le`](./lean_stage3/LineBound.md#Slice4-log_1300_le) | theorem | `LineBound` | Real.log 1300 ≤ 7.28 |
| [`Slice3.log_3029_ge`](./lean_stage3/LineBound.md#Slice3-log_3029_ge) | theorem | `LineBound` | (1:ℝ)/30 ≤ Real.log (30/29) |
| [`JointDialGate.log_absorbed`](./lean_stage3/JointDialGate.md#JointDialGate-log_absorbed) | theorem | `JointDialGate` | C * x ^ θ * Real.log x ^ k ≤ C / (2 * (θ' - θ) / (2 * ((k : ℝ) + 1))) ^ k * x ^ θ' |
| [`LandauMellinG.log_cpow_integrable`](./lean_stage3/LandauMellinG.md#LandauMellinG-log_cpow_integrable) | theorem | `LandauMellinG` | IntegrableOn (fun y : ℝ =&gt; (Real.log y : ℂ) * (y : ℂ) ^ (-s)) (Ioi 1) |
| [`LandauMellinG.log_cpow_integral`](./lean_stage3/LandauMellinG.md#LandauMellinG-log_cpow_integral) | theorem | `LandauMellinG` | ∫ y in Ioi (1 : ℝ), (Real.log y : ℂ) * (y : ℂ) ^ (-s) = 1 / (s - 1) ^ 2 |
| [`LandauMellinG.log_cpow_norm_le`](./lean_stage3/LandauMellinG.md#LandauMellinG-log_cpow_norm_le) | theorem | `LandauMellinG` | ‖(Real.log y : ℂ) * (y : ℂ) ^ (-s)‖ ≤ y ^ ((s.re - 1) / 2 - s.re) / ((s.re - 1) / 2) |
| [`LandauChebyshev.log_four_lt_two`](./lean_stage3/LandauChebyshev.md#LandauChebyshev-log_four_lt_two) | theorem | `LandauChebyshev` | Real.log 4 &lt; 2 |
| [`JointLadder.log_indep`](./lean/JointLadder.md#JointLadder-log_indep) | theorem | `JointLadder` | l = 0 ∧ k = 0 |
| [`Stage3.log_norm_z_le`](./lean_stage3/Stirling.md#Stage3-log_norm_z_le) | theorem | `Stirling` | \|Real.log ‖(1 : ℂ) / 4 + (t : ℂ) / 2 * Complex.I‖ - Real.log (t / 2)\| ≤ 1 / (4 * t) |
| [`LandauKernel.log_pow_integrable`](./lean_stage3/LandauKernel.md#LandauKernel-log_pow_integrable) | theorem | `LandauKernel` | IntegrableOn (fun y : ℝ =&gt; Real.log y ^ n * y ^ (-a - 1)) (Ioi 1) |
| [`LandauKernel.log_pow_integral`](./lean_stage3/LandauKernel.md#LandauKernel-log_pow_integral) | theorem | `LandauKernel` | ∫ y in Ioi (1 : ℝ), Real.log y ^ k * y ^ (-a - 1) = k.factorial / a ^ (k + 1) |
| [`Stage3.log_pow_isBigO_rpow`](./lean_stage3/ThetaConverse.md#Stage3-log_pow_isBigO_rpow) | theorem | `ThetaConverse` | (fun t : ℝ ↦ (Real.log t) ^ k) =O[Filter.atTop] (fun t : ℝ ↦ t ^ δ) |
| [`LandauKernel.log_pow_le`](./lean_stage3/LandauKernel.md#LandauKernel-log_pow_le) | theorem | `LandauKernel` | Real.log y ^ n ≤ y ^ (a / 2) / (a / (2 * (n + 1))) ^ n |
| [`WeilPowerGeom.log_step`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-log_step) | theorem | `WeilPowerGeom` | 1 / ((m : ℝ) + 1) ≤ Real.log ((m : ℝ) + 1) - Real.log m |
| [`WeilPowerGeom.log_telescope`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-log_telescope) | theorem | `WeilPowerGeom` | ∀ b : ℕ, a ≤ b → ∑ m ∈ Finset.Ico a b, 1 / ((m : ℝ) + 1) ≤ Real.log b - Real.log a |
| [`Stage3.log_two_pi_le`](./lean_stage3/ZeroSum.md#Stage3-log_two_pi_le) | theorem | `ZeroSum` | Real.log (2 * Real.pi) ≤ 2 |
| [`Stage3.logDeriv_congr_of_eventuallyEq`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_congr_of_eventuallyEq) | theorem | `ArgIdentity` | logDeriv f x = logDeriv g x |
| [`Stage3.logDeriv_gammaR`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR) | theorem | `ArgIdentity` | logDeriv Gammaℝ s = -(Real.log Real.pi : ℂ) / 2 + Complex.digamma (s / 2) / 2 |
| [`Stage3.logDeriv_gammaR_analyticAt`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR_analyticAt) | theorem | `ArgIdentity` | AnalyticAt ℂ (logDeriv Gammaℝ) z |
| [`Stage3.logDeriv_gammaR_comp_continuous`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR_comp_continuous) | theorem | `ArgIdentity` | Continuous fun x : ℝ =&gt; logDeriv Gammaℝ (g x) |
| [`Stage3.logDeriv_gammaR_conj`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR_conj) | theorem | `ArgIdentity` | logDeriv Gammaℝ (conj s) = conj (logDeriv Gammaℝ s) |
| [`Stage3.logDeriv_gammaR_continuousAt`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR_continuousAt) | theorem | `ArgIdentity` | ContinuousAt (logDeriv Gammaℝ) z |
| [`Stage3.logDeriv_gammaR_holo`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR_holo) | theorem | `ArgIdentity` | HolomorphicOn (logDeriv Gammaℝ) {s : ℂ \| 0 &lt; s.re} |
| [`Stage3.logDeriv_gammaR_im_eq_zero`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_gammaR_im_eq_zero) | theorem | `ArgIdentity` | (logDeriv Gammaℝ ((x : ℝ) : ℂ)).im = 0 |
| [`Stage3.logDeriv_xi_conj`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_xi_conj) | theorem | `ArgIdentity` | logDeriv xi (conj s) = conj (logDeriv xi s) |
| [`Stage3.logDeriv_xi_continuousAt`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_xi_continuousAt) | theorem | `ArgIdentity` | ContinuousAt (logDeriv xi) p |
| [`Stage3.logDeriv_xi_meromorphicAt`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_xi_meromorphicAt) | theorem | `ArgIdentity` | MeromorphicAt (logDeriv xi) s |
| [`Stage3.logDeriv_xi_one_sub`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_xi_one_sub) | theorem | `ArgIdentity` | logDeriv xi (1 - s) = -logDeriv xi s |
| [`Stage3.logDeriv_xi_split`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_xi_split) | theorem | `ArgIdentity` | logDeriv xi s = 1 / s + 1 / (s - 1) + logDeriv Gammaℝ s + logDeriv riemannZeta s |
| [`Stage3.logDeriv_zeta_analyticAt`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_zeta_analyticAt) | theorem | `ArgIdentity` | AnalyticAt ℂ (logDeriv riemannZeta) z |
| [`Elephant.logDeriv_zeta_coeffs`](./lean/Elephant.md#Elephant-logDeriv_zeta_coeffs) | theorem | `Elephant` | LSeries (fun n =&gt; (vonMangoldt n : ℂ)) s = -deriv riemannZeta s / riemannZeta s |
| [`Stage3.logDeriv_zeta_continuousAt`](./lean_stage3/ArgIdentity.md#Stage3-logDeriv_zeta_continuousAt) | theorem | `ArgIdentity` | ContinuousAt (logDeriv riemannZeta) z |
| [`Slice4.logDeriv_zetaE`](./lean_stage3/LineBound.md#Slice4-logDeriv_zetaE) | theorem | `LineBound` | deriv zetaE s / zetaE s = 1 / (s - 1) + deriv ζ s / ζ s |
| [`Slice4.logDerivZeta_compact`](./lean_stage3/LineBound.md#Slice4-logDerivZeta_compact) | theorem | `LineBound` | ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖ ≤ 14535 + 212 / (σ₁ - 1/2) |
| [`Stage3.logDerivZeta_compact_theta`](./lean_stage3/ThetaLine.md#Stage3-logDerivZeta_compact_theta) | theorem | `ThetaLine` | ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖ ≤ 14530 + 2 / (1 - θ) + 212 / (σ₁ - θ) |
| [`Slice3.logDerivZeta_crude`](./lean_stage3/LineBound.md#Slice3-logDerivZeta_crude) | theorem | `LineBound` | ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖ ≤ 1996 * Real.log (84 * t) + (29 * Real.log t + 129) / (σ₁ - 1/2) |
| [`Stage3.logDerivZeta_crude_half`](./lean_stage3/Abscissa.md#Stage3-logDerivZeta_crude_half) | theorem | `Abscissa` | ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖ ≤ 1996 * Real.log (84 * t) + (29 * Real.log t + 129) / (σ₁ - 1/2) |
| [`Stage3.logDerivZeta_crude_theta`](./lean_stage3/Abscissa.md#Stage3-logDerivZeta_crude_theta) | theorem | `Abscissa` | ‖deriv ζ ((σ₁ : ℂ) + I * (t : ℂ)) / ζ ((σ₁ : ℂ) + I * (t : ℂ))‖ ≤ 1996 * Real.log (84 * t) + (29 * Real.log t + 129) / (σ₁ - θ) |
| [`Slice4b.logDerivZeta_line`](./lean_stage3/LineBound.md#Slice4b-logDerivZeta_line) | theorem | `LineBound` | ‖deriv ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ)) / ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))‖ ≤ 11100 * (Real.log X) ^ 2 |
| [`Stage3.logDerivZeta_line_half`](./lean_stage3/ThetaLine.md#Stage3-logDerivZeta_line_half) | theorem | `ThetaLine` | ‖deriv ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ)) / ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))‖ ≤ 11100 * (Real.log X) ^ 2 |
| [`Stage3.logDerivZeta_line_theta`](./lean_stage3/ThetaLine.md#Stage3-logDerivZeta_line_theta) | theorem | `ThetaLine` | ‖deriv ζ (((θ + 1/Real.log X : ℝ)) + I * (t : ℂ)) / ζ (((θ + 1/Real.log X : ℝ)) + I * (t : ℂ))‖ ≤ 11100 * (Real.log X) ^ 2 |
| [`EdgeBound.logDerivZeta_low_edge`](./lean_stage3/LowEdge.md#EdgeBound-logDerivZeta_low_edge) | theorem | `LowEdge` | ‖deriv riemannZeta u / riemannZeta u‖ ≤ 1620000 |
| [`Slice4b.logDerivZeta_norm_neg`](./lean_stage3/LineBound.md#Slice4b-logDerivZeta_norm_neg) | theorem | `LineBound` | ‖deriv ζ ((σ : ℂ) + I * ((-t : ℝ) : ℂ)) / ζ ((σ : ℂ) + I * ((-t : ℝ) : ℂ))‖ = ‖deriv ζ ((σ : ℂ) + I * (t : ℂ)) / ζ ((σ : ℂ) + I * (t : ℂ))‖ |
| [`EdgeBound.logDerivZeta_short_segment`](./lean_stage3/LowEdge.md#EdgeBound-logDerivZeta_short_segment) | theorem | `LowEdge` | ‖deriv riemannZeta (((-1/4 : ℝ):ℂ) + t * Complex.I) / riemannZeta (((-1/4 : ℝ):ℂ) + t * Complex.I)‖ ≤ 1620000 |
| [`Slice3.logDerivZeta_sq_at_t`](./lean_stage3/LineBound.md#Slice3-logDerivZeta_sq_at_t) | theorem | `LineBound` | ‖deriv ζ (((1/2 + 1/Real.log t : ℝ)) + I * (t : ℂ)) / ζ (((1/2 + 1/Real.log t : ℝ)) + I * (t : ℂ))‖ ≤ 21600 * (Real.log t) ^ 2 |
| [`Slice3.logDerivZeta_sq_at_X`](./lean_stage3/LineBound.md#Slice3-logDerivZeta_sq_at_X) | theorem | `LineBound` | ‖deriv ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ)) / ζ (((1/2 + 1/Real.log X : ℝ)) + I * (t : ℂ))‖ ≤ 11100 * (Real.log X) ^ 2 |
| [`Stage3.logDerivZeta_sq_at_X_theta`](./lean_stage3/ThetaLine.md#Stage3-logDerivZeta_sq_at_X_theta) | theorem | `ThetaLine` | ‖deriv ζ (((θ + 1/Real.log X : ℝ)) + I * (t : ℂ)) / ζ (((θ + 1/Real.log X : ℝ)) + I * (t : ℂ))‖ ≤ 11100 * (Real.log X) ^ 2 |
| [`LandauMellinG.logPrim`](./lean_stage3/LandauMellinG.md#LandauMellinG-logPrim) | def | `LandauMellinG` | ℂ |
| [`EdgeBound.low_ball_count`](./lean_stage3/LowCount.md#EdgeBound-low_ball_count) | theorem | `LowCount` | (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0 : ℝ) ≤ 8 / 5)).toFinset, (analyticOrderNatAt gz w : ℝ)) ≤ 119 |
| [`EdgeBound.low_ball_count_wide`](./lean_stage3/LowEdge.md#EdgeBound-low_ball_count_wide) | theorem | `LowEdge` | (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0 : ℝ) ≤ 46 / 25)).toFinset, (analyticOrderNatAt gz w : ℝ)) ≤ 250 |
| [`EdgeBound.low_rect_count`](./lean_stage3/LowCount.md#EdgeBound-low_rect_count) | theorem | `LowCount` | (∑ ρ ∈ (ContourShift.zeta_zeros_rectangle_finite (0 : ℂ) ((1 : ℝ) + Complex.I * (6 : ℝ))).toFinset, (analyticOrderNatAt riemannZeta ρ : ℝ)) ≤ 714 |
| [`WeilOnLine.lowCount`](./lean_stage3/WeilOnLine.md#WeilOnLine-lowCount) | def | `WeilOnLine` | ℝ |
| [`WeilOnLine.lowCount_nonneg`](./lean_stage3/WeilOnLine.md#WeilOnLine-lowCount_nonneg) | theorem | `WeilOnLine` | 0 ≤ lowCount |
| [`LandauTail.lower_tail_le`](./lean_stage3/LandauTail.md#LandauTail-lower_tail_le) | theorem | `LandauTail` | ∫ y in Ioc (1 : ℝ) Y, Real.log y ^ k * y ^ (-a - 1) ≤ Y ^ b * (k.factorial / (a + b) ^ (k + 1)) |
| [`WeilOnLine.lowSet`](./lean_stage3/WeilOnLine.md#WeilOnLine-lowSet) | def | `WeilOnLine` | Set ℂ |
| [`WeilOnLine.lowSet_finite`](./lean_stage3/WeilOnLine.md#WeilOnLine-lowSet_finite) | theorem | `WeilOnLine` | lowSet.Finite |
| [`WeilOnLine.lowU`](./lean_stage3/WeilOnLine.md#WeilOnLine-lowU) | def | `WeilOnLine` | Set ℂ |
| [`WeilOnLine.lowU_analytic`](./lean_stage3/WeilOnLine.md#WeilOnLine-lowU_analytic) | theorem | `WeilOnLine` | AnalyticOnNhd ℂ riemannZeta lowU |
| [`WeilOnLine.lowU_preconnected`](./lean_stage3/WeilOnLine.md#WeilOnLine-lowU_preconnected) | theorem | `WeilOnLine` | IsPreconnected lowU |
| [`LandauMellinG.LSeries_vonMangoldt_real_ne_zero`](./lean_stage3/LandauMellinG.md#LandauMellinG-LSeries_vonMangoldt_real_ne_zero) | theorem | `LandauMellinG` | L ↗Λ (σ : ℂ) ≠ 0 |
| [`Stage3.lt_σθ`](./lean_stage3/ThetaPsi.md#Stage3-lt_--) | theorem | `ThetaPsi` | θ &lt; σθ θ X |
| [`WeilPowerBands.M`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-M) | def | `WeilPowerBands` | ℝ |
| [`WeilSeries.M`](./lean_stage3/WeilSeries.md#WeilSeries-M) | def | `WeilSeries` | ℝ |
| [`WeilWindow.m2`](./lean_stage3/WeilWindow.md#WeilWindow-m2) | def | `WeilWindow` | ℝ |
| [`WeilWindow.m2_ge`](./lean_stage3/WeilWindow.md#WeilWindow-m2_ge) | theorem | `WeilWindow` | 1 / 24 ≤ m2 |
| [`WeilWindow.m2_le`](./lean_stage3/WeilWindow.md#WeilWindow-m2_le) | theorem | `WeilWindow` | m2 ≤ 2 / 3 |
| [`WeilPowerBands.M_nonneg`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-M_nonneg) | theorem | `WeilPowerBands` | 0 ≤ M h γ m k |
| [`WeilSeries.M_nonneg`](./lean_stage3/WeilSeries.md#WeilSeries-M_nonneg) | theorem | `WeilSeries` | 0 ≤ M h γ k |
| [`WeilPowerGeom.Mab`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-Mab) | def | `WeilPowerGeom` | ℝ |
| [`WeilPowerGeomGen.MabGen`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-MabGen) | def | `WeilPowerGeomGen` | ℝ |
| [`WeilPowerShell.MabGen_le`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-MabGen_le) | theorem | `WeilPowerShell` | WeilPowerGeomGen.MabGen (zOf e' D e) (1 / ((lam : ℝ) * Real.pi ^ 2)) (-1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) a b ≤ Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) |
| [`ArgCount.mainTerm_abs_le`](./lean_stage3/ArgCount.md#ArgCount-mainTerm_abs_le) | theorem | `ArgCount` | \|Kadiri.zetaCountingMainTerm T\| ≤ 3 |
| [`VonKoch.measurable_psi`](./lean_stage3/VonKochScaffold.md#VonKoch-measurable_psi) | theorem | `VonKochScaffold` | Measurable (fun t : ℝ ↦ ψ t) |
| [`VonKoch.measurable_psi'`](./lean_stage3/VonKochScaffold.md#VonKoch-measurable_psi-) | theorem | `VonKochScaffold` | Measurable (fun t : ℝ ↦ ψ t) |
| [`GeneratorPeak.measured`](./lean/GeneratorPeak.md#GeneratorPeak-measured) | def | `GeneratorPeak` | List ℝ |
| [`Measured.measured_breakdown_prime`](./lean/Measured.md#Measured-measured_breakdown_prime) | def | `Measured` | ℕ |
| [`Measured.measured_breakdown_resid`](./lean/Measured.md#Measured-measured_breakdown_resid) | def | `Measured` | ℕ |
| [`Zeros.measured_centered_zero_count`](./lean/Zeros.md#Zeros-measured_centered_zero_count) | def | `Zeros` | ℕ |
| [`SeedPerturbation.measured_composite`](./lean/SeedPerturbation.md#SeedPerturbation-measured_composite) | def | `SeedPerturbation` | List ℤ |
| [`PairIdentity.measured_composite_at_zeros`](./lean/PairIdentity.md#PairIdentity-measured_composite_at_zeros) | def | `PairIdentity` | List ℤ |
| [`SeedPerturbation.measured_composite_four`](./lean/SeedPerturbation.md#SeedPerturbation-measured_composite_four) | def | `SeedPerturbation` | List ℤ |
| [`PairIdentity.measured_composite_matches_pair_identity`](./lean/PairIdentity.md#PairIdentity-measured_composite_matches_pair_identity) | theorem | `PairIdentity` | zero_cells.map (fun c =&gt; ((2 : ℤ) - 1) ^ (c.2 + 1) * 2 ^ (c.1 - 1 - c.2)) = measured_composite_at_zeros |
| [`SeedPerturbation.measured_composite_silence46`](./lean/SeedPerturbation.md#SeedPerturbation-measured_composite_silence46) | def | `SeedPerturbation` | List ℤ |
| [`Covering.measured_contributing`](./lean/Covering.md#Covering-measured_contributing) | def | `Covering` | ℕ |
| [`Measured.measured_contributing_primes`](./lean/Measured.md#Measured-measured_contributing_primes) | def | `Measured` | ℕ |
| [`Measured.measured_elliptic_max_dev`](./lean/Measured.md#Measured-measured_elliptic_max_dev) | def | `Measured` | ℝ |
| [`SeedPerturbation.measured_emptied_four`](./lean/SeedPerturbation.md#SeedPerturbation-measured_emptied_four) | def | `SeedPerturbation` | List ℤ |
| [`SeedPerturbation.measured_emptied_matches_shift`](./lean/SeedPerturbation.md#SeedPerturbation-measured_emptied_matches_shift) | theorem | `SeedPerturbation` | [1 - tableFrom emptied_excess 2 1, 4 - tableFrom emptied_excess 4 1, 16 - tableFrom emptied_excess 8 3, 8192 - tableFrom emptied_excess 20 6] = measured_emptied_four |
| [`Covering.measured_eps`](./lean/Covering.md#Covering-measured_eps) | def | `Covering` | ℝ |
| [`Measured.measured_exact_zeros`](./lean/Measured.md#Measured-measured_exact_zeros) | def | `Measured` | List (ℕ × ℕ) |
| [`Measured.measured_G4_peak`](./lean/Measured.md#Measured-measured_G4_peak) | def | `Measured` | List ℝ |
| [`GeneratorPeak.measured_has_interior_peak`](./lean/GeneratorPeak.md#GeneratorPeak-measured_has_interior_peak) | theorem | `GeneratorPeak` | (23.628706 : ℝ) &lt; 38.299307 ∧ (27.061132 : ℝ) &lt; 38.299307 |
| [`Covering.measured_in_support`](./lean/Covering.md#Covering-measured_in_support) | def | `Covering` | ℕ |
| [`Measured.measured_offset_resid`](./lean/Measured.md#Measured-measured_offset_resid) | def | `Measured` | ℝ |
| [`Measured.measured_offset_smooth`](./lean/Measured.md#Measured-measured_offset_smooth) | def | `Measured` | ℝ |
| [`Measured.measured_radius_resid`](./lean/Measured.md#Measured-measured_radius_resid) | def | `Measured` | ℝ |
| [`Measured.measured_radius_smooth`](./lean/Measured.md#Measured-measured_radius_smooth) | def | `Measured` | ℝ |
| [`Measured.measured_rank_11a1`](./lean/Measured.md#Measured-measured_rank_11a1) | def | `Measured` | ℝ |
| [`Measured.measured_rank_37a1`](./lean/Measured.md#Measured-measured_rank_37a1) | def | `Measured` | ℝ |
| [`Measured.measured_rank_389a1`](./lean/Measured.md#Measured-measured_rank_389a1) | def | `Measured` | ℝ |
| [`Zeros.measured_repeat_20_6`](./lean/Zeros.md#Zeros-measured_repeat_20_6) | def | `Zeros` | ℤ |
| [`Zeros.measured_repeat_8_3`](./lean/Zeros.md#Zeros-measured_repeat_8_3) | def | `Zeros` | ℤ |
| [`Measured.measured_residual_from_zeros`](./lean/Measured.md#Measured-measured_residual_from_zeros) | def | `Measured` | List ℝ |
| [`Isogeny.measured_row_eight`](./lean/Isogeny.md#Isogeny-measured_row_eight) | theorem | `Isogeny` | (List.range 6).map (rowN Zeros.pi2 3) = [4, 14, 79, 467, 2948, 19488] |
| [`Isogeny.measured_row_four`](./lean/Isogeny.md#Isogeny-measured_row_four) | theorem | `Isogeny` | (List.range 10).map (rowN Zeros.pi2 2) = [2, 4, 12, 36, 118, 392, 1336, 4642, 16458, 59025] |
| [`SeedPerturbation.measured_silence46_matches_shift`](./lean/SeedPerturbation.md#SeedPerturbation-measured_silence46_matches_shift) | theorem | `SeedPerturbation` | [4 - tableFrom silence46_excess 4 1, 16 - tableFrom silence46_excess 8 3, 8192 - tableFrom silence46_excess 20 6] = measured_composite_silence46 |
| [`Covering.measured_spacing`](./lean/Covering.md#Covering-measured_spacing) | def | `Covering` | ℝ |
| [`Measured.measured_weil_arithmetic`](./lean/Measured.md#Measured-measured_weil_arithmetic) | def | `Measured` | ℝ |
| [`Measured.measured_weil_spectral`](./lean/Measured.md#Measured-measured_weil_spectral) | def | `Measured` | ℝ |
| [`Construction.measured_zeros`](./lean/Construction.md#Construction-measured_zeros) | def | `Construction` | List (ℕ × ℕ) |
| [`Zeros.measured_zeros`](./lean/Zeros.md#Zeros-measured_zeros) | def | `Zeros` | List (ℕ × ℕ) |
| [`Zeros.measured_zeros_all_vanish`](./lean/Zeros.md#Zeros-measured_zeros_all_vanish) | theorem | `Zeros` | ∀ c ∈ measured_zeros, Construction.tableFrom dyadicRow (c.1 : ℤ) c.2 = 0 |
| [`RHPull.mellin_bump_bounded`](./lean_stage3/LineBound.md#RHPull-mellin_bump_bounded) | theorem | `LineBound` | ∃ B &gt; 0, ∀ w : ℂ, 0 &lt; w.re → w.re ≤ 2 → ‖mellin (fun x ↦ (ν x : ℂ)) w‖ ≤ B |
| [`JointSymbol.mellin_dd`](./lean_stage3/JointSymbol.md#JointSymbol-mellin_dd) | theorem | `JointSymbol` | (∀ y : ℝ, y ≤ 1 → dd f y = 0) ∧ IntegrableOn (fun y : ℝ =&gt; dd f y * (y : ℂ) ^ (-s - 1)) (Ioi 1) ∧ ∫ y in Ioi (1 : ℝ), dd f y * (y : ℂ) ^ (-s - 1) = (1 - (2 : ℂ) ^ (-s)) * ∫ y in Ioi (1 : ℝ), f y * (y … |
| [`JointSymbol.mellin_dd_iter`](./lean_stage3/JointSymbol.md#JointSymbol-mellin_dd_iter) | theorem | `JointSymbol` | ∫ y in Ioi (1 : ℝ), (dd^[d] cutG) y * (y : ℂ) ^ (-s - 1) = (1 - (2 : ℂ) ^ (-s)) ^ d * LandauMellinG.Phi s |
| [`JointSymbol.mellin_dd_iter_aux`](./lean_stage3/JointSymbol.md#JointSymbol-mellin_dd_iter_aux) | theorem | `JointSymbol` | (∀ y : ℝ, y ≤ 1 → (dd^[d] f) y = 0) ∧ IntegrableOn (fun y : ℝ =&gt; (dd^[d] f) y * (y : ℂ) ^ (-s - 1)) (Ioi 1) ∧ ∫ y in Ioi (1 : ℝ), (dd^[d] f) y * (y : ℂ) ^ (-s - 1) = (1 - (2 : ℂ) ^ (-s)) ^ d * ∫ y in … |
| [`LandauMellinG.mellin_G`](./lean_stage3/LandauMellinG.md#LandauMellinG-mellin_G) | theorem | `LandauMellinG` | ∫ y in Ioi (1 : ℝ), (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1) = Phi s |
| [`RHPull.mellin_horiz_le`](./lean_stage3/LineBound.md#RHPull-mellin_horiz_le) | theorem | `LineBound` | ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) + I * (T : ℂ))‖ ≤ B / T |
| [`RHPull.mellin_horiz_le_neg`](./lean_stage3/LineBound.md#RHPull-mellin_horiz_le_neg) | theorem | `LineBound` | ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) - (T : ℂ) * I)‖ ≤ B / T |
| [`RHPull.mellin_main_const`](./lean_stage3/LineBound.md#RHPull-mellin_main_const) | theorem | `LineBound` | ∃ Cmain &gt; 0, ∃ ε₀ &gt; 0, ∀ ε : ℝ, 0 &lt; ε → ε &lt; ε₀ → ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 - 1‖ ≤ Cmain * ε |
| [`LandauMellin.mellin_rampSum`](./lean_stage3/LandauMellin.md#LandauMellin-mellin_rampSum) | theorem | `LandauMellin` | ∫ y in Ioi (1 : ℝ), (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1) = -deriv riemannZeta s / riemannZeta s / (s * (s - 1)) |
| [`JointSymbol.mellin_shift`](./lean_stage3/JointSymbol.md#JointSymbol-mellin_shift) | theorem | `JointSymbol` | IntegrableOn (fun y : ℝ =&gt; f (y / 2) * (y : ℂ) ^ (-s - 1)) (Ioi 1) ∧ ∫ y in Ioi (1 : ℝ), f (y / 2) * (y : ℂ) ^ (-s - 1) = (2 : ℂ) ^ (-s) * ∫ y in Ioi (1 : ℝ), f y * (y : ℂ) ^ (-s - 1) |
| [`RHPull.mellin_smooth1_le`](./lean_stage3/LineBound.md#RHPull-mellin_smooth1_le) | theorem | `LineBound` | ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) s‖ ≤ B * ‖s‖⁻¹ |
| [`RHPull.mellin_vert_le`](./lean_stage3/LineBound.md#RHPull-mellin_vert_le) | theorem | `LineBound` | ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σRH X : ℂ) + I * (t : ℂ))‖ ≤ B * ‖((σRH X : ℂ)) + I * (t : ℂ)‖⁻¹ |
| [`Stage3.mellin_vert_le_theta`](./lean_stage3/ThetaPsi.md#Stage3-mellin_vert_le_theta) | theorem | `ThetaPsi` | ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σθ θ X : ℂ) + I * (t : ℂ))‖ ≤ B * ‖((σθ θ X : ℂ)) + I * (t : ℂ)‖⁻¹ |
| [`LandauTaylor.mellinLog`](./lean_stage3/LandauTaylor.md#LandauTaylor-mellinLog) | def | `LandauTaylor` | ℂ |
| [`LandauTaylor.mellinLog_hasDerivAt`](./lean_stage3/LandauTaylor.md#LandauTaylor-mellinLog_hasDerivAt) | theorem | `LandauTaylor` | HasDerivAt (mellinLog k) (mellinLog (k + 1) s) s |
| [`LandauTaylor.mellinLog_integrable`](./lean_stage3/LandauTaylor.md#LandauTaylor-mellinLog_integrable) | theorem | `LandauTaylor` | IntegrableOn (fun y : ℝ =&gt; (LandauWindow.G y : ℂ) * (-(Real.log y : ℂ)) ^ k * (y : ℂ) ^ (-s - 1)) (Ioi 1) |
| [`LandauTaylor.mellinLog_real`](./lean_stage3/LandauTaylor.md#LandauTaylor-mellinLog_real) | theorem | `LandauTaylor` | mellinLog k (σ : ℂ) = (-1) ^ k * ((∫ y in Ioi (1 : ℝ), LandauWindow.G y * Real.log y ^ k * y ^ (-σ - 1) : ℝ) : ℂ) |
| [`ReZetaCount.mem_reZeros`](./lean_stage3/ReZetaCount.md#ReZetaCount-mem_reZeros) | theorem | `ReZetaCount` | x ∈ reZeros hT ↔ x ∈ Set.Ioo (1/2 : ℝ) 2 ∧ (riemannZeta ((x : ℂ) + T * Complex.I)).re = 0 |
| [`ArgLegs.mem_slitPlane_of_re_nonneg`](./lean_stage3/ArgLegs.md#ArgLegs-mem_slitPlane_of_re_nonneg) | theorem | `ArgLegs` | z ∈ Complex.slitPlane |
| [`ContourShift.mem_zetaWindow`](./lean_stage3/ContourShift.md#ContourShift-mem_zetaWindow) | theorem | `ContourShift` | ρ ∈ Stage3.zetaWindow T₀ |
| [`WeilBands.mem_zetaWindow_of_online`](./lean_stage3/WeilBands.md#WeilBands-mem_zetaWindow_of_online) | theorem | `WeilBands` | ρ ∈ Stage3.zetaWindow T |
| [`Stage3.meromorphicOrderAt_xi_eq_zeta`](./lean_stage3/ArgIdentity.md#Stage3-meromorphicOrderAt_xi_eq_zeta) | theorem | `ArgIdentity` | meromorphicOrderAt xi ρ = meromorphicOrderAt riemannZeta ρ |
| [`Nonvanishing.Mlow`](./lean/Nonvanishing.md#Nonvanishing-Mlow) | def | `Nonvanishing` | ℝ |
| [`Chain.mode`](./lean/Chain.md#Chain-mode) | def | `Chain` | ℂ → ℂ |
| [`Elephant.mode`](./lean/Elephant.md#Elephant-mode) | def | `Elephant` | ℤ → ℂ |
| [`TransferOp.mode_hasEigenvector`](./lean/TransferOp.md#TransferOp-mode_hasEigenvector) | theorem | `TransferOp` | bdiffL.HasEigenvector (Sym b ρ) (mode b ρ) |
| [`TransferOp.mode_ne_zero`](./lean/TransferOp.md#TransferOp-mode_ne_zero) | theorem | `TransferOp` | mode b ρ ≠ 0 |
| [`TransferOp.mode_ne_zero'`](./lean/TransferOp.md#TransferOp-mode_ne_zero-) | theorem | `TransferOp` | mode b ρ r ≠ 0 |
| [`TransferOp.mode_pow`](./lean/TransferOp.md#TransferOp-mode_pow) | theorem | `TransferOp` | (bdiffL ^ N) (mode b ρ) = (Sym b ρ) ^ N • mode b ρ |
| [`CellModes.mode_two_int`](./lean_stage3/CellModes.md#CellModes-mode_two_int) | theorem | `CellModes` | Chain.mode 2 ρ (r : ℂ) = ((2:ℂ) ^ ρ) ^ r |
| [`Superposition.modeSum`](./lean/Superposition.md#Superposition-modeSum) | def | `Superposition` | ℂ → ℂ |
| [`WeilWindow.mul_sinh_ge`](./lean_stage3/WeilWindow.md#WeilWindow-mul_sinh_ge) | theorem | `WeilWindow` | s * x ^ 2 ≤ x * Real.sinh (s * x) |
| [`Stage3.N_abs_le`](./lean_stage3/ZeroSum.md#Stage3-N_abs_le) | theorem | `ZeroSum` | \|riemannZeta.N T\| ≤ T / (2 * Real.pi) * (Real.log T + 3) + riemannZeta.RvM b₁ b₂ b₃ T + 7 / 8 |
| [`ArgCount.N_eq_of_no_zero_between`](./lean_stage3/ArgCount.md#ArgCount-N_eq_of_no_zero_between) | theorem | `ArgCount` | riemannZeta.N T = riemannZeta.N T₀ |
| [`ArgCount.N_eq_sum`](./lean_stage3/ArgCount.md#ArgCount-N_eq_sum) | theorem | `ArgCount` | riemannZeta.N T = ∑ z ∈ (Kadiri.zeroes_rect_univ_positive_height_finite T).toFinset, (1 : ℝ) * (riemannZeta.order z : ℝ) |
| [`Stage3.N_eq_sum`](./lean_stage3/ArgIdentity.md#Stage3-N_eq_sum) | theorem | `ArgIdentity` | riemannZeta.N T = ∑ ρ ∈ (Kadiri.zeroes_rect_univ_positive_height_finite T).toFinset, (riemannZeta.order ρ : ℝ) |
| [`ArgCount.N_mono`](./lean_stage3/ArgCount.md#ArgCount-N_mono) | theorem | `ArgCount` | riemannZeta.N T ≤ riemannZeta.N T' |
| [`ArgCount.N_nonneg`](./lean_stage3/ArgCount.md#ArgCount-N_nonneg) | theorem | `ArgCount` | 0 ≤ riemannZeta.N T |
| [`JointLadder.nat_log_indep`](./lean/JointLadder.md#JointLadder-nat_log_indep) | theorem | `JointLadder` | a = 0 ∧ b = 0 |
| [`Elephant.natCast_mul_cpow`](./lean/Elephant.md#Elephant-natCast_mul_cpow) | theorem | `Elephant` | ((m * n : ℕ) : ℂ) ^ s = (m : ℂ) ^ s * (n : ℂ) ^ s |
| [`PerronKernel.near_diagonal_sum`](./lean_stage3/PerronKernel.md#PerronKernel-near_diagonal_sum) | theorem | `PerronKernel` | (∑' n : ℕ, if 0 &lt; \|Real.log (x / n)\| ∧ \|Real.log (x / n)\| &lt; 1/2 then ArithmeticFunction.vonMangoldt n * min 1 (1/(T * \|Real.log (x / n)\|)) else 0) ≤ 100 * x * Real.log (x * T) ^ 2 / T + 4 * Real.log x |
| [`WeilPowerAssembly.near_nonneg`](./lean_stage3/WeilPowerAssembly.md#WeilPowerAssembly-near_nonneg) | theorem | `WeilPowerAssembly` | 0 ≤ ∑ ρ ∈ near_set, WeilPowerBands.termW h γ m ρ |
| [`Zeros.neg_below_zero`](./lean/Zeros.md#Zeros-neg_below_zero) | theorem | `Zeros` | Construction.tableFrom N r (d + 1) = -Construction.tableFrom N (r - 1) d |
| [`LandauChebyshev.neg_le_G`](./lean_stage3/LandauChebyshev.md#LandauChebyshev-neg_le_G) | theorem | `LandauChebyshev` | -(y * Real.log y) ≤ LandauWindow.G y |
| [`Propagation.neg_one_pow`](./lean/Propagation.md#Propagation-neg_one_pow) | theorem | `Propagation` | ((-1 : ℤ)) ^ m = 1 ∨ ((-1 : ℤ)) ^ m = -1 |
| [`Crossover.no_crossover_of_single`](./lean/Crossover.md#Crossover-no_crossover_of_single) | theorem | `Crossover` | ratio A 0 x y j ≠ 1 |
| [`GeneratorPeak.no_interior_peak`](./lean/GeneratorPeak.md#GeneratorPeak-no_interior_peak) | theorem | `GeneratorPeak` | False |
| [`VonKoch.no_zero_right_of_half`](./lean_stage3/VonKochScaffold.md#VonKoch-no_zero_right_of_half) | theorem | `VonKochScaffold` | riemannZeta ρ ≠ 0 |
| [`Stage3.no_zero_right_of_theta`](./lean_stage3/ThetaConverse.md#Stage3-no_zero_right_of_theta) | theorem | `ThetaConverse` | ζ ρ ≠ 0 |
| [`Nonvanishing.nonvanishing_of`](./lean/Nonvanishing.md#Nonvanishing-nonvanishing_of) | theorem | `Nonvanishing` | stencilR (d + 1) f r ≠ 0 |
| [`RelativeGate.nonvanishing_of_relErr`](./lean/RelativeGate.md#RelativeGate-nonvanishing_of_relErr) | theorem | `RelativeGate` | stencilR (d + 1) f r ≠ 0 |
| [`Zeros.nonzero_19_6`](./lean/Zeros.md#Zeros-nonzero_19_6) | theorem | `Zeros` | Construction.tableFrom dyadicRow 19 6 = 343 |
| [`Zeros.nonzero_7_3`](./lean/Zeros.md#Zeros-nonzero_7_3) | theorem | `Zeros` | Construction.tableFrom dyadicRow 7 3 = 5 |
| [`WeilPowerPhase.norm_A_sq`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-norm_A_sq) | theorem | `WeilPowerPhase` | ‖((cS m / D m : ℝ) : ℂ) * w * P m w‖ ^ 2 = (cS m / D m) ^ 2 * ‖w‖ ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m) |
| [`WeilPowerShell.norm_coef`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-norm_coef) | theorem | `WeilPowerShell` | ‖coef e' D e‖ = (e' ^ 2 + D ^ 2) / e ^ 2 |
| [`WeilPowerGeom.norm_corr_le`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-norm_corr_le) | theorem | `WeilPowerGeom` | ‖Complex.exp (z * (u m : ℂ)) - Complex.exp (z * ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2)‖ ≤ Real.exp (z.re * ((m : ℝ) + 1 / 2) / Real.pi ^ 2) * (2 * ‖z‖) * (u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2) |
| [`WeilPowerGeomGen.norm_corr_le_gen`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-norm_corr_le_gen) | theorem | `WeilPowerGeomGen` | ‖Complex.exp (z * (u h : ℂ)) - Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ))‖ ≤ Real.exp (z.re * (α * (h : ℝ) + β₀)) * (2 * ‖z‖) * (c / ((h : ℝ) + 1)) |
| [`Elephant.norm_cpow_neg`](./lean/Elephant.md#Elephant-norm_cpow_neg) | theorem | `Elephant` | ‖(b : ℂ) ^ (-s)‖ = b ^ (-s.re) |
| [`Stage3.norm_cpow_of_RH`](./lean_stage3/Assembly.md#Stage3-norm_cpow_of_RH) | theorem | `Assembly` | ‖(x : ℂ) ^ (ρ : ℂ)‖ = Real.sqrt x |
| [`WeilPowerPhase.norm_delta_le`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-norm_delta_le) | theorem | `WeilPowerPhase` | ‖delta m w n‖ ≤ q m w |
| [`WeilPowerPhase.norm_exp_delta_sub_one_le`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-norm_exp_delta_sub_one_le) | theorem | `WeilPowerPhase` | ‖Complex.exp (delta m w n) - 1‖ ≤ 2 * q m w |
| [`WeilPowerBounds.norm_factor_ge`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_factor_ge) | theorem | `WeilPowerBounds` | w.re ^ 2 ≤ ‖w ^ 2 + (a : ℂ) ^ 2‖ |
| [`WeilPowerBounds.norm_factor_ge_far`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_factor_ge_far) | theorem | `WeilPowerBounds` | w.im ^ 2 / 2 ≤ ‖w ^ 2 + (a : ℂ) ^ 2‖ |
| [`WeilPowerTail.norm_g_le`](./lean_stage3/WeilPowerTail.md#WeilPowerTail-norm_g_le) | theorem | `WeilPowerTail` | ‖g w j‖ ≤ Real.exp ((w ^ 2).re * hterm j + ‖w‖ ^ 4 * hterm j ^ 2 / 2) |
| [`RHPull.norm_ge_height`](./lean_stage3/LineBound.md#RHPull-norm_ge_height) | theorem | `LineBound` | T ≤ ‖((σ : ℂ)) + I * (T : ℂ)‖ |
| [`RHPull.norm_ge_height_neg`](./lean_stage3/LineBound.md#RHPull-norm_ge_height_neg) | theorem | `LineBound` | T ≤ ‖((σ : ℂ)) - (T : ℂ) * I‖ |
| [`LandauTrig.norm_geom_Ico_le`](./lean_stage3/LandauTrig.md#LandauTrig-norm_geom_Ico_le) | theorem | `LandauTrig` | ‖∑ n ∈ Finset.Ico a (a + N), w ^ n‖ ≤ 2 / ‖w - 1‖ |
| [`WeilPowerGeom.norm_geom_le`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-norm_geom_le) | theorem | `WeilPowerGeom` | ‖∑ m ∈ Finset.Ico a b, Complex.exp (z * ((m : ℂ) + 1 / 2) / (Real.pi : ℂ) ^ 2)‖ ≤ geomBound z a b |
| [`WeilPowerGeomGen.norm_geom_le_gen`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-norm_geom_le_gen) | theorem | `WeilPowerGeomGen` | ‖∑ h ∈ Finset.Ico a b, Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ))‖ ≤ geomBoundGen z α β₀ a b |
| [`BoxBounds.norm_le_of_sq`](./lean_stage3/BoxBounds.md#BoxBounds-norm_le_of_sq) | theorem | `BoxBounds` | ‖z‖ ≤ c |
| [`RHPull.norm_line_ge`](./lean_stage3/LineBound.md#RHPull-norm_line_ge) | theorem | `LineBound` | (1 + \|t\|) / 3 ≤ ‖((σRH X : ℂ)) + I * (t : ℂ)‖ |
| [`Stage3.norm_line_ge_theta`](./lean_stage3/ThetaPull.md#Stage3-norm_line_ge_theta) | theorem | `ThetaPull` | (1 + \|t\|) / 3 ≤ ‖((σθ θ X : ℂ)) + I * (t : ℂ)‖ |
| [`WeilPowerPhase.norm_log_sub_le`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-norm_log_sub_le) | theorem | `WeilPowerPhase` | ‖Complex.log (g w j) - x w j‖ ≤ ‖x w j‖ ^ 2 |
| [`Slice5.norm_logDerivZeta_of_one_lt_re`](./lean_stage3/LineBound.md#Slice5-norm_logDerivZeta_of_one_lt_re) | theorem | `LineBound` | ‖deriv ζ s / ζ s‖ ≤ 2 / (s.re - 1) + 4 / (s.re - 1) ^ 2 |
| [`Slice5.norm_logDerivZeta_sigma0`](./lean_stage3/LineBound.md#Slice5-norm_logDerivZeta_sigma0) | theorem | `LineBound` | ‖deriv ζ (((1 + 1 / L : ℝ) : ℂ) + I * (t : ℂ)) / ζ (((1 + 1 / L : ℝ) : ℂ) + I * (t : ℂ))‖ ≤ 2 * L + 4 * L ^ 2 |
| [`Stage3.norm_logDerivZeta_zero`](./lean_stage3/RowLeaves.md#Stage3-norm_logDerivZeta_zero) | theorem | `RowLeaves` | ‖deriv riemannZeta 0 / riemannZeta 0‖ = Real.log (2 * Real.pi) |
| [`WeilPowerGauss.norm_one_add_le`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_one_add_le) | theorem | `WeilPowerGauss` | ‖1 + x‖ ≤ Real.exp (x.re + ‖x‖ ^ 2) |
| [`WeilPowerTail.norm_one_add_le`](./lean_stage3/WeilPowerTail.md#WeilPowerTail-norm_one_add_le) | theorem | `WeilPowerTail` | ‖1 + z‖ ≤ Real.exp (z.re + ‖z‖ ^ 2 / 2) |
| [`WeilPowerGeom.norm_one_sub_exp_ge`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-norm_one_sub_exp_ge) | theorem | `WeilPowerGeom` | Real.exp w.re * \|Real.sin w.im\| ≤ ‖1 - Complex.exp w‖ |
| [`WeilPowerBounds.norm_QS_ge`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_QS_ge) | theorem | `WeilPowerBounds` | (w.re ^ 2) ^ (m + 1) ≤ ‖QS m w‖ |
| [`WeilPowerBounds.norm_QS_ge_far`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_QS_ge_far) | theorem | `WeilPowerBounds` | (w.im ^ 2 / 2) ^ (m + 1) ≤ ‖QS m w‖ |
| [`WeilPowerBounds.norm_S_le`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_S_le) | theorem | `WeilPowerBounds` | ‖S m w‖ ≤ cS m * Real.cosh w.re / ‖QS m w‖ |
| [`WeilPowerBounds.norm_S_le'`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_S_le-) | theorem | `WeilPowerBounds` | ‖S m w‖ ≤ cS m * Real.cosh w.re / ‖QS m w‖ |
| [`WeilPowerSharp.norm_S_le_c_neg`](./lean_stage3/WeilPowerSharp.md#WeilPowerSharp-norm_S_le_c_neg) | theorem | `WeilPowerSharp` | ‖S m w‖ ≤ cS m / D m * ‖w‖ * Real.exp ((w ^ 2).re * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) |
| [`WeilPowerSharp.norm_S_le_c_pos`](./lean_stage3/WeilPowerSharp.md#WeilPowerSharp-norm_S_le_c_pos) | theorem | `WeilPowerSharp` | ‖S m w‖ ≤ cS m / D m * ‖w‖ * Real.exp ((w ^ 2).re / (Real.pi ^ 2 * ((m : ℝ) + 1)) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) |
| [`WeilPowerBounds.norm_S_le_far`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_S_le_far) | theorem | `WeilPowerBounds` | ‖S m w‖ ≤ cS m * Real.cosh w.re * (2 / w.im ^ 2) ^ (m + 1) |
| [`WeilPowerCompare.norm_S_le_gauss`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-norm_S_le_gauss) | theorem | `WeilPowerCompare` | ‖S m w‖ ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖ * Real.exp (Eup m w) |
| [`WeilPowerGauss.norm_S_le_gauss_neg`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_S_le_gauss_neg) | theorem | `WeilPowerGauss` | ‖S m w‖ ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖ * Real.exp ((w ^ 2).re * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) |
| [`WeilPowerGauss.norm_S_le_gauss_pos`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_S_le_gauss_pos) | theorem | `WeilPowerGauss` | ‖S m w‖ ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖ * Real.exp ((w ^ 2).re / (Real.pi ^ 2 * ((m : ℝ) + 1)) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) |
| [`WeilPowerTail.norm_S_le_tail`](./lean_stage3/WeilPowerTail.md#WeilPowerTail-norm_S_le_tail) | theorem | `WeilPowerTail` | ‖S m w‖ ≤ cS m / D m * ‖w‖ * Real.exp ((w ^ 2).re * sigma m + ‖w‖ ^ 4 / (6 * Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) |
| [`WeilPowerPhase.norm_S_sub_le`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-norm_S_sub_le) | theorem | `WeilPowerPhase` | ‖S m w - ((cS m / D m : ℝ) : ℂ) * w * P m w‖ ≤ 2 * q m w * ‖((cS m / D m : ℝ) : ℂ) * w * P m w‖ |
| [`WeilLobe.norm_sinh_le`](./lean_stage3/WeilLobe.md#WeilLobe-norm_sinh_le) | theorem | `WeilLobe` | ‖Complex.sinh z‖ ≤ Real.cosh z.re |
| [`RHPull.norm_sq_line`](./lean_stage3/LineBound.md#RHPull-norm_sq_line) | theorem | `LineBound` | ‖((σ : ℂ) + I * (t : ℂ))‖ ^ 2 = σ ^ 2 + t ^ 2 |
| [`CellZeros.norm_stencil_le`](./lean_stage3/CellZeros.md#CellZeros-norm_stencil_le) | theorem | `CellZeros` | ‖stencil d a r‖ ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ) * B j |
| [`WeilPowerGeom.norm_sum_exp_u_le`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-norm_sum_exp_u_le) | theorem | `WeilPowerGeom` | ‖∑ m ∈ Finset.Ico a b, Complex.exp (z * (u m : ℂ))‖ ≤ geomBound z a b + 2 * ‖z‖ * Mab z a b * ((Real.log b - Real.log a) / (4 * Real.pi ^ 2)) |
| [`WeilPowerGeomGen.norm_sum_exp_u_le_gen`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-norm_sum_exp_u_le_gen) | theorem | `WeilPowerGeomGen` | ‖∑ h ∈ Finset.Ico a b, Complex.exp (z * (u h : ℂ))‖ ≤ geomBoundGen z α β₀ a b + 2 * ‖z‖ * c * MabGen z α β₀ a b * (Real.log b - Real.log a) |
| [`Elephant.norm_sym_band`](./lean/Elephant.md#Elephant-norm_sym_band) | theorem | `Elephant` | 1 - b ^ (-(1:ℝ)/2) ≤ ‖Sym b ((1:ℂ)/2 + γ * Complex.I)‖ ∧ ‖Sym b ((1:ℂ)/2 + γ * Complex.I)‖ ≤ 1 + b ^ (-(1:ℝ)/2) |
| [`Elephant.norm_sym_imaginary`](./lean/Elephant.md#Elephant-norm_sym_imaginary) | theorem | `Elephant` | ‖Sym b ((γ : ℂ) * Complex.I)‖ = 2 * \|Real.sin (γ * Real.log b / 2)\| |
| [`NyquistPeak.norm_sym_on_imaginary_axis`](./lean/NyquistPeak.md#NyquistPeak-norm_sym_on_imaginary_axis) | theorem | `NyquistPeak` | ‖Chain.Sym b (γ * Complex.I)‖ = 2 * \|Real.sin (γ * Real.log b / 2)\| |
| [`NyquistPeak.norm_sym_pow_at_boundaryBase`](./lean/NyquistPeak.md#NyquistPeak-norm_sym_pow_at_boundaryBase) | theorem | `NyquistPeak` | ‖Chain.Sym (boundaryBase γ) (γ * Complex.I)‖ ^ d = 2 ^ d |
| [`WeilPowerGauss.norm_T_le`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_T_le) | theorem | `WeilPowerGauss` | ‖T m w n‖ ≤ Real.exp ((w ^ 2).re / Real.pi ^ 2 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 + ‖w‖ ^ 4 / Real.pi ^ 4 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4) |
| [`WeilPowerGauss.norm_T_le_neg`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_T_le_neg) | theorem | `WeilPowerGauss` | ‖T m w n‖ ≤ Real.exp ((w ^ 2).re * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) |
| [`WeilPowerGauss.norm_T_le_pos`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_T_le_pos) | theorem | `WeilPowerGauss` | ‖T m w n‖ ≤ Real.exp ((w ^ 2).re / (Real.pi ^ 2 * ((m : ℝ) + 1)) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) |
| [`WeilPowerTail.norm_T_le_tail`](./lean_stage3/WeilPowerTail.md#WeilPowerTail-norm_T_le_tail) | theorem | `WeilPowerTail` | ‖T m w n‖ ≤ Real.exp ((w ^ 2).re * sigmaN m n + ‖w‖ ^ 4 / (6 * Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) |
| [`Stage3.norm_term_le_dyadic`](./lean_stage3/Assembly.md#Stage3-norm_term_le_dyadic) | theorem | `Assembly` | ‖(x : ℂ) ^ (ρ : ℂ) / (ρ : ℂ)‖ ≤ 2 * Real.sqrt x * ∑ j ∈ Finset.range (K + 1), ((2 : ℝ) ^ j)⁻¹ * (if \|(ρ : ℂ).im\| &lt; 2 ^ (j + 1) then 1 else 0) |
| [`Stage3.norm_term_le_of_RH`](./lean_stage3/Assembly.md#Stage3-norm_term_le_of_RH) | theorem | `Assembly` | ‖(x : ℂ) ^ (ρ : ℂ) / (ρ : ℂ)‖ ≤ 2 * Real.sqrt x |
| [`WeilPowerCompare.norm_wOf_pow4`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-norm_wOf_pow4) | theorem | `WeilPowerCompare` | ‖wOf ε Δ h‖ ^ 4 = ((ε ^ 2 + Δ ^ 2) * h ^ 2) ^ 2 |
| [`WeilPowerCompare.norm_wOf_sq`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-norm_wOf_sq) | theorem | `WeilPowerCompare` | ‖wOf ε Δ h‖ ^ 2 = (ε ^ 2 + Δ ^ 2) * h ^ 2 |
| [`WeilPowerGauss.norm_x_le`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_x_le) | theorem | `WeilPowerGauss` | ‖w ^ 2 / ((Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2)‖ ≤ 1 / 2 |
| [`Stage3.norm_zeroPartialSum_le`](./lean_stage3/Assembly.md#Stage3-norm_zeroPartialSum_le) | theorem | `Assembly` | ‖zeroPartialSum x ((2 : ℝ) ^ (K + 1))‖ ≤ 2 * Real.sqrt x * (2 * \|riemannZeta.N ((2 : ℝ) ^ (K + 1))\| + weightedZeroHeightBucket) |
| [`Stage3.norm_zeroPartialSum_le_logsq`](./lean_stage3/Assembly.md#Stage3-norm_zeroPartialSum_le_logsq) | theorem | `Assembly` | ‖zeroPartialSum x ((2 : ℝ) ^ (K + 1))‖ ≤ 2 * Real.sqrt x * (2 * (Real.log 2 / (2 * Real.pi) * (K + 1) * (K + 2) + 3 * (K + 1) / Real.pi + 2 * (riemannZeta.RvM b₁ b₂ b₃ ((2 : ℝ) ^ (K + 1)) + 7 / 8)) + … |
| [`Stage3.norm_zeroPartialSum_le_sharp`](./lean_stage3/Assembly.md#Stage3-norm_zeroPartialSum_le_sharp) | theorem | `Assembly` | ‖zeroPartialSum x ((2 : ℝ) ^ (K + 1))‖ ≤ 2 * Real.sqrt x * ∑ j ∈ Finset.range (K + 1), ((2 : ℝ) ^ j)⁻¹ * (2 * \|riemannZeta.N ((2 : ℝ) ^ (j + 1))\| + weightedZeroHeightBucket) |
| [`ReZetaCount.norm_zeta_sub_one_le`](./lean_stage3/ReZetaCount.md#ReZetaCount-norm_zeta_sub_one_le) | theorem | `ReZetaCount` | ‖riemannZeta s - 1‖ ≤ Real.pi ^ 2 / 6 - 1 |
| [`BoxBounds.norm_zeta_three_halves_le`](./lean_stage3/BoxBounds.md#BoxBounds-norm_zeta_three_halves_le) | theorem | `BoxBounds` | ‖riemannZeta (3 / 2)‖ ≤ 7 / 2 |
| [`Transform.norm_zmap`](./lean/Transform.md#Transform-norm_zmap) | theorem | `Transform` | ‖(b : ℂ) ^ (-s)‖ = b ^ (-s.re) |
| [`Transform.norm_zmap_critical`](./lean/Transform.md#Transform-norm_zmap_critical) | theorem | `Transform` | ‖(b : ℂ) ^ (-((1 : ℂ)/2 + γ * I))‖ = b ^ (-(1:ℝ)/2) |
| [`Transform.norm_zmap_zero_line`](./lean/Transform.md#Transform-norm_zmap_zero_line) | theorem | `Transform` | ‖(b : ℂ) ^ (-s)‖ = 1 |
| [`WeilPowerShell.norm_zOf_c_le`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-norm_zOf_c_le) | theorem | `WeilPowerShell` | ‖zOf e' D e‖ * (1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2)) ≤ (a : ℝ) + 1 |
| [`WeilPowerShell.norm_zOf_le`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-norm_zOf_le) | theorem | `WeilPowerShell` | ‖zOf e' D e‖ ≤ 2 * (e' ^ 2 + D ^ 2 + e ^ 2) |
| [`Stage3.normSq_add_zq`](./lean_stage3/Stirling.md#Stage3-normSq_add_zq) | theorem | `Stirling` | ‖(n : ℂ) + zq t‖ ^ 2 = ((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2 |
| [`Nyquist.nyquist`](./lean/Nyquist.md#Nyquist-nyquist) | def | `Nyquist` | ℝ |
| [`NyquistPeak.nyquist_boundaryBase`](./lean/NyquistPeak.md#NyquistPeak-nyquist_boundaryBase) | theorem | `NyquistPeak` | Nyquist.nyquist (boundaryBase γ) = γ |
| [`Nyquist.nyquist_no_go`](./lean/Nyquist.md#Nyquist-nyquist_no_go) | theorem | `Nyquist` | ∃ γ', \|γ'\| &lt; \|γ\| ∧ Aliases b γ γ' |
| [`WeilTransform.odd_integral_exp`](./lean_stage3/WeilTransform.md#WeilTransform-odd_integral_exp) | theorem | `WeilTransform` | (∫ x in (-1 : ℝ)..1, ((q x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ))) = ∫ x in (-1 : ℝ)..1, ((q x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) |
| [`WeilOffLine.offline_term_le`](./lean_stage3/WeilOffLine.md#WeilOffLine-offline_term_le) | theorem | `WeilOffLine` | (laplace (phiC h γ) (-offPt ε γ) * laplace (phiC h γ) (-(1 - offPt ε γ))).re ≤ -((h / 2) ^ 2 * (WeilWindow.Sigma (ε * h) * (WeilWindow.Sigma (ε * h) - 2 * ‖SigmaC (((ε : ℂ) + 2 * Complex.I * (γ : ℂ)) … |
| [`WeilOffLine.offline_term_le_explicit`](./lean_stage3/WeilOffLine.md#WeilOffLine-offline_term_le_explicit) | theorem | `WeilOffLine` | (laplace (phiC h γ) (-offPt ε γ) * laplace (phiC h γ) (-(1 - offPt ε γ))).re ≤ -((h / 2) ^ 2 * (WeilWindow.Sigma (ε * h) * (WeilWindow.Sigma (ε * h) - 2 * ((2 * Real.pi + Real.pi ^ 2) * Real.cosh (ε *… |
| [`WeilDetect.OffLineBox`](./lean_stage3/WeilDetect.md#WeilDetect-OffLineBox) | def | `WeilDetect` | Set ℂ |
| [`Stage3.offLineBox_finite`](./lean_stage3/BoxFinite.md#Stage3-offLineBox_finite) | theorem | `BoxFinite` | (WeilDetect.OffLineBox ε T).Finite |
| [`WeilOffLine.offPt`](./lean_stage3/WeilOffLine.md#WeilOffLine-offPt) | def | `WeilOffLine` | ℂ |
| [`WeilOffLine.offPt_sub_half`](./lean_stage3/WeilOffLine.md#WeilOffLine-offPt_sub_half) | theorem | `WeilOffLine` | offPt ε γ - 1 / 2 = (ε : ℂ) + Complex.I * (γ : ℂ) |
| [`JointLadder.offset_of_aliases`](./lean/JointLadder.md#JointLadder-offset_of_aliases) | theorem | `JointLadder` | ∃ j : ℤ, (γ - γ') * jointSample m n = 2 * Real.pi * j |
| [`Transform.on_critical_line_iff_inversion_fixed`](./lean/Transform.md#Transform-on_critical_line_iff_inversion_fixed) | theorem | `Transform` | s.re = 1 / 2 ↔ ‖(b : ℂ) ^ (-(1 : ℂ)) / (b : ℂ) ^ (-s)‖ = ‖(b : ℂ) ^ (-s)‖ |
| [`Transform.on_critical_line_iff_norm`](./lean/Transform.md#Transform-on_critical_line_iff_norm) | theorem | `Transform` | s.re = 1 / 2 ↔ ‖(b : ℂ) ^ (-s)‖ = b ^ (-(1 : ℝ) / 2) |
| [`WeilPowerAssembly.on_line_le`](./lean_stage3/WeilPowerAssembly.md#WeilPowerAssembly-on_line_le) | theorem | `WeilPowerAssembly` | WeilPowerOnLine.onLineBound h γ m ≤ 2 * (88 * (γ + WeilPowerBands.r h m + 2) ^ 4 * (4 * h ^ 2 + WeilPowerBands.cFarM m / h ^ 2) * (Real.pi ^ 2 / 6)) + 4 * h ^ 2 * WeilOnLine.lowCount |
| [`Stage3.one_add_log_four_le`](./lean_stage3/PsiToPi.md#Stage3-one_add_log_four_le) | theorem | `PsiToPi` | 1 + Real.log 4 ≤ 5 * Real.log 2 ^ 2 |
| [`BoxBounds.one_le_norm_zeta_three`](./lean_stage3/BoxBounds.md#BoxBounds-one_le_norm_zeta_three) | theorem | `BoxBounds` | 1 ≤ ‖riemannZeta 3‖ |
| [`WeilPowerBands.one_le_r`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-one_le_r) | theorem | `WeilPowerBands` | 1 ≤ r h m |
| [`ContourShift.one_le_zeta_order`](./lean_stage3/ContourShift.md#ContourShift-one_le_zeta_order) | theorem | `ContourShift` | 1 ≤ analyticOrderNatAt riemannZeta ρ |
| [`NyquistPeak.one_lt_boundaryBase`](./lean/NyquistPeak.md#NyquistPeak-one_lt_boundaryBase) | theorem | `NyquistPeak` | 1 &lt; boundaryBase γ |
| [`Transform.one_mem_periodLattice`](./lean/Transform.md#Transform-one_mem_periodLattice) | theorem | `Transform` | (1 : ℂ) ∈ periodLattice b |
| [`PerronKernel.one_sub_two_neg_rpow`](./lean_stage3/PerronKernel.md#PerronKernel-one_sub_two_neg_rpow) | theorem | `PerronKernel` | δ / 5 ≤ 1 - (2:ℝ) ^ (-δ) |
| [`WeilOnLine.OnLine`](./lean_stage3/WeilOnLine.md#WeilOnLine-OnLine) | abbrev | `WeilOnLine` | Type |
| [`WeilBackground.online_term_eq`](./lean_stage3/WeilBackground.md#WeilBackground-online_term_eq) | theorem | `WeilBackground` | laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ)) = (((h / 2) ^ 2 * (WeilTransform.Psi (h * (ρ.im + γ)) + WeilTransform.Psi (h * (ρ.im - γ))) ^ 2 : ℝ) : ℂ) |
| [`WeilPowerBackground.online_term_eq`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-online_term_eq) | theorem | `WeilPowerBackground` | laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ)) = (((h / 2) ^ 2 * (PsiW m (h * (ρ.im + γ)) + PsiW m (h * (ρ.im - γ))) ^ 2 : ℝ) : ℂ) |
| [`WeilBackground.online_term_le_far`](./lean_stage3/WeilBackground.md#WeilBackground-online_term_le_far) | theorem | `WeilBackground` | (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re ≤ (h / 2) ^ 2 * ((2 * Real.pi + Real.pi ^ 2) / (h * (ρ.im - γ)) ^ 2 + (2 * Real.pi + Real.pi ^ 2) / (h * (ρ.im + γ)) ^ 2) ^ 2 |
| [`WeilPowerBackground.online_term_le_far`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-online_term_le_far) | theorem | `WeilPowerBackground` | (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re ≤ (h / 2) ^ 2 * (cS m * (2 / (h * (ρ.im - γ)) ^ 2) ^ (m + 1) + cS m * (2 / (h * (ρ.im + γ)) ^ 2) ^ (m + 1)) ^ 2 |
| [`WeilBackground.online_term_le_near`](./lean_stage3/WeilBackground.md#WeilBackground-online_term_le_near) | theorem | `WeilBackground` | (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re ≤ 4 * h ^ 2 |
| [`WeilPowerBackground.online_term_le_near`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-online_term_le_near) | theorem | `WeilPowerBackground` | (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re ≤ 4 * h ^ 2 |
| [`WeilPowerBackground.online_term_nonneg`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-online_term_nonneg) | theorem | `WeilPowerBackground` | 0 ≤ (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re |
| [`WeilTiles.online_term_nonneg`](./lean_stage3/WeilTiles.md#WeilTiles-online_term_nonneg) | theorem | `WeilTiles` | 0 ≤ (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re |
| [`WeilOnLine.onLineBound`](./lean_stage3/WeilOnLine.md#WeilOnLine-onLineBound) | def | `WeilOnLine` | ℝ |
| [`WeilPowerOnLine.onLineBound`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-onLineBound) | def | `WeilPowerOnLine` | ℝ |
| [`WeilOnLine.onLineBound_le`](./lean_stage3/WeilOnLine.md#WeilOnLine-onLineBound_le) | theorem | `WeilOnLine` | onLineBound h γ ≤ 2 * (88 * (γ + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2) * (Real.pi ^ 2 / 6)) + 4 * h ^ 2 * lowCount |
| [`WeilPowerOnLine.onLineBound_le`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-onLineBound_le) | theorem | `WeilPowerOnLine` | onLineBound h γ m ≤ 2 * (88 * (γ + r h m + 2) ^ 4 * (4 * h ^ 2 + cFarM m / h ^ 2) * (Real.pi ^ 2 / 6)) + 4 * h ^ 2 * lowCount |
| [`ContourShift.order_bridge`](./lean_stage3/ContourShift.md#ContourShift-order_bridge) | theorem | `ContourShift` | ((riemannZeta.order ρ : ℤ) : ℂ) = ((analyticOrderNatAt riemannZeta ρ : ℕ) : ℂ) |
| [`WeilBands.order_eq_analyticOrderNatAt`](./lean_stage3/WeilBands.md#WeilBands-order_eq_analyticOrderNatAt) | theorem | `WeilBands` | ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) = (analyticOrderNatAt riemannZeta (ρ : ℂ) : ℝ) |
| [`WeilBridgeLeaf.order_eq_toNat`](./lean_stage3/WeilBridgeLeaf.md#WeilBridgeLeaf-order_eq_toNat) | theorem | `WeilBridgeLeaf` | riemannZeta.order ρ = (((analyticOrderAt riemannZeta ρ).toNat : ℕ) : ℤ) |
| [`Propagation.outside_cone_zero`](./lean/Propagation.md#Propagation-outside_cone_zero) | theorem | `Propagation` | tableFrom (deltaRow s) r d = 0 |
| [`WeilPowerPhase.P`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-P) | def | `WeilPowerPhase` | ℂ |
| [`WeilWindow.P`](./lean_stage3/WeilWindow.md#WeilWindow-P) | def | `WeilWindow` | ℝ |
| [`WeilLobe.P_eq`](./lean_stage3/WeilLobe.md#WeilLobe-P_eq) | theorem | `WeilLobe` | P x = (1 + Real.cos (Real.pi * x)) / 2 |
| [`WeilPower.P_eq_c_sq`](./lean_stage3/WeilPower.md#WeilPower-P_eq_c_sq) | theorem | `WeilPower` | P x = c x ^ 2 |
| [`WeilTransform.P_even`](./lean_stage3/WeilTransform.md#WeilTransform-P_even) | theorem | `WeilTransform` | P (-x) = P x |
| [`WeilWindow.P_ge_half`](./lean_stage3/WeilWindow.md#WeilWindow-P_ge_half) | theorem | `WeilWindow` | 1 / 2 ≤ P x |
| [`WeilWindow.P_le_one`](./lean_stage3/WeilWindow.md#WeilWindow-P_le_one) | theorem | `WeilWindow` | P x ≤ 1 |
| [`WeilWindow.P_neg_one`](./lean_stage3/WeilWindow.md#WeilWindow-P_neg_one) | theorem | `WeilWindow` | P (-1) = 0 |
| [`WeilWindow.P_nonneg`](./lean_stage3/WeilWindow.md#WeilWindow-P_nonneg) | theorem | `WeilWindow` | 0 ≤ P x |
| [`WeilWindow.P_one`](./lean_stage3/WeilWindow.md#WeilWindow-P_one) | theorem | `WeilWindow` | P 1 = 0 |
| [`WeilPower.P_pow`](./lean_stage3/WeilPower.md#WeilPower-P_pow) | theorem | `WeilPower` | P x ^ m = c x ^ (2 * m) |
| [`WeilPowerPhase.P_tendsto`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-P_tendsto) | theorem | `WeilPowerPhase` | Tendsto (fun n =&gt; Complex.exp (w ^ 2 * ((sigmaN m n : ℝ) : ℂ))) atTop (𝓝 (P m w)) |
| [`Transform.pair_collapses_iff_critical`](./lean/Transform.md#Transform-pair_collapses_iff_critical) | theorem | `Transform` | ‖(b : ℂ) ^ (-s)‖ = ‖(b : ℂ) ^ (-(1 - s))‖ ↔ s.re = 1 / 2 |
| [`PairIdentity.pair_identity`](./lean/PairIdentity.md#PairIdentity-pair_identity) | theorem | `PairIdentity` | tableFrom P r d + tableFrom C r d = (b - 1) ^ (d + 1) * b ^ e |
| [`Zeros.pair_shares_diagonal`](./lean/Zeros.md#Zeros-pair_shares_diagonal) | theorem | `Zeros` | (r - 1) - (d : ℤ) = r - ((d + 1 : ℕ) : ℤ) |
| [`ZeroCells.pairIdentity_all_vanish`](./lean/ZeroCells.md#ZeroCells-pairIdentity_all_vanish) | theorem | `ZeroCells` | ∀ c ∈ PairIdentity.zero_cells, Construction.tableFrom Zeros.dyadicRow (c.1 : ℤ) c.2 = 0 |
| [`ZeroCells.pairIdentity_eq`](./lean/ZeroCells.md#ZeroCells-pairIdentity_eq) | theorem | `ZeroCells` | PairIdentity.zero_cells = Zeros.measured_zeros |
| [`Bridge.paperFT_kOf`](./lean_bridge/WeilBridge.md#Bridge-paperFT_kOf) | theorem | `WeilBridge` | paperFT (kOf G) (gammaOf ρ) = laplace G (-ρ) * laplace G (-(1 - ρ)) |
| [`ContourShift.partner_zero`](./lean_stage3/ContourShift.md#ContourShift-partner_zero) | theorem | `ContourShift` | ∃ ρ' : ℂ, riemannZeta ρ' = 0 ∧ ρ'.im = ρ.im ∧ 1/2 ≤ ρ'.re ∧ ρ'.re &lt; 1 |
| [`Propagation.pasc`](./lean/Propagation.md#Propagation-pasc) | def | `Propagation` | ℕ → ℕ → ℤ |
| [`Propagation.pasc_eq_zero`](./lean/Propagation.md#Propagation-pasc_eq_zero) | theorem | `Propagation` | pasc n k = 0 |
| [`Propagation.pasc_pos`](./lean/Propagation.md#Propagation-pasc_pos) | theorem | `Propagation` | 0 &lt; pasc n k |
| [`Propagation.pasc_succ`](./lean/Propagation.md#Propagation-pasc_succ) | theorem | `Propagation` | pasc (n + 1) (k + 1) = pasc n k + pasc n (k + 1) |
| [`Propagation.pasc_zero`](./lean/Propagation.md#Propagation-pasc_zero) | theorem | `Propagation` | pasc n 0 = 1 |
| [`GeneratorPeak.perBlock`](./lean/GeneratorPeak.md#GeneratorPeak-perBlock) | def | `GeneratorPeak` | ℝ |
| [`Chain.period_vacuous_at_one`](./lean/Chain.md#Chain-period_vacuous_at_one) | theorem | `Chain` | Function.Periodic f (2 * Real.pi / Real.log 1) |
| [`Transform.periodLattice`](./lean/Transform.md#Transform-periodLattice) | def | `Transform` | AddSubgroup ℂ |
| [`Transform.periodLattice_discrete`](./lean/Transform.md#Transform-periodLattice_discrete) | theorem | `Transform` | DiscreteTopology (periodLattice b) |
| [`Transform.periodLattice_eq_span`](./lean/Transform.md#Transform-periodLattice_eq_span) | theorem | `Transform` | periodLattice b = (Submodule.span ℤ (Set.range (latticeBasis hb))).toAddSubgroup |
| [`PerronKernel.perron_kernel_coarse`](./lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_coarse) | theorem | `PerronKernel` | ‖perronI y c T - perronδ y‖ ≤ y ^ c |
| [`PerronKernel.perron_kernel_coarse_gt`](./lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_coarse_gt) | theorem | `PerronKernel` | ‖perronI y c T - perronδ y‖ ≤ y ^ c |
| [`PerronKernel.perron_kernel_coarse_lt`](./lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_coarse_lt) | theorem | `PerronKernel` | ‖perronI y c T - perronδ y‖ ≤ y ^ c |
| [`PerronKernel.perron_kernel_decay`](./lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_decay) | theorem | `PerronKernel` | ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * \|Real.log y\|) |
| [`PerronKernel.perron_kernel_decay_gt`](./lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_decay_gt) | theorem | `PerronKernel` | ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * \|Real.log y\|) |
| [`PerronKernel.perron_kernel_decay_lt`](./lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_decay_lt) | theorem | `PerronKernel` | ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * \|Real.log y\|) |
| [`PerronKernel.perron_kernel_truncated`](./lean_stage3/PerronKernel.md#PerronKernel-perron_kernel_truncated) | theorem | `PerronKernel` | ‖perronI y c T - perronδ y‖ ≤ y ^ c * min 1 (1 / (T * \|Real.log y\|)) |
| [`PerronKernel.perron_sum_eq_integral`](./lean_stage3/PerronKernel.md#PerronKernel-perron_sum_eq_integral) | theorem | `PerronKernel` | (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronI (x/n) (1 + 1/Real.log x) T) = (2 * (Real.pi:ℂ) * Complex.I)⁻¹ * ∫ t in (-T)..T, (- deriv riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I… |
| [`PerronKernel.perron_to_psi`](./lean_stage3/PerronKernel.md#PerronKernel-perron_to_psi) | theorem | `PerronKernel` | ‖(Chebyshev.psi x : ℂ) - ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronI (x/n) (1 + 1/Real.log x) T‖ ≤ 600 * x * Real.log (x * T) ^ 2 / T + 13 * Real.log x |
| [`PerronKernel.perronI`](./lean_stage3/PerronKernel.md#PerronKernel-perronI) | def | `PerronKernel` | ℂ |
| [`PerronKernel.perronI_eq_VIntegral'`](./lean_stage3/PerronKernel.md#PerronKernel-perronI_eq_VIntegral-) | theorem | `PerronKernel` | perronI y c T = VIntegral' (fun s : ℂ ↦ (y : ℂ) ^ s / s) c (-T) T |
| [`PerronKernel.perronI_one_norm`](./lean_stage3/PerronKernel.md#PerronKernel-perronI_one_norm) | theorem | `PerronKernel` | ‖perronI 1 c T‖ ≤ 1/2 |
| [`PerronKernel.perronδ`](./lean_stage3/PerronKernel.md#PerronKernel-perron-) | def | `PerronKernel` | ℂ |
| [`NyquistPeak.phase_at_boundaryBase`](./lean/NyquistPeak.md#NyquistPeak-phase_at_boundaryBase) | theorem | `NyquistPeak` | γ * Real.log (boundaryBase γ) = Real.pi |
| [`WeilPowerNear.phase_le`](./lean_stage3/WeilPowerNear.md#WeilPowerNear-phase_le) | theorem | `WeilPowerNear` | 4 * e' * D * WeilPowerGeomGen.uLam lam h ≤ 4 * e' * D * ((b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) |
| [`Stage3.phasePoint`](./lean_stage3/Stirling.md#Stage3-phasePoint) | def | `Stirling` | ℝ |
| [`ArgCount.phasePoint_bound_near`](./lean_stage3/ArgCount.md#ArgCount-phasePoint_bound_near) | theorem | `ArgCount` | ∃ M : ℝ, 0 ≤ M ∧ ∀ t ∈ Set.Icc (T₀ - 1) T₀, \|Stage3.phasePoint t\| ≤ M |
| [`Stage3.phasePoint_compact_le`](./lean_stage3/Stirling.md#Stage3-phasePoint_compact_le) | theorem | `Stirling` | ∀ t ∈ Set.Icc (0 : ℝ) 1, \|phasePoint t\| ≤ 8 |
| [`Stage3.phasePoint_eq`](./lean_stage3/Stirling.md#Stage3-phasePoint_eq) | theorem | `Stirling` | phasePoint t = (Complex.digamma (zq t)).re |
| [`Stage3.phaseTheta`](./lean_stage3/Stirling.md#Stage3-phaseTheta) | def | `Stirling` | ℝ |
| [`ArgCount.phaseTheta_sub_le`](./lean_stage3/ArgCount.md#ArgCount-phaseTheta_sub_le) | theorem | `ArgCount` | \|Stage3.phaseTheta T₀ - Stage3.phaseTheta T\| ≤ (T₀ - T) * (M / 2 + Real.log Real.pi / 2) |
| [`Stage3.phaseTheta_zero`](./lean_stage3/Stirling.md#Stage3-phaseTheta_zero) | theorem | `Stirling` | phaseTheta 0 = 0 |
| [`LandauMellinG.Phi`](./lean_stage3/LandauMellinG.md#LandauMellinG-Phi) | def | `LandauMellinG` | ℂ |
| [`WeilBackground.phi`](./lean_stage3/WeilBackground.md#WeilBackground-phi) | def | `WeilBackground` | ℝ |
| [`LandauPoleLocal.Phi_principal_part`](./lean_stage3/LandauPoleLocal.md#LandauPoleLocal-Phi_principal_part) | theorem | `LandauPoleLocal` | ∃ h : ℂ → ℂ, AnalyticAt ℂ h ρ ∧ ∀ᶠ s in 𝓝[≠] ρ, LandauMellinG.Phi s = h s + (analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ)) / (s - ρ) |
| [`LandauPoleLocal.Phi_regular_at_one`](./lean_stage3/LandauPoleLocal.md#LandauPoleLocal-Phi_regular_at_one) | theorem | `LandauPoleLocal` | ∃ h : ℂ → ℂ, AnalyticAt ℂ h 1 ∧ ∀ᶠ s in 𝓝[≠] 1, LandauMellinG.Phi s = h s |
| [`LandauPoleDisc.Phi_taylor_on_disc`](./lean_stage3/LandauPoleDisc.md#LandauPoleDisc-Phi_taylor_on_disc) | theorem | `LandauPoleDisc` | ∃ (P : Finset ℂ) (C : ℝ), (∀ ρ, ρ ∈ P ↔ ρ ∈ ball c R₂ ∧ ρ ≠ 1 ∧ riemannZeta ρ = 0) ∧ ∀ k : ℕ, ‖iteratedDeriv k LandauMellinG.Phi c - ∑ ρ ∈ P, (analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ)) * (… |
| [`WeilBackground.phiC`](./lean_stage3/WeilBackground.md#WeilBackground-phiC) | def | `WeilBackground` | ℝ → ℂ |
| [`WeilBackground.phiC_real`](./lean_stage3/WeilBackground.md#WeilBackground-phiC_real) | theorem | `WeilBackground` | (phiC h γ u).im = 0 |
| [`WeilPowerBackground.phiW`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-phiW) | def | `WeilPowerBackground` | ℝ |
| [`WeilPowerAssembly.phiW_contDiff_one`](./lean_stage3/WeilPowerAssembly.md#WeilPowerAssembly-phiW_contDiff_one) | theorem | `WeilPowerAssembly` | ContDiff ℝ 1 (WeilPowerBackground.phiW h γ m) |
| [`WeilPowerBackground.phiWC`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-phiWC) | def | `WeilPowerBackground` | ℝ → ℂ |
| [`WeilPowerBackground.phiWC_real`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-phiWC_real) | theorem | `WeilPowerBackground` | (phiWC h γ m u).im = 0 |
| [`Zeros.pi2`](./lean/Zeros.md#Zeros-pi2) | def | `Zeros` | ℕ → ℤ |
| [`Stage3.pi_mul_N_eq`](./lean_stage3/ArgIdentity.md#Stage3-pi_mul_N_eq) | theorem | `ArgIdentity` | Real.pi * riemannZeta.N T = (∫ t in (0:ℝ)..T, logDeriv xi (2 + (t : ℂ) * Complex.I)).re - (∫ x in (1/2:ℝ)..2, logDeriv xi ((x : ℂ) + T * Complex.I)).im |
| [`Stage3.pi_sub_Li_eq`](./lean_stage3/PsiToPi.md#Stage3-pi_sub_Li_eq) | theorem | `PsiToPi` | (Nat.primeCounting ⌊x⌋₊ : ℝ) - Li x = (θ x - x) / Real.log x + ∫ t in (2 : ℝ)..x, (θ t - t) / (t * Real.log t ^ 2) |
| [`Stage3.pole_away`](./lean_stage3/JensenCount.md#Stage3-pole_away) | theorem | `JensenCount` | 2 * z + (2 + Complex.I * (T : ℂ)) ≠ 1 |
| [`Stage3.pole_away_centre`](./lean_stage3/JensenCount.md#Stage3-pole_away_centre) | theorem | `JensenCount` | v ≠ 1 |
| [`Transform.poleLattice`](./lean/Transform.md#Transform-poleLattice) | def | `Transform` | AddSubgroup ℂ |
| [`TableDepths.pow_lower`](./lean_stage3/TableDepths.md#TableDepths-pow_lower) | theorem | `TableDepths` | (0.6931:ℝ) ^ k ≤ Real.log 2 ^ k |
| [`JointDialGate.powerSaving_relErr`](./lean_stage3/JointDialGate.md#JointDialGate-powerSaving_relErr) | theorem | `JointDialGate` | StmtRelErrWindow f L r n (A * (2 : ℝ) ^ (((r : ℝ) - n) * (θ - 1))) |
| [`RelativeGate.powerSaving_relErr`](./lean/RelativeGate.md#RelativeGate-powerSaving_relErr) | theorem | `RelativeGate` | StmtRelErrWindow f L r n (A * (2 : ℝ) ^ (((r : ℝ) - n) * (θ - 1))) |
| [`VonKoch.preconnected_region`](./lean_stage3/VonKochScaffold.md#VonKoch-preconnected_region) | theorem | `VonKochScaffold` | IsPreconnected region |
| [`Stage3.preconnected_regionθ`](./lean_stage3/ThetaConverse.md#Stage3-preconnected_region-) | theorem | `ThetaConverse` | IsPreconnected (regionθ θ) |
| [`ZetaGrowth.preconnected_stripRegion`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-preconnected_stripRegion) | theorem | `ZetaGrowth` | IsPreconnected stripRegion |
| [`Measured.predicted_elliptic_re`](./lean/Measured.md#Measured-predicted_elliptic_re) | def | `Measured` | ℝ |
| [`Measured.predicted_radius_resid`](./lean/Measured.md#Measured-predicted_radius_resid) | def | `Measured` | ℝ |
| [`Measured.predicted_radius_smooth`](./lean/Measured.md#Measured-predicted_radius_smooth) | def | `Measured` | ℝ |
| [`Measured.predicted_rank_11a1`](./lean/Measured.md#Measured-predicted_rank_11a1) | def | `Measured` | ℝ |
| [`Measured.predicted_rank_37a1`](./lean/Measured.md#Measured-predicted_rank_37a1) | def | `Measured` | ℝ |
| [`Measured.predicted_rank_389a1`](./lean/Measured.md#Measured-predicted_rank_389a1) | def | `Measured` | ℝ |
| [`Elephant.primeCount_backward_diff`](./lean/Elephant.md#Elephant-primeCount_backward_diff) | theorem | `Elephant` | ∑ m ∈ Finset.range (b ^ (r + 1) + 1), (primeIndicator m - (if b ∣ m then primeIndicator (m / b) else 0)) = (Nat.primeCounting (b ^ (r + 1)) : ℂ) - (Nat.primeCounting (b ^ r) : ℂ) |
| [`Zeros.primeFactors_eq_of_meets`](./lean/ZerosStencil.md#Zeros-primeFactors_eq_of_meets) | theorem | `ZerosStencil` | b.primeFactors = c.primeFactors |
| [`Elephant.primeIndicator`](./lean/Elephant.md#Elephant-primeIndicator) | def | `Elephant` | ℕ → ℂ |
| [`Elephant.primeRow`](./lean/Elephant.md#Elephant-primeRow) | def | `Elephant` | ℕ → ℤ |
| [`Elephant.primeRowZ`](./lean/Elephant.md#Elephant-primeRowZ) | def | `Elephant` | ℤ → ℂ |
| [`Bridge.primeSide`](./lean_bridge/WeilBridge.md#Bridge-primeSide) | def | `WeilBridge` | ℂ |
| [`Bridge.primeSide_eq`](./lean_bridge/WeilBridge.md#Bridge-primeSide_eq) | theorem | `WeilBridge` | primeSide k = literatureRHS k |
| [`Bridge.primeSideM`](./lean_bridge/WeilBridge.md#Bridge-primeSideM) | def | `WeilBridge` | ℂ |
| [`WeilBridgeLeaf.primeSideM`](./lean_stage3/WeilBridgeLeaf.md#WeilBridgeLeaf-primeSideM) | def | `WeilBridgeLeaf` | ℂ |
| [`Bridge.primeSideM_eq`](./lean_bridge/WeilBridge.md#Bridge-primeSideM_eq) | theorem | `WeilBridge` | primeSideM k = primeSide k |
| [`Elephant.primeTable_eq_stencil`](./lean/Elephant.md#Elephant-primeTable_eq_stencil) | theorem | `Elephant` | ((fwdDiff (1 : ℕ))^[d] (primeRow b)) r = ∑ k ∈ Finset.range (d + 1), ((-1 : ℤ) ^ (d - k) * d.choose k) • primeRow b (r + k • 1) |
| [`Elephant.primeTable_eq_sym_weighted`](./lean/Elephant.md#Elephant-primeTable_eq_sym_weighted) | theorem | `Elephant` | (bdiff^[d]) (primeRowZ b) r = ∑ i ∈ s, c i * (Sym (b : ℝ) (ρ i)) ^ d * mode (b : ℝ) (ρ i) r |
| [`Propagation.propagator`](./lean/Propagation.md#Propagation-propagator) | theorem | `Propagation` | tableFrom (deltaRow s) (s + (k : ℤ)) d = (-1) ^ k * pasc d k |
| [`SeedPerturbation.protected_at_R_three`](./lean/SeedPerturbation.md#SeedPerturbation-protected_at_R_three) | theorem | `SeedPerturbation` | zero_cells.map (fun c =&gt; decide (3 &lt; (c.1 : ℤ) - (c.2 : ℤ))) = [false, false, true, true] |
| [`SeedPerturbation.protected_at_R_two`](./lean/SeedPerturbation.md#SeedPerturbation-protected_at_R_two) | theorem | `SeedPerturbation` | zero_cells.map (fun c =&gt; decide (2 &lt; (c.1 : ℤ) - (c.2 : ℤ))) = [false, true, true, true] |
| [`WeilPowerBounds.Ps`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-Ps) | def | `WeilPowerBounds` | ℝ |
| [`WeilPowerBounds.Ps_le`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-Ps_le) | theorem | `WeilPowerBounds` | Ps m s ≤ (s ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ^ (m + 1) |
| [`WeilPowerBounds.Ps_pos`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-Ps_pos) | theorem | `WeilPowerBounds` | 0 &lt; Ps m s |
| [`Slice5.pseries_le`](./lean_stage3/LineBound.md#Slice5-pseries_le) | theorem | `LineBound` | ∑' (n : ℕ), ((n : ℝ)) ^ (-1 - b) ≤ 1 + 1 / b |
| [`Slice5.pseries_tail_le`](./lean_stage3/LineBound.md#Slice5-pseries_tail_le) | theorem | `LineBound` | ∑' (n : ℕ), ((n + 1 + 1 : ℕ) : ℝ) ^ (-1 - b) ≤ 1 / b |
| [`WeilTransform.Psi`](./lean_stage3/WeilTransform.md#WeilTransform-Psi) | def | `WeilTransform` | ℝ |
| [`WeilBackground.Psi_bound`](./lean_stage3/WeilBackground.md#WeilBackground-Psi_bound) | theorem | `WeilBackground` | \|WeilTransform.Psi s\| ≤ (2 * Real.pi + Real.pi ^ 2) / s ^ 2 |
| [`WeilBackground.Psi_le_two`](./lean_stage3/WeilBackground.md#WeilBackground-Psi_le_two) | theorem | `WeilBackground` | \|WeilTransform.Psi s\| ≤ 2 |
| [`WeilOnLine.Psi_neg`](./lean_stage3/WeilOnLine.md#WeilOnLine-Psi_neg) | theorem | `WeilOnLine` | WeilTransform.Psi (-s) = -WeilTransform.Psi s |
| [`VonKoch.psi_partial_bigO`](./lean_stage3/VonKochScaffold.md#VonKoch-psi_partial_bigO) | theorem | `VonKochScaffold` | (fun n : ℕ ↦ ∑ k ∈ Finset.Icc 1 n, ArithmeticFunction.vonMangoldt k) =O[Filter.atTop] fun n : ℕ ↦ (n : ℝ) ^ (1:ℝ) |
| [`RHPull.psi_sub_self_le`](./lean_stage3/LineBound.md#RHPull-psi_sub_self_le) | theorem | `LineBound` | \|ψ X - X\| ≤ E₁ + E₂ + E₃ |
| [`RHPull.psi_weak_at`](./lean_stage3/LineBound.md#RHPull-psi_weak_at) | theorem | `LineBound` | \|ψ X - X\| ≤ (c₁ + c₂ + c₃) * Real.sqrt X * (Real.log X) ^ 3 |
| [`RHPull.psi_weak_of_RH`](./lean_stage3/LineBound.md#RHPull-psi_weak_of_RH) | theorem | `LineBound` | ∃ C &gt; 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t → \|ψ t - t\| ≤ C * Real.sqrt t * (Real.log t) ^ 3 |
| [`Stage3.psi_weak_of_RH_half`](./lean_stage3/ThetaPsi.md#Stage3-psi_weak_of_RH_half) | theorem | `ThetaPsi` | ∃ C &gt; 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t → \|ψ t - t\| ≤ C * Real.sqrt t * (Real.log t) ^ 3 |
| [`Stage3.psi_weak_of_theta`](./lean_stage3/ThetaPsi.md#Stage3-psi_weak_of_theta) | theorem | `ThetaPsi` | ∃ C &gt; 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t → \|ψ t - t\| ≤ C * t ^ θ * (Real.log t) ^ 3 |
| [`WeilPowerBackground.PsiW`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-PsiW) | def | `WeilPowerBackground` | ℝ |
| [`WeilPowerBackground.PsiW_le_far`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-PsiW_le_far) | theorem | `WeilPowerBackground` | \|PsiW m t\| ≤ cS m * (2 / t ^ 2) ^ (m + 1) |
| [`WeilPowerBackground.PsiW_le_two`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-PsiW_le_two) | theorem | `WeilPowerBackground` | \|PsiW m t\| ≤ 2 |
| [`WeilPowerOnLine.PsiW_neg`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-PsiW_neg) | theorem | `WeilPowerOnLine` | PsiW m (-t) = -PsiW m t |
| [`Stage3.psiWeak_floor`](./lean_stage3/AssemblyFloor.md#Stage3-psiWeak_floor) | theorem | `AssemblyFloor` | StmtPsiWeak (floorConst c₁ c₂ b₁ b₂ b₃ W x₀) 2 x₀ |
| [`Stage3.psiWeak_floor_split`](./lean_stage3/GlueFloor.md#Stage3-psiWeak_floor_split) | theorem | `GlueFloor` | StmtPsiWeak (floorConstSplit c₁ c₃ c₄ b₁ b₂ b₃ W x₀) 2 x₀ |
| [`Stage3.psiWeak_of_RH_EF_NT`](./lean_stage3/Assembly.md#Stage3-psiWeak_of_RH_EF_NT) | theorem | `Assembly` | StmtPsiWeak (9 * c₁ + c₂ + 28 + 16 * b₁ + 16 * b₂ + 8 * b₃ + 4 * W) 2 (max x₁ 16) |
| [`JointWindowDial.psiWeakTheta_of_window`](./lean_stage3/JointWindowDial.md#JointWindowDial-psiWeakTheta_of_window) | theorem | `JointWindowDial` | ∃ C' &gt; 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t → \|Chebyshev.psi t - t\| ≤ C' * t ^ θ * Real.log t ^ 3 |
| [`RHPull.pull_at_RH_abscissa`](./lean_stage3/LineBound.md#RHPull-pull_at_RH_abscissa) | theorem | `LineBound` | SmoothedChebyshev SmoothingF ε X = I₁ SmoothingF ε X T - I₂ SmoothingF ε T X (1 / 2 + 1 / Real.log X) + I₃₇ SmoothingF ε T X (1 / 2 + 1 / Real.log X) + I₈ SmoothingF ε T X (1 / 2 + 1 / Real.log X) + I… |
| [`Stage3.pull_at_theta_abscissa`](./lean_stage3/ThetaPsi.md#Stage3-pull_at_theta_abscissa) | theorem | `ThetaPsi` | SmoothedChebyshev SmoothingF ε X = I₁ SmoothingF ε X T - I₂ SmoothingF ε T X (σθ θ X) + I₃₇ SmoothingF ε T X (σθ θ X) + I₈ SmoothingF ε T X (σθ θ X) + I₉ SmoothingF ε X T + mellin (fun x ↦ (Smooth1 Sm… |
| [`WeilLobe.q`](./lean_stage3/WeilLobe.md#WeilLobe-q) | def | `WeilLobe` | ℝ |
| [`WeilOddPower.q`](./lean_stage3/WeilOddPower.md#WeilOddPower-q) | def | `WeilOddPower` | ℝ |
| [`WeilPower.Q`](./lean_stage3/WeilPower.md#WeilPower-Q) | def | `WeilPower` | ℂ |
| [`WeilPowerPhase.q`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-q) | def | `WeilPowerPhase` | ℝ |
| [`WeilLobe.q1`](./lean_stage3/WeilLobe.md#WeilLobe-q1) | def | `WeilLobe` | ℝ |
| [`WeilLobe.q1_neg_one`](./lean_stage3/WeilLobe.md#WeilLobe-q1_neg_one) | theorem | `WeilLobe` | q1 (-1) = 0 |
| [`WeilLobe.q1_one`](./lean_stage3/WeilLobe.md#WeilLobe-q1_one) | theorem | `WeilLobe` | q1 1 = 0 |
| [`WeilLobe.q2`](./lean_stage3/WeilLobe.md#WeilLobe-q2) | def | `WeilLobe` | ℝ |
| [`WeilLobe.q2_bound`](./lean_stage3/WeilLobe.md#WeilLobe-q2_bound) | theorem | `WeilLobe` | \|q2 x\| ≤ Real.pi + Real.pi ^ 2 / 2 |
| [`WeilLobe.q_eq`](./lean_stage3/WeilLobe.md#WeilLobe-q_eq) | theorem | `WeilLobe` | x * P x = q x |
| [`WeilOddPower.q_eq`](./lean_stage3/WeilOddPower.md#WeilOddPower-q_eq) | theorem | `WeilOddPower` | q m x = -(2 / (((m : ℝ) + 1) * Real.pi)) * f1 (2 * m + 1) x |
| [`WeilLobe.q_neg_one`](./lean_stage3/WeilLobe.md#WeilLobe-q_neg_one) | theorem | `WeilLobe` | q (-1) = 0 |
| [`WeilPowerPhase.q_nonneg`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-q_nonneg) | theorem | `WeilPowerPhase` | 0 ≤ q m w |
| [`WeilOddPower.q_odd`](./lean_stage3/WeilOddPower.md#WeilOddPower-q_odd) | theorem | `WeilOddPower` | q m (-x) = -q m x |
| [`WeilLobe.q_one`](./lean_stage3/WeilLobe.md#WeilLobe-q_one) | theorem | `WeilLobe` | q 1 = 0 |
| [`WeilPower.Q_succ`](./lean_stage3/WeilPower.md#WeilPower-Q_succ) | theorem | `WeilPower` | Q (m + 1) w = Q m w * (w ^ 2 + (Real.pi : ℂ) ^ 2 * ((m : ℂ) + 1) ^ 2) |
| [`WeilOddPower.Q_succ_eq`](./lean_stage3/WeilOddPower.md#WeilOddPower-Q_succ_eq) | theorem | `WeilOddPower` | Q (m + 1) w = w * QS m w |
| [`WeilPowerCompare.qerr`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-qerr) | def | `WeilPowerCompare` | ℝ |
| [`WeilPowerCompare.qerr_pos`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-qerr_pos) | theorem | `WeilPowerCompare` | 0 &lt; qerr m ε' Δ ε |
| [`WeilOddPower.QS`](./lean_stage3/WeilOddPower.md#WeilOddPower-QS) | def | `WeilOddPower` | ℂ |
| [`WeilPowerGauss.QS_eq_D_mul`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-QS_eq_D_mul) | theorem | `WeilPowerGauss` | QS m w = (D m : ℂ) * ∏ j ∈ Finset.range (m + 1), g w j |
| [`WeilPowerBounds.QS_factor`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-QS_factor) | theorem | `WeilPowerBounds` | QS m w = ∏ j ∈ Finset.range (m + 1), (w ^ 2 + ((Real.pi * ((j : ℝ) + 1) : ℝ) : ℂ) ^ 2) |
| [`WeilPowerBounds.QS_ne_zero`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-QS_ne_zero) | theorem | `WeilPowerBounds` | QS m w ≠ 0 |
| [`WeilPowerCompare.QS_ne_zero_wOf`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-QS_ne_zero_wOf) | theorem | `WeilPowerCompare` | QS m (wOf ε Δ h) ≠ 0 |
| [`WeilPowerBounds.QS_ofReal`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-QS_ofReal) | theorem | `WeilPowerBounds` | QS m (s : ℂ) = ((Ps m s : ℝ) : ℂ) |
| [`WeilPowerBands.r`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-r) | def | `WeilPowerBands` | ℝ |
| [`WeilPowerSigma.r_le`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-r_le) | theorem | `WeilPowerSigma` | u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2 ≤ 1 / (Real.pi ^ 2 * (4 * (m : ℝ) + 6)) |
| [`WeilPowerSigma.r_pos`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-r_pos) | theorem | `WeilPowerSigma` | 1 / (2 * Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2) ≤ u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2 |
| [`LandauMellin.rampK`](./lean_stage3/LandauMellin.md#LandauMellin-rampK) | def | `LandauMellin` | ℂ |
| [`LandauMellin.rampK_eq_indicator`](./lean_stage3/LandauMellin.md#LandauMellin-rampK_eq_indicator) | theorem | `LandauMellin` | rampK s n y = (Ioi (n : ℝ)).indicator (fun t : ℝ =&gt; (1 / (n : ℂ)) * (t : ℂ) ^ (-s) - (t : ℂ) ^ (-s - 1)) y |
| [`LandauMellin.rampK_integrable`](./lean_stage3/LandauMellin.md#LandauMellin-rampK_integrable) | theorem | `LandauMellin` | IntegrableOn (rampK s n) (Ioi 1) |
| [`LandauMellin.rampK_integral`](./lean_stage3/LandauMellin.md#LandauMellin-rampK_integral) | theorem | `LandauMellin` | ∫ y in Ioi (1 : ℝ), rampK s n y = (n : ℂ) ^ (-s) / (s * (s - 1)) |
| [`LandauMellin.rampK_integral_norm`](./lean_stage3/LandauMellin.md#LandauMellin-rampK_integral_norm) | theorem | `LandauMellin` | ∫ y in Ioi (1 : ℝ), ‖rampK s n y‖ = (n : ℝ) ^ (-s.re) / (s.re * (s.re - 1)) |
| [`LandauWindow.rampSum`](./lean_stage3/LandauWindow.md#LandauWindow-rampSum) | def | `LandauWindow` | ℝ |
| [`LandauMellin.rampSum_eq_tsum`](./lean_stage3/LandauMellin.md#LandauMellin-rampSum_eq_tsum) | theorem | `LandauMellin` | LandauWindow.rampSum y = ∑' n : ℕ, Λ n * max (y / n - 1) 0 |
| [`LandauCrude.rampSum_le`](./lean_stage3/LandauCrude.md#LandauCrude-rampSum_le) | theorem | `LandauCrude` | LandauWindow.rampSum y ≤ y * Real.log y * (1 + Real.log y) |
| [`LandauChebyshev.rampSum_le_log`](./lean_stage3/LandauChebyshev.md#LandauChebyshev-rampSum_le_log) | theorem | `LandauChebyshev` | LandauWindow.rampSum y ≤ y * (Real.log y + (Real.log 4 + 4)) |
| [`LandauMellinG.rampSum_mellin_integrable`](./lean_stage3/LandauMellinG.md#LandauMellinG-rampSum_mellin_integrable) | theorem | `LandauMellinG` | IntegrableOn (fun y : ℝ =&gt; (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1)) (Ioi 1) |
| [`LandauCrude.rampSum_nonneg`](./lean_stage3/LandauCrude.md#LandauCrude-rampSum_nonneg) | theorem | `LandauCrude` | 0 ≤ LandauWindow.rampSum y |
| [`WeilPowerCompare.rate`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-rate) | def | `WeilPowerCompare` | ℝ |
| [`WeilPowerCompare.rate_eq_of_le`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-rate_eq_of_le) | theorem | `WeilPowerCompare` | rate m ε' Δ ε = -(cE m * (Δ ^ 2 + ε ^ 2 - ε' ^ 2)) |
| [`WeilPowerCompare.rate_neg_of_ge`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-rate_neg_of_ge) | theorem | `WeilPowerCompare` | rate m ε' Δ ε &lt; 0 |
| [`WeilPowerCompare.rate_neg_of_le`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-rate_neg_of_le) | theorem | `WeilPowerCompare` | rate m ε' Δ ε &lt; 0 |
| [`WeilPowerCompare.rate_neg_of_qerr`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-rate_neg_of_qerr) | theorem | `WeilPowerCompare` | rate m ε' Δ ε &lt; 0 |
| [`Crossover.ratio`](./lean/Crossover.md#Crossover-ratio) | def | `Crossover` | ℝ |
| [`Crossover.ratio_strictMono`](./lean/Crossover.md#Crossover-ratio_strictMono) | theorem | `Crossover` | StrictMono (ratio A B x y) |
| [`WeilPowerPhase.re_A_sq`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-re_A_sq) | theorem | `WeilPowerPhase` | ((((cS m / D m : ℝ) : ℂ) * w * P m w) ^ 2).re = (cS m / D m) ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m) * ((w ^ 2).re * Real.cos (2 * (w ^ 2).im * sigma m) - (w ^ 2).im * Real.sin (2 * (w ^ 2).im * sig… |
| [`Stage3.re_digamma_sub_log_le`](./lean_stage3/Stirling.md#Stage3-re_digamma_sub_log_le) | theorem | `Stirling` | \|phasePoint t - Real.log ‖zq t‖\| ≤ 96 / t |
| [`Stage3.re_eq_half_of_RH`](./lean_stage3/Assembly.md#Stage3-re_eq_half_of_RH) | theorem | `Assembly` | (ρ : ℂ).re = 1 / 2 |
| [`WeilDetect.re_eq_half_of_RH`](./lean_stage3/WeilDetect.md#WeilDetect-re_eq_half_of_RH) | theorem | `WeilDetect` | (ρ : ℂ).re = 1 / 2 |
| [`LandauTrig.re_mul_geom_ge`](./lean_stage3/LandauTrig.md#LandauTrig-re_mul_geom_ge) | theorem | `LandauTrig` | -(‖c‖ * (2 / ‖w - 1‖)) ≤ (c * ∑ n ∈ Finset.Ico a (a + N), w ^ n).re |
| [`WeilPowerPhase.re_S_sq_ge`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-re_S_sq_ge) | theorem | `WeilPowerPhase` | (cS m / D m) ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m) * ((w ^ 2).re * Real.cos (2 * (w ^ 2).im * sigma m) - (w ^ 2).im * Real.sin (2 * (w ^ 2).im * sigma m)) - (cS m / D m) ^ 2 * ‖w‖ ^ 2 * Real.exp (… |
| [`ArgLegs.re_sign_const`](./lean_stage3/ArgLegs.md#ArgLegs-re_sign_const) | theorem | `ArgLegs` | (∀ x ∈ Set.Icc a b, 0 ≤ (g x).re) ∨ (∀ x ∈ Set.Icc a b, (g x).re ≤ 0) |
| [`WeilPowerPhase.re_sq_ge`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-re_sq_ge) | theorem | `WeilPowerPhase` | ((((cS m / D m : ℝ) : ℂ) * w * P m w) ^ 2).re - ‖((cS m / D m : ℝ) : ℂ) * w * P m w‖ ^ 2 * (4 * q m w + 4 * q m w ^ 2) ≤ ((S m w) ^ 2).re |
| [`Stage3.re_sub_log_norm_le`](./lean_stage3/Stirling.md#Stage3-re_sub_log_norm_le) | theorem | `Stirling` | \|w.re - Real.log ‖1 + w‖\| ≤ 8 * ‖w‖ ^ 2 |
| [`WeilPowerNear.re_term_eq`](./lean_stage3/WeilPowerNear.md#WeilPowerNear-re_term_eq) | theorem | `WeilPowerNear` | (WeilPowerShell.coef e' D e * Complex.exp (WeilPowerShell.zOf e' D e * (u : ℂ))).re = Real.exp (2 * (e' ^ 2 - D ^ 2 - e ^ 2) * u) / e ^ 2 * ((e' ^ 2 - D ^ 2) * Real.cos (4 * e' * D * u) - 2 * e' * D *… |
| [`ReZetaCount.re_zeta_two_line_ge`](./lean_stage3/ReZetaCount.md#ReZetaCount-re_zeta_two_line_ge) | theorem | `ReZetaCount` | 2 - Real.pi ^ 2 / 6 ≤ (riemannZeta (2 + (t : ℂ) * Complex.I)).re |
| [`ReZetaCount.re_zeta_two_line_pos`](./lean_stage3/ReZetaCount.md#ReZetaCount-re_zeta_two_line_pos) | theorem | `ReZetaCount` | 0 &lt; (riemannZeta (2 + (t : ℂ) * Complex.I)).re |
| [`PerronKernel.rect_residue`](./lean_stage3/PerronKernel.md#PerronKernel-rect_residue) | theorem | `PerronKernel` | RectangleIntegral' (fun s : ℂ ↦ (y : ℂ) ^ s / s) (-(X:ℂ) - Complex.I * T) ((c:ℂ) + Complex.I * T) = 1 |
| [`PerronKernel.rect_subset_right`](./lean_stage3/PerronKernel.md#PerronKernel-rect_subset_right) | theorem | `PerronKernel` | Rectangle ((c : ℂ) - Complex.I * T) ((X : ℂ) + Complex.I * T) ⊆ {s : ℂ \| 0 &lt; s.re} |
| [`Stage3.rectangleIntegral_logDeriv_xi_eq_N`](./lean_stage3/ArgIdentity.md#Stage3-rectangleIntegral_logDeriv_xi_eq_N) | theorem | `ArgIdentity` | RectangleIntegral' (logDeriv xi) (-1 : ℂ) (2 + Complex.I * T) = ((riemannZeta.N T : ℝ) : ℂ) |
| [`ContourShift.rectangleIntegral_sum_poles`](./lean_stage3/ContourShift.md#ContourShift-rectangleIntegral_sum_poles) | theorem | `ContourShift` | RectangleIntegral' (fun s ↦ ∑ p ∈ P, A p / (s - p)) z w = ∑ p ∈ P, A p |
| [`VonKoch.region`](./lean_stage3/VonKochScaffold.md#VonKoch-region) | def | `VonKochScaffold` | Set ℂ |
| [`Stage3.regionθ`](./lean_stage3/ThetaConverse.md#Stage3-region-) | def | `ThetaConverse` | Set ℂ |
| [`Stage3.regionθ_half`](./lean_stage3/ThetaConverse.md#Stage3-region-_half) | theorem | `ThetaConverse` | regionθ (1/2) = VonKoch.region |
| [`RelativeGate.relError_bound`](./lean/RelativeGate.md#RelativeGate-relError_bound) | theorem | `RelativeGate` | \|stencilR n (fun x =&gt; f x - L x) r\| ≤ EhighRel r n ρ |
| [`JointFloorGate.relErrWindow_floor_of_RH`](./lean_stage3/JointFloorGate.md#JointFloorGate-relErrWindow_floor_of_RH) | theorem | `JointFloorGate` | ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ ∀ x₀ : ℝ, 16 ≤ x₀ → ∀ (r : ℤ) (n : ℕ), x₀ ^ 2 ≤ (2 : ℝ) ^ ((r : ℝ) - n) → 0 ≤ (r : ℝ) - n → JointDialGate.StmtRelErrWindow (fun m : ℤ =&gt; (Nat.primeCounting ⌊… |
| [`JointDialGate.relErrWindow_of_theta`](./lean_stage3/JointDialGate.md#JointDialGate-relErrWindow_of_theta) | theorem | `JointDialGate` | StmtRelErrWindow f L r n (C / (2 * (θ' - θ) / (2 * ((k : ℝ) + 1))) ^ k * (2 : ℝ) ^ (((r : ℝ) - n) * (θ' - 1))) |
| [`JointDialGate.relErrWindow_of_window`](./lean_stage3/JointDialGate.md#JointDialGate-relErrWindow_of_window) | theorem | `JointDialGate` | ∃ A x₀ : ℝ, 0 ≤ A ∧ ∀ (r : ℤ) (n : ℕ), x₀ ≤ (2 : ℝ) ^ ((r : ℝ) - n) → 0 ≤ (r : ℝ) - n → StmtRelErrWindow (fun m : ℤ =&gt; (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ)) (fun m : ℤ =&gt; Stage3.Li ((2 : ℝ) ^ … |
| [`RouteGate.relErrWindow_route`](./lean_stage3/RouteGate.md#RouteGate-relErrWindow_route) | theorem | `RouteGate` | ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ ∀ x₀ : ℝ, 16 ≤ x₀ → ∀ (r : ℤ) (n : ℕ), x₀ ^ 2 ≤ (2 : ℝ) ^ ((r : ℝ) - n) → JointDialGate.StmtRelErrWindow (fun m : ℤ =&gt; (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋… |
| [`RouteNum.relErrWindow_route_num`](./lean_stage3/RouteNum.md#RouteNum-relErrWindow_route_num) | theorem | `RouteNum` | JointDialGate.StmtRelErrWindow (fun m : ℤ =&gt; (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ)) (fun m : ℤ =&gt; 2 / Real.log 2 + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r n (Stage3.routeConst… |
| [`RelativeGate.relGate_eps`](./lean/RelativeGate.md#RelativeGate-relGate_eps) | theorem | `RelativeGate` | Real.log 2 ^ d / (2 * r * 3 ^ (d + 1)) = ((1 / 2) * (Real.log 2 / 3) ^ (d + 1)) / ((r : ℝ) * Real.log 2) |
| [`RelativeGate.relGate_iff`](./lean/RelativeGate.md#RelativeGate-relGate_iff) | theorem | `RelativeGate` | EhighRel r (d + 1) ρ &lt; Mlow r d ↔ ρ &lt; Real.log 2 ^ d / (2 * r * 3 ^ (d + 1)) |
| [`RelativeGate.relWindow_term_le`](./lean/RelativeGate.md#RelativeGate-relWindow_term_le) | theorem | `RelativeGate` | ρ * (2 : ℝ) ^ ((r : ℝ) - k) = ρ * (2 : ℝ) ^ (r : ℝ) * ((2 : ℝ) ^ (-(1 : ℝ))) ^ k |
| [`Stage3.rem_arith`](./lean_stage3/Assembly.md#Stage3-rem_arith) | theorem | `Assembly` | c₁ * xx * G ^ 2 / TT + c₂ * L ≤ (9 * c₁ + c₂) * L ^ 2 |
| [`Stage3.rem_floor`](./lean_stage3/AssemblyFloor.md#Stage3-rem_floor) | theorem | `AssemblyFloor` | c₁ * xx * G ^ 2 / TT ≤ 18 * c₁ * L ^ 2 / xx |
| [`Zeros.repeat_iff_wings`](./lean/ZerosStencil.md#Zeros-repeat_iff_wings) | theorem | `ZerosStencil` | Construction.tableFrom N r d = Construction.tableFrom N (r - 1) d ↔ wingPlus (d + 1) (fun k =&gt; N (r - k)) = wingMinus (d + 1) (fun k =&gt; N (r - k)) |
| [`ContourShift.residue_identity`](./lean_stage3/ContourShift.md#ContourShift-residue_identity) | theorem | `ContourShift` | RectangleIntegral' (fun s : ℂ ↦ (- deriv riemannZeta s / riemannZeta s) * ((x:ℝ):ℂ) ^ s / s) (((-1/4 : ℝ):ℂ) - Complex.I * T') (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * T') = (x : ℂ) - deriv riemannZe… |
| [`ContourShift.residue_rectangle_multi`](./lean_stage3/ContourShift.md#ContourShift-residue_rectangle_multi) | theorem | `ContourShift` | RectangleIntegral' f z w = ∑ p ∈ P, A p |
| [`ContourShift.residue_rectangle_of_local`](./lean_stage3/ContourShift.md#ContourShift-residue_rectangle_of_local) | theorem | `ContourShift` | RectangleIntegral' f z w = ∑ p ∈ P, A p |
| [`ReZetaCount.reZeros`](./lean_stage3/ReZetaCount.md#ReZetaCount-reZeros) | def | `ReZetaCount` | Finset ℝ |
| [`ReZetaCount.reZeroSet`](./lean_stage3/ReZetaCount.md#ReZetaCount-reZeroSet) | def | `ReZetaCount` | Set ℝ |
| [`ReZetaCount.reZeroSet_finite`](./lean_stage3/ReZetaCount.md#ReZetaCount-reZeroSet_finite) | theorem | `ReZetaCount` | (reZeroSet T).Finite |
| [`VonKoch.RH_iff_psiWeak`](./lean_stage3/VonKochScaffold.md#VonKoch-RH_iff_psiWeak) | theorem | `VonKochScaffold` | RiemannHypothesis ↔ ∃ C &gt; 0, ∃ x₀ : ℝ, Stage3.StmtPsiWeak C 3 x₀ |
| [`VonKoch.RH_of_no_zero_right_of_half`](./lean_stage3/VonKochScaffold.md#VonKoch-RH_of_no_zero_right_of_half) | theorem | `VonKochScaffold` | RiemannHypothesis |
| [`VonKoch.RH_of_psiWeak`](./lean_stage3/VonKochScaffold.md#VonKoch-RH_of_psiWeak) | theorem | `VonKochScaffold` | RiemannHypothesis |
| [`Stage3.RH_of_psiWeakTheta_half`](./lean_stage3/ThetaConverse.md#Stage3-RH_of_psiWeakTheta_half) | theorem | `ThetaConverse` | RiemannHypothesis |
| [`LandauWindow.rh_of_window`](./lean_stage3/LandauWindow.md#LandauWindow-rh_of_window) | theorem | `LandauWindow` | RiemannHypothesis |
| [`LandauCriterion.rh_of_windows`](./lean_stage3/LandauCriterion.md#LandauCriterion-rh_of_windows) | theorem | `LandauCriterion` | RiemannHypothesis |
| [`LandauWindow.rh_of_zeroFree_half`](./lean_stage3/LandauWindow.md#LandauWindow-rh_of_zeroFree_half) | theorem | `LandauWindow` | RiemannHypothesis |
| [`WeilPowerGeom.rho_ne_one`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-rho_ne_one) | theorem | `WeilPowerGeom` | Complex.exp (z / (Real.pi : ℂ) ^ 2) ≠ 1 |
| [`WeilPowerGeomGen.rho_ne_one_gen`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-rho_ne_one_gen) | theorem | `WeilPowerGeomGen` | Complex.exp (z * ((α : ℝ) : ℂ)) ≠ 1 |
| [`Transform.riemannHypothesis_iff_pair_collapses`](./lean/Transform.md#Transform-riemannHypothesis_iff_pair_collapses) | theorem | `Transform` | RiemannHypothesis ↔ ∀ (s : ℂ), riemannZeta s = 0 → ¬(∃ n : ℕ, s = -2 * (n + 1)) → s ≠ 1 → ‖(b : ℂ) ^ (-s)‖ = ‖(b : ℂ) ^ (-(1 - s))‖ |
| [`Transform.riemannHypothesis_iff_zeros_inversion_fixed`](./lean/Transform.md#Transform-riemannHypothesis_iff_zeros_inversion_fixed) | theorem | `Transform` | RiemannHypothesis ↔ ∀ (s : ℂ), riemannZeta s = 0 → ¬(∃ n : ℕ, s = -2 * (n + 1)) → s ≠ 1 → ‖(b : ℂ) ^ (-(1 : ℂ)) / (b : ℂ) ^ (-s)‖ = ‖(b : ℂ) ^ (-s)‖ |
| [`Transform.riemannHypothesis_iff_zeros_on_middle_circle`](./lean/Transform.md#Transform-riemannHypothesis_iff_zeros_on_middle_circle) | theorem | `Transform` | RiemannHypothesis ↔ ∀ (s : ℂ), riemannZeta s = 0 → ¬(∃ n : ℕ, s = -2 * (n + 1)) → s ≠ 1 → ‖(b : ℂ) ^ (-s)‖ = b ^ (-(1 : ℝ) / 2) |
| [`Stage3.routeConst`](./lean_stage3/RouteNum.md#Stage3-routeConst) | def | `RouteNum` | ℝ |
| [`GateEval.routeConst_le`](./lean_stage3/GateEval.md#GateEval-routeConst_le) | theorem | `GateEval` | Stage3.routeConst ((2:ℝ) ^ (36:ℕ)) ≤ 414 |
| [`Isogeny.row_three_eq_triple`](./lean/Isogeny.md#Isogeny-row_three_eq_triple) | theorem | `Isogeny` | rowN Q 3 r = rowN Q 1 (3 * r) + rowN Q 1 (3 * r + 1) + rowN Q 1 (3 * r + 2) |
| [`Isogeny.row_two_eq_pair`](./lean/Isogeny.md#Isogeny-row_two_eq_pair) | theorem | `Isogeny` | rowN Q 2 r = rowN Q 1 (2 * r) + rowN Q 1 (2 * r + 1) |
| [`Isogeny.rowN`](./lean/Isogeny.md#Isogeny-rowN) | def | `Isogeny` | ℤ |
| [`TableRoute.rowN`](./lean_stage3/TableRoute.md#TableRoute-rowN) | def | `TableRoute` | ℤ |
| [`Isogeny.rowN_comp`](./lean/Isogeny.md#Isogeny-rowN_comp) | theorem | `Isogeny` | rowN Q (k * l) r = rowN (fun n =&gt; Q (k * n)) l r |
| [`Isogeny.rowN_eq_blockSum`](./lean/Isogeny.md#Isogeny-rowN_eq_blockSum) | theorem | `Isogeny` | rowN Q k r = ∑ j ∈ range k, rowN Q 1 (k * r + j) |
| [`Isogeny.rowOf`](./lean/Isogeny.md#Isogeny-rowOf) | def | `Isogeny` | ℤ |
| [`Isogeny.rowOf_eq_rowN`](./lean/Isogeny.md#Isogeny-rowOf_eq_rowN) | theorem | `Isogeny` | rowOf P b r = rowN (fun n =&gt; P (b ^ n)) 1 r |
| [`Transform.rpow_left_inj`](./lean/Transform.md#Transform-rpow_left_inj) | theorem | `Transform` | b ^ x = b ^ y ↔ x = y |
| [`Stage3.rpow_neg_half_mul`](./lean_stage3/PsiToPi.md#Stage3-rpow_neg_half_mul) | theorem | `PsiToPi` | t ^ (-(1 : ℝ) / 2) * (t * Real.log t ^ 2) = Real.sqrt t * Real.log t ^ 2 |
| [`RHPull.rpow_one_add`](./lean_stage3/LineBound.md#RHPull-rpow_one_add) | theorem | `LineBound` | X ^ (1 + 1 / Real.log X) = Real.exp 1 * X |
| [`Stage3.rpow_theta_sub_one_mul`](./lean_stage3/ThetaPi.md#Stage3-rpow_theta_sub_one_mul) | theorem | `ThetaPi` | t ^ (θ - 1) * (t * Real.log t ^ 2) = t ^ θ * Real.log t ^ 2 |
| [`RHPull.rpow_σRH`](./lean_stage3/LineBound.md#RHPull-rpow_-RH) | theorem | `LineBound` | X ^ (σRH X) = Real.exp 1 * Real.sqrt X |
| [`Stage3.rpow_σθ`](./lean_stage3/Abscissa.md#Stage3-rpow_--) | theorem | `Abscissa` | X ^ (σθ θ X) = Real.exp 1 * X ^ θ |
| [`Stage3.rpow_σθ_half`](./lean_stage3/Abscissa.md#Stage3-rpow_--_half) | theorem | `Abscissa` | X ^ (σθ (1/2) X) = Real.exp 1 * Real.sqrt X |
| [`ArgCount.rvM_crude`](./lean_stage3/ArgCount.md#ArgCount-rvM_crude) | theorem | `ArgCount` | riemannZeta.Riemann_vonMangoldt_bound 112 0 698 |
| [`ArgCount.rvM_crude_of_good_two`](./lean_stage3/ArgCount.md#ArgCount-rvM_crude_of_good_two) | theorem | `ArgCount` | riemannZeta.Riemann_vonMangoldt_bound 112 0 173 |
| [`Stage3.RvM_mono`](./lean_stage3/ZeroSum.md#Stage3-RvM_mono) | theorem | `ZeroSum` | riemannZeta.RvM b₁ b₂ b₃ T ≤ riemannZeta.RvM b₁ b₂ b₃ T' |
| [`Stage3.RvM_of_phase_arg`](./lean_stage3/RvMCrude.md#Stage3-RvM_of_phase_arg) | theorem | `RvMCrude` | riemannZeta.Riemann_vonMangoldt_bound (B₁ + B₁') 0 (B₃ + B₃') |
| [`Stage3.rvM_of_sFromLocal`](./lean_stage3/ArgIdentity.md#Stage3-rvM_of_sFromLocal) | theorem | `ArgIdentity` | riemannZeta.Riemann_vonMangoldt_bound (97 + a * 15) 0 (98 + (a * 73 + b)) |
| [`Stage3.rvM_of_stirling_and_pieces`](./lean_stage3/ArgCrude.md#Stage3-rvM_of_stirling_and_pieces) | theorem | `ArgCrude` | riemannZeta.Riemann_vonMangoldt_bound (B₁ + a * A₁) 0 (B₃ + (a * A₃ + b)) |
| [`Expansion.S`](./lean/Expansion.md#Expansion-S) | def | `Expansion` | ℝ |
| [`WeilOddPower.S`](./lean_stage3/WeilOddPower.md#WeilOddPower-S) | def | `WeilOddPower` | ℂ |
| [`WeilOddPower.S_eq`](./lean_stage3/WeilOddPower.md#WeilOddPower-S_eq) | theorem | `WeilOddPower` | S m w = 2 * w * K (m + 1) w / (((m : ℂ) + 1) * (Real.pi : ℂ)) |
| [`Expansion.S_eq_alt`](./lean/Expansion.md#Expansion-S_eq_alt) | theorem | `Expansion` | S d x = ∑ j ∈ range (d + 1), (-1 : ℝ) ^ j * t d j x |
| [`WeilPowerBounds.S_eq_div`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-S_eq_div) | theorem | `WeilPowerBounds` | S m w = (cS m : ℂ) * Complex.sinh w / QS m w |
| [`WeilPowerBounds.S_eq_div'`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-S_eq_div-) | theorem | `WeilPowerBounds` | S m w = (cS m : ℂ) * Complex.sinh w / QS m w |
| [`WeilPowerBackground.S_eq_sinh`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-S_eq_sinh) | theorem | `WeilPowerBackground` | S m w = ∫ x in (-1 : ℝ)..1, ((q m x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) |
| [`Expansion.S_floor`](./lean/Expansion.md#Expansion-S_floor) | theorem | `Expansion` | Real.log 2 ^ d / (2 * x) ≤ S d x |
| [`WeilPowerBackground.S_I_mul`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-S_I_mul) | theorem | `WeilPowerBackground` | S m (Complex.I * (t : ℂ)) = Complex.I * (PsiW m t : ℂ) |
| [`WeilOddPower.S_mul_QS`](./lean_stage3/WeilOddPower.md#WeilOddPower-S_mul_QS) | theorem | `WeilOddPower` | S m w * QS m w = (cS m : ℂ) * Complex.sinh w |
| [`WeilPowerBackground.S_neg`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-S_neg) | theorem | `WeilPowerBackground` | S m (-w) = -S m w |
| [`WeilPowerBounds.S_real_eq`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-S_real_eq) | theorem | `WeilPowerBounds` | S m (s : ℂ) = ((cS m * Real.sinh s / Ps m s : ℝ) : ℂ) |
| [`WeilPowerBounds.S_real_ge`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-S_real_ge) | theorem | `WeilPowerBounds` | cS m * Real.exp s / (4 * (s ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ^ (m + 1)) ≤ (S m (s : ℂ)).re |
| [`WeilPowerGauss.S_real_ge_gauss`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-S_real_ge_gauss) | theorem | `WeilPowerGauss` | 4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) * s * Real.exp (s ^ 2 * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2) - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ≤ (S m (s : ℂ)).re |
| [`WeilPowerCompare.S_real_ge_low`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-S_real_ge_low) | theorem | `WeilPowerCompare` | 4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) * s * Real.exp (Elow m s) ≤ (S m (s : ℂ)).re |
| [`WeilPowerSharp.S_real_ge_sharp`](./lean_stage3/WeilPowerSharp.md#WeilPowerSharp-S_real_ge_sharp) | theorem | `WeilPowerSharp` | cS m / D m * s * Real.exp (s ^ 2 / (Real.pi ^ 2 * ((m : ℝ) + 2)) - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ≤ (S m (s : ℂ)).re |
| [`WeilPowerCompare.S_real_pos`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-S_real_pos) | theorem | `WeilPowerCompare` | 0 &lt; (S m (s : ℂ)).re |
| [`WeilOddPower.S_zero_mul`](./lean_stage3/WeilOddPower.md#WeilOddPower-S_zero_mul) | theorem | `WeilOddPower` | S 0 w * (w ^ 2 + (Real.pi : ℂ) ^ 2) = 2 * (Real.pi : ℂ) * Complex.sinh w |
| [`Nyquist.sample`](./lean/Nyquist.md#Nyquist-sample) | def | `Nyquist` | ℝ |
| [`Stage3.schoenfeld_iff_weak`](./lean_stage3/Statement.md#Stage3-schoenfeld_iff_weak) | theorem | `Statement` | StmtSchoenfeld pi li ↔ StmtSchoenfeldWeak (1 / (8 * Real.pi)) 1 2657 pi li |
| [`Stage3.schoenfeldWeak_floor_of_RH`](./lean_stage3/AssemblyFloor.md#Stage3-schoenfeldWeak_floor_of_RH) | theorem | `AssemblyFloor` | ∃ c₁ c₂ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₂ ∧ ∀ x₀ : ℝ, 16 ≤ x₀ → StmtSchoenfeldWeak (3 * floorConst c₁ c₂ 112 0 698 weightedZeroHeightBucket x₀ + 13) 1 (max (x₀ ^ 2) 9) (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li |
| [`Stage3.schoenfeldWeak_floor_split_of_RH`](./lean_stage3/GlueFloor.md#Stage3-schoenfeldWeak_floor_split_of_RH) | theorem | `GlueFloor` | ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ ∀ x₀ : ℝ, 16 ≤ x₀ → StmtSchoenfeldWeak (3 * floorConstSplit c₁ c₃ c₄ 112 0 698 weightedZeroHeightBucket x₀ + 13) 1 (max (x₀ ^ 2) 9) (fun x =&gt; (Nat.primeCount… |
| [`Stage3.schoenfeldWeak_of_psiWeak`](./lean_stage3/PsiToPi.md#Stage3-schoenfeldWeak_of_psiWeak) | theorem | `PsiToPi` | StmtSchoenfeldWeak (3 * C + 13) (k - 1) (max (x₀ ^ 2) 9) (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li |
| [`Stage3.schoenfeldWeak_of_psiWeak_half`](./lean_stage3/ThetaPi.md#Stage3-schoenfeldWeak_of_psiWeak_half) | theorem | `ThetaPi` | StmtSchoenfeldWeak (3 * C + 13) (k - 1) (max (x₀ ^ 2) 9) (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li |
| [`Slice8.schoenfeldWeak_of_psiWeak_three`](./lean_stage3/LineBound.md#Slice8-schoenfeldWeak_of_psiWeak_three) | theorem | `LineBound` | Stage3.StmtSchoenfeldWeak (3 * C + 13) 2 (max (x₀ ^ 2) 9) (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li |
| [`Stage3.schoenfeldWeak_of_RH_half`](./lean_stage3/ThetaPi.md#Stage3-schoenfeldWeak_of_RH_half) | theorem | `ThetaPi` | ∃ C &gt; 0, ∃ x₀ : ℝ, StmtSchoenfeldWeak C 2 x₀ (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li |
| [`Stage3.schoenfeldWeak_route_num`](./lean_stage3/RouteNum.md#Stage3-schoenfeldWeak_route_num) | theorem | `RouteNum` | StmtSchoenfeldWeak (routeConst x₀) 1 (max (x₀ ^ 2) 9) (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li |
| [`Stage3.schoenfeldWeakTheta_of_psiWeakTheta`](./lean_stage3/ThetaPi.md#Stage3-schoenfeldWeakTheta_of_psiWeakTheta) | theorem | `ThetaPi` | StmtSchoenfeldWeakTheta θ (3 * C + 13) (k - 1) (max (x₀ ^ 2) 9) (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li |
| [`JointWindowDial.schoenfeldWeakTheta_of_window`](./lean_stage3/JointWindowDial.md#JointWindowDial-schoenfeldWeakTheta_of_window) | theorem | `JointWindowDial` | ∃ C' &gt; 0, ∃ x₀ : ℝ, Stage3.StmtSchoenfeldWeakTheta θ C' 2 x₀ (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li |
| [`Stage3.schoenfeldWeakTheta_of_zeroFree`](./lean_stage3/ThetaPi.md#Stage3-schoenfeldWeakTheta_of_zeroFree) | theorem | `ThetaPi` | ∃ C &gt; 0, ∃ x₀ : ℝ, StmtSchoenfeldWeakTheta θ C 2 x₀ (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li |
| [`RelativeGate.schoenfeldWindow_relErr`](./lean/RelativeGate.md#RelativeGate-schoenfeldWindow_relErr) | theorem | `RelativeGate` | StmtRelErrWindow f L r n ((Real.log 2 * r / (8 * Real.pi)) * (2 : ℝ) ^ (-((r : ℝ) - n) / 2)) |
| [`GeneratorPeak.score`](./lean/GeneratorPeak.md#GeneratorPeak-score) | def | `GeneratorPeak` | ℝ |
| [`GeneratorPeak.score_eq`](./lean/GeneratorPeak.md#GeneratorPeak-score_eq) | theorem | `GeneratorPeak` | score R P α β k = P ^ β * (R k) ^ (α - β) |
| [`ArgCount.sCrude_holds`](./lean_stage3/ArgCount.md#ArgCount-sCrude_holds) | theorem | `ArgCount` | Stage3.StmtSCrude Stage3.argS 15 600 |
| [`ArgCount.sCrude_holds_of_good_two`](./lean_stage3/ArgCount.md#ArgCount-sCrude_holds_of_good_two) | theorem | `ArgCount` | Stage3.StmtSCrude Stage3.argS 15 75 |
| [`Stage3.sCrude_of_local`](./lean_stage3/ArgCrude.md#Stage3-sCrude_of_local) | theorem | `ArgCrude` | StmtSCrude S (a * A₁) (a * A₃ + b) |
| [`Chain.second_ladder_winds_densely`](./lean/Chain.md#Chain-second_ladder_winds_densely) | theorem | `Chain` | DenseRange (fun k : ℤ =&gt; k • ((2 * Real.pi / Real.log b₂ : ℝ) : AddCircle (2 * Real.pi / Real.log b₁))) ↔ Irrational (Real.log b₁ / Real.log b₂) |
| [`ZeroCells.seedPerturbation_all_vanish`](./lean/ZeroCells.md#ZeroCells-seedPerturbation_all_vanish) | theorem | `ZeroCells` | ∀ c ∈ SeedPerturbation.zero_cells, Construction.tableFrom Zeros.dyadicRow (c.1 : ℤ) c.2 = 0 |
| [`ZeroCells.seedPerturbation_eq`](./lean/ZeroCells.md#ZeroCells-seedPerturbation_eq) | theorem | `ZeroCells` | SeedPerturbation.zero_cells = Zeros.measured_zeros |
| [`PerronKernel.seg_inv_integral`](./lean_stage3/PerronKernel.md#PerronKernel-seg_inv_integral) | theorem | `PerronKernel` | (∫ t in (-T)..T, ((c : ℂ) + Complex.I * t)⁻¹ * Complex.I) = 2 * Real.arctan (T / c) * Complex.I |
| [`ArgLegs.segment_im_integral_le`](./lean_stage3/ArgLegs.md#ArgLegs-segment_im_integral_le) | theorem | `ArgLegs` | \|(∫ x in a..b, g' x / g x).im\| ≤ Real.pi * ((Z.card : ℝ) + 1) |
| [`WeilPowerShell.shellSum`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-shellSum) | def | `WeilPowerShell` | ℝ |
| [`WeilPowerShell.shellSum_le`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-shellSum_le) | theorem | `WeilPowerShell` | \|shellSum e' D e lam a b\| ≤ (e' ^ 2 + D ^ 2) / e ^ 2 * Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) * ((lam : ℝ) * Real.pi ^ 3 * Real.exp (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (1 / ((lam : ℝ) * … |
| [`WeilPowerShell.shellSum_le_abs`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-shellSum_le_abs) | theorem | `WeilPowerShell` | \|shellSum e' D e lam a b\| ≤ (e' ^ 2 + \|D\| ^ 2) / e ^ 2 * Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) * ((lam : ℝ) * Real.pi ^ 3 * Real.exp (2 * (e' ^ 2 + \|D\| ^ 2 + e ^ 2) * (1 / ((lam : ℝ… |
| [`WeilPowerShell.shellSum_neg`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-shellSum_neg) | theorem | `WeilPowerShell` | shellSum e' (-D) e lam a b = shellSum e' D e lam a b |
| [`WeilPowerNear.shellSum_nonneg`](./lean_stage3/WeilPowerNear.md#WeilPowerNear-shellSum_nonneg) | theorem | `WeilPowerNear` | 0 ≤ WeilPowerShell.shellSum e' D e lam a b |
| [`WeilPowerNear.shellSum_nonneg_abs`](./lean_stage3/WeilPowerNear.md#WeilPowerNear-shellSum_nonneg_abs) | theorem | `WeilPowerNear` | 0 ≤ WeilPowerShell.shellSum e' D e lam a b |
| [`WeilPowerPhase.sigma`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-sigma) | def | `WeilPowerPhase` | ℝ |
| [`WeilWindow.Sigma`](./lean_stage3/WeilWindow.md#WeilWindow-Sigma) | def | `WeilWindow` | ℝ |
| [`WeilPowerPhase.sigma_ge`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-sigma_ge) | theorem | `WeilPowerPhase` | 1 / (Real.pi ^ 2 * ((m : ℝ) + 2)) ≤ sigma m |
| [`WeilWindow.Sigma_ge`](./lean_stage3/WeilWindow.md#WeilWindow-Sigma_ge) | theorem | `WeilWindow` | s / 24 ≤ Sigma s |
| [`WeilPowerSigma.sigma_ge_amgm`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-sigma_ge_amgm) | theorem | `WeilPowerSigma` | 1 / (Real.pi ^ 2 * ((m : ℝ) + 2)) + 1 / (2 * Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2) ≤ sigma m |
| [`WeilWindow.Sigma_ge_mul`](./lean_stage3/WeilWindow.md#WeilWindow-Sigma_ge_mul) | theorem | `WeilWindow` | s * m2 ≤ Sigma s |
| [`WeilPowerPhase.sigma_le`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-sigma_le) | theorem | `WeilPowerPhase` | sigma m ≤ 1 / (Real.pi ^ 2 * ((m : ℝ) + 1)) |
| [`WeilPowerSigma.sigma_le_half`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-sigma_le_half) | theorem | `WeilPowerSigma` | sigma m ≤ 2 / (Real.pi ^ 2 * (2 * (m : ℝ) + 3)) |
| [`WeilTransform.SigmaC`](./lean_stage3/WeilTransform.md#WeilTransform-SigmaC) | def | `WeilTransform` | ℂ |
| [`WeilLobe.SigmaC_bound`](./lean_stage3/WeilLobe.md#WeilLobe-SigmaC_bound) | theorem | `WeilLobe` | ‖SigmaC w‖ ≤ (2 * Real.pi + Real.pi ^ 2) * Real.cosh w.re / ‖w‖ ^ 2 |
| [`WeilLobe.SigmaC_eq_ibp`](./lean_stage3/WeilLobe.md#WeilLobe-SigmaC_eq_ibp) | theorem | `WeilLobe` | SigmaC w = (1 / w ^ 2) * ∫ x in (-1 : ℝ)..1, ((q2 x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) |
| [`WeilTransform.SigmaC_I_mul`](./lean_stage3/WeilTransform.md#WeilTransform-SigmaC_I_mul) | theorem | `WeilTransform` | SigmaC (Complex.I * (s : ℂ)) = Complex.I * (Psi s : ℂ) |
| [`WeilOffLine.SigmaC_neg`](./lean_stage3/WeilOffLine.md#WeilOffLine-SigmaC_neg) | theorem | `WeilOffLine` | SigmaC (-w) = -SigmaC w |
| [`WeilTransform.SigmaC_ofReal`](./lean_stage3/WeilTransform.md#WeilTransform-SigmaC_ofReal) | theorem | `WeilTransform` | SigmaC (s : ℂ) = (WeilWindow.Sigma s : ℂ) |
| [`WeilPowerPhase.sigmaN`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-sigmaN) | def | `WeilPowerPhase` | ℝ |
| [`WeilPowerPhase.sigmaN_eq`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-sigmaN_eq) | theorem | `WeilPowerPhase` | sigmaN m n = 1 / Real.pi ^ 2 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 |
| [`WeilPowerPhase.sigmaN_tendsto`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-sigmaN_tendsto) | theorem | `WeilPowerPhase` | Tendsto (fun n =&gt; sigmaN m n) atTop (𝓝 (sigma m)) |
| [`SeedPerturbation.silence46_alive_at_three`](./lean/SeedPerturbation.md#SeedPerturbation-silence46_alive_at_three) | theorem | `SeedPerturbation` | silence46_excess 3 ≠ 0 |
| [`SeedPerturbation.silence46_cell_4_1_moves`](./lean/SeedPerturbation.md#SeedPerturbation-silence46_cell_4_1_moves) | theorem | `SeedPerturbation` | tableFrom (fun x =&gt; N x - silence46_excess x) 4 1 ≠ tableFrom N 4 1 |
| [`SeedPerturbation.silence46_deep_cells_fixed`](./lean/SeedPerturbation.md#SeedPerturbation-silence46_deep_cells_fixed) | theorem | `SeedPerturbation` | tableFrom (fun x =&gt; N x - silence46_excess x) 8 3 = tableFrom N 8 3 ∧ tableFrom (fun x =&gt; N x - silence46_excess x) 20 6 = tableFrom N 20 6 |
| [`SeedPerturbation.silence46_excess`](./lean/SeedPerturbation.md#SeedPerturbation-silence46_excess) | def | `SeedPerturbation` | ℤ → ℤ |
| [`SeedPerturbation.silence46_vanishes_above_three`](./lean/SeedPerturbation.md#SeedPerturbation-silence46_vanishes_above_three) | theorem | `SeedPerturbation` | ∀ s : ℤ, 3 &lt; s → silence46_excess s = 0 |
| [`WeilPowerGeom.sin_im_ge`](./lean_stage3/WeilPowerGeom.md#WeilPowerGeom-sin_im_ge) | theorem | `WeilPowerGeom` | 2 * z.im / Real.pi ^ 3 ≤ Real.sin (z.im / Real.pi ^ 2) |
| [`WeilPowerGeomGen.sin_im_ge_gen`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-sin_im_ge_gen) | theorem | `WeilPowerGeomGen` | 2 * (z.im * α) / Real.pi ≤ Real.sin (z.im * α) |
| [`WeilOddPower.sin_pi_mul`](./lean_stage3/WeilOddPower.md#WeilOddPower-sin_pi_mul) | theorem | `WeilOddPower` | Real.sin (Real.pi * x) = 2 * Real.sin (Real.pi * x / 2) * c x |
| [`WeilPowerBounds.sinh_ge`](./lean_stage3/WeilPowerBounds.md#WeilPowerBounds-sinh_ge) | theorem | `WeilPowerBounds` | Real.exp s / 4 ≤ Real.sinh s |
| [`RHPull.smoothedChebyshev_sqrt_bound`](./lean_stage3/LineBound.md#RHPull-smoothedChebyshev_sqrt_bound) | theorem | `LineBound` | ‖SmoothedChebyshev ν ε X - mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 * X‖ ≤ B₁ + B₉ + (22200 * Real.exp 1 * C / ε) * Real.sqrt X * (Real.log X) ^ 2 + (1 / (2 * Real.pi)) * (1 / 2) * ((1996 * Real.log (84… |
| [`RHPull.smoothedChebyshev_sub_main_norm_le`](./lean_stage3/LineBound.md#RHPull-smoothedChebyshev_sub_main_norm_le) | theorem | `LineBound` | ‖SmoothedChebyshev ν ε X - mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 * X‖ ≤ B₁ + B₉ + (1 / (2 * Real.pi)) * (2 * T) * (11100 * (Real.log X) ^ 2 * M₃₇ * X ^ (σRH X)) + (1 / (2 * Real.pi)) * (1 / 2) * ((19… |
| [`Crossover.spread_is_non_monotone`](./lean/Crossover.md#Crossover-spread_is_non_monotone) | theorem | `Crossover` | (0.0591885 : ℝ) &lt; 0.3026405 ∧ (0.0219312 : ℝ) &lt; 0.3026405 |
| [`Crossover.spread_prime`](./lean/Crossover.md#Crossover-spread_prime) | def | `Crossover` | List ℝ |
| [`Crossover.spread_smooth`](./lean/Crossover.md#Crossover-spread_smooth) | def | `Crossover` | List ℝ |
| [`TableDepths.sq_le_gen`](./lean_stage3/TableDepths.md#TableDepths-sq_le_gen) | theorem | `TableDepths` | r ^ 2 ≤ r₀ ^ 2 * (2:ℝ) ^ ((r - r₀) / 2) |
| [`GateEval.sq_le_two_rpow`](./lean_stage3/GateEval.md#GateEval-sq_le_two_rpow) | theorem | `GateEval` | r ^ 2 ≤ 6400 * (2:ℝ) ^ ((r - 80) / 2) |
| [`ZetaGrowth.sq_mul_zeta_analytic`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-sq_mul_zeta_analytic) | theorem | `ZetaGrowth` | AnalyticAt ℂ (fun z : ℂ ↦ (z - 1)^2 * riemannZeta z) s |
| [`ContourShift.sq_mul_zeta_analyticAt_one`](./lean_stage3/ContourShift.md#ContourShift-sq_mul_zeta_analyticAt_one) | theorem | `ContourShift` | AnalyticAt ℂ (fun s ↦ (s - 1)^2 * riemannZeta s) 1 |
| [`Chain.sq_rpow_half`](./lean/Chain.md#Chain-sq_rpow_half) | theorem | `Chain` | (b ^ (-(1:ℝ)/2)) ^ 2 = b ^ (-(1:ℝ)) |
| [`ZetaGrowth.sq_zeta_band_bound`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-sq_zeta_band_bound) | theorem | `ZetaGrowth` | ∃ C : ℝ, 0 &lt; C ∧ ∀ s : ℂ, -1/2 ≤ s.re → s.re ≤ 4 → ‖(s - 1)^2 * riemannZeta s‖ ≤ C * (2 + \|s.im\|) ^ 4 |
| [`BoxBounds.sq_zeta_band_explicit`](./lean_stage3/BoxBounds.md#BoxBounds-sq_zeta_band_explicit) | theorem | `BoxBounds` | ‖(s - 1) ^ 2 * riemannZeta s‖ ≤ 135 * (2 + \|s.im\|) ^ 4 |
| [`BoxBounds.sq_zeta_box`](./lean_stage3/BoxBounds.md#BoxBounds-sq_zeta_box) | theorem | `BoxBounds` | ‖(s - 1) ^ 2 * riemannZeta s‖ ≤ 135 |
| [`Stage3.sqPos_eq`](./lean_stage3/ExplicitBump.md#Stage3-sqPos_eq) | theorem | `ExplicitBump` | (max 0 u) ^ 2 = if u ≤ 0 then 0 else u ^ 2 |
| [`Stage3.sqrt_le_rpow_theta`](./lean_stage3/ThetaPi.md#Stage3-sqrt_le_rpow_theta) | theorem | `ThetaPi` | Real.sqrt x ≤ x ^ θ |
| [`NyquistPeak.stationary_maximum`](./lean/NyquistPeak.md#NyquistPeak-stationary_maximum) | theorem | `NyquistPeak` | HasDerivAt (gain d) 0 Real.pi ∧ (∀ θ : ℝ, gain d θ ≤ gain d Real.pi) ∧ (∀ θ : ℝ, \|Real.sin (θ / 2)\| ≠ 1 → gain d θ &lt; gain d Real.pi) |
| [`CellZeros.stencil`](./lean_stage3/CellZeros.md#CellZeros-stencil) | def | `CellZeros` | ℂ |
| [`Zeros.stencil`](./lean/ZerosStencil.md#Zeros-stencil) | def | `ZerosStencil` | ℤ |
| [`CellZeros.stencil_add`](./lean_stage3/CellZeros.md#CellZeros-stencil_add) | theorem | `CellZeros` | stencil d (fun n =&gt; a n + b n) r = stencil d a r + stencil d b r |
| [`Zeros.stencil_add`](./lean/ZerosStencil.md#Zeros-stencil_add) | theorem | `ZerosStencil` | stencil N (fun k =&gt; g k + h k) = stencil N g + stencil N h |
| [`Zeros.stencil_annihilates_const`](./lean/ZerosStencil.md#Zeros-stencil_annihilates_const) | theorem | `ZerosStencil` | stencil N (fun _ =&gt; c) = 0 |
| [`Zeros.stencil_arm_doubled`](./lean/ZerosStencil.md#Zeros-stencil_arm_doubled) | theorem | `ZerosStencil` | (∑ k ∈ Finset.range (N + 1), (1 + (-1 : ℤ) ^ k) * (N.choose k)) = 2 ^ N |
| [`Zeros.stencil_arms_eq`](./lean/ZerosStencil.md#Zeros-stencil_arms_eq) | theorem | `ZerosStencil` | (∑ k ∈ Finset.range (N + 1), (1 + (-1 : ℤ) ^ k) * (N.choose k)) = ∑ k ∈ Finset.range (N + 1), (1 - (-1 : ℤ) ^ k) * (N.choose k) |
| [`CellZeros.stencil_const_mul`](./lean_stage3/CellZeros.md#CellZeros-stencil_const_mul) | theorem | `CellZeros` | stencil d (fun n =&gt; c * a n) r = c * stencil d a r |
| [`Zeros.stencil_eq_wings`](./lean/ZerosStencil.md#Zeros-stencil_eq_wings) | theorem | `ZerosStencil` | stencil N g = wingPlus N g - wingMinus N g |
| [`Zeros.stencil_eq_zero_iff_wings`](./lean/ZerosStencil.md#Zeros-stencil_eq_zero_iff_wings) | theorem | `ZerosStencil` | stencil N g = 0 ↔ wingPlus N g = wingMinus N g |
| [`CellZeros.stencil_mode`](./lean_stage3/CellZeros.md#CellZeros-stencil_mode) | theorem | `CellZeros` | stencil d (fun n : ℤ =&gt; w ^ n) r = w ^ r * (1 - w⁻¹) ^ d |
| [`Zeros.stencil_smul`](./lean/ZerosStencil.md#Zeros-stencil_smul) | theorem | `ZerosStencil` | stencil N (fun k =&gt; c * g k) = c * stencil N g |
| [`CellZeros.stencil_sub`](./lean_stage3/CellZeros.md#CellZeros-stencil_sub) | theorem | `CellZeros` | stencil d (fun n =&gt; a n - b n) r = stencil d a r - stencil d b r |
| [`CellZeros.stencil_sum`](./lean_stage3/CellZeros.md#CellZeros-stencil_sum) | theorem | `CellZeros` | stencil d (fun n =&gt; ∑ i ∈ s, f i n) r = ∑ i ∈ s, stencil d (f i) r |
| [`Zeros.stencil_weights_antisymm`](./lean/ZerosStencil.md#Zeros-stencil_weights_antisymm) | theorem | `ZerosStencil` | ((-1 : ℤ)) ^ (N - k) * (N.choose (N - k)) = -(((-1 : ℤ)) ^ k * (N.choose k)) |
| [`CellZeros.stencil_zeroPartialSum`](./lean_stage3/CellZeros.md#CellZeros-stencil_zeroPartialSum) | theorem | `CellZeros` | stencil d (fun n : ℤ =&gt; Stage3.zeroPartialSum ((2:ℝ) ^ n) T) r = ∑' ρ : {ρ : Kadiri.NontrivialZeros // \|(ρ : ℂ).im\| &lt; T}, ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ) * (((2:ℂ) ^ (… |
| [`Nonvanishing.stencilR`](./lean/Nonvanishing.md#Nonvanishing-stencilR) | def | `Nonvanishing` | ℝ |
| [`MainTerm.stencilR_eq_iter`](./lean/MainTerm.md#MainTerm-stencilR_eq_iter) | theorem | `MainTerm` | Nonvanishing.stencilR n (fun k : ℤ =&gt; G k) r = (bdiffR^[n]) G r |
| [`MainTerm.stencilR_ge_of`](./lean/MainTerm.md#MainTerm-stencilR_ge_of) | theorem | `MainTerm` | c ≤ \|Nonvanishing.stencilR (d + 1) (fun k : ℤ =&gt; G k) r\| |
| [`Nonvanishing.stencilR_row`](./lean/Nonvanishing.md#Nonvanishing-stencilR_row) | theorem | `Nonvanishing` | stencilR d (bdiffZ g) r = stencilR (d + 1) g r |
| [`Nonvanishing.stencilR_sub`](./lean/Nonvanishing.md#Nonvanishing-stencilR_sub) | theorem | `Nonvanishing` | stencilR n (fun x =&gt; f x - L x) r = stencilR n f r - stencilR n L r |
| [`Chain.StmtA1`](./lean/Chain.md#Chain-StmtA1) | def | `Chain` | Prop |
| [`Chain.StmtA2`](./lean/Chain.md#Chain-StmtA2) | def | `Chain` | Prop |
| [`Chain.StmtA3`](./lean/Chain.md#Chain-StmtA3) | def | `Chain` | Prop |
| [`Chain.StmtA4`](./lean/Chain.md#Chain-StmtA4) | def | `Chain` | Prop |
| [`Stage3.StmtArgIdentity`](./lean_stage3/ArgCrude.md#Stage3-StmtArgIdentity) | def | `ArgCrude` | Prop |
| [`Stage3.stmtArgIdentity_holds`](./lean_stage3/ArgIdentity.md#Stage3-stmtArgIdentity_holds) | theorem | `ArgIdentity` | StmtArgIdentity phaseTheta argS |
| [`Chain.StmtB4`](./lean/Chain.md#Chain-StmtB4) | def | `Chain` | Prop |
| [`Chain.StmtB5`](./lean/Chain.md#Chain-StmtB5) | def | `Chain` | Prop |
| [`Stage3.StmtBacklundArg`](./lean_stage3/RvMCrude.md#Stage3-StmtBacklundArg) | def | `RvMCrude` | Prop |
| [`Stage3.StmtBacklundPhase`](./lean_stage3/RvMCrude.md#Stage3-StmtBacklundPhase) | def | `RvMCrude` | Prop |
| [`Chain.StmtC1`](./lean/Chain.md#Chain-StmtC1) | def | `Chain` | Prop |
| [`Chain.StmtC2`](./lean/Chain.md#Chain-StmtC2) | def | `Chain` | Prop |
| [`Chain.StmtC3`](./lean/Chain.md#Chain-StmtC3) | def | `Chain` | Prop |
| [`Chain.StmtC3lower`](./lean/Chain.md#Chain-StmtC3lower) | def | `Chain` | Prop |
| [`WeilDetect.StmtDetect`](./lean_stage3/WeilDetect.md#WeilDetect-StmtDetect) | def | `WeilDetect` | Prop |
| [`WeilPowerAssembly.StmtDetectGap`](./lean_stage3/WeilPowerAssembly.md#WeilPowerAssembly-StmtDetectGap) | def | `WeilPowerAssembly` | Prop |
| [`Stage3.StmtDigammaLog`](./lean_stage3/Stirling.md#Stage3-StmtDigammaLog) | def | `Stirling` | Prop |
| [`Stage3.stmtDigammaLog_holds`](./lean_stage3/Stirling.md#Stage3-stmtDigammaLog_holds) | theorem | `Stirling` | StmtDigammaLog 97 |
| [`Glue.stmtEF_poly`](./lean_stage3/Glue.md#Glue-stmtEF_poly) | theorem | `Glue` | ∃ c₁ c₂ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₂ ∧ Stage3.StmtExplicitFormulaPoly c₁ c₂ 16 |
| [`Stage3.stmtEF_split`](./lean_stage3/GlueFloor.md#Stage3-stmtEF_split) | theorem | `GlueFloor` | ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ StmtExplicitFormulaSplit c₁ c₃ c₄ 16 |
| [`Stage3.stmtEF_split_num`](./lean_stage3/RouteNum.md#Stage3-stmtEF_split_num) | theorem | `RouteNum` | StmtExplicitFormulaSplit Glue.c1n Glue.c3n Glue.c4n 16 |
| [`Stage3.StmtExplicitFormula`](./lean_stage3/Assembly.md#Stage3-StmtExplicitFormula) | def | `Assembly` | Prop |
| [`Stage3.StmtExplicitFormulaPoly`](./lean_stage3/Assembly.md#Stage3-StmtExplicitFormulaPoly) | def | `Assembly` | Prop |
| [`Stage3.StmtExplicitFormulaSplit`](./lean_stage3/GlueFloor.md#Stage3-StmtExplicitFormulaSplit) | def | `GlueFloor` | Prop |
| [`LandauCriterion.stmtLandauWindow`](./lean_stage3/LandauCriterion.md#LandauCriterion-stmtLandauWindow) | theorem | `LandauCriterion` | LandauWindow.StmtLandauWindow |
| [`LandauWindow.StmtLandauWindow`](./lean_stage3/LandauWindow.md#LandauWindow-StmtLandauWindow) | def | `LandauWindow` | Prop |
| [`Stage3.StmtLocalCount`](./lean_stage3/ArgCrude.md#Stage3-StmtLocalCount) | def | `ArgCrude` | Prop |
| [`Stage3.StmtPsiWeak`](./lean_stage3/PsiToPi.md#Stage3-StmtPsiWeak) | def | `PsiToPi` | Prop |
| [`Stage3.stmtPsiWeak_iff_theta_half`](./lean_stage3/ThetaPi.md#Stage3-stmtPsiWeak_iff_theta_half) | theorem | `ThetaPi` | StmtPsiWeak C k x₀ ↔ StmtPsiWeakTheta (1/2) C k x₀ |
| [`RHPull.stmtPsiWeak_of_RH`](./lean_stage3/LineBound.md#RHPull-stmtPsiWeak_of_RH) | theorem | `LineBound` | ∃ C &gt; 0, ∃ x₀ : ℝ, Stage3.StmtPsiWeak C 3 x₀ |
| [`Stage3.stmtPsiWeak_of_RH_half`](./lean_stage3/ThetaPsi.md#Stage3-stmtPsiWeak_of_RH_half) | theorem | `ThetaPsi` | ∃ C &gt; 0, ∃ x₀ : ℝ, Stage3.StmtPsiWeak C 3 x₀ |
| [`Stage3.StmtPsiWeakTheta`](./lean_stage3/ThetaPi.md#Stage3-StmtPsiWeakTheta) | def | `ThetaPi` | Prop |
| [`JointDialGate.StmtRelErrWindow`](./lean_stage3/JointDialGate.md#JointDialGate-StmtRelErrWindow) | def | `JointDialGate` | Prop |
| [`RelativeGate.StmtRelErrWindow`](./lean/RelativeGate.md#RelativeGate-StmtRelErrWindow) | def | `RelativeGate` | Prop |
| [`Schoenfeld.StmtSchoenfeld`](./lean/Schoenfeld.md#Schoenfeld-StmtSchoenfeld) | def | `Schoenfeld` | Prop |
| [`Stage3.StmtSchoenfeld`](./lean_stage3/Statement.md#Stage3-StmtSchoenfeld) | def | `Statement` | Prop |
| [`Stage3.StmtSchoenfeldWeak`](./lean_stage3/Statement.md#Stage3-StmtSchoenfeldWeak) | def | `Statement` | Prop |
| [`Stage3.stmtSchoenfeldWeak_iff_theta_half`](./lean_stage3/ThetaPi.md#Stage3-stmtSchoenfeldWeak_iff_theta_half) | theorem | `ThetaPi` | StmtSchoenfeldWeak C k x₀ pi li ↔ StmtSchoenfeldWeakTheta (1/2) C k x₀ pi li |
| [`Stage3.StmtSchoenfeldWeakTheta`](./lean_stage3/ThetaPi.md#Stage3-StmtSchoenfeldWeakTheta) | def | `ThetaPi` | Prop |
| [`Nonvanishing.StmtSchoenfeldWindow`](./lean/Nonvanishing.md#Nonvanishing-StmtSchoenfeldWindow) | def | `Nonvanishing` | Prop |
| [`Stage3.StmtSchoenfeldWindow`](./lean_stage3/Statement.md#Stage3-StmtSchoenfeldWindow) | def | `Statement` | Prop |
| [`Stage3.StmtSCrude`](./lean_stage3/ArgCrude.md#Stage3-StmtSCrude) | def | `ArgCrude` | Prop |
| [`Stage3.StmtSFromLocal`](./lean_stage3/ArgCrude.md#Stage3-StmtSFromLocal) | def | `ArgCrude` | Prop |
| [`WeilPowerCount.StmtShortCount`](./lean_stage3/WeilPowerCount.md#WeilPowerCount-StmtShortCount) | def | `WeilPowerCount` | Prop |
| [`Stage3.StmtWeakWindow`](./lean_stage3/Statement.md#Stage3-StmtWeakWindow) | def | `Statement` | Prop |
| [`Bridge.StmtWeilBridge`](./lean_bridge/WeilBridge.md#Bridge-StmtWeilBridge) | def | `WeilBridge` | Prop |
| [`WeilBridgeLeaf.StmtWeilBridge`](./lean_stage3/WeilBridgeLeaf.md#WeilBridgeLeaf-StmtWeilBridge) | def | `WeilBridgeLeaf` | Prop |
| [`Bridge.stmtWeilBridge_holds`](./lean_bridge/WeilBridge.md#Bridge-stmtWeilBridge_holds) | theorem | `WeilBridge` | StmtWeilBridge |
| [`WeilDetect.StmtWeilPositive`](./lean_stage3/WeilDetect.md#WeilDetect-StmtWeilPositive) | def | `WeilDetect` | Prop |
| [`Stage3.StmtZeroFreeRight`](./lean_stage3/Abscissa.md#Stage3-StmtZeroFreeRight) | def | `Abscissa` | Prop |
| [`GeneratorPeak.strictAnti_of_lt`](./lean/GeneratorPeak.md#GeneratorPeak-strictAnti_of_lt) | theorem | `GeneratorPeak` | StrictAnti (score R P α β) |
| [`GeneratorPeak.strictMono_of_lt`](./lean/GeneratorPeak.md#GeneratorPeak-strictMono_of_lt) | theorem | `GeneratorPeak` | StrictMono (score R P α β) |
| [`Transform.strip_is_fundamental_domain`](./lean/Transform.md#Transform-strip_is_fundamental_domain) | theorem | `Transform` | ‖(b : ℂ) ^ (-s)‖ = 1 ∧ (s + 1).re = 1 ∧ ‖(b : ℂ) ^ (-(s + 1))‖ = b ^ (-(1 : ℝ)) |
| [`ZetaGrowth.stripRegion`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-stripRegion) | def | `ZetaGrowth` | Set ℂ |
| [`LandauTrig.sum_block_ge`](./lean_stage3/LandauTrig.md#LandauTrig-sum_block_ge) | theorem | `LandauTrig` | -(∑ j ∈ s, ‖c j‖ * (2 / ‖z j - 1‖)) ≤ ∑ n ∈ Finset.Ico a (a + N), T n |
| [`WeilPowerBands.sum_by_bands`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-sum_by_bands) | theorem | `WeilPowerBands` | ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ ∑ k ∈ S.image (fun ρ : Kadiri.NontrivialZeros =&gt; idx (ρ : ℂ).im), M k * (15 * Real.log (centre k) + 73) |
| [`WeilTiles.sum_by_bands`](./lean_stage3/WeilTiles.md#WeilTiles-sum_by_bands) | theorem | `WeilTiles` | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ ∑ k ∈ S.image (fun ρ : Kadiri.NontrivialZeros =&gt; idx (ρ : ℂ).im), M k * (15 * Real.log (centre k) + 73) |
| [`WeilPowerTail.sum_hterm_sq_le`](./lean_stage3/WeilPowerTail.md#WeilPowerTail-sum_hterm_sq_le) | theorem | `WeilPowerTail` | ∑ j ∈ Finset.Ico (m + 1) n, hterm j ^ 2 ≤ 1 / (3 * Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3) |
| [`VonKoch.sum_Icc_vonMangoldt`](./lean_stage3/VonKochScaffold.md#VonKoch-sum_Icc_vonMangoldt) | theorem | `VonKochScaffold` | ∑ k ∈ Finset.Icc 1 n, ArithmeticFunction.vonMangoldt k = ψ n |
| [`LandauCrude.sum_inv_le`](./lean_stage3/LandauCrude.md#LandauCrude-sum_inv_le) | theorem | `LandauCrude` | ∑ n ∈ Finset.range (N + 1), ((n : ℝ))⁻¹ ≤ 1 + Real.log N |
| [`WeilPowerGauss.sum_inv_pow4_le`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-sum_inv_pow4_le) | theorem | `WeilPowerGauss` | ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4 ≤ 1 / ((m : ℝ) + 1) ^ 3 |
| [`WeilPowerTail.sum_inv_pow4_le_third`](./lean_stage3/WeilPowerTail.md#WeilPowerTail-sum_inv_pow4_le_third) | theorem | `WeilPowerTail` | ∀ n : ℕ, m + 1 ≤ n → ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4 ≤ 1 / 3 * (1 / ((m : ℝ) + 1) ^ 3 - 1 / (n : ℝ) ^ 3) |
| [`Stage3.sum_inv_pow_two_le`](./lean_stage3/ZeroSum.md#Stage3-sum_inv_pow_two_le) | theorem | `ZeroSum` | (∑ j ∈ range n, ((2 : ℝ) ^ j)⁻¹) ≤ 2 |
| [`WeilPowerGauss.sum_inv_sq_ge`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-sum_inv_sq_ge) | theorem | `WeilPowerGauss` | ((m : ℝ) + 2) / (2 * (m : ℝ) + 3) ^ 2 ≤ ∑ j ∈ Finset.Ico (m + 1) (2 * m + 3), 1 / ((j : ℝ) + 1) ^ 2 |
| [`WeilPowerSharp.sum_inv_sq_ge_sharp`](./lean_stage3/WeilPowerSharp.md#WeilPowerSharp-sum_inv_sq_ge_sharp) | theorem | `WeilPowerSharp` | 1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1) ≤ ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 |
| [`WeilPowerGauss.sum_inv_sq_le`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-sum_inv_sq_le) | theorem | `WeilPowerGauss` | ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 ≤ 1 / ((m : ℝ) + 1) |
| [`WeilPowerBands.sum_le_bandSeries`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-sum_le_bandSeries) | theorem | `WeilPowerBands` | ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ ∑' k : ℕ, M k * (15 * Real.log (centre k) + 73) |
| [`WeilTiles.sum_le_bandSeries`](./lean_stage3/WeilTiles.md#WeilTiles-sum_le_bandSeries) | theorem | `WeilTiles` | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ ∑' k : ℕ, M k * (15 * Real.log (centre k) + 73) |
| [`WeilOnLine.sum_low_le`](./lean_stage3/WeilOnLine.md#WeilOnLine-sum_low_le) | theorem | `WeilOnLine` | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ 4 * h ^ 2 * lowCount |
| [`WeilPowerOnLine.sum_low_le`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-sum_low_le) | theorem | `WeilPowerOnLine` | ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ 4 * h ^ 2 * lowCount |
| [`WeilPowerSigma.sum_lower_amgm`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-sum_lower_amgm) | theorem | `WeilPowerSigma` | 1 / ((m : ℝ) + 2) + 1 / (2 * ((m : ℝ) + 2) ^ 2) - 1 / ((n : ℝ) + 1) - 1 / (2 * ((n : ℝ) + 1) ^ 2) ≤ ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 |
| [`WeilOnLine.sum_lower_le`](./lean_stage3/WeilOnLine.md#WeilOnLine-sum_lower_le) | theorem | `WeilOnLine` | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ B h γ |
| [`WeilPowerOnLine.sum_lower_le`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-sum_lower_le) | theorem | `WeilPowerOnLine` | ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ B h γ m |
| [`ZetaGrowth.sum_norm_le`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-sum_norm_le) | theorem | `ZetaGrowth` | ‖∑ n ∈ Finset.range N, 1 / ((n:ℂ) + 1) ^ s‖ ≤ (N:ℝ) * (N:ℝ) ^ ((1:ℝ)/2) |
| [`WeilOnLine.sum_onLine_le`](./lean_stage3/WeilOnLine.md#WeilOnLine-sum_onLine_le) | theorem | `WeilOnLine` | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ onLineBound h γ |
| [`WeilPowerOnLine.sum_onLine_le`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-sum_onLine_le) | theorem | `WeilPowerOnLine` | ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ onLineBound h γ m |
| [`WeilOnLine.sum_onLine_subtype_le`](./lean_stage3/WeilOnLine.md#WeilOnLine-sum_onLine_subtype_le) | theorem | `WeilOnLine` | ∑ ρ ∈ s, weightedTerm h γ ρ.1 ≤ onLineBound h γ |
| [`WeilPowerOnLine.sum_onLine_subtype_le`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-sum_onLine_subtype_le) | theorem | `WeilPowerOnLine` | ∑ ρ ∈ s, weightedTermW h γ m ρ.1 ≤ onLineBound h γ m |
| [`Elephant.sum_primeIndicator`](./lean/Elephant.md#Elephant-sum_primeIndicator) | theorem | `Elephant` | ∑ m ∈ Finset.range (x + 1), primeIndicator m = (Nat.primeCounting x : ℂ) |
| [`Stage3.sum_range_add_one`](./lean_stage3/ZeroSum.md#Stage3-sum_range_add_one) | theorem | `ZeroSum` | (∑ j ∈ range n, ((j : ℝ) + 1)) = n * (n + 1) / 2 |
| [`Elephant.sum_shift`](./lean/Elephant.md#Elephant-sum_shift) | theorem | `Elephant` | ∑ m ∈ Finset.range (x + 1), (if b ∣ m then a (m / b) else 0) = ∑ k ∈ Finset.range (x / b + 1), a k |
| [`LandauTrig.sum_sq_block_ge`](./lean_stage3/LandauTrig.md#LandauTrig-sum_sq_block_ge) | theorem | `LandauTrig` | (N : ℝ) * ∑ j ∈ s, ‖c j‖ ^ 2 - ∑ j ∈ s, ∑ l ∈ s, (if j = l then 0 else ‖c j‖ * ‖c l‖ * (2 / ‖z j * conj (z l) - 1‖)) ≤ ∑ n ∈ Finset.Ico a (a + N), T n ^ 2 |
| [`WeilPowerSharp.sum_telescope`](./lean_stage3/WeilPowerSharp.md#WeilPowerSharp-sum_telescope) | theorem | `WeilPowerSharp` | ∀ n : ℕ, m + 1 ≤ n → ∑ j ∈ Finset.Ico (m + 1) n, 1 / (((j : ℝ) + 1) * ((j : ℝ) + 2)) = 1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1) |
| [`WeilPowerSigma.sum_telescope_amgm`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-sum_telescope_amgm) | theorem | `WeilPowerSigma` | ∀ n : ℕ, m + 1 ≤ n → ∑ j ∈ Finset.Ico (m + 1) n, ((1 / ((j : ℝ) + 1) - 1 / ((j : ℝ) + 2)) + (1 / (2 * ((j : ℝ) + 1) ^ 2) - 1 / (2 * ((j : ℝ) + 2) ^ 2))) = (1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1)) + (1 … |
| [`WeilPowerSigma.sum_telescope_half`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-sum_telescope_half) | theorem | `WeilPowerSigma` | ∀ n : ℕ, m + 1 ≤ n → ∑ j ∈ Finset.Ico (m + 1) n, (1 / ((j : ℝ) + 1 / 2) - 1 / ((j : ℝ) + 3 / 2)) = 1 / ((m : ℝ) + 3 / 2) - 1 / ((n : ℝ) + 1 / 2) |
| [`WeilPowerSigma.sum_upper_half`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-sum_upper_half) | theorem | `WeilPowerSigma` | ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 ≤ 2 / (2 * (m : ℝ) + 3) |
| [`WeilOnLine.sum_upper_le`](./lean_stage3/WeilOnLine.md#WeilOnLine-sum_upper_le) | theorem | `WeilOnLine` | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ B h γ |
| [`WeilPowerOnLine.sum_upper_le`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-sum_upper_le) | theorem | `WeilPowerOnLine` | ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ B h γ m |
| [`WeilPowerShell.sum_uSh_eq`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-sum_uSh_eq) | theorem | `WeilPowerShell` | ∑ h ∈ Finset.Ico a b, coef e' D e * Complex.exp (zOf e' D e * ((WeilPowerGeomGen.uLam lam h : ℝ) : ℂ)) = ∑ h ∈ Finset.Ico a b, coef e' D e * Complex.exp (zOf e' D e * ((uSh lam h : ℝ) : ℂ)) |
| [`WeilPowerPhase.summable_hterm`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-summable_hterm) | theorem | `WeilPowerPhase` | Summable hterm |
| [`WeilOnLine.summable_onLine`](./lean_stage3/WeilOnLine.md#WeilOnLine-summable_onLine) | theorem | `WeilOnLine` | Summable (fun ρ : OnLine =&gt; weightedTerm h γ ρ.1) |
| [`WeilPowerOnLine.summable_onLine`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-summable_onLine) | theorem | `WeilPowerOnLine` | Summable (fun ρ : OnLine =&gt; weightedTermW h γ m ρ.1) |
| [`WeilPowerPhase.summable_shift`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-summable_shift) | theorem | `WeilPowerPhase` | Summable (fun k : ℕ =&gt; hterm (k + (m + 1))) |
| [`WeilSeries.summable_shift2`](./lean_stage3/WeilSeries.md#WeilSeries-summable_shift2) | theorem | `WeilSeries` | Summable (fun k : ℕ =&gt; 1 / ((k : ℝ) + 1) ^ 2) |
| [`WeilSeries.summable_shift3`](./lean_stage3/WeilSeries.md#WeilSeries-summable_shift3) | theorem | `WeilSeries` | Summable (fun k : ℕ =&gt; 1 / ((k : ℝ) + 1) ^ 3) |
| [`Elephant.summatory_sym`](./lean/Elephant.md#Elephant-summatory_sym) | theorem | `Elephant` | ∑ m ∈ Finset.range (x + 1), (a m - (if b ∣ m then a (m / b) else 0)) = (∑ m ∈ Finset.range (x + 1), a m) - ∑ k ∈ Finset.range (x / b + 1), a k |
| [`Chain.Sym`](./lean/Chain.md#Chain-Sym) | def | `Chain` | ℂ |
| [`Elephant.Sym`](./lean/Elephant.md#Elephant-Sym) | def | `Elephant` | ℂ |
| [`EulerFactorChain.sym`](./lean/EulerFactorChain.md#EulerFactorChain-sym) | def | `EulerFactorChain` | ℂ |
| [`Chain.sym_eq_zero_iff`](./lean/Chain.md#Chain-sym_eq_zero_iff) | theorem | `Chain` | Sym b s = 0 ↔ ∃ k : ℤ, s = (k : ℂ) * (2 * Real.pi * I / Real.log b) |
| [`Elephant.sym_eq_zero_iff`](./lean/Elephant.md#Elephant-sym_eq_zero_iff) | theorem | `Elephant` | Sym b s = 0 ↔ ∃ k : ℤ, s = (k : ℂ) * (2 * Real.pi * Complex.I / Real.log b) |
| [`TransferOp.sym_hasEigenvalue`](./lean/TransferOp.md#TransferOp-sym_hasEigenvalue) | theorem | `TransferOp` | bdiffL.HasEigenvalue (Sym b ρ) |
| [`Elephant.sym_mul_logDeriv_zeta`](./lean/Elephant.md#Elephant-sym_mul_logDeriv_zeta) | theorem | `Elephant` | Sym (b : ℝ) s * (-deriv riemannZeta s / riemannZeta s) = LSeries (fun n =&gt; (vonMangoldt n : ℂ)) s - LSeries (fun m =&gt; if b ∣ m then (vonMangoldt (m / b) : ℂ) else 0) s |
| [`Elephant.sym_mul_lseries`](./lean/Elephant.md#Elephant-sym_mul_lseries) | theorem | `Elephant` | Sym ((b : ℕ) : ℝ) s * LSeries a s = LSeries a s - LSeries (fun m =&gt; if b ∣ m then a (m / b) else 0) s |
| [`EulerFactorChain.sym_natCast`](./lean/EulerFactorChain.md#EulerFactorChain-sym_natCast) | theorem | `EulerFactorChain` | sym (n : ℝ) s = 1 - (n : ℂ) ^ (-s) |
| [`Elephant.sym_ne_zero_on_critical_line`](./lean/Elephant.md#Elephant-sym_ne_zero_on_critical_line) | theorem | `Elephant` | Sym b ((1 : ℂ)/2 + γ * Complex.I) ≠ 0 |
| [`NyquistPeak.sym_on_imaginary_axis`](./lean/NyquistPeak.md#NyquistPeak-sym_on_imaginary_axis) | theorem | `NyquistPeak` | Chain.Sym b (γ * Complex.I) = 1 - Complex.exp (((-(γ * Real.log b) : ℝ) : ℂ) * Complex.I) |
| [`Chain.sym_periodic`](./lean/Chain.md#Chain-sym_periodic) | theorem | `Chain` | Sym b (s + 2 * Real.pi * I / Real.log b) = Sym b s |
| [`Elephant.sym_pow_expand`](./lean/Elephant.md#Elephant-sym_pow_expand) | theorem | `Elephant` | (Sym b ρ) ^ d = ∑ k ∈ Finset.range (d + 1), (-1 : ℂ) ^ k * (d.choose k : ℂ) * ((b : ℂ) ^ (-ρ)) ^ k |
| [`Elephant.sym_tprod_eq_zeta`](./lean/Elephant.md#Elephant-sym_tprod_eq_zeta) | theorem | `Elephant` | ∏' p : Nat.Primes, (Sym ((p : ℕ) : ℝ) s)⁻¹ = riemannZeta s |
| [`CellModes.sym_two`](./lean_stage3/CellModes.md#CellModes-sym_two) | theorem | `CellModes` | Chain.Sym 2 ρ = 1 - ((2:ℂ) ^ ρ)⁻¹ |
| [`Transform.sym_zero_on_outer_circle`](./lean/Transform.md#Transform-sym_zero_on_outer_circle) | theorem | `Transform` | ‖(b : ℂ) ^ (-s)‖ = 1 |
| [`Transform.sym_zero_partner_on_inner_circle`](./lean/Transform.md#Transform-sym_zero_partner_on_inner_circle) | theorem | `Transform` | ‖(b : ℂ) ^ (-(1 - s))‖ = b ^ (-(1 : ℝ)) |
| [`EulerFactorChain.symbol_at_one`](./lean/EulerFactorChain.md#EulerFactorChain-symbol_at_one) | theorem | `EulerFactorChain` | (b : ℂ) ^ (r * 1) - (b : ℂ) ^ ((r - 1) * 1) = sym b 1 * (b : ℂ) ^ (r * 1) |
| [`EulerFactorChain.symbol_of_backward_difference`](./lean/EulerFactorChain.md#EulerFactorChain-symbol_of_backward_difference) | theorem | `EulerFactorChain` | (b : ℂ) ^ (r * ρ) - (b : ℂ) ^ ((r - 1) * ρ) = sym b ρ * (b : ℂ) ^ (r * ρ) |
| [`Elephant.symbol_of_difference`](./lean/Elephant.md#Elephant-symbol_of_difference) | theorem | `Elephant` | (b : ℂ) ^ (r * ρ) - (b : ℂ) ^ ((r - 1) * ρ) = Sym b ρ * (b : ℂ) ^ (r * ρ) |
| [`JointSymbol.symPhi_principal_part`](./lean_stage3/JointSymbol.md#JointSymbol-symPhi_principal_part) | theorem | `JointSymbol` | ∃ h : ℂ → ℂ, AnalyticAt ℂ h ρ ∧ ∀ᶠ s in 𝓝[≠] ρ, (1 - (2 : ℂ) ^ (-s)) ^ d * LandauMellinG.Phi s = h s + (1 - (2 : ℂ) ^ (-ρ)) ^ d * ((analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ))) / (s - ρ) |
| [`Expansion.t`](./lean/Expansion.md#Expansion-t) | def | `Expansion` | ℝ |
| [`WeilPowerGauss.T`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-T) | def | `WeilPowerGauss` | ℂ |
| [`WeilPowerPhase.T_eq_exp`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-T_eq_exp) | theorem | `WeilPowerPhase` | T m w n = Complex.exp (∑ j ∈ Finset.Ico (m + 1) n, Complex.log (g w j)) |
| [`WeilPowerPhase.T_eq_mul`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-T_eq_mul) | theorem | `WeilPowerPhase` | T m w n = Complex.exp (w ^ 2 * ((sigmaN m n : ℝ) : ℂ)) * Complex.exp (delta m w n) |
| [`Expansion.t_halves`](./lean/Expansion.md#Expansion-t_halves) | theorem | `Expansion` | t d (j + 1) x ≤ t d j x / 2 |
| [`Expansion.t_nonneg`](./lean/Expansion.md#Expansion-t_nonneg) | theorem | `Expansion` | 0 ≤ t d j x |
| [`WeilPowerGauss.T_ofReal`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-T_ofReal) | theorem | `WeilPowerGauss` | T m (s : ℂ) n = ((Tr m s n : ℝ) : ℂ) |
| [`Expansion.t_zero`](./lean/Expansion.md#Expansion-t_zero) | theorem | `Expansion` | t d 0 x = Real.log 2 ^ d * x⁻¹ |
| [`Construction.tableFrom`](./lean/Construction.md#Construction-tableFrom) | def | `Construction` | ℤ → ℕ → ℤ |
| [`Construction.tableFrom_add`](./lean/Construction.md#Construction-tableFrom_add) | theorem | `Construction` | tableFrom (fun x =&gt; N x + M x) r d = tableFrom N r d + tableFrom M r d |
| [`PairIdentity.tableFrom_add_window`](./lean/PairIdentity.md#PairIdentity-tableFrom_add_window) | theorem | `PairIdentity` | tableFrom P r d + tableFrom C r d = tableFrom T r d |
| [`SeedPerturbation.tableFrom_at_boundary`](./lean/SeedPerturbation.md#SeedPerturbation-tableFrom_at_boundary) | theorem | `SeedPerturbation` | tableFrom e r d = (-1) ^ d * e R |
| [`Chain.tableFrom_eq_bdiff_iter`](./lean/Chain.md#Chain-tableFrom_eq_bdiff_iter) | theorem | `Chain` | ((Construction.tableFrom N r d : ℤ) : ℂ) = (bdiff^[d]) g (r : ℂ) |
| [`Zeros.tableFrom_eq_fwdDiff`](./lean/ZerosStencil.md#Zeros-tableFrom_eq_fwdDiff) | theorem | `ZerosStencil` | Construction.tableFrom N r d = (-1 : ℤ) ^ d * (fwdDiff (-1 : ℤ))^[d] N r |
| [`Superposition.tableFrom_eq_modeSum_reweighted`](./lean/Superposition.md#Superposition-tableFrom_eq_modeSum_reweighted) | theorem | `Superposition` | ((Construction.tableFrom N r d : ℤ) : ℂ) = modeSum b ρ (fun i =&gt; c i * (Sym b (ρ i)) ^ d) s (r : ℂ) |
| [`Zeros.tableFrom_eq_stencil`](./lean/ZerosStencil.md#Zeros-tableFrom_eq_stencil) | theorem | `ZerosStencil` | Construction.tableFrom N r d = stencil d (fun k =&gt; N (r - k)) |
| [`Zeros.tableFrom_eq_zero_iff_wings`](./lean/ZerosStencil.md#Zeros-tableFrom_eq_zero_iff_wings) | theorem | `ZerosStencil` | Construction.tableFrom N r d = 0 ↔ wingPlus d (fun k =&gt; N (r - k)) = wingMinus d (fun k =&gt; N (r - k)) |
| [`SeedPerturbation.tableFrom_eq_zero_of_vanishing_above`](./lean/SeedPerturbation.md#SeedPerturbation-tableFrom_eq_zero_of_vanishing_above) | theorem | `SeedPerturbation` | tableFrom e r d = 0 |
| [`Zeros.tableFrom_isTable`](./lean/Zeros.md#Zeros-tableFrom_isTable) | theorem | `Zeros` | IsTable (Construction.tableFrom N) |
| [`Construction.tableFrom_isTableOf`](./lean/Construction.md#Construction-tableFrom_isTableOf) | theorem | `Construction` | IsTableOf N (tableFrom N) |
| [`Chain.tableFrom_mode`](./lean/Chain.md#Chain-tableFrom_mode) | theorem | `Chain` | ((Construction.tableFrom N r d : ℤ) : ℂ) = (Sym b ρ) ^ d * mode b ρ (r : ℂ) |
| [`Nonvanishing.tableFrom_ne_zero_of`](./lean/Nonvanishing.md#Nonvanishing-tableFrom_ne_zero_of) | theorem | `Nonvanishing` | Construction.tableFrom N r d ≠ 0 |
| [`MainTerm.tableFrom_ne_zero_of_deriv`](./lean/MainTerm.md#MainTerm-tableFrom_ne_zero_of_deriv) | theorem | `MainTerm` | Construction.tableFrom N r d ≠ 0 |
| [`Expansion.tableFrom_ne_zero_of_li`](./lean/Expansion.md#Expansion-tableFrom_ne_zero_of_li) | theorem | `Expansion` | Construction.tableFrom N r d ≠ 0 |
| [`RelativeLi.tableFrom_ne_zero_of_powerSaving`](./lean/RelativeLi.md#RelativeLi-tableFrom_ne_zero_of_powerSaving) | theorem | `RelativeLi` | Construction.tableFrom N r d ≠ 0 |
| [`RelativeGate.tableFrom_ne_zero_of_relErr`](./lean/RelativeGate.md#RelativeGate-tableFrom_ne_zero_of_relErr) | theorem | `RelativeGate` | Construction.tableFrom N r d ≠ 0 |
| [`RelativeLi.tableFrom_ne_zero_of_relErr_li`](./lean/RelativeLi.md#RelativeLi-tableFrom_ne_zero_of_relErr_li) | theorem | `RelativeLi` | Construction.tableFrom N r d ≠ 0 |
| [`RelativeLi.tableFrom_ne_zero_of_relErr_li'`](./lean/RelativeLi.md#RelativeLi-tableFrom_ne_zero_of_relErr_li-) | theorem | `RelativeLi` | Construction.tableFrom N r d ≠ 0 |
| [`Interpolant.tableFrom_ne_zero_of_relErr_liRow`](./lean/Interpolant.md#Interpolant-tableFrom_ne_zero_of_relErr_liRow) | theorem | `Interpolant` | Construction.tableFrom N r d ≠ 0 |
| [`Schoenfeld.tableFrom_ne_zero_of_schoenfeld`](./lean/Schoenfeld.md#Schoenfeld-tableFrom_ne_zero_of_schoenfeld) | theorem | `Schoenfeld` | Construction.tableFrom N r d ≠ 0 |
| [`Chain.tableFrom_norm_on_critical_line`](./lean/Chain.md#Chain-tableFrom_norm_on_critical_line) | theorem | `Chain` | ‖((Construction.tableFrom N r d : ℤ) : ℂ)‖ = ‖Sym b ((1 : ℂ)/2 + γ * I)‖ ^ d * ‖mode b ((1 : ℂ)/2 + γ * I) (r : ℂ)‖ |
| [`PairIdentity.tableFrom_of_geometric`](./lean/PairIdentity.md#PairIdentity-tableFrom_of_geometric) | theorem | `PairIdentity` | tableFrom G r d = (b - 1) ^ d * G (r - d) |
| [`Construction.tableFrom_smul`](./lean/Construction.md#Construction-tableFrom_smul) | theorem | `Construction` | tableFrom (fun x =&gt; c * N x) r d = c * tableFrom N r d |
| [`SeedPerturbation.tableFrom_sub`](./lean/SeedPerturbation.md#SeedPerturbation-tableFrom_sub) | theorem | `SeedPerturbation` | tableFrom (fun x =&gt; N x - e x) r d = tableFrom N r d - tableFrom e r d |
| [`SeedPerturbation.tableFrom_zero`](./lean/SeedPerturbation.md#SeedPerturbation-tableFrom_zero) | theorem | `SeedPerturbation` | tableFrom (fun _ : ℤ =&gt; (0 : ℤ)) r d = 0 |
| [`ZetaGrowth.tail_differentiableAt`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-tail_differentiableAt) | theorem | `ZetaGrowth` | DifferentiableAt ℂ (fun w : ℂ ↦ ∫ x in Ioi (N:ℝ), (emA x : ℂ) * (x:ℂ) ^ (-(w+2))) z |
| [`ZetaGrowth.tail_ibp`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-tail_ibp) | theorem | `ZetaGrowth` | ∫ x in Ioi (N:ℝ), ((⌊x⌋ : ℂ) + 1/2 - (x:ℂ)) * (x:ℂ) ^ (-(s+1)) = (s+1) * ∫ x in Ioi (N:ℝ), (emA x : ℂ) * (x:ℂ) ^ (-(s+2)) |
| [`ZetaGrowth.tail_norm_le`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-tail_norm_le) | theorem | `ZetaGrowth` | ‖∫ x in Ioi (N:ℝ), (emA x : ℂ) * (x:ℂ) ^ (-(s+2))‖ ≤ (1/4) * (N:ℝ) ^ (-s.re - 1) |
| [`WeilPowerSelect.target_bound`](./lean_stage3/WeilPowerSelect.md#WeilPowerSelect-target_bound) | theorem | `WeilPowerSelect` | ∃ k : ℕ, (k : ℝ) ≤ h / (4 * K' * Real.pi ^ 2 * lam) ∧ ∀ ε', 0 ≤ ε' → ε' ≤ E (k + 1) → ε' ^ 2 ≤ (E k) ^ 2 + δSel K' lam h |
| [`WeilPowerSelect.target_ge_box`](./lean_stage3/WeilPowerSelect.md#WeilPowerSelect-target_ge_box) | theorem | `WeilPowerSelect` | E 0 ≤ E k |
| [`WeilPowerSelect.target_height_le`](./lean_stage3/WeilPowerSelect.md#WeilPowerSelect-target_height_le) | theorem | `WeilPowerSelect` | T + (k : ℝ) / 2 ≤ T + h / (8 * K' * Real.pi ^ 2 * lam) |
| [`WeilPowerAssembly.target_lower`](./lean_stage3/WeilPowerAssembly.md#WeilPowerAssembly-target_lower) | theorem | `WeilPowerAssembly` | WeilPowerBands.termW h γ m (ρ : ℂ) ≤ -((h / 2) ^ 2 * ((cS m / D m) ^ 2 * Real.exp (2 * ((wm h γ (ρ : ℂ)) ^ 2).re * sigma m) * (((wm h γ (ρ : ℂ)) ^ 2).re * Real.cos (2 * ((wm h γ (ρ : ℂ)) ^ 2).im * sig… |
| [`Transform.tau`](./lean/Transform.md#Transform-tau) | def | `Transform` | ℝ |
| [`Transform.tau_pos`](./lean/Transform.md#Transform-tau_pos) | theorem | `Transform` | 0 &lt; tau b |
| [`Transform.tau_pow`](./lean/Transform.md#Transform-tau_pow) | theorem | `Transform` | tau (b ^ n) = tau b / n |
| [`Transform.tau_ratio_of_meet`](./lean/Transform.md#Transform-tau_ratio_of_meet) | theorem | `Transform` | tau b / tau c = n / m |
| [`Transform.tauI_mem_periodLattice`](./lean/Transform.md#Transform-tauI_mem_periodLattice) | theorem | `Transform` | ((tau b : ℂ) * I) ∈ periodLattice b |
| [`LandauPoleSub.taylor_coeff_sub_poles`](./lean_stage3/LandauPoleSub.md#LandauPoleSub-taylor_coeff_sub_poles) | theorem | `LandauPoleSub` | ∃ C : ℝ, ∀ k : ℕ, ‖iteratedDeriv k f c - ∑ q ∈ P, A q * ((-1) ^ k * (k.factorial : ℂ) * (c - q) ^ (-1 - (k : ℤ)))‖ ≤ k.factorial * C / R ^ k |
| [`Isogeny.telescope`](./lean/Isogeny.md#Isogeny-telescope) | theorem | `Isogeny` | ∑ j ∈ range k, (g (m + j + 1) - g (m + j)) = g (m + k) - g m |
| [`LandauKernel.tendsto_log_pow_mul`](./lean_stage3/LandauKernel.md#LandauKernel-tendsto_log_pow_mul) | theorem | `LandauKernel` | Tendsto (fun y : ℝ =&gt; Real.log y ^ n * y ^ (-a)) atTop (𝓝 0) |
| [`LandauMellinG.tendsto_logPrim`](./lean_stage3/LandauMellinG.md#LandauMellinG-tendsto_logPrim) | theorem | `LandauMellinG` | Tendsto (logPrim s) atTop (𝓝 0) |
| [`WeilPowerGauss.tendsto_S`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-tendsto_S) | theorem | `WeilPowerGauss` | Tendsto (fun n : ℕ =&gt; ((cS m / D m : ℝ) : ℂ) * w * T m w n) atTop (𝓝 (S m w)) |
| [`WeilOnLine.term_conj`](./lean_stage3/WeilOnLine.md#WeilOnLine-term_conj) | theorem | `WeilOnLine` | (laplace (phiC h γ) (-(starRingEnd ℂ) ρ) * laplace (phiC h γ) (-(1 - (starRingEnd ℂ) ρ))).re = (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re |
| [`WeilPowerOnLine.term_conj`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-term_conj) | theorem | `WeilPowerOnLine` | termW h γ m ((starRingEnd ℂ) ρ) = termW h γ m ρ |
| [`WeilOffLine.term_eq_neg_sq`](./lean_stage3/WeilOffLine.md#WeilOffLine-term_eq_neg_sq) | theorem | `WeilOffLine` | laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ)) = -(ghat h γ (ρ - 1 / 2)) ^ 2 |
| [`WeilPowerBackground.term_eq_neg_sq`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-term_eq_neg_sq) | theorem | `WeilPowerBackground` | laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ)) = -(what h γ m (ρ - 1 / 2)) ^ 2 |
| [`WeilPowerBridge.term_eq_sidebands`](./lean_stage3/WeilPowerBridge.md#WeilPowerBridge-term_eq_sidebands) | theorem | `WeilPowerBridge` | WeilPowerBands.termW h γ m ρ = -((h / 2) ^ 2 * (((S m (wm h γ ρ)) ^ 2).re + 2 * (S m (wp h γ ρ) * S m (wm h γ ρ)).re + ((S m (wp h γ ρ)) ^ 2).re)) |
| [`WeilPowerBridge.term_le_at_zero`](./lean_stage3/WeilPowerBridge.md#WeilPowerBridge-term_le_at_zero) | theorem | `WeilPowerBridge` | WeilPowerBands.termW h γ m (ρ : ℂ) ≤ -((h / 2) ^ 2 * ((cS m / D m) ^ 2 * Real.exp (2 * ((wm h γ (ρ : ℂ)) ^ 2).re * sigma m) * (((wm h γ (ρ : ℂ)) ^ 2).re * Real.cos (2 * ((wm h γ (ρ : ℂ)) ^ 2).im * sig… |
| [`WeilPowerBands.term_le_M`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-term_le_M) | theorem | `WeilPowerBands` | termW h γ m ρ ≤ M h γ m (idx (ρ : ℂ).im) |
| [`WeilSeries.term_le_M`](./lean_stage3/WeilSeries.md#WeilSeries-term_le_M) | theorem | `WeilSeries` | (laplace (phiC h γ) (-(ρ : ℂ)) * laplace (phiC h γ) (-(1 - (ρ : ℂ)))).re ≤ M h γ (idx (ρ : ℂ).im) |
| [`WeilPowerBridge.term_le_sidebands`](./lean_stage3/WeilPowerBridge.md#WeilPowerBridge-term_le_sidebands) | theorem | `WeilPowerBridge` | WeilPowerBands.termW h γ m ρ ≤ -((h / 2) ^ 2 * (((S m (wm h γ ρ)) ^ 2).re - 2 * ‖S m (wp h γ ρ)‖ * ‖S m (wm h γ ρ)‖ - ‖S m (wp h γ ρ)‖ ^ 2)) |
| [`WeilPowerNear.term_nonneg`](./lean_stage3/WeilPowerNear.md#WeilPowerNear-term_nonneg) | theorem | `WeilPowerNear` | 0 ≤ (WeilPowerShell.coef e' D e * Complex.exp (WeilPowerShell.zOf e' D e * ((WeilPowerGeomGen.uLam lam h : ℝ) : ℂ))).re |
| [`WeilOffLine.term_re_eq`](./lean_stage3/WeilOffLine.md#WeilOffLine-term_re_eq) | theorem | `WeilOffLine` | (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re = (ghat h γ (ρ - 1 / 2)).im ^ 2 - (ghat h γ (ρ - 1 / 2)).re ^ 2 |
| [`WeilPowerBackground.term_re_eq`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-term_re_eq) | theorem | `WeilPowerBackground` | (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re = (what h γ m (ρ - 1 / 2)).im ^ 2 - (what h γ m (ρ - 1 / 2)).re ^ 2 |
| [`WeilPowerBands.termW`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-termW) | def | `WeilPowerBands` | ℝ |
| [`WeilPowerBands.termW_nonneg`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-termW_nonneg) | theorem | `WeilPowerBands` | 0 ≤ termW h γ m ρ |
| [`Stage3.theta_err_of_psi`](./lean_stage3/PsiToPi.md#Stage3-theta_err_of_psi) | theorem | `PsiToPi` | \|θ x - x\| ≤ E + 2 * Real.sqrt x * Real.log x |
| [`Stage3.theta_err_of_psi_theta`](./lean_stage3/ThetaPi.md#Stage3-theta_err_of_psi_theta) | theorem | `ThetaPi` | \|ϑ x - x\| ≤ E + 2 * x ^ θ * Real.log x |
| [`Stage3.theta_instantiation_arithmetic`](./lean_stage3/ThetaPsi.md#Stage3-theta_instantiation_arithmetic) | theorem | `ThetaPsi` | c * (X ^ (1 - θ))⁻¹ * X * Real.log X ≤ c * X ^ θ * (Real.log X) ^ 3 ∧ c * X * Real.log X / ((X ^ (1 - θ))⁻¹ * X) ≤ c * X ^ θ * (Real.log X) ^ 3 ∧ c * ((X ^ (1 - θ))⁻¹ * X) ≤ c * X ^ θ * (Real.log X) ^… |
| [`JointDialGate.thetaWindow_of_global`](./lean_stage3/JointDialGate.md#JointDialGate-thetaWindow_of_global) | theorem | `JointDialGate` | ∀ j ∈ range (n + 1), \|f (r - j) - L (r - j)\| ≤ C * ((2 : ℝ) ^ ((r : ℝ) - j)) ^ θ * Real.log ((2 : ℝ) ^ ((r : ℝ) - j)) ^ k |
| [`TwinLattice.three_five_exceptional`](./lean/TwinLattice.md#TwinLattice-three_five_exceptional) | theorem | `TwinLattice` | (3 : ℕ).Prime ∧ (5 : ℕ).Prime ∧ (3 + 1) % 6 ≠ 0 |
| [`Bridge.tiltF`](./lean_bridge/WeilBridge.md#Bridge-tiltF) | def | `WeilBridge` | ℝ → ℂ |
| [`WeilBridgeLeaf.tiltF`](./lean_stage3/WeilBridgeLeaf.md#WeilBridgeLeaf-tiltF) | def | `WeilBridgeLeaf` | ℝ → ℂ |
| [`Bridge.tiltF_im`](./lean_bridge/WeilBridge.md#Bridge-tiltF_im) | theorem | `WeilBridge` | (tiltF G u).im = 0 |
| [`Transform.Torus`](./lean/Transform.md#Transform-Torus) | abbrev | `Transform` | Type |
| [`Transform.torus_period`](./lean/Transform.md#Transform-torus_period) | theorem | `Transform` | ((s + (tau b : ℂ) * I : ℂ) : Torus b) = (s : Torus b) |
| [`Transform.torus_shift`](./lean/Transform.md#Transform-torus_shift) | theorem | `Transform` | ((s + 1 : ℂ) : Torus b) = (s : Torus b) |
| [`PairIdentity.total_const_on_diagonal`](./lean/PairIdentity.md#PairIdentity-total_const_on_diagonal) | theorem | `PairIdentity` | (∀ d₁ d₂ : ℕ, (b - 1) ^ (d₁ + 1) * b ^ e = (b - 1) ^ (d₂ + 1) * b ^ e) ↔ b = 2 |
| [`PairIdentity.total_eq_pow_iff_base_two`](./lean/PairIdentity.md#PairIdentity-total_eq_pow_iff_base_two) | theorem | `PairIdentity` | (b - 1) ^ (d + 1) * b ^ e = b ^ e ↔ b = 2 |
| [`WeilPowerGauss.Tr`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-Tr) | def | `WeilPowerGauss` | ℝ |
| [`WeilPowerGauss.Tr_ge`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-Tr_ge) | theorem | `WeilPowerGauss` | Real.exp (s ^ 2 * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2) - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ≤ Tr m s n |
| [`WeilPowerSharp.Tr_ge_sharp`](./lean_stage3/WeilPowerSharp.md#WeilPowerSharp-Tr_ge_sharp) | theorem | `WeilPowerSharp` | Real.exp (s ^ 2 / Real.pi ^ 2 * (1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1)) - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ≤ Tr m s n |
| [`JointLadder.triadic_winds_densely_on_dyadic`](./lean/JointLadder.md#JointLadder-triadic_winds_densely_on_dyadic) | theorem | `JointLadder` | DenseRange (fun k : ℤ =&gt; k • ((2 * Real.pi / Real.log 3 : ℝ) : AddCircle (2 * Real.pi / Real.log 2))) |
| [`WeilOnLine.tsum_onLine_le`](./lean_stage3/WeilOnLine.md#WeilOnLine-tsum_onLine_le) | theorem | `WeilOnLine` | ∑' ρ : OnLine, weightedTerm h γ ρ.1 ≤ onLineBound h γ |
| [`WeilPowerOnLine.tsum_onLine_le`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-tsum_onLine_le) | theorem | `WeilPowerOnLine` | ∑' ρ : OnLine, weightedTermW h γ m ρ.1 ≤ onLineBound h γ m |
| [`WeilSeries.tsum_shift2`](./lean_stage3/WeilSeries.md#WeilSeries-tsum_shift2) | theorem | `WeilSeries` | ∑' k : ℕ, 1 / ((k : ℝ) + 1) ^ 2 = Real.pi ^ 2 / 6 |
| [`WeilPowerBands.tsum_upper_le`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-tsum_upper_le) | theorem | `WeilPowerBands` | ∑' ρ : Upper, weightedTermW h γ m ρ.1 ≤ ∑' k : ℕ, M k * (15 * Real.log (centre k) + 73) |
| [`WeilTiles.tsum_upper_le`](./lean_stage3/WeilTiles.md#WeilTiles-tsum_upper_le) | theorem | `WeilTiles` | ∑' ρ : Upper, weightedTerm h γ ρ.1 ≤ ∑' k : ℕ, M k * (15 * Real.log (centre k) + 73) |
| [`WeilPowerBands.tsum_upper_le_explicit`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-tsum_upper_le_explicit) | theorem | `WeilPowerBands` | ∑' ρ : Upper, weightedTermW h γ m ρ.1 ≤ A h γ m * (Real.pi ^ 2 / 6) |
| [`WeilSeries.tsum_upper_le_explicit`](./lean_stage3/WeilSeries.md#WeilSeries-tsum_upper_le_explicit) | theorem | `WeilSeries` | ∑' ρ : Upper, weightedTerm h γ ρ.1 ≤ A h γ * (Real.pi ^ 2 / 6) |
| [`WeilPowerBands.tsum_upper_le_explicit'`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-tsum_upper_le_explicit-) | theorem | `WeilPowerBands` | ∑' ρ : Upper, weightedTermW h γ m ρ.1 ≤ 88 * (γ + r h m + 2) ^ 4 * (4 * h ^ 2 + cFarM m / h ^ 2) * (Real.pi ^ 2 / 6) |
| [`WeilSeries.tsum_upper_le_explicit'`](./lean_stage3/WeilSeries.md#WeilSeries-tsum_upper_le_explicit-) | theorem | `WeilSeries` | ∑' ρ : Upper, weightedTerm h γ ρ.1 ≤ 88 * (γ + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2) * (Real.pi ^ 2 / 6) |
| [`PerronKernel.tsum_vonMangoldt_div_cpow`](./lean_stage3/PerronKernel.md#PerronKernel-tsum_vonMangoldt_div_cpow) | theorem | `PerronKernel` | (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * ((x / n : ℝ) : ℂ) ^ s) = (- deriv riemannZeta s / riemannZeta s) * ((x:ℝ):ℂ) ^ s |
| [`TwinLattice.twin_lower_mod_six`](./lean/TwinLattice.md#TwinLattice-twin_lower_mod_six) | theorem | `TwinLattice` | p % 6 = 5 |
| [`TwinLattice.twin_pocket`](./lean/TwinLattice.md#TwinLattice-twin_pocket) | theorem | `TwinLattice` | (p + 1) % 6 = 0 |
| [`CellZeros.two_cpow_ne_zero`](./lean_stage3/CellZeros.md#CellZeros-two_cpow_ne_zero) | theorem | `CellZeros` | (2:ℂ) ^ ρ ≠ 0 |
| [`WeilTiles.two_le_centre`](./lean_stage3/WeilTiles.md#WeilTiles-two_le_centre) | theorem | `WeilTiles` | 2 ≤ centre k |
| [`WeilSeries.two_le_of_one_lt`](./lean_stage3/WeilSeries.md#WeilSeries-two_le_of_one_lt) | theorem | `WeilSeries` | 2 ≤ \|(k : ℝ) - (k0 : ℝ)\| |
| [`JointLadder.two_pow_ne_three_pow`](./lean/JointLadder.md#JointLadder-two_pow_ne_three_pow) | theorem | `JointLadder` | (2 : ℕ) ^ l ≠ 3 ^ k |
| [`LandauMellin.two_powers_integrableOn`](./lean_stage3/LandauMellin.md#LandauMellin-two_powers_integrableOn) | theorem | `LandauMellin` | IntegrableOn (fun t : ℝ =&gt; (1 / (n : ℂ)) * (t : ℂ) ^ (-s) - (t : ℂ) ^ (-s - 1)) (Ioi (n : ℝ)) |
| [`TableDepths.two_rpow_neg_nat`](./lean_stage3/TableDepths.md#TableDepths-two_rpow_neg_nat) | theorem | `TableDepths` | (2:ℝ) ^ (-(n:ℝ)) = 1 / (2:ℝ) ^ n |
| [`TableDepths.two_rpow_neg_nat_half`](./lean_stage3/TableDepths.md#TableDepths-two_rpow_neg_nat_half) | theorem | `TableDepths` | (2:ℝ) ^ (-(n:ℝ) + 1 / 2) ≤ 1.4143 / (2:ℝ) ^ n |
| [`WeilPowerSigma.u`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-u) | def | `WeilPowerSigma` | ℝ |
| [`WeilPowerSigma.u_def`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-u_def) | theorem | `WeilPowerSigma` | u m = ((m : ℝ) + 1) ^ 2 * sigma m |
| [`WeilPowerSigma.u_mono`](./lean_stage3/WeilPowerSigma.md#WeilPowerSigma-u_mono) | theorem | `WeilPowerSigma` | u m ≤ u (m + 1) |
| [`WeilPowerGeomGen.uLam`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-uLam) | def | `WeilPowerGeomGen` | ℝ |
| [`WeilPowerGeomGen.uLam_bracket`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-uLam_bracket) | theorem | `WeilPowerGeomGen` | 0 ≤ uLam lam h - ((h : ℝ) / ((lam : ℝ) * Real.pi ^ 2) - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) ∧ uLam lam h - ((h : ℝ) / ((lam : ℝ) * Real.pi ^ 2) - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) ≤ 1 / (2 * (… |
| [`WeilPowerGeomGen.uLam_eq`](./lean_stage3/WeilPowerGeomGen.md#WeilPowerGeomGen-uLam_eq) | theorem | `WeilPowerGeomGen` | uLam lam h = WeilPowerSigma.u (lam * h - 1) / (lam : ℝ) ^ 2 |
| [`WeilPowerNear.uLam_le`](./lean_stage3/WeilPowerNear.md#WeilPowerNear-uLam_le) | theorem | `WeilPowerNear` | WeilPowerGeomGen.uLam lam h ≤ (h : ℝ) / ((lam : ℝ) * Real.pi ^ 2) |
| [`WeilPowerNear.uLam_nonneg`](./lean_stage3/WeilPowerNear.md#WeilPowerNear-uLam_nonneg) | theorem | `WeilPowerNear` | 0 ≤ WeilPowerGeomGen.uLam lam h |
| [`Construction.unique_of_isTableOf`](./lean/Construction.md#Construction-unique_of_isTableOf) | theorem | `Construction` | ∀ r d, f r d = tableFrom N r d |
| [`WeilTiles.Upper`](./lean_stage3/WeilTiles.md#WeilTiles-Upper) | abbrev | `WeilTiles` | Type |
| [`LandauTail.upper_tail_le`](./lean_stage3/LandauTail.md#LandauTail-upper_tail_le) | theorem | `LandauTail` | ∫ y in Ioi Z, Real.log y ^ k * y ^ (-a - 1) ≤ Z ^ (-b) * (k.factorial / (a - b) ^ (k + 1)) |
| [`WeilPowerShell.uSh`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-uSh) | def | `WeilPowerShell` | ℝ |
| [`WeilPowerShell.uSh_bracket`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-uSh_bracket) | theorem | `WeilPowerShell` | ∀ k : ℕ, 0 ≤ uSh lam k - ((k : ℝ) / ((lam : ℝ) * Real.pi ^ 2) - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) ∧ uSh lam k - ((k : ℝ) / ((lam : ℝ) * Real.pi ^ 2) - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) ≤ 1 /… |
| [`ArgLegs.vertical_leg_le`](./lean_stage3/ArgLegs.md#ArgLegs-vertical_leg_le) | theorem | `ArgLegs` | \|(∫ t in (0:ℝ)..T, logDeriv riemannZeta (2 + (t : ℂ) * Complex.I)).re\| ≤ Real.pi / 2 |
| [`PerronKernel.vonMangoldt_rpow_partial`](./lean_stage3/PerronKernel.md#PerronKernel-vonMangoldt_rpow_partial) | theorem | `PerronKernel` | ∑ n ∈ s, ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c) ≤ 2 * (Real.log 4 + 4) / (1 - (2:ℝ) ^ (1 - c)) |
| [`PerronKernel.vonMangoldt_rpow_summable`](./lean_stage3/PerronKernel.md#PerronKernel-vonMangoldt_rpow_summable) | theorem | `PerronKernel` | Summable (fun n : ℕ ↦ ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c)) |
| [`PerronKernel.vonMangoldt_rpow_tsum`](./lean_stage3/PerronKernel.md#PerronKernel-vonMangoldt_rpow_tsum) | theorem | `PerronKernel` | ∑' n : ℕ, ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c) ≤ 2 * (Real.log 4 + 4) / (1 - (2:ℝ) ^ (1 - c)) |
| [`Slice5.vonMangoldt_term_le`](./lean_stage3/LineBound.md#Slice5-vonMangoldt_term_le) | theorem | `LineBound` | ‖LSeries.term (fun k : ℕ =&gt; ((vonMangoldt k : ℝ) : ℂ)) ((1 + 2 * b : ℝ) : ℂ) n‖ ≤ (1 / b) * ((n : ℝ)) ^ (-1 - b) |
| [`WeilOddPower.W`](./lean_stage3/WeilOddPower.md#WeilOddPower-W) | def | `WeilOddPower` | ℝ |
| [`Stage3.weak_anti_x₀`](./lean_stage3/Statement.md#Stage3-weak_anti_x-) | theorem | `Statement` | StmtSchoenfeldWeak C k x₀' pi li |
| [`Stage3.weak_mono`](./lean_stage3/Statement.md#Stage3-weak_mono) | theorem | `Statement` | StmtSchoenfeldWeak C' k x₀ pi li |
| [`Stage3.weakWindow_at_schoenfeld`](./lean_stage3/Statement.md#Stage3-weakWindow_at_schoenfeld) | theorem | `Statement` | StmtWeakWindow (1 / (8 * Real.pi)) 1 f L r n ↔ StmtSchoenfeldWindow f L r n |
| [`Stage3.weakWindow_of_global`](./lean_stage3/Statement.md#Stage3-weakWindow_of_global) | theorem | `Statement` | StmtWeakWindow C k f L r n |
| [`JointFloorGate.weakWindow_relErr`](./lean_stage3/JointFloorGate.md#JointFloorGate-weakWindow_relErr) | theorem | `JointFloorGate` | JointDialGate.StmtRelErrWindow f L r n (C * (Real.log 2 * r) ^ k * (2 : ℝ) ^ (-(((r : ℝ) - n) / 2))) |
| [`WeilSeries.weight_le`](./lean_stage3/WeilSeries.md#WeilSeries-weight_le) | theorem | `WeilSeries` | 15 * Real.log (centre k) + 73 ≤ 88 * ((k : ℝ) + 1) |
| [`WeilSeries.weight_nonneg`](./lean_stage3/WeilSeries.md#WeilSeries-weight_nonneg) | theorem | `WeilSeries` | 0 ≤ 15 * Real.log (centre k) + 73 |
| [`WeilBands.weightedTerm`](./lean_stage3/WeilBands.md#WeilBands-weightedTerm) | def | `WeilBands` | ℝ |
| [`WeilOnLine.weightedTerm_conjZ`](./lean_stage3/WeilOnLine.md#WeilOnLine-weightedTerm_conjZ) | theorem | `WeilOnLine` | weightedTerm h γ (conjZ ρ) = weightedTerm h γ ρ |
| [`WeilTiles.weightedTerm_nonneg`](./lean_stage3/WeilTiles.md#WeilTiles-weightedTerm_nonneg) | theorem | `WeilTiles` | 0 ≤ weightedTerm h γ ρ |
| [`WeilPowerBands.weightedTermW`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-weightedTermW) | def | `WeilPowerBands` | ℝ |
| [`WeilPowerOnLine.weightedTermW_conjZ`](./lean_stage3/WeilPowerOnLine.md#WeilPowerOnLine-weightedTermW_conjZ) | theorem | `WeilPowerOnLine` | weightedTermW h γ m (conjZ ρ) = weightedTermW h γ m ρ |
| [`WeilPowerBands.weightedTermW_nonneg`](./lean_stage3/WeilPowerBands.md#WeilPowerBands-weightedTermW_nonneg) | theorem | `WeilPowerBands` | 0 ≤ weightedTermW h γ m ρ |
| [`Stage3.weightedZeroHeightBucket_eq_zero`](./lean_stage3/RealSegment.md#Stage3-weightedZeroHeightBucket_eq_zero) | theorem | `RealSegment` | Kadiri.weightedZeroHeightBucket = 0 |
| [`Bridge.weil_bridge`](./lean_bridge/WeilBridge.md#Bridge-weil_bridge) | theorem | `WeilBridge` | Summable (fun ρ : {ρ : ℂ \| riemannZeta ρ = 0 ∧ 0 &lt; ρ.re ∧ ρ.re &lt; 1} =&gt; (((analyticOrderAt riemannZeta (ρ : ℂ)).toNat : ℕ) : ℂ) * (laplace G (-(ρ : ℂ)) * laplace G (-(1 - (ρ : ℂ))))) ∧ ∑' ρ : {ρ : ℂ \| … |
| [`WeilDetect.weilPositive_of_RH`](./lean_stage3/WeilDetect.md#WeilDetect-weilPositive_of_RH) | theorem | `WeilDetect` | StmtWeilPositive L |
| [`WeilOddPower.what`](./lean_stage3/WeilOddPower.md#WeilOddPower-what) | def | `WeilOddPower` | ℂ |
| [`WeilOddPower.what_eq`](./lean_stage3/WeilOddPower.md#WeilOddPower-what_eq) | theorem | `WeilOddPower` | what h γ m z = ((h : ℂ) / 2) * (S m ((z + Complex.I * (γ : ℂ)) * (h : ℂ)) + S m ((z - Complex.I * (γ : ℂ)) * (h : ℂ))) |
| [`WeilPowerBackground.what_I`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-what_I) | theorem | `WeilPowerBackground` | what h γ m (Complex.I * (t : ℂ)) = Complex.I * ((h : ℂ) / 2) * ((PsiW m (h * (t + γ)) : ℂ) + (PsiW m (h * (t - γ)) : ℂ)) |
| [`WeilPowerBackground.what_neg`](./lean_stage3/WeilPowerBackground.md#WeilPowerBackground-what_neg) | theorem | `WeilPowerBackground` | what h γ m (-z) = -what h γ m z |
| [`SeedPerturbation.window_bottoms_correct`](./lean/SeedPerturbation.md#SeedPerturbation-window_bottoms_correct) | theorem | `SeedPerturbation` | zero_cells.map (fun c =&gt; (c.1 : ℤ) - (c.2 : ℤ)) = zero_window_bottoms |
| [`Zeros.window_exclusive_of_prime_exponent`](./lean/ZerosStencil.md#Zeros-window_exclusive_of_prime_exponent) | theorem | `ZerosStencil` | b = 2 ∧ k = 7 |
| [`Schoenfeld.window_of_global`](./lean/Schoenfeld.md#Schoenfeld-window_of_global) | theorem | `Schoenfeld` | Nonvanishing.StmtSchoenfeldWindow f L r n |
| [`Stage3.window_of_global`](./lean_stage3/Statement.md#Stage3-window_of_global) | theorem | `Statement` | StmtSchoenfeldWindow f L r n |
| [`Zeros.window_shared_of_composite_exponent`](./lean/Zeros.md#Zeros-window_shared_of_composite_exponent) | theorem | `Zeros` | (4 : ℕ) ^ 2 = 2 ^ 4 |
| [`Nonvanishing.window_term_le`](./lean/Nonvanishing.md#Nonvanishing-window_term_le) | theorem | `Nonvanishing` | (Real.log 2 * ((r : ℝ) - k) / (8 * Real.pi)) * (2 : ℝ) ^ (((r : ℝ) - k) / 2) ≤ (Real.log 2 * r / (8 * Real.pi)) * (2 : ℝ) ^ ((r : ℝ) / 2) * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k |
| [`LandauWindow.WindowBound`](./lean_stage3/LandauWindow.md#LandauWindow-WindowBound) | def | `LandauWindow` | Prop |
| [`Zeros.wingMinus`](./lean/ZerosStencil.md#Zeros-wingMinus) | def | `ZerosStencil` | ℤ |
| [`Zeros.wingPlus`](./lean/ZerosStencil.md#Zeros-wingPlus) | def | `ZerosStencil` | ℤ |
| [`WeilPowerBridge.wm`](./lean_stage3/WeilPowerBridge.md#WeilPowerBridge-wm) | def | `WeilPowerBridge` | ℂ |
| [`WeilPowerCompare.wOf`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-wOf) | def | `WeilPowerCompare` | ℂ |
| [`WeilPowerCompare.wOf_im`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-wOf_im) | theorem | `WeilPowerCompare` | (wOf ε Δ h).im = Δ * h |
| [`WeilPowerCompare.wOf_re`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-wOf_re) | theorem | `WeilPowerCompare` | (wOf ε Δ h).re = ε * h |
| [`WeilPowerCompare.wOf_sq_re`](./lean_stage3/WeilPowerCompare.md#WeilPowerCompare-wOf_sq_re) | theorem | `WeilPowerCompare` | ((wOf ε Δ h) ^ 2).re = (ε ^ 2 - Δ ^ 2) * h ^ 2 |
| [`WeilPowerBridge.wp`](./lean_stage3/WeilPowerBridge.md#WeilPowerBridge-wp) | def | `WeilPowerBridge` | ℂ |
| [`WeilPowerBridge.wp_im`](./lean_stage3/WeilPowerBridge.md#WeilPowerBridge-wp_im) | theorem | `WeilPowerBridge` | (wp h γ ρ).im = (ρ.im + γ) * h |
| [`WeilPowerBridge.wp_re`](./lean_stage3/WeilPowerBridge.md#WeilPowerBridge-wp_re) | theorem | `WeilPowerBridge` | (wp h γ ρ).re = (ρ.re - 1 / 2) * h |
| [`WeilPowerPhase.x`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-x) | def | `WeilPowerPhase` | ℂ |
| [`WeilPowerPhase.x_eq_mul`](./lean_stage3/WeilPowerPhase.md#WeilPowerPhase-x_eq_mul) | theorem | `WeilPowerPhase` | x w j = w ^ 2 * ((hterm j : ℝ) : ℂ) |
| [`WeilPowerGauss.x_norm`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-x_norm) | theorem | `WeilPowerGauss` | ‖w ^ 2 / ((Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2)‖ = ‖w‖ ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2) |
| [`WeilPowerGauss.x_re`](./lean_stage3/WeilPowerGauss.md#WeilPowerGauss-x_re) | theorem | `WeilPowerGauss` | (w ^ 2 / ((Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2)).re = (w ^ 2).re / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2) |
| [`Stage3.xi`](./lean_stage3/ArgIdentity.md#Stage3-xi) | def | `ArgIdentity` | ℂ |
| [`Stage3.xi_analyticAt`](./lean_stage3/ArgIdentity.md#Stage3-xi_analyticAt) | theorem | `ArgIdentity` | AnalyticAt ℂ xi s |
| [`Stage3.xi_conj`](./lean_stage3/ArgIdentity.md#Stage3-xi_conj) | theorem | `ArgIdentity` | xi (conj s) = conj (xi s) |
| [`Stage3.xi_divisor_support_eq`](./lean_stage3/ArgIdentity.md#Stage3-xi_divisor_support_eq) | theorem | `ArgIdentity` | (MeromorphicOn.divisor xi (Rectangle (-1 : ℂ) (2 + Complex.I * T))).support = riemannZeta.zeroes_rect (Set.univ : Set ℝ) (Set.Ioo 0 T) |
| [`Stage3.xi_eq_completed`](./lean_stage3/ArgIdentity.md#Stage3-xi_eq_completed) | theorem | `ArgIdentity` | xi s = s * (s - 1) * completedRiemannZeta s |
| [`Stage3.xi_eq_prod`](./lean_stage3/ArgIdentity.md#Stage3-xi_eq_prod) | theorem | `ArgIdentity` | xi s = s * (s - 1) * Gammaℝ s * riemannZeta s |
| [`Stage3.xi_eq_zero_iff`](./lean_stage3/ArgIdentity.md#Stage3-xi_eq_zero_iff) | theorem | `ArgIdentity` | xi s = 0 ↔ riemannZeta s = 0 ∧ 0 &lt; s.re ∧ s.re &lt; 1 |
| [`Stage3.xi_meromorphicOrderAt_ne_top`](./lean_stage3/ArgIdentity.md#Stage3-xi_meromorphicOrderAt_ne_top) | theorem | `ArgIdentity` | meromorphicOrderAt xi p ≠ ⊤ |
| [`Stage3.xi_ne_zero_of_one_le_re`](./lean_stage3/ArgIdentity.md#Stage3-xi_ne_zero_of_one_le_re) | theorem | `ArgIdentity` | xi s ≠ 0 |
| [`Stage3.xi_ne_zero_of_re_nonpos`](./lean_stage3/ArgIdentity.md#Stage3-xi_ne_zero_of_re_nonpos) | theorem | `ArgIdentity` | xi s ≠ 0 |
| [`Stage3.xi_ne_zero_of_real`](./lean_stage3/ArgIdentity.md#Stage3-xi_ne_zero_of_real) | theorem | `ArgIdentity` | xi (σ : ℂ) ≠ 0 |
| [`Stage3.xi_ne_zero_on_good_top`](./lean_stage3/ArgIdentity.md#Stage3-xi_ne_zero_on_good_top) | theorem | `ArgIdentity` | xi ((x : ℂ) + T * Complex.I) ≠ 0 |
| [`Stage3.xi_one`](./lean_stage3/ArgIdentity.md#Stage3-xi_one) | theorem | `ArgIdentity` | xi 1 = 1 |
| [`Stage3.xi_one_sub`](./lean_stage3/ArgIdentity.md#Stage3-xi_one_sub) | theorem | `ArgIdentity` | xi (1 - s) = xi s |
| [`Stage3.xi_zero`](./lean_stage3/ArgIdentity.md#Stage3-xi_zero) | theorem | `ArgIdentity` | xi 0 = 1 |
| [`WeilTransform.xP_odd`](./lean_stage3/WeilTransform.md#WeilTransform-xP_odd) | theorem | `WeilTransform` | (-x) * P (-x) = -(x * P x) |
| [`Crossover.xterm`](./lean/Crossover.md#Crossover-xterm) | def | `Crossover` | ℝ |
| [`Crossover.yterm`](./lean/Crossover.md#Crossover-yterm) | def | `Crossover` | ℝ |
| [`Zeros.zero_20_6`](./lean/Zeros.md#Zeros-zero_20_6) | theorem | `Zeros` | Construction.tableFrom dyadicRow 20 6 = 0 |
| [`Zeros.zero_2_1`](./lean/Zeros.md#Zeros-zero_2_1) | theorem | `Zeros` | Construction.tableFrom dyadicRow 2 1 = 0 |
| [`Zeros.zero_4_1`](./lean/Zeros.md#Zeros-zero_4_1) | theorem | `Zeros` | Construction.tableFrom dyadicRow 4 1 = 0 |
| [`Zeros.zero_8_3`](./lean/Zeros.md#Zeros-zero_8_3) | theorem | `Zeros` | Construction.tableFrom dyadicRow 8 3 = 0 |
| [`Zeros.zero_at_20_6_of_repeat`](./lean/Zeros.md#Zeros-zero_at_20_6_of_repeat) | theorem | `Zeros` | Construction.tableFrom N 20 6 = 0 |
| [`Zeros.zero_at_8_3_of_repeat`](./lean/Zeros.md#Zeros-zero_at_8_3_of_repeat) | theorem | `Zeros` | Construction.tableFrom N 8 3 = 0 |
| [`PairIdentity.zero_cells`](./lean/PairIdentity.md#PairIdentity-zero_cells) | def | `PairIdentity` | List (ℕ × ℕ) |
| [`SeedPerturbation.zero_cells`](./lean/SeedPerturbation.md#SeedPerturbation-zero_cells) | def | `SeedPerturbation` | List (ℕ × ℕ) |
| [`Construction.zero_determined_by_row`](./lean/Construction.md#Construction-zero_determined_by_row) | theorem | `Construction` | tableFrom N r d = tableFrom M r d |
| [`SeedPerturbation.zero_iff_of_seed_perturbation`](./lean/SeedPerturbation.md#SeedPerturbation-zero_iff_of_seed_perturbation) | theorem | `SeedPerturbation` | tableFrom (fun x =&gt; N x - e x) r d = 0 ↔ tableFrom N r d = 0 |
| [`Zeros.zero_iff_repeat`](./lean/Zeros.md#Zeros-zero_iff_repeat) | theorem | `Zeros` | f r (d + 1) = 0 ↔ f r d = f (r - 1) d |
| [`LandauZeroSide.zero_side`](./lean_stage3/LandauZeroSide.md#LandauZeroSide-zero_side) | theorem | `LandauZeroSide` | ∃ r R τ C₁ : ℝ, ∃ N₀ : ℕ, σ₀ - 1 &lt; r ∧ r ≤ ‖(σ₀ : ℂ) - ρ₀‖ ∧ r &lt; R ∧ 0 &lt; τ ∧ 0 ≤ C₁ ∧ ∀ a N : ℕ, N₀ ≤ N → ∃ k ∈ Finset.Ico a (a + N), τ / r ^ (k + 1) - C₁ / R ^ k ≤ LandauPrimeSide.Ik σ₀ k / k.factori… |
| [`SeedPerturbation.zero_stable_of_seed_perturbation`](./lean/SeedPerturbation.md#SeedPerturbation-zero_stable_of_seed_perturbation) | theorem | `SeedPerturbation` | tableFrom (fun x =&gt; N x - e x) r d = 0 |
| [`SeedPerturbation.zero_window_bottoms`](./lean/SeedPerturbation.md#SeedPerturbation-zero_window_bottoms) | def | `SeedPerturbation` | List ℤ |
| [`WeilBridgeLeaf.zeroes_rect_strip`](./lean_stage3/WeilBridgeLeaf.md#WeilBridgeLeaf-zeroes_rect_strip) | theorem | `WeilBridgeLeaf` | riemannZeta.zeroes_rect (Set.Ioo 0 1) Set.univ = {ρ : ℂ \| riemannZeta ρ = 0 ∧ 0 &lt; ρ.re ∧ ρ.re &lt; 1} |
| [`WeilDetect.zeroForm`](./lean_stage3/WeilDetect.md#WeilDetect-zeroForm) | def | `WeilDetect` | ℂ |
| [`WeilBridgeLeaf.zeroForm_eq_primeSide`](./lean_stage3/WeilBridgeLeaf.md#WeilBridgeLeaf-zeroForm_eq_primeSide) | theorem | `WeilBridgeLeaf` | zeroForm G = primeSideM (kOfM G) |
| [`WeilBridgeLeaf.zeroForm_eq_strip`](./lean_stage3/WeilBridgeLeaf.md#WeilBridgeLeaf-zeroForm_eq_strip) | theorem | `WeilBridgeLeaf` | zeroForm G = ∑' ρ : {ρ : ℂ \| riemannZeta ρ = 0 ∧ 0 &lt; ρ.re ∧ ρ.re &lt; 1}, (((analyticOrderAt riemannZeta (ρ : ℂ)).toNat : ℕ) : ℂ) * (laplace G (-(ρ : ℂ)) * laplace G (-(1 - (ρ : ℂ)))) |
| [`WeilDetect.zeroForm_nonneg_of_RH`](./lean_stage3/WeilDetect.md#WeilDetect-zeroForm_nonneg_of_RH) | theorem | `WeilDetect` | 0 ≤ (zeroForm G).re |
| [`LandauWindow.zeroFree_half_of_window`](./lean_stage3/LandauWindow.md#LandauWindow-zeroFree_half_of_window) | theorem | `LandauWindow` | ∀ s : ℂ, 1 / 2 &lt; s.re → riemannZeta s ≠ 0 |
| [`Stage3.zeroFreeRight_iff_psiWeakTheta`](./lean_stage3/ThetaConverse.md#Stage3-zeroFreeRight_iff_psiWeakTheta) | theorem | `ThetaConverse` | StmtZeroFreeRight θ ↔ ∃ C &gt; 0, ∃ x₀ : ℝ, StmtPsiWeakTheta θ C 3 x₀ |
| [`Stage3.zeroFreeRight_mono`](./lean_stage3/Abscissa.md#Stage3-zeroFreeRight_mono) | theorem | `Abscissa` | StmtZeroFreeRight θ' |
| [`Stage3.zeroFreeRight_of_psiWeakTheta`](./lean_stage3/ThetaConverse.md#Stage3-zeroFreeRight_of_psiWeakTheta) | theorem | `ThetaConverse` | StmtZeroFreeRight θ |
| [`Stage3.zeroFreeRight_of_RH`](./lean_stage3/Abscissa.md#Stage3-zeroFreeRight_of_RH) | theorem | `Abscissa` | StmtZeroFreeRight (1/2) |
| [`JointWindowDial.zeroFreeRight_of_window`](./lean_stage3/JointWindowDial.md#JointWindowDial-zeroFreeRight_of_window) | theorem | `JointWindowDial` | Stage3.StmtZeroFreeRight θ |
| [`Stage3.zeroFreeRight_one`](./lean_stage3/Abscissa.md#Stage3-zeroFreeRight_one) | theorem | `Abscissa` | StmtZeroFreeRight 1 |
| [`Stage3.zeroFreeRight_one_of_chebyshev`](./lean_stage3/ThetaConverse.md#Stage3-zeroFreeRight_one_of_chebyshev) | theorem | `ThetaConverse` | StmtZeroFreeRight 1 |
| [`ContourShift.zeroGap`](./lean_stage3/ContourShift.md#ContourShift-zeroGap) | def | `ContourShift` | ℝ |
| [`ContourShift.zeroGap_le`](./lean_stage3/ContourShift.md#ContourShift-zeroGap_le) | theorem | `ContourShift` | zeroGap T ≤ 9/10 |
| [`ContourShift.zeroGap_pos`](./lean_stage3/ContourShift.md#ContourShift-zeroGap_pos) | theorem | `ContourShift` | 0 &lt; zeroGap T |
| [`Stage3.zeroinner_arith`](./lean_stage3/Assembly.md#Stage3-zeroinner_arith) | theorem | `Assembly` | 2 * (Real.log 2 / (2 * Real.pi) * (KK + 1) * (KK + 2) + 3 * (KK + 1) / Real.pi + 2 * (R + 7 / 8)) + 2 * W ≤ 2 * (7 + 4 * b₁ + 4 * b₂ + 2 * b₃) * L ^ 2 + 2 * W |
| [`Stage3.zeroinner_floor`](./lean_stage3/AssemblyFloor.md#Stage3-zeroinner_floor) | theorem | `AssemblyFloor` | 2 * (Real.log 2 / (2 * Real.pi) * (KK + 1) * (KK + 2) + 3 * (KK + 1) / Real.pi + 2 * (R + 7 / 8)) + 2 * W ≤ 2 * (L ^ 2 + (4 + 4 * b₁ + 4 * b₂) * L + 2 * b₃ + 2) + 2 * W |
| [`Stage3.zeroPartialSum`](./lean_stage3/Assembly.md#Stage3-zeroPartialSum) | def | `Assembly` | ℂ |
| [`ContourShift.zeroPartialSum_eq_sum`](./lean_stage3/ContourShift.md#ContourShift-zeroPartialSum_eq_sum) | theorem | `ContourShift` | Stage3.zeroPartialSum x T' = ∑ p ∈ ZF, ((analyticOrderNatAt riemannZeta p : ℂ) * ((x : ℂ) ^ p / p)) |
| [`Glue.zeroPartialSum_swap`](./lean_stage3/Glue.md#Glue-zeroPartialSum_swap) | theorem | `Glue` | ∃ C : ℝ, 0 &lt; C ∧ ∀ x T T' : ℝ, 16 ≤ x → 2 ≤ T → T ≤ T' → T' ≤ T + 1 → ‖Stage3.zeroPartialSum x T' - Stage3.zeroPartialSum x T‖ ≤ C * x * Real.log T / T |
| [`Glue.zeroPartialSum_swap_num`](./lean_stage3/GlueNum.md#Glue-zeroPartialSum_swap_num) | theorem | `GlueNum` | ∀ x T T' : ℝ, 16 ≤ x → 2 ≤ T → T ≤ T' → T' ≤ T + 1 → ‖Stage3.zeroPartialSum x T' - Stage3.zeroPartialSum x T‖ ≤ Csn * x * Real.log T / T |
| [`Transform.zeros_in_fundamental_annulus`](./lean/Transform.md#Transform-zeros_in_fundamental_annulus) | theorem | `Transform` | b ^ (-(1 : ℝ)) &lt; ‖(b : ℂ) ^ (-s)‖ ∧ ‖(b : ℂ) ^ (-s)‖ &lt; 1 |
| [`Transform.zeros_outside_inner_circle`](./lean/Transform.md#Transform-zeros_outside_inner_circle) | theorem | `Transform` | b ^ (-(1 : ℝ)) &lt; ‖(b : ℂ) ^ (-s)‖ |
| [`Transform.zeros_re_lt_one`](./lean/Transform.md#Transform-zeros_re_lt_one) | theorem | `Transform` | s.re &lt; 1 |
| [`Transform.zeros_re_pos`](./lean/Transform.md#Transform-zeros_re_pos) | theorem | `Transform` | 0 &lt; s.re |
| [`ZetaGrowth.zeta1`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta1) | def | `ZetaGrowth` | ℂ |
| [`ZetaGrowth.zeta1_analyticOnNhd`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta1_analyticOnNhd) | theorem | `ZetaGrowth` | AnalyticOnNhd ℂ (zeta1 N) stripRegion |
| [`ZetaGrowth.zeta1_eq_zeta`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta1_eq_zeta) | theorem | `ZetaGrowth` | zeta1 N s = riemannZeta s |
| [`ZetaGrowth.zeta1_eq_zeta_strip`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta1_eq_zeta_strip) | theorem | `ZetaGrowth` | Set.EqOn (zeta1 N) riemannZeta stripRegion |
| [`ContourShift.zeta_analyticAt`](./lean_stage3/ContourShift.md#ContourShift-zeta_analyticAt) | theorem | `ContourShift` | AnalyticAt ℂ riemannZeta ρ |
| [`VonKoch.zeta_analyticOnNhd`](./lean_stage3/VonKochScaffold.md#VonKoch-zeta_analyticOnNhd) | theorem | `VonKochScaffold` | AnalyticOnNhd ℂ riemannZeta region |
| [`Stage3.zeta_analyticOnNhd_regionθ`](./lean_stage3/ThetaConverse.md#Stage3-zeta_analyticOnNhd_region-) | theorem | `ThetaConverse` | AnalyticOnNhd ℂ ζ (regionθ θ) |
| [`Stage3.zeta_centre_lower`](./lean_stage3/JensenCount.md#Stage3-zeta_centre_lower) | theorem | `JensenCount` | (1 : ℝ) / 3 ≤ ‖ζ (2 + Complex.I * T)‖ |
| [`Stage3.zeta_centre_ne_zero`](./lean_stage3/JensenCount.md#Stage3-zeta_centre_ne_zero) | theorem | `JensenCount` | ζ (2 + Complex.I * (T : ℂ)) ≠ 0 |
| [`Stage3.zeta_comp_analytic`](./lean_stage3/JensenCount.md#Stage3-zeta_comp_analytic) | theorem | `JensenCount` | AnalyticAt ℂ (fun z : ℂ =&gt; ζ (2 * z + (2 + Complex.I * (T : ℂ)))) w |
| [`Stage3.zeta_disk_upper`](./lean_stage3/JensenCount.md#Stage3-zeta_disk_upper) | theorem | `JensenCount` | ‖ζ w‖ ≤ 28 * T |
| [`ZetaGrowth.zeta_growth_strip`](./lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta_growth_strip) | theorem | `ZetaGrowth` | ‖riemannZeta s‖ ≤ 15 * \|s.im\| ^ 2 |
| [`ContourShift.zeta_local_data`](./lean_stage3/ContourShift.md#ContourShift-zeta_local_data) | theorem | `ContourShift` | ∃ h : ℂ → ℂ, AnalyticAt ℂ h p ∧ ∀ᶠ s in nhdsWithin p {p}ᶜ, - deriv riemannZeta s / riemannZeta s * ((x:ℝ):ℂ) ^ s / s = h s + (-(n:ℂ) * ((x:ℝ):ℂ) ^ p / p) / (s - p) |
| [`ContourShift.zeta_local_data_one`](./lean_stage3/ContourShift.md#ContourShift-zeta_local_data_one) | theorem | `ContourShift` | ∃ h : ℂ → ℂ, AnalyticAt ℂ h 1 ∧ ∀ᶠ s in nhdsWithin 1 {1}ᶜ, - deriv riemannZeta s / riemannZeta s * ((x:ℝ):ℂ) ^ s / s = h s + ((x:ℝ):ℂ) / (s - 1) |
| [`ContourShift.zeta_local_data_origin`](./lean_stage3/ContourShift.md#ContourShift-zeta_local_data_origin) | theorem | `ContourShift` | ∃ h : ℂ → ℂ, AnalyticAt ℂ h 0 ∧ ∀ᶠ s in nhdsWithin 0 {0}ᶜ, - deriv riemannZeta s / riemannZeta s * ((x:ℝ):ℂ) ^ s / s = h s + (- deriv riemannZeta 0 / riemannZeta 0) / (s - 0) |
| [`ContourShift.zeta_local_data_zero`](./lean_stage3/ContourShift.md#ContourShift-zeta_local_data_zero) | theorem | `ContourShift` | ∃ h : ℂ → ℂ, AnalyticAt ℂ h ρ ∧ ∀ᶠ s in nhdsWithin ρ {ρ}ᶜ, - deriv riemannZeta s / riemannZeta s * ((x:ℝ):ℂ) ^ s / s = h s + (-(analyticOrderNatAt riemannZeta ρ : ℂ) * ((x:ℝ):ℂ) ^ ρ / ρ) / (s - ρ) |
| [`Stage3.zeta_local_zero_count`](./lean_stage3/JensenCount.md#Stage3-zeta_local_zero_count) | theorem | `JensenCount` | ∑ ρ ∈ (zetaWindow_finite hT).toFinset, (analyticOrderNatAt ζ ρ : ℝ) ≤ 15 * Real.log T + 73 |
| [`Glue.zeta_logderiv_good_bound`](./lean_stage3/Glue.md#Glue-zeta_logderiv_good_bound) | theorem | `Glue` | ∃ C : ℝ, 0 &lt; C ∧ ∀ T T' : ℝ, 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 &lt; ρ.re → ContourShift.zeroGap T ≤ \|ρ.im - T'\|) → ∀ u : ℂ, \|u.im\| = T' → -1/4 ≤ u.re → u.re ≤ 2 → ‖deriv riem… |
| [`Glue.zeta_logderiv_good_bound_num`](./lean_stage3/GlueNum.md#Glue-zeta_logderiv_good_bound_num) | theorem | `GlueNum` | ∀ T T' : ℝ, 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 &lt; ρ.re → ContourShift.zeroGap T ≤ \|ρ.im - T'\|) → ∀ u : ℂ, \|u.im\| = T' → -1/4 ≤ u.re → u.re ≤ 2 → ‖deriv riemannZeta u / riema… |
| [`ContourShift.zeta_meromorphicOn`](./lean_stage3/ContourShift.md#ContourShift-zeta_meromorphicOn) | theorem | `ContourShift` | MeromorphicOn riemannZeta U |
| [`Elephant.zeta_ne_zero_of_re_eq_zero`](./lean/Elephant.md#Elephant-zeta_ne_zero_of_re_eq_zero) | theorem | `Elephant` | riemannZeta ρ ≠ 0 |
| [`ContourShift.zeta_ne_zero_of_re_mem`](./lean_stage3/ContourShift.md#ContourShift-zeta_ne_zero_of_re_mem) | theorem | `ContourShift` | riemannZeta w ≠ 0 |
| [`Stage3.zeta_ne_zero_of_real_mem_Ioo`](./lean_stage3/ArgIdentity.md#Stage3-zeta_ne_zero_of_real_mem_Ioo) | theorem | `ArgIdentity` | riemannZeta (σ : ℂ) ≠ 0 |
| [`RHPull.zeta_ne_zero_of_RH`](./lean_stage3/LineBound.md#RHPull-zeta_ne_zero_of_RH) | theorem | `LineBound` | ζ s ≠ 0 |
| [`Slice3.zeta_ne_zero_of_RH`](./lean_stage3/LineBound.md#Slice3-zeta_ne_zero_of_RH) | theorem | `LineBound` | ζ s ≠ 0 |
| [`Slice4.zeta_ne_zero_of_RH`](./lean_stage3/LineBound.md#Slice4-zeta_ne_zero_of_RH) | theorem | `LineBound` | ζ s ≠ 0 |
| [`Stage3.zeta_ne_zero_right_of`](./lean_stage3/Abscissa.md#Stage3-zeta_ne_zero_right_of) | theorem | `Abscissa` | ζ s ≠ 0 |
| [`LandauWindow.zeta_neg_nat_ne_zero`](./lean_stage3/LandauWindow.md#LandauWindow-zeta_neg_nat_ne_zero) | theorem | `LandauWindow` | riemannZeta (-(n : ℂ)) ≠ 0 |
| [`ContourShift.zeta_order_conj`](./lean_stage3/ContourShift.md#ContourShift-zeta_order_conj) | theorem | `ContourShift` | analyticOrderNatAt riemannZeta ((starRingEnd ℂ) ρ) = analyticOrderNatAt riemannZeta ρ |
| [`ContourShift.zeta_order_ne_top`](./lean_stage3/ContourShift.md#ContourShift-zeta_order_ne_top) | theorem | `ContourShift` | analyticOrderAt riemannZeta ρ ≠ ⊤ |
| [`ContourShift.zeta_order_reflect`](./lean_stage3/ContourShift.md#ContourShift-zeta_order_reflect) | theorem | `ContourShift` | analyticOrderNatAt riemannZeta (1 - (starRingEnd ℂ) ρ) = analyticOrderNatAt riemannZeta ρ |
| [`BoxBounds.zeta_ratio_ge`](./lean_stage3/BoxBounds.md#BoxBounds-zeta_ratio_ge) | theorem | `BoxBounds` | 2 / 7 ≤ ‖riemannZeta 3 / riemannZeta (3 / 2)‖ |
| [`EdgeBound.zeta_ratio_pos`](./lean_stage3/EdgeBound.md#EdgeBound-zeta_ratio_pos) | theorem | `EdgeBound` | (0:ℝ) &lt; ‖riemannZeta 3 / riemannZeta (3/2)‖ |
| [`Stage3.zeta_re_neg_of_real_mem_Ioo`](./lean_stage3/ArgIdentity.md#Stage3-zeta_re_neg_of_real_mem_Ioo) | theorem | `ArgIdentity` | (riemannZeta (σ : ℂ)).re &lt; 0 |
| [`Stage3.zeta_real_ne_zero`](./lean_stage3/RealSegment.md#Stage3-zeta_real_ne_zero) | theorem | `RealSegment` | riemannZeta (σ : ℂ) ≠ 0 |
| [`Stage3.zeta_real_ne_zero_upper`](./lean_stage3/RealSegment.md#Stage3-zeta_real_ne_zero_upper) | theorem | `RealSegment` | riemannZeta (σ : ℂ) ≠ 0 |
| [`Elephant.zeta_zero_weight_band`](./lean/Elephant.md#Elephant-zeta_zero_weight_band) | theorem | `Elephant` | (1 - b ^ (-(1:ℝ)/2)) ^ d ≤ ‖Sym b ρ‖ ^ d ∧ ‖Sym b ρ‖ ^ d ≤ (1 + b ^ (-(1:ℝ)/2)) ^ d |
| [`ContourShift.zeta_zeros_rectangle_finite`](./lean_stage3/ContourShift.md#ContourShift-zeta_zeros_rectangle_finite) | theorem | `ContourShift` | {ρ : ℂ \| riemannZeta ρ = 0 ∧ ρ ∈ Rectangle z w}.Finite |
| [`Stage3.zetaArgContour`](./lean_stage3/ArgIdentity.md#Stage3-zetaArgContour) | def | `ArgIdentity` | ℝ |
| [`ArgLegs.zetaArgContour_le`](./lean_stage3/ArgLegs.md#ArgLegs-zetaArgContour_le) | theorem | `ArgLegs` | \|Stage3.zetaArgContour T\| ≤ (Z.card : ℝ) + 3 / 2 |
| [`Slice4.zetaE`](./lean_stage3/LineBound.md#Slice4-zetaE) | def | `LineBound` | ℂ → ℂ |
| [`Slice4.zetaE_differentiable`](./lean_stage3/LineBound.md#Slice4-zetaE_differentiable) | theorem | `LineBound` | Differentiable ℂ zetaE |
| [`Slice4.zetaE_differentiableAt_of_ne`](./lean_stage3/LineBound.md#Slice4-zetaE_differentiableAt_of_ne) | theorem | `LineBound` | DifferentiableAt ℂ zetaE s |
| [`Slice4.zetaE_disk_upper`](./lean_stage3/LineBound.md#Slice4-zetaE_disk_upper) | theorem | `LineBound` | ‖zetaE w‖ ≤ 430 |
| [`Slice4.zetaE_eq`](./lean_stage3/LineBound.md#Slice4-zetaE_eq) | theorem | `LineBound` | zetaE s = (s - 1) * ζ s |
| [`Slice4.zetaE_ne_zero_of_RH`](./lean_stage3/LineBound.md#Slice4-zetaE_ne_zero_of_RH) | theorem | `LineBound` | zetaE s ≠ 0 |
| [`Slice4.zetaE_one`](./lean_stage3/LineBound.md#Slice4-zetaE_one) | theorem | `LineBound` | zetaE 1 = 1 |
| [`Stage3.zetaLocalCount`](./lean_stage3/JensenCount.md#Stage3-zetaLocalCount) | def | `JensenCount` | ℝ |
| [`Stage3.zetaLocalCount_eq`](./lean_stage3/JensenCount.md#Stage3-zetaLocalCount_eq) | theorem | `JensenCount` | zetaLocalCount T = ∑ ρ ∈ (zetaWindow_finite hT).toFinset, (analyticOrderNatAt ζ ρ : ℝ) |
| [`Stage3.zetaWindow`](./lean_stage3/JensenCount.md#Stage3-zetaWindow) | def | `JensenCount` | Set ℂ |
| [`Stage3.zetaWindow_finite`](./lean_stage3/JensenCount.md#Stage3-zetaWindow_finite) | theorem | `JensenCount` | (zetaWindow T).Finite |
| [`Stage3.zetaWindowTwo_finite`](./lean_stage3/JensenCount.md#Stage3-zetaWindowTwo_finite) | theorem | `JensenCount` | {ρ : ℂ \| ζ ρ = 0 ∧ ‖ρ - (2 + Complex.I * (T : ℂ))‖ ≤ 2}.Finite |
| [`Transform.zmap_functional_equation`](./lean/Transform.md#Transform-zmap_functional_equation) | theorem | `Transform` | (b : ℂ) ^ (-((1 : ℂ) - s)) = (b : ℂ) ^ (-(1 : ℂ)) / (b : ℂ) ^ (-s) |
| [`Transform.zmap_ne_zero`](./lean/Transform.md#Transform-zmap_ne_zero) | theorem | `Transform` | (b : ℂ) ^ (-s) ≠ 0 |
| [`Transform.zmap_pair_product`](./lean/Transform.md#Transform-zmap_pair_product) | theorem | `Transform` | ‖(b : ℂ) ^ (-s)‖ * ‖(b : ℂ) ^ (-(1 - s))‖ = b ^ (-(1 : ℝ)) |
| [`Transform.zmap_period`](./lean/Transform.md#Transform-zmap_period) | theorem | `Transform` | (b : ℂ) ^ (-(s + 2 * Real.pi * I / Real.log b)) = (b : ℂ) ^ (-s) |
| [`Transform.zmap_period_tau`](./lean/Transform.md#Transform-zmap_period_tau) | theorem | `Transform` | (b : ℂ) ^ (-(s + (tau b : ℂ) * I)) = (b : ℂ) ^ (-s) |
| [`Transform.zmap_period_zsmul`](./lean/Transform.md#Transform-zmap_period_zsmul) | theorem | `Transform` | (b : ℂ) ^ (-(s + (n : ℂ) * ((tau b : ℂ) * I))) = (b : ℂ) ^ (-s) |
| [`Transform.zmap_shift`](./lean/Transform.md#Transform-zmap_shift) | theorem | `Transform` | (b : ℂ) ^ (-(s + 1)) = (b : ℂ) ^ (-s) / (b : ℂ) |
| [`Transform.zmap_shift_modulus`](./lean/Transform.md#Transform-zmap_shift_modulus) | theorem | `Transform` | ‖(b : ℂ) ^ (-(s + n))‖ = ‖(b : ℂ) ^ (-s)‖ / b ^ n |
| [`WeilPowerShell.zOf`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-zOf) | def | `WeilPowerShell` | ℂ |
| [`WeilPowerShell.zOf_im`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-zOf_im) | theorem | `WeilPowerShell` | (zOf e' D e).im = 4 * e' * D |
| [`WeilPowerShell.zOf_re`](./lean_stage3/WeilPowerShell.md#WeilPowerShell-zOf_re) | theorem | `WeilPowerShell` | (zOf e' D e).re = 2 * (e' ^ 2 - D ^ 2 - e ^ 2) |
| [`Stage3.zq`](./lean_stage3/Stirling.md#Stage3-zq) | def | `Stirling` | ℂ |
| [`WeilPowerSelect.δSel`](./lean_stage3/WeilPowerSelect.md#WeilPowerSelect--Sel) | def | `WeilPowerSelect` | ℝ |
| [`WeilPowerSelect.δSel_pos`](./lean_stage3/WeilPowerSelect.md#WeilPowerSelect--Sel_pos) | theorem | `WeilPowerSelect` | 0 &lt; δSel K' lam h |
| [`RHPull.σRH`](./lean_stage3/LineBound.md#RHPull--RH) | def | `LineBound` | ℝ |
| [`RHPull.σRH_re`](./lean_stage3/LineBound.md#RHPull--RH_re) | theorem | `LineBound` | ((σRH X : ℂ) + I * (t : ℂ)).re = σRH X |
| [`Stage3.σθ`](./lean_stage3/Abscissa.md#Stage3---) | def | `Abscissa` | ℝ |
| [`Stage3.σθ_half`](./lean_stage3/Abscissa.md#Stage3---_half) | theorem | `Abscissa` | σθ (1/2) X = RHPull.σRH X |
| [`Stage3.σθ_lt_one`](./lean_stage3/ThetaPsi.md#Stage3---_lt_one) | theorem | `ThetaPsi` | σθ θ X &lt; 1 |
| [`Stage3.σθ_re`](./lean_stage3/Abscissa.md#Stage3---_re) | theorem | `Abscissa` | ((σθ θ X : ℂ) + I * (t : ℂ)).re = σθ θ X |
