/-
ReZetaCount — block H2 of `lean_stage3/design/hnt.md`, "The count: zeros of
Re ζ on the segment, and Re ζ > 0 on the line Re s = 2".

H1 takes two things as hypotheses; this module earns both. On the line
`Re s = 2` the Dirichlet series gives `‖ζ(s) − 1‖ ≤ π²/6 − 1 < 1`, hence
`Re ζ(2+it) ≥ 2 − π²/6 > 0`. On the segment `[1/2, 2]` at height `T` the
zeros of `x ↦ Re ζ(x+iT)` are the real zeros of
`G_T(z) = ζ(2z+2+iT) + ζ(2z+2−iT)` at `z = (x−2)/2 ∈ (−3/4, 0)`, since for
real `z` the second term is the conjugate of the first. `F_T = G_T/G_T(0)`
is `1` at the centre, analytic on the closed unit disk, and `≤ 80T` on the
`15/16` disk, so upstream's `ZerosBound` at `r = 7/8`, `R = 15/16` counts
those zeros by `15 log T + 73` — the arithmetic of
`Stage3.zeta_local_zero_count`, whose `84T` is larger than this `80T`.

The fifteen theorems, hypotheses copied from the block's Theorems lines
(C1 is `2 ≤ T`):

  norm_zeta_sub_one_le      (hs : s.re = 2)
  re_zeta_two_line_ge       none
  re_zeta_two_line_pos      none
  G_zero_eq                 none
  G_real                    none
  G_zero_ne                 none
  F_zero_eq_one             none
  arg_ne_one                C1, ‖z‖ < 11/10
  F_analytic                C1
  F_bound                   C1, ‖z‖ ≤ 15/16
  F_zeros_finite            C1
  F_count_le                C1
  reZeroSet_finite          C1
  mem_reZeros               C1
  card_reZeros_le           C1

with the three defs `G`, `F`, `reZeroSet` and the def `reZeros` the block
lists among its Theorems lines.

Pins: re_zeta_two_line_pos, F_count_le, card_reZeros_le, mem_reZeros.

Composed from `Stage3/JensenCount.lean`: `zeta_disk_upper`. That file
declares `namespace Stage3`, so the name is read here as
`Stage3.zeta_disk_upper` and not under the `JensenCount` namespace the
block's Composes line writes (ASSUMED, PINS.md § Current; TRAPS row 32).
`ZerosBound`, `SetOfZeros` and `finiteSetOfZeros_mono` are upstream, in the
root namespace, reached through `Stage3.JensenCount`'s import of
`PrimeNumberTheoremAnd.StrongPNT`.

`F_bound`'s denominator bound `2(2 − π²/6) ≥ 7/10` does not follow from the
`Real.pi_lt_d2` the block names: `π < 3.15` gives only `4 − π²/3 > 0.69`,
and `56T/0.69 > 80T`. `Real.pi_lt_d4` (`π < 3.1416`) gives
`4 − π²/3 > 0.710`, which carries the block's `56T/(7/10) = 80T` (ASSUMED).

`F_zeros_finite` and `card_reZeros_le` each rebuild the analyticity of
`F_T` on a ball rather than calling a shared lemma, since the block lists
no such theorem: the first needs the `11/10` ball (the accumulation point
can sit on the unit circle), the second only the open unit ball, which
`F_analytic` gives by `AnalyticOnNhd.mono` (ASSUMED).

The order-at-a-zero step of `card_reZeros_le` reads `analyticOrderNatAt` as
`(analyticOrderAt _).toNat` and rules out both `0` and `⊤`: `⊤` would make
`F_T` vanish on a neighbourhood, hence on the whole unit ball by the
identity principle, against `F_T(0) = 1` (ASSUMED: the block names
`analyticOrderAt_eq_top` but not `ENat.toNat_eq_zero`, which is the step
from the `ℕ∞` order to the `ℕ` one).

What the next slice needs: H3 supplies `Z = reZeros hT` to H1's
`horizontal_leg_le` with `card_reZeros_le` as its `Z2`, and `hpos` to
`vertical_leg_le` from `re_zeta_two_line_pos`; then the good heights, the
bad heights above 2 by a good height below, and `StmtSCrude argS 15 75`.
-/
import Stage3.JensenCount

