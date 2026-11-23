/-
PiZeros — block T2 of `lean_stage3/design/joints.md`. 2026-11-22.

Joint T1 in the integer table: the count of primes in place of the log-weighted
count, zero by zero. The passage from one to the other is linear: `tr f x` is
`f x / log x` plus the integral of `f` against `1/(t·log²t)` from `2`, and
`Stage3.pi_sub_Li_eq` says the count minus its smooth part is `tr (θ − id)`.
Write `θ − id` as the explicit formula's remainder at a height, minus the sum
over the zeros below it, minus the higher prime powers `ψ − θ`. Then `tr`
passes through, zero by zero, and the result is an identity: it holds for every
`x ≥ 2` and every height.

  wt, tr                    the passage, on any function
  tr_sub, tr_const_mul, tr_sum   it is linear
  pi_sub_Li_eq_tr           the count minus Li is tr (θ − id)
  piMode ρ x                one zero's part of the count: tr (t ↦ t^ρ/ρ)
  efRem T, psiTheta         the explicit formula's remainder; ψ − θ
  pi_eq_zero_sum            2 ≤ x ⊢ π(⌊x⌋) − Li x = −Σ_{|γ|<T} m(ρ)·piMode ρ x
                              + tr (efRem T) x − tr psiTheta x
  norm_tr_psiTheta_le       2 ≤ x ⊢ ‖tr psiTheta x‖ ≤ 8·√x
  table_cell_eq_zero_sum    d + 2 ≤ r ⊢ the table's cell (r, d) less the smooth
                              cell = the same three terms under the stencil

What the next slice needs: a bound on `tr (efRem T) x`. The explicit formula
bounds `efRem T t` only for `T ≤ t²`, so the integral from `2` to `√T` needs
its own estimate. It is not here.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.FiniteOffLine
import Stage3.CellResidual

namespace PiZeros

open Chebyshev MeasureTheory Kadiri FiniteOffLine Finset
open scoped Chebyshev

noncomputable section

/-- The weight of the passage from the log-weighted count to the count. -/
def wt (t : ℝ) : ℂ := (((t * Real.log t ^ 2)⁻¹ : ℝ) : ℂ)

/-- The passage from the log-weighted count to the count, applied to any
function: its value over the logarithm, plus its integral against the weight. -/
def tr (f : ℝ → ℂ) (x : ℝ) : ℂ :=
  f x / (Real.log x : ℂ) + ∫ t in (2:ℝ)..x, f t * wt t

/-- For `x ≥ 2` the weight is continuous on `[2, x]`. -/
theorem wt_continuousOn {x : ℝ} (hx : 2 ≤ x) : ContinuousOn wt (Set.uIcc 2 x) :=
  Complex.continuous_ofReal.comp_continuousOn (Stage3.continuousOn_inv_mul_log_sq le_rfl hx)

/-- For `x ≥ 2`, a function integrable on `[2, x]` stays integrable when multiplied by the weight. -/
theorem integrable_mul_wt {f : ℝ → ℂ} {x : ℝ} (hx : 2 ≤ x)
    (hf : IntervalIntegrable f volume 2 x) :
    IntervalIntegrable (fun t => f t * wt t) volume 2 x :=
  hf.mul_continuousOn (wt_continuousOn hx)

/-- The passage of a difference of two integrable functions is the difference of their passages. -/
theorem tr_sub {f g : ℝ → ℂ} {x : ℝ} (hx : 2 ≤ x) (hf : IntervalIntegrable f volume 2 x)
    (hg : IntervalIntegrable g volume 2 x) :
    tr (fun t => f t - g t) x = tr f x - tr g x := by
  unfold tr
  have h : (fun t => (f t - g t) * wt t) = fun t => f t * wt t - g t * wt t := by
    funext t
    ring
  rw [h, intervalIntegral.integral_sub (integrable_mul_wt hx hf) (integrable_mul_wt hx hg)]
  ring

/-- A constant factor passes through the passage. -/
theorem tr_const_mul (c : ℂ) (f : ℝ → ℂ) (x : ℝ) :
    tr (fun t => c * f t) x = c * tr f x := by
  unfold tr
  have h : (fun t => c * f t * wt t) = fun t => c * (f t * wt t) := by
    funext t
    ring
  rw [h, intervalIntegral.integral_const_mul]
  ring

