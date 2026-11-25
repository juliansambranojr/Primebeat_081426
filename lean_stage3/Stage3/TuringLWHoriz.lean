/-
TuringLWHoriz — block S14 of `lean_stage3/design/stencil.md`, Turing's method, Littlewood's
three pieces: the lower side `Turing.StmtHorizLower a₂ b₂`, proved with `a₂ = 102`,
`b₂ = 500`. 2026-11-25.

Goal (`Stage3/TuringS.lean`): for `t ≥ 2`,

  `∫_{1/2}^{2} log‖ζ(x + it)‖ dx ≥ −(a₂ log t + b₂)`.

**The route.** Write `M = log(84 t)` and `z(x) = (x − 2)/2`, so that
`Stage3.jensenF t (z(x)) = ζ(x + it)/ζ(2 + it)` and `‖z(x)‖ ≤ 3/4` on the segment.
`TuringLWHorizPoint.log_jensenF_ge` (Borel–Carathéodory on the Blaschke quotient) gives, off
the zeros,

  `log‖f z‖ ≥ −12 M − N log 2 + Σ_ρ m_ρ log‖z − ρ‖`,  `N = Σ m_ρ ≤ 15 M`.

With `‖z(x) − ρ‖ ≥ |Re(z(x) − ρ)| = |x − β_ρ|/2`, `β_ρ = 2 + 2 Re ρ`, and
`‖ζ(2 + it)‖ ≥ 1/3` (`Stage3.zeta_centre_lower`), the integrand is at least

  `g(x) = −12 M − N log 2 − log 3 + Σ_ρ m_ρ (log(x − β_ρ) − log 2)`

for every `x ∈ [1/2, 2]` outside the finite set `{β_ρ}` (`log_zeta_ge`). `g` is integrable and,
by `TuringLWHorizLog.integral_log_sub_ge` (`∫ log(x − β) ≥ −7/2`),

  `∫ g ≥ −18 M − (3/2) log 3 − N (7/2 + 3 log 2) ≥ −102 M − 3`   (`integral_g_ge`).

`M ≤ log t + 4.86` closes it: `−102 log t − 500`. If the integrand is not integrable the
integral is `0` and the bound holds trivially.

**Sizes and the lost-factor check.** Every term is a multiple of `M = log t + O(1)`: the
Borel–Carathéodory factor `2r/(R − r) = 12` (radii `3/4 < 7/8`), the zero count `15 M`
(`ZerosBound`, radii `7/8 < 15/16`), and per zero the constant `7/2 + 3 log 2 < 5.6`. No factor
grows faster than `log t`; none was lost. The constant `102` exceeds the earlier guess `30`: the
per-zero constant `7/2` is crude (sharp `≈ 1.93`), and the two `log 2`s and the count `15 M`
are the tree's existing crude radii. All of it is `O(log t)`.

| name | content | status |
|---|---|---|
| `zx x` | `((x − 2)/2 : ℂ)` | def |
| `beta ρ` | `2 + 2 Re ρ` | def |
| `gLow ht x` | `g(x)` above | def |
| `log_zeta_ge` | `x ∈ [1/2, 2]`, `x ∉ {β_ρ}` ⊢ `g(x) ≤ log‖ζ(x + it)‖` | proved |
| `intervalIntegrable_gLow` | `g` integrable on `[1/2, 2]` | proved |
| `integral_g_ge` | `−(102 log t + 500) ≤ ∫_{1/2}^{2} g` | proved |
| `horizLower_holds` | `Turing.StmtHorizLower 102 500` | **proved** |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Mathlib
import Stage3.TuringS
import Stage3.TuringLWHorizLog
import Stage3.TuringLWHorizPoint

namespace TuringLW

open Complex Stage3 MeasureTheory

noncomputable section

/-- The point of the model's disc over `x + it`. -/
def zx (x : ℝ) : ℂ := (((x - 2) / 2 : ℝ) : ℂ)

/-- The real abscissa of a model zero, pulled back to `s`. -/
def beta (ρ : ℂ) : ℝ := 2 + 2 * ρ.re

/-- The lower function. -/
def gLow {t : ℝ} (ht : 2 ≤ t) (x : ℝ) : ℝ :=
  -12 * Real.log (84 * t) - zeroMass ht * Real.log 2 - Real.log 3 +
    ∑ ρ ∈ zeroSet ht, (analyticOrderNatAt (jensenF t) ρ : ℝ) *
      (Real.log (x - beta ρ) - Real.log 2)

theorem zx_arg (x t : ℝ) :
    2 * zx x + (2 + Complex.I * (t : ℂ)) = (x : ℂ) + (t : ℂ) * Complex.I := by
  unfold zx; push_cast; ring

theorem norm_zx {x : ℝ} (hx1 : 1 / 2 ≤ x) (hx2 : x ≤ 2) : ‖zx x‖ ≤ 3 / 4 := by
  unfold zx
  rw [Complex.norm_real, Real.norm_eq_abs, abs_le]
  constructor <;> linarith

