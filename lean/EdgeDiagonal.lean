/-
EdgeDiagonal — the table's edge diagonals are forward differences, and they read each
exponential `z^m` with the factor `(z − 1)^d`.

`edge_eq_fwdDiff`: the cell `(g + d, d)` is the `d`-th forward difference of the row
sequence at row `g`. `fwdDiff_iter_geom`: the `d`-th forward difference of `z^m` is
`(z − 1)^d · z^m`. For the main term `z = 2` the factor is `1` per depth
(`fwdDiff_iter_two`); for a zeta zero `ρ` it is `(2^ρ − 1)^d`, whose modulus reaches `1 + √2`
on the critical line and `2^β + 1` at real part `β`. Along an edge diagonal the zeros
outgrow the main term; that is the deep corner.
-/
import Mathlib
import Construction

namespace EdgeDiagonal

/-- **The edge diagonal is a forward difference.** -/
theorem edge_eq_fwdDiff (N : ℤ → ℤ) (d : ℕ) :
    ∀ g : ℤ, Construction.tableFrom N (g + d) d = (fwdDiff 1)^[d] N g := by
  induction d with
  | zero => intro g; simp [Construction.tableFrom]
  | succ n ih =>
    intro g
    rw [Function.iterate_succ_apply']
    show Construction.tableFrom N (g + ((n + 1 : ℕ) : ℤ)) n
        - Construction.tableFrom N (g + ((n + 1 : ℕ) : ℤ) - 1) n = _
    rw [fwdDiff, ← ih (g + 1), ← ih g]
    congr 2 <;> push_cast <;> ring

/-- **The `d`-th forward difference of an exponential.** -/
theorem fwdDiff_iter_geom {K : Type*} [Field K] (z : K) (hz : z ≠ 0) (d : ℕ) :
    (fwdDiff 1)^[d] (fun m : ℤ => z ^ m) = fun m => (z - 1) ^ d * z ^ m := by
  induction d with
  | zero => funext m; simp
  | succ n ih =>
    rw [Function.iterate_succ_apply', ih]
    funext m
    simp only [fwdDiff]
    rw [zpow_add_one₀ hz, pow_succ]
    ring

/-- **The main term's factor is one per depth.** -/
theorem fwdDiff_iter_two (d : ℕ) :
    (fwdDiff 1)^[d] (fun m : ℤ => (2 : ℝ) ^ m) = fun m => (2 : ℝ) ^ m := by
  rw [fwdDiff_iter_geom (2 : ℝ) (by norm_num)]
  funext m; norm_num

end EdgeDiagonal

/-- info: 'EdgeDiagonal.edge_eq_fwdDiff' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms EdgeDiagonal.edge_eq_fwdDiff

/-- info: 'EdgeDiagonal.fwdDiff_iter_geom' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms EdgeDiagonal.fwdDiff_iter_geom

/-- info: 'EdgeDiagonal.fwdDiff_iter_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms EdgeDiagonal.fwdDiff_iter_two
