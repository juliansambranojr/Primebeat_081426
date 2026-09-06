/-
WeilPowerOnLine — the switched window's on-line background, all heights.
Rung 5, eighth slice. 2026-09-06.

Unit 0334 bounds the weighted on-line sum of the switched window over
heights `≥ 11/10` by `B h γ m = A h γ m·π²/6`. This module is unit 0324
with the term replaced: the negative heights by conjugation (`PsiW` is
odd, so the on-line term is conjugation-invariant, and the multiplicity is
conjugation-symmetric upstream), the low band `|t| ≤ 11/10` by unit 0324's
finite set and its `lowCount`, each low term at most `4h²`, and the
assembly:

  onLineBound h γ m = 2·B h γ m + 4h²·lowCount
  tsum_onLine_le      the full weighted sum over all on-line zeros is at
                      most `onLineBound h γ m`, for `h > 0`, `γ ≥ 11/10`
  summable_onLine     and the on-line series is summable
  onLineBound_le      in `γ`, `h` and `m` alone:
                      `≤ 2·88·(γ + r + 2)⁴·(4h² + cFarM m/h²)·π²/6 + 4h²·lowCount`.

With `cFarM m ≤ 1000(m+1)²` (unit 0334) and `r ≤ 1 + 5(m+1)/h`, the whole
on-line background is polynomial in `h`, `m` and `γ`. Rung 4b for the
switched window is closed.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilPowerBands
import Stage3.WeilOnLine

namespace WeilPowerOnLine

noncomputable section

open Complex WeilDetect WeilBands WeilTiles WeilOddPower WeilPowerBackground WeilPowerBands
  WeilOnLine Real

/-- `PsiW` is odd. -/
theorem PsiW_neg (m : ℕ) (t : ℝ) : PsiW m (-t) = -PsiW m t := by
  unfold PsiW
  rw [← intervalIntegral.integral_neg]
  apply intervalIntegral.integral_congr
  intro x _
  simp only [neg_mul, Real.sin_neg, mul_neg]

/-- The on-line term is invariant under conjugation of the zero. -/
theorem term_conj {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) {ρ : ℂ} (hρ : ρ.re = 1 / 2) :
    termW h γ m ((starRingEnd ℂ) ρ) = termW h γ m ρ := by
  have hρ' : ((starRingEnd ℂ) ρ).re = 1 / 2 := by simp [hρ]
  unfold termW
  rw [online_term_eq hh γ m hρ', online_term_eq hh γ m hρ, Complex.ofReal_re, Complex.ofReal_re]
  simp only [Complex.conj_im]
  have e1 : h * (-ρ.im + γ) = -(h * (ρ.im - γ)) := by ring
  have e2 : h * (-ρ.im - γ) = -(h * (ρ.im + γ)) := by ring
  rw [e1, e2, PsiW_neg, PsiW_neg]
  ring

theorem weightedTermW_conjZ {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) (ρ : Kadiri.NontrivialZeros)
    (hρ : (ρ : ℂ).re = 1 / 2) : weightedTermW h γ m (conjZ ρ) = weightedTermW h γ m ρ := by
  have hne : (ρ : ℂ) ≠ 1 := by
    intro h1
    rw [h1] at hρ
    norm_num at hρ
  show termW h γ m ((starRingEnd ℂ) (ρ : ℂ)) * ((riemannZeta.order ((starRingEnd ℂ) (ρ : ℂ)) : ℤ) : ℝ)
    = termW h γ m (ρ : ℂ) * ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)
  rw [term_conj hh γ m hρ, Kadiri.riemannZeta_order_conj hne]

/-- One side's bound: `A h γ m · π²/6`. -/
def B (h γ : ℝ) (m : ℕ) : ℝ := A h γ m * (Real.pi ^ 2 / 6)

