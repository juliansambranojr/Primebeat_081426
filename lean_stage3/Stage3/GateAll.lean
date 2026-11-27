/-
GateAll — the explicit-formula route's window at every depth, with the constant named.

`GateEval.gate_hyp_of_RH` reads the route at depth six. `window_414_of_RH` reads it at any
window `n` whose bottom sits at least 72 rows up, `x₀ = 2^36`: under RH the rows of `π` meet
`StmtRelErrWindow` against the main term with `ρ = 414·(log 2·r)·2^(−(r−n)/2)`. The gate's
arithmetic for each depth is done in the table's tree (`lean/RHDepths.lean`), welded by statement.
-/
import Stage3.GateEval

namespace GateAll

/-- **The route's window, every depth, constant `414`.** -/
theorem window_414_of_RH (hRH : RiemannHypothesis) {r : ℤ} {n : ℕ}
    (hn : (72 : ℝ) ≤ (r : ℝ) - n) :
    JointDialGate.StmtRelErrWindow
        (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
        (fun m : ℤ => 2 / Real.log 2
          + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r n
        (414 * (Real.log 2 * r) ^ 1 * (2 : ℝ) ^ (-(((r : ℝ) - n) / 2))) := by
  have hx₀ : (16:ℝ) ≤ (2:ℝ) ^ (36:ℕ) := by norm_num
  have hbot : ((2:ℝ) ^ (36:ℕ)) ^ 2 ≤ (2 : ℝ) ^ ((r : ℝ) - n) := by
    have h1 : ((2:ℝ) ^ (36:ℕ)) ^ 2 = (2:ℝ) ^ ((72:ℕ):ℝ) := by
      rw [Real.rpow_natCast]; norm_num
    rw [h1]
    exact Real.rpow_le_rpow_of_exponent_le (by norm_num) (by push_cast; linarith)
  have hW := RouteNum.relErrWindow_route_num hRH hx₀ r n hbot
  have hr0 : (0:ℝ) < r := by
    have : (0:ℝ) ≤ n := Nat.cast_nonneg n
    linarith
  have hP0 : (0:ℝ) ≤ (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-(((r:ℝ) - n) / 2)) := by
    have hl : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
    have := Real.rpow_pos_of_pos (show (0:ℝ) < 2 by norm_num) (-(((r:ℝ) - n) / 2))
    positivity
  intro k hk
  have h := hW k hk
  have hle : Stage3.routeConst ((2:ℝ) ^ (36:ℕ)) * (Real.log 2 * r) ^ 1
        * (2:ℝ) ^ (-(((r:ℝ) - n) / 2))
      ≤ 414 * (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-(((r:ℝ) - n) / 2)) := by
    have := mul_le_mul_of_nonneg_right GateEval.routeConst_le hP0
    linarith
  have hpow : (0:ℝ) ≤ (2:ℝ) ^ ((r:ℝ) - k) := (Real.rpow_pos_of_pos (by norm_num) _).le
  calc _ ≤ _ := h
    _ ≤ _ := mul_le_mul_of_nonneg_right hle hpow

end GateAll

/-- info: 'GateAll.window_414_of_RH' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms GateAll.window_414_of_RH

namespace GateAll
open Finset

theorem floor_bound40 {c1 c3 c4 ℓ : ℝ} (hc1' : c1 ≤ 88216610000)
    (hc3' : c3 ≤ 15) (hc4' : c4 ≤ 6468930000) (hℓ : 27.72 ≤ ℓ) :
    3 * (4 + (16 + 16 * 112 + 16 * 0) / ℓ + (8 * 698 + 8 + 4 * 0) / ℓ ^ 2
        + 18 * c1 / ((2:ℝ) ^ (40:ℕ) * (2:ℝ) ^ (20:ℕ)) + c3 / ((2:ℝ) ^ (20:ℕ) * ℓ)
        + c4 * (1 / (2:ℝ) ^ (10:ℕ)) / (2:ℝ) ^ (20:ℕ)) + 13 ≤ 263 := by
  have hℓ0 : (0:ℝ) < ℓ := by linarith
  have h1 : (16 + 16 * 112 + 16 * 0 : ℝ) / ℓ ≤ 65.81 := by
    rw [div_le_iff₀ hℓ0]; nlinarith
  have h2 : (8 * 698 + 8 + 4 * 0 : ℝ) / ℓ ^ 2 ≤ 7.28 := by
    rw [div_le_iff₀ (by positivity)]; nlinarith [mul_le_mul hℓ hℓ (by norm_num) hℓ0.le]
  have h3 : 18 * c1 / ((2:ℝ) ^ (40:ℕ) * (2:ℝ) ^ (20:ℕ)) ≤ 0.001 := by
    rw [div_le_iff₀ (by positivity)]; norm_num; linarith
  have h4 : c3 / ((2:ℝ) ^ (20:ℕ) * ℓ) ≤ 0.001 := by
    rw [div_le_iff₀ (by positivity)]; norm_num; nlinarith
  have h5 : c4 * (1 / (2:ℝ) ^ (10:ℕ)) / (2:ℝ) ^ (20:ℕ) ≤ 6.03 := by
    rw [div_le_iff₀ (by positivity)]; norm_num; linarith
  linarith

/-- The route constant at the floor `2^40` is at most `263`. -/
theorem routeConst_le40 : Stage3.routeConst ((2:ℝ) ^ (40:ℕ)) ≤ 263 := by
  have hlog : Real.log ((2:ℝ) ^ (40:ℕ)) = 40 * Real.log 2 := by
    rw [Real.log_pow]; push_cast; ring
  have hsqrt : Real.sqrt ((2:ℝ) ^ (40:ℕ)) = (2:ℝ) ^ (20:ℕ) := by
    rw [show (2:ℝ) ^ (40:ℕ) = ((2:ℝ) ^ (20:ℕ)) ^ 2 by norm_num, Real.sqrt_sq (by positivity)]
  have hq : ((2:ℝ) ^ (40:ℕ)) ^ (-(1:ℝ) / 4) = 1 / (2:ℝ) ^ (10:ℕ) := by
    have h1 : (2:ℝ) ^ (40:ℕ) = ((2:ℝ) ^ (10:ℕ)) ^ ((4:ℕ):ℝ) := by
      rw [Real.rpow_natCast]; norm_num
    rw [h1, ← Real.rpow_mul (by positivity)]
    have h2 : ((4:ℕ):ℝ) * (-(1:ℝ) / 4) = -1 := by norm_num
    rw [h2, Real.rpow_neg_one, one_div]
  have hℓ : (27.72:ℝ) ≤ 40 * Real.log 2 := by
    have := Real.log_two_gt_d9; linarith
  unfold Stage3.routeConst Stage3.floorConstSplit Stage3.floorConst
  rw [hlog, hsqrt, hq]
  exact floor_bound40 RouteNum.c1n_le RouteNum.c3n_le RouteNum.c4n_le hℓ

/-- **The route's window at the floor `2^40`, constant `263`.** -/
theorem window_263_of_RH (hRH : RiemannHypothesis) {r : ℤ} {n : ℕ}
    (hn : (80 : ℝ) ≤ (r : ℝ) - n) :
    JointDialGate.StmtRelErrWindow
        (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
        (fun m : ℤ => 2 / Real.log 2
          + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r n
        (263 * (Real.log 2 * r) ^ 1 * (2 : ℝ) ^ (-(((r : ℝ) - n) / 2))) := by
  have hx₀ : (16:ℝ) ≤ (2:ℝ) ^ (40:ℕ) := by norm_num
  have hbot : ((2:ℝ) ^ (40:ℕ)) ^ 2 ≤ (2 : ℝ) ^ ((r : ℝ) - n) := by
    have h1 : ((2:ℝ) ^ (40:ℕ)) ^ 2 = (2:ℝ) ^ ((80:ℕ):ℝ) := by
      rw [Real.rpow_natCast]; norm_num
    rw [h1]
    exact Real.rpow_le_rpow_of_exponent_le (by norm_num) (by push_cast; linarith)
  have hW := RouteNum.relErrWindow_route_num hRH hx₀ r n hbot
  have hr0 : (0:ℝ) < r := by
    have : (0:ℝ) ≤ n := Nat.cast_nonneg n
    linarith
  have hP0 : (0:ℝ) ≤ (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-(((r:ℝ) - n) / 2)) := by
    have hl : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
    have := Real.rpow_pos_of_pos (show (0:ℝ) < 2 by norm_num) (-(((r:ℝ) - n) / 2))
    positivity
  intro k hk
  have h := hW k hk
  have hle : Stage3.routeConst ((2:ℝ) ^ (40:ℕ)) * (Real.log 2 * r) ^ 1
        * (2:ℝ) ^ (-(((r:ℝ) - n) / 2))
      ≤ 263 * (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-(((r:ℝ) - n) / 2)) := by
    have := mul_le_mul_of_nonneg_right routeConst_le40 hP0
    linarith
  have hpow : (0:ℝ) ≤ (2:ℝ) ^ ((r:ℝ) - k) := (Real.rpow_pos_of_pos (by norm_num) _).le
  calc _ ≤ _ := h
    _ ≤ _ := mul_le_mul_of_nonneg_right hle hpow

end GateAll

/-- info: 'GateAll.window_263_of_RH' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms GateAll.window_263_of_RH