namespace ReZetaCount

noncomputable section

open Filter Set

/-- The symmetrised local model's numerator: `ζ(2z+2+iT) + ζ(2z+2−iT)`. -/
def G (T : ℝ) (z : ℂ) : ℂ :=
  riemannZeta (2 * z + 2 + Complex.I * (T : ℂ)) + riemannZeta (2 * z + 2 - Complex.I * (T : ℂ))

/-- The normalised model, `1` at the centre. -/
def F (T : ℝ) (z : ℂ) : ℂ := G T z / G T 0

/-- The zeros of `x ↦ Re ζ(x + iT)` on the open segment `(1/2, 2)`. -/
def reZeroSet (T : ℝ) : Set ℝ :=
  {x : ℝ | x ∈ Set.Ioo (1/2 : ℝ) 2 ∧ (riemannZeta ((x : ℂ) + T * Complex.I)).re = 0}

/-- **The Dirichlet tail on `Re s = 2`.** `‖ζ(s) − 1‖ ≤ π²/6 − 1 < 1`. -/
theorem norm_zeta_sub_one_le {s : ℂ} (hs : s.re = 2) :
    ‖riemannZeta s - 1‖ ≤ Real.pi ^ 2 / 6 - 1 := by
  have hs1 : 1 < s.re := by rw [hs]; norm_num
  have hsum0 : Summable (fun n : ℕ => 1 / (n : ℂ) ^ s) :=
    Complex.summable_one_div_nat_cpow.mpr hs1
  have hsum : Summable (fun n : ℕ => 1 / ((n : ℂ) + 1) ^ s) := by
    refine ((summable_nat_add_iff 1).mpr hsum0).congr ?_
    intro n
    rw [show ((n + 1 : ℕ) : ℂ) = (n : ℂ) + 1 by push_cast; ring]
  have hzeta := zeta_eq_tsum_one_div_nat_add_one_cpow hs1
  have hpeel : ∑' n : ℕ, 1 / ((n : ℂ) + 1) ^ s
      = 1 + ∑' n : ℕ, 1 / ((n : ℂ) + 2) ^ s := by
    rw [hsum.tsum_eq_zero_add]
    congr 1
    · norm_num
    · refine tsum_congr ?_
      intro n
      rw [show ((n + 1 : ℕ) : ℂ) + 1 = (n : ℂ) + 2 by push_cast; ring]
  have hnorm : ∀ n : ℕ, ‖(1 : ℂ) / ((n : ℂ) + 2) ^ s‖ = 1 / ((n : ℝ) + 2) ^ 2 := by
    intro n
    have hx : (0:ℝ) < (n : ℝ) + 2 := by positivity
    rw [show ((n : ℂ) + 2) = (((n : ℝ) + 2 : ℝ) : ℂ) by push_cast; ring, norm_div, norm_one,
      Complex.norm_cpow_eq_rpow_re_of_pos hx, hs, ← Real.rpow_natCast ((n:ℝ)+2) 2]
    norm_num
  have hz2 : Summable (fun n : ℕ => 1 / (n : ℝ) ^ 2) := hasSum_zeta_two.summable
  have hg : Summable (fun n : ℕ => 1 / ((n : ℝ) + 1) ^ 2) := by
    refine ((summable_nat_add_iff 1).mpr hz2).congr ?_
    intro n
    rw [show ((n + 1 : ℕ) : ℝ) = (n : ℝ) + 1 by push_cast; ring]
  have hgt : ∑' n : ℕ, 1 / ((n : ℝ) + 1) ^ 2 = Real.pi ^ 2 / 6 := by
    have h0 := hz2.tsum_eq_zero_add
    rw [hasSum_zeta_two.tsum_eq] at h0
    rw [tsum_congr (fun b : ℕ =>
      show (1:ℝ) / ((b + 1 : ℕ) : ℝ) ^ 2 = 1 / ((b : ℝ) + 1) ^ 2 by push_cast; ring)] at h0
    -- the `n = 0` term is `1 / 0 ^ 2 = 0`; rewrite it alone so the tsum body stays an atom
    have hz0 : (1:ℝ) / ((0:ℕ):ℝ) ^ 2 = 0 := by norm_num
    rw [hz0, zero_add] at h0
    linarith [h0]
  have hg2 : Summable (fun n : ℕ => 1 / ((n : ℝ) + 2) ^ 2) := by
    refine ((summable_nat_add_iff 1).mpr hg).congr ?_
    intro n
    rw [show ((n + 1 : ℕ) : ℝ) + 1 = (n : ℝ) + 2 by push_cast; ring]
  have hreal : ∑' n : ℕ, 1 / ((n : ℝ) + 2) ^ 2 = Real.pi ^ 2 / 6 - 1 := by
    have h1 := hg.tsum_eq_zero_add
    rw [hgt] at h1
    rw [tsum_congr (fun b : ℕ =>
      show (1:ℝ) / (((b + 1 : ℕ) : ℝ) + 1) ^ 2 = 1 / ((b : ℝ) + 2) ^ 2 by
        push_cast; ring)] at h1
    have h10 : (1:ℝ) / (((0:ℕ):ℝ) + 1) ^ 2 = 1 := by norm_num
    rw [h10] at h1
    linarith [h1]
  have hnormsum : Summable (fun n : ℕ => ‖(1 : ℂ) / ((n : ℂ) + 2) ^ s‖) :=
    hg2.congr (fun n => (hnorm n).symm)
  have hkey : ‖riemannZeta s - 1‖ = ‖∑' n : ℕ, (1:ℂ) / ((n : ℂ) + 2) ^ s‖ := by
    rw [hzeta, hpeel]
    congr 1
    ring
  rw [hkey]
  calc ‖∑' n : ℕ, (1:ℂ) / ((n : ℂ) + 2) ^ s‖
      ≤ ∑' n : ℕ, ‖(1:ℂ) / ((n : ℂ) + 2) ^ s‖ := norm_tsum_le_tsum_norm hnormsum
    _ = ∑' n : ℕ, 1 / ((n : ℝ) + 2) ^ 2 := tsum_congr hnorm
    _ = Real.pi ^ 2 / 6 - 1 := hreal

