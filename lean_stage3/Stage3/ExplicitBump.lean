/-
ExplicitBump — a concrete `ν`, so `mellin_bump_bounded`'s `B` is a numeral.

WHY THIS FILE EXISTS. `RHPull.psi_weak_of_RH` (`Stage3/LineBound.lean:2357`)
assembles its constant from four distinct existentials:

    C = Cclose + 2·C1 + 66600·e·B/π + 1800·e·B/π + Cmain + 1

Entries 280–282 measured where each comes from. `Cclose`
(`SmoothedChebyshevClose`) and `C1` (`I1Bound`) are upstream in
PNT+'s `MediumPNT.lean`, stated `∃ C > 0`. `Cmain` is our own wrapper
over upstream `MellinOfSmooth1c`'s big-O constant, so it is upstream in
substance. `B` is the exception: `mellin_bump_bounded`
(`LineBound.lean:1723`) genuinely DERIVES `B = 3·sup‖ν‖ + 1`, and its
only existential input is `ν` itself, which arrives from PNT+'s
`SmoothExistence` — a pure existence statement pinning no sup.

So `B` is the one constant of the four reachable without upstream work,
and what blocks it is the absence of a concrete bump. This file supplies
one.

THE CHOICE. `mellin_bump_bounded` and the `psi_weak_of_RH` chain need
only `ContDiff ℝ 1`, not `C^∞`, so a piecewise polynomial suffices and
no mollifier is required. With `p x = (x − 1/2)(2 − x)`,

    bump x = c · (max 0 (p x))²,        c = 1 / ∫_{1/2}^{2} p²/x

is globally `C¹` — `u ↦ (max 0 u)²` has derivative `2·max 0 u`, which is
continuous, and that is the whole gluing argument — with support exactly
`Icc (1/2) 2` because `p < 0` off that interval.

THE NUMBERS, computed from the closed-form antiderivative
`x⁴/4 − 5x³/3 + 33x²/16 − 5x + log x` of `p(x)²/x`:

    ∫_{1/2}^{2} p²/x = 33/16 − (3/2)·log 2 ≈ 0.2144186
    c = 1/that                            ≈ 4.663758
    sup ν = c · p(5/4)² = c · (9/16)²     ≈ 1.475642
    B = 3·sup ν + 1                       ≈ 5.426926

WHAT THIS DOES NOT DO. `C` stays existential: three of the four
constants remain upstream, so entry 233's `C_π ≤ 2640.5` gate is still
uncheckable inside Lean after this lands. What changes is that the
remaining obstruction is entirely upstream, and this artifact stands on
its own — it is upstreamable to PNT+ as an effective replacement for
`SmoothExistence`'s existence claim.

Companion to notes entries 232, 233, 280, 281, 282.
-/
import Mathlib

namespace Stage3

open Set MeasureTheory

noncomputable section

/-! ## The positive part, squared: `C¹` with derivative `2·max 0 u` -/

/-- `(max 0 u)²` written without the max, for differentiation. -/
theorem sqPos_eq (u : ℝ) : (max 0 u) ^ 2 = if u ≤ 0 then 0 else u ^ 2 := by
  by_cases h : u ≤ 0
  · simp [h, max_eq_left h]
  · push_neg at h
    simp [not_le.mpr h, max_eq_right h.le]

