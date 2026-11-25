/-
LevinsonEdge — block S11 of `lean_stage3/design/stencil.md`, step 1d (ii). 2026-11-24.

The horizontal edges of `LevinsonTurn.G_turn_eq`: for `G = ζ + c ζ'`, `0 ≤ c ≤ 1`, and a
height `T ≥ 4` at which `G` has no zero on the segment `[1/2, 3] + iT`, the term
`Im ∫_{1/2}^{3} logDeriv G (x + iT) dx` is `O(log T)` with explicit constants.

The route is Backlund's, the tree's template for `ζ` (`ArgLegs`, `ReZetaCount`, `ArgCount`):

* The step from a count to the argument is the tree's generic `ArgLegs.segment_im_integral_le`
  (stated for any path `g` with derivative `g'`): with `Z` a `Finset` holding the zeros of
  `x ↦ Re G(x + iT)` in `(1/2, 3)`, `|Im ∫ g'/g| ≤ π (|Z| + 1)`. It is instantiated at
  `g x = G(x + iT)`, `g' x = G'(x + iT)`, so `g'/g` is `logDeriv G (x + iT)`.
* The count. Put `g z = G(3 + iT + 3z)`, so the closed unit ball maps onto
  `|s − (3 + iT)| ≤ 3` and the segment `[1/2, 3] + iT` onto the real interval `[−5/6, 0]`.
  The symmetrisation `h z = (g z + conj (g (conj z)))/2` (`symm`) is holomorphic where `g` is
  (Mathlib's `differentiableAt_conj_conj_iff`), equals `Re g x` at real `x`, and has
  `h 0 = Re G(3 + iT)`. This is the tree's `ReZetaCount.G`, there written through the
  reflection `ζ(conj s) = conj ζ(s)`; here no reflection of `ζ'` is needed. Upstream's
  `ZerosBound` at `r = 5/6`, `R = 7/8` on `model g = h / h 0` gives
  `|Z| ≤ log(M/m) / log(21/20) ≤ 21 log(M/m)`, with `M` a bound for `‖g‖` on the `7/8`
  ball and `m ≤ Re g 0` (`real_zero_count`).
* `Re G(3 + iT) ≥ 2 − π²/6 ≥ 1/3`, from `LevinsonSize.norm_G_sub_one_le`.
* The growth. On `|w − (3 + iT)| ≤ 11/4` we have `Re w ≥ 1/4` and `Im w ≥ T − 11/4 ≥ 1`, and
  upstream's `ZetaAltFormula` gives `‖ζ w‖ ≤ 2 + 4‖w‖ ≤ 4T + 25` (`zeta_norm_le`, the proof of
  `Stage3.zeta_disk_upper` re-run with these margins; upstream `GlobalBound` stops at
  `Re ≥ 1/2`). Cauchy's estimate on circles of radius `1/8` (Mathlib's
  `Complex.norm_deriv_le_of_forall_mem_sphere_norm_le`) gives `‖ζ' w‖ ≤ 32T + 200` on
  `|w − (3 + iT)| ≤ 21/8`, hence `‖G w‖ ≤ 36T + 225` there.
