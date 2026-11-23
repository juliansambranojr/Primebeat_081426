/-
MollifiedMean — block C4 of `lean_stage3/design/carlson.md`. 2026-11-23.

The mean square of `f_X(s) = ζ(s)·M_X(s) − 1` along `Re s = u`, `1/2 < u ≤ 2`, over
`t ∈ [1, T]`. Euler–Maclaurin of order `k` (block C3) writes `ζ = P_N − N^{1−s}/(1−s) + E` with
`‖E‖ ≤ A_k N^{−u}(1 + (T+2+k)^k N^{1−k})`. Then `f = (P_N·M_X − 1) − N^{1−s}/(1−s)·M_X + E·M_X`.
The first piece is the Dirichlet sum of block C2 with its terms below `X` gone, and the weighted
mean value theorem (block C1b) charges it `T·Σ_{n ≥ X} c_n² n^{−2u} + 6 log·Σ c_n² n^{1−2u}`.
The second sum is block C2b, proved here by dyadic blocks. The other two pieces are small
pointwise, since `‖M_X‖ ≤ X` and `|1 − s| ≥ t`.

  M                       M_X(s) = Σ_{1 ≤ d < X} μ(d)·d^{−s}
  f                       f_X(s) = ζ(s)·M_X(s) − 1
  b                       coef X N n for X ≤ n, else 0
  emConst_nonneg          0 ≤ A_k
  norm_M_le               0 ≤ Re s ⊢ ‖M_X(s)‖ ≤ X
  norm_smooth_le          0 < t ⊢ ‖N^{1−s}/(1−s)‖ ≤ N^{1−u}/t at s = u + it
  PM_sub_one_eq           2 ≤ X ≤ N ⊢ P_N·M_X − 1 = Σ_{n ≤ N·X} b_n·n^{−s}
  f_eq                    f = (Σ b_n n^{−s}) − N^{1−s}/(1−s)·M_X + E·M_X
  norm_sq_add_three       ‖a + b + c‖² ≤ 3(‖a‖² + ‖b‖² + ‖c‖²)
  rpow_sq                 0 ≤ x ⊢ (x^a)² = x^{2a}
  sum_b_sq_eq             Σ_{n ≤ Y} b_n²·w_n = Σ_{X ≤ n ≤ Y} c_n²·w_n
  sum_coef_sq_up_le       (C2b) Σ_{n ≤ Y} c_n² n^{1−2u} ≤ 4(1+log X)³(1+log Y)·max 1 (Y^{2−2u})
  integral_inv_sq_le      ∫_1^T t^{−2} dt ≤ 1
  mean_sq_main_le         ∫_1^T ‖Σ b_n n^{−s}‖² ≤ T·(2/(1−2^{1−2u}))X^{1−2u}(1+log X)³
                            + 24(1+log NX)²(1+log X)³·max 1 ((NX)^{2−2u})
  mean_sq_f_le            the mean square of f, four terms

What the next slice needs: the zeros from the mean square (block C5), integrating this bound in
`u` over `[σ − r, 2]` with `X = T^a`, `N = T^(1+ε)` and `k` fixed large. It is not here.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ZetaEM
import Stage3.Mollified
import Stage3.DirichletMeanW

namespace MollifiedMean

open Finset

noncomputable section

/-- The Möbius sum `M_X(s) = Σ_{1 ≤ d < X} μ(d)·d^(−s)`. -/
def M (X : ℕ) (s : ℂ) : ℂ :=
  ∑ d ∈ Ico 1 X, (ArithmeticFunction.moebius d : ℂ) * (d : ℂ) ^ (-s)

/-- The mollified function `f_X(s) = ζ(s)·M_X(s) − 1`. -/
def f (X : ℕ) (s : ℂ) : ℂ := riemannZeta s * M X s - 1

/-- The coefficient of `P_N·M_X − 1`: `coef X N n` for `X ≤ n`, and `0` below `X`. -/
def b (X N n : ℕ) : ℝ := if X ≤ n then (Mollified.coef X N n : ℝ) else 0

/-- The Euler–Maclaurin constant `A_k` is nonnegative. -/
theorem emConst_nonneg (k : ℕ) : 0 ≤ ZetaEM.emConst k := by
  unfold ZetaEM.emConst
  have h1 : 0 ≤ ∑ j ∈ Finset.Ico 1 k, |bernoulliFun (j+1) 0| / ((j+1).factorial : ℝ) :=
    sum_nonneg fun j _ => by positivity
  have h2 : 0 ≤ ZetaEM.bernBound k / (k.factorial : ℝ) :=
    div_nonneg (ZetaEM.bernBound_nonneg k) (by positivity)
  linarith

