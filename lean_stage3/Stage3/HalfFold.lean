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

namespace HalfFold

open Finset SieveExact HalfSplit HalfTaper

/-- The small side's floors are its exact fractions less its roundings. -/
theorem small_side_split (N y : ℕ) :
    ∑ d ∈ Icc 1 y, sieveMu N d * ((N / d : ℕ) : ℝ)
      = (N : ℝ) * ∑ d ∈ Icc 1 y, sieveMu N d / d
        - ∑ d ∈ Icc 1 y, sieveMu N d * Int.fract ((N : ℝ) / (d : ℝ)) := by
  rw [Finset.mul_sum, ← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun d _ => ?_
  have h := congrArg (fun q : ℚ => (q : ℝ)) (natDiv_eq_sub_fract N d)
  push_cast at h
  rw [h]; ring

/-- **The wobble through the tapered fold.** With `y = √N`: the wobble is the smooth counts, less
the tapered small side, less the mirrored side, plus the small side's roundings, plus the fold line
corrected by the taper, `(⌊N/y⌋ − N/y) · M_S(y)`. Unit 0589: the tapered small side and the
mirrored side less the smooth counts each stay near two square roots, `10⁴` to `3·10⁷`. -/
theorem wobble_taper (N : ℕ) (hN : 1 ≤ N) :
    HalfSieve.wobble N = 1 + Stage3.Li (N : ℝ) - Stage3.Li ((Nat.sqrt N : ℕ) : ℝ)
      - (N : ℝ) * ∑ d ∈ Icc 1 (Nat.sqrt N), sieveMu N d / d * (1 - (d : ℝ) / (Nat.sqrt N : ℕ))
      - ∑ m ∈ Icc 1 (N / Nat.sqrt N), cnt (sieveMu N) (N / m)
      + ∑ d ∈ Icc 1 (Nat.sqrt N), sieveMu N d * Int.fract ((N : ℝ) / (d : ℝ))
      + (((N / Nat.sqrt N : ℕ) : ℝ) - (N : ℝ) / (Nat.sqrt N : ℕ)) * cnt (sieveMu N) (Nat.sqrt N) := by
  have hy : 0 < Nat.sqrt N := Nat.sqrt_pos.mpr (by omega)
  rw [wobble_fold N hN, small_side_split, taper_eq (sieveMu N) N (Nat.sqrt N) hy]
  unfold cnt
  ring

end HalfFold

/-- info: 'HalfFold.wobble_taper' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfFold.wobble_taper
