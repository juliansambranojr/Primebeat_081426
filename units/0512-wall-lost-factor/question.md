> Source: session transcript, 2026-11-24

> Yes log

The question it answers, from the transcript:

> The repo's rule says a lost factor gets a decision unit. Do you want rounds 2 and 3 logged as one now?

From `lean_stage3/Stage3/ReachRoute.lean`, the arrangement closed before the wall:

```
theorem reached_mode_false {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    {σ₀ Θ : ℝ} (hσ₀ : 1 / 2 < σ₀) (hσ₀Θ : σ₀ < Θ) (hΘ1 : Θ ≤ 1)
    (hΘ : ∀ ρ : Kadiri.NontrivialZeros, (ρ : ℂ).re ≤ Θ) :
    ∃ E : ℝ, σ₀ ≤ E ∧ E < Θ ∧ ∀ σ : ℝ, E ≤ σ →
      ∀ ρ₁ : Kadiri.NontrivialZeros, σ < (ρ₁ : ℂ).re →
      (∃ (u : ℕ → ℂ) (M : ℝ),
        (∀ j, u j ∈ connectedComponentIn (Metric.ball (0:ℂ) ((2:ℝ) ^ (-σ)) \ K σ) 0) ∧
        Tendsto u atTop (𝓝 (um ρ₁)) ∧
        (∀ j, u j ≠ um ρ₁) ∧
        (∀ j, ∀ ρ : Kadiri.NontrivialZeros, σ ≤ (ρ : ℂ).re → um ρ ≠ um ρ₁ →
          ‖u j - um ρ₁‖ ≤ M * ‖um ρ - u j‖)) →
      False := by
  classical
  obtain ⟨θ', Ct, hθ'1, hCt, hPb⟩ := P_bound hH hσ₀ (hσ₀Θ.le.trans hΘ1) hΘ
  refine ⟨max σ₀ (Θ - (1 - θ')), le_max_left _ _, max_lt hσ₀Θ (by linarith), ?_⟩
  intro σ hσE ρ₁ hρ₁ hreach
  obtain ⟨u, M, huW, hulim, hune, huM⟩ := hreach
  have hσ₀σ : σ₀ ≤ σ := (le_max_left _ _).trans hσE
  have hΘσ : Θ ≤ σ + (1 - θ') := by
    have := (le_max_right σ₀ (Θ - (1 - θ'))).trans hσE
    linarith
  have hσ : 1 / 2 < σ := by linarith
  -- the radius of G
  set X := (2:ℝ) ^ σ with hXdef
  have hX : 0 < X := by positivity
  have hA := hPb σ hσ₀σ hΘσ
  have hRX : (2:ℝ) ^ (-σ) = X⁻¹ := Real.rpow_neg (by norm_num) σ
  rw [hRX] at huW
  -- the mode u₁
  obtain ⟨u₁, hu₁⟩ : ∃ v : ℂ, v = um ρ₁ := ⟨_, rfl⟩
  rw [← hu₁] at hulim hune huM
  have hu₁K : u₁ ∈ K σ := by
    rw [hu₁]
    exact um_mem_K ρ₁ hρ₁.le
  have hu₁R : ‖u₁‖ < X⁻¹ := by
    rw [hu₁, norm_um, ← hRX]
    exact Real.rpow_lt_rpow_of_exponent_lt (by norm_num) (by linarith)
  have hu₁1 : ‖u₁‖ ≤ 1 := by
    rw [hu₁, norm_um]
    exact Real.rpow_le_one_of_one_le_of_nonpos (by norm_num) (by linarith [ρ₁.2.1.1])
  have hu₁0 : u₁ ≠ 0 := by
    intro h
    have := K_subset σ hu₁K
    rw [h] at this
    norm_num at this
  -- the component W
  set W := connectedComponentIn (Metric.ball (0:ℂ) X⁻¹ \ K σ) 0 with hWdef
  have hWopen : IsOpen W := (Metric.isOpen_ball.sdiff (isClosed_K σ)).connectedComponentIn
  have hWsub : W ⊆ Metric.ball (0:ℂ) X⁻¹ \ K σ := connectedComponentIn_subset _ _
  have h0 : (0:ℂ) ∈ Metric.ball (0:ℂ) X⁻¹ \ K σ := by
    refine ⟨Metric.mem_ball_self (by positivity), fun h => ?_⟩
    have := K_subset σ h
    norm_num at this
  have hGan : AnalyticOnNhd ℂ (G σ) W := by
    refine DifferentiableOn.analyticOnNhd (fun v hv => ?_) hWopen
    exact (differentiableAt_G hX hA (mem_ball_zero_iff.mp (hWsub hv).1)).differentiableWithinAt
  have hFan : AnalyticOnNhd ℂ (F σ) W := by
    refine DifferentiableOn.analyticOnNhd (fun v hv => ?_) hWopen
    exact (differentiableAt_F hσ (hWsub hv).2).differentiableWithinAt
  have hev : G σ =ᶠ[𝓝 0] F σ := by
    filter_upwards [Metric.ball_mem_nhds (0:ℂ) (by norm_num : (0:ℝ) < 1 / 4)] with v hv
    exact G_eq_F hσ (mem_ball_zero_iff.mp hv)
  have hEq : Set.EqOn (G σ) (F σ) W :=
    hGan.eqOn_of_preconnected_of_eventuallyEq hFan isPreconnected_connectedComponentIn
      (mem_connectedComponentIn h0) hev
  have huK : ∀ j, u j ∉ K σ := fun j => (hWsub (huW j)).2
  have hne : ∀ j, u₁ - u j ≠ 0 := fun j => sub_ne_zero.mpr (hune j).symm
  -- (u₁ − u_j)·G(u_j) → 0
  have hGc : ContinuousAt (G σ) u₁ := (differentiableAt_G hX hA hu₁R).continuousAt
  have hlimG : Tendsto (fun j => (u₁ - u j) * G σ (u j)) atTop (𝓝 0) := by
    have h : ContinuousAt (fun v => (u₁ - v) * G σ v) u₁ :=
      ContinuousAt.mul (by fun_prop) hGc
    have h' : Tendsto (fun v => (u₁ - v) * G σ v) (𝓝 u₁) (𝓝 ((u₁ - u₁) * G σ u₁)) := h
    rw [sub_self, zero_mul] at h'
    exact h'.comp hulim
  -- (u₁ − u_j)·F(u_j) → u₁·Σ_fibre m(ρ)/ρ
  set g : FilterAttained.S σ → ℂ := fun ρ =>
    (if um ρ.1 = u₁ then LadderMean.coef ρ.1 else 0) * u₁ with hg
  have hlimF : Tendsto (fun j => ∑' ρ : FilterAttained.S σ,
      (u₁ - u j) * (LadderMean.coef ρ.1 / (1 - (2:ℂ) ^ (ρ.1 : ℂ) * u j))) atTop
      (𝓝 (∑' ρ, g ρ)) := by
    refine tendsto_tsum_of_dominated_convergence ((summable_coef hσ).mul_left (|M| + 1))
      (fun ρ => ?_) ?_
    · by_cases hfib : um ρ.1 = u₁
      · have hgρ : g ρ = LadderMean.coef ρ.1 * u₁ := by simp only [hg, if_pos hfib]
        rw [hgρ]
        refine tendsto_const_nhds.congr (fun j => ?_)
        rw [one_sub_eq, hfib, fibre_term (hne j) (mode_ne_zero ρ.1), ← um_eq, hfib]
      · have hgρ : g ρ = 0 := by simp only [hg, if_neg hfib, zero_mul]
        rw [hgρ]
        have hd : 1 - (2:ℂ) ^ (ρ.1 : ℂ) * u₁ ≠ 0 := by
          have h1 : 0 < ‖um ρ.1 - u₁‖ := norm_pos_iff.mpr (sub_ne_zero.mpr hfib)
          exact norm_pos_iff.mp (h1.trans_le (norm_sub_le ρ.1 u₁))
        have hc : ContinuousAt (fun v => (u₁ - v) *
            (LadderMean.coef ρ.1 / (1 - (2:ℂ) ^ (ρ.1 : ℂ) * v))) u₁ :=
          ContinuousAt.mul (by fun_prop) (ContinuousAt.div (by fun_prop) (by fun_prop) hd)
        have h' : Tendsto (fun v => (u₁ - v) *
            (LadderMean.coef ρ.1 / (1 - (2:ℂ) ^ (ρ.1 : ℂ) * v))) (𝓝 u₁)
            (𝓝 ((u₁ - u₁) * (LadderMean.coef ρ.1 / (1 - (2:ℂ) ^ (ρ.1 : ℂ) * u₁)))) := hc
        rw [sub_self, zero_mul] at h'
        exact h'.comp hulim
    · refine Filter.Eventually.of_forall (fun j ρ => ?_)
      by_cases hfib : um ρ.1 = u₁
      · rw [one_sub_eq, hfib, fibre_term (hne j) (mode_ne_zero ρ.1), ← um_eq, hfib, norm_mul]
        calc ‖LadderMean.coef ρ.1‖ * ‖u₁‖ ≤ ‖LadderMean.coef ρ.1‖ :=
              mul_le_of_le_one_right (norm_nonneg _) hu₁1
          _ ≤ (|M| + 1) * ‖LadderMean.coef ρ.1‖ :=
              le_mul_of_one_le_left (norm_nonneg _) (by linarith [abs_nonneg M])
      · have hd0 : 0 < ‖um ρ.1 - u j‖ := by
          refine norm_pos_iff.mpr (sub_ne_zero.mpr fun h => huK j ?_)
          rw [← h]
          exact um_mem_K ρ.1 ρ.2
        have hD := norm_sub_le ρ.1 (u j)
        have hMj := huM j ρ.1 ρ.2 hfib
        rw [norm_mul, norm_div, norm_sub_rev u₁ (u j)]
        calc ‖u j - u₁‖ * (‖LadderMean.coef ρ.1‖ / ‖1 - (2:ℂ) ^ (ρ.1 : ℂ) * u j‖)
            ≤ ‖u j - u₁‖ * (‖LadderMean.coef ρ.1‖ / ‖um ρ.1 - u j‖) :=
              mul_le_mul_of_nonneg_left
                (div_le_div_of_nonneg_left (norm_nonneg _) hd0 hD) (norm_nonneg _)
          _ = ‖LadderMean.coef ρ.1‖ * (‖u j - u₁‖ / ‖um ρ.1 - u j‖) := by ring
          _ ≤ ‖LadderMean.coef ρ.1‖ * M :=
              mul_le_mul_of_nonneg_left ((div_le_iff₀ hd0).mpr hMj) (norm_nonneg _)
          _ ≤ (|M| + 1) * ‖LadderMean.coef ρ.1‖ := by
              rw [mul_comm]
              exact mul_le_mul_of_nonneg_right (by linarith [le_abs_self M]) (norm_nonneg _)
  have hFG : ∀ j, (u₁ - u j) * G σ (u j) = ∑' ρ : FilterAttained.S σ,
      (u₁ - u j) * (LadderMean.coef ρ.1 / (1 - (2:ℂ) ^ (ρ.1 : ℂ) * u j)) := by
    intro j
    rw [hEq (huW j), ResidueRoute.F, tsum_mul_left]
  have hzero : ∑' ρ, g ρ = 0 := tendsto_nhds_unique hlimF (hlimG.congr hFG)
  -- the fibre's weight is zero, against positive real parts
  set h : FilterAttained.S σ → ℂ := fun ρ =>
    if um ρ.1 = u₁ then LadderMean.coef ρ.1 else 0 with hhdef
  have hs : Summable h := Summable.of_norm_bounded (summable_coef hσ) (fun ρ => by
    simp only [hhdef]
    split_ifs
    · exact le_rfl
    · rw [norm_zero]
      exact norm_nonneg _)
  have hgh : ∑' ρ, g ρ = (∑' ρ, h ρ) * u₁ := by
    rw [← tsum_mul_right]
  have hh0 : ∑' ρ, h ρ = 0 := by
    rw [hgh] at hzero
    exact (mul_eq_zero.mp hzero).resolve_right hu₁0
  have hre := Complex.re_tsum hs
  rw [hh0, Complex.zero_re] at hre
  have hnn : ∀ ρ, 0 ≤ (h ρ).re := fun ρ => by
    simp only [hhdef]
    split_ifs
    · exact (AliasClass.re_order_div_pos ρ.1).le
    · rw [Complex.zero_re]
  have hpos : 0 < ∑' ρ, (h ρ).re := by
    refine Summable.tsum_pos (Complex.hasSum_re hs.hasSum).summable hnn ⟨ρ₁, hρ₁.le⟩ ?_
    simp only [hhdef]
    rw [if_pos hu₁.symm]
    exact AliasClass.re_order_div_pos ρ₁
  linarith

/-- **Isolation and the frontier give a reach, with `M = 1`.** If `u₁ = 2^(−ρ₁)`,
`Re ρ₁ ≥ σ`, is isolated in `K σ` and on the frontier of the component of `0` in
`{|u| < 2^(−σ)} ∖ K σ`, a sequence of the component tending to `u₁`, cut to its terms
within `ε/2` of `u₁`, reaches `ρ₁` with `M = 1`. -/
theorem reach_of_isolated {σ : ℝ} {ρ₁ : Kadiri.NontrivialZeros} (hρ₁ : σ ≤ (ρ₁ : ℂ).re)
    (hiso : ∃ ε : ℝ, 0 < ε ∧
      ∀ u ∈ K σ, ‖u - (2:ℂ) ^ (-(ρ₁ : ℂ))‖ < ε → u = (2:ℂ) ^ (-(ρ₁ : ℂ)))
    (hfr : (2:ℂ) ^ (-(ρ₁ : ℂ)) ∈
      frontier (connectedComponentIn (Metric.ball (0:ℂ) ((2:ℝ) ^ (-σ)) \ K σ) 0)) :
    ∃ (u : ℕ → ℂ) (M : ℝ),
      (∀ j, u j ∈ connectedComponentIn (Metric.ball (0:ℂ) ((2:ℝ) ^ (-σ)) \ K σ) 0) ∧
      Tendsto u atTop (𝓝 (um ρ₁)) ∧
      (∀ j, u j ≠ um ρ₁) ∧
      (∀ j, ∀ ρ : Kadiri.NontrivialZeros, σ ≤ (ρ : ℂ).re → um ρ ≠ um ρ₁ →
        ‖u j - um ρ₁‖ ≤ M * ‖um ρ - u j‖) := by
  obtain ⟨ε, hε, hiso⟩ := hiso
  set W := connectedComponentIn (Metric.ball (0:ℂ) ((2:ℝ) ^ (-σ)) \ K σ) 0 with hWdef
  have hWsub : W ⊆ Metric.ball (0:ℂ) ((2:ℝ) ^ (-σ)) \ K σ := connectedComponentIn_subset _ _
  have hu₁K : um ρ₁ ∈ K σ := um_mem_K ρ₁ hρ₁
  obtain ⟨v, hvW, hv⟩ := mem_closure_iff_seq_limit.mp (frontier_subset_closure hfr)
  obtain ⟨N, hN⟩ := Metric.tendsto_atTop.mp hv (ε / 2) (by positivity)
  refine ⟨fun j => v (j + N), 1, fun j => hvW (j + N), ?_, fun j h => ?_, ?_⟩
  · exact (tendsto_add_atTop_iff_nat N).mpr hv
  · have h' : v (j + N) = um ρ₁ := h
    exact (hWsub (hvW (j + N))).2 (by rw [h']; exact hu₁K)
  · intro j ρ hρ hne
    have hclose : ‖v (j + N) - um ρ₁‖ < ε / 2 := by
      have := hN (j + N) (by omega)
      rwa [dist_eq_norm] at this
    have hfar : ε ≤ ‖um ρ - um ρ₁‖ :=
      not_lt.mp fun h => hne (hiso _ (um_mem_K ρ hρ) h)
    have htri := norm_sub_le_norm_sub_add_norm_sub (um ρ) (v (j + N)) (um ρ₁)
    rw [one_mul]
    linarith

/-- **S4's statement from S6.** `ResidueRoute.isolated_boundary_mode_false`, read off
`reached_mode_false` through `reach_of_isolated`. -/
theorem isolated_boundary_mode_false' {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    {σ₀ Θ : ℝ} (hσ₀ : 1 / 2 < σ₀) (hσ₀Θ : σ₀ < Θ) (hΘ1 : Θ ≤ 1)
    (hΘ : ∀ ρ : Kadiri.NontrivialZeros, (ρ : ℂ).re ≤ Θ) :
    ∃ E : ℝ, σ₀ ≤ E ∧ E < Θ ∧ ∀ σ : ℝ, E ≤ σ →
      ∀ ρ₁ : Kadiri.NontrivialZeros, σ < (ρ₁ : ℂ).re →
      (∃ ε : ℝ, 0 < ε ∧ ∀ u ∈ K σ, ‖u - (2:ℂ) ^ (-(ρ₁ : ℂ))‖ < ε → u = (2:ℂ) ^ (-(ρ₁ : ℂ))) →
      (2:ℂ) ^ (-(ρ₁ : ℂ)) ∈
        frontier (connectedComponentIn (Metric.ball (0:ℂ) ((2:ℝ) ^ (-σ)) \ K σ) 0) →
      False := by
  obtain ⟨E, hσ₀E, hEΘ, hE⟩ := reached_mode_false hH hσ₀ hσ₀Θ hΘ1 hΘ
  exact ⟨E, hσ₀E, hEΘ, fun σ hσ ρ₁ hρ₁ hiso hfr =>
    hE σ hσ ρ₁ hρ₁ (reach_of_isolated hρ₁.le hiso hfr)⟩

/-- info: 'ReachRoute.reached_mode_false' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms reached_mode_false

/-- info: 'ReachRoute.reach_of_isolated' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms reach_of_isolated

/-- info: 'ReachRoute.isolated_boundary_mode_false'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms isolated_boundary_mode_false'

end

end ReachRoute
```
