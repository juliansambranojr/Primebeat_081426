/-
Capstone — every zero outside the open corner, in one statement.

`OpenCorner r d`: depth at least 17, row at least 93, and below both lines of `WeakDepths`
(`r < 4d + 30`, and `r < 3.7d + 39` when `d ≥ 30`). `only_four_zeros_outside_corner`: with the π list on
rows 23 … 92 (`PiNarrow.StmtPiData23`) and the two-floor route (`WeakDepths.StmtRoute13`, which
`lean_stage3/Stage3/RouteTight.lean`'s `RouteSharp.weakWindow13_of_RH` proves from RH, welded), every
zero of the true table outside the open corner is one of the four. The theorem the loop stops on is
this one with the two inputs proved and the open corner empty of zeros.
-/
import Mathlib
import WeakDepths
import Census23
import Census25

namespace Capstone

/-- The cells no proved theorem reaches. -/
def OpenCorner (r : ℤ) (d : ℕ) : Prop :=
  17 ≤ d ∧ 93 ≤ r ∧ (r : ℝ) < 4 * (d : ℝ) + 30 ∧ ¬ (30 ≤ d ∧ 3.7 * (d : ℝ) + 39 ≤ r)

/-- **Every zero outside the open corner is one of the four.** -/
theorem only_four_zeros_outside_corner (hpi : PiNarrow.StmtPiData23) (hW : WeakDepths.StmtRoute13)
    {r : ℤ} {d : ℕ} (hd : 1 ≤ d) (hlo : (d : ℤ) < r) (hout : ¬ OpenCorner r d)
    (hz : Construction.tableFrom ToInfinity.trueRow r d = 0) :
    (r, d) = (2, 1) ∨ (r, d) = (4, 1) ∨ (r, d) = (8, 3) ∨ (r, d) = (20, 6) := by
  by_cases h92 : r ≤ 92
  · exact ToInfinity.census_zero hd hlo h92
      (by rw [ToInfinity.cell_eq_true (PiNarrow.piData_of_23 hpi) r d hlo h92]; exact hz)
  refine WeakDepths.only_four_zeros_rh_line37 hpi hW hd hlo ?_ hz
  unfold OpenCorner at hout
  by_cases h16 : d ≤ 16
  · exact Or.inl h16
  by_cases hl : 4 * (d : ℝ) + 30 ≤ r
  · exact Or.inr (Or.inl hl)
  right; right
  by_contra hc
  exact hout ⟨by omega, by omega, by linarith, hc⟩

/-- **Every zero outside the open corner, on the π list narrowed to rows 24 … 92.** Rows 0 … 23 are
`PiChunks.piData_le23`, proved by the kernel. -/
theorem only_four_zeros_outside_corner24 (hpi : Census23.StmtPiData24) (hW : WeakDepths.StmtRoute13)
    {r : ℤ} {d : ℕ} (hd : 1 ≤ d) (hlo : (d : ℤ) < r) (hout : ¬ OpenCorner r d)
    (hz : Construction.tableFrom ToInfinity.trueRow r d = 0) :
    (r, d) = (2, 1) ∨ (r, d) = (4, 1) ∨ (r, d) = (8, 3) ∨ (r, d) = (20, 6) :=
  only_four_zeros_outside_corner (Census23.piData23_of_24 hpi) hW hd hlo hout hz

/-- **Every zero outside the open corner, on the π list narrowed to rows 26 … 92.** Rows 0 … 25 are
`PiChunks.piData_le25`, proved by the kernel (`Census25.piData25_of_26`, `Census24.piData24_of_25`). -/
theorem only_four_zeros_outside_corner26 (hpi : Census25.StmtPiData26) (hW : WeakDepths.StmtRoute13)
    {r : ℤ} {d : ℕ} (hd : 1 ≤ d) (hlo : (d : ℤ) < r) (hout : ¬ OpenCorner r d)
    (hz : Construction.tableFrom ToInfinity.trueRow r d = 0) :
    (r, d) = (2, 1) ∨ (r, d) = (4, 1) ∨ (r, d) = (8, 3) ∨ (r, d) = (20, 6) :=
  only_four_zeros_outside_corner24 (Census24.piData24_of_25 (Census25.piData25_of_26 hpi)) hW hd hlo hout hz

end Capstone

/-- info: 'Capstone.only_four_zeros_outside_corner' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Capstone.only_four_zeros_outside_corner

/-- info: 'Capstone.only_four_zeros_outside_corner24' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Capstone.only_four_zeros_outside_corner24

/-- info: 'Capstone.only_four_zeros_outside_corner26' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Capstone.only_four_zeros_outside_corner26
