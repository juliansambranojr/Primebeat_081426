/-
RHDepths — depths 1 … 10, every row, under the explicit-formula route of RH.

`StmtRoute414` is, character for character, the conclusion of
`lean_stage3/Stage3/GateAll.window_414_of_RH` (with this tree's `RelativeGate.StmtRelErrWindow`
for that tree's `JointDialGate.StmtRelErrWindow`, welded), read for every window with `r − n ≥ 72`.
That theorem takes only `RiemannHypothesis`, which leanprover-community/riemann-hypothesis proves
(welded, `utilities/check_weld.py`).

`route_lt_price`: for `d ≤ 10` and `r ≥ 89`, the route's `ρ` is under the exact gate's price.
`only_four_zeros_rh_le10`: with the π list on rows 23 … 92, every zero at depths 1 … 10, in any
row, is one of the four.
-/
import Mathlib
import ExactBand
import PiNarrow

namespace RHDepths
open RelativeGate ExactGate ExactBand

/-- The route's window for every `r`, `n` with `r − n ≥ 72`. -/
def StmtRoute414 : Prop :=
  ∀ (r : ℤ) (n : ℕ), (72 : ℝ) ≤ (r : ℝ) - n →
    RelativeGate.StmtRelErrWindow
        (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
        (fun m : ℤ => 2 / Real.log 2
          + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r n
        (414 * (Real.log 2 * r) ^ 1 * (2 : ℝ) ^ (-(((r : ℝ) - n) / 2)))

theorem sq_le_two_rpow89 {r : ℝ} (hr : 89 ≤ r) : r ^ 2 ≤ 7921 * (2:ℝ) ^ ((r - 89) / 2) := by
  have hL := Real.log_two_gt_d9
  set y : ℝ := Real.log 2 * ((r - 89) / 2) with hy
  have hy0 : 0 ≤ y := by
    rw [hy]; have : (0:ℝ) ≤ (r - 89) / 2 := by linarith
    positivity
  have hexp : (2:ℝ) ^ ((r - 89) / 2) = Real.exp y := by rw [Real.rpow_def_of_pos (by norm_num)]
  have hq := Real.quadratic_le_exp_of_nonneg hy0
  have hyl : 0.3465 * (r - 89) ≤ y := by rw [hy]; nlinarith
  rw [hexp]
  have hy2 : (0.3465 * (r - 89)) ^ 2 ≤ y ^ 2 := pow_le_pow_left₀ (by nlinarith) hyl 2
  nlinarith

/-- **The route under the exact gate's price, depths up to ten, from row 89.** -/
theorem route_lt_price {r : ℤ} {d : ℕ} (hd : d ≤ 10) (hr : (89 : ℝ) ≤ r) :
    414 * (Real.log 2 * r) ^ 1 * (2 : ℝ) ^ (-(((r : ℝ) - ((d + 1 : ℕ) : ℝ)) / 2)) < priceX r d := by
  have hL := Real.log_two_gt_d9
  have hLu := Real.log_two_lt_d9
  have hdR : (d : ℝ) ≤ 10 := by exact_mod_cast hd
  have hd0 : (0 : ℝ) ≤ d := Nat.cast_nonneg d
  have hr0 : (0 : ℝ) < r := by linarith
  set E : ℝ := (2:ℝ) ^ (((r:ℝ) - 89) / 2) with hE
  have hE1 : 1 ≤ E := Real.one_le_rpow (by norm_num) (by linarith)
  have hsq := sq_le_two_rpow89 hr
  rw [← hE] at hsq
  -- 2^(−(r−d−1)/2) = 1/(E · 2^((88−d)/2))
  set G : ℝ := (2:ℝ) ^ ((88 - (d:ℝ)) / 2) with hG
  have hG39 : (2:ℝ) ^ (39:ℕ) ≤ G := by
    rw [hG, ← Real.rpow_natCast]
    exact Real.rpow_le_rpow_of_exponent_le (by norm_num) (by push_cast; linarith)
  have hsplit : (2 : ℝ) ^ (-(((r : ℝ) - ((d + 1 : ℕ) : ℝ)) / 2)) * (E * G) = 1 := by
    rw [hE, hG, ← Real.rpow_add (by norm_num), ← Real.rpow_add (by norm_num)]
    rw [show -(((r : ℝ) - ((d + 1 : ℕ) : ℝ)) / 2) + (((r:ℝ) - 89) / 2 + (88 - (d:ℝ)) / 2) = 0 by
      push_cast; ring]
    simp
  have hEG : 0 < E * G := by positivity
  have hP : (2 : ℝ) ^ (-(((r : ℝ) - ((d + 1 : ℕ) : ℝ)) / 2)) = 1 / (E * G) := by
    field_simp; linarith [hsplit]
  -- the price: q ≤ 10/78, so 1 − q/(1−q) ≥ 0.85
  unfold priceX; simp only
  have hden : 0 < (r : ℝ) - 1 - d := by linarith
  set q := (d : ℝ) / ((r : ℝ) - 1 - d) with hq
  have hq0 : 0 ≤ q := div_nonneg hd0 hden.le
  have hq1 : q ≤ 10 / 78 := by rw [hq, div_le_iff₀ hden]; nlinarith
  have hc : (0.85 : ℝ) ≤ 1 - q / (1 - q) := by
    have h1q : 0 < 1 - q := by linarith
    have : q / (1 - q) ≤ 0.15 := by rw [div_le_iff₀ h1q]; nlinarith
    linarith
  have h3 : (3:ℝ) ^ (d + 1) ≤ 3 ^ 11 := pow_le_pow_right₀ (by norm_num) (by omega)
  rw [hP, lt_div_iff₀ (by positivity)]
  -- 414·L·r/(E G) · r·3^(d+1) < 1 − q/(1−q)
  have key : 414 * (Real.log 2 * r) ^ 1 * (1 / (E * G)) * ((r : ℝ) * 3 ^ (d + 1))
      = 414 * Real.log 2 * (r:ℝ) ^ 2 * 3 ^ (d + 1) / (E * G) := by
    field_simp
  rw [key, div_lt_iff₀ hEG]
  have hb : 414 * Real.log 2 * (r:ℝ) ^ 2 * 3 ^ (d + 1) ≤ 414 * 0.6932 * (7921 * E) * 3 ^ 11 := by
    have h3p : (0:ℝ) < 3 ^ (d + 1) := by positivity
    have : 414 * Real.log 2 * (r:ℝ) ^ 2 * 3 ^ (d + 1) ≤ 414 * 0.6932 * (r:ℝ) ^ 2 * 3 ^ (d + 1) := by
      have : (0:ℝ) ≤ (r:ℝ) ^ 2 * 3 ^ (d + 1) := by positivity
      nlinarith
    calc _ ≤ 414 * 0.6932 * (r:ℝ) ^ 2 * 3 ^ (d + 1) := this
      _ ≤ 414 * 0.6932 * (7921 * E) * 3 ^ (d + 1) := by gcongr
      _ ≤ 414 * 0.6932 * (7921 * E) * 3 ^ 11 := by gcongr
  have hnum : 414 * 0.6932 * (7921 * E) * 3 ^ 11 < 0.85 * (E * (2:ℝ) ^ (39:ℕ)) := by
    norm_num; nlinarith
  calc _ ≤ _ := hb
    _ < 0.85 * (E * (2:ℝ) ^ (39:ℕ)) := hnum
    _ ≤ (1 - q / (1 - q)) * (E * G) := by
        apply mul_le_mul hc (mul_le_mul_of_nonneg_left hG39 (by linarith)) (by positivity) (by linarith)

end RHDepths

/-- info: 'RHDepths.route_lt_price' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RHDepths.route_lt_price

namespace RHDepths
open RelativeGate ExactGate ExactBand

theorem floor_two_rpow {m : ℤ} (hm : 0 ≤ m) :
    (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ) = ToInfinity.piRow m := by
  unfold ToInfinity.piRow
  have hmt : m = (m.toNat : ℤ) := (Int.toNat_of_nonneg hm).symm
  congr 2
  rw [hmt, Int.cast_natCast, Real.rpow_natCast]
  simp only [Int.toNat_natCast]
  exact_mod_cast Nat.floor_natCast (2 ^ m.toNat)

/-- **Depths 1 … 10, every row, under the route.** With the π list on rows 23 … 92 and the route's
window (`StmtRoute414`, which `GateAll.window_414_of_RH` proves from RH), every zero of the true
table at depths 1 … 10 is one of the four. -/
theorem only_four_zeros_rh_le10 (hpi : PiNarrow.StmtPiData23) (hR : StmtRoute414)
    {r : ℤ} {d : ℕ} (hd : 1 ≤ d) (hd10 : d ≤ 10) (hlo : (d : ℤ) < r)
    (hz : Construction.tableFrom ToInfinity.trueRow r d = 0) :
    (r, d) = (2, 1) ∨ (r, d) = (4, 1) ∨ (r, d) = (8, 3) ∨ (r, d) = (20, 6) := by
  by_cases h92 : r ≤ 92
  · exact ToInfinity.census_zero hd hlo h92
      (by rw [ToInfinity.cell_eq_true (PiNarrow.piData_of_23 hpi) r d hlo h92]; exact hz)
  · exfalso
    have hr93 : (93 : ℤ) ≤ r := by omega
    have hrR : (93 : ℝ) ≤ r := by exact_mod_cast hr93
    have hdR : (d : ℝ) ≤ 10 := by exact_mod_cast hd10
    set F : ℤ → ℝ := fun m => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ) with hF
    have hwin := hR r (d + 1) (by push_cast; linarith)
    have hS : StmtRelErrWindow F (fun k : ℤ => Interpolant.liRow k) r (d + 1)
        (414 * (Real.log 2 * r) ^ 1 * (2 : ℝ) ^ (-(((r : ℝ) - ((d + 1 : ℕ) : ℝ)) / 2))) := by
      intro k hk
      have hkn : (k : ℝ) ≤ d + 1 := by
        have := Nat.lt_succ_iff.mp (Finset.mem_range.mp hk); exact_mod_cast this
      have hm : (1 : ℝ) / 2 ≤ ((r - k : ℤ) : ℝ) := by push_cast; linarith
      have h := hwin k hk
      simp only at h ⊢
      rw [Interpolant.liRow_eq hm]
      exact h
    have hband : 3 * (d : ℝ) + 1 < r := by linarith
    refine tableFrom_ne_zero_exact (f := F) ?_ hS hband
      (gap_of_price hband (route_lt_price hd10 (by linarith))) hz
    intro k hk
    have := Finset.mem_range.mp hk
    have h1 : (1 : ℤ) ≤ r - k := by omega
    rw [ToInfinity.trueRow_eq_bdiff h1]
    unfold Nonvanishing.bdiffZ
    rw [hF]; simp only
    rw [floor_two_rpow (by omega), floor_two_rpow (by omega)]

end RHDepths

/-- info: 'RHDepths.only_four_zeros_rh_le10' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RHDepths.only_four_zeros_rh_le10

namespace RHDepths
open RelativeGate ExactGate ExactBand

/-- The route's window at the floor `2^40`, for every `r`, `n` with `r − n ≥ 80`: the conclusion of
`lean_stage3/Stage3/GateAll.window_263_of_RH`, welded by statement. -/
def StmtRoute263 : Prop :=
  ∀ (r : ℤ) (n : ℕ), (80 : ℝ) ≤ (r : ℝ) - n →
    RelativeGate.StmtRelErrWindow
        (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
        (fun m : ℤ => 2 / Real.log 2
          + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r n
        (263 * (Real.log 2 * r) ^ 1 * (2 : ℝ) ^ (-(((r : ℝ) - n) / 2)))

theorem sq_le_two_rpow93 {r : ℝ} (hr : 93 ≤ r) : r ^ 2 ≤ 8649 * (2:ℝ) ^ ((r - 93) / 2) := by
  have hL := Real.log_two_gt_d9
  set y : ℝ := Real.log 2 * ((r - 93) / 2) with hy
  have hy0 : 0 ≤ y := by
    rw [hy]; have : (0:ℝ) ≤ (r - 93) / 2 := by linarith
    positivity
  have hexp : (2:ℝ) ^ ((r - 93) / 2) = Real.exp y := by rw [Real.rpow_def_of_pos (by norm_num)]
  have hq := Real.quadratic_le_exp_of_nonneg hy0
  have hyl : 0.3465 * (r - 93) ≤ y := by rw [hy]; nlinarith
  rw [hexp]
  have hy2 : (0.3465 * (r - 93)) ^ 2 ≤ y ^ 2 := pow_le_pow_left₀ (by nlinarith) hyl 2
  nlinarith

/-- **Depth eleven: the floor-`2^40` route under the price from row 93.** -/
theorem route263_lt_price11 {r : ℤ} (hr : (93 : ℝ) ≤ r) :
    263 * (Real.log 2 * r) ^ 1 * (2 : ℝ) ^ (-(((r : ℝ) - ((11 + 1 : ℕ) : ℝ)) / 2)) < priceX r 11 := by
  have hL := Real.log_two_gt_d9
  have hLu := Real.log_two_lt_d9
  have hr0 : (0 : ℝ) < r := by linarith
  set E : ℝ := (2:ℝ) ^ (((r:ℝ) - 93) / 2) with hE
  have hE1 : 1 ≤ E := Real.one_le_rpow (by norm_num) (by linarith)
  have hsq := sq_le_two_rpow93 hr
  rw [← hE] at hsq
  set G : ℝ := (2:ℝ) ^ ((81 : ℝ) / 2) with hG
  have hG40 : (2:ℝ) ^ (40:ℕ) ≤ G := by
    rw [hG, ← Real.rpow_natCast]
    exact Real.rpow_le_rpow_of_exponent_le (by norm_num) (by norm_num)
  have hsplit : (2 : ℝ) ^ (-(((r : ℝ) - ((11 + 1 : ℕ) : ℝ)) / 2)) * (E * G) = 1 := by
    rw [hE, hG, ← Real.rpow_add (by norm_num), ← Real.rpow_add (by norm_num)]
    rw [show -(((r : ℝ) - ((11 + 1 : ℕ) : ℝ)) / 2) + (((r:ℝ) - 93) / 2 + (81 : ℝ) / 2) = 0 by
      push_cast; ring]
    simp
  have hEG : 0 < E * G := by positivity
  have hP : (2 : ℝ) ^ (-(((r : ℝ) - ((11 + 1 : ℕ) : ℝ)) / 2)) = 1 / (E * G) := by
    field_simp; linarith [hsplit]
  unfold priceX; simp only
  have hden : 0 < (r : ℝ) - 1 - ((11 : ℕ) : ℝ) := by push_cast; linarith
  set q := ((11 : ℕ) : ℝ) / ((r : ℝ) - 1 - ((11 : ℕ) : ℝ)) with hq
  have hq0 : 0 ≤ q := div_nonneg (by norm_num) hden.le
  have hq1 : q ≤ 11 / 81 := by rw [hq, div_le_iff₀ hden]; push_cast; nlinarith
  have hc : (0.84 : ℝ) ≤ 1 - q / (1 - q) := by
    have h1q : 0 < 1 - q := by linarith
    have : q / (1 - q) ≤ 0.16 := by rw [div_le_iff₀ h1q]; nlinarith
    linarith
  rw [hP, lt_div_iff₀ (by positivity)]
  have key : 263 * (Real.log 2 * r) ^ 1 * (1 / (E * G)) * ((r : ℝ) * 3 ^ (11 + 1))
      = 263 * Real.log 2 * (r:ℝ) ^ 2 * 3 ^ (11 + 1) / (E * G) := by
    field_simp
  rw [key, div_lt_iff₀ hEG]
  have hb : 263 * Real.log 2 * (r:ℝ) ^ 2 * 3 ^ (11 + 1) ≤ 263 * 0.6932 * (8649 * E) * 3 ^ 12 := by
    have : (0:ℝ) ≤ (r:ℝ) ^ 2 * 3 ^ (11 + 1) := by positivity
    calc _ ≤ 263 * 0.6932 * (r:ℝ) ^ 2 * 3 ^ (11 + 1) := by nlinarith
      _ ≤ 263 * 0.6932 * (8649 * E) * 3 ^ (11 + 1) := by gcongr
      _ = _ := by norm_num
  have hnum : 263 * 0.6932 * (8649 * E) * 3 ^ 12 < 0.84 * (E * (2:ℝ) ^ (40:ℕ)) := by
    norm_num; nlinarith
  calc _ ≤ _ := hb
    _ < 0.84 * (E * (2:ℝ) ^ (40:ℕ)) := hnum
    _ ≤ (1 - q / (1 - q)) * (E * G) := by
        apply mul_le_mul hc (mul_le_mul_of_nonneg_left hG40 (by linarith)) (by positivity) (by linarith)

/-- **Depths 1 … 11, every row.** -/
theorem only_four_zeros_rh_le11 (hpi : PiNarrow.StmtPiData23) (hR : StmtRoute414) (hR' : StmtRoute263)
    {r : ℤ} {d : ℕ} (hd : 1 ≤ d) (hd11 : d ≤ 11) (hlo : (d : ℤ) < r)
    (hz : Construction.tableFrom ToInfinity.trueRow r d = 0) :
    (r, d) = (2, 1) ∨ (r, d) = (4, 1) ∨ (r, d) = (8, 3) ∨ (r, d) = (20, 6) := by
  rcases Nat.lt_or_ge d 11 with h10 | h11
  · exact only_four_zeros_rh_le10 hpi hR hd (by omega) hlo hz
  have hd' : d = 11 := by omega
  subst hd'
  by_cases h92 : r ≤ 92
  · exact ToInfinity.census_zero hd hlo h92
      (by rw [ToInfinity.cell_eq_true (PiNarrow.piData_of_23 hpi) r 11 hlo h92]; exact hz)
  · exfalso
    have hr93 : (93 : ℤ) ≤ r := by omega
    have hrR : (93 : ℝ) ≤ r := by exact_mod_cast hr93
    set F : ℤ → ℝ := fun m => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ) with hF
    have hwin := hR' r (11 + 1) (by push_cast; linarith)
    have hS : StmtRelErrWindow F (fun k : ℤ => Interpolant.liRow k) r (11 + 1)
        (263 * (Real.log 2 * r) ^ 1 * (2 : ℝ) ^ (-(((r : ℝ) - ((11 + 1 : ℕ) : ℝ)) / 2))) := by
      intro k hk
      have hkn : (k : ℝ) ≤ 12 := by
        have := Nat.lt_succ_iff.mp (Finset.mem_range.mp hk); exact_mod_cast this
      have hm : (1 : ℝ) / 2 ≤ ((r - k : ℤ) : ℝ) := by push_cast; linarith
      have h := hwin k hk
      simp only at h ⊢
      rw [Interpolant.liRow_eq hm]
      exact h
    have hband : 3 * ((11 : ℕ) : ℝ) + 1 < r := by push_cast; linarith
    refine tableFrom_ne_zero_exact (f := F) ?_ hS hband
      (gap_of_price hband (route263_lt_price11 hrR)) hz
    intro k hk
    have := Finset.mem_range.mp hk
    have h1 : (1 : ℤ) ≤ r - k := by omega
    rw [ToInfinity.trueRow_eq_bdiff h1]
    unfold Nonvanishing.bdiffZ
    rw [hF]; simp only
    rw [floor_two_rpow (by omega), floor_two_rpow (by omega)]

end RHDepths

/-- info: 'RHDepths.only_four_zeros_rh_le11' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RHDepths.only_four_zeros_rh_le11