/-- For `Re s ≥ 0` the Möbius sum has norm at most `X`, each of its terms having norm at most
one. -/
theorem norm_M_le (X : ℕ) {s : ℂ} (hs : 0 ≤ s.re) : ‖M X s‖ ≤ X := by
  unfold M
  calc ‖∑ d ∈ Ico 1 X, (ArithmeticFunction.moebius d : ℂ) * (d : ℂ) ^ (-s)‖
      ≤ ∑ d ∈ Ico 1 X, ‖(ArithmeticFunction.moebius d : ℂ) * (d : ℂ) ^ (-s)‖ := norm_sum_le _ _
    _ ≤ ∑ d ∈ Ico 1 X, (1 : ℝ) := by
        refine sum_le_sum fun d hd => ?_
        have hd1 : 1 ≤ d := (mem_Ico.1 hd).1
        rw [norm_mul, Complex.norm_intCast, Complex.norm_natCast_cpow_of_pos (by omega)]
        have h1 : |((ArithmeticFunction.moebius d : ℤ) : ℝ)| ≤ 1 := by
          exact_mod_cast ArithmeticFunction.abs_moebius_le_one
        have h2 : (d : ℝ) ^ (-s).re ≤ 1 :=
          Real.rpow_le_one_of_one_le_of_nonpos (by exact_mod_cast hd1)
            (by rw [Complex.neg_re]; linarith)
        have h3 : 0 ≤ (d : ℝ) ^ (-s).re := Real.rpow_nonneg (Nat.cast_nonneg _) _
        nlinarith [abs_nonneg ((ArithmeticFunction.moebius d : ℤ) : ℝ)]
    _ = ((X - 1 : ℕ) : ℝ) := by simp
    _ ≤ X := by exact_mod_cast Nat.sub_le X 1

/-- At `s = u + it` with `t > 0`, the smooth term satisfies `‖N^(1−s)/(1−s)‖ ≤ N^(1−u)/t`,
because `|1 − s| ≥ t`. -/
theorem norm_smooth_le {N : ℕ} (hN : 0 < N) (u : ℝ) {t : ℝ} (ht : 0 < t) :
    ‖(N : ℂ) ^ (1 - ((u : ℂ) + Complex.I * (t : ℂ))) / (1 - ((u : ℂ) + Complex.I * (t : ℂ)))‖
      ≤ (N : ℝ) ^ (1 - u) / t := by
  rw [norm_div, Complex.norm_natCast_cpow_of_pos hN]
  have hre : (1 - ((u : ℂ) + Complex.I * (t : ℂ))).re = 1 - u := by simp
  have him : (1 - ((u : ℂ) + Complex.I * (t : ℂ))).im = -t := by simp
  have hle : t ≤ ‖1 - ((u : ℂ) + Complex.I * (t : ℂ))‖ := by
    have := Complex.abs_im_le_norm (1 - ((u : ℂ) + Complex.I * (t : ℂ)))
    rw [him, abs_neg, abs_of_pos ht] at this
    exact this
  rw [hre]
  exact div_le_div_of_nonneg_left (Real.rpow_nonneg (Nat.cast_nonneg _) _) ht hle

/-- For `2 ≤ X ≤ N`, the product `P_N·M_X` minus one is the Dirichlet sum over `n ≤ N·X` with the
coefficients `b`, the terms below `X` other than `n = 1` vanishing and the `n = 1` term being
one. -/
theorem PM_sub_one_eq (s : ℂ) {X N : ℕ} (hX : 2 ≤ X) (hXN : X ≤ N) :
    (∑ m ∈ Icc 1 N, (m : ℂ) ^ (-s)) * M X s - 1 =
      ∑ n ∈ Icc 1 (N * X), (b X N n : ℂ) * (n : ℂ) ^ (-s) := by
  rw [M, Mollified.prod_eq_sum]
  have hpt : ∀ n ∈ Icc 1 (N * X), (Mollified.coef X N n : ℂ) * (n : ℂ) ^ (-s) =
      (b X N n : ℂ) * (n : ℂ) ^ (-s) + if n = 1 then 1 else 0 := by
    intro n hn
    have hn1 := (mem_Icc.1 hn).1
    unfold b
    by_cases hXn : X ≤ n
    · rw [if_pos hXn, if_neg (by omega)]
      push_cast
      ring
    · rw [if_neg hXn]
      by_cases h1 : n = 1
      · subst h1
        rw [if_pos rfl, Mollified.coef_one X N (by omega) (by omega)]
        simp
      · rw [if_neg h1, Mollified.coef_eq_zero X N n (by omega) (by omega) (by omega)]
        simp
  rw [sum_congr rfl hpt, sum_add_distrib, sum_ite_eq' (Icc 1 (N * X)) 1 (fun _ => (1 : ℂ)),
    if_pos (by
      rw [mem_Icc]
      exact ⟨le_refl 1, Nat.one_le_iff_ne_zero.2 (Nat.mul_ne_zero (by omega) (by omega))⟩)]
  ring

/-- For `2 ≤ X ≤ N`, `f_X(s)` is the Dirichlet sum of `P_N·M_X − 1`, minus the smooth term times
`M_X`, plus the Euler–Maclaurin error `ζ − P_N + N^(1−s)/(1−s)` times `M_X`. -/
theorem f_eq (s : ℂ) {X N : ℕ} (hX : 2 ≤ X) (hXN : X ≤ N) :
    f X s = ∑ n ∈ Icc 1 (N * X), (b X N n : ℂ) * (n : ℂ) ^ (-s)
      + (-((N : ℂ) ^ (1 - s) / (1 - s))) * M X s
      + (riemannZeta s - ∑ n ∈ Icc 1 N, (n : ℂ) ^ (-s) + (N : ℂ) ^ (1 - s) / (1 - s)) * M X s := by
  rw [← PM_sub_one_eq s hX hXN, f]
  ring

