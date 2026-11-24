/-
LevinsonTurn — block S11 of `lean_stage3/design/stencil.md`, step 1c. 2026-11-24.

The turning of a continuous argument along the line is an integral of the
logarithmic derivative, and its `G` part is the argument principle on the
rectangle right of the line. With `P x = ∫_a^x F'/F`, the function
`exp(−P) · F` has derivative `0` inside `[a, b]` (FTC with interior derivatives),
so `F t = F a · exp(P t)`; comparing with `F = ‖F‖ · exp(iφ)` gives
`φ t − φ a − Im P t ∈ 2πℤ` at every `t`, and a continuous function on `[a, b]`
with values in `2πℤ`, zero at `a`, is zero at `b` (intermediate value theorem:
it would pass `π`). No branch of log is chosen. On the line `F t = f(1/2 + t i)`,
`F' t = f'(1/2 + t i) · i` and `Im(i x) = Re x`. The rectangle step is
`Littlewood.two_pi_count_eq` at `σ = z.re = 1/2`, solved for the left edge;
its `hgood` holds because every zero is in the open interior
(`Littlewood.support_interior`), so `p.re > 1/2`, and the count at `σ = 1/2` is
then the count of all zeros of the rectangle, with order.

Rectangle `R = Rectangle z w`, `z = 1/2 + a i`, `w = X + b i`, `1/2 < X`, `a < b`.

  int_valued_const        a ≤ b, d continuous on [a, b], d t ∈ ℤ there, d a = 0
                            ⊢ d b = 0
  lift_turn_eq_integral   a ≤ b, F continuous on [a, b], HasDerivAt F (F' t) t on (a, b),
                            F' continuous on [a, b], F ≠ 0 on [a, b],
                            φ continuous on [a, b], F t = ‖F t‖ · exp(iφ t) there
                            ⊢ φ b − φ a = Im ∫_a^b F' t / F t dt
  line_turn_eq_integral   a ≤ b, f analytic at 1/2 + t i and nonzero there for t ∈ [a, b],
                            φ continuous, f(1/2 + t i) = ‖·‖ · exp(iφ t)
                            ⊢ φ b − φ a = Re ∫_a^b logDeriv f (1/2 + t i) dt
  turn_split              a ≤ b, G analytic at 1/2 + t i and nonzero there for t ∈ [a, b]
                            ⊢ Re ∫ logDeriv (Gammaℝ · G) = Re ∫ logDeriv Gammaℝ + Re ∫ logDeriv G
  lineF_turn_eq           a ≤ b, ζ + c ζ' ≠ 0 at 1/2 + t i for t ∈ [a, b], φ a continuous
                            argument of `LevinsonArg.lineF c` on [a, b]
                            ⊢ φ b − φ a = Re ∫_a^b logDeriv Gammaℝ (1/2 + t i) dt
                                        + Re ∫_a^b logDeriv (ζ + c ζ') (1/2 + t i) dt
  countRight_left_eq      countRight f z w z.re = Σ_{ρ ∈ S} D ρ   (all zeros, with order)
  G_turn_eq               G analytic on R, nonzero on its border
                            ⊢ Re ∫_a^b logDeriv G (1/2 + t i) dt
                              = −2π · countRight G z w (1/2)
                                + Im ∫_{1/2}^X logDeriv G (x + a i) dx
                                − Im ∫_{1/2}^X logDeriv G (x + b i) dx
                                + Re ∫_a^b logDeriv G (X + t i) dt

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LevinsonArg
import Stage3.Littlewood

namespace LevinsonTurn

open Complex

/-- A continuous function on `[a, b]` with integer values, zero at `a`, is zero at `b`. -/
theorem int_valued_const {d : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b)
    (hc : ContinuousOn d (Set.Icc a b)) (hint : ∀ t ∈ Set.Icc a b, ∃ n : ℤ, d t = n)
    (ha : d a = 0) : d b = 0 := by
  obtain ⟨n, hn⟩ := hint b ⟨hab, le_rfl⟩
  by_contra hb
  have hn0 : n ≠ 0 := by
    intro h
    apply hb
    rw [hn, h, Int.cast_zero]
  have hn1 : (1 : ℝ) ≤ |(n : ℝ)| := by
    rw [← Int.cast_abs]
    exact_mod_cast Int.one_le_abs hn0
  have hg : ContinuousOn (fun t => |d t|) (Set.Icc a b) := hc.abs
  have hmem : (1 / 2 : ℝ) ∈ Set.Icc (|d a|) (|d b|) := by
    rw [ha, hn, abs_zero]
    constructor <;> linarith
  obtain ⟨s, hs, hds⟩ := intermediate_value_Icc hab hg hmem
  obtain ⟨m, hm⟩ := hint s hs
  simp only at hds
  rw [hm] at hds
  have h2 : ((2 * |m| : ℤ) : ℝ) = 1 := by
    push_cast
    linarith
  have h3 : (2 * |m| : ℤ) = 1 := by exact_mod_cast h2
  omega

/-- **Target 1.** The turning of a continuous argument of a differentiable nonvanishing
`F` on `[a, b]` is the imaginary part of `∫_a^b F'/F`. -/
theorem lift_turn_eq_integral {F F' : ℝ → ℂ} {φ : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b)
    (hFc : ContinuousOn F (Set.Icc a b))
    (hF : ∀ t ∈ Set.Ioo a b, HasDerivAt F (F' t) t)
    (hF'c : ContinuousOn F' (Set.Icc a b))
    (hne : ∀ t ∈ Set.Icc a b, F t ≠ 0)
    (hφc : ContinuousOn φ (Set.Icc a b))
    (hφ : ∀ t ∈ Set.Icc a b, F t = ‖F t‖ * Complex.exp (φ t * Complex.I)) :
    φ b - φ a = (∫ t in a..b, F' t / F t).im := by
  have hhc : ContinuousOn (fun t => F' t / F t) (Set.Icc a b) := hF'c.div hFc hne
  -- the primitive `P x = ∫_a^x F'/F`
  have hPc : ContinuousOn (fun x => ∫ t in a..x, F' t / F t) (Set.Icc a b) := by
    have h := intervalIntegral.continuousOn_primitive_interval
      (μ := MeasureTheory.volume) (f := fun t => F' t / F t) (a := a) (b := b)
      (by rw [Set.uIcc_of_le hab]; exact hhc.integrableOn_Icc)
    rwa [Set.uIcc_of_le hab] at h
  have hPd : ∀ x ∈ Set.Ioo a b,
      HasDerivAt (fun x => ∫ t in a..x, F' t / F t) (F' x / F x) x := by
    intro x hx
    have hsub : Set.uIcc a x ⊆ Set.Icc a b := by
      rw [Set.uIcc_of_le hx.1.le]
      exact Set.Icc_subset_Icc le_rfl hx.2.le
    exact intervalIntegral.integral_hasDerivAt_right ((hhc.mono hsub).intervalIntegrable)
      (ContinuousOn.stronglyMeasurableAtFilter isOpen_Ioo
        (hhc.mono Set.Ioo_subset_Icc_self) x hx)
      (hhc.continuousAt (Icc_mem_nhds hx.1 hx.2))
  -- `E = exp(−P) · F` is constant on `[a, b]`
  set E : ℝ → ℂ := fun y => Complex.exp (-(∫ t in a..y, F' t / F t)) * F y with hE_def
  have hEc : ContinuousOn E (Set.Icc a b) := (hPc.neg.cexp).mul hFc
  have hEd : ∀ x ∈ Set.Ioo a b, HasDerivAt E 0 x := by
    intro x hx
    have h1 := ((hPd x hx).neg.cexp).mul (hF x hx)
    have h2 : HasDerivAt E
        (Complex.exp (-(∫ t in a..x, F' t / F t)) * -(F' x / F x) * F x
          + Complex.exp (-(∫ t in a..x, F' t / F t)) * F' x) x := h1
    refine h2.congr_deriv ?_
    have hFx : F x ≠ 0 := hne x (Set.Ioo_subset_Icc_self hx)
    have hc : F' x / F x * F x = F' x := div_mul_cancel₀ _ hFx
    linear_combination (-(Complex.exp (-(∫ t in a..x, F' t / F t)))) * hc
  have hE : ∀ t ∈ Set.Icc a b, E t = F a := by
    intro t ht
    have hsub : Set.Icc a t ⊆ Set.Icc a b := Set.Icc_subset_Icc le_rfl ht.2
    have h := intervalIntegral.integral_eq_sub_of_hasDerivAt_of_le (f' := fun _ => (0 : ℂ))
      ht.1 (hEc.mono hsub) (fun x hx => hEd x ⟨hx.1, lt_of_lt_of_le hx.2 ht.2⟩)
      intervalIntegrable_const
    simp only [intervalIntegral.integral_zero] at h
    have hEa : E a = F a := by
      simp only [hE_def, intervalIntegral.integral_same, neg_zero, Complex.exp_zero, one_mul]
    rw [← hEa]
    exact (sub_eq_zero.mp h.symm)
  -- the representation `F s = exp(log ‖F s‖ + i φ s)`
  have hrep : ∀ s ∈ Set.Icc a b,
      F s = Complex.exp (↑(Real.log ‖F s‖) + ↑(φ s) * Complex.I) := by
    intro s hs
    rw [Complex.exp_add, ← Complex.ofReal_exp, Real.exp_log (norm_pos_iff.mpr (hne s hs))]
    exact hφ s hs
  have ha : a ∈ Set.Icc a b := ⟨le_rfl, hab⟩
  -- `φ t − φ a − Im P t ∈ 2πℤ`
  have hint : ∀ t ∈ Set.Icc a b, ∃ n : ℤ,
      (φ t - φ a - (∫ u in a..t, F' u / F u).im) / (2 * Real.pi) = n := by
    intro t ht
    have hFt : F t = Complex.exp (∫ u in a..t, F' u / F u) * F a := by
      rw [← hE t ht]
      simp only [hE_def, ← mul_assoc, ← Complex.exp_add, add_neg_cancel, Complex.exp_zero,
        one_mul]
    rw [hrep t ht, hrep a ha, ← Complex.exp_add] at hFt
    obtain ⟨n, hn⟩ := Complex.exp_eq_exp_iff_exists_int.mp hFt
    refine ⟨n, ?_⟩
    have him := congrArg Complex.im hn
    simp only [Complex.add_im, Complex.ofReal_im, Complex.mul_im, Complex.ofReal_re,
      Complex.I_re, Complex.I_im, mul_zero, mul_one, zero_add, Complex.intCast_re,
      Complex.intCast_im, Complex.re_ofNat, Complex.im_ofNat, zero_mul, add_zero,
      Complex.mul_re, sub_zero] at him
    have hπ : (2 * Real.pi) ≠ 0 := by positivity
    rw [div_eq_iff hπ]
    linarith
  have hdc : ContinuousOn
      (fun t => (φ t - φ a - (∫ u in a..t, F' u / F u).im) / (2 * Real.pi))
      (Set.Icc a b) :=
    ((hφc.sub continuousOn_const).sub (Complex.continuous_im.comp_continuousOn hPc)).div_const _
  have hd0 := int_valued_const hab hdc hint
    (by simp only [sub_self, intervalIntegral.integral_same, Complex.zero_im, zero_div])
  have hπ : (2 * Real.pi) ≠ 0 := by positivity
  rw [div_eq_zero_iff, or_iff_left hπ] at hd0
  linarith

/-- The critical line as a path, and its derivative `i`. -/
theorem hasDerivAt_line_comp {f : ℂ → ℂ} {t : ℝ}
    (hf : DifferentiableAt ℂ f (1/2 + t * I)) :
    HasDerivAt (fun y : ℝ => f (1/2 + y * I)) (deriv f (1/2 + t * I) * I) t := by
  have hlin : HasDerivAt (fun w : ℂ => (1/2 : ℂ) + w * I) I (t : ℂ) := by
    have := ((hasDerivAt_id (t : ℂ)).mul_const I).const_add (1/2 : ℂ)
    simpa using this
  have hcomp : HasDerivAt (fun w : ℂ => f ((1/2 : ℂ) + w * I))
      (deriv f (1/2 + t * I) * I) (t : ℂ) :=
    HasDerivAt.comp (t : ℂ) (h₂ := f) (h := fun w : ℂ => (1/2 : ℂ) + w * I)
      hf.hasDerivAt hlin
  exact hcomp.comp_ofReal

theorem continuous_line : Continuous (fun t : ℝ => (1/2 + t * I : ℂ)) := by fun_prop

/-- **Target 1, on the line.** For `f` analytic and nonvanishing along
`[1/2 + a i, 1/2 + b i]`, a continuous argument turns by `Re ∫_a^b logDeriv f (1/2 + t i) dt`. -/
theorem line_turn_eq_integral {f : ℂ → ℂ} {φ : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b)
    (hf : ∀ t ∈ Set.Icc a b, AnalyticAt ℂ f (1/2 + t * I))
    (hne : ∀ t ∈ Set.Icc a b, f (1/2 + t * I) ≠ 0)
    (hφc : ContinuousOn φ (Set.Icc a b))
    (hφ : ∀ t ∈ Set.Icc a b,
      f (1/2 + t * I) = ‖f (1/2 + t * I)‖ * Complex.exp (φ t * Complex.I)) :
    φ b - φ a = (∫ t in a..b, logDeriv f (1/2 + t * I)).re := by
  have hFc : ContinuousOn (fun t : ℝ => f (1/2 + t * I)) (Set.Icc a b) := fun t ht =>
    (ContinuousAt.comp (g := f) (f := fun t : ℝ => (1/2 + t * I : ℂ))
      (hf t ht).continuousAt continuous_line.continuousAt).continuousWithinAt
  have hF'c : ContinuousOn (fun t : ℝ => deriv f (1/2 + t * I) * I) (Set.Icc a b) := by
    intro t ht
    exact ((ContinuousAt.comp (g := deriv f) (f := fun t : ℝ => (1/2 + t * I : ℂ))
      (hf t ht).deriv.continuousAt continuous_line.continuousAt).mul
        continuousAt_const).continuousWithinAt
  have h := lift_turn_eq_integral (F := fun t : ℝ => f (1/2 + t * I))
    (F' := fun t : ℝ => deriv f (1/2 + t * I) * I) hab hFc
    (fun t ht => hasDerivAt_line_comp (hf t (Set.Ioo_subset_Icc_self ht)).differentiableAt)
    hF'c hne hφc hφ
  rw [h]
  have heq : (∫ t in a..b, deriv f (1/2 + t * I) * I / f (1/2 + t * I)) =
      ∫ t in a..b, logDeriv f (1/2 + t * I) * I := by
    refine intervalIntegral.integral_congr (fun t _ => ?_)
    simp only [logDeriv_apply]
    ring
  rw [heq, intervalIntegral.integral_mul_const, Complex.mul_I_im]

/-- Along the line, `logDeriv f` is continuous where `f` is analytic and nonzero. -/
theorem continuousOn_logDeriv_line {f : ℂ → ℂ} {S : Set ℝ}
    (hf : ∀ t ∈ S, AnalyticAt ℂ f (1/2 + t * I)) (hne : ∀ t ∈ S, f (1/2 + t * I) ≠ 0) :
    ContinuousOn (fun t : ℝ => logDeriv f (1/2 + t * I)) S := by
  intro t ht
  exact (ContinuousAt.comp (g := logDeriv f) (f := fun t : ℝ => (1/2 + t * I : ℂ))
    (Littlewood.continuousAt_logDeriv (hf t ht) (hf t ht).deriv (hne t ht))
    continuous_line.continuousAt).continuousWithinAt

/-- `Gammaℝ` is analytic right of zero. -/
theorem analyticAt_Gammaℝ {s : ℂ} (hs : 0 < s.re) : AnalyticAt ℂ Gammaℝ s := by
  have hopen : IsOpen {z : ℂ | 0 < z.re} := isOpen_lt continuous_const Complex.continuous_re
  have hd : DifferentiableOn ℂ Gammaℝ {z : ℂ | 0 < z.re} := fun z hz =>
    (LevinsonLine.differentiableAt_Gammaℝ hz).differentiableWithinAt
  exact hd.analyticAt (hopen.mem_nhds hs)

/-- **Target 2.** The split: `Re ∫ logDeriv (Gammaℝ · G) = Re ∫ logDeriv Gammaℝ + Re ∫ logDeriv G`
along the line, for `G` analytic and nonvanishing there. -/
theorem turn_split {G : ℂ → ℂ} {a b : ℝ} (hab : a ≤ b)
    (hG : ∀ t ∈ Set.Icc a b, AnalyticAt ℂ G (1/2 + t * I))
    (hne : ∀ t ∈ Set.Icc a b, G (1/2 + t * I) ≠ 0) :
    (∫ t in a..b, logDeriv (fun s => Gammaℝ s * G s) (1/2 + t * I)).re =
      (∫ t in a..b, logDeriv Gammaℝ (1/2 + t * I)).re +
        (∫ t in a..b, logDeriv G (1/2 + t * I)).re := by
  have hre : ∀ t : ℝ, 0 < ((1/2 : ℂ) + t * I).re := fun t => (LevinsonLine.line_facts t).2.2
  have hΓ : ∀ t ∈ Set.Icc a b, AnalyticAt ℂ Gammaℝ (1/2 + t * I) := fun t _ =>
    analyticAt_Gammaℝ (hre t)
  have hΓne : ∀ t ∈ Set.Icc a b, Gammaℝ (1/2 + t * I) ≠ 0 := fun t _ =>
    Gammaℝ_ne_zero_of_re_pos (hre t)
  have hiΓ : IntervalIntegrable (fun t : ℝ => logDeriv Gammaℝ (1/2 + t * I))
      MeasureTheory.volume a b := by
    apply ContinuousOn.intervalIntegrable
    rw [Set.uIcc_of_le hab]
    exact continuousOn_logDeriv_line hΓ hΓne
  have hiG : IntervalIntegrable (fun t : ℝ => logDeriv G (1/2 + t * I))
      MeasureTheory.volume a b := by
    apply ContinuousOn.intervalIntegrable
    rw [Set.uIcc_of_le hab]
    exact continuousOn_logDeriv_line hG hne
  have heq : (∫ t in a..b, logDeriv (fun s => Gammaℝ s * G s) (1/2 + t * I)) =
      ∫ t in a..b, (logDeriv Gammaℝ (1/2 + t * I) + logDeriv G (1/2 + t * I)) := by
    refine intervalIntegral.integral_congr (fun t ht => ?_)
    rw [Set.uIcc_of_le hab] at ht
    exact logDeriv_mul (1/2 + t * I) (hΓne t ht) (hne t ht) (hΓ t ht).differentiableAt
      (hG t ht).differentiableAt
  rw [heq, intervalIntegral.integral_add hiΓ hiG, Complex.add_re]

/-- **Target 2, for Levinson's function.** A continuous argument of
`LevinsonArg.lineF c = Gammaℝ · (ζ + c ζ')` along `[1/2 + a i, 1/2 + b i]`, where
`ζ + c ζ'` does not vanish, turns by the `Gammaℝ` part plus the `G` part. -/
theorem lineF_turn_eq {c a b : ℝ} {φ : ℝ → ℝ} (hab : a ≤ b)
    (hne : ∀ t ∈ Set.Icc a b,
      riemannZeta (1/2 + t * I) + c * deriv riemannZeta (1/2 + t * I) ≠ 0)
    (hφc : ContinuousOn φ (Set.Icc a b))
    (hφ : ∀ t ∈ Set.Icc a b,
      LevinsonArg.lineF c t = ‖LevinsonArg.lineF c t‖ * Complex.exp (φ t * Complex.I)) :
    φ b - φ a = (∫ t in a..b, logDeriv Gammaℝ (1/2 + t * I)).re +
      (∫ t in a..b, logDeriv (fun s => riemannZeta s + c * deriv riemannZeta s)
        (1/2 + t * I)).re := by
  have hdz : DifferentiableOn ℂ riemannZeta {1}ᶜ := fun z hz =>
    (differentiableAt_riemannZeta hz).differentiableWithinAt
  have hG : ∀ t ∈ Set.Icc a b,
      AnalyticAt ℂ (fun s => riemannZeta s + c * deriv riemannZeta s) (1/2 + t * I) := by
    intro t _
    have h1 := (LevinsonLine.line_facts t).2.1
    have hζ : AnalyticAt ℂ riemannZeta (1/2 + t * I) :=
      hdz.analyticAt (isOpen_compl_singleton.mem_nhds h1)
    exact hζ.add (analyticAt_const.mul hζ.deriv)
  have hf : ∀ t ∈ Set.Icc a b,
      AnalyticAt ℂ (fun s => Gammaℝ s * (riemannZeta s + c * deriv riemannZeta s))
        (1/2 + t * I) := fun t ht =>
    (analyticAt_Gammaℝ (LevinsonLine.line_facts t).2.2).mul (hG t ht)
  have hfne : ∀ t ∈ Set.Icc a b,
      Gammaℝ (1/2 + t * I) * (riemannZeta (1/2 + t * I) + c * deriv riemannZeta (1/2 + t * I))
        ≠ 0 := fun t ht =>
    mul_ne_zero (Gammaℝ_ne_zero_of_re_pos (LevinsonLine.line_facts t).2.2) (hne t ht)
  have h := line_turn_eq_integral
    (f := fun s => Gammaℝ s * (riemannZeta s + c * deriv riemannZeta s)) hab hf hfne hφc hφ
  rw [h]
  exact turn_split (G := fun s => riemannZeta s + c * deriv riemannZeta s) hab hG hne

/-- At `σ = z.re` the count right of `σ` is the count of every zero of the rectangle,
with order. -/
theorem countRight_left_eq {f : ℂ → ℂ} {z w : ℂ} (hre : z.re < w.re) (him : z.im < w.im)
    (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hB : ∀ p ∈ RectangleBorder z w, f p ≠ 0) :
    Littlewood.countRight f z w z.re =
      ∑ p ∈ (divisor_support_rectangle_finite f z w).toFinset,
        ((MeromorphicOn.divisor f (Rectangle z w) p : ℤ) : ℝ) := by
  unfold Littlewood.countRight
  refine Finset.sum_congr rfl (fun p hp => ?_)
  have hpS := (divisor_support_rectangle_finite f z w).mem_toFinset.mp hp
  rw [if_pos (Littlewood.support_interior hre him hf hB hpS).1]

/-- **Target 3.** The `G` part of the turning along `[1/2 + a i, 1/2 + b i]`: for `G`
analytic on the rectangle with corners `1/2 + a i` and `X + b i` and nonzero on its
border, `Re ∫_a^b logDeriv G (1/2 + t i) dt` is `−2π` times the zeros of `G` in the
rectangle, with order, plus the right edge and the two horizontal terms. -/
theorem G_turn_eq {G : ℂ → ℂ} {a b X : ℝ} (hX : 1/2 < X) (hab : a < b)
    (hG : AnalyticOnNhd ℂ G (Rectangle ((1/2 : ℂ) + a * I) ((X : ℂ) + b * I)))
    (hB : ∀ p ∈ RectangleBorder ((1/2 : ℂ) + a * I) ((X : ℂ) + b * I), G p ≠ 0) :
    (∫ t in a..b, logDeriv G (1/2 + t * I)).re =
      -(2 * Real.pi * Littlewood.countRight G ((1/2 : ℂ) + a * I) ((X : ℂ) + b * I) (1/2))
      + (∫ x in (1/2 : ℝ)..X, logDeriv G (↑x + ↑a * I)).im
      - (∫ x in (1/2 : ℝ)..X, logDeriv G (↑x + ↑b * I)).im
      + (∫ t in a..b, logDeriv G (↑X + ↑t * I)).re := by
  have hzre : ((1/2 : ℂ) + a * I).re = 1/2 := by simp
  have hzim : ((1/2 : ℂ) + a * I).im = a := by simp
  have hwre : ((X : ℂ) + b * I).re = X := by simp
  have hwim : ((X : ℂ) + b * I).im = b := by simp
  have hre : ((1/2 : ℂ) + a * I).re < ((X : ℂ) + b * I).re := by rw [hzre, hwre]; exact hX
  have him : ((1/2 : ℂ) + a * I).im < ((X : ℂ) + b * I).im := by rw [hzim, hwim]; exact hab
  have hσ : (1/2 : ℝ) ∈ Set.Icc ((1/2 : ℂ) + a * I).re ((X : ℂ) + b * I).re := by
    rw [hzre, hwre]; exact ⟨le_rfl, hX.le⟩
  have hgood : ∀ p ∈ (divisor_support_rectangle_finite G ((1/2 : ℂ) + a * I)
      ((X : ℂ) + b * I)).toFinset, p.re ≠ 1/2 := by
    intro p hp
    have hpS := (divisor_support_rectangle_finite G _ _).mem_toFinset.mp hp
    have h1 := (Littlewood.support_interior hre him hG hB hpS).1
    rw [hzre] at h1
    exact ne_of_gt h1
  have h := Littlewood.two_pi_count_eq hre him hG hB hσ hgood
  rw [hzim, hwre, hwim] at h
  have hc : (((1/2 : ℝ)) : ℂ) = 1/2 := by push_cast; ring
  simp only [hc] at h
  linarith

/-- info: 'LevinsonTurn.lift_turn_eq_integral' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lift_turn_eq_integral

/-- info: 'LevinsonTurn.line_turn_eq_integral' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms line_turn_eq_integral

/-- info: 'LevinsonTurn.turn_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms turn_split

/-- info: 'LevinsonTurn.lineF_turn_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lineF_turn_eq

/-- info: 'LevinsonTurn.countRight_left_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms countRight_left_eq

/-- info: 'LevinsonTurn.G_turn_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms G_turn_eq

end LevinsonTurn
