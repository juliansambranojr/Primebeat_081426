/-
ExplicitTwo — block G2 of `lean_stage3/design/floor.md`. 2026-11-23.

`LeftSmooth.explicit_formula_all` with the floor lowered from `16 ≤ x` to
`2 ≤ x`, as a parallel chain. Perron's formula comes from block G1
(`PerronTwo.explicit_formula_perron_two`). Every `x`-free lemma is reused
unchanged; the lemmas below are copies of the originals with the lines that
used the floor rewritten. No proved file is edited.

  residue_identity_two         1 < x  (copy of ContourShift.residue_identity)
  zeroPartialSum_swap_two      1 ≤ x  (copy of Glue.zeroPartialSum_swap_num)
  logDeriv_re_ge_two           2 ≤ Re u ⊢ ‖ζ′/ζ(u)‖ ≤ 6
  Cpn_ge                       360 ≤ Cpn
  logDeriv_good_ext            the good bound on −1/4 ≤ Re u ≤ 5/2, constant Cpn
  Cht                          Cpn·3·(11/4)
  edge_horizontal_bound_two    2 ≤ x ⊢ horizontal edge ≤ Cht·x·log²T/T
  c1t, c3t                     2800 + 2·Cht + Csn,  18 + ‖ζ′(0)/ζ(0)‖/log 2
  explicit_formula_left_two    2 ≤ x, 2 ≤ T ⊢ the formula with the left edge kept
  series_side_two              2 ≤ x ⊢ series side ≤ 4·Bser·x^(−1/4)
  smooth_side_two              2 ≤ x ⊢ smooth side ≤ 4·Bsm·x^(−1/4)
  Bleft2                       4·Bleft
  left_edge_bound_two          2 ≤ x, 2 ≤ T ⊢ left edge ≤ Bleft2·x^(−1/4)
  explicit_formula_all_two     2 ≤ x, 2 ≤ T ⊢ ‖ψ x − x + Σ‖
                                 ≤ c1t·x·log²(xT)/T + c3t·log x + Bleft2·x^(−1/4)

Where the floor bit in the originals: `c = 1 + 1/log x ≤ 2` (now `≤ 5/2`;
above `Re u = 2` the good bound is replaced by the absolute bound on
`ζ′/ζ`, and the edge length is `≤ 11/4`), `32 ≤ x·T` (now `4 ≤ x·T`),
`K0 ≤ K0/2·log x` (now `K0 ≤ K0/log 2·log x`), and `log 16 ≤ log x` in
`Bser`, `Bsm` (now `log 2`, a factor four).

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LeftSmooth
import Stage3.PerronTwo
import Stage3.LineBound

namespace ExplicitTwo

open Complex Topology Set MeasureTheory

section Residue

open ContourShift

