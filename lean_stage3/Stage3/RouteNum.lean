/-
RouteNum — block E8c of `lean_stage3/design/joints.md`. 2026-11-22.

The explicit-formula route at the gate with its three constants named, and a
numeral above each constant in the chain.

  stmtEF_split_num        StmtExplicitFormulaSplit c1n c3n c4n 16
  routeConst x₀           3·floorConstSplit c1n c3n c4n 112 0 698 0 x₀ + 13
  relErrWindow_route_num  RH ⊢ ∀ x₀ ≥ 16, ∀ r n, x₀² ≤ 2^(r−n) →
                            StmtRelErrWindow (rows of π)
                              (m ↦ 2/log 2 + ∫ t in 1..m, exp (log 2·t)/t) r n
                              (routeConst x₀·(log 2·r)^1·2^(−(r−n)/2))

  C1n ≤ 1909224, C2n ≤ 2167, Cen ≤ 1911393, Cpn ≤ 6534550000,
  Chn ≤ 44108300000, Csn ≤ 1136, Dln ≤ 89846200,
  c1n ≤ 88216610000, c3n ≤ 15, c4n ≤ 6468930000

`relErrWindow_route_num` is `RouteGate.relErrWindow_route` with no "there
exists": the constant is a definition, and the lemmas above bound each of its
three inputs by a numeral.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.GlueNum
import Stage3.RouteGate

namespace RouteNum

open Finset

noncomputable section

theorem inv_log_two_le : 1 / Real.log 2 ≤ 1.4428 := by
  have hl : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  rw [div_le_iff₀ hl]
  nlinarith [Real.log_two_gt_d9]

theorem C1n_le : EdgeBound.C1n ≤ 1909224 := by
  have hlogR : (3:ℝ) / 98 ≤ Real.log ((49/50:ℝ) / (19/20)) := by
    have h1 : Real.log (95 / 98) ≤ 95 / 98 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
    rw [show ((49/50:ℝ) / (19/20)) = ((95:ℝ) / 98)⁻¹ by norm_num, Real.log_inv]
    linarith
  have hG0 : (0:ℝ) ≤ 16 * (23/25:ℝ) ^ 2 / ((23/25:ℝ) - 22/25) ^ 3
      + 1 / (((49/50:ℝ) ^ 2 / (19/20) - 19/20) * Real.log ((49/50:ℝ) / (19/20))) := by
    have h1 : (0:ℝ) < Real.log ((49/50:ℝ) / (19/20)) := by linarith
    have h2 : (0:ℝ) < (49/50:ℝ) ^ 2 / (19/20) - 19/20 := by norm_num
    positivity
  have hG : 16 * (23/25:ℝ) ^ 2 / ((23/25:ℝ) - 22/25) ^ 3
      + 1 / (((49/50:ℝ) ^ 2 / (19/20) - 19/20) * Real.log ((49/50:ℝ) / (19/20)))
      ≤ 212136 := by
    have e1 : 16 * (23/25:ℝ) ^ 2 / ((23/25:ℝ) - 22/25) ^ 3 = 211600 := by norm_num
    have e2 : ((49/50:ℝ) ^ 2 / (19/20) - 19/20) = 579 / 9500 := by norm_num
    have e3 : 1 / ((579 / 9500 : ℝ) * Real.log ((49/50:ℝ) / (19/20))) ≤ 536 := by
      rw [div_le_iff₀ (by positivity)]
      nlinarith
    rw [e1, e2]
    linarith
  have hc := BoxBounds.zeta_ratio_ge
  have hcpos : (0:ℝ) < ‖riemannZeta 3 / riemannZeta (3/2)‖ := by linarith
  have hl : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have hD : 135 * 81 / (4 * ‖riemannZeta 3 / riemannZeta (3/2)‖) + 2 ≤ (2:ℝ) ^ (14:ℕ) := by
    have h1 : (135 * 81 : ℝ) / (4 * ‖riemannZeta 3 / riemannZeta (3/2)‖)
        ≤ 135 * 81 / (4 * (2/7)) :=
      div_le_div_of_nonneg_left (by norm_num) (by norm_num) (by linarith)
    norm_num at h1 ⊢
    linarith
  have hDpos : (0:ℝ) < 135 * 81 / (4 * ‖riemannZeta 3 / riemannZeta (3/2)‖) + 2 := by
    positivity
  have hlogD : Real.log (135 * 81 / (4 * ‖riemannZeta 3 / riemannZeta (3/2)‖) + 2)
      ≤ 14 * Real.log 2 := by
    have h2 := Real.log_le_log hDpos hD
    rw [Real.log_pow] at h2
    push_cast at h2
    linarith
  have hD1 : (1:ℝ) ≤ 135 * 81 / (4 * ‖riemannZeta 3 / riemannZeta (3/2)‖) + 2 := by
    have : (0:ℝ) < 135 * 81 / (4 * ‖riemannZeta 3 / riemannZeta (3/2)‖) := by positivity
    linarith
  have hA0 : (0:ℝ) ≤ Real.log (135 * 81 / (4 * ‖riemannZeta 3 / riemannZeta (3/2)‖) + 2)
      / Real.log 2 + 4 := by
    have := Real.log_nonneg hD1
    positivity
  have hA : Real.log (135 * 81 / (4 * ‖riemannZeta 3 / riemannZeta (3/2)‖) + 2)
      / Real.log 2 + 4 ≤ 18 := by
    have h3 : Real.log (135 * 81 / (4 * ‖riemannZeta 3 / riemannZeta (3/2)‖) + 2)
        / Real.log 2 ≤ 14 := by
      rw [div_le_iff₀ hl]
      exact hlogD
    linarith
  have key : ∀ g a : ℝ, 0 ≤ g → g ≤ 212136 → 0 ≤ a → a ≤ 18 → g / 2 * a ≤ 1909224 := by
    intro g a h1 h2 h3 h4
    nlinarith [mul_le_mul h2 h4 h3 (by norm_num : (0:ℝ) ≤ 212136)]
  unfold EdgeBound.C1n
  exact key _ _ hG0 hG hA0 hA

