/-
ZeroDensity — block C6 of `lean_stage3/design/carlson.md`. 2026-11-23.

The zero-density bound with a power saving. Fix `σ > 1/2` and put `δ = (σ − 1/2)/4`. For a
height `T` take `X = ⌈T^δ⌉₊`, `N = ⌈T^(1+δ)⌉₊` and the order `k = ⌈1/δ⌉₊ + 1`. On every line
`u ∈ (σ − δ, 1 + δ]` the four terms of `MollifiedMean.mean_sq_f_le` are each at most a constant
times `T^(1 − 6δ²)·(1 + log T)^5`. Integrating over `u` and feeding the result to
`ZeroSquares.card_zeros_le` bounds the number of zeros by a constant times
`T^(1 − 6δ²)·(1 + log T)^6`, and `1 + log T ≤ (1 + 6/δ²)·T^(δ²/6)` turns this into
`C·T^(1 − 5δ²)`.

  ceil_bounds      for `y ≥ 1`, `y ≤ ⌈y⌉₊ ≤ 2y`
  one_add_log_le   for `T ≥ 1`, `ε > 0`, `1 + log T ≤ (1 + 1/ε)·T^ε`
  sq_rpow_le       `X ≤ 2·T^δ` gives `X² ≤ 4·T^(2δ)`
  term1_le         the diagonal term is at most `T·c₁·T^(−6δ²)·L³`
  term2_le         the off-diagonal term is at most `24·(4L)²·(2L)³·4·T^(1−4δ)`
  term3_le         the term `X²·N^(2−2u)` is at most `8·T^(1−3δ)`
  term4_le         the Euler–Maclaurin remainder term is at most `4·A_k²·(1 + 2^k)²·T^δ`
  bConst           the constant `B(δ, k)` of the mean-square bound
  bConst_nonneg    `0 ≤ B(δ, k)`
  inner_le         `∫_1^T ‖f X (u + i t)‖² ≤ B·T^(1−6δ²)·(1 + log T)^5` on each line
  zero_density     `#Z ≤ C·T^θ` with `θ = 1 − 5δ² < 1`, `δ = (σ − 1/2)/4`

What the next slice needs: the dyadic summation of block C6, `Σ_{Re ρ ≥ σ} m(ρ)/|ρ| < ∞`, from
`zero_density` on the blocks `[2^j, 2^(j+1)]`, with the multiplicities `m(ρ)` counted. It is
not here.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Mathlib
import Stage3.ZeroSquares

namespace ZeroDensity

open MeasureTheory Set

noncomputable section

/-- For `y ≥ 1` the ceiling `⌈y⌉₊` lies between `y` and `2y`. -/
theorem ceil_bounds {y : ℝ} (hy : 1 ≤ y) : y ≤ (⌈y⌉₊ : ℝ) ∧ (⌈y⌉₊ : ℝ) ≤ 2 * y := by
  refine ⟨Nat.le_ceil y, ?_⟩
  have := Nat.ceil_lt_add_one (by linarith : (0:ℝ) ≤ y)
  linarith

/-- For `T ≥ 1` and `ε > 0`, the quantity `1 + log T` is at most `(1 + 1/ε)·T^ε`. -/
theorem one_add_log_le {T ε : ℝ} (hT : 1 ≤ T) (hε : 0 < ε) :
    1 + Real.log T ≤ (1 + 1 / ε) * T ^ ε := by
  have h1 := Real.log_le_rpow_div (by linarith : (0:ℝ) ≤ T) hε
  have h2 : 1 ≤ T ^ ε := Real.one_le_rpow hT hε.le
  have h3 : T ^ ε / ε = 1 / ε * T ^ ε := by ring
  have h4 : (1 + 1 / ε) * T ^ ε = T ^ ε + 1 / ε * T ^ ε := by ring
  rw [h4]
  linarith

/-- For `T > 0`, the bound `X ≤ 2·T^δ` gives `X² ≤ 4·T^(2δ)`. -/
theorem sq_rpow_le {δ T : ℝ} {X : ℕ} (hT0 : 0 < T) (hX2 : (X:ℝ) ≤ 2 * T ^ δ) :
    (X:ℝ) ^ 2 ≤ 4 * T ^ (2 * δ) := by
  have h := pow_le_pow_left₀ (Nat.cast_nonneg X) hX2 2
  have e2 : (T ^ δ) ^ 2 = T ^ (2 * δ) := by
    rw [← Real.rpow_natCast (T ^ δ) 2, ← Real.rpow_mul hT0.le]
    congr 1
    push_cast
    ring
  have e : (2 * T ^ δ) ^ 2 = 4 * T ^ (2 * δ) := by
    rw [mul_pow, e2]
    norm_num
  linarith