/-- **The vertical leg's sign, quantitative.** `Re ζ(2+it) ≥ 2 − π²/6`. -/
theorem re_zeta_two_line_ge (t : ℝ) :
    2 - Real.pi ^ 2 / 6 ≤ (riemannZeta (2 + (t : ℂ) * Complex.I)).re := by
  have hs : (2 + (t : ℂ) * Complex.I).re = 2 := by simp
  have h1 := norm_zeta_sub_one_le hs
  have h2 : |(riemannZeta (2 + (t : ℂ) * Complex.I) - 1).re|
      ≤ ‖riemannZeta (2 + (t : ℂ) * Complex.I) - 1‖ := Complex.abs_re_le_norm _
  rw [show (riemannZeta (2 + (t : ℂ) * Complex.I) - 1).re
      = (riemannZeta (2 + (t : ℂ) * Complex.I)).re - 1 by simp, abs_le] at h2
  linarith [h2.1, h2.2]

/-- **T3, discharged.** `Re ζ(2+it) > 0`. -/
theorem re_zeta_two_line_pos (t : ℝ) : 0 < (riemannZeta (2 + (t : ℂ) * Complex.I)).re := by
  have h := re_zeta_two_line_ge t
  nlinarith [Real.pi_lt_d2, Real.pi_gt_three]

/-- `G_T(0) = 2 Re ζ(2+iT)`, a real number. -/
theorem G_zero_eq (T : ℝ) :
    G T 0 = ((2 * (riemannZeta (2 + Complex.I * (T : ℂ))).re : ℝ) : ℂ) := by
  have hconj : (2 : ℂ) - Complex.I * (T : ℂ) = (starRingEnd ℂ) (2 + Complex.I * (T : ℂ)) := by
    simp [Complex.ext_iff]
  simp only [G, mul_zero, zero_add, hconj, riemannZeta_conj, Complex.add_conj]

/-- On the real axis `G_T` is real: `G_T(x) = 2 Re ζ(2x+2+iT)`. -/
theorem G_real (T : ℝ) (x : ℝ) :
    G T (x : ℂ) = ((2 * (riemannZeta (2 * (x : ℂ) + 2 + Complex.I * (T : ℂ))).re : ℝ) : ℂ) := by
  have hconj : 2 * (x : ℂ) + 2 - Complex.I * (T : ℂ)
      = (starRingEnd ℂ) (2 * (x : ℂ) + 2 + Complex.I * (T : ℂ)) := by
    simp [Complex.ext_iff]
  simp only [G, hconj, riemannZeta_conj, Complex.add_conj]

