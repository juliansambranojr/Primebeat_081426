/-
JensenCount — `StmtLocalCount` discharged: the Backlund-style local zero
count for `ζ`, with explicit constants.

Entry 141 mapped the route for `StmtBacklundArg`; entry 156 recorded that
upstream PR #1751 landed `ZerosBound` — the Jensen disk count — sorry-free.
`Stage3/ArgCrude.lean` names the leaf that count is supposed to fill
(`StmtLocalCount cnt A₁ A₃`) and sketches the discharge. This module builds
the concrete `cnt` and proves the leaf.

WHY THE UPSTREAM WINDOW IS NOT ENOUGH. `ZeroWindow t` is centred at
`3/2 + it` with radius `3/4`, so `Re ρ ∈ [3/4, 9/4]`; it never reaches the
critical line, because it exists for zero-free-strip work. And no
translation-only window can be repaired: `ZerosBound` needs `r < R < 1`, so a
window reaching `Re = 1/2` at radius `r` would need its majorant radius `R`
to reach below `1/2`, where upstream's `GlobalBound` (a `Re ∈ [1/2, 5/2]`
strip bound) stops applying.

WHAT THIS MODULE DOES INSTEAD. Scale by two:

    f z = ζ (2z + (2 + iT)) / ζ (2 + iT)

so the closed unit ball maps onto `|s - (2+iT)| ≤ 2`, `r = 7/8` covers
`|s - (2+iT)| ≤ 7/4`, and `R = 15/16` needs a majorant on
`|s - (2+iT)| ≤ 15/8`, i.e. `Re ∈ [1/8, 31/8]`.

WHY THE RADIUS IS 7/4. The radius-`3/2` disk about `2 + iT` is tangent to the
critical line. A zero at `1/2 + iγ` sits at distance `√((3/2)² + (T-γ)²)`,
which is `≤ 3/2` only when `γ = T` exactly, so the radius-`3/2` count is `0`
for almost every `T`. Its consumer `StmtSFromLocal` (Stage3/ArgCrude.lean)
would then read `|S T| ≤ b`, a bounded-`S` claim, and that is false. At
radius `7/4` the disk reaches `|γ - T| ≤ √((7/4)² - (3/2)²) = √(13/16)`
≈ `0.901` on the line `Re = 1/2`. O77 measured this on a `T`-grid to `900`
(`results/leaf_instantiation.json`): the count vanishes on 12% of the grid,
and `|S T| ≤ 0.462 · cnt T + 0.508` holds across it.

Three obligations follow, and all three are proved here rather than imported:

  `zeta_disk_upper`    `‖ζ w‖ ≤ 28 T` on `|w - (2+iT)| ≤ 15/8`, from upstream
                       `ZetaAltFormula` — the same estimate as `GlobalBound`
                       but re-run for the wider disk
  `zeta_centre_lower`  `‖ζ (2+iT)‖ ≥ 1/3`, from the Dirichlet series and
                       `ζ(2) = π²/6`; upstream's `ZetaFixedLowerBound` is
                       stated only at `3/2`
  `pole_away`          the pole at `s = 1` stays outside the mapped ball:
                       `2z + (2+iT) = 1` forces `Re z = -1/2` and
                       `Im z ≤ -1`, hence `‖z‖² ≥ 5/4 > (11/10)²`

CONSTANTS. `1/log(15/14) ≤ 15` (from `log(14/15) ≤ -1/15`) and
`log 84 ≤ 4.86` (from `84 ≤ 2^7` and `log 2 < 0.6931471808`) give

    zetaLocalCount T ≤ 15 log T + 73    for all T ≥ 2.

Crude-explicit is the spec. Entry 130's budget accepts `A₁ ≤ 100`,
`A₃ ≤ 1000`; `15` and `73` clear it with room, and the widening from
radius `3/2` cost about a factor of two in `A₁`, paid out of that room.

Consumes: `StmtLocalCount` (Stage3.ArgCrude), `ZerosBound`, `SetOfZeros`,
`finiteSetOfZeros_mono`, `ZetaAltFormula`, `analyticOrderNatAt_fun_div_const`
(PrimeNumberTheoremAnd.StrongPNT).
Companion to notes entries 130, 141, 156.
-/
import Mathlib
import PrimeNumberTheoremAnd.StrongPNT
import Stage3.ArgCrude

namespace Stage3

noncomputable section

open Complex Filter Set MeasureTheory

local notation "ζ" => riemannZeta

