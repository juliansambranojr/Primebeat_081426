> Source: session transcript, 2026-11-22, after PR 7 merged

> No your caveats are just fixes or problems you don't address

From `lean_stage3/Stage3/TableRoute.lean`, the definition and the pinned statement:

```
/-- The table's row: the number of primes in the dyadic block `(2^(m−1), 2^m]`. -/
def rowN (m : ℤ) : ℤ :=
  (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℤ)
    - (Nat.primeCounting ⌊(2 : ℝ) ^ ((m - 1 : ℤ) : ℝ)⌋₊ : ℤ)

/-- **Under RH, depth six has no zero from row 80 on.** -/
theorem cell_ne_zero_of_RH (hRH : RiemannHypothesis) {r : ℤ} (hr : 80 ≤ r) :
    Construction.tableFrom rowN r 6 ≠ 0 := by
```