/-- The passage of a finite sum of integrable functions is the sum of their passages. -/
theorem tr_sum {ι : Type*} (s : Finset ι) (f : ι → ℝ → ℂ) {x : ℝ} (hx : 2 ≤ x)
    (hf : ∀ i ∈ s, IntervalIntegrable (f i) volume 2 x) :
    tr (fun t => ∑ i ∈ s, f i t) x = ∑ i ∈ s, tr (f i) x := by
  unfold tr
  have h : (fun t => (∑ i ∈ s, f i t) * wt t) = fun t => ∑ i ∈ s, f i t * wt t := by
    funext t
    rw [Finset.sum_mul]
  rw [h, intervalIntegral.integral_finsetSum (fun i hi => integrable_mul_wt hx (hf i hi)),
    Finset.sum_div, ← Finset.sum_add_distrib]

/-- The count minus its smooth part is the passage applied to `θ − id`. -/
theorem pi_sub_Li_eq_tr {x : ℝ} (hx : 2 ≤ x) :
    (((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x : ℝ) : ℂ)
      = tr (fun t => ((θ t - t : ℝ) : ℂ)) x := by
  rw [Stage3.pi_sub_Li_eq hx]
  unfold tr wt
  have h : (fun t : ℝ => ((θ t - t : ℝ) : ℂ) * (((t * Real.log t ^ 2)⁻¹ : ℝ) : ℂ))
      = fun t : ℝ => (((θ t - t) / (t * Real.log t ^ 2) : ℝ) : ℂ) := by
    funext t
    rw [div_eq_mul_inv]
    push_cast
    ring
  rw [h, intervalIntegral.integral_ofReal]
  push_cast
  ring

/-- One zero's part of the count: the passage applied to `t^ρ/ρ`. -/
def piMode (ρ : ℂ) (x : ℝ) : ℂ := tr (fun t => (t : ℂ) ^ ρ / ρ) x

/-- The remainder of the explicit formula at a height. -/
def efRem (T : ℝ) (t : ℝ) : ℂ := ((ψ t : ℝ) : ℂ) - (t : ℂ) + Stage3.zeroPartialSum t T

/-- The prime powers above the first: `ψ − θ`. -/
def psiTheta (t : ℝ) : ℂ := ((ψ t - θ t : ℝ) : ℂ)

/-- The zero sum below a height, written as a sum over the finite set of zeros below it. -/
theorem zeroPartialSum_eq_sum (t T : ℝ) :
    Stage3.zeroPartialSum t T
      = ∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ)) := by
  unfold Stage3.zeroPartialSum
  exact tsum_sub_eq_sum T
    (fun ρ : NontrivialZeros => ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)
      * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ)))

/-- A monotone real function, read as complex, is integrable on `[2, x]`. -/
theorem integrable_ofReal_of_monotone {f : ℝ → ℝ} (hf : Monotone f) (x : ℝ) :
    IntervalIntegrable (fun t => ((f t : ℝ) : ℂ)) volume 2 x := by
  have h : IntervalIntegrable f volume 2 x := (hf.monotoneOn _).intervalIntegrable
  exact ⟨h.1.ofReal, h.2.ofReal⟩

/-- For `x ≥ 2` the function `t ↦ t^ρ/ρ` is integrable on `[2, x]`. -/
theorem integrable_cpow {x : ℝ} (hx : 2 ≤ x) (ρ : ℂ) :
    IntervalIntegrable (fun t : ℝ => (t : ℂ) ^ ρ / ρ) volume 2 x := by
  apply ContinuousOn.intervalIntegrable
  rw [Set.uIcc_of_le hx]
  intro t ht
  have ht0 : t ≠ 0 := by linarith [ht.1]
  exact ((Complex.continuousAt_ofReal_cpow_const t ρ (Or.inr ht0)).div_const ρ).continuousWithinAt