/-- `log(x − β_ρ) − log 2 ≤ log‖z(x) − ρ‖` for `x ≠ β_ρ`. -/
theorem log_sub_le {x : ℝ} {ρ : ℂ} (hx : x ≠ beta ρ) :
    Real.log (x - beta ρ) - Real.log 2 ≤ Real.log ‖zx x - ρ‖ := by
  have hre : (zx x - ρ).re = (x - beta ρ) / 2 := by
    unfold zx beta; simp only [Complex.sub_re, Complex.ofReal_re]; ring
  have hne : x - beta ρ ≠ 0 := sub_ne_zero.mpr hx
  have hpos : 0 < |x - beta ρ| / 2 := by positivity
  have hle : |x - beta ρ| / 2 ≤ ‖zx x - ρ‖ := by
    have := Complex.abs_re_le_norm (zx x - ρ)
    rw [hre, abs_div, abs_of_pos (by norm_num : (0 : ℝ) < 2)] at this
    exact this
  have h1 := Real.log_le_log hpos hle
  rw [Real.log_div (abs_ne_zero.mpr hne) (by norm_num), Real.log_abs] at h1
  exact h1

/-- **The pointwise lower bound on the segment.** -/
theorem log_zeta_ge {t : ℝ} (ht : 2 ≤ t) {x : ℝ} (hx1 : 1 / 2 ≤ x) (hx2 : x ≤ 2)
    (hxE : x ∉ (zeroSet ht).image beta) :
    gLow ht x ≤ Real.log ‖riemannZeta ((x : ℂ) + (t : ℂ) * Complex.I)‖ := by
  have hz := norm_zx hx1 hx2
  have hfz : jensenF t (zx x) ≠ 0 := by
    intro h0
    apply hxE
    rw [Finset.mem_image]
    refine ⟨zx x, ?_, ?_⟩
    · rw [zeroSet, Set.Finite.mem_toFinset]
      exact ⟨by linarith, h0⟩
    · unfold beta zx; simp only [Complex.ofReal_re]; ring
  have hpt := log_jensenF_ge ht hz hfz
  have hsum : ∑ ρ ∈ zeroSet ht, (analyticOrderNatAt (jensenF t) ρ : ℝ) *
        (Real.log (x - beta ρ) - Real.log 2) ≤
      ∑ ρ ∈ zeroSet ht, (analyticOrderNatAt (jensenF t) ρ : ℝ) * Real.log ‖zx x - ρ‖ := by
    refine Finset.sum_le_sum (fun ρ hρ => mul_le_mul_of_nonneg_left (log_sub_le ?_)
      (Nat.cast_nonneg _))
    intro h
    exact hxE (Finset.mem_image.mpr ⟨ρ, hρ, h.symm⟩)
  have hc := zeta_centre_ne_zero t
  have hζ : riemannZeta ((x : ℂ) + (t : ℂ) * Complex.I) ≠ 0 := by
    intro h0
    apply hfz
    unfold jensenF
    rw [zx_arg, h0, zero_div]
  have hf : Real.log ‖jensenF t (zx x)‖ =
      Real.log ‖riemannZeta ((x : ℂ) + (t : ℂ) * Complex.I)‖ -
        Real.log ‖riemannZeta (2 + Complex.I * (t : ℂ))‖ := by
    unfold jensenF
    rw [zx_arg, norm_div, Real.log_div (norm_ne_zero_iff.mpr hζ) (norm_ne_zero_iff.mpr hc)]
  have hcl : -Real.log 3 ≤ Real.log ‖riemannZeta (2 + Complex.I * (t : ℂ))‖ := by
    have h3 := zeta_centre_lower t
    have := Real.log_le_log (by norm_num) h3
    rw [one_div, Real.log_inv] at this
    exact this
  unfold gLow
  linarith

/-- A finite sum of interval-integrable real functions, in lambda form. -/
theorem intervalIntegrable_sum' {ι : Type*} (s : Finset ι) (f : ι → ℝ → ℝ) {a b : ℝ}
    (h : ∀ i ∈ s, IntervalIntegrable (f i) volume a b) :
    IntervalIntegrable (fun x => ∑ i ∈ s, f i x) volume a b := by
  classical
  induction s using Finset.induction_on with
  | empty => simp
  | insert i s hi ih =>
    simp only [Finset.sum_insert hi]
    exact (h i (Finset.mem_insert_self i s)).add
      (ih fun j hj => h j (Finset.mem_insert_of_mem hj))

/-- The lower function is integrable on the segment. -/
theorem intervalIntegrable_gLow {t : ℝ} (ht : 2 ≤ t) :
    IntervalIntegrable (gLow ht) volume (1 / 2) 2 := by
  have hs : IntervalIntegrable (fun x => ∑ ρ ∈ zeroSet ht,
      (analyticOrderNatAt (jensenF t) ρ : ℝ) * (Real.log (x - beta ρ) - Real.log 2))
      volume (1 / 2) 2 := by
    exact intervalIntegrable_sum' (zeroSet ht) _ (fun ρ _ =>
      ((intervalIntegrable_log_sub (beta ρ)).sub intervalIntegrable_const).const_mul _)
  exact intervalIntegrable_const.add hs

