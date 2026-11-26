/-
# Stage3.HalfTaper — the sieve's Möbius sum with no sharp cut

Unit 0588: every sharp cut of the sieve's Möbius sum at a level `y` carries `N · Σ_{d≤y} μ(d)/d`,
larger than the square root unless `y = N`. Tapered by `(1 − d/y)`, the sum stays near `2√N` at
`y = √N` for `N` to `10¹⁰` (scratch, exploratory, 2026-11-26) while the sharp one reaches `60√N`.
The difference is exact and is one term: `(N/y)` times the signed count up to `y`. At the fold
`y = √N` it is `√N · M(√N)`, the Möbius count on Julian's fold line.
-/
import Mathlib

namespace HalfTaper

open Finset

/-- **The taper takes out exactly the signed count at the cut.** For any weights `c`,

    N · Σ_{d ≤ y} c(d)/d · (1 − d/y) = N · Σ_{d ≤ y} c(d)/d − (N/y) · Σ_{d ≤ y} c(d). -/
theorem taper_eq (c : ℕ → ℚ) (N y : ℕ) (hy : 0 < y) :
    (N : ℚ) * ∑ d ∈ Icc 1 y, c d / d * (1 - (d : ℚ) / y)
      = (N : ℚ) * ∑ d ∈ Icc 1 y, c d / d - ((N : ℚ) / y) * ∑ d ∈ Icc 1 y, c d := by
  have hy' : (y : ℚ) ≠ 0 := by exact_mod_cast hy.ne'
  rw [Finset.mul_sum, Finset.mul_sum, Finset.mul_sum, ← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun d hd => ?_
  have hd0 : (d : ℚ) ≠ 0 := by
    have := (mem_Icc.mp hd).1; exact_mod_cast (by omega : d ≠ 0)
  field_simp

end HalfTaper

/-- info: 'HalfTaper.taper_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfTaper.taper_eq
