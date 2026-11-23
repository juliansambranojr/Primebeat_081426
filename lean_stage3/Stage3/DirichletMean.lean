/-
DirichletMean — block C1 of `lean_stage3/design/carlson.md`. 2026-11-23.

An elementary mean value theorem for a finite Dirichlet sum. For `S(t) = Σ_{n ≤ N} a_n n^{-it}`
the integral of `|S|²` over a window of length `L` is at most `(L + 8N(1 + log N))·Σ |a_n|²`.
The square expands into a double sum; the diagonal gives `L·Σ|a_n|²`. Off the diagonal each
integral of `e^{itθ}` is at most `2/|θ|`, the gap `|log m − log n|` is at least `|m − n|/N`, and
the harmonic sum bounds each row by `4N(1 + log N)`. A real part `σ` enters through the weights
`a_n n^{-σ}`.

  natCast_cpow_neg_I_mul        1 ≤ n ⊢ n^{-it} = exp(i·(−log n)·t)
  sq_norm_sum_eq                |S(t)|² as the double sum Σ_m Σ_n a_m·conj a_n·e^{it(log n − log m)}
  integral_sq_norm_eq           the same, integrated over [T₁, T₂], sums outside
  norm_integral_exp_le          θ ≠ 0 ⊢ ‖∫_{T₁}^{T₂} e^{iθt}‖ ≤ 2/|θ|
  log_gap                       1 ≤ n < m ≤ N ⊢ (m − n)/N ≤ log m − log n
  inv_log_gap                   m ≠ n in [1, N] ⊢ 2/|log n − log m| ≤ 2N·|m − n|⁻¹
  sum_inv_le_harmonic           an injective reindexing into [1, N] has Σ 1/k ≤ Σ_{k ≤ N} 1/k
  sum_inv_Icc_le                Σ_{k=1}^{N} 1/k ≤ 1 + log N
  sum_inv_dist_le               Σ_{n ≠ m} 1/|m − n| ≤ 2(1 + log N)
  sum_mul_mul_le                Σ_m Σ_n A_m A_n K_{mn} ≤ R·Σ A_m², for K symmetric with rows ≤ R
  dirichlet_mean_value_window   T₁ ≤ T₂ ⊢ ∫_{T₁}^{T₂} |S|² ≤ (T₂ − T₁ + 8N(1+log N))·Σ|a_n|²
  dirichlet_mean_value          0 ≤ T ⊢ ∫_0^T |S|² ≤ (T + 8N(1+log N))·Σ|a_n|²
  dirichlet_mean_value_sigma    the same with n^{-(σ+it)}, right side Σ|a_n|²·n^{-2σ}

What the next slice needs: the mean value theorem applied to the mollified zeta sum on a
vertical line, with the tail beyond `N` handled separately. It is not here.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Mathlib

namespace DirichletMean

open Finset

noncomputable section

/-- For `n ≥ 1`, the power `n^{-it}` is the exponential `exp(i·(−log n)·t)`. -/
theorem natCast_cpow_neg_I_mul {n : ℕ} (hn : 1 ≤ n) (t : ℝ) :
    (n : ℂ) ^ (-(Complex.I * (t : ℂ))) =
      Complex.exp (Complex.I * ((-Real.log n : ℝ) : ℂ) * t) := by
  have h0 : (n : ℂ) ≠ 0 := Nat.cast_ne_zero.2 (by omega)
  rw [Complex.cpow_def_of_ne_zero h0, ← Complex.natCast_log]
  congr 1
  push_cast
  ring

