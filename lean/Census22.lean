/-
Census22 — the bottom of the true table, proved from the primes with nothing assumed.

Every cell in rows 1 … 22 reads `π(2^m)` only for `m ≤ 22`, and those are proved
(`PiChunks.piData_le22`). So the census of rows 1 … 22 at every depth holds with no named
input: the only zeros are (2,1), (4,1), (8,3) and (20,6).
-/
import Mathlib
import ToInfinity
import Census20
import PiRow22

namespace Census22

/-- **The four zeros in rows 1 … 22, every depth, with no input.** -/
theorem only_four_zeros_le22 {r : Int} {d : Nat} (hd : 1 ≤ d) (hlo : (d : Int) < r) (h22 : r ≤ 22)
    (hz : Construction.tableFrom ToInfinity.trueRow r d = 0) :
    (r, d) = (2, 1) ∨ (r, d) = (4, 1) ∨ (r, d) = (8, 3) ∨ (r, d) = (20, 6) :=
  ToInfinity.census_zero hd hlo (by omega)
    (by rw [Census20.cell_eq_true_le (R := 22) (by norm_num) PiChunks.piData_le22 r d hlo h22]; exact hz)

end Census22

/-- info: 'Census22.only_four_zeros_le22' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Census22.only_four_zeros_le22

