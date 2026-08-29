/-
# The contour shift — slices 2, 3, 4 (hEF's build order, entry 257)

SCRATCH: this file carries named `sorry`s by design. It is the slice map
for the contour shift, compiling so the obligations are real Lean
statements. Do not count this module in any sorry-free claim.

Slice 1 is COMPLETE in `Stage3.PerronKernel` (`explicit_formula_perron`):
`ψ` against the truncated `−ζ′/ζ` integral at `re = 1 + 1/log x`, error
`600·x·log(xT)²/T + 13·log x`. This file moves the contour:

  S2  good heights: in every unit interval there is a `T'` whose distance
      to every zero ordinate is ≥ `zeroGap T` — pigeonhole on
      `Stage3.zeta_local_zero_count` (15·log T + 73 orders per window),
      with the `β ≥ 1/2` partner via `riemannZeta_conj` +
      `riemannZeta_one_sub` placing every ordinate in a window.
  S3  edge bounds: at a good height, `‖ζ′/ζ(σ ± iT′)‖ ≤ C·log²T′` on
      `−1 ≤ σ ≤ 2`. Route: the Hadamard partial fraction
      (PNT+ `LogDerivZetaFinalBound` covers `σ > 1/2`; the strip needs
      the partial-fraction with the good-gap denominator bounds; `σ ≤ −1`
      by the functional equation).
  S4  the residue identity: `RectangleIntegral'` of `G = (−ζ′/ζ)·x^s/s`
      on `[−1, c] × [−T′, T′]` equals `x − ζ′/ζ(0) − Σ_{|γ|<T′} m·x^ρ/ρ`
      (PNT+ `ResidueTheoremOnRectangleWithSimplePole` / sumResiduesIn
      machinery; the pole at 1 gives `x`, at 0 gives `−ζ′/ζ(0)`, each ρ
      gives `−m·x^ρ/ρ`).

Assembly target: `StmtExplicitFormula c₁ c₂ x₁` (Stage3.Assembly:101) in
the consumed regime; the `T > x` tail is its own flagged obligation.
-/
import Stage3.PerronKernel
import Stage3.JensenCount
import Stage3.Assembly
import PrimeNumberTheoremAnd.RectangleArgumentPrinciple

namespace ContourShift

open Complex Topology

/-- The ordinate gap the pigeonhole delivers: crude-explicit,
`1/(180·log T + 1060)`. -/
noncomputable def zeroGap (T : ℝ) : ℝ := 1 / (180 * Real.log T + 1060)

theorem zeroGap_pos {T : ℝ} (hT : 2 ≤ T) : 0 < zeroGap T := by
  rw [zeroGap]
  have h1 : (0:ℝ) < Real.log T := Real.log_pos (by linarith)
  positivity

theorem zeroGap_le {T : ℝ} (hT : 2 ≤ T) : zeroGap T ≤ 9/10 := by
  rw [zeroGap]
  have h1 : (0:ℝ) < Real.log T := Real.log_pos (by linarith)
  rw [div_le_iff₀ (by positivity)]
  nlinarith

/-- `ζ` is analytic away from the pole. -/
theorem zeta_analyticAt {ρ : ℂ} (hρ : ρ ≠ 1) : AnalyticAt ℂ riemannZeta ρ := by
  have hd : DifferentiableOn ℂ riemannZeta ({(1:ℂ)}ᶜ : Set ℂ) := fun s hs ↦
    (differentiableAt_riemannZeta (Set.mem_compl_singleton_iff.mp hs)).differentiableWithinAt
  exact hd.analyticAt (isOpen_compl_singleton.mem_nhds
    (Set.mem_compl_singleton_iff.mpr hρ))

