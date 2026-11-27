/-
Census25 — rows 1 … 25 from the primes, and the named π input narrowed to rows 26 … 92.

`PiChunks.piData_le25` proves the π list through row 25 (`PiRow25`, Legendre's formula). So the census of
rows 1 … 25 at every depth holds with no named input, and `StmtPiData26`, the π list on rows 26 … 92,
gives back `Census24.StmtPiData25`.
-/
import Mathlib
import ToInfinity
import Census20
import PiRow25
import Census24

namespace Census25

/-- **The four zeros in rows 1 … 25, every depth, with no input.** -/
theorem only_four_zeros_le25 {r : Int} {d : Nat} (hd : 1 ≤ d) (hlo : (d : Int) < r) (h25 : r ≤ 25)
    (hz : Construction.tableFrom ToInfinity.trueRow r d = 0) :
    (r, d) = (2, 1) ∨ (r, d) = (4, 1) ∨ (r, d) = (8, 3) ∨ (r, d) = (20, 6) :=
  ToInfinity.census_zero hd hlo (by omega)
    (by rw [Census20.cell_eq_true_le (R := 25) (by norm_num) PiChunks.piData_le25 r d hlo h25]; exact hz)

/-- The π list on rows 26 … 92, the part no proof in the tree reaches. -/
def StmtPiData26 : Prop :=
  ∀ n : Nat, 26 ≤ n → n ≤ 92 → (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int)

theorem piData25_of_26 (h : StmtPiData26) : Census24.StmtPiData25 := by
  intro n hn hn92
  rcases Nat.lt_or_ge n 26 with h25 | h26
  · exact PiChunks.piData_le25 n (by omega)
  · exact h n h26 hn92

end Census25

/-- info: 'Census25.only_four_zeros_le25' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Census25.only_four_zeros_le25

/-- info: 'Census25.piData25_of_26' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Census25.piData25_of_26
