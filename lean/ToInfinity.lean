/-
ToInfinity — the reach of Julian's invariant, stated on the true prime count.

`AllDepths.zeroCells_eq` finds the four zeros among the cells built from the OEIS list to row 92.
`DepthSix.StmtPiData` names the input: that list is π at powers of two. Here the true row,
`π(2^r) − π(2^(r−1))` from Mathlib's `Nat.primeCounting`, is shown equal to the list's row up to
row 92 under that input, so every cell the census reads is a cell of the true table.
-/
import Mathlib
import Construction
import DepthSix
import AllDepths

namespace ToInfinity

/-- The true row of the dyadic table: the primes in `(2^(r−1), 2^r]`, for `r ≥ 1`. -/
noncomputable def trueRow (r : Int) : Int :=
  if 1 ≤ r then (Nat.primeCounting (2 ^ r.toNat) : Int) - Nat.primeCounting (2 ^ (r - 1).toNat) else 0

/-- **Under the named input, the list's row is the true row up to row 92.** -/
theorem row_eq_trueRow (hpi : DepthSix.StmtPiData) {r : Int} (h1 : 1 ≤ r) (h92 : r ≤ 92) :
    DepthSix.row r = trueRow r := by
  unfold DepthSix.row trueRow
  rw [if_pos ⟨h1, h92⟩, if_pos h1]
  rw [hpi r.toNat (by omega), hpi (r - 1).toNat (by omega)]

/-- **A cell whose window sits inside rows 1 … 92 is the same in both tables.** -/
theorem cell_eq_true (hpi : DepthSix.StmtPiData) (r : Int) (d : Nat) (hlo : (d : Int) < r)
    (h92 : r ≤ 92) :
    Construction.tableFrom DepthSix.row r d = Construction.tableFrom trueRow r d := by
  induction d generalizing r with
  | zero => simp only [Construction.tableFrom]; exact row_eq_trueRow hpi (by omega) h92
  | succ n ih =>
    simp only [Construction.tableFrom]
    rw [ih r (by omega) h92, ih (r - 1) (by omega) (by omega)]

end ToInfinity

/-- info: 'ToInfinity.cell_eq_true' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ToInfinity.cell_eq_true
