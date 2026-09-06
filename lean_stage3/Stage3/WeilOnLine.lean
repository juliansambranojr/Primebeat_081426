/-
WeilOnLine — the on-line background, all heights. Rung 4b, second half,
slice B3 of the detection ladder (units 0316–0323). 2026-09-06.

Unit 0323 bounds the weighted on-line sum over heights `≥ 11/10` by
`B h γ = A h γ·π²/6`. The count's window reaches no lower, and only
positive heights. This slice closes the other two ranges and assembles:

  Psi_neg, term_conj, conjZ, weightedTerm_conjZ
      `Ψ` is odd, so the on-line term is invariant under conjugation of
      the zero; conjugates of nontrivial zeros are nontrivial zeros
      (`riemannZeta_conj`); the multiplicity is conjugation-symmetric
      (upstream `Kadiri.riemannZeta_order_conj`). Hence the weighted term
      is conjugation-invariant.
  sum_lower_le
      a finite set of on-line zeros of height `≤ −11/10` conjugates,
      injectively, to one of height `≥ 11/10`, so its weighted sum is at
      most `B h γ` too.
  lowSet_finite, lowCount, sum_low_le
      the on-line zeros of height `|t| ≤ 11/10` are finite: an accumulation
      point on the compact segment would force `ζ ≡ 0` on the half-plane
      `Re z < 3/4` (convex, so preconnected; `ζ` analytic there, the pole at
      `1` excluded), against `ζ(0) = −1/2`. Their total multiplicity is
      `lowCount`, carried by name: its value is a computation this ladder
      does not make (it is `0`; the first zero has height above `14`).
      Each low term is at most `4h²` (unit 0320), so the low sum is at most
      `4h²·lowCount`.
  sum_onLine_le, tsum_onLine_le, summable_onLine
      the full weighted sum over all on-line zeros is at most
      `onLineBound h γ = 2·B h γ + 4h²·lowCount`, for `h > 0`, `γ ≥ 11/10`,
      and the on-line series is summable.
  onLineBound_le
      in `γ` and `h` alone:
      `≤ 2·88·(γ+3)⁴·(4h² + cFar/h²)·π²/6 + 4h²·lowCount`.

This closes rung 4b: the on-line background is bounded, explicitly, by a
quantity that grows as `h²` while rung 5's main term grows as `h⁴`.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilSeries

namespace WeilOnLine

noncomputable section

open Complex WeilDetect WeilBackground WeilBands WeilTiles WeilSeries Real

/-- `Ψ` is odd. -/
theorem Psi_neg (s : ℝ) : WeilTransform.Psi (-s) = -WeilTransform.Psi s := by
  unfold WeilTransform.Psi
  rw [← intervalIntegral.integral_neg]
  apply intervalIntegral.integral_congr
  intro x _
  simp only [neg_mul, Real.sin_neg, mul_neg]