/-- The diagonal term of `MollifiedMean.mean_sq_f_le` on a line with `2u − 1 ≥ 6δ`, when
`X ≥ T^δ`, is at most `T·(2/(1 − 2^(−6δ)))·T^(−6δ²)·L³`, where `L` bounds `1 + log X`. -/
theorem term1_le {δ T u L : ℝ} {X : ℕ} (hδ : 0 < δ) (hT : 1 ≤ T) (hu : 6 * δ ≤ 2 * u - 1)
    (hX : T ^ δ ≤ X) (hL : 1 + Real.log X ≤ L) :
    T * (2 / (1 - (2:ℝ) ^ (1 - 2 * u))) * (X:ℝ) ^ (1 - 2 * u) * (1 + Real.log X) ^ 3
      ≤ T * (2 / (1 - (2:ℝ) ^ (-(6 * δ)))) * T ^ (-(6 * δ ^ 2)) * L ^ 3 := by
  have hT0 : (0:ℝ) ≤ T := by linarith
  have h2 : (2:ℝ) ^ (1 - 2 * u) ≤ (2:ℝ) ^ (-(6 * δ)) :=
    Real.rpow_le_rpow_of_exponent_le (by norm_num) (by linarith)
  have h2lt : (2:ℝ) ^ (-(6 * δ)) < 1 :=
    Real.rpow_lt_one_of_one_lt_of_neg (by norm_num) (by linarith)
  have hden : 0 < 1 - (2:ℝ) ^ (-(6 * δ)) := by linarith
  have hA : 2 / (1 - (2:ℝ) ^ (1 - 2 * u)) ≤ 2 / (1 - (2:ℝ) ^ (-(6 * δ))) :=
    div_le_div_of_nonneg_left (by norm_num) hden (by linarith)
  have hTd : 1 ≤ T ^ δ := Real.one_le_rpow hT hδ.le
  have hX1 : (1:ℝ) ≤ X := hTd.trans hX
  have hB : (X:ℝ) ^ (1 - 2 * u) ≤ T ^ (-(6 * δ ^ 2)) := by
    calc (X:ℝ) ^ (1 - 2 * u) ≤ (X:ℝ) ^ (-(6 * δ)) :=
          Real.rpow_le_rpow_of_exponent_le hX1 (by linarith)
      _ ≤ (T ^ δ) ^ (-(6 * δ)) :=
          Real.rpow_le_rpow_of_nonpos (by linarith) hX (by linarith)
      _ = T ^ (-(6 * δ ^ 2)) := by
          rw [← Real.rpow_mul hT0]
          congr 1
          ring
  have hlog0 : 0 ≤ 1 + Real.log X := by
    have := Real.log_nonneg hX1
    linarith
  have hC : (1 + Real.log X) ^ 3 ≤ L ^ 3 := pow_le_pow_left₀ hlog0 hL 3
  have hc1 : 0 ≤ T * (2 / (1 - (2:ℝ) ^ (-(6 * δ)))) :=
    mul_nonneg hT0 (div_nonneg (by norm_num) hden.le)
  have s1 := mul_le_mul_of_nonneg_left hA hT0
  have s2 := mul_le_mul s1 hB (Real.rpow_nonneg (Nat.cast_nonneg X) _) hc1
  exact mul_le_mul s2 hC (pow_nonneg hlog0 3) (mul_nonneg hc1 (Real.rpow_nonneg hT0 _))

/-- The off-diagonal term of `MollifiedMean.mean_sq_f_le` on a line with `2u − 1 ≥ 6δ`, when
`N·X ≤ 4·T^(1+2δ)`, is at most `24·(4L)²·(2L)³·4·T^(1−4δ)`. -/
theorem term2_le {δ T u L : ℝ} {X N : ℕ} (hδ : 0 < δ) (hδ8 : δ ≤ 1 / 8) (hT : 1 ≤ T)
    (hu : 6 * δ ≤ 2 * u - 1) (hX1 : 1 ≤ X) (hN1 : 1 ≤ N)
    (hNX : ((N * X : ℕ) : ℝ) ≤ 4 * T ^ (1 + 2 * δ))
    (hL1 : 1 + Real.log X ≤ 2 * L) (hL2 : 1 + Real.log ((N * X : ℕ) : ℝ) ≤ 4 * L)
    (hL0 : 0 ≤ L) :
    24 * (1 + Real.log ((N * X : ℕ) : ℝ)) ^ 2 * (1 + Real.log X) ^ 3
        * max 1 (((N * X : ℕ) : ℝ) ^ (2 - 2 * u))
      ≤ 24 * (4 * L) ^ 2 * (2 * L) ^ 3 * (4 * T ^ (1 - 4 * δ)) := by
  have hT0 : (0:ℝ) ≤ T := by linarith
  have hNX1 : 1 ≤ N * X := Nat.mul_pos (by omega) (by omega)
  have hP1 : (1:ℝ) ≤ ((N * X : ℕ) : ℝ) := by exact_mod_cast hNX1
  have hmax : max 1 (((N * X : ℕ) : ℝ) ^ (2 - 2 * u)) ≤ ((N * X : ℕ) : ℝ) ^ (1 - 6 * δ) :=
    max_le (Real.one_le_rpow hP1 (by linarith)) (Real.rpow_le_rpow_of_exponent_le hP1 (by linarith))
  have h4 : (4:ℝ) ^ (1 - 6 * δ) ≤ 4 := by
    calc (4:ℝ) ^ (1 - 6 * δ) ≤ (4:ℝ) ^ (1:ℝ) :=
          Real.rpow_le_rpow_of_exponent_le (by norm_num) (by linarith)
      _ = 4 := Real.rpow_one 4
  have hP2 : ((N * X : ℕ) : ℝ) ^ (1 - 6 * δ) ≤ 4 * T ^ (1 - 4 * δ) := by
    calc ((N * X : ℕ) : ℝ) ^ (1 - 6 * δ) ≤ (4 * T ^ (1 + 2 * δ)) ^ (1 - 6 * δ) :=
          Real.rpow_le_rpow (by linarith) hNX (by linarith)
      _ = (4:ℝ) ^ (1 - 6 * δ) * T ^ ((1 + 2 * δ) * (1 - 6 * δ)) := by
          rw [Real.mul_rpow (by norm_num) (Real.rpow_nonneg hT0 _), ← Real.rpow_mul hT0]
      _ ≤ 4 * T ^ (1 - 4 * δ) :=
          mul_le_mul h4 (Real.rpow_le_rpow_of_exponent_le hT (by nlinarith))
            (Real.rpow_nonneg hT0 _) (by norm_num)
  have hl1 : 0 ≤ 1 + Real.log X := by
    have := Real.log_nonneg (by exact_mod_cast hX1 : (1:ℝ) ≤ X)
    linarith
  have hl2 : 0 ≤ 1 + Real.log ((N * X : ℕ) : ℝ) := by
    have := Real.log_nonneg hP1
    linarith
  have hA : (1 + Real.log ((N * X : ℕ) : ℝ)) ^ 2 ≤ (4 * L) ^ 2 := pow_le_pow_left₀ hl2 hL2 2
  have hB : (1 + Real.log X) ^ 3 ≤ (2 * L) ^ 3 := pow_le_pow_left₀ hl1 hL1 3
  have s1 := mul_le_mul_of_nonneg_left hA (by norm_num : (0:ℝ) ≤ 24)
  have s2 := mul_le_mul s1 hB (pow_nonneg hl1 3) (by positivity)
  have hb : 0 ≤ 24 * (4 * L) ^ 2 * (2 * L) ^ 3 :=
    mul_nonneg (by positivity) (pow_nonneg (by linarith) 3)
  exact mul_le_mul s2 (hmax.trans hP2) (zero_le_one.trans (le_max_left _ _)) hb

