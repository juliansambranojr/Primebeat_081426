/-
Census24 — rows 1 … 24 from the primes, and the named π input narrowed to rows 25 … 92.

`PiChunks.piData_le24` proves the π list through row 24 (`PiRow24`, Legendre's formula). So the census of
rows 1 … 24 at every depth holds with no named input, and `StmtPiData25`, the π list on rows 25 … 92,
gives back `Census23.StmtPiData24`.
-/
import Mathlib
import ToInfinity
import Census20
import PiRow24
import Census23

namespace Census24

/-- **The four zeros in rows 1 … 24, every depth, with no input.** -/
theorem only_four_zeros_le24 {r : Int} {d : Nat} (hd : 1 ≤ d) (hlo : (d : Int) < r) (h24 : r ≤ 24)
    (hz : Construction.tableFrom ToInfinity.trueRow r d = 0) :
    (r, d) = (2, 1) ∨ (r, d) = (4, 1) ∨ (r, d) = (8, 3) ∨ (r, d) = (20, 6) :=
  ToInfinity.census_zero hd hlo (by omega)
    (by rw [Census20.cell_eq_true_le (R := 24) (by norm_num) PiChunks.piData_le24 r d hlo h24]; exact hz)

/-- The π list on rows 25 … 92, the part no proof in the tree reaches. -/
def StmtPiData25 : Prop :=
  ∀ n : Nat, 25 ≤ n → n ≤ 92 → (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int)

theorem piData24_of_25 (h : StmtPiData25) : Census23.StmtPiData24 := by
  intro n hn hn92
  rcases Nat.lt_or_ge n 25 with h24 | h25
  · exact PiChunks.piData_le24 n (by omega)
  · exact h n h25 hn92

end Census24

/-- info: 'Census24.only_four_zeros_le24' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Census24.only_four_zeros_le24

/-- info: 'Census24.piData24_of_25' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Census24.piData24_of_25
