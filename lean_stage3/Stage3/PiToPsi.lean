/-
PiToPsi — block T5 of `lean_stage3/design/joints.md`, first part. 2026-11-22.

From the count `π` back to `ψ`. `PsiToPi` carries a bound on `ψ` to a bound on
`π − Li`; this module carries it back, by upstream's Abel summation
`Chebyshev.theta_eq_primeCounting_mul_log_sub_integral` and the matching
identity for `Li`. With `VonKoch.RH_iff_psiWeak` the Riemann hypothesis is then
equivalent to the square-root bound on `π − Li` itself.

  Li_two                         Li 2 = 2 / log 2
  continuousOn_Li                Li is continuous on (1, ∞)
  Li_mul_log_sub_integral        2 ≤ x ⊢ Li x · log x − ∫₂ˣ Li t / t = x
  intervalIntegrable_pi_div      2 ≤ x ⊢ π(⌊t⌋)/t is integrable on [2, x]
  intervalIntegrable_Li_div      2 ≤ x ⊢ Li t / t is integrable on [2, x]
  relRes                         relRes t = (π(⌊t⌋) − Li t) / t
  intervalIntegrable_relRes      2 ≤ x ⊢ relRes is integrable on [2, x]
  theta_sub_id_eq                2 ≤ x ⊢ θ x − x = (π(⌊x⌋) − Li x)·log x − ∫₂ˣ relRes
  relRes_tail_le                 the tail of ∫|relRes| under the π-side bound
  psiWeak_of_schoenfeldWeak      0 ≤ C, 2 ≤ x₀, StmtSchoenfeldWeak C 1 x₀ π Li
                                   ⊢ ∃ C' > 0, ∃ x₁, StmtPsiWeak C' 3 x₁
  RH_of_schoenfeldWeak           StmtSchoenfeldWeak C 1 x₀ π Li ⊢ RiemannHypothesis
  RH_iff_schoenfeldWeak          RiemannHypothesis ↔ ∃ C x₀, StmtSchoenfeldWeak C 1 x₀ π Li

Sizes. With `B = ∫₂^{x₀} |relRes|`, for `x ≥ max x₀ 3`:
`|θ x − x| ≤ C·√x·log²x + B + 2C·√x·log x`, `|ψ − θ| ≤ 2√x·log x`, and
`log x ≥ 1`, `√x ≥ 1` give `|ψ x − x| ≤ (3C + B + 2)·√x·log³x`.

What the next slice needs: `RH_iff_schoenfeldWeak`, for `CellResidual`.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.GlueFloor
import Stage3.RowLeaves
import Stage3.VonKochScaffold

namespace PiToPsi

open Chebyshev MeasureTheory Set Stage3
open scoped Chebyshev

noncomputable section

/-- At two the smooth count is `2 / log 2`: its integral part is empty there. -/
theorem Li_two : Stage3.Li 2 = 2 / Real.log 2 := by
  unfold Stage3.Li
  simp

/-- The smooth count `Li` is continuous past one, because it has a derivative there. -/
theorem continuousOn_Li : ContinuousOn Stage3.Li (Ioi 1) := fun _ hy =>
  (hasDerivAt_Li hy).continuousAt.continuousWithinAt

/-- Every point between two and `x` is past one, where `Li` and `log` behave. -/
theorem uIcc_two_subset {x : ℝ} (hx : 2 ≤ x) : uIcc (2 : ℝ) x ⊆ Ioi 1 := by
  rw [uIcc_of_le hx]
  intro t ht
  exact lt_of_lt_of_le (by norm_num) ht.1

/-- `Li t / t` can be integrated from two to `x`. -/
theorem intervalIntegrable_Li_div {x : ℝ} (hx : 2 ≤ x) :
    IntervalIntegrable (fun t : ℝ => Stage3.Li t / t) volume 2 x := by
  refine ContinuousOn.intervalIntegrable ?_
  refine (continuousOn_Li.mono (uIcc_two_subset hx)).div continuousOn_id ?_
  intro t ht
  have h1 : (1 : ℝ) < t := uIcc_two_subset hx ht
  linarith