/-- The squared norm of a finite Dirichlet sum at height `t` is the double sum of
`a_m · conj a_n · e^{it(log n − log m)}`. -/
theorem sq_norm_sum_eq (N : ℕ) (a : ℕ → ℂ) (t : ℝ) :
    ((‖∑ n ∈ Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ)))‖ ^ 2 : ℝ) : ℂ) =
      ∑ m ∈ Icc 1 N, ∑ n ∈ Icc 1 N, a m * (starRingEnd ℂ) (a n) *
        Complex.exp (Complex.I * ((Real.log n - Real.log m : ℝ) : ℂ) * t) := by
  have hS : ∑ n ∈ Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ))) =
      ∑ n ∈ Icc 1 N, a n * Complex.exp (Complex.I * ((-Real.log n : ℝ) : ℂ) * t) :=
    sum_congr rfl fun n hn => by rw [natCast_cpow_neg_I_mul (mem_Icc.1 hn).1]
  rw [hS, Complex.ofReal_pow, ← Complex.mul_conj', map_sum, sum_mul_sum]
  refine sum_congr rfl fun m _ => sum_congr rfl fun n _ => ?_
  rw [map_mul, ← Complex.exp_conj]
  have : Complex.exp (Complex.I * ((-Real.log m : ℝ) : ℂ) * t) *
      Complex.exp ((starRingEnd ℂ) (Complex.I * ((-Real.log n : ℝ) : ℂ) * t)) =
      Complex.exp (Complex.I * ((Real.log n - Real.log m : ℝ) : ℂ) * t) := by
    rw [← Complex.exp_add]
    congr 1
    simp only [map_mul, Complex.conj_I, Complex.conj_ofReal]
    push_cast
    ring
  rw [← this]
  ring

/-- The integral of the squared norm over `[T₁, T₂]` is the double sum of
`a_m · conj a_n` times the integral of `e^{it(log n − log m)}`. -/
theorem integral_sq_norm_eq (N : ℕ) (a : ℕ → ℂ) (T₁ T₂ : ℝ) :
    ((∫ t in T₁..T₂,
        ‖∑ n ∈ Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ)))‖ ^ 2 : ℝ) : ℂ) =
      ∑ m ∈ Icc 1 N, ∑ n ∈ Icc 1 N, a m * (starRingEnd ℂ) (a n) *
        ∫ t in T₁..T₂, Complex.exp (Complex.I * ((Real.log n - Real.log m : ℝ) : ℂ) * t) := by
  rw [← intervalIntegral.integral_ofReal]
  simp_rw [sq_norm_sum_eq]
  rw [intervalIntegral.integral_finsetSum (fun m _ => ?_)]
  · refine sum_congr rfl fun m _ => ?_
    rw [intervalIntegral.integral_finsetSum (fun n _ => ?_)]
    · exact sum_congr rfl fun n _ => intervalIntegral.integral_const_mul _ _
    · exact (by fun_prop : Continuous _).intervalIntegrable _ _
  · exact (by fun_prop : Continuous _).intervalIntegrable _ _

/-- For a nonzero real frequency `θ`, the integral of `e^{iθt}` over any window has norm at
most `2/|θ|`. -/
theorem norm_integral_exp_le {θ : ℝ} (hθ : θ ≠ 0) (T₁ T₂ : ℝ) :
    ‖∫ t in T₁..T₂, Complex.exp (Complex.I * (θ : ℂ) * t)‖ ≤ 2 / |θ| := by
  have hc : Complex.I * (θ : ℂ) ≠ 0 := mul_ne_zero Complex.I_ne_zero (Complex.ofReal_ne_zero.2 hθ)
  rw [integral_exp_mul_complex hc, norm_div]
  have h1 : ∀ T : ℝ, ‖Complex.exp (Complex.I * (θ : ℂ) * T)‖ = 1 := fun T => by
    rw [show Complex.I * (θ : ℂ) * T = ((θ * T : ℝ) : ℂ) * Complex.I by push_cast; ring]
    exact Complex.norm_exp_ofReal_mul_I _
  have h2 : ‖Complex.I * (θ : ℂ)‖ = |θ| := by
    rw [norm_mul, Complex.norm_I, one_mul, Complex.norm_real, Real.norm_eq_abs]
  rw [h2]
  have hpos : 0 < |θ| := abs_pos.2 hθ
  gcongr
  calc _ ≤ ‖Complex.exp (Complex.I * (θ : ℂ) * T₂)‖ + ‖Complex.exp (Complex.I * (θ : ℂ) * T₁)‖ :=
        norm_sub_le _ _
    _ = 2 := by rw [h1, h1]; norm_num

/-- For `1 ≤ n < m ≤ N`, the gap between the logarithms is at least `(m − n)/N`. -/
theorem log_gap {m n N : ℕ} (hn : 1 ≤ n) (hnm : n < m) (hm : m ≤ N) :
    ((m : ℝ) - n) / N ≤ Real.log m - Real.log n := by
  have hn' : (0 : ℝ) < n := by exact_mod_cast hn
  have hnm' : (n : ℝ) < m := by exact_mod_cast hnm
  have hm' : (0 : ℝ) < m := by linarith
  have hN : (m : ℝ) ≤ N := by exact_mod_cast hm
  have h1 := Real.one_sub_inv_le_log_of_pos (div_pos hm' hn')
  rw [Real.log_div hm'.ne' hn'.ne', inv_div] at h1
  have h2 : ((m : ℝ) - n) / N ≤ ((m : ℝ) - n) / m :=
    div_le_div_of_nonneg_left (by linarith) hm' hN
  have h3 : ((m : ℝ) - n) / m = 1 - n / m := by field_simp
  linarith

