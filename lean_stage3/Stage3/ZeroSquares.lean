/-
ZeroSquares — block C5 of `lean_stage3/design/carlson.md`. 2026-11-23.

The number of zeros of ζ to the right of a line is bounded by the mean square of the mollified
function `f X s = ζ(s)·M X s − 1` over a strip. At a zero `ρ` the function `f X` takes the value
`−1`, so the mean-square lower bound of `SquareMean.sq_mean_lower` on the square of half-side `δ`
about `ρ` gives `π δ² ≤` the integral of `‖f X‖²` over that square. The square sits in the strip
`[σ − δ, 1 + δ] × [j − 1/4, j + 5/4]` with `j = ⌊Im ρ⌋₊`. The zeros sharing one `j` lie in one
Jensen window of `Stage3.zeta_local_zero_count`, so there are at most `15 log T + 73` of them;
and the strips `[j − 1/4, j + 5/4]` cover each height at most three times inside `[1, T]`.

  one_le_zeta_order  a zero of ζ off the pole has analytic order at least one
  differentiable_M   the Möbius sum `M X` is entire
  differentiableOn_f `f X` is complex differentiable away from `1`
  f_at_zero          at a zero of ζ, `f X ρ = −1`
  sqG                `‖f X (u + i·max t 1)‖²`, the integrand made continuous on the whole plane
  continuous_sqG     `sqG X` is jointly continuous
  innerI             the inner integral `∫_a^b sqG X u t dt`, as a function of `u`
  continuous_innerI  the inner integral is continuous in `u`
  innerI_nonneg      the inner integral over `a ≤ b` is nonnegative
  innerI_mono        the inner integral grows with its interval
  innerI_eq          for `1 ≤ a`, the inner integral is the integral of `‖f X (u + i t)‖²`
  square_lower       one zero gives `π δ² ≤ ∫_{σ−δ}^{1+δ} ∫_{n+7/4}^{n+13/4} sqG`
  window_mem         a zero with `n + 2 ≤ Im ρ < n + 3` lies in the window at height `n + 5/2`
  card_fiber_le      at most `15 log T + 73` zeros share one value of `⌊Im ρ⌋₊`
  sum_unit_strips    the unit strips `[n + c, n + 1 + c]` tile `[c, L + c]`
  strips_le          `Σ_{n < L} ∫_{n+7/4}^{n+13/4} sqG ≤ 3·∫_1^T sqG` when `L + 3 ≤ T`
  card_zeros_le      `π δ²·#Z ≤ 3 (15 log T + 73)·∫_{σ−δ}^{1+δ} ∫_1^T ‖f X (u + i t)‖²`

What the next slice needs: `MollifiedMean.mean_sq_f_le` on each vertical line `u` of
`[σ − δ, 1 + δ]`, integrated over `u`, to bound the right side of `card_zeros_le`; then the
choice `X = T^a`, `N = T^(1+ε)`, `δ = (σ − 1/2)/2` of block C6. It is not here.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Mathlib
import Stage3.MollifiedMean
import Stage3.SquareMean
import Stage3.JensenCount

namespace ZeroSquares

open MeasureTheory Set Complex

noncomputable section

