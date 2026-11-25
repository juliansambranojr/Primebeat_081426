/-
DigammaBoundSize — block S13 of `lean_stage3/design/stencil.md`, B4 step 2, the sizes of `H_w`
and of `V`. 2026-11-25.

From `DigammaBoundIdentity.V_eq_sum_H`, `V(w) = Σ_j Q_j (−1/L)^j H_w^{(j)}(w)`. Cauchy's
estimate on the circle of radius `R` about `w` (Mathlib's
`Complex.norm_iteratedDeriv_le_of_forall_mem_sphere_norm_le`) bounds the `j`-th term by
`|Q_j| j! M (LR)^{−j}`, `M` a bound for `‖H_w‖` on the circle. So for `LR ≥ 1`
(`V_norm_le`, `V_sub_le`), with `K_Q = Σ_j |Q_j| j!`:

  `‖V(w)‖ ≤ K_Q M`,   `‖V(w) − Q(0) ζ(w)‖ ≤ K_Q M/(LR)`.

The size of `H_w`. `‖H_w(z)‖ = ‖ζ(z)‖ · ‖Gammaℝ z‖/‖Gammaℝ w‖ · T^{−(Re z − Re w)/2}` at
`L = log T`. By the tree's crude Stirling for `‖Gammaℝ‖` (`ApproxBounds.log_norm_Gammaℝ_approx`,
error `gErr`), the `Re`-shift of `log ‖Gammaℝ‖` at height `y` is `(Re z − Re w)·lY(y/2)/2` up to
`O(1)`, and `lY(y/2) = log T + O(1)` for `y ∈ [T/8, 3T]` (`lY_bounds`); the heights differ by at
most `1`, so the `−π|y|/4` terms differ by `O(1)`. Hence the ratio times `T^{−Δ/2}` is at most a
constant `B` (`gamma_ratio`): no factor growing with `T` is lost. (Computed before proving,
scratchpad `digamma/hsize.py`, mpmath: the ratio is at most `6.0` at `T = 10², 10⁴, 10⁸` on
the circles used below.)

* The right edge, `w = 3 + t i`, `R = 1`: the circle has `Re z ≥ 2`, `‖ζ‖ ≤ π²/6`
  (`zeta_norm_le_two`), so `‖V − ζ‖ ≤ 2 K_Q B/L` when `Q(0) = 1`, and
  `Re V ≥ 2 − π²/6 − 1/100 ≥ 1/3` once `L ≥ 400 K_Q B` (with `Re ζ(3 + it) ≥ 2 − π²/6` from
  `LevinsonSize.norm_G_sub_one_le` at `c = 0`).
* The discs, `‖w − (3 + t i)‖ ≤ 21/8`, `R = 1/8`: the circle has `Re z ≥ 1/4`, `Im z ≥ 1`, so
  `‖ζ z‖ ≤ 2 + 4‖z‖ ≤ 5t` (`LevinsonEdge.zeta_norm_le`), and `‖V(w)‖ ≤ 5 K_Q B t` once `L ≥ 8`.

  | name               | statement                                                            | status |
  |--------------------|----------------------------------------------------------------------|--------|
  | `lY_bounds`        | `16 ≤ T`, `y ∈ [T/8, 3T]` ⊢ `log T − 3 ≤ lY(y/2) ≤ log T + 1`          | PROVED |
  | `gErr_le`          | `r ∈ [1/8, 7/2]` ⊢ `gErr r ≤ 58`                                       | PROVED |
  | `gamma_ratio`      | `∃ B > 0`, `‖Gammaℝ z‖/‖Gammaℝ w‖ · e^{−(log T/2)(Re z − Re w)} ≤ B` for `Re ∈ [1/4, 7]`, `Im ∈ [T/8, 3T]`, `|Im z − Im w| ≤ 1`, `T ≥ 16` | PROVED |
  | `norm_H`           | `‖H_w z‖ = ‖ζ z‖ · ‖Gammaℝ z‖/‖Gammaℝ w‖ · e^{−(L/2)(Re z − Re w)}`    | PROVED |
  | `V_norm_le`        | `1 ≤ LR`, `H_w` differentiable on the closed disc, `‖H_w‖ ≤ M` on the circle ⊢ `‖V w‖ ≤ K_Q M` | PROVED |
  | `V_sub_le`         | the same ⊢ `‖V w − Q(0) ζ w‖ ≤ K_Q M/(LR)`                              | PROVED |
  | `zeta_norm_le_two` | `2 ≤ Re z` ⊢ `‖ζ z‖ ≤ π²/6`                                            | PROVED |

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.DigammaBoundIdentity
import Stage3.ApproxBounds

