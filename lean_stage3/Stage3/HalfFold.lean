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

namespace HalfFold

open Finset SieveExact HalfSplit HalfTaper

/-- **The sieve's Möbius weight is at most one in size.** At most one set of sieve primes has a
given product (`prod_injOn_primes`). -/
theorem abs_sieveMu_le_one (N k : ℕ) : |sieveMu N k| ≤ 1 := by
  unfold sieveMu
  set F := (lowT N).filter (fun T => (∏ p ∈ T, p) = k)
  have hcard : F.card ≤ 1 := by
    rw [Finset.card_le_one]
    intro T hT T' hT'
    have hF : ∀ U ∈ F, ∀ q ∈ U, q.Prime := fun U hU q hq =>
      prime_of_mem_smallPrimes (mem_powerset.mp (mem_filter.mp (mem_filter.mp hU).1).1 hq)
    exact prod_injOn_primes F hF hT hT' ((mem_filter.mp hT).2.trans (mem_filter.mp hT').2.symm)
  calc |∑ T ∈ F, (-1 : ℝ) ^ T.card| ≤ ∑ T ∈ F, |(-1 : ℝ) ^ T.card| := Finset.abs_sum_le_sum_abs _ _
    _ = F.card := by simp
    _ ≤ 1 := by exact_mod_cast hcard

/-- The signed count up to `t` is at most `t`. -/
theorem abs_cnt_le (N t : ℕ) : |cnt (sieveMu N) t| ≤ t := by
  unfold cnt
  calc _ ≤ ∑ d ∈ Icc 1 t, |sieveMu N d| := Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ d ∈ Icc 1 t, (1 : ℝ) := Finset.sum_le_sum fun d _ => abs_sieveMu_le_one N d
    _ = t := by simp

end HalfFold

/-- info: 'HalfFold.abs_sieveMu_le_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfFold.abs_sieveMu_le_one

namespace HalfFold

open Finset SieveExact HalfSplit HalfTaper

/-- The tapered small side of the fold at `√N`. -/
noncomputable def taperedSmall (N : ℕ) : ℝ :=
  (N : ℝ) * ∑ d ∈ Icc 1 (Nat.sqrt N), sieveMu N d / d * (1 - (d : ℝ) / (Nat.sqrt N : ℕ))

/-- The mirrored side of the fold less the smooth counts. -/
noncomputable def mirroredExcess (N : ℕ) : ℝ :=
  ∑ m ∈ Icc 1 (N / Nat.sqrt N), cnt (sieveMu N) (N / m)
    - (1 + Stage3.Li (N : ℝ) - Stage3.Li ((Nat.sqrt N : ℕ) : ℝ))

/-- **The fold leaves at most two square roots outside its two sides.** -/
theorem wobble_fold_bound (N : ℕ) (hN : 1 ≤ N) :
    |HalfSieve.wobble N + taperedSmall N + mirroredExcess N| ≤ 2 * Real.sqrt N := by
  have hy : 0 < Nat.sqrt N := Nat.sqrt_pos.mpr (by omega)
  have hyR : (0 : ℝ) < (Nat.sqrt N : ℕ) := by exact_mod_cast hy
  have key : HalfSieve.wobble N + taperedSmall N + mirroredExcess N
      = ∑ d ∈ Icc 1 (Nat.sqrt N), sieveMu N d * Int.fract ((N : ℝ) / (d : ℝ))
        + (((N / Nat.sqrt N : ℕ) : ℝ) - (N : ℝ) / (Nat.sqrt N : ℕ)) * cnt (sieveMu N) (Nat.sqrt N) := by
    rw [wobble_taper N hN]; unfold taperedSmall mirroredExcess; ring
  rw [key]
  have hsq : ((Nat.sqrt N : ℕ) : ℝ) ≤ Real.sqrt N := Real.nat_sqrt_le_real_sqrt
  have h1 : |∑ d ∈ Icc 1 (Nat.sqrt N), sieveMu N d * Int.fract ((N : ℝ) / (d : ℝ))| ≤ Real.sqrt N := by
    calc _ ≤ ∑ d ∈ Icc 1 (Nat.sqrt N), |sieveMu N d * Int.fract ((N : ℝ) / (d : ℝ))| :=
          Finset.abs_sum_le_sum_abs _ _
      _ ≤ ∑ d ∈ Icc 1 (Nat.sqrt N), (1 : ℝ) := by
          refine Finset.sum_le_sum fun d _ => ?_
          rw [abs_mul, abs_of_nonneg (Int.fract_nonneg ((N : ℝ) / (d : ℝ)))]
          have := abs_sieveMu_le_one N d
          have h2 := (Int.fract_lt_one ((N : ℝ) / (d : ℝ))).le
          have h3 := Int.fract_nonneg ((N : ℝ) / (d : ℝ))
          nlinarith [abs_nonneg (sieveMu N d)]
      _ = (Nat.sqrt N : ℕ) := by simp
      _ ≤ Real.sqrt N := hsq
  have hfl : |((N / Nat.sqrt N : ℕ) : ℝ) - (N : ℝ) / (Nat.sqrt N : ℕ)| ≤ 1 := by
    have hfl1 : ((N / Nat.sqrt N : ℕ) : ℝ) ≤ (N : ℝ) / (Nat.sqrt N : ℕ) := Nat.cast_div_le
    have hfl2 : (N : ℝ) / (Nat.sqrt N : ℕ) < ((N / Nat.sqrt N : ℕ) : ℝ) + 1 := by
      rw [div_lt_iff₀ hyR]
      have := Nat.lt_succ_iff.mpr (le_refl (N / Nat.sqrt N))
      have h := Nat.lt_mul_div_succ N hy
      have : (N : ℝ) < ((Nat.sqrt N * (N / Nat.sqrt N + 1) : ℕ) : ℝ) := by exact_mod_cast h
      push_cast at this; linarith
    rw [abs_le]; constructor <;> linarith
  have h2 : |(((N / Nat.sqrt N : ℕ) : ℝ) - (N : ℝ) / (Nat.sqrt N : ℕ)) * cnt (sieveMu N) (Nat.sqrt N)|
      ≤ Real.sqrt N := by
    rw [abs_mul]
    calc _ ≤ 1 * ((Nat.sqrt N : ℕ) : ℝ) :=
          mul_le_mul hfl (abs_cnt_le N _) (abs_nonneg _) zero_le_one
      _ ≤ Real.sqrt N := by rw [one_mul]; exact hsq
  calc _ ≤ _ := abs_add_le _ _
    _ ≤ Real.sqrt N + Real.sqrt N := add_le_add h1 h2
    _ = 2 * Real.sqrt N := by ring

