/-
BasinChainSplit — block S15 of `lean_stage3/design/stencil.md`, the chain from no right zeros,
step 3 (the split): the horizontal edge `h(t)` integrated in `t` is a difference of `∫ log|V|`.
2026-11-25.

Pins: `PINS.md` § Current, "the chain to the goal from no right zeros".

**The split, for any `f` analytic on a rectangle** (`split_logDeriv`): on
`[x₁, x₂] × [t₁, t₂]`, with `f` not identically zero there and `x ↦ log‖f(x + it_j)‖`
integrable,

  `∫_{t₁}^{t₂} Im ∫_{x₁}^{x₂} f′/f (x + it) dx dt = ∫_{x₁}^{x₂} log‖f(x + it₁)‖ dx
                                                    − ∫_{x₁}^{x₂} log‖f(x + it₂)‖ dx`,

and the inner function of `t` is interval integrable. The route is part (b)–(d) of
`TuringLW.stmtSplit_holds` with `ζ` replaced by `f` and no argument identity: Fubini on the
rectangle (`Littlewood.integrableOn_logDeriv_prod`), `Im` through both integrals, and on almost
every vertical (no zero of `f` on it, the zeros being finitely many) `∫ Im f′/f dt =
log‖f(x + it₁)‖ − log‖f(x + it₂)‖` (`TuringLW.integral_im_logDeriv_vertical`). A zero on a
horizontal edge or on the left edge is allowed: the identity is almost everywhere.

For `V = ConreyCount.V Q L` above `Im = 1/2` (`split_V`): `∫_{t₁}^{t₂} hEdge Q L t dt =
J(t₁) − J(t₂)`, `J(t) = ∫_{1/2}^{3} log‖V(x + it)‖ dx` (`logJ`), with `V` nonzero at one point.
This is Littlewood's lemma for `arg V`: `hEdge` is the turning of `arg V` from the line to
`Re s = 3`, and only its integral enters the averaging.

  | name | statement | status |
  |---|---|---|
  | `split_logDeriv` | the split, `f` analytic on the rectangle | PROVED |
  | `intervalIntegrable_log_V` | `1/2 < t` ⊢ `x ↦ log‖V(x + it)‖` interval integrable | PROVED |
  | `logJ` | `J(t) = ∫_{1/2}^{3} log‖V(x + it)‖ dx` | def |
  | `split_V` | `∫ hEdge = J t₁ − J t₂`, `hEdge` integrable | PROVED |

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.BasinChainCount
import Stage3.TuringLWSplit

noncomputable section

namespace BasinChain

open Complex MeasureTheory Set Filter Polynomial ConreyCount
open scoped Interval