noncomputable section

namespace DigammaBound

open Complex Polynomial Filter Topology Metric

/-- `lY(y/2) = log T + O(1)` on `[T/8, 3T]`. -/
theorem lY_bounds {T y : ℝ} (hT : 16 ≤ T) (h1 : T / 8 ≤ y) (h2 : y ≤ 3 * T) :
    Real.log T - 3 ≤ ApproxBounds.lY (y / 2) ∧ ApproxBounds.lY (y / 2) ≤ Real.log T + 1 := by
  unfold ApproxBounds.lY
  have hTpos : 0 < T := by linarith
  have hl2 := Real.log_two_lt_d9
  have hlT2 : Real.log (T ^ 2) = 2 * Real.log T := by
    rw [Real.log_pow]; push_cast; ring
  constructor
  · have hle : T ^ 2 / 256 ≤ 1 + (y / 2) ^ 2 := by nlinarith
    have h := Real.log_le_log (by positivity) hle
    rw [Real.log_div (by positivity) (by norm_num), hlT2] at h
    have h256 : Real.log (256 : ℝ) = 8 * Real.log 2 := by
      rw [show (256 : ℝ) = 2 ^ 8 by norm_num, Real.log_pow]; push_cast; ring
    rw [h256] at h
    linarith
  · have hle : 1 + (y / 2) ^ 2 ≤ 3 * T ^ 2 := by nlinarith
    have h := Real.log_le_log (by positivity) hle
    rw [Real.log_mul (by norm_num) (by positivity), hlT2] at h
    have h3 : Real.log 3 ≤ 2 := by
      have := Real.log_le_sub_one_of_pos (show (0 : ℝ) < 3 by norm_num)
      linarith
    linarith

/-- The Stirling error is bounded on `[1/8, 7/2]`. -/
theorem gErr_le {r : ℝ} (h1 : 1 / 8 ≤ r) (h2 : r ≤ 7 / 2) : ApproxBounds.gErr r ≤ 58 := by
  unfold ApproxBounds.gErr
  have hr : 0 < r := by linarith
  have ha : |r - 1 / 2| ≤ 3 := by rw [abs_le]; constructor <;> linarith
  have hinv : 1 / r ≤ 8 := by rw [div_le_iff₀ hr]; linarith
  have hlog : |Real.log r| ≤ 8 := by
    rw [abs_le]
    constructor
    · have h := Real.log_le_sub_one_of_pos (inv_pos.mpr hr)
      rw [Real.log_inv] at h
      have : r⁻¹ ≤ 8 := by rw [inv_eq_one_div]; exact hinv
      linarith
    · have := Real.log_le_sub_one_of_pos hr
      linarith
  have hl2 : Real.log 2 ≤ 1 := by have := Real.log_two_lt_d9; linarith
  have hl20 : 0 ≤ Real.log 2 := Real.log_nonneg (by norm_num)
  have hb : 0 ≤ 2 + 1 / r + |Real.log r| + Real.log 2 := by positivity
  have hm := mul_le_mul ha (show 2 + 1 / r + |Real.log r| + Real.log 2 ≤ 2 + 8 + 8 + 1 by linarith)
    hb (by norm_num)
  linarith

