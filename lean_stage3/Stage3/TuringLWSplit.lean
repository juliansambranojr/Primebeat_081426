/-
TuringLWSplit — block S14 of `lean_stage3/design/stencil.md`, Turing's method, Littlewood's
pieces: the split identity (`Turing.StmtSplit`) and the oscillating right edge
(`Turing.StmtOsc`, from `Stage3/TuringLWSplitOsc.lean`). 2026-11-25.

**(Split)** For `2 ≤ t₁ ≤ t₂`,

  `π (S₁ t₂ − S₁ t₁) = ∫_{t₁}^{t₂} F + ∫_{1/2}^{2} (log|ζ(x + it₂)| − log|ζ(x + it₁)|) dx`.

The route, on the rectangle `R = [1/2, 2] × [t₁, t₂]` and the larger `R₀ = [0, 2] × [t₁, t₂]`:
* the zeros of `ζ` in `R₀` are finitely many (PNT+ `divisor_support_rectangle_finite`, read
  through `Littlewood.mem_support_divisor`); every zero with `Re ρ > 0` and height in
  `[t₁, t₂]` lies in `R₀` (`Re ρ < 1`). So at almost every `t ∈ (t₁, t₂]` the height is good and
  `Stage3.argS_eq_zetaArgContour` gives `π S t = F t − Im ∫_{1/2}^{2} L(x + it) dx`, `L = ζ′/ζ`;
* `L(x + it)` is integrable on `R` (`Littlewood.integrableOn_logDeriv_prod`), so the order of
  integration swaps (Fubini) and `Im` commutes with both integrals;
* on almost every vertical `x` (no zero of `R₀` on it), `∂_t log|ζ(x + it)| = −Im L(x + it)`
  (`integral_im_logDeriv_vertical`), so `∫_{t₁}^{t₂} Im L(x + it) dt = log|ζ(x + it₁)| −
  log|ζ(x + it₂)|`;
* `x ↦ log|ζ(x + it)|` is interval integrable for `t ≠ 0` (Mathlib
  `MeromorphicOn.intervalIntegrable_log_norm`, `ζ(· + it)` real-analytic), which splits the
  last integral even when a zero sits on a horizontal edge.

| name | content | status |
|---|---|---|
| `order_ne_top_of` | `f` analytic on `R`, `f q ≠ 0` at one `q ∈ R` ⊢ no order `⊤` on `R` | proved |
| `zeta_analyticOnNhd` | `0 < Im z, Im w` ⊢ `ζ` analytic on `Rectangle z w` | proved |
| `integral_im_logDeriv_vertical` | no zero on `Re = x` ⊢ `∫ Im L(x+it) dt = log‖f(x+ic)‖ − log‖f(x+id)‖` | proved |
| `intervalIntegrable_log_zeta` | `t ≠ 0` ⊢ `x ↦ log‖ζ(x + it)‖` interval integrable | proved |
| `pi_S_ae` | a.e. `t ∈ (t₁, t₂]`: `π S t = F t − Im ∫_{1/2}^{2} L(x + it) dx` | proved |
| `stmtSplit_holds` | `Turing.StmtSplit` | proved |
| `stmtOsc_holds` | `Turing.StmtOsc 2` (in `TuringLWSplitOsc`) | proved |
| `littlewood_of_lower` | `StmtHorizLower a₂ b₂` ⊢ `StmtLittlewood ((3/2 + a₂)/π) ((2 + (3/2) log 9 + b₂)/π) 2` | proved |

Open: `Turing.StmtHorizLower a₂ b₂` (another worker, `Stage3/TuringLWHoriz*.lean`).

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.TuringLWSplitOsc
import Stage3.Littlewood

namespace TuringLW

open Complex MeasureTheory Set Filter
open scoped Interval