/-- For distinct `m, n` in `[1, N]`, `2/|log n − log m|` is at most `2N/|m − n|`. -/
theorem inv_log_gap {m n N : ℕ} (hm : m ∈ Icc 1 N) (hn : n ∈ Icc 1 N) (hne : m ≠ n) :
    2 / |Real.log n - Real.log m| ≤ 2 * N * |(m : ℝ) - n|⁻¹ := by
  rw [mem_Icc] at hm hn
  have hN : (0 : ℝ) < N := by exact_mod_cast (show 0 < N by omega)
  -- the one-sided bound, for `p < q`
  have key : ∀ p q : ℕ, 1 ≤ p → p < q → q ≤ N →
      2 / (Real.log q - Real.log p) ≤ 2 * N * ((q : ℝ) - p)⁻¹ := by
    intro p q hp hpq hq
    have hpq' : (p : ℝ) < q := by exact_mod_cast hpq
    have hg := log_gap hp hpq hq
    have hpos : 0 < ((q : ℝ) - p) / N := div_pos (by linarith) hN
    calc 2 / (Real.log q - Real.log p) ≤ 2 / (((q : ℝ) - p) / N) :=
          div_le_div_of_nonneg_left (by norm_num) hpos hg
      _ = 2 * N * ((q : ℝ) - p)⁻¹ := by
          field_simp
  rcases lt_or_gt_of_ne hne with h | h
  · have h' : (m : ℝ) < n := by exact_mod_cast h
    have hg := log_gap hm.1 h hn.2
    have hpos : 0 < ((n : ℝ) - m) / N := div_pos (by linarith) hN
    rw [abs_of_pos (by linarith), abs_sub_comm, abs_of_pos (by linarith)]
    exact key m n hm.1 h hn.2
  · have h' : (n : ℝ) < m := by exact_mod_cast h
    have hg := log_gap hn.1 h hm.2
    have hpos : 0 < ((m : ℝ) - n) / N := div_pos (by linarith) hN
    rw [abs_sub_comm, abs_of_pos (by linarith), abs_of_pos (by linarith)]
    exact key n m hn.1 h hm.2

/-- A sum of `1/g(n)` over a set on which `g` is injective with values in `[1, N]` is at most
the harmonic sum up to `N`. -/
theorem sum_inv_le_harmonic {N : ℕ} (s : Finset ℕ) (g : ℕ → ℕ) (hg : Set.InjOn g s)
    (hmap : ∀ n ∈ s, g n ∈ Icc 1 N) :
    ∑ n ∈ s, ((g n : ℕ) : ℝ)⁻¹ ≤ ∑ k ∈ Icc 1 N, (k : ℝ)⁻¹ := by
  rw [← Finset.sum_image (f := fun k : ℕ => (k : ℝ)⁻¹) hg]
  refine sum_le_sum_of_subset_of_nonneg ?_ (fun _ _ _ => by positivity)
  intro k hk
  obtain ⟨n, hn, rfl⟩ := mem_image.1 hk
  exact hmap n hn

/-- The harmonic sum `Σ_{k=1}^{N} 1/k` is at most `1 + log N`. -/
theorem sum_inv_Icc_le (N : ℕ) : ∑ k ∈ Icc 1 N, (k : ℝ)⁻¹ ≤ 1 + Real.log N := by
  have := harmonic_le_one_add_log N
  simp_rw [harmonic_eq_sum_Icc, Rat.cast_sum, Rat.cast_inv, Rat.cast_natCast] at this
  exact this

