/-
ShareLink — block J6 of `lean_stage3/design/closedloop.md`. 2026-11-23.

The table flipped inside out. A cell's total `T` splits two ways. The primes
and the composites split it by adding: `P + C = T`. A zero and its mirror split
it by multiplying: their modes have sizes `T^β` and `T^(1−β)`, whose product is
`T`. On the multiplying side the table is one line, the exponent from `0` to
`1`, and the real part of a zero is the share of the total its mode takes
there. The two meet in the middle exactly at one half, where both are `√T`.
The table's own swap, prime for composite, moves no mode: it changes the sign
of the residual and nothing else.

  mode_size            0 < T ⊢ ‖T^ρ‖ = T^(Re ρ)
  share_is_re          1 < T ⊢ logb T ‖T^ρ‖ = Re ρ
  pair_shares_add      1 < T ⊢ the two shares of a zero and its mirror add to 1
  add_shares_add       T ≠ 0, P + C = T ⊢ P/T + C/T = 1
  meet_iff             1 < T ⊢ ‖T^ρ‖ = ‖T^(mirror ρ)‖ ↔ Re ρ = 1/2
  meet_sqrt_iff        1 < T ⊢ ‖T^ρ‖ = √T ↔ Re ρ = 1/2
  swap_flips_residual  P = S + R, P + C = T ⊢ C = (T − S) − R
  spiralLink_iff_meet  SpiralLink ↔ every zero meets its mirror at base 2

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.BandJoin

namespace ShareLink

open Kadiri SpiralLink

/-- **A zero's mode.** At the total `T` the mode of a zero has size `T` to the
zero's real part. -/
theorem mode_size {T : ℝ} (hT : 0 < T) (ρ : NontrivialZeros) :
    ‖(T : ℂ) ^ (ρ : ℂ)‖ = T ^ (ρ : ℂ).re :=
  Complex.norm_cpow_eq_rpow_re_of_pos hT _

/-- **The real part is a share.** On the multiplying scale, the share of the
total `T` that a zero's mode takes is the zero's real part. -/
theorem share_is_re {T : ℝ} (hT : 1 < T) (ρ : NontrivialZeros) :
    Real.logb T ‖(T : ℂ) ^ (ρ : ℂ)‖ = (ρ : ℂ).re := by
  rw [mode_size (by linarith) ρ]
  exact Real.logb_rpow (by linarith) (by linarith)

/-- **The pair splits the total.** The shares of a zero and of its mirror add
to one, as the prime share and the composite share of a cell do. -/
theorem pair_shares_add {T : ℝ} (hT : 1 < T) (ρ : NontrivialZeros) :
    Real.logb T ‖(T : ℂ) ^ (ρ : ℂ)‖
      + Real.logb T ‖(T : ℂ) ^ ((mirrorZ ρ : NontrivialZeros) : ℂ)‖ = 1 := by
  rw [share_is_re hT, share_is_re hT, mirrorZ_re]
  ring

/-- **The adding split.** Two parts of a total have shares that add to one. -/
theorem add_shares_add {P C T : ℝ} (hT : T ≠ 0) (h : P + C = T) : P / T + C / T = 1 := by
  rw [← add_div, h, div_self hT]

/-- **Meeting in the middle.** A zero's mode and its mirror's are the same size
exactly when the zero's real part is one half. -/
theorem meet_iff {T : ℝ} (hT : 1 < T) (ρ : NontrivialZeros) :
    ‖(T : ℂ) ^ (ρ : ℂ)‖ = ‖(T : ℂ) ^ ((mirrorZ ρ : NontrivialZeros) : ℂ)‖
      ↔ (ρ : ℂ).re = 1 / 2 := by
  constructor
  · intro h
    have h1 := congrArg (Real.logb T) h
    rw [share_is_re hT, share_is_re hT, mirrorZ_re] at h1
    linarith
  · intro h
    rw [mode_size (by linarith), mode_size (by linarith), mirrorZ_re, h]
    norm_num

/-- **The middle is the square root.** A zero's mode is the square root of the
total exactly when the zero's real part is one half. -/
theorem meet_sqrt_iff {T : ℝ} (hT : 1 < T) (ρ : NontrivialZeros) :
    ‖(T : ℂ) ^ (ρ : ℂ)‖ = Real.sqrt T ↔ (ρ : ℂ).re = 1 / 2 := by
  have hT0 : 0 < T := by linarith
  rw [mode_size hT0, Real.sqrt_eq_rpow]
  constructor
  · intro h
    have h1 := congrArg (Real.logb T) h
    rw [Real.logb_rpow hT0 (by linarith), Real.logb_rpow hT0 (by linarith)] at h1
    exact h1
  · intro h
    rw [h]

/-- **The swap moves no mode.** If the prime cell is a smooth part plus a
residual, the composite cell is the rest of the total less the same residual. -/
theorem swap_flips_residual {P C T S R : ℝ} (hP : P = S + R) (h : P + C = T) :
    C = (T - S) - R := by
  linarith

/-- **The loop, as the meeting.** The spiral link holds exactly when every
zero's mode and its mirror's are the same size at base two. -/
theorem spiralLink_iff_meet :
    SpiralLink.SpiralLink ↔ ∀ ρ : NontrivialZeros,
      ‖((2 : ℝ) : ℂ) ^ (ρ : ℂ)‖ = ‖((2 : ℝ) : ℂ) ^ ((mirrorZ ρ : NontrivialZeros) : ℂ)‖ := by
  rw [← SpiralLink.rh_iff_spiralLink, ClosedLoopJoin.rh_iff_re_half]
  exact forall_congr' fun ρ => (meet_iff (by norm_num) ρ).symm

/-- info: 'ShareLink.share_is_re' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms share_is_re

/-- info: 'ShareLink.pair_shares_add' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms pair_shares_add

/-- info: 'ShareLink.meet_sqrt_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms meet_sqrt_iff

/-- info: 'ShareLink.spiralLink_iff_meet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms spiralLink_iff_meet

end ShareLink
