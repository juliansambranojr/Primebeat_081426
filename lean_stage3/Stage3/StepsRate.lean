/-
StepsRate — block R8 of `lean_stage3/design/runs.md`. 2026-11-23.

The second size of unit 0472: the size rate. Away from the zeros the turned
steps to a cutoff `N`, less their smooth term, grow no faster than `N` to the
power of the largest real part of a zero below the height less the real part
of the point.

  norm_K_le_pow   a ≠ s, a ≠ s − 1, Re a − Re s ≤ δ, 0 ≤ δ ⊢
                    ‖K(a)‖ ≤ (‖s‖/‖a−s‖ + ‖s−1‖/‖a−s+1‖)·2·N^δ
  rate_upper      every zero below T has real part ≤ Θ and is not s,
                  0 < Re s ≤ 1, Re s ≤ Θ ⊢
                    ‖S − K(1)‖ ≤ (Σ over the zeros below T)·N^(Θ − Re s) + error

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.StepsPeak

namespace StepsRate

open StepsPeak Kadiri

/-- **A zero's kernel grows at most as the cutoff to the gap of the real parts.** -/
theorem norm_K_le_pow {N : ℕ} (hN : 2 ≤ N) {s a : ℂ} (h1 : a ≠ s) (h2 : a ≠ s - 1)
    {δ : ℝ} (hδ : 0 ≤ δ) (hre : a.re - s.re ≤ δ) :
    ‖K N s a‖ ≤ (‖s‖ / ‖a - s‖ + ‖s - 1‖ / ‖a - s + 1‖) * 2 * (N : ℝ) ^ δ := by
  have hN' : (2:ℝ) ≤ N := by exact_mod_cast hN
  have hNpos : (0:ℝ) < N := by linarith
  have hP : 0 < (N:ℝ) ^ δ := Real.rpow_pos_of_pos hNpos δ
  have has1 : a - s + 1 ≠ 0 := fun h => h2 (by linear_combination h)
  have hn1 : ‖(N:ℂ) ^ (a - s)‖ ≤ (N:ℝ) ^ δ := by
    rw [← Complex.ofReal_natCast, Complex.norm_cpow_eq_rpow_re_of_pos hNpos]
    exact Real.rpow_le_rpow_of_exponent_le (by linarith) (by simpa using hre)
  have hn2 : ‖(2:ℂ) ^ (a - s)‖ ≤ (N:ℝ) ^ δ := by
    rw [← Complex.ofReal_ofNat, Complex.norm_cpow_eq_rpow_re_of_pos (by norm_num)]
    calc (2:ℝ) ^ (a - s).re ≤ (2:ℝ) ^ δ :=
          Real.rpow_le_rpow_of_exponent_le (by norm_num) (by simpa using hre)
      _ ≤ (N:ℝ) ^ δ := Real.rpow_le_rpow (by norm_num) hN' hδ
  have hn3 : ‖(N:ℂ) ^ (a - s + 1)‖ ≤ (N:ℝ) ^ δ * N := by
    rw [← Complex.ofReal_natCast, Complex.norm_cpow_eq_rpow_re_of_pos hNpos]
    calc (N:ℝ) ^ (a - s + 1).re ≤ (N:ℝ) ^ (δ + 1) :=
          Real.rpow_le_rpow_of_exponent_le (by linarith) (by simp; linarith)
      _ = (N:ℝ) ^ δ * N := by rw [Real.rpow_add hNpos, Real.rpow_one]
  have hn4 : ‖(2:ℂ) ^ (a - s + 1)‖ ≤ (N:ℝ) ^ δ * N := by
    rw [← Complex.ofReal_ofNat, Complex.norm_cpow_eq_rpow_re_of_pos (by norm_num)]
    calc (2:ℝ) ^ (a - s + 1).re ≤ (2:ℝ) ^ (δ + 1) :=
          Real.rpow_le_rpow_of_exponent_le (by norm_num) (by simp; linarith)
      _ ≤ (N:ℝ) ^ (δ + 1) := Real.rpow_le_rpow (by norm_num) hN' (by linarith)
      _ = (N:ℝ) ^ δ * N := by rw [Real.rpow_add hNpos, Real.rpow_one]
  rw [K_eq hN h1 h2]
  refine (norm_sub_le _ _).trans ?_
  have hX : ‖s * ((N:ℂ) ^ (a - s) - 2 ^ (a - s)) / (a - s)‖
      ≤ ‖s‖ / ‖a - s‖ * 2 * (N:ℝ) ^ δ := by
    rw [norm_div, norm_mul]
    have h : ‖(N:ℂ) ^ (a - s) - 2 ^ (a - s)‖ ≤ 2 * (N:ℝ) ^ δ :=
      (norm_sub_le _ _).trans (by linarith)
    calc ‖s‖ * ‖(N:ℂ) ^ (a - s) - 2 ^ (a - s)‖ / ‖a - s‖
        ≤ ‖s‖ * (2 * (N:ℝ) ^ δ) / ‖a - s‖ :=
          div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left h (norm_nonneg _))
            (norm_nonneg _)
      _ = ‖s‖ / ‖a - s‖ * 2 * (N:ℝ) ^ δ := by ring
  have hY : ‖(s - 1) * ((N:ℂ) ^ (a - s + 1) - 2 ^ (a - s + 1)) / ((a - s + 1) * N)‖
      ≤ ‖s - 1‖ / ‖a - s + 1‖ * 2 * (N:ℝ) ^ δ := by
    rw [norm_div, norm_mul, norm_mul, Complex.norm_natCast]
    have h : ‖(N:ℂ) ^ (a - s + 1) - 2 ^ (a - s + 1)‖ ≤ 2 * ((N:ℝ) ^ δ * N) :=
      (norm_sub_le _ _).trans (by linarith)
    have hd : ‖a - s + 1‖ ≠ 0 := norm_ne_zero_iff.mpr has1
    have hN0 : (N:ℝ) ≠ 0 := hNpos.ne'
    calc ‖s - 1‖ * ‖(N:ℂ) ^ (a - s + 1) - 2 ^ (a - s + 1)‖ / (‖a - s + 1‖ * N)
        ≤ ‖s - 1‖ * (2 * ((N:ℝ) ^ δ * N)) / (‖a - s + 1‖ * N) :=
          div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left h (norm_nonneg _))
            (by positivity)
      _ = ‖s - 1‖ / ‖a - s + 1‖ * 2 * (N:ℝ) ^ δ := by
          field_simp
  have e : (‖s‖ / ‖a - s‖ + ‖s - 1‖ / ‖a - s + 1‖) * 2 * (N : ℝ) ^ δ
      = ‖s‖ / ‖a - s‖ * 2 * (N:ℝ) ^ δ + ‖s - 1‖ / ‖a - s + 1‖ * 2 * (N:ℝ) ^ δ := by ring
  rw [e]
  linarith