/-- The term `X²·N^(2−2u)` of `MollifiedMean.mean_sq_f_le` on a line with `2u − 1 ≥ 6δ`, when
`X ≤ 2·T^δ` and `N ≤ 2·T^(1+δ)`, is at most `8·T^(1−3δ)`. -/
theorem term3_le {δ T u : ℝ} {X N : ℕ} (hδ : 0 < δ) (hδ8 : δ ≤ 1 / 8) (hT : 1 ≤ T)
    (hu : 6 * δ ≤ 2 * u - 1) (hX2 : (X:ℝ) ≤ 2 * T ^ δ) (hN1 : (1:ℝ) ≤ N)
    (hN2 : (N:ℝ) ≤ 2 * T ^ (1 + δ)) :
    (X:ℝ) ^ 2 * (N:ℝ) ^ (2 - 2 * u) ≤ 8 * T ^ (1 - 3 * δ) := by
  have hT0 : 0 < T := by linarith
  have hXsq := sq_rpow_le hT0 hX2
  have h2 : (2:ℝ) ^ (1 - 6 * δ) ≤ 2 := by
    calc (2:ℝ) ^ (1 - 6 * δ) ≤ (2:ℝ) ^ (1:ℝ) :=
          Real.rpow_le_rpow_of_exponent_le (by norm_num) (by linarith)
      _ = 2 := Real.rpow_one 2
  have hNu : (N:ℝ) ^ (2 - 2 * u) ≤ 2 * T ^ ((1 + δ) * (1 - 6 * δ)) := by
    calc (N:ℝ) ^ (2 - 2 * u) ≤ (N:ℝ) ^ (1 - 6 * δ) :=
          Real.rpow_le_rpow_of_exponent_le hN1 (by linarith)
      _ ≤ (2 * T ^ (1 + δ)) ^ (1 - 6 * δ) := Real.rpow_le_rpow (by linarith) hN2 (by linarith)
      _ = (2:ℝ) ^ (1 - 6 * δ) * T ^ ((1 + δ) * (1 - 6 * δ)) := by
          rw [Real.mul_rpow (by norm_num) (Real.rpow_nonneg hT0.le _), ← Real.rpow_mul hT0.le]
      _ ≤ 2 * T ^ ((1 + δ) * (1 - 6 * δ)) :=
          mul_le_mul_of_nonneg_right h2 (Real.rpow_nonneg hT0.le _)
  have hprod := mul_le_mul hXsq hNu (Real.rpow_nonneg (Nat.cast_nonneg N) _) (by positivity)
  have e : 4 * T ^ (2 * δ) * (2 * T ^ ((1 + δ) * (1 - 6 * δ)))
      = 8 * T ^ (2 * δ + (1 + δ) * (1 - 6 * δ)) := by
    rw [Real.rpow_add hT0]
    ring
  have hexp : T ^ (2 * δ + (1 + δ) * (1 - 6 * δ)) ≤ T ^ (1 - 3 * δ) :=
    Real.rpow_le_rpow_of_exponent_le hT (by nlinarith)
  linarith