* Arithmetic: `3 (36T + 225) ≤ 300 T` for `T ≥ 4`, `log 300 ≤ 9 log 2 < 6.2384`, and
  `π (21 (log T + 6.2384) + 1) ≤ 21π log T + 133π`.

  zeta_norm_le          1/4 ≤ Re u, 1 ≤ Im u  ⊢ ‖ζ u‖ ≤ 2 + 4‖u‖
  zeta_disc_le          4 ≤ T, ‖u − (3 + iT)‖ ≤ 11/4  ⊢ ‖ζ u‖ ≤ 4T + 25
  deriv_zeta_disc_le    4 ≤ T, ‖w − (3 + iT)‖ ≤ 21/8  ⊢ ‖ζ' w‖ ≤ 32T + 200
  G_disc_le             0 ≤ c ≤ 1, 4 ≤ T, ‖w − (3 + iT)‖ ≤ 21/8
                          ⊢ ‖ζ w + c ζ' w‖ ≤ 36T + 225
  real_zero_count       g differentiable on ‖z‖ < 11/10, 0 < m ≤ Re g 0, ‖g‖ ≤ M on ‖z‖ ≤ 7/8
                          ⊢ ∃ Z : Finset ℝ, (|x| ≤ 5/6 ∧ Re g x = 0 → x ∈ Z) ∧
                              |Z| ≤ 21 log (M/m)
  edge_le_of_bound      4 ≤ T, G analytic off 1, 1/3 ≤ Re G(3 + iT),
                          ‖G‖ ≤ M on ‖w − (3 + iT)‖ ≤ 21/8, G ≠ 0 on [1/2, 3] + iT
                          ⊢ |Im ∫_{1/2}^{3} logDeriv G (x + iT) dx| ≤ π (21 log (3M) + 1)
  horizontal_edge_le    0 ≤ c ≤ 1, 4 ≤ T, ζ + c ζ' ≠ 0 on [1/2, 3] + iT
                          ⊢ |Im ∫_{1/2}^{3} logDeriv (ζ + c ζ') (x + iT) dx|
                              ≤ 21π log T + 133π

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LevinsonSize

namespace LevinsonEdge

open Complex Filter Set MeasureTheory

/-! ## The growth of `ζ`, `ζ'` and `G` on the disc about `3 + iT` -/

/-- **`ζ` right of `Re = 1/4`, above `Im = 1`.** `‖ζ u‖ ≤ 2 + 4‖u‖`, from upstream's
`ZetaAltFormula`; the proof of `Stage3.zeta_disk_upper` with these margins. -/
theorem zeta_norm_le {u : ℂ} (hre : 1 / 4 ≤ u.re) (him : 1 ≤ u.im) :
    ‖riemannZeta u‖ ≤ 2 + 4 * ‖u‖ := by
  have hrepos : 0 < u.re := by linarith
  have hu1 : u ≠ 1 := by
    intro h; rw [h, Complex.one_im] at him; linarith
  have hsub : 1 ≤ ‖u - 1‖ := by
    have h := Complex.abs_im_le_norm (u - 1)
    rw [Complex.sub_im, Complex.one_im, sub_zero, abs_of_nonneg (by linarith)] at h
    linarith
  have leadingTerms : ‖(1 : ℂ) + 1 / (u - 1)‖ ≤ 2 := by
    have h4 : ‖(1 : ℂ) / (u - 1)‖ ≤ 1 := by
      rw [norm_div, norm_one, div_le_iff₀ (by linarith : (0:ℝ) < ‖u - 1‖)]
      linarith
    calc ‖(1 : ℂ) + 1 / (u - 1)‖ ≤ ‖(1 : ℂ)‖ + ‖(1 : ℂ) / (u - 1)‖ := norm_add_le _ _
      _ ≤ 2 := by rw [norm_one]; linarith
  have domBound : ∀ {x : ℝ}, x ∈ Set.Ioi (1 : ℝ) →
      |Int.fract x| * ‖(x : ℂ) ^ (-u - 1)‖ ≤ x ^ (-u.re - 1) := by
    intro x hu
    rw [Set.mem_Ioi] at hu
    rw [Complex.norm_cpow_eq_rpow_re_of_pos (by linarith)]
    simp only [Complex.sub_re, Complex.neg_re, Complex.one_re, Int.abs_fract]
    exact mul_le_of_le_one_left (Real.rpow_nonneg (by linarith) _) (Int.fract_lt_one x).le
  have domIntegral : Integrable (fun x : ℝ => x ^ (-u.re - 1))
      (volume.restrict (Set.Ioi 1)) := integrableOn_Ioi_rpow_of_lt (by linarith) zero_lt_one
  have hint : ‖∫ (v : ℝ) in Set.Ioi 1, ((Int.fract v : ℝ) : ℂ) * (v : ℂ) ^ (-u - 1)‖
      ≤ 1 / u.re := by
    refine (MeasureTheory.norm_integral_le_integral_norm _).trans ?_
    have hI := integral_Ioi_rpow_of_lt (a := -u.re - 1) (by linarith) one_pos
    simp only [sub_add_cancel, Real.one_rpow, neg_div_neg_eq] at hI
    simp only [Complex.norm_mul, Complex.norm_real, Real.norm_eq_abs, ← hI]
    refine integral_mono_ae (domIntegral.mono' (((measurable_fract.abs).mul
      ((Complex.measurable_ofReal.pow_const _).norm)).aestronglyMeasurable) ?_) domIntegral
      (by filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with x hx using domBound hx)
    filter_upwards [ae_restrict_mem measurableSet_Ioi] with x hx
    rw [norm_mul, Real.norm_eq_abs, abs_abs, norm_norm]
    exact domBound hx
  have hmul : ‖u * ∫ (v : ℝ) in Set.Ioi 1, ((Int.fract v : ℝ) : ℂ) * (v : ℂ) ^ (-u - 1)‖
      ≤ 4 * ‖u‖ := by
    rw [norm_mul]
    have hinv : (1 : ℝ) / u.re ≤ 4 := by
      rw [div_le_iff₀ hrepos]; linarith
    calc ‖u‖ * ‖∫ (v : ℝ) in Set.Ioi 1, ((Int.fract v : ℝ) : ℂ) * (v : ℂ) ^ (-u - 1)‖
        ≤ ‖u‖ * 4 := mul_le_mul_of_nonneg_left (hint.trans hinv) (norm_nonneg _)
      _ = 4 * ‖u‖ := by ring
  rw [ZetaAltFormula hrepos hu1]
  exact norm_sub_le_of_le leadingTerms hmul