/-- For `m` in `[1, N]`, the sum of `1/|m − n|` over the other `n` in `[1, N]` is at most
`2(1 + log N)`. -/
theorem sum_inv_dist_le {N m : ℕ} (hm : m ∈ Icc 1 N) :
    ∑ n ∈ Icc 1 N, (if m = n then 0 else |(m : ℝ) - n|⁻¹) ≤ 2 * (1 + Real.log N) := by
  have hm' := mem_Icc.1 hm
  calc ∑ n ∈ Icc 1 N, (if m = n then 0 else |(m : ℝ) - n|⁻¹)
      ≤ ∑ n ∈ Icc 1 N, ((if n < m then (((m - n : ℕ) : ℕ) : ℝ)⁻¹ else 0) +
          (if m < n then (((n - m : ℕ) : ℕ) : ℝ)⁻¹ else 0)) := by
        refine sum_le_sum fun n _ => ?_
        rcases lt_trichotomy n m with h | h | h
        · have h' : (n : ℝ) < m := by exact_mod_cast h
          rw [if_neg (by omega), if_pos h, if_neg (by omega), add_zero, Nat.cast_sub h.le,
            abs_of_pos (by linarith)]
        · subst h
          simp
        · have h' : (m : ℝ) < n := by exact_mod_cast h
          rw [if_neg (by omega), if_neg (by omega), if_pos h, zero_add, Nat.cast_sub h.le,
            abs_sub_comm, abs_of_pos (by linarith)]
    _ = ∑ n ∈ (Icc 1 N).filter (· < m), (((m - n : ℕ) : ℕ) : ℝ)⁻¹ +
          ∑ n ∈ (Icc 1 N).filter (m < ·), (((n - m : ℕ) : ℕ) : ℝ)⁻¹ := by
        rw [sum_add_distrib, sum_filter, sum_filter]
    _ ≤ ∑ k ∈ Icc 1 N, (k : ℝ)⁻¹ + ∑ k ∈ Icc 1 N, (k : ℝ)⁻¹ := by
        gcongr
        · refine sum_inv_le_harmonic _ (fun n => m - n) ?_ ?_
          · intro x hx y hy hxy
            simp only [coe_filter, mem_Icc, Set.mem_setOf_eq] at hx hy hxy
            omega
          · intro n hn
            simp only [mem_filter, mem_Icc] at hn ⊢
            omega
        · refine sum_inv_le_harmonic _ (fun n => n - m) ?_ ?_
          · intro x hx y hy hxy
            simp only [coe_filter, mem_Icc, Set.mem_setOf_eq] at hx hy hxy
            omega
          · intro n hn
            simp only [mem_filter, mem_Icc] at hn ⊢
            omega
    _ ≤ 2 * (1 + Real.log N) := by
        linarith [sum_inv_Icc_le N]

/-- For a symmetric nonnegative kernel `K` whose rows sum to at most `R`, the quadratic form
`Σ_m Σ_n A_m A_n K_{mn}` is at most `R · Σ A_m²`. -/
theorem sum_mul_mul_le (s : Finset ℕ) (A : ℕ → ℝ) (K : ℕ → ℕ → ℝ) (R : ℝ)
    (hK0 : ∀ m ∈ s, ∀ n ∈ s, 0 ≤ K m n) (hsym : ∀ m n, K m n = K n m)
    (hrow : ∀ m ∈ s, ∑ n ∈ s, K m n ≤ R) :
    ∑ m ∈ s, ∑ n ∈ s, A m * A n * K m n ≤ R * ∑ m ∈ s, A m ^ 2 := by
  calc ∑ m ∈ s, ∑ n ∈ s, A m * A n * K m n
      ≤ ∑ m ∈ s, ∑ n ∈ s, (A m ^ 2 / 2 * K m n + A n ^ 2 / 2 * K m n) :=
        sum_le_sum fun m hm => sum_le_sum fun n hn => by
          nlinarith [mul_nonneg (sq_nonneg (A m - A n)) (hK0 m hm n hn)]
    _ = ∑ m ∈ s, ∑ n ∈ s, A m ^ 2 / 2 * K m n + ∑ m ∈ s, ∑ n ∈ s, A n ^ 2 / 2 * K m n := by
        simp only [sum_add_distrib]
    _ = ∑ m ∈ s, ∑ n ∈ s, A m ^ 2 / 2 * K m n + ∑ m ∈ s, ∑ n ∈ s, A m ^ 2 / 2 * K m n := by
        congr 1
        rw [sum_comm]
        exact sum_congr rfl fun m _ => sum_congr rfl fun n _ => by rw [hsym]
    _ = ∑ m ∈ s, A m ^ 2 * ∑ n ∈ s, K m n := by
        rw [← sum_add_distrib]
        refine sum_congr rfl fun m _ => ?_
        rw [← sum_add_distrib, mul_sum]
        exact sum_congr rfl fun n _ => by ring
    _ ≤ ∑ m ∈ s, A m ^ 2 * R :=
        sum_le_sum fun m hm => mul_le_mul_of_nonneg_left (hrow m hm) (sq_nonneg _)
    _ = R * ∑ m ∈ s, A m ^ 2 := by rw [mul_sum]; exact sum_congr rfl fun m _ => by ring