theorem zeta_centre_lower (T : ℝ) : (1 : ℝ) / 3 ≤ ‖ζ (2 + Complex.I * T)‖ := by
  have hsre : (2 + Complex.I * (T : ℂ)).re = 2 := by
    simp only [Complex.add_re, Complex.re_ofNat, Complex.mul_re, Complex.I_re,
      Complex.ofReal_re, zero_mul, Complex.I_im, Complex.ofReal_im, mul_zero, sub_self, add_zero]
  have hs1 : 1 < (2 + Complex.I * (T : ℂ)).re := by rw [hsre]; norm_num
  have hsne : (2 + Complex.I * (T : ℂ)) ≠ 0 := by
    intro h; rw [h] at hsre; simp only [Complex.zero_re] at hsre; norm_num at hsre
  have hnormeq : ∀ n : ℕ,
      ‖(1 : ℂ) / (n : ℂ) ^ (2 + Complex.I * (T : ℂ))‖ = 1 / (n : ℝ) ^ 2 := by
    intro n
    rcases Nat.eq_zero_or_pos n with rfl | hn
    · simp [Complex.zero_cpow hsne]
    · rw [norm_div, norm_one, Complex.norm_natCast_cpow_of_pos hn, hsre,
        ← Real.rpow_natCast (n : ℝ) 2]
      norm_num
  have hgsum : Summable (fun n : ℕ => (1 : ℝ) / (n : ℝ) ^ 2) := hasSum_zeta_two.summable
  have hfsum : Summable (fun n : ℕ => (1 : ℂ) / (n : ℂ) ^ (2 + Complex.I * (T : ℂ))) :=
    Complex.summable_one_div_nat_cpow.mpr hs1
  have hgtail : ∑' n : ℕ, (1 : ℝ) / ((n + 2 : ℕ) : ℝ) ^ 2 = Real.pi ^ 2 / 6 - 1 := by
    have h := hgsum.sum_add_tsum_nat_add 2
    rw [hasSum_zeta_two.tsum_eq] at h
    rw [Finset.sum_range_succ, Finset.sum_range_one] at h
    norm_num at h ⊢
    linarith
  have hftail : ζ (2 + Complex.I * (T : ℂ))
      = 1 + ∑' n : ℕ, (1 : ℂ) / ((n + 2 : ℕ) : ℂ) ^ (2 + Complex.I * (T : ℂ)) := by
    rw [zeta_eq_tsum_one_div_nat_cpow hs1, ← hfsum.sum_add_tsum_nat_add 2,
      Finset.sum_range_succ, Finset.sum_range_one]
    norm_num [Complex.zero_cpow hsne]
  have hbound : ‖∑' n : ℕ, (1 : ℂ) / ((n + 2 : ℕ) : ℂ) ^ (2 + Complex.I * (T : ℂ))‖
      ≤ Real.pi ^ 2 / 6 - 1 := by
    rw [← hgtail]
    refine (norm_tsum_le_tsum_norm ?_).trans_eq (tsum_congr (fun n => hnormeq (n + 2)))
    · simpa only [hnormeq] using (summable_nat_add_iff 2).mpr hgsum
  have hpi : Real.pi ^ 2 / 6 - 1 ≤ 2 / 3 := by
    nlinarith [Real.pi_lt_d2, Real.pi_gt_d2]
  have htri : ‖(1 : ℂ)‖ ≤ ‖ζ (2 + Complex.I * (T : ℂ))‖ +
      ‖∑' n : ℕ, (1 : ℂ) / ((n + 2 : ℕ) : ℂ) ^ (2 + Complex.I * (T : ℂ))‖ := by
    nth_rewrite 1 [show (1 : ℂ) = ζ (2 + Complex.I * (T : ℂ))
      - ∑' n : ℕ, (1 : ℂ) / ((n + 2 : ℕ) : ℂ) ^ (2 + Complex.I * (T : ℂ)) by rw [hftail]; ring]
    exact norm_sub_le _ _
  rw [norm_one] at htri
  linarith

/-- **The majorant on the wide disk.** `‖ζ w‖ ≤ 28 T` for `T ≥ 2` and
`‖w - (2 + iT)‖ ≤ 15/8`; this is the `R = 15/16` radius of the Jensen step
pulled back through `s = 2z + (2 + iT)`. On that disk `Re w ≥ 1/8 > 0` and
`Im w ≥ T - 15/8 ≥ 1/8`, so the pole at `s = 1` is avoided with room. -/
theorem zeta_disk_upper {T : ℝ} (hT : 2 ≤ T) {w : ℂ}
    (hw : ‖w - (2 + Complex.I * (T : ℂ))‖ ≤ 15 / 8) : ‖ζ w‖ ≤ 28 * T := by
  have hu_re : (w - (2 + Complex.I * (T : ℂ))).re = w.re - 2 := by simp
  have hu_im : (w - (2 + Complex.I * (T : ℂ))).im = w.im - T := by simp
  have h1 : |w.re - 2| ≤ 15 / 8 := by
    rw [← hu_re]; exact le_trans (Complex.abs_re_le_norm _) hw
  have h2 : |w.im - T| ≤ 15 / 8 := by
    rw [← hu_im]; exact le_trans (Complex.abs_im_le_norm _) hw
  obtain ⟨h1a, h1b⟩ := abs_le.mp h1
  obtain ⟨h2a, h2b⟩ := abs_le.mp h2
  have hre : (1 : ℝ) / 8 ≤ w.re := by linarith
  have hrepos : 0 < w.re := by linarith
  have him : (1 : ℝ) / 8 ≤ w.im := by linarith
  have hw1 : w ≠ 1 := by
    intro h; rw [h] at him; simp only [Complex.one_im] at him; linarith
  have hwsub : (1 : ℝ) / 8 ≤ ‖w - 1‖ := by
    have := Complex.abs_im_le_norm (w - 1)
    rw [Complex.sub_im, Complex.one_im, sub_zero] at this
    have : |w.im| = w.im := abs_of_nonneg (by linarith)
    calc (1 : ℝ) / 8 ≤ |w.im| := by rw [this]; linarith
      _ = |(w - 1).im| := by rw [Complex.sub_im, Complex.one_im, sub_zero]
      _ ≤ ‖w - 1‖ := Complex.abs_im_le_norm _
  have hnormw : ‖w‖ ≤ T + 31 / 8 := by
    have hc : ‖(2 : ℂ) + Complex.I * (T : ℂ)‖ ≤ 2 + T := by
      refine le_trans (norm_add_le _ _) ?_
      rw [norm_mul, Complex.norm_I, one_mul, Complex.norm_real, Real.norm_eq_abs,
        abs_of_nonneg (by linarith : (0:ℝ) ≤ T)]
      simp
    calc ‖w‖ = ‖(w - (2 + Complex.I * (T : ℂ))) + (2 + Complex.I * (T : ℂ))‖ := by ring_nf
      _ ≤ ‖w - (2 + Complex.I * (T : ℂ))‖ + ‖(2 : ℂ) + Complex.I * (T : ℂ)‖ := norm_add_le _ _
      _ ≤ 15 / 8 + (2 + T) := by linarith
      _ = T + 31 / 8 := by ring
  have leadingTerms : ‖(1 : ℂ) + 1 / (w - 1)‖ ≤ 9 := by
    have h4 : ‖(1 : ℂ) / (w - 1)‖ ≤ 8 := by
      rw [norm_div, norm_one, div_le_iff₀ (by linarith : (0:ℝ) < ‖w - 1‖)]
      linarith
    calc ‖(1 : ℂ) + 1 / (w - 1)‖ ≤ ‖(1 : ℂ)‖ + ‖(1 : ℂ) / (w - 1)‖ := norm_add_le _ _
      _ ≤ 1 + 8 := by rw [norm_one]; linarith
      _ = 9 := by norm_num
  have domBound : ∀ {x : ℝ}, x ∈ Set.Ioi (1 : ℝ) →
      |Int.fract x| * ‖(x : ℂ) ^ (-w - 1)‖ ≤ x ^ (-w.re - 1) := by
    intro x hu
    rw [Set.mem_Ioi] at hu
    rw [Complex.norm_cpow_eq_rpow_re_of_pos (by linarith)]
    simp only [Complex.sub_re, Complex.neg_re, Complex.one_re, Int.abs_fract]
    exact mul_le_of_le_one_left (Real.rpow_nonneg (by linarith) _) (Int.fract_lt_one x).le
  have domIntegral : Integrable (fun x : ℝ => x ^ (-w.re - 1))
      (volume.restrict (Set.Ioi 1)) := integrableOn_Ioi_rpow_of_lt (by linarith) zero_lt_one
  have hint : ‖∫ (u : ℝ) in Set.Ioi 1, ((Int.fract u : ℝ) : ℂ) * (u : ℂ) ^ (-w - 1)‖
      ≤ 1 / w.re := by
    refine (MeasureTheory.norm_integral_le_integral_norm _).trans ?_
    have hI := integral_Ioi_rpow_of_lt (a := -w.re - 1) (by linarith) one_pos
    simp only [sub_add_cancel, Real.one_rpow, neg_div_neg_eq] at hI
    simp only [Complex.norm_mul, Complex.norm_real, Real.norm_eq_abs, ← hI]
    refine integral_mono_ae (domIntegral.mono' (((measurable_fract.abs).mul
      ((Complex.measurable_ofReal.pow_const _).norm)).aestronglyMeasurable) ?_) domIntegral
      (by filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with x hx using domBound hx)
    filter_upwards [ae_restrict_mem measurableSet_Ioi] with x hx
    rw [norm_mul, Real.norm_eq_abs, abs_abs, norm_norm]
    exact domBound hx
  have hmul : ‖w * ∫ (u : ℝ) in Set.Ioi 1, ((Int.fract u : ℝ) : ℂ) * (u : ℂ) ^ (-w - 1)‖
      ≤ 8 * T + 31 := by
    rw [norm_mul]
    have hinv : (1 : ℝ) / w.re ≤ 8 := by
      rw [div_le_iff₀ hrepos]; linarith
    calc ‖w‖ * ‖∫ (u : ℝ) in Set.Ioi 1, ((Int.fract u : ℝ) : ℂ) * (u : ℂ) ^ (-w - 1)‖
        ≤ (T + 31 / 8) * 8 :=
          mul_le_mul hnormw (hint.trans hinv) (norm_nonneg _) (by linarith)
      _ = 8 * T + 31 := by ring
  rw [ZetaAltFormula hrepos hw1]
  refine (norm_sub_le_of_le leadingTerms hmul).trans ?_
  linarith

