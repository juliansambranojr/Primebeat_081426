/-
Transform — block G's geometry: the strip, the annulus, and what closes it.

`papers/Euler-Factor-Chain.md` § G is listed as **not formalised** in
`lean/BUILD.md`, and most of it is measurement (G2, G4, G5, G7 from O39) or
literature (G3 Jentzsch, G9 Hardy, G10 Odlyzko–te Riele). This file takes the
part that is geometry.

THE PICTURE. `z = b^(−s)` carries the s-plane to `ℂ*`. A vertical line
`Re s = σ` becomes the circle `|z| = b^(−σ)`, so the critical strip becomes an
annulus and the critical line becomes the circle of radius `b^(−1/2)`.

TWO GENERATORS, AND ONE OF THEM WAS MISSING FROM THE RECORD.

  * `s ↦ s + 2πi/log b` leaves `z` fixed. That is the pole lattice
    `Chain.sym_eq_zero_iff` proves, and it is why the strip becomes an annulus
    rather than a plane.
  * `s ↦ s + 1` sends `z ↦ z/b`. **This is the identification that closes the
    annulus into a torus**: `ℂ* / b^ℤ`. At `b = 2` it identifies
    `|z| = 0.5 ~ 1 ~ 2 ~ 4 …`, so every 2:1 annulus is a fundamental domain.

`papers/Euler-Factor-Chain.md` § G7 states the annulus `b^(−1) < |z| < b^(−1/2)`
and its modulus `(log b)/4π`, measured by O39. That annulus has ratio `√b`, so it
is **half a fundamental domain** of `ℂ* / b^ℤ`, whose modulus is `(log b)/2π`.
The record has the number and not the identification. See notes entry 84.

AND THE FUNCTIONAL EQUATION BECOMES AN INVERSION. `s ↦ 1 − s`, whose fixed set
is the critical line, becomes `z ↦ b^(−1)/z` — inversion in the circle
`|z| = b^(−1/2)`. Same fact as `EulerFactorChain.h_functional_equation`, read in
`z`.

WHAT IS NOT HERE. G1's Cauchy–Hadamard radius, G3's Jentzsch, G8's RH
equivalence, and every measured radius. Those stay observations, and G8 is an
equivalent restatement of RH "of identical difficulty" by the paper's own words.
-/
import Mathlib
import EulerFactorChain

open Complex

namespace Transform

variable {b : ℝ}

/-- **The map.** `z = b^(−s)` sends the vertical line `Re s = σ` to the circle
`|z| = b^(−σ)`. -/
theorem norm_zmap (hb : 0 < b) (s : ℂ) :
    ‖(b : ℂ) ^ (-s)‖ = b ^ (-s.re) := by
  rw [Complex.norm_cpow_eq_rpow_re_of_pos hb]
  simp

/-- The critical line lands on the circle of radius `b^(−1/2)`. -/
theorem norm_zmap_critical (hb : 0 < b) (γ : ℝ) :
    ‖(b : ℂ) ^ (-((1 : ℂ)/2 + γ * I))‖ = b ^ (-(1:ℝ)/2) := by
  rw [norm_zmap hb]
  norm_num

/-- **The deck transformation.** `s ↦ s + 1` becomes `z ↦ z / b`. This is the
identification that closes the annulus into a torus: `ℂ* / b^ℤ`. -/
theorem zmap_shift (hb : 0 < b) (s : ℂ) :
    (b : ℂ) ^ (-(s + 1)) = (b : ℂ) ^ (-s) / (b : ℂ) := by
  have h : (b : ℂ) ≠ 0 := by exact_mod_cast hb.ne'
  rw [show -(s + 1) = -s + (-1 : ℂ) by ring, Complex.cpow_add _ _ h]
  simp [Complex.cpow_neg_one, div_eq_mul_inv]

/-- **The other generator.** `s ↦ s + 2πi/log b` leaves `z` fixed — that is the
pole lattice, and it is why the strip maps to an annulus rather than a plane. -/
theorem zmap_period (hb : 0 < b) (hb1 : b ≠ 1) (s : ℂ) :
    (b : ℂ) ^ (-(s + 2 * Real.pi * I / Real.log b)) = (b : ℂ) ^ (-s) := by
  have h : (b : ℂ) ≠ 0 := by exact_mod_cast hb.ne'
  have hl : (Real.log b : ℂ) ≠ 0 := by
    exact_mod_cast Real.log_ne_zero_of_pos_of_ne_one hb hb1
  have hclog : Complex.log (b : ℂ) = (Real.log b : ℂ) := (Complex.ofReal_log hb.le).symm
  rw [Complex.cpow_def_of_ne_zero h, Complex.cpow_def_of_ne_zero h, hclog,
      show (Real.log b : ℂ) * -(s + 2 * (Real.pi : ℂ) * I / (Real.log b : ℂ))
        = (Real.log b : ℂ) * -s + -(2 * (Real.pi : ℂ) * I) from by field_simp; ring,
      Complex.exp_add, Complex.exp_neg, Complex.exp_two_pi_mul_I]
  simp

/-- **The functional equation, in `z`.** `s ↦ 1 − s` becomes `z ↦ b^(−1)/z`,
inversion in the circle `|z| = b^(−1/2)` — which is the critical line. -/
theorem zmap_functional_equation (hb : 0 < b) (s : ℂ) :
    (b : ℂ) ^ (-((1 : ℂ) - s)) = (b : ℂ) ^ (-(1 : ℂ)) / (b : ℂ) ^ (-s) := by
  have h : (b : ℂ) ≠ 0 := by exact_mod_cast hb.ne'
  rw [show -((1:ℂ) - s) = -(1:ℂ) - (-s) by ring, Complex.cpow_sub _ _ h]

/-- **G7's modulus.** The annulus between the two radii has conformal modulus
`(log b)/4π`. Its ratio is `√b`, so it is half a fundamental domain of
`ℂ* / b^ℤ`, whose modulus is `(log b)/2π`. -/
theorem annulus_modulus (hb : 0 < b) :
    Real.log (b ^ (-(1:ℝ)/2) / b ^ (-(1:ℝ))) / (2 * Real.pi)
      = Real.log b / (4 * Real.pi) := by
  rw [← Real.rpow_sub hb, show -(1:ℝ)/2 - -(1:ℝ) = (1:ℝ)/2 by ring,
      Real.log_rpow hb]
  ring

/-! ## Axiom check

Every theorem here is ℂ-valued, so `Classical.choice` is the floor and stays.
`lean/BUILD.md` § Mathlib-free core has why that is the distinction to watch.
-/

/-- info: 'Transform.norm_zmap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Transform.norm_zmap

/-- info: 'Transform.norm_zmap_critical' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Transform.norm_zmap_critical

/-- info: 'Transform.zmap_shift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Transform.zmap_shift

/-- info: 'Transform.zmap_period' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Transform.zmap_period

/-- info: 'Transform.zmap_functional_equation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Transform.zmap_functional_equation

/-- info: 'Transform.annulus_modulus' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Transform.annulus_modulus

end Transform
