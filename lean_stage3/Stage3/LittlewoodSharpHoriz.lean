/-
LittlewoodSharpHoriz — block S14 of `lean_stage3/design/stencil.md`, Turing at scale: sharper
Littlewood constants, part 3, the lower side `Turing.StmtHorizLower (113/4) 128`. 2026-11-25.

Goal (`Stage3/TuringS.lean`): for `t ≥ 2`, `∫_{1/2}^{2} log‖ζ(x + it)‖ dx ≥ −(a₂ log t + b₂)`.
`TuringLWHoriz.horizLower_holds` has `a₂ = 102`, `b₂ = 500`; this module has `a₂ = 113/4 = 28.25`,
`b₂ = 128`.

**The route** is `TuringLWHoriz`'s, with `LittlewoodSharpPoint.log_jensenF_ge` in place of
`TuringLWHorizPoint.log_jensenF_ge`. With `M = log(84 t)`, `z(x) = (x − 2)/2` (`TuringLW.zx`),
`‖z(x)‖ = (2 − x)/2` and `2M‖z‖/(25/32 − ‖z‖) = 2M (2 − x)/(x − 7/16) = 2M · bcw x`, the
integrand is at least, off the finite set `{β_ρ}`,

  `g(x) = −N log(25/16) − log 3 − 2M bcw(x) + Σ_ρ m_ρ (log(x − β_ρ) − log 2)`   (`log_zeta_ge`),

and (`integral_g_ge`), with `∫ bcw = (25/16) log 25 − 3/2 ≤ 229/64`, `∫ log(x − β) ≥ −2`,
`log(25/16) ≤ 1/2`, `N ≤ (50/9) M`:

  `∫ g ≥ −(229/32) M − N (11/4 + (3/2) log 2) − (3/2) log 3 ≥ −28.22 M − 1.65`,

and `M ≤ log t + 89/20` closes it at `−((113/4) log t + 128)`.

**Sizes, per unit of `M`** (`checks/littlewoodsharp/budget.py`): Borel–Carathéodory `18 → 7.16`;
the count `15 → 50/9`; per zero `7/2 + 3 log 2 = 5.58 → 11/4 + (3/2) log 2 = 3.79`. Total
`≈ 101.7 → 28.21`. No factor grows faster than `log t`.

| name | content | status |
|---|---|---|
| `gLow ht x` | `g(x)` above | def |
| `norm_zx_eq` | `x ≤ 2 ⊢ ‖z(x)‖ = (2 − x)/2` | proved |
| `log_zeta_ge` | `x ∈ [1/2, 2]`, `x ∉ {β_ρ}` ⊢ `g(x) ≤ log‖ζ(x + it)‖` | proved |
| `intervalIntegrable_gLow` | `g` integrable on `[1/2, 2]` | proved |
| `integral_g_ge` | `−((113/4) log t + 128) ≤ ∫_{1/2}^{2} g` | proved |
| `horizLower_sharp` | `Turing.StmtHorizLower (113/4) 128` | **proved** |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Mathlib
import Stage3.TuringLWHoriz
import Stage3.LittlewoodSharpPoint

namespace LittlewoodSharp

open Complex Stage3 MeasureTheory

noncomputable section

/-- The lower function, sharper radii. -/
def gLow {t : ℝ} (ht : 2 ≤ t) (x : ℝ) : ℝ :=
  (-(zeroMass ht * Real.log (25 / 16)) - Real.log 3) +
    (-(2 * Real.log (84 * t))) * bcw x +
    ∑ ρ ∈ zeroSet ht, (analyticOrderNatAt (jensenF t) ρ : ℝ) *
      (Real.log (x - TuringLW.beta ρ) - Real.log 2)

theorem norm_zx_eq {x : ℝ} (hx2 : x ≤ 2) : ‖TuringLW.zx x‖ = (2 - x) / 2 := by
  unfold TuringLW.zx
  rw [Complex.norm_real, Real.norm_eq_abs, abs_of_nonpos (by linarith)]
  ring

/-- The pointwise Borel–Carathéodory term on the segment is `2M · bcw x`. -/
theorem bc_eq {x M : ℝ} (hx1 : 1 / 2 ≤ x) (hx2 : x ≤ 2) :
    2 * M * ‖TuringLW.zx x‖ / (25 / 32 - ‖TuringLW.zx x‖) = 2 * M * bcw x := by
  rw [norm_zx_eq hx2, show (25 / 32 : ℝ) - (2 - x) / 2 = (x - 7 / 16) / 2 by ring]
  have hne : x - 7 / 16 ≠ 0 := by intro h; linarith
  unfold bcw
  field_simp