/-- Finite on-line sums of height `≥ 11/10`. -/
theorem sum_upper_le {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) (m : ℕ)
    (S : Finset Kadiri.NontrivialZeros)
    (hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ 11 / 10 ≤ (ρ : ℂ).im) :
    ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ B h γ m := by
  unfold B
  refine (sum_le_bandSeries m S hS (M h γ m) (M_nonneg h γ m) ?_ (bandSeries_summable hh m)).trans
    (bandSeries_le hh m)
  intro ρ hρ
  exact term_le_M hh hγ m ρ (hS ρ hρ).1 (hS ρ hρ).2

/-- **Negative heights.** -/
theorem sum_lower_le {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) (m : ℕ)
    (S : Finset Kadiri.NontrivialZeros)
    (hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ (ρ : ℂ).im ≤ -(11 / 10)) :
    ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ B h γ m := by
  have e : ∑ ρ ∈ S, weightedTermW h γ m ρ = ∑ ρ ∈ S.image conjZ, weightedTermW h γ m ρ := by
    rw [Finset.sum_image (fun a _ b _ hab => conjZ_injective hab)]
    apply Finset.sum_congr rfl
    intro ρ hρ
    exact (weightedTermW_conjZ hh γ m ρ (hS ρ hρ).1).symm
  rw [e]
  apply sum_upper_le hh hγ m
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

/-- **The low band.** Finite on-line sums of height `|t| ≤ 11/10`. -/
theorem sum_low_le {h γ : ℝ} (hh : 0 < h) (m : ℕ) (S : Finset Kadiri.NontrivialZeros)
    (hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ |(ρ : ℂ).im| ≤ 11 / 10) :
    ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ 4 * h ^ 2 * lowCount := by
  have hord : ∀ ρ : Kadiri.NontrivialZeros, (0 : ℝ) ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) :=
    fun ρ => by exact_mod_cast (Kadiri.riemannZeta_order_pos_nontrivialZero ρ).le
  have h1 : ∑ ρ ∈ S, weightedTermW h γ m ρ
      ≤ ∑ ρ ∈ S, 4 * h ^ 2 * (analyticOrderNatAt riemannZeta (ρ : ℂ) : ℝ) := by
    apply Finset.sum_le_sum
    intro ρ hρ
    unfold weightedTermW
    rw [← order_eq_analyticOrderNatAt ρ]
    exact mul_le_mul_of_nonneg_right (online_term_le_near hh γ m (hS ρ hρ).1) (hord ρ)
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
  calc ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ _ := h1
    _ = _ := h2
    _ ≤ 4 * h ^ 2 * lowCount := mul_le_mul_of_nonneg_left h3 (by positivity)

/-- The on-line background bound: `2·B h γ m + 4h²·lowCount`. -/
def onLineBound (h γ : ℝ) (m : ℕ) : ℝ := 2 * B h γ m + 4 * h ^ 2 * lowCount

