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

/-- Per-term bound for the digamma series on the quarter-line segment:
`‖1/(n+1) − 1/(n+z)‖ ≤ 4/(n+1)²` whenever `re z = 1/4` and `‖z−1‖ ≤ 1`. -/
theorem digamma_term_norm_le {z : ℂ} (hre : z.re = 1 / 4)
    (hz1 : ‖z - 1‖ ≤ 1) (n : ℕ) :
    ‖1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + z)‖ ≤ 4 / ((n : ℝ) + 1) ^ 2 := by
  have hnre : ((n : ℂ) + z).re = (n : ℝ) + 1 / 4 := by
    simp [Complex.add_re, hre]
  have hnz : ((n : ℂ) + z) ≠ 0 := by
    intro h
    rw [h] at hnre
    simp at hnre
    nlinarith [Nat.cast_nonneg (α := ℝ) n, hnre]
  have hn1 : ((n : ℂ) + 1) ≠ 0 := by
    have hcast : ((n : ℂ) + 1) = ((n + 1 : ℕ) : ℂ) := by push_cast; ring
    rw [hcast]
    exact_mod_cast Nat.succ_ne_zero n
  have hid : 1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + z)
      = (z - 1) / (((n : ℂ) + 1) * ((n : ℂ) + z)) := by
    field_simp
    ring
  rw [hid, norm_div, norm_mul, Complex.norm_natCast_add_one]
  have hzn : (n : ℝ) + 1 / 4 ≤ ‖(n : ℂ) + z‖ := by
    calc (n : ℝ) + 1 / 4 = ((n : ℂ) + z).re := hnre.symm
      _ ≤ |((n : ℂ) + z).re| := le_abs_self _
      _ ≤ ‖(n : ℂ) + z‖ := Complex.abs_re_le_norm _
  have hn1p : (0 : ℝ) < (n : ℝ) + 1 := by positivity
  have hd : ((n : ℝ) + 1) ^ 2 / 4 ≤ ((n : ℝ) + 1) * ‖(n : ℂ) + z‖ := by
    nlinarith [mul_le_mul_of_nonneg_left hzn hn1p.le,
      Nat.cast_nonneg (α := ℝ) n]
  have hdp : (0 : ℝ) < ((n : ℝ) + 1) ^ 2 / 4 := by positivity
  have hD0 : (0 : ℝ) < ((n : ℝ) + 1) * ‖(n : ℂ) + z‖ :=
    mul_pos hn1p (norm_pos_iff.mpr hnz)
  calc ‖z - 1‖ / (((n : ℝ) + 1) * ‖(n : ℂ) + z‖)
      ≤ 1 / (((n : ℝ) + 1) * ‖(n : ℂ) + z‖) := by gcongr
    _ ≤ 1 / (((n : ℝ) + 1) ^ 2 / 4) :=
        one_div_le_one_div_of_le hdp hd
    _ = 4 / ((n : ℝ) + 1) ^ 2 := by
        rw [one_div_div]

