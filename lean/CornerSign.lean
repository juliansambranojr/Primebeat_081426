/-
CornerSign — a cell whose two parents have opposite signs is not zero.

A cell at depth `d+1` is its two depth-`d` parents' difference (`Construction.tableFrom`).
If those parents have opposite signs the difference cannot vanish. Measured to row 92 this
session: of the 2878 corner cells past `r ≈ 3.5d`, 2577 have opposite-sign parents, so
nonvanishing there is a property of the sign pattern one depth up. The other 301 have
same-sign parents, and among them only (20,6) has equal parents.
-/
import Mathlib
import Construction

namespace CornerSign

/-- **Opposite-sign parents give a nonzero child.** -/
theorem ne_zero_of_opposite (N : Int → Int) (r : Int) (d : Nat)
    (h : Construction.tableFrom N r d * Construction.tableFrom N (r - 1) d < 0) :
    Construction.tableFrom N r (d + 1) ≠ 0 := by
  show Construction.tableFrom N r d - Construction.tableFrom N (r - 1) d ≠ 0
  intro h0
  have : Construction.tableFrom N r d = Construction.tableFrom N (r - 1) d := by omega
  rw [this] at h
  nlinarith [mul_self_nonneg (Construction.tableFrom N (r - 1) d)]

/-- **Same sign, different size, also nonzero.** -/
theorem ne_zero_of_natAbs_ne (N : Int → Int) (r : Int) (d : Nat)
    (h : (Construction.tableFrom N r d).natAbs ≠ (Construction.tableFrom N (r - 1) d).natAbs) :
    Construction.tableFrom N r (d + 1) ≠ 0 := by
  show Construction.tableFrom N r d - Construction.tableFrom N (r - 1) d ≠ 0
  intro h0
  apply h
  rw [show Construction.tableFrom N r d = Construction.tableFrom N (r - 1) d by omega]

end CornerSign

/-- info: 'CornerSign.ne_zero_of_opposite' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms CornerSign.ne_zero_of_opposite

/-- info: 'CornerSign.ne_zero_of_natAbs_ne' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms CornerSign.ne_zero_of_natAbs_ne
