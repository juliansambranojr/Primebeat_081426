/-
# Stage3.SieveOrder — the sediment in the sieve's order

Unit 0586 adds the terms of a section of the approximate functional equation one at
a time in two orders: the natural one, `1, 2, …, M`, and the sieve's, grouped by
largest prime factor, primes ascending, `n` ascending inside a group. The partial
sums differ; the full section does not. This file proves the second fact: the
sieve order is a permutation of `1, …, M`, so any sum over it is the natural sum.
It says nothing about where the partial sums' zeros are.
-/
import Mathlib

namespace SieveOrder

/-- The largest prime factor of `n` (`1` for `n ≤ 1`). -/
def lpf (n : ℕ) : ℕ := (Nat.primeFactorsList n).foldr max 1

/-- The sieve's comparison: by largest prime factor, then by `n`. -/
def sieveLe (a b : ℕ) : Bool :=
  decide (lpf a < lpf b) || (decide (lpf a = lpf b) && decide (a ≤ b))

/-- The sieve order of `1, …, M`. -/
def sieveOrder (M : ℕ) : List ℕ := (List.range' 1 M).mergeSort sieveLe

/-- The sieve order is a reordering of `1, …, M`. -/
theorem sieveOrder_perm (M : ℕ) : List.Perm (sieveOrder M) (List.range' 1 M) :=
  List.mergeSort_perm _ _

/-- **The full section does not depend on the order.** Any sum over the sieve order
is the sum over `1, …, M`. -/
theorem sum_sieveOrder {β : Type*} [AddCommMonoid β] (f : ℕ → β) (M : ℕ) :
    ((sieveOrder M).map f).sum = ((List.range' 1 M).map f).sum :=
  ((sieveOrder_perm M).map f).sum_eq

end SieveOrder

/-- info: 'SieveOrder.sum_sieveOrder' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms SieveOrder.sum_sieveOrder