/-- The on-line term is invariant under conjugation of the zero. -/
theorem term_conj {h : ℝ} (hh : 0 < h) (γ : ℝ) {ρ : ℂ} (hρ : ρ.re = 1 / 2) :
    (laplace (phiC h γ) (-(starRingEnd ℂ) ρ)
        * laplace (phiC h γ) (-(1 - (starRingEnd ℂ) ρ))).re
      = (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re := by
  have hρ' : ((starRingEnd ℂ) ρ).re = 1 / 2 := by simp [hρ]
  rw [online_term_eq hh γ hρ', online_term_eq hh γ hρ, Complex.ofReal_re, Complex.ofReal_re]
  simp only [Complex.conj_im]
  have e1 : h * (-ρ.im + γ) = -(h * (ρ.im - γ)) := by ring
  have e2 : h * (-ρ.im - γ) = -(h * (ρ.im + γ)) := by ring
  rw [e1, e2, Psi_neg, Psi_neg]
  ring

/-- Conjugates of nontrivial zeros are nontrivial zeros. -/
theorem conj_mem (ρ : Kadiri.NontrivialZeros) :
    (starRingEnd ℂ) (ρ : ℂ) ∈ Kadiri.NontrivialZeros := by
  have hmem := ρ.2
  simp only [Kadiri.NontrivialZeros, riemannZeta.zeroes_rect, riemannZeta.zeroes,
    Set.mem_setOf_eq] at hmem ⊢
  obtain ⟨hre, -, hz⟩ := hmem
  refine ⟨by simpa using hre, Set.mem_univ _, ?_⟩
  rw [riemannZeta_conj, hz, map_zero]

/-- The conjugate, as a nontrivial zero. -/
def conjZ (ρ : Kadiri.NontrivialZeros) : Kadiri.NontrivialZeros :=
  ⟨(starRingEnd ℂ) (ρ : ℂ), conj_mem ρ⟩

theorem conjZ_injective : Function.Injective conjZ := by
  intro a b hab
  have h : (starRingEnd ℂ) (a : ℂ) = (starRingEnd ℂ) (b : ℂ) := congrArg Subtype.val hab
  exact Subtype.ext ((starRingEnd ℂ).injective h)

theorem weightedTerm_conjZ {h : ℝ} (hh : 0 < h) (γ : ℝ) (ρ : Kadiri.NontrivialZeros)
    (hρ : (ρ : ℂ).re = 1 / 2) : weightedTerm h γ (conjZ ρ) = weightedTerm h γ ρ := by
  have hne : (ρ : ℂ) ≠ 1 := by
    intro h1
    rw [h1] at hρ
    norm_num at hρ
  show (laplace (phiC h γ) (-(starRingEnd ℂ) (ρ : ℂ))
        * laplace (phiC h γ) (-(1 - (starRingEnd ℂ) (ρ : ℂ)))).re
      * ((riemannZeta.order ((starRingEnd ℂ) (ρ : ℂ)) : ℤ) : ℝ)
    = (laplace (phiC h γ) (-(ρ : ℂ)) * laplace (phiC h γ) (-(1 - (ρ : ℂ)))).re
      * ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)
  rw [term_conj hh γ hρ, Kadiri.riemannZeta_order_conj hne]

/-- One side's bound: `A h γ · π²/6`. -/
def B (h γ : ℝ) : ℝ := A h γ * (Real.pi ^ 2 / 6)

/-- Finite on-line sums of height `≥ 11/10`. -/
theorem sum_upper_le {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ)
    (S : Finset Kadiri.NontrivialZeros)
    (hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ 11 / 10 ≤ (ρ : ℂ).im) :
    ∑ ρ ∈ S, weightedTerm h γ ρ ≤ B h γ := by
  unfold B
  refine (sum_le_bandSeries S hS (M h γ) (M_nonneg h γ) ?_ (bandSeries_summable hh)).trans
    (bandSeries_le hh)
  intro ρ hρ
  exact term_le_M hh hγ ρ (hS ρ hρ).1 (hS ρ hρ).2

/-- **Negative heights.** Finite on-line sums of height `≤ −11/10`, by
conjugation onto the upper range. -/
theorem sum_lower_le {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ)
    (S : Finset Kadiri.NontrivialZeros)
    (hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ (ρ : ℂ).im ≤ -(11 / 10)) :
    ∑ ρ ∈ S, weightedTerm h γ ρ ≤ B h γ := by
  have e : ∑ ρ ∈ S, weightedTerm h γ ρ = ∑ ρ ∈ S.image conjZ, weightedTerm h γ ρ := by
    rw [Finset.sum_image (fun a _ b _ hab => conjZ_injective hab)]
    apply Finset.sum_congr rfl
    intro ρ hρ
    exact (weightedTerm_conjZ hh γ ρ (hS ρ hρ).1).symm
  rw [e]
  apply sum_upper_le hh hγ
  intro σ hσ
  rw [Finset.mem_image] at hσ
  obtain ⟨ρ, hρ, rfl⟩ := hσ
  obtain ⟨hre, him⟩ := hS ρ hρ
  constructor
  · show ((starRingEnd ℂ) (ρ : ℂ)).re = 1 / 2
    simp [hre]
  · show 11 / 10 ≤ ((starRingEnd ℂ) (ρ : ℂ)).im
    simp only [Complex.conj_im]
    linarith

/-- The on-line zeros of height `|t| ≤ 11/10`, as points. -/
def lowSet : Set ℂ := {ρ : ℂ | riemannZeta ρ = 0 ∧ ρ.re = 1 / 2 ∧ |ρ.im| ≤ 11 / 10}

/-- The half-plane `Re z < 3/4`: open, convex, pole-free. -/
def lowU : Set ℂ := {z : ℂ | z.re < 3 / 4}

theorem lowU_preconnected : IsPreconnected lowU :=
  (convex_halfSpace_re_lt (r := 3 / 4)).isPreconnected

theorem lowU_analytic : AnalyticOnNhd ℂ riemannZeta lowU := by
  intro z hz
  apply analyticAt_riemannZeta
  intro h1
  have : z.re < 3 / 4 := hz
  rw [h1] at this
  norm_num at this

/-- **The low band is finite.** -/
theorem lowSet_finite : lowSet.Finite := by
  by_contra hinf
  rw [Set.not_finite] at hinf
  have hK : IsCompact ((fun t : ℝ => ((1 / 2 : ℝ) : ℂ) + Complex.I * (t : ℂ)) ''
      Set.Icc (-(11 / 10)) (11 / 10)) :=
    isCompact_Icc.image (by fun_prop)
  have hsub : lowSet ⊆ (fun t : ℝ => ((1 / 2 : ℝ) : ℂ) + Complex.I * (t : ℂ)) ''
      Set.Icc (-(11 / 10)) (11 / 10) := by
    intro ρ hρ
    refine ⟨ρ.im, abs_le.mp hρ.2.2, ?_⟩
    apply Complex.ext <;> simp [hρ.2.1]
  obtain ⟨x, hxK, hacc⟩ := hinf.exists_accPt_of_subset_isCompact hK hsub
  have hxre : x.re = 1 / 2 := by
    obtain ⟨t, -, rfl⟩ := hxK
    simp
  have hfeq : Set.EqOn riemannZeta 0 lowU := by
    refine AnalyticOnNhd.eqOn_zero_of_preconnected_of_mem_closure lowU_analytic
      lowU_preconnected (z₀ := x) ?_ ?_
    · show x.re < 3 / 4
      rw [hxre]
      norm_num
    · simp only [mem_closure_iff_clusterPt, ← accPt_principal_iff_clusterPt]
      exact hacc.mono (Filter.principal_mono.mpr fun _ h => h.1)
  have h0 : riemannZeta 0 = 0 := hfeq (by show (0 : ℂ).re < 3 / 4; simp)
  rw [riemannZeta_zero] at h0
  norm_num at h0

/-- **The low count.** Total multiplicity of the on-line zeros of height
`|t| ≤ 11/10`. Carried by name. -/
def lowCount : ℝ := ∑ ρ ∈ lowSet_finite.toFinset, (analyticOrderNatAt riemannZeta ρ : ℝ)

theorem lowCount_nonneg : 0 ≤ lowCount :=
  Finset.sum_nonneg (fun _ _ => Nat.cast_nonneg _)

/-- **The low band.** Finite on-line sums of height `|t| ≤ 11/10`. -/
theorem sum_low_le {h γ : ℝ} (hh : 0 < h) (S : Finset Kadiri.NontrivialZeros)
    (hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ |(ρ : ℂ).im| ≤ 11 / 10) :
    ∑ ρ ∈ S, weightedTerm h γ ρ ≤ 4 * h ^ 2 * lowCount := by
  have hord : ∀ ρ : Kadiri.NontrivialZeros, (0 : ℝ) ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) :=
    fun ρ => by exact_mod_cast (Kadiri.riemannZeta_order_pos_nontrivialZero ρ).le
  have h1 : ∑ ρ ∈ S, weightedTerm h γ ρ
      ≤ ∑ ρ ∈ S, 4 * h ^ 2 * (analyticOrderNatAt riemannZeta (ρ : ℂ) : ℝ) := by
    apply Finset.sum_le_sum
    intro ρ hρ
    unfold weightedTerm
    rw [← order_eq_analyticOrderNatAt ρ]
    exact mul_le_mul_of_nonneg_right (online_term_le_near hh γ (hS ρ hρ).1) (hord ρ)
  have h2 : ∑ ρ ∈ S, 4 * h ^ 2 * (analyticOrderNatAt riemannZeta (ρ : ℂ) : ℝ)
      = 4 * h ^ 2 * ∑ z ∈ S.image (fun ρ : Kadiri.NontrivialZeros => (ρ : ℂ)),
          (analyticOrderNatAt riemannZeta z : ℝ) := by
    rw [← Finset.mul_sum, Finset.sum_image]
    intro a _ b _ hab
    exact Subtype.ext hab
  have h3 : ∑ z ∈ S.image (fun ρ : Kadiri.NontrivialZeros => (ρ : ℂ)),
      (analyticOrderNatAt riemannZeta z : ℝ) ≤ lowCount := by
    unfold lowCount
    apply Finset.sum_le_sum_of_subset_of_nonneg _ (fun _ _ _ => Nat.cast_nonneg _)
    intro z hz
    rw [Finset.mem_image] at hz
    obtain ⟨ρ, hρ, rfl⟩ := hz
    rw [Set.Finite.mem_toFinset]
    exact ⟨Kadiri.riemannZeta_nontrivialZero_zero ρ, (hS ρ hρ).1, (hS ρ hρ).2⟩
  calc ∑ ρ ∈ S, weightedTerm h γ ρ ≤ _ := h1
    _ = _ := h2
    _ ≤ 4 * h ^ 2 * lowCount := mul_le_mul_of_nonneg_left h3 (by positivity)