/-- `Littlewood.order_ne_top` with any nonvanishing point of the rectangle for the corner. -/
theorem order_ne_top_of {f : ℂ → ℂ} {z w q : ℂ} (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hq : q ∈ Rectangle z w) (hfq : f q ≠ 0) :
    ∀ p ∈ Rectangle z w, meromorphicOrderAt f p ≠ ⊤ := by
  intro p hp htop
  rw [(hf p hp).meromorphicOrderAt_eq] at htop
  have h2 : analyticOrderAt f p = ⊤ := by
    cases hn : analyticOrderAt f p
    · rfl
    · rw [hn] at htop; simp [ENat.map_coe] at htop
  have hev := analyticOrderAt_eq_top.mp h2
  have hconv : Convex ℝ (Rectangle z w) := by
    rw [Complex.rectangle_eq_convexHull]; exact convex_convexHull ℝ _
  have hzero := hf.eqOn_zero_of_preconnected_of_eventuallyEq_zero hconv.isPreconnected hp hev
  exact hfq (hzero hq)

theorem far_mem (z w : ℂ) : w ∈ Rectangle z w :=
  mem_reProdIm.mpr ⟨right_mem_uIcc, right_mem_uIcc⟩

theorem zeta_analyticOnNhd {z w : ℂ} (hz : 0 < z.im) (hw : 0 < w.im) :
    AnalyticOnNhd ℂ riemannZeta (Rectangle z w) := by
  intro p hp
  apply analyticAt_riemannZeta
  intro h1
  have him := (mem_reProdIm.mp hp).2
  rw [h1, Complex.one_im] at him
  rcases Set.mem_uIcc.mp him with h | h <;> linarith [h.1, h.2]