/-- **Component two of `StmtDigammaLog`, discharged with an explicit
constant:** `|Re ψ(1/4 + it/2)| ≤ 8` on `[0, 1]`. From the sorry-free
series: `|ψ| ≤ γ + Σ 4/(n+1)² = γ + 4·π²/6 < 8`. -/
theorem phasePoint_compact_le : ∀ t ∈ Set.Icc (0 : ℝ) 1, |phasePoint t| ≤ 8 := by
  intro t ht
  unfold phasePoint
  set z : ℂ := (1 : ℂ) / 4 + (t : ℂ) / 2 * Complex.I with hz
  have hre : z.re = 1 / 4 := by
    simp [hz, Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im]
  have hz1 : ‖z - 1‖ ≤ 1 := by
    have hre1 : (z - 1).re = -(3 / 4) := by
      simp [hz, Complex.sub_re, Complex.add_re, Complex.mul_re,
        Complex.I_re, Complex.I_im]
      norm_num
    have him1 : (z - 1).im = t / 2 := by
      simp [hz, Complex.sub_im, Complex.add_im, Complex.mul_im,
        Complex.I_re, Complex.I_im]
    rw [Complex.norm_eq_sqrt_sq_add_sq, hre1, him1]
    have ht1 : t ≤ 1 := ht.2
    have ht0 : 0 ≤ t := ht.1
    have hs := Real.sqrt_le_sqrt (by nlinarith :
      (-(3 / 4 : ℝ)) ^ 2 + (t / 2) ^ 2 ≤ 1)
    simpa using hs
  have hcond : ∀ n : ℕ, z ≠ -(n : ℂ) := by
    intro n h
    have h2 := congrArg Complex.re h
    rw [hre] at h2
    simp at h2
    nlinarith [Nat.cast_nonneg (α := ℝ) n, h2]
  have hψ := Complex.digamma_eq_tsum hcond
  have hsummand_le : ∀ n : ℕ,
      ‖1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + z)‖ ≤ 4 / ((n : ℝ) + 1) ^ 2 :=
    digamma_term_norm_le hre hz1
  have hg : Summable (fun n : ℕ => 4 / ((n : ℝ) + 1) ^ 2) := by
    have := Complex.summable_one_div_natCast_add_one_sq
    simpa [div_eq_mul_inv] using this.mul_left (4 : ℝ)
  have hf : Summable (fun n : ℕ =>
      ‖1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + z)‖) :=
    Summable.of_nonneg_of_le (fun n => norm_nonneg _) hsummand_le hg
  have htsum : ‖∑' n : ℕ, (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + z))‖
      ≤ ∑' n : ℕ, 4 / ((n : ℝ) + 1) ^ 2 :=
    le_trans (norm_tsum_le_tsum_norm hf) (hf.tsum_le_tsum (fun n => hsummand_le n) hg)
  have hzeta : (∑' n : ℕ, 4 / ((n : ℝ) + 1) ^ 2)
      = 4 * (Real.pi ^ 2 / 6) := by
    have hbasel := hasSum_zeta_two
    have hshift : (∑' n : ℕ, (1 : ℝ) / (n : ℝ) ^ 2)
        = (1 : ℝ) / (0 : ℝ) ^ 2 + ∑' n : ℕ, (1 : ℝ) / ((n : ℝ) + 1) ^ 2 := by
      rw [Summable.tsum_eq_zero_add hbasel.summable]
      push_cast
      ring_nf
    have h0 : (1 : ℝ) / (0 : ℝ) ^ 2 = 0 := by norm_num
    have hval : (∑' n : ℕ, (1 : ℝ) / ((n : ℝ) + 1) ^ 2) = Real.pi ^ 2 / 6 := by
      have := hbasel.tsum_eq
      rw [hshift, h0] at this
      linarith
    calc (∑' n : ℕ, 4 / ((n : ℝ) + 1) ^ 2)
        = 4 * ∑' n : ℕ, (1 : ℝ) / ((n : ℝ) + 1) ^ 2 := by
          rw [← tsum_mul_left]
          congr 1
          funext n
          ring
      _ = 4 * (Real.pi ^ 2 / 6) := by rw [hval]
  have hγ : Real.eulerMascheroniConstant < 2 / 3 :=
    Real.eulerMascheroniConstant_lt_two_thirds
  have hγ0 : (0 : ℝ) < Real.eulerMascheroniConstant :=
    lt_trans (by norm_num) Real.one_half_lt_eulerMascheroniConstant
  have hπ : Real.pi < 3.15 := Real.pi_lt_d2
  have hπ0 : (0 : ℝ) < Real.pi := Real.pi_pos
  calc |(Complex.digamma z).re| ≤ ‖Complex.digamma z‖ :=
        Complex.abs_re_le_norm _
    _ = ‖-(Real.eulerMascheroniConstant : ℂ)
          + ∑' n : ℕ, (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + z))‖ := by
        rw [hψ]
    _ ≤ ‖(-(Real.eulerMascheroniConstant : ℂ))‖
          + ‖∑' n : ℕ, (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + z))‖ :=
        norm_add_le _ _
    _ ≤ Real.eulerMascheroniConstant + 4 * (Real.pi ^ 2 / 6) := by
        have hnr : ‖(-(Real.eulerMascheroniConstant : ℂ))‖
            = Real.eulerMascheroniConstant := by
          rw [norm_neg, Complex.norm_real, Real.norm_eq_abs, abs_of_pos hγ0]
        rw [hnr, ← hzeta]
        linarith [htsum]
    _ ≤ 8 := by nlinarith

/-- The norm-vs-`t/2` log ratio on the quarter-line:
`|log‖z_t‖ − log(t/2)| ≤ 1/(4t)` for `t ≥ 1` — from
`log(1 + 1/(4t²)) ≤ 1/(4t²)`. -/
theorem log_norm_z_le {t : ℝ} (ht : 1 ≤ t) :
    |Real.log ‖(1 : ℂ) / 4 + (t : ℂ) / 2 * Complex.I‖ - Real.log (t / 2)|
      ≤ 1 / (4 * t) := by
  have ht0 : (0 : ℝ) < t := by linarith
  have hre : ((1 : ℂ) / 4 + (t : ℂ) / 2 * Complex.I).re = 1 / 4 := by
    simp [Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im]
  have him : ((1 : ℂ) / 4 + (t : ℂ) / 2 * Complex.I).im = t / 2 := by
    simp [Complex.add_im, Complex.mul_im, Complex.I_re, Complex.I_im]
  rw [Complex.norm_eq_sqrt_sq_add_sq, hre, him, Real.log_sqrt (by positivity)]
  have hlogB : Real.log (t / 2) = Real.log ((t / 2) ^ 2) / 2 := by
    rw [Real.log_pow]
    push_cast
    ring
  rw [hlogB]
  have hA : (0 : ℝ) < (1 / 4 : ℝ) ^ 2 + (t / 2) ^ 2 := by positivity
  have hB : (0 : ℝ) < ((t / 2) : ℝ) ^ 2 := by positivity
  have hcomb : Real.log ((1 / 4 : ℝ) ^ 2 + (t / 2) ^ 2) / 2
        - Real.log ((t / 2) ^ 2) / 2
      = Real.log (((1 / 4 : ℝ) ^ 2 + (t / 2) ^ 2) / ((t / 2) ^ 2)) / 2 := by
    rw [Real.log_div (ne_of_gt hA) (ne_of_gt hB)]
    ring
  rw [hcomb]
  have hratio : ((1 / 4 : ℝ) ^ 2 + (t / 2) ^ 2) / ((t / 2) ^ 2)
      = 1 + 1 / (4 * t ^ 2) := by
    field_simp
    ring
  rw [hratio]
  have hup : Real.log (1 + 1 / (4 * t ^ 2)) ≤ 1 / (4 * t ^ 2) := by
    have h := Real.log_le_sub_one_of_pos
      (by positivity : (0 : ℝ) < 1 + 1 / (4 * t ^ 2))
    have h2 : (1 + 1 / (4 * t ^ 2)) - 1 = 1 / (4 * t ^ 2) := by ring
    linarith
  have hdn : (0 : ℝ) ≤ Real.log (1 + 1 / (4 * t ^ 2)) := by
    apply Real.log_nonneg
    have h3 : (0 : ℝ) < 1 / (4 * t ^ 2) := by positivity
    linarith
  rw [abs_of_nonneg (by linarith)]
  have hqt : 1 / (4 * t ^ 2) ≤ 1 / (2 * t) :=
    one_div_le_one_div_of_le (by positivity) (by nlinarith)
  have hb : (1 : ℝ) / (2 * t) / 2 = 1 / (4 * t) := by ring
  linarith

/-- The quadratic tail sum on the quarter-line:
`Σ' 1/((n+1/4)² + (t/2)²) ≤ 12/t` for `t ≥ 1`. Head (`n < ⌊t⌋+1`) by
the `(t/2)²` floor, tail by the dependency's sorry-free
`tsum_one_div_natCast_add_add_one_sq_le`. -/
theorem inv_quadratic_tsum_le {t : ℝ} (ht : 1 ≤ t) :
    (∑' n : ℕ, (((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹) ≤ 12 / t := by
  have ht0 : (0 : ℝ) < t := by linarith
  set K : ℕ := ⌊t⌋₊ + 1 with hKdef
  have hKt : t < (K : ℝ) := by
    have h := Nat.lt_floor_add_one t
    rw [hKdef]
    push_cast
    linarith
  have hKt' : (K : ℝ) ≤ t + 1 := by
    have h := Nat.floor_le (le_of_lt ht0)
    rw [hKdef]
    push_cast
    linarith
  have hK1 : 1 ≤ K := by omega
  clear_value K
  have hg16 : Summable (fun n : ℕ => 16 / ((n : ℝ) + 1) ^ 2) := by
    have h := Complex.summable_one_div_natCast_add_one_sq
    simpa [div_eq_mul_inv] using h.mul_left (16 : ℝ)
  have hterm16 : ∀ n : ℕ,
      (((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹ ≤ 16 / ((n : ℝ) + 1) ^ 2 := by
    intro n
    have hn0 : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
    have hq : ((n : ℝ) + 1) ^ 2 / 16 ≤ ((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2 := by
      nlinarith [sq_nonneg ((t : ℝ) / 2)]
    calc (((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹
        ≤ (((n : ℝ) + 1) ^ 2 / 16)⁻¹ := inv_anti₀ (by positivity) hq
      _ = 16 / ((n : ℝ) + 1) ^ 2 := by rw [inv_div]
  have hf : Summable (fun n : ℕ => (((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹) :=
    Summable.of_nonneg_of_le (fun n => by positivity) hterm16 hg16
  have hhead : (∑ i ∈ Finset.range K,
      (((i : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹) ≤ 8 / t := by
    have hper : ∀ i ∈ Finset.range K,
        (((i : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹ ≤ (((t : ℝ) / 2) ^ 2)⁻¹ := by
      intro i _
      exact inv_anti₀ (by positivity) (le_add_of_nonneg_left (by positivity))
    have hsum := Finset.sum_le_sum hper
    rw [Finset.sum_const, Finset.card_range, nsmul_eq_mul] at hsum
    have hinv : ((((t : ℝ) / 2) ^ 2))⁻¹ = 4 / t ^ 2 := by
      rw [div_pow, inv_div]
      norm_num
    rw [hinv] at hsum
    have hKb : (K : ℝ) * (4 / t ^ 2) ≤ 8 / t := by
      have key : (K : ℝ) * 4 ≤ 8 * t := by linarith
      have e3 : (8 : ℝ) * t / t ^ 2 = 8 / t := by
        field_simp
      calc (K : ℝ) * (4 / t ^ 2) = (K : ℝ) * 4 / t ^ 2 := by ring
        _ ≤ 8 * t / t ^ 2 := by gcongr
        _ = 8 / t := e3
    linarith
  have htail : (∑' i : ℕ,
      ((((i + K : ℕ) : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹) ≤ 4 / t := by
    have htailsum : Summable (fun i : ℕ =>
        ((((i + K : ℕ) : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹) :=
      (summable_nat_add_iff K).mpr hf
    have hgbase : Summable (fun i : ℕ => 1 / (((i + K : ℕ) : ℝ) + 1) ^ 2) :=
      (summable_nat_add_iff K).mpr Complex.summable_one_div_natCast_add_one_sq
    have hgtail : Summable (fun i : ℕ => 4 / (((i + K : ℕ) : ℝ) + 1) ^ 2) := by
      simpa [div_eq_mul_inv] using hgbase.mul_left (4 : ℝ)
    have hper : ∀ i : ℕ,
        ((((i + K : ℕ) : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹
          ≤ 4 / (((i + K : ℕ) : ℝ) + 1) ^ 2 := by
      intro i
      have hm1 : (1 : ℝ) ≤ ((i + K : ℕ) : ℝ) := by
        have h1 : 1 ≤ i + K := by omega
        exact_mod_cast h1
      have hs1 : ((((i + K : ℕ) : ℝ) + 1) ^ 2) / 4
          ≤ (((i + K : ℕ) : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2 := by
        nlinarith [sq_nonneg ((t : ℝ) / 2)]
      calc ((((i + K : ℕ) : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹
          ≤ (((((i + K : ℕ) : ℝ) + 1) ^ 2) / 4)⁻¹ :=
            inv_anti₀ (by positivity) hs1
        _ = 4 / (((i + K : ℕ) : ℝ) + 1) ^ 2 := by rw [inv_div]
    have hcomp := htailsum.tsum_le_tsum hper hgtail
    have hval : (∑' i : ℕ, 4 / (((i + K : ℕ) : ℝ) + 1) ^ 2) ≤ 4 / (K : ℝ) := by
      have h4 : (∑' i : ℕ, 4 / (((i + K : ℕ) : ℝ) + 1) ^ 2)
          = 4 * ∑' i : ℕ, 1 / (((i + K : ℕ) : ℝ) + 1) ^ 2 := by
        rw [← tsum_mul_left]
        congr 1
        funext i
        ring
      rw [h4]
      have hlem := Complex.tsum_one_div_natCast_add_add_one_sq_le (N := K) hK1
      calc 4 * ∑' i : ℕ, 1 / (((i + K : ℕ) : ℝ) + 1) ^ 2
          ≤ 4 * (K : ℝ)⁻¹ :=
            mul_le_mul_of_nonneg_left hlem (by norm_num)
        _ = 4 / (K : ℝ) := by rw [div_eq_mul_inv]
    have hKinv : 4 / (K : ℝ) ≤ 4 / t := by
      gcongr
    linarith
  rw [← Summable.sum_add_tsum_nat_add (f := fun n : ℕ =>
    (((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹) K hf]
  refine le_trans (add_le_add hhead htail) (le_of_eq ?_)
  field_simp
  norm_num

/-- **The per-term log-Taylor bound** — the telescope's engine: for
`w` in the open right half-plane with `‖w‖ ≤ 2`,
`|Re w − log‖1 + w‖| ≤ 8‖w‖²`. Both sides come from
`log y ≤ y − 1` alone (applied at `1+u` and at `(1+u)⁻¹`). The `≤ 2`
radius admits the `n = 0` term of the telescope at every `t ≥ 1`. -/
theorem re_sub_log_norm_le {w : ℂ} (hw : 0 < w.re) (hw1 : ‖w‖ ≤ 2) :
    |w.re - Real.log ‖1 + w‖| ≤ 8 * ‖w‖ ^ 2 := by
  have hnw : (0 : ℝ) ≤ ‖w‖ := norm_nonneg w
  have hp : (0 : ℝ) ≤ ‖w‖ ^ 2 := by positivity
  have hwre : w.re ≤ ‖w‖ :=
    le_trans (le_abs_self _) (Complex.abs_re_le_norm _)
  have hsq : ‖w‖ ^ 2 = w.re ^ 2 + w.im ^ 2 := by
    rw [Complex.norm_eq_sqrt_sq_add_sq, Real.sq_sqrt (by positivity)]
  have hexp : ‖1 + w‖ ^ 2 = 1 + (2 * w.re + ‖w‖ ^ 2) := by
    rw [Complex.norm_eq_sqrt_sq_add_sq, Real.sq_sqrt (by positivity)]
    simp only [Complex.add_re, Complex.add_im, Complex.one_re, Complex.one_im]
    rw [hsq]
    ring
  set u : ℝ := 2 * w.re + ‖w‖ ^ 2 with hu
  have hu0 : (0 : ℝ) < u := by
    rw [hu]
    nlinarith
  have h1u : (0 : ℝ) < 1 + u := by linarith
  have hlogeq : Real.log ‖1 + w‖ = Real.log (1 + u) / 2 := by
    rw [← Real.sqrt_sq (norm_nonneg (1 + w)), Real.log_sqrt (by positivity),
      hexp]
  have hupper : Real.log (1 + u) ≤ u := by
    have h := Real.log_le_sub_one_of_pos h1u
    have h2 : (1 + u) - 1 = u := by ring
    linarith
  have hlow : u / (1 + u) ≤ Real.log (1 + u) := by
    have hinv := Real.log_le_sub_one_of_pos
      (show (0 : ℝ) < (1 + u)⁻¹ by positivity)
    rw [Real.log_inv] at hinv
    have hid : (1 + u)⁻¹ - 1 = -(u / (1 + u)) := by
      field_simp
      ring
    linarith
  set v : ℝ := u / (1 + u) with hvdef
  have hv0 : (0 : ℝ) ≤ v := by
    rw [hvdef]
    positivity
  have hval : v * (1 + u) = u := by
    rw [hvdef]
    exact div_mul_cancel₀ u (ne_of_gt h1u)
  have hvu0 : (0 : ℝ) ≤ v * u := mul_nonneg hv0 hu0.le
  have hvu : v ≤ u := by nlinarith [hval]
  have hw2w : ‖w‖ ^ 2 ≤ 2 * ‖w‖ := by nlinarith
  have hu3 : u ≤ 4 * ‖w‖ := by
    rw [hu]
    linarith [hwre, hw2w]
  have huv9 : u * v ≤ 16 * ‖w‖ ^ 2 := by
    have h1 : u * v ≤ u * u := mul_le_mul_of_nonneg_left hvu hu0.le
    have h2 : u * u ≤ 16 * ‖w‖ ^ 2 := by nlinarith [hu3, hu0]
    linarith
  rw [hlogeq, abs_le]
  constructor
  · nlinarith [hupper]
  · nlinarith [hlow, hval, huv9]

/-- The quarter-line point, named: `zq t = 1/4 + it/2`. -/
noncomputable def zq (t : ℝ) : ℂ := (1 : ℂ) / 4 + (t : ℂ) / 2 * Complex.I

theorem phasePoint_eq (t : ℝ) :
    phasePoint t = (Complex.digamma (zq t)).re := rfl

/-- Norm-square along the shifted quarter-line:
`‖n + zq t‖² = (n + 1/4)² + (t/2)²`. -/
theorem normSq_add_zq (t : ℝ) (n : ℕ) :
    ‖(n : ℂ) + zq t‖ ^ 2 = ((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2 := by
  have hre : ((n : ℂ) + zq t).re = (n : ℝ) + 1 / 4 := by
    simp [zq, Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im]
  have him : ((n : ℂ) + zq t).im = t / 2 := by
    simp [zq, Complex.add_im, Complex.mul_im, Complex.I_re, Complex.I_im]
  rw [Complex.norm_eq_sqrt_sq_add_sq, Real.sq_sqrt (by positivity), hre, him]

/-- The shifted point is never zero (its real part is `n + 1/4`). -/
theorem add_zq_ne_zero (t : ℝ) (n : ℕ) : (n : ℂ) + zq t ≠ 0 := by
  intro h
  have hre : ((n : ℂ) + zq t).re = (n : ℝ) + 1 / 4 := by
    simp [zq, Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im]
  rw [h] at hre
  simp at hre
  nlinarith [Nat.cast_nonneg (α := ℝ) n, hre]

/-- **The per-term telescope bound:** each digamma-series step tracks the
log-norm step to within `8/((n+1/4)² + (t/2)²)` on `t ≥ 1`. -/
theorem a_term_le {t : ℝ} (ht : 1 ≤ t) (n : ℕ) :
    |(((n : ℂ) + zq t)⁻¹).re
        - (Real.log ‖((n + 1 : ℕ) : ℂ) + zq t‖ - Real.log ‖(n : ℂ) + zq t‖)|
      ≤ 8 * ((((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹) := by
  have ht0 : (0 : ℝ) < t := by linarith
  set w : ℂ := ((n : ℂ) + zq t)⁻¹ with hw
  have hz0 : (n : ℂ) + zq t ≠ 0 := add_zq_ne_zero t n
  have hnormsq : ‖(n : ℂ) + zq t‖ ^ 2 = ((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2 :=
    normSq_add_zq t n
  have hnpos : (0 : ℝ) < ‖(n : ℂ) + zq t‖ := norm_pos_iff.mpr hz0
  have hhalf : (1 : ℝ) / 2 ≤ ‖(n : ℂ) + zq t‖ := by
    nlinarith [hnormsq, hnpos, Nat.cast_nonneg (α := ℝ) n, sq_nonneg ((n : ℝ) + 1 / 4)]
  -- w-facts
  have hwnorm : ‖w‖ = ‖(n : ℂ) + zq t‖⁻¹ := by
    rw [hw, norm_inv]
  have hw2 : ‖w‖ ≤ 2 := by
    rw [hwnorm]
    have h2 : ((1 : ℝ) / 2)⁻¹ = 2 := by norm_num
    calc ‖(n : ℂ) + zq t‖⁻¹ ≤ ((1 : ℝ) / 2)⁻¹ := inv_anti₀ (by norm_num) hhalf
      _ = 2 := h2
  have hwre : 0 < w.re := by
    rw [hw, Complex.inv_re]
    have hre : ((n : ℂ) + zq t).re = (n : ℝ) + 1 / 4 := by
      simp [zq, Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im]
    rw [hre]
    have hnsq : (0 : ℝ) < Complex.normSq ((n : ℂ) + zq t) := by
      rw [Complex.normSq_pos]
      exact hz0
    have hn0 : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
    positivity
  have hwsq : ‖w‖ ^ 2 = ((((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2))⁻¹ := by
    rw [hwnorm, ← hnormsq]
    rw [inv_pow]
  -- the log step is log‖1 + w‖
  have hstep : Real.log ‖((n + 1 : ℕ) : ℂ) + zq t‖ - Real.log ‖(n : ℂ) + zq t‖
      = Real.log ‖1 + w‖ := by
    have hdivpt : ((n + 1 : ℕ) : ℂ) + zq t = ((n : ℂ) + zq t) * (1 + w) := by
      rw [hw]
      field_simp
      push_cast
      ring
    rw [hdivpt, norm_mul, Real.log_mul (ne_of_gt hnpos)
      (by
        rw [norm_ne_zero_iff]
        intro h0
        rw [h0, mul_zero] at hdivpt
        exact add_zq_ne_zero t (n + 1) hdivpt)]
    ring
  rw [hstep, ← hwsq]
  exact re_sub_log_norm_le hwre hw2

end

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Stage3.phasePoint_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.phasePoint_eq

/-- info: 'Stage3.normSq_add_zq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.normSq_add_zq

/-- info: 'Stage3.add_zq_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.add_zq_ne_zero

/-- info: 'Stage3.a_term_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.a_term_le

/-- info: 'Stage3.re_sub_log_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.re_sub_log_norm_le

/-- info: 'Stage3.log_norm_z_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.log_norm_z_le

/-- info: 'Stage3.inv_quadratic_tsum_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.inv_quadratic_tsum_le

/-- info: 'Stage3.digamma_term_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.digamma_term_norm_le

/-- info: 'Stage3.phasePoint_compact_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.phasePoint_compact_le

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