/-- The centre `2 + iT` has real part `2`, hence `ζ` does not vanish there. -/
theorem zeta_centre_ne_zero (T : ℝ) : ζ (2 + Complex.I * (T : ℂ)) ≠ 0 := by
  refine riemannZeta_ne_zero_of_one_lt_re ?_
  simp only [Complex.add_re, Complex.re_ofNat, Complex.mul_re, Complex.I_re,
    Complex.ofReal_re, zero_mul, Complex.I_im, Complex.ofReal_im, mul_zero, sub_self, add_zero]
  norm_num

/-- **The pole stays outside the mapped ball.** For `T ≥ 2` and `‖z‖ ≤ 11/10`,
the point `2z + (2 + iT)` is never the pole `s = 1`. -/
theorem pole_away {T : ℝ} (hT : 2 ≤ T) {z : ℂ} (hz : ‖z‖ ≤ 11 / 10) :
    2 * z + (2 + Complex.I * (T : ℂ)) ≠ 1 := by
  intro h
  have hre : (2 * z + (2 + Complex.I * (T : ℂ))).re = 2 * z.re + 2 := by simp
  have him : (2 * z + (2 + Complex.I * (T : ℂ))).im = 2 * z.im + T := by simp
  rw [h, Complex.one_re] at hre
  rw [h, Complex.one_im] at him
  have hns : ‖z‖ ^ 2 = z.re * z.re + z.im * z.im := by
    rw [Complex.sq_norm, Complex.normSq_apply]
  nlinarith [norm_nonneg z]