/-- The on-line background bound: `2·B h γ + 4h²·lowCount`. -/
def onLineBound (h γ : ℝ) : ℝ := 2 * B h γ + 4 * h ^ 2 * lowCount

/-- **All heights.** Any finite on-line sum is at most `onLineBound`. -/
theorem sum_onLine_le {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ)
    (S : Finset Kadiri.NontrivialZeros) (hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2) :
    ∑ ρ ∈ S, weightedTerm h γ ρ ≤ onLineBound h γ := by
  classical
  rw [← Finset.sum_filter_add_sum_filter_not S
    (fun ρ : Kadiri.NontrivialZeros => 11 / 10 ≤ (ρ : ℂ).im)]
  rw [← Finset.sum_filter_add_sum_filter_not
    (S.filter (fun ρ : Kadiri.NontrivialZeros => ¬ 11 / 10 ≤ (ρ : ℂ).im))
    (fun ρ : Kadiri.NontrivialZeros => (ρ : ℂ).im ≤ -(11 / 10))]
  have hU : ∑ ρ ∈ S.filter (fun ρ : Kadiri.NontrivialZeros => 11 / 10 ≤ (ρ : ℂ).im),
      weightedTerm h γ ρ ≤ B h γ := by
    apply sum_upper_le hh hγ
    intro ρ hρ
    rw [Finset.mem_filter] at hρ
    exact ⟨hS ρ hρ.1, hρ.2⟩
  have hL : ∑ ρ ∈ (S.filter (fun ρ : Kadiri.NontrivialZeros => ¬ 11 / 10 ≤ (ρ : ℂ).im)).filter
      (fun ρ : Kadiri.NontrivialZeros => (ρ : ℂ).im ≤ -(11 / 10)),
      weightedTerm h γ ρ ≤ B h γ := by
    apply sum_lower_le hh hγ
    intro ρ hρ
    rw [Finset.mem_filter, Finset.mem_filter] at hρ
    exact ⟨hS ρ hρ.1.1, hρ.2⟩
  have hM : ∑ ρ ∈ (S.filter (fun ρ : Kadiri.NontrivialZeros => ¬ 11 / 10 ≤ (ρ : ℂ).im)).filter
      (fun ρ : Kadiri.NontrivialZeros => ¬ (ρ : ℂ).im ≤ -(11 / 10)),
      weightedTerm h γ ρ ≤ 4 * h ^ 2 * lowCount := by
    apply sum_low_le hh
    intro ρ hρ
    rw [Finset.mem_filter, Finset.mem_filter] at hρ
    obtain ⟨⟨hρS, h1⟩, h2⟩ := hρ
    push Not at h1 h2
    exact ⟨hS ρ hρS, abs_le.mpr ⟨h2.le, h1.le⟩⟩
  unfold onLineBound
  linarith