/-- The centre value is nonzero, so the normalisation is legitimate. -/
theorem G_zero_ne (T : ℝ) : G T 0 ≠ 0 := by
  have hpos : 0 < (riemannZeta (2 + Complex.I * (T : ℂ))).re := by
    have h := re_zeta_two_line_pos T
    rwa [mul_comm ((T : ℂ)) Complex.I] at h
  rw [G_zero_eq, Complex.ofReal_ne_zero]
  exact ne_of_gt (by linarith)

theorem F_zero_eq_one (T : ℝ) : F T 0 = 1 := div_self (G_zero_ne T)

/-- **The pole stays off both arguments.** -/
theorem arg_ne_one {T : ℝ} (hT : 2 ≤ T) {z : ℂ} (hz : ‖z‖ < 11 / 10) :
    2 * z + 2 + Complex.I * (T : ℂ) ≠ 1 ∧ 2 * z + 2 - Complex.I * (T : ℂ) ≠ 1 := by
  have hns : ‖z‖ ^ 2 = z.re * z.re + z.im * z.im := by
    rw [Complex.sq_norm, Complex.normSq_apply]
  constructor
  · intro h
    have hre : (2 * z + 2 + Complex.I * (T : ℂ)).re = 2 * z.re + 2 := by simp
    have him : (2 * z + 2 + Complex.I * (T : ℂ)).im = 2 * z.im + T := by simp
    rw [h, Complex.one_re] at hre
    rw [h, Complex.one_im] at him
    nlinarith [norm_nonneg z]
  · intro h
    have hre : (2 * z + 2 - Complex.I * (T : ℂ)).re = 2 * z.re + 2 := by simp
    have him : (2 * z + 2 - Complex.I * (T : ℂ)).im = 2 * z.im - T := by simp [sub_eq_add_neg]
    rw [h, Complex.one_re] at hre
    rw [h, Complex.one_im] at him
    nlinarith [norm_nonneg z]

theorem F_analytic {T : ℝ} (hT : 2 ≤ T) :
    AnalyticOnNhd ℂ (F T) (Metric.closedBall (0 : ℂ) 1) := by
  intro z hz
  simp only [Metric.mem_closedBall, dist_zero_right] at hz
  have hne := arg_ne_one hT (show ‖z‖ < 11 / 10 by linarith)
  have haff1 : AnalyticAt ℂ (fun w : ℂ => 2 * w + 2 + Complex.I * (T : ℂ)) z :=
    ((analyticAt_const.fun_mul analyticAt_id).fun_add analyticAt_const).fun_add analyticAt_const
  have haff2 : AnalyticAt ℂ (fun w : ℂ => 2 * w + 2 - Complex.I * (T : ℂ)) z :=
    ((analyticAt_const.fun_mul analyticAt_id).fun_add analyticAt_const).fun_sub analyticAt_const
  have h1 : AnalyticAt ℂ (fun w : ℂ => riemannZeta (2 * w + 2 + Complex.I * (T : ℂ))) z :=
    AnalyticAt.fun_comp (analyticAt_riemannZeta hne.1) haff1
  have h2 : AnalyticAt ℂ (fun w : ℂ => riemannZeta (2 * w + 2 - Complex.I * (T : ℂ))) z :=
    AnalyticAt.fun_comp (analyticAt_riemannZeta hne.2) haff2
  show AnalyticAt ℂ (fun w : ℂ =>
    (riemannZeta (2 * w + 2 + Complex.I * (T : ℂ))
      + riemannZeta (2 * w + 2 - Complex.I * (T : ℂ))) / G T 0) z
  exact (h1.fun_add h2).div_const