/-- **The pointwise lower bound on the segment.** -/
theorem log_zeta_ge {t : ℝ} (ht : 2 ≤ t) {x : ℝ} (hx1 : 1 / 2 ≤ x) (hx2 : x ≤ 2)
    (hxE : x ∉ (zeroSet ht).image TuringLW.beta) :
    gLow ht x ≤ Real.log ‖riemannZeta ((x : ℂ) + (t : ℂ) * Complex.I)‖ := by
  have hz := TuringLW.norm_zx hx1 hx2
  have hfz : jensenF t (TuringLW.zx x) ≠ 0 := by
    intro h0
    apply hxE
    rw [Finset.mem_image]
    refine ⟨TuringLW.zx x, ?_, ?_⟩
    · rw [zeroSet, Set.Finite.mem_toFinset]
      exact ⟨by linarith, h0⟩
    · unfold TuringLW.beta TuringLW.zx; simp only [Complex.ofReal_re]; ring
  have hpt := log_jensenF_ge ht hz hfz
  rw [bc_eq hx1 hx2] at hpt
  have hsum : ∑ ρ ∈ zeroSet ht, (analyticOrderNatAt (jensenF t) ρ : ℝ) *
        (Real.log (x - TuringLW.beta ρ) - Real.log 2) ≤
      ∑ ρ ∈ zeroSet ht, (analyticOrderNatAt (jensenF t) ρ : ℝ) *
        Real.log ‖TuringLW.zx x - ρ‖ := by
    refine Finset.sum_le_sum (fun ρ hρ => mul_le_mul_of_nonneg_left
      (TuringLW.log_sub_le ?_) (Nat.cast_nonneg _))
    intro h
    exact hxE (Finset.mem_image.mpr ⟨ρ, hρ, h.symm⟩)
  have hc := zeta_centre_ne_zero t
  have hζ : riemannZeta ((x : ℂ) + (t : ℂ) * Complex.I) ≠ 0 := by
    intro h0
    apply hfz
    unfold jensenF
    rw [TuringLW.zx_arg, h0, zero_div]
  have hf : Real.log ‖jensenF t (TuringLW.zx x)‖ =
      Real.log ‖riemannZeta ((x : ℂ) + (t : ℂ) * Complex.I)‖ -
        Real.log ‖riemannZeta (2 + Complex.I * (t : ℂ))‖ := by
    unfold jensenF
    rw [TuringLW.zx_arg, norm_div,
      Real.log_div (norm_ne_zero_iff.mpr hζ) (norm_ne_zero_iff.mpr hc)]
  have hcl : -Real.log 3 ≤ Real.log ‖riemannZeta (2 + Complex.I * (t : ℂ))‖ := by
    have h3 := zeta_centre_lower t
    have := Real.log_le_log (by norm_num) h3
    rw [one_div, Real.log_inv] at this
    exact this
  unfold gLow
  linarith

/-- The per-zero terms are integrable. -/
theorem intervalIntegrable_term (t : ℝ) (ρ : ℂ) :
    IntervalIntegrable (fun x => (analyticOrderNatAt (jensenF t) ρ : ℝ) *
      (Real.log (x - TuringLW.beta ρ) - Real.log 2)) volume (1 / 2) 2 :=
  ((intervalIntegrable_log_sub (TuringLW.beta ρ)).sub intervalIntegrable_const).const_mul _

theorem intervalIntegrable_sumTerm {t : ℝ} (ht : 2 ≤ t) :
    IntervalIntegrable (fun x => ∑ ρ ∈ zeroSet ht, (analyticOrderNatAt (jensenF t) ρ : ℝ) *
      (Real.log (x - TuringLW.beta ρ) - Real.log 2)) volume (1 / 2) 2 :=
  TuringLW.intervalIntegrable_sum' (zeroSet ht) _ (fun ρ _ => intervalIntegrable_term t ρ)

/-- The lower function is integrable on the segment. -/
theorem intervalIntegrable_gLow {t : ℝ} (ht : 2 ≤ t) :
    IntervalIntegrable (gLow ht) volume (1 / 2) 2 :=
  (intervalIntegrable_const.add (intervalIntegrable_bcw.const_mul _)).add
    (intervalIntegrable_sumTerm ht)

