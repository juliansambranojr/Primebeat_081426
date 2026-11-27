/-
PiNarrow — the named π input narrowed to the rows not yet proved.

`StmtPiData20`: the list `DepthSix.piTwoPow` agrees with `π(2^n)` on rows 20 … 92. Rows 0 … 19
are `PiChunks.piData_le19`, proved by the kernel. `piData_of_20` rebuilds `StmtPiData`, and
`only_four_zeros_rh20` restates `ExactRH.only_four_zeros_rh` on the narrowed input.
-/
import Mathlib
import PiRow19
import ExactRH

namespace PiNarrow

/-- The π list on rows 20 … 92, the part no proof in the tree reaches. -/
def StmtPiData20 : Prop :=
  ∀ n : Nat, 20 ≤ n → n ≤ 92 → (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int)

theorem piData_of_20 (h : StmtPiData20) : DepthSix.StmtPiData := by
  intro n hn
  rcases Nat.lt_or_ge n 20 with h19 | h20
  · exact PiChunks.piData_le19 n (by omega)
  · exact h n h20 hn

/-- **The four zeros, on the narrowed π input and Schoenfeld's window.** -/
theorem only_four_zeros_rh20 (hpi : StmtPiData20)
    (hRH : ∀ r : Int, 92 < r → ∀ d : Nat,
      Nonvanishing.StmtSchoenfeldWindow ToInfinity.piRow (fun k : Int => Interpolant.liRow k) r (d + 1))
    {r : Int} {d : Nat} (hd : 1 ≤ d) (hlo : (d : Int) < r)
    (hin : r ≤ 92 ∨ (3 * (d : ℝ) + 1 < r ∧ Nonvanishing.Ehigh r (d + 1) < ExactGate.floorX r d))
    (hz : Construction.tableFrom ToInfinity.trueRow r d = 0) :
    (r, d) = (2, 1) ∨ (r, d) = (4, 1) ∨ (r, d) = (8, 3) ∨ (r, d) = (20, 6) :=
  ExactRH.only_four_zeros_rh (piData_of_20 hpi) hRH hd hlo hin hz

end PiNarrow

/-- info: 'PiNarrow.only_four_zeros_rh20' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PiNarrow.only_four_zeros_rh20