/-- **The pole stays outside the window.** For `T ≥ 2`, every point within
`11/5` of `2 + iT` differs from `1`. -/
theorem pole_away_centre {T : ℝ} (hT : 2 ≤ T) {v : ℂ}
    (hv : ‖v - (2 + Complex.I * (T : ℂ))‖ < 11 / 5) : v ≠ 1 := by
  intro h
  subst h
  have hre : ((1 : ℂ) - (2 + Complex.I * (T : ℂ))).re = -1 := by simp; norm_num
  have him : ((1 : ℂ) - (2 + Complex.I * (T : ℂ))).im = -T := by simp
  have hns : ‖(1 : ℂ) - (2 + Complex.I * (T : ℂ))‖ ^ 2
      = ((1 : ℂ) - (2 + Complex.I * (T : ℂ))).re * ((1 : ℂ) - (2 + Complex.I * (T : ℂ))).re
        + ((1 : ℂ) - (2 + Complex.I * (T : ℂ))).im * ((1 : ℂ) - (2 + Complex.I * (T : ℂ))).im := by
    rw [Complex.sq_norm, Complex.normSq_apply]
  rw [hre, him] at hns
  nlinarith [norm_nonneg ((1 : ℂ) - (2 + Complex.I * (T : ℂ)))]

/-- `ζ` has finitely many zeros within `2` of the centre. -/
theorem zetaWindowTwo_finite {T : ℝ} (hT : 2 ≤ T) :
    {ρ : ℂ | ζ ρ = 0 ∧ ‖ρ - (2 + Complex.I * (T : ℂ))‖ ≤ 2}.Finite := by
  by_contra hinf
  rw [Set.not_finite] at hinf
  have zerosSubset : {ρ : ℂ | ζ ρ = 0 ∧ ‖ρ - (2 + Complex.I * (T : ℂ))‖ ≤ 2}
      ⊆ Metric.closedBall (2 + Complex.I * (T : ℂ)) 2 := fun _ hx => by
    simpa only [Metric.mem_closedBall, Complex.dist_eq] using hx.2
  obtain ⟨x, hxK, hacc⟩ :=
    hinf.exists_accPt_of_subset_isCompact
      (isCompact_closedBall (2 + Complex.I * (T : ℂ)) 2) zerosSubset
  have hfAnalytic : AnalyticOnNhd ℂ ζ (Metric.ball (2 + Complex.I * (T : ℂ)) (11 / 5)) := by
    intro z hz
    simp only [Metric.mem_ball, Complex.dist_eq] at hz
    exact analyticAt_riemannZeta (pole_away_centre hT hz)
  have hfeq : Set.EqOn ζ 0 (Metric.ball (2 + Complex.I * (T : ℂ)) (11 / 5)) := by
    refine AnalyticOnNhd.eqOn_zero_of_preconnected_of_mem_closure hfAnalytic
      Metric.isPreconnected_ball (z₀ := x) ?_ ?_
    · simp only [Metric.mem_ball, Metric.mem_closedBall] at hxK ⊢
      linarith
    · simp only [mem_closure_iff_clusterPt, ← accPt_principal_iff_clusterPt]
      exact hacc.mono (principal_mono.mpr fun _ h => h.1)
  exact zeta_centre_ne_zero T (hfeq (Metric.mem_ball_self (by norm_num)))

