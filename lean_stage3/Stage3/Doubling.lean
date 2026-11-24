/-
Doubling — block R15 of `lean_stage3/design/runs.md`. 2026-11-24.

The self-bound at `N` less twice the self-bound at `⌊N/2⌋`. The even scales
`N/(2j)` are the scales of `⌊N/2⌋`, so the difference keeps the odd scales
and subtracts the even ones: an alternating sum of the staircase, equal to
`log N! − 2·log ⌊N/2⌋!`. By Stirling that is `N log 2` up to `O(log N)`, and
the alternating sum of `N/k` is `N log 2` up to `N` times the tail of the
alternating harmonic series, at most `1`. The alternating residuals add up
to `O(log N)`.

  alt_scales       Σ_{k≤N} (−1)^(k+1) ψ(N/k) = Σ_{n≤N} log n − 2·Σ_{n≤N/2} log n
  alt_harmonic     1 ≤ N ⊢ |Σ_{k≤N} (−1)^(k+1)/k − log 2| ≤ 1/N
  alt_resid_small  2 ≤ N ⊢ |Σ_{k≤N} (−1)^(k+1) (ψ(N/k) − N/k)| ≤ 4 log N + 5

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.NoHoles

namespace Doubling

open Finset

/-- The sign `(−1)^(k+1)` read off the parity of `k`. -/
theorem neg_one_pow_succ_eq (k : ℕ) :
    (-1 : ℝ) ^ (k + 1) = if 2 ∣ k then -1 else 1 := by
  split_ifs with h
  · obtain ⟨m, rfl⟩ := h
    rw [pow_succ, pow_mul]
    norm_num
  · obtain ⟨m, rfl⟩ : ∃ m, k = 2 * m + 1 := ⟨k / 2, by omega⟩
    rw [show 2 * m + 1 + 1 = 2 * (m + 1) by ring, pow_mul]
    norm_num

/-- **The doubling.** The self-bound at `N` less twice the self-bound at
`⌊N/2⌋` is the alternating sum of the staircase over the scales `N/k`. -/
theorem alt_scales (N : ℕ) :
    ∑ k ∈ Icc 1 N, (-1 : ℝ) ^ (k + 1) * Chebyshev.psi ((N : ℝ) / (k : ℝ))
      = ∑ n ∈ Icc 1 N, Real.log n - 2 * ∑ n ∈ Icc 1 (N / 2), Real.log n := by
  have hsplit : ∀ f : ℕ → ℝ, ∑ k ∈ Icc 1 N, (-1 : ℝ) ^ (k + 1) * f k
      = ∑ k ∈ Icc 1 N, f k - 2 * ∑ k ∈ (Icc 1 N).filter (fun k => 2 ∣ k), f k := by
    intro f
    rw [Finset.sum_filter, Finset.mul_sum, ← Finset.sum_sub_distrib]
    refine Finset.sum_congr rfl fun k _ => ?_
    rw [neg_one_pow_succ_eq]
    split_ifs <;> ring
  rw [hsplit, NoHoles.multiples_eq_image N (by norm_num : 1 ≤ 2),
    Finset.sum_image (fun a _ b _ h => by omega), SelfBound.self_bound]
  congr 2
  rw [← SelfBound.self_bound (N / 2)]
  refine Finset.sum_congr rfl fun j _ => ?_
  rw [NoHoles.psi_floor, NoHoles.psi_floor (N / 2) j, Nat.div_div_eq_div_mul]