/-- **The imaginary part along a vertical line is a difference of `log ‖f‖`.** No branch. -/
theorem integral_im_logDeriv_vertical {f : ℂ → ℂ} {z w : ℂ}
    (hf : AnalyticOnNhd ℂ f (Rectangle z w)) {x : ℝ} (hx : x ∈ [[z.re, w.re]])
    (hnz : ∀ t ∈ [[z.im, w.im]], f (↑x + ↑t * I) ≠ 0) :
    ∫ t in z.im..w.im, (logDeriv f (↑x + ↑t * I)).im
      = Real.log ‖f (↑x + ↑z.im * I)‖ - Real.log ‖f (↑x + ↑w.im * I)‖ := by
  have key := intervalIntegral.integral_eq_sub_of_hasDerivAt (a := z.im) (b := w.im)
    (f := fun t : ℝ => -Real.log ‖f (↑x + ↑t * I)‖)
    (f' := fun t : ℝ => (logDeriv f (↑x + ↑t * I)).im) ?_ ?_
  · rw [key]; ring
  · intro t ht
    have h1 : HasDerivAt (fun s : ℂ => (x : ℂ) + s * I) I (t : ℂ) := by
      simpa using ((hasDerivAt_id (t : ℂ)).mul_const I).const_add (x : ℂ)
    have hd : HasDerivAt (fun s : ℂ => f ((x : ℂ) + s * I))
        (deriv f (↑x + ↑t * I) * I) (t : ℂ) :=
      ((hf _ (Littlewood.horiz_mem hx ht)).differentiableAt.hasDerivAt).comp (t : ℂ) h1
    have h2 := (Littlewood.hasDerivAt_log_norm hd.comp_ofReal (hnz t ht)).neg
    refine h2.congr_deriv ?_
    rw [logDeriv_apply, mul_div_right_comm, Complex.mul_I_re, neg_neg]
  · apply ContinuousOn.intervalIntegrable
    exact Complex.continuous_im.comp_continuousOn
      (Littlewood.continuousOn_logDeriv_comp hf (by fun_prop)
        (fun t ht => Littlewood.horiz_mem hx ht) hnz)

/-- `x ↦ log ‖ζ(x + it)‖` is interval integrable off the real axis: `ζ(· + it)` is
real-analytic, and `log ‖·‖` of a real-meromorphic function is (Mathlib). -/
theorem intervalIntegrable_log_zeta {t : ℝ} (ht : t ≠ 0) (a b : ℝ) :
    IntervalIntegrable (fun x : ℝ => Real.log ‖riemannZeta ((x : ℂ) + (t : ℂ) * I)‖) volume a b := by
  apply MeromorphicOn.intervalIntegrable_log_norm (f := fun x : ℝ => riemannZeta ((x : ℂ) + (t : ℂ) * I))
  intro x _
  have h1 : ((x : ℂ) + (t : ℂ) * I) ≠ 1 := by
    intro h
    have := congrArg Complex.im h
    simp at this
    exact ht this
  have hz : AnalyticAt ℝ riemannZeta ((x : ℂ) + (t : ℂ) * I) :=
    (analyticAt_riemannZeta h1).restrictScalars
  have hg : AnalyticAt ℝ (fun y : ℝ => (y : ℂ) + (t : ℂ) * I) x :=
    (Complex.ofRealCLM.analyticAt x).add analyticAt_const
  exact (hz.comp_of_eq hg rfl).meromorphicAt

/-- **The split identity**, `Turing.StmtSplit`. -/
theorem stmtSplit_holds : Turing.StmtSplit := by
  intro t₁ t₂ h1 h12
  classical
  obtain ⟨z0, hz0⟩ : ∃ c : ℂ, c = ⟨0, t₁⟩ := ⟨_, rfl⟩
  obtain ⟨z, hz⟩ : ∃ c : ℂ, c = ⟨1 / 2, t₁⟩ := ⟨_, rfl⟩
  obtain ⟨w, hw⟩ : ∃ c : ℂ, c = ⟨2, t₂⟩ := ⟨_, rfl⟩
  have hz0re : z0.re = 0 := by rw [hz0]
  have hz0im : z0.im = t₁ := by rw [hz0]
  have hzre : z.re = 1 / 2 := by rw [hz]
  have hzim : z.im = t₁ := by rw [hz]
  have hwre : w.re = 2 := by rw [hw]
  have hwim : w.im = t₂ := by rw [hw]
  have hζw : riemannZeta w ≠ 0 := riemannZeta_ne_zero_of_one_le_re (by rw [hwre]; norm_num)
  have hfa0 : AnalyticOnNhd ℂ riemannZeta (Rectangle z0 w) :=
    zeta_analyticOnNhd (by rw [hz0im]; linarith) (by rw [hwim]; linarith)
  have hfa : AnalyticOnNhd ℂ riemannZeta (Rectangle z w) :=
    zeta_analyticOnNhd (by rw [hzim]; linarith) (by rw [hwim]; linarith)
  have hfin0 := order_ne_top_of hfa0 (far_mem z0 w) hζw
  have hfin := order_ne_top_of hfa (far_mem z w) hζw
  set Z := (divisor_support_rectangle_finite riemannZeta z0 w).toFinset with hZdef
  have hZ : ∀ p ∈ Rectangle z0 w, riemannZeta p = 0 → p ∈ Z := fun p hp h0 =>
    (divisor_support_rectangle_finite riemannZeta z0 w).mem_toFinset.mpr
      ((Littlewood.mem_support_divisor subset_rfl hfa0 hfin0 p).mpr ⟨hp, h0⟩)
  have hR0 : ∀ x t : ℝ, 0 ≤ x → x ≤ 2 → t₁ ≤ t → t ≤ t₂ →
      ((x : ℂ) + (t : ℂ) * I) ∈ Rectangle z0 w := fun x t hx0 hx2 ht1 ht2 =>
    Littlewood.horiz_mem (by rw [hz0re, hwre]; exact Set.mem_uIcc_of_le hx0 hx2)
      (by rw [hz0im, hwim]; exact Set.mem_uIcc_of_le ht1 ht2)
  -- (a) the argument identity at almost every height
  have hA : ∀ᵐ t ∂volume, t ∈ Ι t₁ t₂ → Real.pi * Turing.S t
      = Turing.F t - (∫ x in (1 / 2 : ℝ)..2, logDeriv riemannZeta (↑x + ↑t * I)).im := by
    have hc : ((Z.image Complex.im : Finset ℝ) : Set ℝ).Countable := Finset.countable_toSet _
    filter_upwards [hc.ae_notMem volume] with t ht htI
    rw [uIoc_of_le h12] at htI
    have hgood : ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → ρ.im ≠ t := by
      intro ρ hρ hre him
      have hre1 : ρ.re < 1 := by
        by_contra hc
        exact riemannZeta_ne_zero_of_one_le_re (not_lt.mp hc) hρ
      have hmem : ρ ∈ Rectangle z0 w := by
        have hρ' := hR0 ρ.re ρ.im hre.le (by linarith) (by rw [him]; exact htI.1.le)
          (by rw [him]; exact htI.2)
        rwa [Complex.re_add_im] at hρ'
      exact ht (Finset.mem_coe.mpr (Finset.mem_image.mpr ⟨ρ, hZ ρ hmem hρ, him⟩))
    have harg := Stage3.argS_eq_zetaArgContour (by linarith [htI.1]) hgood
    rw [Turing.S_eq_argS, harg, Stage3.zetaArgContour, Turing.F, ← mul_assoc,
      mul_one_div_cancel Real.pi_ne_zero, one_mul]
  -- (b) Fubini on `R`
  have hrect := Littlewood.integrableOn_logDeriv_prod hfa hfin
  rw [hzre, hwre, hzim, hwim] at hrect
  have hint2 : Integrable (Function.uncurry fun (x t : ℝ) => logDeriv riemannZeta (↑x + ↑t * I))
      ((volume.restrict (Ioc (1 / 2 : ℝ) 2)).prod (volume.restrict (Ioc t₁ t₂))) := by
    rw [Measure.prod_restrict, ← Measure.volume_eq_prod]
    have hsub : Ioc (1 / 2 : ℝ) 2 ×ˢ Ioc t₁ t₂ ⊆ [[(1 / 2 : ℝ), 2]] ×ˢ [[t₁, t₂]] := by
      rw [uIcc_of_le (by norm_num), uIcc_of_le h12]
      exact prod_mono Ioc_subset_Icc_self Ioc_subset_Icc_self
    exact hrect.mono_set hsub
  have hhalf : (1 / 2 : ℝ) ≤ 2 := by norm_num
  have hswap : ∫ x in (1 / 2 : ℝ)..2, (∫ t in t₁..t₂, logDeriv riemannZeta (↑x + ↑t * I))
      = ∫ t in t₁..t₂, (∫ x in (1 / 2 : ℝ)..2, logDeriv riemannZeta (↑x + ↑t * I)) := by
    simp only [intervalIntegral.integral_of_le hhalf, intervalIntegral.integral_of_le h12]
    exact integral_integral_swap hint2
  have hXint : IntervalIntegrable
      (fun x : ℝ => ∫ t in t₁..t₂, logDeriv riemannZeta (↑x + ↑t * I)) volume (1 / 2) 2 := by
    rw [intervalIntegrable_iff_integrableOn_Ioc_of_le hhalf]
    simp only [intervalIntegral.integral_of_le h12]
    exact hint2.integral_prod_left
  have hTint : IntervalIntegrable
      (fun t : ℝ => ∫ x in (1 / 2 : ℝ)..2, logDeriv riemannZeta (↑x + ↑t * I)) volume t₁ t₂ := by
    rw [intervalIntegrable_iff_integrableOn_Ioc_of_le h12]
    simp only [intervalIntegral.integral_of_le hhalf]
    exact hint2.integral_prod_right
  have hGint : IntervalIntegrable
      (fun t : ℝ => (∫ x in (1 / 2 : ℝ)..2, logDeriv riemannZeta (↑x + ↑t * I)).im)
      volume t₁ t₂ := by
    rw [intervalIntegrable_iff_integrableOn_Ioc_of_le h12] at hTint ⊢
    exact Complex.imCLM.integrable_comp hTint
  have hcomm1 : ∫ t in t₁..t₂, (∫ x in (1 / 2 : ℝ)..2, logDeriv riemannZeta (↑x + ↑t * I)).im
      = (∫ t in t₁..t₂, ∫ x in (1 / 2 : ℝ)..2, logDeriv riemannZeta (↑x + ↑t * I)).im := by
    have := Complex.imCLM.intervalIntegral_comp_comm hTint
    simp only [Complex.imCLM_apply] at this
    exact this
  have hcomm2 : (∫ x in (1 / 2 : ℝ)..2, ∫ t in t₁..t₂, logDeriv riemannZeta (↑x + ↑t * I)).im
      = ∫ x in (1 / 2 : ℝ)..2, (∫ t in t₁..t₂, logDeriv riemannZeta (↑x + ↑t * I)).im := by
    have := Complex.imCLM.intervalIntegral_comp_comm hXint
    simp only [Complex.imCLM_apply] at this
    exact this.symm
  -- (c) almost every vertical
  have hC : ∀ᵐ x ∂volume, x ∈ Ι (1 / 2 : ℝ) 2 →
      (∫ t in t₁..t₂, logDeriv riemannZeta (↑x + ↑t * I)).im
        = Real.log ‖riemannZeta ((x : ℂ) + (t₁ : ℂ) * I)‖
          - Real.log ‖riemannZeta ((x : ℂ) + (t₂ : ℂ) * I)‖ := by
    have hc : ((Z.image Complex.re : Finset ℝ) : Set ℝ).Countable := Finset.countable_toSet _
    filter_upwards [hc.ae_notMem volume] with x hx hxI
    rw [uIoc_of_le hhalf] at hxI
    have hxR : x ∈ [[z.re, w.re]] := by
      rw [hzre, hwre]; exact Set.mem_uIcc_of_le hxI.1.le hxI.2
    have hnz : ∀ t ∈ [[z.im, w.im]], riemannZeta (↑x + ↑t * I) ≠ 0 := by
      intro t ht h0
      rw [hzim, hwim, uIcc_of_le h12] at ht
      have hmem := hR0 x t (by linarith [hxI.1]) hxI.2 ht.1 ht.2
      exact hx (Finset.mem_coe.mpr (Finset.mem_image.mpr ⟨_, hZ _ hmem h0, by simp⟩))
    have hcont : ContinuousOn (fun t : ℝ => logDeriv riemannZeta (↑x + ↑t * I)) [[z.im, w.im]] :=
      Littlewood.continuousOn_logDeriv_comp hfa (by fun_prop)
        (fun t ht => Littlewood.horiz_mem hxR ht) hnz
    rw [hzim, hwim] at hcont
    have hcm := Complex.imCLM.intervalIntegral_comp_comm (hcont.intervalIntegrable (μ := volume))
    simp only [Complex.imCLM_apply] at hcm
    have hv := integral_im_logDeriv_vertical hfa hxR hnz
    rw [hzim, hwim] at hv
    rw [← hcm, hv]
  -- (d) assembly
  have hl1 := intervalIntegrable_log_zeta (t := t₁) (by linarith) (1 / 2) 2
  have hl2 := intervalIntegrable_log_zeta (t := t₂) (by linarith) (1 / 2) 2
  rw [Turing.S₁_sub, ← intervalIntegral.integral_const_mul, intervalIntegral.integral_congr_ae hA,
    intervalIntegral.integral_sub (continuous_F.intervalIntegrable _ _) hGint, hcomm1, ← hswap,
    hcomm2, intervalIntegral.integral_congr_ae hC, intervalIntegral.integral_sub hl1 hl2]
  ring

/-- **Littlewood's bound from the lower horizontal side alone**: (Split) and (Osc) are proved. -/
theorem littlewood_of_lower {a₂ b₂ : ℝ} (hlow : Turing.StmtHorizLower a₂ b₂) (ha₂ : 0 ≤ a₂) :
    Turing.StmtLittlewood ((3 / 2 + a₂) / Real.pi)
      ((2 + (3 / 2) * Real.log 9 + b₂) / Real.pi) 2 :=
  Turing.littlewood_of_pieces stmtSplit_holds stmtOsc_holds hlow ha₂

/-- info: 'TuringLW.integral_im_logDeriv_vertical' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms integral_im_logDeriv_vertical

/-- info: 'TuringLW.intervalIntegrable_log_zeta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms intervalIntegrable_log_zeta

/-- info: 'TuringLW.stmtSplit_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtSplit_holds

/-- info: 'TuringLW.littlewood_of_lower' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms littlewood_of_lower

end TuringLW
