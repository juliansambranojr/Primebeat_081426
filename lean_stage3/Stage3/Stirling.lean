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

/-- **The last analytic fact of the Stirling half:** the digamma
comparison. Component one: `|Re ψ(1/4 + it/2) − log(t/2)| ≤ C/t` for
`t ≥ 1` — the textbook `ψ(z) = log z + O(1/|z|)` on the quarter-line.
Component two: `|Re ψ| ≤ C` on `[0, 1]` — boundedness on the compact
piece. Both classical; the discharge route is the dependency's
sorry-free `digamma_eq_tsum` series. -/
def StmtDigammaLog (C : ℝ) : Prop :=
  (∀ t : ℝ, 1 ≤ t → |phasePoint t - Real.log (t / 2)| ≤ C / t) ∧
    ∀ t ∈ Set.Icc (0 : ℝ) 1, |phasePoint t| ≤ C

/-- **The Stirling half, reduced to the digamma comparison:**
`StmtDigammaLog C` gives `StmtBacklundPhase phaseTheta C (C + 1)`. The
proof splits the phase integral at `1`, bounds the compact piece by
`C`, integrates the `C/t` band to `C·log T`, evaluates the main term
by `integral_log_half`, and watches the `T`-terms cancel exactly
against the RvM main term — the `7/8` mismatch and the integration
constants land inside `C + 1`. -/
theorem backlundPhase_of_digammaLog {C : ℝ} (hC : 0 ≤ C)
    (h : StmtDigammaLog C) : StmtBacklundPhase phaseTheta C (C + 1) := by
  obtain ⟨hband, hlow⟩ := h
  intro T hT
  have hT0 : (0 : ℝ) < T := by linarith
  have hT1 : (1 : ℝ) ≤ T := by linarith
  have hπ : (3 : ℝ) < Real.pi := Real.pi_gt_three
  have hlog2hi : Real.log 2 < 0.6931471808 := Real.log_two_lt_d9
  have hlog2lo : (0.6931471803 : ℝ) < Real.log 2 := Real.log_two_gt_d9
  have hlogT : (0 : ℝ) < Real.log T := Real.log_pos (by linarith)
  -- split the phase integral at 1
  have hsplit : (∫ t in (0 : ℝ)..T, phasePoint t)
      = (∫ t in (0 : ℝ)..1, phasePoint t)
        + ∫ t in (1 : ℝ)..T, phasePoint t :=
    (intervalIntegral.integral_add_adjacent_intervals
      (intervalIntegrable_phasePoint 0 1)
      (intervalIntegrable_phasePoint 1 T)).symm
  have hint_log : IntervalIntegrable (fun t => Real.log (t / 2))
      MeasureTheory.volume 1 T := by
    apply ContinuousOn.intervalIntegrable
    intro t ht
    rw [Set.uIcc_of_le hT1] at ht
    have ht0 : (0 : ℝ) < t := by linarith [ht.1]
    exact ((Real.continuousAt_log (by positivity)).comp
      (by fun_prop : ContinuousAt (fun u : ℝ => u / 2) t)).continuousWithinAt
  have hdiff_int : IntervalIntegrable
      (fun t => phasePoint t - Real.log (t / 2)) MeasureTheory.volume 1 T :=
    (intervalIntegrable_phasePoint 1 T).sub hint_log
  have hdecomp : (∫ t in (1 : ℝ)..T, phasePoint t)
      = (∫ t in (1 : ℝ)..T, Real.log (t / 2))
        + ∫ t in (1 : ℝ)..T, (phasePoint t - Real.log (t / 2)) := by
    rw [← intervalIntegral.integral_add hint_log hdiff_int]
    apply intervalIntegral.integral_congr
    intro t _
    ring
  -- the compact piece
  have hE1 : |∫ t in (0 : ℝ)..1, phasePoint t| ≤ C := by
    have hb := intervalIntegral.norm_integral_le_of_norm_le
      (μ := MeasureTheory.volume) (f := phasePoint) (g := fun _ => C)
      (by norm_num : (0 : ℝ) ≤ 1) ?_ intervalIntegrable_const
    · rw [Real.norm_eq_abs] at hb
      simpa using hb
    · filter_upwards with t ht
      rw [Real.norm_eq_abs]
      exact hlow t ⟨le_of_lt ht.1, ht.2⟩
  -- the band piece
  have hE2 : |∫ t in (1 : ℝ)..T, (phasePoint t - Real.log (t / 2))|
      ≤ C * Real.log T := by
    have h0T : (0 : ℝ) ∉ Set.uIcc 1 T := by
      rw [Set.uIcc_of_le hT1]
      rintro ⟨h01, _⟩
      linarith
    have hgint : (∫ t in (1 : ℝ)..T, C * t⁻¹) = C * Real.log T := by
      rw [intervalIntegral.integral_const_mul, integral_inv h0T]
      simp
    have hb := intervalIntegral.norm_integral_le_of_norm_le
      (μ := MeasureTheory.volume)
      (f := fun t => phasePoint t - Real.log (t / 2))
      (g := fun t => C * t⁻¹) hT1 ?_ ?_
    · rw [Real.norm_eq_abs, hgint] at hb
      exact hb
    · filter_upwards with t ht
      have ht1 : (1 : ℝ) ≤ t := le_of_lt ht.1
      rw [Real.norm_eq_abs]
      have := hband t ht1
      rw [div_eq_mul_inv] at this
      exact this
    · apply ContinuousOn.intervalIntegrable
      apply ContinuousOn.mul continuousOn_const
      intro t ht
      rw [Set.uIcc_of_le hT1] at ht
      have ht0 : t ≠ 0 := by
        have := ht.1
        intro h0
        rw [h0] at this
        linarith
      exact (continuousAt_inv₀ ht0).continuousWithinAt
  -- assemble
  unfold phaseTheta
  rw [hsplit, hdecomp, integral_log_half hT1]
  unfold Kadiri.zetaCountingMainTerm
  set E₁ : ℝ := ∫ t in (0 : ℝ)..1, phasePoint t with hE₁def
  set E₂ : ℝ := ∫ t in (1 : ℝ)..T, (phasePoint t - Real.log (t / 2)) with hE₂def
  have hkey : Real.log (T / (2 * Real.pi))
      = Real.log (T / 2) - Real.log Real.pi := by
    rw [Real.log_div (by linarith) (by positivity),
      Real.log_div (by linarith) (by norm_num),
      Real.log_mul (by norm_num) (by positivity)]
    ring
  have hexpand : 1 / 2 * (E₁ + (T * Real.log (T / 2) - T + 1 + Real.log 2 + E₂))
        - T / 2 * Real.log Real.pi
      = Real.pi * (T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))
          - T / (2 * Real.pi))
        + (E₁ + E₂) / 2 + (1 + Real.log 2) / 2 := by
    rw [hkey]
    field_simp
    ring
  rw [hexpand]
  have hπ0 : Real.pi ≠ 0 := by positivity
  have hred : (Real.pi * (T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))
        - T / (2 * Real.pi)) + (E₁ + E₂) / 2 + (1 + Real.log 2) / 2) / Real.pi
        + 1
        - (T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))
          - T / (2 * Real.pi) + 7 / 8)
      = (E₁ + E₂) / (2 * Real.pi) + (1 + Real.log 2) / (2 * Real.pi) + 1 / 8 := by
    field_simp
    ring
  rw [hred]
  -- the numeric close
  have h2π : (0 : ℝ) < 2 * Real.pi := by positivity
  have hA : (0 : ℝ) ≤ (1 + Real.log 2) / (2 * Real.pi) := by positivity
  have hfin1 : |(E₁ + E₂) / (2 * Real.pi) + (1 + Real.log 2) / (2 * Real.pi) + 1 / 8|
      ≤ |(E₁ + E₂) / (2 * Real.pi)| + (1 + Real.log 2) / (2 * Real.pi) + 1 / 8 := by
    calc |(E₁ + E₂) / (2 * Real.pi) + (1 + Real.log 2) / (2 * Real.pi) + 1 / 8|
        ≤ |(E₁ + E₂) / (2 * Real.pi) + (1 + Real.log 2) / (2 * Real.pi)|
            + |(1 : ℝ) / 8| := abs_add_le _ _
      _ ≤ |(E₁ + E₂) / (2 * Real.pi)| + |(1 + Real.log 2) / (2 * Real.pi)|
            + |(1 : ℝ) / 8| := by
          have h := abs_add_le ((E₁ + E₂) / (2 * Real.pi))
            ((1 + Real.log 2) / (2 * Real.pi))
          linarith [h]
      _ = |(E₁ + E₂) / (2 * Real.pi)| + (1 + Real.log 2) / (2 * Real.pi)
            + 1 / 8 := by
          rw [abs_of_nonneg hA, abs_of_nonneg (by norm_num : (0 : ℝ) ≤ (1 : ℝ) / 8)]
  refine le_trans hfin1 ?_
  have hsum : |E₁ + E₂| ≤ C + C * Real.log T :=
    le_trans (abs_add_le E₁ E₂) (add_le_add hE1 hE2)
  have habs1 : |(E₁ + E₂) / (2 * Real.pi)| ≤ (C + C * Real.log T) / (2 * Real.pi) := by
    rw [abs_div, abs_of_pos h2π]
    gcongr
  have t1 : (C + C * Real.log T) / (2 * Real.pi) ≤ C + C * Real.log T := by
    apply div_le_self (by positivity) (by nlinarith)
  have t2 : (1 + Real.log 2) / (2 * Real.pi) ≤ 1 / 2 := by
    rw [div_le_iff₀ h2π]
    nlinarith
  linarith [habs1, t1, t2]

end

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Stage3.backlundPhase_of_digammaLog' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.backlundPhase_of_digammaLog

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