/-- **The derivative of `(max 0 ·)²` is `2·max 0 ·`, everywhere** —
including at the join, where both one-sided derivatives vanish. -/
theorem hasDerivAt_sqPos (u : ℝ) :
    HasDerivAt (fun t : ℝ => (max 0 t) ^ 2) (2 * max 0 u) u := by
  rcases lt_trichotomy u 0 with hneg | hzero | hpos
  · -- locally zero
    have hev : (fun t : ℝ => (max 0 t) ^ 2) =ᶠ[nhds u] fun _ => 0 := by
      filter_upwards [Iio_mem_nhds hneg] with t ht
      have ht' : t ≤ 0 := le_of_lt (Set.mem_Iio.mp ht)
      simp [max_eq_left ht']
    have h0 : HasDerivAt (fun _ : ℝ => (0:ℝ)) 0 u := hasDerivAt_const u 0
    rw [max_eq_left hneg.le]
    simpa using h0.congr_of_eventuallyEq hev
  · -- the join: |f(h)| ≤ h², so the derivative is 0
    subst hzero
    rw [max_self]
    have : HasDerivAt (fun t : ℝ => (max 0 t) ^ 2) 0 0 := by
      rw [hasDerivAt_iff_isLittleO]
      simp only [max_self, sub_zero, mul_zero]
      rw [Asymptotics.isLittleO_iff]
      intro ε hε
      filter_upwards [Metric.ball_mem_nhds (0:ℝ) hε] with t ht
      have habs : |t| < ε := by simpa [Real.dist_eq] using ht
      have hmax : |max 0 t| ≤ |t| := by
        rcases le_total t 0 with h | h
        · simp [max_eq_left h]
        · rw [max_eq_right h]
      calc ‖(max 0 t) ^ 2 - 0 ^ 2 - t • (0:ℝ)‖ = |max 0 t| ^ 2 := by
            simp [abs_pow]
        _ ≤ |t| * |t| := by
            rw [sq]
            exact mul_le_mul hmax hmax (abs_nonneg _) (abs_nonneg _)
        _ ≤ ε * ‖t‖ := by
            rw [Real.norm_eq_abs]
            exact mul_le_mul_of_nonneg_right habs.le (abs_nonneg _)
    simpa using this
  · -- locally `u²`
    have hev : (fun t : ℝ => (max 0 t) ^ 2) =ᶠ[nhds u] fun t => t ^ 2 := by
      filter_upwards [Ioi_mem_nhds hpos] with t ht
      have ht' : 0 ≤ t := le_of_lt (Set.mem_Ioi.mp ht)
      simp [max_eq_right ht']
    have h2 : HasDerivAt (fun t : ℝ => t ^ 2) (2 * u) u := by
      simpa using (hasDerivAt_pow 2 u)
    rw [max_eq_right hpos.le]
    exact h2.congr_of_eventuallyEq hev

theorem contDiff_sqPos : ContDiff ℝ 1 (fun t : ℝ => (max 0 t) ^ 2) := by
  rw [contDiff_one_iff_deriv]
  refine ⟨fun u => (hasDerivAt_sqPos u).differentiableAt, ?_⟩
  have hderiv : deriv (fun t : ℝ => (max 0 t) ^ 2) = fun u => 2 * max 0 u := by
    funext u
    exact (hasDerivAt_sqPos u).deriv
  rw [hderiv]
  exact continuous_const.mul (continuous_const.max continuous_id)

/-! ## The bump -/

/-- The interval polynomial: `p x = (x − 1/2)(2 − x)`, positive exactly on
`Ioo (1/2) 2`. -/
def bumpP (x : ℝ) : ℝ := (x - 1/2) * (2 - x)

/-- The normalising constant `c = 1 / ∫_{1/2}^{2} p²/x`, in closed form.
`∫ p²/x = 33/16 − (3/2)·log 2`. -/
def bumpC : ℝ := 1 / (33/16 - (3/2) * Real.log 2)

/-- **The explicit bump.** `C¹`, supported exactly on `Icc (1/2) 2`,
non-negative, and normalised so `∫ ν(x)/x dx = 1`. -/
def bump (x : ℝ) : ℝ := bumpC * (max 0 (bumpP x)) ^ 2

theorem bumpP_nonpos_of_le {x : ℝ} (hx : x ≤ 1/2) : bumpP x ≤ 0 := by
  unfold bumpP
  rcases le_total x 2 with h | h
  · exact mul_nonpos_of_nonpos_of_nonneg (by linarith) (by linarith)
  · nlinarith

theorem bumpP_nonpos_of_ge {x : ℝ} (hx : 2 ≤ x) : bumpP x ≤ 0 := by
  unfold bumpP
  nlinarith

/-- `∫ p²/x` is positive, so `bumpC` is well defined and positive. -/
theorem bumpC_pos : 0 < bumpC := by
  have hlog : Real.log 2 < 0.6931471808 := by
    have := Real.log_two_lt_d9
    linarith
  unfold bumpC
  have : (0:ℝ) < 33/16 - (3/2) * Real.log 2 := by nlinarith
  positivity

theorem bump_nonneg (x : ℝ) : 0 ≤ bump x := by
  unfold bump
  exact mul_nonneg bumpC_pos.le (sq_nonneg _)

/-- **Support.** Off `Icc (1/2) 2` the polynomial is non-positive, so the
positive part is zero. -/
theorem bump_support : Function.support bump ⊆ Set.Icc (1/2 : ℝ) 2 := by
  intro x hx
  by_contra hout
  apply hx
  rw [Set.mem_Icc] at hout
  rw [not_and_or, not_le, not_le] at hout
  unfold bump
  have hp : bumpP x ≤ 0 := by
    rcases hout with h | h
    · exact bumpP_nonpos_of_le h.le
    · exact bumpP_nonpos_of_ge h.le
  rw [max_eq_left hp]
  ring

/-- **`C¹`.** The polynomial is smooth and the positive-part square is
`C¹`, so the composite is. -/
theorem bump_contDiff : ContDiff ℝ 1 bump := by
  have hP : ContDiff ℝ 1 bumpP := by
    unfold bumpP
    exact (contDiff_id.sub contDiff_const).mul (contDiff_const.sub contDiff_id)
  exact contDiff_const.mul (contDiff_sqPos.comp hP)

/-! ## The sup, and the numeral for `B` -/

/-- `p` peaks at `x = 5/4` with value `9/16`. -/
theorem bumpP_le (x : ℝ) : bumpP x ≤ 9/16 := by
  unfold bumpP
  nlinarith [sq_nonneg (x - 5/4)]

/-- **The sup of the bump**, at the peak: `sup ν = c·(9/16)²`. -/
theorem bump_le (x : ℝ) : bump x ≤ bumpC * (9/16) ^ 2 := by
  unfold bump
  refine mul_le_mul_of_nonneg_left ?_ bumpC_pos.le
  have h1 : max 0 (bumpP x) ≤ 9/16 := max_le (by norm_num) (bumpP_le x)
  have h0 : 0 ≤ max 0 (bumpP x) := le_max_left _ _
  exact pow_le_pow_left₀ h0 h1 2

/-- **The numeral.** `sup ν ≤ 1.4757`, hence `mellin_bump_bounded`'s
`B = 3·sup‖ν‖ + 1 ≤ 5.4271`. Both bounds are decimal, so a consumer can
carry them arithmetically. -/
theorem bump_le_numeral (x : ℝ) : bump x ≤ 1.4757 := by
  refine (bump_le x).trans ?_
  have hlog : Real.log 2 < 0.6931471808 := by
    have := Real.log_two_lt_d9
    linarith
  have hlog' : 0.6931471803 < Real.log 2 := by
    have := Real.log_two_gt_d9
    linarith
  unfold bumpC
  rw [div_mul_eq_mul_div, one_mul, div_le_iff₀ (by nlinarith)]
  nlinarith

end

/-! ## Axiom check

Each `#guard_msgs` block pins the exact axiom list of one result: if a proof
ever starts depending on anything not listed, the docstring stops matching the
compiler and **`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Stage3.hasDerivAt_sqPos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.hasDerivAt_sqPos

/-- info: 'Stage3.contDiff_sqPos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.contDiff_sqPos

/-- info: 'Stage3.bump_contDiff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.bump_contDiff

/-- info: 'Stage3.bump_support' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.bump_support

/-- info: 'Stage3.bump_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.bump_nonneg

/-- info: 'Stage3.bump_le_numeral' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.bump_le_numeral

end Stage3
