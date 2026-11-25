/-
# FloorConst — block S12 of `lean_stage3/design/stencil.md`, piece 5a, the closed form: the limit and its value. 2026-11-25.

The top module of piece 5a. `FloorConstDeriv` computes the partials of Young's `c(α,β)` off
`α + β = 0`; `FloorConstLimit` turns Levinson's operator at `(−R/L, −R/L)` into the closed form
`Kfl A B C (log M / log T) R`, exactly, and proves `Re D[c](T) → Kfl A B C θ R`. Here, at
Levinson's `P(x) = x` (`A = 1`, `B = 1/2`, `C = 1/3`) and `θ = 49/100 < 1/2`, `R = 13/10`:
`K = Kfl 1 (1/2) (1/3) (49/100) (13/10) = r + c e^(2R)` with `r = −760154441/645918000`,
`c = 3405769/12918360`, and the Taylor bounds on `e^(1/10)` and `e^(1/15)` give `K < e^R`
(`log K < R`) and `K ≤ e^(2R/3)`, so `κ = 1 − log K / R ≥ 1/3`.

Computed with Python (`fractions`, `math`), not proved: `K = 2.372692…`, `κ = 0.335365…` at
this choice; at `θ = 1/2`, `R = 1.3`, `κ = 0.342735…`.

| name | content | status |
|---|---|---|
| `kappaL` | `κ(θ, R) = 1 − log (Kfl 1 (1/2) (1/3) θ R) / R` | defined |
| `exp_tenth_le`, `exp_tenth_ge`, `exp_fifteenth_ge` | Taylor bounds, four terms | proved |
| `Kfl_levinson_eq` | `K = r + c · e^(13/10)²` | proved |
| `Kfl_levinson_lt` | `Kfl 1 (1/2) (1/3) (49/100) (13/10) < e^(13/10)` | proved |
| `log_Kfl_levinson_lt` | `log K < 13/10` | proved |
| `kappa_levinson_ge` | `1/3 ≤ κ(49/100, 13/10)` | proved |
| `floor_const` | the limit at `P = X`, `θ = 49/100`, `R = 13/10`, with `1/3 ≤ κ` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.FloorConstLimit

namespace FloorConst

open Complex Filter Topology TwistedMoment Operator

noncomputable section

/-- Levinson's proportion at `P(x) = x`: `κ = 1 − log K / R`. -/
def kappaL (θ R : ℝ) : ℝ := 1 - Real.log (Kfl 1 (1 / 2) (1 / 3) θ R) / R

end

theorem exp_tenth_le : Real.exp (1 / 10) ≤ 1 + 1 / 10 + 1 / 200 + 1 / 6000 + 1 / 192000 := by
  have h := Real.exp_bound' (x := 1 / 10) (by norm_num) (by norm_num) (n := 4) (by norm_num)
  refine h.trans (le_of_eq ?_)
  simp [Finset.sum_range_succ, Nat.factorial]
  norm_num

theorem exp_tenth_ge : 1 + 1 / 10 + 1 / 200 + 1 / 6000 ≤ Real.exp (1 / 10) := by
  have h := Real.sum_le_exp_of_nonneg (x := 1 / 10) (by norm_num) 4
  refine le_trans (le_of_eq ?_) h
  simp [Finset.sum_range_succ, Nat.factorial]
  norm_num

theorem exp_fifteenth_ge : 1 + 1 / 15 + 1 / 450 + 1 / 20250 ≤ Real.exp (1 / 15) := by
  have h := Real.sum_le_exp_of_nonneg (x := 1 / 15) (by norm_num) 4
  refine le_trans (le_of_eq ?_) h
  simp [Finset.sum_range_succ, Nat.factorial]
  norm_num

theorem exp_mul_nat (n : ℕ) (x : ℝ) : Real.exp (n * x) = Real.exp x ^ n := Real.exp_nat_mul x n

/-- `K = r + c · e^(13/10)²` at `P(x) = x`, `θ = 49/100`, `R = 13/10`. -/
theorem Kfl_levinson_eq :
    Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10) =
      -760154441 / 645918000 + 3405769 / 12918360 * Real.exp (13 / 10) ^ 2 := by
  unfold Kfl
  rw [show (2 : ℝ) * (13 / 10) = 13 / 10 + 13 / 10 by norm_num, Real.exp_add]
  ring

theorem exp_13_10_bounds :
    (1 + 1 / 10 + 1 / 200 + 1 / 6000 : ℝ) ^ 13 ≤ Real.exp (13 / 10) ∧
      Real.exp (13 / 10) ≤ (1 + 1 / 10 + 1 / 200 + 1 / 6000 + 1 / 192000 : ℝ) ^ 13 := by
  have e : Real.exp (13 / 10) = Real.exp (1 / 10) ^ 13 := by
    rw [← exp_mul_nat]
    norm_num
  rw [e]
  exact ⟨pow_le_pow_left₀ (by norm_num) exp_tenth_ge 13,
    pow_le_pow_left₀ (Real.exp_pos _).le exp_tenth_le 13⟩

