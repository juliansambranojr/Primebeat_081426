/-
Census21 — the bottom of the true table, proved from the primes with nothing assumed.

Every cell in rows 1 … 21 reads `π(2^m)` only for `m ≤ 21`, and those are proved
(`PiChunks.piData_le21`). So the census of rows 1 … 21 at every depth holds with no named
input: the only zeros are (2,1), (4,1), (8,3) and (20,6).
-/
import Mathlib
import ToInfinity
import Census20
import PiRow21

namespace Census21

/-- **The four zeros in rows 1 … 21, every depth, with no input.** -/
theorem only_four_zeros_le21 {r : Int} {d : Nat} (hd : 1 ≤ d) (hlo : (d : Int) < r) (h21 : r ≤ 21)
    (hz : Construction.tableFrom ToInfinity.trueRow r d = 0) :
    (r, d) = (2, 1) ∨ (r, d) = (4, 1) ∨ (r, d) = (8, 3) ∨ (r, d) = (20, 6) :=
  ToInfinity.census_zero hd hlo (by omega)
    (by rw [Census20.cell_eq_true_le (R := 21) (by norm_num) PiChunks.piData_le21 r d hlo h21]; exact hz)

end Census21

/-- info: 'Census21.only_four_zeros_le21' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Census21.only_four_zeros_le21