/-- **The split for `f` analytic on a rectangle.** -/
theorem split_logDeriv {f : ℂ → ℂ} {x₁ x₂ t₁ t₂ : ℝ} (hx : x₁ ≤ x₂) (h12 : t₁ ≤ t₂)
    (hfa : AnalyticOnNhd ℂ f (Rectangle ⟨x₁, t₁⟩ ⟨x₂, t₂⟩))
    {q : ℂ} (hq : q ∈ Rectangle ⟨x₁, t₁⟩ ⟨x₂, t₂⟩) (hfq : f q ≠ 0)
    (hl1 : IntervalIntegrable (fun x : ℝ => Real.log ‖f ((x : ℂ) + (t₁ : ℂ) * I)‖) volume x₁ x₂)
    (hl2 : IntervalIntegrable (fun x : ℝ => Real.log ‖f ((x : ℂ) + (t₂ : ℂ) * I)‖) volume x₁ x₂) :
    IntervalIntegrable (fun t : ℝ => (∫ x in x₁..x₂, logDeriv f (↑x + ↑t * I)).im) volume t₁ t₂ ∧
    ∫ t in t₁..t₂, (∫ x in x₁..x₂, logDeriv f (↑x + ↑t * I)).im
      = (∫ x in x₁..x₂, Real.log ‖f ((x : ℂ) + (t₁ : ℂ) * I)‖)
        - ∫ x in x₁..x₂, Real.log ‖f ((x : ℂ) + (t₂ : ℂ) * I)‖ := by
  classical
  obtain ⟨z, hz⟩ : ∃ c : ℂ, c = ⟨x₁, t₁⟩ := ⟨_, rfl⟩
  obtain ⟨w, hw⟩ : ∃ c : ℂ, c = ⟨x₂, t₂⟩ := ⟨_, rfl⟩
  rw [← hz, ← hw] at hfa hq
  have hzre : z.re = x₁ := by rw [hz]
  have hzim : z.im = t₁ := by rw [hz]
  have hwre : w.re = x₂ := by rw [hw]
  have hwim : w.im = t₂ := by rw [hw]
  have hfin := TuringLW.order_ne_top_of hfa hq hfq
  set Z := (divisor_support_rectangle_finite f z w).toFinset with hZdef
  have hZ : ∀ p ∈ Rectangle z w, f p = 0 → p ∈ Z := fun p hp h0 =>
    (divisor_support_rectangle_finite f z w).mem_toFinset.mpr
      ((Littlewood.mem_support_divisor subset_rfl hfa hfin p).mpr ⟨hp, h0⟩)
  have hR0 : ∀ x t : ℝ, x₁ ≤ x → x ≤ x₂ → t₁ ≤ t → t ≤ t₂ →
      ((x : ℂ) + (t : ℂ) * I) ∈ Rectangle z w := fun x t hx1 hx2 ht1 ht2 =>
    Littlewood.horiz_mem (by rw [hzre, hwre]; exact Set.mem_uIcc_of_le hx1 hx2)
      (by rw [hzim, hwim]; exact Set.mem_uIcc_of_le ht1 ht2)
  -- Fubini on the rectangle
  have hrect := Littlewood.integrableOn_logDeriv_prod hfa hfin
  rw [hzre, hwre, hzim, hwim] at hrect
  have hint2 : Integrable (Function.uncurry fun (x t : ℝ) => logDeriv f (↑x + ↑t * I))
      ((volume.restrict (Ioc x₁ x₂)).prod (volume.restrict (Ioc t₁ t₂))) := by
    rw [Measure.prod_restrict, ← Measure.volume_eq_prod]
    have hsub : Ioc x₁ x₂ ×ˢ Ioc t₁ t₂ ⊆ [[x₁, x₂]] ×ˢ [[t₁, t₂]] := by
      rw [uIcc_of_le hx, uIcc_of_le h12]
      exact prod_mono Ioc_subset_Icc_self Ioc_subset_Icc_self
    exact hrect.mono_set hsub
  have hswap : ∫ x in x₁..x₂, (∫ t in t₁..t₂, logDeriv f (↑x + ↑t * I))
      = ∫ t in t₁..t₂, (∫ x in x₁..x₂, logDeriv f (↑x + ↑t * I)) := by
    simp only [intervalIntegral.integral_of_le hx, intervalIntegral.integral_of_le h12]
    exact integral_integral_swap hint2
  have hXint : IntervalIntegrable
      (fun x : ℝ => ∫ t in t₁..t₂, logDeriv f (↑x + ↑t * I)) volume x₁ x₂ := by
    rw [intervalIntegrable_iff_integrableOn_Ioc_of_le hx]
    simp only [intervalIntegral.integral_of_le h12]
    exact hint2.integral_prod_left
  have hTint : IntervalIntegrable
      (fun t : ℝ => ∫ x in x₁..x₂, logDeriv f (↑x + ↑t * I)) volume t₁ t₂ := by
    rw [intervalIntegrable_iff_integrableOn_Ioc_of_le h12]
    simp only [intervalIntegral.integral_of_le hx]
    exact hint2.integral_prod_right
  have hGint : IntervalIntegrable
      (fun t : ℝ => (∫ x in x₁..x₂, logDeriv f (↑x + ↑t * I)).im) volume t₁ t₂ := by
    rw [intervalIntegrable_iff_integrableOn_Ioc_of_le h12] at hTint ⊢
    exact Complex.imCLM.integrable_comp hTint
  refine ⟨hGint, ?_⟩
  have hcomm1 : ∫ t in t₁..t₂, (∫ x in x₁..x₂, logDeriv f (↑x + ↑t * I)).im
      = (∫ t in t₁..t₂, ∫ x in x₁..x₂, logDeriv f (↑x + ↑t * I)).im := by
    have := Complex.imCLM.intervalIntegral_comp_comm hTint
    simp only [Complex.imCLM_apply] at this
    exact this
  have hcomm2 : (∫ x in x₁..x₂, ∫ t in t₁..t₂, logDeriv f (↑x + ↑t * I)).im
      = ∫ x in x₁..x₂, (∫ t in t₁..t₂, logDeriv f (↑x + ↑t * I)).im := by
    have := Complex.imCLM.intervalIntegral_comp_comm hXint
    simp only [Complex.imCLM_apply] at this
    exact this.symm
  -- almost every vertical
  have hC : ∀ᵐ x ∂volume, x ∈ Ι x₁ x₂ →
      (∫ t in t₁..t₂, logDeriv f (↑x + ↑t * I)).im
        = Real.log ‖f ((x : ℂ) + (t₁ : ℂ) * I)‖ - Real.log ‖f ((x : ℂ) + (t₂ : ℂ) * I)‖ := by
    have hc : ((Z.image Complex.re : Finset ℝ) : Set ℝ).Countable := Finset.countable_toSet _
    filter_upwards [hc.ae_notMem volume] with x hxZ hxI
    rw [uIoc_of_le hx] at hxI
    have hxR : x ∈ [[z.re, w.re]] := by
      rw [hzre, hwre]; exact Set.mem_uIcc_of_le hxI.1.le hxI.2
    have hnz : ∀ t ∈ [[z.im, w.im]], f (↑x + ↑t * I) ≠ 0 := by
      intro t ht h0
      rw [hzim, hwim, uIcc_of_le h12] at ht
      have hmem := hR0 x t hxI.1.le hxI.2 ht.1 ht.2
      exact hxZ (Finset.mem_coe.mpr (Finset.mem_image.mpr ⟨_, hZ _ hmem h0, by simp⟩))
    have hcont : ContinuousOn (fun t : ℝ => logDeriv f (↑x + ↑t * I)) [[z.im, w.im]] :=
      Littlewood.continuousOn_logDeriv_comp hfa (by fun_prop)
        (fun t ht => Littlewood.horiz_mem hxR ht) hnz
    rw [hzim, hwim] at hcont
    have hcm := Complex.imCLM.intervalIntegral_comp_comm (hcont.intervalIntegrable (μ := volume))
    simp only [Complex.imCLM_apply] at hcm
    have hv := TuringLW.integral_im_logDeriv_vertical hfa hxR hnz
    rw [hzim, hwim] at hv
    rw [← hcm, hv]
  rw [hcomm1, ← hswap, hcomm2, intervalIntegral.integral_congr_ae hC,
    intervalIntegral.integral_sub hl1 hl2]

