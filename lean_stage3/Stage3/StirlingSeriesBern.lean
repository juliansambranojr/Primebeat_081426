/-
StirlingSeriesBern — block S14 of `lean_stage3/design/stencil.md`, Turing at scale: the size of the
Bernoulli polynomials on `[0, 1]`, for every order, and Stirling's remainder with it. 2026-11-25.

Mathlib's Fourier series of `B_k` (`hasSum_one_div_pow_mul_fourier_mul_bernoulliFun`, `k ≥ 2`,
`x ∈ [0, 1]`): `Σ_{n ∈ ℤ} n^{−k} e(nx) = −(2πi)^k/k! · B_k(x)`. Each term has norm at most
`1/n²` (`n ≠ 0`; the term `n = 0` is `0`), and `Σ_{n ∈ ℤ} 1/n² = π²/3` (`hasSum_zeta_two` twice),
so `|B_k(x)| ≤ (π²/3)·k!/(2π)^k` (`abs_bernoulliFun_le`) and `bernBound k ≤ 4·k!/6^k`
(`bernBound_le`). With `StirlingSeriesLim.stirling_series` this makes the remainder explicit for
every `K` (`stirling_series_explicit`).

| name | content | status |
|---|---|---|
| `hasSum_inv_sq_int` | `Σ_{n ∈ ℤ} 1/n² = π²/3` | proved |
| `abs_bernoulliFun_le` | `2 ≤ k`, `x ∈ [0,1]` ⊢ `|B_k(x)| ≤ (π²/3)·k!/(2π)^k` | proved |
| `bernBound_le` | `2 ≤ k` ⊢ `bernBound k ≤ 4·k!/6^k` | proved |
| `stirling_series_explicit` | `0 < Re z`, `½ ≤ |Im z|`, `1 ≤ K` ⊢ `‖logG z − S_{K+1} z − ½ log 2π‖ ≤ 4(2K)!/6^{2K}/(2K)·(6/|Im z|)/‖z‖^{2K−2}` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.StirlingSeriesLim

namespace StirlingSeries

open Complex Filter Topology

noncomputable section