/-- Coordinates on the disc about `3 + iT`. -/
theorem disc_facts {T d : ℝ} (hT : 0 ≤ T) {u : ℂ} (hu : ‖u - (3 + (T : ℂ) * I)‖ ≤ d) :
    3 - d ≤ u.re ∧ T - d ≤ u.im ∧ ‖u‖ ≤ d + 3 + T := by
  have hre : (u - (3 + (T : ℂ) * I)).re = u.re - 3 := by simp
  have him : (u - (3 + (T : ℂ) * I)).im = u.im - T := by simp
  have h1 : |u.re - 3| ≤ d := by
    rw [← hre]; exact le_trans (Complex.abs_re_le_norm _) hu
  have h2 : |u.im - T| ≤ d := by
    rw [← him]; exact le_trans (Complex.abs_im_le_norm _) hu
  obtain ⟨h1a, -⟩ := abs_le.mp h1
  obtain ⟨h2a, -⟩ := abs_le.mp h2
  have hc : ‖(3 : ℂ) + (T : ℂ) * I‖ ≤ 3 + T := by
    refine le_trans (norm_add_le _ _) ?_
    rw [norm_mul, Complex.norm_I, mul_one, Complex.norm_real, Real.norm_eq_abs,
      abs_of_nonneg hT]
    simp
  have hn : ‖u‖ ≤ ‖u - (3 + (T : ℂ) * I)‖ + ‖(3 : ℂ) + (T : ℂ) * I‖ := by
    calc ‖u‖ = ‖(u - (3 + (T : ℂ) * I)) + (3 + (T : ℂ) * I)‖ := by rw [sub_add_cancel]
      _ ≤ _ := norm_add_le _ _
  refine ⟨by linarith, by linarith, by linarith⟩

/-- **`ζ` on the `11/4` disc about `3 + iT`.** `‖ζ u‖ ≤ 4T + 25` for `T ≥ 4`. -/
theorem zeta_disc_le {T : ℝ} (hT : 4 ≤ T) {u : ℂ}
    (hu : ‖u - (3 + (T : ℂ) * I)‖ ≤ 11 / 4) : ‖riemannZeta u‖ ≤ 4 * T + 25 := by
  obtain ⟨h1, h2, h3⟩ := disc_facts (by linarith) hu
  have h := zeta_norm_le (u := u) (by linarith) (by linarith)
  linarith

/-- **`ζ'` on the `21/8` disc about `3 + iT`.** Cauchy's estimate on the circle of radius
`1/8`: `‖ζ' w‖ ≤ 8 (4T + 25) = 32T + 200`. -/
theorem deriv_zeta_disc_le {T : ℝ} (hT : 4 ≤ T) {w : ℂ}
    (hw : ‖w - (3 + (T : ℂ) * I)‖ ≤ 21 / 8) : ‖deriv riemannZeta w‖ ≤ 32 * T + 200 := by
  have hdz : DifferentiableOn ℂ riemannZeta {1}ᶜ := fun z hz =>
    (differentiableAt_riemannZeta hz).differentiableWithinAt
  have hnear : ∀ u : ℂ, ‖u - w‖ ≤ 1 / 8 → ‖u - (3 + (T : ℂ) * I)‖ ≤ 11 / 4 := by
    intro u hu
    calc ‖u - (3 + (T : ℂ) * I)‖ = ‖(u - w) + (w - (3 + (T : ℂ) * I))‖ := by
          rw [sub_add_sub_cancel]
      _ ≤ ‖u - w‖ + ‖w - (3 + (T : ℂ) * I)‖ := norm_add_le _ _
      _ ≤ 11 / 4 := by linarith
  have hsub : Metric.closedBall w (1 / 8) ⊆ ({1}ᶜ : Set ℂ) := by
    intro u hu h1
    rw [Metric.mem_closedBall, Complex.dist_eq] at hu
    obtain ⟨-, him, -⟩ := disc_facts (by linarith) (hnear u hu)
    rw [Set.mem_singleton_iff] at h1
    rw [h1, Complex.one_im] at him
    linarith
  have hd : DiffContOnCl ℂ riemannZeta (Metric.ball w (1 / 8)) :=
    hdz.diffContOnCl_ball hsub
  have hC : ∀ u ∈ Metric.sphere w (1 / 8), ‖riemannZeta u‖ ≤ 4 * T + 25 := by
    intro u hu
    rw [mem_sphere_iff_norm] at hu
    exact zeta_disc_le hT (hnear u hu.le)
  have h := Complex.norm_deriv_le_of_forall_mem_sphere_norm_le (by norm_num) hd hC
  have heq : (4 * T + 25) / (1 / 8 : ℝ) = 32 * T + 200 := by ring
  rw [heq] at h
  exact h

/-- `G = ζ + c ζ'` is analytic away from the pole. -/
theorem G_analyticAt (c : ℝ) {w : ℂ} (hw : w ≠ 1) :
    AnalyticAt ℂ (fun s => riemannZeta s + c * deriv riemannZeta s) w := by
  have hdz : DifferentiableOn ℂ riemannZeta {1}ᶜ := fun z hz =>
    (differentiableAt_riemannZeta hz).differentiableWithinAt
  have hζ : AnalyticAt ℂ riemannZeta w :=
    hdz.analyticAt (isOpen_compl_singleton.mem_nhds hw)
  exact hζ.add (analyticAt_const.mul hζ.deriv)