/-- The Euler–Maclaurin remainder term of `MollifiedMean.mean_sq_f_le`, when `δ·(k − 1) ≥ 1`,
`X ≤ 2·T^δ`, `N ≥ T^(1+δ)` and `T + 2 + k ≤ 2T`, is at most `4·E²·(1 + 2^k)²·T^δ`. -/
theorem term4_le {δ T u E : ℝ} {k X N : ℕ} (hδ : 0 < δ) (hT : 1 ≤ T)
    (hk : 1 ≤ δ * ((k:ℝ) - 1)) (hTk : T + 2 + k ≤ 2 * T) (hu : 1 / 2 ≤ u)
    (hX2 : (X:ℝ) ≤ 2 * T ^ δ) (hN : T ^ (1 + δ) ≤ N) :
    T * (X:ℝ) ^ 2 * E ^ 2 * (N:ℝ) ^ (-2 * u)
        * (1 + (T + 2 + k) ^ k * (N:ℝ) ^ (1 - (k:ℝ))) ^ 2
      ≤ 4 * E ^ 2 * (1 + 2 ^ k) ^ 2 * T ^ δ := by
  have hT0 : 0 < T := by linarith
  have hTd1 : 1 ≤ T ^ (1 + δ) := Real.one_le_rpow hT (by linarith)
  have hN1 : (1:ℝ) ≤ N := hTd1.trans hN
  have hN0 : (0:ℝ) < N := by linarith
  have hXsq := sq_rpow_le hT0 hX2
  have hNu : (N:ℝ) ^ (-2 * u) ≤ T ^ (-(1 + δ)) := by
    calc (N:ℝ) ^ (-2 * u) ≤ (N:ℝ) ^ (-1:ℝ) :=
          Real.rpow_le_rpow_of_exponent_le hN1 (by linarith)
      _ ≤ (T ^ (1 + δ)) ^ (-1:ℝ) := Real.rpow_le_rpow_of_nonpos (by linarith) hN (by norm_num)
      _ = T ^ (-(1 + δ)) := by
          rw [← Real.rpow_mul hT0.le]
          congr 1
          ring
  have hk1 : 1 - (k:ℝ) ≤ 0 := by nlinarith
  have hW : (T + 2 + k) ^ k * (N:ℝ) ^ (1 - (k:ℝ)) ≤ 2 ^ k := by
    have a1 : (T + 2 + k) ^ k ≤ (2 * T) ^ k := pow_le_pow_left₀ (by positivity) hTk k
    have a2 : (N:ℝ) ^ (1 - (k:ℝ)) ≤ T ^ ((1 + δ) * (1 - k)) := by
      calc (N:ℝ) ^ (1 - (k:ℝ)) ≤ (T ^ (1 + δ)) ^ (1 - (k:ℝ)) :=
            Real.rpow_le_rpow_of_nonpos (by linarith) hN hk1
        _ = T ^ ((1 + δ) * (1 - k)) := by rw [← Real.rpow_mul hT0.le]
    have a3 : (2 * T) ^ k * T ^ ((1 + δ) * (1 - k))
        = 2 ^ k * T ^ ((k:ℝ) + (1 + δ) * (1 - k)) := by
      rw [mul_pow, Real.rpow_add hT0, Real.rpow_natCast]
      ring
    have a4 : T ^ ((k:ℝ) + (1 + δ) * (1 - k)) ≤ 1 :=
      Real.rpow_le_one_of_one_le_of_nonpos hT (by nlinarith)
    calc (T + 2 + k) ^ k * (N:ℝ) ^ (1 - (k:ℝ)) ≤ (2 * T) ^ k * T ^ ((1 + δ) * (1 - k)) :=
          mul_le_mul a1 a2 (Real.rpow_nonneg hN0.le _) (by positivity)
      _ = 2 ^ k * T ^ ((k:ℝ) + (1 + δ) * (1 - k)) := a3
      _ ≤ 2 ^ k * 1 := mul_le_mul_of_nonneg_left a4 (by positivity)
      _ = 2 ^ k := mul_one _
  have hW0 : 0 ≤ (T + 2 + k) ^ k * (N:ℝ) ^ (1 - (k:ℝ)) :=
    mul_nonneg (pow_nonneg (by positivity) _) (Real.rpow_nonneg hN0.le _)
  have hWsq : (1 + (T + 2 + k) ^ k * (N:ℝ) ^ (1 - (k:ℝ))) ^ 2 ≤ (1 + 2 ^ k) ^ 2 :=
    pow_le_pow_left₀ (by linarith) (by linarith) 2
  have hTX : T * (X:ℝ) ^ 2 * (N:ℝ) ^ (-2 * u) ≤ 4 * T ^ δ := by
    have h := mul_le_mul (mul_le_mul_of_nonneg_left hXsq hT0.le) hNu
      (Real.rpow_nonneg hN0.le _) (by positivity)
    have e : T * (4 * T ^ (2 * δ)) * T ^ (-(1 + δ)) = 4 * T ^ δ := by
      have e1 : T * (4 * T ^ (2 * δ)) * T ^ (-(1 + δ))
          = 4 * (T ^ (1:ℝ) * T ^ (2 * δ) * T ^ (-(1 + δ))) := by
        rw [Real.rpow_one]
        ring
      rw [e1, ← Real.rpow_add hT0, ← Real.rpow_add hT0]
      rw [show (1:ℝ) + 2 * δ + -(1 + δ) = δ by ring]
    linarith
  have e : T * (X:ℝ) ^ 2 * E ^ 2 * (N:ℝ) ^ (-2 * u)
        * (1 + (T + 2 + k) ^ k * (N:ℝ) ^ (1 - (k:ℝ))) ^ 2
      = (T * (X:ℝ) ^ 2 * (N:ℝ) ^ (-2 * u)) * E ^ 2
        * (1 + (T + 2 + k) ^ k * (N:ℝ) ^ (1 - (k:ℝ))) ^ 2 := by ring
  rw [e]
  have h := mul_le_mul (mul_le_mul_of_nonneg_right hTX (sq_nonneg E)) hWsq (sq_nonneg _)
    (mul_nonneg (by positivity) (sq_nonneg E))
  calc (T * (X:ℝ) ^ 2 * (N:ℝ) ^ (-2 * u)) * E ^ 2
        * (1 + (T + 2 + k) ^ k * (N:ℝ) ^ (1 - (k:ℝ))) ^ 2
      ≤ 4 * T ^ δ * E ^ 2 * (1 + 2 ^ k) ^ 2 := h
    _ = 4 * E ^ 2 * (1 + 2 ^ k) ^ 2 * T ^ δ := by ring

