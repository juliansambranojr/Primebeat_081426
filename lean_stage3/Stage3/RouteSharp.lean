/-
RouteSharp — the explicit-formula route on the sharper zero count `rvM_sharp` (`b₁ = 15`,
`b₃ = 626`) in place of `rvM_crude` (`112`, `698`). Copies of `RouteNum.schoenfeldWeak_route_num` and
`RouteNum.relErrWindow_route_num` with those constants; `routeConstS_le40`: at the floor `2^40` the
route's constant is at most `91`, under the `94.7` depth twelve needs at row 93.
-/
import Stage3.RouteNum
import Stage3.RvMSharp

namespace Stage3
open Kadiri Complex Chebyshev
open scoped Chebyshev
noncomputable section

/-- The route's constant on the sharper zero count. -/
def routeConstS (x₀ : ℝ) : ℝ :=
  3 * floorConstSplit Glue.c1n Glue.c3n Glue.c4n 15 0 626 0 x₀ + 13

theorem schoenfeldWeak_routeS (hRH : RiemannHypothesis) {x₀ : ℝ} (hx₀ : 16 ≤ x₀) :
    StmtSchoenfeldWeak (routeConstS x₀) 1 (max (x₀ ^ 2) 9)
      (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li := by
  have hRvM2 : 0 ≤ riemannZeta.RvM 15 0 626 2 := by
    unfold riemannZeta.RvM
    have := Real.log_nonneg (show (1 : ℝ) ≤ 2 by norm_num)
    linarith
  have hpsi := psiWeak_floor_split hRH Glue.c1n_nonneg Glue.c3n_nonneg Glue.c4n_nonneg
    (by norm_num) le_rfl (by norm_num) weightedZeroHeightBucket_eq_zero.symm
    hRvM2 stmtEF_split_num Stage3.rvM_sharp hx₀ hx₀
  exact schoenfeldWeak_of_psiWeak (k := 2) le_rfl (by linarith)
    (floorConstSplit_nonneg Glue.c1n_nonneg Glue.c3n_nonneg Glue.c4n_nonneg
      (by norm_num) le_rfl (by norm_num) le_rfl hx₀) hpsi

end

end Stage3

namespace RouteNum
open Finset
noncomputable section

theorem relErrWindow_routeS (hRH : RiemannHypothesis) {x₀ : ℝ} (hx₀ : 16 ≤ x₀)
    (r : ℤ) (n : ℕ) (hbot : x₀ ^ 2 ≤ (2 : ℝ) ^ ((r : ℝ) - n)) :
    JointDialGate.StmtRelErrWindow
      (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
      (fun m : ℤ => 2 / Real.log 2
        + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r n
      (Stage3.routeConstS x₀ * (Real.log 2 * r) ^ 1
        * (2 : ℝ) ^ (-(((r : ℝ) - n) / 2))) := by
  have hpos : 0 < (r : ℝ) - n := by
    by_contra hneg
    push_neg at hneg
    have h1 : (2 : ℝ) ^ ((r : ℝ) - n) ≤ 1 :=
      Real.rpow_le_one_of_one_le_of_nonpos (by norm_num) hneg
    nlinarith
  have hpi := Stage3.schoenfeldWeak_routeS hRH hx₀
  have hC : 0 ≤ Stage3.routeConstS x₀ := by
    have := Stage3.floorConstSplit_nonneg (b₁ := 15) (b₂ := 0) (b₃ := 626) (W := 0)
      (x₀ := x₀) Glue.c1n_nonneg Glue.c3n_nonneg Glue.c4n_nonneg
      (by norm_num) le_rfl (by norm_num) le_rfl hx₀
    unfold Stage3.routeConstS
    linarith
  have h9 : (9 : ℝ) ≤ x₀ ^ 2 := by nlinarith
  have hbot' : max (x₀ ^ 2) 9 ≤ (2 : ℝ) ^ ((r : ℝ) - n) := max_le hbot (le_trans h9 hbot)
  have hW := JointFloorGate.weakWindow_relErr hC hpos.le
    (Stage3.weakWindow_of_global (f := fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
      (L := fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) hpi (fun _ => rfl) (fun _ => rfl) hbot')
  intro k hk
  have hkn : (k : ℝ) ≤ n := by
    exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
  have hm : (0 : ℝ) < ((r - k : ℤ) : ℝ) := by
    push_cast
    linarith
  have hk' := hW k hk
  simp only at hk' ⊢
  rw [← Stage3.Li_two_rpow hm]
  exact hk'

end

end RouteNum

namespace RouteSharp

theorem floor_bound40S {c1 c3 c4 ℓ : ℝ} (hc1' : c1 ≤ 88216610000)
    (hc3' : c3 ≤ 15) (hc4' : c4 ≤ 6468930000) (hℓ : 27.72 ≤ ℓ) :
    3 * (4 + (16 + 16 * 15 + 16 * 0) / ℓ + (8 * 626 + 8 + 4 * 0) / ℓ ^ 2
        + 18 * c1 / ((2:ℝ) ^ (40:ℕ) * (2:ℝ) ^ (20:ℕ)) + c3 / ((2:ℝ) ^ (20:ℕ) * ℓ)
        + c4 * (1 / (2:ℝ) ^ (10:ℕ)) / (2:ℝ) ^ (20:ℕ)) + 13 ≤ 91 := by
  have hℓ0 : (0:ℝ) < ℓ := by linarith
  have h1 : (16 + 16 * 15 + 16 * 0 : ℝ) / ℓ ≤ 9.24 := by
    rw [div_le_iff₀ hℓ0]; nlinarith
  have h2 : (8 * 626 + 8 + 4 * 0 : ℝ) / ℓ ^ 2 ≤ 6.53 := by
    rw [div_le_iff₀ (by positivity)]; nlinarith [mul_le_mul hℓ hℓ (by norm_num) hℓ0.le]
  have h3 : 18 * c1 / ((2:ℝ) ^ (40:ℕ) * (2:ℝ) ^ (20:ℕ)) ≤ 0.001 := by
    rw [div_le_iff₀ (by positivity)]; norm_num; linarith
  have h4 : c3 / ((2:ℝ) ^ (20:ℕ) * ℓ) ≤ 0.001 := by
    rw [div_le_iff₀ (by positivity)]; norm_num; nlinarith
  have h5 : c4 * (1 / (2:ℝ) ^ (10:ℕ)) / (2:ℝ) ^ (20:ℕ) ≤ 6.03 := by
    rw [div_le_iff₀ (by positivity)]; norm_num; linarith
  linarith

theorem routeConstS_le40 : Stage3.routeConstS ((2:ℝ) ^ (40:ℕ)) ≤ 91 := by
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
  unfold Stage3.routeConstS Stage3.floorConstSplit Stage3.floorConst
  rw [hlog, hsqrt, hq]
  exact floor_bound40S RouteNum.c1n_le RouteNum.c3n_le RouteNum.c4n_le hℓ

/-- **The route's window at the floor `2^40` on the sharper zero count, constant `91`.** -/
theorem window_91_of_RH (hRH : RiemannHypothesis) {r : ℤ} {n : ℕ}
    (hn : (80 : ℝ) ≤ (r : ℝ) - n) :
    JointDialGate.StmtRelErrWindow
        (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
        (fun m : ℤ => 2 / Real.log 2
          + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r n
        (91 * (Real.log 2 * r) ^ 1 * (2 : ℝ) ^ (-(((r : ℝ) - n) / 2))) := by
  have hx₀ : (16:ℝ) ≤ (2:ℝ) ^ (40:ℕ) := by norm_num
  have hbot : ((2:ℝ) ^ (40:ℕ)) ^ 2 ≤ (2 : ℝ) ^ ((r : ℝ) - n) := by
    have h1 : ((2:ℝ) ^ (40:ℕ)) ^ 2 = (2:ℝ) ^ ((80:ℕ):ℝ) := by
      rw [Real.rpow_natCast]; norm_num
    rw [h1]
    exact Real.rpow_le_rpow_of_exponent_le (by norm_num) (by push_cast; linarith)
  have hW := RouteNum.relErrWindow_routeS hRH hx₀ r n hbot
  have hr0 : (0:ℝ) < r := by
    have : (0:ℝ) ≤ n := Nat.cast_nonneg n
    linarith
  have hP0 : (0:ℝ) ≤ (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-(((r:ℝ) - n) / 2)) := by
    have hl : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
    have := Real.rpow_pos_of_pos (show (0:ℝ) < 2 by norm_num) (-(((r:ℝ) - n) / 2))
    positivity
  intro k hk
  have h := hW k hk
  have hle : Stage3.routeConstS ((2:ℝ) ^ (40:ℕ)) * (Real.log 2 * r) ^ 1
        * (2:ℝ) ^ (-(((r:ℝ) - n) / 2))
      ≤ 91 * (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-(((r:ℝ) - n) / 2)) := by
    have := mul_le_mul_of_nonneg_right routeConstS_le40 hP0
    linarith
  have hpow : (0:ℝ) ≤ (2:ℝ) ^ ((r:ℝ) - k) := (Real.rpow_pos_of_pos (by norm_num) _).le
  calc _ ≤ _ := h
    _ ≤ _ := mul_le_mul_of_nonneg_right hle hpow

end RouteSharp

/-- info: 'RouteSharp.window_91_of_RH' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RouteSharp.window_91_of_RH
