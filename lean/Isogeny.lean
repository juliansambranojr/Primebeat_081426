/-
Isogeny — what the isogeny does to the row.

`Transform.tau_ratio_of_meet` proves that two ladders which meet have rationally
related modular parameters: `bⁿ = cᵐ → τ(b)/τ(c) = n/m`. That is a statement
about the tori `ℂ*/b^ℤ`, and the torus knows only `b`. No prime enters it.

This file is the arithmetic shadow of the same relation, and it is the one place
the geometry touches the counting function. The claim:

    row_k(r) = Σ_{j<k} row_1(k·r + j)

**The degree-`k` isogeny acts on the row as block-summation by `k`.** Base 4's
row is base 2's row summed in pairs; base 8's is base 2's summed in triples.

WHY THAT MATTERS HERE. A block sum followed by a stride-`k` step is a box filter
followed by decimation. So a base inside an isogeny class carries no count its
generator's row does not already carry — `{2,4,8}` is one row read at three
decimations, and `{3,9}` is one read at two. `O53_alias_tau.py:43` sweeps
`BASES = [2, 3, 4, 6, 8, 9]`, which is three classes wearing six labels.

THE INDEX. Everything below is indexed by the **exponent**, matching
`Zeros.pi2 : ℕ → ℤ`, which is `π(2ⁿ)` at `n` rather than `π` at `2ⁿ`. So the
base-`bᵏ` row over the block `(b^{kr}, b^{k(r+1)}]` is `Q (k*(r+1)) - Q (k*r)`,
and `k = 1` recovers the base-`b` row. Indexing from the bottom keeps truncated
ℕ subtraction out of every statement. `rowOf` gives the "count up to `x`"
reading, and `rowOf_eq_rowN` is the one-line bridge.

The proof is a telescope and holds for **any** `Q : ℕ → ℤ`. Nothing about primes
is used, which is the honest content: the identity is bookkeeping on a ladder,
and it applies to `π` because `π` is evaluated on one.

Companion to papers/Euler-Factor-Chain.md § G and notes entry 87.
-/
import Mathlib
import Zeros

namespace Isogeny

open Finset

/-- The row of an exponent-indexed count `Q` at decimation `k`: the count on the
block from exponent `k*r` to exponent `k*(r+1)`. `k = 1` is the base row. -/
def rowN (Q : ℕ → ℤ) (k : ℕ) (r : ℕ) : ℤ := Q (k * (r + 1)) - Q (k * r)

/-- The "count up to `x`" reading, for a `P` that eats values rather than
exponents. -/
def rowOf (P : ℕ → ℤ) (b : ℕ) (r : ℕ) : ℤ := P (b ^ (r + 1)) - P (b ^ r)

/-- The bridge: composing `P` with `b^·` turns one into the other. -/
theorem rowOf_eq_rowN (P : ℕ → ℤ) (b r : ℕ) :
    rowOf P b r = rowN (fun n => P (b ^ n)) 1 r := by
  unfold rowOf rowN
  simp

/-- Telescoping over `Finset.range`. Stated for an arbitrary `g : ℕ → ℤ` because
that is all the identity below needs. -/
theorem telescope (g : ℕ → ℤ) (m k : ℕ) :
    ∑ j ∈ range k, (g (m + j + 1) - g (m + j)) = g (m + k) - g m := by
  induction k with
  | zero => simp
  | succ k ih =>
      rw [Finset.sum_range_succ, ih, ← Nat.add_assoc]
      omega

/-- **The isogeny on the row.** Passing from a ladder to its `k`-th power sums
the row in blocks of `k`. Holds for any `Q`; no arithmetic input is used. -/
theorem rowN_eq_blockSum (Q : ℕ → ℤ) (k r : ℕ) :
    rowN Q k r = ∑ j ∈ range k, rowN Q 1 (k * r + j) := by
  have hg : ∀ j : ℕ, rowN Q 1 j = Q (j + 1) - Q j := by
    intro j; unfold rowN; simp
  simp only [hg]
  rw [telescope Q (k * r) k]
  unfold rowN
  rw [Nat.mul_succ]