/-- **The disk bound.** `‖F_T‖ ≤ 80T` on the `15/16` disk. -/
theorem F_bound {T : ℝ} (hT : 2 ≤ T) {z : ℂ} (hz : ‖z‖ ≤ 15 / 16) :
    ‖F T z‖ ≤ 80 * T := by
  have hnum1 : ‖riemannZeta (2 * z + 2 + Complex.I * (T : ℂ))‖ ≤ 28 * T := by
    refine Stage3.zeta_disk_upper hT ?_
    rw [show 2 * z + 2 + Complex.I * (T:ℂ) - (2 + Complex.I * (T:ℂ)) = 2 * z by ring, norm_mul]
    simp only [Complex.norm_ofNat]
    linarith
  have hcj : 2 * z + 2 - Complex.I * (T : ℂ)
      = (starRingEnd ℂ) (2 * (starRingEnd ℂ) z + 2 + Complex.I * (T : ℂ)) := by
    simp [Complex.ext_iff, sub_eq_add_neg]
  have hnum2 : ‖riemannZeta (2 * z + 2 - Complex.I * (T : ℂ))‖ ≤ 28 * T := by
    rw [hcj, riemannZeta_conj, Complex.norm_conj]
    refine Stage3.zeta_disk_upper hT ?_
    rw [show 2 * (starRingEnd ℂ) z + 2 + Complex.I * (T:ℂ) - (2 + Complex.I * (T:ℂ))
        = 2 * (starRingEnd ℂ) z by ring, norm_mul, Complex.norm_conj]
    simp only [Complex.norm_ofNat]
    linarith
  have hG : ‖G T z‖ ≤ 56 * T := by
    simp only [G]
    calc ‖riemannZeta (2 * z + 2 + Complex.I * (T:ℂ))
            + riemannZeta (2 * z + 2 - Complex.I * (T:ℂ))‖
        ≤ ‖riemannZeta (2 * z + 2 + Complex.I * (T:ℂ))‖
            + ‖riemannZeta (2 * z + 2 - Complex.I * (T:ℂ))‖ := norm_add_le _ _
      _ ≤ 56 * T := by linarith
  have hre : 2 - Real.pi ^ 2 / 6 ≤ (riemannZeta (2 + Complex.I * (T : ℂ))).re := by
    have h := re_zeta_two_line_ge T
    rwa [mul_comm ((T : ℂ)) Complex.I] at h
  have hden : (7:ℝ)/10 ≤ ‖G T 0‖ := by
    have hb : (7:ℝ)/10 ≤ 2 * (2 - Real.pi ^ 2 / 6) := by
      nlinarith [Real.pi_lt_d4, Real.pi_gt_three]
    rw [G_zero_eq, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (by linarith)]
    linarith
  have hdenpos : (0:ℝ) < ‖G T 0‖ := by linarith
  simp only [F, norm_div]
  rw [div_le_iff₀ hdenpos]
  calc ‖G T z‖ ≤ 56 * T := hG
    _ = 80 * T * (7/10) := by ring
    _ ≤ 80 * T * ‖G T 0‖ := mul_le_mul_of_nonneg_left hden (by linarith)

