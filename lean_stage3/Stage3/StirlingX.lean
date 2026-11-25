/-
# StirlingX — block S12 of `lean_stage3/design/stencil.md`, Stirling with the phase for `X_{α,β,t}`. 2026-11-25.

Target: `SwapX.StmtXStirling`, `‖X_{α,β,t} − (t/2π)^(−α−β)‖ ≤ C/t`. **That statement is false**
(see below). What is proved is the relative form `StmtXStirlingRel`:
`‖X − (t/2π)^(−α−β)‖ ≤ C ‖(t/2π)^(−α−β)‖/t`, `‖α‖, ‖β‖ ≤ 1/10`, `t ≥ 1`, `C = 17 e^17`, and from
it the corollary `lemma3_resO_of_mainO'` (`StmtDiagMainO → StmtLemma3resO`, `θ < 1/2`, `κ > 0`).

The route. `XY_eq_young` with `w± = 1/4 ± it/2` writes
`X = π^(α+β) Γ(w₋−α/2) Γ(w₊−β/2) / (Γ(w₊+α/2) Γ(w₋+β/2))`; with `Γ = exp ∘ logG`
(`StirlingLog.exp_logG`) this is one exponential (`XY_eq_exp`). `logG_shift` gives each
`logG(w+a) − logG w = a log w + O(1/|Im w|)`, so the exponent is
`(α+β) log π − ((α+β)/2)(log w₋ + log w₊) + O(16/t)`, and `log w₋ + log w₊ = 2 log‖w₊‖`
(`log_conj`), `log‖w₊‖ = log(t/2) + O(1/t)`: the exponent of `X` minus that of `(t/2π)^(−α−β)`
is `≤ 17/t` (`exponent_le`), and `‖e^E − 1‖ ≤ ‖E‖ e^‖E‖` closes it.

Why the absolute form is false. The next Stirling term is `X = (t/2π)^(−α−β)(1 + i(α²−β²)/(2t)
+ O(t^(−2)))`, so `‖X − (t/2π)^(−α−β)‖ ≍ |α²−β²| t^(−Re(α+β)−1)/2`, which is not `O(1/t)` when
`Re(α+β) < 0` and `α² ≠ β²`. Numerically (mpmath, `α = −1/10`, `β = −i/10`): `t·‖X − (t/2π)^(−α−β)‖
= 0.0100, 0.0131, 0.0166, 0.0209, 0.0263` at `t = 10, 10², 10³, 10⁴, 10⁵`, growing like
`t^(1/10)`, while `t·‖X − ·‖/‖(t/2π)^(−α−β)‖ → 0.0100 = |α²−β²|/2`. The non-negation is not
proved here. `SwapX.E_bound` takes the absolute bound for every `t ≥ 1` at the `Regime` pair, which
fails in the same way, so `E_bound'` takes it on the support `[T/4, 2T]` only, and there
`‖(t/2π)^(−α−β)‖ ≤ e^(10κ)` (`norm_main_le`) turns the relative bound into `C e^(10κ)/t`.
`stmtXAll_of'` is `SwapX.stmtXAll_of` with that one step changed, copied otherwise.

The size check. The remainder is exactly `O(1/t)` relative; no logarithm is lost (the sums in
`logG_shift` are `≍ 1/|Im w|`). The factor `‖(t/2π)^(−α−β)‖ ≤ t^(1/5)` that the absolute form
would need is bounded by `e^(10κ)` on the regime `‖α‖, ‖β‖ ≤ κ/L`, so nothing grows with `T`.

| name | content | status |
|---|---|---|
| `wp`, `wm` | `w± = 1/4 ± it/2` | def |
| `XY_eq_exp` | `X` as one exponential of `logG`'s | proved |
| `log_wm_add_log_wp`, `log_wp_sub` | `log w₋ + log w₊ = 2 log‖w₊‖`; `|log(t/2) − log‖w₊‖| ≤ 1/t` | proved |
| `norm_exp_sub_one_le'` | `‖e^x − 1‖ ≤ ‖x‖ e^‖x‖` | proved |
| `StmtXStirlingRel` | `‖X − (t/2π)^(−α−β)‖ ≤ C ‖(t/2π)^(−α−β)‖/t` | defined |
| `exponent_le`, `stmtXStirlingRel_holds` | the exponent difference `≤ 17/t`; `StmtXStirlingRel`, `C = 17e^17` | proved |
| `SwapX.StmtXStirling` | the absolute form | false (numerics above), the negation not proved |
| `norm_main_le` | `‖(t/2π)^z‖ ≤ e^(10κ)` on `[T/4, 2T]`, `‖z‖ ≤ 2κ/L` | proved |
| `E_bound'`, `stmtXAll_of'` | `SwapX.E_bound`, `SwapX.stmtXAll_of` from the relative form | proved |
| `lemma3_resO_of_mainO'` | `StmtDiagMainO → StmtLemma3resO`, `θ < 1/2`, `κ > 0` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below on each main theorem.
-/
import Stage3.SwapX
import Stage3.StirlingLog

namespace Stirling

open Complex MeasureTheory Filter Topology ApproxFE ApproxBounds TwistedMoment OffDiagClose
  Diagonal DiagMainStmt DiagonalO SwapX
open scoped ContDiff

noncomputable section

