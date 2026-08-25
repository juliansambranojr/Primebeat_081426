/-
Stirling — the phase construction: θ as the digamma integral.

Entry 132 made the continuous phase part of the Stirling half's
discharge. This module constructs it. The classical θ(T) is
`Im log Γ(1/4 + iT/2) − (T/2)·log π` along the continuous branch, and
the continuous branch IS the integral of the derivative:

  d/dt Im log Γ(1/4 + it/2) = Im (i/2 · ψ(1/4 + it/2))
                            = (1/2) · Re ψ(1/4 + it/2),

with `ψ = Complex.digamma` (Mathlib: `logDeriv Gamma`). So define

  phasePoint t = Re ψ(1/4 + it/2)
  phaseTheta T = (1/2)·∫₀ᵀ phasePoint − (T/2)·log π

— continuous by construction, wrap-free by construction, anchored at
`phaseTheta 0 = 0` (`= arg Γ(1/4)`, and `Γ(1/4) > 0`). This slice
lands the construction and its regularity, plus the FTC evaluation of
the main-term integral:

  continuous_phasePoint        the integrand is continuous (PNT+'s
                               sorry-free digamma continuity on re > 0)
  intervalIntegrable_phasePoint  hence integrable on every interval
  phaseTheta_zero              the anchor
  integral_log_half            ∫₁ᵀ log(t/2) dt = T·log(T/2) − T + 1 + log 2
                               — the main term, by FTC, avoiding t = 0

Next slice (the Stirling core): the explicit comparison
`|phasePoint t − log(t/2)| ≤ E(t)` from the digamma series
(`digamma_eq_tsum`, sorry-free in the dependency), integrating to the
`B₁·log T + B₃` band of `StmtBacklundPhase phaseTheta` — budget
`B₁ ≤ 100` where Rosser needs `0.137`.

Consumes (same tree, no weld): `Complex.digamma` (Mathlib),
`continuousAt_digamma_of_re_pos` (PNT+ DigammaSeries, sorry-free). The
weld caveat from Stage3.lean applies to composition with the bench.
Companion to notes entry 135.
-/
import Mathlib
import PrimeNumberTheoremAnd.Mathlib.Analysis.SpecialFunctions.Gamma.DigammaSeries
import Stage3.RvMCrude

namespace Stage3

noncomputable section

/-- The phase integrand: `Re ψ(1/4 + it/2)`, the derivative of the
continuous `Im log Γ` along the quarter-line. -/
def phasePoint (t : ℝ) : ℝ :=
  (Complex.digamma ((1 : ℂ) / 4 + (t : ℂ) / 2 * Complex.I)).re

/-- **The continuous phase**, by construction: the integral of the
derivative, anchored at `θ(0) = 0 = arg Γ(1/4)`. -/
def phaseTheta (T : ℝ) : ℝ :=
  (1 / 2) * (∫ t in (0 : ℝ)..T, phasePoint t) - T / 2 * Real.log Real.pi

/-- The integrand is continuous: the quarter-line stays in `re > 0`,
where the dependency's digamma continuity holds sorry-free. -/
theorem continuous_phasePoint : Continuous phasePoint := by
  rw [continuous_iff_continuousAt]
  intro t
  have hre : (0 : ℝ) < ((1 : ℂ) / 4 + (t : ℂ) / 2 * Complex.I).re := by
    simp [Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im]
  have hpath : ContinuousAt (fun s : ℝ => (1 : ℂ) / 4 + (s : ℂ) / 2 * Complex.I) t := by
    fun_prop
  have hdg : ContinuousAt Complex.digamma ((1 : ℂ) / 4 + (t : ℂ) / 2 * Complex.I) :=
    Complex.continuousAt_digamma_of_re_pos hre
  have hcomp : ContinuousAt
      (fun s : ℝ => Complex.digamma ((1 : ℂ) / 4 + (s : ℂ) / 2 * Complex.I)) t :=
    ContinuousAt.comp (g := Complex.digamma)
      (f := fun s : ℝ => (1 : ℂ) / 4 + (s : ℂ) / 2 * Complex.I) hdg hpath
  exact ContinuousAt.comp (g := Complex.re)
    (f := fun s : ℝ => Complex.digamma ((1 : ℂ) / 4 + (s : ℂ) / 2 * Complex.I))
    Complex.continuous_re.continuousAt hcomp