/-- **The count as a sum over the zeros, exactly.** For every `x ≥ 2` and every
height `T`: the count minus its smooth part is minus the sum over the zeros
below `T` of each zero's part, plus the passage of the explicit formula's
remainder, minus the passage of the higher prime powers. -/
theorem pi_eq_zero_sum {x : ℝ} (hx : 2 ≤ x) (T : ℝ) :
    (((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x : ℝ) : ℂ)
      = -∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
        + tr (efRem T) x - tr psiTheta x := by
  have hψ := integrable_ofReal_of_monotone psi_mono x
  have hθ := integrable_ofReal_of_monotone theta_mono x
  have hid : IntervalIntegrable (fun t : ℝ => (t : ℂ)) volume 2 x :=
    Complex.continuous_ofReal.intervalIntegrable 2 x
  have hZi : ∀ ρ ∈ ZF T, IntervalIntegrable
      (fun t : ℝ => ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ)))
      volume 2 x := fun ρ _ => (integrable_cpow hx (ρ : ℂ)).const_mul _
  have hZ : IntervalIntegrable (fun t : ℝ => ∑ ρ ∈ ZF T,
      ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ))) volume 2 x :=
by
    have e : (fun t : ℝ => ∑ ρ ∈ ZF T,
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ)))
        = ∑ ρ ∈ ZF T, fun t : ℝ =>
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ)) := by
      funext t
      rw [Finset.sum_apply]
    rw [e]
    exact IntervalIntegrable.sum (ZF T) hZi
  have hR : IntervalIntegrable (efRem T) volume 2 x := by
    have h := (hψ.sub hid).add hZ
    refine h.congr ?_
    intro t _
    show ((ψ t : ℝ) : ℂ) - (t : ℂ) + _ = efRem T t
    unfold efRem
    rw [zeroPartialSum_eq_sum]
  have hPT : IntervalIntegrable psiTheta volume 2 x := by
    have h := hψ.sub hθ
    refine h.congr ?_
    intro t _
    show ((ψ t : ℝ) : ℂ) - ((θ t : ℝ) : ℂ) = psiTheta t
    unfold psiTheta
    push_cast
    ring
  have hfun : (fun t : ℝ => ((θ t - t : ℝ) : ℂ))
      = fun t : ℝ => (efRem T t - ∑ ρ ∈ ZF T,
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ))) - psiTheta t := by
    funext t
    unfold efRem psiTheta
    rw [zeroPartialSum_eq_sum]
    push_cast
    ring
  rw [pi_sub_Li_eq_tr hx, hfun, tr_sub hx (hR.sub hZ) hPT, tr_sub hx hR hZ, tr_sum _ _ hx hZi]
  have hm : ∀ ρ ∈ ZF T, tr (fun t : ℝ => ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)
        * ((t : ℂ) ^ (ρ : ℂ) / (ρ : ℂ))) x
      = ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x :=
    fun ρ _ => tr_const_mul _ _ x
  rw [Finset.sum_congr rfl hm]
  ring