/-! ## Part 1: `X_{α,β,t}` as one exponential -/

/-- `w₊ = 1/4 + it/2`. -/
def wp (t : ℝ) : ℂ := 1 / 4 + (t : ℂ) / 2 * I

/-- `w₋ = 1/4 − it/2`. -/
def wm (t : ℝ) : ℂ := 1 / 4 - (t : ℂ) / 2 * I

theorem wp_re (t : ℝ) : (wp t).re = 1 / 4 := by simp [wp]
theorem wp_im (t : ℝ) : (wp t).im = t / 2 := by simp [wp]
theorem wm_re (t : ℝ) : (wm t).re = 1 / 4 := by simp [wm]
theorem wm_im (t : ℝ) : (wm t).im = -(t / 2) := by simp [wm]

theorem re_shift_pos {w a : ℂ} (hw : w.re = 1 / 4) (ha : ‖a‖ ≤ 1 / 10) : 0 < (w + a / 2).re := by
  have h := (abs_le.mp (Complex.abs_re_le_norm a)).1
  rw [add_re, hw, div_ofNat_re]
  linarith

theorem re_shift_pos' {w a : ℂ} (hw : w.re = 1 / 4) (ha : ‖a‖ ≤ 1 / 10) :
    0 < (w + -a / 2).re := by
  have h := re_shift_pos hw (a := -a) (by rwa [norm_neg])
  simpa [neg_div] using h

