/-
GateEval — block E9 of `lean_stage3/design/joints.md`. 2026-11-22.

The table gate's own inequality, evaluated on the explicit-formula route at
the floor `x₀ = 2^36` and depth six.

  floor_bound      the arithmetic of `routeConst` at a floor with
                     √x₀ = 2^18, x₀^(1/4) = 2^9, log x₀ = ℓ ≥ 24.95
  routeConst_le    routeConst (2^36) ≤ 414
  sq_le_two_rpow   80 ≤ r ⊢ r² ≤ 6400·2^((r−80)/2)
  gate_ineq        80 ≤ r ⊢ 414·(log 2·r)^1·2^(−((r−7)/2)) < (log 2)^6/(2·r·3^7)
  gate_hyp_of_RH   RH, 80 ≤ r ⊢ ∃ ρ, StmtRelErrWindow (rows of π) (main term) r (6+1) ρ
                     ∧ ρ < (log 2)^6/(2·r·3^(6+1))

`gate_hyp_of_RH`'s conclusion is, character for character, the hypothesis
`hroute` of `lean/RouteCell.cell_ne_zero_of_route` in the table's tree, with
`RelativeGate.StmtRelErrWindow` there for `JointDialGate.StmtRelErrWindow`
here (welded). The two trees are on different toolchains.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.RouteNum

namespace GateEval

open Finset

noncomputable section

