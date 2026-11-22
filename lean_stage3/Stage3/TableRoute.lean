/-
TableRoute — block E10 of `lean_stage3/design/joints.md`: the join between
the two trees, closed for the explicit-formula route. 2026-11-22.

`lean_stage3/Stage3/TablePort/` holds the ten modules of the table's tree
that its gate depends on, copied onto this toolchain. With them the route's
conclusion (`GateEval.gate_hyp_of_RH`) and the gate
(`RouteCell.cell_ne_zero_of_route`) are in one tree, and their composition is
one theorem.

  rowN                    m ↦ π(2^m) − π(2^(m−1)), the table's row
  cell_ne_zero_of_RH      RH, 80 ≤ r ⊢ Construction.tableFrom rowN r 6 ≠ 0

Under RH, no cell of the table at depth six is zero from row 80 on. One
statement, checked by the kernel; the text weld is no longer part of it.

Axioms: the pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.GateEval
import Stage3.TablePort.RouteCell

namespace TableRoute

noncomputable section

/-- The table's row: the number of primes in the dyadic block `(2^(m−1), 2^m]`. -/
def rowN (m : ℤ) : ℤ :=
  (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℤ)
    - (Nat.primeCounting ⌊(2 : ℝ) ^ ((m - 1 : ℤ) : ℝ)⌋₊ : ℤ)

/-- **Under RH, depth six has no zero from row 80 on.** -/
theorem cell_ne_zero_of_RH (hRH : RiemannHypothesis) {r : ℤ} (hr : 80 ≤ r) :
    Construction.tableFrom rowN r 6 ≠ 0 := by
  obtain ⟨ρ, hS, hρ⟩ := GateEval.gate_hyp_of_RH hRH hr
  refine RouteCell.cell_ne_zero_of_route
    (f := fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ)) hr ?_ ⟨ρ, hS, hρ⟩
  intro k _
  unfold rowN Nonvanishing.bdiffZ
  push_cast
  rfl

end

/-- info: 'TableRoute.cell_ne_zero_of_RH' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cell_ne_zero_of_RH

end TableRoute
