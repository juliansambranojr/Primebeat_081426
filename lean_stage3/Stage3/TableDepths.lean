/-
TableDepths — block E11 of `lean_stage3/design/joints.md`. 2026-11-22.

`TableRoute.cell_ne_zero_of_RH` is depth six. The same route and gate at any
depth, from one numeric check at one row, and the instances that fall inside
the computed table.

  sq_le_gen          6 ≤ r₀ ≤ r ⊢ r² ≤ r₀²·2^((r−r₀)/2)
  gate_ineq_gen      the gate's gap at every r ≥ r₀ from its value at r₀
  cell_ne_zero_gen   RH, the floor, d ≤ 24, the check at r₀, r₀ ≤ r
                       ⊢ Construction.tableFrom TableRoute.rowN r d ≠ 0
  depth_one … depth_eight
                     rows 74, 75, 76, 77, 78, 80, 85, 91

Under RH, at each depth from one to eight, no cell is zero from that row on.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.TableRoute

namespace TableDepths

open Finset

noncomputable section

/-- If `6 ≤ r₀ ≤ r`, then `r² ≤ r₀²·2^((r−r₀)/2)`. -/
theorem sq_le_gen {r₀ r : ℝ} (h6 : 6 ≤ r₀) (hr : r₀ ≤ r) :
    r ^ 2 ≤ r₀ ^ 2 * (2:ℝ) ^ ((r - r₀) / 2) := by
  have hL := Real.log_two_gt_d9
  set s : ℝ := r - r₀ with hs
  have hs0 : 0 ≤ s := by rw [hs]; linarith
  set y : ℝ := Real.log 2 * (s / 2) with hy
  have hy0 : 0 ≤ y := by
    rw [hy]
    have : (0:ℝ) ≤ s / 2 := by linarith
    positivity
  have hexp : (2:ℝ) ^ (s / 2) = Real.exp y := by
    rw [Real.rpow_def_of_pos (by norm_num)]
  have hq := Real.quadratic_le_exp_of_nonneg hy0
  have hyl : 0.3465 * s ≤ y := by
    rw [hy]
    nlinarith
  have hy2 : (0.3465 * s) ^ 2 ≤ y ^ 2 := pow_le_pow_left₀ (by positivity) hyl 2
  have hr0 : (0:ℝ) ≤ r₀ := by linarith
  have ha : 2 * r₀ * s ≤ 0.3465 * r₀ ^ 2 * s := by
    have := mul_nonneg (mul_nonneg hr0 hs0) (by linarith : (0:ℝ) ≤ 0.3465 * r₀ - 2)
    nlinarith
  have hb : s ^ 2 ≤ 0.06 * r₀ ^ 2 * s ^ 2 := by
    have h36 : (36:ℝ) ≤ r₀ ^ 2 := by nlinarith
    have := mul_nonneg (sq_nonneg s) (by linarith : (0:ℝ) ≤ 0.06 * r₀ ^ 2 - 1)
    nlinarith
  have hrs : r = r₀ + s := by rw [hs]; ring
  rw [hexp]
  have h1 : r ^ 2 ≤ r₀ ^ 2 * (1 + 0.3465 * s + (0.3465 * s) ^ 2 / 2) := by
    rw [hrs]
    nlinarith
  have h2 : r₀ ^ 2 * (1 + 0.3465 * s + (0.3465 * s) ^ 2 / 2) ≤ r₀ ^ 2 * Real.exp y := by
    apply mul_le_mul_of_nonneg_left ?_ (sq_nonneg r₀)
    linarith
  linarith