/-- **The window.** `ζ`'s zeros in the closed disk of radius `7/4` about
`2 + iT`. On the critical line this disk covers `|γ - T| ≤ √(13/16)` ≈ `0.901`,
an interval of positive length — which is what radius `3/2` fails to do, being
tangent to the line and so catching only `γ = T`. -/
def zetaWindow (T : ℝ) : Set ℂ :=
  {ρ : ℂ | ζ ρ = 0 ∧ ‖ρ - (2 + Complex.I * (T : ℂ))‖ ≤ 7 / 4}

theorem zetaWindow_finite {T : ℝ} (hT : 2 ≤ T) : (zetaWindow T).Finite := by
  refine Set.Finite.subset (zetaWindowTwo_finite hT) ?_
  intro z hz
  exact ⟨hz.1, by linarith [hz.2]⟩

/-- **The normalised local model.** `f z = ζ (2z + 2 + iT) / ζ (2 + iT)`; the
closed unit ball maps onto `|s - (2+iT)| ≤ 2`. -/
def jensenF (T : ℝ) : ℂ → ℂ :=
  fun z => ζ (2 * z + (2 + Complex.I * (T : ℂ))) / ζ (2 + Complex.I * (T : ℂ))

theorem zeta_comp_analytic {T : ℝ} (hT : 2 ≤ T) {w : ℂ} (hw : ‖w‖ ≤ 11 / 10) :
    AnalyticAt ℂ (fun z : ℂ => ζ (2 * z + (2 + Complex.I * (T : ℂ)))) w := by
  refine AnalyticAt.fun_comp (analyticAt_riemannZeta (pole_away hT hw)) ?_
  exact (analyticAt_const.fun_mul analyticAt_id).fun_add analyticAt_const

theorem jensenF_analytic {T : ℝ} (hT : 2 ≤ T) :
    AnalyticOnNhd ℂ (jensenF T) (Metric.closedBall (0 : ℂ) 1) := by
  intro z hz
  simp only [Metric.mem_closedBall, dist_zero_right] at hz
  have h := zeta_comp_analytic hT (show ‖z‖ ≤ 11 / 10 by linarith)
  exact h.div_const

theorem jensenF_zero_eq_one (T : ℝ) : jensenF T 0 = 1 := by
  simp only [jensenF, mul_zero, zero_add]
  exact div_self (zeta_centre_ne_zero T)

theorem jensenF_zeros_finite {T : ℝ} (hT : 2 ≤ T) : (SetOfZeros 1 (jensenF T)).Finite := by
  have hinj : Function.Injective (fun z : ℂ => 2 * z + (2 + Complex.I * (T : ℂ))) := by
    intro a b hab
    simp only [add_left_inj] at hab
    exact mul_left_cancel₀ (by norm_num : (2 : ℂ) ≠ 0) hab
  have hpre : ((fun z : ℂ => 2 * z + (2 + Complex.I * (T : ℂ))) ⁻¹'
      {ρ : ℂ | ζ ρ = 0 ∧ ‖ρ - (2 + Complex.I * (T : ℂ))‖ ≤ 2}).Finite :=
    Set.Finite.preimage (hinj.injOn) (zetaWindowTwo_finite hT)
  refine Set.Finite.subset hpre ?_
  intro z hz
  obtain ⟨hznorm, hzzero⟩ := hz
  simp only [jensenF, div_eq_zero_iff, zeta_centre_ne_zero T, or_false] at hzzero
  refine ⟨hzzero, ?_⟩
  have : 2 * z + (2 + Complex.I * (T : ℂ)) - (2 + Complex.I * (T : ℂ)) = 2 * z := by ring
  rw [this, norm_mul]
  simp only [Complex.norm_ofNat]
  linarith

