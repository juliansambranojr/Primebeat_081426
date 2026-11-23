/-
Saddle — block J7 of `lean_stage3/design/closedloop.md`. 2026-11-23.

The table as stretch-and-fold, and a zero off the line as a saddle.

Going down one row of the dyadic table doubles `N`. Every rounding of the
sieve is then doubled and folded back into the unit: the baker's map on its
first coordinate. The fold commutes with the table's mirror `x ↦ 1 − x`.

Measured against the square root of the total, one doubling multiplies the mode
of a zero by `2^ε`, `ε = Re ρ − 1/2`, and its mirror's by `2^(−ε)`. The product
is one. Off the line one factor is above one and the other below: a saddle. On
the line both are one: a centre. A saddle makes the staircase run away in the
square-root frame (`RateBelow.rain_psi`). The spiral link is the staircase not
running away there.

  fold_fract             fract (2x) = 2·fract x, less 1 past one half
  fold_rounding          the same for the rounding of 2N/d
  fold_mirror            the fold commutes with x ↦ 1 − x
  stretch_eq             stretch ρ = 2^(ε(Re ρ))
  saddle_area            stretch ρ · stretch (mirror ρ) = 1
  centre_iff             stretch ρ = 1 ↔ Re ρ = 1/2
  saddle_of_off_line     off the line: one factor above one, the other below
  saddle_runs_away       off the line: the staircase leaves every square-root bound
  centre_of_noRunaway    no runaway ⊢ every zero is a centre
  spiralLink_iff_noRunaway, spiralLink_iff_centres

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ShareLink
import Stage3.RateBelow

namespace Saddle

open Kadiri SpiralLink ClosedLoopJoin

/-! ## Stretch and fold -/

/-- **The baker's fold.** Doubling a number doubles its fractional part and
folds it back into the unit. -/
theorem fold_fract (x : ℝ) :
    Int.fract (2 * x) = if Int.fract x < 1 / 2 then 2 * Int.fract x else 2 * Int.fract x - 1 := by
  have h0 := Int.fract_nonneg x
  have h1 := Int.fract_lt_one x
  have hx := Int.floor_add_fract x
  split_ifs with h
  · rw [Int.fract_eq_iff]
    refine ⟨by linarith, by linarith, 2 * ⌊x⌋, ?_⟩
    push_cast
    linarith
  · rw [Int.fract_eq_iff]
    refine ⟨by linarith, by linarith, 2 * ⌊x⌋ + 1, ?_⟩
    push_cast
    linarith

/-- **One row down.** The rounding of `2N/d` is the rounding of `N/d`, doubled
and folded. -/
theorem fold_rounding (N d : ℕ) :
    Int.fract (2 * (N : ℝ) / (d : ℝ))
      = if Int.fract ((N : ℝ) / (d : ℝ)) < 1 / 2 then 2 * Int.fract ((N : ℝ) / (d : ℝ))
        else 2 * Int.fract ((N : ℝ) / (d : ℝ)) - 1 := by
  rw [mul_div_assoc]
  exact fold_fract _

/-- **The fold commutes with the mirror.** Away from the fold's own edge, the
fold of the mirror image is the mirror image of the fold. -/
theorem fold_mirror (x : ℝ) (h : Int.fract (2 * x) ≠ 0) :
    Int.fract (2 * (1 - x)) = 1 - Int.fract (2 * x) := by
  have e : 2 * (1 - x) = ((2 : ℤ) : ℝ) + (-(2 * x)) := by
    push_cast
    ring
  rw [e, Int.fract_intCast_add, Int.fract_neg h]

/-! ## The saddle -/

/-- The factor one doubling puts on a zero's mode, against the square root of
the total. -/
noncomputable def stretch (ρ : NontrivialZeros) : ℝ :=
  ‖((2 : ℝ) : ℂ) ^ (ρ : ℂ)‖ / Real.sqrt 2

/-- The factor is two to the closed loop's `ε`. -/
theorem stretch_eq (ρ : NontrivialZeros) : stretch ρ = (2 : ℝ) ^ epsilon (ρ : ℂ).re := by
  unfold stretch epsilon
  rw [ShareLink.mode_size (by norm_num) ρ, Real.sqrt_eq_rpow, ← Real.rpow_sub (by norm_num)]

/-- **Area one.** The factor of a zero times the factor of its mirror is one. -/
theorem saddle_area (ρ : NontrivialZeros) : stretch ρ * stretch (mirrorZ ρ) = 1 := by
  rw [stretch_eq, stretch_eq, mirrorZ_re, ← Real.rpow_add (by norm_num)]
  have h : epsilon (ρ : ℂ).re + epsilon (1 - (ρ : ℂ).re) = 0 := by
    unfold epsilon
    ring
  rw [h, Real.rpow_zero]