/-- `x ↦ log ‖V(x + it)‖` is interval integrable above `Im = 1/2`. -/
theorem intervalIntegrable_log_V (Q : ℝ[X]) (L : ℝ) {t : ℝ} (ht : 1/2 < t) (a b : ℝ) :
    IntervalIntegrable (fun x : ℝ => Real.log ‖V Q L ((x : ℂ) + (t : ℂ) * I)‖) volume a b := by
  apply MeromorphicOn.intervalIntegrable_log_norm
    (f := fun x : ℝ => V Q L ((x : ℂ) + (t : ℂ) * I))
  intro x _
  have hz : AnalyticAt ℝ (V Q L) ((x : ℂ) + (t : ℂ) * I) :=
    (analyticAt_V_upper Q L (by simpa using ht)).restrictScalars
  have hg : AnalyticAt ℝ (fun y : ℝ => (y : ℂ) + (t : ℂ) * I) x :=
    (Complex.ofRealCLM.analyticAt x).add analyticAt_const
  exact (hz.comp_of_eq hg rfl).meromorphicAt

/-- `J(t) = ∫_{1/2}^{3} log‖V(x + it)‖ dx`. -/
def logJ (Q : ℝ[X]) (L t : ℝ) : ℝ :=
  ∫ x in (1/2 : ℝ)..3, Real.log ‖V Q L ((x : ℂ) + (t : ℂ) * I)‖

/-- **The split for `V`.** For `1/2 < t₁ ≤ t₂` and `V(3 + t₁ i) ≠ 0`: `hEdge` is interval
integrable on `[t₁, t₂]` and `∫_{t₁}^{t₂} hEdge = J(t₁) − J(t₂)`. -/
theorem split_V (Q : ℝ[X]) (L : ℝ) {t₁ t₂ : ℝ} (h1 : 1/2 < t₁) (h12 : t₁ ≤ t₂)
    (hne : V Q L (3 + t₁ * I) ≠ 0) :
    IntervalIntegrable (fun t => hEdge Q L t) volume t₁ t₂ ∧
    ∫ t in t₁..t₂, hEdge Q L t = logJ Q L t₁ - logJ Q L t₂ := by
  have hfa : AnalyticOnNhd ℂ (V Q L) (Rectangle ⟨1/2, t₁⟩ ⟨3, t₂⟩) := by
    intro p hp
    have him := (mem_reProdIm.mp hp).2
    simp only at him
    rw [Set.uIcc_of_le h12] at him
    exact analyticAt_V_upper Q L (by linarith [him.1])
  have hq : (3 + t₁ * I : ℂ) ∈ Rectangle ⟨1/2, t₁⟩ ⟨3, t₂⟩ := by
    refine mem_reProdIm.mpr ⟨?_, ?_⟩
    · simp only [add_re, ofReal_re, mul_re, I_re, mul_zero, ofReal_im, I_im, mul_one, sub_self,
        add_zero, Complex.re_ofNat]
      rw [Set.uIcc_of_le (by norm_num : (1/2 : ℝ) ≤ 3)]
      norm_num
    · simp only [add_im, mul_im, ofReal_re, I_im, mul_one, ofReal_im, I_re, mul_zero, add_zero,
        Complex.im_ofNat, zero_add]
      rw [Set.uIcc_of_le h12]
      exact ⟨le_rfl, h12⟩
  have h := split_logDeriv (f := V Q L) (by norm_num : (1/2 : ℝ) ≤ 3) h12 hfa hq hne
    (intervalIntegrable_log_V Q L h1 _ _)
    (intervalIntegrable_log_V Q L (by linarith) _ _)
  exact ⟨h.1, h.2⟩

/-- info: 'BasinChain.split_logDeriv' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms split_logDeriv

/-- info: 'BasinChain.intervalIntegrable_log_V' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms intervalIntegrable_log_V

/-- info: 'BasinChain.split_V' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms split_V

end BasinChain

end
