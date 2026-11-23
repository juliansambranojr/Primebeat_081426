/-
PerronTwo — block G1 of `lean_stage3/design/floor.md`. 2026-11-23.

`PerronKernel.explicit_formula_perron` with the floor lowered from `16 ≤ x`
to `2 ≤ x`. Every `x`-free helper of `PerronKernel` is reused unchanged; the
lemmas below are copies of the originals with the lines that used the floor
rewritten. `PerronKernel.lean` is untouched.

  one_sub_two_neg_rpow'        0 < δ ≤ 5/2 ⊢ δ/5 ≤ 1 − 2^(−δ)
  inv_log_le_of_two_le         2 ≤ x ⊢ 1/log x ≤ 3/2   (so c ≤ 5/2)
  far_terms_sum_two            2 ≤ x, 2 ≤ T ⊢ far range ≤ 300·x·log²(xT)/T
  near_diagonal_sum_two        2 ≤ x, 1 ≤ T ⊢ near range ≤ 100·x·log²(xT)/T + 4·log x
  kernel_sum_bound_two         2 ≤ x, 2 ≤ T ⊢ ≤ 700·x·log²(xT)/T + 17·log x
  delta_sum_close_two          1 < x ⊢ ‖ψ x − Σ Λ(n)·δ(x/n)‖ ≤ log x
  kernel_diff_summable_two     1 < x, 1 ≤ T
  perron_to_psi_two            2 ≤ x, 2 ≤ T ⊢ ≤ 700·x·log²(xT)/T + 18·log x
  perron_sum_eq_integral_two   1 < x, 1 ≤ T
  explicit_formula_perron_two  2 ≤ x, 2 ≤ T ⊢ ‖ψ x − (2πi)⁻¹∫(−ζ′/ζ)·xˢ/s‖
                                 ≤ 700·x·log²(xT)/T + 18·log x,  c = 1 + 1/log x

Where the floor bit in the originals: `δ = 1/log x ≤ 1` (now `≤ 5/2`),
`e ≤ x·T` (now from `x·T ≥ 4`), `c ≤ 2` (now `c ≤ 5/2`, so the near-diagonal
factor `(x/n)^c ≤ e^(5/4) ≤ 4` replaces `e`), and `1 + log(3x) ≤ 3·log x`
(now `≤ 5·log x`).

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.PerronKernel

namespace PerronTwo

open Complex Topology PerronKernel

/-- Geometric-denominator bound on the wider range: `δ/5 ≤ 1 − 2^(−δ)` for
`0 < δ ≤ 5/2`. Below `1` it is `PerronKernel.one_sub_two_neg_rpow`; above, `2^(−δ) ≤ 1/2`. -/
theorem one_sub_two_neg_rpow' {δ : ℝ} (h0 : 0 < δ) (h1 : δ ≤ 5/2) :
    δ / 5 ≤ 1 - (2:ℝ) ^ (-δ) := by
  rcases le_total δ 1 with h | h
  · exact one_sub_two_neg_rpow h0 h
  · have h2 : (2:ℝ) ^ (-δ) ≤ (2:ℝ) ^ (-1:ℝ) :=
      Real.rpow_le_rpow_of_exponent_le (by norm_num) (by linarith)
    have h3 : (2:ℝ) ^ (-1:ℝ) = 1/2 := by
      rw [Real.rpow_neg_one]
      norm_num
    rw [h3] at h2
    linarith

/-- `1/log x ≤ 3/2` from `x ≥ 2` (`1/log 2 < 3/2`): the abscissa `c = 1 + 1/log x`
sits at most `5/2`. -/
theorem inv_log_le_of_two_le {x : ℝ} (hx : 2 ≤ x) : 1 / Real.log x ≤ 3/2 := by
  have hl2 : (0.6931471803 : ℝ) < Real.log 2 := Real.log_two_gt_d9
  have hlx : Real.log 2 ≤ Real.log x := Real.log_le_log (by norm_num) hx
  have hlx0 : (0:ℝ) < Real.log x := by linarith
  rw [div_le_iff₀ hlx0]
  linarith

/-- **Slice 1b from `x = 2` — the far-terms sum.** The terms with `|log(x/n)| ≥ 1/2`
sum to at most `300·x·log(xT)²/T`, for `x ≥ 2`, `T ≥ 2`. -/
theorem far_terms_sum_two {x T : ℝ} (hx : 2 ≤ x) (hT : 2 ≤ T) :
    (∑' n : ℕ, if 1/2 ≤ |Real.log (x / n)| then
        ArithmeticFunction.vonMangoldt n * (x / n) ^ (1 + 1/Real.log x)
          / (T * |Real.log (x / n)|)
      else 0)
      ≤ 300 * x * Real.log (x * T) ^ 2 / T := by
  have hx0 : (0:ℝ) < x := by linarith
  have hT0 : (0:ℝ) < T := by linarith
  have hlx0 : (0:ℝ) < Real.log x := Real.log_pos (by linarith)
  set δ : ℝ := 1 / Real.log x with hδ
  have hδ0 : 0 < δ := by rw [hδ]; positivity
  have hδ1 : δ ≤ 5/2 := by
    rw [hδ]
    linarith [inv_log_le_of_two_le hx]
  set c : ℝ := 1 + δ with hc
  have hc1 : 1 < c := by rw [hc]; linarith
  have hq : (2:ℝ) ^ (1 - c) = (2:ℝ) ^ (-δ) := by
    rw [hc]
    ring_nf
  have hxc : x ^ c = Real.exp 1 * x := by
    rw [hc, Real.rpow_add hx0, Real.rpow_one, hδ, Real.rpow_def_of_pos hx0,
      mul_one_div, div_self hlx0.ne']
    ring
  -- pointwise majorisation
  have hpt : ∀ n : ℕ, (if 1/2 ≤ |Real.log (x / n)| then
      ArithmeticFunction.vonMangoldt n * (x / n) ^ c / (T * |Real.log (x / n)|) else 0)
      ≤ (2 * Real.exp 1 * x / T) * (ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c)) := by
    intro n
    by_cases h : 1/2 ≤ |Real.log (x / n)|
    · rw [if_pos h]
      rcases Nat.eq_zero_or_pos n with rfl | hn
      · exfalso
        rw [Nat.cast_zero, div_zero, Real.log_zero, abs_zero] at h
        linarith
      · have hn0 : (0:ℝ) < (n:ℝ) := by exact_mod_cast hn
        have hdiv : (x / n) ^ c = x ^ c * (n:ℝ) ^ (-c) := by
          rw [Real.div_rpow hx0.le hn0.le, Real.rpow_neg hn0.le, div_eq_mul_inv]
        have hnum0 : (0:ℝ) ≤ ArithmeticFunction.vonMangoldt n * (x / n) ^ c :=
          mul_nonneg ArithmeticFunction.vonMangoldt_nonneg
            (Real.rpow_nonneg (by positivity) _)
        have hden : T / 2 ≤ T * |Real.log (x / n)| := by
          calc T / 2 = T * (1/2) := by ring
            _ ≤ T * |Real.log (x / n)| := mul_le_mul_of_nonneg_left h hT0.le
        calc ArithmeticFunction.vonMangoldt n * (x / n) ^ c / (T * |Real.log (x / n)|)
            ≤ ArithmeticFunction.vonMangoldt n * (x / n) ^ c / (T / 2) :=
              div_le_div_of_nonneg_left hnum0 (by positivity) hden
          _ = (2 / T) * (ArithmeticFunction.vonMangoldt n * (x / n) ^ c) := by
              field_simp
          _ = (2 * Real.exp 1 * x / T) * (ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c)) := by
              rw [hdiv, hxc]
              ring
    · rw [if_neg h]
      positivity
  have hg : Summable (fun n : ℕ ↦
      (2 * Real.exp 1 * x / T) * (ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c))) :=
    (vonMangoldt_rpow_summable hc1).mul_left _
  have hf : Summable (fun n : ℕ ↦ if 1/2 ≤ |Real.log (x / n)| then
      ArithmeticFunction.vonMangoldt n * (x / n) ^ c / (T * |Real.log (x / n)|) else 0) := by
    apply Summable.of_nonneg_of_le _ hpt hg
    intro n
    by_cases h : 1/2 ≤ |Real.log (x / n)|
    · rw [if_pos h]
      positivity
    · rw [if_neg h]
  have hq1lt : (2:ℝ) ^ (1 - c) < 1 := by
    rw [hq]
    exact Real.rpow_lt_one_of_one_lt_of_neg one_lt_two (by linarith)
  have hinv : (1 - (2:ℝ) ^ (1 - c))⁻¹ ≤ 5 * Real.log x := by
    have h5 := one_sub_two_neg_rpow' hδ0 hδ1
    rw [hq]
    rw [← one_div]
    calc 1 / (1 - (2:ℝ)^(-δ)) ≤ 1 / (δ/5) :=
          one_div_le_one_div_of_le (by positivity) h5
      _ = 5 / δ := by ring
      _ = 5 * Real.log x := by
          rw [hδ]
          field_simp
  calc (∑' n : ℕ, if 1/2 ≤ |Real.log (x / n)| then
        ArithmeticFunction.vonMangoldt n * (x / n) ^ c / (T * |Real.log (x / n)|) else 0)
      ≤ ∑' n : ℕ, (2 * Real.exp 1 * x / T)
          * (ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c)) :=
        hf.tsum_le_tsum hpt hg
    _ = (2 * Real.exp 1 * x / T)
          * ∑' n : ℕ, ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c) := tsum_mul_left
    _ ≤ (2 * Real.exp 1 * x / T) * (2 * (Real.log 4 + 4) / (1 - (2:ℝ)^(1-c))) := by
        apply mul_le_mul_of_nonneg_left (vonMangoldt_rpow_tsum hc1)
        positivity
    _ ≤ (2 * Real.exp 1 * x / T) * (2 * (Real.log 4 + 4) * (5 * Real.log x)) := by
        apply mul_le_mul_of_nonneg_left _ (by positivity)
        rw [div_eq_mul_inv]
        apply mul_le_mul_of_nonneg_left hinv
        positivity
    _ ≤ 300 * x * Real.log (x * T) ^ 2 / T := by
        have hlogx_le : Real.log x ≤ Real.log (x*T) := by
          apply Real.log_le_log hx0
          nlinarith [mul_le_mul_of_nonneg_left hT hx0.le]
        have hlogxT1 : 1 ≤ Real.log (x*T) := by
          have hex : Real.exp 1 ≤ x*T := by
            nlinarith [mul_le_mul_of_nonneg_left hT hx0.le, Real.exp_one_lt_d9]
          calc (1:ℝ) = Real.log (Real.exp 1) := (Real.log_exp 1).symm
            _ ≤ Real.log (x*T) := Real.log_le_log (Real.exp_pos 1) hex
        have hnum : 20 * Real.exp 1 * (Real.log 4 + 4) ≤ 300 := by
          have h1 : Real.exp 1 < 2.7182818286 := Real.exp_one_lt_d9
          have h2 : Real.log 4 = 2 * Real.log 2 := by
            rw [show (4:ℝ) = 2^2 by norm_num, Real.log_pow]
            push_cast
            ring
          have h3 : Real.log 2 < 0.6931471808 := Real.log_two_lt_d9
          nlinarith [mul_nonneg
            (by linarith : (0:ℝ) ≤ 2.7182818286 - Real.exp 1)
            (by nlinarith : (0:ℝ) ≤ 5.3862943616 - (Real.log 4 + 4)),
            Real.exp_pos 1, Real.log_two_gt_d9]
        have hK0 : (0:ℝ) < Real.log 4 + 4 := by positivity
        have hchain : Real.log x ≤ Real.log (x*T) ^ 2 := by nlinarith
        rw [div_mul_eq_mul_div]
        apply div_le_div_of_nonneg_right _ hT0.le
        nlinarith [mul_le_mul_of_nonneg_right hnum (mul_nonneg hx0.le hlx0.le),
          mul_le_mul_of_nonneg_left hchain (by positivity : (0:ℝ) ≤ 300 * x)]