/-- Finitely many zeros in the closed unit disk: the template of
`Stage3.zetaWindowTwo_finite`. -/
theorem F_zeros_finite {T : ℝ} (hT : 2 ≤ T) : (SetOfZeros 1 (F T)).Finite := by
  by_contra hinf
  rw [Set.not_finite] at hinf
  have hsub : SetOfZeros 1 (F T) ⊆ Metric.closedBall (0 : ℂ) 1 := fun x hx => by
    simpa only [Metric.mem_closedBall, dist_zero_right] using hx.1
  obtain ⟨x, hxK, hacc⟩ :=
    hinf.exists_accPt_of_subset_isCompact (isCompact_closedBall (0 : ℂ) 1) hsub
  have hFan : AnalyticOnNhd ℂ (F T) (Metric.ball (0 : ℂ) (11 / 10)) := by
    intro w hw
    simp only [Metric.mem_ball, dist_zero_right] at hw
    have hne := arg_ne_one hT hw
    have haff1 : AnalyticAt ℂ (fun v : ℂ => 2 * v + 2 + Complex.I * (T : ℂ)) w :=
      ((analyticAt_const.fun_mul analyticAt_id).fun_add analyticAt_const).fun_add analyticAt_const
    have haff2 : AnalyticAt ℂ (fun v : ℂ => 2 * v + 2 - Complex.I * (T : ℂ)) w :=
      ((analyticAt_const.fun_mul analyticAt_id).fun_add analyticAt_const).fun_sub analyticAt_const
    have h1 : AnalyticAt ℂ (fun v : ℂ => riemannZeta (2 * v + 2 + Complex.I * (T : ℂ))) w :=
      AnalyticAt.fun_comp (analyticAt_riemannZeta hne.1) haff1
    have h2 : AnalyticAt ℂ (fun v : ℂ => riemannZeta (2 * v + 2 - Complex.I * (T : ℂ))) w :=
      AnalyticAt.fun_comp (analyticAt_riemannZeta hne.2) haff2
    show AnalyticAt ℂ (fun v : ℂ =>
      (riemannZeta (2 * v + 2 + Complex.I * (T : ℂ))
        + riemannZeta (2 * v + 2 - Complex.I * (T : ℂ))) / G T 0) w
    exact (h1.fun_add h2).div_const
  have hfeq : Set.EqOn (F T) 0 (Metric.ball (0 : ℂ) (11 / 10)) := by
    refine AnalyticOnNhd.eqOn_zero_of_preconnected_of_mem_closure hFan
      Metric.isPreconnected_ball (z₀ := x) ?_ ?_
    · simp only [Metric.mem_closedBall, dist_zero_right] at hxK
      simp only [Metric.mem_ball, dist_zero_right]
      linarith
    · simp only [mem_closure_iff_clusterPt, ← accPt_principal_iff_clusterPt]
      exact hacc.mono (principal_mono.mpr fun _ h => h.2)
  have h0 := hfeq (Metric.mem_ball_self (by norm_num : (0:ℝ) < 11 / 10))
  rw [F_zero_eq_one T] at h0
  simp at h0

/-- **The Jensen count.** The total order of the zeros of `F_T` in the `7/8`
disk is at most `15 log T + 73`, the arithmetic of
`Stage3.zeta_local_zero_count` run from `log(80T)` in place of `log(84T)`. -/
theorem F_count_le {T : ℝ} (hT : 2 ≤ T) :
    ∑ ρ ∈ (finiteSetOfZeros_mono (by norm_num : (7:ℝ)/8 < 1) (F_zeros_finite hT)).toFinset,
        (analyticOrderNatAt (F T) ρ : ℝ)
      ≤ 15 * Real.log T + 73 := by
  have hrlt1 : (7 : ℝ) / 8 < 1 := by norm_num
  have hZB := ZerosBound (B := 80 * T) (r := 7 / 8) (R := 15 / 16) (f := F T)
    (by norm_num) hrlt1 (by norm_num) (by norm_num) (F_analytic hT)
    (F_zero_eq_one T) (F_zeros_finite hT) (fun z hz => F_bound hT hz)
  rw [Nat.cast_sum, show (15 : ℝ) / 16 / (7 / 8) = 15 / 14 by norm_num] at hZB
  have hlog1514 : (1 : ℝ) / 15 ≤ Real.log (15 / 14) := by
    have h1 : Real.log (14 / 15) ≤ 14 / 15 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
    rw [show (15 : ℝ) / 14 = ((14 : ℝ) / 15)⁻¹ by norm_num, Real.log_inv]
    linarith
  have hlog1514pos : (0 : ℝ) < Real.log (15 / 14) := by linarith
  have hlog80 : Real.log 80 ≤ 4.86 := by
    have h128 : Real.log 80 ≤ Real.log 128 := Real.log_le_log (by norm_num) (by norm_num)
    have h2 : Real.log 128 = 7 * Real.log 2 := by
      rw [show (128 : ℝ) = 2 ^ (7 : ℕ) by norm_num, Real.log_pow]
      norm_num
    have h3 := Real.log_two_lt_d9
    linarith
  have hlog80nn : (0 : ℝ) ≤ Real.log 80 := Real.log_nonneg (by norm_num)
  have hlogT : (0 : ℝ) ≤ Real.log T := Real.log_nonneg (by linarith)
  have hlogB : Real.log (80 * T) = Real.log 80 + Real.log T :=
    Real.log_mul (by norm_num) (by linarith)
  have hinv : 1 / Real.log (15 / 14) ≤ 15 := by
    rw [div_le_iff₀ hlog1514pos]
    linarith
  calc ∑ ρ ∈ (finiteSetOfZeros_mono hrlt1 (F_zeros_finite hT)).toFinset,
        (analyticOrderNatAt (F T) ρ : ℝ)
      ≤ 1 / Real.log (15 / 14) * Real.log (80 * T) := hZB
    _ ≤ 15 * Real.log (80 * T) := by
        refine mul_le_mul_of_nonneg_right hinv ?_
        rw [hlogB]; linarith
    _ = 15 * (Real.log 80 + Real.log T) := by rw [hlogB]
    _ ≤ 15 * Real.log T + 73 := by linarith

