/-
ArgCount — block `hnt.md#H3` of `lean_stage3/design/hnt.md`, "The assembly:
StmtSCrude argS, good heights by the identity, bad heights by a good one
beside them".

At a good height `T ≥ 2` — one with no zero of `ζ` of positive real part on
the line `Im s = T` — the argument identity turns `argS T` into
`zetaArgContour T`, and H1's leg bound with H2's `Finset` of zeros of `Re ζ`
on the cut gives `|argS T| ≤ 15 log T + 73 + 3/2`. At a bad height `T₀ > 2`
the identity is unavailable, so a good height `T` just below is taken: the
zeros of positive height below `T₀` are finitely many, so `N T = N T₀`, and
`phaseTheta` is an integral of a continuous integrand, so it moves by at most
`π/2` over a short enough interval — the difference costs `1/2` and the bound
becomes `15 log T₀ + 75`. At `T₀ = 2` there is no good height below inside
`2 ≤ T`, so a good `T' ∈ (2, 3)` above is used with `N` monotone and the
Stirling phase bound, giving the single-point constant `600`.

The theorems, hypotheses copied from the block's Theorems lines:

  argS_le_of_good            C1 (hT : 2 ≤ T), good T
  N_eq_sum                   none
  N_nonneg                   none
  N_mono                     (h : T ≤ T')
  N_eq_of_no_zero_between    (hle : T ≤ T₀), no zero with Im ∈ Ico T T₀
  exists_good_below          (ha : 0 ≤ a), (hlt : a < T₀)
  phasePoint_bound_near      none
  phaseTheta_sub_le          (hle : T ≤ T₀), (h1 : T₀ ≤ T + 1), the bound hM
  argS_le_gt_two             (hT : 2 < T)
  mainTerm_abs_le            (h2 : 2 ≤ T), (h3 : T ≤ 3)
  argS_two_le                none
  sCrude_holds_of_good_two   good 2
  sCrude_holds               none
  rvM_crude_of_good_two      good 2
  rvM_crude                  none

Pins: argS_le_of_good, argS_le_gt_two, sCrude_holds, sCrude_holds_of_good_two,
rvM_crude, rvM_crude_of_good_two.

Composed, from the block's Composes line: `Stage3.argS`,
`Stage3.argS_eq_zetaArgContour`, `Stage3.phaseTheta`, `Stage3.phasePoint`,
`Stage3.continuous_phasePoint`, `Stage3.intervalIntegrable_phasePoint`,
`Stage3.StmtSCrude`, `Stage3.backlundPhase_holds`,
`Stage3.stmtArgIdentity_holds`, `Stage3.backlundArg_of_identity`,
`Stage3.RvM_of_phase_arg`; H1's `ArgLegs.zetaArgContour_le`; H2's
`ReZetaCount.re_zeta_two_line_pos`, `ReZetaCount.reZeros`,
`ReZetaCount.mem_reZeros`, `ReZetaCount.card_reZeros_le`; upstream's
`Kadiri.zeroes_rect_univ_positive_height_finite`,
`Kadiri.riemannZeta_one_le_order_positiveHeightZero`,
`Kadiri.zetaCountingMainTerm`, `riemannZeta.N`, `riemannZeta.zeroes_sum`,
`riemannZeta.zeroes_rect`, `riemannZeta.order`. The `Kadiri.*` names resolve
through `Stage3.ArgLegs → Stage3.ArgIdentity`, which imports
`PrimeNumberTheoremAnd.IEANTN.KadiriZeroCounting`, so no import is added.

What the next slice needs: `good 2` — no zero of `ζ` with `0 < Re ρ` and
`Im ρ = 2` — which turns the `600` into a `75` and the band `112 0 698` into
`112 0 173`; and the Stirling half's `97`, which is what the band's `112`
would have to give back to reach entry 130's budget of `100`.
-/
import Stage3.ArgLegs
import Stage3.ReZetaCount

namespace ArgCount

noncomputable section

/-- A height with no zero of `ζ` of positive real part on it. -/
def good (T : ℝ) : Prop := ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → ρ.im ≠ T

/-- **The good heights.** The identity plus H1's legs and H2's count. -/
theorem argS_le_of_good {T : ℝ} (hT : 2 ≤ T) (hg : good T) :
    |Stage3.argS T| ≤ 15 * Real.log T + 73 + 3 / 2 := by
  rw [Stage3.argS_eq_zetaArgContour hT hg]
  have hcon := ArgLegs.zetaArgContour_le hT
    (fun t _ => ReZetaCount.re_zeta_two_line_pos t)
    (by
      intro x hx h0
      exact hg _ h0 (by simp; linarith [hx.1]) (by simp))
    (ReZetaCount.reZeros hT)
    (fun x hx h0 => (ReZetaCount.mem_reZeros hT).2 ⟨hx, h0⟩)
  have hcard := ReZetaCount.card_reZeros_le hT
  linarith

/-- `N T` as the finite sum of orders over the zero rectangle. -/
theorem N_eq_sum (T : ℝ) : riemannZeta.N T
    = ∑ z ∈ (Kadiri.zeroes_rect_univ_positive_height_finite T).toFinset,
        (1 : ℝ) * (riemannZeta.order z : ℝ) := by
  rw [riemannZeta.N, riemannZeta.zeroes_sum,
    ← Finset.tsum_subtype' (Kadiri.zeroes_rect_univ_positive_height_finite T).toFinset
      (fun z => (1 : ℝ) * (riemannZeta.order z : ℝ)),
    (Kadiri.zeroes_rect_univ_positive_height_finite T).coe_toFinset]

/-- Every order is at least one, so the count is nonnegative. -/
theorem N_nonneg (T : ℝ) : 0 ≤ riemannZeta.N T := by
  rw [N_eq_sum T]
  refine Finset.sum_nonneg fun z hz => ?_
  have h1 : (1 : ℤ) ≤ riemannZeta.order z :=
    Kadiri.riemannZeta_one_le_order_positiveHeightZero
      ⟨z, (Kadiri.zeroes_rect_univ_positive_height_finite T).mem_toFinset.1 hz⟩
  have h2 : (1 : ℝ) ≤ (riemannZeta.order z : ℝ) := by exact_mod_cast h1
  linarith

/-- The count is monotone in the height. -/
theorem N_mono {T T' : ℝ} (h : T ≤ T') : riemannZeta.N T ≤ riemannZeta.N T' := by
  rw [N_eq_sum T, N_eq_sum T']
  refine Finset.sum_le_sum_of_subset_of_nonneg ?_ ?_
  · refine Set.Finite.toFinset_subset_toFinset.2 ?_
    intro ρ hρ
    simp only [riemannZeta.zeroes_rect, riemannZeta.zeroes, Set.mem_setOf_eq, Set.mem_Ioo,
      Set.mem_univ, true_and] at hρ ⊢
    exact ⟨⟨hρ.1.1, lt_of_lt_of_le hρ.1.2 h⟩, hρ.2⟩
  · intro z hz _
    have h1 : (1 : ℤ) ≤ riemannZeta.order z :=
      Kadiri.riemannZeta_one_le_order_positiveHeightZero
        ⟨z, (Kadiri.zeroes_rect_univ_positive_height_finite T').mem_toFinset.1 hz⟩
    have h2 : (1 : ℝ) ≤ (riemannZeta.order z : ℝ) := by exact_mod_cast h1
    linarith

/-- No zero with imaginary part in `[T, T₀)` means the count does not move. -/
theorem N_eq_of_no_zero_between {T T₀ : ℝ} (hle : T ≤ T₀)
    (hno : ∀ ρ : ℂ, riemannZeta ρ = 0 → ρ.im ∈ Set.Ico T T₀ → False) :
    riemannZeta.N T = riemannZeta.N T₀ := by
  have hset : riemannZeta.zeroes_rect Set.univ (Set.Ioo 0 T)
      = riemannZeta.zeroes_rect Set.univ (Set.Ioo 0 T₀) := by
    ext ρ
    simp only [riemannZeta.zeroes_rect, riemannZeta.zeroes, Set.mem_setOf_eq, Set.mem_Ioo,
      Set.mem_univ, true_and]
    constructor
    · rintro ⟨h1, h2⟩
      exact ⟨⟨h1.1, lt_of_lt_of_le h1.2 hle⟩, h2⟩
    · rintro ⟨h1, h2⟩
      refine ⟨⟨h1.1, ?_⟩, h2⟩
      rcases lt_or_ge ρ.im T with h | h
      · exact h
      · exact (hno ρ h2 ⟨h, h1.2⟩).elim
  unfold riemannZeta.N riemannZeta.zeroes_sum
  rw [hset]

/-- Below any height there is a good height with no zero between the two. -/
theorem exists_good_below {a T₀ : ℝ} (ha : 0 ≤ a) (hlt : a < T₀) :
    ∃ T : ℝ, a < T ∧ T < T₀ ∧ good T ∧
      ∀ ρ : ℂ, riemannZeta ρ = 0 → ρ.im ∈ Set.Ico T T₀ → False := by
  classical
  have hfin := Kadiri.zeroes_rect_univ_positive_height_finite T₀
  obtain ⟨F, hFa, hFmem, hFlt⟩ :
      ∃ F : Finset ℝ, a ∈ F ∧
        (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.im → ρ.im < T₀ → ρ.im ∈ F) ∧
        ∀ y ∈ F, y < T₀ := by
    refine ⟨insert a (hfin.toFinset.image Complex.im), Finset.mem_insert_self _ _, ?_, ?_⟩
    · intro ρ h0 h1 h2
      refine Finset.mem_insert_of_mem (Finset.mem_image_of_mem Complex.im ?_)
      refine hfin.mem_toFinset.2 ?_
      simp only [riemannZeta.zeroes_rect, riemannZeta.zeroes, Set.mem_setOf_eq, Set.mem_Ioo,
        Set.mem_univ, true_and]
      exact ⟨⟨h1, h2⟩, h0⟩
    · intro y hy
      rcases Finset.mem_insert.1 hy with rfl | hy
      · exact hlt
      · obtain ⟨ρ, hρ, rfl⟩ := Finset.mem_image.1 hy
        have hρ' := hfin.mem_toFinset.1 hρ
        simp only [riemannZeta.zeroes_rect, riemannZeta.zeroes, Set.mem_setOf_eq, Set.mem_Ioo,
          Set.mem_univ, true_and] at hρ'
        exact hρ'.1.2
  have hFne : F.Nonempty := ⟨a, hFa⟩
  have hmlt : F.max' hFne < T₀ := (Finset.max'_lt_iff F hFne).2 hFlt
  have hma : a ≤ F.max' hFne := Finset.le_max' F a hFa
  refine ⟨(F.max' hFne + T₀) / 2, by linarith, by linarith, ?_, ?_⟩
  · intro ρ h0 _ him
    have hle := Finset.le_max' F ρ.im (hFmem ρ h0 (by linarith) (by linarith))
    linarith
  · intro ρ h0 hIco
    have hle := Finset.le_max' F ρ.im (hFmem ρ h0 (by linarith [hIco.1]) hIco.2)
    linarith [hIco.1]

/-- The phase integrand is bounded on the unit interval below any height. -/
theorem phasePoint_bound_near (T₀ : ℝ) :
    ∃ M : ℝ, 0 ≤ M ∧ ∀ t ∈ Set.Icc (T₀ - 1) T₀, |Stage3.phasePoint t| ≤ M := by
  obtain ⟨C, hC⟩ := (isCompact_Icc (a := T₀ - 1) (b := T₀)).exists_bound_of_continuousOn
    Stage3.continuous_phasePoint.continuousOn
  refine ⟨max C 0, le_max_right _ _, fun t ht => ?_⟩
  have h := hC t ht
  rw [Real.norm_eq_abs] at h
  exact h.trans (le_max_left _ _)

/-- The phase moves by at most the length times the integrand bound. -/
theorem phaseTheta_sub_le {T T₀ M : ℝ} (hle : T ≤ T₀) (h1 : T₀ ≤ T + 1)
    (hM : ∀ t ∈ Set.Icc (T₀ - 1) T₀, |Stage3.phasePoint t| ≤ M) :
    |Stage3.phaseTheta T₀ - Stage3.phaseTheta T|
      ≤ (T₀ - T) * (M / 2 + Real.log Real.pi / 2) := by
  have hsub : (∫ t in (0:ℝ)..T₀, Stage3.phasePoint t)
      - (∫ t in (0:ℝ)..T, Stage3.phasePoint t) = ∫ t in T..T₀, Stage3.phasePoint t :=
    intervalIntegral.integral_interval_sub_left
      (Stage3.intervalIntegrable_phasePoint 0 T₀) (Stage3.intervalIntegrable_phasePoint 0 T)
  have hbound : ‖∫ t in T..T₀, Stage3.phasePoint t‖ ≤ M * |T₀ - T| := by
    refine intervalIntegral.norm_integral_le_of_norm_le_const ?_
    intro t ht
    rw [Set.uIoc_of_le hle, Set.mem_Ioc] at ht
    rw [Real.norm_eq_abs]
    exact hM t ⟨by linarith [ht.1], ht.2⟩
  rw [Real.norm_eq_abs, abs_of_nonneg (by linarith : (0:ℝ) ≤ T₀ - T)] at hbound
  have hkey : Stage3.phaseTheta T₀ - Stage3.phaseTheta T
      = (1/2) * ((∫ t in (0:ℝ)..T₀, Stage3.phasePoint t)
        - (∫ t in (0:ℝ)..T, Stage3.phasePoint t)) - (T₀ - T)/2 * Real.log Real.pi := by
    unfold Stage3.phaseTheta; ring
  rw [hkey, hsub, abs_le]
  have h2 := abs_le.1 hbound
  constructor
  · linarith [h2.1, h2.2]
  · -- the certificate needs `0 ≤ (T₀ - T) * log π`: the product of the two signs
    have hlogpi : 0 ≤ Real.log Real.pi := Real.log_nonneg (by linarith [Real.pi_gt_three])
    have hprod : 0 ≤ (T₀ - T) * Real.log Real.pi :=
      mul_nonneg (by linarith) hlogpi
    nlinarith [h2.1, h2.2, hprod]

/-- **The bad heights above 2.** A good height just below, with the count
equal and the phase moving by at most `π/2`. -/
theorem argS_le_gt_two {T : ℝ} (hT : 2 < T) : |Stage3.argS T| ≤ 15 * Real.log T + 75 := by
  obtain ⟨M, hM0, hM⟩ := phasePoint_bound_near T
  have hpi : (0:ℝ) < Real.pi := Real.pi_pos
  have hlogpi : 0 < Real.log Real.pi := Real.log_pos (by linarith [Real.pi_gt_three])
  have hden : 0 < M + Real.log Real.pi + 1 := by linarith
  have hδpos : 0 < min 1 (Real.pi / (M + Real.log Real.pi + 1)) :=
    lt_min one_pos (div_pos hpi hden)
  have hδle1 : min 1 (Real.pi / (M + Real.log Real.pi + 1)) ≤ 1 := min_le_left _ _
  have hδle : min 1 (Real.pi / (M + Real.log Real.pi + 1))
      ≤ Real.pi / (M + Real.log Real.pi + 1) := min_le_right _ _
  obtain ⟨T', ha, hlt, hg, hno⟩ :=
    exists_good_below (a := max 2 (T - min 1 (Real.pi / (M + Real.log Real.pi + 1)))) (T₀ := T)
      (le_max_of_le_left (by norm_num)) (max_lt hT (by linarith))
  have hT'2 : (2:ℝ) ≤ T' := le_of_lt (lt_of_le_of_lt (le_max_left _ _) ha)
  have hgap : T - T' < min 1 (Real.pi / (M + Real.log Real.pi + 1)) := by
    have hr := le_max_right 2 (T - min 1 (Real.pi / (M + Real.log Real.pi + 1)))
    linarith
  have hN : riemannZeta.N T' = riemannZeta.N T := N_eq_of_no_zero_between hlt.le hno
  have hθ := phaseTheta_sub_le (T := T') (T₀ := T) (M := M) hlt.le (by linarith) hM
  have hb2 : (T - T') * (M + Real.log Real.pi + 1) ≤ Real.pi := by
    rw [← le_div_iff₀ hden]
    linarith
  have hhalf : (T - T') * (M / 2 + Real.log Real.pi / 2) ≤ Real.pi / 2 := by
    nlinarith [hb2, hM0, hlogpi, hpi, hlt]
  have hdiv := abs_le.1 (hθ.trans hhalf)
  have hq1 : (Stage3.phaseTheta T - Stage3.phaseTheta T') / Real.pi ≤ 1/2 := by
    rw [div_le_iff₀ hpi]; linarith [hdiv.2]
  have hq2 : -(1/2 : ℝ) ≤ (Stage3.phaseTheta T - Stage3.phaseTheta T') / Real.pi := by
    rw [le_div_iff₀ hpi]; linarith [hdiv.1]
  have hargdiff : Stage3.argS T
      = Stage3.argS T' - (Stage3.phaseTheta T - Stage3.phaseTheta T') / Real.pi := by
    unfold Stage3.argS
    rw [← hN]
    ring
  have hlog : Real.log T' ≤ Real.log T := Real.log_le_log (by linarith) hlt.le
  have hgood := abs_le.1 (argS_le_of_good hT'2 hg)
  rw [abs_le]
  constructor
  · linarith [hgood.1, hgood.2]
  · linarith [hgood.1, hgood.2]

/-- The RvM main term is small on `[2, 3]`. -/
theorem mainTerm_abs_le {T : ℝ} (h2 : 2 ≤ T) (h3 : T ≤ 3) :
    |Kadiri.zetaCountingMainTerm T| ≤ 3 := by
  have hpi := Real.pi_gt_three
  have hu0 : 0 < T / (2 * Real.pi) := div_pos (by linarith) (by linarith)
  have hu : T / (2 * Real.pi) ≤ 1/2 := by
    rw [div_le_iff₀ (by linarith)]; linarith
  have hlog : Real.log (T / (2 * Real.pi)) ≤ 0 := Real.log_nonpos hu0.le (by linarith)
  have hkey : -(T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))) ≤ 1 - T / (2 * Real.pi) := by
    have h := Real.log_le_sub_one_of_pos (inv_pos.2 hu0)
    rw [Real.log_inv] at h
    have h' := mul_le_mul_of_nonneg_left h hu0.le
    have hinv : T / (2 * Real.pi) * (T / (2 * Real.pi))⁻¹ = 1 := mul_inv_cancel₀ (ne_of_gt hu0)
    nlinarith [h', hinv]
  rw [Kadiri.zetaCountingMainTerm, abs_le]
  constructor
  · nlinarith [hkey, hu0, mul_nonneg hu0.le (neg_nonneg.2 hlog)]
  · nlinarith [hkey, hu0, mul_nonneg hu0.le (neg_nonneg.2 hlog)]

/-- **The single point `T = 2`.** A good height just above, with the count
monotone and the Stirling phase bound. -/
theorem argS_two_le : |Stage3.argS 2| ≤ 15 * Real.log 2 + 600 := by
  obtain ⟨T', h2, h3, hg, -⟩ := exists_good_below (a := (2:ℝ)) (T₀ := (3:ℝ))
    (by norm_num) (by norm_num)
  have hT'2 : (2:ℝ) ≤ T' := h2.le
  have hN' : riemannZeta.N T' = Stage3.argS T' + (Stage3.phaseTheta T' / Real.pi + 1) := by
    unfold Stage3.argS; ring
  have hN2' : riemannZeta.N 2 = Stage3.argS 2 + (Stage3.phaseTheta 2 / Real.pi + 1) := by
    unfold Stage3.argS; ring
  have hph := abs_le.1 (Stage3.backlundPhase_holds T' hT'2)
  have hph2 := abs_le.1 (Stage3.backlundPhase_holds 2 le_rfl)
  have hmain := abs_le.1 (mainTerm_abs_le hT'2 h3.le)
  have hmain2 := abs_le.1 (mainTerm_abs_le (le_refl (2:ℝ)) (by norm_num))
  have hgood := abs_le.1 (argS_le_of_good hT'2 hg)
  have hlogT' : Real.log T' ≤ 2 :=
    le_trans (Real.log_le_sub_one_of_pos (by linarith)) (by linarith)
  have hlogT'n : 0 ≤ Real.log T' := Real.log_nonneg (by linarith)
  have hlog2 : Real.log 2 ≤ 1 :=
    le_trans (Real.log_le_sub_one_of_pos (by norm_num)) (by norm_num)
  have hlog2n : (0:ℝ) ≤ Real.log 2 := Real.log_nonneg (by norm_num)
  have hN2 := N_nonneg 2
  have hNm := N_mono hT'2
  rw [abs_le]
  constructor
  · linarith [hph.1, hph.2, hph2.1, hph2.2, hmain.1, hmain.2, hmain2.1, hmain2.2,
      hgood.1, hgood.2]
  · linarith [hph.1, hph.2, hph2.1, hph2.2, hmain.1, hmain.2, hmain2.1, hmain2.2,
      hgood.1, hgood.2]

/-- **StmtSCrude under `good 2`**: `|argS T| ≤ 15 log T + 75`. -/
theorem sCrude_holds_of_good_two (h2 : good 2) : Stage3.StmtSCrude Stage3.argS 15 75 := by
  intro T hT
  rcases hT.lt_or_eq with hlt | rfl
  · exact argS_le_gt_two hlt
  · have h := argS_le_of_good (le_refl (2:ℝ)) h2
    linarith

/-- **StmtSCrude unconditionally**: `|argS T| ≤ 15 log T + 600`. -/
theorem sCrude_holds : Stage3.StmtSCrude Stage3.argS 15 600 := by
  intro T hT
  rcases hT.lt_or_eq with hlt | rfl
  · have h := argS_le_gt_two hlt
    have h0 : 0 ≤ Real.log T := Real.log_nonneg (by linarith)
    linarith
  · exact argS_two_le

/-- **The crude hNT band under `good 2`.** -/
theorem rvM_crude_of_good_two (h2 : good 2) :
    riemannZeta.Riemann_vonMangoldt_bound 112 0 173 := by
  have h := Stage3.RvM_of_phase_arg Stage3.backlundPhase_holds
    (Stage3.backlundArg_of_identity Stage3.stmtArgIdentity_holds (sCrude_holds_of_good_two h2))
  norm_num at h
  exact h

/-- **The crude hNT band, unconditional.** -/
theorem rvM_crude : riemannZeta.Riemann_vonMangoldt_bound 112 0 698 := by
  have h := Stage3.RvM_of_phase_arg Stage3.backlundPhase_holds
    (Stage3.backlundArg_of_identity Stage3.stmtArgIdentity_holds sCrude_holds)
  norm_num at h
  exact h

/-- info: 'ArgCount.argS_le_of_good' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms argS_le_of_good

/-- info: 'ArgCount.argS_le_gt_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms argS_le_gt_two

/-- info: 'ArgCount.sCrude_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sCrude_holds

/-- info: 'ArgCount.sCrude_holds_of_good_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sCrude_holds_of_good_two

/-- info: 'ArgCount.rvM_crude' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rvM_crude

/-- info: 'ArgCount.rvM_crude_of_good_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rvM_crude_of_good_two

end

end ArgCount