/-- info: 'PerronTwo.far_terms_sum_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms far_terms_sum_two

/-- **Slice 1c from `x = 2` — the near-diagonal sum.** The terms with
`0 < |log(x/n)| < 1/2`, each weighted by `min(1, 1/(T·|log(x/n)|))`, sum to at most
`100·x·log(xT)²/T + 4·log x`, for `x ≥ 2`. -/
theorem near_diagonal_sum_two {x T : ℝ} (hx : 2 ≤ x) (hT : 1 ≤ T) :
    (∑' n : ℕ, if 0 < |Real.log (x / n)| ∧ |Real.log (x / n)| < 1/2 then
        ArithmeticFunction.vonMangoldt n * min 1 (1/(T * |Real.log (x / n)|))
      else 0)
      ≤ 100 * x * Real.log (x * T) ^ 2 / T + 4 * Real.log x := by
  have hx0 : (0:ℝ) < x := by linarith
  have hT0 : (0:ℝ) < T := lt_of_lt_of_le one_pos hT
  have hl2x : Real.log 2 ≤ Real.log x := Real.log_le_log (by norm_num) hx
  have hl2 : (0.6931471803 : ℝ) < Real.log 2 := Real.log_two_gt_d9
  have hlx0 : (0:ℝ) < Real.log x := by linarith
  set f : ℕ → ℝ := fun n ↦ if 0 < |Real.log (x / n)| ∧ |Real.log (x / n)| < 1/2 then
      ArithmeticFunction.vonMangoldt n * min 1 (1/(T * |Real.log (x / n)|)) else 0 with hfd
  have hfnn : ∀ n, 0 ≤ f n := by
    intro n
    rw [hfd]
    dsimp only
    by_cases h : 0 < |Real.log (x / n)| ∧ |Real.log (x / n)| < 1/2
    · rw [if_pos h]
      exact mul_nonneg ArithmeticFunction.vonMangoldt_nonneg
        (le_min zero_le_one (by positivity))
    · rw [if_neg h]
  set N : ℕ := ⌈2*x⌉₊ with hNd
  set m : ℕ := ⌊x⌋₊ with hmd
  have hmx : (m:ℝ) ≤ x := Nat.floor_le hx0.le
  have hxm1 : x < (m:ℝ) + 1 := Nat.lt_floor_add_one x
  have hNx : 2*x ≤ (N:ℝ) := Nat.le_ceil _
  have hmN : m + 2 ≤ N := by
    have h2 : ((m + 2 : ℕ) : ℝ) ≤ (N:ℝ) := by push_cast; linarith
    exact_mod_cast h2
  -- the pointwise majorant, valid on all of ℕ
  set g : ℕ → ℝ := fun n ↦ min 1 (4*x/(T * |x - (n:ℝ)|)) with hgd
  have hgnn : ∀ n, 0 ≤ g n := fun n ↦ le_min zero_le_one (by positivity)
  have hg1 : ∀ n, g n ≤ 1 := fun n ↦ min_le_left _ _
  have hexp2 : Real.exp (1/2) ≤ 2 := by
    have h := Real.exp_le_exp.mpr
      (show (1:ℝ)/2 ≤ Real.log 2 by linarith [Real.log_two_gt_d9])
    rwa [Real.exp_log two_pos] at h
  have hmaj : ∀ n : ℕ, f n ≤ 2 * Real.log x * g n := by
    intro n
    rw [hfd]
    dsimp only
    by_cases h : 0 < |Real.log (x / n)| ∧ |Real.log (x / n)| < 1/2
    · rw [if_pos h]
      obtain ⟨hpos, hlt⟩ := h
      have hn0 : (0:ℝ) < (n:ℝ) := by
        rcases Nat.eq_zero_or_pos n with rfl | hn
        · rw [Nat.cast_zero, div_zero, Real.log_zero, abs_zero] at hpos
          linarith
        · exact_mod_cast hn
      have ht0 : (0:ℝ) < x/n := by positivity
      have hxn : x ≠ (n:ℝ) := by
        intro he
        rw [he, div_self hn0.ne', Real.log_one, abs_zero] at hpos
        linarith
      obtain ⟨hL1, hL2⟩ := abs_lt.mp hlt
      have htlo : 1/2 ≤ x/n := by
        have h3 : Real.exp (-(1/2)) ≤ Real.exp (Real.log (x/n)) :=
          Real.exp_le_exp.mpr (by linarith)
        rw [Real.exp_log ht0] at h3
        have hEinv : (0:ℝ) ≤ (Real.exp ((1:ℝ)/2))⁻¹ := by positivity
        have h4 : (1/2:ℝ) ≤ Real.exp (-(1/2)) := by
          rw [Real.exp_neg]
          nlinarith [mul_inv_cancel₀ (Real.exp_pos ((1:ℝ)/2)).ne', hexp2]
        linarith
      have hthi : x/n ≤ 2 := by
        have h5 : Real.exp (Real.log (x/n)) ≤ Real.exp (1/2) :=
          Real.exp_le_exp.mpr hL2.le
        rw [Real.exp_log ht0] at h5
        exact h5.trans hexp2
      have hn2x : (n:ℝ) ≤ 2*x := by
        nlinarith [mul_le_mul_of_nonneg_right htlo hn0.le, div_mul_cancel₀ x hn0.ne']
      have hdpos : (0:ℝ) < |x - (n:ℝ)| := abs_pos.mpr (sub_ne_zero.mpr hxn)
      -- |log(x/n)| ≥ |x−n|/(4x)
      have hlog_ge : |x - (n:ℝ)| / (4*x) ≤ |Real.log (x/n)| := by
        have h6 := abs_sub_one_le_two_abs_log htlo hthi
        have h7 : |x/(n:ℝ) - 1| = |x - n| / n := by
          rw [show x/(n:ℝ) - 1 = (x - n)/n by field_simp, abs_div, abs_of_pos hn0]
        rw [h7] at h6
        calc |x - (n:ℝ)| / (4*x) ≤ |x - n| / (2*n) := by
              apply div_le_div_of_nonneg_left (abs_nonneg _) (by positivity)
              linarith
          _ = |x - n| / n / 2 := by ring
          _ ≤ |Real.log (x/n)| := h6
      -- min comparison
      have hmin : min 1 (1/(T * |Real.log (x / n)|)) ≤ g n := by
        rw [hgd]
        dsimp only
        apply min_le_min le_rfl
        have h8 : T * (|x - n| / (4*x)) ≤ T * |Real.log (x/n)| :=
          mul_le_mul_of_nonneg_left hlog_ge hT0.le
        calc 1/(T * |Real.log (x / n)|) ≤ 1/(T * (|x - n| / (4*x))) :=
              one_div_le_one_div_of_le (by positivity) h8
          _ = 4*x/(T * |x - n|) := by
              field_simp
      -- Λ comparison
      have hΛ : ArithmeticFunction.vonMangoldt n ≤ 2 * Real.log x := by
        calc ArithmeticFunction.vonMangoldt n ≤ Real.log n :=
              ArithmeticFunction.vonMangoldt_le_log
          _ ≤ Real.log (2*x) := Real.log_le_log hn0 hn2x
          _ = Real.log 2 + Real.log x := Real.log_mul two_ne_zero hx0.ne'
          _ ≤ 2 * Real.log x := by linarith [Real.log_two_lt_d9]
      exact mul_le_mul hΛ hmin (le_min zero_le_one (by positivity)) (by positivity)
    · rw [if_neg h]
      exact mul_nonneg (by positivity) (hgnn n)
  -- the harmonic pieces
  have hharm : ∀ K : ℕ, (K:ℝ) ≤ 3*x →
      ∑ j ∈ Finset.range K, 4*x/(T*(j+1)) ≤ (4*x/T) * (5 * Real.log x) := by
    intro K hK
    have h1 : ∑ j ∈ Finset.range K, 4*x/(T*(j+1))
        = (4*x/T) * ∑ j ∈ Finset.range K, (1:ℝ)/(j+1) := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _
      have hj : ((j:ℝ)+1) ≠ 0 := by positivity
      field_simp
    rw [h1]
    apply mul_le_mul_of_nonneg_left _ (by positivity)
    have h2 : ∑ j ∈ Finset.range K, (1:ℝ)/(j+1) = ((harmonic K : ℚ) : ℝ) := by
      rw [harmonic]
      push_cast
      apply Finset.sum_congr rfl
      intro j _
      rw [one_div]
    rw [h2]
    have h3 := harmonic_le_one_add_log K
    have h4 : Real.log K ≤ Real.log (3*x) := by
      rcases Nat.eq_zero_or_pos K with rfl | hK0
      · simp
        exact Real.log_nonneg (by linarith)
      · exact Real.log_le_log (by exact_mod_cast hK0) hK
    have h5 : Real.log (3*x) ≤ 2 * Real.log 2 + Real.log x := by
      have h6 : Real.log 3 ≤ 2 * Real.log 2 := by
        have h7 : Real.log 3 ≤ Real.log 4 := Real.log_le_log (by norm_num) (by norm_num)
        have h8 : Real.log 4 = 2 * Real.log 2 := by
          rw [show (4:ℝ) = 2^2 by norm_num, Real.log_pow]
          push_cast
          ring
        linarith
      rw [Real.log_mul (by norm_num) (by linarith)]
      linarith
    linarith
  -- lower band: n ∈ range m
  have hlower : ∑ n ∈ Finset.range m, g n ≤ (4*x/T) * (5 * Real.log x) := by
    have hstep : ∀ n ∈ Finset.range m, g n ≤ 4*x/(T*((m - 1 - n : ℕ)+1)) := by
      intro n hn
      rw [Finset.mem_range] at hn
      have hcast : ((m - 1 - n : ℕ):ℝ) + 1 = (m:ℝ) - n := by
        have h1 : n ≤ m - 1 := by omega
        have h2 : (1:ℕ) ≤ m := by omega
        push_cast [Nat.cast_sub h1, Nat.cast_sub h2]
        ring
      rw [hgd]
      dsimp only
      calc min 1 (4*x/(T * |x - (n:ℝ)|)) ≤ 4*x/(T * |x - (n:ℝ)|) := min_le_right _ _
        _ ≤ 4*x/(T*((m - 1 - n : ℕ)+1)) := by
            rw [hcast]
            apply div_le_div_of_nonneg_left (by positivity) (by
              have : (0:ℝ) < (m:ℝ) - n := by
                have : (n:ℝ) < m := by exact_mod_cast hn
                linarith
              positivity)
            apply mul_le_mul_of_nonneg_left _ hT0.le
            rw [abs_of_nonneg (by
              have : (n:ℝ) < m := by exact_mod_cast hn
              linarith : (0:ℝ) ≤ x - n)]
            have : (n:ℝ) < m := by exact_mod_cast hn
            linarith
    calc ∑ n ∈ Finset.range m, g n
        ≤ ∑ n ∈ Finset.range m, 4*x/(T*((m - 1 - n : ℕ)+1)) := Finset.sum_le_sum hstep
      _ = ∑ j ∈ Finset.range m, 4*x/(T*((j:ℝ)+1)) := by
          rw [← Finset.sum_range_reflect (fun j ↦ 4*x/(T*((j:ℝ)+1))) m]
      _ ≤ (4*x/T) * (5 * Real.log x) := hharm m (by linarith)
  -- upper band: n ∈ Ico m N
  have hupper : ∑ n ∈ Finset.Ico m N, g n
      ≤ 2 + (4*x/T) * (5 * Real.log x) := by
    have hmN' : m ≤ N := by omega
    rw [Finset.sum_Ico_eq_sum_range]
    have hK2 : N - m = (N - m - 2) + 1 + 1 := by omega
    rw [hK2, Finset.sum_range_succ', Finset.sum_range_succ']
    have hstep : ∀ i ∈ Finset.range (N - m - 2), g (m + (i + 1 + 1))
        ≤ 4*x/(T*((i:ℝ)+1)) := by
      intro i _
      rw [hgd]
      dsimp only
      calc min 1 (4*x/(T * |x - ((m + (i+1+1) : ℕ):ℝ)|))
          ≤ 4*x/(T * |x - ((m + (i+1+1) : ℕ):ℝ)|) := min_le_right _ _
        _ ≤ 4*x/(T*((i:ℝ)+1)) := by
            apply div_le_div_of_nonneg_left (by positivity) (by positivity)
            apply mul_le_mul_of_nonneg_left _ hT0.le
            have h1 : ((m + (i+1+1) : ℕ):ℝ) = (m:ℝ) + i + 2 := by push_cast; ring
            rw [h1, abs_of_nonpos (by linarith : x - ((m:ℝ) + i + 2) ≤ 0)]
            linarith
    calc (∑ i ∈ Finset.range (N - m - 2), g (m + (i + 1 + 1)))
          + g (m + (0 + 1)) + g (m + 0)
        ≤ (∑ i ∈ Finset.range (N - m - 2), 4*x/(T*((i:ℝ)+1))) + 1 + 1 := by
          have := Finset.sum_le_sum hstep
          have g1 := hg1 (m + (0+1))
          have g2 := hg1 (m + 0)
          linarith
      _ ≤ (4*x/T) * (5 * Real.log x) + 2 := by
          have := hharm (N - m - 2) (by
            have : ((N - m - 2 : ℕ):ℝ) ≤ (N:ℝ) := by
              have : (N - m - 2 : ℕ) ≤ N := by omega
              exact_mod_cast this
            have hN3 : (N:ℝ) ≤ 3*x := by
              have := Nat.ceil_lt_add_one (by positivity : (0:ℝ) ≤ 2*x)
              linarith
            linarith)
          linarith
      _ = 2 + (4*x/T) * (5 * Real.log x) := by ring
  -- assemble the finset bound
  apply Real.tsum_le_of_sum_le hfnn
  intro s
  have hvanish : ∀ n : ℕ, n ∉ Finset.range N → f n = 0 := by
    intro n hn
    rw [Finset.mem_range, not_lt] at hn
    rw [hfd]
    dsimp only
    rw [if_neg]
    rintro ⟨hpos, hlt⟩
    have hnN : (2*x:ℝ) ≤ n := by
      have h1 : (N:ℝ) ≤ n := by exact_mod_cast hn
      linarith
    have hn0 : (0:ℝ) < n := by linarith
    have hxn2 : x / n ≤ 1/2 := by
      have h2 : x/(n:ℝ) ≤ x/(2*x) := div_le_div_of_nonneg_left hx0.le (by positivity) hnN
      have h3 : x/(2*x) = 1/2 := by field_simp
      rw [h3] at h2
      exact h2
    have h4 : Real.log (x/n) ≤ Real.log (1/2) :=
      Real.log_le_log (by positivity) hxn2
    have h5 : Real.log ((1:ℝ)/2) = -Real.log 2 := by
      rw [one_div, Real.log_inv]
    have h6 : (1/2:ℝ) ≤ |Real.log (x/n)| := by
      have h7 := neg_le_abs (Real.log (x/n))
      have h8 : (1/2:ℝ) ≤ -Real.log (x/n) := by
        rw [h5] at h4
        linarith [Real.log_two_gt_d9]
      linarith
    linarith
  have hsplit : ∑ n ∈ s, f n ≤ ∑ n ∈ Finset.range N, f n := by
    classical
    calc ∑ n ∈ s, f n
        = ∑ n ∈ s.filter (· ∈ Finset.range N), f n
          + ∑ n ∈ s.filter (fun n ↦ ¬ (n ∈ Finset.range N)), f n :=
          (Finset.sum_filter_add_sum_filter_not s _ f).symm
      _ = ∑ n ∈ s.filter (· ∈ Finset.range N), f n := by
          have hz : ∑ n ∈ s.filter (fun n ↦ ¬ (n ∈ Finset.range N)), f n = 0 := by
            apply Finset.sum_eq_zero
            intro n hn
            exact hvanish n (Finset.mem_filter.mp hn).2
          rw [hz, add_zero]
      _ ≤ ∑ n ∈ Finset.range N, f n := by
          apply Finset.sum_le_sum_of_subset_of_nonneg
          · intro n hn
            exact (Finset.mem_filter.mp hn).2
          · exact fun n _ _ ↦ hfnn n
  refine hsplit.trans ?_
  calc ∑ n ∈ Finset.range N, f n
      ≤ ∑ n ∈ Finset.range N, 2 * Real.log x * g n :=
        Finset.sum_le_sum (fun n _ ↦ hmaj n)
    _ = 2 * Real.log x * ∑ n ∈ Finset.range N, g n := by rw [Finset.mul_sum]
    _ = 2 * Real.log x * (∑ n ∈ Finset.range m, g n + ∑ n ∈ Finset.Ico m N, g n) := by
        congr 1
        rw [Finset.range_eq_Ico, Finset.range_eq_Ico,
          Finset.sum_Ico_consecutive _ (Nat.zero_le m) (by omega : m ≤ N)]
    _ ≤ 2 * Real.log x * ((4*x/T) * (5 * Real.log x)
          + (2 + (4*x/T) * (5 * Real.log x))) := by
        apply mul_le_mul_of_nonneg_left _ (by positivity)
        linarith [hlower, hupper]
    _ ≤ 100 * x * Real.log (x * T) ^ 2 / T + 4 * Real.log x := by
        have hlog_le : Real.log x ≤ Real.log (x*T) := by
          apply Real.log_le_log hx0
          nlinarith [mul_le_mul_of_nonneg_left hT hx0.le]
        have hsq : Real.log x ^ 2 ≤ Real.log (x*T) ^ 2 := by nlinarith
        have hstep2 : 2 * Real.log x * ((4*x/T) * (5 * Real.log x)
              + (2 + (4*x/T) * (5 * Real.log x)))
            = 80 * x * Real.log x ^ 2 / T + 4 * Real.log x := by
          field_simp
          try ring
        rw [hstep2]
        have h80 : 80 * x * Real.log x ^ 2 / T ≤ 100 * x * Real.log (x*T) ^ 2 / T := by
          apply div_le_div_of_nonneg_right _ hT0.le
          nlinarith [hsq, sq_nonneg (Real.log x)]
        linarith

/-- info: 'PerronTwo.near_diagonal_sum_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms near_diagonal_sum_two

/-- **Slice 1's analytic composition from `x = 2`.** The summed kernel error
`‖Σ Λ(n)·(perronI(x/n) − δ(x/n))‖` is at most `700·x·log(xT)²/T + 17·log x`, for
`x ≥ 2`, `T ≥ 2`. The near-diagonal factor is `(x/n)^c ≤ e^(5/4) ≤ 4`. -/
theorem kernel_sum_bound_two {x T : ℝ} (hx : 2 ≤ x) (hT : 2 ≤ T) :
    ‖(∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ)
          * (perronI (x/n) (1 + 1/Real.log x) T - perronδ (x/n)))‖
      ≤ 700 * x * Real.log (x * T) ^ 2 / T + 17 * Real.log x := by
  have hx0 : (0:ℝ) < x := by linarith
  have hT1 : (1:ℝ) ≤ T := by linarith
  have hT0 : (0:ℝ) < T := by linarith
  have hlx0 : (0:ℝ) < Real.log x := Real.log_pos (by linarith)
  set c : ℝ := 1 + 1/Real.log x with hcd
  have hc0 : (0:ℝ) < c := by rw [hcd]; positivity
  have hc2 : c ≤ 5/2 := by
    rw [hcd]
    linarith [inv_log_le_of_two_le hx]
  have hexp54 : Real.exp (5/4) ≤ 4 := by
    have h2 : Real.log 4 = 2 * Real.log 2 := by
      rw [show (4:ℝ) = 2^2 by norm_num, Real.log_pow]
      push_cast
      ring
    have h3 : (5/4:ℝ) ≤ Real.log 4 := by
      rw [h2]
      linarith [Real.log_two_gt_d9]
    calc Real.exp (5/4) ≤ Real.exp (Real.log 4) := Real.exp_le_exp.mpr h3
      _ = 4 := Real.exp_log (by norm_num)
  set far : ℕ → ℝ := fun n ↦ if 1/2 ≤ |Real.log (x / n)| then
      ArithmeticFunction.vonMangoldt n * (x / n) ^ c / (T * |Real.log (x / n)|)
    else 0 with hfard
  set near : ℕ → ℝ := fun n ↦ if 0 < |Real.log (x / n)| ∧ |Real.log (x / n)| < 1/2 then
      ArithmeticFunction.vonMangoldt n * min 1 (1/(T * |Real.log (x / n)|))
    else 0 with hneard
  set diagI : ℕ → ℝ := fun n ↦ if n = ⌊x⌋₊ ∧ ((⌊x⌋₊ : ℕ) : ℝ) = x then Real.log x
    else 0 with hdiagd
  have hfarnn : ∀ n, 0 ≤ far n := by
    intro n
    rw [hfard]
    dsimp only
    split
    · positivity
    · exact le_rfl
  have hnearnn : ∀ n, 0 ≤ near n := by
    intro n
    rw [hneard]
    dsimp only
    split
    · exact mul_nonneg ArithmeticFunction.vonMangoldt_nonneg
        (le_min zero_le_one (by positivity))
    · exact le_rfl
  have hdiagnn : ∀ n, 0 ≤ diagI n := by
    intro n
    rw [hdiagd]
    dsimp only
    split
    · positivity
    · exact le_rfl
  have hpt : ∀ n : ℕ, ‖(ArithmeticFunction.vonMangoldt n : ℂ)
        * (perronI (x/n) c T - perronδ (x/n))‖
      ≤ far n + 4 * near n + diagI n := by
    intro n
    have hΛnn := ArithmeticFunction.vonMangoldt_nonneg (n := n)
    have hnorm : ‖(ArithmeticFunction.vonMangoldt n : ℂ)
          * (perronI (x/n) c T - perronδ (x/n))‖
        = ArithmeticFunction.vonMangoldt n * ‖perronI (x/n) c T - perronδ (x/n)‖ := by
      rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hΛnn]
    rw [hnorm]
    rcases Nat.eq_zero_or_pos n with rfl | hn
    · simp only [ArithmeticFunction.map_zero, zero_mul]
      have h1 := hfarnn 0
      have h2 := hnearnn 0
      have h3 := hdiagnn 0
      nlinarith [Real.exp_pos 1, mul_nonneg (Real.exp_pos 1).le h2]
    · have hn0 : (0:ℝ) < (n:ℝ) := by exact_mod_cast hn
      have hyx : (0:ℝ) < x/n := by positivity
      by_cases hne : x/(n:ℝ) = 1
      · have hnx : (n:ℝ) = x := by
          field_simp at hne
          linarith [hne]
        have hδ1 : perronδ (x/n) = 0 := by
          rw [perronδ, if_neg]
          rw [hne]
          norm_num
        have hbound : ‖perronI (x/n) c T - perronδ (x/n)‖ ≤ 1/2 := by
          rw [hδ1, sub_zero, hne]
          exact perronI_one_norm hc0
        have hfl : n = ⌊x⌋₊ := by
          rw [← hnx, Nat.floor_natCast]
        have hdiag_val : diagI n = Real.log x := by
          rw [hdiagd]
          dsimp only
          rw [if_pos ⟨hfl, by rw [← hfl]; exact hnx⟩]
        have hΛlog : ArithmeticFunction.vonMangoldt n ≤ Real.log x := by
          calc ArithmeticFunction.vonMangoldt n ≤ Real.log n :=
                ArithmeticFunction.vonMangoldt_le_log
            _ = Real.log x := by rw [hnx]
        calc ArithmeticFunction.vonMangoldt n * ‖perronI (x/n) c T - perronδ (x/n)‖
            ≤ Real.log x * (1/2) := by
              apply mul_le_mul hΛlog hbound (norm_nonneg _) (by positivity)
          _ ≤ far n + 4 * near n + diagI n := by
              rw [hdiag_val]
              have h1 := hfarnn n
              have h2 := hnearnn n
              nlinarith [Real.exp_pos 1, hlx0, mul_nonneg (Real.exp_pos 1).le h2]
      · have h1a := perron_kernel_truncated hyx hne hc0 hT1
        have hlogne : Real.log (x/n) ≠ 0 := by
          intro h
          apply hne
          have h7 := Real.exp_log hyx
          rw [h, Real.exp_zero] at h7
          linarith [h7]
        have habs0 : 0 < |Real.log (x/n)| := abs_pos.mpr hlogne
        by_cases hfar : 1/2 ≤ |Real.log (x / n)|
        · have hfar_val : far n = ArithmeticFunction.vonMangoldt n
              * (x / n) ^ c / (T * |Real.log (x / n)|) := by
            rw [hfard]
            dsimp only
            rw [if_pos hfar]
          have hminle : min 1 (1/(T * |Real.log (x/n)|)) ≤ 1/(T * |Real.log (x/n)|) :=
            min_le_right _ _
          calc ArithmeticFunction.vonMangoldt n * ‖perronI (x/n) c T - perronδ (x/n)‖
              ≤ ArithmeticFunction.vonMangoldt n
                  * ((x/n) ^ c * min 1 (1/(T * |Real.log (x/n)|))) :=
                mul_le_mul_of_nonneg_left h1a hΛnn
            _ ≤ ArithmeticFunction.vonMangoldt n
                  * ((x/n) ^ c * (1/(T * |Real.log (x/n)|))) := by
                apply mul_le_mul_of_nonneg_left _ hΛnn
                exact mul_le_mul_of_nonneg_left hminle
                  (Real.rpow_nonneg hyx.le _)
            _ = far n := by
                rw [hfar_val]
                field_simp
            _ ≤ far n + 4 * near n + diagI n := by
                have h2 := hnearnn n
                have h3 := hdiagnn n
                nlinarith [Real.exp_pos 1, mul_nonneg (Real.exp_pos 1).le h2]
        · rw [not_le] at hfar
          have hnear_val : near n = ArithmeticFunction.vonMangoldt n
              * min 1 (1/(T * |Real.log (x / n)|)) := by
            rw [hneard]
            dsimp only
            rw [if_pos ⟨habs0, hfar⟩]
          have hxc_e : (x/n) ^ c ≤ 4 := by
            rw [Real.rpow_def_of_pos hyx]
            refine le_trans (Real.exp_le_exp.mpr ?_) hexp54
            calc Real.log (x/n) * c ≤ |Real.log (x/n)| * c := by
                  apply mul_le_mul_of_nonneg_right (le_abs_self _) hc0.le
              _ ≤ (1/2) * (5/2) := by
                  apply mul_le_mul hfar.le hc2 hc0.le (by norm_num)
              _ = 5/4 := by norm_num
          calc ArithmeticFunction.vonMangoldt n * ‖perronI (x/n) c T - perronδ (x/n)‖
              ≤ ArithmeticFunction.vonMangoldt n
                  * ((x/n) ^ c * min 1 (1/(T * |Real.log (x/n)|))) :=
                mul_le_mul_of_nonneg_left h1a hΛnn
            _ ≤ ArithmeticFunction.vonMangoldt n
                  * (4 * min 1 (1/(T * |Real.log (x/n)|))) := by
                apply mul_le_mul_of_nonneg_left _ hΛnn
                apply mul_le_mul_of_nonneg_right hxc_e
                exact le_min zero_le_one (by positivity)
            _ = 4 * near n := by
                rw [hnear_val]
                ring
            _ ≤ far n + 4 * near n + diagI n := by
                have h1 := hfarnn n
                have h3 := hdiagnn n
                linarith
  have hfar_sum : Summable far := by
    have hc1 : 1 < c := by
      rw [hcd]
      have h9 : 0 < 1/Real.log x := by positivity
      linarith
    apply Summable.of_nonneg_of_le hfarnn _
      ((vonMangoldt_rpow_summable hc1).mul_left (2 * Real.exp 1 * x / T))
    intro n
    rw [hfard]
    dsimp only
    by_cases h : 1/2 ≤ |Real.log (x / n)|
    · rw [if_pos h]
      rcases Nat.eq_zero_or_pos n with rfl | hn
      · simp [ArithmeticFunction.map_zero]
        try positivity
      · have hn0 : (0:ℝ) < (n:ℝ) := by exact_mod_cast hn
        have hdiv : (x / n) ^ c = x ^ c * (n:ℝ) ^ (-c) := by
          rw [Real.div_rpow hx0.le hn0.le, Real.rpow_neg hn0.le, div_eq_mul_inv]
        have hxc : x ^ c = Real.exp 1 * x := by
          rw [hcd, Real.rpow_add hx0, Real.rpow_one, Real.rpow_def_of_pos hx0,
            mul_one_div, div_self hlx0.ne']
          ring
        have hden : T / 2 ≤ T * |Real.log (x / n)| := by
          calc T / 2 = T * (1/2) := by ring
            _ ≤ T * |Real.log (x / n)| := mul_le_mul_of_nonneg_left h hT0.le
        calc ArithmeticFunction.vonMangoldt n * (x / n) ^ c / (T * |Real.log (x / n)|)
            ≤ ArithmeticFunction.vonMangoldt n * (x / n) ^ c / (T / 2) := by
              apply div_le_div_of_nonneg_left _ (by positivity) hden
              exact mul_nonneg ArithmeticFunction.vonMangoldt_nonneg
                (Real.rpow_nonneg (by positivity) _)
          _ = (2 * Real.exp 1 * x / T)
                * (ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c)) := by
              rw [hdiv, hxc]
              field_simp
              try ring
    · rw [if_neg h]
      positivity
  have hN2 : ∀ n : ℕ, n ∉ Finset.range (⌈2*x⌉₊ + 1) → near n = 0 := by
    intro n hn
    rw [Finset.mem_range, not_lt] at hn
    rw [hneard]
    dsimp only
    rw [if_neg]
    rintro ⟨hpos, hlt⟩
    have hnN : (2*x:ℝ) ≤ n := by
      have h1 : ((⌈2*x⌉₊ + 1 : ℕ):ℝ) ≤ n := by exact_mod_cast hn
      have h2 : (2*x:ℝ) ≤ ⌈2*x⌉₊ := Nat.le_ceil _
      push_cast at h1
      linarith
    have hn0 : (0:ℝ) < n := by linarith
    have hxn2 : x / n ≤ 1/2 := by
      have h2 : x/(n:ℝ) ≤ x/(2*x) := div_le_div_of_nonneg_left hx0.le (by positivity) hnN
      have h3 : x/(2*x) = 1/2 := by field_simp
      rw [h3] at h2
      exact h2
    have h4 : Real.log (x/n) ≤ Real.log (1/2) :=
      Real.log_le_log (by positivity) hxn2
    have h5 : Real.log ((1:ℝ)/2) = -Real.log 2 := by
      rw [one_div, Real.log_inv]
    have h6 : (1/2:ℝ) ≤ |Real.log (x/n)| := by
      have h7 := neg_le_abs (Real.log (x/n))
      rw [h5] at h4
      linarith [Real.log_two_gt_d9]
    linarith
  have hnear_sum : Summable near := summable_of_ne_finset_zero hN2
  have hdiag_sum : Summable diagI := by
    apply summable_of_ne_finset_zero (s := {⌊x⌋₊})
    intro n hn
    rw [Finset.mem_singleton] at hn
    rw [hdiagd]
    dsimp only
    rw [if_neg]
    rintro ⟨h1, _⟩
    exact hn h1
  have hmaj_sum : Summable (fun n ↦ far n + 4 * near n + diagI n) :=
    ((hfar_sum.add (hnear_sum.mul_left _)).add hdiag_sum)
  have hnorm_sum : Summable (fun n : ℕ ↦ ‖(ArithmeticFunction.vonMangoldt n : ℂ)
      * (perronI (x/n) c T - perronδ (x/n))‖) :=
    Summable.of_nonneg_of_le (fun n ↦ norm_nonneg _) hpt hmaj_sum
  calc ‖(∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ)
          * (perronI (x/n) c T - perronδ (x/n)))‖
      ≤ ∑' n : ℕ, ‖(ArithmeticFunction.vonMangoldt n : ℂ)
          * (perronI (x/n) c T - perronδ (x/n))‖ :=
        norm_tsum_le_tsum_norm hnorm_sum
    _ ≤ ∑' n : ℕ, (far n + 4 * near n + diagI n) :=
        hnorm_sum.tsum_le_tsum hpt hmaj_sum
    _ = ((∑' n, far n) + ∑' n, 4 * near n) + ∑' n, diagI n := by
        rw [(hfar_sum.add (hnear_sum.mul_left _)).tsum_add hdiag_sum,
          hfar_sum.tsum_add (hnear_sum.mul_left _)]
    _ ≤ (300 * x * Real.log (x*T)^2 / T)
          + 4 * (100 * x * Real.log (x*T)^2 / T + 4 * Real.log x)
          + Real.log x := by
        have h1 := far_terms_sum_two hx hT
        have h2 := near_diagonal_sum_two hx hT1
        have h3 : (∑' n, diagI n) ≤ Real.log x := by
          rw [tsum_eq_single ⌊x⌋₊ (by
            intro n hn
            rw [hdiagd]
            dsimp only
            rw [if_neg]
            rintro ⟨h4, _⟩
            exact hn h4)]
          rw [hdiagd]
          dsimp only
          split
          · exact le_rfl
          · linarith
        have h5 : (∑' n, 4 * near n)
            = 4 * ∑' n, near n := tsum_mul_left
        have h6 : (∑' n, near n) ≤ 100 * x * Real.log (x*T)^2 / T + 4 * Real.log x := h2
        rw [h5]
        have h8 := mul_le_mul_of_nonneg_left h6 (by norm_num : (0:ℝ) ≤ 4)
        linarith [h1, h3]
    _ = 700 * x * Real.log (x * T) ^ 2 / T + 17 * Real.log x := by ring

/-- info: 'PerronTwo.kernel_sum_bound_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms kernel_sum_bound_two

/-- The δ-side of the composition from `x > 1`: the indicator sum is `ψ` up to
one von Mangoldt value at the possible integer point. -/
theorem delta_sum_close_two {x : ℝ} (hx : 1 < x) :
    ‖(Chebyshev.psi x : ℂ) - ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ)
        * perronδ (x / n)‖ ≤ Real.log x := by
  have hx0 : (0:ℝ) < x := by linarith
  have hlx0 : (0:ℝ) < Real.log x := Real.log_pos hx
  set F : ℕ → ℝ := fun n ↦ if 0 < n ∧ (n:ℝ) < x then ArithmeticFunction.vonMangoldt n
    else 0 with hFd
  have hterm : ∀ n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronδ (x/n)
      = ((F n : ℝ) : ℂ) := by
    intro n
    rw [hFd]
    dsimp only
    rcases Nat.eq_zero_or_pos n with rfl | hn
    · simp [perronδ, ArithmeticFunction.map_zero]
    · have hn0 : (0:ℝ) < (n:ℝ) := by exact_mod_cast hn
      rw [perronδ]
      by_cases h : (n:ℝ) < x
      · rw [if_pos ((one_lt_div hn0).mpr h), if_pos ⟨hn, h⟩, mul_one]
      · rw [if_neg (fun hcon ↦ h ((one_lt_div hn0).mp hcon)),
          if_neg (fun hcon ↦ h hcon.2), mul_zero]
        norm_num
  have hvan : ∀ n : ℕ, n ∉ Finset.range ⌈x⌉₊ → ((F n : ℝ) : ℂ) = 0 := by
    intro n hn
    rw [Finset.mem_range, not_lt] at hn
    rw [hFd]
    dsimp only
    rw [if_neg]
    · norm_num
    · rintro ⟨_, h2⟩
      have h3 : x ≤ ⌈x⌉₊ := Nat.le_ceil x
      have h4 : ((⌈x⌉₊ : ℕ) : ℝ) ≤ n := by exact_mod_cast hn
      linarith
  have htsum : (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronδ (x/n))
      = ((∑ n ∈ Finset.range ⌈x⌉₊, F n : ℝ) : ℂ) := by
    calc (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronδ (x/n))
        = ∑' n : ℕ, ((F n : ℝ) : ℂ) := by
          apply tsum_congr
          exact hterm
      _ = ∑ n ∈ Finset.range ⌈x⌉₊, ((F n : ℝ) : ℂ) := tsum_eq_sum hvan
      _ = ((∑ n ∈ Finset.range ⌈x⌉₊, F n : ℝ) : ℂ) := by
          push_cast
          rfl
  rw [htsum]
  rw [show (Chebyshev.psi x : ℂ) - ((∑ n ∈ Finset.range ⌈x⌉₊, F n : ℝ) : ℂ)
      = (((Chebyshev.psi x - ∑ n ∈ Finset.range ⌈x⌉₊, F n : ℝ)) : ℂ) by push_cast; ring]
  rw [Complex.norm_real, Real.norm_eq_abs]
  -- real comparison
  have hFsum : ∑ n ∈ Finset.range ⌈x⌉₊, F n
      = ∑ n ∈ (Finset.range ⌈x⌉₊).filter (fun n : ℕ ↦ 0 < n ∧ (n:ℝ) < x),
          ArithmeticFunction.vonMangoldt n := by
    rw [Finset.sum_filter]
  have hψ : Chebyshev.psi x
      = ∑ n ∈ Finset.Ioc 0 ⌊x⌋₊, ArithmeticFunction.vonMangoldt n := by
    rw [Chebyshev.psi]
  have hsub : (Finset.range ⌈x⌉₊).filter (fun n : ℕ ↦ 0 < n ∧ (n:ℝ) < x)
      ⊆ Finset.Ioc 0 ⌊x⌋₊ := by
    intro n hn
    rw [Finset.mem_filter] at hn
    obtain ⟨_, hn1, hn2⟩ := hn
    rw [Finset.mem_Ioc]
    exact ⟨hn1, Nat.le_floor hn2.le⟩
  have hdiff_sub : Finset.Ioc 0 ⌊x⌋₊
        \ (Finset.range ⌈x⌉₊).filter (fun n : ℕ ↦ 0 < n ∧ (n:ℝ) < x)
      ⊆ {⌊x⌋₊} := by
    intro n hn
    rw [Finset.mem_sdiff, Finset.mem_Ioc, Finset.mem_filter] at hn
    obtain ⟨⟨hn1, hn2⟩, hn3⟩ := hn
    rw [Finset.mem_singleton]
    by_contra hne
    apply hn3
    have hnlt : (n:ℝ) < x := by
      have h4 : (n:ℝ) ≤ ⌊x⌋₊ := by exact_mod_cast hn2
      have h5 : ((⌊x⌋₊:ℕ):ℝ) ≤ x := Nat.floor_le hx0.le
      rcases lt_or_eq_of_le (lt_of_le_of_ne (hn2 : n ≤ ⌊x⌋₊)
        hne : n < ⌊x⌋₊).le with h6 | h6
      · have : (n:ℝ) < ⌊x⌋₊ := by exact_mod_cast lt_of_le_of_ne hn2 hne
        linarith
      · have : (n:ℝ) < ⌊x⌋₊ := by exact_mod_cast lt_of_le_of_ne hn2 hne
        linarith
    constructor
    · rw [Finset.mem_range]
      have h7 : x ≤ ⌈x⌉₊ := Nat.le_ceil x
      have h8 : (n:ℝ) < ⌈x⌉₊ := by linarith
      exact_mod_cast h8
    · exact ⟨hn1, hnlt⟩
  have hkey : Chebyshev.psi x - ∑ n ∈ Finset.range ⌈x⌉₊, F n
      = ∑ n ∈ (Finset.Ioc 0 ⌊x⌋₊
          \ (Finset.range ⌈x⌉₊).filter (fun n : ℕ ↦ 0 < n ∧ (n:ℝ) < x)),
          ArithmeticFunction.vonMangoldt n := by
    rw [hFsum, hψ, eq_comm, eq_sub_iff_add_eq]
    exact Finset.sum_sdiff hsub
  rw [hkey]
  have hnn : (0:ℝ) ≤ ∑ n ∈ (Finset.Ioc 0 ⌊x⌋₊
      \ (Finset.range ⌈x⌉₊).filter (fun n : ℕ ↦ 0 < n ∧ (n:ℝ) < x)),
      ArithmeticFunction.vonMangoldt n :=
    Finset.sum_nonneg (fun n _ ↦ ArithmeticFunction.vonMangoldt_nonneg)
  rw [abs_of_nonneg hnn]
  calc ∑ n ∈ (Finset.Ioc 0 ⌊x⌋₊
        \ (Finset.range ⌈x⌉₊).filter (fun n : ℕ ↦ 0 < n ∧ (n:ℝ) < x)),
        ArithmeticFunction.vonMangoldt n
      ≤ ∑ n ∈ ({⌊x⌋₊} : Finset ℕ), ArithmeticFunction.vonMangoldt n :=
        Finset.sum_le_sum_of_subset_of_nonneg hdiff_sub
          (fun n _ _ ↦ ArithmeticFunction.vonMangoldt_nonneg)
    _ = ArithmeticFunction.vonMangoldt ⌊x⌋₊ := Finset.sum_singleton _ _
    _ ≤ Real.log ⌊x⌋₊ := ArithmeticFunction.vonMangoldt_le_log
    _ ≤ Real.log x := by
        have h9 : ((⌊x⌋₊:ℕ):ℝ) ≤ x := Nat.floor_le hx0.le
        have h10 : (0:ℝ) < ⌊x⌋₊ := by
          have : 0 < ⌊x⌋₊ := Nat.floor_pos.mpr hx.le
          exact_mod_cast this
        exact Real.log_le_log h10 h9

/-- Summability of the kernel differences from `x > 1`, via the crude majorant
`Λ(n)·(x/n)^c` — sharp enough for convergence, everywhere. -/
theorem kernel_diff_summable_two {x T : ℝ} (hx : 1 < x) (hT : 1 ≤ T) :
    Summable (fun n : ℕ ↦ (ArithmeticFunction.vonMangoldt n : ℂ)
      * (perronI (x/n) (1 + 1/Real.log x) T - perronδ (x/n))) := by
  have hx0 : (0:ℝ) < x := by linarith
  have hlx0 : (0:ℝ) < Real.log x := Real.log_pos hx
  set c : ℝ := 1 + 1/Real.log x with hcd
  have hc0 : (0:ℝ) < c := by rw [hcd]; positivity
  have hc1 : 1 < c := by
    rw [hcd]
    have h9 : 0 < 1/Real.log x := by positivity
    linarith
  rw [← summable_norm_iff]
  apply Summable.of_nonneg_of_le (fun n ↦ norm_nonneg _) _
    ((vonMangoldt_rpow_summable hc1).mul_left (x ^ c))
  intro n
  have hΛnn := ArithmeticFunction.vonMangoldt_nonneg (n := n)
  rcases Nat.eq_zero_or_pos n with rfl | hn
  · simp [ArithmeticFunction.map_zero]
  · have hn0 : (0:ℝ) < (n:ℝ) := by exact_mod_cast hn
    have hyx : (0:ℝ) < x/n := by positivity
    have hnorm : ‖(ArithmeticFunction.vonMangoldt n : ℂ)
          * (perronI (x/n) c T - perronδ (x/n))‖
        = ArithmeticFunction.vonMangoldt n * ‖perronI (x/n) c T - perronδ (x/n)‖ := by
      rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hΛnn]
    rw [hnorm]
    have hker : ‖perronI (x/n) c T - perronδ (x/n)‖ ≤ (x/n) ^ c := by
      by_cases hne : x/(n:ℝ) = 1
      · have hδ1 : perronδ (x/n) = 0 := by
          rw [perronδ, if_neg]
          rw [hne]
          norm_num
        rw [hδ1, sub_zero, hne]
        calc ‖perronI 1 c T‖ ≤ 1/2 := perronI_one_norm hc0
          _ ≤ (1:ℝ) ^ c := by
              rw [Real.one_rpow]
              norm_num
      · calc ‖perronI (x/n) c T - perronδ (x/n)‖
            ≤ (x/n) ^ c * min 1 (1/(T * |Real.log (x/n)|)) :=
              perron_kernel_truncated hyx hne hc0 hT
          _ ≤ (x/n) ^ c * 1 := by
              apply mul_le_mul_of_nonneg_left (min_le_left _ _)
                (Real.rpow_nonneg hyx.le _)
          _ = (x/n) ^ c := mul_one _
    have hdiv : (x / n) ^ c = x ^ c * (n:ℝ) ^ (-c) := by
      rw [Real.div_rpow hx0.le hn0.le, Real.rpow_neg hn0.le, div_eq_mul_inv]
    calc ArithmeticFunction.vonMangoldt n * ‖perronI (x/n) c T - perronδ (x/n)‖
        ≤ ArithmeticFunction.vonMangoldt n * (x/n) ^ c :=
          mul_le_mul_of_nonneg_left hker hΛnn
      _ = x ^ c * (ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c)) := by
          rw [hdiv]
          ring

/-- **Slice 1 from `x = 2` — the Perron-to-ψ bound.** The truncated Perron sum of
the von Mangoldt function misses `ψ` by at most `700·x·log(xT)²/T + 18·log x`, for
`x ≥ 2`, `T ≥ 2`. -/
theorem perron_to_psi_two {x T : ℝ} (hx : 2 ≤ x) (hT : 2 ≤ T) :
    ‖(Chebyshev.psi x : ℂ) - ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ)
        * perronI (x/n) (1 + 1/Real.log x) T‖
      ≤ 700 * x * Real.log (x * T) ^ 2 / T + 18 * Real.log x := by
  have hx0 : (0:ℝ) < x := by linarith
  have hδsum : Summable (fun n : ℕ ↦ (ArithmeticFunction.vonMangoldt n : ℂ)
      * perronδ (x/n)) := by
    apply summable_of_ne_finset_zero (s := Finset.range ⌈x⌉₊)
    intro n hn
    rw [Finset.mem_range, not_lt] at hn
    have h3 : x ≤ ⌈x⌉₊ := Nat.le_ceil x
    have h4 : ((⌈x⌉₊ : ℕ) : ℝ) ≤ n := by exact_mod_cast hn
    have h5 : x/(n:ℝ) ≤ 1 := by
      have hn0 : (0:ℝ) < n := by linarith
      rw [div_le_one hn0]
      linarith
    rw [perronδ, if_neg (by linarith), mul_zero]
  have hdiff := kernel_diff_summable_two (by linarith : (1:ℝ) < x) (by linarith : (1:ℝ) ≤ T)
  have hsplit : (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ)
        * perronI (x/n) (1 + 1/Real.log x) T)
      = (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ)
          * (perronI (x/n) (1 + 1/Real.log x) T - perronδ (x/n)))
        + ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronδ (x/n) := by
    rw [← hdiff.tsum_add hδsum]
    apply tsum_congr
    intro n
    ring
  calc ‖(Chebyshev.psi x : ℂ) - ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ)
        * perronI (x/n) (1 + 1/Real.log x) T‖
      = ‖((Chebyshev.psi x : ℂ) - ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ)
            * perronδ (x/n))
          - ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ)
            * (perronI (x/n) (1 + 1/Real.log x) T - perronδ (x/n))‖ := by
        rw [hsplit]
        ring_nf
    _ ≤ ‖(Chebyshev.psi x : ℂ) - ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ)
            * perronδ (x/n)‖
          + ‖∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ)
            * (perronI (x/n) (1 + 1/Real.log x) T - perronδ (x/n))‖ :=
        norm_sub_le _ _
    _ ≤ Real.log x + (700 * x * Real.log (x * T) ^ 2 / T + 17 * Real.log x) :=
        add_le_add (delta_sum_close_two (by linarith)) (kernel_sum_bound_two hx hT)
    _ = 700 * x * Real.log (x * T) ^ 2 / T + 18 * Real.log x := by ring