/-- The square of the norm of a sum of three terms is at most three times the sum of their
squared norms. -/
theorem norm_sq_add_three (x y z : ℂ) : ‖x + y + z‖ ^ 2 ≤ 3 * (‖x‖ ^ 2 + ‖y‖ ^ 2 + ‖z‖ ^ 2) := by
  have h := norm_add₃_le (a := x) (b := y) (c := z)
  have h2 : ‖x + y + z‖ ^ 2 ≤ (‖x‖ + ‖y‖ + ‖z‖) ^ 2 :=
    pow_le_pow_left₀ (norm_nonneg _) h 2
  nlinarith [sq_nonneg (‖x‖ - ‖y‖), sq_nonneg (‖y‖ - ‖z‖), sq_nonneg (‖x‖ - ‖z‖)]

/-- For `x ≥ 0`, the square of `x^a` is `x^(2a)`. -/
theorem rpow_sq {x : ℝ} (hx : 0 ≤ x) (a : ℝ) : (x ^ a) ^ 2 = x ^ (2 * a) := by
  rw [← Real.rpow_natCast, ← Real.rpow_mul hx]
  congr 1
  push_cast
  ring

/-- For `1 ≤ X`, a sum over `[1, Y]` of `b_n²·w_n` is the sum over `[X, Y]` of `coef²·w_n`. -/
theorem sum_b_sq_eq {X : ℕ} (hX : 1 ≤ X) (N Y : ℕ) (w : ℕ → ℝ) :
    ∑ n ∈ Icc 1 Y, b X N n ^ 2 * w n = ∑ n ∈ Icc X Y, (Mollified.coef X N n : ℝ) ^ 2 * w n := by
  have h1 : ∀ n ∈ Icc 1 Y, b X N n ^ 2 * w n =
      if X ≤ n then (Mollified.coef X N n : ℝ) ^ 2 * w n else 0 := by
    intro n _
    unfold b
    split_ifs <;> simp
  rw [sum_congr rfl h1, ← sum_filter]
  congr 1
  ext n
  simp only [mem_filter, mem_Icc]
  omega

