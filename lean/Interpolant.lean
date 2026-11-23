/-
Interpolant — the smooth interpolant of the main term, constructed.
Block C1 of `lean_stage3/design/joints.md`. 2026-11-22.

Every gate theorem in this tree takes a function `G`, smooth on the whole
line, with derivative `2^x/x` beyond one half (`Expansion.f2x`). Until this
file none was constructed (unit 0403).

  F                  2/log 2 + ∫ t in 1..x, f2x t
  liRow              smoothTransition (4x − 1) · F x
  F_hasDerivAt       0 < x ⊢ HasDerivAt F (f2x x) x
  liRow_contDiff     ContDiff ℝ ⊤ liRow
  liRow_hasDerivAt   1/2 < x ⊢ HasDerivAt liRow (f2x x) x
  liRow_eq           1/2 ≤ x ⊢ liRow x = 2/log 2 + ∫ t in 1..x, f2x t
  tableFrom_ne_zero_of_relErr_liRow
                     `RelativeLi`'s gate theorem with `G := liRow`

`2/log 2` is the value at the row `m = 1` of `x/log x + ∫₂ˣ dt/log²t`. That
`liRow m` is that function at `2^m` is a statement about the other tree's
`Li` and is not proved here.
-/
import Mathlib
import RelativeLi

namespace Interpolant

open Set Filter Topology

noncomputable section

/-- The antiderivative of `2^x/x` through the value `2/log 2` at `x = 1`. -/
def F (x : ℝ) : ℝ := 2 / Real.log 2 + ∫ t in (1 : ℝ)..x, Expansion.f2x t

/-- The interpolant: `F` cut off smoothly below one half. -/
def liRow (x : ℝ) : ℝ := Real.smoothTransition (4 * x - 1) * F x

/-- Helper: the integrand `f2x` (`2^x/x`) is smooth on the positive half-line. -/
theorem f2x_contDiffOn : ContDiffOn ℝ (⊤ : ℕ∞) Expansion.f2x (Ioi 0) := by
  unfold Expansion.f2x
  apply ContDiffOn.div
  · exact (Real.contDiff_exp.comp (contDiff_const.mul contDiff_id)).contDiffOn
  · exact contDiff_id.contDiffOn
  · intro x hx
    exact ne_of_gt hx

/-- Helper: the integrand `f2x` is continuous on the positive half-line. -/
theorem f2x_continuousOn : ContinuousOn Expansion.f2x (Ioi 0) :=
  f2x_contDiffOn.continuousOn

/-- For `x > 0`, the antiderivative `F` has derivative `f2x x` at `x`. -/
theorem F_hasDerivAt {x : ℝ} (hx : 0 < x) : HasDerivAt F (Expansion.f2x x) x := by
  have hsub : uIcc (1 : ℝ) x ⊆ Ioi 0 := by
    intro t ht
    rcases mem_uIcc.mp ht with ⟨h1, _⟩ | ⟨h1, _⟩
    · exact lt_of_lt_of_le one_pos h1
    · exact lt_of_lt_of_le hx h1
  have hint : IntervalIntegrable Expansion.f2x MeasureTheory.volume 1 x :=
    (f2x_continuousOn.mono hsub).intervalIntegrable
  have hmeas : StronglyMeasurableAtFilter Expansion.f2x (𝓝 x) MeasureTheory.volume :=
    f2x_continuousOn.stronglyMeasurableAtFilter isOpen_Ioi x hx
  have hcont : ContinuousAt Expansion.f2x x :=
    f2x_continuousOn.continuousAt (Ioi_mem_nhds hx)
  have h := intervalIntegral.integral_hasDerivAt_right hint hmeas hcont
  unfold F
  exact h.const_add _

/-- The antiderivative `F` is smooth on the positive half-line. -/
theorem F_contDiffOn : ContDiffOn ℝ (⊤ : ℕ∞) F (Ioi 0) := by
  rw [contDiffOn_infty_iff_deriv_of_isOpen isOpen_Ioi]
  refine ⟨fun x hx => (F_hasDerivAt hx).differentiableAt.differentiableWithinAt, ?_⟩
  exact f2x_contDiffOn.congr fun x hx => (F_hasDerivAt hx).deriv