/-- **The integral of the lower function.** -/
theorem integral_g_ge {t : ℝ} (ht : 2 ≤ t) :
    -(113 / 4 * Real.log t + 128) ≤ ∫ x in (1 / 2 : ℝ)..2, gLow ht x := by
  set N := zeroMass ht with hNdef
  set M := Real.log (84 * t) with hMdef
  have hI : ∫ x in (1 / 2 : ℝ)..2, gLow ht x =
      (2 - 1 / 2) * (-(N * Real.log (25 / 16)) - Real.log 3) +
        (-(2 * M)) * ((25 / 16) * Real.log 25 - 3 / 2) +
        ∑ ρ ∈ zeroSet ht, (analyticOrderNatAt (jensenF t) ρ : ℝ) *
          ((∫ x in (1 / 2 : ℝ)..2, Real.log (x - TuringLW.beta ρ)) - (2 - 1 / 2) * Real.log 2) := by
    unfold gLow
    rw [intervalIntegral.integral_add (intervalIntegrable_const.add
        (intervalIntegrable_bcw.const_mul _)) (intervalIntegrable_sumTerm ht),
      intervalIntegral.integral_add intervalIntegrable_const (intervalIntegrable_bcw.const_mul _),
      intervalIntegral.integral_const, smul_eq_mul, intervalIntegral.integral_const_mul,
      integral_bcw, intervalIntegral.integral_finsetSum (fun ρ _ => intervalIntegrable_term t ρ)]
    congr 1
    refine Finset.sum_congr rfl (fun ρ _ => ?_)
    rw [intervalIntegral.integral_const_mul, intervalIntegral.integral_sub
      (intervalIntegrable_log_sub (TuringLW.beta ρ)) intervalIntegrable_const,
      intervalIntegral.integral_const, smul_eq_mul]
  have hper : ∑ ρ ∈ zeroSet ht, (analyticOrderNatAt (jensenF t) ρ : ℝ) *
        (-2 - (2 - 1 / 2) * Real.log 2) ≤
      ∑ ρ ∈ zeroSet ht, (analyticOrderNatAt (jensenF t) ρ : ℝ) *
        ((∫ x in (1 / 2 : ℝ)..2, Real.log (x - TuringLW.beta ρ)) - (2 - 1 / 2) * Real.log 2) :=
    Finset.sum_le_sum (fun ρ _ => mul_le_mul_of_nonneg_left
      (by linarith [integral_log_sub_ge_two (TuringLW.beta ρ)]) (Nat.cast_nonneg _))
  have hper' : ∑ ρ ∈ zeroSet ht, (analyticOrderNatAt (jensenF t) ρ : ℝ) *
        (-2 - (2 - 1 / 2) * Real.log 2) = N * (-2 - (2 - 1 / 2) * Real.log 2) := by
    rw [hNdef]; unfold zeroMass; rw [Finset.sum_mul]
  rw [hper'] at hper
  have hN : N ≤ 50 / 9 * M := zeroMass_le ht
  have hN0 : 0 ≤ N := Finset.sum_nonneg (fun ρ _ => Nat.cast_nonneg _)
  have hM0 : 0 < M := log84T_pos ht
  have hl2 := Real.log_two_lt_d9
  have h25 := log25_le
  have h2516 := log2516_le
  have h3 := log3_le'
  have h84 := log84_le'
  have hMeq : M = Real.log 84 + Real.log t := Real.log_mul (by norm_num) (by linarith)
  have hlt : 0 ≤ Real.log t := Real.log_nonneg (by linarith)
  have hbc : (-(2 * M)) * ((25 / 16) * Real.log 25 - 3 / 2) ≥ -(229 / 32) * M := by
    nlinarith
  have h16 : N * Real.log (25 / 16) ≤ N * (1 / 2) := mul_le_mul_of_nonneg_left h2516 hN0
  have hK : 11 / 4 + 3 / 2 * Real.log 2 ≤ 3790 / 1000 := by linarith
  have hNK : N * (11 / 4 + 3 / 2 * Real.log 2) ≤ 50 / 9 * M * (3790 / 1000) :=
    mul_le_mul hN hK (by linarith [Real.log_pos (by norm_num : (1 : ℝ) < 2)]) (by positivity)
  rw [hI]
  have e : (2 - 1 / 2) * (-(N * (1 / 2))) + N * (-2 - (2 - 1 / 2) * Real.log 2) =
      -(N * (11 / 4 + 3 / 2 * Real.log 2)) := by ring
  nlinarith

/-- **The lower side, sharper.** `StmtHorizLower (113/4) 128`. -/
theorem horizLower_sharp : Turing.StmtHorizLower (113 / 4) 128 := by
  intro t ht
  have hlt : 0 ≤ Real.log t := Real.log_nonneg (by linarith)
  by_cases hi : IntervalIntegrable
      (fun x : ℝ => Real.log ‖riemannZeta ((x : ℂ) + (t : ℂ) * Complex.I)‖) volume (1 / 2) 2
  · have hE : ∀ᵐ x ∂volume, x ∉ (((zeroSet ht).image TuringLW.beta : Finset ℝ) : Set ℝ) :=
      measure_eq_zero_iff_ae_notMem.mp ((Finset.finite_toSet _).measure_zero volume)
    have hae : gLow ht ≤ᵐ[volume.restrict (Set.Icc (1 / 2) 2)]
        (fun x : ℝ => Real.log ‖riemannZeta ((x : ℂ) + (t : ℂ) * Complex.I)‖) := by
      rw [Filter.EventuallyLE, ae_restrict_iff' measurableSet_Icc]
      filter_upwards [hE] with x hx hxI
      exact log_zeta_ge ht hxI.1 hxI.2 (by simpa using hx)
    have hm := intervalIntegral.integral_mono_ae_restrict (by norm_num : (1 / 2 : ℝ) ≤ 2)
      (intervalIntegrable_gLow ht) hi hae
    linarith [integral_g_ge ht]
  · rw [intervalIntegral.integral_undef hi]
    linarith

end

/-- info: 'LittlewoodSharp.log_zeta_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_zeta_ge

/-- info: 'LittlewoodSharp.integral_g_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms integral_g_ge

/-- info: 'LittlewoodSharp.horizLower_sharp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms horizLower_sharp

end LittlewoodSharp
