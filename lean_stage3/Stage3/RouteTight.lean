/-
RouteTight — the route through the sharp ψ-to-π transfer (`PsiToPiSharp`).

`routeConstT x₀ = F + (2F + 13)/log(max(x₀², 9))`, with `F` the floor constant `RouteSharp` uses.
At the floor `2^38` it is at most `40` (`routeConstT_le38`), against `127` through the old transfer.
`weakWindow40_of_RH`: under RH every window with `r − n ≥ 76` meets `StmtWeakWindow 40 1`.
-/
import Stage3.RouteSharp
import Stage3.PsiToPiSharp

namespace Stage3
open Kadiri Complex Chebyshev
open scoped Chebyshev
noncomputable section

/-- The route's constant through the sharp transfer. -/
def routeConstT (x₀ : ℝ) : ℝ :=
  floorConstSplit Glue.c1n Glue.c3n Glue.c4n 15 0 626 0 x₀
    + (2 * floorConstSplit Glue.c1n Glue.c3n Glue.c4n 15 0 626 0 x₀ + 13)
      / Real.log (max (x₀ ^ 2) 9)

theorem schoenfeldWeak_routeT (hRH : RiemannHypothesis) {x₀ : ℝ} (hx₀ : 16 ≤ x₀) :
    StmtSchoenfeldWeak (routeConstT x₀) 1 (max (x₀ ^ 2) 9)
      (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li := by
  have hRvM2 : 0 ≤ riemannZeta.RvM 15 0 626 2 := by
    unfold riemannZeta.RvM
    have := Real.log_nonneg (show (1 : ℝ) ≤ 2 by norm_num)
    linarith
  have hpsi := psiWeak_floor_split hRH Glue.c1n_nonneg Glue.c3n_nonneg Glue.c4n_nonneg
    (by norm_num) le_rfl (by norm_num) weightedZeroHeightBucket_eq_zero.symm
    hRvM2 stmtEF_split_num Stage3.rvM_sharp hx₀ hx₀
  have hℓ : 0 < Real.log (max (x₀ ^ 2) 9) :=
    Real.log_pos (lt_of_lt_of_le (by norm_num) (le_max_right _ _))
  exact schoenfeldWeak_of_psiWeak_sharp (by linarith)
    (floorConstSplit_nonneg Glue.c1n_nonneg Glue.c3n_nonneg Glue.c4n_nonneg
      (by norm_num) le_rfl (by norm_num) le_rfl hx₀) hℓ le_rfl hpsi

/-- The route's constant on two floors: the top term at `x₀²`, the integral from `x₀`. -/
def routeConstU (x₀ : ℝ) : ℝ :=
  floorConstSplit Glue.c1n Glue.c3n Glue.c4n 15 0 626 0 (x₀ ^ 2)
    + (2 * floorConstSplit Glue.c1n Glue.c3n Glue.c4n 15 0 626 0 x₀ + 13)
      / Real.log (max (x₀ ^ 2) 9)

theorem schoenfeldWeak_routeU (hRH : RiemannHypothesis) {x₀ : ℝ} (hx₀ : 16 ≤ x₀) :
    StmtSchoenfeldWeak (routeConstU x₀) 1 (max (x₀ ^ 2) 9)
      (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li := by
  have hRvM2 : 0 ≤ riemannZeta.RvM 15 0 626 2 := by
    unfold riemannZeta.RvM
    have := Real.log_nonneg (show (1 : ℝ) ≤ 2 by norm_num)
    linarith
  have hx₂ : 16 ≤ x₀ ^ 2 := by nlinarith
  have hpsi := psiWeak_floor_split hRH Glue.c1n_nonneg Glue.c3n_nonneg Glue.c4n_nonneg
    (by norm_num) le_rfl (by norm_num) weightedZeroHeightBucket_eq_zero.symm
    hRvM2 stmtEF_split_num Stage3.rvM_sharp hx₀ hx₀
  have hpsi₂ := psiWeak_floor_split hRH Glue.c1n_nonneg Glue.c3n_nonneg Glue.c4n_nonneg
    (by norm_num) le_rfl (by norm_num) weightedZeroHeightBucket_eq_zero.symm
    hRvM2 stmtEF_split_num Stage3.rvM_sharp hx₂ hx₂
  have hℓ : 0 < Real.log (max (x₀ ^ 2) 9) :=
    Real.log_pos (lt_of_lt_of_le (by norm_num) (le_max_right _ _))
  exact schoenfeldWeak_of_psiWeak_two (by linarith)
    (floorConstSplit_nonneg Glue.c1n_nonneg Glue.c3n_nonneg Glue.c4n_nonneg
      (by norm_num) le_rfl (by norm_num) le_rfl hx₀) hℓ le_rfl hpsi hpsi₂

end

end Stage3

namespace RouteSharp

theorem routeConstT_le38 : Stage3.routeConstT ((2:ℝ) ^ (38:ℕ)) ≤ 40 := by
  have hS := routeConstS_le38
  unfold Stage3.routeConstS at hS
  set F := Stage3.floorConstSplit Glue.c1n Glue.c3n Glue.c4n 15 0 626 0 ((2:ℝ) ^ (38:ℕ)) with hF
  have hF38 : F ≤ 38 := by linarith
  have hmax : max (((2:ℝ) ^ (38:ℕ)) ^ 2) 9 = (2:ℝ) ^ (76:ℕ) := by
    rw [max_eq_left (by norm_num)]; norm_num
  have hlog : Real.log ((2:ℝ) ^ (76:ℕ)) = 76 * Real.log 2 := by
    rw [Real.log_pow]; push_cast; ring
  have hℓ : (52.67:ℝ) ≤ 76 * Real.log 2 := by have := Real.log_two_gt_d9; linarith
  unfold Stage3.routeConstT
  rw [← hF, hmax, hlog]
  have hq : (2 * F + 13) / (76 * Real.log 2) ≤ 1.7 := by
    rw [div_le_iff₀ (by linarith)]; nlinarith
  linarith

/-- **The route at the floor `2^38` through the sharp transfer, point by point.** -/
theorem weakWindow40_of_RH (hRH : RiemannHypothesis) {r : ℤ} {n : ℕ}
    (hn : (76 : ℝ) ≤ (r : ℝ) - n) :
    Stage3.StmtWeakWindow 40 1
        (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
        (fun m : ℤ => 2 / Real.log 2
          + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r n := by
  have hx₀ : (16:ℝ) ≤ (2:ℝ) ^ (38:ℕ) := by norm_num
  have hpi := Stage3.schoenfeldWeak_routeT hRH hx₀
  have h9 : (9:ℝ) ≤ ((2:ℝ) ^ (38:ℕ)) ^ 2 := by norm_num
  have hbot : max (((2:ℝ) ^ (38:ℕ)) ^ 2) 9 ≤ (2 : ℝ) ^ ((r : ℝ) - n) := by
    rw [max_eq_left h9]
    have h1 : ((2:ℝ) ^ (38:ℕ)) ^ 2 = (2:ℝ) ^ ((76:ℕ):ℝ) := by
      rw [Real.rpow_natCast]; norm_num
    rw [h1]
    exact Real.rpow_le_rpow_of_exponent_le (by norm_num) (by push_cast; linarith)
  have hW := Stage3.weakWindow_of_global (f := fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
      (L := fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) hpi (fun _ => rfl) (fun _ => rfl) hbot
  intro j hj
  have hjn : (j : ℝ) ≤ n := by exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)
  have hm : (0 : ℝ) < ((r - j : ℤ) : ℝ) := by push_cast; linarith
  have h := hW j hj
  simp only at h ⊢
  rw [← Stage3.Li_two_rpow hm]
  have hP : (0:ℝ) ≤ (Real.log 2 * ((r:ℝ) - j)) ^ 1 * (2:ℝ) ^ (((r:ℝ) - j) / 2) := by
    have hl : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
    have : (0:ℝ) < (r:ℝ) - j := by linarith
    have := Real.rpow_pos_of_pos (show (0:ℝ) < 2 by norm_num) (((r:ℝ) - j) / 2)
    positivity
  calc _ ≤ _ := h
    _ ≤ 40 * (Real.log 2 * ((r:ℝ) - j)) ^ 1 * (2:ℝ) ^ (((r:ℝ) - j) / 2) := by
        have := mul_le_mul_of_nonneg_right routeConstT_le38 hP
        nlinarith

theorem floor_bound76 {c1 c3 c4 ℓ q : ℝ} (hc1' : c1 ≤ 88216610000)
    (hc3' : c3 ≤ 15) (hc4' : c4 ≤ 6468930000) (hℓ : 52.67 ≤ ℓ) (hq : q ≤ 1) (hq0 : 0 ≤ q)
    (hc4n : 0 ≤ c4) :
    4 + (16 + 16 * 15 + 16 * 0) / ℓ + (8 * 626 + 8 + 4 * 0) / ℓ ^ 2
        + 18 * c1 / ((2:ℝ) ^ (76:ℕ) * (2:ℝ) ^ (38:ℕ)) + c3 / ((2:ℝ) ^ (38:ℕ) * ℓ)
        + c4 * q / (2:ℝ) ^ (38:ℕ) ≤ 10.7 := by
  have hℓ0 : (0:ℝ) < ℓ := by linarith
  have h1 : (16 + 16 * 15 + 16 * 0 : ℝ) / ℓ ≤ 4.861 := by
    rw [div_le_iff₀ hℓ0]; nlinarith
  have h2 : (8 * 626 + 8 + 4 * 0 : ℝ) / ℓ ^ 2 ≤ 1.809 := by
    rw [div_le_iff₀ (by positivity)]; nlinarith [mul_le_mul hℓ hℓ (by norm_num) hℓ0.le]
  have h3 : 18 * c1 / ((2:ℝ) ^ (76:ℕ) * (2:ℝ) ^ (38:ℕ)) ≤ 0.001 := by
    rw [div_le_iff₀ (by positivity)]; norm_num; linarith
  have h4 : c3 / ((2:ℝ) ^ (38:ℕ) * ℓ) ≤ 0.001 := by
    rw [div_le_iff₀ (by positivity)]; norm_num; nlinarith
  have h5 : c4 * q / (2:ℝ) ^ (38:ℕ) ≤ 0.024 := by
    rw [div_le_iff₀ (by positivity)]
    have : c4 * q ≤ 6468930000 := by nlinarith
    norm_num; linarith
  linarith

theorem routeConstU_le38 : Stage3.routeConstU ((2:ℝ) ^ (38:ℕ)) ≤ 13 := by
  have hS := routeConstS_le38
  unfold Stage3.routeConstS at hS
  set F := Stage3.floorConstSplit Glue.c1n Glue.c3n Glue.c4n 15 0 626 0 ((2:ℝ) ^ (38:ℕ)) with hF
  have hF38 : F ≤ 38 := by linarith
  have hsq : ((2:ℝ) ^ (38:ℕ)) ^ 2 = (2:ℝ) ^ (76:ℕ) := by norm_num
  have hmax : max (((2:ℝ) ^ (38:ℕ)) ^ 2) 9 = (2:ℝ) ^ (76:ℕ) := by
    rw [max_eq_left (by norm_num)]; norm_num
  have hlog : Real.log ((2:ℝ) ^ (76:ℕ)) = 76 * Real.log 2 := by
    rw [Real.log_pow]; push_cast; ring
  have hℓ : (52.67:ℝ) ≤ 76 * Real.log 2 := by have := Real.log_two_gt_d9; linarith
  have hsqrt : Real.sqrt ((2:ℝ) ^ (76:ℕ)) = (2:ℝ) ^ (38:ℕ) := by
    rw [show (2:ℝ) ^ (76:ℕ) = ((2:ℝ) ^ (38:ℕ)) ^ 2 by norm_num, Real.sqrt_sq (by positivity)]
  have hq : ((2:ℝ) ^ (76:ℕ)) ^ (-(1:ℝ) / 4) ≤ 1 :=
    Real.rpow_le_one_of_one_le_of_nonpos (by norm_num) (by norm_num)
  have hq0 : 0 ≤ ((2:ℝ) ^ (76:ℕ)) ^ (-(1:ℝ) / 4) := by positivity
  have hF76 : Stage3.floorConstSplit Glue.c1n Glue.c3n Glue.c4n 15 0 626 0 ((2:ℝ) ^ (76:ℕ)) ≤ 10.7 := by
    unfold Stage3.floorConstSplit Stage3.floorConst
    rw [hlog, hsqrt]
    exact floor_bound76 RouteNum.c1n_le RouteNum.c3n_le RouteNum.c4n_le hℓ hq hq0 Glue.c4n_nonneg
  unfold Stage3.routeConstU
  rw [← hF, hsq, max_eq_left (by norm_num : (9:ℝ) ≤ (2:ℝ) ^ (76:ℕ)), hlog]
  have hdiv : (2 * F + 13) / (76 * Real.log 2) ≤ 1.7 := by
    rw [div_le_iff₀ (by linarith)]; nlinarith
  linarith

/-- **The route at the floor `2^38` on two floors, point by point.** -/
theorem weakWindow13_of_RH (hRH : RiemannHypothesis) {r : ℤ} {n : ℕ}
    (hn : (76 : ℝ) ≤ (r : ℝ) - n) :
    Stage3.StmtWeakWindow 13 1
        (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
        (fun m : ℤ => 2 / Real.log 2
          + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r n := by
  have hx₀ : (16:ℝ) ≤ (2:ℝ) ^ (38:ℕ) := by norm_num
  have hpi := Stage3.schoenfeldWeak_routeU hRH hx₀
  have h9 : (9:ℝ) ≤ ((2:ℝ) ^ (38:ℕ)) ^ 2 := by norm_num
  have hbot : max (((2:ℝ) ^ (38:ℕ)) ^ 2) 9 ≤ (2 : ℝ) ^ ((r : ℝ) - n) := by
    rw [max_eq_left h9]
    have h1 : ((2:ℝ) ^ (38:ℕ)) ^ 2 = (2:ℝ) ^ ((76:ℕ):ℝ) := by
      rw [Real.rpow_natCast]; norm_num
    rw [h1]
    exact Real.rpow_le_rpow_of_exponent_le (by norm_num) (by push_cast; linarith)
  have hW := Stage3.weakWindow_of_global (f := fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
      (L := fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) hpi (fun _ => rfl) (fun _ => rfl) hbot
  intro j hj
  have hjn : (j : ℝ) ≤ n := by exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)
  have hm : (0 : ℝ) < ((r - j : ℤ) : ℝ) := by push_cast; linarith
  have h := hW j hj
  simp only at h ⊢
  rw [← Stage3.Li_two_rpow hm]
  have hP : (0:ℝ) ≤ (Real.log 2 * ((r:ℝ) - j)) ^ 1 * (2:ℝ) ^ (((r:ℝ) - j) / 2) := by
    have hl : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
    have : (0:ℝ) < (r:ℝ) - j := by linarith
    have := Real.rpow_pos_of_pos (show (0:ℝ) < 2 by norm_num) (((r:ℝ) - j) / 2)
    positivity
  calc _ ≤ _ := h
    _ ≤ 13 * (Real.log 2 * ((r:ℝ) - j)) ^ 1 * (2:ℝ) ^ (((r:ℝ) - j) / 2) := by
        have := mul_le_mul_of_nonneg_right routeConstU_le38 hP
        nlinarith

end RouteSharp

/-- info: 'RouteSharp.weakWindow40_of_RH' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RouteSharp.weakWindow40_of_RH

/-- info: 'RouteSharp.weakWindow13_of_RH' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RouteSharp.weakWindow13_of_RH