theorem jensenF_bound {T : ℝ} (hT : 2 ≤ T) {z : ℂ} (hz : ‖z‖ ≤ 15 / 16) :
    ‖jensenF T z‖ ≤ 84 * T := by
  have hnum : ‖ζ (2 * z + (2 + Complex.I * (T : ℂ)))‖ ≤ 28 * T := by
    refine zeta_disk_upper hT ?_
    have hrw : 2 * z + (2 + Complex.I * (T : ℂ)) - (2 + Complex.I * (T : ℂ)) = 2 * z := by ring
    rw [hrw, norm_mul]
    simp only [Complex.norm_ofNat]
    linarith
  have hden : (1 : ℝ) / 3 ≤ ‖ζ (2 + Complex.I * (T : ℂ))‖ := zeta_centre_lower T
  have hdenpos : (0 : ℝ) < ‖ζ (2 + Complex.I * (T : ℂ))‖ := by linarith
  simp only [jensenF, norm_div]
  rw [div_le_iff₀ hdenpos]
  calc ‖ζ (2 * z + (2 + Complex.I * (T : ℂ)))‖ ≤ 28 * T := hnum
    _ = 84 * T * (1 / 3) := by ring
    _ ≤ 84 * T * ‖ζ (2 + Complex.I * (T : ℂ))‖ :=
        mul_le_mul_of_nonneg_left hden (by linarith)

/-- The analytic order is unchanged by an invertible affine change of variable. -/
theorem analyticOrderNatAt_fun_comp_affine (g : ℂ → ℂ) {a : ℂ} (b z : ℂ) (ha : a ≠ 0) :
    analyticOrderNatAt (fun w : ℂ => g (a * w + b)) z = analyticOrderNatAt g (a * z + b) := by
  have hg : AnalyticAt ℂ (fun w : ℂ => a * w + b) z :=
    (analyticAt_const.fun_mul analyticAt_id).fun_add analyticAt_const
  have hd : deriv (fun w : ℂ => a * w + b) z = a := by
    have hda : HasDerivAt (fun w : ℂ => a * w + b) (a * 1) z :=
      ((hasDerivAt_id z).const_mul a).add_const b
    rw [hda.deriv, mul_one]
  have asComp : analyticOrderAt (g ∘ fun w : ℂ => a * w + b) z = analyticOrderAt g (a * z + b) :=
    analyticOrderAt_comp_of_deriv_ne_zero hg (by rw [hd]; exact ha)
  simp only [analyticOrderNatAt, ← asComp, Function.comp_def]

theorem jensenF_order {T : ℝ} (hT : 2 ≤ T) {w : ℂ} (hw : ‖w‖ ≤ 11 / 10) :
    analyticOrderNatAt (jensenF T) w
      = analyticOrderNatAt ζ (2 * w + (2 + Complex.I * (T : ℂ))) := by
  have h1 : analyticOrderNatAt (jensenF T) w
      = analyticOrderNatAt (fun z : ℂ => ζ (2 * z + (2 + Complex.I * (T : ℂ)))) w := by
    show analyticOrderNatAt (fun z : ℂ => ζ (2 * z + (2 + Complex.I * (T : ℂ)))
        / ζ (2 + Complex.I * (T : ℂ))) w = _
    exact analyticOrderNatAt_fun_div_const (zeta_centre_ne_zero T) (zeta_comp_analytic hT hw)
  rw [h1]
  exact analyticOrderNatAt_fun_comp_affine ζ _ w (by norm_num)

/-- **THE LOCAL ZERO COUNT.** For every `T ≥ 2`, the total order of the zeros
of `ζ` in the closed disk `|s - (2 + iT)| ≤ 7/4` — a disk which meets the
critical line in the segment `|γ - T| ≤ √(13/16)` — is at most
`15 log T + 73`.

