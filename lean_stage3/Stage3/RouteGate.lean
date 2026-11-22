/-
RouteGate — block E6 of `lean_stage3/design/joints.md`. 2026-11-22.

The explicit-formula route at the gate's statement (unit 0411) with two of
its leaves substituted: `W = 0` (unit 0414) and the main term written as the
formula the table tree's interpolant has at the rows (unit 0413).

  relErrWindow_route   RH ⊢ ∃ c₁ c₃ c₄ ≥ 0, ∀ x₀ ≥ 16, ∀ r n, x₀² ≤ 2^(r−n) →
                         StmtRelErrWindow (rows of π)
                           (m ↦ 2/log 2 + ∫ t in 1..m, exp (log 2·t)/t) r n
                           ((3·floorConstSplit c₁ c₃ c₄ 112 0 698 0 x₀ + 13)
                              ·(log 2·r)^1·2^(−(r−n)/2))

The main term is `lean/Interpolant.liRow` at the rows (`liRow_eq`), so this
is the hypothesis `hS` of `lean/Interpolant.tableFrom_ne_zero_of_relErr_liRow`
with `n = d + 1`. The two trees meet by statement text.

What the next slice needs: the constants as numerals (`M0`, `Mc`, the compact
patch), and `c₃` exposed if `K0 = log 2π` is to be read off.

Axioms: the pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.JointFloorGate
import Stage3.RowLeaves
import Stage3.RealSegment

namespace RouteGate

open Finset

noncomputable section

theorem relErrWindow_route (hRH : RiemannHypothesis) :
    ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ ∀ x₀ : ℝ, 16 ≤ x₀ →
      ∀ (r : ℤ) (n : ℕ), x₀ ^ 2 ≤ (2 : ℝ) ^ ((r : ℝ) - n) →
      JointDialGate.StmtRelErrWindow
        (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
        (fun m : ℤ => 2 / Real.log 2
          + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r n
        ((3 * Stage3.floorConstSplit c₁ c₃ c₄ 112 0 698 0 x₀ + 13)
          * (Real.log 2 * r) ^ 1 * (2 : ℝ) ^ (-(((r : ℝ) - n) / 2))) := by
  obtain ⟨c₁, c₃, c₄, hc₁, hc₃, hc₄, h⟩ := JointFloorGate.relErrWindow_floor_of_RH hRH
  refine ⟨c₁, c₃, c₄, hc₁, hc₃, hc₄, fun x₀ hx₀ r n hbot => ?_⟩
  have hpos : 0 < (r : ℝ) - n := by
    by_contra hneg
    push_neg at hneg
    have h1 : (2 : ℝ) ^ ((r : ℝ) - n) ≤ 1 :=
      Real.rpow_le_one_of_one_le_of_nonpos (by norm_num) hneg
    nlinarith
  have hW := h x₀ hx₀ r n hbot hpos.le
  rw [Stage3.weightedZeroHeightBucket_eq_zero] at hW
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

/-- info: 'RouteGate.relErrWindow_route' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms relErrWindow_route

end RouteGate
