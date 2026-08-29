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
  apply continuousOn_finset_sum
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
  sorry

end ContourShift
