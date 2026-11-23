/-
DirichletMeanW — block C1b of `lean_stage3/design/carlson.md`. 2026-11-23.

A weighted mean value theorem for a finite Dirichlet sum. It replaces the uniform length `N` of
block C1 by each term's own index: for `S(t) = Σ_{n ≤ N} a_n n^{-it}` the integral of `|S|²`
over a window of length `L` is at most `Σ |a_n|²·(L + 6n(1 + log N))`. The square expands into
a double sum as in `DirichletMean`. Off the diagonal the kernel is at most `2/|log m − log n|`.
A weighted Schur test with weights `1/n` charges row `m` the cost `m·Σ_{n ≠ m} K(m,n)/n`, and the
gap `log(larger) − log(smaller) ≥ (larger − smaller)/larger` bounds that by `6m(1 + log N)`.
A real part `σ` enters through the weights `a_n n^{-σ}`.

  log_gap_larger                      1 ≤ p < q ⊢ (q − p)/q ≤ log q − log p
  weighted_gap                        m ≠ n ≥ 1 ⊢ 2/|log n − log m|·(m/n) ≤ 2m(|m − n|⁻¹ + n⁻¹)
  sum_mul_mul_le_weighted             Σ_m Σ_n A_m A_n K_{mn} ≤ Σ_m A_m²·R_m, if Σ_n K_{mn}w_m/w_n ≤ R_m
  dirichlet_mean_value_weighted       T₁ ≤ T₂ ⊢ ∫_{T₁}^{T₂} |S|² ≤ Σ|a_n|²·(T₂ − T₁ + 6n(1+log N))
  dirichlet_mean_value_weighted_sigma the same with n^{-(σ+it)}, each term also weighted by n^{-2σ}

What the next slice needs: the weighted theorem applied to the mollified zeta sum on a vertical
line, where the coefficient decay makes `Σ|a_n|²·n` small. It is not here.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.DirichletMean

namespace DirichletMeanW

open Finset DirichletMean

noncomputable section

/-- For `1 ≤ p < q`, the gap between the logarithms is at least `(q − p)/q`, with the larger
index in the denominator. -/
theorem log_gap_larger {p q : ℕ} (hp : 1 ≤ p) (hpq : p < q) :
    ((q : ℝ) - p) / q ≤ Real.log q - Real.log p := by
  have hp' : (0 : ℝ) < p := by exact_mod_cast hp
  have hpq' : (p : ℝ) < q := by exact_mod_cast hpq
  have hq' : (0 : ℝ) < q := by linarith
  have h1 := Real.one_sub_inv_le_log_of_pos (div_pos hq' hp')
  rw [Real.log_div hq'.ne' hp'.ne', inv_div] at h1
  have h3 : ((q : ℝ) - p) / q = 1 - p / q := by field_simp
  linarith