/-- At a zero away from the pole, the order is at least one. -/
theorem one_le_zeta_order {ρ : ℂ} (hρ1 : ρ ≠ 1) (hz : riemannZeta ρ = 0) :
    1 ≤ analyticOrderNatAt riemannZeta ρ := by
  have han := zeta_analyticAt hρ1
  have htop : analyticOrderAt riemannZeta ρ ≠ ⊤ := by
    intro htop
    have hev : riemannZeta =ᶠ[nhds ρ] 0 := by
      filter_upwards [analyticOrderAt_eq_top.mp htop] with z hz'
      simpa using hz'
    have hcon : IsPreconnected ({(1:ℂ)}ᶜ : Set ℂ) := by
      have h2 := isPathConnected_compl_singleton_of_one_lt_rank
        (by rw [rank_real_complex]; norm_num) (1:ℂ)
      exact h2.isConnected.isPreconnected
    have hAOn : AnalyticOnNhd ℂ riemannZeta ({(1:ℂ)}ᶜ : Set ℂ) := fun z hz' ↦
      zeta_analyticAt (Set.mem_compl_singleton_iff.mp hz')
    have hzero := hAOn.eqOn_zero_of_preconnected_of_eventuallyEq_zero hcon
      (Set.mem_compl_singleton_iff.mpr hρ1) hev
    have h2 : riemannZeta 2 = 0 := by
      have h3 := hzero (show (2:ℂ) ∈ ({(1:ℂ)}ᶜ : Set ℂ) by
        rw [Set.mem_compl_singleton_iff]
        norm_num)
      simpa using h3
    exact riemannZeta_ne_zero_of_one_le_re (by norm_num) h2
  have h0 : analyticOrderAt riemannZeta ρ ≠ 0 := by
    intro h0
    obtain ⟨g, hg, hgρ, hev⟩ := (han.analyticOrderAt_eq_natCast (n := 0)).mp
      (by exact_mod_cast h0)
    have hself := hev.self_of_nhds
    rw [pow_zero, one_smul, hz] at hself
    exact hgρ hself.symm
  show 1 ≤ (analyticOrderAt riemannZeta ρ).toNat
  have hne : (analyticOrderAt riemannZeta ρ).toNat ≠ 0 := by
    intro hzero
    rcases ENat.toNat_eq_zero.mp hzero with h | h
    · exact h0 h
    · exact htop h
  omega

/-- The reflection partner: every ordinate of a nontrivial zero carries a
zero with `re ∈ [1/2, 1)` at the same ordinate. -/
theorem partner_zero {ρ : ℂ} (hz : riemannZeta ρ = 0) (hre : 0 < ρ.re)
    (hre1 : ρ.re < 1) :
    ∃ ρ' : ℂ, riemannZeta ρ' = 0 ∧ ρ'.im = ρ.im ∧ 1/2 ≤ ρ'.re ∧ ρ'.re < 1 := by
  by_cases h : 1/2 ≤ ρ.re
  · exact ⟨ρ, hz, rfl, h, hre1⟩
  · push_neg at h
    refine ⟨1 - (starRingEnd ℂ) ρ, ?_, ?_, ?_, ?_⟩
    · have hwn : ∀ n : ℕ, (starRingEnd ℂ) ρ ≠ -(n : ℂ) := by
        intro n hcon
        have h5 := congrArg Complex.re hcon
        simp [Complex.conj_re] at h5
        have hn : (0:ℝ) ≤ (n:ℝ) := Nat.cast_nonneg n
        linarith
      have hw1 : (starRingEnd ℂ) ρ ≠ 1 := by
        intro hcon
        have h5 := congrArg Complex.re hcon
        simp [Complex.conj_re] at h5
        linarith
      have hfe := riemannZeta_one_sub hwn hw1
      have hζc : riemannZeta ((starRingEnd ℂ) ρ) = 0 := by
        rw [riemannZeta_conj, hz, map_zero]
      rw [hζc, mul_zero] at hfe
      exact hfe
    · simp [Complex.sub_im, Complex.conj_im]
    · simp only [Complex.sub_re, Complex.one_re, Complex.conj_re]
      linarith
    · simp only [Complex.sub_re, Complex.one_re, Complex.conj_re]
      linarith

/-- Membership in a `zetaWindow` from coordinate bounds. -/
theorem mem_zetaWindow {T₀ : ℝ} {ρ : ℂ} (hz : riemannZeta ρ = 0)
    (hre : 1/2 ≤ ρ.re) (hre1 : ρ.re < 1) (him : |ρ.im - T₀| ≤ 9/10) :
    ρ ∈ Stage3.zetaWindow T₀ := by
  refine ⟨hz, ?_⟩
  have hns : Complex.normSq (ρ - (2 + Complex.I * (T₀ : ℂ))) ≤ (7/4)^2 := by
    rw [Complex.normSq_apply]
    have hre2 : (ρ - (2 + Complex.I * (T₀ : ℂ))).re = ρ.re - 2 := by simp
    have him2 : (ρ - (2 + Complex.I * (T₀ : ℂ))).im = ρ.im - T₀ := by simp
    rw [hre2, him2]
    nlinarith [sq_abs (ρ.im - T₀), abs_nonneg (ρ.im - T₀)]
  calc ‖ρ - (2 + Complex.I * (T₀ : ℂ))‖
      = Real.sqrt (Complex.normSq (ρ - (2 + Complex.I * (T₀ : ℂ)))) := by
        rw [Complex.norm_def]
    _ ≤ Real.sqrt ((7/4)^2) := Real.sqrt_le_sqrt hns
    _ = 7/4 := by
        rw [Real.sqrt_sq (by norm_num : (0:ℝ) ≤ 7/4)]

/-- **Slice 2 — good heights exist.** -/
theorem goodT_exists {T : ℝ} (hT : 2 ≤ T) :
    ∃ T' ∈ Set.Icc T (T+1), ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re →
      zeroGap T ≤ |ρ.im - T'| := by
  have hT1 : 2 ≤ T + 1 := by linarith
  have hlogT : (0:ℝ) < Real.log T := Real.log_pos (by linarith)
  classical
  set W : Finset ℂ := (Stage3.zetaWindow_finite hT).toFinset
    ∪ (Stage3.zetaWindow_finite hT1).toFinset with hWd
  set S : Finset ℝ := W.image Complex.im with hSd
  have hwincard : ∀ (T₀ : ℝ) (hT₀ : 2 ≤ T₀),
      (((Stage3.zetaWindow_finite hT₀).toFinset.card : ℝ))
        ≤ 15 * Real.log T₀ + 73 := by
    intro T₀ hT₀
    have h4 := Stage3.zeta_local_zero_count hT₀
    have h5 : (((Stage3.zetaWindow_finite hT₀).toFinset.card : ℝ))
        ≤ ∑ ρ ∈ (Stage3.zetaWindow_finite hT₀).toFinset,
            (analyticOrderNatAt riemannZeta ρ : ℝ) := by
      rw [Finset.card_eq_sum_ones]
      push_cast
      apply Finset.sum_le_sum
      intro ρ hρ
      rw [Set.Finite.mem_toFinset] at hρ
      have hρ1 : ρ ≠ 1 := by
        intro h
        have h6 := hρ.2
        rw [h] at h6
        have h7 := Complex.abs_im_le_norm ((1:ℂ) - (2 + Complex.I * (T₀ : ℂ)))
        have h8 : ((1:ℂ) - (2 + Complex.I * (T₀ : ℂ))).im = -T₀ := by simp
        rw [h8, abs_neg, abs_of_pos (by linarith : (0:ℝ) < T₀)] at h7
        linarith
      have h9 := one_le_zeta_order hρ1 hρ.1
      exact_mod_cast h9
    linarith
  have hcard : ((S.card : ℝ)) ≤ 30 * Real.log T + 176 := by
    have h1 : ((S.card : ℝ)) ≤ ((W.card : ℝ)) := by
      exact_mod_cast Finset.card_image_le
    have h2 : ((W.card : ℝ)) ≤ (((Stage3.zetaWindow_finite hT).toFinset.card : ℝ))
        + (((Stage3.zetaWindow_finite hT1).toFinset.card : ℝ)) := by
      rw [hWd]
      exact_mod_cast Finset.card_union_le _ _
    have h6 := hwincard T hT
    have h7 := hwincard (T+1) hT1
    have hlog : Real.log (T+1) ≤ Real.log T + 1 := by
      have h8 : Real.log (T+1) ≤ Real.log (2*T) := by
        apply Real.log_le_log (by linarith)
        linarith
      rw [Real.log_mul (by norm_num) (by linarith)] at h8
      linarith [Real.log_two_lt_d9]
    linarith
  set k : ℕ := S.card with hkd
  set δ : ℝ := 1 / (2 * ((k:ℝ) + 1)) with hδd
  have hδ0 : 0 < δ := by rw [hδd]; positivity
  have hmid : ∃ i ∈ Finset.range (k+1), ∀ γ ∈ S,
      δ ≤ |γ - (T + (2*(i:ℝ)+1) * δ)| := by
    by_contra hcon
    push_neg at hcon
    choose f hf1 hf2 using hcon
    set g : ℕ → ℝ := fun i ↦ if h : i ∈ Finset.range (k+1) then f i h else 0
      with hgd
    have hg1 : ∀ i ∈ Finset.range (k+1), g i ∈ S := by
      intro i hi
      rw [hgd]
      simp only [dif_pos hi]
      exact hf1 i hi
    have hg2 : ∀ i ∈ Finset.range (k+1), |g i - (T + (2*(i:ℝ)+1)*δ)| < δ := by
      intro i hi
      rw [hgd]
      simp only [dif_pos hi]
      exact hf2 i hi
    have hinj : Set.InjOn g (Finset.range (k+1)) := by
      intro i hi j hj hij
      rw [Finset.mem_coe] at hi hj
      by_contra hne
      have hd1 := hg2 i hi
      have hd2 := hg2 j hj
      rw [hij] at hd1
      have habs : (1:ℝ) ≤ |(i:ℝ) - (j:ℝ)| := by
        have h6 : (i:ℤ) ≠ (j:ℤ) := by
          intro h7
          exact hne (by exact_mod_cast h7)
        have h7 : 1 ≤ |(i:ℤ) - (j:ℤ)| := by
          rcases lt_or_gt_of_ne h6 with h | h
          · rw [abs_of_neg (by omega)]
            omega
          · rw [abs_of_pos (by omega)]
            omega
        have h8 : ((1:ℤ):ℝ) ≤ ((|(i:ℤ) - (j:ℤ)|:ℤ):ℝ) := by exact_mod_cast h7
        push_cast at h8
        exact h8
      have hsep : 2*δ ≤ |(T + (2*(i:ℝ)+1)*δ) - (T + (2*(j:ℝ)+1)*δ)| := by
        have h1 : (T + (2*(i:ℝ)+1)*δ) - (T + (2*(j:ℝ)+1)*δ)
            = ((i:ℝ) - (j:ℝ)) * (2*δ) := by ring
        rw [h1, abs_mul, abs_of_pos (by linarith : (0:ℝ) < 2*δ)]
        nlinarith
      have h9 : |(T + (2*(i:ℝ)+1)*δ) - (T + (2*(j:ℝ)+1)*δ)|
          ≤ |g j - (T + (2*(i:ℝ)+1)*δ)| + |g j - (T + (2*(j:ℝ)+1)*δ)| := by
        calc |(T + (2*(i:ℝ)+1)*δ) - (T + (2*(j:ℝ)+1)*δ)|
            = |((T + (2*(i:ℝ)+1)*δ) - g j) + (g j - (T + (2*(j:ℝ)+1)*δ))| := by
              ring_nf
          _ ≤ |(T + (2*(i:ℝ)+1)*δ) - g j| + |g j - (T + (2*(j:ℝ)+1)*δ)| :=
              abs_add_le _ _
          _ = |g j - (T + (2*(i:ℝ)+1)*δ)| + |g j - (T + (2*(j:ℝ)+1)*δ)| := by
              rw [abs_sub_comm]
      linarith
    have hcard2 : (Finset.range (k+1)).card ≤ S.card :=
      Finset.card_le_card_of_injOn g hg1 hinj
    rw [Finset.card_range, ← hkd] at hcard2
    omega
  obtain ⟨i, hi, hgood⟩ := hmid
  rw [Finset.mem_range] at hi
  set T2 : ℝ := T + (2*(i:ℝ)+1)*δ with hT2d
  have hT2lo : T ≤ T2 := by
    rw [hT2d]
    have h1 : (0:ℝ) ≤ (2*(i:ℝ)+1)*δ := by positivity
    linarith
  have hT2hi : T2 ≤ T + 1 := by
    rw [hT2d, hδd]
    have h1 : (i:ℝ) ≤ (k:ℝ) := by
      have h2 : i ≤ k := by omega
      exact_mod_cast h2
    have h2 : (2*(i:ℝ)+1) * (1 / (2*((k:ℝ)+1))) ≤ 1 := by
      rw [mul_one_div, div_le_one (by positivity)]
      linarith
    linarith
  have hgap_le_δ : zeroGap T ≤ δ := by
    rw [zeroGap, hδd]
    apply one_div_le_one_div_of_le (by positivity)
    have h1 : ((k:ℝ)) ≤ 30 * Real.log T + 176 := hcard
    linarith
  refine ⟨T2, ⟨hT2lo, hT2hi⟩, ?_⟩
  intro ρ hz hre
  by_cases him : T - 9/10 ≤ ρ.im ∧ ρ.im ≤ T + 19/10
  · have hre1 : ρ.re < 1 := by
      by_contra hge
      push_neg at hge
      exact riemannZeta_ne_zero_of_one_le_re hge hz
    obtain ⟨ρ2, hz2, him2, hre2, hre12⟩ := partner_zero hz hre hre1
    have hρ2W : ρ2 ∈ W := by
      rw [hWd, Finset.mem_union]
      by_cases hcase : ρ.im ≤ T + 9/10
      · left
        rw [Set.Finite.mem_toFinset]
        apply mem_zetaWindow hz2 hre2 hre12
        rw [him2, abs_le]
        exact ⟨by linarith [him.1], by linarith⟩
      · right
        rw [Set.Finite.mem_toFinset]
        apply mem_zetaWindow hz2 hre2 hre12
        push_neg at hcase
        rw [him2, abs_le]
        exact ⟨by linarith, by linarith [him.2]⟩
    have hmem : ρ.im ∈ S := by
      rw [hSd]
      exact Finset.mem_image.mpr ⟨ρ2, hρ2W, him2⟩
    calc zeroGap T ≤ δ := hgap_le_δ
      _ ≤ |ρ.im - T2| := hgood ρ.im hmem
  · push_neg at him
    have h910 : (9:ℝ)/10 ≤ |ρ.im - T2| := by
      by_cases hcase : T - 9/10 ≤ ρ.im
      · have h1 := him hcase
        rw [abs_of_pos (by linarith)]
        linarith
      · push_neg at hcase
        rw [abs_of_neg (by linarith)]
        linarith
    calc zeroGap T ≤ 9/10 := zeroGap_le hT
      _ ≤ |ρ.im - T2| := h910

/-- info: 'ContourShift.goodT_exists' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms goodT_exists

/-- **Slice 3 — the edge bound at a good height.** -/
theorem edge_bound {T T' : ℝ} (hT : 2 ≤ T) (hT' : T' ∈ Set.Icc T (T+1))
    (hgood : ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → zeroGap T ≤ |ρ.im - T'|) :
    ∃ C : ℝ, 0 < C ∧ C ≤ 10 ^ 7 ∧ ∀ σ : ℝ, -1 ≤ σ → σ ≤ 2 → ∀ ε : ℝ, ε = T' ∨ ε = -T' →
      ‖deriv riemannZeta ((σ : ℂ) + Complex.I * ε)
          / riemannZeta ((σ : ℂ) + Complex.I * ε)‖
        ≤ C * Real.log T ^ 2 := by
  sorry

/-! ## S4 machinery — the multi-pole residue theorem on a rectangle

PNT+'s `ResidueTheoremOnRectangleWithSimplePole` handles one simple pole.
Its proof only ever uses the border values of `f`, so the many-pole
version needs no new analysis: congr the border to
`g + Σ principal parts`, split by linearity, vanish `g`, and fire
`ResidueTheoremInRectangle` once per pole. -/

/-- A finite sum of simple-pole principal parts is border-integrable
when every pole is interior. -/
theorem borderIntegrable_sum_poles {z w : ℂ} {P : Finset ℂ} {A : ℂ → ℂ}
    (pIn : ∀ p ∈ P, Rectangle z w ∈ nhds p) :
    RectangleBorderIntegrable (fun s ↦ ∑ p ∈ P, A p / (s - p)) z w := by
  apply ContinuousOn.rectangleBorder_integrable
  apply continuousOn_finsetSum
  intro p hp
  apply ContinuousOn.div continuousOn_const
    ((continuous_id.sub continuous_const).continuousOn)
  intro s hs hzero
  have hsp : s = p := sub_eq_zero.mp hzero
  rw [hsp] at hs
  exact not_mem_rectangleBorder_of_rectangle_mem_nhds (pIn p hp) hs

/-- The rectangle integral of a finite sum of simple-pole principal
parts, all poles interior, is the sum of the residues. -/
theorem rectangleIntegral_sum_poles {z w : ℂ} {P : Finset ℂ} {A : ℂ → ℂ}
    (zRe_le_wRe : z.re ≤ w.re) (zIm_le_wIm : z.im ≤ w.im)
    (pIn : ∀ p ∈ P, Rectangle z w ∈ nhds p) :
    RectangleIntegral' (fun s ↦ ∑ p ∈ P, A p / (s - p)) z w = ∑ p ∈ P, A p := by
  classical
  revert pIn
  refine Finset.induction_on P ?_ ?_
  · intro _
    simp [RectangleIntegral', RectangleIntegral, HIntegral, VIntegral]
  · intro p Q hpQ ih pIn
    have hpin : Rectangle z w ∈ nhds p := pIn p (Finset.mem_insert_self p Q)
    have hQin : ∀ q ∈ Q, Rectangle z w ∈ nhds q := fun q hq ↦
      pIn q (Finset.mem_insert_of_mem hq)
    have ihQ := ih hQin
    have hsplit : (fun s ↦ ∑ q ∈ insert p Q, A q / (s - q))
        = (fun s ↦ A p / (s - p)) + (fun s ↦ ∑ q ∈ Q, A q / (s - q)) := by
      funext s
      simp [Finset.sum_insert hpQ]
    have h1 : RectangleBorderIntegrable (fun s ↦ A p / (s - p)) z w := by
      have h2 := borderIntegrable_sum_poles (z := z) (w := w)
        (P := {p}) (A := A) (by simpa using hpin)
      simpa using h2
    have h2 := borderIntegrable_sum_poles (z := z) (w := w) (P := Q) (A := A) hQin
    rw [hsplit, RectangleIntegral', RectangleBorderIntegrable.add h1 h2, smul_add,
      Finset.sum_insert hpQ]
    have hres := ResidueTheoremInRectangle (c := A p) (p := p) (z := z) (w := w)
      zRe_le_wRe zIm_le_wIm hpin
    exact congrArg₂ (· + ·) hres ihQ

/-- **The multi-pole residue theorem on a rectangle.** If `f` agrees
off the pole set with `g + Σ_p A p/(s − p)` for `g` holomorphic on the
whole rectangle and every pole interior, then the rectangle integral of
`f` collects every residue. -/
theorem residue_rectangle_multi {f g : ℂ → ℂ} {z w : ℂ} {P : Finset ℂ} {A : ℂ → ℂ}
    (zRe_le_wRe : z.re ≤ w.re) (zIm_le_wIm : z.im ≤ w.im)
    (pIn : ∀ p ∈ P, Rectangle z w ∈ nhds p)
    (gHolo : HolomorphicOn g (Rectangle z w))
    (principal : Set.EqOn (f - fun s ↦ ∑ p ∈ P, A p / (s - p)) g
      (Rectangle z w \ (P : Set ℂ))) :
    RectangleIntegral' f z w = ∑ p ∈ P, A p := by
  have hborder : Set.EqOn f (g + fun s ↦ ∑ p ∈ P, A p / (s - p))
      (RectangleBorder z w) := by
    intro s hs
    have hsP : s ∉ (P : Set ℂ) := by
      intro hsP
      exact not_mem_rectangleBorder_of_rectangle_mem_nhds (pIn s hsP) hs
    have h1 := principal ⟨rectangleBorder_subset_rectangle z w hs, hsP⟩
    simp only [Pi.sub_apply] at h1
    simp only [Pi.add_apply]
    linear_combination h1
  rw [RectangleIntegral'_congr hborder]
  have hgInt : RectangleBorderIntegrable g z w := gHolo.rectangleBorderIntegrable
  have hSumInt := borderIntegrable_sum_poles (z := z) (w := w) (P := P) (A := A) pIn
  rw [RectangleIntegral', RectangleBorderIntegrable.add hgInt hSumInt, smul_add,
    gHolo.vanishesOnRectangle (by rfl), smul_zero, zero_add]
  exact rectangleIntegral_sum_poles zRe_le_wRe zIm_le_wIm pIn

/-- **The residue theorem from local data.** `f` holomorphic on the
rectangle off a finite interior pole set, and at each pole `p` equal to
`(analytic at p) + A p/(s − p)` on a punctured neighborhood: the
rectangle integral collects every residue. The global extension is
glued from the local analytic parts. -/
theorem residue_rectangle_of_local {f : ℂ → ℂ} {z w : ℂ} {P : Finset ℂ} {A : ℂ → ℂ}
    (zRe_le_wRe : z.re ≤ w.re) (zIm_le_wIm : z.im ≤ w.im)
    (pIn : ∀ p ∈ P, Rectangle z w ∈ nhds p)
    (fHolo : HolomorphicOn f (Rectangle z w \ (P : Set ℂ)))
    (hloc : ∀ p ∈ P, ∃ h : ℂ → ℂ, AnalyticAt ℂ h p ∧
        ∀ᶠ s in nhdsWithin p {p}ᶜ, f s = h s + A p / (s - p)) :
    RectangleIntegral' f z w = ∑ p ∈ P, A p := by
  classical
  choose! h hana hev using hloc
  set g : ℂ → ℂ := fun s ↦ if s ∈ P then h s s - ∑ q ∈ P.erase s, A q / (s - q)
    else f s - ∑ q ∈ P, A q / (s - q) with hgd
  have hPclosed : IsClosed (P : Set ℂ) := P.finite_toSet.isClosed
  have hgHolo : HolomorphicOn g (Rectangle z w) := by
    intro x hxRect
    by_cases hxP : x ∈ P
    · -- glued point: g agrees with the local analytic model on a full nhds
      have hother : {s : ℂ | s ∉ (P.erase x : Finset ℂ)} ∈ nhds x := by
        have h1 : IsOpen ((↑(P.erase x) : Set ℂ))ᶜ :=
          (P.erase x).finite_toSet.isClosed.isOpen_compl
        exact h1.mem_nhds (by simp)
      have heq : g =ᶠ[nhds x]
          (fun s ↦ h x s - ∑ q ∈ P.erase x, A q / (s - q)) := by
        have h1 := hev x hxP
        rw [eventually_nhdsWithin_iff] at h1
        filter_upwards [h1, hother] with s hs1 hs2
        by_cases hsx : s = x
        · rw [hsx, hgd]
          simp only [if_pos hxP]
        · have hsP : s ∉ P := by
            intro hsP
            exact hs2 (Finset.mem_erase.mpr ⟨hsx, hsP⟩)
          have h2 := hs1 (by simpa using hsx)
          rw [hgd]
          simp only [if_neg hsP]
          rw [h2, ← Finset.add_sum_erase P (fun q ↦ A q / (s - q)) hxP]
          ring
      have hH : DifferentiableAt ℂ
          (fun s ↦ h x s - ∑ q ∈ P.erase x, A q / (s - q)) x := by
        apply DifferentiableAt.sub (hana x hxP).differentiableAt
        apply DifferentiableAt.fun_sum
        intro q hq
        have hxq : x - q ≠ 0 := by
          rw [sub_ne_zero]
          intro hxq
          exact absurd (hxq ▸ hq) (by simp)
        exact (differentiableAt_const _).div
          (differentiableAt_id.sub (differentiableAt_const _)) hxq
      exact (heq.differentiableAt_iff.mpr hH).differentiableWithinAt
    · -- plain point: g agrees with f − Σ near x
      have hcompl : {s : ℂ | s ∉ P} ∈ nhds x :=
        hPclosed.isOpen_compl.mem_nhds hxP
      have heq : g =ᶠ[nhds x] (fun s ↦ f s - ∑ q ∈ P, A q / (s - q)) := by
        filter_upwards [hcompl] with s hs
        rw [hgd]
        simp only [if_neg hs]
      have hd1 : DifferentiableWithinAt ℂ f (Rectangle z w) x := by
        refine (fHolo x ⟨hxRect, hxP⟩).mono_of_mem_nhdsWithin ?_
        rw [Set.sdiff_eq]
        exact Filter.inter_mem self_mem_nhdsWithin
          (mem_nhdsWithin_of_mem_nhds hcompl)
      have hd2 : DifferentiableAt ℂ (fun s ↦ ∑ q ∈ P, A q / (s - q)) x := by
        apply DifferentiableAt.fun_sum
        intro q hq
        have hxq : x - q ≠ 0 := by
          rw [sub_ne_zero]
          intro hxq
          exact hxP (hxq ▸ hq)
        exact (differentiableAt_const _).div
          (differentiableAt_id.sub (differentiableAt_const _)) hxq
      refine DifferentiableWithinAt.congr_of_eventuallyEq
        (hd1.sub hd2.differentiableWithinAt) ?_ ?_
      · exact heq.filter_mono nhdsWithin_le_nhds
      · rw [hgd]
        simp only [if_neg hxP, Pi.sub_apply]
  apply residue_rectangle_multi zRe_le_wRe zIm_le_wIm pIn hgHolo
  intro s hs
  have hsP : s ∉ P := by simpa using hs.2
  simp only [Pi.sub_apply]
  rw [hgd]
  simp only [if_neg hsP]

/-- `dslope` of an analytic function is analytic at the point. -/
theorem analyticAt_dslope {f : ℂ → ℂ} {p : ℂ} (hf : AnalyticAt ℂ f p) :
    AnalyticAt ℂ (dslope f p) p := by
  obtain ⟨q, hq⟩ := hf
  exact hq.has_fpower_series_dslope_fslope.analyticAt

/-- Off the point, `f s/(s−p)` splits as `f p/(s−p) + dslope f p s`. -/
theorem div_sub_eq_dslope {f : ℂ → ℂ} {p s : ℂ} (hsp : s ≠ p) :
    f s / (s - p) = f p / (s - p) + dslope f p s := by
  rw [dslope_of_ne _ hsp, slope_def_field]
  have h1 : s - p ≠ 0 := sub_ne_zero.mpr hsp
  field_simp
  ring

/-- **The local pole data of `G = (−ζ′/ζ)·x^s/s` at a factorization
point.** Where `ζ` factors as `(s−p)^n·g` with `g` analytic and
nonvanishing at `p ≠ 0`, `G` splits as `analytic + (−n·x^p/p)/(s−p)`
on a punctured neighborhood: the pole is simple with residue
`−n·x^p/p`. Covers every nontrivial zero (`n = order ≥ 1`) and the
pole of `ζ` at `1` (`n = −1`, residue `+x`) in one statement. -/
theorem zeta_local_data {p : ℂ} {n : ℤ} {g : ℂ → ℂ} {x : ℝ} (hx : 0 < x)
    (hp0 : p ≠ 0) (hg : AnalyticAt ℂ g p) (hgp : g p ≠ 0)
    (hfac : ∀ᶠ s in nhdsWithin p {p}ᶜ, riemannZeta s = (s - p) ^ n * g s) :
    ∃ h : ℂ → ℂ, AnalyticAt ℂ h p ∧ ∀ᶠ s in nhdsWithin p {p}ᶜ,
      - deriv riemannZeta s / riemannZeta s * ((x:ℝ):ℂ) ^ s / s
        = h s + (-(n:ℂ) * ((x:ℝ):ℂ) ^ p / p) / (s - p) := by
  have hxne : ((x:ℝ):ℂ) ≠ 0 := Complex.ofReal_ne_zero.mpr (ne_of_gt hx)
  have hcpow : Differentiable ℂ (fun t : ℂ ↦ ((x:ℝ):ℂ) ^ t) :=
    differentiable_id.const_cpow (Or.inl hxne)
  have hk : AnalyticAt ℂ (fun t : ℂ ↦ ((x:ℝ):ℂ) ^ t / t) p :=
    (hcpow.analyticAt p).div analyticAt_id hp0
  have hlg : AnalyticAt ℂ (logDeriv g) p := by
    have h1 : logDeriv g = fun t ↦ deriv g t / g t := rfl
    rw [h1]
    exact hg.deriv.div hg hgp
  refine ⟨fun t ↦ -(n:ℂ) * dslope (fun u ↦ ((x:ℝ):ℂ) ^ u / u) p t
      - logDeriv g t * (((x:ℝ):ℂ) ^ t / t), ?_, ?_⟩
  · exact (analyticAt_const.mul (analyticAt_dslope hk)).sub
      (hlg.mul ((hcpow.analyticAt p).div analyticAt_id hp0))
  · obtain ⟨U, hUfac, hUopen, hpU⟩ := eventually_nhds_iff.mp
      (eventually_nhdsWithin_iff.mp hfac)
    have hgana := hg.eventually_analyticAt
    have hgne : ∀ᶠ t in nhds p, g t ≠ 0 := hg.continuousAt.eventually_ne hgp
    filter_upwards [eventually_mem_nhdsWithin,
      (hUopen.eventually_mem hpU).filter_mono nhdsWithin_le_nhds,
      hgana.filter_mono nhdsWithin_le_nhds,
      hgne.filter_mono nhdsWithin_le_nhds] with s hsp' hsU hsW hsV
    have hsp : s ≠ p := Set.mem_compl_singleton_iff.mp hsp'
    have hspne : s - p ≠ 0 := sub_ne_zero.mpr hsp
    have hzp : (s - p) ^ n ≠ 0 := zpow_ne_zero n hspne
    have hev_s : riemannZeta =ᶠ[nhds s] fun t ↦ (t - p) ^ n * g t := by
      have hopen : IsOpen (U ∩ {p}ᶜ) := hUopen.inter isOpen_compl_singleton
      filter_upwards [hopen.mem_nhds ⟨hsU, hsp'⟩] with t ht
      exact hUfac t ht.1 (Set.mem_compl_singleton_iff.mp ht.2)
    have hζs : riemannZeta s = (s - p) ^ n * g s := hUfac s hsU hsp
    have hld : logDeriv riemannZeta s = (n:ℂ) / (s - p) + logDeriv g s := by
      have h1 : logDeriv riemannZeta s = logDeriv (fun t ↦ (t - p) ^ n * g t) s := by
        rw [logDeriv_apply, logDeriv_apply, hev_s.deriv_eq, hζs]
      rw [h1, logDeriv_mul (f := fun t : ℂ ↦ (t - p) ^ n) (g := g) s hzp hsV
        ((differentiableAt_id.sub (differentiableAt_const p)).zpow (Or.inl hspne))
        hsW.differentiableAt]
      congr 1
      have h6 := logDeriv_fun_zpow (f := fun t : ℂ ↦ t - p) (x := s)
        (differentiableAt_id.sub (differentiableAt_const p)) n
      beta_reduce at h6
      rw [h6]
      have h2 : logDeriv (fun t : ℂ ↦ t - p) s = 1 / (s - p) := by
        rw [logDeriv_apply, deriv_sub_const, deriv_id'']
      rw [h2]
      ring
    have h3 : - deriv riemannZeta s / riemannZeta s = -logDeriv riemannZeta s := by
      rw [logDeriv_apply, neg_div]
    have h5 := div_sub_eq_dslope (f := fun t : ℂ ↦ ((x:ℝ):ℂ) ^ t / t) hsp
    calc - deriv riemannZeta s / riemannZeta s * ((x:ℝ):ℂ) ^ s / s
        = -((n:ℂ) / (s - p) + logDeriv g s) * ((x:ℝ):ℂ) ^ s / s := by
          rw [h3, hld]
      _ = -(n:ℂ) * (((x:ℝ):ℂ) ^ s / s / (s - p))
            - logDeriv g s * (((x:ℝ):ℂ) ^ s / s) := by
          ring
      _ = -(n:ℂ) * (((x:ℝ):ℂ) ^ p / p / (s - p)
              + dslope (fun u ↦ ((x:ℝ):ℂ) ^ u / u) p s)
            - logDeriv g s * (((x:ℝ):ℂ) ^ s / s) := by
          rw [h5]
      _ = (-(n:ℂ) * dslope (fun u ↦ ((x:ℝ):ℂ) ^ u / u) p s
            - logDeriv g s * (((x:ℝ):ℂ) ^ s / s))
            + (-(n:ℂ) * ((x:ℝ):ℂ) ^ p / p) / (s - p) := by
          ring

/-- info: 'ContourShift.zeta_local_data' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_local_data

/-- The order of `ζ` at any point off the pole is finite (identity
theorem on `ℂ∖{1}`, as in `one_le_zeta_order`). -/
theorem zeta_order_ne_top {ρ : ℂ} (hρ1 : ρ ≠ 1) :
    analyticOrderAt riemannZeta ρ ≠ ⊤ := by
  intro htop
  have hev : riemannZeta =ᶠ[nhds ρ] 0 := by
    filter_upwards [analyticOrderAt_eq_top.mp htop] with z hz'
    simpa using hz'
  have hcon : IsPreconnected ({(1:ℂ)}ᶜ : Set ℂ) := by
    have h2 := isPathConnected_compl_singleton_of_one_lt_rank
      (by rw [rank_real_complex]; norm_num) (1:ℂ)
    exact h2.isConnected.isPreconnected
  have hAOn : AnalyticOnNhd ℂ riemannZeta ({(1:ℂ)}ᶜ : Set ℂ) := fun z hz' ↦
    zeta_analyticAt (Set.mem_compl_singleton_iff.mp hz')
  have hzero := hAOn.eqOn_zero_of_preconnected_of_eventuallyEq_zero hcon
    (Set.mem_compl_singleton_iff.mpr hρ1) hev
  have h2 : riemannZeta 2 = 0 := by
    have h3 := hzero (show (2:ℂ) ∈ ({(1:ℂ)}ᶜ : Set ℂ) by
      rw [Set.mem_compl_singleton_iff]
      norm_num)
    simpa using h3
  exact riemannZeta_ne_zero_of_one_le_re (by norm_num) h2

/-- Local pole data of `G` at a nontrivial zero: residue
`−(order)·x^ρ/ρ`. -/
theorem zeta_local_data_zero {ρ : ℂ} {x : ℝ} (hx : 0 < x)
    (hρ0 : ρ ≠ 0) (hρ1 : ρ ≠ 1) (hz : riemannZeta ρ = 0) :
    ∃ h : ℂ → ℂ, AnalyticAt ℂ h ρ ∧ ∀ᶠ s in nhdsWithin ρ {ρ}ᶜ,
      - deriv riemannZeta s / riemannZeta s * ((x:ℝ):ℂ) ^ s / s
        = h s + (-(analyticOrderNatAt riemannZeta ρ : ℂ) * ((x:ℝ):ℂ) ^ ρ / ρ)
            / (s - ρ) := by
  have han := zeta_analyticAt hρ1
  have hm : analyticOrderAt riemannZeta ρ
      = ((analyticOrderNatAt riemannZeta ρ : ℕ) : ℕ∞) :=
    (ENat.coe_toNat (zeta_order_ne_top hρ1)).symm
  obtain ⟨g, hg, hgρ, hev⟩ := (han.analyticOrderAt_eq_natCast).mp hm
  have hfac : ∀ᶠ s in nhdsWithin ρ {ρ}ᶜ,
      riemannZeta s = (s - ρ) ^ ((analyticOrderNatAt riemannZeta ρ : ℕ) : ℤ) * g s := by
    filter_upwards [hev.filter_mono nhdsWithin_le_nhds] with s hs
    rw [hs, smul_eq_mul, zpow_natCast]
  obtain ⟨h, hha, hhe⟩ := zeta_local_data
    (n := ((analyticOrderNatAt riemannZeta ρ : ℕ) : ℤ)) hx hρ0 hg hgρ hfac
  refine ⟨h, hha, ?_⟩
  filter_upwards [hhe] with s hs2
  rw [hs2]
  push_cast
  ring

/-- Local pole data of `G` at `1`: residue `+x`. The factorization
`ζ = (s−1)^{−1}·g` is built from the completed zeta function. -/
theorem zeta_local_data_one {x : ℝ} (hx : 0 < x) :
    ∃ h : ℂ → ℂ, AnalyticAt ℂ h 1 ∧ ∀ᶠ s in nhdsWithin 1 {1}ᶜ,
      - deriv riemannZeta s / riemannZeta s * ((x:ℝ):ℂ) ^ s / s
        = h s + ((x:ℝ):ℂ) / (s - 1) := by
  have hπ : ((Real.pi:ℝ):ℂ) ≠ 0 := Complex.ofReal_ne_zero.mpr Real.pi_ne_zero
  set D : ℂ → ℂ := fun s ↦ ((Real.pi:ℝ):ℂ) ^ (-s/2) * Complex.Gamma (s/2) with hDd
  set N : ℂ → ℂ := fun s ↦ (s-1) * completedRiemannZeta₀ s - (s-1)/s + 1 with hNd
  have hΓ : AnalyticAt ℂ (fun s : ℂ ↦ Complex.Gamma (s/2)) 1 := by
    have hopen : IsOpen {s : ℂ | 0 < s.re} := isOpen_lt continuous_const Complex.continuous_re
    have hdiff : DifferentiableOn ℂ (fun s : ℂ ↦ Complex.Gamma (s/2)) {s : ℂ | 0 < s.re} := by
      intro t ht
      apply DifferentiableAt.differentiableWithinAt
      have h1 : DifferentiableAt ℂ Complex.Gamma (t/2) := by
        apply Complex.differentiableAt_Gamma
        intro m hcon
        have h2 : t = -(2 * (m:ℂ)) := by linear_combination 2 * hcon
        have h3 : (0:ℝ) < t.re := ht
        have h4 : t.re = -(2 * (m:ℝ)) := by
          rw [h2]
          simp
        rw [h4] at h3
        have h5 : (0:ℝ) ≤ (m:ℝ) := Nat.cast_nonneg m
        linarith
      exact h1.comp t (differentiableAt_id.div_const 2)
    exact hdiff.analyticAt (hopen.mem_nhds (by simp))
  have hDana : AnalyticAt ℂ D 1 := by
    rw [hDd]
    exact (((differentiable_id.neg.div_const 2).const_cpow
      (Or.inl hπ)).analyticAt 1).mul hΓ
  have hD1 : D 1 ≠ 0 := by
    rw [hDd]
    apply mul_ne_zero
    · rw [Complex.cpow_def_of_ne_zero hπ]
      exact Complex.exp_ne_zero _
    · exact Complex.Gamma_ne_zero_of_re_pos (by norm_num [Complex.div_re])
  have hNana : AnalyticAt ℂ N 1 := by
    rw [hNd]
    exact (((analyticAt_id.sub analyticAt_const).mul
      (differentiable_completedZeta₀.analyticAt 1)).sub
      ((analyticAt_id.sub analyticAt_const).div analyticAt_id one_ne_zero)).add
      analyticAt_const
  have hN1 : N 1 = 1 := by
    rw [hNd]
    simp
  have hg : AnalyticAt ℂ (fun s ↦ N s / D s) 1 := hNana.div hDana hD1
  have hgp : N 1 / D 1 ≠ 0 := by
    rw [hN1]
    exact div_ne_zero one_ne_zero hD1
  have hDne : ∀ᶠ s in nhds 1, D s ≠ 0 := hDana.continuousAt.eventually_ne hD1
  have hs0 : ∀ᶠ s in nhds (1:ℂ), s ≠ 0 :=
    isOpen_compl_singleton.eventually_mem (Set.mem_compl_singleton_iff.mpr one_ne_zero)
  have hfac : ∀ᶠ s in nhdsWithin 1 {1}ᶜ,
      riemannZeta s = (s - 1) ^ (-1 : ℤ) * (N s / D s) := by
    filter_upwards [eventually_mem_nhdsWithin,
      hDne.filter_mono nhdsWithin_le_nhds,
      hs0.filter_mono nhdsWithin_le_nhds] with s hs1 hsD hs0'
    have hs1' : s ≠ 1 := Set.mem_compl_singleton_iff.mp hs1
    have hs1ne : s - 1 ≠ 0 := sub_ne_zero.mpr hs1'
    have h1s : (1:ℂ) - s ≠ 0 := by
      intro hcon
      exact hs1' (by linear_combination -hcon)
    rw [riemannZeta_eq_completedRiemannZeta₀ hs0', zpow_neg_one]
    rw [hNd, hDd]
    field_simp
    ring
  obtain ⟨h, hha, hhe⟩ := zeta_local_data (n := (-1 : ℤ)) hx one_ne_zero hg hgp hfac
  refine ⟨h, hha, ?_⟩
  filter_upwards [hhe] with s hs2
  rw [hs2, Complex.cpow_one]
  push_cast
  ring

/-- Local pole data of `G` at `0`: residue `−ζ′(0)/ζ(0)`. -/
theorem zeta_local_data_origin {x : ℝ} (hx : 0 < x) :
    ∃ h : ℂ → ℂ, AnalyticAt ℂ h 0 ∧ ∀ᶠ s in nhdsWithin 0 {0}ᶜ,
      - deriv riemannZeta s / riemannZeta s * ((x:ℝ):ℂ) ^ s / s
        = h s + (- deriv riemannZeta 0 / riemannZeta 0) / (s - 0) := by
  have hxne : ((x:ℝ):ℂ) ≠ 0 := Complex.ofReal_ne_zero.mpr (ne_of_gt hx)
  have hζ0 : riemannZeta 0 ≠ 0 := by
    rw [riemannZeta_zero]
    norm_num
  have hζan := zeta_analyticAt (show (0:ℂ) ≠ 1 by norm_num)
  have hu : AnalyticAt ℂ
      (fun t ↦ - deriv riemannZeta t / riemannZeta t * ((x:ℝ):ℂ) ^ t) 0 :=
    (hζan.deriv.neg.div hζan hζ0).mul
      ((differentiable_id.const_cpow (Or.inl hxne)).analyticAt 0)
  refine ⟨dslope (fun t ↦ - deriv riemannZeta t / riemannZeta t * ((x:ℝ):ℂ) ^ t) 0,
    analyticAt_dslope hu, ?_⟩
  filter_upwards [eventually_mem_nhdsWithin] with s hs
  have hs0 : s ≠ 0 := Set.mem_compl_singleton_iff.mp hs
  have h5 := div_sub_eq_dslope
    (f := fun t ↦ - deriv riemannZeta t / riemannZeta t * ((x:ℝ):ℂ) ^ t)
    (p := 0) (s := s) hs0
  beta_reduce at h5
  rw [Complex.cpow_zero, mul_one] at h5
  rw [sub_zero] at h5 ⊢
  rw [h5]
  ring

/-- No zeros on the strip `re ∈ [−1, 0]`: the functional equation
carries nonvanishing over from `re ∈ [1, 2]`. The cosine factor can
only vanish at `s = 1`, where `ζ` has its pole instead. -/
theorem zeta_ne_zero_of_re_mem {w : ℂ} (h1 : -1 ≤ w.re) (h2 : w.re ≤ 0) :
    riemannZeta w ≠ 0 := by
  intro hw
  by_cases hw0 : w = 0
  · rw [hw0, riemannZeta_zero] at hw
    norm_num at hw
  set s : ℂ := 1 - w with hsd
  have hsre : s.re = 1 - w.re := by
    rw [hsd]
    simp [Complex.sub_re]
  have hsre1 : 1 ≤ s.re := by rw [hsre]; linarith
  have hsre2 : s.re ≤ 2 := by rw [hsre]; linarith
  have hsn : ∀ n : ℕ, s ≠ -(n:ℂ) := by
    intro n hcon
    have h5 := congrArg Complex.re hcon
    simp only [Complex.neg_re, Complex.natCast_re] at h5
    have h6 : (0:ℝ) ≤ (n:ℝ) := Nat.cast_nonneg n
    linarith
  have hs1 : s ≠ 1 := by
    rw [hsd]
    intro hcon
    apply hw0
    linear_combination -hcon
  have hfe := riemannZeta_one_sub hsn hs1
  have h1w : (1:ℂ) - s = w := by rw [hsd]; ring
  rw [h1w, hw] at hfe
  have hπne : ((Real.pi:ℝ):ℂ) ≠ 0 := Complex.ofReal_ne_zero.mpr Real.pi_ne_zero
  have hf2 : (2:ℂ) ≠ 0 := two_ne_zero
  have hfp : ((2:ℂ) * ((Real.pi:ℝ):ℂ)) ^ (-s) ≠ 0 := by
    rw [Complex.cpow_def_of_ne_zero (mul_ne_zero hf2 hπne)]
    exact Complex.exp_ne_zero _
  have hfΓ : Complex.Gamma s ≠ 0 := Complex.Gamma_ne_zero_of_re_pos (by linarith)
  have hfζ : riemannZeta s ≠ 0 := riemannZeta_ne_zero_of_one_le_re hsre1
  have hfc : Complex.cos (((Real.pi:ℝ):ℂ) * s / 2) ≠ 0 := by
    intro hc
    obtain ⟨k, hk⟩ := Complex.cos_eq_zero_iff.mp hc
    have hs2k : s = 2*(k:ℂ)+1 := by
      have h3 : ((Real.pi:ℝ):ℂ) * s = ((Real.pi:ℝ):ℂ) * (2*(k:ℂ)+1) := by
        linear_combination 2 * hk
      exact mul_left_cancel₀ hπne h3
    have h4 := congrArg Complex.re hs2k
    have h5 : s.re = 2*(k:ℝ)+1 := by
      rw [h4]
      simp
    have h6 : (0:ℤ) ≤ 2*k := by
      have : (0:ℝ) ≤ 2*(k:ℝ) := by linarith
      exact_mod_cast this
    have h7 : (2*k : ℤ) ≤ 1 := by
      have : 2*(k:ℝ) ≤ 1 := by linarith
      exact_mod_cast this
    have hk0 : k = 0 := by omega
    rw [hk0] at hs2k
    apply hs1
    rw [hs2k]
    norm_num
  exact (mul_ne_zero (mul_ne_zero (mul_ne_zero (mul_ne_zero hf2 hfp) hfΓ) hfc) hfζ)
    hfe.symm

/-- `(s−1)²·ζ` is analytic at `1`, from the unconditional
completed-zeta formula (junk values at `s = 1` agree on both sides). -/
theorem sq_mul_zeta_analyticAt_one :
    AnalyticAt ℂ (fun s ↦ (s - 1)^2 * riemannZeta s) 1 := by
  have hπ : ((Real.pi:ℝ):ℂ) ≠ 0 := Complex.ofReal_ne_zero.mpr Real.pi_ne_zero
  have heq : (fun s : ℂ ↦ (s - 1)^2 * riemannZeta s)
      = fun s ↦ ((s-1)^2 * (s * completedRiemannZeta₀ s - 1) + s * (s-1)) /
          (2 * ((Real.pi:ℝ):ℂ)^(-s/2) * Complex.Gamma (s/2 + 1)) := by
    funext s
    rw [riemannZeta_eq_mul_completedRiemannZeta₀, ← mul_div_assoc]
    congr 1
    by_cases hs1 : s = 1
    · rw [hs1]
      simp
    · have h1s : (1:ℂ) - s ≠ 0 := by
        intro hcon
        exact hs1 (by linear_combination -hcon)
      field_simp
      ring
  rw [heq]
  apply AnalyticAt.div
  · exact (((analyticAt_id.sub analyticAt_const).pow 2).mul
      ((analyticAt_id.mul (differentiable_completedZeta₀.analyticAt 1)).sub
        analyticAt_const)).add (analyticAt_id.mul (analyticAt_id.sub analyticAt_const))
  · apply AnalyticAt.mul
    · exact (analyticAt_const.mul
        (((differentiable_id.neg.div_const 2).const_cpow (Or.inl hπ)).analyticAt 1))
    · have hopen : IsOpen {s : ℂ | -2 < s.re} := isOpen_lt continuous_const Complex.continuous_re
      have hdiff : DifferentiableOn ℂ (fun s : ℂ ↦ Complex.Gamma (s/2 + 1))
          {s : ℂ | -2 < s.re} := by
        intro t ht
        apply DifferentiableAt.differentiableWithinAt
        have h1 : DifferentiableAt ℂ Complex.Gamma (t/2 + 1) := by
          apply Complex.differentiableAt_Gamma
          intro m hcon
          have h2 : t = -(2 * (m:ℂ)) - 2 := by linear_combination 2 * hcon
          have h3 : (-2:ℝ) < t.re := ht
          have h4 : t.re = -(2 * (m:ℝ)) - 2 := by
            rw [h2]
            simp
          rw [h4] at h3
          have h5 : (0:ℝ) ≤ (m:ℝ) := Nat.cast_nonneg m
          linarith
        exact h1.comp t ((differentiableAt_id.div_const 2).add_const 1)
      exact hdiff.analyticAt (hopen.mem_nhds (by simp; norm_num))
  · apply mul_ne_zero
    · apply mul_ne_zero two_ne_zero
      rw [Complex.cpow_def_of_ne_zero hπ]
      exact Complex.exp_ne_zero _
    · apply Complex.Gamma_ne_zero_of_re_pos
      have : ((1:ℂ)/2 + 1).re = 3/2 := by
        simp [Complex.add_re]
        norm_num
      rw [this]
      norm_num

/-- `ζ` is meromorphic on any set. -/
theorem zeta_meromorphicOn (U : Set ℂ) : MeromorphicOn riemannZeta U := by
  intro s hs
  by_cases hs1 : s = 1
  · rw [hs1]
    exact ⟨2, by simpa [smul_eq_mul] using sq_mul_zeta_analyticAt_one⟩
  · exact (zeta_analyticAt hs1).meromorphicAt

/-- The zeros of `ζ` in a closed rectangle form a finite set. -/
theorem zeta_zeros_rectangle_finite (z w : ℂ) :
    {ρ : ℂ | riemannZeta ρ = 0 ∧ ρ ∈ Rectangle z w}.Finite := by
  apply Set.Finite.subset
    ((divisor_support_rectangle_finite riemannZeta z w).union (Set.finite_singleton 1))
  rintro ρ ⟨hz, hρR⟩
  by_cases hρ1 : ρ = 1
  · right
    exact hρ1
  · left
    have h1 := (zeta_meromorphicOn (Rectangle z w)).divisor_apply hρR
    rw [Function.mem_support, h1, (zeta_analyticAt hρ1).meromorphicOrderAt_eq]
    cases hO : analyticOrderAt riemannZeta ρ with
    | top => exact absurd hO (zeta_order_ne_top hρ1)
    | coe n =>
      have hn : n ≠ 0 := by
        intro hn0
        rw [hn0] at hO
        exact ((zeta_analyticAt hρ1).analyticOrderAt_eq_zero.mp (by exact_mod_cast hO)) hz
      rw [ENat.map_coe, WithTop.untop₀_coe]
      exact_mod_cast hn

/-- The ledger's `riemannZeta.order` agrees with `analyticOrderNatAt`
away from the pole (mirrors PNT+ KadiriZeroCounting's own bridge). -/
theorem order_bridge {ρ : ℂ} (hρ1 : ρ ≠ 1) :
    ((riemannZeta.order ρ : ℤ) : ℂ) = ((analyticOrderNatAt riemannZeta ρ : ℕ) : ℂ) := by
  unfold riemannZeta.order
  rw [(zeta_analyticAt hρ1).meromorphicOrderAt_eq]
  cases hO : analyticOrderAt riemannZeta ρ with
  | top => exact absurd hO (zeta_order_ne_top hρ1)
  | coe n =>
    rw [ENat.map_coe, WithTop.untopD_coe]
    have h2 : analyticOrderNatAt riemannZeta ρ = n := by
      show (analyticOrderAt riemannZeta ρ).toNat = n
      rw [hO]
      simp
    rw [h2]
    push_cast
    ring

/-- `zeroPartialSum` as a concrete finite sum, over any `Finset`
enumerating exactly the nontrivial zeros below the height. -/
theorem zeroPartialSum_eq_sum {x T' : ℝ} {ZF : Finset ℂ}
    (hiff : ∀ ρ : ℂ, ρ ∈ ZF ↔ (ρ ∈ Kadiri.NontrivialZeros ∧ |ρ.im| < T')) :
    Stage3.zeroPartialSum x T'
      = ∑ p ∈ ZF, ((analyticOrderNatAt riemannZeta p : ℂ) * ((x : ℂ) ^ p / p)) := by
  classical
  set G : ℂ → ℂ := fun p ↦ ((analyticOrderNatAt riemannZeta p : ℂ) * ((x : ℂ) ^ p / p))
    with hGd
  let e : {ρ : Kadiri.NontrivialZeros // |(ρ:ℂ).im| < T'} ≃ {p : ℂ // p ∈ ZF} :=
    { toFun := fun ρ ↦ ⟨(ρ.val : ℂ), (hiff _).mpr ⟨ρ.val.property, ρ.property⟩⟩
      invFun := fun p ↦ ⟨⟨(p : ℂ), ((hiff p).mp p.property).1⟩, ((hiff p).mp p.property).2⟩
      left_inv := fun ρ ↦ Subtype.ext (Subtype.ext rfl)
      right_inv := fun p ↦ Subtype.ext rfl }
  haveI : Fintype {ρ : Kadiri.NontrivialZeros // |(ρ:ℂ).im| < T'} :=
    Fintype.ofEquiv _ e.symm
  calc Stage3.zeroPartialSum x T'
      = ∑ ρ : {ρ : Kadiri.NontrivialZeros // |(ρ:ℂ).im| < T'},
          ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ)
            * ((x : ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ)
              / ((ρ : Kadiri.NontrivialZeros) : ℂ)) := by
        rw [Stage3.zeroPartialSum, tsum_fintype]
    _ = ∑ ρ : {ρ : Kadiri.NontrivialZeros // |(ρ:ℂ).im| < T'}, G ((e ρ : ℂ)) := by
        apply Finset.sum_congr rfl
        intro ρ _
        have hρ1 : ((ρ.val : Kadiri.NontrivialZeros) : ℂ) ≠ 1 :=
          Kadiri.nontrivialZero_ne_one ρ.val
        rw [hGd]
        simp only []
        rw [order_bridge hρ1]
        rfl
    _ = ∑ p : {p : ℂ // p ∈ ZF}, G p := Equiv.sum_comp e (fun p ↦ G (p : ℂ))
    _ = ∑ p ∈ ZF, G p := Finset.sum_coe_sort ZF G

/-- info: 'ContourShift.zeta_meromorphicOn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_meromorphicOn

/-- info: 'ContourShift.zeta_zeros_rectangle_finite' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_zeros_rectangle_finite

/-- info: 'ContourShift.zeta_ne_zero_of_re_mem' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_ne_zero_of_re_mem

/-- info: 'ContourShift.zeta_local_data_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_local_data_zero

/-- info: 'ContourShift.zeta_local_data_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_local_data_one

/-- info: 'ContourShift.zeta_local_data_origin' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_local_data_origin

/-- info: 'ContourShift.residue_rectangle_of_local' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms residue_rectangle_of_local

/-- info: 'ContourShift.residue_rectangle_multi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms residue_rectangle_multi

/-- info: 'ContourShift.rectangleIntegral_sum_poles' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rectangleIntegral_sum_poles

/-- **Slice 4 — the residue identity on the good rectangle.** The zeros
enter here: pulling the line integral to `σ = −1` collects the pole at
`1` (residue `x`), the pole at `0` (residue `−ζ′/ζ(0)`), and every
nontrivial zero below height `T'` (residue `−m_ρ·x^ρ/ρ`). -/
theorem residue_identity {x T T' : ℝ} (hx : 16 ≤ x) (hT : 2 ≤ T)
    (hT' : T' ∈ Set.Icc T (T+1))
    (hgood : ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → zeroGap T ≤ |ρ.im - T'|) :
    RectangleIntegral'
        (fun s : ℂ ↦ (- deriv riemannZeta s / riemannZeta s)
          * ((x:ℝ):ℂ) ^ s / s)
        (-1 - Complex.I * T') (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * T')
      = (x : ℂ) - deriv riemannZeta 0 / riemannZeta 0
        - Stage3.zeroPartialSum x T' := by
  classical
  have hx0 : (0:ℝ) < x := by linarith
  have hlx : (0:ℝ) < Real.log x := Real.log_pos (by linarith)
  obtain ⟨hT'lo, hT'hi⟩ := hT'
  have hT'2 : (2:ℝ) ≤ T' := le_trans hT hT'lo
  set c : ℝ := 1 + 1/Real.log x with hcd
  have hc1 : 1 < c := by
    rw [hcd]
    have h1 : (0:ℝ) < 1/Real.log x := by positivity
    linarith
  set zc : ℂ := -1 - Complex.I * (T':ℂ) with hzcd
  set wc : ℂ := ((c:ℝ):ℂ) + Complex.I * (T':ℂ) with hwcd
  have hzre : zc.re = -1 := by rw [hzcd]; simp
  have hzim : zc.im = -T' := by rw [hzcd]; simp
  have hwre : wc.re = c := by rw [hwcd]; simp
  have hwim : wc.im = T' := by rw [hwcd]; simp
  have hrele : zc.re ≤ wc.re := by rw [hzre, hwre]; linarith
  have himle : zc.im ≤ wc.im := by rw [hzim, hwim]; linarith
  have hrect_mem : ∀ s : ℂ, s ∈ Rectangle zc wc ↔
      ((-1 ≤ s.re ∧ s.re ≤ c) ∧ (-T' ≤ s.im ∧ s.im ≤ T')) := by
    intro s
    simp only [Rectangle]
    rw [Complex.mem_reProdIm, hzre, hwre, hzim, hwim,
      Set.uIcc_of_le (by linarith : (-1:ℝ) ≤ c),
      Set.uIcc_of_le (by linarith : -T' ≤ T'), Set.mem_Icc, Set.mem_Icc]
  have hfence : ∀ ρ : ℂ, riemannZeta ρ = 0 → ρ ∈ Rectangle zc wc →
      ((0 < ρ.re ∧ ρ.re < 1) ∧ |ρ.im| < T') := by
    intro ρ hz hρR
    obtain ⟨⟨hre1, hre2⟩, him1, him2⟩ := (hrect_mem ρ).mp hρR
    have hre_pos : 0 < ρ.re := by
      by_contra hle
      push_neg at hle
      exact zeta_ne_zero_of_re_mem hre1 hle hz
    have hre_lt1 : ρ.re < 1 := by
      by_contra hge
      push_neg at hge
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

/-- info: 'ContourShift.residue_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms residue_identity

/-- info: 'ContourShift.zeroPartialSum_eq_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeroPartialSum_eq_sum

end ContourShift
