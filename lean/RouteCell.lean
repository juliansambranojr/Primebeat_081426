/-
RouteCell — block E9 of `lean_stage3/design/joints.md`, the table tree's half.

The gate (`Interpolant.tableFrom_ne_zero_of_relErr_liRow`) at depth six, on
the statement the other tree's explicit-formula route proves under RH.

  cell_ne_zero_of_route   80 ≤ r, the row hypothesis, and
                            ∃ ρ, StmtRelErrWindow f (main term) r (6+1) ρ
                                 ∧ ρ < (log 2)^6/(2·r·3^(6+1))
                          ⊢ tableFrom N r 6 ≠ 0

The hypothesis `hroute` is, character for character, the conclusion of
`lean_stage3/Stage3/GateEval.gate_hyp_of_RH`, with this tree's
`RelativeGate.StmtRelErrWindow` for that tree's `JointDialGate.StmtRelErrWindow`
(welded, `utilities/check_weld.py`) and `f` the rows of the prime count. The
two trees are on different toolchains; the kernel checks each half and not
the join.

Read across that join: under RH, no cell at depth six is zero from row 80 on.
-/
import Mathlib
import Interpolant

namespace RouteCell

open Set

/-- If `80 ≤ r`, the integer rows `N (r - k)` for `k ≤ 7` equal the backward differences of `f`,
and `f` sits within relative error `ρ < (log 2)^6/(2·r·3^7)` of the main term on the window
of `8` rows ending at `r`, then the table cell `tableFrom N r 6` at depth six is nonzero. -/
theorem cell_ne_zero_of_route {N : ℤ → ℤ} {f : ℤ → ℝ} {r : ℤ} (hr : 80 ≤ r)
    (hrow : ∀ k ∈ Finset.range (6 + 2),
      ((N (r - k) : ℤ) : ℝ) = Nonvanishing.bdiffZ f (r - k))
    (hroute : ∃ ρ : ℝ, RelativeGate.StmtRelErrWindow f
        (fun m : ℤ => 2 / Real.log 2
          + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r (6 + 1) ρ
      ∧ ρ < Real.log 2 ^ 6 / (2 * r * 3 ^ (6 + 1))) :
    Construction.tableFrom N r 6 ≠ 0 := by
  obtain ⟨ρ, hS, hρ⟩ := hroute
  have hrR : (80 : ℝ) ≤ (r : ℝ) := by exact_mod_cast hr
  have hS' : RelativeGate.StmtRelErrWindow f (fun k : ℤ => Interpolant.liRow k) r (6 + 1) ρ := by
    intro k hk
    have hkn : (k : ℝ) ≤ 7 := by
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
  refine Interpolant.tableFrom_ne_zero_of_relErr_liRow (d := 6) hrow hS' ?_ ?_ hρ
  · push_cast
    linarith
  · push_cast
    nlinarith

/-- info: 'RouteCell.cell_ne_zero_of_route' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RouteCell.cell_ne_zero_of_route

end RouteCell
