/-
Mollified — block C2 of `lean_stage3/design/carlson.md`. 2026-11-23.

The product of the finite sum `P_N(s) = Σ_{n ≤ N} n^{-s}` with the short Möbius sum
`M_X(s) = Σ_{d < X} μ(d)·d^{-s}` is a finite Dirichlet sum `Σ_n c_n·n^{-s}` with
`c_n = Σ_{d | n, d < X, n/d ≤ N} μ(d)`. For `1 < n < X`, `n ≤ N` the coefficient vanishes and
`c_1 = 1`. Each `|c_n|` is at most the number of divisors of `n` below `X`. The square of that
count is at most the number of triples `(g, a, b)` below `X` with `g·a·b | n` (send a pair of
divisors to its gcd and cofactors), so its sum up to `Y` is at most `Y·(Σ_{k<X} 1/k)³`. Dyadic
blocks then bound the tail weighted by `n^{-2u}` for `u > 1/2`.

  tauBelow                  the number of divisors of `n` below `X`
  coef                      the coefficient of `n^{-s}` in `P_N·M_X`
  prod_eq_sum               P_N(s)·M_X(s) = Σ_{n ≤ N·X} coef·n^{-s}
  coef_one                  1 < X, 1 ≤ N ⊢ coef 1 = 1
  coef_eq_zero              1 < n < X, n ≤ N ⊢ coef n = 0
  abs_coef_le               |coef n| ≤ tauBelow X n
  card_Icc_dvd              #{n ∈ [1, Y] : k | n} = Y / k
  tauBelow_sq_le            tauBelow² ≤ #{(g, a, b) ∈ [1, X)³ : g·a·b | n}
  sum_inv_Ico_le            Σ_{1 ≤ k < X} 1/k ≤ 1 + log X
  sum_tauBelow_sq_le        Σ_{n ≤ Y} tauBelow² ≤ Y·(1 + log X)³
  coef_sq_le                coef² ≤ tauBelow²
  sum_coef_sq_le            Σ_{n ≤ Y} coef² ≤ Y·(1 + log X)³
  sum_Ico_dyadic            a sum over [X, 2^J·X) split into the J dyadic blocks
  sum_coef_sq_weighted_le   u > 1/2, 1 ≤ X ⊢ Σ_{X ≤ n ≤ Y} coef²·n^{-2u}
                              ≤ 2/(1 − 2^{1−2u})·X^{1−2u}·(1 + log X)³

What the next slice needs: `ζ` as a finite sum to any order (block C3), so that `ζ·M_X − 1`
on a vertical line is this Dirichlet sum minus its first term plus a small remainder. It is
not here.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Mathlib

namespace Mollified

open Finset

noncomputable section

/-- The number of divisors of `n` below `X`. -/
def tauBelow (X n : ℕ) : ℕ := ((Nat.divisors n).filter (· < X)).card

/-- The coefficient of `n^(−s)` in the product of `Σ_{m ≤ N} m^(−s)` and `Σ_{d < X} μ(d)d^(−s)`. -/
def coef (X N n : ℕ) : ℤ :=
  ∑ d ∈ (Nat.divisors n).filter (fun d => d < X ∧ n / d ≤ N), ArithmeticFunction.moebius d

