/-
Census20 — the bottom of the true table, proved from the primes with nothing assumed.

Every cell in rows 1 … 20 reads `π(2^m)` only for `m ≤ 20`, and those are proved
(`PiChunks.piData_le20`). So the census of rows 1 … 20 at every depth holds with no named
input: the only zeros are (2,1), (4,1), (8,3) and (20,6).
-/
import Mathlib
import ToInfinity
import PiRow20

namespace Census20

theorem row_eq_trueRow_le {R : Nat} (hR : R ≤ 92)
    (hpi : ∀ n : Nat, n ≤ R → (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int))
    {r : Int} (h1 : 1 ≤ r) (hr : r ≤ R) :
    DepthSix.row r = ToInfinity.trueRow r := by
  unfold DepthSix.row ToInfinity.trueRow
  rw [if_pos ⟨h1, by omega⟩, if_pos h1]
  rw [hpi r.toNat (by omega), hpi (r - 1).toNat (by omega)]

theorem cell_eq_true_le {R : Nat} (hR : R ≤ 92)
    (hpi : ∀ n : Nat, n ≤ R → (DepthSix.piTwoPow.getD n 0 : Int) = (Nat.primeCounting (2 ^ n) : Int))
    (r : Int) (d : Nat) (hlo : (d : Int) < r) (hr : r ≤ R) :
    Construction.tableFrom DepthSix.row r d = Construction.tableFrom ToInfinity.trueRow r d := by
  induction d generalizing r with
  | zero => simp only [Construction.tableFrom]; exact row_eq_trueRow_le hR hpi (by omega) hr
  | succ n ih =>
    simp only [Construction.tableFrom]
    rw [ih r (by omega) hr, ih (r - 1) (by omega) (by omega)]

/-- **The four zeros in rows 1 … 20, every depth, with no input.** -/
theorem only_four_zeros_le20 {r : Int} {d : Nat} (hd : 1 ≤ d) (hlo : (d : Int) < r) (h20 : r ≤ 20)
    (hz : Construction.tableFrom ToInfinity.trueRow r d = 0) :
    (r, d) = (2, 1) ∨ (r, d) = (4, 1) ∨ (r, d) = (8, 3) ∨ (r, d) = (20, 6) :=
  ToInfinity.census_zero hd hlo (by omega)
    (by rw [cell_eq_true_le (R := 20) (by norm_num) PiChunks.piData_le20 r d hlo h20]; exact hz)

/-- **And (20,6) is a zero of the true table**, proved from the primes. -/
theorem zero_20_6_true : Construction.tableFrom ToInfinity.trueRow 20 6 = 0 := by
  rw [← cell_eq_true_le (R := 20) (by norm_num) PiChunks.piData_le20 20 6 (by norm_num) le_rfl]
  exact DepthSix.zero_20_6

end Census20

/-- info: 'Census20.only_four_zeros_le20' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Census20.only_four_zeros_le20

/-- info: 'Census20.zero_20_6_true' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Census20.zero_20_6_true