/-- The zeros of `Re ζ` on the segment inject into the `7/8` zero set of `F_T`. -/
theorem reZeroSet_finite {T : ℝ} (hT : 2 ≤ T) : (reZeroSet T).Finite := by
  have hinj : Function.Injective (fun x : ℝ => (((x : ℂ) - 2) / 2)) := by
    intro a b hab
    have h : (a : ℂ) = (b : ℂ) := by
      simp only at hab
      linear_combination 2 * hab
    exact_mod_cast h
  have hpre : ((fun x : ℝ => (((x : ℂ) - 2) / 2)) ⁻¹' (SetOfZeros (7/8) (F T))).Finite :=
    Set.Finite.preimage (Set.injOn_of_injective hinj)
      (finiteSetOfZeros_mono (by norm_num : (7:ℝ)/8 < 1) (F_zeros_finite hT))
  refine Set.Finite.subset hpre ?_
  intro x hx
  simp only [reZeroSet, Set.mem_setOf_eq] at hx
  obtain ⟨hxIoo, hxre⟩ := hx
  simp only [Set.mem_preimage, SetOfZeros, Set.mem_setOf_eq]
  have hcast : ((x : ℂ) - 2) / 2 = (((x - 2) / 2 : ℝ) : ℂ) := by push_cast; ring
  constructor
  · rw [hcast, Complex.norm_real, Real.norm_eq_abs, abs_le]
    constructor <;> linarith [hxIoo.1, hxIoo.2]
  · have hG : G T (((x : ℂ) - 2) / 2) = 0 := by
      rw [hcast, G_real T ((x - 2) / 2),
        show 2 * ((((x - 2) / 2 : ℝ)) : ℂ) + 2 + Complex.I * (T : ℂ)
          = (x : ℂ) + (T : ℂ) * Complex.I by push_cast; ring, hxre]
      norm_num
    show G T (((x : ℂ) - 2) / 2) / G T 0 = 0
    rw [hG, zero_div]

/-- The zeros of `Re ζ` on the segment, as a `Finset`. -/
def reZeros {T : ℝ} (hT : 2 ≤ T) : Finset ℝ := (reZeroSet_finite hT).toFinset

theorem mem_reZeros {T : ℝ} (hT : 2 ≤ T) {x : ℝ} :
    x ∈ reZeros hT ↔
      x ∈ Set.Ioo (1/2 : ℝ) 2 ∧ (riemannZeta ((x : ℂ) + T * Complex.I)).re = 0 := by
  simp only [reZeros, Set.Finite.mem_toFinset, reZeroSet, Set.mem_setOf_eq]

/-- **Z2, with its bound.** `q(T) ≤ 15 log T + 73`. -/
theorem card_reZeros_le {T : ℝ} (hT : 2 ≤ T) :
    ((reZeros hT).card : ℝ) ≤ 15 * Real.log T + 73 := by
  have h78 : (7:ℝ)/8 < 1 := by norm_num
  have hball : AnalyticOnNhd ℂ (F T) (Metric.ball (0:ℂ) 1) :=
    (F_analytic hT).mono Metric.ball_subset_closedBall
  have hone : ∀ ρ ∈ (finiteSetOfZeros_mono h78 (F_zeros_finite hT)).toFinset,
      1 ≤ analyticOrderNatAt (F T) ρ := by
    intro ρ hρ
    rw [Set.Finite.mem_toFinset] at hρ
    obtain ⟨hn, hz⟩ := hρ
    have hAn : AnalyticAt ℂ (F T) ρ := by
      refine F_analytic hT ρ ?_
      simp only [Metric.mem_closedBall, dist_zero_right]
      linarith
    have hne0 : analyticOrderAt (F T) ρ ≠ 0 := hAn.analyticOrderAt_ne_zero.mpr hz
    have hnetop : analyticOrderAt (F T) ρ ≠ ⊤ := by
      intro htop
      have hev : ∀ᶠ z in nhds ρ, F T z = 0 := analyticOrderAt_eq_top.mp htop
      have hmem : ρ ∈ Metric.ball (0:ℂ) 1 := by
        simp only [Metric.mem_ball, dist_zero_right]; linarith
      have heq : Set.EqOn (F T) 0 (Metric.ball (0:ℂ) 1) :=
        hball.eqOn_zero_of_preconnected_of_eventuallyEq_zero Metric.isPreconnected_ball hmem
          (by filter_upwards [hev] with z hz using hz)
      have h0 := heq (Metric.mem_ball_self (by norm_num : (0:ℝ) < 1))
      rw [F_zero_eq_one T] at h0
      simp at h0
    rw [Nat.one_le_iff_ne_zero]
    intro h
    rcases ENat.toNat_eq_zero.mp h with h | h
    · exact hne0 h
    · exact hnetop h
  have hcard : (reZeros hT).card
      ≤ ((finiteSetOfZeros_mono h78 (F_zeros_finite hT)).toFinset).card := by
    refine Finset.card_le_card_of_injOn (fun x : ℝ => (((x : ℂ) - 2) / 2)) ?_ ?_
    · intro x hx
      rw [Finset.mem_coe, mem_reZeros hT] at hx
      rw [Finset.mem_coe, Set.Finite.mem_toFinset]
      obtain ⟨hxIoo, hxre⟩ := hx
      simp only [SetOfZeros, Set.mem_setOf_eq]
      have hcast : ((x : ℂ) - 2) / 2 = (((x - 2) / 2 : ℝ) : ℂ) := by push_cast; ring
      constructor
      · rw [hcast, Complex.norm_real, Real.norm_eq_abs, abs_le]
        constructor <;> linarith [hxIoo.1, hxIoo.2]
      · have hG : G T (((x : ℂ) - 2) / 2) = 0 := by
          rw [hcast, G_real T ((x - 2) / 2),
            show 2 * ((((x - 2) / 2 : ℝ)) : ℂ) + 2 + Complex.I * (T : ℂ)
              = (x : ℂ) + (T : ℂ) * Complex.I by push_cast; ring, hxre]
          norm_num
        show G T (((x : ℂ) - 2) / 2) / G T 0 = 0
        rw [hG, zero_div]
    · intro a _ b _ hab
      have h : (a : ℂ) = (b : ℂ) := by
        simp only at hab
        linear_combination 2 * hab
      exact_mod_cast h
  have hsum : (((finiteSetOfZeros_mono h78 (F_zeros_finite hT)).toFinset).card : ℝ)
      ≤ ∑ ρ ∈ (finiteSetOfZeros_mono h78 (F_zeros_finite hT)).toFinset,
          (analyticOrderNatAt (F T) ρ : ℝ) := by
    rw [Finset.card_eq_sum_ones ((finiteSetOfZeros_mono h78 (F_zeros_finite hT)).toFinset)]
    push_cast
    refine Finset.sum_le_sum ?_
    intro ρ hρ
    exact_mod_cast hone ρ hρ
  calc ((reZeros hT).card : ℝ)
      ≤ (((finiteSetOfZeros_mono h78 (F_zeros_finite hT)).toFinset).card : ℝ) := by
        exact_mod_cast hcard
    _ ≤ ∑ ρ ∈ (finiteSetOfZeros_mono h78 (F_zeros_finite hT)).toFinset,
          (analyticOrderNatAt (F T) ρ : ℝ) := hsum
    _ ≤ 15 * Real.log T + 73 := F_count_le hT

/-- info: 'ReZetaCount.re_zeta_two_line_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms re_zeta_two_line_pos

/-- info: 'ReZetaCount.F_count_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms F_count_le

/-- info: 'ReZetaCount.mem_reZeros' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mem_reZeros

/-- info: 'ReZetaCount.card_reZeros_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms card_reZeros_le

end

end ReZetaCount