/-- **The residue identity from `x > 1`.** `ContourShift.residue_identity` with
the hypothesis `16 ≤ x` lowered to `1 < x`: on the good rectangle from
`−1/4 − iT′` to `1 + 1/log x + iT′`, the normalized contour integral of
`−ζ′/ζ(s)·x^s/s` is `x − ζ′/ζ(0) − Σ_{|γ|<T′} m·x^ρ/ρ`. The proof is the original's;
only the derivations of `0 < x` and `0 < log x` change. -/
theorem residue_identity_two {x T T' : ℝ} (hx : 1 < x) (hT : 2 ≤ T)
    (hT' : T' ∈ Set.Icc T (T+1))
    (hgood : ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → zeroGap T ≤ |ρ.im - T'|) :
    RectangleIntegral'
        (fun s : ℂ ↦ (- deriv riemannZeta s / riemannZeta s)
          * ((x:ℝ):ℂ) ^ s / s)
        (((-1/4 : ℝ):ℂ) - Complex.I * T') (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * T')
      = (x : ℂ) - deriv riemannZeta 0 / riemannZeta 0
        - Stage3.zeroPartialSum x T' := by
  classical
  have hx0 : (0:ℝ) < x := by linarith
  have hlx : (0:ℝ) < Real.log x := Real.log_pos hx
  obtain ⟨hT'lo, hT'hi⟩ := hT'
  have hT'2 : (2:ℝ) ≤ T' := le_trans hT hT'lo
  set c : ℝ := 1 + 1/Real.log x with hcd
  have hc1 : 1 < c := by
    rw [hcd]
    have h1 : (0:ℝ) < 1/Real.log x := by positivity
    linarith
  set zc : ℂ := ((-1/4 : ℝ):ℂ) - Complex.I * (T':ℂ) with hzcd
  set wc : ℂ := ((c:ℝ):ℂ) + Complex.I * (T':ℂ) with hwcd
  have hzre : zc.re = -1/4 := by rw [hzcd]; simp
  have hzim : zc.im = -T' := by rw [hzcd]; simp
  have hwre : wc.re = c := by rw [hwcd]; simp
  have hwim : wc.im = T' := by rw [hwcd]; simp
  have hrele : zc.re ≤ wc.re := by rw [hzre, hwre]; linarith
  have himle : zc.im ≤ wc.im := by rw [hzim, hwim]; linarith
  have hrect_mem : ∀ s : ℂ, s ∈ Rectangle zc wc ↔
      ((-1/4 ≤ s.re ∧ s.re ≤ c) ∧ (-T' ≤ s.im ∧ s.im ≤ T')) := by
    intro s
    simp only [Rectangle]
    rw [Complex.mem_reProdIm, hzre, hwre, hzim, hwim,
      Set.uIcc_of_le (by linarith : (-1/4:ℝ) ≤ c),
      Set.uIcc_of_le (by linarith : -T' ≤ T'), Set.mem_Icc, Set.mem_Icc]
  have hfence : ∀ ρ : ℂ, riemannZeta ρ = 0 → ρ ∈ Rectangle zc wc →
      ((0 < ρ.re ∧ ρ.re < 1) ∧ |ρ.im| < T') := by
    intro ρ hz hρR
    obtain ⟨⟨hre1, hre2⟩, him1, him2⟩ := (hrect_mem ρ).mp hρR
    have hre_pos : 0 < ρ.re := by
      by_contra hle
      rw [not_lt] at hle
      exact zeta_ne_zero_of_re_mem (by linarith) hle hz
    have hre_lt1 : ρ.re < 1 := by
      by_contra hge
      rw [not_lt] at hge
      exact riemannZeta_ne_zero_of_one_le_re hge hz
    have hgap := zeroGap_pos hT
    have hgd := hgood ρ hz hre_pos
    have him_ne : ρ.im ≠ T' := by
      intro h
      rw [h, sub_self, abs_zero] at hgd
      linarith
    have him_ne2 : ρ.im ≠ -T' := by
      intro h
      have hzc2 : riemannZeta ((starRingEnd ℂ) ρ) = 0 := by
        rw [riemannZeta_conj, hz, map_zero]
      have hgd2 := hgood _ hzc2 (by rw [Complex.conj_re]; exact hre_pos)
      rw [Complex.conj_im, h, neg_neg, sub_self, abs_zero] at hgd2
      linarith
    refine ⟨⟨hre_pos, hre_lt1⟩, ?_⟩
    rw [abs_lt]
    exact ⟨lt_of_le_of_ne him1 (Ne.symm him_ne2), lt_of_le_of_ne him2 him_ne⟩
  have hfin := zeta_zeros_rectangle_finite zc wc
  set ZF : Finset ℂ := hfin.toFinset with hZFd
  have hZF_mem : ∀ ρ : ℂ, ρ ∈ ZF ↔ (riemannZeta ρ = 0 ∧ ρ ∈ Rectangle zc wc) := by
    intro ρ
    rw [hZFd, Set.Finite.mem_toFinset]
    exact Iff.rfl
  have h0ZF : (0:ℂ) ∉ ZF := by
    intro h
    have h2 := ((hZF_mem 0).mp h).1
    rw [riemannZeta_zero] at h2
    norm_num at h2
  have h1ZF : (1:ℂ) ∉ ZF := by
    intro h
    obtain ⟨hz2, hρR2⟩ := (hZF_mem 1).mp h
    have h3 := (hfence 1 hz2 hρR2).1.2
    simp at h3
  set P : Finset ℂ := insert 0 (insert 1 ZF) with hPd
  set A : ℂ → ℂ := fun p ↦ if p = 0 then - deriv riemannZeta 0 / riemannZeta 0
    else if p = 1 then ((x:ℝ):ℂ)
    else -(analyticOrderNatAt riemannZeta p : ℂ) * ((x:ℝ):ℂ) ^ p / p with hAd
  have hpIn : ∀ p ∈ P, Rectangle zc wc ∈ nhds p := by
    intro p hp
    rw [rectangle_mem_nhds_iff, Set.uIoo_of_le hrele, Set.uIoo_of_le himle,
      Complex.mem_reProdIm, hzre, hwre, hzim, hwim, Set.mem_Ioo, Set.mem_Ioo]
    rw [hPd] at hp
    rcases Finset.mem_insert.mp hp with rfl | hp2
    · simp only [Complex.zero_re, Complex.zero_im]
      refine ⟨⟨by norm_num, by linarith⟩, ⟨by linarith, by linarith⟩⟩
    rcases Finset.mem_insert.mp hp2 with rfl | hpZ
    · simp only [Complex.one_re, Complex.one_im]
      refine ⟨⟨by norm_num, hc1⟩, ⟨by linarith, by linarith⟩⟩
    · obtain ⟨hz2, hρR2⟩ := (hZF_mem p).mp hpZ
      obtain ⟨⟨hh1, hh2⟩, hh3⟩ := hfence p hz2 hρR2
      rw [abs_lt] at hh3
      exact ⟨⟨by linarith, by linarith⟩, hh3⟩
  have hfHolo : HolomorphicOn (fun s : ℂ ↦ (- deriv riemannZeta s / riemannZeta s)
      * ((x:ℝ):ℂ) ^ s / s) (Rectangle zc wc \ (P : Set ℂ)) := by
    intro s hs
    obtain ⟨hsR, hsP⟩ := hs
    have hs0 : s ≠ 0 := by
      intro h
      apply hsP
      rw [hPd, h]
      simp
    have hs1 : s ≠ 1 := by
      intro h
      apply hsP
      rw [hPd, h]
      simp
    have hsz : riemannZeta s ≠ 0 := by
      intro h
      apply hsP
      rw [hPd]
      have h4 : s ∈ ZF := (hZF_mem s).mpr ⟨h, hsR⟩
      simp [h4]
    have hζan := zeta_analyticAt hs1
    have hd1 : DifferentiableAt ℂ (fun t : ℂ ↦ - deriv riemannZeta t / riemannZeta t) s :=
      (hζan.deriv.differentiableAt.neg).div hζan.differentiableAt hsz
    have hd2 : DifferentiableAt ℂ (fun t : ℂ ↦ ((x:ℝ):ℂ) ^ t) s :=
      (differentiable_id.const_cpow
        (Or.inl (Complex.ofReal_ne_zero.mpr hx0.ne'))).differentiableAt
    exact ((hd1.mul hd2).div differentiableAt_id hs0).differentiableWithinAt
  have hloc : ∀ p ∈ P, ∃ h : ℂ → ℂ, AnalyticAt ℂ h p ∧
      ∀ᶠ s in nhdsWithin p {p}ᶜ,
        (- deriv riemannZeta s / riemannZeta s) * ((x:ℝ):ℂ) ^ s / s
          = h s + A p / (s - p) := by
    intro p hp
    rw [hPd] at hp
    rcases Finset.mem_insert.mp hp with rfl | hp2
    · have hA0 : A 0 = - deriv riemannZeta 0 / riemannZeta 0 := by simp [hAd]
      obtain ⟨h, hha, hhe⟩ := zeta_local_data_origin hx0
      refine ⟨h, hha, ?_⟩
      filter_upwards [hhe] with s hs
      rw [hA0]
      exact hs
    rcases Finset.mem_insert.mp hp2 with rfl | hpZ
    · have hA1 : A 1 = ((x:ℝ):ℂ) := by simp [hAd]
      obtain ⟨h, hha, hhe⟩ := zeta_local_data_one hx0
      refine ⟨h, hha, ?_⟩
      filter_upwards [hhe] with s hs
      rw [hA1]
      exact hs
    · obtain ⟨hz2, hρR2⟩ := (hZF_mem p).mp hpZ
      obtain ⟨⟨hh1, hh2⟩, _⟩ := hfence p hz2 hρR2
      have hp0 : p ≠ 0 := by
        intro h
        rw [h] at hh1
        simp at hh1
      have hp1 : p ≠ 1 := by
        intro h
        rw [h] at hh2
        simp at hh2
      have hAρ : A p = -(analyticOrderNatAt riemannZeta p : ℂ) * ((x:ℝ):ℂ) ^ p / p := by
        simp [hAd, hp0, hp1]
      obtain ⟨h, hha, hhe⟩ := zeta_local_data_zero hx0 hp0 hp1 hz2
      refine ⟨h, hha, ?_⟩
      filter_upwards [hhe] with s hs
      rw [hAρ]
      exact hs
  have hmain := residue_rectangle_of_local hrele himle hpIn hfHolo hloc
  rw [hmain]
  have hA0 : A 0 = - deriv riemannZeta 0 / riemannZeta 0 := by simp [hAd]
  have hA1 : A 1 = ((x:ℝ):ℂ) := by simp [hAd]
  have h0in : (0:ℂ) ∉ insert (1:ℂ) ZF := by
    intro h
    rcases Finset.mem_insert.mp h with h | h
    · exact (by norm_num : (0:ℂ) ≠ 1) h
    · exact h0ZF h
  rw [hPd, Finset.sum_insert h0in, Finset.sum_insert h1ZF, hA0, hA1]
  have hiff : ∀ ρ : ℂ, ρ ∈ ZF ↔ (ρ ∈ Kadiri.NontrivialZeros ∧ |ρ.im| < T') := by
    intro ρ
    rw [hZF_mem]
    constructor
    · rintro ⟨hz2, hρR2⟩
      obtain ⟨⟨hh1, hh2⟩, hh3⟩ := hfence ρ hz2 hρR2
      exact ⟨⟨⟨hh1, hh2⟩, Set.mem_univ _, hz2⟩, hh3⟩
    · rintro ⟨⟨hre, _, hz2⟩, him⟩
      rw [abs_lt] at him
      refine ⟨hz2, (hrect_mem ρ).mpr ⟨⟨by linarith [hre.1], by linarith [hre.2]⟩,
        by linarith [him.1], by linarith [him.2]⟩⟩
  have hZPS := zeroPartialSum_eq_sum (x := x) hiff
  have hsum2 : ∑ p ∈ ZF, A p
      = -∑ p ∈ ZF, ((analyticOrderNatAt riemannZeta p : ℂ) * ((x : ℂ) ^ p / p)) := by
    rw [← Finset.sum_neg_distrib]
    apply Finset.sum_congr rfl
    intro p hpZ
    obtain ⟨hz2, hρR2⟩ := (hZF_mem p).mp hpZ
    obtain ⟨⟨hh1, hh2⟩, _⟩ := hfence p hz2 hρR2
    have hp0 : p ≠ 0 := by
      intro h
      rw [h] at hh1
      simp at hh1
    have hp1 : p ≠ 1 := by
      intro h
      rw [h] at hh2
      simp at hh2
    rw [hAd]
    simp only [if_neg hp0, if_neg hp1]
    ring
  rw [hsum2, hZPS]
  ring

/-- info: 'ExplicitTwo.residue_identity_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms residue_identity_two

end Residue

/-- **The swap from `x ≥ 1`.** `Glue.zeroPartialSum_swap_num` with `16 ≤ x` lowered to
`1 ≤ x`: moving the zero sum from a height `T′ ∈ [T, T+1]` back to `T` costs at most
`Csn·x·log T/T`. -/
theorem zeroPartialSum_swap_two :
    ∀ x T T' : ℝ, 1 ≤ x → 2 ≤ T → T ≤ T' → T' ≤ T + 1 →
      ‖Stage3.zeroPartialSum x T' - Stage3.zeroPartialSum x T‖
        ≤ Glue.Csn * x * Real.log T / T := by
  classical
  obtain ⟨C2, hC2def⟩ : ∃ C2 : ℝ, C2 = Glue.Csn := ⟨_, rfl⟩
  have hC20 : 0 < C2 := by rw [hC2def]; exact Glue.Csn_pos
  have hC2 := Glue.band_order_sum_le_num
  rw [← hC2def] at hC2
  rw [← hC2def]
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
    have hnot' : T ≤ |ρ.im| := by
      by_contra h
      rw [not_le] at h
      exact hnot ⟨hρb, h⟩
    obtain ⟨hζ, hre, himb⟩ := hbase_shape ρ hρb
    exact ⟨hζ, hre, hnot', himb⟩
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

/-- **The absolute bound right of `Re = 2`.** For `2 ≤ Re u`, `‖ζ′/ζ(u)‖ ≤ 6`, from
`Slice5.norm_logDerivZeta_of_one_lt_re` (`≤ 2/(σ−1) + 4/(σ−1)²`, RH-free). -/
theorem logDeriv_re_ge_two {u : ℂ} (hu : 2 ≤ u.re) :
    ‖deriv riemannZeta u / riemannZeta u‖ ≤ 6 := by
  have h := Slice5.norm_logDerivZeta_of_one_lt_re (s := u) (by linarith)
  have h1 : (1:ℝ) ≤ u.re - 1 := by linarith
  have h2 : 2 / (u.re - 1) ≤ 2 := by
    rw [div_le_iff₀ (by linarith)]
    linarith
  have h3 : 4 / (u.re - 1) ^ 2 ≤ 4 := by
    rw [div_le_iff₀ (by positivity)]
    nlinarith
  linarith

/-- The good-height constant is at least `360`: `Cpn = Cen·2·(180 + 1060/log 2)` with
`Cen = C1n + C2n + 1/log 2 ≥ 1`. -/
theorem Cpn_ge : (360:ℝ) ≤ Glue.Cpn := by
  have hl : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have hl1 : Real.log 2 ≤ 1 := by
    have := Real.log_le_sub_one_of_pos (show (0:ℝ) < 2 by norm_num)
    linarith
  have h1 := EdgeBound.C1n_pos
  have h2 := EdgeBound.C2n_pos
  have hinv : (1:ℝ) ≤ 1 / Real.log 2 := by
    rw [le_div_iff₀ hl]
    linarith
  have hCe : (1:ℝ) ≤ EdgeBound.Cen := by
    unfold EdgeBound.Cen
    linarith
  have hq : (0:ℝ) ≤ 1060 / Real.log 2 := by positivity
  unfold Glue.Cpn
  nlinarith

/-- **The good-height bound on the wider band.** `Glue.zeta_logderiv_good_bound_num`
extended from `−1/4 ≤ Re u ≤ 2` to `−1/4 ≤ Re u ≤ 5/2`, same constant `Cpn`: below
`Re u = 2` it is the original; above, `‖ζ′/ζ(u)‖ ≤ 6 ≤ 360·log²2 ≤ Cpn·log²T`. -/
theorem logDeriv_good_ext :
    ∀ T T' : ℝ, 2 ≤ T → T' ∈ Set.Icc T (T+1) →
      (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re →
        ContourShift.zeroGap T ≤ |ρ.im - T'|) →
      ∀ u : ℂ, |u.im| = T' → -1/4 ≤ u.re → u.re ≤ 5/2 →
      ‖deriv riemannZeta u / riemannZeta u‖ ≤ Glue.Cpn * Real.log T ^ 2 := by
  intro T T' hT hT' hgood u him hre1 hre2
  rcases le_total u.re 2 with h | h
  · exact Glue.zeta_logderiv_good_bound_num T T' hT hT' hgood u him hre1 h
  · have h6 := logDeriv_re_ge_two h
    have hC := Cpn_ge
    have hl2 : (0.6931471803:ℝ) < Real.log 2 := Real.log_two_gt_d9
    have hlT : Real.log 2 ≤ Real.log T := Real.log_le_log (by norm_num) hT
    have hsq : (0.48:ℝ) ≤ Real.log T ^ 2 := by nlinarith
    nlinarith

/-- The horizontal-edge constant from `x = 2`: `Cpn·3·(11/4)`. The edge runs from
`−1/4` to `c ≤ 5/2`, length at most `11/4`. -/
noncomputable def Cht : ℝ := Glue.Cpn * 3 * (11/4)

/-- The horizontal-edge constant `Cht` is positive. -/
theorem Cht_pos : 0 < Cht := by
  have h := Glue.Cpn_pos
  unfold Cht
  positivity

/-- **The horizontal-edge integral bound from `x = 2`.** `Glue.edge_horizontal_bound_num`
for `2 ≤ x`: at a good height, both signs, the integral of `−ζ′/ζ(s)·x^s/s` along
`Im s = y`, `|y| = T′`, from `−1/4` to `1 + 1/log x`, has norm at most
`Cht·x·log²T/T`. The abscissa is now `≤ 5/2`, the good bound is `logDeriv_good_ext`,
and the edge length is `≤ 11/4`. -/
theorem edge_horizontal_bound_two :
    ∀ x T T' : ℝ, 2 ≤ x → 2 ≤ T → T' ∈ Set.Icc T (T+1) →
      (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re →
        ContourShift.zeroGap T ≤ |ρ.im - T'|) →
      ∀ y : ℝ, |y| = T' →
      ‖HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) y‖
        ≤ Cht * x * Real.log T ^ 2 / T := by
  classical
  obtain ⟨Cp, hCpdef⟩ : ∃ Cp : ℝ, Cp = Glue.Cpn := ⟨_, rfl⟩
  have hCp0 : 0 < Cp := by rw [hCpdef]; exact Glue.Cpn_pos
  have hCp := logDeriv_good_ext
  rw [← hCpdef] at hCp
  have hCdef : Cht = Cp * 3 * (11/4) := by
    unfold Cht
    rw [hCpdef]
  rw [hCdef]
  intro x T T' hx hT hT' hgood y hy
  obtain ⟨hT'lo, hT'hi⟩ := hT'
  have hT'2 : (2:ℝ) ≤ T' := le_trans hT hT'lo
  have hx0 : (0:ℝ) < x := by linarith
  have hlx : (0:ℝ) < Real.log x :=
    Real.log_pos (by linarith)
  have hc2 : 1 + 1/Real.log x ≤ 5/2 := by
    have h3 : 1/Real.log x ≤ 3/2 := PerronTwo.inv_log_le_of_two_le hx
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
      ‖Glue.Gf x (σ + y * Complex.I)‖ ≤ Cp * Real.log T ^ 2 * (3*x) / T := by
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
    rw [Glue.Gf]
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
  calc ‖∫ σ in (-1/4 : ℝ)..(1 + 1/Real.log x), Glue.Gf x (σ + y * Complex.I)‖
      ≤ Cp * Real.log T ^ 2 * (3*x) / T * |(1 + 1/Real.log x) - (-1/4)| :=
        intervalIntegral.norm_integral_le_of_norm_le_const hbound
    _ ≤ Cp * 3 * (11/4) * x * Real.log T ^ 2 / T := by
        have h8 : |(1 + 1/Real.log x) - (-1/4 : ℝ)| ≤ 11/4 := by
          have h30 := one_div_pos.mpr hlx
          rw [abs_of_pos (by linarith)]
          linarith
        have h9 : (0:ℝ) ≤ Cp * Real.log T ^ 2 * (3*x) / T := by positivity
        calc Cp * Real.log T ^ 2 * (3*x) / T * |(1 + 1/Real.log x) - (-1/4)|
            ≤ Cp * Real.log T ^ 2 * (3*x) / T * (11/4) := by
              apply mul_le_mul_of_nonneg_left h8 h9
          _ = Cp * 3 * (11/4) * x * Real.log T ^ 2 / T := by ring

/-- info: 'ExplicitTwo.edge_horizontal_bound_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms edge_horizontal_bound_two

/-- The explicit formula's first constant from `x = 2`: `2800 + 2·Cht + Csn`. -/
noncomputable def c1t : ℝ := 2800 + 2 * Cht + Glue.Csn

/-- The explicit formula's log-constant from `x = 2`: `18 + ‖ζ′(0)/ζ(0)‖/log 2`. -/
noncomputable def c3t : ℝ := 18 + ‖deriv riemannZeta 0 / riemannZeta 0‖ / Real.log 2

set_option maxHeartbeats 1600000 in
/-- **The explicit formula with the left edge kept, from `x = 2`.** For `2 ≤ x` and
`2 ≤ T` there is a height `T′` in `[T, T+1]` with
`‖ψ(x) − x + Σ_{|γ|<T} m·x^ρ/ρ‖ ≤ c1t·x·log²(xT)/T + c3t·log x + ‖left edge at T′‖`.
`ExplicitLeft.explicit_formula_left`'s proof on the chain from `x = 2`: Perron from
`PerronTwo`, the residue identity, the horizontal edges and the swap from this file. -/
theorem explicit_formula_left_two {x T : ℝ} (hx : 2 ≤ x) (hT : 2 ≤ T) :
    ∃ T' : ℝ, T ≤ T' ∧ T' ≤ T + 1 ∧
      ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖
        ≤ c1t * x * Real.log (x*T)^2 / T + c3t * Real.log x
          + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖ := by
  classical
  obtain ⟨Ch, hChdef⟩ : ∃ Ch : ℝ, Ch = Cht := ⟨_, rfl⟩
  have hCh0 : 0 < Ch := by rw [hChdef]; exact Cht_pos
  have hCh := edge_horizontal_bound_two
  rw [← hChdef] at hCh
  obtain ⟨Cs, hCsdef⟩ : ∃ Cs : ℝ, Cs = Glue.Csn := ⟨_, rfl⟩
  have hCs0 : 0 < Cs := by rw [hCsdef]; exact Glue.Csn_pos
  have hCs := zeroPartialSum_swap_two
  rw [← hCsdef] at hCs
  set K0 : ℝ := ‖deriv riemannZeta 0 / riemannZeta 0‖ with hK0d
  have hK00 : (0:ℝ) ≤ K0 := norm_nonneg _
  have hC1 : c1t = 2800 + 2*Ch + Cs := by
    unfold c1t
    rw [hChdef, hCsdef]
  have hC3 : c3t = 18 + K0/Real.log 2 := by
    unfold c3t
    rw [hK0d]
  rw [hC1, hC3]
  have hx0 : (0:ℝ) < x := by linarith
  have hl2 : (0.6931471803:ℝ) < Real.log 2 := Real.log_two_gt_d9
  have hl20 : (0:ℝ) < Real.log 2 := by linarith
  have hlx2 : Real.log 2 ≤ Real.log x := Real.log_le_log (by norm_num) hx
  obtain ⟨T', hT'mem, hgood⟩ := ContourShift.goodT_exists hT
  obtain ⟨hT'lo, hT'hi⟩ := hT'mem
  refine ⟨T', hT'lo, hT'hi, ?_⟩
  have hT'2 : (2:ℝ) ≤ T' := le_trans hT hT'lo
  have hT'1 : (1:ℝ) ≤ T' := by linarith
  have hT0 : (0:ℝ) < T := by linarith
  have hT'0 : (0:ℝ) < T' := by linarith
  have hS1 := PerronTwo.explicit_formula_perron_two (x := x) (T := T') hx hT'2
  have hS4 := residue_identity_two (by linarith : (1:ℝ) < x) hT ⟨hT'lo, hT'hi⟩ hgood
  set P : ℂ := (2 * (Real.pi:ℂ) * Complex.I)⁻¹
      * ∫ t in (-T')..T',
          (- deriv riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t)
            / riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t))
          * ((x:ℝ):ℂ) ^ (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t)
          / (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t) * Complex.I with hPd
  set zc : ℂ := ((-1/4 : ℝ):ℂ) - Complex.I * (T':ℂ) with hzcd
  set wc : ℂ := ((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * (T':ℂ) with hwcd
  have hS4g : RectangleIntegral' (Glue.Gf x) zc wc
      = (x:ℂ) - deriv riemannZeta 0 / riemannZeta 0
        - Stage3.zeroPartialSum x T' := hS4
  have hzre : zc.re = -1/4 := by rw [hzcd]; simp
  have hzim : zc.im = -T' := by rw [hzcd]; simp
  have hwre : wc.re = 1 + 1/Real.log x := by rw [hwcd]; simp
  have hwim : wc.im = T' := by rw [hwcd]; simp
  have hsplit : RectangleIntegral (Glue.Gf x) zc wc
      = HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) (-T')
        - HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) T'
        + VIntegral (Glue.Gf x) (1 + 1/Real.log x) (-T') T'
        - VIntegral (Glue.Gf x) (-1/4) (-T') T' := by
    simp only [RectangleIntegral]
    rw [hzre, hzim, hwre, hwim]
  have hPV : P = (2 * (Real.pi:ℂ) * Complex.I)⁻¹
      * VIntegral (Glue.Gf x) (1 + 1/Real.log x) (-T') T' := by
    rw [hPd, VIntegral, smul_eq_mul]
    congr 1
    rw [intervalIntegral.integral_mul_const, mul_comm]
    congr 1
    apply intervalIntegral.integral_congr
    intro t _
    have harg : ((1 + 1/Real.log x : ℝ):ℂ) + (t:ℂ) * Complex.I
        = ((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * (t:ℂ) := by ring
    simp only [Glue.Gf]
    rw [harg]
  have hPR : P - RectangleIntegral' (Glue.Gf x) zc wc
      = (2 * (Real.pi:ℂ) * Complex.I)⁻¹
        * (- HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) (-T')
          + HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) T'
          + VIntegral (Glue.Gf x) (-1/4) (-T') T') := by
    rw [hPV, RectangleIntegral', smul_eq_mul, hsplit,
      show (1 / (2 * (Real.pi:ℂ) * Complex.I)) = (2 * (Real.pi:ℂ) * Complex.I)⁻¹
        from one_div _]
    ring
  have hinv : ‖(2 * (Real.pi:ℂ) * Complex.I)⁻¹‖ ≤ 1 := by
    rw [norm_inv, norm_mul, norm_mul, Complex.norm_I, mul_one]
    have h3 : ‖(2:ℂ)‖ = 2 := by norm_num
    have h4 : ‖((Real.pi:ℝ):ℂ)‖ = Real.pi := by
      rw [Complex.norm_real, Real.norm_eq_abs, abs_of_pos Real.pi_pos]
    rw [h3, h4]
    have h5 : (1:ℝ) ≤ 2 * Real.pi := by nlinarith [Real.pi_gt_three]
    exact inv_le_one_of_one_le₀ h5
  have hEtop := hCh x T T' hx hT ⟨hT'lo, hT'hi⟩ hgood T'
    (abs_of_pos (by linarith))
  have hEbot := hCh x T T' hx hT ⟨hT'lo, hT'hi⟩ hgood (-T')
    (by rw [abs_neg]; exact abs_of_pos (by linarith))
  have hE : ‖P - RectangleIntegral' (Glue.Gf x) zc wc‖
      ≤ 2*(Ch * x * Real.log T^2 / T) + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖ := by
    rw [hPR, norm_mul]
    have h6 : ‖- HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) (-T')
        + HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) T'
        + VIntegral (Glue.Gf x) (-1/4) (-T') T'‖
        ≤ ‖HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) (-T')‖
          + ‖HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) T'‖
          + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖ := by
      calc ‖_ + _ + _‖ ≤ ‖- HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) (-T')
            + HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) T'‖
            + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖ := norm_add_le _ _
        _ ≤ _ := by
            have h7 := norm_add_le (- HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) (-T'))
              (HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) T')
            rw [norm_neg] at h7
            linarith
    calc ‖(2 * (Real.pi:ℂ) * Complex.I)⁻¹‖ * ‖_‖
        ≤ 1 * (‖HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) (-T')‖
          + ‖HIntegral (Glue.Gf x) (-1/4) (1 + 1/Real.log x) T'‖
          + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖) := by
          apply mul_le_mul hinv h6 (norm_nonneg _) (by norm_num)
      _ ≤ 2*(Ch * x * Real.log T^2 / T) + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖ := by
          rw [one_mul]
          linarith [hEtop, hEbot]
  have hswap := hCs x T T' (by linarith) hT hT'lo (by linarith)
  have hswap' : ‖Stage3.zeroPartialSum x T - Stage3.zeroPartialSum x T'‖
      ≤ Cs * x * Real.log T / T := by
    rw [← norm_neg, neg_sub]
    exact hswap
  have hkey : (Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T
      = ((Chebyshev.psi x : ℂ) - P)
        + (P - RectangleIntegral' (Glue.Gf x) zc wc)
        + (RectangleIntegral' (Glue.Gf x) zc wc - (x:ℂ) + Stage3.zeroPartialSum x T')
        + (Stage3.zeroPartialSum x T - Stage3.zeroPartialSum x T') := by
    ring
  have hCn : ‖RectangleIntegral' (Glue.Gf x) zc wc - (x:ℂ)
      + Stage3.zeroPartialSum x T'‖ = K0 := by
    rw [show RectangleIntegral' (Glue.Gf x) zc wc - (x:ℂ) + Stage3.zeroPartialSum x T'
        = - (deriv riemannZeta 0 / riemannZeta 0) by rw [hS4g]; ring]
    rw [norm_neg]
  -- the arithmetic
  have hL1 : (1:ℝ) ≤ Real.log (x*T) := by
    have h8 : (4:ℝ) ≤ x*T := by nlinarith
    have h9 : Real.log 4 ≤ Real.log (x*T) := Real.log_le_log (by norm_num) h8
    rw [show (4:ℝ) = 2^2 by norm_num, Real.log_pow] at h9
    push_cast at h9
    nlinarith
  have hL0 : (0:ℝ) ≤ Real.log (x*T) := by linarith
  have hsq : Real.log (x*T')^2 ≤ 4*Real.log (x*T)^2 := by
    have h11 : x*T' ≤ 2*(x*T) := by nlinarith
    have h12 : Real.log (x*T') ≤ Real.log (2*(x*T)) :=
      Real.log_le_log (by positivity) h11
    have h12b : Real.log (2*(x*T)) = Real.log 2 + Real.log (x*T) :=
      Real.log_mul (by norm_num) (by positivity)
    rw [h12b] at h12
    have h13 : Real.log 2 ≤ 1 := by
      have := Real.log_le_sub_one_of_pos (show (0:ℝ) < 2 by norm_num)
      linarith
    have h14 : Real.log (x*T') ≤ 2*Real.log (x*T) := by linarith
    have h15 : (0:ℝ) ≤ Real.log (x*T') := by
      apply Real.log_nonneg
      nlinarith
    calc Real.log (x*T')^2 ≤ (2*Real.log (x*T))^2 := by
          apply pow_le_pow_left₀ h15 h14
      _ = 4*Real.log (x*T)^2 := by ring
  have he1 : 700 * x * Real.log (x*T')^2 / T' + 18*Real.log x
      ≤ 2800 * x * Real.log (x*T)^2 / T + 18*Real.log x := by
    have h16 : 700 * x * Real.log (x*T')^2 ≤ 2800 * x * Real.log (x*T)^2 := by
      have h16b := mul_le_mul_of_nonneg_left hsq (show (0:ℝ) ≤ 700*x by linarith)
      nlinarith [h16b]
    have h17 : 700 * x * Real.log (x*T')^2 / T'
        ≤ 2800 * x * Real.log (x*T)^2 / T' := by
      apply div_le_div_of_nonneg_right h16 hT'0.le
    have h18 : 2800 * x * Real.log (x*T)^2 / T'
        ≤ 2800 * x * Real.log (x*T)^2 / T := by
      apply div_le_div_of_nonneg_left (by positivity) hT0 hT'lo
    linarith
  have he2 : 2*(Ch * x * Real.log T^2 / T) ≤ 2*Ch * x * Real.log (x*T)^2 / T := by
    have h19 : Real.log T ≤ Real.log (x*T) := by
      apply Real.log_le_log hT0
      nlinarith
    have h20 : (0:ℝ) ≤ Real.log T := Real.log_nonneg (by linarith)
    have h21 : Real.log T^2 ≤ Real.log (x*T)^2 := by
      apply pow_le_pow_left₀ h20 h19
    have h22 : 2*Ch * x * Real.log T^2 ≤ 2*Ch * x * Real.log (x*T)^2 := by
      have h22b := mul_le_mul_of_nonneg_left h21 (show (0:ℝ) ≤ 2*Ch*x by positivity)
      nlinarith [h22b]
    have h23 : 2*Ch * x * Real.log T^2 / T ≤ 2*Ch * x * Real.log (x*T)^2 / T := by
      apply div_le_div_of_nonneg_right h22 hT0.le
    calc 2*(Ch * x * Real.log T^2 / T) = 2*Ch * x * Real.log T^2 / T := by ring
      _ ≤ 2*Ch * x * Real.log (x*T)^2 / T := h23
  have he3 : K0 ≤ K0/Real.log 2 * Real.log x := by
    rw [div_mul_eq_mul_div, le_div_iff₀ hl20]
    nlinarith [mul_le_mul_of_nonneg_left hlx2 hK00]
  have he4 : Cs * x * Real.log T / T ≤ Cs * x * Real.log (x*T)^2 / T := by
    have h19 : Real.log T ≤ Real.log (x*T) := by
      apply Real.log_le_log hT0
      nlinarith
    have h20 : (0:ℝ) ≤ Real.log T := Real.log_nonneg (by linarith)
    have h24 : Real.log T ≤ Real.log (x*T)^2 := by
      nlinarith [hL1]
    have h25 : Cs * x * Real.log T ≤ Cs * x * Real.log (x*T)^2 := by
      have h25b := mul_le_mul_of_nonneg_left h24 (show (0:ℝ) ≤ Cs*x by positivity)
      nlinarith [h25b]
    apply div_le_div_of_nonneg_right h25 hT0.le
  rw [hkey]
  calc ‖((Chebyshev.psi x : ℂ) - P)
        + (P - RectangleIntegral' (Glue.Gf x) zc wc)
        + (RectangleIntegral' (Glue.Gf x) zc wc - (x:ℂ) + Stage3.zeroPartialSum x T')
        + (Stage3.zeroPartialSum x T - Stage3.zeroPartialSum x T')‖
      ≤ ‖(Chebyshev.psi x : ℂ) - P‖
        + ‖P - RectangleIntegral' (Glue.Gf x) zc wc‖
        + ‖RectangleIntegral' (Glue.Gf x) zc wc - (x:ℂ) + Stage3.zeroPartialSum x T'‖
        + ‖Stage3.zeroPartialSum x T - Stage3.zeroPartialSum x T'‖ := norm_add₄_le
    _ ≤ (700 * x * Real.log (x*T')^2 / T' + 18*Real.log x)
        + (2*(Ch * x * Real.log T^2 / T) + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖)
        + K0 + Cs * x * Real.log T / T := by
        rw [hCn]
        linarith [hS1, hE, hswap']
    _ ≤ (2800 + 2*Ch + Cs) * x * Real.log (x*T)^2 / T
        + (18 + K0/Real.log 2) * Real.log x + ‖VIntegral (Glue.Gf x) (-1/4) (-T') T'‖ := by
        have h26 : (2800 + 2*Ch + Cs) * x * Real.log (x*T)^2 / T
            = 2800 * x * Real.log (x*T)^2 / T + 2*Ch * x * Real.log (x*T)^2 / T
              + Cs * x * Real.log (x*T)^2 / T := by ring
        have h27 : (18 + K0/Real.log 2) * Real.log x
            = 18*Real.log x + K0/Real.log 2 * Real.log x := by ring
        rw [h26, h27]
        linarith [he1, he2, he3, he4]

/-- info: 'ExplicitTwo.explicit_formula_left_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms explicit_formula_left_two

section Series

open LeftKernel

set_option maxHeartbeats 1600000 in
/-- **The series side from `x = 2`.** `LeftKernel.series_side` for `2 ≤ x`: the
Dirichlet-series half of the left edge, `∫_{−T}^{T} ζ'/ζ(5/4 − it)·x^(−1/4+it)/(−1/4+it) dt`,
has norm at most `4·Bser·x^(−1/4)`. The kernel's `1/log(x·n)` is now bounded by
`1/log 2 = 4/log 16`. -/
theorem series_side_two {x T : ℝ} (hx : 2 ≤ x) (hT : 2 ≤ T) :
    ‖∫ t in (-T)..T, (deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)
        / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I))
        * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
        / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)‖
      ≤ 4 * Bser * x ^ (-(1:ℝ)/4) := by
  have hx0 : 0 < x := by linarith
  have hT0 : 0 < T := by linarith
  set X : ℝ := x ^ (-(1:ℝ)/4) with hXdef
  have hX0 : 0 ≤ X := Real.rpow_nonneg hx0.le _
  set K0 : ℝ := (1 + 4 * Real.pi) / Real.log 2 with hK0def
  set s : ℝ → ℂ := fun t => ((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I with hsdef
  have hs_ne : ∀ t, s t ≠ 0 := by
    intro t h
    have := congrArg Complex.re h
    simp [hsdef] at this
  have hs_norm : ∀ t, 1 / 4 ≤ ‖s t‖ := by
    intro t
    have h := Complex.abs_re_le_norm (s t)
    have hre : (s t).re = -1/4 := by simp [hsdef]
    rw [hre] at h
    norm_num at h
    linarith
  set G : ℕ → ℝ → ℂ := fun n t =>
    ((vmTerm n * X : ℝ) : ℂ) * (((x * (n:ℝ) : ℝ) : ℂ) ^ ((t:ℂ) * Complex.I) / s t) with hGdef
  have hG0 : G 0 = fun _ => 0 := by
    funext t
    simp [hGdef, vmTerm]
  -- pointwise: the series of `G n t` sums to minus the integrand
  have hpt : ∀ t : ℝ, HasSum (fun n => G n t)
      (-((deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)
        / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I))
        * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
        / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))) := by
    intro t
    have hw : 1 < ((5/4:ℂ) - (t:ℂ) * Complex.I).re := by simp; norm_num
    have hL : HasSum (fun n => LSeries.term (fun n => ((ArithmeticFunction.vonMangoldt n : ℝ) : ℂ))
        ((5/4:ℂ) - (t:ℂ) * Complex.I) n)
        (LSeries (fun n => ((ArithmeticFunction.vonMangoldt n : ℝ) : ℂ))
          ((5/4:ℂ) - (t:ℂ) * Complex.I)) :=
      (ArithmeticFunction.LSeriesSummable_vonMangoldt hw).LSeriesHasSum
    rw [ArithmeticFunction.LSeries_vonMangoldt_eq_deriv_riemannZeta_div hw] at hL
    have hm := hL.mul_right ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I) / s t)
    have hfun : (fun n => G n t) = fun n =>
        LSeries.term (fun n => ((ArithmeticFunction.vonMangoldt n : ℝ) : ℂ))
          ((5/4:ℂ) - (t:ℂ) * Complex.I) n
        * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I) / s t) := by
      funext n
      rcases eq_or_ne n 0 with rfl | hn
      · simp [hGdef, vmTerm]
      · have hn' : (0:ℝ) < n := by exact_mod_cast Nat.pos_of_ne_zero hn
        rw [LSeries.term_of_ne_zero hn]
        have e1 : (n:ℂ) ^ ((5/4:ℂ) - (t:ℂ) * Complex.I)
            = Complex.exp ((Real.log n : ℂ) * ((5/4:ℂ) - (t:ℂ) * Complex.I)) := by
          rw [Complex.cpow_def_of_ne_zero (Nat.cast_ne_zero.mpr hn), Complex.natCast_log]
        have e2 : (x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)
            = Complex.exp ((Real.log x : ℂ) * (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)) := by
          rw [Complex.cpow_def_of_ne_zero (by exact_mod_cast hx0.ne'),
            ← Complex.ofReal_log hx0.le]
        have e3 := cpow_tI (mul_pos hx0 hn') t
        have e4 : vmTerm n * X = ArithmeticFunction.vonMangoldt n
            * Real.exp (Real.log n * (-(5:ℝ)/4)) * Real.exp (Real.log x * (-(1:ℝ)/4)) := by
          rw [vmTerm, hXdef, Real.rpow_def_of_pos hn', Real.rpow_def_of_pos hx0]
        have key : (Complex.exp ((Real.log n : ℂ) * ((5/4:ℂ) - (t:ℂ) * Complex.I)))⁻¹
            * Complex.exp ((Real.log x : ℂ) * (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
            = Complex.exp ((Real.log n : ℂ) * (-(5:ℂ)/4))
              * Complex.exp ((Real.log x : ℂ) * (-(1:ℂ)/4))
              * Complex.exp ((Real.log (x * n) : ℂ) * ((t:ℂ) * Complex.I)) := by
          rw [← Complex.exp_neg, ← Complex.exp_add, ← Complex.exp_add, ← Complex.exp_add,
            Real.log_mul hx0.ne' hn'.ne']
          congr 1
          push_cast
          ring
        simp only [hGdef]
        rw [e1, e2, e3, e4]
        push_cast at key ⊢
        linear_combination (-((ArithmeticFunction.vonMangoldt n : ℝ) : ℂ) / s t) * key
    have hval : -((deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)
        / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I))
        * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
        / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
        = -deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)
          / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)
          * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I) / s t) := by
      simp only [hsdef]
      ring
    rw [hfun, hval]
    exact hm
  -- continuity and the uniform bound of each `G n`
  have hcont : ∀ n, Continuous (G n) := by
    intro n
    rcases eq_or_ne n 0 with rfl | hn
    · rw [hG0]; exact continuous_const
    · have hn' : (0:ℝ) < n := by exact_mod_cast Nat.pos_of_ne_zero hn
      have hy0 : ((x * (n:ℝ) : ℝ) : ℂ) ≠ 0 := by exact_mod_cast (mul_pos hx0 hn').ne'
      simp only [hGdef]
      exact continuous_const.mul
        ((Continuous.const_cpow (by fun_prop) (Or.inl hy0)).div (by fun_prop) hs_ne)
  have hbound : ∀ n t, ‖G n t‖ ≤ vmTerm n * X * 4 := by
    intro n t
    rcases eq_or_ne n 0 with rfl | hn
    · rw [hG0]; simp [vmTerm]
    · have hn' : (0:ℝ) < n := by exact_mod_cast Nat.pos_of_ne_zero hn
      have hc : 0 ≤ vmTerm n * X := mul_nonneg (vmTerm_nonneg n) hX0
      simp only [hGdef]
      rw [norm_mul, norm_div, norm_cpow_tI (mul_pos hx0 hn'), Complex.norm_real,
        Real.norm_eq_abs, abs_of_nonneg hc]
      apply mul_le_mul_of_nonneg_left _ hc
      have h4 := hs_norm t
      rw [div_le_iff₀ (by linarith)]
      linarith
  -- exchange of sum and integral
  have hsum := intervalIntegral.hasSum_integral_of_dominated_convergence
    (μ := volume) (a := -T) (b := T) (F := G)
    (fun n _ => vmTerm n * X * 4)
    (fun n => (hcont n).aestronglyMeasurable)
    (fun n => Filter.Eventually.of_forall (fun t _ => hbound n t))
    (Filter.Eventually.of_forall (fun _ _ => (vmTerm_summable.mul_right X).mul_right 4))
    intervalIntegrable_const
    (Filter.Eventually.of_forall (fun t _ => hpt t))
  -- each term's integral
  have hterm : ∀ n, ‖∫ t in (-T)..T, G n t‖ ≤ vmTerm n * (X * K0) := by
    intro n
    rcases eq_or_ne n 0 with rfl | hn
    · rw [hG0]; simp [vmTerm]
    · have hn' : (0:ℝ) < n := by exact_mod_cast Nat.pos_of_ne_zero hn
      have hn1 : (1:ℝ) ≤ n := by exact_mod_cast Nat.one_le_iff_ne_zero.mpr hn
      have hc : 0 ≤ vmTerm n * X := mul_nonneg (vmTerm_nonneg n) hX0
      have hy : 2 ≤ x * (n:ℝ) := by nlinarith
      simp only [hGdef, hsdef]
      rw [intervalIntegral.integral_const_mul, norm_mul, Complex.norm_real, Real.norm_eq_abs,
        abs_of_nonneg hc]
      have hk := kernel_bound (y := x * (n:ℝ)) (T := T) (a := -1/4) (by linarith) hT0
        (by norm_num)
      have habs : |(-1/4 : ℝ)| = 1 / 4 := by norm_num [abs_of_neg]
      rw [habs] at hk
      have hlog2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
      have hlog : Real.log 2 ≤ Real.log (x * (n:ℝ)) := Real.log_le_log (by norm_num) hy
      have h2T : 2 / T ≤ 1 := by rw [div_le_iff₀ hT0]; linarith
      have hk2 : (2 / T + Real.pi / (1/4)) / Real.log (x * (n:ℝ)) ≤ K0 := by
        rw [hK0def]
        apply div_le_div₀ (by positivity) _ hlog2 hlog
        have : Real.pi / (1/4) = 4 * Real.pi := by ring
        linarith
      calc vmTerm n * X * ‖∫ t in (-T)..T,
              ((x * (n:ℝ) : ℝ) : ℂ) ^ ((t:ℂ) * Complex.I) / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)‖
          ≤ vmTerm n * X * K0 := by
            apply mul_le_mul_of_nonneg_left _ hc
            exact hk.trans hk2
        _ = vmTerm n * (X * K0) := by ring
  have hfin := hsum.norm_le_of_bounded (vmTerm_summable.hasSum.mul_right (X * K0)) hterm
  rw [intervalIntegral.integral_neg, norm_neg] at hfin
  refine hfin.trans (le_of_eq ?_)
  have hl2 : Real.log 2 ≠ 0 := (Real.log_pos (by norm_num : (1:ℝ) < 2)).ne'
  have h16 : Real.log 16 = 4 * Real.log 2 := by
    rw [show (16:ℝ) = 2 ^ 4 by norm_num, Real.log_pow]
    push_cast
    ring
  rw [Bser, h16, hK0def]
  field_simp
  try ring

end Series

section Smooth

open LeftSmooth

set_option maxHeartbeats 1600000 in
/-- **The smooth side from `x = 2`.** `LeftSmooth.smooth_side` for `2 ≤ x`: with
`s = −1/4 + it` and `w = 5/4 − it`, the integral of `(ζ′/ζ(s) + ζ′/ζ(w))·x^s/s` over
`[−T, T]` has norm at most `4·Bsm·x^(−1/4)`. The three pieces are bounded by
`Nsm/log x` as before; the last step uses `log 2 ≤ log x`, and `Nsm/log 2 = 4·Bsm`. -/
theorem smooth_side_two {x T : ℝ} (hx : 2 ≤ x) (hT : 2 ≤ T) :
    ‖∫ t in (-T)..T, (deriv riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)
          / riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)
        + deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)
          / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I))
        * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
        / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)‖
      ≤ 4 * Bsm * x ^ (-(1:ℝ)/4) := by
  have hx0 : 0 < x := by linarith
  have hx1 : 1 < x := by linarith
  have hT0 : 0 < T := by linarith
  have hlx : 0 < Real.log x := Real.log_pos hx1
  have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hl2x : Real.log 2 ≤ Real.log x := Real.log_le_log (by norm_num) hx
  have hpi := Real.pi_pos
  have hk := kc_pos
  set X : ℝ := x ^ (-(1:ℝ)/4) with hXdef
  have hX0 : 0 ≤ X := Real.rpow_nonneg hx0.le _
  set A : ℝ → ℂ := fun t => ((x:ℂ) ^ ((t:ℂ) * Complex.I)) * (c0 * (sL t)⁻¹) with hAdef
  set M : ℝ → ℂ := fun t => ((x:ℂ) ^ ((t:ℂ) * Complex.I))
    * ((-Complex.digamma (wL t) - (Real.eulerMascheroniConstant:ℂ)) * (sL t)⁻¹) with hMdef
  set C : ℝ → ℂ := fun t => ((x:ℂ) ^ ((t:ℂ) * Complex.I)) * tanPiece t with hCdef
  have hpt : ∀ t : ℝ, (deriv riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)
          / riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)
        + deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)
          / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I))
        * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
        / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)
      = (X:ℂ) * (A t + M t + ((Real.pi:ℂ) / 2) * C t) := by
    intro t
    change (deriv riemannZeta (sL t) / riemannZeta (sL t)
        + deriv riemannZeta (wL t) / riemannZeta (wL t)) * ((x:ℂ) ^ (sL t)) / (sL t) = _
    have hw : 1 < (wL t).re := by rw [wL_re]; norm_num
    obtain ⟨_, hG⟩ := logDeriv_sum hw (cos_wL_ne t)
    rw [one_sub_wL] at hG
    rw [hG, cpow_sL hx0, ← hXdef]
    simp only [hAdef, hMdef, hCdef, tanPiece, Gs, c0]
    field_simp [sL_ne t]
    try ring
  have hint : (∫ t in (-T)..T, (deriv riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)
          / riemannZeta (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)
        + deriv riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I)
          / riemannZeta ((5/4:ℂ) - (t:ℂ) * Complex.I))
        * ((x:ℂ) ^ (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
        / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I))
      = ∫ t in (-T)..T, (X:ℂ) * (A t + M t + ((Real.pi:ℂ) / 2) * C t) := by
    congr 1
    funext t
    exact hpt t
  have hcA : Continuous A := (continuous_cpow_tI hx0).mul
    (continuous_const.mul (continuous_sL.inv₀ sL_ne))
  have hcM : Continuous M := (continuous_cpow_tI hx0).mul
    ((continuous_digamma_wL.neg.sub continuous_const).mul (continuous_sL.inv₀ sL_ne))
  have hcC : Continuous C := (continuous_cpow_tI hx0).mul continuous_tanPiece
  rw [hint, intervalIntegral.integral_const_mul, intervalIntegral.integral_add,
    intervalIntegral.integral_add, intervalIntegral.integral_const_mul]
  rotate_left
  · exact hcA.intervalIntegrable _ _
  · exact hcM.intervalIntegrable _ _
  · exact (hcA.add hcM).intervalIntegrable _ _
  · exact (continuous_const.mul hcC).intervalIntegrable _ _
  rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hX0, mul_comm (4 * Bsm) X]
  apply mul_le_mul_of_nonneg_left _ hX0
  -- the three pieces
  have hAb : ‖∫ t in (-T)..T, A t‖ ≤ ‖c0‖ * (1 + 4 * Real.pi) / Real.log x := by
    have e : (fun t => A t) = fun (t : ℝ) => c0 * (((x:ℂ) ^ ((t:ℂ) * Complex.I))
        / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)) := by
      funext t
      simp only [hAdef, sL]
      ring
    rw [e, intervalIntegral.integral_const_mul, norm_mul]
    have hkb := LeftKernel.kernel_bound (y := x) (T := T) (a := -1/4) hx1 hT0 (by norm_num)
    have habs : |(-1/4 : ℝ)| = 1 / 4 := by norm_num [abs_of_neg]
    rw [habs] at hkb
    have h2T : 2 / T ≤ 1 := by rw [div_le_iff₀ hT0]; linarith
    have hkb2 : (2 / T + Real.pi / (1/4)) / Real.log x ≤ (1 + 4 * Real.pi) / Real.log x := by
      apply div_le_div_of_nonneg_right _ hlx.le
      have : Real.pi / (1/4) = 4 * Real.pi := by ring
      linarith
    calc ‖c0‖ * ‖∫ t in (-T)..T, ((x:ℂ) ^ ((t:ℂ) * Complex.I))
          / (((-1/4 : ℝ):ℂ) + (t:ℂ) * Complex.I)‖
        ≤ ‖c0‖ * ((1 + 4 * Real.pi) / Real.log x) := by
          gcongr
          exact hkb.trans hkb2
      _ = ‖c0‖ * (1 + 4 * Real.pi) / Real.log x := by ring
  have hMb : ‖∫ t in (-T)..T, M t‖ ≤ (∑' n : ℕ, dgTerm n) * ((2 + Real.pi) / Real.log x) :=
    digamma_piece hx1 hT0.le
  have hCb : ‖((Real.pi:ℂ) / 2) * ∫ t in (-T)..T, C t‖
      ≤ Real.pi / 2 * ((8 + 2 * Real.pi ^ 2 + 4 * Real.pi) / (kc * Real.log x)) := by
    rw [norm_mul]
    have e : ‖((Real.pi:ℂ) / 2)‖ = Real.pi / 2 := by
      rw [norm_div, Complex.norm_real, Real.norm_eq_abs, abs_of_pos hpi]
      norm_num
    rw [e]
    gcongr
    exact tan_piece hx1 hT0.le
  have htot : ‖(∫ t in (-T)..T, A t) + (∫ t in (-T)..T, M t)
      + ((Real.pi:ℂ) / 2) * ∫ t in (-T)..T, C t‖ ≤ Nsm / Real.log x := by
    refine (norm_add_le _ _).trans ?_
    have h3 := norm_add_le (∫ t in (-T)..T, A t) (∫ t in (-T)..T, M t)
    have e : Nsm / Real.log x = ‖c0‖ * (1 + 4 * Real.pi) / Real.log x
        + (∑' n : ℕ, dgTerm n) * ((2 + Real.pi) / Real.log x)
        + Real.pi / 2 * ((8 + 2 * Real.pi ^ 2 + 4 * Real.pi) / (kc * Real.log x)) := by
      unfold Nsm
      ring
    rw [e]
    linarith
  refine htot.trans ?_
  have e4 : 4 * Bsm = Nsm / Real.log 2 := by
    have h16 : Real.log 16 = 4 * Real.log 2 := by
      rw [show (16:ℝ) = 2 ^ 4 by norm_num, Real.log_pow]
      push_cast
      ring
    unfold Bsm
    rw [h16]
    field_simp
    try ring
  rw [e4]
  exact div_le_div_of_nonneg_left Nsm_nonneg hl2 hl2x

/-- The left-edge constant from `x = 2`: four times `LeftSmooth.Bleft`. -/
noncomputable def Bleft2 : ℝ := 4 * Bleft

set_option maxHeartbeats 1600000 in
/-- **The left edge from `x = 2`.** For `2 ≤ x` and `2 ≤ T`, the integral of
`−ζ′/ζ(s)·x^s/s` up `Re s = −1/4` from `−T` to `T` has norm at most `Bleft2·x^(−1/4)`,
with `Bleft2` free of `x` and `T`: the smooth side plus the series side. -/
theorem left_edge_bound_two {x T : ℝ} (hx : 2 ≤ x) (hT : 2 ≤ T) :
    ‖VIntegral (Glue.Gf x) (-1/4) (-T) T‖ ≤ Bleft2 * x ^ (-(1:ℝ)/4) := by
  have hx0 : 0 < x := by linarith
  have hS : ‖∫ t in (-T)..T, (deriv riemannZeta (sL t) / riemannZeta (sL t)
      + deriv riemannZeta (wL t) / riemannZeta (wL t)) * ((x:ℂ) ^ (sL t)) / (sL t)‖
      ≤ 4 * Bsm * x ^ (-(1:ℝ)/4) := smooth_side_two hx hT
  have hR : ‖∫ t in (-T)..T, (deriv riemannZeta (wL t) / riemannZeta (wL t))
      * ((x:ℂ) ^ (sL t)) / (sL t)‖ ≤ 4 * LeftKernel.Bser * x ^ (-(1:ℝ)/4) :=
    series_side_two hx hT
  have hcs := continuous_logDeriv_path continuous_sL sL_ne_one zeta_sL_ne
  have hcw := continuous_logDeriv_path continuous_wL wL_ne_one zeta_wL_ne
  have hx0' : (x:ℂ) ≠ 0 := by exact_mod_cast hx0.ne'
  have hcx : Continuous fun t => (x:ℂ) ^ (sL t) :=
    Continuous.const_cpow continuous_sL (Or.inl hx0')
  have hiS : IntervalIntegrable (fun t => (deriv riemannZeta (sL t) / riemannZeta (sL t)
      + deriv riemannZeta (wL t) / riemannZeta (wL t)) * ((x:ℂ) ^ (sL t)) / (sL t))
      volume (-T) T :=
    (((hcs.add hcw).mul hcx).div continuous_sL sL_ne).intervalIntegrable _ _
  have hiR : IntervalIntegrable (fun t => (deriv riemannZeta (wL t) / riemannZeta (wL t))
      * ((x:ℂ) ^ (sL t)) / (sL t)) volume (-T) T :=
    ((hcw.mul hcx).div continuous_sL sL_ne).intervalIntegrable _ _
  have e : (∫ y in (-T)..T, Glue.Gf x (((-1/4 : ℝ):ℂ) + (y:ℂ) * Complex.I))
      = (∫ t in (-T)..T, (deriv riemannZeta (wL t) / riemannZeta (wL t))
          * ((x:ℂ) ^ (sL t)) / (sL t))
        - ∫ t in (-T)..T, (deriv riemannZeta (sL t) / riemannZeta (sL t)
          + deriv riemannZeta (wL t) / riemannZeta (wL t)) * ((x:ℂ) ^ (sL t)) / (sL t) := by
    rw [← intervalIntegral.integral_sub hiR hiS]
    congr 1
    funext t
    change Glue.Gf x (sL t) = _
    simp only [Glue.Gf]
    ring
  unfold VIntegral
  rw [norm_smul, Complex.norm_I, one_mul, e]
  refine (norm_sub_le _ _).trans ?_
  unfold Bleft2 Bleft
  linarith

/-- info: 'ExplicitTwo.left_edge_bound_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms left_edge_bound_two

end Smooth

/-- **The explicit formula at every height, from `x = 2`.** For `2 ≤ x` and `2 ≤ T`:
`‖ψ(x) − x + Σ_{|γ|<T} m·x^ρ/ρ‖ ≤ c1t·x·log²(xT)/T + c3t·log x + Bleft2·x^(−1/4)`,
with no cap on `T` and the left edge bounded free of the height. -/
theorem explicit_formula_all_two {x T : ℝ} (hx : 2 ≤ x) (hT : 2 ≤ T) :
    ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖
      ≤ c1t * x * Real.log (x*T)^2 / T + c3t * Real.log x
        + Bleft2 * x ^ (-(1:ℝ)/4) := by
  obtain ⟨T', hTT', _, hF⟩ := explicit_formula_left_two hx hT
  have hE := left_edge_bound_two hx (le_trans hT hTT')
  linarith

/-- info: 'ExplicitTwo.explicit_formula_all_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms explicit_formula_all_two

end ExplicitTwo