Backlund's Jensen step, with crude-explicit constants: upstream `ZerosBound`
at `r = 7/8`, `R = 15/16` on `f z = ζ (2z + 2 + iT) / ζ (2 + iT)`. -/
theorem zeta_local_zero_count {T : ℝ} (hT : 2 ≤ T) :
    ∑ ρ ∈ (zetaWindow_finite hT).toFinset, (analyticOrderNatAt ζ ρ : ℝ)
      ≤ 15 * Real.log T + 73 := by
  have hrlt1 : (7 : ℝ) / 8 < 1 := by norm_num
  have hZB := ZerosBound (B := 84 * T) (r := 7 / 8) (R := 15 / 16) (f := jensenF T)
    (by norm_num) hrlt1 (by norm_num) (by norm_num) (jensenF_analytic hT)
    (jensenF_zero_eq_one T) (jensenF_zeros_finite hT) (fun z hz => jensenF_bound hT hz)
  rw [Nat.cast_sum, show (15 : ℝ) / 16 / (7 / 8) = 15 / 14 by norm_num] at hZB
  have hsum : ∑ ρ ∈ (zetaWindow_finite hT).toFinset, (analyticOrderNatAt ζ ρ : ℝ)
      = ∑ z ∈ (finiteSetOfZeros_mono hrlt1 (jensenF_zeros_finite hT)).toFinset,
          (analyticOrderNatAt (jensenF T) z : ℝ) := by
    refine Finset.sum_nbij' (i := fun ρ : ℂ => (ρ - (2 + Complex.I * (T : ℂ))) / 2)
      (j := fun z : ℂ => 2 * z + (2 + Complex.I * (T : ℂ))) ?_ ?_ ?_ ?_ ?_
    · intro ρ hρ
      rw [Set.Finite.mem_toFinset] at hρ ⊢
      simp only [zetaWindow, Set.mem_setOf_eq] at hρ
      simp only [SetOfZeros, Set.mem_setOf_eq]
      refine ⟨?_, ?_⟩
      · rw [norm_div]
        simp only [Complex.norm_ofNat]
        linarith [hρ.2]
      · show ζ (2 * ((ρ - (2 + Complex.I * (T : ℂ))) / 2) + (2 + Complex.I * (T : ℂ)))
            / ζ (2 + Complex.I * (T : ℂ)) = 0
        rw [show 2 * ((ρ - (2 + Complex.I * (T : ℂ))) / 2) + (2 + Complex.I * (T : ℂ)) = ρ by
          ring, hρ.1, zero_div]
    · intro z hz
      rw [Set.Finite.mem_toFinset] at hz ⊢
      simp only [SetOfZeros, Set.mem_setOf_eq] at hz
      simp only [zetaWindow, Set.mem_setOf_eq]
      obtain ⟨hzn, hzz⟩ := hz
      refine ⟨?_, ?_⟩
      · have : jensenF T z = ζ (2 * z + (2 + Complex.I * (T : ℂ)))
            / ζ (2 + Complex.I * (T : ℂ)) := rfl
        rw [this, div_eq_zero_iff] at hzz
        exact hzz.resolve_right (zeta_centre_ne_zero T)
      · rw [show 2 * z + (2 + Complex.I * (T : ℂ)) - (2 + Complex.I * (T : ℂ)) = 2 * z by ring,
          norm_mul]
        simp only [Complex.norm_ofNat]
        linarith
    · intro ρ _
      show 2 * ((ρ - (2 + Complex.I * (T : ℂ))) / 2) + (2 + Complex.I * (T : ℂ)) = ρ
      ring
    · intro z _
      show (2 * z + (2 + Complex.I * (T : ℂ)) - (2 + Complex.I * (T : ℂ))) / 2 = z
      ring
    · intro ρ hρ
      rw [Set.Finite.mem_toFinset] at hρ
      simp only [zetaWindow, Set.mem_setOf_eq] at hρ
      have hw : ‖(ρ - (2 + Complex.I * (T : ℂ))) / 2‖ ≤ 11 / 10 := by
        rw [norm_div]
        simp only [Complex.norm_ofNat]
        linarith [hρ.2]
      show (analyticOrderNatAt ζ ρ : ℝ)
        = (analyticOrderNatAt (jensenF T) ((ρ - (2 + Complex.I * (T : ℂ))) / 2) : ℝ)
      rw [jensenF_order hT hw,
        show 2 * ((ρ - (2 + Complex.I * (T : ℂ))) / 2) + (2 + Complex.I * (T : ℂ)) = ρ by ring]
  rw [hsum]
  have hlog1514 : (1 : ℝ) / 15 ≤ Real.log (15 / 14) := by
    have h1 : Real.log (14 / 15) ≤ 14 / 15 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
    rw [show (15 : ℝ) / 14 = ((14 : ℝ) / 15)⁻¹ by norm_num, Real.log_inv]
    linarith
  have hlog1514pos : (0 : ℝ) < Real.log (15 / 14) := by linarith
  have hlog84 : Real.log 84 ≤ 4.86 := by
    have h128 : Real.log 84 ≤ Real.log 128 := Real.log_le_log (by norm_num) (by norm_num)
    have h2 : Real.log 128 = 7 * Real.log 2 := by
      rw [show (128 : ℝ) = 2 ^ (7 : ℕ) by norm_num, Real.log_pow]
      norm_num
    have h3 := Real.log_two_lt_d9
    linarith
  have hlog84nn : (0 : ℝ) ≤ Real.log 84 := Real.log_nonneg (by norm_num)
  have hlogT : (0 : ℝ) ≤ Real.log T := Real.log_nonneg (by linarith)
  have hlogB : Real.log (84 * T) = Real.log 84 + Real.log T :=
    Real.log_mul (by norm_num) (by linarith)
  have hinv : 1 / Real.log (15 / 14) ≤ 15 := by
    rw [div_le_iff₀ hlog1514pos]
    linarith
  calc ∑ z ∈ (finiteSetOfZeros_mono hrlt1 (jensenF_zeros_finite hT)).toFinset,
        (analyticOrderNatAt (jensenF T) z : ℝ)
      ≤ 1 / Real.log (15 / 14) * Real.log (84 * T) := hZB
    _ ≤ 15 * Real.log (84 * T) := by
        refine mul_le_mul_of_nonneg_right hinv ?_
        rw [hlogB]; linarith
    _ = 15 * (Real.log 84 + Real.log T) := by rw [hlogB]
    _ ≤ 15 * Real.log T + 73 := by linarith