theorem floor_bound {c1 c3 c4 ℓ : ℝ} (hc1' : c1 ≤ 88216610000)
    (hc3' : c3 ≤ 15) (hc4' : c4 ≤ 6468930000) (hℓ : 24.95 ≤ ℓ) :
    3 * (4 + (16 + 16 * 112 + 16 * 0) / ℓ + (8 * 698 + 8 + 4 * 0) / ℓ ^ 2
        + 18 * c1 / ((2:ℝ) ^ (36:ℕ) * (2:ℝ) ^ (18:ℕ)) + c3 / ((2:ℝ) ^ (18:ℕ) * ℓ)
        + c4 * (1 / (2:ℝ) ^ (9:ℕ)) / (2:ℝ) ^ (18:ℕ)) + 13 ≤ 414 := by
  have hℓ0 : (0:ℝ) < ℓ := by linarith
  have h1 : (16 + 16 * 112 + 16 * 0 : ℝ) / ℓ ≤ 72.47 := by
    rw [div_le_iff₀ hℓ0]
    nlinarith
  have h2 : (8 * 698 + 8 + 4 * 0 : ℝ) / ℓ ^ 2 ≤ 8.99 := by
    rw [div_le_iff₀ (by positivity)]
    nlinarith [mul_le_mul hℓ hℓ (by norm_num) hℓ0.le]
  have h3 : 18 * c1 / ((2:ℝ) ^ (36:ℕ) * (2:ℝ) ^ (18:ℕ)) ≤ 0.001 := by
    rw [div_le_iff₀ (by positivity)]
    norm_num
    linarith
  have h4 : c3 / ((2:ℝ) ^ (18:ℕ) * ℓ) ≤ 0.001 := by
    rw [div_le_iff₀ (by positivity)]
    norm_num
    nlinarith
  have h5 : c4 * (1 / (2:ℝ) ^ (9:ℕ)) / (2:ℝ) ^ (18:ℕ) ≤ 48.2 := by
    rw [div_le_iff₀ (by positivity)]
    norm_num
    linarith
  linarith

theorem routeConst_le : Stage3.routeConst ((2:ℝ) ^ (36:ℕ)) ≤ 414 := by
  have hlog : Real.log ((2:ℝ) ^ (36:ℕ)) = 36 * Real.log 2 := by
    rw [Real.log_pow]
    push_cast
    ring
  have hsqrt : Real.sqrt ((2:ℝ) ^ (36:ℕ)) = (2:ℝ) ^ (18:ℕ) := by
    rw [show (2:ℝ) ^ (36:ℕ) = ((2:ℝ) ^ (18:ℕ)) ^ 2 by norm_num, Real.sqrt_sq (by positivity)]
  have hq : ((2:ℝ) ^ (36:ℕ)) ^ (-(1:ℝ) / 4) = 1 / (2:ℝ) ^ (9:ℕ) := by
    have h1 : (2:ℝ) ^ (36:ℕ) = ((2:ℝ) ^ (9:ℕ)) ^ ((4:ℕ):ℝ) := by
      rw [Real.rpow_natCast]
      norm_num
    rw [h1, ← Real.rpow_mul (by positivity)]
    have h2 : ((4:ℕ):ℝ) * (-(1:ℝ) / 4) = -1 := by norm_num
    rw [h2, Real.rpow_neg_one, one_div]
  have hℓ : (24.95:ℝ) ≤ 36 * Real.log 2 := by
    have := Real.log_two_gt_d9
    linarith
  unfold Stage3.routeConst Stage3.floorConstSplit Stage3.floorConst
  rw [hlog, hsqrt, hq]
  exact floor_bound RouteNum.c1n_le RouteNum.c3n_le RouteNum.c4n_le hℓ

theorem sq_le_two_rpow {r : ℝ} (hr : 80 ≤ r) :
    r ^ 2 ≤ 6400 * (2:ℝ) ^ ((r - 80) / 2) := by
  have hL := Real.log_two_gt_d9
  set y : ℝ := Real.log 2 * ((r - 80) / 2) with hy
  have hy0 : 0 ≤ y := by
    rw [hy]
    have : (0:ℝ) ≤ (r - 80) / 2 := by linarith
    positivity
  have hexp : (2:ℝ) ^ ((r - 80) / 2) = Real.exp y := by
    rw [Real.rpow_def_of_pos (by norm_num)]
  have hq := Real.quadratic_le_exp_of_nonneg hy0
  have hs : (0:ℝ) ≤ r - 80 := by linarith
  have hyl : 0.3465 * (r - 80) ≤ y := by
    rw [hy]
    nlinarith
  rw [hexp]
  have h1 : r ^ 2 ≤ 6400 * (1 + y + y ^ 2 / 2) := by
    have hy2 : (0.3465 * (r - 80)) ^ 2 ≤ y ^ 2 :=
      pow_le_pow_left₀ (by positivity) hyl 2
    nlinarith
  linarith

theorem gate_ineq {r : ℝ} (hr : 80 ≤ r) :
    414 * (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-((r - 7) / 2))
      < Real.log 2 ^ 6 / (2 * r * 3 ^ 7) := by
  have hLlo := Real.log_two_gt_d9
  have hL0 : (0:ℝ) < Real.log 2 := by linarith
  have hr0 : (0:ℝ) < r := by linarith
  have hL5 : (0.1599:ℝ) < Real.log 2 ^ 5 := by
    calc (0.1599:ℝ) < 0.6931 ^ 5 := by norm_num
      _ < Real.log 2 ^ 5 := pow_lt_pow_left₀ (by linarith) (by norm_num) (by norm_num)
  set P : ℝ := (2:ℝ) ^ (-((r - 7) / 2)) with hP
  have hP0 : 0 < P := Real.rpow_pos_of_pos (by norm_num) _
  have hsqrt2 : (2:ℝ) ^ ((1:ℝ) / 2) ≤ 1.4143 := by
    rw [← Real.sqrt_eq_rpow]
    calc Real.sqrt 2 ≤ Real.sqrt (1.4143 ^ 2) := Real.sqrt_le_sqrt (by norm_num)
      _ = 1.4143 := Real.sqrt_sq (by norm_num)
  have h37 : (2:ℝ) ^ (-(37:ℝ)) = 1 / (2:ℝ) ^ (37:ℕ) := by
    rw [Real.rpow_neg (by norm_num), ← Real.rpow_natCast, one_div]
    norm_num
  have hprod : (2:ℝ) ^ ((r - 80) / 2) * P = (2:ℝ) ^ (-(37:ℝ)) * (2:ℝ) ^ ((1:ℝ) / 2) := by
    rw [hP, ← Real.rpow_add (by norm_num), ← Real.rpow_add (by norm_num)]
    congr 1
    ring
  have hkey : r ^ 2 * P ≤ 6400 * (1 / (2:ℝ) ^ (37:ℕ) * 1.4143) := by
    calc r ^ 2 * P ≤ 6400 * (2:ℝ) ^ ((r - 80) / 2) * P :=
          mul_le_mul_of_nonneg_right (sq_le_two_rpow hr) hP0.le
      _ = 6400 * ((2:ℝ) ^ ((r - 80) / 2) * P) := by ring
      _ = 6400 * ((2:ℝ) ^ (-(37:ℝ)) * (2:ℝ) ^ ((1:ℝ) / 2)) := by rw [hprod]
      _ ≤ 6400 * (1 / (2:ℝ) ^ (37:ℕ) * 1.4143) := by
          rw [h37]
          apply mul_le_mul_of_nonneg_left ?_ (by norm_num)
          exact mul_le_mul_of_nonneg_left hsqrt2 (by positivity)
  have hnum : (414:ℝ) * (2 * 3 ^ 7) * (6400 * (1 / (2:ℝ) ^ (37:ℕ) * 1.4143)) < 0.1599 := by
    norm_num
  rw [lt_div_iff₀ (by positivity)]
  have hrw : 414 * (Real.log 2 * r) ^ 1 * P * (2 * r * 3 ^ 7)
      = Real.log 2 * (414 * (2 * 3 ^ 7) * (r ^ 2 * P)) := by ring
  rw [hrw]
  have h1 : 414 * (2 * 3 ^ 7) * (r ^ 2 * P)
      ≤ 414 * (2 * 3 ^ 7) * (6400 * (1 / (2:ℝ) ^ (37:ℕ) * 1.4143)) :=
    mul_le_mul_of_nonneg_left hkey (by norm_num)
  have h2 : 414 * (2 * 3 ^ 7) * (r ^ 2 * P) < Real.log 2 ^ 5 := by linarith
  calc Real.log 2 * (414 * (2 * 3 ^ 7) * (r ^ 2 * P))
      < Real.log 2 * Real.log 2 ^ 5 := mul_lt_mul_of_pos_left h2 hL0
    _ = Real.log 2 ^ 6 := by ring

/-- **The gate's two hypotheses, under RH, at depth six from row 80.** -/
theorem gate_hyp_of_RH (hRH : RiemannHypothesis) {r : ℤ} (hr : 80 ≤ r) :
    ∃ ρ : ℝ, JointDialGate.StmtRelErrWindow
        (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
        (fun m : ℤ => 2 / Real.log 2
          + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r (6 + 1) ρ
      ∧ ρ < Real.log 2 ^ 6 / (2 * r * 3 ^ (6 + 1)) := by
  have hrR : (80:ℝ) ≤ (r:ℝ) := by exact_mod_cast hr
  have hx₀ : (16:ℝ) ≤ (2:ℝ) ^ (36:ℕ) := by norm_num
  have hcast : (((6 + 1 : ℕ)) : ℝ) = 7 := by norm_num
  have hbot : ((2:ℝ) ^ (36:ℕ)) ^ 2 ≤ (2 : ℝ) ^ ((r : ℝ) - ((6 + 1 : ℕ) : ℝ)) := by
    rw [hcast]
    have h1 : ((2:ℝ) ^ (36:ℕ)) ^ 2 = (2:ℝ) ^ ((72:ℕ):ℝ) := by
      rw [Real.rpow_natCast]
      norm_num
    rw [h1]
    apply Real.rpow_le_rpow_of_exponent_le (by norm_num)
    push_cast
    linarith
  refine ⟨_, RouteNum.relErrWindow_route_num hRH hx₀ r (6 + 1) hbot, ?_⟩
  rw [hcast]
  have hP0 : (0:ℝ) ≤ (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-(((r:ℝ) - 7) / 2)) := by
    have hl : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
    have hr0 : (0:ℝ) < (r:ℝ) := by linarith
    have := Real.rpow_pos_of_pos (show (0:ℝ) < 2 by norm_num) (-(((r:ℝ) - 7) / 2))
    positivity
  have hle : Stage3.routeConst ((2:ℝ) ^ (36:ℕ)) * (Real.log 2 * r) ^ 1
        * (2:ℝ) ^ (-(((r:ℝ) - 7) / 2))
      ≤ 414 * (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-(((r:ℝ) - 7) / 2)) := by
    have := mul_le_mul_of_nonneg_right routeConst_le hP0
    linarith
  have hg := gate_ineq hrR
  have h3 : ((3:ℝ)) ^ (6 + 1) = 3 ^ 7 := by norm_num
  rw [h3]
  linarith

end

/-- info: 'GateEval.routeConst_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms routeConst_le

/-- info: 'GateEval.gate_ineq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gate_ineq

/-- info: 'GateEval.gate_hyp_of_RH' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gate_hyp_of_RH

end GateEval