/-- The product of the finite zeta sum up to `N` and the Möbius sum below `X` is the Dirichlet
sum over `n ≤ N·X` with coefficients `coef X N n`. -/
theorem prod_eq_sum (s : ℂ) (N X : ℕ) :
    (∑ m ∈ Icc 1 N, (m : ℂ) ^ (-s)) *
        (∑ d ∈ Ico 1 X, (ArithmeticFunction.moebius d : ℂ) * (d : ℂ) ^ (-s)) =
      ∑ n ∈ Icc 1 (N * X), (coef X N n : ℂ) * (n : ℂ) ^ (-s) := by
  have hR : ∀ n, (coef X N n : ℂ) * (n : ℂ) ^ (-s) =
      ∑ d ∈ (Nat.divisors n).filter (fun d => d < X ∧ n / d ≤ N),
        (ArithmeticFunction.moebius d : ℂ) * (n : ℂ) ^ (-s) := by
    intro n
    simp only [coef, Int.cast_sum, Finset.sum_mul]
  rw [sum_congr rfl fun n _ => hR n,
    Finset.sum_comm' (t' := Ico 1 X) (s' := fun d => (Icc 1 N).image (· * d))]
  · rw [sum_mul_sum, sum_comm]
    refine sum_congr rfl fun d hd => ?_
    have hd1 : 0 < d := (mem_Ico.1 hd).1
    rw [sum_image]
    · refine sum_congr rfl fun m _ => ?_
      push_cast
      rw [Complex.natCast_mul_natCast_cpow]
      ring
    · intro a _ b _ h
      exact Nat.eq_of_mul_eq_mul_right hd1 h
  · intro n d
    simp only [mem_Icc, mem_filter, Nat.mem_divisors, mem_image, mem_Ico]
    constructor
    · rintro ⟨⟨hn1, -⟩, ⟨⟨k, rfl⟩, hn0⟩, hdX, hkN⟩
      have hd0 : 0 < d := Nat.pos_of_ne_zero fun h => hn0 (by simp [h])
      have hk0 : 0 < k := Nat.pos_of_ne_zero fun h => hn0 (by simp [h])
      rw [Nat.mul_div_cancel_left k hd0] at hkN
      exact ⟨⟨k, ⟨hk0, hkN⟩, Nat.mul_comm k d⟩, hd0, hdX⟩
    · rintro ⟨⟨a, ⟨ha1, haN⟩, rfl⟩, hd1, hdX⟩
      rw [Nat.mul_div_cancel a hd1]
      refine ⟨⟨Nat.mul_pos ha1 hd1, Nat.mul_le_mul haN hdX.le⟩,
        ⟨Dvd.intro_left a rfl, (Nat.mul_pos ha1 hd1).ne'⟩, hdX, haN⟩

/-- The coefficient of `1^(−s)` is `1` once `1 < X` and `1 ≤ N`. -/
theorem coef_one (X N : ℕ) (hX : 1 < X) (hN : 1 ≤ N) : coef X N 1 = 1 := by
  rw [coef, Nat.divisors_one, filter_singleton, if_pos ⟨hX, by simpa using hN⟩]
  simp

/-- For `1 < n < X` with `n ≤ N` every divisor of `n` is allowed, so the coefficient is the
full Möbius divisor sum, which is `0`. -/
theorem coef_eq_zero (X N n : ℕ) (h1 : 1 < n) (hX : n < X) (hN : n ≤ N) : coef X N n = 0 := by
  have hfil : (Nat.divisors n).filter (fun d => d < X ∧ n / d ≤ N) = Nat.divisors n := by
    refine filter_true_of_mem fun d hd => ?_
    exact ⟨(Nat.divisor_le hd).trans_lt hX, (Nat.div_le_self n d).trans hN⟩
  have h := congrArg (fun f : ArithmeticFunction ℤ => f n)
    ArithmeticFunction.coe_zeta_mul_moebius
  simp only [ArithmeticFunction.coe_zeta_mul_apply,
    ArithmeticFunction.one_apply_ne (by omega : n ≠ 1)] at h
  rw [coef, hfil]
  exact h

/-- The coefficient is at most the number of divisors of `n` below `X` in absolute value. -/
theorem abs_coef_le (X N n : ℕ) : |coef X N n| ≤ tauBelow X n := by
  unfold coef tauBelow
  calc |∑ d ∈ (Nat.divisors n).filter (fun d => d < X ∧ n / d ≤ N),
          ArithmeticFunction.moebius d|
      ≤ ∑ d ∈ (Nat.divisors n).filter (fun d => d < X ∧ n / d ≤ N),
          |ArithmeticFunction.moebius d| := abs_sum_le_sum_abs _ _
    _ ≤ ∑ d ∈ (Nat.divisors n).filter (fun d => d < X ∧ n / d ≤ N), (1 : ℤ) :=
        sum_le_sum fun d _ => ArithmeticFunction.abs_moebius_le_one
    _ = (((Nat.divisors n).filter (fun d => d < X ∧ n / d ≤ N)).card : ℤ) := by simp
    _ ≤ _ := by
        exact_mod_cast card_le_card fun d hd => by
          simp only [mem_filter] at hd ⊢
          exact ⟨hd.1, hd.2.1⟩

/-- Exactly `Y / k` of the naturals in `[1, Y]` are multiples of `k`. -/
theorem card_Icc_dvd (Y k : ℕ) : ((Icc 1 Y).filter (k ∣ ·)).card = Y / k := by
  have : Icc 1 Y = Ioc 0 Y := by
    ext x
    simp only [mem_Icc, mem_Ioc]
    omega
  rw [this]
  exact Nat.Ioc_filter_dvd_card_eq_div Y k

/-- The triples of naturals in `[1, X)`. -/
def triples (X : ℕ) : Finset (ℕ × ℕ × ℕ) := Ico 1 X ×ˢ (Ico 1 X ×ˢ Ico 1 X)

/-- The square of the number of divisors of `n` below `X` is at most the number of triples
`(g, a, b)` in `[1, X)³` with `g·a·b` dividing `n`. -/
theorem tauBelow_sq_le (X n : ℕ) :
    tauBelow X n ^ 2 ≤ ((triples X).filter (fun t => t.1 * t.2.1 * t.2.2 ∣ n)).card := by
  rw [tauBelow, sq, ← card_product]
  refine card_le_card_of_injOn
    (fun p => (Nat.gcd p.1 p.2, p.1 / Nat.gcd p.1 p.2, p.2 / Nat.gcd p.1 p.2)) ?_ ?_
  · intro p hp
    simp only [mem_coe, mem_product, mem_filter, Nat.mem_divisors] at hp
    obtain ⟨⟨⟨h1, hn⟩, hX1⟩, ⟨⟨h2, -⟩, hX2⟩⟩ := hp
    have hp1 : 0 < p.1 := Nat.pos_of_dvd_of_pos h1 (Nat.pos_of_ne_zero hn)
    have hp2 : 0 < p.2 := Nat.pos_of_dvd_of_pos h2 (Nat.pos_of_ne_zero hn)
    have hg : 0 < Nat.gcd p.1 p.2 := Nat.gcd_pos_of_pos_left _ hp1
    have hg1 : Nat.gcd p.1 p.2 ≤ p.1 := Nat.le_of_dvd hp1 (Nat.gcd_dvd_left _ _)
    have hg2 : Nat.gcd p.1 p.2 ≤ p.2 := Nat.le_of_dvd hp2 (Nat.gcd_dvd_right _ _)
    have hlcm : Nat.gcd p.1 p.2 * (p.1 / Nat.gcd p.1 p.2) * (p.2 / Nat.gcd p.1 p.2) =
        Nat.lcm p.1 p.2 := by
      rw [Nat.mul_div_cancel' (Nat.gcd_dvd_left _ _), Nat.lcm,
        Nat.mul_div_assoc _ (Nat.gcd_dvd_right _ _)]
    simp only [triples, mem_coe, mem_filter, mem_product, mem_Ico]
    refine ⟨⟨⟨hg, hg1.trans_lt hX1⟩, ⟨Nat.div_pos hg1 hg, (Nat.div_le_self _ _).trans_lt hX1⟩,
      ⟨Nat.div_pos hg2 hg, (Nat.div_le_self _ _).trans_lt hX2⟩⟩, ?_⟩
    rw [hlcm]
    exact Nat.lcm_dvd h1 h2
  · intro p _ q _ h
    simp only [Prod.mk.injEq] at h
    obtain ⟨hg, h1, h2⟩ := h
    refine Prod.ext ?_ ?_
    · calc p.1 = Nat.gcd p.1 p.2 * (p.1 / Nat.gcd p.1 p.2) :=
            (Nat.mul_div_cancel' (Nat.gcd_dvd_left _ _)).symm
        _ = Nat.gcd q.1 q.2 * (q.1 / Nat.gcd q.1 q.2) := congrArg₂ (· * ·) hg h1
        _ = q.1 := Nat.mul_div_cancel' (Nat.gcd_dvd_left _ _)
    · calc p.2 = Nat.gcd p.1 p.2 * (p.2 / Nat.gcd p.1 p.2) :=
            (Nat.mul_div_cancel' (Nat.gcd_dvd_right _ _)).symm
        _ = Nat.gcd q.1 q.2 * (q.2 / Nat.gcd q.1 q.2) := congrArg₂ (· * ·) hg h2
        _ = q.2 := Nat.mul_div_cancel' (Nat.gcd_dvd_right _ _)

/-- The harmonic sum over `[1, X)` is at most `1 + log X`. -/
theorem sum_inv_Ico_le (X : ℕ) : ∑ k ∈ Ico 1 X, ((k : ℝ))⁻¹ ≤ 1 + Real.log X := by
  calc ∑ k ∈ Ico 1 X, ((k : ℝ))⁻¹ ≤ ∑ k ∈ Icc 1 X, ((k : ℝ))⁻¹ :=
        sum_le_sum_of_subset_of_nonneg Ico_subset_Icc_self (fun _ _ _ => by positivity)
    _ = (harmonic X : ℝ) := by simp [harmonic_eq_sum_Icc]
    _ ≤ _ := harmonic_le_one_add_log X

/-- The sum over `n ≤ Y` of the squared count of divisors of `n` below `X` is at most
`Y·(1 + log X)³`. -/
theorem sum_tauBelow_sq_le (X Y : ℕ) :
    ∑ n ∈ Icc 1 Y, (tauBelow X n : ℝ) ^ 2 ≤ Y * (1 + Real.log X) ^ 3 := by
  have h2 : ∑ n ∈ Icc 1 Y, ((triples X).filter (fun t => t.1 * t.2.1 * t.2.2 ∣ n)).card =
      ∑ t ∈ triples X, Y / (t.1 * t.2.1 * t.2.2) := by
    simp_rw [card_filter]
    rw [sum_comm]
    refine sum_congr rfl fun t _ => ?_
    rw [← card_Icc_dvd, card_filter]
  have hH := sum_inv_Ico_le X
  have hH0 : 0 ≤ ∑ k ∈ Ico 1 X, ((k : ℝ))⁻¹ := sum_nonneg fun _ _ => by positivity
  calc ∑ n ∈ Icc 1 Y, (tauBelow X n : ℝ) ^ 2
      ≤ ∑ n ∈ Icc 1 Y,
          ((((triples X).filter (fun t => t.1 * t.2.1 * t.2.2 ∣ n)).card : ℕ) : ℝ) :=
        sum_le_sum fun n _ => by exact_mod_cast tauBelow_sq_le X n
    _ = ∑ t ∈ triples X, ((Y / (t.1 * t.2.1 * t.2.2) : ℕ) : ℝ) := by
        rw [← Nat.cast_sum, h2, Nat.cast_sum]
    _ ≤ ∑ t ∈ triples X, (Y : ℝ) * (((t.1 : ℝ))⁻¹ * ((t.2.1 : ℝ))⁻¹ * ((t.2.2 : ℝ))⁻¹) :=
        sum_le_sum fun t _ => by
          refine Nat.cast_div_le.trans_eq ?_
          push_cast
          rw [div_eq_mul_inv, mul_inv, mul_inv]
    _ = Y * (∑ k ∈ Ico 1 X, ((k : ℝ))⁻¹) ^ 3 := by
        rw [← mul_sum]
        congr 1
        simp only [triples, sum_product, ← mul_sum, ← sum_mul]
        ring
    _ ≤ Y * (1 + Real.log X) ^ 3 := by gcongr

/-- The square of the coefficient is at most the square of the divisor count below `X`. -/
theorem coef_sq_le (X N n : ℕ) : (coef X N n : ℝ) ^ 2 ≤ (tauBelow X n : ℝ) ^ 2 := by
  have h : |(coef X N n : ℝ)| ≤ tauBelow X n := by exact_mod_cast abs_coef_le X N n
  rw [← sq_abs]
  exact pow_le_pow_left₀ (abs_nonneg _) h 2

/-- The sum over `n ≤ Y` of the squared coefficients is at most `Y·(1 + log X)³`. -/
theorem sum_coef_sq_le (X N Y : ℕ) :
    ∑ n ∈ Icc 1 Y, (coef X N n : ℝ) ^ 2 ≤ Y * (1 + Real.log X) ^ 3 :=
  (sum_le_sum fun n _ => coef_sq_le X N n).trans (sum_tauBelow_sq_le X Y)

/-- A sum over `[X, 2^J·X)` is the sum of its `J` dyadic blocks `[2^j·X, 2^(j+1)·X)`. -/
theorem sum_Ico_dyadic (f : ℕ → ℝ) (X J : ℕ) :
    ∑ n ∈ Ico X (2 ^ J * X), f n =
      ∑ j ∈ range J, ∑ n ∈ Ico (2 ^ j * X) (2 ^ (j + 1) * X), f n := by
  induction J with
  | zero => simp
  | succ J ih =>
    rw [sum_range_succ, ← ih, sum_Ico_consecutive]
    · exact Nat.le_mul_of_pos_left X (by positivity)
    · exact Nat.mul_le_mul_right X (Nat.pow_le_pow_right (by norm_num) (Nat.le_succ J))

/-- For `u > 1/2` and `1 ≤ X`, the squared coefficients weighted by `n^(−2u)` over `[X, Y]`
sum to at most `2/(1 − 2^(1−2u))·X^(1−2u)·(1 + log X)³`, for every `Y`. -/
theorem sum_coef_sq_weighted_le (u : ℝ) (hu : 1 / 2 < u) (X N Y : ℕ) (hX : 1 ≤ X) :
    ∑ n ∈ Icc X Y, (coef X N n : ℝ) ^ 2 * (n : ℝ) ^ (-2 * u) ≤
      2 / (1 - (2 : ℝ) ^ (1 - 2 * u)) * (X : ℝ) ^ (1 - 2 * u) * (1 + Real.log X) ^ 3 := by
  set L := (1 + Real.log X) ^ 3 with hL
  set q := (2 : ℝ) ^ (1 - 2 * u) with hq
  have hq0 : 0 ≤ q := Real.rpow_nonneg (by norm_num) _
  have hq1 : q < 1 := Real.rpow_lt_one_of_one_lt_of_neg (by norm_num) (by linarith)
  have hXpos : (0 : ℝ) < X := by exact_mod_cast hX
  have hL0 : 0 ≤ L := pow_nonneg (by have := Real.log_natCast_nonneg X; linarith) 3
  let f : ℕ → ℝ := fun n => (coef X N n : ℝ) ^ 2 * (n : ℝ) ^ (-2 * u)
  have hf0 : ∀ n, 0 ≤ f n := fun n =>
    mul_nonneg (sq_nonneg _) (Real.rpow_nonneg (Nat.cast_nonneg _) _)
  have h1 : ∑ n ∈ Icc X Y, f n ≤ ∑ n ∈ Ico X (2 ^ Y * X), f n := by
    refine sum_le_sum_of_subset_of_nonneg ?_ (fun n _ _ => hf0 n)
    intro n hn
    rw [mem_Icc] at hn
    rw [mem_Ico]
    refine ⟨hn.1, lt_of_le_of_lt hn.2 ?_⟩
    calc Y < 2 ^ Y := Nat.lt_two_pow_self
      _ ≤ 2 ^ Y * X := Nat.le_mul_of_pos_right _ hX
  have h2 : ∀ j, ∑ n ∈ Ico (2 ^ j * X) (2 ^ (j + 1) * X), f n ≤
      2 * (X : ℝ) ^ (1 - 2 * u) * L * q ^ j := by
    intro j
    have hjX : 1 ≤ 2 ^ j * X := Nat.one_le_iff_ne_zero.2 (by positivity)
    have hy : (0 : ℝ) < ((2 ^ j * X : ℕ) : ℝ) := by exact_mod_cast hjX
    have hsub : Ico (2 ^ j * X) (2 ^ (j + 1) * X) ⊆ Icc 1 (2 ^ (j + 1) * X) := by
      intro n hn
      simp only [mem_Ico, mem_Icc] at hn ⊢
      omega
    calc ∑ n ∈ Ico (2 ^ j * X) (2 ^ (j + 1) * X), f n
        ≤ ∑ n ∈ Ico (2 ^ j * X) (2 ^ (j + 1) * X),
            (coef X N n : ℝ) ^ 2 * ((2 ^ j * X : ℕ) : ℝ) ^ (-2 * u) := by
          refine sum_le_sum fun n hn => ?_
          refine mul_le_mul_of_nonneg_left ?_ (sq_nonneg _)
          exact Real.rpow_le_rpow_of_nonpos hy (by exact_mod_cast (mem_Ico.1 hn).1)
            (by linarith)
      _ = (∑ n ∈ Ico (2 ^ j * X) (2 ^ (j + 1) * X), (coef X N n : ℝ) ^ 2) *
            ((2 ^ j * X : ℕ) : ℝ) ^ (-2 * u) := by rw [sum_mul]
      _ ≤ (∑ n ∈ Icc 1 (2 ^ (j + 1) * X), (coef X N n : ℝ) ^ 2) *
            ((2 ^ j * X : ℕ) : ℝ) ^ (-2 * u) :=
          mul_le_mul_of_nonneg_right
            (sum_le_sum_of_subset_of_nonneg hsub (fun _ _ _ => sq_nonneg _))
            (Real.rpow_nonneg hy.le _)
      _ ≤ (((2 ^ (j + 1) * X : ℕ) : ℝ) * L) * ((2 ^ j * X : ℕ) : ℝ) ^ (-2 * u) :=
          mul_le_mul_of_nonneg_right (sum_coef_sq_le X N _) (Real.rpow_nonneg hy.le _)
      _ = 2 * (X : ℝ) ^ (1 - 2 * u) * L * q ^ j := by
          push_cast
          rw [Real.mul_rpow (by positivity) hXpos.le,
            ← Real.rpow_pow_comm (by norm_num : (0 : ℝ) ≤ 2), hq,
            show (1 : ℝ) - 2 * u = 1 + (-2 * u) by ring,
            Real.rpow_add (by norm_num : (0 : ℝ) < 2), Real.rpow_add hXpos,
            Real.rpow_one, Real.rpow_one, mul_pow, pow_succ]
          ring
  show ∑ n ∈ Icc X Y, f n ≤ _
  calc ∑ n ∈ Icc X Y, f n ≤ ∑ n ∈ Ico X (2 ^ Y * X), f n := h1
    _ = ∑ j ∈ range Y, ∑ n ∈ Ico (2 ^ j * X) (2 ^ (j + 1) * X), f n := sum_Ico_dyadic f X Y
    _ ≤ ∑ j ∈ range Y, 2 * (X : ℝ) ^ (1 - 2 * u) * L * q ^ j := sum_le_sum fun j _ => h2 j
    _ = 2 * (X : ℝ) ^ (1 - 2 * u) * L * ∑ j ∈ range Y, q ^ j := by rw [mul_sum]
    _ ≤ 2 * (X : ℝ) ^ (1 - 2 * u) * L * (1 - q)⁻¹ := by
        have hc : 0 ≤ 2 * (X : ℝ) ^ (1 - 2 * u) * L :=
          mul_nonneg (mul_nonneg (by norm_num) (Real.rpow_nonneg hXpos.le _)) hL0
        refine mul_le_mul_of_nonneg_left ?_ hc
        rw [← tsum_geometric_of_lt_one hq0 hq1]
        exact (summable_geometric_of_lt_one hq0 hq1).sum_le_tsum _
          (fun j _ => pow_nonneg hq0 j)
    _ = 2 / (1 - q) * (X : ℝ) ^ (1 - 2 * u) * L := by ring

/-- info: 'Mollified.prod_eq_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms prod_eq_sum

/-- info: 'Mollified.sum_coef_sq_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sum_coef_sq_le

/--
info: 'Mollified.sum_coef_sq_weighted_le' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs in
#print axioms sum_coef_sq_weighted_le

end

end Mollified
