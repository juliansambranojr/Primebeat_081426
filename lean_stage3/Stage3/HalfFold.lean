/-
# Stage3.HalfFold — the wobble through Julian's mirror fold

`HalfTaper.fold_eq` folds any weighted floor sum about a level `y`; `HalfSplit.wobble_low` writes
the wobble through the floors of the sieve's products up to `N`. Here the two meet at `y = √N`:
the wobble is the smooth counts less the small side of the fold, less the mirrored side, plus the
fold line. Unit 0589 measured both sides near two square roots, tapered, from `10⁴` to `3·10⁷`.
-/
import Stage3.HalfSplit
import Stage3.HalfTaper

namespace HalfFold

open Finset SieveExact HalfSplit HalfTaper

/-- The floors of the products up to `N`, by the value of the product. -/
theorem floors_by_value (N : ℕ) :
    ∑ T ∈ lowT N, (-1 : ℝ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℝ)
      = ∑ k ∈ Icc 1 N, sieveMu N k * ((N / k : ℕ) : ℝ) := by
  unfold sieveMu
  have hmaps : ∀ T ∈ lowT N, (∏ p ∈ T, p) ∈ Icc 1 N := by
    intro T hT
    have hTp : ∀ q ∈ T, q.Prime := fun q hq =>
      prime_of_mem_smallPrimes (mem_powerset.mp (mem_filter.mp hT).1 hq)
    exact mem_Icc.mpr ⟨Nat.one_le_iff_ne_zero.mpr
      (Finset.prod_ne_zero_iff.mpr fun q hq => (hTp q hq).ne_zero), (mem_filter.mp hT).2⟩
  rw [← Finset.sum_fiberwise_of_maps_to hmaps]
  refine Finset.sum_congr rfl fun k _ => ?_
  rw [Finset.sum_mul]
  refine Finset.sum_congr rfl fun T hT => ?_
  rw [(mem_filter.mp hT).2]

/-- **The wobble through Julian's fold.** At the fold level `y = √N`:

    wobble = 1 + Li N − Li √N − (small side) − (mirrored side) + (fold line). -/
theorem wobble_fold (N : ℕ) (hN : 1 ≤ N) :
    HalfSieve.wobble N = 1 + Stage3.Li (N : ℝ) - Stage3.Li ((Nat.sqrt N : ℕ) : ℝ)
      - ∑ d ∈ Icc 1 (Nat.sqrt N), sieveMu N d * ((N / d : ℕ) : ℝ)
      - ∑ m ∈ Icc 1 (N / Nat.sqrt N), cnt (sieveMu N) (N / m)
      + ((N / Nat.sqrt N : ℕ) : ℝ) * cnt (sieveMu N) (Nat.sqrt N) := by
  have hy : 1 ≤ Nat.sqrt N := Nat.le_sqrt.mpr (by simpa using hN)
  rw [wobble_low, floors_by_value, fold_eq (sieveMu N) N (Nat.sqrt N) hy]
  ring

end HalfFold

/-- info: 'HalfFold.wobble_fold' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfFold.wobble_fold