/-- For distinct `m, n ≥ 1`, the off-diagonal kernel bound `2/|log n − log m|` times the weight
ratio `m/n` is at most `2m(1/|m − n| + 1/n)`. -/
theorem weighted_gap {m n : ℕ} (hm : 1 ≤ m) (hn : 1 ≤ n) (hne : m ≠ n) :
    2 / |Real.log n - Real.log m| * ((m : ℝ) / n)
      ≤ 2 * m * (|(m : ℝ) - n|⁻¹ + (n : ℝ)⁻¹) := by
  have hm' : (0 : ℝ) < m := by exact_mod_cast hm
  have hn' : (0 : ℝ) < n := by exact_mod_cast hn
  have hmn0 : (0 : ℝ) ≤ m / n := by positivity
  rcases lt_or_gt_of_ne hne with h | h
  · -- `m < n`: the gap is at least `(n − m)/n`
    have h' : (m : ℝ) < n := by exact_mod_cast h
    have hg := log_gap_larger hm h
    set d : ℝ := (n : ℝ) - m with hd
    have hd0 : 0 < d := by rw [hd]; linarith
    set g : ℝ := Real.log n - Real.log m with hgdef
    have hg0 : 0 < g := lt_of_lt_of_le (div_pos hd0 hn') hg
    have habs : |(m : ℝ) - n| = d := by rw [abs_sub_comm, abs_of_pos hd0]
    rw [abs_of_pos hg0, habs]
    have hdg : d ≤ g * n := (div_le_iff₀ hn').1 hg
    have h2 : 2 / g ≤ 2 * n / d := by
      rw [div_le_div_iff₀ hg0 hd0]; nlinarith
    calc 2 / g * ((m : ℝ) / n) ≤ 2 * n / d * ((m : ℝ) / n) :=
          mul_le_mul_of_nonneg_right h2 hmn0
      _ = 2 * m * d⁻¹ := by field_simp
      _ ≤ 2 * m * (d⁻¹ + (n : ℝ)⁻¹) := by
          have : (0 : ℝ) ≤ (n : ℝ)⁻¹ := by positivity
          have : (0 : ℝ) ≤ 2 * m := by positivity
          nlinarith
  · -- `n < m`: the gap is at least `(m − n)/m`
    have h' : (n : ℝ) < m := by exact_mod_cast h
    have hg := log_gap_larger hn h
    set d : ℝ := (m : ℝ) - n with hd
    have hd0 : 0 < d := by rw [hd]; linarith
    set g : ℝ := Real.log m - Real.log n with hgdef
    have hg0 : 0 < g := lt_of_lt_of_le (div_pos hd0 hm') hg
    have habs : |Real.log n - Real.log m| = g := by rw [abs_sub_comm, abs_of_pos hg0]
    rw [habs, abs_of_pos hd0]
    have hdg : d ≤ g * m := (div_le_iff₀ hm').1 hg
    have h2 : 2 / g ≤ 2 * m / d := by
      rw [div_le_div_iff₀ hg0 hd0]; nlinarith
    calc 2 / g * ((m : ℝ) / n) ≤ 2 * m / d * ((m : ℝ) / n) :=
          mul_le_mul_of_nonneg_right h2 hmn0
      _ = 2 * m * (d⁻¹ + (n : ℝ)⁻¹) := by
          rw [hd]
          have : (m : ℝ) - n ≠ 0 := hd0.ne'
          field_simp
          try ring

/-- Weighted Schur test: for a symmetric nonnegative kernel `K` and positive weights `w`, the
quadratic form `Σ_m Σ_n A_m A_n K_{mn}` is at most `Σ_m A_m²·R_m` whenever each weighted row
`Σ_n K_{mn}·(w_m/w_n)` is at most `R_m`. -/
theorem sum_mul_mul_le_weighted (s : Finset ℕ) (A w : ℕ → ℝ) (K : ℕ → ℕ → ℝ) (R : ℕ → ℝ)
    (hw : ∀ m ∈ s, 0 < w m)
    (hK0 : ∀ m ∈ s, ∀ n ∈ s, 0 ≤ K m n) (hsym : ∀ m n, K m n = K n m)
    (hrow : ∀ m ∈ s, ∑ n ∈ s, K m n * (w m / w n) ≤ R m) :
    ∑ m ∈ s, ∑ n ∈ s, A m * A n * K m n ≤ ∑ m ∈ s, A m ^ 2 * R m := by
  have hpt : ∀ m ∈ s, ∀ n ∈ s, A m * A n * K m n ≤
      A m ^ 2 / 2 * (K m n * (w m / w n)) + A n ^ 2 / 2 * (K n m * (w n / w m)) := by
    intro m hm n hn
    have hu : 0 < w m / w n := div_pos (hw m hm) (hw n hn)
    have hwm : w m ≠ 0 := (hw m hm).ne'
    have hwn : w n ≠ 0 := (hw n hn).ne'
    have key : 2 * A m * A n ≤ A m ^ 2 * (w m / w n) + A n ^ 2 * (w m / w n)⁻¹ := by
      rw [← sub_nonneg]
      have : A m ^ 2 * (w m / w n) + A n ^ 2 * (w m / w n)⁻¹ - 2 * A m * A n =
          (A m * (w m / w n) - A n) ^ 2 * (w m / w n)⁻¹ := by
        field_simp
        try ring
      rw [this]
      positivity
    rw [inv_div] at key
    rw [hsym n m]
    nlinarith [hK0 m hm n hn]
  calc ∑ m ∈ s, ∑ n ∈ s, A m * A n * K m n
      ≤ ∑ m ∈ s, ∑ n ∈ s,
          (A m ^ 2 / 2 * (K m n * (w m / w n)) + A n ^ 2 / 2 * (K n m * (w n / w m))) :=
        sum_le_sum fun m hm => sum_le_sum fun n hn => hpt m hm n hn
    _ = ∑ m ∈ s, ∑ n ∈ s, A m ^ 2 / 2 * (K m n * (w m / w n)) +
          ∑ m ∈ s, ∑ n ∈ s, A n ^ 2 / 2 * (K n m * (w n / w m)) := by
        simp only [sum_add_distrib]
    _ = ∑ m ∈ s, ∑ n ∈ s, A m ^ 2 / 2 * (K m n * (w m / w n)) +
          ∑ m ∈ s, ∑ n ∈ s, A m ^ 2 / 2 * (K m n * (w m / w n)) := by
        rw [sum_comm (s := s) (t := s) (f := fun m n => A n ^ 2 / 2 * (K n m * (w n / w m)))]
    _ = ∑ m ∈ s, A m ^ 2 * ∑ n ∈ s, K m n * (w m / w n) := by
        rw [← sum_add_distrib]
        refine sum_congr rfl fun m _ => ?_
        rw [← sum_add_distrib, mul_sum]
        exact sum_congr rfl fun n _ => by ring
    _ ≤ ∑ m ∈ s, A m ^ 2 * R m :=
        sum_le_sum fun m hm => mul_le_mul_of_nonneg_left (hrow m hm) (sq_nonneg _)

/-- On a window `[T₁, T₂]`, the mean square of a finite Dirichlet sum `Σ_{n ≤ N} a_n n^{-it}`
is at most `Σ |a_n|²·(T₂ − T₁ + 6n(1 + log N))`, each term charged its own index `n`. -/
theorem dirichlet_mean_value_weighted (N : ℕ) (a : ℕ → ℂ) {T₁ T₂ : ℝ} (h : T₁ ≤ T₂) :
    ∫ t in T₁..T₂,
        ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-(Complex.I * (t : ℂ)))‖ ^ 2
      ≤ ∑ n ∈ Finset.Icc 1 N, ‖a n‖ ^ 2 * ((T₂ - T₁) + 6 * n * (1 + Real.log N)) := by
  set L := T₂ - T₁ with hL
  have hL0 : 0 ≤ L := by rw [hL]; linarith
  set K : ℕ → ℕ → ℝ := fun m n =>
    if m = n then L else 2 / |Real.log n - Real.log m| with hK
  set D : ℕ → ℕ → ℝ := fun m n => if m = n then 0 else |(m : ℝ) - n|⁻¹ with hD
  have hlogN : 0 ≤ Real.log N := Real.log_natCast_nonneg N
  have hK0 : ∀ m ∈ Icc 1 N, ∀ n ∈ Icc 1 N, 0 ≤ K m n := fun m _ n _ => by
    simp only [hK]; split_ifs <;> positivity
  have hsym : ∀ m n, K m n = K n m := fun m n => by
    simp only [hK]
    by_cases hmn : m = n
    · subst hmn; rfl
    · rw [if_neg hmn, if_neg (Ne.symm hmn), abs_sub_comm]
  have hw : ∀ m ∈ Icc 1 N, (0 : ℝ) < (m : ℝ) := fun m hm => by
    have := (mem_Icc.1 hm).1
    exact_mod_cast (show 0 < m by omega)
  have hrow : ∀ m ∈ Icc 1 N, ∑ n ∈ Icc 1 N, K m n * ((m : ℝ) / n)
      ≤ L + 6 * m * (1 + Real.log N) := by
    intro m hm
    have hm1 := (mem_Icc.1 hm).1
    have hmpos := hw m hm
    have hpt : ∀ n ∈ Icc 1 N, K m n * ((m : ℝ) / n) ≤
        (if m = n then L else 0) + 2 * m * (D m n + (n : ℝ)⁻¹) := by
      intro n hn
      have hn1 := (mem_Icc.1 hn).1
      by_cases hmn : m = n
      · subst hmn
        simp only [hK, hD, if_true, div_self hmpos.ne', mul_one, zero_add]
        have : (0 : ℝ) ≤ 2 * m * (m : ℝ)⁻¹ := by positivity
        linarith
      · simp only [hK, hD, if_neg hmn, zero_add]
        exact weighted_gap hm1 hn1 hmn
    calc ∑ n ∈ Icc 1 N, K m n * ((m : ℝ) / n)
        ≤ ∑ n ∈ Icc 1 N, ((if m = n then L else 0) + 2 * m * (D m n + (n : ℝ)⁻¹)) :=
          sum_le_sum hpt
      _ = L + 2 * m * (∑ n ∈ Icc 1 N, D m n + ∑ n ∈ Icc 1 N, (n : ℝ)⁻¹) := by
          rw [sum_add_distrib, sum_ite_eq, if_pos hm, ← mul_sum, sum_add_distrib]
      _ ≤ L + 6 * m * (1 + Real.log N) := by
          have h1 := sum_inv_dist_le hm
          have h2 := sum_inv_Icc_le N
          have hDsum : ∑ n ∈ Icc 1 N, D m n ≤ 2 * (1 + Real.log N) := h1
          nlinarith
  have hJ : ∀ m ∈ Icc 1 N, ∀ n ∈ Icc 1 N,
      ‖∫ t in T₁..T₂, Complex.exp (Complex.I * ((Real.log n - Real.log m : ℝ) : ℂ) * t)‖
        ≤ K m n := by
    intro m hm n hn
    by_cases hmn : m = n
    · subst hmn
      simp only [hK, if_true, sub_self, Complex.ofReal_zero,
        mul_zero, zero_mul, Complex.exp_zero, intervalIntegral.integral_const, Complex.real_smul,
        mul_one, Complex.norm_real, Real.norm_eq_abs]
      rw [abs_of_nonneg hL0]
    · have hθ : Real.log n - Real.log m ≠ 0 := by
        have hmpos := hw m hm
        have hnpos := hw n hn
        rcases lt_or_gt_of_ne hmn with h | h
        · have := Real.log_lt_log hmpos (by exact_mod_cast h : (m : ℝ) < n)
          linarith
        · have := Real.log_lt_log hnpos (by exact_mod_cast h : (n : ℝ) < m)
          linarith
      refine (norm_integral_exp_le hθ T₁ T₂).trans ?_
      simp only [hK, if_neg hmn, le_refl]
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
    _ ≤ ∑ m ∈ Icc 1 N, ‖a m‖ ^ 2 * (L + 6 * m * (1 + Real.log N)) :=
        sum_mul_mul_le_weighted _ _ (fun n => (n : ℝ)) K _ hw hK0 hsym hrow

/-- With a real part `σ`, the mean square on `[T₁, T₂]` of `Σ_{n ≤ N} a_n n^{-(σ+it)}` is at
most `Σ |a_n|²·n^{-2σ}·(T₂ − T₁ + 6n(1 + log N))`, each term charged its own index `n`. -/
theorem dirichlet_mean_value_weighted_sigma (N : ℕ) (a : ℕ → ℂ) (σ : ℝ) {T₁ T₂ : ℝ}
    (h : T₁ ≤ T₂) :
    ∫ t in T₁..T₂,
        ‖∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-((σ : ℂ) + Complex.I * (t : ℂ)))‖ ^ 2
      ≤ ∑ n ∈ Finset.Icc 1 N,
          ‖a n‖ ^ 2 * (n : ℝ) ^ (-2 * σ) * ((T₂ - T₁) + 6 * n * (1 + Real.log N)) := by
  have h1 : ∀ t : ℝ, ∑ n ∈ Finset.Icc 1 N, a n * (n : ℂ) ^ (-((σ : ℂ) + Complex.I * (t : ℂ))) =
      ∑ n ∈ Finset.Icc 1 N, (a n * (n : ℂ) ^ (-(σ : ℂ))) *
        (n : ℂ) ^ (-(Complex.I * (t : ℂ))) := fun t =>
    sum_congr rfl fun n hn => by
      have : (n : ℂ) ≠ 0 := Nat.cast_ne_zero.2 (by have := (mem_Icc.1 hn).1; omega)
      rw [neg_add, Complex.cpow_add _ _ this, mul_assoc]
  have h2 : ∀ n ∈ Finset.Icc 1 N, ‖a n * (n : ℂ) ^ (-(σ : ℂ))‖ ^ 2 =
      ‖a n‖ ^ 2 * (n : ℝ) ^ (-2 * σ) := fun n hn => by
    have hn0 : 0 < n := by have := (mem_Icc.1 hn).1; omega
    rw [norm_mul, Complex.norm_natCast_cpow_of_pos hn0, mul_pow]
    congr 1
    rw [Complex.neg_re, Complex.ofReal_re, ← Real.rpow_natCast,
      ← Real.rpow_mul (Nat.cast_nonneg _)]
    congr 1
    push_cast
    ring
  simp_rw [h1]
  refine (dirichlet_mean_value_weighted N _ h).trans (le_of_eq ?_)
  exact sum_congr rfl fun n hn => by rw [h2 n hn]

/-- info: 'DirichletMeanW.dirichlet_mean_value_weighted' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dirichlet_mean_value_weighted

/-- info: 'DirichletMeanW.dirichlet_mean_value_weighted_sigma' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dirichlet_mean_value_weighted_sigma

end

end DirichletMeanW