end HalfFold

/-- info: 'HalfFold.wobble_fold_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfFold.wobble_fold_bound

namespace HalfFold

/-- **The open line in the fold's form.** If the tapered small side and the mirrored side less the
smooth counts both stay within `C √N log N` from some `N₀` on, the wobble does: `WobbleSqrt`, and
with it the Riemann hypothesis (`HalfSieve.spiralLink_iff_wobble`, `OneChain.one_chain`). -/
theorem wobbleSqrt_of_fold {C₁ C₂ : ℝ} {N₀ : ℕ}
    (h₁ : ∀ N ≥ N₀, |taperedSmall N| ≤ C₁ * Real.sqrt N * Real.log N)
    (h₂ : ∀ N ≥ N₀, |mirroredExcess N| ≤ C₂ * Real.sqrt N * Real.log N) :
    HalfSieve.WobbleSqrt := by
  refine ⟨C₁ + C₂ + 2, max N₀ 3, fun N hN => ?_⟩
  have hN0 : N₀ ≤ N := le_trans (le_max_left _ _) hN
  have hN3 : 3 ≤ N := le_trans (le_max_right _ _) hN
  have hlog : 1 ≤ Real.log N := by
    rw [Real.le_log_iff_exp_le (by positivity)]
    have : Real.exp 1 < 3 := lt_trans Real.exp_one_lt_d9 (by norm_num)
    have h3 : (3 : ℝ) ≤ N := by exact_mod_cast hN3
    linarith
  have hsq : 0 ≤ Real.sqrt N := Real.sqrt_nonneg _
  have hb := wobble_fold_bound N (by omega)
  have hw : HalfSieve.wobble N
      = (HalfSieve.wobble N + taperedSmall N + mirroredExcess N) - taperedSmall N - mirroredExcess N := by
    ring
  rw [hw]
  calc |(HalfSieve.wobble N + taperedSmall N + mirroredExcess N) - taperedSmall N - mirroredExcess N|
      ≤ |HalfSieve.wobble N + taperedSmall N + mirroredExcess N| + |taperedSmall N| + |mirroredExcess N| := by
        have := abs_sub (HalfSieve.wobble N + taperedSmall N + mirroredExcess N - taperedSmall N)
          (mirroredExcess N)
        have := abs_sub (HalfSieve.wobble N + taperedSmall N + mirroredExcess N) (taperedSmall N)
        linarith
    _ ≤ 2 * Real.sqrt N + C₁ * Real.sqrt N * Real.log N + C₂ * Real.sqrt N * Real.log N := by
        linarith [h₁ N hN0, h₂ N hN0]
    _ ≤ (C₁ + C₂ + 2) * Real.sqrt N * Real.log N := by nlinarith

end HalfFold

/-- info: 'HalfFold.wobbleSqrt_of_fold' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfFold.wobbleSqrt_of_fold