/-- Hence integrable on every interval. -/
theorem intervalIntegrable_phasePoint (a b : ℝ) :
    IntervalIntegrable phasePoint MeasureTheory.volume a b :=
  continuous_phasePoint.intervalIntegrable a b

/-- The anchor: `θ(0) = 0`. -/
theorem phaseTheta_zero : phaseTheta 0 = 0 := by
  unfold phaseTheta
  rw [intervalIntegral.integral_same]
  ring

/-- **The main-term integral, by FTC** (avoiding `t = 0` entirely):
`∫₁ᵀ log(t/2) dt = T·log(T/2) − T + 1 + log 2`. The antiderivative is
`t·log(t/2) − t`. -/
theorem integral_log_half {T : ℝ} (hT : 1 ≤ T) :
    (∫ t in (1 : ℝ)..T, Real.log (t / 2))
      = T * Real.log (T / 2) - T + 1 + Real.log 2 := by
  have hderiv : ∀ t ∈ Set.uIcc (1 : ℝ) T,
      HasDerivAt (fun u : ℝ => u * Real.log (u / 2) - u) (Real.log (t / 2)) t := by
    intro t ht
    rw [Set.uIcc_of_le hT] at ht
    have ht0 : (0 : ℝ) < t := by linarith [ht.1]
    have h1 : HasDerivAt (fun u : ℝ => u / 2) (1 / 2) t := by
      simpa using (hasDerivAt_id t).div_const 2
    have h2 : HasDerivAt (fun u : ℝ => Real.log (u / 2)) ((t / 2)⁻¹ * (1 / 2)) t := by
      have h := (Real.hasDerivAt_log (by positivity : (t / 2) ≠ 0)).comp t h1
      simpa [Function.comp_def] using h
    have h3 : HasDerivAt (fun u : ℝ => u * Real.log (u / 2))
        (1 * Real.log (t / 2) + t * ((t / 2)⁻¹ * (1 / 2))) t :=
      (hasDerivAt_id t).mul h2
    have hcancel : t * ((t / 2)⁻¹ * (1 / 2)) = 1 := by
      field_simp
    have h4 : (1 : ℝ) * Real.log (t / 2) + t * ((t / 2)⁻¹ * (1 / 2)) - 1
        = Real.log (t / 2) := by
      rw [hcancel]
      ring
    have hfin := h3.sub (hasDerivAt_id t)
    rw [h4] at hfin
    exact hfin
  have hint : IntervalIntegrable (fun t => Real.log (t / 2))
      MeasureTheory.volume 1 T := by
    apply ContinuousOn.intervalIntegrable
    intro t ht
    rw [Set.uIcc_of_le hT] at ht
    have ht0 : (0 : ℝ) < t := by linarith [ht.1]
    exact ((Real.continuousAt_log (by positivity)).comp
      (by fun_prop : ContinuousAt (fun u : ℝ => u / 2) t)).continuousWithinAt
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint]
  have h2 : Real.log ((1 : ℝ) / 2) = -Real.log 2 := by
    rw [Real.log_div (by norm_num) (by norm_num)]
    simp
  rw [h2]
  ring

end

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Stage3.continuous_phasePoint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.continuous_phasePoint

/-- info: 'Stage3.intervalIntegrable_phasePoint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.intervalIntegrable_phasePoint

/-- info: 'Stage3.phaseTheta_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.phaseTheta_zero

/-- info: 'Stage3.integral_log_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.integral_log_half

end Stage3
