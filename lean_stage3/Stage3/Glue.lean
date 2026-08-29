/-
# The glue — assembling StmtExplicitFormula from the four slices

Pieces, in build order:
- the band count and the `zeroPartialSum` swap (`T′ → T`),
- the edge-integral estimates (S3's pointwise bounds integrated),
- the rectangle-edge splitting matching S1's line integral,
- the final assembly in the `T ≤ x²` regime + the consumer patch.
-/
import Stage3.EdgeBound

namespace Glue

open Complex Topology Set

/-- **The band count**: any finite set of strip zeros with `|im|` in
`[T, T+1]` has total multiplicity `≤ C·log T` — two windows per sign,
reflection for the left half, conjugation for the negative sign. -/
theorem band_order_sum_le :
    ∃ C : ℝ, 0 < C ∧ ∀ T : ℝ, 2 ≤ T → ∀ F : Finset ℂ,
      (∀ ρ ∈ F, riemannZeta ρ = 0 ∧ (0 < ρ.re ∧ ρ.re < 1)
        ∧ T ≤ |ρ.im| ∧ |ρ.im| ≤ T + 1) →
      (∑ ρ ∈ F, (analyticOrderNatAt riemannZeta ρ : ℝ)) ≤ C * Real.log T := by
  classical
  have hlog2 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  set W0 : ℝ := 15 + 88 / Real.log 2 with hW0d
  have hW00 : 0 < W0 := by
    rw [hW0d]
    positivity
  refine ⟨8 * W0, by positivity, ?_⟩
  intro T hT F hF
  have hlogT : Real.log 2 ≤ Real.log T := Real.log_le_log (by norm_num) hT
  have hlogT0 : 0 < Real.log T := lt_of_lt_of_le hlog2 hlogT
  have hc1 : (2:ℝ) ≤ T := hT
  have hc2 : (2:ℝ) ≤ T + 1 := by linarith
  set W : Finset ℂ :=
    (Stage3.zetaWindow_finite hc1).toFinset ∪ (Stage3.zetaWindow_finite hc2).toFinset
    with hWd
  -- the chooser for positive-band zeros with re ≥ 1/2
  have hchoice : ∀ ρ : ℂ, riemannZeta ρ = 0 → 1/2 ≤ ρ.re → ρ.re < 1 →
      T ≤ ρ.im → ρ.im ≤ T + 1 → ρ ∈ W := by
    intro ρ hζ hre hre1 him1 him2
    rw [hWd]
    rcases le_total ρ.im (T + 9/10) with h1 | h1
    · apply Finset.mem_union_left
      rw [Set.Finite.mem_toFinset]
      apply ContourShift.mem_zetaWindow hζ hre hre1
      rw [abs_le]
      constructor <;> linarith
    · apply Finset.mem_union_right
      rw [Set.Finite.mem_toFinset]
      apply ContourShift.mem_zetaWindow hζ hre hre1
      rw [abs_le]
      constructor <;> linarith
  have hunion_le : ∀ (Aset Bset : Finset ℂ),
      ∑ w ∈ Aset ∪ Bset, (analyticOrderNatAt riemannZeta w : ℝ)
        ≤ (∑ w ∈ Aset, (analyticOrderNatAt riemannZeta w : ℝ))
          + ∑ w ∈ Bset, (analyticOrderNatAt riemannZeta w : ℝ) := by
    intro Aset Bset
    have h5 := Finset.sum_union_inter (s₁ := Aset) (s₂ := Bset)
      (f := fun w ↦ (analyticOrderNatAt riemannZeta w : ℝ))
    have h6 : (0:ℝ) ≤ ∑ w ∈ Aset ∩ Bset, (analyticOrderNatAt riemannZeta w : ℝ) := by
      apply Finset.sum_nonneg
      intro w _
      positivity
    linarith
  have hWsum : (∑ w ∈ W, (analyticOrderNatAt riemannZeta w : ℝ))
      ≤ 2 * (W0 * Real.log T) := by
    rw [hWd]
    have h7 : ∀ (T0 : ℝ) (hT0 : 2 ≤ T0), T0 ≤ T + 1 →
        (∑ ρ ∈ (Stage3.zetaWindow_finite hT0).toFinset,
          (analyticOrderNatAt riemannZeta ρ : ℝ)) ≤ W0 * Real.log T := by
      intro T0 hT0 hT0le
      have h8 := Stage3.zeta_local_zero_count hT0
      have h9 : Real.log T0 ≤ Real.log 2 + Real.log T := by
        have h10 : Real.log T0 ≤ Real.log (2 * T) := by
          apply Real.log_le_log (by linarith)
          linarith
        rwa [Real.log_mul (by norm_num) (by linarith)] at h10
      have h11 : Real.log 2 ≤ 1 := by
        have := Real.log_le_sub_one_of_pos (by norm_num : (0:ℝ) < 2)
        linarith
      have h12 : (73:ℝ) ≤ 73 / Real.log 2 * Real.log T := by
        rw [div_mul_eq_mul_div, le_div_iff₀ hlog2]
        nlinarith
      have h13 : (15:ℝ) ≤ 15 / Real.log 2 * Real.log T := by
        rw [div_mul_eq_mul_div, le_div_iff₀ hlog2]
        nlinarith
      have h14 : 15 * Real.log T0 ≤ 15 * (Real.log 2 + Real.log T) := by linarith
      have h15 : 73 / Real.log 2 * Real.log T + 15 / Real.log 2 * Real.log T
          = 88 / Real.log 2 * Real.log T := by ring
      rw [hW0d, show (15 + 88 / Real.log 2) * Real.log T
          = 15 * Real.log T + 88 / Real.log 2 * Real.log T by ring]
      linarith
    calc ∑ w ∈ _ ∪ _, (analyticOrderNatAt riemannZeta w : ℝ)
        ≤ _ := hunion_le _ _
      _ ≤ W0 * Real.log T + W0 * Real.log T :=
          add_le_add (h7 _ hc1 (by linarith)) (h7 _ hc2 (by linarith))
      _ = 2 * (W0 * Real.log T) := by ring
  -- one positive-band half (any sign of re), counted through W
  have hhalf : ∀ G : Finset ℂ,
      (∀ ρ ∈ G, riemannZeta ρ = 0 ∧ (0 < ρ.re ∧ ρ.re < 1)
        ∧ T ≤ ρ.im ∧ ρ.im ≤ T + 1) →
      (∑ ρ ∈ G, (analyticOrderNatAt riemannZeta ρ : ℝ))
        ≤ 4 * (W0 * Real.log T) := by
    intro G hG
    rw [← Finset.sum_filter_add_sum_filter_not G (fun w ↦ 1/2 ≤ w.re)]
    have hp1 : (∑ w ∈ G.filter (fun w ↦ 1/2 ≤ w.re),
        (analyticOrderNatAt riemannZeta w : ℝ))
          ≤ ∑ w ∈ W, (analyticOrderNatAt riemannZeta w : ℝ) := by
      apply Finset.sum_le_sum_of_subset_of_nonneg
      · intro w hw
        rw [Finset.mem_filter] at hw
        obtain ⟨hwG, hwre⟩ := hw
        obtain ⟨hζ, ⟨_, hre1⟩, him1, him2⟩ := hG w hwG
        exact hchoice w hζ hwre hre1 him1 him2
      · intro w _ _
        positivity
    have hp2 : (∑ w ∈ G.filter (fun w ↦ ¬(1/2 ≤ w.re)),
        (analyticOrderNatAt riemannZeta w : ℝ))
          ≤ ∑ w ∈ W, (analyticOrderNatAt riemannZeta w : ℝ) := by
      have hrinj : Function.Injective (fun w : ℂ ↦ 1 - (starRingEnd ℂ) w) := by
        intro a b hab
        have h11 : (starRingEnd ℂ) a = (starRingEnd ℂ) b := by
          have h12 : (1:ℂ) - (starRingEnd ℂ) a = 1 - (starRingEnd ℂ) b := hab
          linear_combination -h12
        have h13 := congrArg (starRingEnd ℂ) h11
        rwa [Complex.conj_conj, Complex.conj_conj] at h13
      have hsum_refl : (∑ w ∈ G.filter (fun w ↦ ¬(1/2 ≤ w.re)),
          (analyticOrderNatAt riemannZeta w : ℝ))
            = ∑ w ∈ (G.filter (fun w ↦ ¬(1/2 ≤ w.re))).image
                (fun w ↦ 1 - (starRingEnd ℂ) w),
              (analyticOrderNatAt riemannZeta w : ℝ) := by
        rw [Finset.sum_image (fun a _ b _ hab ↦ hrinj hab)]
        apply Finset.sum_congr rfl
        intro w hw
        rw [Finset.mem_filter] at hw
        obtain ⟨hwG, _⟩ := hw
        obtain ⟨hζ, ⟨hre0, hre1⟩, _, _⟩ := hG w hwG
        rw [ContourShift.zeta_order_reflect hre0 hre1]
      rw [hsum_refl]
      apply Finset.sum_le_sum_of_subset_of_nonneg
      · intro w' hw'
        rw [Finset.mem_image] at hw'
        obtain ⟨w, hw, rfl⟩ := hw'
        rw [Finset.mem_filter] at hw
        obtain ⟨hwG, hwre⟩ := hw
        push_neg at hwre
        obtain ⟨hζ, ⟨hre0, hre1⟩, him1, him2⟩ := hG w hwG
        have hcw : riemannZeta ((starRingEnd ℂ) w) = 0 := by
          rw [riemannZeta_conj, hζ, map_zero]
        have hwn : ∀ n : ℕ, (starRingEnd ℂ) w ≠ -(n:ℂ) := by
          intro n hcon
          have h14 := congrArg Complex.re hcon
          simp only [Complex.conj_re, Complex.neg_re, Complex.natCast_re] at h14
          have h15 : (0:ℝ) ≤ (n:ℝ) := Nat.cast_nonneg n
          linarith
        have hw1c : (starRingEnd ℂ) w ≠ 1 := by
          intro hcon
          have h16 := congrArg Complex.re hcon
          simp only [Complex.conj_re, Complex.one_re] at h16
          linarith
        have hfe := riemannZeta_one_sub hwn hw1c
        rw [hcw, mul_zero] at hfe
        have hre' : (1 - (starRingEnd ℂ) w).re = 1 - w.re := by
          simp [Complex.sub_re, Complex.conj_re]
        have him' : (1 - (starRingEnd ℂ) w).im = w.im := by
          simp [Complex.sub_im, Complex.conj_im]
        apply hchoice _ hfe
        · rw [hre']
          linarith
        · rw [hre']
          linarith
        · rw [him']
          exact him1
        · rw [him']
          exact him2
      · intro w _ _
        positivity
    linarith [hWsum]
  -- split by sign of the ordinate; conjugate the negative half
  rw [← Finset.sum_filter_add_sum_filter_not F (fun w ↦ 0 ≤ w.im)]
  have hpos : (∑ ρ ∈ F.filter (fun w ↦ 0 ≤ w.im),
      (analyticOrderNatAt riemannZeta ρ : ℝ)) ≤ 4 * (W0 * Real.log T) := by
    apply hhalf
    intro ρ hρ
    rw [Finset.mem_filter] at hρ
    obtain ⟨hρF, hρim⟩ := hρ
    obtain ⟨hζ, hre, him1, him2⟩ := hF ρ hρF
    rw [abs_of_nonneg hρim] at him1 him2
    exact ⟨hζ, hre, him1, him2⟩
  have hneg : (∑ ρ ∈ F.filter (fun w ↦ ¬(0 ≤ w.im)),
      (analyticOrderNatAt riemannZeta ρ : ℝ)) ≤ 4 * (W0 * Real.log T) := by
    have hcinj : Function.Injective (fun w : ℂ ↦ (starRingEnd ℂ) w) := by
      intro a b hab
      have h17 := congrArg (starRingEnd ℂ) hab
      rwa [Complex.conj_conj, Complex.conj_conj] at h17
    have hsum_conj : (∑ ρ ∈ F.filter (fun w ↦ ¬(0 ≤ w.im)),
        (analyticOrderNatAt riemannZeta ρ : ℝ))
          = ∑ ρ ∈ (F.filter (fun w ↦ ¬(0 ≤ w.im))).image (starRingEnd ℂ),
            (analyticOrderNatAt riemannZeta ρ : ℝ) := by
      rw [Finset.sum_image (fun a _ b _ hab ↦ hcinj hab)]
      apply Finset.sum_congr rfl
      intro w hw
      rw [Finset.mem_filter] at hw
      obtain ⟨hwF, _⟩ := hw
      obtain ⟨hζ, ⟨_, hre1⟩, _, _⟩ := hF w hwF
      have hw1 : w ≠ 1 := by
        intro h
        rw [h] at hre1
        simp at hre1
      rw [ContourShift.zeta_order_conj hw1]
    rw [hsum_conj]
    apply hhalf
    intro ρ hρ
    rw [Finset.mem_image] at hρ
    obtain ⟨w, hw, rfl⟩ := hρ
    rw [Finset.mem_filter] at hw
    obtain ⟨hwF, hwim⟩ := hw
    push_neg at hwim
    obtain ⟨hζ, ⟨hre0, hre1⟩, him1, him2⟩ := hF w hwF
    rw [abs_of_neg hwim] at him1 him2
    refine ⟨?_, ⟨?_, ?_⟩, ?_, ?_⟩
    · rw [riemannZeta_conj, hζ, map_zero]
    · rw [Complex.conj_re]
      exact hre0
    · rw [Complex.conj_re]
      exact hre1
    · rw [Complex.conj_im]
      linarith
    · rw [Complex.conj_im]
      linarith
  calc (∑ ρ ∈ F.filter (fun w ↦ 0 ≤ w.im),
        (analyticOrderNatAt riemannZeta ρ : ℝ))
      + ∑ ρ ∈ F.filter (fun w ↦ ¬(0 ≤ w.im)),
        (analyticOrderNatAt riemannZeta ρ : ℝ)
      ≤ 4 * (W0 * Real.log T) + 4 * (W0 * Real.log T) := add_le_add hpos hneg
    _ = 8 * W0 * Real.log T := by ring

end Glue