/-- Base 4's row is base 2's row summed in pairs. -/
theorem row_two_eq_pair (Q : ℕ → ℤ) (r : ℕ) :
    rowN Q 2 r = rowN Q 1 (2 * r) + rowN Q 1 (2 * r + 1) := by
  unfold rowN
  simp only [Nat.one_mul, show 2 * (r + 1) = 2 * r + 1 + 1 from by omega]
  omega

/-- Base 8's row is base 2's row summed in triples. -/
theorem row_three_eq_triple (Q : ℕ → ℤ) (r : ℕ) :
    rowN Q 3 r = rowN Q 1 (3 * r) + rowN Q 1 (3 * r + 1) + rowN Q 1 (3 * r + 2) := by
  unfold rowN
  simp only [Nat.one_mul, show 3 * (r + 1) = 3 * r + 2 + 1 from by omega,
    show 3 * r + 1 + 1 = 3 * r + 2 from by omega]
  omega

/-- **Decimation composes.** Reading a ladder at `k` and then at `l` is reading
it at `k*l` — so `{2,4,8}` is a chain and not three separate relations. -/
theorem rowN_comp (Q : ℕ → ℤ) (k l r : ℕ) :
    rowN Q (k * l) r = rowN (fun n => Q (k * n)) l r := by
  unfold rowN
  rw [Nat.mul_assoc, Nat.mul_assoc]

/-- The weld to the measured row. `Zeros.dyadicRow` indexes from the top over
`ℤ` and is windowed to `1 ≤ r ≤ 20`; inside that window it is `rowN Zeros.pi2 1`
shifted by one. -/
theorem dyadicRow_eq_rowN (r : ℕ) (h : r ≤ 19) :
    Zeros.dyadicRow ((r : ℤ) + 1) = rowN Zeros.pi2 1 r := by
  unfold Zeros.dyadicRow rowN
  have hle : (r : ℤ) + 1 ≤ 20 := by omega
  have hge : (1 : ℤ) ≤ (r : ℤ) + 1 := by omega
  rw [if_pos ⟨hge, hle⟩]
  have e1 : ((r : ℤ) + 1).toNat = r + 1 := by omega
  have e2 : ((r : ℤ) + 1 - 1).toNat = r := by omega
  rw [e1, e2]
  simp

/-- The measured base-4 row, from the 21 pinned values and nothing else. These
are the numbers `row_two_eq_pair` says are base 2's row summed in pairs. -/
theorem measured_row_four :
    (List.range 10).map (rowN Zeros.pi2 2)
      = [2, 4, 12, 36, 118, 392, 1336, 4642, 16458, 59025] := by
  decide

/-- The measured base-8 row, same 21 values read at decimation 3. -/
theorem measured_row_eight :
    (List.range 6).map (rowN Zeros.pi2 3) = [4, 14, 79, 467, 2948, 19488] := by
  decide

/-- info: 'Isogeny.rowOf_eq_rowN' depends on axioms: [propext] -/
#guard_msgs in
#print axioms Isogeny.rowOf_eq_rowN

/-- info: 'Isogeny.telescope' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Isogeny.telescope

/-- info: 'Isogeny.rowN_eq_blockSum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Isogeny.rowN_eq_blockSum

/-- info: 'Isogeny.row_two_eq_pair' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms Isogeny.row_two_eq_pair

/-- info: 'Isogeny.row_three_eq_triple' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms Isogeny.row_three_eq_triple

/-- info: 'Isogeny.rowN_comp' depends on axioms: [propext] -/
#guard_msgs in
#print axioms Isogeny.rowN_comp

/-- info: 'Isogeny.dyadicRow_eq_rowN' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms Isogeny.dyadicRow_eq_rowN

/-- info: 'Isogeny.measured_row_four' does not depend on any axioms -/
#guard_msgs in
#print axioms Isogeny.measured_row_four

/-- info: 'Isogeny.measured_row_eight' does not depend on any axioms -/
#guard_msgs in
#print axioms Isogeny.measured_row_eight

end Isogeny
