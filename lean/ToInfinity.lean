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
import Nonvanishing
import RelativeGate
import Interpolant

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

namespace ToInfinity

open Finset

/-- The prime count at powers of two, as a real function of the row. -/
noncomputable def piRow (m : Int) : ℝ := (Nat.primeCounting (2 ^ m.toNat) : ℝ)

/-- The true row is the backward difference of `piRow`. -/
theorem trueRow_eq_bdiff {m : Int} (hm : 1 ≤ m) :
    ((trueRow m : Int) : ℝ) = Nonvanishing.bdiffZ piRow m := by
  unfold trueRow Nonvanishing.bdiffZ piRow
  rw [if_pos hm]; push_cast; ring

/-- The census, read off the list table: a zero cell of the list table within rows 1 … 92 is one of
the four. -/
theorem census_zero {r : Int} {d : Nat} (_hd : 1 ≤ d) (hlo : (d : Int) < r) (h92 : r ≤ 92)
    (hz : Construction.tableFrom DepthSix.row r d = 0) :
    (r, d) = (2, 1) ∨ (r, d) = (4, 1) ∨ (r, d) = (8, 3) ∨ (r, d) = (20, 6) := by
  obtain ⟨i, hi⟩ : ∃ i : Nat, r = ((i + 1 + d : Nat) : Int) := ⟨(r - 1 - d).toNat, by omega⟩
  subst hi
  have hid : i + d < 92 := by omega
  have hget : (AllDepths.tab d).getD i 0 = 0 := by rw [AllDepths.tab_eq d i hid]; exact hz
  have hmem : (i + 1 + d, d) ∈ AllDepths.zeroCells := by
    unfold AllDepths.zeroCells
    rw [List.mem_flatMap]
    refine ⟨d, List.mem_range.mpr (by omega), ?_⟩
    rw [List.mem_map]
    refine ⟨i, ?_, rfl⟩
    rw [List.mem_filter]
    refine ⟨List.mem_range.mpr (by omega), ?_⟩
    simpa using hget
  rw [AllDepths.zeroCells_eq] at hmem
  simp only [List.mem_cons, List.mem_nil_iff, or_false, Prod.mk.injEq] at hmem
  rcases hmem with ⟨h1, h2⟩ | ⟨h1, h2⟩ | ⟨h1, h2⟩ | ⟨h1, h2⟩ <;>
    [left; (right; left); (right; right; left); (right; right; right)] <;>
    simp only [Prod.mk.injEq] <;> constructor <;> omega

/-- **The reach of Julian's invariant.** Under the named π list (`StmtPiData`) and one named input,
a relative-error bound on π at powers of two against the table's main term, at the price the gate
asks, past row 92 at depths 1 … 11: every zero of the true table at those depths is one of the four.
The input is the shape of the FKS2 tables (in PNT+, behind `Table4Ext.allCells_trusted`); it is not
the conclusion. -/
theorem only_four_zeros (hpi : DepthSix.StmtPiData)
    (hbound : ∀ r : Int, 92 < r → ∀ d : Nat, 1 ≤ d → d ≤ 11 →
      ∃ ρ : ℝ, RelativeGate.StmtRelErrWindow piRow (fun k : Int => Interpolant.liRow k) r (d + 1) ρ ∧
        ρ < Real.log 2 ^ d / (2 * r * 3 ^ (d + 1)))
    {r : Int} {d : Nat} (hd : 1 ≤ d) (hd11 : d ≤ 11) (hlo : (d : Int) < r)
    (hz : Construction.tableFrom trueRow r d = 0) :
    (r, d) = (2, 1) ∨ (r, d) = (4, 1) ∨ (r, d) = (8, 3) ∨ (r, d) = (20, 6) := by
  by_cases h92 : r ≤ 92
  · exact census_zero hd hlo h92 (by rw [cell_eq_true hpi r d hlo h92]; exact hz)
  · exfalso
    obtain ⟨ρ, hS, hρ⟩ := hbound r (by omega) d hd hd11
    have hr : (93 : ℝ) ≤ r := by exact_mod_cast (show (93 : Int) ≤ r by omega)
    have hdR : (d : ℝ) ≤ 11 := by exact_mod_cast hd11
    have hlog : (0.69 : ℝ) < Real.log 2 := by have := Real.log_two_gt_d9; linarith
    refine Interpolant.tableFrom_ne_zero_of_relErr_liRow (f := piRow) ?_ hS ?_ ?_ hρ hz
    · intro k hk
      have := Finset.mem_range.mp hk
      exact trueRow_eq_bdiff (by omega)
    · linarith
    · nlinarith

end ToInfinity

/-- info: 'ToInfinity.only_four_zeros' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ToInfinity.only_four_zeros