/-- One step of the logarithm against `1/x`. -/
theorem log_step {x : ℝ} (hx : 0 < x) :
    1 / (x + 1) ≤ Real.log (x + 1) - Real.log x ∧ Real.log (x + 1) - Real.log x ≤ 1 / x := by
  rw [← Real.log_div (by linarith) hx.ne']
  have hq : 0 < (x + 1) / x := by positivity
  have hx0 : x ≠ 0 := hx.ne'
  have hx1 : x + 1 ≠ 0 := by linarith
  constructor
  · have h := Real.one_sub_inv_le_log_of_pos hq
    have e : 1 - ((x + 1) / x)⁻¹ = 1 / (x + 1) := by
      field_simp
      try ring
    linarith
  · have h := Real.log_le_sub_one_of_pos hq
    have e : (x + 1) / x - 1 = 1 / x := by
      field_simp
      try ring
    linarith

/-- The harmonic sum from `n+1` to `n+k` against `log((n+k)/n)`. -/
theorem harmonic_block {n : ℕ} (hn : 1 ≤ n) (k : ℕ) :
    Real.log ((n + k : ℕ) : ℝ) - Real.log (n : ℝ) - (1 / (n : ℝ) - 1 / ((n + k : ℕ) : ℝ))
        ≤ ∑ i ∈ Icc 1 (n + k), 1 / (i : ℝ) - ∑ i ∈ Icc 1 n, 1 / (i : ℝ)
      ∧ ∑ i ∈ Icc 1 (n + k), 1 / (i : ℝ) - ∑ i ∈ Icc 1 n, 1 / (i : ℝ)
        ≤ Real.log ((n + k : ℕ) : ℝ) - Real.log (n : ℝ) := by
  induction k with
  | zero => simp
  | succ k ih =>
    rw [show n + (k + 1) = (n + k) + 1 by omega, Finset.sum_Icc_succ_top (by omega)]
    have hx : (0 : ℝ) < ((n + k : ℕ) : ℝ) := Nat.cast_pos.mpr (by omega)
    obtain ⟨h3, h4⟩ := log_step hx
    obtain ⟨h1, h2⟩ := ih
    rw [Nat.cast_succ]
    constructor <;> linarith

/-- The alternating sum up to `2m` is the harmonic sum from `m+1` to `2m`. -/
theorem alt_even (m : ℕ) :
    ∑ k ∈ Icc 1 (2 * m), (-1 : ℝ) ^ (k + 1) / (k : ℝ)
      = ∑ k ∈ Icc 1 (2 * m), 1 / (k : ℝ) - ∑ k ∈ Icc 1 m, 1 / (k : ℝ) := by
  induction m with
  | zero => simp
  | succ m ih =>
    rw [show 2 * (m + 1) = 2 * m + 1 + 1 by ring]
    simp only [Finset.sum_Icc_succ_top (show 1 ≤ 2 * m + 1 + 1 by omega),
      Finset.sum_Icc_succ_top (show 1 ≤ 2 * m + 1 by omega),
      Finset.sum_Icc_succ_top (show 1 ≤ m + 1 by omega)]
    rw [ih]
    have s1 : (-1 : ℝ) ^ (2 * m + 1 + 1) = 1 := by
      rw [show 2 * m + 1 + 1 = 2 * (m + 1) by ring, pow_mul]
      norm_num
    have s2 : (-1 : ℝ) ^ (2 * m + 1 + 1 + 1) = -1 := by
      rw [show 2 * m + 1 + 1 + 1 = 2 * (m + 1) + 1 by ring, pow_succ, pow_mul]
      norm_num
    rw [s1, s2]
    push_cast
    have hm1 : (m : ℝ) + 1 ≠ 0 := by positivity
    have hm2 : 2 * (m : ℝ) + 1 + 1 ≠ 0 := by positivity
    have e : (-1 : ℝ) / (2 * m + 1 + 1) = 1 / (2 * m + 1 + 1) - 1 / (m + 1) := by
      field_simp
      try ring
    rw [e]
    ring

/-- The alternating sum up to `2m` lies within `1/(2m)` below `log 2`. -/
theorem alt_even_bound {m : ℕ} (hm : 1 ≤ m) :
    Real.log 2 - 1 / (2 * (m : ℝ)) ≤ ∑ k ∈ Icc 1 (2 * m), (-1 : ℝ) ^ (k + 1) / (k : ℝ)
      ∧ ∑ k ∈ Icc 1 (2 * m), (-1 : ℝ) ^ (k + 1) / (k : ℝ) ≤ Real.log 2 := by
  rw [alt_even]
  have hb := harmonic_block hm m
  rw [show m + m = 2 * m by ring, Nat.cast_mul, Nat.cast_ofNat] at hb
  have hm0 : (m : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
  have hl : Real.log (2 * (m : ℝ)) = Real.log 2 + Real.log m :=
    Real.log_mul two_ne_zero hm0
  have hf : 1 / (m : ℝ) - 1 / (2 * m) = 1 / (2 * m) := by
    field_simp
    try ring
  obtain ⟨h1, h2⟩ := hb
  constructor <;> linarith

/-- **The alternating harmonic sum.** Within `1/N` of `log 2`. -/
theorem alt_harmonic {N : ℕ} (hN : 1 ≤ N) :
    |∑ k ∈ Icc 1 N, (-1 : ℝ) ^ (k + 1) / (k : ℝ) - Real.log 2| ≤ 1 / (N : ℝ) := by
  have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hl2' := Real.log_two_lt_d9
  obtain ⟨m, rfl | rfl⟩ := Nat.even_or_odd' N
  · have hm : 1 ≤ m := by omega
    obtain ⟨h1, h2⟩ := alt_even_bound hm
    have hpos : 0 < 1 / (2 * (m : ℝ)) := by
      have : (0 : ℝ) < m := Nat.cast_pos.mpr (by omega)
      positivity
    rw [abs_le, Nat.cast_mul, Nat.cast_ofNat]
    constructor <;> linarith
  · rw [Finset.sum_Icc_succ_top (by omega)]
    have s : (-1 : ℝ) ^ (2 * m + 1 + 1) = 1 := by
      rw [show 2 * m + 1 + 1 = 2 * (m + 1) by ring, pow_mul]
      norm_num
    rw [s]
    push_cast
    rcases Nat.eq_zero_or_pos m with rfl | hm
    · norm_num
      rw [abs_le]
      constructor <;> linarith
    · obtain ⟨h1, h2⟩ := alt_even_bound hm
      have hm0 : (1 : ℝ) ≤ m := by exact_mod_cast hm
      have key : 1 / (2 * (m : ℝ)) ≤ 2 / (2 * m + 1) := by
        rw [div_le_div_iff₀ (by positivity) (by positivity)]
        nlinarith
      have e : 2 / (2 * (m : ℝ) + 1) = 1 / (2 * m + 1) + 1 / (2 * m + 1) := by ring
      have hpos : 0 < 1 / (2 * (m : ℝ) + 1) := by positivity
      rw [abs_le]
      constructor <;> linarith

/-- The smooth parts of the two log-sums against `N log 2`. -/
theorem doubling_smooth {N M : ℕ} (hM : 1 ≤ M) (h : N = 2 * M ∨ N = 2 * M + 1) :
    |(N : ℝ) * Real.log N - N - 2 * ((M : ℝ) * Real.log M - M) - N * Real.log 2|
      ≤ Real.log N + 1 := by
  have hM0 : (M : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
  have hM1 : (1 : ℝ) ≤ M := by exact_mod_cast hM
  have hl2M : Real.log (2 * (M : ℝ)) = Real.log 2 + Real.log M :=
    Real.log_mul two_ne_zero hM0
  have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  rcases h with rfl | rfl
  · push_cast
    rw [hl2M]
    have hlogN : 0 ≤ Real.log M := Real.log_nonneg hM1
    have key : 2 * (M : ℝ) * (Real.log 2 + Real.log M) - 2 * M - 2 * (M * Real.log M - M)
        - 2 * M * Real.log 2 = 0 := by ring
    rw [key, abs_zero]
    linarith
  · push_cast
    have hx : (0 : ℝ) < 2 * M := by positivity
    obtain ⟨hs1, hs2⟩ := log_step hx
    have hprod : 2 * (M : ℝ) * (Real.log (2 * M + 1) - Real.log (2 * M)) ≤ 1 := by
      have h := mul_le_mul_of_nonneg_left hs2 hx.le
      have e : 2 * (M : ℝ) * (1 / (2 * M)) = 1 := by
        field_simp
        try ring
      linarith
    have hprod0 : 0 ≤ 2 * (M : ℝ) * (Real.log (2 * M + 1) - Real.log (2 * M)) := by
      have : 0 < 1 / (2 * (M : ℝ) + 1) := by positivity
      exact mul_nonneg hx.le (by linarith)
    have hla : Real.log 2 ≤ Real.log (2 * M + 1) :=
      Real.log_le_log (by norm_num) (by linarith)
    have key : (2 * (M : ℝ) + 1) * Real.log (2 * M + 1) - (2 * M + 1)
        - 2 * (M * Real.log M - M) - (2 * M + 1) * Real.log 2
        = 2 * M * (Real.log (2 * M + 1) - Real.log (2 * M))
          + (Real.log (2 * M + 1) - Real.log 2) - 1
          + 2 * M * (Real.log (2 * M) - Real.log 2 - Real.log M) := by ring
    have hz : Real.log (2 * (M : ℝ)) - Real.log 2 - Real.log M = 0 := by linarith
    rw [key, hz, mul_zero, add_zero, abs_le]
    constructor <;> linarith

/-- **The alternating residuals are small.** Over the scales `N/k` with the
signs `(−1)^(k+1)`, the residuals of the staircase add up to at most
`4 log N + 5`. -/
theorem alt_resid_small {N : ℕ} (hN : 2 ≤ N) :
    |∑ k ∈ Icc 1 N, (-1 : ℝ) ^ (k + 1) * (Chebyshev.psi ((N : ℝ) / (k : ℝ)) - (N : ℝ) / (k : ℝ))|
      ≤ 4 * Real.log N + 5 := by
  have hsum : ∑ k ∈ Icc 1 N, (-1 : ℝ) ^ (k + 1) * (Chebyshev.psi ((N : ℝ) / (k : ℝ))
        - (N : ℝ) / (k : ℝ))
      = (∑ n ∈ Icc 1 N, Real.log n - 2 * ∑ n ∈ Icc 1 (N / 2), Real.log n)
        - (N : ℝ) * ∑ k ∈ Icc 1 N, (-1 : ℝ) ^ (k + 1) / (k : ℝ) := by
    simp only [mul_sub]
    rw [Finset.sum_sub_distrib, alt_scales]
    congr 1
    rw [Finset.mul_sum]
    refine Finset.sum_congr rfl fun k _ => ?_
    ring
  rw [hsum]
  obtain ⟨M, hM⟩ := Nat.even_or_odd' N
  have hdiv : N / 2 = M := by omega
  have hM1 : 1 ≤ M := by omega
  rw [hdiv]
  have hD := doubling_smooth hM1 hM
  have heN := NoHoles.log_factorial_close (M := N) (by omega)
  have heM := NoHoles.log_factorial_close hM1
  have hNpos : (0 : ℝ) < N := Nat.cast_pos.mpr (by omega)
  have hlogMN : Real.log (M : ℝ) ≤ Real.log (N : ℝ) :=
    Real.log_le_log (Nat.cast_pos.mpr (by omega)) (by exact_mod_cast (by omega : M ≤ N))
  have hh := alt_harmonic (N := N) (by omega)
  have hNh : |(N : ℝ) * (∑ k ∈ Icc 1 N, (-1 : ℝ) ^ (k + 1) / (k : ℝ) - Real.log 2)| ≤ 1 := by
    rw [abs_mul, abs_of_pos hNpos]
    have h := mul_le_mul_of_nonneg_left hh hNpos.le
    have e : (N : ℝ) * (1 / (N : ℝ)) = 1 := by
      field_simp
      try ring
    linarith
  rw [abs_le] at hD heN heM hNh ⊢
  obtain ⟨hD1, hD2⟩ := hD
  obtain ⟨heN1, heN2⟩ := heN
  obtain ⟨heM1, heM2⟩ := heM
  obtain ⟨hNh1, hNh2⟩ := hNh
  constructor <;> linarith

/-- info: 'Doubling.alt_scales' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms alt_scales

/-- info: 'Doubling.alt_harmonic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms alt_harmonic

/-- info: 'Doubling.alt_resid_small' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms alt_resid_small

end Doubling
