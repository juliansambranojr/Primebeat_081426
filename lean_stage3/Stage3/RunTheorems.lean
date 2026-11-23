/-
RunTheorems — block R1 of `lean_stage3/design/runs.md`. 2026-11-23.

The exploratory runs of units 0473 and 0474 measured two patterns on a
stretch of rows. Each has an exact core that holds at every row, with nothing
computed.

  mode_fold      2^(ρ + 2πi·k/log 2) = 2^ρ for every integer k: on the ladder
                 a height shows only up to the period 2π/log 2 (unit 0473)
  mode_cross     2^ρ₁ · conj(2^ρ₂) = exp((β₁+β₂)·log 2 + i·(γ₁−γ₂)·log 2):
                 the product of one mode with the conjugate of another turns
                 by the difference of their heights (unit 0474)
  two_mode_beat  ‖c₁·z₁^k + c₂·z₂^k‖² = ‖c₁·z₁^k‖² + ‖c₂·z₂^k‖²
                 + 2·Re(c₁·conj c₂·(z₁·conj z₂)^k): at every row the size of
                 two modes together is their two sizes plus a term that turns
                 with (z₁·conj z₂)^k
  zero_pair_beat for two zeros: that term is
                 2^((β₁+β₂)k)·Re(c₁·conj c₂·exp(i·k·(γ₁−γ₂)·log 2)): it turns,
                 row by row, at the difference of the two heights

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.OneChain

namespace RunTheorems

open Complex

/-- A mode of the base two, written with the exponential. -/
theorem two_cpow (ρ : ℂ) : (2:ℂ) ^ ρ = Complex.exp (ρ * (Real.log 2 : ℂ)) := by
  rw [Complex.cpow_def_of_ne_zero (by norm_num : (2:ℂ) ≠ 0), mul_comm]
  congr 1
  rw [show (2:ℂ) = ((2:ℝ):ℂ) by norm_num, ← Complex.ofReal_log (by norm_num : (0:ℝ) ≤ 2)]

/-- **The fold.** On the ladder of base two, raising the height of a point by a
whole number of periods `2π/log 2` leaves its mode unchanged. -/
theorem mode_fold (ρ : ℂ) (k : ℤ) :
    (2:ℂ) ^ (ρ + 2 * Real.pi * Complex.I * (k : ℂ) / (Real.log 2 : ℂ)) = (2:ℂ) ^ ρ := by
  have hlog : (Real.log 2 : ℂ) ≠ 0 := by
    exact_mod_cast (Real.log_pos (by norm_num : (1:ℝ) < 2)).ne'
  rw [two_cpow, two_cpow, add_mul, Complex.exp_add]
  have e : 2 * (Real.pi : ℂ) * Complex.I * (k : ℂ) / (Real.log 2 : ℂ) * (Real.log 2 : ℂ)
      = (k : ℂ) * (2 * Real.pi * Complex.I) := by
    field_simp
    try ring
  rw [e, Complex.exp_int_mul_two_pi_mul_I, mul_one]

/-- **The cross term of two modes.** A mode times the conjugate of another is
the exponential of the sum of the real parts and the difference of the
heights, each times `log 2`. -/
theorem mode_cross (ρ₁ ρ₂ : ℂ) :
    (2:ℂ) ^ ρ₁ * (starRingEnd ℂ) ((2:ℂ) ^ ρ₂)
      = Complex.exp ((((ρ₁.re + ρ₂.re) * Real.log 2 : ℝ) : ℂ)
          + (((ρ₁.im - ρ₂.im) * Real.log 2 : ℝ) : ℂ) * Complex.I) := by
  obtain ⟨L, hL⟩ : ∃ L : ℝ, L = Real.log 2 := ⟨_, rfl⟩
  rw [two_cpow, two_cpow, ← hL, ← Complex.exp_conj, ← Complex.exp_add]
  congr 1
  apply Complex.ext
  · simp [Complex.mul_re]
    ring
  · simp [Complex.mul_im]
    ring

/-- **Two modes together, at every row.** The squared size of the sum of two
modes is the sum of their squared sizes plus twice the real part of a term that
turns with the row. -/
theorem two_mode_beat (c₁ c₂ z₁ z₂ : ℂ) (k : ℕ) :
    ‖c₁ * z₁ ^ k + c₂ * z₂ ^ k‖ ^ 2
      = ‖c₁ * z₁ ^ k‖ ^ 2 + ‖c₂ * z₂ ^ k‖ ^ 2
        + 2 * (c₁ * (starRingEnd ℂ) c₂ * (z₁ * (starRingEnd ℂ) z₂) ^ k).re := by
  rw [Complex.sq_norm, Complex.sq_norm, Complex.sq_norm, Complex.normSq_add]
  congr 2
  simp only [map_mul, map_pow]
  ring_nf

/-- **The beat between two zeros.** For two points, the term that turns in
`two_mode_beat` is the row's power of `2^(β₁+β₂)` times a rotation by the row
times the difference of the two heights times `log 2`. -/
theorem zero_pair_beat (c₁ c₂ ρ₁ ρ₂ : ℂ) (k : ℕ) :
    (c₁ * (starRingEnd ℂ) c₂ * ((2:ℂ) ^ ρ₁ * (starRingEnd ℂ) ((2:ℂ) ^ ρ₂)) ^ k)
      = c₁ * (starRingEnd ℂ) c₂
          * ((((2:ℝ) ^ ((ρ₁.re + ρ₂.re) * (k:ℝ)) : ℝ) : ℂ)
            * Complex.exp ((((k:ℝ) * ((ρ₁.im - ρ₂.im) * Real.log 2) : ℝ) : ℂ) * Complex.I)) := by
  rw [mode_cross, ← Complex.exp_nat_mul]
  congr 1
  rw [Real.rpow_def_of_pos (by norm_num : (0:ℝ) < 2), Complex.ofReal_exp, ← Complex.exp_add]
  congr 1
  push_cast
  ring

/-- info: 'RunTheorems.mode_fold' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mode_fold

/-- info: 'RunTheorems.mode_cross' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mode_cross

/-- info: 'RunTheorems.two_mode_beat' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms two_mode_beat

/-- info: 'RunTheorems.zero_pair_beat' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zero_pair_beat

end RunTheorems