/-- At a zero `ρ ≠ 1` of ζ, the analytic order of ζ at `ρ` is at least one. -/
theorem one_le_zeta_order {ρ : ℂ} (hρ1 : ρ ≠ 1) (hz : riemannZeta ρ = 0) :
    1 ≤ analyticOrderNatAt riemannZeta ρ := by
  have hd : DifferentiableOn ℂ riemannZeta ({(1:ℂ)}ᶜ : Set ℂ) := fun s hs ↦
    (differentiableAt_riemannZeta (Set.mem_compl_singleton_iff.mp hs)).differentiableWithinAt
  have hAOn : AnalyticOnNhd ℂ riemannZeta ({(1:ℂ)}ᶜ : Set ℂ) := fun z hz' ↦
    hd.analyticAt (isOpen_compl_singleton.mem_nhds hz')
  have han := hAOn ρ (Set.mem_compl_singleton_iff.mpr hρ1)
  have htop : analyticOrderAt riemannZeta ρ ≠ ⊤ := by
    intro htop
    have hev : riemannZeta =ᶠ[nhds ρ] 0 := by
      filter_upwards [analyticOrderAt_eq_top.mp htop] with z hz'
      simpa using hz'
    have hcon : IsPreconnected ({(1:ℂ)}ᶜ : Set ℂ) := by
      have h2 := isPathConnected_compl_singleton_of_one_lt_rank
        (by rw [rank_real_complex]; norm_num) (1:ℂ)
      exact h2.isConnected.isPreconnected
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
  have hcast : analyticOrderAt riemannZeta ρ = (analyticOrderNatAt riemannZeta ρ : ℕ∞) :=
    (Nat.cast_analyticOrderNatAt htop).symm
  rw [hcast] at h0
  have : analyticOrderNatAt riemannZeta ρ ≠ 0 := by exact_mod_cast h0
  omega

/-- The Möbius sum `M X` is complex differentiable on the whole plane. -/
theorem differentiable_M (X : ℕ) : Differentiable ℂ (MollifiedMean.M X) := by
  intro s
  unfold MollifiedMean.M
  apply DifferentiableAt.fun_sum
  intro d hd
  have hd0 : (d : ℂ) ≠ 0 := by
    have : 1 ≤ d := (Finset.mem_Ico.mp hd).1
    exact_mod_cast (show d ≠ 0 by omega)
  exact (differentiableAt_id.neg.const_cpow (Or.inl hd0)).const_mul _

/-- The mollified function `f X` is complex differentiable on the plane with the point `1`
removed. -/
theorem differentiableOn_f (X : ℕ) :
    DifferentiableOn ℂ (MollifiedMean.f X) ({(1:ℂ)}ᶜ : Set ℂ) := by
  intro s hs
  have h1 := differentiableAt_riemannZeta (Set.mem_compl_singleton_iff.mp hs)
  unfold MollifiedMean.f
  exact ((h1.mul (differentiable_M X s)).sub_const 1).differentiableWithinAt

/-- At a zero of ζ the mollified function takes the value `−1`. -/
theorem f_at_zero (X : ℕ) {ρ : ℂ} (hz : riemannZeta ρ = 0) : MollifiedMean.f X ρ = -1 := by
  simp [MollifiedMean.f, hz]

/-- The integrand `‖f X (u + i·max t 1)‖²`; it agrees with `‖f X (u + i t)‖²` for `t ≥ 1` and
is continuous on the whole plane. -/
def sqG (X : ℕ) (u t : ℝ) : ℝ :=
  ‖MollifiedMean.f X ((u : ℂ) + Complex.I * ((max t 1 : ℝ) : ℂ))‖ ^ 2

/-- The integrand `sqG X` is jointly continuous in `(u, t)`. -/
theorem continuous_sqG (X : ℕ) : Continuous (Function.uncurry (sqG X)) := by
  have hc : Continuous fun p : ℝ × ℝ => (p.1 : ℂ) + Complex.I * ((max p.2 1 : ℝ) : ℂ) := by
    fun_prop
  have hmaps : ∀ p : ℝ × ℝ, (p.1 : ℂ) + Complex.I * ((max p.2 1 : ℝ) : ℂ) ∈
      ({(1:ℂ)}ᶜ : Set ℂ) := by
    intro p h
    have h1 : ((p.1 : ℂ) + Complex.I * ((max p.2 1 : ℝ) : ℂ)).im = (1 : ℂ).im := by
      rw [Set.mem_singleton_iff.mp h]
    simp only [Complex.add_im, Complex.ofReal_im, Complex.mul_im, Complex.I_re,
      Complex.I_im, Complex.ofReal_re, zero_mul, one_mul, zero_add, Complex.one_im] at h1
    have : (1 : ℝ) ≤ max p.2 1 := le_max_right _ _
    linarith
  have := ((differentiableOn_f X).continuousOn.comp_continuous hc hmaps).norm.pow 2
  exact this

/-- For fixed `u`, the integrand `sqG X u` is nonnegative. -/
theorem sqG_nonneg (X : ℕ) (u t : ℝ) : 0 ≤ sqG X u t := by
  unfold sqG; positivity

/-- The inner integral `∫_a^b sqG X u t dt`, as a function of `u`. -/
def innerI (X : ℕ) (a b u : ℝ) : ℝ := ∫ t in a..b, sqG X u t

/-- For fixed `u`, the integrand `t ↦ sqG X u t` is continuous. -/
theorem continuous_sqG_slice (X : ℕ) (u : ℝ) : Continuous (sqG X u) :=
  (continuous_sqG X).uncurry_left u

/-- The inner integral `innerI X a b` is continuous in `u`. -/
theorem continuous_innerI (X : ℕ) (a b : ℝ) : Continuous (innerI X a b) :=
  intervalIntegral.continuous_parametric_intervalIntegral_of_continuous' (continuous_sqG X) a b

/-- The inner integral over an interval `a ≤ b` is nonnegative. -/
theorem innerI_nonneg (X : ℕ) {a b : ℝ} (hab : a ≤ b) (u : ℝ) : 0 ≤ innerI X a b u :=
  intervalIntegral.integral_nonneg hab (fun t _ => sqG_nonneg X u t)

/-- The inner integral over `[a, b]` is at most the one over a larger interval `[c, d]`. -/
theorem innerI_mono (X : ℕ) {a b c d : ℝ} (hca : c ≤ a) (hab : a ≤ b) (hbd : b ≤ d) (u : ℝ) :
    innerI X a b u ≤ innerI X c d u :=
  intervalIntegral.integral_mono_interval hca hab hbd
    (Filter.Eventually.of_forall (fun t => sqG_nonneg X u t))
    ((continuous_sqG_slice X u).intervalIntegrable _ _)

/-- For `1 ≤ a ≤ b`, the inner integral is the integral of `‖f X (u + i t)‖²` over `[a, b]`. -/
theorem innerI_eq (X : ℕ) {a b : ℝ} (ha : 1 ≤ a) (hab : a ≤ b) (u : ℝ) :
    innerI X a b u = ∫ t in a..b, ‖MollifiedMean.f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2 := by
  unfold innerI
  refine intervalIntegral.integral_congr (fun t ht => ?_)
  rw [Set.uIcc_of_le hab] at ht
  have : max t 1 = t := max_eq_left (by linarith [ht.1])
  simp only [sqG, this]

/-- One zero `ρ` with `σ ≤ Re ρ < 1` and `n + 2 ≤ Im ρ < n + 3` gives
`π δ² ≤ ∫_{σ−δ}^{1+δ} ∫_{n+7/4}^{n+13/4} sqG X u t dt du`. -/
theorem square_lower (X : ℕ) {σ δ : ℝ} (hδ : 0 < δ) (hδ4 : δ ≤ 1 / 4) {ρ : ℂ}
    (hz : riemannZeta ρ = 0) (hσρ : σ ≤ ρ.re) (hρ1 : ρ.re < 1) (n : ℕ)
    (hn1 : (n : ℝ) + 2 ≤ ρ.im) (hn2 : ρ.im < (n : ℝ) + 3) :
    Real.pi * δ ^ 2 ≤ ∫ u in (σ - δ)..(1 + δ), innerI X ((n : ℝ) + 7 / 4) ((n : ℝ) + 13 / 4) u := by
  have hn0 : (0 : ℝ) ≤ n := Nat.cast_nonneg n
  have hsub : (Icc (ρ.re - δ) (ρ.re + δ)) ×ℂ (Icc (ρ.im - δ) (ρ.im + δ))
      ⊆ ({(1:ℂ)}ᶜ : Set ℂ) := by
    intro z hz' h1
    rw [Complex.mem_reProdIm] at hz'
    rw [Set.mem_singleton_iff.mp h1] at hz'
    have := hz'.2.1
    simp only [Complex.one_im] at this
    linarith
  have h := SquareMean.sq_mean_lower hδ isOpen_compl_singleton hsub (differentiableOn_f X)
  rw [f_at_zero X hz, norm_neg, norm_one, one_pow, mul_one] at h
  have hcongr : (∫ u in (ρ.re - δ)..(ρ.re + δ), ∫ t in (ρ.im - δ)..(ρ.im + δ),
        ‖MollifiedMean.f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2)
      = ∫ u in (ρ.re - δ)..(ρ.re + δ), innerI X (ρ.im - δ) (ρ.im + δ) u := by
    refine intervalIntegral.integral_congr (fun u _ => ?_)
    exact (innerI_eq X (by linarith) (by linarith) u).symm
  rw [hcongr] at h
  have h2 : (∫ u in (ρ.re - δ)..(ρ.re + δ), innerI X (ρ.im - δ) (ρ.im + δ) u)
      ≤ ∫ u in (ρ.re - δ)..(ρ.re + δ), innerI X ((n : ℝ) + 7 / 4) ((n : ℝ) + 13 / 4) u := by
    refine intervalIntegral.integral_mono_on (by linarith)
      ((continuous_innerI X _ _).intervalIntegrable _ _)
      ((continuous_innerI X _ _).intervalIntegrable _ _) (fun u _ => ?_)
    exact innerI_mono X (by linarith) (by linarith) (by linarith) u
  have h3 : (∫ u in (ρ.re - δ)..(ρ.re + δ), innerI X ((n : ℝ) + 7 / 4) ((n : ℝ) + 13 / 4) u)
      ≤ ∫ u in (σ - δ)..(1 + δ), innerI X ((n : ℝ) + 7 / 4) ((n : ℝ) + 13 / 4) u := by
    refine intervalIntegral.integral_mono_interval (by linarith) (by linarith) (by linarith)
      (Filter.Eventually.of_forall (fun u => innerI_nonneg X (by linarith) u))
      ((continuous_innerI X _ _).intervalIntegrable _ _)
  linarith

/-- A zero `ρ` of ζ with `1/2 < Re ρ < 1` and `n + 2 ≤ Im ρ < n + 3` lies in the Jensen window
`Stage3.zetaWindow (n + 5/2)`. -/
theorem window_mem {ρ : ℂ} (hz : riemannZeta ρ = 0) (h1 : 1 / 2 < ρ.re) (h2 : ρ.re < 1)
    (n : ℕ) (hn1 : (n : ℝ) + 2 ≤ ρ.im) (hn2 : ρ.im < (n : ℝ) + 3) :
    ρ ∈ Stage3.zetaWindow ((n : ℝ) + 5 / 2) := by
  refine ⟨hz, ?_⟩
  set w := ρ - (2 + Complex.I * (((n : ℝ) + 5 / 2 : ℝ) : ℂ)) with hw
  have hre : w.re = ρ.re - 2 := by
    simp [hw]
  have him : w.im = ρ.im - ((n : ℝ) + 5 / 2) := by
    simp [hw]
  have hsq : ‖w‖ ^ 2 ≤ (7 / 4) ^ 2 := by
    rw [Complex.sq_norm, Complex.normSq_apply, hre, him]
    nlinarith
  have hn : 0 ≤ ‖w‖ := norm_nonneg _
  nlinarith

/-- If every point of `W` is a zero of ζ with `1/2 < Re ρ < 1` and `n + 2 ≤ Im ρ < n + 3`,
and `n + 5/2 ≤ T`, then `W` has at most `15 log T + 73` elements. -/
theorem card_fiber_le {T : ℝ} (n : ℕ) (hnT : (n : ℝ) + 5 / 2 ≤ T) (W : Finset ℂ)
    (hW : ∀ ρ ∈ W, riemannZeta ρ = 0 ∧ 1 / 2 < ρ.re ∧ ρ.re < 1 ∧
      (n : ℝ) + 2 ≤ ρ.im ∧ ρ.im < (n : ℝ) + 3) :
    (W.card : ℝ) ≤ 15 * Real.log T + 73 := by
  have hn0 : (0 : ℝ) ≤ n := Nat.cast_nonneg n
  have hT2 : (2 : ℝ) ≤ (n : ℝ) + 5 / 2 := by linarith
  have hsub : W ⊆ (Stage3.zetaWindow_finite hT2).toFinset := by
    intro ρ hρ
    obtain ⟨hz, h1, h2, h3, h4⟩ := hW ρ hρ
    rw [Set.Finite.mem_toFinset]
    exact window_mem hz h1 h2 n h3 h4
  have hcount := Stage3.zeta_local_zero_count hT2
  have hcard : (W.card : ℝ) ≤ ∑ ρ ∈ W, (analyticOrderNatAt riemannZeta ρ : ℝ) := by
    rw [Finset.card_eq_sum_ones, Nat.cast_sum, Nat.cast_one]
    refine Finset.sum_le_sum (fun ρ hρ => ?_)
    obtain ⟨hz, _, _, h3, _⟩ := hW ρ hρ
    have hne : ρ ≠ 1 := by
      intro h
      rw [h, Complex.one_im] at h3
      linarith
    exact_mod_cast one_le_zeta_order hne hz
  have hmono : ∑ ρ ∈ W, (analyticOrderNatAt riemannZeta ρ : ℝ)
      ≤ ∑ ρ ∈ (Stage3.zetaWindow_finite hT2).toFinset, (analyticOrderNatAt riemannZeta ρ : ℝ) :=
    Finset.sum_le_sum_of_subset_of_nonneg hsub (fun _ _ _ => Nat.cast_nonneg _)
  have hlog : Real.log ((n : ℝ) + 5 / 2) ≤ Real.log T := Real.log_le_log (by linarith) hnT
  linarith

/-- The unit strips `[n + c, n + 1 + c]`, `n < L`, tile `[c, L + c]`: the sum of the inner
integrals over them is the inner integral over `[c, L + c]`. -/
theorem sum_unit_strips (X : ℕ) (c : ℝ) (L : ℕ) (u : ℝ) :
    ∑ n ∈ Finset.range L, innerI X ((n : ℝ) + c) ((n : ℝ) + 1 + c) u
      = innerI X c ((L : ℝ) + c) u := by
  have h := intervalIntegral.sum_integral_adjacent_intervals (f := sqG X u)
    (μ := volume) (a := fun k : ℕ => (k : ℝ) + c) (n := L)
    (fun k _ => (continuous_sqG_slice X u).intervalIntegrable _ _)
  simp only [Nat.cast_add, Nat.cast_one, Nat.cast_zero, zero_add] at h
  unfold innerI
  exact h

/-- If `L + 3 ≤ T`, the strips `[n + 7/4, n + 13/4]`, `n < L`, cover each height in `[1, T]` at
most three times: the sum of their inner integrals is at most `3·∫_1^T sqG X u t dt`. -/
theorem strips_le (X : ℕ) {T : ℝ} (L : ℕ) (hLT : (L : ℝ) + 3 ≤ T) (u : ℝ) :
    ∑ n ∈ Finset.range L, innerI X ((n : ℝ) + 7 / 4) ((n : ℝ) + 13 / 4) u
      ≤ 3 * innerI X 1 T u := by
  have hL0 : (0 : ℝ) ≤ L := Nat.cast_nonneg L
  have hint : ∀ a b : ℝ, IntervalIntegrable (sqG X u) volume a b :=
    fun a b => (continuous_sqG_slice X u).intervalIntegrable a b
  have hterm : ∀ n : ℕ, innerI X ((n : ℝ) + 7 / 4) ((n : ℝ) + 13 / 4) u
      ≤ innerI X ((n : ℝ) + 1) ((n : ℝ) + 1 + 1) u + innerI X ((n : ℝ) + 2) ((n : ℝ) + 1 + 2) u
        + innerI X ((n : ℝ) + 3) ((n : ℝ) + 1 + 3) u := by
    intro n
    have hn0 : (0 : ℝ) ≤ n := Nat.cast_nonneg n
    have hm := innerI_mono X (a := (n : ℝ) + 7 / 4) (b := (n : ℝ) + 13 / 4)
      (c := (n : ℝ) + 1) (d := (n : ℝ) + 4) (by linarith) (by linarith) (by linarith) u
    have e1 : (n : ℝ) + 1 + 1 = (n : ℝ) + 2 := by ring
    have e2 : (n : ℝ) + 1 + 2 = (n : ℝ) + 3 := by ring
    have e3 : (n : ℝ) + 1 + 3 = (n : ℝ) + 4 := by ring
    rw [e1, e2, e3]
    have hadd : innerI X ((n : ℝ) + 1) ((n : ℝ) + 4) u
        = innerI X ((n : ℝ) + 1) ((n : ℝ) + 2) u + innerI X ((n : ℝ) + 2) ((n : ℝ) + 3) u
          + innerI X ((n : ℝ) + 3) ((n : ℝ) + 4) u := by
      unfold innerI
      rw [intervalIntegral.integral_add_adjacent_intervals (hint _ _) (hint _ _),
        intervalIntegral.integral_add_adjacent_intervals (hint _ _) (hint _ _)]
    linarith
  calc ∑ n ∈ Finset.range L, innerI X ((n : ℝ) + 7 / 4) ((n : ℝ) + 13 / 4) u
      ≤ ∑ n ∈ Finset.range L, (innerI X ((n : ℝ) + 1) ((n : ℝ) + 1 + 1) u
          + innerI X ((n : ℝ) + 2) ((n : ℝ) + 1 + 2) u
          + innerI X ((n : ℝ) + 3) ((n : ℝ) + 1 + 3) u) :=
        Finset.sum_le_sum (fun n _ => hterm n)
    _ = innerI X 1 ((L : ℝ) + 1) u + innerI X 2 ((L : ℝ) + 2) u
          + innerI X 3 ((L : ℝ) + 3) u := by
        rw [Finset.sum_add_distrib, Finset.sum_add_distrib, sum_unit_strips, sum_unit_strips,
          sum_unit_strips]
    _ ≤ 3 * innerI X 1 T u := by
        have a1 := innerI_mono X (a := 1) (b := (L : ℝ) + 1) (c := 1) (d := T)
          (le_refl 1) (by linarith) (by linarith) u
        have a2 := innerI_mono X (a := 2) (b := (L : ℝ) + 2) (c := 1) (d := T)
          (by norm_num) (by linarith) (by linarith) u
        have a3 := innerI_mono X (a := 3) (b := (L : ℝ) + 3) (c := 1) (d := T)
          (by norm_num) (by linarith) (by linarith) u
        linarith

/-- For a finite set `Z` of zeros of ζ with `σ ≤ Re ρ < 1` and `2 ≤ Im ρ ≤ T − 2`, where
`1/2 < σ − δ`, `0 < δ ≤ 1/4`, `σ ≤ 1` and `T ≥ 5`, the count of `Z` times `π δ²` is at most
`3 (15 log T + 73)` times the integral of `‖f X‖²` over the strip `[σ − δ, 1 + δ] × [1, T]`. -/
theorem card_zeros_le {σ δ T : ℝ} (hσ : 1 / 2 < σ - δ) (hσ1 : σ ≤ 1) (hδ : 0 < δ)
    (hδ4 : δ ≤ 1 / 4) (hT : 5 ≤ T) (X : ℕ) (Z : Finset ℂ)
    (hZ : ∀ ρ ∈ Z, riemannZeta ρ = 0 ∧ σ ≤ ρ.re ∧ ρ.re < 1 ∧ 2 ≤ ρ.im ∧ ρ.im ≤ T - 2) :
    Real.pi * δ ^ 2 * (Z.card : ℝ)
      ≤ 3 * (15 * Real.log T + 73)
          * ∫ u in (σ - δ)..(1 + δ), ∫ t in (1:ℝ)..T,
              ‖MollifiedMean.f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2 := by
  set C : ℝ := 15 * Real.log T + 73 with hC
  have hlogT : 0 ≤ Real.log T := Real.log_nonneg (by linarith)
  have hC0 : 0 ≤ C := by rw [hC]; linarith
  have hab : σ - δ ≤ 1 + δ := by linarith
  set L : ℕ := ⌊T⌋₊ - 3 with hL
  have hT5 : 5 ≤ ⌊T⌋₊ := Nat.le_floor (by exact_mod_cast hT)
  have hLT : (L : ℝ) + 3 ≤ T := by
    have h1 : L + 3 = ⌊T⌋₊ := by omega
    have h2 : ((L + 3 : ℕ) : ℝ) ≤ T := by rw [h1]; exact Nat.floor_le (by linarith)
    exact_mod_cast h2
  set nf : ℂ → ℕ := fun ρ => ⌊ρ.im⌋₊ - 2 with hnf
  have hfacts : ∀ ρ ∈ Z, (nf ρ : ℝ) + 2 ≤ ρ.im ∧ ρ.im < (nf ρ : ℝ) + 3 ∧ nf ρ < L := by
    intro ρ hρ
    obtain ⟨_, _, _, h3, h4⟩ := hZ ρ hρ
    have hf2 : 2 ≤ ⌊ρ.im⌋₊ := Nat.le_floor (by exact_mod_cast h3)
    have heq : nf ρ + 2 = ⌊ρ.im⌋₊ := by simp only [hnf]; omega
    have hfl : (⌊ρ.im⌋₊ : ℝ) ≤ ρ.im := Nat.floor_le (by linarith)
    have hlt : ρ.im < (⌊ρ.im⌋₊ : ℝ) + 1 := Nat.lt_floor_add_one _
    have hcast : ((nf ρ + 2 : ℕ) : ℝ) = (⌊ρ.im⌋₊ : ℝ) := by rw [heq]
    push_cast at hcast
    have hfT : ⌊ρ.im⌋₊ + 2 ≤ ⌊T⌋₊ := Nat.le_floor (by push_cast; linarith)
    refine ⟨by linarith, by linarith, ?_⟩
    omega
  set S : ℕ → ℝ := fun n =>
    ∫ u in (σ - δ)..(1 + δ), innerI X ((n : ℝ) + 7 / 4) ((n : ℝ) + 13 / 4) u with hS
  have hS0 : ∀ n : ℕ, 0 ≤ S n := fun n =>
    intervalIntegral.integral_nonneg hab (fun u _ => innerI_nonneg X (by linarith) u)
  have hmaps : ∀ ρ ∈ Z, nf ρ ∈ Finset.range L :=
    fun ρ hρ => Finset.mem_range.mpr (hfacts ρ hρ).2.2
  have step1 : Real.pi * δ ^ 2 * (Z.card : ℝ) ≤ ∑ ρ ∈ Z, S (nf ρ) := by
    have : Real.pi * δ ^ 2 * (Z.card : ℝ) = ∑ ρ ∈ Z, Real.pi * δ ^ 2 := by
      rw [Finset.sum_const, nsmul_eq_mul]; ring
    rw [this]
    refine Finset.sum_le_sum (fun ρ hρ => ?_)
    obtain ⟨hz, h1, h2, _, _⟩ := hZ ρ hρ
    obtain ⟨g1, g2, _⟩ := hfacts ρ hρ
    exact square_lower X hδ hδ4 hz h1 h2 (nf ρ) g1 g2
  have step2 : ∑ ρ ∈ Z, S (nf ρ) ≤ C * ∑ n ∈ Finset.range L, S n := by
    rw [← Finset.sum_fiberwise_of_maps_to' hmaps S, Finset.mul_sum]
    refine Finset.sum_le_sum (fun n hn => ?_)
    rw [Finset.sum_const, nsmul_eq_mul]
    refine mul_le_mul_of_nonneg_right ?_ (hS0 n)
    have hnL : (n : ℝ) + 1 ≤ L := by
      have := Finset.mem_range.mp hn
      exact_mod_cast this
    refine card_fiber_le n (by linarith) _ (fun ρ hρ => ?_)
    rw [Finset.mem_filter] at hρ
    obtain ⟨hρZ, hρn⟩ := hρ
    obtain ⟨hz, h1, h2, _, _⟩ := hZ ρ hρZ
    obtain ⟨g1, g2, _⟩ := hfacts ρ hρZ
    rw [hρn] at g1 g2
    exact ⟨hz, by linarith, h2, g1, g2⟩
  have step3 : ∑ n ∈ Finset.range L, S n
      ≤ ∫ u in (σ - δ)..(1 + δ), 3 * innerI X 1 T u := by
    simp only [hS]
    rw [← intervalIntegral.integral_finsetSum
      (fun n _ => (continuous_innerI X _ _).intervalIntegrable _ _)]
    refine intervalIntegral.integral_mono_on hab ?_ ?_ (fun u _ => strips_le X L hLT u)
    · exact (continuous_finsetSum _ (fun n _ => continuous_innerI X _ _)).intervalIntegrable _ _
    · exact ((continuous_innerI X 1 T).const_smul (3 : ℝ)).intervalIntegrable _ _
  have step4 : (∫ u in (σ - δ)..(1 + δ), 3 * innerI X 1 T u)
      = 3 * ∫ u in (σ - δ)..(1 + δ), ∫ t in (1:ℝ)..T,
          ‖MollifiedMean.f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2 := by
    rw [intervalIntegral.integral_const_mul]
    congr 1
    exact intervalIntegral.integral_congr (fun u _ => innerI_eq X (le_refl 1) (by linarith) u)
  calc Real.pi * δ ^ 2 * (Z.card : ℝ) ≤ ∑ ρ ∈ Z, S (nf ρ) := step1
    _ ≤ C * ∑ n ∈ Finset.range L, S n := step2
    _ ≤ C * ∫ u in (σ - δ)..(1 + δ), 3 * innerI X 1 T u :=
        mul_le_mul_of_nonneg_left step3 hC0
    _ = 3 * C * ∫ u in (σ - δ)..(1 + δ), ∫ t in (1:ℝ)..T,
          ‖MollifiedMean.f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2 := by
        rw [step4]; ring

/-- info: 'ZeroSquares.card_zeros_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms card_zeros_le

/-- info: 'ZeroSquares.square_lower' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms square_lower

/-- info: 'ZeroSquares.strips_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms strips_le

end

end ZeroSquares