/-- On-line zeros. -/
abbrev OnLine : Type := {ρ : Kadiri.NontrivialZeros // (ρ : ℂ).re = 1 / 2}

theorem sum_onLine_subtype_le {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) (s : Finset OnLine) :
    ∑ ρ ∈ s, weightedTerm h γ ρ.1 ≤ onLineBound h γ := by
  have hinj : ∀ a ∈ s, ∀ b ∈ s, (a : Kadiri.NontrivialZeros) = b → a = b :=
    fun a _ b _ hab => Subtype.ext hab
  rw [← Finset.sum_image (f := weightedTerm h γ) hinj]
  apply sum_onLine_le hh hγ
  intro ρ hρ
  rw [Finset.mem_image] at hρ
  obtain ⟨σ, _, rfl⟩ := hρ
  exact σ.2

/-- **The on-line background.** For `h > 0` and `γ ≥ 11/10`, the full
weighted sum over all on-line zeros is at most `onLineBound h γ`. -/
theorem tsum_onLine_le {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) :
    ∑' ρ : OnLine, weightedTerm h γ ρ.1 ≤ onLineBound h γ := by
  apply Real.tsum_le_of_sum_le
  · intro ρ
    exact weightedTerm_nonneg hh γ ρ.1 ρ.2
  · exact sum_onLine_subtype_le hh hγ

/-- The on-line series is summable. -/
theorem summable_onLine {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) :
    Summable (fun ρ : OnLine => weightedTerm h γ ρ.1) := by
  apply summable_of_sum_le
  · intro ρ
    exact weightedTerm_nonneg hh γ ρ.1 ρ.2
  · exact sum_onLine_subtype_le hh hγ

theorem A_le {h γ : ℝ} (hγ : 11 / 10 ≤ γ) :
    A h γ ≤ 88 * (γ + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2) := by
  unfold A
  have hi := idx_le hγ
  have hK0 : (0 : ℝ) ≤ idx γ := Nat.cast_nonneg _
  have hp : ((idx γ : ℝ) + 3) ^ 4 ≤ (γ + 3) ^ 4 :=
    pow_le_pow_left₀ (by positivity) (by linarith) 4
  apply mul_le_mul_of_nonneg_right _ (four_h_add_nonneg h)
  exact mul_le_mul_of_nonneg_left hp (by norm_num)

/-- **The on-line background, in `γ` and `h` alone.** -/
theorem onLineBound_le {h γ : ℝ} (hγ : 11 / 10 ≤ γ) :
    onLineBound h γ
      ≤ 2 * (88 * (γ + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2) * (Real.pi ^ 2 / 6))
        + 4 * h ^ 2 * lowCount := by
  unfold onLineBound B
  have h1 := A_le (h := h) hγ
  have h2 : A h γ * (Real.pi ^ 2 / 6)
      ≤ 88 * (γ + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2) * (Real.pi ^ 2 / 6) :=
    mul_le_mul_of_nonneg_right h1 (by positivity)
  linarith

end

/-- info: 'WeilOnLine.term_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms term_conj

/-- info: 'WeilOnLine.lowSet_finite' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lowSet_finite

/-- info: 'WeilOnLine.tsum_onLine_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms tsum_onLine_le

end WeilOnLine
