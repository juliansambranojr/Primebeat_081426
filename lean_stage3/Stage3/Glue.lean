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

/-- **The swap**: moving the zero sum from a height `T′ ∈ [T, T+1]`
back to `T` costs `≤ C·x·log T / T`. -/
theorem zeroPartialSum_swap :
    ∃ C : ℝ, 0 < C ∧ ∀ x T T' : ℝ, 16 ≤ x → 2 ≤ T → T ≤ T' → T' ≤ T + 1 →
      ‖Stage3.zeroPartialSum x T' - Stage3.zeroPartialSum x T‖
        ≤ C * x * Real.log T / T := by
  classical
  obtain ⟨C2, hC20, hC2⟩ := band_order_sum_le
  refine ⟨C2, hC20, ?_⟩
  intro x T T' hx hT hTT' hT'1
  have hx0 : (0:ℝ) < x := by linarith
  have hx1 : (1:ℝ) ≤ x := by linarith
  have hT0 : (0:ℝ) < T := by linarith
  have hlogT0 : 0 < Real.log T := Real.log_pos (by linarith)
  set zc : ℂ := ((0:ℝ):ℂ) - Complex.I * (((T+1 : ℝ)):ℂ) with hzcd
  set wc : ℂ := ((1:ℝ):ℂ) + Complex.I * (((T+1 : ℝ)):ℂ) with hwcd
  have hzre : zc.re = 0 := by rw [hzcd]; simp
  have hzim : zc.im = -(T+1) := by rw [hzcd]; simp
  have hwre : wc.re = 1 := by rw [hwcd]; simp
  have hwim : wc.im = T+1 := by rw [hwcd]; simp
  set base := (ContourShift.zeta_zeros_rectangle_finite zc wc).toFinset with hbased
  have hrect_mem : ∀ ρ : ℂ, ρ ∈ Rectangle zc wc ↔
      ((0 ≤ ρ.re ∧ ρ.re ≤ 1) ∧ (-(T+1) ≤ ρ.im ∧ ρ.im ≤ T+1)) := by
    intro ρ
    simp only [Rectangle]
    rw [Complex.mem_reProdIm, hzre, hwre, hzim, hwim,
      Set.uIcc_of_le (by norm_num : (0:ℝ) ≤ 1),
      Set.uIcc_of_le (by linarith : -(T+1) ≤ T+1),
      Set.mem_Icc, Set.mem_Icc]
  have hbase_shape : ∀ ρ ∈ base, riemannZeta ρ = 0 ∧ (0 < ρ.re ∧ ρ.re < 1)
      ∧ |ρ.im| ≤ T+1 := by
    intro ρ hρ
    rw [hbased, Set.Finite.mem_toFinset] at hρ
    obtain ⟨hζ, hρR⟩ := hρ
    obtain ⟨⟨hre1, hre2⟩, him1, him2⟩ := (hrect_mem ρ).mp hρR
    refine ⟨hζ, ⟨?_, ?_⟩, ?_⟩
    · rcases lt_or_eq_of_le hre1 with h | h
      · exact h
      · exfalso
        exact ContourShift.zeta_ne_zero_of_re_mem (by linarith) (by linarith) hζ
    · rcases lt_or_eq_of_le hre2 with h | h
      · exact h
      · exfalso
        exact riemannZeta_ne_zero_of_one_le_re (by linarith) hζ
    · rw [abs_le]
      exact ⟨him1, him2⟩
  have hiff : ∀ τ : ℝ, τ ≤ T + 1 → ∀ ρ : ℂ,
      ρ ∈ base.filter (fun w ↦ |w.im| < τ)
        ↔ (ρ ∈ Kadiri.NontrivialZeros ∧ |ρ.im| < τ) := by
    intro τ hτ ρ
    rw [Finset.mem_filter]
    constructor
    · rintro ⟨hρb, him⟩
      obtain ⟨hζ, ⟨hre1, hre2⟩, _⟩ := hbase_shape ρ hρb
      exact ⟨⟨⟨hre1, hre2⟩, Set.mem_univ _, hζ⟩, him⟩
    · rintro ⟨⟨⟨hre1, hre2⟩, -, hζ⟩, him⟩
      refine ⟨?_, him⟩
      rw [hbased, Set.Finite.mem_toFinset]
      refine ⟨hζ, (hrect_mem ρ).mpr ⟨⟨hre1.le, hre2.le⟩, ?_⟩⟩
      rw [abs_lt] at him
      constructor <;> linarith [him.1, him.2]
  have hsub : base.filter (fun w ↦ |w.im| < T)
      ⊆ base.filter (fun w ↦ |w.im| < T') := by
    intro ρ hρ
    rw [Finset.mem_filter] at hρ ⊢
    exact ⟨hρ.1, lt_of_lt_of_le hρ.2 hTT'⟩
  rw [ContourShift.zeroPartialSum_eq_sum (fun ρ ↦ hiff T' hT'1 ρ),
    ContourShift.zeroPartialSum_eq_sum (fun ρ ↦ hiff T (by linarith) ρ),
    ← Finset.sum_sdiff_eq_sub hsub]
  set SD := base.filter (fun w ↦ |w.im| < T') \ base.filter (fun w ↦ |w.im| < T)
    with hSDd
  have hSD_shape : ∀ ρ ∈ SD, riemannZeta ρ = 0 ∧ (0 < ρ.re ∧ ρ.re < 1)
      ∧ T ≤ |ρ.im| ∧ |ρ.im| ≤ T + 1 := by
    intro ρ hρ
    rw [hSDd, Finset.mem_sdiff, Finset.mem_filter] at hρ
    obtain ⟨⟨hρb, _⟩, hnot⟩ := hρ
    rw [Finset.mem_filter] at hnot
    push_neg at hnot
    obtain ⟨hζ, hre, himb⟩ := hbase_shape ρ hρb
    exact ⟨hζ, hre, hnot hρb, himb⟩
  calc ‖∑ ρ ∈ SD, (analyticOrderNatAt riemannZeta ρ : ℂ) * ((x:ℂ)^ρ/ρ)‖
      ≤ ∑ ρ ∈ SD, ‖(analyticOrderNatAt riemannZeta ρ : ℂ) * ((x:ℂ)^ρ/ρ)‖ :=
        norm_sum_le _ _
    _ ≤ ∑ ρ ∈ SD, (analyticOrderNatAt riemannZeta ρ : ℝ) * (x/T) := by
        apply Finset.sum_le_sum
        intro ρ hρ
        obtain ⟨hζ, ⟨hre1, hre2⟩, him1, _⟩ := hSD_shape ρ hρ
        rw [norm_mul, Complex.norm_natCast, norm_div]
        have hxρ : ‖(x:ℂ)^ρ‖ ≤ x := by
          rw [Complex.norm_cpow_eq_rpow_re_of_pos hx0]
          calc x ^ ρ.re ≤ x ^ (1:ℝ) := Real.rpow_le_rpow_of_exponent_le hx1 hre2.le
            _ = x := Real.rpow_one x
        have hρn : T ≤ ‖ρ‖ := le_trans him1 (Complex.abs_im_le_norm ρ)
        have hρ0 : (0:ℝ) < ‖ρ‖ := by linarith
        apply mul_le_mul_of_nonneg_left ?_ (by positivity)
        rw [div_le_div_iff₀ hρ0 hT0]
        calc ‖(x:ℂ)^ρ‖ * T ≤ x * T := by
              nlinarith [norm_nonneg ((x:ℂ)^ρ)]
          _ ≤ x * ‖ρ‖ := by nlinarith
    _ = (∑ ρ ∈ SD, (analyticOrderNatAt riemannZeta ρ : ℝ)) * (x/T) := by
        rw [← Finset.sum_mul]
    _ ≤ (C2 * Real.log T) * (x/T) := by
        apply mul_le_mul_of_nonneg_right (hC2 T hT SD hSD_shape) (by positivity)
    _ = C2 * x * Real.log T / T := by ring


/-- The contour integrand of the explicit formula. -/
noncomputable def Gf (x : ℝ) : ℂ → ℂ :=
  fun s ↦ (- deriv riemannZeta s / riemannZeta s) * ((x:ℝ):ℂ) ^ s / s

/-- **The pointwise good-height bound**, both signs of the height. -/
theorem zeta_logderiv_good_bound :
    ∃ C : ℝ, 0 < C ∧ ∀ T T' : ℝ, 2 ≤ T → T' ∈ Set.Icc T (T+1) →
      (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re →
        ContourShift.zeroGap T ≤ |ρ.im - T'|) →
      ∀ u : ℂ, |u.im| = T' → -1/4 ≤ u.re → u.re ≤ 2 →
      ‖deriv riemannZeta u / riemannZeta u‖ ≤ C * Real.log T ^ 2 := by
  classical
  obtain ⟨Ce, hCe0, hCe⟩ := EdgeBound.edge_bound_core
  have hlog2 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  refine ⟨Ce * 2 * (180 + 1060 / Real.log 2), by positivity, ?_⟩
  intro T T' hT hT' hgood u him hre1 hre2
  obtain ⟨hT'lo, hT'hi⟩ := hT'
  have hT'2 : (2:ℝ) ≤ T' := le_trans hT hT'lo
  have hlogT : Real.log 2 ≤ Real.log T := Real.log_le_log (by norm_num) hT
  have hlogT0 : 0 < Real.log T := lt_of_lt_of_le hlog2 hlogT
  have hlogT'0 : Real.log 2 ≤ Real.log T' := Real.log_le_log (by norm_num) hT'2
  have hgap0 := ContourShift.zeroGap_pos hT
  have hgap1 := ContourShift.zeroGap_le hT
  have hmain : ∀ v : ℂ, v.im = T' → -1/4 ≤ v.re → v.re ≤ 2 →
      ‖deriv riemannZeta v / riemannZeta v‖
        ≤ Ce * 2 * (180 + 1060 / Real.log 2) * Real.log T ^ 2 := by
    intro v hvim hvre1 hvre2
    have hvζ : riemannZeta v ≠ 0 := by
      intro hz
      by_cases hvre : v.re ≤ 0
      · exact ContourShift.zeta_ne_zero_of_re_mem (by linarith) hvre hz
      · push_neg at hvre
        have h1 := hgood v hz hvre
        rw [hvim, sub_self, abs_zero] at h1
        linarith
    have hδ : ∀ w ∈ (EdgeBound.gz_zeros_ball_finite T'
        (by norm_num : (0:ℝ) ≤ 46/25)).toFinset,
        ContourShift.zeroGap T ≤ ‖v - w‖ := by
      intro w hw
      rw [Set.Finite.mem_toFinset] at hw
      obtain ⟨hζw, ⟨hwre0, _⟩, _⟩ := EdgeBound.ball_zero_shape hT'2 hw.1 hw.2
      have h2 := hgood w hζw hwre0
      have h3 := Complex.abs_im_le_norm (v - w)
      have h4 : (v - w).im = T' - w.im := by
        rw [Complex.sub_im, hvim]
      rw [h4] at h3
      calc ContourShift.zeroGap T ≤ |w.im - T'| := h2
        _ = |T' - w.im| := abs_sub_comm _ _
        _ ≤ ‖v - w‖ := h3
    have h5 := hCe T' hT'2 v hvim hvre1 hvre2 hvζ (ContourShift.zeroGap T)
      hgap0 (by linarith) hδ
    have h5b : Ce * Real.log T' / ContourShift.zeroGap T
        = Ce * Real.log T' * (180 * Real.log T + 1060) := by
      rw [ContourShift.zeroGap]
      have hD : (180 * Real.log T + 1060 : ℝ) ≠ 0 := by positivity
      field_simp
    rw [h5b] at h5
    have h7 : Real.log T' ≤ 2 * Real.log T := by
      have h8 : Real.log T' ≤ Real.log (2*T) := by
        apply Real.log_le_log (by linarith)
        linarith
      rw [Real.log_mul (by norm_num) (by linarith)] at h8
      linarith
    have h9 : (1060:ℝ) ≤ 1060 / Real.log 2 * Real.log T := by
      rw [div_mul_eq_mul_div, le_div_iff₀ hlog2]
      nlinarith
    calc ‖deriv riemannZeta v / riemannZeta v‖
        ≤ Ce * Real.log T' * (180 * Real.log T + 1060) := h5
      _ ≤ Ce * (2*Real.log T) * (180 * Real.log T + 1060 / Real.log 2 * Real.log T) := by
          apply mul_le_mul
          · exact mul_le_mul_of_nonneg_left h7 hCe0.le
          · linarith
          · positivity
          · positivity
      _ = Ce * 2 * (180 + 1060 / Real.log 2) * Real.log T ^ 2 := by ring
  rcases (abs_eq (by linarith : (0:ℝ) ≤ T')).mp him with h | h
  · exact hmain u h hre1 hre2
  · have hu1 : u ≠ 1 := by
      intro hc
      rw [hc] at h
      simp at h
      linarith
    have hv := hmain ((starRingEnd ℂ) u)
      (by rw [Complex.conj_im, h]; ring)
      (by rw [Complex.conj_re]; exact hre1)
      (by rw [Complex.conj_re]; exact hre2)
    have heq : ‖deriv riemannZeta u / riemannZeta u‖
        = ‖deriv riemannZeta ((starRingEnd ℂ) u)
            / riemannZeta ((starRingEnd ℂ) u)‖ := by
      rw [EdgeBound.deriv_zeta_conj hu1, riemannZeta_conj, ← map_div₀,
        RCLike.norm_conj]
    rw [heq]
    exact hv

/-- **The horizontal-edge integral bound** at a good height, both
signs: `≤ C·x·log²T/T`. -/
theorem edge_horizontal_bound :
    ∃ C : ℝ, 0 < C ∧ ∀ x T T' : ℝ, 16 ≤ x → 2 ≤ T → T' ∈ Set.Icc T (T+1) →
      (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re →
        ContourShift.zeroGap T ≤ |ρ.im - T'|) →
      ∀ y : ℝ, |y| = T' →
      ‖HIntegral (Gf x) (-1/4) (1 + 1/Real.log x) y‖
        ≤ C * x * Real.log T ^ 2 / T := by
  classical
  obtain ⟨Cp, hCp0, hCp⟩ := zeta_logderiv_good_bound
  refine ⟨Cp * 3 * (9/4), by positivity, ?_⟩
  intro x T T' hx hT hT' hgood y hy
  obtain ⟨hT'lo, hT'hi⟩ := hT'
  have hT'2 : (2:ℝ) ≤ T' := le_trans hT hT'lo
  have hx0 : (0:ℝ) < x := by linarith
  have hlx : (0:ℝ) < Real.log x :=
    Real.log_pos (by linarith)
  have hlx16 : Real.log 16 ≤ Real.log x := Real.log_le_log (by norm_num) hx
  have hl16 : (2:ℝ) < Real.log 16 := by
    have h1 : (16:ℝ) = 2^4 := by norm_num
    rw [h1, Real.log_pow]
    have h2 : (0.6931471803:ℝ) < Real.log 2 := Real.log_two_gt_d9
    push_cast
    nlinarith
  have hc2 : 1 + 1/Real.log x ≤ 2 := by
    have h3 : 1/Real.log x ≤ 1/2 := by
      rw [div_le_div_iff₀ hlx (by norm_num)]
      linarith
    linarith
  have hxc : ∀ σ : ℝ, σ ≤ 1 + 1/Real.log x → x ^ σ ≤ 3 * x := by
    intro σ hσ
    have h4 : x ^ σ ≤ x ^ (1 + 1/Real.log x) := by
      apply Real.rpow_le_rpow_of_exponent_le (by linarith)
      exact hσ
    have h5 : x ^ (1 + 1/Real.log x) = x * Real.exp 1 := by
      rw [Real.rpow_add hx0, Real.rpow_one]
      congr 1
      rw [Real.rpow_def_of_pos hx0, mul_one_div, div_self (ne_of_gt hlx)]
    have h6 : Real.exp 1 ≤ 3 := by
      have := Real.exp_one_lt_d9
      linarith
    calc x ^ σ ≤ x * Real.exp 1 := by rw [← h5]; exact h4
      _ ≤ 3 * x := by nlinarith
  have hlogT0 : (0:ℝ) < Real.log T := Real.log_pos (by linarith)
  rw [HIntegral]
  have hbound : ∀ σ ∈ Set.uIoc (-1/4 : ℝ) (1 + 1/Real.log x),
      ‖Gf x (σ + y * Complex.I)‖ ≤ Cp * Real.log T ^ 2 * (3*x) / T := by
    intro σ hσ
    rw [Set.uIoc_of_le (by
      have h30 := one_div_pos.mpr hlx
      linarith : (-1/4:ℝ) ≤ 1 + 1/Real.log x)] at hσ
    obtain ⟨hσ1, hσ2⟩ := hσ
    set u : ℂ := σ + y * Complex.I with hud
    have hure : u.re = σ := by rw [hud]; simp
    have huim : u.im = y := by rw [hud]; simp
    have hp := hCp T T' hT ⟨hT'lo, hT'hi⟩ hgood u (by rw [huim]; exact hy)
      (by rw [hure]; linarith) (by rw [hure]; linarith)
    rw [Gf]
    show ‖(- deriv riemannZeta u / riemannZeta u) * ((x:ℝ):ℂ) ^ u / u‖
      ≤ Cp * Real.log T ^ 2 * (3*x) / T
    rw [norm_div, norm_mul, neg_div, norm_neg]
    have hxu : ‖((x:ℝ):ℂ) ^ u‖ ≤ 3*x := by
      rw [Complex.norm_cpow_eq_rpow_re_of_pos hx0, hure]
      exact hxc σ hσ2
    have hun : T ≤ ‖u‖ := by
      have h7 := Complex.abs_im_le_norm u
      rw [huim, hy] at h7
      linarith
    have hun0 : (0:ℝ) < ‖u‖ := by linarith
    rw [div_le_div_iff₀ hun0 (by linarith : (0:ℝ) < T)]
    calc ‖deriv riemannZeta u / riemannZeta u‖ * ‖((x:ℝ):ℂ) ^ u‖ * T
        ≤ (Cp * Real.log T ^ 2) * (3*x) * T := by
          apply mul_le_mul_of_nonneg_right ?_ (by linarith)
          apply mul_le_mul hp hxu (norm_nonneg _) (by positivity)
      _ ≤ (Cp * Real.log T ^ 2) * (3*x) * ‖u‖ := by
          apply mul_le_mul_of_nonneg_left hun ?_
          positivity
      _ = Cp * Real.log T ^ 2 * (3*x) * ‖u‖ := by ring
  calc ‖∫ σ in (-1/4 : ℝ)..(1 + 1/Real.log x), Gf x (σ + y * Complex.I)‖
      ≤ Cp * Real.log T ^ 2 * (3*x) / T * |(1 + 1/Real.log x) - (-1/4)| :=
        intervalIntegral.norm_integral_le_of_norm_le_const hbound
    _ ≤ Cp * 3 * (9/4) * x * Real.log T ^ 2 / T := by
        have h8 : |(1 + 1/Real.log x) - (-1/4 : ℝ)| ≤ 9/4 := by
          have h30 := one_div_pos.mpr hlx
          rw [abs_of_pos (by linarith)]
          linarith
        have h9 : (0:ℝ) ≤ Cp * Real.log T ^ 2 * (3*x) / T := by positivity
        calc Cp * Real.log T ^ 2 * (3*x) / T * |(1 + 1/Real.log x) - (-1/4)|
            ≤ Cp * Real.log T ^ 2 * (3*x) / T * (9/4) := by
              apply mul_le_mul_of_nonneg_left h8 h9
          _ = Cp * 3 * (9/4) * x * Real.log T ^ 2 / T := by ring


/-- info: 'Glue.band_order_sum_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms band_order_sum_le

/-- info: 'Glue.zeroPartialSum_swap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeroPartialSum_swap

end Glue