/-- **The higher prime powers are of square-root size.** -/
theorem norm_tr_psiTheta_le {x : ℝ} (hx : 2 ≤ x) : ‖tr psiTheta x‖ ≤ 8 * Real.sqrt x := by
  unfold tr
  have hlogx : 0 < Real.log x := Real.log_pos (by linarith)
  have hl2 : (0.69:ℝ) < Real.log 2 := by
    have := Real.log_two_gt_d9
    linarith
  have h1 : ‖psiTheta x / (Real.log x : ℂ)‖ ≤ 2 * Real.sqrt x := by
    unfold psiTheta
    rw [norm_div, Complex.norm_real, Complex.norm_real, Real.norm_eq_abs, Real.norm_eq_abs,
      abs_of_pos hlogx, div_le_iff₀ hlogx]
    exact abs_psi_sub_theta_le_sqrt_mul_log (by linarith)
  have h2 : ‖∫ t in (2:ℝ)..x, psiTheta t * wt t‖
      ≤ ∫ t in (2:ℝ)..x, (2 / Real.log 2) * t ^ (-(1:ℝ) / 2) := by
    refine intervalIntegral.norm_integral_le_of_norm_le hx ?_ ?_
    · filter_upwards with t ht
      have h2t : (2:ℝ) ≤ t := ht.1.le
      have ht0 : 0 < t := by linarith
      have hlt : 0 < Real.log t := Real.log_pos (by linarith)
      have hl2t : Real.log 2 ≤ Real.log t := Real.log_le_log (by norm_num) h2t
      have hpos : 0 < (t * Real.log t ^ 2)⁻¹ := by positivity
      unfold psiTheta wt
      rw [norm_mul, Complex.norm_real, Complex.norm_real, Real.norm_eq_abs, Real.norm_eq_abs,
        abs_of_pos hpos]
      have hb := abs_psi_sub_theta_le_sqrt_mul_log (x := t) (by linarith)
      have hs : 0 < Real.sqrt t := Real.sqrt_pos.mpr ht0
      have hss : Real.sqrt t * Real.sqrt t = t := Real.mul_self_sqrt ht0.le
      have hsq : t ^ (-(1:ℝ) / 2) = (Real.sqrt t)⁻¹ := by
        rw [Real.sqrt_eq_rpow, ← Real.rpow_neg ht0.le]
        congr 1
        ring
      rw [hsq]
      have hden : t * Real.log t ^ 2 = (Real.sqrt t * Real.log t) * (Real.sqrt t * Real.log t) := by
        calc t * Real.log t ^ 2 = (Real.sqrt t * Real.sqrt t) * Real.log t ^ 2 := by rw [hss]
          _ = _ := by ring
      have e : (2 * Real.sqrt t * Real.log t) * (t * Real.log t ^ 2)⁻¹
          = 2 / Real.log t * (Real.sqrt t)⁻¹ := by
        rw [hden]
        field_simp
      calc |ψ t - θ t| * (t * Real.log t ^ 2)⁻¹
          ≤ (2 * Real.sqrt t * Real.log t) * (t * Real.log t ^ 2)⁻¹ :=
            mul_le_mul_of_nonneg_right hb hpos.le
        _ = 2 / Real.log t * (Real.sqrt t)⁻¹ := e
        _ ≤ 2 / Real.log 2 * (Real.sqrt t)⁻¹ := by
            apply mul_le_mul_of_nonneg_right _ (by positivity)
            exact div_le_div_of_nonneg_left (by norm_num) (by linarith) hl2t
    · have h0 : (0:ℝ) ∉ Set.uIcc 2 x := by
        rw [Set.uIcc_of_le hx]
        rintro ⟨h, _⟩
        linarith
      exact (intervalIntegral.intervalIntegrable_rpow (Or.inr h0)).const_mul _
  have h3 := Stage3.integral_A_rpow_le (a := 2) (x := x) (A := 2 / Real.log 2)
    (by norm_num) hx (by positivity)
  have h4 : 2 * (2 / Real.log 2) ≤ 6 := by
    rw [← mul_div_assoc, div_le_iff₀ (by linarith)]
    linarith
  have hsx := Real.sqrt_nonneg x
  calc ‖psiTheta x / (Real.log x : ℂ) + ∫ t in (2:ℝ)..x, psiTheta t * wt t‖
      ≤ ‖psiTheta x / (Real.log x : ℂ)‖ + ‖∫ t in (2:ℝ)..x, psiTheta t * wt t‖ := norm_add_le _ _
    _ ≤ 2 * Real.sqrt x + 2 * (2 / Real.log 2) * Real.sqrt x := by linarith
    _ ≤ 8 * Real.sqrt x := by nlinarith

/-- Two rows that agree on the entries a stencil reads have the same stencil. -/
theorem stencil_congr (n : ℕ) {a b : ℤ → ℂ} {r : ℤ}
    (h : ∀ j ∈ range (n + 1), a (r - j) = b (r - j)) :
    CellZeros.stencil n a r = CellZeros.stencil n b r := by
  unfold CellZeros.stencil
  exact Finset.sum_congr rfl fun j hj => by rw [h j hj]

/-- The stencil of the negative of a row is the negative of its stencil. -/
theorem stencil_neg (n : ℕ) (a : ℤ → ℂ) (r : ℤ) :
    CellZeros.stencil n (fun m => -a m) r = -CellZeros.stencil n a r := by
  have h := CellZeros.stencil_const_mul n (-1) a r
  simpa using h

