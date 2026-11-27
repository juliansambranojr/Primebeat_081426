/-
# FloorSumTele — block S12 of `lean_stage3/design/stencil.md`, piece 5c, the sum: the telescoping over halvings. 2026-11-25.

Abstract. A per-window floor `c (g T − g(T/2)) − e T log T ≤ f T − f(T/2)` for `T ≥ T₁` sums over
`T, T/2, …, T/2^(n+1)` to `c (g T − g(T/2^(n+1))) − 2 e T log T ≤ f T − f(T/2^(n+1))`.

The sizes, checked before the proof. The errors are `e Σ_{j ≤ n} (T/2^j) log(T/2^j)`, and
`log(T/2^j) ≤ log T`, so the sum is `≤ e T log T Σ_j 2^(−j) ≤ 2 e T log T`: no factor of `log T`
and no factor of `n` is lost. The induction carries exactly this: the step at `T` costs
`e T log T`, the tail from `T/2` costs `2 e (T/2) log(T/2) ≤ e T log T`, total `2 e T log T`.

| name | content | status |
|---|---|---|
| `tele` | the sum of the window floors over `n + 1` halvings | proved |
| `exists_halving` | an `n` with `T₁ ≤ T/2^n` and `T/2^(n+1) < T₁` | proved |
| `tele_floor` | `c (g T − g T₁) − 2 e T log T ≤ f T` for `f ≥ 0`, `g` monotone, `c ≥ 0` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Mathlib

namespace FloorSum

theorem half_pow_succ (T : ℝ) (n : ℕ) : T / 2 / 2 ^ n = T / 2 ^ (n + 1) := by
  rw [pow_succ, div_div, mul_comm]

/-- **The telescoping.** The window floors at `T, T/2, …, T/2^n` sum, with error `2 e T log T`. -/
theorem tele {f g : ℝ → ℝ} {c e T₁ : ℝ} (hT₁ : 1 ≤ T₁) (he : 0 ≤ e)
    (hstep : ∀ T : ℝ, T₁ ≤ T →
      c * (g T - g (T / 2)) - e * T * Real.log T ≤ f T - f (T / 2)) :
    ∀ n : ℕ, ∀ T : ℝ, T₁ ≤ T / 2 ^ n →
      c * (g T - g (T / 2 ^ (n + 1))) - 2 * e * T * Real.log T ≤ f T - f (T / 2 ^ (n + 1)) := by
  intro n
  induction n with
  | zero =>
    intro T hT
    simp only [pow_zero, div_one, zero_add, pow_one] at hT ⊢
    have hT1 : 1 ≤ T := hT₁.trans hT
    have hl : 0 ≤ e * T * Real.log T :=
      mul_nonneg (mul_nonneg he (by linarith)) (Real.log_nonneg hT1)
    have := hstep T hT
    linarith
  | succ n ih =>
    intro T hT
    have hp : (1 : ℝ) ≤ 2 ^ (n + 1) := one_le_pow₀ (by norm_num)
    have hT0 : 0 < T := by
      have h1 : 0 < T / 2 ^ (n + 1) := by linarith
      have h2 : (0 : ℝ) < 2 ^ (n + 1) := by positivity
      exact (div_pos_iff_of_pos_right h2).mp h1
    have hTT : T / 2 ^ (n + 1) ≤ T := div_le_self hT0.le hp
    have h1 := hstep T (hT.trans hTT)
    have h2 := ih (T / 2) (by rw [half_pow_succ]; exact hT)
    rw [half_pow_succ] at h2
    have hT1 : 1 ≤ T / 2 := by
      have : T / 2 ^ (n + 1) ≤ T / 2 := by
        rw [← half_pow_succ]
        exact div_le_self (by positivity) (one_le_pow₀ (by norm_num))
      linarith
    have hl : Real.log (T / 2) ≤ Real.log T := Real.log_le_log (by positivity) (by linarith)
    have hl' : e * T * Real.log (T / 2) ≤ e * T * Real.log T :=
      mul_le_mul_of_nonneg_left hl (mul_nonneg he hT0.le)
    have e1 : 2 * e * (T / 2) * Real.log (T / 2) = e * T * Real.log (T / 2) := by ring
    rw [e1] at h2
    linarith

/-- **The bottom of the halvings.** -/
theorem exists_halving {T T₁ : ℝ} (hT₁ : 0 < T₁) (hT : T₁ ≤ T) :
    ∃ n : ℕ, T₁ ≤ T / 2 ^ n ∧ T / 2 ^ (n + 1) < T₁ := by
  classical
  obtain ⟨m, hm⟩ := pow_unbounded_of_one_lt (T / T₁) (by norm_num : (1 : ℝ) < 2)
  have hex : ∃ m : ℕ, T / 2 ^ m < T₁ := by
    refine ⟨m, ?_⟩
    rw [div_lt_iff₀ hT₁] at hm
    rw [div_lt_iff₀ (by positivity)]
    linarith
  have h0 : Nat.find hex ≠ 0 := by
    intro h
    have := Nat.find_spec hex
    rw [h, pow_zero, div_one] at this
    linarith
  obtain ⟨n, hn⟩ := Nat.exists_eq_succ_of_ne_zero h0
  refine ⟨n, ?_, ?_⟩
  · have := Nat.find_min hex (show n < Nat.find hex by omega)
    exact not_lt.mp this
  · have := Nat.find_spec hex
    rw [hn] at this
    exact this

/-- **The floor from the window floors.** -/
theorem tele_floor {f g : ℝ → ℝ} {c e T₁ : ℝ} (hT₁ : 1 ≤ T₁) (he : 0 ≤ e) (hc : 0 ≤ c)
    (hf : ∀ T : ℝ, 0 ≤ f T) (hg : Monotone g)
    (hstep : ∀ T : ℝ, T₁ ≤ T →
      c * (g T - g (T / 2)) - e * T * Real.log T ≤ f T - f (T / 2)) :
    ∀ T : ℝ, T₁ ≤ T → c * (g T - g T₁) - 2 * e * T * Real.log T ≤ f T := by
  intro T hT
  obtain ⟨n, hn1, hn2⟩ := exists_halving (by linarith) hT
  have h := tele hT₁ he hstep n T hn1
  have hgb : c * g (T / 2 ^ (n + 1)) ≤ c * g T₁ := mul_le_mul_of_nonneg_left (hg hn2.le) hc
  have := hf (T / 2 ^ (n + 1))
  linarith

/-- info: 'FloorSum.tele' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms tele

/-- info: 'FloorSum.exists_halving' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exists_halving

/-- info: 'FloorSum.tele_floor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms tele_floor

end FloorSum
