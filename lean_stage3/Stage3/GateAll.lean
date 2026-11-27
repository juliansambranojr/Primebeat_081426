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