/-- Block C2b: for `u > 1/2`, the squared coefficients weighted upward by `n^(1−2u)` sum over
`[1, Y]` to at most `4·(1 + log X)³·(1 + log Y)·max 1 (Y^(2−2u))`. -/
theorem sum_coef_sq_up_le (u : ℝ) (hu : 1 / 2 < u) (X N Y : ℕ) :
    ∑ n ∈ Icc 1 Y, (Mollified.coef X N n : ℝ) ^ 2 * (n : ℝ) ^ (1 - 2 * u) ≤
      4 * (1 + Real.log X) ^ 3 * (1 + Real.log Y) * max 1 ((Y : ℝ) ^ (2 - 2 * u)) := by
  set L := (1 + Real.log X) ^ 3 with hL
  have hL0 : 0 ≤ L := pow_nonneg (by have := Real.log_natCast_nonneg X; linarith) 3
  have hlogY : 0 ≤ Real.log Y := Real.log_natCast_nonneg Y
  have hmax : 1 ≤ max 1 ((Y : ℝ) ^ (2 - 2 * u)) := le_max_left _ _
  rcases Nat.eq_zero_or_pos Y with hY | hY
  · subst hY
    simp only [Icc_eq_empty_of_lt (show (0:ℕ) < 1 by norm_num), sum_empty]
    positivity
  set J := Nat.log 2 Y + 1 with hJ
  let g : ℕ → ℝ := fun n => (Mollified.coef X N n : ℝ) ^ 2 * (n : ℝ) ^ (1 - 2 * u)
  have hg0 : ∀ n, 0 ≤ g n := fun n =>
    mul_nonneg (sq_nonneg _) (Real.rpow_nonneg (Nat.cast_nonneg _) _)
  have hYJ : Y < 2 ^ J := Nat.lt_pow_succ_log_self (by norm_num) Y
  have h1 : ∑ n ∈ Icc 1 Y, g n ≤ ∑ n ∈ Ico (2 ^ 0 * 1) (2 ^ J * 1), g n := by
    refine sum_le_sum_of_subset_of_nonneg ?_ (fun n _ _ => hg0 n)
    intro n hn
    simp only [mem_Icc] at hn
    simp only [mem_Ico, pow_zero, mul_one]
    omega
  have h2 : ∀ j ∈ range J, ∑ n ∈ Ico (2 ^ j * 1) (2 ^ (j + 1) * 1), g n ≤
      2 * L * max 1 ((Y : ℝ) ^ (2 - 2 * u)) := by
    intro j hj
    have hjY : 2 ^ j ≤ Y := by
      have hj' : j ≤ Nat.log 2 Y := by rw [mem_range] at hj; omega
      exact (Nat.pow_le_pow_right (by norm_num) hj').trans (Nat.pow_log_le_self 2 hY.ne')
    have hy : (0 : ℝ) < ((2 ^ j : ℕ) : ℝ) := by positivity
    have hy1 : (1 : ℝ) ≤ ((2 ^ j : ℕ) : ℝ) := by exact_mod_cast Nat.one_le_two_pow
    have hsub : Ico (2 ^ j * 1) (2 ^ (j + 1) * 1) ⊆ Icc 1 (2 ^ (j + 1)) := by
      intro n hn
      simp only [mem_Ico, mem_Icc, mul_one] at hn ⊢
      have : 1 ≤ 2 ^ j := Nat.one_le_two_pow
      omega
    have hpow : ((2 ^ j : ℕ) : ℝ) ^ (2 - 2 * u) ≤ max 1 ((Y : ℝ) ^ (2 - 2 * u)) := by
      rcases le_or_gt 0 (2 - 2 * u) with he | he
      · exact (Real.rpow_le_rpow hy.le (by exact_mod_cast hjY) he).trans (le_max_right _ _)
      · exact (Real.rpow_le_one_of_one_le_of_nonpos hy1 he.le).trans (le_max_left _ _)
    calc ∑ n ∈ Ico (2 ^ j * 1) (2 ^ (j + 1) * 1), g n
        ≤ ∑ n ∈ Ico (2 ^ j * 1) (2 ^ (j + 1) * 1),
            (Mollified.coef X N n : ℝ) ^ 2 * ((2 ^ j : ℕ) : ℝ) ^ (1 - 2 * u) := by
          refine sum_le_sum fun n hn => ?_
          refine mul_le_mul_of_nonneg_left ?_ (sq_nonneg _)
          have hn' : 2 ^ j ≤ n := by simpa using (mem_Ico.1 hn).1
          exact Real.rpow_le_rpow_of_nonpos hy (by exact_mod_cast hn') (by linarith)
      _ = (∑ n ∈ Ico (2 ^ j * 1) (2 ^ (j + 1) * 1), (Mollified.coef X N n : ℝ) ^ 2) *
            ((2 ^ j : ℕ) : ℝ) ^ (1 - 2 * u) := by rw [sum_mul]
      _ ≤ (∑ n ∈ Icc 1 (2 ^ (j + 1)), (Mollified.coef X N n : ℝ) ^ 2) *
            ((2 ^ j : ℕ) : ℝ) ^ (1 - 2 * u) :=
          mul_le_mul_of_nonneg_right
            (sum_le_sum_of_subset_of_nonneg hsub (fun _ _ _ => sq_nonneg _))
            (Real.rpow_nonneg hy.le _)
      _ ≤ (((2 ^ (j + 1) : ℕ) : ℝ) * L) * ((2 ^ j : ℕ) : ℝ) ^ (1 - 2 * u) :=
          mul_le_mul_of_nonneg_right (Mollified.sum_coef_sq_le X N _) (Real.rpow_nonneg hy.le _)
      _ = 2 * L * ((2 ^ j : ℕ) : ℝ) ^ (2 - 2 * u) := by
          have e1 : ((2 ^ (j + 1) : ℕ) : ℝ) = 2 * ((2 ^ j : ℕ) : ℝ) := by push_cast; ring
          have e2 : ((2 ^ j : ℕ) : ℝ) ^ (2 - 2 * u) =
              ((2 ^ j : ℕ) : ℝ) * ((2 ^ j : ℕ) : ℝ) ^ (1 - 2 * u) := by
            rw [show (2 : ℝ) - 2 * u = 1 + (1 - 2 * u) by ring, Real.rpow_add hy, Real.rpow_one]
          rw [e1, e2]
          ring
      _ ≤ 2 * L * max 1 ((Y : ℝ) ^ (2 - 2 * u)) :=
          mul_le_mul_of_nonneg_left hpow (by positivity)
  have hJle : (J : ℝ) ≤ 2 * (1 + Real.log Y) := by
    have hm : ((Nat.log 2 Y : ℕ) : ℝ) * Real.log 2 ≤ Real.log Y := by
      have h := Nat.pow_log_le_self 2 hY.ne'
      have h' : ((2 ^ Nat.log 2 Y : ℕ) : ℝ) ≤ (Y : ℝ) := by exact_mod_cast h
      have hpos : (0 : ℝ) < ((2 ^ Nat.log 2 Y : ℕ) : ℝ) := by positivity
      have := Real.log_le_log hpos h'
      rw [Nat.cast_pow, Real.log_pow] at this
      push_cast at this
      linarith
    have hl2 := Real.log_two_gt_d9
    have hm0 : (0 : ℝ) ≤ ((Nat.log 2 Y : ℕ) : ℝ) := Nat.cast_nonneg _
    rw [hJ]
    push_cast
    nlinarith
  calc ∑ n ∈ Icc 1 Y, (Mollified.coef X N n : ℝ) ^ 2 * (n : ℝ) ^ (1 - 2 * u)
      = ∑ n ∈ Icc 1 Y, g n := rfl
    _ ≤ ∑ n ∈ Ico (2 ^ 0 * 1) (2 ^ J * 1), g n := h1
    _ = ∑ j ∈ range J, ∑ n ∈ Ico (2 ^ j * 1) (2 ^ (j + 1) * 1), g n := by
        rw [pow_zero, one_mul]
        exact Mollified.sum_Ico_dyadic g 1 J
    _ ≤ ∑ j ∈ range J, 2 * L * max 1 ((Y : ℝ) ^ (2 - 2 * u)) := sum_le_sum h2
    _ = (J : ℝ) * (2 * L * max 1 ((Y : ℝ) ^ (2 - 2 * u))) := by simp
    _ ≤ (2 * (1 + Real.log Y)) * (2 * L * max 1 ((Y : ℝ) ^ (2 - 2 * u))) :=
        mul_le_mul_of_nonneg_right hJle (by positivity)
    _ = 4 * L * (1 + Real.log Y) * max 1 ((Y : ℝ) ^ (2 - 2 * u)) := by ring

/-- The integral of `t^(−2)` over `[1, T]` is at most one. -/
theorem integral_inv_sq_le {T : ℝ} (hT : 1 ≤ T) : ∫ t in (1:ℝ)..T, (t ^ 2)⁻¹ ≤ 1 := by
  have hpos : ∀ x ∈ Set.uIcc (1:ℝ) T, 0 < x := by
    intro x hx
    rw [Set.uIcc_of_le hT] at hx
    linarith [hx.1]
  have hderiv : ∀ x ∈ Set.uIcc (1:ℝ) T, HasDerivAt (fun y : ℝ => -y⁻¹) ((x ^ 2)⁻¹) x := by
    intro x hx
    simpa using (hasDerivAt_inv (hpos x hx).ne').fun_neg
  have hint : IntervalIntegrable (fun x : ℝ => (x ^ 2)⁻¹) MeasureTheory.volume 1 T := by
    refine ContinuousOn.intervalIntegrable ?_
    exact (continuousOn_pow 2).inv₀ fun x hx => pow_ne_zero 2 (hpos x hx).ne'
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint]
  have : 0 ≤ T⁻¹ := inv_nonneg.2 (by linarith)
  simp only [inv_one]
  linarith

/-- On `[1, T]` along `Re s = u > 1/2`, the mean square of the Dirichlet sum of `P_N·M_X − 1` is
at most `T·(2/(1 − 2^(1−2u)))·X^(1−2u)·(1 + log X)³` plus
`24·(1 + log NX)²·(1 + log X)³·max 1 ((NX)^(2−2u))`. -/
theorem mean_sq_main_le {X N : ℕ} (hX : 1 ≤ X) {u T : ℝ} (hu : 1 / 2 < u) (hT : 1 ≤ T) :
    ∫ t in (1:ℝ)..T,
        ‖∑ n ∈ Icc 1 (N * X), (b X N n : ℂ) * (n : ℂ) ^ (-((u : ℂ) + Complex.I * (t : ℂ)))‖ ^ 2
      ≤ T * (2 / (1 - (2:ℝ) ^ (1 - 2 * u))) * (X:ℝ) ^ (1 - 2 * u) * (1 + Real.log X) ^ 3
        + 24 * (1 + Real.log ((N * X : ℕ) : ℝ)) ^ 2 * (1 + Real.log X) ^ 3
            * max 1 (((N * X : ℕ) : ℝ) ^ (2 - 2 * u)) := by
  set Y := N * X with hY
  set LY := 1 + Real.log (Y : ℝ) with hLY
  have hLY0 : 0 ≤ LY := by have := Real.log_natCast_nonneg Y; linarith
  have h := DirichletMeanW.dirichlet_mean_value_weighted_sigma Y (fun n => (b X N n : ℂ)) u hT
  have hnorm : ∀ n, ‖(b X N n : ℂ)‖ ^ 2 = b X N n ^ 2 := fun n => by
    rw [Complex.norm_real, Real.norm_eq_abs, sq_abs]
  simp only [hnorm] at h
  refine h.trans ?_
  have hsplit : ∑ n ∈ Icc 1 Y, b X N n ^ 2 * (n : ℝ) ^ (-2 * u) * ((T - 1) + 6 * n * LY) =
      (T - 1) * ∑ n ∈ Icc 1 Y, b X N n ^ 2 * (n : ℝ) ^ (-2 * u)
        + 6 * LY * ∑ n ∈ Icc 1 Y, b X N n ^ 2 * ((n : ℝ) ^ (-2 * u) * n) := by
    rw [mul_sum, mul_sum, ← sum_add_distrib]
    exact sum_congr rfl fun n _ => by ring
  rw [hsplit]
  -- the first sum
  have hS1 : ∑ n ∈ Icc 1 Y, b X N n ^ 2 * (n : ℝ) ^ (-2 * u) ≤
      2 / (1 - (2:ℝ) ^ (1 - 2 * u)) * (X:ℝ) ^ (1 - 2 * u) * (1 + Real.log X) ^ 3 := by
    rw [sum_b_sq_eq hX N Y (fun n => (n : ℝ) ^ (-2 * u))]
    exact Mollified.sum_coef_sq_weighted_le u hu X N Y hX
  have hS10 : 0 ≤ ∑ n ∈ Icc 1 Y, b X N n ^ 2 * (n : ℝ) ^ (-2 * u) :=
    sum_nonneg fun n _ => mul_nonneg (sq_nonneg _) (Real.rpow_nonneg (Nat.cast_nonneg _) _)
  -- the second sum
  have hS2 : ∑ n ∈ Icc 1 Y, b X N n ^ 2 * ((n : ℝ) ^ (-2 * u) * n) ≤
      4 * (1 + Real.log X) ^ 3 * LY * max 1 ((Y : ℝ) ^ (2 - 2 * u)) := by
    refine le_trans ?_ (sum_coef_sq_up_le u hu X N Y)
    refine sum_le_sum fun n hn => ?_
    have hn0 : (0 : ℝ) < n := by exact_mod_cast (mem_Icc.1 hn).1
    have he : (n : ℝ) ^ (-2 * u) * n = (n : ℝ) ^ (1 - 2 * u) := by
      rw [show (1 : ℝ) - 2 * u = -2 * u + 1 by ring, Real.rpow_add hn0, Real.rpow_one]
    rw [he]
    refine mul_le_mul_of_nonneg_right ?_ (Real.rpow_nonneg hn0.le _)
    unfold b
    split_ifs
    · exact le_refl _
    · simp only [ne_eq, OfNat.ofNat_ne_zero, not_false_eq_true, zero_pow]
      exact sq_nonneg _
  have hT0 : 0 ≤ T := by linarith
  have hK1 : (T - 1) * ∑ n ∈ Icc 1 Y, b X N n ^ 2 * (n : ℝ) ^ (-2 * u) ≤
      T * (2 / (1 - (2:ℝ) ^ (1 - 2 * u)) * (X:ℝ) ^ (1 - 2 * u) * (1 + Real.log X) ^ 3) := by
    calc (T - 1) * ∑ n ∈ Icc 1 Y, b X N n ^ 2 * (n : ℝ) ^ (-2 * u)
        ≤ T * ∑ n ∈ Icc 1 Y, b X N n ^ 2 * (n : ℝ) ^ (-2 * u) :=
          mul_le_mul_of_nonneg_right (by linarith) hS10
      _ ≤ _ := mul_le_mul_of_nonneg_left hS1 hT0
  have hK2 : 6 * LY * ∑ n ∈ Icc 1 Y, b X N n ^ 2 * ((n : ℝ) ^ (-2 * u) * n) ≤
      6 * LY * (4 * (1 + Real.log X) ^ 3 * LY * max 1 ((Y : ℝ) ^ (2 - 2 * u))) :=
    mul_le_mul_of_nonneg_left hS2 (by positivity)
  have hfin : 6 * LY * (4 * (1 + Real.log X) ^ 3 * LY * max 1 ((Y : ℝ) ^ (2 - 2 * u))) =
      24 * LY ^ 2 * (1 + Real.log X) ^ 3 * max 1 ((Y : ℝ) ^ (2 - 2 * u)) := by ring
  rw [hfin] at hK2
  linarith

/-- The mean square of `f_X = ζ·M_X − 1` over `t ∈ [1, T]` on the line `Re s = u`, for
`1/2 < u ≤ 2`, `k ≥ 2`, `2 ≤ X ≤ N` and `T + 3 + k ≤ N`, is at most three times the sum of
the main term `T·X^(1−2u)·logs`, the off-diagonal term `(NX)^(2−2u)·logs`, the smooth term
`X²·N^(2−2u)` and the Euler–Maclaurin term `T·X²·A_k²·N^(−2u)·(1 + (T+2+k)^k·N^(1−k))²`. -/
theorem mean_sq_f_le (k : ℕ) (hk : 2 ≤ k) {X N : ℕ} (hX : 2 ≤ X) (hXN : X ≤ N) {u T : ℝ}
    (hu : 1 / 2 < u) (hu2 : u ≤ 2) (hT : 1 ≤ T) (hTN : T + 3 + k ≤ N) :
    ∫ t in (1:ℝ)..T, ‖f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2
      ≤ 3 * (T * (2 / (1 - (2:ℝ) ^ (1 - 2 * u))) * (X:ℝ) ^ (1 - 2 * u) * (1 + Real.log X) ^ 3
            + 24 * (1 + Real.log ((N * X : ℕ) : ℝ)) ^ 2 * (1 + Real.log X) ^ 3
                * max 1 (((N * X : ℕ) : ℝ) ^ (2 - 2 * u))
            + (X:ℝ) ^ 2 * (N:ℝ) ^ (2 - 2 * u)
            + T * (X:ℝ) ^ 2 * ZetaEM.emConst k ^ 2 * (N:ℝ) ^ (-2 * u)
                * (1 + (T + 2 + k) ^ k * (N:ℝ) ^ (1 - (k:ℝ))) ^ 2) := by
  have hN : 0 < N := by omega
  have hN0 : (0:ℝ) < N := by exact_mod_cast hN
  have hX0 : (0:ℝ) ≤ X := Nat.cast_nonneg _
  have hu0 : 0 < u := by linarith
  set s : ℝ → ℂ := fun t => (u : ℂ) + Complex.I * (t : ℂ) with hs
  set A : ℝ → ℂ := fun t =>
    ∑ n ∈ Icc 1 (N * X), (b X N n : ℂ) * (n : ℂ) ^ (-((u : ℂ) + Complex.I * (t : ℂ))) with hA
  set W : ℝ := 1 + (T + 2 + k) ^ k * (N:ℝ) ^ (1 - (k:ℝ)) with hW
  set cB : ℝ := (X:ℝ) ^ 2 * (N:ℝ) ^ (2 - 2 * u) with hcB
  set cC : ℝ := (X:ℝ) ^ 2 * ZetaEM.emConst k ^ 2 * (N:ℝ) ^ (-2 * u) * W ^ 2 with hcC
  have hW0 : 0 ≤ W := by positivity
  have hcB0 : 0 ≤ cB := by positivity
  have hcC0 : 0 ≤ cC := by positivity
  have hsc : Continuous s := by rw [hs]; fun_prop
  have hsre : ∀ t, (s t).re = u := fun t => by simp [hs]
  -- continuity of the Dirichlet sum and of `M`
  have hcpow : ∀ n : ℕ, 1 ≤ n → Continuous fun t : ℝ => (n : ℂ) ^ (-s t) := fun n hn =>
    Continuous.const_cpow hsc.neg (Or.inl (Nat.cast_ne_zero.2 (by omega)))
  have hAc : Continuous A := by
    rw [hA]
    exact continuous_finsetSum _ fun n hn =>
      continuous_const.mul (hcpow n (mem_Icc.1 hn).1)
  have hMc : Continuous fun t => M X (s t) := by
    unfold M
    exact continuous_finsetSum _ fun d hd =>
      continuous_const.mul (hcpow d (mem_Ico.1 hd).1)
  have hs1 : ∀ t : ℝ, 1 ≤ t → s t ≠ 1 := fun t ht h => by
    have := congrArg Complex.im h
    simp [hs] at this
    linarith
  have hfc : ContinuousOn (fun t => ‖f X (s t)‖ ^ 2) (Set.uIcc 1 T) := by
    refine continuousOn_of_forall_continuousAt fun t ht => ?_
    rw [Set.uIcc_of_le hT] at ht
    have hz : ContinuousAt (fun t => riemannZeta (s t)) t :=
      (differentiableAt_riemannZeta (hs1 t ht.1)).continuousAt.comp hsc.continuousAt
    unfold f
    exact ((hz.mul hMc.continuousAt).sub continuousAt_const).norm.pow 2
  have hpos : ∀ x ∈ Set.uIcc (1:ℝ) T, 0 < x := by
    intro x hx
    rw [Set.uIcc_of_le hT] at hx
    linarith [hx.1]
  have hinvc : ContinuousOn (fun x : ℝ => (x ^ 2)⁻¹) (Set.uIcc 1 T) :=
    (continuousOn_pow 2).inv₀ fun x hx => pow_ne_zero 2 (hpos x hx).ne'
  have iA : IntervalIntegrable (fun t => 3 * ‖A t‖ ^ 2) MeasureTheory.volume 1 T :=
    (continuous_const.mul (hAc.norm.pow 2)).intervalIntegrable _ _
  have iB : IntervalIntegrable (fun t : ℝ => 3 * cB * (t ^ 2)⁻¹) MeasureTheory.volume 1 T :=
    (continuousOn_const.mul hinvc).intervalIntegrable
  have iC : IntervalIntegrable (fun _ : ℝ => 3 * cC) MeasureTheory.volume 1 T :=
    intervalIntegrable_const
  -- the pointwise bound
  have hpt : ∀ t ∈ Set.Icc (1:ℝ) T,
      ‖f X (s t)‖ ^ 2 ≤ 3 * ‖A t‖ ^ 2 + 3 * cB * (t ^ 2)⁻¹ + 3 * cC := by
    intro t ht
    have ht0 : 0 < t := by linarith [ht.1]
    have hM := norm_M_le X (s := s t) (by rw [hsre]; exact hu0.le)
    have hsnorm : ‖s t‖ ≤ T + 2 := by
      calc ‖s t‖ ≤ ‖(u : ℂ)‖ + ‖Complex.I * (t : ℂ)‖ := norm_add_le _ _
        _ = |u| + |t| := by
            rw [norm_mul, Complex.norm_I, one_mul, Complex.norm_real, Complex.norm_real,
              Real.norm_eq_abs, Real.norm_eq_abs]
        _ ≤ T + 2 := by
            rw [abs_of_pos hu0, abs_of_pos ht0]
            linarith [ht.2]
    have hsN : ‖s t‖ + k ≤ N := by linarith
    have hE := ZetaEM.norm_zeta_sub_partial_le k hk hN (s := s t) (by rw [hsre]; exact hu0)
      (hs1 t ht.1) hsN
    rw [hsre] at hE
    have hEW : ZetaEM.emConst k * (N:ℝ) ^ (-u) * (1 + (‖s t‖ + k) ^ k * (N:ℝ) ^ (1 - (k:ℝ)))
        ≤ ZetaEM.emConst k * (N:ℝ) ^ (-u) * W := by
      refine mul_le_mul_of_nonneg_left ?_
        (mul_nonneg (emConst_nonneg k) (Real.rpow_nonneg hN0.le _))
      rw [hW]
      have : (‖s t‖ + k) ^ k ≤ (T + 2 + k) ^ k :=
        pow_le_pow_left₀ (by positivity) (by linarith) k
      have := mul_le_mul_of_nonneg_right this (Real.rpow_nonneg hN0.le (1 - (k:ℝ)))
      linarith
    have hS := norm_smooth_le hN u ht0
    rw [f_eq (s t) hX hXN]
    refine (norm_sq_add_three _ _ _).trans ?_
    have hB : ‖(-((N : ℂ) ^ (1 - s t) / (1 - s t))) * M X (s t)‖ ^ 2 ≤ cB * (t ^ 2)⁻¹ := by
      rw [norm_mul, norm_neg]
      have h1 : ‖(N : ℂ) ^ (1 - s t) / (1 - s t)‖ * ‖M X (s t)‖ ≤ (N:ℝ) ^ (1 - u) / t * X :=
        mul_le_mul hS hM (norm_nonneg _) (by positivity)
      have h2 := pow_le_pow_left₀ (by positivity) h1 2
      refine h2.trans (le_of_eq ?_)
      rw [hcB, show (2 : ℝ) - 2 * u = 2 * (1 - u) by ring, ← rpow_sq hN0.le]
      field_simp
      try ring
    have hC : ‖(riemannZeta (s t) - ∑ n ∈ Icc 1 N, (n : ℂ) ^ (-s t)
        + (N : ℂ) ^ (1 - s t) / (1 - s t)) * M X (s t)‖ ^ 2 ≤ cC := by
      rw [norm_mul]
      have h1 := mul_le_mul (hE.trans hEW) hM (norm_nonneg _)
        (mul_nonneg (mul_nonneg (emConst_nonneg k) (Real.rpow_nonneg hN0.le _)) hW0)
      have h2 := pow_le_pow_left₀ (by positivity) h1 2
      refine h2.trans (le_of_eq ?_)
      rw [hcC, show (-2 : ℝ) * u = 2 * (-u) by ring, ← rpow_sq hN0.le]
      ring
    have hAeq : ∑ n ∈ Icc 1 (N * X), (b X N n : ℂ) * (n : ℂ) ^ (-s t) = A t := rfl
    rw [hAeq]
    nlinarith
  have hmono := intervalIntegral.integral_mono_on hT (hfc.intervalIntegrable)
    ((iA.add iB).add iC) hpt
  have hsum : ∫ t in (1:ℝ)..T, (3 * ‖A t‖ ^ 2 + 3 * cB * (t ^ 2)⁻¹ + 3 * cC) =
      3 * (∫ t in (1:ℝ)..T, ‖A t‖ ^ 2) + 3 * cB * (∫ t in (1:ℝ)..T, (t ^ 2)⁻¹)
        + (T - 1) * (3 * cC) := by
    rw [intervalIntegral.integral_add (iA.add iB) iC, intervalIntegral.integral_add iA iB,
      intervalIntegral.integral_const_mul, intervalIntegral.integral_const_mul,
      intervalIntegral.integral_const, smul_eq_mul]
  rw [hsum] at hmono
  have hmain := mean_sq_main_le (N := N) (by omega : 1 ≤ X) hu hT
  have hinv := integral_inv_sq_le hT
  have hB' : 3 * cB * (∫ t in (1:ℝ)..T, (t ^ 2)⁻¹) ≤ 3 * cB := by nlinarith
  have hC' : (T - 1) * (3 * cC) ≤ 3 * (T * cC) := by nlinarith
  have hAA : (∫ t in (1:ℝ)..T, ‖A t‖ ^ 2) =
      ∫ t in (1:ℝ)..T,
        ‖∑ n ∈ Icc 1 (N * X), (b X N n : ℂ) * (n : ℂ) ^ (-((u : ℂ) + Complex.I * (t : ℂ)))‖ ^ 2 :=
    rfl
  have hcC' : T * cC = T * (X:ℝ) ^ 2 * ZetaEM.emConst k ^ 2 * (N:ℝ) ^ (-2 * u)
      * (1 + (T + 2 + k) ^ k * (N:ℝ) ^ (1 - (k:ℝ))) ^ 2 := by rw [hcC, hW]; ring
  rw [hAA] at hmono
  rw [← hcC']
  show ∫ t in (1:ℝ)..T, ‖f X (s t)‖ ^ 2 ≤ _
  linarith

/-- info: 'MollifiedMean.sum_coef_sq_up_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sum_coef_sq_up_le

/-- info: 'MollifiedMean.mean_sq_main_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mean_sq_main_le

/-- info: 'MollifiedMean.mean_sq_f_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mean_sq_f_le

end

end MollifiedMean