/-- **`G` on the `21/8` disc about `3 + iT`.** `‖ζ w + c ζ' w‖ ≤ 36T + 225`. -/
theorem G_disc_le {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) {T : ℝ} (hT : 4 ≤ T) {w : ℂ}
    (hw : ‖w - (3 + (T : ℂ) * I)‖ ≤ 21 / 8) :
    ‖riemannZeta w + c * deriv riemannZeta w‖ ≤ 36 * T + 225 := by
  have h1 := zeta_disc_le hT (le_trans hw (by norm_num))
  have h2 := deriv_zeta_disc_le hT hw
  have h3 : c * ‖deriv riemannZeta w‖ ≤ 1 * (32 * T + 200) :=
    mul_le_mul hc1 h2 (norm_nonneg _) zero_le_one
  calc ‖riemannZeta w + c * deriv riemannZeta w‖
      ≤ ‖riemannZeta w‖ + ‖(c : ℂ) * deriv riemannZeta w‖ := norm_add_le _ _
    _ = ‖riemannZeta w‖ + c * ‖deriv riemannZeta w‖ := by
        rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hc0]
    _ ≤ 36 * T + 225 := by linarith

/-! ## The Jensen count of the real zeros of `Re g` -/

/-- The symmetrisation `h z = (g z + conj (g (conj z)))/2`, which is `Re g` on the real axis. -/
noncomputable
def symm (g : ℂ → ℂ) (z : ℂ) : ℂ :=
  (g z + (starRingEnd ℂ) (g ((starRingEnd ℂ) z))) / 2

/-- The normalised model `h / h 0`, `1` at the centre. -/
noncomputable
def model (g : ℂ → ℂ) (z : ℂ) : ℂ := symm g z / symm g 0

/-- On the real axis the symmetrisation is `Re g`. -/
theorem symm_real (g : ℂ → ℂ) (x : ℝ) : symm g (x : ℂ) = ((g x).re : ℂ) := by
  simp only [symm, Complex.conj_ofReal]
  rw [Complex.add_conj]
  push_cast
  ring

/-- At the centre the symmetrisation is `Re g 0`. -/
theorem symm_zero (g : ℂ → ℂ) : symm g 0 = ((g 0).re : ℂ) := by
  have h := symm_real g 0
  simpa only [Complex.ofReal_zero] using h