/-- `log 3 ≤ 2`. -/
theorem log3_le : Real.log 3 ≤ 2 := by
  have := Real.log_le_sub_one_of_pos (by norm_num : (0 : ℝ) < 3)
  linarith

/-- **The integral of the lower function.** -/
theorem integral_g_ge {t : ℝ} (ht : 2 ≤ t) :
    -(102 * Real.log t + 500) ≤ ∫ x in (1 / 2 : ℝ)..2, gLow ht x := by
  have hterm : ∀ ρ ∈ zeroSet ht, IntervalIntegrable (fun x =>
      (analyticOrderNatAt (jensenF t) ρ : ℝ) * (Real.log (x - beta ρ) - Real.log 2))
      volume (1 / 2) 2 := fun ρ _ =>
    ((intervalIntegrable_log_sub (beta ρ)).sub intervalIntegrable_const).const_mul _
  have hs : IntervalIntegrable (fun x => ∑ ρ ∈ zeroSet ht,
      (analyticOrderNatAt (jensenF t) ρ : ℝ) * (Real.log (x - beta ρ) - Real.log 2))
      volume (1 / 2) 2 := by
    exact intervalIntegrable_sum' (zeroSet ht) _ hterm
  have hI : ∫ x in (1 / 2 : ℝ)..2, gLow ht x =
      (2 - 1 / 2) * (-12 * Real.log (84 * t) - zeroMass ht * Real.log 2 - Real.log 3) +
        ∑ ρ ∈ zeroSet ht, (analyticOrderNatAt (jensenF t) ρ : ℝ) *
          ((∫ x in (1 / 2 : ℝ)..2, Real.log (x - beta ρ)) - (2 - 1 / 2) * Real.log 2) := by
    unfold gLow
    rw [intervalIntegral.integral_add intervalIntegrable_const hs,
      intervalIntegral.integral_const, smul_eq_mul, intervalIntegral.integral_finsetSum hterm]
    congr 1
    refine Finset.sum_congr rfl (fun ρ _ => ?_)
    rw [intervalIntegral.integral_const_mul, intervalIntegral.integral_sub
      (intervalIntegrable_log_sub (beta ρ)) intervalIntegrable_const,
      intervalIntegral.integral_const, smul_eq_mul]
  have hper : ∑ ρ ∈ zeroSet ht, (analyticOrderNatAt (jensenF t) ρ : ℝ) *
        (-(7 / 2) - (2 - 1 / 2) * Real.log 2) ≤
      ∑ ρ ∈ zeroSet ht, (analyticOrderNatAt (jensenF t) ρ : ℝ) *
        ((∫ x in (1 / 2 : ℝ)..2, Real.log (x - beta ρ)) - (2 - 1 / 2) * Real.log 2) :=
    Finset.sum_le_sum (fun ρ _ => mul_le_mul_of_nonneg_left
      (by linarith [integral_log_sub_ge (beta ρ)]) (Nat.cast_nonneg _))
  have hper' : ∑ ρ ∈ zeroSet ht, (analyticOrderNatAt (jensenF t) ρ : ℝ) *
        (-(7 / 2) - (2 - 1 / 2) * Real.log 2) =
      zeroMass ht * (-(7 / 2) - (2 - 1 / 2) * Real.log 2) := by
    unfold zeroMass; rw [Finset.sum_mul]
  have hN := zeroMass_le ht
  have hN0 : 0 ≤ zeroMass ht := Finset.sum_nonneg (fun ρ _ => Nat.cast_nonneg _)
  have hl2 := Real.log_two_lt_d9
  have hl2' : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hK : 7 / 2 + 3 * Real.log 2 ≤ 28 / 5 := by linarith
  have hNK : zeroMass ht * (7 / 2 + 3 * Real.log 2) ≤ 15 * Real.log (84 * t) * (28 / 5) :=
    mul_le_mul hN hK (by linarith) (by linarith [log84T_pos ht])
  have hM := log84T_eq ht
  have h84 := log84_le
  have h3 := log3_le
  rw [hI]
  rw [hper'] at hper
  have e : zeroMass ht * (-(7 / 2) - (2 - 1 / 2) * Real.log 2) - (2 - 1 / 2) *
      (zeroMass ht * Real.log 2) = -(zeroMass ht * (7 / 2 + 3 * Real.log 2)) := by ring
  nlinarith

/-- **The lower side, proved.** `StmtHorizLower 102 500`. -/
theorem horizLower_holds : Turing.StmtHorizLower 102 500 := by
  intro t ht
  have hlt : 0 ≤ Real.log t := Real.log_nonneg (by linarith)
  by_cases hi : IntervalIntegrable
      (fun x : ℝ => Real.log ‖riemannZeta ((x : ℂ) + (t : ℂ) * Complex.I)‖) volume (1 / 2) 2
  · have hE : ∀ᵐ x ∂volume, x ∉ (((zeroSet ht).image beta : Finset ℝ) : Set ℝ) :=
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

/-- info: 'TuringLW.log_zeta_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_zeta_ge

/-- info: 'TuringLW.integral_g_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms integral_g_ge

/-- info: 'TuringLW.horizLower_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms horizLower_holds

end TuringLW
