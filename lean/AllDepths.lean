/-
AllDepths — every cell of Julian's table to row 92, every depth, by the kernel.

`tableFrom` recomputes each cell from scratch, two calls per depth, so the kernel cannot reach depth
ninety through it. Here the table is built row-list by row-list: each depth is the list of
differences of the one above (`diffs`), and `tab_eq` proves that list is `tableFrom`, entry by entry.
Then the kernel reads all 4278 cells and finds exactly the four zeros. The rows are `DepthSix.row`,
π(2^n) from the OEIS list, an input named by `DepthSix.StmtPiData`.
-/
import Mathlib
import Construction
import DepthSix

namespace AllDepths

/-- One step down the table: neighbouring differences. -/
def diffs (l : List Int) : List Int := List.zipWith (fun a b => b - a) l l.tail

/-- The depth-0 row as a list, rows 1 … 92. -/
def row0 : List Int := (List.range 92).map (fun i => DepthSix.row (i + 1 : Nat))

/-- Depth `d` as a list: entry `i` is the cell at row `i + 1 + d`. -/
def tab : Nat → List Int
  | 0 => row0
  | d + 1 => diffs (tab d)

theorem length_tab (d : Nat) : (tab d).length = 92 - d := by
  induction d with
  | zero => simp [tab, row0]
  | succ n ih => simp [tab, diffs, List.length_zipWith, ih]; omega

/-- **The list table is the table.** -/
theorem tab_eq (d i : Nat) (h : i + d < 92) :
    (tab d).getD i 0 = Construction.tableFrom DepthSix.row ((i + 1 + d : Nat) : Int) d := by
  induction d generalizing i with
  | zero =>
    simp only [tab, row0, Construction.tableFrom]
    rw [List.getD_eq_getElem _ _ (by simp; omega)]
    simp
  | succ n ih =>
    have hl := length_tab n
    have h1 : i + 1 < (tab n).length := by omega
    have h0 : i < (tab n).length := by omega
    simp only [tab, diffs]
    rw [List.getD_eq_getElem _ _ (by simp [List.length_zipWith]; omega)]
    simp only [List.getElem_zipWith, List.getElem_tail]
    rw [← List.getD_eq_getElem _ 0 h1, ← List.getD_eq_getElem _ 0 h0,
      ih (i + 1) (by omega), ih i (by omega)]
    rw [Construction.tableFrom]
    congr 2 <;> push_cast <;> ring

/-- The cells at zero, read from the list table: `(row, depth)`. -/
def zeroCells : List (Nat × Nat) :=
  (List.range 92).flatMap (fun d =>
    ((List.range (92 - d)).filter (fun i => (tab d).getD i 0 == 0)).map (fun i => (i + 1 + d, d)))

/-- **The kernel finds exactly four zeros**, at every depth, to row 92 (depth 0 included, where a
row of primes is never empty past the first rows). -/
theorem zeroCells_eq : zeroCells = [(2, 1), (4, 1), (8, 3), (20, 6)] := by decide

end AllDepths

/-- info: 'AllDepths.tab_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms AllDepths.tab_eq

/-- info: 'AllDepths.zeroCells_eq' depends on axioms: [propext] -/
#guard_msgs in
#print axioms AllDepths.zeroCells_eq