/-- The symmetrisation is holomorphic where `g` is, on a ball about `0`. -/
theorem symm_differentiableOn {g : ℂ → ℂ} {ρ : ℝ}
    (hd : DifferentiableOn ℂ g (Metric.ball (0 : ℂ) ρ)) :
    DifferentiableOn ℂ (symm g) (Metric.ball (0 : ℂ) ρ) := by
  intro z hz
  have hz' : (starRingEnd ℂ) z ∈ Metric.ball (0 : ℂ) ρ := by
    rw [Metric.mem_ball, dist_zero_right] at hz ⊢
    rwa [Complex.norm_conj]
  have h1 : DifferentiableAt ℂ g z := hd.differentiableAt (Metric.isOpen_ball.mem_nhds hz)
  have h2 : DifferentiableAt ℂ g ((starRingEnd ℂ) z) :=
    hd.differentiableAt (Metric.isOpen_ball.mem_nhds hz')
  have h3 : DifferentiableAt ℂ ((starRingEnd ℂ) ∘ g ∘ (starRingEnd ℂ)) z :=
    differentiableAt_conj_conj_iff.mpr h2
  have h4 : DifferentiableAt ℂ
      (fun w => (g w + ((starRingEnd ℂ) ∘ g ∘ (starRingEnd ℂ)) w) / 2) z :=
    (h1.add h3).div_const 2
  exact h4.differentiableWithinAt

/-- The symmetrisation is bounded by `g` on a ball about `0`. -/
theorem norm_symm_le {g : ℂ → ℂ} {M ρ : ℝ} (hM : ∀ z : ℂ, ‖z‖ ≤ ρ → ‖g z‖ ≤ M)
    {z : ℂ} (hz : ‖z‖ ≤ ρ) : ‖symm g z‖ ≤ M := by
  have h1 := hM z hz
  have h2 := hM ((starRingEnd ℂ) z) (by rwa [Complex.norm_conj])
  have h3 : ‖g z + (starRingEnd ℂ) (g ((starRingEnd ℂ) z))‖ ≤ M + M := by
    refine le_trans (norm_add_le _ _) ?_
    rw [Complex.norm_conj]
    linarith
  simp only [symm, norm_div, Complex.norm_ofNat]
  linarith

/-- **The Jensen count.** If `g` is holomorphic on `‖z‖ < 11/10`, `0 < m ≤ Re g 0` and
`‖g‖ ≤ M` on `‖z‖ ≤ 7/8`, then the real zeros of `Re g` in `[−5/6, 5/6]` lie in a `Finset`
of size at most `21 log (M/m)`: upstream `ZerosBound` at `r = 5/6`, `R = 7/8` on
`model g`. -/
theorem real_zero_count {g : ℂ → ℂ} {m M : ℝ}
    (hd : DifferentiableOn ℂ g (Metric.ball (0 : ℂ) (11 / 10))) (hm : 0 < m)
    (h0 : m ≤ (g 0).re) (hM : ∀ z : ℂ, ‖z‖ ≤ 7 / 8 → ‖g z‖ ≤ M) :
    ∃ Z : Finset ℝ, (∀ x : ℝ, |x| ≤ 5 / 6 → (g x).re = 0 → x ∈ Z) ∧
      (Z.card : ℝ) ≤ 21 * Real.log (M / m) := by
  have hs0 := symm_zero g
  have hs0ne : symm g 0 ≠ 0 := by
    rw [hs0, Complex.ofReal_ne_zero]
    exact ne_of_gt (by linarith)
  have hsd := symm_differentiableOn hd
  have han : AnalyticOnNhd ℂ (model g) (Metric.ball (0 : ℂ) (11 / 10)) := by
    intro z hz
    exact (hsd.analyticAt (Metric.isOpen_ball.mem_nhds hz)).div_const
  have hball1 : Metric.closedBall (0 : ℂ) 1 ⊆ Metric.ball (0 : ℂ) (11 / 10) := by
    intro z hz
    rw [Metric.mem_closedBall] at hz
    rw [Metric.mem_ball]
    linarith
  have hanc : AnalyticOnNhd ℂ (model g) (Metric.closedBall (0 : ℂ) 1) := han.mono hball1
  have hf0 : model g 0 = 1 := div_self hs0ne
  -- finitely many zeros in the closed unit ball: the template of `ReZetaCount.F_zeros_finite`
  have hfin : (SetOfZeros 1 (model g)).Finite := by
    by_contra hinf
    rw [Set.not_finite] at hinf
    have hsub : SetOfZeros 1 (model g) ⊆ Metric.closedBall (0 : ℂ) 1 := fun x hx => by
      simpa only [Metric.mem_closedBall, dist_zero_right] using hx.1
    obtain ⟨x, hxK, hacc⟩ :=
      hinf.exists_accPt_of_subset_isCompact (isCompact_closedBall (0 : ℂ) 1) hsub
    have hfeq : Set.EqOn (model g) 0 (Metric.ball (0 : ℂ) (11 / 10)) := by
      refine AnalyticOnNhd.eqOn_zero_of_preconnected_of_mem_closure han
        Metric.isPreconnected_ball (z₀ := x) (hball1 hxK) ?_
      simp only [mem_closure_iff_clusterPt, ← accPt_principal_iff_clusterPt]
      exact hacc.mono (principal_mono.mpr fun _ h => h.2)
    have h0' := hfeq (Metric.mem_ball_self (by norm_num : (0:ℝ) < 11 / 10))
    rw [hf0] at h0'
    simp at h0'
  -- the bound on the `7/8` ball
  have hg0 : ‖g 0‖ ≤ M := hM 0 (by rw [norm_zero]; norm_num)
  have hmM : m ≤ M := le_trans h0 (le_trans (Complex.re_le_norm _) hg0)
  have hn0 : m ≤ ‖symm g 0‖ := by
    rw [hs0, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (by linarith)]
    exact h0
  have hbound : ∀ z : ℂ, ‖z‖ ≤ 7 / 8 → ‖model g z‖ ≤ M / m := by
    intro z hz
    have hsz := norm_symm_le hM hz
    have hpos : 0 < ‖symm g 0‖ := by linarith
    simp only [model, norm_div]
    rw [div_le_div_iff₀ hpos hm]
    exact mul_le_mul hsz hn0 hm.le (by linarith)
  have h56 : (5 : ℝ) / 6 < 1 := by norm_num
  have hZB := ZerosBound (B := M / m) (r := 5 / 6) (R := 7 / 8) (f := model g)
    (by norm_num) h56 (by norm_num) (by norm_num) hanc hf0 hfin hbound
  rw [Nat.cast_sum, show (7 : ℝ) / 8 / (5 / 6) = 21 / 20 by norm_num] at hZB
  refine ⟨((finiteSetOfZeros_mono h56 hfin).toFinset).image Complex.re, ?_, ?_⟩
  · intro x hx hx0
    refine Finset.mem_image.mpr ⟨(x : ℂ), ?_, Complex.ofReal_re x⟩
    rw [Set.Finite.mem_toFinset]
    refine ⟨?_, ?_⟩
    · rw [Complex.norm_real, Real.norm_eq_abs]
      exact hx
    · show symm g (x : ℂ) / symm g 0 = 0
      rw [symm_real, hx0, Complex.ofReal_zero, zero_div]
  · have hball : AnalyticOnNhd ℂ (model g) (Metric.ball (0 : ℂ) 1) :=
      hanc.mono Metric.ball_subset_closedBall
    have hone : ∀ ρ ∈ (finiteSetOfZeros_mono h56 hfin).toFinset,
        1 ≤ analyticOrderNatAt (model g) ρ := by
      intro ρ hρ
      rw [Set.Finite.mem_toFinset] at hρ
      obtain ⟨hn, hz⟩ := hρ
      have hAn : AnalyticAt ℂ (model g) ρ := by
        refine hanc ρ ?_
        rw [Metric.mem_closedBall, dist_zero_right]
        linarith
      have hne0 : analyticOrderAt (model g) ρ ≠ 0 := hAn.analyticOrderAt_ne_zero.mpr hz
      have hnetop : analyticOrderAt (model g) ρ ≠ ⊤ := by
        intro htop
        have hev : ∀ᶠ z in nhds ρ, model g z = 0 := analyticOrderAt_eq_top.mp htop
        have hmem : ρ ∈ Metric.ball (0 : ℂ) 1 := by
          rw [Metric.mem_ball, dist_zero_right]; linarith
        have heq : Set.EqOn (model g) 0 (Metric.ball (0 : ℂ) 1) :=
          hball.eqOn_zero_of_preconnected_of_eventuallyEq_zero Metric.isPreconnected_ball hmem
            (by filter_upwards [hev] with z hz using hz)
        have h0' := heq (Metric.mem_ball_self (by norm_num : (0:ℝ) < 1))
        rw [hf0] at h0'
        simp at h0'
      rw [Nat.one_le_iff_ne_zero]
      intro h
      rcases ENat.toNat_eq_zero.mp h with h | h
      · exact hne0 h
      · exact hnetop h
    have hcard1 : (((finiteSetOfZeros_mono h56 hfin).toFinset.image Complex.re).card : ℝ)
        ≤ ((finiteSetOfZeros_mono h56 hfin).toFinset.card : ℝ) := by
      exact_mod_cast Finset.card_image_le
    have hsum : (((finiteSetOfZeros_mono h56 hfin).toFinset).card : ℝ)
        ≤ ∑ ρ ∈ (finiteSetOfZeros_mono h56 hfin).toFinset,
            (analyticOrderNatAt (model g) ρ : ℝ) := by
      rw [Finset.card_eq_sum_ones ((finiteSetOfZeros_mono h56 hfin).toFinset)]
      push_cast
      refine Finset.sum_le_sum ?_
      intro ρ hρ
      exact_mod_cast hone ρ hρ
    have hlog2120 : (1 : ℝ) / 21 ≤ Real.log (21 / 20) := by
      have h1 : Real.log (20 / 21) ≤ 20 / 21 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
      rw [show (21 : ℝ) / 20 = ((20 : ℝ) / 21)⁻¹ by norm_num, Real.log_inv]
      linarith
    have hlogpos : (0 : ℝ) < Real.log (21 / 20) := by linarith
    have hinv : 1 / Real.log (21 / 20) ≤ 21 := by
      rw [div_le_iff₀ hlogpos]
      linarith
    have hMm : 1 ≤ M / m := by
      rw [le_div_iff₀ hm]; linarith
    have hlogMm : 0 ≤ Real.log (M / m) := Real.log_nonneg hMm
    calc (((finiteSetOfZeros_mono h56 hfin).toFinset.image Complex.re).card : ℝ)
        ≤ ((finiteSetOfZeros_mono h56 hfin).toFinset.card : ℝ) := hcard1
      _ ≤ ∑ ρ ∈ (finiteSetOfZeros_mono h56 hfin).toFinset,
            (analyticOrderNatAt (model g) ρ : ℝ) := hsum
      _ ≤ 1 / Real.log (21 / 20) * Real.log (M / m) := hZB
      _ ≤ 21 * Real.log (M / m) := mul_le_mul_of_nonneg_right hinv hlogMm

/-! ## The edge -/

/-- **The edge, with the growth as a hypothesis.** For `G` analytic off `1`, `T ≥ 4`,
`Re G(3 + iT) ≥ 1/3`, `‖G‖ ≤ M` on `|w − (3 + iT)| ≤ 21/8`, and `G ≠ 0` on the segment
`[1/2, 3] + iT`: `|Im ∫_{1/2}^{3} logDeriv G (x + iT) dx| ≤ π (21 log (3M) + 1)`. -/
theorem edge_le_of_bound {G : ℂ → ℂ} {T M : ℝ} (hT : 4 ≤ T)
    (hGa : ∀ w : ℂ, w ≠ 1 → AnalyticAt ℂ G w)
    (h0 : 1 / 3 ≤ (G (3 + (T : ℂ) * I)).re)
    (hM : ∀ w : ℂ, ‖w - (3 + (T : ℂ) * I)‖ ≤ 21 / 8 → ‖G w‖ ≤ M)
    (hne : ∀ x ∈ Set.Icc (1/2:ℝ) 3, G (↑x + ↑T * I) ≠ 0) :
    |(∫ x in (1/2:ℝ)..3, logDeriv G (↑x + ↑T * I)).im|
      ≤ Real.pi * (21 * Real.log (3 * M) + 1) := by
  -- the count, on the disc of radius `3` about `3 + iT`
  have hd : DifferentiableOn ℂ (fun z : ℂ => G (3 + (T : ℂ) * I + 3 * z))
      (Metric.ball (0 : ℂ) (11 / 10)) := by
    intro z hz
    rw [Metric.mem_ball, dist_zero_right] at hz
    have hw : (3 + (T : ℂ) * I + 3 * z) ≠ 1 := by
      intro h
      have him : (3 + (T : ℂ) * I + 3 * z).im = T + 3 * z.im := by simp
      rw [h, Complex.one_im] at him
      have hzi := abs_le.mp (le_trans (Complex.abs_im_le_norm z) hz.le)
      linarith [hzi.1]
    have hf : DifferentiableAt ℂ (fun z : ℂ => 3 + (T : ℂ) * I + 3 * z) z := by fun_prop
    exact (DifferentiableAt.comp (g := G) (f := fun z : ℂ => 3 + (T : ℂ) * I + 3 * z) z
      (hGa _ hw).differentiableAt hf).differentiableWithinAt
  have hg0 : 1 / 3 ≤ ((fun z : ℂ => G (3 + (T : ℂ) * I + 3 * z)) 0).re := by
    show 1 / 3 ≤ (G (3 + (T : ℂ) * I + 3 * 0)).re
    rw [mul_zero, add_zero]
    exact h0
  have hgM : ∀ z : ℂ, ‖z‖ ≤ 7 / 8 → ‖(fun z : ℂ => G (3 + (T : ℂ) * I + 3 * z)) z‖ ≤ M := by
    intro z hz
    refine hM _ ?_
    rw [show 3 + (T : ℂ) * I + 3 * z - (3 + (T : ℂ) * I) = 3 * z by ring, norm_mul]
    simp only [Complex.norm_ofNat]
    linarith
  obtain ⟨Z', hZ'mem, hZ'card⟩ := real_zero_count hd (by norm_num) hg0 hgM
  have hdiv : M / (1 / 3 : ℝ) = 3 * M := by ring
  rw [hdiv] at hZ'card
  -- the zeros of `Re G(x + iT)` on `(1/2, 3)`
  have hZ : ∀ x ∈ Set.Ioo (1/2:ℝ) 3, ((fun y : ℝ => G (↑y + ↑T * I)) x).re = 0 →
      x ∈ Z'.image (fun y : ℝ => 3 * y + 3) := by
    intro x hx hx0
    refine Finset.mem_image.mpr ⟨(x - 3) / 3, hZ'mem _ ?_ ?_, by ring⟩
    · rw [abs_le]; constructor <;> linarith [hx.1, hx.2]
    · show (G (3 + (T : ℂ) * I + 3 * (((x - 3) / 3 : ℝ) : ℂ))).re = 0
      rw [show (3 : ℂ) + (T : ℂ) * I + 3 * (((x - 3) / 3 : ℝ) : ℂ) = (x : ℂ) + (T : ℂ) * I by
        push_cast; ring]
      exact hx0
  have hcard : ((Z'.image (fun y : ℝ => 3 * y + 3)).card : ℝ) ≤ (Z'.card : ℝ) := by
    exact_mod_cast Finset.card_image_le
  -- Backlund's step, the tree's generic `ArgLegs.segment_im_integral_le`
  have hne1 : ∀ x : ℝ, (x : ℂ) + (T : ℂ) * I ≠ 1 := by
    intro x h
    have h2 : ((x : ℂ) + (T : ℂ) * I).im = (1 : ℂ).im := by rw [h]
    simp at h2
    linarith
  have hder : ∀ x ∈ Set.Icc (1/2:ℝ) 3,
      HasDerivAt (fun y : ℝ => G ((y : ℂ) + (T : ℂ) * I))
        (deriv G ((x : ℂ) + (T : ℂ) * I)) x := by
    intro x _
    have hz : HasDerivAt (fun w : ℂ => w + (T : ℂ) * I) 1 ((x : ℝ) : ℂ) := by
      simpa using (hasDerivAt_id ((x : ℝ) : ℂ)).add_const ((T : ℂ) * I)
    have hcomp :=
      ((((hGa _ (hne1 x)).differentiableAt).hasDerivAt).comp ((x : ℝ) : ℂ) hz).comp_ofReal
    simpa [Function.comp] using hcomp
  have hcg : ContinuousOn (fun x : ℝ => G ((x : ℂ) + (T : ℂ) * I)) (Set.Icc (1/2:ℝ) 3) :=
    fun x hx => ((hder x hx).continuousAt).continuousWithinAt
  have hc : ContinuousOn (fun x : ℝ => deriv G ((x : ℂ) + (T : ℂ) * I)
      / G ((x : ℂ) + (T : ℂ) * I)) (Set.Icc (1/2:ℝ) 3) := by
    intro x hx
    have hf : ContinuousAt (fun y : ℝ => (y : ℂ) + (T : ℂ) * I) x := by fun_prop
    have h1 := ContinuousAt.comp (g := deriv G) (f := fun y : ℝ => (y : ℂ) + (T : ℂ) * I)
      (hGa _ (hne1 x)).deriv.continuousAt hf
    have h2 := ContinuousAt.comp (g := G) (f := fun y : ℝ => (y : ℂ) + (T : ℂ) * I)
      (hGa _ (hne1 x)).continuousAt hf
    exact (h1.div h2 (hne x hx)).continuousWithinAt
  have key := ArgLegs.segment_im_integral_le
    (g := fun x : ℝ => G ((x : ℂ) + (T : ℂ) * I))
    (g' := fun x : ℝ => deriv G ((x : ℂ) + (T : ℂ) * I))
    (by norm_num : (1/2:ℝ) ≤ 3) hder hne hc hcg _ hZ
  have hgoal : (∫ x in (1/2:ℝ)..3, logDeriv G (↑x + ↑T * I))
      = ∫ x in (1/2:ℝ)..3, deriv G ((x : ℂ) + (T : ℂ) * I) / G ((x : ℂ) + (T : ℂ) * I) := by
    simp only [logDeriv_apply]
  rw [hgoal]
  refine le_trans key (mul_le_mul_of_nonneg_left ?_ Real.pi_pos.le)
  linarith

/-- **S11 step 1d (ii), the horizontal edge.** For `0 ≤ c ≤ 1`, `T ≥ 4`, and
`G = ζ + c ζ'` nonzero on the segment `[1/2, 3] + iT`:
`|Im ∫_{1/2}^{3} logDeriv G (x + iT) dx| ≤ 21π log T + 133π`. -/
theorem horizontal_edge_le {c T : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) (hT : 4 ≤ T)
    (hne : ∀ x ∈ Set.Icc (1/2:ℝ) 3,
      riemannZeta (↑x + ↑T * I) + c * deriv riemannZeta (↑x + ↑T * I) ≠ 0) :
    |(∫ x in (1/2:ℝ)..3,
        logDeriv (fun s => riemannZeta s + c * deriv riemannZeta s) (↑x + ↑T * I)).im|
      ≤ 21 * Real.pi * Real.log T + 133 * Real.pi := by
  have h0 : 1 / 3 ≤ (riemannZeta (3 + (T : ℂ) * I)
      + c * deriv riemannZeta (3 + (T : ℂ) * I)).re := by
    have hs : ((3 : ℂ) + (T : ℂ) * I).re = 3 := by simp
    have h1 := LevinsonSize.norm_G_sub_one_le hc0 hc1 hs
    have h2 := Complex.abs_re_le_norm
      (riemannZeta (3 + (T : ℂ) * I) + c * deriv riemannZeta (3 + (T : ℂ) * I) - 1)
    rw [Complex.sub_re, Complex.one_re, abs_le] at h2
    nlinarith [Real.pi_lt_d2, Real.pi_gt_three, h2.1, h1]
  have h := edge_le_of_bound (G := fun s => riemannZeta s + c * deriv riemannZeta s)
    (M := 36 * T + 225) hT (fun w hw => G_analyticAt c hw) h0
    (fun w hw => G_disc_le hc0 hc1 hT hw) hne
  have hTpos : (0 : ℝ) < T := by linarith
  have hlogle : Real.log (3 * (36 * T + 225)) ≤ Real.log 300 + Real.log T := by
    rw [← Real.log_mul (by norm_num) (by linarith)]
    exact Real.log_le_log (by linarith) (by linarith)
  have hlog300 : Real.log 300 ≤ 6.2384 := by
    have h512 : Real.log 300 ≤ Real.log 512 := Real.log_le_log (by norm_num) (by norm_num)
    have h2 : Real.log 512 = 9 * Real.log 2 := by
      rw [show (512 : ℝ) = 2 ^ (9 : ℕ) by norm_num, Real.log_pow]
      norm_num
    have h3 := Real.log_two_lt_d9
    linarith
  have hb : 21 * Real.log (3 * (36 * T + 225)) + 1 ≤ 21 * Real.log T + 133 := by
    linarith
  calc |(∫ x in (1/2:ℝ)..3,
        logDeriv (fun s => riemannZeta s + c * deriv riemannZeta s) (↑x + ↑T * I)).im|
      ≤ Real.pi * (21 * Real.log (3 * (36 * T + 225)) + 1) := h
    _ ≤ Real.pi * (21 * Real.log T + 133) :=
        mul_le_mul_of_nonneg_left hb Real.pi_pos.le
    _ = 21 * Real.pi * Real.log T + 133 * Real.pi := by ring

/-- info: 'LevinsonEdge.zeta_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_norm_le

/-- info: 'LevinsonEdge.deriv_zeta_disc_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms deriv_zeta_disc_le

/-- info: 'LevinsonEdge.G_disc_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms G_disc_le

/-- info: 'LevinsonEdge.real_zero_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms real_zero_count

/-- info: 'LevinsonEdge.edge_le_of_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms edge_le_of_bound

/-- info: 'LevinsonEdge.horizontal_edge_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms horizontal_edge_le

end LevinsonEdge