/-- **The size rate, from above.** At a point `s` with `0 < Re s ≤ 1` that is
not a zero, if every zero below the height `T` has real part at most `Θ` and
`Re s ≤ Θ`, the turned steps to the cutoff `N` less their smooth term are at
most a sum over the zeros below `T`, free of `N`, times `N^(Θ − Re s)`, plus
the error of `peak_formula`. -/
theorem rate_upper {N : ℕ} (hN : 2 ≤ N) {s : ℂ} (hs : 0 < s.re) (hs1 : s.re ≤ 1)
    {T : ℝ} (hT : 2 ≤ T) {Θ : ℝ} (hsΘ : s.re ≤ Θ)
    (hΘ : ∀ ρ ∈ FiniteOffLine.ZF T, (ρ : ℂ).re ≤ Θ)
    (hne : ∀ ρ ∈ FiniteOffLine.ZF T, (ρ : ℂ) ≠ s) :
    ‖S N s - K N s 1‖
      ≤ (∑ ρ ∈ FiniteOffLine.ZF T,
            ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) / ‖(ρ : ℂ)‖
              * ((‖s‖ / ‖(ρ : ℂ) - s‖ + ‖s - 1‖ / ‖(ρ : ℂ) - s + 1‖) * 2))
          * (N : ℝ) ^ (Θ - s.re)
        + (‖s‖ + ‖s - 1‖) * (ExplicitTwo.c1t * N * Real.log ((N:ℝ) * T) ^ 2 / T + C1 s.re) := by
  have hpf := peak_formula hN hs hT
  have htri : ‖S N s - K N s 1‖
      ≤ ‖S N s - K N s 1 + ∑ ρ ∈ FiniteOffLine.ZF T,
            ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * K N s (ρ : ℂ)‖
        + ‖∑ ρ ∈ FiniteOffLine.ZF T,
            ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * K N s (ρ : ℂ)‖ := by
    have := norm_sub_le (S N s - K N s 1 + ∑ ρ ∈ FiniteOffLine.ZF T,
            ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * K N s (ρ : ℂ))
        (∑ ρ ∈ FiniteOffLine.ZF T,
            ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * K N s (ρ : ℂ))
    simpa using this
  have hsum : ‖∑ ρ ∈ FiniteOffLine.ZF T,
        ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * K N s (ρ : ℂ)‖
      ≤ (∑ ρ ∈ FiniteOffLine.ZF T,
            ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) / ‖(ρ : ℂ)‖
              * ((‖s‖ / ‖(ρ : ℂ) - s‖ + ‖s - 1‖ / ‖(ρ : ℂ) - s + 1‖) * 2))
          * (N : ℝ) ^ (Θ - s.re) := by
    rw [Finset.sum_mul]
    refine (norm_sum_le _ _).trans (Finset.sum_le_sum fun ρ hρ => ?_)
    have hρre : 0 < (ρ : ℂ).re := ρ.2.1.1
    have h2 : (ρ : ℂ) ≠ s - 1 := by
      intro h
      have := congrArg Complex.re h
      simp at this
      linarith
    have hK := norm_K_le_pow hN (hne ρ hρ) h2 (δ := Θ - s.re) (by linarith)
      (by linarith [hΘ ρ hρ])
    rw [norm_mul, norm_div, norm_order]
    have hc : 0 ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) / ‖(ρ : ℂ)‖ :=
      div_nonneg (FiniteOffLine.order_nonneg ρ) (norm_nonneg _)
    calc ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) / ‖(ρ : ℂ)‖ * ‖K N s (ρ : ℂ)‖
        ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) / ‖(ρ : ℂ)‖
            * ((‖s‖ / ‖(ρ : ℂ) - s‖ + ‖s - 1‖ / ‖(ρ : ℂ) - s + 1‖) * 2
                * (N : ℝ) ^ (Θ - s.re)) := mul_le_mul_of_nonneg_left hK hc
      _ = _ := by ring
  linarith

/-- info: 'StepsRate.norm_K_le_pow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_K_le_pow

/-- info: 'StepsRate.rate_upper' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rate_upper

end StepsRate
