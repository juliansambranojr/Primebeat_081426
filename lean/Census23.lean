/-
Census23 — rows 1 … 23 from the primes, and the named π input narrowed to rows 24 … 92.

`PiChunks.piData_le23` proves the π list through row 23 (`PiRow23`, Legendre's formula). So the census of
rows 1 … 23 at every depth holds with no named input, and `StmtPiData24`, the π list on rows 24 … 92,
gives back `PiNarrow.StmtPiData23`.
-/
import Mathlib
import ToInfinity
import Census20
import PiRow23
import PiNarrow

namespace Census23

/-- **The four zeros in rows 1 … 23, every depth, with no input.** -/
theorem only_four_zeros_le23 {r : Int} {d : Nat} (hd : 1 ≤ d) (hlo : (d : Int) < r) (h23 : r ≤ 23)
    (hz : Construction.tableFrom ToInfinity.trueRow r d = 0) :
    (r, d) = (2, 1) ∨ (r, d) = (4, 1) ∨ (r, d) = (8, 3) ∨ (r, d) = (20, 6) :=
  ToInfinity.census_zero hd hlo (by omega)
    (by rw [Census20.cell_eq_true_le (R := 23) (by norm_num) PiChunks.piData_le23 r d hlo h23]; exact hz)

/-- The π list on rows 24 … 92, the part no proof in the tree reaches. -/
def StmtPiData24 : Prop :=
  ∀ n : Nat, 24 ≤ n → n ≤ 92 → (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int)

theorem piData23_of_24 (h : StmtPiData24) : PiNarrow.StmtPiData23 := by
  intro n hn hn92
  rcases Nat.lt_or_ge n 24 with h23 | h24
  · exact PiChunks.piData_le23 n (by omega)
  · exact h n h24 hn92

end Census23

/-- info: 'Census23.only_four_zeros_le23' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Census23.only_four_zeros_le23

/-- info: 'Census23.piData23_of_24' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Census23.piData23_of_24