/-- The interpolant `liRow` is smooth on the whole real line. -/
theorem liRow_contDiff : ContDiff ℝ (⊤ : ℕ∞) liRow := by
  rw [contDiff_iff_contDiffAt]
  intro x
  rcases lt_or_ge x (1 / 4) with hx | hx
  · have hev : liRow =ᶠ[𝓝 x] fun _ => (0 : ℝ) := by
      filter_upwards [Iio_mem_nhds hx] with y hy
      have hy' : 4 * y - 1 ≤ 0 := by
        have : y < 1 / 4 := hy
        linarith
      unfold liRow
      rw [Real.smoothTransition.zero_of_nonpos hy', zero_mul]
    exact contDiffAt_const.congr_of_eventuallyEq hev
  · have hx0 : 0 < x := by linarith
    have h1 : ContDiffAt ℝ (⊤ : ℕ∞) (fun y : ℝ => Real.smoothTransition (4 * y - 1)) x :=
      (Real.smoothTransition.contDiff.comp
        ((contDiff_const.mul contDiff_id).sub contDiff_const)).contDiffAt
    exact h1.mul (F_contDiffOn.contDiffAt (Ioi_mem_nhds hx0))

/-- For `x ≥ 1/2`, the interpolant equals the antiderivative:
`liRow x = 2/log 2 + ∫ t in 1..x, f2x t`. -/
theorem liRow_eq {x : ℝ} (hx : 1 / 2 ≤ x) :
    liRow x = 2 / Real.log 2 + ∫ t in (1 : ℝ)..x, Expansion.f2x t := by
  unfold liRow
  rw [Real.smoothTransition.one_of_one_le (by linarith), one_mul]
  rfl

/-- For `x > 1/2`, the interpolant `liRow` has derivative `f2x x` at `x`. -/
theorem liRow_hasDerivAt {x : ℝ} (hx : x ∈ Ioi ((1 : ℝ) / 2)) :
    HasDerivAt liRow (Expansion.f2x x) x := by
  have hx' : (1 : ℝ) / 2 < x := hx
  have hev : liRow =ᶠ[𝓝 x] F := by
    filter_upwards [Ioi_mem_nhds hx'] with y hy
    have hy' : (1 : ℝ) / 2 < y := hy
    exact liRow_eq hy'.le
  exact (F_hasDerivAt (by linarith)).congr_of_eventuallyEq hev

/-- **The gate with nothing assumed about the main term.** -/
theorem tableFrom_ne_zero_of_relErr_liRow {N : ℤ → ℤ} {f : ℤ → ℝ}
    {r : ℤ} {d : ℕ} {ρ : ℝ}
    (hrow : ∀ k ∈ Finset.range (d + 2),
      ((N (r - k) : ℤ) : ℝ) = Nonvanishing.bdiffZ f (r - k))
    (hS : RelativeGate.StmtRelErrWindow f (fun k : ℤ => liRow k) r (d + 1) ρ)
    (hbot : (1 : ℝ) ≤ (r : ℝ) - (d + 1))
    (hw : 2 * (d : ℝ) ≤ Real.log 2 * ((r : ℝ) - (d + 1)))
    (hρ : ρ < Real.log 2 ^ d / (2 * r * 3 ^ (d + 1))) :
    Construction.tableFrom N r d ≠ 0 :=
  RelativeLi.tableFrom_ne_zero_of_relErr_li' liRow_contDiff
    (fun _ hx => liRow_hasDerivAt hx) hrow hS hbot hw hρ

end

/-- info: 'Interpolant.liRow_contDiff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Interpolant.liRow_contDiff

/-- info: 'Interpolant.liRow_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Interpolant.liRow_hasDerivAt

/-- info: 'Interpolant.tableFrom_ne_zero_of_relErr_liRow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Interpolant.tableFrom_ne_zero_of_relErr_liRow

/-- info: 'Interpolant.f2x_contDiffOn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Interpolant.f2x_contDiffOn

/-- info: 'Interpolant.f2x_continuousOn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Interpolant.f2x_continuousOn

/-- info: 'Interpolant.F_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Interpolant.F_hasDerivAt

/-- info: 'Interpolant.F_contDiffOn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Interpolant.F_contDiffOn

/-- info: 'Interpolant.liRow_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Interpolant.liRow_eq

end Interpolant