/-- On a window `[T₁, T₂]`, the mean square of a finite Dirichlet sum `Σ_{n ≤ N} a_n n^{-it}`
is at most `(T₂ − T₁ + 8N(1 + log N))·Σ |a_n|²`. -/
theorem dirichlet_mean_value_window (N : ℕ) (a : ℕ → ℂ) {T₁ T₂ : ℝ} (h : T₁ ≤ T₂) :
    ∫ t in T₁..T₂,
        ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ)))‖ ^ 2
      ≤ (T₂ - T₁ + 8 * N * (1 + Real.log N)) * ∑ n ∈ Finset.Icc 1 N, ‖a n‖ ^ 2 := by
  set L := T₂ - T₁ with hL
  have hL0 : 0 ≤ L := by rw [hL]; linarith
  set D : ℕ → ℕ → ℝ := fun m n => if m = n then 0 else |(m : ℝ) - n|⁻¹ with hD
  set K : ℕ → ℕ → ℝ := fun m n => (if m = n then L else 0) + 2 * N * D m n with hK
  have hlogN : 0 ≤ Real.log N := Real.log_natCast_nonneg N
  have hD0 : ∀ m n, 0 ≤ D m n := fun m n => by
    simp only [hD]; split_ifs <;> positivity
  have hK0 : ∀ m ∈ Icc 1 N, ∀ n ∈ Icc 1 N, 0 ≤ K m n := fun m _ n _ => by
    have := hD0 m n
    simp only [hK]; split_ifs <;> positivity
  have hsym : ∀ m n, K m n = K n m := fun m n => by
    simp only [hK, hD]
    by_cases hmn : m = n
    · subst hmn; rfl
    · rw [if_neg hmn, if_neg (Ne.symm hmn), if_neg hmn, if_neg (Ne.symm hmn), abs_sub_comm]
  have hrow : ∀ m ∈ Icc 1 N, ∑ n ∈ Icc 1 N, K m n ≤ L + 8 * N * (1 + Real.log N) := by
    intro m hm
    have h1 : ∑ n ∈ Icc 1 N, K m n = L + 2 * N * ∑ n ∈ Icc 1 N, D m n := by
      simp only [hK, sum_add_distrib, sum_ite_eq, if_pos hm, ← mul_sum]
    rw [h1]
    have h2 := sum_inv_dist_le hm
    have hN0 : (0 : ℝ) ≤ N := Nat.cast_nonneg N
    nlinarith
  have hJ : ∀ m ∈ Icc 1 N, ∀ n ∈ Icc 1 N,
      ‖∫ t in T₁..T₂, Complex.exp (Complex.I * ((Real.log n - Real.log m : ℝ) : ℂ) * t)‖
        ≤ K m n := by
    intro m hm n hn
    by_cases hmn : m = n
    · subst hmn
      simp only [hK, hD, if_true, mul_zero, add_zero, sub_self, Complex.ofReal_zero,
        mul_zero, zero_mul, Complex.exp_zero, intervalIntegral.integral_const, Complex.real_smul,
        mul_one, Complex.norm_real, Real.norm_eq_abs]
      rw [abs_of_nonneg hL0]
    · have hθ : Real.log n - Real.log m ≠ 0 := by
        have hm' := (mem_Icc.1 hm).1
        have hn' := (mem_Icc.1 hn).1
        have hmpos : (0 : ℝ) < m := by exact_mod_cast hm'
        have hnpos : (0 : ℝ) < n := by exact_mod_cast hn'
        rcases lt_or_gt_of_ne hmn with h | h
        · have := Real.log_lt_log hmpos (by exact_mod_cast h : (m : ℝ) < n)
          linarith
        · have := Real.log_lt_log hnpos (by exact_mod_cast h : (n : ℝ) < m)
          linarith
      refine (norm_integral_exp_le hθ T₁ T₂).trans ?_
      simp only [hK, hD, if_neg hmn, zero_add]
      exact inv_log_gap hm hn hmn
  calc ∫ t in T₁..T₂,
        ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ)))‖ ^ 2
      ≤ ‖((∫ t in T₁..T₂,
          ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ)))‖ ^ 2 : ℝ) : ℂ)‖ := by
        rw [Complex.norm_real, Real.norm_eq_abs]
        exact le_abs_self _
    _ = ‖∑ m ∈ Icc 1 N, ∑ n ∈ Icc 1 N, a m * (starRingEnd ℂ) (a n) *
          ∫ t in T₁..T₂,
            Complex.exp (Complex.I * ((Real.log n - Real.log m : ℝ) : ℂ) * t)‖ := by
        rw [integral_sq_norm_eq]
    _ ≤ ∑ m ∈ Icc 1 N, ∑ n ∈ Icc 1 N, ‖a m‖ * ‖a n‖ * K m n := by
        refine (norm_sum_le _ _).trans (sum_le_sum fun m hm =>
          (norm_sum_le _ _).trans (sum_le_sum fun n hn => ?_))
        rw [norm_mul, norm_mul, Complex.norm_conj]
        exact mul_le_mul_of_nonneg_left (hJ m hm n hn) (by positivity)
    _ ≤ (L + 8 * N * (1 + Real.log N)) * ∑ m ∈ Icc 1 N, ‖a m‖ ^ 2 :=
        sum_mul_mul_le _ _ K _ hK0 hsym hrow

