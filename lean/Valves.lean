/-
Valves — Julian's seals and release valves on the 6k ± 1 lattice.

Julian, 2026-11-26: "So does that mean that composites in the 6k slots are release valves? If primes
are seals?" Every number `6k ± 1` is a slot. A slot holding a prime is a seal; a slot holding a
composite (closed by a prime ≥ 5) is a valve. In a row of the dyadic table above the scaffold primes
2 and 3, seals plus valves are the slots, so by linearity (`Construction.tableFrom_add`) the seals'
cell plus the valves' cell is the slots' cell, a near-geometric third of the row's integers.

At the deep balance the seals' cell is 0 (`Zeros.zero_20_6`), so the valves carry the slots' whole
share: 2688, near 2¹³/3. That is `DeepZeroBand.composite_cell_20_6` (the composites carry the whole
2¹³) read on the lattice.
-/
import Construction
import Zeros

namespace Valves

/-- The slots `k ≤ n` with `k ≡ ±1 (mod 6)`. -/
def slotsUpTo (n : Nat) : Int :=
  2 * (n / 6 : Nat) + (if 1 ≤ n % 6 then 1 else 0) + (if 5 ≤ n % 6 then 1 else 0)

/-- The slots in the rung `(2^(r−1), 2^r]`. -/
def slotRow : Int → Int := fun r =>
  if 1 ≤ r then slotsUpTo (2 ^ r.toNat) - slotsUpTo (2 ^ (r - 1).toNat) else 0

/-- The valves in a rung: its slots less its seals. -/
def valveRow : Int → Int := fun r => slotRow r - Zeros.dyadicRow r

/-- **Seals plus valves are the slots, cell by cell.** -/
theorem seals_add_valves (r : Int) (d : Nat) :
    Construction.tableFrom Zeros.dyadicRow r d + Construction.tableFrom valveRow r d
      = Construction.tableFrom slotRow r d := by
  rw [← Construction.tableFrom_add]
  congr 1
  funext x
  unfold valveRow
  omega

/-- **At the deep balance the valves carry the slots' whole share.** -/
theorem valves_at_deep_zero :
    Construction.tableFrom valveRow 20 6 = Construction.tableFrom slotRow 20 6 := by
  have h := seals_add_valves 20 6
  rw [Zeros.zero_20_6] at h
  omega

/-- The slots' share at the deep balance, computed: `2688`, near `2¹³/3`. -/
theorem slot_cell_20_6 : Construction.tableFrom slotRow 20 6 = 2688 := by decide

end Valves

/-- info: 'Valves.seals_add_valves' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms Valves.seals_add_valves

/-- info: 'Valves.slot_cell_20_6' does not depend on any axioms -/
#guard_msgs in
#print axioms Valves.slot_cell_20_6