/-- `log Γ` is bounded on `[1/8, 7/2]`. -/
theorem logGamma_bound : ∃ C : ℝ, ∀ r ∈ Set.Icc (1 / 8 : ℝ) (7 / 2),
    |Real.log (Real.Gamma r)| ≤ C := by
  have hc : ContinuousOn (fun r => Real.log (Real.Gamma r)) (Set.Icc (1 / 8 : ℝ) (7 / 2)) := by
    intro r hr
    have hr0 : 0 < r := by linarith [hr.1]
    have hd : DifferentiableAt ℝ Real.Gamma r := Real.differentiableAt_Gamma (fun m h => by
      have : (0 : ℝ) ≤ m := Nat.cast_nonneg m
      linarith)
    exact (hd.continuousAt.log (Real.Gamma_pos_of_pos hr0).ne').continuousWithinAt
  obtain ⟨C, hC⟩ := isCompact_Icc.exists_bound_of_continuousOn hc
  exact ⟨C, fun r hr => by simpa [Real.norm_eq_abs] using hC r hr⟩

/-- A product of two bounded reals. -/
theorem mul_le_of_abs {a b A B : ℝ} (ha : |a| ≤ A) (hb : |b| ≤ B) : a * b ≤ A * B := by
  have h1 : a * b ≤ |a * b| := le_abs_self _
  rw [abs_mul] at h1
  have h2 : |a| * |b| ≤ A * B := mul_le_mul ha hb (abs_nonneg _) (le_trans (abs_nonneg _) ha)
  linarith

/-- **The ratio of `Gammaℝ` at nearby heights, with the shift taken out.** -/
theorem gamma_ratio : ∃ B : ℝ, 0 < B ∧ ∀ T : ℝ, 16 ≤ T → ∀ z w : ℂ,
    1 / 4 ≤ z.re → z.re ≤ 7 → 1 / 4 ≤ w.re → w.re ≤ 7 →
    T / 8 ≤ z.im → z.im ≤ 3 * T → T / 8 ≤ w.im → w.im ≤ 3 * T → |z.im - w.im| ≤ 1 →
    ‖Gammaℝ z‖ / ‖Gammaℝ w‖ * Real.exp (-(Real.log T / 2) * (z.re - w.re)) ≤ B := by
  obtain ⟨C, hC⟩ := logGamma_bound
  refine ⟨Real.exp (2 * |C| + 160), Real.exp_pos _, ?_⟩
  intro T hT z w hz1 hz2 hw1 hw2 hzy1 hzy2 hwy1 hwy2 hzw
  have hzr : 0 < z.re := by linarith
  have hwr : 0 < w.re := by linarith
  have hGz : 0 < ‖Gammaℝ z‖ := norm_pos_iff.mpr (Gammaℝ_ne_zero_of_re_pos hzr)
  have hGw : 0 < ‖Gammaℝ w‖ := norm_pos_iff.mpr (Gammaℝ_ne_zero_of_re_pos hwr)
  have ez := abs_le.mp (ApproxBounds.log_norm_Gammaℝ_approx hzr)
  have ew := abs_le.mp (ApproxBounds.log_norm_Gammaℝ_approx hwr)
  have gz := gErr_le (r := z.re / 2) (by linarith) (by linarith)
  have gw := gErr_le (r := w.re / 2) (by linarith) (by linarith)
  have Cz := abs_le.mp (hC (z.re / 2) ⟨by linarith, by linarith⟩)
  have Cw := abs_le.mp (hC (w.re / 2) ⟨by linarith, by linarith⟩)
  have hCa : C ≤ |C| := le_abs_self C
  have lz := lY_bounds hT hzy1 hzy2
  have lw := lY_bounds hT hwy1 hwy2
  have hpi : Real.log Real.pi ≤ 3 := by
    have := Real.log_le_sub_one_of_pos Real.pi_pos
    linarith [Real.pi_lt_d2]
  have hpi0 : 0 ≤ Real.log Real.pi := Real.log_nonneg (by linarith [Real.pi_gt_three])
  have hmod : ApproxBounds.gRModel z - ApproxBounds.gRModel w
      - (Real.log T / 2) * (z.re - w.re) ≤ 2 * |C| + 44 := by
    unfold ApproxBounds.gRModel ApproxBounds.gModel
    rw [abs_of_pos (show 0 < z.im / 2 by linarith), abs_of_pos (show 0 < w.im / 2 by linarith)]
    have key : -(z.re / 2) * Real.log Real.pi +
          (Real.log (Real.Gamma (z.re / 2)) - Real.log (Real.Gamma (1 / 2)) +
            Real.log Real.pi / 2 - Real.pi * (z.im / 2) / 2 +
            (z.re / 2 - 1 / 2) * ApproxBounds.lY (z.im / 2)) -
        (-(w.re / 2) * Real.log Real.pi +
          (Real.log (Real.Gamma (w.re / 2)) - Real.log (Real.Gamma (1 / 2)) +
            Real.log Real.pi / 2 - Real.pi * (w.im / 2) / 2 +
            (w.re / 2 - 1 / 2) * ApproxBounds.lY (w.im / 2))) -
        Real.log T / 2 * (z.re - w.re)
        = (-(z.re - w.re) / 2) * Real.log Real.pi
          + (Real.log (Real.Gamma (z.re / 2)) - Real.log (Real.Gamma (w.re / 2)))
          - Real.pi / 4 * (z.im - w.im)
          + (z.re / 2 - 1 / 2) * (ApproxBounds.lY (z.im / 2) - Real.log T)
          - (w.re / 2 - 1 / 2) * (ApproxBounds.lY (w.im / 2) - Real.log T) := by ring
    rw [key]
    have t1 : (-(z.re - w.re) / 2) * Real.log Real.pi ≤ 4 * 3 :=
      mul_le_mul (by linarith) hpi hpi0 (by norm_num)
    have t3 : -(Real.pi / 4 * (z.im - w.im)) ≤ 1 := by
      have := abs_le.mp hzw
      nlinarith [Real.pi_lt_d2, Real.pi_pos]
    have t4 := mul_le_of_abs (a := z.re / 2 - 1 / 2) (b := ApproxBounds.lY (z.im / 2) - Real.log T)
      (A := 3) (B := 3) (by rw [abs_le]; constructor <;> linarith)
      (by rw [abs_le]; constructor <;> linarith [lz.1, lz.2])
    have t5 := mul_le_of_abs (a := -(w.re / 2 - 1 / 2))
      (b := ApproxBounds.lY (w.im / 2) - Real.log T)
      (A := 3) (B := 3) (by rw [abs_le]; constructor <;> linarith)
      (by rw [abs_le]; constructor <;> linarith [lw.1, lw.2])
    have e5 : -(w.re / 2 - 1 / 2) * (ApproxBounds.lY (w.im / 2) - Real.log T)
        = -((w.re / 2 - 1 / 2) * (ApproxBounds.lY (w.im / 2) - Real.log T)) := by ring
    rw [e5] at t5
    linarith [Cz.1, Cz.2, Cw.1, Cw.2]
  have hlog : Real.log ‖Gammaℝ z‖ - Real.log ‖Gammaℝ w‖
      - (Real.log T / 2) * (z.re - w.re) ≤ 2 * |C| + 160 := by
    linarith [ez.1, ez.2, ew.1, ew.2]
  calc ‖Gammaℝ z‖ / ‖Gammaℝ w‖ * Real.exp (-(Real.log T / 2) * (z.re - w.re))
      = Real.exp (Real.log ‖Gammaℝ z‖ - Real.log ‖Gammaℝ w‖
          - (Real.log T / 2) * (z.re - w.re)) := by
        rw [show Real.log ‖Gammaℝ z‖ - Real.log ‖Gammaℝ w‖ - (Real.log T / 2) * (z.re - w.re)
            = (Real.log ‖Gammaℝ z‖ - Real.log ‖Gammaℝ w‖)
              + (-(Real.log T / 2) * (z.re - w.re)) by ring,
          Real.exp_add, Real.exp_sub, Real.exp_log hGz, Real.exp_log hGw]
    _ ≤ Real.exp (2 * |C| + 160) := Real.exp_le_exp.mpr hlog

/-- The norm of `H_w`. -/
theorem norm_H (L : ℝ) (w z : ℂ) : ‖H L w z‖ = ‖riemannZeta z‖ *
    (‖Gammaℝ z‖ / ‖Gammaℝ w‖ * Real.exp (-(L / 2) * (z.re - w.re))) := by
  have hre : (-((L / 2 : ℝ) : ℂ) * (z - w)).re = -(L / 2) * (z.re - w.re) := by
    simp [Complex.mul_re]
  unfold H
  rw [norm_mul, norm_div, norm_mul, Complex.norm_exp, hre]
  ring

/-- `H_w(w) = ζ(w)`. -/
theorem H_self (L : ℝ) {w : ℂ} (hw : 0 < w.re) : H L w w = riemannZeta w := by
  have hG : Gammaℝ w ≠ 0 := Gammaℝ_ne_zero_of_re_pos hw
  unfold H
  rw [sub_self, mul_zero, Complex.exp_zero, mul_one]
  field_simp

/-- `K_Q = Σ_j |Q_j| j!`. -/
def KQ (Q : ℝ[X]) : ℝ := ∑ j ∈ Finset.range (Q.natDegree + 1), |Q.coeff j| * (j.factorial : ℝ)

theorem KQ_nonneg (Q : ℝ[X]) : 0 ≤ KQ Q :=
  Finset.sum_nonneg fun j _ => by positivity

/-- **One term, by Cauchy's estimate.** -/
theorem term_le (Q : ℝ[X]) {L R M : ℝ} (hL : 0 < L) (hR : 0 < R) {w : ℂ}
    (hd : DifferentiableOn ℂ (H L w) (closedBall w R))
    (hM : ∀ z ∈ sphere w R, ‖H L w z‖ ≤ M) (j : ℕ) :
    ‖((Q.coeff j * (-1 / L) ^ j : ℝ) : ℂ) * iteratedDeriv j (H L w) w‖
      ≤ |Q.coeff j| * (j.factorial : ℝ) * M / (L * R) ^ j := by
  have hdc : DiffContOnCl ℂ (H L w) (ball w R) :=
    DifferentiableOn.diffContOnCl (by rw [closure_ball w hR.ne']; exact hd)
  have hc := Complex.norm_iteratedDeriv_le_of_forall_mem_sphere_norm_le j hR hdc hM
  rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_mul, abs_pow, abs_div, abs_neg, abs_one,
    abs_of_pos hL]
  calc |Q.coeff j| * (1 / L) ^ j * ‖iteratedDeriv j (H L w) w‖
      ≤ |Q.coeff j| * (1 / L) ^ j * (j.factorial * M / R ^ j) :=
        mul_le_mul_of_nonneg_left hc (by positivity)
    _ = |Q.coeff j| * (j.factorial : ℝ) * M / (L * R) ^ j := by
        rw [mul_pow, one_div_pow]
        field_simp

/-- **The size of `V` from the size of `H_w` on a circle.** -/
theorem V_norm_le (Q : ℝ[X]) {L R M : ℝ} (hL : 0 < L) (hR : 0 < R) (hLR : 1 ≤ L * R)
    (hM0 : 0 ≤ M) {w : ℂ} (hw : 0 < w.re) (hw1 : w ≠ 1)
    (hd : DifferentiableOn ℂ (H L w) (closedBall w R))
    (hM : ∀ z ∈ sphere w R, ‖H L w z‖ ≤ M) :
    ‖ConreyCount.V Q L w‖ ≤ KQ Q * M := by
  rw [V_eq_sum_H Q hL.ne' hw hw1]
  refine (norm_sum_le _ _).trans ?_
  unfold KQ
  rw [Finset.sum_mul]
  refine Finset.sum_le_sum fun j _ => (term_le Q hL hR hd hM j).trans ?_
  exact div_le_self (by positivity) (one_le_pow₀ hLR)

/-- **`V` near `Q(0) ζ`, from the size of `H_w` on a circle.** -/
theorem V_sub_le (Q : ℝ[X]) {L R M : ℝ} (hL : 0 < L) (hR : 0 < R) (hLR : 1 ≤ L * R)
    (hM0 : 0 ≤ M) {w : ℂ} (hw : 0 < w.re) (hw1 : w ≠ 1)
    (hd : DifferentiableOn ℂ (H L w) (closedBall w R))
    (hM : ∀ z ∈ sphere w R, ‖H L w z‖ ≤ M) :
    ‖ConreyCount.V Q L w - (Q.coeff 0 : ℂ) * riemannZeta w‖ ≤ KQ Q * M / (L * R) := by
  rw [V_eq_sum_H Q hL.ne' hw hw1, Finset.sum_range_succ']
  have h0 : ((Q.coeff 0 * (-1 / L) ^ 0 : ℝ) : ℂ) * iteratedDeriv 0 (H L w) w
      = (Q.coeff 0 : ℂ) * riemannZeta w := by
    rw [iteratedDeriv_zero, H_self L hw, pow_zero, mul_one]
  rw [h0, add_sub_cancel_right]
  have hLR0 : 0 < L * R := by positivity
  have hK : ∑ j ∈ Finset.range Q.natDegree, |Q.coeff (j + 1)| * ((j + 1).factorial : ℝ) ≤ KQ Q := by
    unfold KQ
    rw [Finset.sum_range_succ']
    have : 0 ≤ |Q.coeff 0| * ((0 : ℕ).factorial : ℝ) := by positivity
    linarith
  refine (norm_sum_le _ _).trans ?_
  calc ∑ j ∈ Finset.range Q.natDegree,
        ‖((Q.coeff (j + 1) * (-1 / L) ^ (j + 1) : ℝ) : ℂ) * iteratedDeriv (j + 1) (H L w) w‖
      ≤ ∑ j ∈ Finset.range Q.natDegree,
          |Q.coeff (j + 1)| * ((j + 1).factorial : ℝ) * M / (L * R) := by
        refine Finset.sum_le_sum fun j _ => (term_le Q hL hR hd hM (j + 1)).trans ?_
        exact div_le_div_of_nonneg_left (by positivity) hLR0
          (le_self_pow₀ hLR (Nat.succ_ne_zero j))
    _ = (∑ j ∈ Finset.range Q.natDegree, |Q.coeff (j + 1)| * ((j + 1).factorial : ℝ)) * M
          / (L * R) := by
        rw [Finset.sum_mul, Finset.sum_div]
    _ ≤ KQ Q * M / (L * R) := by
        gcongr

/-- `‖ζ z‖ ≤ π²/6` on `Re z ≥ 2`. -/
theorem zeta_norm_le_two {z : ℂ} (hz : 2 ≤ z.re) : ‖riemannZeta z‖ ≤ Real.pi ^ 2 / 6 := by
  have hs1 : 1 < z.re := by linarith
  have hA : HasSum (LSeries.term 1 z) (riemannZeta z) := by
    rw [← LSeries_one_eq_riemannZeta hs1]
    exact (LSeriesSummable_one_iff.mpr hs1).LSeriesHasSum
  refine hA.norm_le_of_bounded hasSum_zeta_two (fun n => ?_)
  rcases Nat.eq_zero_or_pos n with hn | hn
  · subst hn
    simp [LSeries.term_def]
  · rw [LSeries.term_def, if_neg hn.ne', Pi.one_apply, norm_div, norm_one,
      Complex.norm_natCast_cpow_of_pos hn]
    have hn1 : (1 : ℝ) ≤ n := by exact_mod_cast hn
    have h2 : (n : ℝ) ^ (2 : ℕ) ≤ (n : ℝ) ^ z.re := by
      rw [← Real.rpow_natCast]
      exact Real.rpow_le_rpow_of_exponent_le hn1 (by push_cast; linarith)
    exact one_div_le_one_div_of_le (by positivity) h2

/-- `Re ζ(3 + t i) ≥ 2 − π²/6`. -/
theorem re_zeta_three_ge (t : ℝ) : 2 - Real.pi ^ 2 / 6 ≤ (riemannZeta (3 + t * I)).re := by
  have h := LevinsonSize.norm_G_sub_one_le (c := 0) le_rfl zero_le_one (s := 3 + t * I)
    (by simp)
  simp only [Complex.ofReal_zero, zero_mul, add_zero] at h
  have h1 : -‖riemannZeta (3 + t * I) - 1‖ ≤ (riemannZeta (3 + t * I) - 1).re :=
    neg_le_of_abs_le (Complex.abs_re_le_norm _)
  rw [Complex.sub_re, Complex.one_re] at h1
  linarith

/-- info: 'DigammaBound.gamma_ratio' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gamma_ratio

/-- info: 'DigammaBound.V_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms V_norm_le

/-- info: 'DigammaBound.V_sub_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms V_sub_le

/-- info: 'DigammaBound.zeta_norm_le_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_norm_le_two

end DigammaBound

end