/-- The count over `t` can be integrated from two to `x`: the count only steps upward. -/
theorem intervalIntegrable_pi_div {x : ℝ} (hx : 2 ≤ x) :
    IntervalIntegrable (fun t : ℝ => (Nat.primeCounting ⌊t⌋₊ : ℝ) / t) volume 2 x := by
  have hmono : Monotone (fun t : ℝ => (Nat.primeCounting ⌊t⌋₊ : ℝ)) := by
    intro a b hab
    show (Nat.primeCounting ⌊a⌋₊ : ℝ) ≤ (Nat.primeCounting ⌊b⌋₊ : ℝ)
    exact_mod_cast Nat.monotone_primeCounting (Nat.floor_mono hab)
  have h1 : IntervalIntegrable (fun t : ℝ => (Nat.primeCounting ⌊t⌋₊ : ℝ)) volume 2 x :=
    hmono.intervalIntegrable
  have h2 : ContinuousOn (fun t : ℝ => t⁻¹) (uIcc (2 : ℝ) x) := by
    refine continuousOn_id.inv₀ ?_
    intro t ht
    have h1 : (1 : ℝ) < t := uIcc_two_subset hx ht
    simp only [id_eq]
    linarith
  have h3 := h1.mul_continuousOn h2
  simpa [div_eq_mul_inv] using h3

/-- **`Li` undone.** `Li x · log x` minus the integral of `Li t / t` from two is exactly `x`. This is the smooth side of the passage from the count back to `θ`. -/
theorem Li_mul_log_sub_integral {x : ℝ} (hx : 2 ≤ x) :
    Stage3.Li x * Real.log x - ∫ t in (2 : ℝ)..x, Stage3.Li t / t = x := by
  have hderiv : ∀ t ∈ uIcc (2 : ℝ) x,
      HasDerivAt (fun u => Stage3.Li u * Real.log u) (1 + Stage3.Li t / t) t := by
    intro t ht
    have h1 : (1 : ℝ) < t := uIcc_two_subset hx ht
    have hl : Real.log t ≠ 0 := (Real.log_pos h1).ne'
    have ht0 : t ≠ 0 := by linarith
    have h := (hasDerivAt_Li h1).mul (Real.hasDerivAt_log ht0)
    refine h.congr_deriv ?_
    rw [one_div_mul_cancel hl, div_eq_mul_inv]
  have hone : IntervalIntegrable (fun _ : ℝ => (1 : ℝ)) volume 2 x := intervalIntegrable_const
  have hint : IntervalIntegrable (fun t : ℝ => 1 + Stage3.Li t / t) volume 2 x :=
    hone.add (intervalIntegrable_Li_div hx)
  have hFTC := intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint
  rw [intervalIntegral.integral_add hone (intervalIntegrable_Li_div hx),
    intervalIntegral.integral_const, smul_eq_mul, mul_one] at hFTC
  have h2 : Stage3.Li 2 * Real.log 2 = 2 := by
    rw [Li_two]
    exact div_mul_cancel₀ _ (Real.log_pos (by norm_num)).ne'
  linarith

/-- The residual of the count against `Stage3.Li`, relative to `t`. -/
def relRes (t : ℝ) : ℝ := ((Nat.primeCounting ⌊t⌋₊ : ℝ) - Stage3.Li t) / t

/-- The relative residual can be integrated from two to `x`. -/
theorem intervalIntegrable_relRes {x : ℝ} (hx : 2 ≤ x) :
    IntervalIntegrable relRes volume 2 x := by
  have h : relRes = fun t : ℝ => (Nat.primeCounting ⌊t⌋₊ : ℝ) / t - Stage3.Li t / t := by
    funext t
    unfold relRes
    rw [sub_div]
  rw [h]
  exact (intervalIntegrable_pi_div hx).sub (intervalIntegrable_Li_div hx)