theorem C2n_le : EdgeBound.C2n ≤ 2167 := by
  have hM := EdgeBound.low_rect_count
  have hM0 : (0:ℝ) ≤ ∑ ρ ∈ (ContourShift.zeta_zeros_rectangle_finite (0:ℂ)
      ((1:ℝ) + Complex.I * (6:ℝ))).toFinset, (analyticOrderNatAt riemannZeta ρ : ℝ) :=
    Finset.sum_nonneg (fun _ _ ↦ Nat.cast_nonneg _)
  have hi := inv_log_two_le
  have hl : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have hi0 : (0:ℝ) ≤ 1 / Real.log 2 := by positivity
  have h1 : (∑ ρ ∈ (ContourShift.zeta_zeros_rectangle_finite (0:ℂ)
      ((1:ℝ) + Complex.I * (6:ℝ))).toFinset, (analyticOrderNatAt riemannZeta ρ : ℝ))
      / Real.log 2 ≤ 714 * 1.4428 := by
    rw [div_eq_mul_one_div]
    exact mul_le_mul hM hi hi0 (by norm_num)
  have h2 : (88:ℝ) / Real.log 2 ≤ 88 * 1.4428 := by
    rw [div_eq_mul_one_div]
    exact mul_le_mul_of_nonneg_left hi (by norm_num)
  unfold EdgeBound.C2n
  norm_num at h1 h2 ⊢
  linarith

theorem Cen_le : EdgeBound.Cen ≤ 1911393 := by
  have h1 := C1n_le
  have h2 := C2n_le
  have h3 := inv_log_two_le
  unfold EdgeBound.Cen
  norm_num at h3 ⊢
  linarith

theorem Cpn_le : Glue.Cpn ≤ 6534550000 := by
  have h1 := Cen_le
  have h0 := EdgeBound.Cen_pos
  have hi := inv_log_two_le
  have hl : (0:ℝ) < Real.log 2 := Real.log_pos (by norm_num)
  have h2 : (1060:ℝ) / Real.log 2 ≤ 1060 * 1.4428 := by
    rw [div_eq_mul_one_div]
    exact mul_le_mul_of_nonneg_left hi (by norm_num)
  have h3 : (0:ℝ) ≤ 1060 / Real.log 2 := by positivity
  unfold Glue.Cpn
  have h4 : EdgeBound.Cen * 2 * (180 + 1060 / Real.log 2)
      ≤ 1911393 * 2 * (180 + 1060 * 1.4428) :=
    mul_le_mul (by linarith) (by linarith) (by linarith) (by norm_num)
  norm_num at h4 ⊢
  linarith

theorem Chn_le : Glue.Chn ≤ 44108300000 := by
  have h1 := Cpn_le
  unfold Glue.Chn
  linarith

theorem Csn_le : Glue.Csn ≤ 1136 := by
  have hi := inv_log_two_le
  have h2 : (88:ℝ) / Real.log 2 ≤ 88 * 1.4428 := by
    rw [div_eq_mul_one_div]
    exact mul_le_mul_of_nonneg_left hi (by norm_num)
  unfold Glue.Csn
  norm_num at h2 ⊢
  linarith

theorem Dln_le : Glue.Dln ≤ 89846200 := by
  have h1 := Cen_le
  have hi := inv_log_two_le
  have h2 : (9 * (1620000 + 1) : ℝ) / Real.log 2 ≤ 9 * (1620000 + 1) * 1.4428 := by
    rw [div_eq_mul_one_div]
    exact mul_le_mul_of_nonneg_left hi (by norm_num)
  unfold Glue.Dln
  norm_num at h2 ⊢
  linarith