/-- `Σ_{n ∈ ℤ} 1/n² = π²/3`. -/
theorem hasSum_inv_sq_int : HasSum (fun n : ℤ => 1 / (n : ℝ) ^ 2) (Real.pi ^ 2 / 3) := by
  have h1 : HasSum (fun n : ℕ => 1 / (((n : ℤ) : ℝ)) ^ 2) (Real.pi ^ 2 / 6) := by
    simpa only [Int.cast_natCast] using hasSum_zeta_two
  have h0 := (hasSum_nat_add_iff' (f := fun n : ℕ => 1 / (n : ℝ) ^ 2) 1).mpr hasSum_zeta_two
  have hval : Real.pi ^ 2 / 6 - ∑ i ∈ Finset.range 1, 1 / (i : ℝ) ^ 2 = Real.pi ^ 2 / 6 := by
    simp
  rw [hval] at h0
  have hfun : (fun n : ℕ => 1 / (((-((n : ℤ) + 1)) : ℤ) : ℝ) ^ 2)
      = (fun n : ℕ => 1 / ((n + 1 : ℕ) : ℝ) ^ 2) := by
    funext n
    push_cast
    ring
  have h2 : HasSum (fun n : ℕ => 1 / (((-((n : ℤ) + 1)) : ℤ) : ℝ) ^ 2) (Real.pi ^ 2 / 6) := by
    rw [hfun]
    exact h0
  have h := HasSum.of_nat_of_neg_add_one (f := fun n : ℤ => 1 / (n : ℝ) ^ 2) h1 h2
  rw [show Real.pi ^ 2 / 6 + Real.pi ^ 2 / 6 = Real.pi ^ 2 / 3 by ring] at h
  exact h

/-- **The Bernoulli polynomials on `[0, 1]`**: `|B_k(x)| ≤ (π²/3)·k!/(2π)^k` for `k ≥ 2`. -/
theorem abs_bernoulliFun_le {k : ℕ} (hk : 2 ≤ k) {x : ℝ} (hx : x ∈ Set.Icc (0 : ℝ) 1) :
    |bernoulliFun k x| ≤ Real.pi ^ 2 / 3 * k.factorial / (2 * Real.pi) ^ k := by
  have hs := hasSum_one_div_pow_mul_fourier_mul_bernoulliFun hk hx
  have hb := hs.norm_le_of_bounded hasSum_inv_sq_int ?_
  · have hpi : 0 < 2 * Real.pi := by positivity
    have hfac : (0 : ℝ) < k.factorial := by exact_mod_cast Nat.factorial_pos k
    have hn : ‖-(2 * (Real.pi : ℂ) * I) ^ k / (k.factorial : ℂ) * (bernoulliFun k x : ℂ)‖
        = (2 * Real.pi) ^ k / k.factorial * |bernoulliFun k x| := by
      rw [norm_mul, norm_div, norm_neg, norm_pow, norm_mul, norm_mul, Complex.norm_I,
        Complex.norm_real, Complex.norm_natCast, Real.norm_eq_abs, Complex.norm_ofNat,
        Complex.norm_real, Real.norm_eq_abs, abs_of_pos Real.pi_pos]
      ring
    rw [hn] at hb
    rw [le_div_iff₀ (pow_pos hpi k)]
    have : (2 * Real.pi) ^ k / k.factorial * |bernoulliFun k x| * k.factorial
        = |bernoulliFun k x| * (2 * Real.pi) ^ k := by
      field_simp
    nlinarith
  · intro n
    rw [norm_mul]
    have h1 : ‖fourier n (x : AddCircle (1 : ℝ))‖ ≤ 1 := by
      have := (fourier n : C(AddCircle (1 : ℝ), ℂ)).norm_coe_le_norm (x : AddCircle (1 : ℝ))
      rwa [fourier_norm] at this
    rcases eq_or_ne n 0 with rfl | hn0
    · simp [zero_pow (by omega : k ≠ 0)]
    · have hn1 : (1 : ℝ) ≤ |(n : ℝ)| := by
        rw [← Int.cast_abs]
        exact_mod_cast Int.one_le_abs hn0
      have h2 : ‖1 / (n : ℂ) ^ k‖ ≤ 1 / (n : ℝ) ^ 2 := by
        rw [norm_div, norm_one, norm_pow, Complex.norm_intCast, ← sq_abs (n : ℝ)]
        apply one_div_le_one_div_of_le (by positivity)
        calc |(n : ℝ)| ^ 2 ≤ |(n : ℝ)| ^ k := pow_le_pow_right₀ hn1 hk
          _ = |(n : ℝ)| ^ k := rfl
      calc ‖1 / (n : ℂ) ^ k‖ * ‖fourier n (x : AddCircle (1 : ℝ))‖ ≤ (1 / (n : ℝ) ^ 2) * 1 :=
            mul_le_mul h2 h1 (norm_nonneg _) (by positivity)
        _ = 1 / (n : ℝ) ^ 2 := mul_one _

/-- **`bernBound k ≤ 4·k!/6^k`** for `k ≥ 2`. -/
theorem bernBound_le {k : ℕ} (hk : 2 ≤ k) : ZetaEM.bernBound k ≤ 4 * k.factorial / 6 ^ k := by
  unfold ZetaEM.bernBound
  apply csSup_le
  · exact ⟨_, ⟨0, ⟨le_refl _, zero_le_one⟩, rfl⟩⟩
  · rintro y ⟨x, hx, rfl⟩
    refine (abs_bernoulliFun_le hk hx).trans ?_
    have hpi3 := Real.pi_gt_three
    have hpi4 := Real.pi_lt_four
    have hfac : (0 : ℝ) < k.factorial := by exact_mod_cast Nat.factorial_pos k
    have h6 : (6 : ℝ) ^ k ≤ (2 * Real.pi) ^ k := pow_le_pow_left₀ (by norm_num) (by linarith) k
    have h6p : (0 : ℝ) < 6 ^ k := by positivity
    have hpi2 : Real.pi ^ 2 / 3 ≤ 4 := by
      have : Real.pi ^ 2 ≤ 12 := by
        have := Real.pi_lt_d2
        nlinarith
      linarith
    calc Real.pi ^ 2 / 3 * k.factorial / (2 * Real.pi) ^ k
        ≤ 4 * k.factorial / (2 * Real.pi) ^ k := by
          apply div_le_div_of_nonneg_right _ (by positivity)
          exact mul_le_mul_of_nonneg_right hpi2 hfac.le
      _ ≤ 4 * k.factorial / 6 ^ k := div_le_div_of_nonneg_left (by positivity) h6p h6

/-- **Stirling's series, every constant explicit**: for `Re z > 0`, `|Im z| ≥ ½`, `K ≥ 1`,
`‖logG z − S_{K+1}(z) − ½ log 2π‖ ≤ 4(2K)!/6^{2K}/(2K)·(6/|Im z|)/‖z‖^{2K−2}`. -/
theorem stirling_series_explicit {z : ℂ} (hz : 0 < z.re) (hY : 1 / 2 ≤ |z.im|) {K : ℕ}
    (hK : 1 ≤ K) :
    ‖Stirling.logG z - stirMain (K + 1) z - ((Real.log (2 * Real.pi) / 2 : ℝ) : ℂ)‖
      ≤ 4 * (2 * K).factorial / 6 ^ (2 * K) / (2 * K) * (6 / |z.im|) / ‖z‖ ^ (2 * K - 2) := by
  refine (stirling_series hz hY hK).trans ?_
  have hY0 : 0 < |z.im| := by linarith
  have hK0 : (0 : ℝ) < 2 * K := by
    have : (1 : ℝ) ≤ K := by exact_mod_cast hK
    linarith
  have hz0 : 0 < ‖z‖ := by
    have := Complex.abs_im_le_norm z
    linarith
  apply div_le_div_of_nonneg_right _ (by positivity)
  apply mul_le_mul_of_nonneg_right _ (by positivity)
  exact div_le_div_of_nonneg_right (bernBound_le (by omega)) hK0.le

end

/-- info: 'StirlingSeries.abs_bernoulliFun_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms abs_bernoulliFun_le

/-- info: 'StirlingSeries.bernBound_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms bernBound_le

/-- info: 'StirlingSeries.stirling_series_explicit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stirling_series_explicit

end StirlingSeries