/-- The gate's gap at every row `r ≥ r₀ ≥ 6` from its value at `r₀`: if
`414·(2·3^(d+1))·r₀²·2^(−(r₀−(d+1))/2) ≤ a` and `a·log 2 < (log 2)^d`, then
`414·(log 2·r)·2^(−(r−(d+1))/2) < (log 2)^d / (2·r·3^(d+1))`. -/
theorem gate_ineq_gen (d : ℕ) {r₀ r a : ℝ} (h6 : 6 ≤ r₀) (hr : r₀ ≤ r)
    (hA : 414 * (2 * 3 ^ (d + 1)) * (r₀ ^ 2 * (2:ℝ) ^ (-((r₀ - ((d:ℝ) + 1)) / 2))) ≤ a)
    (ha : a * Real.log 2 < Real.log 2 ^ d) :
    414 * (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-((r - ((d:ℝ) + 1)) / 2))
      < Real.log 2 ^ d / (2 * r * 3 ^ (d + 1)) := by
  have hL0 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have hr0 : (0:ℝ) < r := by linarith
  set P : ℝ := (2:ℝ) ^ (-((r - ((d:ℝ) + 1)) / 2)) with hP
  have hP0 : 0 < P := Real.rpow_pos_of_pos (by norm_num) _
  have hprod : (2:ℝ) ^ ((r - r₀) / 2) * P = (2:ℝ) ^ (-((r₀ - ((d:ℝ) + 1)) / 2)) := by
    rw [hP, ← Real.rpow_add (by norm_num)]
    congr 1
    ring
  have hkey : r ^ 2 * P ≤ r₀ ^ 2 * (2:ℝ) ^ (-((r₀ - ((d:ℝ) + 1)) / 2)) := by
    calc r ^ 2 * P ≤ r₀ ^ 2 * (2:ℝ) ^ ((r - r₀) / 2) * P :=
          mul_le_mul_of_nonneg_right (sq_le_gen h6 hr) hP0.le
      _ = r₀ ^ 2 * ((2:ℝ) ^ ((r - r₀) / 2) * P) := by ring
      _ = r₀ ^ 2 * (2:ℝ) ^ (-((r₀ - ((d:ℝ) + 1)) / 2)) := by rw [hprod]
  rw [lt_div_iff₀ (by positivity)]
  have hrw : 414 * (Real.log 2 * r) ^ 1 * P * (2 * r * 3 ^ (d + 1))
      = Real.log 2 * (414 * (2 * 3 ^ (d + 1)) * (r ^ 2 * P)) := by ring
  rw [hrw]
  have h1 : 414 * (2 * 3 ^ (d + 1)) * (r ^ 2 * P) ≤ a :=
    le_trans (mul_le_mul_of_nonneg_left hkey (by positivity)) hA
  calc Real.log 2 * (414 * (2 * 3 ^ (d + 1)) * (r ^ 2 * P))
      ≤ Real.log 2 * a := mul_le_mul_of_nonneg_left h1 hL0.le
    _ = a * Real.log 2 := by ring
    _ < Real.log 2 ^ d := ha