open Classical in
/-- **The count function.** Total zero order of `ζ` in `|s - (2+iT)| ≤ 7/4`. -/
def zetaLocalCount (T : ℝ) : ℝ :=
  if h : (zetaWindow T).Finite then ∑ ρ ∈ h.toFinset, (analyticOrderNatAt ζ ρ : ℝ) else 0

theorem zetaLocalCount_eq {T : ℝ} (hT : 2 ≤ T) :
    zetaLocalCount T
      = ∑ ρ ∈ (zetaWindow_finite hT).toFinset, (analyticOrderNatAt ζ ρ : ℝ) := by
  classical
  simp only [zetaLocalCount, dif_pos (zetaWindow_finite hT)]

/-- **THE LEAF, DISCHARGED.** `StmtLocalCount` holds for the concrete zeta
zero count with the explicit constants `A₁ = 15`, `A₃ = 73`. Entry 130's
budget accepts `A₁ ≤ 100`, `A₃ ≤ 1000`, so these clear it with room; the
widening from radius `3/2` to `7/4` cost roughly a factor of two in `A₁`
and is paid out of that budget. -/
theorem localCount_holds : StmtLocalCount zetaLocalCount 15 73 := by
  intro T hT
  rw [zetaLocalCount_eq hT]
  exact zeta_local_zero_count hT

end

/-! ## Axiom check

Each `#guard_msgs` block pins the exact axiom list of one result: if a proof
ever starts depending on anything not listed, the docstring stops matching the
compiler and **`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Stage3.zeta_centre_lower' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeta_centre_lower

/-- info: 'Stage3.zeta_disk_upper' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeta_disk_upper

/-- info: 'Stage3.zeta_centre_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeta_centre_ne_zero

/-- info: 'Stage3.pole_away' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.pole_away

/-- info: 'Stage3.pole_away_centre' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.pole_away_centre

/-- info: 'Stage3.zetaWindowTwo_finite' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zetaWindowTwo_finite

/-- info: 'Stage3.zetaWindow_finite' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zetaWindow_finite

/-- info: 'Stage3.zeta_comp_analytic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeta_comp_analytic

/-- info: 'Stage3.jensenF_analytic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.jensenF_analytic

/-- info: 'Stage3.jensenF_zero_eq_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.jensenF_zero_eq_one

/-- info: 'Stage3.jensenF_zeros_finite' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.jensenF_zeros_finite

/-- info: 'Stage3.jensenF_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.jensenF_bound

/-- info: 'Stage3.analyticOrderNatAt_fun_comp_affine' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.analyticOrderNatAt_fun_comp_affine

/-- info: 'Stage3.jensenF_order' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.jensenF_order

/-- info: 'Stage3.zeta_local_zero_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeta_local_zero_count

/-- info: 'Stage3.zetaLocalCount_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zetaLocalCount_eq

/-- info: 'Stage3.localCount_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.localCount_holds

end Stage3