/-- `X = exp(log π·(α+β) + logG(w₋−α/2) + logG(w₊−β/2) − logG(w₊+α/2) − logG(w₋+β/2))`. -/
theorem XY_eq_exp {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (t : ℝ) :
    XY α β t = cexp (log (Real.pi : ℂ) * (α + β) +
      ((logG (wm t + -α / 2) + logG (wp t + -β / 2)) -
        (logG (wp t + α / 2) + logG (wm t + β / 2)))) := by
  have hP : (Real.pi : ℂ) ≠ 0 := ofReal_ne_zero.mpr Real.pi_ne_zero
  rw [XY_eq_young, cpow_def_of_ne_zero hP]
  have e1 : (1 / 2 - α - (t : ℂ) * I) / 2 = wm t + -α / 2 := by simp only [wm]; ring
  have e2 : (1 / 2 - β + (t : ℂ) * I) / 2 = wp t + -β / 2 := by simp only [wp]; ring
  have e3 : (1 / 2 + α + (t : ℂ) * I) / 2 = wp t + α / 2 := by simp only [wp]; ring
  have e4 : (1 / 2 + β - (t : ℂ) * I) / 2 = wm t + β / 2 := by simp only [wm]; ring
  rw [e1, e2, e3, e4, ← exp_logG (re_shift_pos' (wm_re t) hα), ← exp_logG (re_shift_pos' (wp_re t) hβ),
    ← exp_logG (re_shift_pos (wp_re t) hα), ← exp_logG (re_shift_pos (wm_re t) hβ),
    Complex.exp_add, Complex.exp_sub, Complex.exp_add, Complex.exp_add]
  ring

/-- `log w₋ + log w₊ = 2 log‖w₊‖`. -/
theorem log_wm_add_log_wp (t : ℝ) : log (wm t) + log (wp t) = ((2 * Real.log ‖wp t‖ : ℝ) : ℂ) := by
  have hslit : wp t ∈ slitPlane := mem_slitPlane_iff.mpr (Or.inl (by rw [wp_re]; norm_num))
  have hc : wm t = (starRingEnd ℂ) (wp t) := by
    unfold wm wp
    simp only [map_add, map_mul, map_div₀, Complex.conj_ofReal, Complex.conj_I, map_one,
      map_ofNat]
    ring
  rw [hc, log_conj _ (slitPlane_arg_ne_pi hslit), add_comm, add_conj, log_re]

/-- `‖exp x − 1‖ ≤ ‖x‖ e^‖x‖`. -/
theorem norm_exp_sub_one_le' (x : ℂ) : ‖cexp x - 1‖ ≤ ‖x‖ * Real.exp ‖x‖ := by
  set f : ℝ → ℂ := fun s => cexp ((s : ℂ) * x) with hf
  have hd : ∀ s ∈ Set.Icc (0 : ℝ) 1, HasDerivAt f (x * cexp ((s : ℂ) * x)) s := by
    intro s _
    have h1 : HasDerivAt (fun s : ℝ => (s : ℂ) * x) x s := by
      simpa using ((hasDerivAt_id s).ofReal_comp).mul_const x
    have h2 := h1.cexp
    refine h2.congr_deriv ?_
    ring
  have hb : ∀ s ∈ Set.Ico (0 : ℝ) 1, ‖x * cexp ((s : ℂ) * x)‖ ≤ ‖x‖ * Real.exp ‖x‖ := by
    intro s hs
    rw [norm_mul, Complex.norm_exp]
    apply mul_le_mul_of_nonneg_left _ (norm_nonneg x)
    apply Real.exp_le_exp.mpr
    rw [re_ofReal_mul]
    have h1 := Complex.re_le_norm x
    have h2 := (abs_le.mp (Complex.abs_re_le_norm x)).1
    nlinarith [hs.1, hs.2, norm_nonneg x]
  have hmv := norm_image_sub_le_of_norm_deriv_le_segment_01' (f := f)
    (fun s hs => (hd s hs).hasDerivWithinAt) hb
  simpa [hf] using hmv

/-- `t/2 ≤ ‖w₊‖ ≤ t/2 + 1/4`. -/
theorem norm_wp_bounds {t : ℝ} (ht : 1 ≤ t) : t / 2 ≤ ‖wp t‖ ∧ ‖wp t‖ ≤ t / 2 + 1 / 4 := by
  constructor
  · have h := Complex.abs_im_le_norm (wp t)
    rw [wp_im, abs_of_pos (by linarith)] at h
    exact h
  · have e : wp t = ((1 / 4 : ℝ) : ℂ) + ((t / 2 : ℝ) : ℂ) * I := by
      unfold wp
      push_cast
      ring
    rw [e]
    refine (norm_add_le _ _).trans ?_
    rw [norm_mul, Complex.norm_I, mul_one, Complex.norm_real, Complex.norm_real, Real.norm_eq_abs,
      Real.norm_eq_abs, abs_of_pos (by norm_num), abs_of_pos (by linarith)]
    linarith

/-- `0 ≤ log‖w₊‖ − log(t/2) ≤ 1/(2t)`. -/
theorem log_wp_sub {t : ℝ} (ht : 1 ≤ t) :
    |Real.log (t / 2) - Real.log ‖wp t‖| ≤ 1 / t := by
  obtain ⟨h1, h2⟩ := norm_wp_bounds ht
  have ht0 : 0 < t / 2 := by linarith
  have hw0 : 0 < ‖wp t‖ := by linarith
  have hle : Real.log (t / 2) ≤ Real.log ‖wp t‖ := Real.log_le_log ht0 h1
  have hup : Real.log ‖wp t‖ - Real.log (t / 2) ≤ 1 / t := by
    rw [← Real.log_div hw0.ne' ht0.ne']
    refine (Real.log_le_sub_one_of_pos (by positivity)).trans ?_
    rw [div_sub_one ht0.ne', div_le_div_iff₀ ht0 (by linarith)]
    nlinarith
  rw [abs_sub_comm, abs_of_nonneg (by linarith)]
  exact hup

/-! ## Part 2: Stirling with the phase, relative form -/

/-- **(4.2) with the phase, relative form.** `X_{α,β,t} = (t/2π)^(−α−β) (1 + O(1/t))`,
uniformly in `‖α‖, ‖β‖ ≤ 1/10`, `t ≥ 1`. -/
def StmtXStirlingRel : Prop :=
  ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
    ‖XY α β t - (((t / (2 * Real.pi) : ℝ)) : ℂ) ^ (-(α + β))‖ ≤
      C * ‖(((t / (2 * Real.pi) : ℝ)) : ℂ) ^ (-(α + β))‖ / t

/-- The exponent of `X` minus the exponent of `(t/2π)^(−α−β)` is `O(1/t)`, constant `17`. -/
theorem exponent_le {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} (ht : 1 ≤ t) :
    ‖(log (Real.pi : ℂ) * (α + β) +
      ((logG (wm t + -α / 2) + logG (wp t + -β / 2)) -
        (logG (wp t + α / 2) + logG (wm t + β / 2)))) -
      log (((t / (2 * Real.pi) : ℝ)) : ℂ) * (-(α + β))‖ ≤ 17 / t := by
  have ht0 : 0 < t := by linarith
  have hY : 1 / 2 ≤ t / 2 := by linarith
  have hYp : |(wp t).im| = t / 2 := by rw [wp_im, abs_of_pos (by linarith)]
  have hYm : |(wm t).im| = t / 2 := by rw [wm_im, abs_neg, abs_of_pos (by linarith)]
  have h8 : ∀ a : ℂ, ‖a‖ ≤ 1 / 10 → ‖a / 2‖ ≤ 1 / 8 := fun a ha => by
    rw [norm_div, Complex.norm_ofNat]; linarith
  have h8' : ∀ a : ℂ, ‖a‖ ≤ 1 / 10 → ‖-a / 2‖ ≤ 1 / 8 := fun a ha => by
    rw [neg_div, norm_neg]; exact h8 a ha
  have hpre : 1 / 4 ≤ (wp t).re := by rw [wp_re]
  have hmre : 1 / 4 ≤ (wm t).re := by rw [wm_re]
  have R1 := logG_shift hmre (h8' α hα) (by rw [hYm]; exact hY)
  have R2 := logG_shift hmre (h8 β hβ) (by rw [hYm]; exact hY)
  have R3 := logG_shift hpre (h8' β hβ) (by rw [hYp]; exact hY)
  have R4 := logG_shift hpre (h8 α hα) (by rw [hYp]; exact hY)
  rw [hYm] at R1 R2
  rw [hYp] at R3 R4
  set δ : ℝ := Real.log (t / 2) - Real.log ‖wp t‖ with hδ
  have hδb := log_wp_sub ht
  have hsum := log_wm_add_log_wp t
  have hpi : log (Real.pi : ℂ) + log (((t / (2 * Real.pi) : ℝ)) : ℂ) = ((Real.log (t / 2) : ℝ) : ℂ) := by
    rw [← ofReal_log Real.pi_pos.le, ← ofReal_log (by positivity), ← ofReal_add,
      ← Real.log_mul Real.pi_ne_zero (by positivity)]
    congr 2
    field_simp
  set r1 := logG (wm t + -α / 2) - logG (wm t) - -α / 2 * log (wm t)
  set r2 := logG (wm t + β / 2) - logG (wm t) - β / 2 * log (wm t)
  set r3 := logG (wp t + -β / 2) - logG (wp t) - -β / 2 * log (wp t)
  set r4 := logG (wp t + α / 2) - logG (wp t) - α / 2 * log (wp t)
  have key : (log (Real.pi : ℂ) * (α + β) +
      ((logG (wm t + -α / 2) + logG (wp t + -β / 2)) -
        (logG (wp t + α / 2) + logG (wm t + β / 2)))) -
      log (((t / (2 * Real.pi) : ℝ)) : ℂ) * (-(α + β)) =
      r1 - r2 + r3 - r4 + (α + β) * (δ : ℂ) := by
    rw [hδ]
    push_cast
    push_cast at hsum hpi
    linear_combination (α + β) * hpi - (α + β) / 2 * hsum
  rw [key]
  have hab : ‖(α + β) * (δ : ℂ)‖ ≤ 1 / t := by
    rw [norm_mul, Complex.norm_real, Real.norm_eq_abs]
    have : ‖α + β‖ ≤ 1 / 5 := (norm_add_le _ _).trans (by linarith)
    have h0 : 0 ≤ 1 / t := by positivity
    nlinarith [norm_nonneg (α + β), abs_nonneg δ]
  have e2 : 2 / (t / 2) = 4 / t := by field_simp; ring
  rw [e2] at R1 R2 R3 R4
  have n1 := norm_add_le (r1 - r2 + r3 - r4) ((α + β) * (δ : ℂ))
  have n2 := norm_sub_le (r1 - r2 + r3) r4
  have n3 := norm_add_le (r1 - r2) r3
  have n4 := norm_sub_le r1 r2
  have e3 : 4 / t + 4 / t + 4 / t + 4 / t + 1 / t = 17 / t := by ring
  linarith

/-- **Stirling with the phase**: `StmtXStirlingRel` holds, constant `17 e^17`. -/
theorem stmtXStirlingRel_holds : StmtXStirlingRel := by
  refine ⟨17 * Real.exp 17, by positivity, fun α β hα hβ t ht => ?_⟩
  have ht0 : 0 < t := by linarith
  have h2 : (0 : ℝ) < t / (2 * Real.pi) := by positivity
  have hne : (((t / (2 * Real.pi) : ℝ)) : ℂ) ≠ 0 := ofReal_ne_zero.mpr h2.ne'
  set m := (((t / (2 * Real.pi) : ℝ)) : ℂ) ^ (-(α + β)) with hm
  set E := (log (Real.pi : ℂ) * (α + β) +
      ((logG (wm t + -α / 2) + logG (wp t + -β / 2)) -
        (logG (wp t + α / 2) + logG (wm t + β / 2)))) -
      log (((t / (2 * Real.pi) : ℝ)) : ℂ) * (-(α + β)) with hE
  have hX : XY α β t - m = m * (cexp E - 1) := by
    rw [XY_eq_exp hα hβ, hm, cpow_def_of_ne_zero hne, mul_sub, mul_one, ← Complex.exp_add, hE]
    ring_nf
  have hEb := exponent_le hα hβ ht
  rw [← hE] at hEb
  rw [hX, norm_mul]
  have h17 : 17 / t ≤ 17 := by rw [div_le_iff₀ ht0]; linarith
  have hexp := norm_exp_sub_one_le' E
  have hb : ‖cexp E - 1‖ ≤ 17 * Real.exp 17 / t := by
    refine hexp.trans ?_
    calc ‖E‖ * Real.exp ‖E‖ ≤ 17 / t * Real.exp 17 :=
          mul_le_mul hEb (Real.exp_le_exp.mpr (hEb.trans h17)) (Real.exp_pos _).le (by positivity)
      _ = 17 * Real.exp 17 / t := by ring
  calc ‖m‖ * ‖cexp E - 1‖ ≤ ‖m‖ * (17 * Real.exp 17 / t) :=
        mul_le_mul_of_nonneg_left hb (norm_nonneg _)
    _ = 17 * Real.exp 17 * ‖m‖ / t := by ring

/-! ## Part 3: the X-term and Lemma 3 from the relative form -/

/-- `‖(t/2π)^z‖ ≤ e^(10κ)` for `t ∈ [T/4, 2T]`, `‖z‖ ≤ 2κ/L`, `T ≥ 8`, `L ≥ 1`. -/
theorem norm_main_le {κ T t : ℝ} {z : ℂ} (hκ : 0 < κ) (hT8 : 8 ≤ T) (hL1 : 1 ≤ Real.log T)
    (hz : ‖z‖ ≤ 2 * κ / Real.log T) (ht : t ∈ Set.Icc (T / 4) (2 * T)) :
    ‖(((t / (2 * Real.pi) : ℝ)) : ℂ) ^ z‖ ≤ Real.exp (10 * κ) := by
  have ht0 : 0 < t := by linarith [ht.1]
  have hp0 : 0 < t / (2 * Real.pi) := by positivity
  rw [Complex.norm_cpow_eq_rpow_re_of_pos hp0, Real.rpow_def_of_pos hp0]
  apply Real.exp_le_exp.mpr
  set ℓ := Real.log (t / (2 * Real.pi)) with hℓ
  have hpi3 := Real.pi_gt_three
  have hpi4 := Real.pi_lt_d2
  have hhi : ℓ ≤ Real.log T := by
    apply Real.log_le_log hp0
    rw [div_le_iff₀ (by positivity)]
    nlinarith [ht.2]
  have hlo : -3 ≤ ℓ := by
    have h := Real.one_sub_inv_le_log_of_pos hp0
    have h4 : (t / (2 * Real.pi))⁻¹ ≤ 4 := by
      rw [inv_div, div_le_iff₀ ht0]
      nlinarith [ht.1]
    linarith
  have hL0 : 0 < Real.log T := by linarith
  have habs : |ℓ| ≤ Real.log T + 3 := abs_le.mpr ⟨by linarith, by linarith⟩
  have hre : |z.re| ≤ 2 * κ / Real.log T := (Complex.abs_re_le_norm z).trans hz
  have h1 : ℓ * z.re ≤ (Real.log T + 3) * (2 * κ / Real.log T) := by
    calc ℓ * z.re ≤ |ℓ * z.re| := le_abs_self _
      _ = |ℓ| * |z.re| := abs_mul _ _
      _ ≤ (Real.log T + 3) * (2 * κ / Real.log T) :=
          mul_le_mul habs hre (abs_nonneg _) (by positivity)
  have h2 : (Real.log T + 3) * (2 * κ / Real.log T) = 2 * κ + 6 * κ / Real.log T := by
    field_simp
    try ring
  have h3 : 6 * κ / Real.log T ≤ 6 * κ := div_le_self (by positivity) hL1
  linarith

/-- `SwapX.E_bound` with the Stirling hypothesis on the support `[T/4, 2T]` only. -/
theorem E_bound' {T L : ℝ} (hT8 : 8 ≤ T) (W : Weight T L) (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ)
    {α β : ℂ} {Cst CS N Bm e : ℝ} (hCst : 0 ≤ Cst) (hCS : 0 ≤ CS) (hN : 0 ≤ N) (hBm : 0 ≤ Bm)
    (he : 0 ≤ e)
    (hst : ∀ t ∈ Set.Icc (T / 4) (2 * T), ‖XY α β t - (((t / (2 * Real.pi) : ℝ)) : ℂ) ^ (-(α + β))‖ ≤ Cst / t)
    (hS1 : ∀ t : ℝ, 1 ≤ t → ‖S1 (-β) (-α) 1 t‖ ≤ CS * N * t ^ e)
    (hmsq : ∀ t, msq M a σ₀ t ≤ Bm) :
    ‖∫ t, (W.w t : ℂ) * ((XY α β t - (T : ℂ) ^ (-(α + β)) *
        (cT (-(α + β)) T * Gk (-(α + β)) 0 t)) * S1 (-β) (-α) 1 t) * (msq M a σ₀ t : ℂ)‖ ≤
      8 * Cst * CS * N * (2 * T) ^ e * Bm := by
  have hT0 : 0 < T := by linarith
  set K : ℝ := 4 * Cst / T * (CS * N * (2 * T) ^ e) * Bm with hK
  have hK0 : 0 ≤ K := by positivity
  have hb := norm_integral_le_Icc (a := T / 4) (b := 2 * T) (K := K)
    (f := fun t => (W.w t : ℂ) * ((XY α β t - (T : ℂ) ^ (-(α + β)) *
        (cT (-(α + β)) T * Gk (-(α + β)) 0 t)) * S1 (-β) (-α) 1 t) * (msq M a σ₀ t : ℂ))
    (by linarith) (fun t ht => w_zero_mul W ht _ _) (fun t ht => by
      have ht0 : 0 < t := by linarith [ht.1]
      have ht1 : 1 ≤ t := by linarith [ht.1]
      rw [Tp_g hT0 ht0, norm_mul, norm_mul, norm_mul, Complex.norm_real, Complex.norm_real,
        Real.norm_eq_abs, Real.norm_eq_abs, abs_of_nonneg (msq_nonneg M a σ₀ t)]
      have hw := W.abs_le_one t
      have h1 : Cst / t ≤ 4 * Cst / T := by
        rw [div_le_div_iff₀ ht0 hT0]
        nlinarith [ht.1]
      have h2 : t ^ e ≤ (2 * T) ^ e := Real.rpow_le_rpow ht0.le ht.2 he
      have hX := (hst t ht).trans h1
      have hS := (hS1 t ht1).trans (mul_le_mul_of_nonneg_left h2 (by positivity))
      calc |W.w t| * (‖XY α β t - (((t / (2 * Real.pi) : ℝ)) : ℂ) ^ (-(α + β))‖ *
            ‖S1 (-β) (-α) 1 t‖) * msq M a σ₀ t
          ≤ 1 * ((4 * Cst / T) * (CS * N * (2 * T) ^ e)) * Bm := by
            apply mul_le_mul _ (hmsq t) (msq_nonneg M a σ₀ t) (by positivity)
            exact mul_le_mul hw (mul_le_mul hX hS (norm_nonneg _) (by positivity))
              (by positivity) zero_le_one
        _ = K := by rw [hK]; ring)
  refine hb.trans ?_
  calc K * (2 * T - T / 4) ≤ K * (2 * T) := mul_le_mul_of_nonneg_left (by linarith) hK0
    _ = 8 * Cst * CS * N * (2 * T) ^ e * Bm := by
        rw [hK]
        field_simp
        try ring

/-- `SwapX.stmtXAll_of` from `StmtXStirlingRel`: on `Regime κ T`, `‖(t/2π)^(−α−β)‖ ≤ e^(10κ)` on
the support (`norm_main_le`), so the relative remainder is `≤ C e^(10κ)/t` there. -/
theorem stmtXAll_of' (P : Polynomial ℝ) {θ : ℝ} (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ} (hκ : 0 < κ)
    (hS : StmtXStirlingRel) (hmain : StmtDiagMainO P θ R κ) : StmtXAll P θ R κ := by
  intro Cs
  set Cs' : ℕ → ℝ := twC (fun i => max (Cs i) 0) with hCs'
  have hCm0 : ∀ i, 0 ≤ max (Cs i) 0 := fun i => le_max_right _ _
  obtain ⟨Co, To, hCo0, ho⟩ := stmtOffDiag_holds P hθ R hκ Cs'
  obtain ⟨Cd, Td, hCd0, hd⟩ := diag_young P hθ R hκ
  obtain ⟨Tm, hm⟩ := hmain 1 one_pos
  obtain ⟨Cc, Tc, hCc0, hc⟩ := c1Y_bound P hθ hκ
  obtain ⟨Cr, hCr0, hrel⟩ := hS
  obtain ⟨Cst, hCst⟩ : ∃ c : ℝ, c = Cr * Real.exp (10 * κ) := ⟨_, rfl⟩
  have hCst0 : 0 ≤ Cst := by rw [hCst]; positivity
  have hη := etaX_pos hθ
  have hη16 := etaX_le (θ := θ)
  obtain ⟨CS, hCS0, hS1⟩ := S1_sharp hη (by linarith)
  obtain ⟨B, hB0, hB⟩ := msq_young P
  obtain ⟨Cf, hCf0, hfs⟩ := size_X hθ κ
  have hK : 0 < Kt κ := by unfold Kt; positivity
  set E2 := Real.exp (2 * κ) with hE2
  set Cu : ℝ := 1 + Cs' 1 + Cs' 2 with hCu
  have hCs'0 : ∀ j, 0 ≤ Cs' j := twC_nonneg hCm0
  have hCu0 : 0 ≤ Cu := by have := hCs'0 1; have := hCs'0 2; rw [hCu]; linarith
  set Q : ℝ := 6 * (Cc + 1) + 3 * Cd + 2 * Co * Cu + Co with hQ
  have hQ0 : 0 ≤ Q := by rw [hQ]; positivity
  refine ⟨E2 * (2 * Kt κ * Q) + 8 * Cst * CS * B ^ 2 * Cf,
    max (max (max To Td) (max Tm Tc)) (max (max 8 (Real.exp 1))
      (max (Real.exp (10 * κ)) (max (Real.exp (52 * κ)) (Real.exp (κ / etaX θ))))),
    by positivity, fun T hT W hW α β hreg => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨⟨⟨hTo, hTd⟩, hTm, hTc⟩, ⟨hT8, hTe⟩, hT10, hT52, hTη⟩ := hT
  have hT0 : 0 < T := by linarith
  have hlog : ∀ x : ℝ, Real.exp x ≤ T → x ≤ Real.log T := fun x hx => by
    rw [← Real.log_exp x]; exact Real.log_le_log (Real.exp_pos x) hx
  have hL1 : 1 ≤ Real.log T := hlog 1 hTe
  have hL52 : 52 * κ ≤ Real.log T := hlog _ hT52
  have hLη : κ / etaX θ ≤ Real.log T := hlog _ hTη
  have hL0 : 0 < Real.log T := by linarith
  have hΔ : 0 < T / Real.log T := div_pos hT0 hL0
  obtain ⟨hα, hβ, hαβ, -⟩ := hreg.small hκ hT10
  have hreg' := hreg.swap
  obtain ⟨hα', hβ', hαβ', -⟩ := hreg'.small hκ hT10
  have hkη : κ / Real.log T ≤ etaX θ := by
    rw [div_le_iff₀ hL0]
    rw [div_le_iff₀ hη] at hLη
    linarith
  have hs : ‖-(α + β)‖ ≤ 2 * κ / Real.log T := by
    rw [norm_neg]
    refine (norm_add_le α β).trans ?_
    have := hreg.1
    have := hreg.2.1
    have e : 2 * κ / Real.log T = κ / Real.log T + κ / Real.log T := by ring
    linarith
  set z : ℂ := -(α + β) with hz
  set M := Mof T θ with hM
  set a := aY P T θ R with ha
  set σ := sig0 T R with hσ
  set b : ℝ := Real.log T / (2 * Kt κ) with hb
  -- the two twisted weights
  set Wu := twist W Complex.reCLM (cT z T) z (1 / 2 - b) b hT0 hΔ
    (h01_re hκ hT0 hL52 hs) (hder_of Complex.reCLM
      (fun w => by rw [Complex.reCLM_apply]; exact Complex.abs_re_le_norm w) hκ hT0 hL1 hL52 hs)
    with hWu
  set Wv := twist W Complex.imCLM (cT z T) z (1 / 2) b hT0 hΔ
    (h01_im hκ hT0 hL52 hs) (hder_of Complex.imCLM
      (fun w => by rw [Complex.imCLM_apply]; exact Complex.abs_im_le_norm w) hκ hT0 hL1 hL52 hs)
    with hWv
  have hWC : ∀ j, twC W.Cj j ≤ Cs' j :=
    twC_mono (fun i => (hW i).trans (le_max_left _ _))
  have hWC' : ∀ j, W.Cj j ≤ Cs' j := fun j =>
    ((hW j).trans (le_max_left _ _)).trans (le_twC hCm0 j)
  -- each `I₁` is `O(T)`
  have hZ : ‖riemannZeta (1 + -β + -α) * Sdiag M a σ (-β) (-α) 0‖ ≤ Cc + 1 := by
    have h1 := hm T hTm (-β) (-α) hreg'
    have h2 := hc T hTc (-β) (-α) hreg'
    have := norm_sub_norm_le (riemannZeta (1 + -β + -α) * Sdiag M a σ (-β) (-α) 0)
      (c1Y P M (-β) (-α))
    linarith
  have hI : ∀ X : WeightAll T (Real.log T), (∀ j, X.Cj j ≤ Cs' j) →
      ‖I1 X.toWeight M a σ (-β) (-α) 1‖ ≤ 2 * T * (Cc + 1) + Cd * (T / Real.log T) +
        Co * errY X.toWeight := fun X hX =>
    I1_X_bound hT8 X M a σ hα' hβ' (hd T hTd X.toWeight (-β) (-α) hreg')
      (ho T hTo X hX (-β) (-α) hreg') hZ
  have hIu := hI Wu hWC
  have hIv := hI Wv hWC
  have hIw := hI W hWC'
  have hTL : T / Real.log T ≤ errY W.toWeight := by
    unfold errY
    have := W.C1_nonneg
    have := W.C2_nonneg
    nlinarith
  have herru : errY Wu.toWeight ≤ Cu * (T / Real.log T) := by
    show (1 + twC W.Cj 1 + twC W.Cj 2) * (T / Real.log T) ≤ _
    rw [hCu]
    exact mul_le_mul_of_nonneg_right (by linarith [hWC 1, hWC 2]) hΔ.le
  have herrv : errY Wv.toWeight ≤ Cu * (T / Real.log T) := by
    show (1 + twC W.Cj 1 + twC W.Cj 2) * (T / Real.log T) ≤ _
    rw [hCu]
    exact mul_le_mul_of_nonneg_right (by linarith [hWC 1, hWC 2]) hΔ.le
  -- the integrands
  set S' := fun t => S1 (-β) (-α) 1 t with hS'
  set f := fun t => (W.w t : ℂ) * S1 (-β) (-α) 1 t * (msq M a σ t : ℂ) with hf
  set fu := fun t => (Wu.w t : ℂ) * S1 (-β) (-α) 1 t * (msq M a σ t : ℂ) with hfu
  set fv := fun t => (Wv.w t : ℂ) * S1 (-β) (-α) 1 t * (msq M a σ t : ℂ) with hfv
  set F := fun t => (W.w t : ℂ) * (cT z T * Gk z 0 t - 1) * S1 (-β) (-α) 1 t *
    (msq M a σ t : ℂ) with hF
  have iF := integrable_I1 W.toWeight (by linarith) M a σ hα' hβ' (c := 1) one_pos
  have iFu := integrable_I1 Wu.toWeight (by linarith) M a σ hα' hβ' (c := 1) one_pos
  have iFv := integrable_I1 Wv.toWeight (by linarith) M a σ hα' hβ' (c := 1) one_pos
  have hpt : ∀ t, F t = ((Kt κ / Real.log T : ℝ) : ℂ) *
      ((2 * fu t - f t) + I * (2 * fv t - f t)) := by
    intro t
    simp only [hF, hf, hfu, hfv]
    rw [decomp hκ hL0 (W.w t) t]
    have eu : Wu.w t = W.w t * phi Complex.reCLM (cT z T) z (1 / 2 - b) b t := rfl
    have ev : Wv.w t = W.w t * phi Complex.imCLM (cT z T) z (1 / 2) b t := rfl
    rw [eu, ev]
    push_cast
    ring
  obtain ⟨iJ, hJ⟩ := lin_comb iF iFu iFv _ hpt
  set J := ∫ t, F t with hJdef
  have hJb : ‖J‖ ≤ 2 * Kt κ * Q * errY W.toWeight := by
    rw [hJ, hQ]
    exact J_alg hK.le hL1 hT0.le hCc0 hCd0 hCo0 hCu0 hIu hIv hIw herru herrv hTL
  -- the remainder
  set Tp : ℂ := (T : ℂ) ^ z with hTp
  have iX := integrable_IX W.toWeight (by linarith) M a σ hα hβ hαβ
  have hsplit : IX W.toWeight M a σ α β 1 - Tp * I1 W.toWeight M a σ (-β) (-α) 1 =
      (∫ t, (W.w t : ℂ) * ((XY α β t - Tp * (cT z T * Gk z 0 t)) * S1 (-β) (-α) 1 t) *
        (msq M a σ t : ℂ)) + Tp * J :=
    split_eq Tp iX iF iJ fun t => by simp only [hF]; ring
  have hNb : 1 + 1 / ‖-β + -α‖ ^ 2 ≤ 1 + κ ^ 2 * Real.log T ^ 2 := N_le hκ hL0 hreg'
  have hst : ∀ t ∈ Set.Icc (T / 4) (2 * T),
      ‖XY α β t - (((t / (2 * Real.pi) : ℝ)) : ℂ) ^ (-(α + β))‖ ≤ Cst / t := by
    intro t ht
    have ht0 : 0 < t := by linarith [ht.1]
    have hm := norm_main_le hκ hT8 hL1 hs ht
    refine (hrel α β hα hβ t (by linarith [ht.1])).trans ?_
    rw [hCst]
    apply div_le_div_of_nonneg_right _ ht0.le
    exact mul_le_mul_of_nonneg_left hm hCr0
  have hEb := E_bound' hT8 W.toWeight M a σ (α := α) (β := β) hCst0 hCS0
    (by positivity : (0 : ℝ) ≤ 1 + κ ^ 2 * Real.log T ^ 2)
    (by positivity : (0 : ℝ) ≤ B ^ 2 * ((M : ℝ) * (1 + Real.log M)))
    (by linarith : (0 : ℝ) ≤ 1 / 2 + 2 * etaX θ)
    hst
    (fun t ht => (hS1 (-β) (-α) hα' hβ' hαβ' (by rw [norm_neg]; exact hreg.2.1.trans hkη)
      (by rw [norm_neg]; exact hreg.1.trans hkη) t ht).trans (by
        apply mul_le_mul_of_nonneg_right _ (by positivity)
        exact mul_le_mul_of_nonneg_left hNb hCS0))
    (fun t => hB T θ R t)
  have hMr : ((M : ℕ) : ℝ) ≤ T ^ θ := Nat.floor_le (by positivity)
  have hsz := hfs T hTe M hMr
  have hEb' : ‖∫ t, (W.w t : ℂ) * ((XY α β t - Tp * (cT z T * Gk z 0 t)) * S1 (-β) (-α) 1 t) *
      (msq M a σ t : ℂ)‖ ≤ 8 * Cst * CS * B ^ 2 * Cf * errY W.toWeight := by
    refine hEb.trans ?_
    calc 8 * Cst * CS * (1 + κ ^ 2 * Real.log T ^ 2) * (2 * T) ^ (1 / 2 + 2 * etaX θ) *
          (B ^ 2 * ((M : ℝ) * (1 + Real.log M))) =
        8 * Cst * CS * B ^ 2 * ((1 + κ ^ 2 * Real.log T ^ 2) *
          (2 * T) ^ (1 / 2 + 2 * etaX θ) * ((M : ℝ) * (1 + Real.log M))) := by ring
      _ ≤ 8 * Cst * CS * B ^ 2 * (Cf * (T / Real.log T)) :=
          mul_le_mul_of_nonneg_left hsz (by positivity)
      _ ≤ 8 * Cst * CS * B ^ 2 * (Cf * errY W.toWeight) :=
          mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left hTL hCf0) (by positivity)
      _ = _ := by ring
  have hTpb : ‖Tp‖ ≤ E2 := by
    rw [hTp, hz]
    exact norm_Tpow_le (by linarith) hreg
  rw [hsplit]
  calc _ ≤ ‖∫ t, (W.w t : ℂ) * ((XY α β t - Tp * (cT z T * Gk z 0 t)) * S1 (-β) (-α) 1 t) *
          (msq M a σ t : ℂ)‖ + ‖Tp * J‖ := norm_add_le _ _
    _ ≤ 8 * Cst * CS * B ^ 2 * Cf * errY W.toWeight + E2 * (2 * Kt κ * Q * errY W.toWeight) := by
        rw [norm_mul]
        exact add_le_add hEb' (mul_le_mul hTpb hJb (norm_nonneg _) (Real.exp_pos _).le)
    _ = _ := by ring

/-- **Lemma 3 up to `I_res`, `o(T)`, from the main term alone**: `SwapX.lemma3_resO_of_mainO`'s
route with the Stirling input discharged in its relative form (`stmtXStirlingRel_holds`),
through `stmtXAll_of'`. `StmtDiagMainO → StmtLemma3resO`, `θ < 1/2`, `κ > 0`. -/
theorem lemma3_resO_of_mainO' (P : Polynomial ℝ) {θ : ℝ} (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ}
    (hκ : 0 < κ) (hmain : StmtDiagMainO P θ R κ) : StmtLemma3resO P θ R κ :=
  lemma3_resO_of_partsAll hκ (stmtDiagO_of_mainO P hθ R hκ hmain) (stmtOffDiag_holds P hθ R hκ)
    (stmtXAll_of' P hθ R hκ stmtXStirlingRel_holds hmain)

/-! ## Axiom pins -/

/-- info: 'Stirling.XY_eq_exp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms XY_eq_exp

/-- info: 'Stirling.exponent_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exponent_le

/-- info: 'Stirling.stmtXStirlingRel_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtXStirlingRel_holds

/-- info: 'Stirling.stmtXAll_of'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtXAll_of'

/-- info: 'Stirling.lemma3_resO_of_mainO'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lemma3_resO_of_mainO'

end

end Stirling
