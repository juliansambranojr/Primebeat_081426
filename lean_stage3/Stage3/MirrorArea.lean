/-
MirrorArea — block S1 of `lean_stage3/design/joints.md`. 2026-11-22.

A mode of the table at base `b` and its mirror, read as the two sides of a
rectangle. The sides are `‖b^ρ‖` and `‖b^(1−ρ)‖`. Their product is `b` for
every `ρ`: the area is fixed by the base and by nothing else. So one side gives
the other at every scale. The rectangle is a square, each side `√b`, exactly
when `ρ` is on the line; off the line one side is longer than `√b`. The
restoring force of block T4 is the logarithm of the ratio of the sides.

  mirror_area                  0 < b ⊢ ‖b^ρ‖ · ‖b^(1−ρ)‖ = b
  mirror_side                  0 < b ⊢ ‖b^(1−ρ)‖ = b / ‖b^ρ‖
  side_eq_sqrt_iff             1 < b ⊢ ‖b^ρ‖ = √b ↔ ρ.re = 1/2
  square_iff                   1 < b ⊢ both sides are √b ↔ ρ.re = 1/2
  long_side_of_off_line        1 < b, ρ.re ≠ 1/2 ⊢ √b < max of the two sides
  restoringForce_eq_log_ratio  0 < b ⊢ restoringForce b ρ = |log (side / mirror side)|

Earlier in the tree: `lean/Transform.lean` proves the same rectangle in the
variable `z = b^(−s)`: `zmap_pair_product` (the product is `b^(−1)`),
`pair_collapses_iff_critical`, `riemannHypothesis_iff_pair_collapses`. This
module restates it in Stage 3, in the sizes block T4 uses, and joins it to
`restoringForce`. The two trees are separate packages, so nothing is imported.

What the next slice needs: a statement that forces equal sides from the table;
it is not here.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.StencilWeil

namespace MirrorArea

open Complex StencilWeil

noncomputable section

/-- **The area is fixed.** A mode and its mirror multiply to the base. -/
theorem mirror_area {b : ℝ} (hb : 0 < b) (ρ : ℂ) :
    ‖(b : ℂ) ^ ρ‖ * ‖(b : ℂ) ^ (1 - ρ)‖ = b := by
  rw [Complex.norm_cpow_eq_rpow_re_of_pos hb, Complex.norm_cpow_eq_rpow_re_of_pos hb,
    ← Real.rpow_add hb]
  simp

/-- **One side gives the other**, at every base. -/
theorem mirror_side {b : ℝ} (hb : 0 < b) (ρ : ℂ) :
    ‖(b : ℂ) ^ (1 - ρ)‖ = b / ‖(b : ℂ) ^ ρ‖ := by
  have h := mirror_area hb ρ
  have hpos : 0 < ‖(b : ℂ) ^ ρ‖ := by
    rw [Complex.norm_cpow_eq_rpow_re_of_pos hb]
    exact Real.rpow_pos_of_pos hb _
  rw [eq_div_iff hpos.ne']
  linarith [mul_comm ‖(b : ℂ) ^ ρ‖ ‖(b : ℂ) ^ (1 - ρ)‖]

/-- A side is the square root of the base exactly on the line. -/
theorem side_eq_sqrt_iff {b : ℝ} (hb : 1 < b) (ρ : ℂ) :
    ‖(b : ℂ) ^ ρ‖ = Real.sqrt b ↔ ρ.re = 1 / 2 := by
  have hb0 : 0 < b := by linarith
  rw [Complex.norm_cpow_eq_rpow_re_of_pos hb0, Real.sqrt_eq_rpow]
  constructor
  · intro h
    have h' := congrArg Real.log h
    rw [Real.log_rpow hb0, Real.log_rpow hb0] at h'
    exact mul_right_cancel₀ (Real.log_pos hb).ne' h'
  · intro h
    rw [h]

/-- **The square.** Both sides are the square root of the base exactly on the
line. -/
theorem square_iff {b : ℝ} (hb : 1 < b) (ρ : ℂ) :
    (‖(b : ℂ) ^ ρ‖ = Real.sqrt b ∧ ‖(b : ℂ) ^ (1 - ρ)‖ = Real.sqrt b) ↔ ρ.re = 1 / 2 := by
  rw [side_eq_sqrt_iff hb, side_eq_sqrt_iff hb]
  simp only [Complex.sub_re, Complex.one_re]
  constructor
  · intro h
    exact h.1
  · intro h
    exact ⟨h, by linarith⟩

/-- **Off the line one side is long.** A rectangle of the same area that is not
the square has a side above the square's. -/
theorem long_side_of_off_line {b : ℝ} (hb : 1 < b) {ρ : ℂ} (h : ρ.re ≠ 1 / 2) :
    Real.sqrt b < max ‖(b : ℂ) ^ ρ‖ ‖(b : ℂ) ^ (1 - ρ)‖ := by
  have hb0 : 0 < b := by linarith
  rw [Complex.norm_cpow_eq_rpow_re_of_pos hb0, Complex.norm_cpow_eq_rpow_re_of_pos hb0,
    Real.sqrt_eq_rpow, lt_max_iff]
  rcases lt_or_gt_of_ne h with h' | h'
  · right
    apply Real.rpow_lt_rpow_of_exponent_lt hb
    simp only [Complex.sub_re, Complex.one_re]
    linarith
  · left
    exact Real.rpow_lt_rpow_of_exponent_lt hb h'

/-- **The force is the shape.** The restoring force is the logarithm of the
ratio of the two sides. -/
theorem restoringForce_eq_log_ratio {b : ℝ} (hb : 0 < b) (ρ : ℂ) :
    restoringForce b ρ = |Real.log (‖(b : ℂ) ^ ρ‖ / ‖(b : ℂ) ^ (1 - ρ)‖)| := by
  unfold restoringForce
  have h1 : ‖(b : ℂ) ^ ρ‖ ≠ 0 := by
    rw [Complex.norm_cpow_eq_rpow_re_of_pos hb]
    exact (Real.rpow_pos_of_pos hb _).ne'
  have h2 : ‖(b : ℂ) ^ (1 - ρ)‖ ≠ 0 := by
    rw [Complex.norm_cpow_eq_rpow_re_of_pos hb]
    exact (Real.rpow_pos_of_pos hb _).ne'
  rw [Real.log_div h1 h2]

/-- info: 'MirrorArea.mirror_area' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mirror_area

/-- info: 'MirrorArea.square_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms square_iff

/-- info: 'MirrorArea.long_side_of_off_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms long_side_of_off_line

end

end MirrorArea