/-- **All heights.** -/
theorem sum_onLine_le {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) (m : ℕ)
    (S : Finset Kadiri.NontrivialZeros) (hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2) :
    ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ onLineBound h γ m := by
  classical
  rw [← Finset.sum_filter_add_sum_filter_not S
    (fun ρ : Kadiri.NontrivialZeros => 11 / 10 ≤ (ρ : ℂ).im)]
  rw [← Finset.sum_filter_add_sum_filter_not
    (S.filter (fun ρ : Kadiri.NontrivialZeros => ¬ 11 / 10 ≤ (ρ : ℂ).im))
    (fun ρ : Kadiri.NontrivialZeros => (ρ : ℂ).im ≤ -(11 / 10))]
  have hU : ∑ ρ ∈ S.filter (fun ρ : Kadiri.NontrivialZeros => 11 / 10 ≤ (ρ : ℂ).im),
      weightedTermW h γ m ρ ≤ B h γ m := by
    apply sum_upper_le hh hγ m
    intro ρ hρ
    rw [Finset.mem_filter] at hρ
    exact ⟨hS ρ hρ.1, hρ.2⟩
  have hL : ∑ ρ ∈ (S.filter (fun ρ : Kadiri.NontrivialZeros => ¬ 11 / 10 ≤ (ρ : ℂ).im)).filter
      (fun ρ : Kadiri.NontrivialZeros => (ρ : ℂ).im ≤ -(11 / 10)),
      weightedTermW h γ m ρ ≤ B h γ m := by
    apply sum_lower_le hh hγ m
    intro ρ hρ
    rw [Finset.mem_filter, Finset.mem_filter] at hρ
    exact ⟨hS ρ hρ.1.1, hρ.2⟩
  have hM : ∑ ρ ∈ (S.filter (fun ρ : Kadiri.NontrivialZeros => ¬ 11 / 10 ≤ (ρ : ℂ).im)).filter
      (fun ρ : Kadiri.NontrivialZeros => ¬ (ρ : ℂ).im ≤ -(11 / 10)),
      weightedTermW h γ m ρ ≤ 4 * h ^ 2 * lowCount := by
    apply sum_low_le hh m
    intro ρ hρ
    rw [Finset.mem_filter, Finset.mem_filter] at hρ
    obtain ⟨⟨hρS, h1⟩, h2⟩ := hρ
    push Not at h1 h2
    exact ⟨hS ρ hρS, abs_le.mpr ⟨h2.le, h1.le⟩⟩
  unfold onLineBound
  linarith

theorem sum_onLine_subtype_le {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) (m : ℕ)
    (s : Finset OnLine) :
    ∑ ρ ∈ s, weightedTermW h γ m ρ.1 ≤ onLineBound h γ m := by
  have hinj : ∀ a ∈ s, ∀ b ∈ s, (a : Kadiri.NontrivialZeros) = b → a = b :=
    fun a _ b _ hab => Subtype.ext hab
  rw [← Finset.sum_image (f := weightedTermW h γ m) hinj]
  apply sum_onLine_le hh hγ m
  intro ρ hρ
  rw [Finset.mem_image] at hρ
  obtain ⟨σ, _, rfl⟩ := hρ
  exact σ.2

/-- **The on-line background of the switched window.** -/
theorem tsum_onLine_le {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) (m : ℕ) :
    ∑' ρ : OnLine, weightedTermW h γ m ρ.1 ≤ onLineBound h γ m := by
  apply Real.tsum_le_of_sum_le
  · intro ρ
    exact weightedTermW_nonneg hh γ m ρ.1 ρ.2
  · exact sum_onLine_subtype_le hh hγ m

/-- The on-line series is summable. -/
theorem summable_onLine {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) (m : ℕ) :
    Summable (fun ρ : OnLine => weightedTermW h γ m ρ.1) := by
  apply summable_of_sum_le
  · intro ρ
    exact weightedTermW_nonneg hh γ m ρ.1 ρ.2
  · exact sum_onLine_subtype_le hh hγ m

/-- **The on-line background, in `γ`, `h` and `m` alone.** -/
theorem onLineBound_le {h γ : ℝ} (hγ : 11 / 10 ≤ γ) (m : ℕ) :
    onLineBound h γ m
      ≤ 2 * (88 * (γ + r h m + 2) ^ 4 * (4 * h ^ 2 + cFarM m / h ^ 2) * (Real.pi ^ 2 / 6))
        + 4 * h ^ 2 * lowCount := by
  unfold onLineBound B
  have h1 := A_le (h := h) hγ m
  have h2 : A h γ m * (Real.pi ^ 2 / 6)
      ≤ 88 * (γ + r h m + 2) ^ 4 * (4 * h ^ 2 + cFarM m / h ^ 2) * (Real.pi ^ 2 / 6) :=
    mul_le_mul_of_nonneg_right h1 (by positivity)
  linarith

end

/-- info: 'WeilPowerOnLine.term_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms term_conj

/-- info: 'WeilPowerOnLine.tsum_onLine_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms tsum_onLine_le

/-- info: 'WeilPowerOnLine.onLineBound_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms onLineBound_le

end WeilPowerOnLine