theorem c1n_le : Glue.c1n ≤ 88216610000 := by
  have h1 := Chn_le
  have h2 := Csn_le
  unfold Glue.c1n
  linarith

theorem c3n_le : Glue.c3n ≤ 15 := by
  unfold Glue.c3n
  rw [Stage3.norm_logDerivZeta_zero]
  have h1 : Real.log (2 * Real.pi) ≤ Real.log 8 :=
    Real.log_le_log (by positivity) (by nlinarith [Real.pi_lt_d2])
  have h2 : Real.log 8 = 3 * Real.log 2 := by
    rw [show (8:ℝ) = 2 ^ (3:ℕ) by norm_num, Real.log_pow]
    norm_num
  have h3 := Real.log_two_lt_d9
  linarith

theorem c4n_le : Glue.c4n ≤ 6468930000 := by
  have h1 := Dln_le
  unfold Glue.c4n
  linarith

end

end RouteNum

namespace Stage3

open Kadiri Complex Chebyshev
open scoped Chebyshev

noncomputable section

/-- The explicit formula with its constants named. -/
theorem stmtEF_split_num : StmtExplicitFormulaSplit Glue.c1n Glue.c3n Glue.c4n 16 :=
  Glue.explicit_formula_split_num

/-- The route's constant on the `π` side, at floor `x₀`. -/
def routeConst (x₀ : ℝ) : ℝ :=
  3 * floorConstSplit Glue.c1n Glue.c3n Glue.c4n 112 0 698 0 x₀ + 13

/-- **From RH to the `π` side, every constant named.** -/
theorem schoenfeldWeak_route_num (hRH : RiemannHypothesis) {x₀ : ℝ} (hx₀ : 16 ≤ x₀) :
    StmtSchoenfeldWeak (routeConst x₀) 1 (max (x₀ ^ 2) 9)
      (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li := by
  have hRvM2 : 0 ≤ riemannZeta.RvM 112 0 698 2 := by
    unfold riemannZeta.RvM
    have := Real.log_nonneg (show (1 : ℝ) ≤ 2 by norm_num)
    linarith
  have hpsi := psiWeak_floor_split hRH Glue.c1n_nonneg Glue.c3n_nonneg Glue.c4n_nonneg
    (by norm_num) le_rfl (by norm_num) weightedZeroHeightBucket_eq_zero.symm
    hRvM2 stmtEF_split_num ArgCount.rvM_crude hx₀ hx₀
  exact schoenfeldWeak_of_psiWeak (k := 2) le_rfl (by linarith)
    (floorConstSplit_nonneg Glue.c1n_nonneg Glue.c3n_nonneg Glue.c4n_nonneg
      (by norm_num) le_rfl (by norm_num) le_rfl hx₀) hpsi

end

end Stage3

namespace RouteNum

open Finset

noncomputable section

/-- **The route at the gate, every constant named.** -/
theorem relErrWindow_route_num (hRH : RiemannHypothesis) {x₀ : ℝ} (hx₀ : 16 ≤ x₀)
    (r : ℤ) (n : ℕ) (hbot : x₀ ^ 2 ≤ (2 : ℝ) ^ ((r : ℝ) - n)) :
    JointDialGate.StmtRelErrWindow
      (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
      (fun m : ℤ => 2 / Real.log 2
        + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r n
      (Stage3.routeConst x₀ * (Real.log 2 * r) ^ 1
        * (2 : ℝ) ^ (-(((r : ℝ) - n) / 2))) := by
  have hpos : 0 < (r : ℝ) - n := by
    by_contra hneg
    push_neg at hneg
    have h1 : (2 : ℝ) ^ ((r : ℝ) - n) ≤ 1 :=
      Real.rpow_le_one_of_one_le_of_nonpos (by norm_num) hneg
    nlinarith
  have hpi := Stage3.schoenfeldWeak_route_num hRH hx₀
  have hC : 0 ≤ Stage3.routeConst x₀ := by
    have := Stage3.floorConstSplit_nonneg (b₁ := 112) (b₂ := 0) (b₃ := 698) (W := 0)
      (x₀ := x₀) Glue.c1n_nonneg Glue.c3n_nonneg Glue.c4n_nonneg
      (by norm_num) le_rfl (by norm_num) le_rfl hx₀
    unfold Stage3.routeConst
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

/-- info: 'RouteNum.relErrWindow_route_num' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms relErrWindow_route_num

/-- info: 'RouteNum.c1n_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms c1n_le

/-- info: 'RouteNum.c3n_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms c3n_le

/-- info: 'RouteNum.c4n_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms c4n_le

end RouteNum