/-- **A centre.** The factor is one exactly on the line. -/
theorem centre_iff (ρ : NontrivialZeros) : stretch ρ = 1 ↔ (ρ : ℂ).re = 1 / 2 := by
  rw [stretch_eq]
  constructor
  · intro h
    have h1 := congrArg (Real.logb 2) h
    rw [Real.logb_rpow (by norm_num) (by norm_num), Real.logb_one] at h1
    unfold epsilon at h1
    linarith
  · intro h
    unfold epsilon
    rw [h]
    simp

/-- **A saddle.** Off the line one factor is above one and the other below. -/
theorem saddle_of_off_line (ρ : NontrivialZeros) (h : (ρ : ℂ).re ≠ 1 / 2) :
    (1 < stretch ρ ∧ stretch (mirrorZ ρ) < 1) ∨ (stretch ρ < 1 ∧ 1 < stretch (mirrorZ ρ)) := by
  rw [stretch_eq, stretch_eq, mirrorZ_re]
  rcases lt_or_gt_of_ne h with hlt | hgt
  · right
    refine ⟨Real.rpow_lt_one_of_one_lt_of_neg (by norm_num) ?_, Real.one_lt_rpow (by norm_num) ?_⟩
    · unfold epsilon; linarith
    · unfold epsilon; linarith
  · left
    refine ⟨Real.one_lt_rpow (by norm_num) ?_, Real.rpow_lt_one_of_one_lt_of_neg (by norm_num) ?_⟩
    · unfold epsilon; linarith
    · unfold epsilon; linarith

/-- **A saddle runs away.** If some zero is off the line, the staircase leaves
every bound of square-root size, beyond every start. -/
theorem saddle_runs_away (ρ : NontrivialZeros) (h : (ρ : ℂ).re ≠ 1 / 2)
    (C : ℝ) (k : ℕ) (x₀ : ℝ) :
    ∃ x : ℝ, x₀ ≤ x ∧ C * x ^ ((1 : ℝ) / 2) * Real.log x ^ k < |Chebyshev.psi x - x| := by
  rcases lt_or_gt_of_ne h with hlt | hgt
  · have hm : (1 : ℝ) / 2 < ((mirrorZ ρ : NontrivialZeros) : ℂ).re := by
      rw [mirrorZ_re]; linarith
    exact RateBelow.rain_psi (mirrorZ ρ) hm C k x₀
  · exact RateBelow.rain_psi ρ hgt C k x₀

/-- The staircase does not run away in the square-root frame: from some point
on it stays within a constant times the square root times a power of the
logarithm. -/
def NoRunaway : Prop :=
  ∃ (C : ℝ) (k : ℕ) (x₀ : ℝ), Stage3.StmtPsiWeakTheta (1 / 2) C k x₀

/-- **No runaway, no saddle.** If the staircase does not run away, every zero
is a centre. -/
theorem centre_of_noRunaway (h : NoRunaway) (ρ : NontrivialZeros) : stretch ρ = 1 := by
  rw [centre_iff]
  by_contra hne
  obtain ⟨C, k, x₀, hb⟩ := h
  obtain ⟨x, hx, hlt⟩ := saddle_runs_away ρ hne C k x₀
  exact absurd (hb x hx) (not_le.mpr hlt)

/-- **The loop is every zero a centre.** -/
theorem spiralLink_iff_centres :
    SpiralLink.SpiralLink ↔ ∀ ρ : NontrivialZeros, stretch ρ = 1 := by
  rw [← SpiralLink.rh_iff_spiralLink, ClosedLoopJoin.rh_iff_re_half]
  exact forall_congr' fun ρ => (centre_iff ρ).symm

/-- **The loop is the staircase not running away.** -/
theorem spiralLink_iff_noRunaway : SpiralLink.SpiralLink ↔ NoRunaway := by
  constructor
  · intro hS
    have hRH : RiemannHypothesis := SpiralLink.rh_iff_spiralLink.mpr hS
    have hfree : Stage3.StmtZeroFreeRight (1 / 2) := by
      intro s hs hs1 hz
      have hre := hRH s hz (by
        rintro ⟨n, rfl⟩
        have h2 : (-2 * ((n : ℂ) + 1)).re = -2 * ((n : ℝ) + 1) := by simp
        rw [h2] at hs
        have hn : (0 : ℝ) ≤ n := Nat.cast_nonneg n
        linarith) hs1
      linarith
    obtain ⟨C, _, x₀, hb⟩ :=
      (Stage3.zeroFreeRight_iff_psiWeakTheta (le_refl _) (by norm_num)).mp hfree
    exact ⟨C, 3, x₀, hb⟩
  · intro h
    exact spiralLink_iff_centres.mpr (centre_of_noRunaway h)

/-- info: 'Saddle.fold_rounding' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms fold_rounding

/-- info: 'Saddle.fold_mirror' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms fold_mirror

/-- info: 'Saddle.saddle_area' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms saddle_area

/-- info: 'Saddle.saddle_of_off_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms saddle_of_off_line

/-- info: 'Saddle.saddle_runs_away' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms saddle_runs_away

/-- info: 'Saddle.spiralLink_iff_noRunaway' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms spiralLink_iff_noRunaway

end Saddle