/-- The constant `B(δ, k)` of the mean-square bound `inner_le`. -/
def bConst (δ : ℝ) (k : ℕ) : ℝ :=
  3 * (8 * (2 / (1 - (2:ℝ) ^ (-(6 * δ)))) + 12296
    + 4 * ZetaEM.emConst k ^ 2 * (1 + 2 ^ k) ^ 2)

/-- For `δ > 0` the constant `B(δ, k)` is nonnegative. -/
theorem bConst_nonneg {δ : ℝ} (hδ : 0 < δ) (k : ℕ) : 0 ≤ bConst δ k := by
  have h2lt : (2:ℝ) ^ (-(6 * δ)) < 1 :=
    Real.rpow_lt_one_of_one_lt_of_neg (by norm_num) (by linarith)
  have h1 : 0 ≤ 2 / (1 - (2:ℝ) ^ (-(6 * δ))) := div_nonneg (by norm_num) (by linarith)
  have h3 : 0 ≤ 4 * ZetaEM.emConst k ^ 2 * (1 + 2 ^ k) ^ 2 := by positivity
  unfold bConst
  linarith

/-- On a line `u` with `2u − 1 ≥ 6δ` and `u ≤ 2`, with `X` and `N` within a factor two of
`T^δ` and `T^(1+δ)`, the mean square `∫_1^T ‖f X (u + i t)‖²` is at most
`B(δ, k)·T^(1−6δ²)·(1 + log T)^5`. -/
theorem inner_le {δ T u : ℝ} {k X N : ℕ} (hδ : 0 < δ) (hδ8 : δ ≤ 1 / 8) (hk2 : 2 ≤ k)
    (hk : 1 ≤ δ * ((k:ℝ) - 1)) (hT2 : 2 ≤ T) (hTk : (k:ℝ) + 2 ≤ T)
    (hX : T ^ δ ≤ X) (hX2 : (X:ℝ) ≤ 2 * T ^ δ) (hN : T ^ (1 + δ) ≤ N)
    (hN2 : (N:ℝ) ≤ 2 * T ^ (1 + δ)) (hX2' : 2 ≤ X) (hXN : X ≤ N) (hTN : T + 3 + k ≤ N)
    (hu : 6 * δ ≤ 2 * u - 1) (hu2 : u ≤ 2) :
    ∫ t in (1:ℝ)..T, ‖MollifiedMean.f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2
      ≤ bConst δ k * T ^ (1 - 6 * δ ^ 2) * (1 + Real.log T) ^ 5 := by
  have hd2 : δ ^ 2 ≤ δ / 8 := by nlinarith
  have hT1 : (1:ℝ) ≤ T := by linarith
  have hT0 : 0 < T := by linarith
  have hlogT : 0 ≤ Real.log T := Real.log_nonneg hT1
  have hX1 : (1:ℝ) ≤ X := by exact_mod_cast (by omega : 1 ≤ X)
  have hX0 : (0:ℝ) < X := by linarith
  have hN1 : (1:ℝ) ≤ N := by exact_mod_cast (by omega : 1 ≤ N)
  have hTd : T ^ δ ≤ T := by
    calc T ^ δ ≤ T ^ (1:ℝ) := Real.rpow_le_rpow_of_exponent_le hT1 (by linarith)
      _ = T := Real.rpow_one T
  have hNX : ((N * X : ℕ) : ℝ) ≤ 4 * T ^ (1 + 2 * δ) := by
    have e : T ^ (1 + 2 * δ) = T ^ (1 + δ) * T ^ δ := by
      rw [← Real.rpow_add hT0]
      congr 1
      ring
    push_cast
    rw [e]
    have := mul_le_mul hN2 hX2 (by linarith) (by positivity)
    linarith
  have hlX : 1 + Real.log X ≤ 2 * (1 + Real.log T) := by
    have h1 : (X:ℝ) ≤ T ^ 2 := by nlinarith
    have h2 := Real.log_le_log hX0 h1
    rw [Real.log_pow] at h2
    push_cast at h2
    linarith
  have hlNX : 1 + Real.log ((N * X : ℕ) : ℝ) ≤ 4 * (1 + Real.log T) := by
    have hP0 : (0:ℝ) < ((N * X : ℕ) : ℝ) := by push_cast; positivity
    have hT2d : T ^ (1 + 2 * δ) ≤ T ^ 2 := by
      calc T ^ (1 + 2 * δ) ≤ T ^ (2:ℝ) := Real.rpow_le_rpow_of_exponent_le hT1 (by linarith)
        _ = T ^ 2 := Real.rpow_two T
    have hT4 : (4:ℝ) ≤ T ^ 2 := by nlinarith
    have hT44 : 4 * T ^ 2 ≤ T ^ 4 := by
      nlinarith [mul_le_mul_of_nonneg_left hT4 (sq_nonneg T)]
    have h1 : ((N * X : ℕ) : ℝ) ≤ T ^ 4 := by linarith
    have h2 := Real.log_le_log hP0 h1
    have e : Real.log (T ^ 4) = 4 * Real.log T := by
      rw [Real.log_pow]
      norm_num
    rw [e] at h2
    linarith
  set L : ℝ := 1 + Real.log T with hLdef
  have hL1 : 1 ≤ L := by linarith
  have h1 := term1_le hδ hT1 hu hX hlX
  have h2 := term2_le hδ hδ8 hT1 hu (by omega : 1 ≤ X) (by omega : 1 ≤ N) hNX hlX hlNX
    (by linarith)
  have h3 := term3_le hδ hδ8 hT1 hu hX2 hN1 hN2
  have h4 := term4_le (E := ZetaEM.emConst k) (u := u) hδ hT1 hk
    (by linarith) (by linarith) hX2 hN
  have hmain := MollifiedMean.mean_sq_f_le k hk2 hX2' hXN (by linarith) hu2 hT1 hTN
  refine hmain.trans ?_
  have hTa : T * T ^ (-(6 * δ ^ 2)) = T ^ (1 - 6 * δ ^ 2) := by
    rw [sub_eq_add_neg, Real.rpow_add hT0, Real.rpow_one]
  have hL35 : L ^ 3 ≤ L ^ 5 := pow_le_pow_right₀ hL1 (by norm_num)
  have hL05 : 1 ≤ L ^ 5 := one_le_pow₀ hL1
  have hTa0 : 0 ≤ T ^ (1 - 6 * δ ^ 2) := Real.rpow_nonneg hT0.le _
  have h2lt : (2:ℝ) ^ (-(6 * δ)) < 1 :=
    Real.rpow_lt_one_of_one_lt_of_neg (by norm_num) (by linarith)
  have hc1 : 0 ≤ 2 / (1 - (2:ℝ) ^ (-(6 * δ))) := div_nonneg (by norm_num) (by linarith)
  have hP1 : T ^ (1 - 6 * δ ^ 2) ≤ T ^ (1 - 6 * δ ^ 2) * L ^ 5 :=
    le_mul_of_one_le_right hTa0 hL05
  have f1 : T * (2 / (1 - (2:ℝ) ^ (-(6 * δ)))) * T ^ (-(6 * δ ^ 2)) * (2 * L) ^ 3
      ≤ 8 * (2 / (1 - (2:ℝ) ^ (-(6 * δ)))) * (T ^ (1 - 6 * δ ^ 2) * L ^ 5) := by
    calc T * (2 / (1 - (2:ℝ) ^ (-(6 * δ)))) * T ^ (-(6 * δ ^ 2)) * (2 * L) ^ 3
        = 8 * (2 / (1 - (2:ℝ) ^ (-(6 * δ)))) * ((T * T ^ (-(6 * δ ^ 2))) * L ^ 3) := by ring
      _ = 8 * (2 / (1 - (2:ℝ) ^ (-(6 * δ)))) * (T ^ (1 - 6 * δ ^ 2) * L ^ 3) := by rw [hTa]
      _ ≤ 8 * (2 / (1 - (2:ℝ) ^ (-(6 * δ)))) * (T ^ (1 - 6 * δ ^ 2) * L ^ 5) :=
          mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left hL35 hTa0) (by positivity)
  have f2 : 24 * (4 * L) ^ 2 * (2 * L) ^ 3 * (4 * T ^ (1 - 4 * δ))
      ≤ 12288 * (T ^ (1 - 6 * δ ^ 2) * L ^ 5) := by
    have hx : T ^ (1 - 4 * δ) ≤ T ^ (1 - 6 * δ ^ 2) :=
      Real.rpow_le_rpow_of_exponent_le hT1 (by linarith)
    have e : 24 * (4 * L) ^ 2 * (2 * L) ^ 3 * (4 * T ^ (1 - 4 * δ))
        = 12288 * (T ^ (1 - 4 * δ) * L ^ 5) := by ring
    rw [e]
    exact mul_le_mul_of_nonneg_left
      (mul_le_mul_of_nonneg_right hx (by positivity)) (by norm_num)
  have f3 : 8 * T ^ (1 - 3 * δ) ≤ 8 * (T ^ (1 - 6 * δ ^ 2) * L ^ 5) := by
    have hx : T ^ (1 - 3 * δ) ≤ T ^ (1 - 6 * δ ^ 2) :=
      Real.rpow_le_rpow_of_exponent_le hT1 (by linarith)
    linarith
  have f4 : 4 * ZetaEM.emConst k ^ 2 * (1 + 2 ^ k) ^ 2 * T ^ δ
      ≤ 4 * ZetaEM.emConst k ^ 2 * (1 + 2 ^ k) ^ 2 * (T ^ (1 - 6 * δ ^ 2) * L ^ 5) := by
    have hx : T ^ δ ≤ T ^ (1 - 6 * δ ^ 2) :=
      Real.rpow_le_rpow_of_exponent_le hT1 (by linarith)
    exact mul_le_mul_of_nonneg_left (hx.trans hP1) (by positivity)
  have e : bConst δ k * T ^ (1 - 6 * δ ^ 2) * L ^ 5
      = 3 * (8 * (2 / (1 - (2:ℝ) ^ (-(6 * δ)))) * (T ^ (1 - 6 * δ ^ 2) * L ^ 5)
        + 12288 * (T ^ (1 - 6 * δ ^ 2) * L ^ 5) + 8 * (T ^ (1 - 6 * δ ^ 2) * L ^ 5)
        + 4 * ZetaEM.emConst k ^ 2 * (1 + 2 ^ k) ^ 2 * (T ^ (1 - 6 * δ ^ 2) * L ^ 5)) := by
    unfold bConst
    ring
  rw [e]
  linarith