/-- On `[0, T]`, the mean square of a finite Dirichlet sum `Σ_{n ≤ N} a_n n^{-it}` is at most
`(T + 8N(1 + log N))·Σ |a_n|²`. -/
theorem dirichlet_mean_value (N : ℕ) (a : ℕ → ℂ) {T : ℝ} (hT : 0 ≤ T) :
    ∫ t in (0:ℝ)..T,
        ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ)))‖ ^ 2
      ≤ (T + 8 * N * (1 + Real.log N)) * ∑ n ∈ Finset.Icc 1 N, ‖a n‖ ^ 2 := by
  simpa using dirichlet_mean_value_window N a hT

/-- With a real part `σ`, the mean square on `[0, T]` of `Σ_{n ≤ N} a_n n^{-(σ+it)}` is at most
`(T + 8N(1 + log N))·Σ |a_n|²·n^{-2σ}`. -/
theorem dirichlet_mean_value_sigma (N : ℕ) (a : ℕ → ℂ) (σ : ℝ) {T : ℝ} (hT : 0 ≤ T) :
    ∫ t in (0:ℝ)..T,
        ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-((σ : ℂ) + Complex.I * (t : ℂ)))‖ ^ 2
      ≤ (T + 8 * N * (1 + Real.log N)) *
          ∑ n ∈ Finset.Icc 1 N, ‖a n‖ ^ 2 * (n : ℝ) ^ (-2 * σ) := by
  have h1 : ∀ t : ℝ, ∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-((σ : ℂ) + Complex.I * (t : ℂ))) =
      ∑ n ∈ Finset.Icc 1 N, (a n * (n : ℂ) ^ (-(σ : ℂ))) *
        (n : ℂ) ^ (-(Complex.I * (t : ℂ))) := fun t =>
    sum_congr rfl fun n hn => by
      have : (n : ℂ) ≠ 0 := Nat.cast_ne_zero.2 (by have := (mem_Icc.1 hn).1; omega)
      rw [neg_add, Complex.cpow_add _ _ this, mul_assoc]
  have h2 : ∑ n ∈ Finset.Icc 1 N, ‖a n * (n : ℂ) ^ (-(σ : ℂ))‖ ^ 2 =
      ∑ n ∈ Finset.Icc 1 N, ‖a n‖ ^ 2 * (n : ℝ) ^ (-2 * σ) :=
    sum_congr rfl fun n hn => by
      have hn0 : 0 < n := by have := (mem_Icc.1 hn).1; omega
      rw [norm_mul, Complex.norm_natCast_cpow_of_pos hn0, mul_pow]
      congr 1
      rw [Complex.neg_re, Complex.ofReal_re, ← Real.rpow_natCast,
        ← Real.rpow_mul (Nat.cast_nonneg _)]
      congr 1
      push_cast
      ring
  simp_rw [h1]
  rw [← h2]
  exact dirichlet_mean_value N _ hT

/-- info: 'DirichletMean.dirichlet_mean_value' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dirichlet_mean_value

/-- info: 'DirichletMean.dirichlet_mean_value_window' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dirichlet_mean_value_window

/-- info: 'DirichletMean.dirichlet_mean_value_sigma' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dirichlet_mean_value_sigma

end

end DirichletMean