/-- **The Fubini from `x > 1`.** The kernel sum is the truncated `−ζ′/ζ` contour
integral on the line `re s = 1 + 1/log x`. -/
theorem perron_sum_eq_integral_two {x T : ℝ} (hx : 1 < x) (hT : 1 ≤ T) :
    (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ)
        * perronI (x/n) (1 + 1/Real.log x) T)
      = (2 * (Real.pi:ℂ) * Complex.I)⁻¹
        * ∫ t in (-T)..T,
            (- deriv riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t)
              / riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t))
            * ((x:ℝ):ℂ) ^ (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t)
            / (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t) * Complex.I := by
  have hx0 : (0:ℝ) < x := by linarith
  have hT0 : (0:ℝ) < T := lt_of_lt_of_le one_pos hT
  have hlx0 : (0:ℝ) < Real.log x := Real.log_pos hx
  set c : ℝ := 1 + 1/Real.log x with hcd
  have hc0 : (0:ℝ) < c := by rw [hcd]; positivity
  have hc1 : 1 < c := by
    rw [hcd]
    have h9 : 0 < 1/Real.log x := by positivity
    linarith
  have hsre : ∀ t : ℝ, (((c:ℝ):ℂ) + Complex.I * t).re = c := by
    intro t
    simp
  have hsne : ∀ t : ℝ, (((c:ℝ):ℂ) + Complex.I * t) ≠ 0 := by
    intro t h
    have hre := congrArg Complex.re h
    simp at hre
    linarith
  -- the summand family, in set-integral form
  set F : ℕ → ℝ → ℂ := fun n t ↦ (ArithmeticFunction.vonMangoldt n : ℂ)
    * (((x/n : ℝ):ℂ) ^ (((c:ℝ):ℂ) + Complex.I * t)
      / (((c:ℝ):ℂ) + Complex.I * t) * Complex.I) with hFd
  have hFcont : ∀ n : ℕ, 0 < n → Continuous (F n) := by
    intro n hn
    rw [hFd]
    dsimp only
    apply Continuous.mul continuous_const
    apply Continuous.mul _ continuous_const
    apply Continuous.div
    · apply Continuous.const_cpow (by fun_prop)
      left
      have hn0 : (0:ℝ) < n := by exact_mod_cast hn
      have : (0:ℝ) < x/n := by positivity
      exact_mod_cast this.ne'
    · fun_prop
    · exact hsne
  have hF0 : F 0 = fun _ ↦ 0 := by
    funext t
    rw [hFd]
    simp [ArithmeticFunction.map_zero]
  have hFint : ∀ n : ℕ, MeasureTheory.Integrable (F n)
      (MeasureTheory.volume.restrict (Set.Ioc (-T) T)) := by
    intro n
    rcases Nat.eq_zero_or_pos n with rfl | hn
    · rw [hF0]
      exact MeasureTheory.integrable_zero _ _ _
    · exact ((hFcont n hn).intervalIntegrable (-T) T).1
  have hFbound : ∀ n : ℕ, 0 < n → ∀ t : ℝ,
      ‖F n t‖ ≤ ArithmeticFunction.vonMangoldt n * (x/n) ^ c / c := by
    intro n hn t
    have hn0 : (0:ℝ) < n := by exact_mod_cast hn
    have hyx : (0:ℝ) < x/n := by positivity
    rw [hFd]
    dsimp only
    rw [norm_mul, norm_mul, Complex.norm_I, mul_one, norm_div,
      Complex.norm_real, Real.norm_eq_abs,
      abs_of_nonneg ArithmeticFunction.vonMangoldt_nonneg,
      Complex.norm_cpow_eq_rpow_re_of_pos hyx, hsre]
    have hden : c ≤ ‖(((c:ℝ):ℂ) + Complex.I * t)‖ := by
      have h := Complex.abs_re_le_norm (((c:ℝ):ℂ) + Complex.I * t)
      rw [hsre] at h
      calc c = |c| := (abs_of_pos hc0).symm
        _ ≤ _ := h
    calc ArithmeticFunction.vonMangoldt n
          * ((x/n) ^ c / ‖(((c:ℝ):ℂ) + Complex.I * t)‖)
        ≤ ArithmeticFunction.vonMangoldt n * ((x/n) ^ c / c) := by
          apply mul_le_mul_of_nonneg_left _ ArithmeticFunction.vonMangoldt_nonneg
          exact div_le_div_of_nonneg_left (Real.rpow_nonneg hyx.le _) hc0 hden
      _ = ArithmeticFunction.vonMangoldt n * (x/n) ^ c / c := by ring
  have hFnorm_sum : Summable (fun n : ℕ ↦
      ∫ t, ‖F n t‖ ∂(MeasureTheory.volume.restrict (Set.Ioc (-T) T))) := by
    apply Summable.of_nonneg_of_le
      (fun n ↦ MeasureTheory.integral_nonneg (fun t ↦ norm_nonneg _)) _
      ((vonMangoldt_rpow_summable hc1).mul_left (2 * T * x ^ c / c))
    intro n
    rcases Nat.eq_zero_or_pos n with rfl | hn
    · rw [hF0]
      simp [ArithmeticFunction.map_zero]
      try positivity
    · have hn0 : (0:ℝ) < n := by exact_mod_cast hn
      have hyx : (0:ℝ) < x/n := by positivity
      have hvol : (MeasureTheory.volume (Set.Ioc (-T) T)).toReal = 2*T := by
        rw [Real.volume_Ioc, ENNReal.toReal_ofReal (by linarith)]
        ring
      calc ∫ t, ‖F n t‖ ∂(MeasureTheory.volume.restrict (Set.Ioc (-T) T))
          ≤ ∫ _t, (ArithmeticFunction.vonMangoldt n * (x/n) ^ c / c)
              ∂(MeasureTheory.volume.restrict (Set.Ioc (-T) T)) := by
            apply MeasureTheory.integral_mono_of_nonneg
            · filter_upwards with t using norm_nonneg _
            · exact MeasureTheory.integrable_const _
            · filter_upwards with t using hFbound n hn t
          _ = (2*T) * (ArithmeticFunction.vonMangoldt n * (x/n) ^ c / c) := by
              rw [MeasureTheory.integral_const, smul_eq_mul,
                MeasureTheory.measureReal_restrict_apply_univ,
                MeasureTheory.measureReal_def, hvol]
          _ = 2 * T * x ^ c / c * (ArithmeticFunction.vonMangoldt n * (n:ℝ)^(-c)) := by
              rw [Real.div_rpow hx0.le hn0.le, Real.rpow_neg hn0.le]
              field_simp
              try ring
  -- the swap
  have hswap := MeasureTheory.integral_tsum_of_summable_integral_norm hFint hFnorm_sum
  -- rewrite each perronI as a set integral of F n
  have hperron : ∀ n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ)
      * perronI (x/n) c T
      = (2 * (Real.pi:ℂ) * Complex.I)⁻¹
        * ∫ t, F n t ∂(MeasureTheory.volume.restrict (Set.Ioc (-T) T)) := by
    intro n
    rw [perronI, hFd]
    dsimp only
    rw [intervalIntegral.integral_of_le (by linarith : -T ≤ T),
      MeasureTheory.integral_const_mul]
    ring
  calc (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronI (x/n) c T)
      = ∑' n : ℕ, (2 * (Real.pi:ℂ) * Complex.I)⁻¹
          * ∫ t, F n t ∂(MeasureTheory.volume.restrict (Set.Ioc (-T) T)) :=
        tsum_congr hperron
    _ = (2 * (Real.pi:ℂ) * Complex.I)⁻¹
          * ∑' n : ℕ, ∫ t, F n t ∂(MeasureTheory.volume.restrict (Set.Ioc (-T) T)) :=
        tsum_mul_left
    _ = (2 * (Real.pi:ℂ) * Complex.I)⁻¹
          * ∫ t, (∑' n : ℕ, F n t) ∂(MeasureTheory.volume.restrict (Set.Ioc (-T) T)) := by
        rw [hswap]
    _ = (2 * (Real.pi:ℂ) * Complex.I)⁻¹
        * ∫ t in (-T)..T,
            (- deriv riemannZeta (((c:ℝ):ℂ) + Complex.I * t)
              / riemannZeta (((c:ℝ):ℂ) + Complex.I * t))
            * ((x:ℝ):ℂ) ^ (((c:ℝ):ℂ) + Complex.I * t)
            / (((c:ℝ):ℂ) + Complex.I * t) * Complex.I := by
        congr 1
        rw [intervalIntegral.integral_of_le (by linarith : -T ≤ T)]
        apply MeasureTheory.integral_congr_ae
        filter_upwards with t
        have hs1 : 1 < ((((c:ℝ):ℂ) + Complex.I * t)).re := by
          rw [hsre]
          exact hc1
        calc (∑' n : ℕ, F n t)
            = (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ)
                * ((x/n : ℝ):ℂ) ^ (((c:ℝ):ℂ) + Complex.I * t))
              * ((((c:ℝ):ℂ) + Complex.I * t)⁻¹ * Complex.I) := by
              rw [← tsum_mul_right]
              apply tsum_congr
              intro n
              rw [hFd]
              dsimp only
              rw [div_eq_mul_inv]
              ring
          _ = (- deriv riemannZeta (((c:ℝ):ℂ) + Complex.I * t)
                / riemannZeta (((c:ℝ):ℂ) + Complex.I * t))
              * ((x:ℝ):ℂ) ^ (((c:ℝ):ℂ) + Complex.I * t)
              / (((c:ℝ):ℂ) + Complex.I * t) * Complex.I := by
              rw [tsum_vonMangoldt_div_cpow hx0 hs1]
              rw [div_eq_mul_inv]
              ring

/-- **hEF, Perron form from `x = 2` — the truncated explicit formula at the line
`re = c`, `c = 1 + 1/log x`.** For `x ≥ 2`, `T ≥ 2`, `ψ` misses the truncated
`−ζ′/ζ` integral by at most `700·x·log(xT)²/T + 18·log x`. -/
theorem explicit_formula_perron_two {x T : ℝ} (hx : 2 ≤ x) (hT : 2 ≤ T) :
    ‖(Chebyshev.psi x : ℂ)
        - (2 * (Real.pi:ℂ) * Complex.I)⁻¹
          * ∫ t in (-T)..T,
              (- deriv riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t)
                / riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t))
              * ((x:ℝ):ℂ) ^ (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t)
              / (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t) * Complex.I‖
      ≤ 700 * x * Real.log (x * T) ^ 2 / T + 18 * Real.log x := by
  rw [← perron_sum_eq_integral_two (by linarith : (1:ℝ) < x) (by linarith : (1:ℝ) ≤ T)]
  exact perron_to_psi_two hx hT

/-- info: 'PerronTwo.explicit_formula_perron_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms explicit_formula_perron_two

end PerronTwo