/-- **Zero density with a power saving.** For `1/2 < σ ≤ 1` there are `θ < 1`, `C ≥ 0` and
`T₀` such that for `T ≥ T₀` every finite set of zeros of ζ with `σ ≤ Re ρ < 1` and
`2 ≤ Im ρ ≤ T − 2` has at most `C·T^θ` elements; here `θ = 1 − 5δ²`, `δ = (σ − 1/2)/4`. -/
theorem zero_density {σ : ℝ} (hσ : 1 / 2 < σ) (hσ1 : σ ≤ 1) :
    ∃ θ C T₀ : ℝ, θ < 1 ∧ 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ Z : Finset ℂ,
      (∀ ρ ∈ Z, riemannZeta ρ = 0 ∧ σ ≤ ρ.re ∧ ρ.re < 1 ∧ 2 ≤ ρ.im ∧ ρ.im ≤ T - 2) →
      (Z.card : ℝ) ≤ C * T ^ θ := by
  obtain ⟨δ, hδdef⟩ : ∃ δ : ℝ, δ = (σ - 1 / 2) / 4 := ⟨_, rfl⟩
  have hδ : 0 < δ := by rw [hδdef]; linarith
  have hδ8 : δ ≤ 1 / 8 := by rw [hδdef]; linarith
  have hσδ : σ = 4 * δ + 1 / 2 := by rw [hδdef]; ring
  obtain ⟨k, hkdef⟩ : ∃ k : ℕ, k = ⌈1 / δ⌉₊ + 1 := ⟨_, rfl⟩
  have hk2 : 2 ≤ k := by
    have : 0 < ⌈1 / δ⌉₊ := Nat.ceil_pos.mpr (by positivity)
    omega
  have hk : 1 ≤ δ * ((k:ℝ) - 1) := by
    have h1 : 1 / δ ≤ (⌈1 / δ⌉₊ : ℝ) := Nat.le_ceil _
    have e : (k:ℝ) - 1 = (⌈1 / δ⌉₊ : ℝ) := by rw [hkdef]; push_cast; ring
    rw [e]
    calc (1:ℝ) = δ * (1 / δ) := (mul_one_div_cancel hδ.ne').symm
      _ ≤ δ * (⌈1 / δ⌉₊ : ℝ) := mul_le_mul_of_nonneg_left h1 hδ.le
  have hB0 := bConst_nonneg hδ k
  have hε : 0 < δ ^ 2 / 6 := by positivity
  have hd2 : 0 < δ ^ 2 := by positivity
  refine ⟨1 - 5 * δ ^ 2, 219 * bConst δ k * (1 + 1 / (δ ^ 2 / 6)) ^ 6 / (Real.pi * δ ^ 2),
    max (2 ^ (1 / δ)) ((k:ℝ) + 5), by linarith,
    div_nonneg (mul_nonneg (mul_nonneg (by norm_num) hB0) (by positivity)) (by positivity), ?_⟩
  intro T hT Z hZ
  have hT1 : (2:ℝ) ^ (1 / δ) ≤ T := le_of_max_le_left hT
  have hTk : (k:ℝ) + 5 ≤ T := le_of_max_le_right hT
  have hk0 : (0:ℝ) ≤ k := Nat.cast_nonneg k
  have hT5 : 5 ≤ T := by linarith
  have hT0 : 0 < T := by linarith
  have hTδ : 2 ≤ T ^ δ := by
    calc (2:ℝ) = ((2:ℝ) ^ (1 / δ)) ^ δ := by
          rw [← Real.rpow_mul (by norm_num), one_div_mul_cancel hδ.ne', Real.rpow_one]
      _ ≤ T ^ δ := Real.rpow_le_rpow (by positivity) hT1 hδ.le
  have hT1δ : T ^ (1 + δ) = T * T ^ δ := by rw [Real.rpow_add hT0, Real.rpow_one]
  have hTδ' : 1 ≤ T ^ (1 + δ) := by rw [hT1δ]; nlinarith
  obtain ⟨X, hXdef⟩ : ∃ X : ℕ, X = ⌈T ^ δ⌉₊ := ⟨_, rfl⟩
  obtain ⟨N, hNdef⟩ : ∃ N : ℕ, N = ⌈T ^ (1 + δ)⌉₊ := ⟨_, rfl⟩
  have hXb : T ^ δ ≤ X ∧ (X:ℝ) ≤ 2 * T ^ δ := by rw [hXdef]; exact ceil_bounds (by linarith)
  have hNb : T ^ (1 + δ) ≤ N ∧ (N:ℝ) ≤ 2 * T ^ (1 + δ) := by
    rw [hNdef]; exact ceil_bounds hTδ'
  have hX2 : 2 ≤ X := by exact_mod_cast hTδ.trans hXb.1
  have hXN : X ≤ N := by
    rw [hXdef, hNdef]
    apply Nat.ceil_mono
    rw [hT1δ]
    nlinarith
  have hTN : T + 3 + k ≤ N := by
    have := mul_le_mul_of_nonneg_left hTδ hT0.le
    linarith [hNb.1, hT1δ]
  have hab : σ - δ ≤ 1 + δ := by linarith
  have hlogT : 0 ≤ Real.log T := Real.log_nonneg (by linarith)
  have hL0 : 0 ≤ 1 + Real.log T := by linarith
  have hM0 : 0 ≤ bConst δ k * T ^ (1 - 6 * δ ^ 2) * (1 + Real.log T) ^ 5 :=
    mul_nonneg (mul_nonneg hB0 (Real.rpow_nonneg hT0.le _)) (pow_nonneg hL0 5)
  have hM : ∀ u ∈ Set.uIoc (σ - δ) (1 + δ),
      ‖∫ t in (1:ℝ)..T, ‖MollifiedMean.f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2‖
        ≤ bConst δ k * T ^ (1 - 6 * δ ^ 2) * (1 + Real.log T) ^ 5 := by
    intro u hu
    rw [Set.uIoc_of_le hab] at hu
    obtain ⟨hu1, hu2⟩ := hu
    have hI0 : 0 ≤ ∫ t in (1:ℝ)..T, ‖MollifiedMean.f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2 :=
      intervalIntegral.integral_nonneg (by linarith) (fun t _ => by positivity)
    rw [Real.norm_of_nonneg hI0]
    exact inner_le hδ hδ8 hk2 hk (by linarith) (by linarith) hXb.1 hXb.2 hNb.1 hNb.2 hX2 hXN
      hTN (by linarith) (by linarith)
  have hout := intervalIntegral.norm_integral_le_of_norm_le_const hM
  have hlen : |1 + δ - (σ - δ)| ≤ 1 := by
    rw [abs_of_nonneg (by linarith)]
    linarith
  have hI : (∫ u in (σ - δ)..(1 + δ), ∫ t in (1:ℝ)..T,
      ‖MollifiedMean.f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2)
        ≤ bConst δ k * T ^ (1 - 6 * δ ^ 2) * (1 + Real.log T) ^ 5 := by
    refine (le_abs_self _).trans ?_
    rw [← Real.norm_eq_abs]
    exact hout.trans (mul_le_of_le_one_right hM0 hlen)
  have hcard := ZeroSquares.card_zeros_le (by linarith : 1 / 2 < σ - δ) hσ1 hδ (by linarith)
    hT5 X Z hZ
  have hL := one_add_log_le (by linarith : (1:ℝ) ≤ T) hε
  have hL6 : (1 + Real.log T) ^ 6 ≤ (1 + 1 / (δ ^ 2 / 6)) ^ 6 * T ^ (δ ^ 2) := by
    have h := pow_le_pow_left₀ hL0 hL 6
    rw [mul_pow, ← Real.rpow_natCast (T ^ (δ ^ 2 / 6)) 6, ← Real.rpow_mul hT0.le] at h
    have e : δ ^ 2 / 6 * ((6:ℕ):ℝ) = δ ^ 2 := by push_cast; ring
    rw [e] at h
    exact h
  have hstep : Real.pi * δ ^ 2 * (Z.card : ℝ)
      ≤ 219 * bConst δ k * (1 + 1 / (δ ^ 2 / 6)) ^ 6 * T ^ (1 - 5 * δ ^ 2) := by
    have hc0 : 0 ≤ 3 * (15 * Real.log T + 73) := by linarith
    have a1 := mul_le_mul_of_nonneg_left hI hc0
    have a2 : 3 * (15 * Real.log T + 73)
          * (bConst δ k * T ^ (1 - 6 * δ ^ 2) * (1 + Real.log T) ^ 5)
        ≤ 219 * (1 + Real.log T)
          * (bConst δ k * T ^ (1 - 6 * δ ^ 2) * (1 + Real.log T) ^ 5) :=
      mul_le_mul_of_nonneg_right (by linarith) hM0
    have a3 : 219 * (1 + Real.log T)
          * (bConst δ k * T ^ (1 - 6 * δ ^ 2) * (1 + Real.log T) ^ 5)
        = 219 * bConst δ k * T ^ (1 - 6 * δ ^ 2) * (1 + Real.log T) ^ 6 := by ring
    have a4 : T ^ (1 - 6 * δ ^ 2) * T ^ (δ ^ 2) = T ^ (1 - 5 * δ ^ 2) := by
      rw [← Real.rpow_add hT0]
      congr 1
      ring
    have hK0 : 0 ≤ 219 * bConst δ k * T ^ (1 - 6 * δ ^ 2) :=
      mul_nonneg (mul_nonneg (by norm_num) hB0) (Real.rpow_nonneg hT0.le _)
    have a5 := mul_le_mul_of_nonneg_left hL6 hK0
    have a6 : 219 * bConst δ k * T ^ (1 - 6 * δ ^ 2)
          * ((1 + 1 / (δ ^ 2 / 6)) ^ 6 * T ^ (δ ^ 2))
        = 219 * bConst δ k * (1 + 1 / (δ ^ 2 / 6)) ^ 6 * T ^ (1 - 5 * δ ^ 2) := by
      rw [← a4]
      ring
    linarith [hcard, a1, a2, a3, a5, a6]
  have hpos : 0 < Real.pi * δ ^ 2 := by positivity
  rw [div_mul_eq_mul_div, le_div_iff₀ hpos]
  linarith

/-- info: 'ZeroDensity.zero_density' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zero_density

/-- info: 'ZeroDensity.inner_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms inner_le

/-- info: 'ZeroDensity.term4_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms term4_le

end

end ZeroDensity