/-- The real stencil of a row, read as complex, is the complex stencil of the row read as complex. -/
theorem stencilR_cast (n : ℕ) (g : ℤ → ℝ) (r : ℤ) :
    ((Nonvanishing.stencilR n g r : ℝ) : ℂ)
      = CellZeros.stencil n (fun m => ((g m : ℝ) : ℂ)) r := by
  unfold Nonvanishing.stencilR CellZeros.stencil
  push_cast
  rfl

/-- **The integer table's cell as a sum over the zeros, exactly.** The cell
`(r, d)` of the table of the prime count along the doublings, less the smooth
cell, is minus the sum over the zeros below any height of each zero's part
under the stencil, plus the stencil of the explicit formula's remainder passed
to the count, minus the stencil of the higher prime powers. -/
theorem table_cell_eq_zero_sum (r : ℤ) (d : ℕ) (hr : (d : ℤ) + 2 ≤ r) (T : ℝ) :
    ((((Construction.tableFrom TableRoute.rowN r d : ℤ) : ℝ)
        - Nonvanishing.stencilR (d + 1) (fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) r : ℝ) : ℂ)
      = -∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)
            * CellZeros.stencil (d + 1) (fun m : ℤ => piMode (ρ : ℂ) ((2:ℝ) ^ (m : ℝ))) r
        + CellZeros.stencil (d + 1) (fun m : ℤ => tr (efRem T) ((2:ℝ) ^ (m : ℝ))) r
        - CellZeros.stencil (d + 1) (fun m : ℤ => tr psiTheta ((2:ℝ) ^ (m : ℝ))) r := by
  rw [CellResidual.table_cell_eq r d]
  unfold CellResidual.cellResid
  rw [stencilR_cast]
  have hpt : ∀ j ∈ range (d + 1 + 1),
      (fun m : ℤ => ((CellResidual.resid 1 m : ℝ) : ℂ)) (r - j)
        = (fun m : ℤ => -(∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)
              * piMode (ρ : ℂ) ((2:ℝ) ^ (m : ℝ)))
            + tr (efRem T) ((2:ℝ) ^ (m : ℝ)) - tr psiTheta ((2:ℝ) ^ (m : ℝ))) (r - j) := by
    intro j hj
    have hj' : j ≤ d + 1 := Nat.lt_succ_iff.mp (mem_range.mp hj)
    have h2 : (2:ℝ) ≤ (2:ℝ) ^ (((r - (j : ℤ) : ℤ)) : ℝ) := by
      have h1 : (1:ℝ) ≤ ((r - (j : ℤ) : ℤ) : ℝ) := by
        exact_mod_cast (by omega : (1:ℤ) ≤ r - j)
      calc (2:ℝ) = 2 ^ (1:ℝ) := (Real.rpow_one 2).symm
        _ ≤ _ := Real.rpow_le_rpow_of_exponent_le (by norm_num) h1
    show ((CellResidual.resid 1 (r - j) : ℝ) : ℂ) = _
    unfold CellResidual.resid
    rw [one_mul]
    exact pi_eq_zero_sum h2 T
  have hc := stencil_congr (d + 1) (r := r)
    (a := fun m : ℤ => ((CellResidual.resid 1 m : ℝ) : ℂ))
    (b := fun m : ℤ => -(∑ ρ ∈ ZF T, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)
              * piMode (ρ : ℂ) ((2:ℝ) ^ (m : ℝ)))
            + tr (efRem T) ((2:ℝ) ^ (m : ℝ)) - tr psiTheta ((2:ℝ) ^ (m : ℝ))) hpt
  rw [hc, CellZeros.stencil_sub, CellZeros.stencil_add, stencil_neg, CellZeros.stencil_sum]
  simp only [CellZeros.stencil_const_mul]

end

/-- info: 'PiZeros.pi_eq_zero_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms pi_eq_zero_sum

/-- info: 'PiZeros.norm_tr_psiTheta_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_tr_psiTheta_le

/-- info: 'PiZeros.table_cell_eq_zero_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms table_cell_eq_zero_sum

end PiZeros