/-- **`θ` from `π`**, with `Stage3.Li` taken off both sides. -/
theorem theta_sub_id_eq {x : ℝ} (hx : 2 ≤ x) :
    θ x - x = ((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x) * Real.log x
      - ∫ t in (2 : ℝ)..x, relRes t := by
  have h1 := Chebyshev.theta_eq_primeCounting_mul_log_sub_integral hx
  have h2 := Li_mul_log_sub_integral hx
  have hsplit : (∫ t in (2 : ℝ)..x, relRes t)
      = (∫ t in (2 : ℝ)..x, (Nat.primeCounting ⌊t⌋₊ : ℝ) / t)
        - ∫ t in (2 : ℝ)..x, Stage3.Li t / t := by
    rw [← intervalIntegral.integral_sub (intervalIntegrable_pi_div hx)
      (intervalIntegrable_Li_div hx)]
    refine intervalIntegral.integral_congr fun t _ => ?_
    simp only [relRes]
    rw [sub_div]
  rw [hsplit]
  linarith

/-- The tail of `∫ |relRes|` under the `π`-side bound. -/
theorem relRes_tail_le {C x₀ x : ℝ} (hC : 0 ≤ C) (hx₀ : 2 ≤ x₀) (hx : x₀ ≤ x)
    (h : StmtSchoenfeldWeak C 1 x₀ (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li) :
    (∫ t in x₀..x, |relRes t|) ≤ 2 * (C * Real.log x) * Real.sqrt x := by
  have hx2 : (2 : ℝ) ≤ x := le_trans hx₀ hx
  have hx₀pos : (0 : ℝ) < x₀ := by linarith
  have hLx : 0 ≤ Real.log x := Real.log_nonneg (by linarith)
  have hsub : uIcc x₀ x ⊆ uIcc (2 : ℝ) x := by
    rw [uIcc_of_le hx, uIcc_of_le hx2]
    exact Icc_subset_Icc_left hx₀
  have hint1 : IntervalIntegrable (fun t => |relRes t|) volume x₀ x :=
    ((intervalIntegrable_relRes hx2).abs).mono_set hsub
  have hint2 : IntervalIntegrable (fun t : ℝ => (C * Real.log x) * t ^ (-(1 : ℝ) / 2))
      volume x₀ x := by
    refine ContinuousOn.intervalIntegrable ?_
    refine continuousOn_const.mul (continuousOn_id.rpow_const ?_)
    intro t ht
    rw [uIcc_of_le hx] at ht
    left
    simp only [id_eq]
    linarith [ht.1]
  refine le_trans (intervalIntegral.integral_mono_on hx hint1 hint2 ?_)
    (integral_A_rpow_le hx₀pos hx (mul_nonneg hC hLx))
  intro t ht
  have ht0 : (0 : ℝ) < t := by linarith [ht.1]
  have hs : 0 < Real.sqrt t := Real.sqrt_pos.mpr ht0
  have hts : Real.sqrt t * Real.sqrt t = t := Real.mul_self_sqrt ht0.le
  have hb := h t ht.1
  rw [pow_one] at hb
  have hlog : Real.log t ≤ Real.log x := Real.log_le_log ht0 ht.2
  have hrp : t ^ (-(1 : ℝ) / 2) = (Real.sqrt t)⁻¹ := by
    rw [show (-(1 : ℝ) / 2) = -(1 / 2) by ring, Real.rpow_neg ht0.le, ← Real.sqrt_eq_rpow]
  have hinv : (Real.sqrt t)⁻¹ * t = Real.sqrt t := by
    rw [inv_mul_eq_div, div_eq_iff hs.ne']
    exact hts.symm
  simp only [relRes]
  rw [abs_div, abs_of_pos ht0, div_le_iff₀ ht0, hrp]
  calc |(Nat.primeCounting ⌊t⌋₊ : ℝ) - Stage3.Li t|
      ≤ C * Real.sqrt t * Real.log t := hb
    _ ≤ C * Real.sqrt t * Real.log x :=
        mul_le_mul_of_nonneg_left hlog (mul_nonneg hC hs.le)
    _ = C * Real.log x * (Real.sqrt t)⁻¹ * t := by
        rw [mul_assoc (C * Real.log x), hinv]
        ring

/-- **From the count to `ψ`.** The square-root bound on `π − Stage3.Li` gives the
bound on `ψ` at two more logarithms. -/
theorem psiWeak_of_schoenfeldWeak {C x₀ : ℝ} (hC : 0 ≤ C) (hx₀ : 2 ≤ x₀)
    (h : StmtSchoenfeldWeak C 1 x₀ (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li) :
    ∃ C' > 0, ∃ x₁ : ℝ, StmtPsiWeak C' 3 x₁ := by
  have hB0 : 0 ≤ ∫ t in (2 : ℝ)..x₀, |relRes t| :=
    intervalIntegral.integral_nonneg hx₀ (fun t _ => abs_nonneg _)
  refine ⟨3 * C + (∫ t in (2 : ℝ)..x₀, |relRes t|) + 2, by positivity, max x₀ 3,
    fun x hx => ?_⟩
  have hxx₀ : x₀ ≤ x := le_trans (le_max_left _ _) hx
  have hx3 : (3 : ℝ) ≤ x := le_trans (le_max_right _ _) hx
  have hx2 : (2 : ℝ) ≤ x := by linarith
  have hL1 : 1 ≤ Real.log x := by
    have he : Real.exp 1 ≤ x := by
      have := Real.exp_one_lt_three
      linarith
    calc (1 : ℝ) = Real.log (Real.exp 1) := (Real.log_exp 1).symm
      _ ≤ Real.log x := Real.log_le_log (Real.exp_pos 1) he
  have hL0 : 0 ≤ Real.log x := by linarith
  have hs1 : 1 ≤ Real.sqrt x := by
    rw [show (1 : ℝ) = Real.sqrt 1 by simp]
    exact Real.sqrt_le_sqrt (by linarith)
  have hs0 : 0 ≤ Real.sqrt x := by linarith
  -- the integral, split at x₀
  have habs : ∀ y : ℝ, 2 ≤ y → IntervalIntegrable (fun t => |relRes t|) volume 2 y :=
    fun y hy => (intervalIntegrable_relRes hy).abs
  have hsub : uIcc x₀ x ⊆ uIcc (2 : ℝ) x := by
    rw [uIcc_of_le hxx₀, uIcc_of_le hx2]
    exact Icc_subset_Icc_left hx₀
  have hsplit : (∫ t in (2 : ℝ)..x, |relRes t|)
      = (∫ t in (2 : ℝ)..x₀, |relRes t|) + ∫ t in x₀..x, |relRes t| :=
    (intervalIntegral.integral_add_adjacent_intervals (habs x₀ hx₀)
      ((habs x hx2).mono_set hsub)).symm
  have hI : |∫ t in (2 : ℝ)..x, relRes t|
      ≤ (∫ t in (2 : ℝ)..x₀, |relRes t|) + 2 * (C * Real.log x) * Real.sqrt x := by
    refine le_trans (intervalIntegral.abs_integral_le_integral_abs hx2) ?_
    rw [hsplit]
    linarith [relRes_tail_le hC hx₀ hxx₀ h]
  -- θ
  have hb := h x hxx₀
  rw [pow_one] at hb
  have hθ : |θ x - x| ≤ C * Real.sqrt x * Real.log x * Real.log x
      + ((∫ t in (2 : ℝ)..x₀, |relRes t|) + 2 * (C * Real.log x) * Real.sqrt x) := by
    rw [theta_sub_id_eq hx2]
    refine le_trans (abs_sub _ _) (add_le_add ?_ hI)
    rw [abs_mul, abs_of_nonneg hL0]
    exact mul_le_mul_of_nonneg_right hb hL0
  -- ψ
  have hψθ := Chebyshev.abs_psi_sub_theta_le_sqrt_mul_log (by linarith : (1 : ℝ) ≤ x)
  have hψ : |ψ x - x| ≤ |ψ x - θ x| + |θ x - x| := abs_sub_le _ _ _
  -- the powers of the logarithm
  have hL2 : Real.log x ^ 2 ≤ Real.log x ^ 3 := by
    nlinarith [mul_nonneg (sq_nonneg (Real.log x)) (sub_nonneg.mpr hL1)]
  have hL13 : Real.log x ≤ Real.log x ^ 3 := by
    nlinarith [mul_nonneg (mul_nonneg hL0 (sub_nonneg.mpr hL1))
      (by linarith : (0 : ℝ) ≤ Real.log x + 1)]
  have hsL : 1 ≤ Real.sqrt x * Real.log x ^ 3 :=
    one_le_mul_of_one_le_of_one_le hs1 (one_le_pow₀ hL1)
  have hCs : 0 ≤ C * Real.sqrt x := mul_nonneg hC hs0
  have e1 : C * Real.sqrt x * Real.log x * Real.log x
      ≤ C * (Real.sqrt x * Real.log x ^ 3) := by
    calc C * Real.sqrt x * Real.log x * Real.log x
        = (C * Real.sqrt x) * Real.log x ^ 2 := by ring
      _ ≤ (C * Real.sqrt x) * Real.log x ^ 3 := mul_le_mul_of_nonneg_left hL2 hCs
      _ = C * (Real.sqrt x * Real.log x ^ 3) := by ring
  have e2 : 2 * (C * Real.log x) * Real.sqrt x
      ≤ 2 * C * (Real.sqrt x * Real.log x ^ 3) := by
    calc 2 * (C * Real.log x) * Real.sqrt x
        = 2 * ((C * Real.sqrt x) * Real.log x) := by ring
      _ ≤ 2 * ((C * Real.sqrt x) * Real.log x ^ 3) := by
          have := mul_le_mul_of_nonneg_left hL13 hCs
          linarith
      _ = 2 * C * (Real.sqrt x * Real.log x ^ 3) := by ring
  have e3 : 2 * Real.sqrt x * Real.log x ≤ 2 * (Real.sqrt x * Real.log x ^ 3) := by
    have := mul_le_mul_of_nonneg_left hL13 hs0
    linarith
  have e4 : (∫ t in (2 : ℝ)..x₀, |relRes t|)
      ≤ (∫ t in (2 : ℝ)..x₀, |relRes t|) * (Real.sqrt x * Real.log x ^ 3) :=
    le_mul_of_one_le_right hB0 hsL
  have hfin : (3 * C + (∫ t in (2 : ℝ)..x₀, |relRes t|) + 2) * Real.sqrt x * Real.log x ^ 3
      = C * (Real.sqrt x * Real.log x ^ 3) + 2 * C * (Real.sqrt x * Real.log x ^ 3)
        + (∫ t in (2 : ℝ)..x₀, |relRes t|) * (Real.sqrt x * Real.log x ^ 3)
        + 2 * (Real.sqrt x * Real.log x ^ 3) := by
    ring
  rw [hfin]
  linarith

/-- **The square-root bound on the count gives the Riemann hypothesis.** -/
theorem RH_of_schoenfeldWeak {C x₀ : ℝ}
    (h : StmtSchoenfeldWeak C 1 x₀ (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li) :
    RiemannHypothesis := by
  have h' : StmtSchoenfeldWeak (max C 0) 1 (max x₀ 2)
      (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li := by
    intro x hx
    have hx2 : (2 : ℝ) ≤ x := le_trans (le_max_right _ _) hx
    have hs0 : 0 ≤ Real.sqrt x := Real.sqrt_nonneg x
    have hL0 : 0 ≤ Real.log x ^ 1 := pow_nonneg (Real.log_nonneg (by linarith)) 1
    refine le_trans (h x (le_trans (le_max_left _ _) hx)) ?_
    exact mul_le_mul_of_nonneg_right
      (mul_le_mul_of_nonneg_right (le_max_left C 0) hs0) hL0
  obtain ⟨C', hC', x₁, hψ⟩ :=
    psiWeak_of_schoenfeldWeak (le_max_right C 0) (le_max_right x₀ 2) h'
  exact VonKoch.RH_iff_psiWeak.mpr ⟨C', hC', x₁, hψ⟩

/-- **The Riemann hypothesis is the square-root bound on the count.** -/
theorem RH_iff_schoenfeldWeak :
    RiemannHypothesis ↔ ∃ C x₀ : ℝ,
      StmtSchoenfeldWeak C 1 x₀ (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li := by
  constructor
  · intro hRH
    obtain ⟨c₁, c₃, c₄, _, _, _, h⟩ := schoenfeldWeak_floor_split_of_RH hRH
    exact ⟨_, _, h 16 le_rfl⟩
  · rintro ⟨C, x₀, h⟩
    exact RH_of_schoenfeldWeak h

/-- info: 'PiToPsi.Li_mul_log_sub_integral' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Li_mul_log_sub_integral

/-- info: 'PiToPsi.theta_sub_id_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms theta_sub_id_eq

/-- info: 'PiToPsi.psiWeak_of_schoenfeldWeak' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms psiWeak_of_schoenfeldWeak

/-- info: 'PiToPsi.RH_of_schoenfeldWeak' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RH_of_schoenfeldWeak

/-- info: 'PiToPsi.RH_iff_schoenfeldWeak' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RH_iff_schoenfeldWeak

end

end PiToPsi