theorem exp_13_15_ge : (1 + 1 / 15 + 1 / 450 + 1 / 20250 : ℝ) ^ 13 ≤ Real.exp (13 / 15) := by
  have e : Real.exp (13 / 15) = Real.exp (1 / 15) ^ 13 := by
    rw [← exp_mul_nat]
    norm_num
  rw [e]
  exact pow_le_pow_left₀ (by norm_num) exp_fifteenth_ge 13

/-- `K ≤ r + c · hi²`, `hi` the upper Taylor bound on `e^(13/10)`. -/
theorem Kfl_levinson_le :
    Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10) ≤
      -760154441 / 645918000 + 3405769 / 12918360 *
        ((1 + 1 / 10 + 1 / 200 + 1 / 6000 + 1 / 192000 : ℝ) ^ 13) ^ 2 := by
  rw [Kfl_levinson_eq]
  have h := exp_13_10_bounds.2
  have h2 : Real.exp (13 / 10) ^ 2 ≤ ((1 + 1 / 10 + 1 / 200 + 1 / 6000 + 1 / 192000 : ℝ) ^ 13) ^ 2 :=
    pow_le_pow_left₀ (Real.exp_pos _).le h 2
  linarith

/-- `0 < K`. -/
theorem Kfl_levinson_pos : 0 < Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10) := by
  rw [Kfl_levinson_eq]
  have h := exp_13_10_bounds.1
  have h2 : ((1 + 1 / 10 + 1 / 200 + 1 / 6000 : ℝ) ^ 13) ^ 2 ≤ Real.exp (13 / 10) ^ 2 :=
    pow_le_pow_left₀ (by norm_num) h 2
  have h3 : (0 : ℝ) < -760154441 / 645918000 + 3405769 / 12918360 *
      ((1 + 1 / 10 + 1 / 200 + 1 / 6000 : ℝ) ^ 13) ^ 2 := by norm_num
  linarith

/-- **`K < e^R`** at `P(x) = x`, `θ = 49/100`, `R = 13/10`. -/
theorem Kfl_levinson_lt : Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10) < Real.exp (13 / 10) := by
  have h1 := Kfl_levinson_le
  have h2 := exp_13_10_bounds.1
  have h3 : -760154441 / 645918000 + 3405769 / 12918360 *
      ((1 + 1 / 10 + 1 / 200 + 1 / 6000 + 1 / 192000 : ℝ) ^ 13) ^ 2 <
      (1 + 1 / 10 + 1 / 200 + 1 / 6000 : ℝ) ^ 13 := by norm_num
  linarith

/-- **`log K < R`**. -/
theorem log_Kfl_levinson_lt : Real.log (Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10)) < 13 / 10 :=
  (Real.log_lt_iff_lt_exp Kfl_levinson_pos).mpr Kfl_levinson_lt

/-- **`κ ≥ 1/3`** at `P(x) = x`, `θ = 49/100`, `R = 13/10`. -/
theorem kappa_levinson_ge : 1 / 3 ≤ kappaL (49 / 100) (13 / 10) := by
  unfold kappaL
  have h1 := Kfl_levinson_le
  have h2 := exp_13_15_ge
  have h3 : -760154441 / 645918000 + 3405769 / 12918360 *
      ((1 + 1 / 10 + 1 / 200 + 1 / 6000 + 1 / 192000 : ℝ) ^ 13) ^ 2 ≤
      (1 + 1 / 15 + 1 / 450 + 1 / 20250 : ℝ) ^ 13 := by norm_num
  have hK : Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10) ≤ Real.exp (13 / 15) := by linarith
  have hlog : Real.log (Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10)) ≤ 13 / 15 :=
    (Real.log_le_iff_le_exp Kfl_levinson_pos).mpr hK
  have e : Real.log (Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10)) / (13 / 10) =
      Real.log (Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10)) * (10 / 13) := by ring
  rw [e]
  linarith

/-- **Piece 5a**: at `P(x) = x`, `θ = 49/100`, `R = 13/10`, `Re D[c](T) → K` with `log K < R`
and `1 − log K / R ≥ 1/3`. -/
theorem floor_const :
    Tendsto (fun T => (Dop (Real.log T) (cY Polynomial.X (Mof T (49 / 100)) T)
      ((-((13 / 10) / Real.log T) : ℝ) : ℂ) ((-((13 / 10) / Real.log T) : ℝ) : ℂ)).re) atTop
      (𝓝 (Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10))) ∧
    Real.log (Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10)) < 13 / 10 ∧
    1 / 3 ≤ kappaL (49 / 100) (13 / 10) :=
  ⟨re_dop_tendsto_X (by norm_num) (by norm_num), log_Kfl_levinson_lt, kappa_levinson_ge⟩

/-- info: 'FloorConst.Kfl_levinson_lt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Kfl_levinson_lt

/-- info: 'FloorConst.kappa_levinson_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms kappa_levinson_ge

/-- info: 'FloorConst.floor_const' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms floor_const

end FloorConst
