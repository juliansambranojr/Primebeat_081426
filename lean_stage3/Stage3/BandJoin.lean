/-
BandJoin — block J5 of `lean_stage3/design/closedloop.md`. 2026-11-23.

The band of the deep zero and the strip of the zeros, under one map.

`lean/DeepZeroBand.lean` divides a cell by its total, its share, and sends a
share `x` to `b^(−x)`: share `0`, the deep zero, on the outer circle; share
`1`, its inverse, on the inner circle; the prime share and the composite share
of a cell multiplying to `b^(−1)`; the middle circle exactly at share one half.
Here the same map at base `2`, `bandR x = 2^(−x)`, is applied to the real part
of a zero: the size of `2^(−ρ)` is `bandR (Re ρ)`. Every nontrivial zero lands
strictly inside the band, a zero and its mirror multiply to one half, and a
zero is on the middle circle exactly when its real part is one half.

  bandR_zero, bandR_one     the two edges: 1 and 1/2
  bandR_mirror              bandR x · bandR (1 − x) = 1/2
  bandR_in_band             0 ≤ x ≤ 1 ⊢ 1/2 ≤ bandR x ≤ 1
  bandR_middle_iff          bandR x = bandR (1/2) ↔ x = 1/2
  share_pair                P + C = tot ⊢ bandR (P/tot) · bandR (C/tot) = 1/2
  zero_image                ‖2^(−ρ)‖ = bandR (Re ρ)
  zero_in_band              1/2 < ‖2^(−ρ)‖ < 1
  zero_pair                 ‖2^(−ρ)‖ · ‖2^(−mirror ρ)‖ = 1/2
  zero_middle_iff           ‖2^(−ρ)‖ = bandR (1/2) ↔ Re ρ = 1/2
  spiralLink_iff_middle     SpiralLink ↔ every zero on the middle circle

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.StepsRate
import Stage3.HalfSieve

namespace BandJoin

open Kadiri

/-- The band's map at base `2`: a share, or a real part, `x` goes to `2^(−x)`. -/
noncomputable def bandR (x : ℝ) : ℝ := (2:ℝ) ^ (-x)

/-- Share `0`, the deep zero, is on the outer circle. -/
theorem bandR_zero : bandR 0 = 1 := by simp [bandR]

/-- Share `1`, the inverse of the deep zero, is on the inner circle. -/
theorem bandR_one : bandR 1 = 1 / 2 := by
  unfold bandR
  rw [Real.rpow_neg (by norm_num), Real.rpow_one]
  norm_num

/-- **The mirror.** A share and its mirror multiply to one half. -/
theorem bandR_mirror (x : ℝ) : bandR x * bandR (1 - x) = 1 / 2 := by
  unfold bandR
  rw [← Real.rpow_add (by norm_num)]
  have h : -x + -(1 - x) = -1 := by ring
  rw [h, Real.rpow_neg (by norm_num), Real.rpow_one]
  norm_num

/-- The band's map is strictly decreasing. -/
theorem bandR_strictAnti : StrictAnti bandR := by
  intro x y h
  unfold bandR
  exact Real.rpow_lt_rpow_of_exponent_lt (by norm_num) (by linarith)

/-- **The band.** A share between `0` and `1` lands between the two circles. -/
theorem bandR_in_band {x : ℝ} (h0 : 0 ≤ x) (h1 : x ≤ 1) : 1 / 2 ≤ bandR x ∧ bandR x ≤ 1 := by
  have a := bandR_strictAnti.antitone h1
  have b := bandR_strictAnti.antitone h0
  rw [bandR_one] at a
  rw [bandR_zero] at b
  exact ⟨a, b⟩

/-- **The middle circle** is reached exactly at one half. -/
theorem bandR_middle_iff (x : ℝ) : bandR x = bandR (1 / 2) ↔ x = 1 / 2 :=
  bandR_strictAnti.injective.eq_iff

/-- **A cell's two shares.** Two parts of a total have shares whose images
multiply to one half. -/
theorem share_pair {P C tot : ℝ} (ht : tot ≠ 0) (h : P + C = tot) :
    bandR (P / tot) * bandR (C / tot) = 1 / 2 := by
  have e : C / tot = 1 - P / tot := by
    field_simp
    linarith
  rw [e, bandR_mirror]

/-- **A zero under the band's map.** The size of `2^(−ρ)` is the band's map at
the real part of `ρ`. -/
theorem zero_image (ρ : NontrivialZeros) : ‖(2:ℂ) ^ (-(ρ:ℂ))‖ = bandR (ρ:ℂ).re := by
  unfold bandR
  rw [← Complex.ofReal_ofNat, Complex.norm_cpow_eq_rpow_re_of_pos (by norm_num)]
  simp

/-- **Every zero is strictly inside the band.** -/
theorem zero_in_band (ρ : NontrivialZeros) :
    1 / 2 < ‖(2:ℂ) ^ (-(ρ:ℂ))‖ ∧ ‖(2:ℂ) ^ (-(ρ:ℂ))‖ < 1 := by
  rw [zero_image]
  have a := bandR_strictAnti ρ.2.1.2
  have b := bandR_strictAnti ρ.2.1.1
  rw [bandR_one] at a
  rw [bandR_zero] at b
  exact ⟨a, b⟩

/-- **A zero and its mirror multiply to one half**, as the prime share and the
composite share of a cell do. -/
theorem zero_pair (ρ : NontrivialZeros) :
    ‖(2:ℂ) ^ (-(ρ:ℂ))‖ * ‖(2:ℂ) ^ (-((SpiralLink.mirrorZ ρ : NontrivialZeros):ℂ))‖ = 1 / 2 := by
  rw [zero_image, zero_image, SpiralLink.mirrorZ_re, bandR_mirror]

/-- **A zero is on the middle circle exactly when its real part is one half.** -/
theorem zero_middle_iff (ρ : NontrivialZeros) :
    ‖(2:ℂ) ^ (-(ρ:ℂ))‖ = bandR (1 / 2) ↔ (ρ:ℂ).re = 1 / 2 := by
  rw [zero_image, bandR_middle_iff]

/-- **The loop on the band.** The spiral link holds exactly when every zero is
on the middle circle of the band. -/
theorem spiralLink_iff_middle :
    SpiralLink.SpiralLink ↔ ∀ ρ : NontrivialZeros, ‖(2:ℂ) ^ (-(ρ:ℂ))‖ = bandR (1 / 2) := by
  rw [← SpiralLink.rh_iff_spiralLink, ClosedLoopJoin.rh_iff_re_half]
  exact forall_congr' fun ρ => (zero_middle_iff ρ).symm

/-- info: 'BandJoin.share_pair' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms share_pair

/-- info: 'BandJoin.zero_in_band' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zero_in_band

/-- info: 'BandJoin.zero_pair' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zero_pair

/-- info: 'BandJoin.spiralLink_iff_middle' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms spiralLink_iff_middle

end BandJoin