/-- **The route and the gate at depth `d`.** -/
theorem cell_ne_zero_gen (hRH : RiemannHypothesis) (d : ℕ) {r₀ a : ℝ} (hd : d ≤ 24)
    (hfloor : 72 + ((d:ℝ) + 1) ≤ r₀)
    (hA : 414 * (2 * 3 ^ (d + 1)) * (r₀ ^ 2 * (2:ℝ) ^ (-((r₀ - ((d:ℝ) + 1)) / 2))) ≤ a)
    (ha : a * Real.log 2 < Real.log 2 ^ d)
    {r : ℤ} (hr : r₀ ≤ (r:ℝ)) :
    Construction.tableFrom TableRoute.rowN r d ≠ 0 := by
  have hdR : (d:ℝ) ≤ 24 := by exact_mod_cast hd
  have hd0 : (0:ℝ) ≤ (d:ℝ) := Nat.cast_nonneg d
  have h6 : (6:ℝ) ≤ r₀ := by linarith
  have hx₀ : (16:ℝ) ≤ (2:ℝ) ^ (36:ℕ) := by norm_num
  have hcast : (((d + 1 : ℕ)) : ℝ) = (d:ℝ) + 1 := by push_cast; ring
  have hbot : ((2:ℝ) ^ (36:ℕ)) ^ 2 ≤ (2 : ℝ) ^ ((r : ℝ) - ((d + 1 : ℕ) : ℝ)) := by
    rw [hcast]
    have h1 : ((2:ℝ) ^ (36:ℕ)) ^ 2 = (2:ℝ) ^ ((72:ℕ):ℝ) := by
      rw [Real.rpow_natCast]
      norm_num
    rw [h1]
    apply Real.rpow_le_rpow_of_exponent_le (by norm_num)
    push_cast
    linarith
  have hS := RouteNum.relErrWindow_route_num hRH hx₀ r (d + 1) hbot
  rw [hcast] at hS
  -- the gap
  have hP0 : (0:ℝ) ≤ (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-(((r:ℝ) - ((d:ℝ) + 1)) / 2)) := by
    have hl : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
    have hr0 : (0:ℝ) < (r:ℝ) := by linarith
    have := Real.rpow_pos_of_pos (show (0:ℝ) < 2 by norm_num) (-(((r:ℝ) - ((d:ℝ) + 1)) / 2))
    positivity
  have hle : Stage3.routeConst ((2:ℝ) ^ (36:ℕ)) * (Real.log 2 * r) ^ 1
        * (2:ℝ) ^ (-(((r:ℝ) - ((d:ℝ) + 1)) / 2))
      ≤ 414 * (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-(((r:ℝ) - ((d:ℝ) + 1)) / 2)) := by
    have := mul_le_mul_of_nonneg_right GateEval.routeConst_le hP0
    linarith
  have hρ := lt_of_le_of_lt hle (gate_ineq_gen d h6 hr hA ha)
  -- the window statement against the constructed interpolant
  have hS' : RelativeGate.StmtRelErrWindow
      (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
      (fun k : ℤ => Interpolant.liRow k) r (d + 1)
      (Stage3.routeConst ((2:ℝ) ^ (36:ℕ)) * (Real.log 2 * r) ^ 1
        * (2:ℝ) ^ (-(((r:ℝ) - ((d:ℝ) + 1)) / 2))) := by
    intro k hk
    have hkn : (k : ℝ) ≤ (d:ℝ) + 1 := by
      have := Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
      exact_mod_cast this
    have hm : (1 : ℝ) / 2 ≤ ((r - k : ℤ) : ℝ) := by
      push_cast
      linarith
    have h := hS k hk
    simp only at h ⊢
    rw [Interpolant.liRow_eq hm]
    exact h
  have hlog := Real.log_two_gt_d9
  refine Interpolant.tableFrom_ne_zero_of_relErr_liRow (d := d) ?_ hS' ?_ ?_ hρ
  · intro k _
    unfold TableRoute.rowN Nonvanishing.bdiffZ
    push_cast
    rfl
  · linarith
  · nlinarith

/-- Helper: the real power `2^(−n)` equals `1/2^n` for a natural number `n`. -/
theorem two_rpow_neg_nat (n : ℕ) : (2:ℝ) ^ (-(n:ℝ)) = 1 / (2:ℝ) ^ n := by
  rw [Real.rpow_neg (by norm_num), Real.rpow_natCast, one_div]

/-- Helper: `2^(−n + 1/2) ≤ 1.4143/2^n` for a natural number `n`. -/
theorem two_rpow_neg_nat_half (n : ℕ) : (2:ℝ) ^ (-(n:ℝ) + 1 / 2) ≤ 1.4143 / (2:ℝ) ^ n := by
  rw [Real.rpow_add (by norm_num), two_rpow_neg_nat, ← Real.sqrt_eq_rpow]
  have hs : Real.sqrt 2 ≤ 1.4143 := by
    calc Real.sqrt 2 ≤ Real.sqrt (1.4143 ^ 2) := Real.sqrt_le_sqrt (by norm_num)
      _ = 1.4143 := Real.sqrt_sq (by norm_num)
  have hp : (0:ℝ) < (2:ℝ) ^ n := by positivity
  rw [div_mul_eq_mul_div, one_mul]
  exact div_le_div_of_nonneg_right hs hp.le

/-- Helper: `0.6931^k ≤ (log 2)^k` for every natural number `k`. -/
theorem pow_lower (k : ℕ) : (0.6931:ℝ) ^ k ≤ Real.log 2 ^ k :=
  pow_le_pow_left₀ (by norm_num) (by linarith [Real.log_two_gt_d9]) k

/-- Depth one, from row 74. -/
theorem depth_one (hRH : RiemannHypothesis) {r : ℤ} (hr : 74 ≤ r) :
    Construction.tableFrom TableRoute.rowN r 1 ≠ 0 := by
  have hL0 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  refine cell_ne_zero_gen hRH 1 (r₀ := 74) (a := 0.001) (by norm_num) (by norm_num) ?_ ?_
    (by exact_mod_cast hr)
  · have e : (-(((74:ℝ) - (((1:ℕ):ℝ) + 1)) / 2)) = -((36:ℕ):ℝ) := by norm_num
    rw [e, two_rpow_neg_nat]
    norm_num
  · have := pow_lower 0
    nlinarith

/-- Depth two, from row 75. -/
theorem depth_two (hRH : RiemannHypothesis) {r : ℤ} (hr : 75 ≤ r) :
    Construction.tableFrom TableRoute.rowN r 2 ≠ 0 := by
  have hL0 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  refine cell_ne_zero_gen hRH 2 (r₀ := 75) (a := 0.002) (by norm_num) (by norm_num) ?_ ?_
    (by exact_mod_cast hr)
  · have e : (-(((75:ℝ) - (((2:ℕ):ℝ) + 1)) / 2)) = -((36:ℕ):ℝ) := by norm_num
    rw [e, two_rpow_neg_nat]
    norm_num
  · have h := pow_lower 1
    have : (0.002:ℝ) < Real.log 2 ^ 1 := lt_of_lt_of_le (by norm_num) h
    calc (0.002:ℝ) * Real.log 2 < Real.log 2 ^ 1 * Real.log 2 :=
          mul_lt_mul_of_pos_right this hL0
      _ = Real.log 2 ^ 2 := by ring

/-- Depth three, from row 76. -/
theorem depth_three (hRH : RiemannHypothesis) {r : ℤ} (hr : 76 ≤ r) :
    Construction.tableFrom TableRoute.rowN r 3 ≠ 0 := by
  have hL0 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  refine cell_ne_zero_gen hRH 3 (r₀ := 76) (a := 0.006) (by norm_num) (by norm_num) ?_ ?_
    (by exact_mod_cast hr)
  · have e : (-(((76:ℝ) - (((3:ℕ):ℝ) + 1)) / 2)) = -((36:ℕ):ℝ) := by norm_num
    rw [e, two_rpow_neg_nat]
    norm_num
  · have h := pow_lower 2
    have : (0.006:ℝ) < Real.log 2 ^ 2 := lt_of_lt_of_le (by norm_num) h
    calc (0.006:ℝ) * Real.log 2 < Real.log 2 ^ 2 * Real.log 2 :=
          mul_lt_mul_of_pos_right this hL0
      _ = Real.log 2 ^ 3 := by ring

/-- Depth four, from row 77. -/
theorem depth_four (hRH : RiemannHypothesis) {r : ℤ} (hr : 77 ≤ r) :
    Construction.tableFrom TableRoute.rowN r 4 ≠ 0 := by
  have hL0 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  refine cell_ne_zero_gen hRH 4 (r₀ := 77) (a := 0.018) (by norm_num) (by norm_num) ?_ ?_
    (by exact_mod_cast hr)
  · have e : (-(((77:ℝ) - (((4:ℕ):ℝ) + 1)) / 2)) = -((36:ℕ):ℝ) := by norm_num
    rw [e, two_rpow_neg_nat]
    norm_num
  · have h := pow_lower 3
    have : (0.018:ℝ) < Real.log 2 ^ 3 := lt_of_lt_of_le (by norm_num) h
    calc (0.018:ℝ) * Real.log 2 < Real.log 2 ^ 3 * Real.log 2 :=
          mul_lt_mul_of_pos_right this hL0
      _ = Real.log 2 ^ 4 := by ring

/-- Depth five, from row 78. -/
theorem depth_five (hRH : RiemannHypothesis) {r : ℤ} (hr : 78 ≤ r) :
    Construction.tableFrom TableRoute.rowN r 5 ≠ 0 := by
  have hL0 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  refine cell_ne_zero_gen hRH 5 (r₀ := 78) (a := 0.054) (by norm_num) (by norm_num) ?_ ?_
    (by exact_mod_cast hr)
  · have e : (-(((78:ℝ) - (((5:ℕ):ℝ) + 1)) / 2)) = -((36:ℕ):ℝ) := by norm_num
    rw [e, two_rpow_neg_nat]
    norm_num
  · have h := pow_lower 4
    have : (0.054:ℝ) < Real.log 2 ^ 4 := lt_of_lt_of_le (by norm_num) h
    calc (0.054:ℝ) * Real.log 2 < Real.log 2 ^ 4 * Real.log 2 :=
          mul_lt_mul_of_pos_right this hL0
      _ = Real.log 2 ^ 5 := by ring

/-- Depth six, from row 80. -/
theorem depth_six (hRH : RiemannHypothesis) {r : ℤ} (hr : 80 ≤ r) :
    Construction.tableFrom TableRoute.rowN r 6 ≠ 0 := by
  have hL0 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  refine cell_ne_zero_gen hRH 6 (r₀ := 80) (a := 0.12) (by norm_num) (by norm_num) ?_ ?_
    (by exact_mod_cast hr)
  · have e : (-(((80:ℝ) - (((6:ℕ):ℝ) + 1)) / 2)) = -((37:ℕ):ℝ) + 1 / 2 := by norm_num
    rw [e]
    have hb := two_rpow_neg_nat_half 37
    calc 414 * (2 * 3 ^ (6 + 1)) * ((80:ℝ) ^ 2 * (2:ℝ) ^ (-((37:ℕ):ℝ) + 1 / 2))
        ≤ 414 * (2 * 3 ^ (6 + 1)) * ((80:ℝ) ^ 2 * (1.4143 / (2:ℝ) ^ 37)) := by
          apply mul_le_mul_of_nonneg_left ?_ (by positivity)
          exact mul_le_mul_of_nonneg_left hb (by positivity)
      _ ≤ 0.12 := by norm_num
  · have h := pow_lower 5
    have : (0.12:ℝ) < Real.log 2 ^ 5 := lt_of_lt_of_le (by norm_num) h
    calc (0.12:ℝ) * Real.log 2 < Real.log 2 ^ 5 * Real.log 2 :=
          mul_lt_mul_of_pos_right this hL0
      _ = Real.log 2 ^ 6 := by ring

/-- Depth seven, from row 85. -/
theorem depth_seven (hRH : RiemannHypothesis) {r : ℤ} (hr : 85 ≤ r) :
    Construction.tableFrom TableRoute.rowN r 7 ≠ 0 := by
  have hL0 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  refine cell_ne_zero_gen hRH 7 (r₀ := 85) (a := 0.102) (by norm_num) (by norm_num) ?_ ?_
    (by exact_mod_cast hr)
  · have e : (-(((85:ℝ) - (((7:ℕ):ℝ) + 1)) / 2)) = -((39:ℕ):ℝ) + 1 / 2 := by norm_num
    rw [e]
    have hb := two_rpow_neg_nat_half 39
    calc 414 * (2 * 3 ^ (7 + 1)) * ((85:ℝ) ^ 2 * (2:ℝ) ^ (-((39:ℕ):ℝ) + 1 / 2))
        ≤ 414 * (2 * 3 ^ (7 + 1)) * ((85:ℝ) ^ 2 * (1.4143 / (2:ℝ) ^ 39)) := by
          apply mul_le_mul_of_nonneg_left ?_ (by positivity)
          exact mul_le_mul_of_nonneg_left hb (by positivity)
      _ ≤ 0.102 := by norm_num
  · have h := pow_lower 6
    have : (0.102:ℝ) < Real.log 2 ^ 6 := lt_of_lt_of_le (by norm_num) h
    calc (0.102:ℝ) * Real.log 2 < Real.log 2 ^ 6 * Real.log 2 :=
          mul_lt_mul_of_pos_right this hL0
      _ = Real.log 2 ^ 7 := by ring

/-- Depth eight, from row 91. -/
theorem depth_eight (hRH : RiemannHypothesis) {r : ℤ} (hr : 91 ≤ r) :
    Construction.tableFrom TableRoute.rowN r 8 ≠ 0 := by
  have hL0 : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  refine cell_ne_zero_gen hRH 8 (r₀ := 91) (a := 0.062) (by norm_num) (by norm_num) ?_ ?_
    (by exact_mod_cast hr)
  · have e : (-(((91:ℝ) - (((8:ℕ):ℝ) + 1)) / 2)) = -((41:ℕ):ℝ) := by norm_num
    rw [e, two_rpow_neg_nat]
    norm_num
  · have h := pow_lower 7
    have : (0.062:ℝ) < Real.log 2 ^ 7 := lt_of_lt_of_le (by norm_num) h
    calc (0.062:ℝ) * Real.log 2 < Real.log 2 ^ 7 * Real.log 2 :=
          mul_lt_mul_of_pos_right this hL0
      _ = Real.log 2 ^ 8 := by ring

end

/-- info: 'TableDepths.cell_ne_zero_gen' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cell_ne_zero_gen

/-- info: 'TableDepths.depth_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms depth_one

/-- info: 'TableDepths.depth_seven' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms depth_seven

/-- info: 'TableDepths.depth_eight' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms depth_eight

end TableDepths
