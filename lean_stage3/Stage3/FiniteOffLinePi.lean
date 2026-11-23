/-
FiniteOffLinePi — block J10e of `lean_stage3/design/joints.md`. 2026-11-23.

The one-ladder converse for the count of primes, in the case of finitely many
zeros off the line. Let a finite set hold every zero of ζ off the line. If the
count of primes at the doublings `2^r` stays within `C·r²·√2^r` of `Li`, then
no zero is off the line.

The proof follows `FiniteOffLine.finite_off_line`. Put `x = 2^r` and take the
height `x`. `PiZeros.pi_eq_zero_sum` writes `π − Li` as minus the sum over the
zeros below `x` of each zero's part `piMode ρ x`, plus two remainders of
square-root size (`PiRemainder.norm_tr_efRem_le_of`, `norm_tr_psiTheta_le`).
One zero's part is `x^ρ/(ρ·log x)` plus an integral; split at `√x`, the
integral is at most `(3√x + 4x^b/(b·log²x))/|ρ|`, where `b` is the real part.
So each zero on the line contributes at most `12√x/|ρ|`, and all of them at
most a constant times `√x·log²x` (`zinv_le_log`). Multiply by `log x = r·log 2`:
the zeros with the largest real part `β` give `Σ m(ρ)/ρ·(2^ρ)^r` plus
`o(2^(rβ))`, and everything else is `o(2^(rβ))`. That top line cannot fade
(`LadderFading.line_not_fading`).

  ipart, piMode_eq        the integral in one zero's part, and the part split
  norm_integrand          the size of the integrand
  norm_ipart_le           0 < b ≤ 1, 4 ≤ x ⊢ ‖ipart ρ x‖ ≤ (3√x + 4x^b/(b·log²x))/|ρ|
  norm_piMode_le          0 < b ≤ 1, 4 ≤ x ⊢ ‖piMode ρ x‖ ≤ ((1 + 4/b)·x^b + 3√x)/|ρ|
  norm_piMode_half        b = 1/2, 4 ≤ x ⊢ ‖piMode ρ x‖ ≤ 12√x/|ρ|
  sqrt_doubling, rpow_doubling, cpow_doubling   √, ^b and ^ρ at 2^r
  ordR, norm_order_mul    the order of a zero as a real, and its size as a factor
  rowBound, rowBound_isLittleO   the row's bound, and it is o((2^β)^r)
  row_bound               8 ≤ r, F below 2^r, the row within C·r²·√2^r
                            ⊢ ‖Σ_{ρ∈S} m(ρ)·(2^ρ)^r/ρ‖ ≤ rowBound
  finite_off_line_pi      F finite ⊇ the zeros off the line, π − Li at the
                            doublings within C·r²·√2^r ⊢ RiemannHypothesis

What the next slice needs: the same with infinitely many zeros off the line.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.PiRemainder
import Stage3.LadderFading
import Stage3.CellModes
import Stage3.LandauWindow

namespace FiniteOffLinePi

open Finset Filter Topology Kadiri FiniteOffLine PiZeros PiRemainder MeasureTheory

noncomputable section

/-- The integral in one zero's part of the count. -/
def ipart (ρ : ℂ) (x : ℝ) : ℂ := ∫ t in (2:ℝ)..x, (t : ℂ) ^ ρ / ρ * wt t

/-- One zero's part of the count is `x^ρ/ρ` over `log x`, plus the integral. -/
theorem piMode_eq (ρ : ℂ) (x : ℝ) :
    piMode ρ x = (x : ℂ) ^ ρ / ρ / (Real.log x : ℂ) + ipart ρ x := rfl

/-- For `t ≥ 2` the integrand has size `t^b/(|ρ|·t·log²t)`, with `b` the real part. -/
theorem norm_integrand (ρ : ℂ) {t : ℝ} (ht : 2 ≤ t) :
    ‖(t : ℂ) ^ ρ / ρ * wt t‖ = ‖ρ‖⁻¹ * (t ^ ρ.re * (t * Real.log t ^ 2)⁻¹) := by
  have ht0 : 0 < t := by linarith
  have hlt : 0 < Real.log t := Real.log_pos (by linarith)
  have hpos : 0 < t * Real.log t ^ 2 := by positivity
  unfold wt
  rw [norm_mul, norm_div, Complex.norm_cpow_eq_rpow_re_of_pos ht0, Complex.norm_real,
    Real.norm_eq_abs, abs_of_pos (inv_pos.mpr hpos), div_eq_mul_inv]
  ring

/-- **The integral in one zero's part.** For a real part `b` in `(0, 1]` and
`x ≥ 4`, the integral is at most `(3√x + 4x^b/(b·log²x))/|ρ|`. -/
theorem norm_ipart_le {ρ : ℂ} (hb0 : 0 < ρ.re) (hb1 : ρ.re ≤ 1) {x : ℝ} (hx : 4 ≤ x) :
    ‖ipart ρ x‖
      ≤ ‖ρ‖⁻¹ * (3 * Real.sqrt x + 4 * x ^ ρ.re / (ρ.re * Real.log x ^ 2)) := by
  have hx2 : (2:ℝ) ≤ x := by linarith
  have hx0 : 0 < x := by linarith
  have hl2 : (0.69 : ℝ) < Real.log 2 := by
    have := Real.log_two_gt_d9
    linarith
  have hL1 : 1 ≤ Real.log x := by
    have h4 : Real.log 4 = 2 * Real.log 2 := by
      rw [show (4:ℝ) = 2 ^ 2 by norm_num, Real.log_pow]
      push_cast
      ring
    have := Real.log_le_log (by norm_num : (0:ℝ) < 4) hx
    linarith
  have hLpos : 0 < Real.log x := by linarith
  have hs2 : (2 : ℝ) ≤ Real.sqrt x := by
    have e : (2 : ℝ) = Real.sqrt 4 := by
      rw [show (4:ℝ) = 2 ^ 2 by norm_num, Real.sqrt_sq (by norm_num)]
    rw [e]
    exact Real.sqrt_le_sqrt hx
  have hspos : 0 < Real.sqrt x := by linarith
  have hss : Real.sqrt x * Real.sqrt x = x := Real.mul_self_sqrt hx0.le
  have hsx : Real.sqrt x ≤ x := by nlinarith
  have hlogs : Real.log (Real.sqrt x) = Real.log x / 2 := Real.log_sqrt hx0.le
  have hn0 : 0 ≤ ‖ρ‖⁻¹ := by positivity
  have hI := integrable_mul_wt hx2 (integrable_cpow hx2 ρ)
  have hmem : Real.sqrt x ∈ Set.uIcc (2 : ℝ) x := Set.mem_uIcc.mpr (Or.inl ⟨hs2, hsx⟩)
  have hI1 := hI.mono_set (Set.uIcc_subset_uIcc Set.left_mem_uIcc hmem)
  have hI2 := hI.mono_set (Set.uIcc_subset_uIcc hmem Set.right_mem_uIcc)
  have hsplit := intervalIntegral.integral_add_adjacent_intervals hI1 hI2
  unfold ipart
  rw [← hsplit]
  -- the low piece
  have hlow : ‖∫ t in (2:ℝ)..Real.sqrt x, (t : ℂ) ^ ρ / ρ * wt t‖
      ≤ ‖ρ‖⁻¹ * (3 * Real.sqrt x) := by
    have hc := intervalIntegral.norm_integral_le_of_norm_le_const (a := 2) (b := Real.sqrt x)
      (C := ‖ρ‖⁻¹ * 3) (f := fun t => (t : ℂ) ^ ρ / ρ * wt t) (by
        intro t ht
        rw [Set.uIoc_of_le hs2] at ht
        have h2t : (2:ℝ) ≤ t := ht.1.le
        have ht0 : 0 < t := by linarith
        have hlt : Real.log 2 ≤ Real.log t := Real.log_le_log (by norm_num) h2t
        have hltpos : 0 < Real.log t := by linarith
        have hinv : (Real.log t ^ 2)⁻¹ ≤ 3 := by
          rw [inv_le_comm₀ (by positivity) (by norm_num)]
          nlinarith
        have htb : t ^ ρ.re ≤ t := by
          calc t ^ ρ.re ≤ t ^ (1:ℝ) := Real.rpow_le_rpow_of_exponent_le (by linarith) hb1
            _ = t := Real.rpow_one t
        rw [norm_integrand ρ h2t]
        apply mul_le_mul_of_nonneg_left _ hn0
        calc t ^ ρ.re * (t * Real.log t ^ 2)⁻¹ ≤ t * (t * Real.log t ^ 2)⁻¹ :=
              mul_le_mul_of_nonneg_right htb (by positivity)
          _ = (Real.log t ^ 2)⁻¹ := by
              rw [mul_inv, ← mul_assoc, mul_inv_cancel₀ ht0.ne', one_mul]
          _ ≤ 3 := hinv)
    have habs : |Real.sqrt x - 2| ≤ Real.sqrt x := by
      rw [abs_of_nonneg (by linarith)]
      linarith
    calc _ ≤ ‖ρ‖⁻¹ * 3 * |Real.sqrt x - 2| := hc
      _ ≤ ‖ρ‖⁻¹ * 3 * Real.sqrt x := mul_le_mul_of_nonneg_left habs (by positivity)
      _ = ‖ρ‖⁻¹ * (3 * Real.sqrt x) := by ring
  -- the high piece
  have hhigh : ‖∫ t in Real.sqrt x..x, (t : ℂ) ^ ρ / ρ * wt t‖
      ≤ ‖ρ‖⁻¹ * (4 * x ^ ρ.re / (ρ.re * Real.log x ^ 2)) := by
    have h0 : (0:ℝ) ∉ Set.uIcc (Real.sqrt x) x := by
      rw [Set.uIcc_of_le hsx]
      rintro ⟨h, _⟩
      linarith
    have hg : IntervalIntegrable
        (fun t : ℝ => (‖ρ‖⁻¹ * (4 / Real.log x ^ 2)) * t ^ (ρ.re - 1))
        volume (Real.sqrt x) x :=
      (intervalIntegral.intervalIntegrable_rpow (Or.inr h0)).const_mul _
    have hpt : ∀ᵐ t ∂volume, t ∈ Set.Ioc (Real.sqrt x) x →
        ‖(t : ℂ) ^ ρ / ρ * wt t‖ ≤ (‖ρ‖⁻¹ * (4 / Real.log x ^ 2)) * t ^ (ρ.re - 1) := by
      filter_upwards with t ht
      have hst : Real.sqrt x ≤ t := ht.1.le
      have ht0 : 0 < t := by linarith
      have h2t : (2:ℝ) ≤ t := by linarith
      have hlt : Real.log x / 2 ≤ Real.log t := by
        rw [← hlogs]
        exact Real.log_le_log hspos hst
      have hinv : (Real.log t ^ 2)⁻¹ ≤ 4 / Real.log x ^ 2 := by
        have h1 : (Real.log x / 2) ^ 2 ≤ Real.log t ^ 2 :=
          pow_le_pow_left₀ (by linarith) hlt 2
        have h2 := inv_anti₀ (by positivity) h1
        calc (Real.log t ^ 2)⁻¹ ≤ ((Real.log x / 2) ^ 2)⁻¹ := h2
          _ = 4 / Real.log x ^ 2 := by rw [div_pow, inv_div]; norm_num
      have hrp : t ^ (ρ.re - 1) = t ^ ρ.re / t := Real.rpow_sub_one ht0.ne' _
      rw [norm_integrand ρ h2t, hrp]
      have e : t ^ ρ.re * (t * Real.log t ^ 2)⁻¹ = t ^ ρ.re / t * (Real.log t ^ 2)⁻¹ := by
        rw [mul_inv, div_eq_mul_inv]
        ring
      rw [e]
      have hq : 0 ≤ t ^ ρ.re / t := by positivity
      calc ‖ρ‖⁻¹ * (t ^ ρ.re / t * (Real.log t ^ 2)⁻¹)
          ≤ ‖ρ‖⁻¹ * (t ^ ρ.re / t * (4 / Real.log x ^ 2)) :=
            mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left hinv hq) hn0
        _ = ‖ρ‖⁻¹ * (4 / Real.log x ^ 2) * (t ^ ρ.re / t) := by ring
    have hc := intervalIntegral.norm_integral_le_of_norm_le hsx hpt hg
    refine hc.trans ?_
    rw [intervalIntegral.integral_const_mul, integral_rpow (Or.inl (by linarith)),
      sub_add_cancel]
    have hsb : 0 ≤ Real.sqrt x ^ ρ.re := Real.rpow_nonneg hspos.le _
    have h1 : (x ^ ρ.re - Real.sqrt x ^ ρ.re) / ρ.re ≤ x ^ ρ.re / ρ.re :=
      div_le_div_of_nonneg_right (by linarith) hb0.le
    calc ‖ρ‖⁻¹ * (4 / Real.log x ^ 2) * ((x ^ ρ.re - Real.sqrt x ^ ρ.re) / ρ.re)
        ≤ ‖ρ‖⁻¹ * (4 / Real.log x ^ 2) * (x ^ ρ.re / ρ.re) :=
          mul_le_mul_of_nonneg_left h1 (by positivity)
      _ = ‖ρ‖⁻¹ * (4 * x ^ ρ.re / (ρ.re * Real.log x ^ 2)) := by ring
  have hn := norm_add_le (∫ t in (2:ℝ)..Real.sqrt x, (t : ℂ) ^ ρ / ρ * wt t)
    (∫ t in Real.sqrt x..x, (t : ℂ) ^ ρ / ρ * wt t)
  rw [mul_add]
  linarith

/-- **One zero's part of the count.** For a real part `b` in `(0, 1]` and `x ≥ 4`,
the part is at most `((1 + 4/b)·x^b + 3√x)/|ρ|`. -/
theorem norm_piMode_le {ρ : ℂ} (hb0 : 0 < ρ.re) (hb1 : ρ.re ≤ 1) {x : ℝ} (hx : 4 ≤ x) :
    ‖piMode ρ x‖ ≤ ‖ρ‖⁻¹ * ((1 + 4 / ρ.re) * x ^ ρ.re + 3 * Real.sqrt x) := by
  have hx0 : 0 < x := by linarith
  have hl2 : (0.69 : ℝ) < Real.log 2 := by
    have := Real.log_two_gt_d9
    linarith
  have hL1 : 1 ≤ Real.log x := by
    have h4 : Real.log 4 = 2 * Real.log 2 := by
      rw [show (4:ℝ) = 2 ^ 2 by norm_num, Real.log_pow]
      push_cast
      ring
    have := Real.log_le_log (by norm_num : (0:ℝ) < 4) hx
    linarith
  have hLpos : 0 < Real.log x := by linarith
  have hn0 : 0 ≤ ‖ρ‖⁻¹ := by positivity
  have hxb : 0 ≤ x ^ ρ.re := Real.rpow_nonneg hx0.le _
  have hmain : ‖(x : ℂ) ^ ρ / ρ / (Real.log x : ℂ)‖ ≤ ‖ρ‖⁻¹ * x ^ ρ.re := by
    rw [norm_div, norm_div, Complex.norm_cpow_eq_rpow_re_of_pos hx0, Complex.norm_real,
      Real.norm_eq_abs, abs_of_pos hLpos, div_le_iff₀ hLpos]
    calc x ^ ρ.re / ‖ρ‖ = ‖ρ‖⁻¹ * x ^ ρ.re * 1 := by ring
      _ ≤ ‖ρ‖⁻¹ * x ^ ρ.re * Real.log x :=
          mul_le_mul_of_nonneg_left hL1 (by positivity)
  have hint := norm_ipart_le hb0 hb1 hx
  have hL2 : 1 ≤ Real.log x ^ 2 := by nlinarith
  have h4 : 4 * x ^ ρ.re / (ρ.re * Real.log x ^ 2) ≤ 4 * x ^ ρ.re / ρ.re :=
    div_le_div_of_nonneg_left (by positivity) hb0 (le_mul_of_one_le_right hb0.le hL2)
  have h5 : ‖ρ‖⁻¹ * (3 * Real.sqrt x + 4 * x ^ ρ.re / (ρ.re * Real.log x ^ 2))
      ≤ ‖ρ‖⁻¹ * (3 * Real.sqrt x + 4 * x ^ ρ.re / ρ.re) :=
    mul_le_mul_of_nonneg_left (by linarith) hn0
  rw [piMode_eq]
  have e : ‖ρ‖⁻¹ * ((1 + 4 / ρ.re) * x ^ ρ.re + 3 * Real.sqrt x)
      = ‖ρ‖⁻¹ * x ^ ρ.re + ‖ρ‖⁻¹ * (3 * Real.sqrt x + 4 * x ^ ρ.re / ρ.re) := by ring
  rw [e]
  linarith [norm_add_le ((x : ℂ) ^ ρ / ρ / (Real.log x : ℂ)) (ipart ρ x)]

/-- **One zero on the line.** For real part `1/2` and `x ≥ 4`, the zero's part of
the count is at most `12√x/|ρ|`. -/
theorem norm_piMode_half {ρ : ℂ} (hre : ρ.re = 1 / 2) {x : ℝ} (hx : 4 ≤ x) :
    ‖piMode ρ x‖ ≤ ‖ρ‖⁻¹ * (12 * Real.sqrt x) := by
  have h := norm_piMode_le (ρ := ρ) (by rw [hre]; norm_num) (by rw [hre]; norm_num) hx
  rw [hre, ← Real.sqrt_eq_rpow] at h
  calc _ ≤ _ := h
    _ = ‖ρ‖⁻¹ * (12 * Real.sqrt x) := by ring

/-- The square root of `2^r` is `√2^r`. -/
theorem sqrt_doubling (r : ℕ) : Real.sqrt ((2:ℝ) ^ r) = Real.sqrt 2 ^ r := by
  have h : (2:ℝ) ^ r = (Real.sqrt 2 ^ r) ^ 2 := by
    rw [← pow_mul, mul_comm, pow_mul, Real.sq_sqrt (by norm_num)]
  rw [h, Real.sqrt_sq (by positivity)]

/-- The real power `b` of `2^r` is `(2^b)^r`. -/
theorem rpow_doubling (r : ℕ) (b : ℝ) : ((2:ℝ) ^ r) ^ b = ((2:ℝ) ^ b) ^ r := by
  rw [← Real.rpow_natCast (2:ℝ) r, ← Real.rpow_natCast ((2:ℝ) ^ b) r,
    ← Real.rpow_mul (by norm_num : (0:ℝ) ≤ 2), ← Real.rpow_mul (by norm_num : (0:ℝ) ≤ 2),
    mul_comm]

/-- The complex power `ρ` of `2^r` is `(2^ρ)^r`. -/
theorem cpow_doubling (r : ℕ) (ρ : ℂ) : (((2:ℝ) ^ r : ℝ) : ℂ) ^ ρ = ((2:ℂ) ^ ρ) ^ r := by
  have h := CellZeros.cpow_two_zpow (r : ℤ) ρ
  rw [zpow_natCast, zpow_natCast] at h
  exact h

/-- The order of a zero, as a real number. -/
def ordR (ρ : NontrivialZeros) : ℝ := ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ)

/-- The order of a zero is nonnegative. -/
theorem ordR_nonneg (ρ : NontrivialZeros) : 0 ≤ ordR ρ := order_nonneg ρ

/-- The order of a zero, as a factor, multiplies the size by the order. -/
theorem norm_order_mul (ρ : NontrivialZeros) (w : ℂ) :
    ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * w‖ = ordR ρ * ‖w‖ := by
  unfold ordR
  rw [norm_mul, Complex.norm_intCast, abs_of_nonneg (order_nonneg ρ)]

/-- The bound on the top line's sum at row `r`. -/
def rowBound (F S : Finset NontrivialZeros) (β C : ℝ) (r : ℕ) : ℝ :=
  (C * Real.log 2 + Arem + 8 + 12 * (Mlow * 39000)) * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r)
  + ∑ ρ ∈ F \ S, ((ordR ρ * ‖(ρ : ℂ)‖⁻¹ * (1 + 4 / (ρ : ℂ).re))
        * ((r : ℝ) ^ 3 * ((2:ℝ) ^ (ρ : ℂ).re) ^ r)
      + (3 * (ordR ρ * ‖(ρ : ℂ)‖⁻¹)) * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r))
  + ∑ ρ ∈ S, ((3 * (ordR ρ * ‖(ρ : ℂ)‖⁻¹)) * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r)
      + (4 * (ordR ρ * ‖(ρ : ℂ)‖⁻¹) / (β * Real.log 2)) * ((r : ℝ)⁻¹ * ((2:ℝ) ^ β) ^ r))

/-- **The row's bound is small against the top line.** If `β > 1/2` and every
zero of `F \ S` has real part below `β`, the bound is `o((2^β)^r)`. -/
theorem rowBound_isLittleO (F S : Finset NontrivialZeros) {β : ℝ} (hβ : 1 / 2 < β)
    (hlt : ∀ ρ ∈ F \ S, (ρ : ℂ).re < β) (C : ℝ) :
    (fun r : ℕ => rowBound F S β C r) =o[atTop] fun r : ℕ => ((2:ℝ) ^ β) ^ r := by
  have hsq : Real.sqrt 2 < (2:ℝ) ^ β := by
    rw [Real.sqrt_eq_rpow]
    exact Real.rpow_lt_rpow_of_exponent_lt (by norm_num) hβ
  have h3 : (fun r : ℕ => (r : ℝ) ^ 3 * Real.sqrt 2 ^ r) =o[atTop]
      fun r : ℕ => ((2:ℝ) ^ β) ^ r :=
    isLittleO_pow_const_mul_const_pow_const_pow_of_norm_lt 3
      (by rw [Real.norm_of_nonneg (Real.sqrt_nonneg 2)]; exact hsq)
  have hinv : (fun r : ℕ => (r : ℝ)⁻¹ * ((2:ℝ) ^ β) ^ r) =o[atTop]
      fun r : ℕ => ((2:ℝ) ^ β) ^ r := by
    have h1 : (fun r : ℕ => (r : ℝ)⁻¹) =o[atTop] fun _ : ℕ => (1:ℝ) :=
      (Asymptotics.isLittleO_one_iff ℝ).mpr (tendsto_inv_atTop_nhds_zero_nat (𝕜 := ℝ))
    have h2 := h1.mul_isBigO (Asymptotics.isBigO_refl (fun r : ℕ => ((2:ℝ) ^ β) ^ r) atTop)
    exact h2.congr_right (fun r => one_mul _)
  have hoff : ∀ ρ ∈ F \ S, (fun r : ℕ => (ordR ρ * ‖(ρ : ℂ)‖⁻¹ * (1 + 4 / (ρ : ℂ).re))
        * ((r : ℝ) ^ 3 * ((2:ℝ) ^ (ρ : ℂ).re) ^ r)
      + (3 * (ordR ρ * ‖(ρ : ℂ)‖⁻¹)) * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r)) =o[atTop]
      fun r : ℕ => ((2:ℝ) ^ β) ^ r := by
    intro ρ hρ
    have hb : (fun r : ℕ => (r : ℝ) ^ 3 * ((2:ℝ) ^ (ρ : ℂ).re) ^ r) =o[atTop]
        fun r : ℕ => ((2:ℝ) ^ β) ^ r :=
      isLittleO_pow_const_mul_const_pow_const_pow_of_norm_lt 3
        (by
          rw [Real.norm_of_nonneg (by positivity)]
          exact Real.rpow_lt_rpow_of_exponent_lt (by norm_num) (hlt ρ hρ))
    exact (hb.const_mul_left _).add (h3.const_mul_left _)
  have hS : ∀ ρ ∈ S, (fun r : ℕ => (3 * (ordR ρ * ‖(ρ : ℂ)‖⁻¹)) * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r)
      + (4 * (ordR ρ * ‖(ρ : ℂ)‖⁻¹) / (β * Real.log 2)) * ((r : ℝ)⁻¹ * ((2:ℝ) ^ β) ^ r))
      =o[atTop] fun r : ℕ => ((2:ℝ) ^ β) ^ r :=
    fun ρ _ => (h3.const_mul_left _).add (hinv.const_mul_left _)
  unfold rowBound
  exact ((h3.const_mul_left _).add (Asymptotics.IsLittleO.sum hoff)).add
    (Asymptotics.IsLittleO.sum hS)

/-- **The top line's sum at one row.** Let `S ⊆ F` have real part `β`, let `F`
hold every zero off the line and lie below `2^r`, with `r ≥ 8`. If the count of
primes at `2^r` is within `C·r²·√2^r` of `Li`, the sum `Σ_{ρ∈S} m(ρ)·(2^ρ)^r/ρ`
is at most `rowBound F S β C r`. -/
theorem row_bound (F S : Finset NontrivialZeros) (hSF : S ⊆ F) {β : ℝ}
    (hSβ : ∀ ρ ∈ S, (ρ : ℂ).re = β)
    (hF : ∀ ρ : NontrivialZeros, (ρ : ℂ).re ≠ 1 / 2 → ρ ∈ F) (C : ℝ) {r : ℕ} (hr : 8 ≤ r)
    (hFr : F ⊆ ZF ((2:ℝ) ^ r))
    (hrow : |(Nat.primeCounting ⌊(2:ℝ) ^ r⌋₊ : ℝ) - Stage3.Li ((2:ℝ) ^ r)|
      ≤ C * (r : ℝ) ^ 2 * Real.sqrt 2 ^ r) :
    ‖∑ ρ ∈ S, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * (((2:ℂ) ^ (ρ : ℂ)) ^ r / (ρ : ℂ))‖
      ≤ rowBound F S β C r := by
  classical
  have hx256 : (256:ℝ) ≤ (2:ℝ) ^ r := by
    calc (256:ℝ) = 2 ^ 8 := by norm_num
      _ ≤ 2 ^ r := pow_le_pow_right₀ (by norm_num) hr
  obtain ⟨x, hxdef⟩ : ∃ x : ℝ, x = (2:ℝ) ^ r := ⟨_, rfl⟩
  rw [← hxdef] at hx256 hFr hrow
  have hx4 : (4:ℝ) ≤ x := by linarith
  have hx2 : (2:ℝ) ≤ x := by linarith
  have hl2 : (0.69 : ℝ) < Real.log 2 := by linarith [Real.log_two_gt_d9]
  have hl2' : Real.log 2 < 1 := by linarith [Real.log_two_lt_d9]
  have hr1 : (1 : ℝ) ≤ (r : ℝ) := by exact_mod_cast (by omega : 1 ≤ r)
  have hr0 : (0 : ℝ) < (r : ℝ) := by linarith
  have hL : Real.log x = (r : ℝ) * Real.log 2 := by rw [hxdef, Real.log_pow]
  have hsx : Real.sqrt x = Real.sqrt 2 ^ r := by rw [hxdef]; exact sqrt_doubling r
  have hxb : ∀ b : ℝ, x ^ b = ((2:ℝ) ^ b) ^ r := fun b => by
    rw [hxdef]; exact rpow_doubling r b
  have hxc : ∀ ρ : ℂ, (x : ℂ) ^ ρ = ((2:ℂ) ^ ρ) ^ r := fun ρ => by
    rw [hxdef]; exact cpow_doubling r ρ
  have hL0 : 0 ≤ Real.log x := by rw [hL]; positivity
  have hLr : Real.log x ≤ (r : ℝ) := by rw [hL]; nlinarith
  have hLne : (Real.log x : ℂ) ≠ 0 := by
    have : Real.log x ≠ 0 := by rw [hL]; positivity
    exact_mod_cast this
  have hs0 : 0 ≤ Real.sqrt 2 ^ r := by positivity
  have hr3 : (r : ℝ) ≤ (r : ℝ) ^ 3 := by nlinarith
  have hL3 : Real.log x ^ 3 ≤ (r : ℝ) ^ 3 := pow_le_pow_left₀ hL0 hLr 3
  have hLr3 : Real.log x ≤ (r : ℝ) ^ 3 := hLr.trans hr3
  have hM := two_le_Mlow
  -- the count as a sum over the zeros, split three ways
  have hid := pi_eq_zero_sum hx2 x
  have hsplit : ∑ ρ ∈ ZF x, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
      = ∑ ρ ∈ ZF x \ F, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
        + (∑ ρ ∈ F \ S, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
          + ∑ ρ ∈ S, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x) := by
    rw [Finset.sum_sdiff hSF, Finset.sum_sdiff hFr]
  have hSid : (Real.log x : ℂ)
        * ∑ ρ ∈ S, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
      = ∑ ρ ∈ S, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * (((2:ℂ) ^ (ρ : ℂ)) ^ r / (ρ : ℂ))
        + (Real.log x : ℂ)
          * ∑ ρ ∈ S, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ipart (ρ : ℂ) x := by
    rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_add_distrib]
    refine Finset.sum_congr rfl fun ρ _ => ?_
    rw [piMode_eq, hxc]
    have hρ0 : (ρ : ℂ) ≠ 0 := by
      intro h
      have := ρ.2.1.1
      rw [h, Complex.zero_re] at this
      exact lt_irrefl _ this
    have e : (Real.log x : ℂ) * (((2:ℂ) ^ (ρ : ℂ)) ^ r / (ρ : ℂ) / (Real.log x : ℂ))
        = ((2:ℂ) ^ (ρ : ℂ)) ^ r / (ρ : ℂ) := by
      field_simp
    linear_combination ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * e
  set Z := ∑ ρ ∈ ZF x, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x with hZd
  set Zon := ∑ ρ ∈ ZF x \ F, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
    with hZond
  set Zoff := ∑ ρ ∈ F \ S, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
    with hZoffd
  set ZS := ∑ ρ ∈ S, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x with hZSd
  set ZI := ∑ ρ ∈ S, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ipart (ρ : ℂ) x with hZId
  set a := ∑ ρ ∈ S, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * (((2:ℂ) ^ (ρ : ℂ)) ^ r / (ρ : ℂ))
    with had
  have key : a = (Real.log x : ℂ) * Z - (Real.log x : ℂ) * Zon - (Real.log x : ℂ) * Zoff
      - (Real.log x : ℂ) * ZI := by
    linear_combination (-(Real.log x : ℂ)) * hsplit - hSid
  -- the whole sum
  have hZ : ‖Z‖ ≤ |(Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x|
      + Arem * Real.sqrt x * Real.log x ^ 2 + 8 * Real.sqrt x := by
    have e : Z = -(((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x : ℝ) : ℂ)
        + tr (efRem x) x - tr psiTheta x := by
      linear_combination hid
    rw [e]
    have h1 := norm_tr_efRem_le_of hx256
    have h2 := norm_tr_psiTheta_le hx2
    have h3 := norm_sub_le (-(((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x : ℝ) : ℂ)
      + tr (efRem x) x) (tr psiTheta x)
    have h4 := norm_add_le (-(((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x : ℝ) : ℂ))
      (tr (efRem x) x)
    rw [norm_neg, Complex.norm_real, Real.norm_eq_abs] at h4
    linarith
  have hZb : Real.log x * ‖Z‖
      ≤ (C * Real.log 2 + Arem + 8) * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r) := by
    have t0 := mul_le_mul_of_nonneg_left hZ hL0
    have t1 : Real.log x * |(Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x|
        ≤ C * Real.log 2 * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r) := by
      calc _ ≤ Real.log x * (C * (r : ℝ) ^ 2 * Real.sqrt 2 ^ r) :=
            mul_le_mul_of_nonneg_left hrow hL0
        _ = _ := by rw [hL]; ring
    have t2 : Real.log x * (Arem * Real.sqrt x * Real.log x ^ 2)
        ≤ Arem * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r) := by
      calc _ = Arem * (Real.log x ^ 3 * Real.sqrt 2 ^ r) := by rw [hsx]; ring
        _ ≤ _ := mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_right hL3 hs0) Arem_nonneg
    have t3 : Real.log x * (8 * Real.sqrt x) ≤ 8 * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r) := by
      calc _ = 8 * (Real.log x * Real.sqrt 2 ^ r) := by rw [hsx]; ring
        _ ≤ _ := mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_right hLr3 hs0) (by norm_num)
    have e : Real.log x * (|(Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x|
          + Arem * Real.sqrt x * Real.log x ^ 2 + 8 * Real.sqrt x)
        = Real.log x * |(Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x|
          + Real.log x * (Arem * Real.sqrt x * Real.log x ^ 2)
          + Real.log x * (8 * Real.sqrt x) := by ring
    have e2 : (C * Real.log 2 + Arem + 8) * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r)
        = C * Real.log 2 * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r)
          + Arem * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r) + 8 * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r) := by
      ring
    rw [e] at t0
    rw [e2]
    linarith
  -- the zeros on the line
  have hon : Real.log x * ‖Zon‖ ≤ 12 * (Mlow * 39000) * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r) := by
    have hon0 : ‖Zon‖ ≤ 12 * Real.sqrt x * zinv x := by
      rw [hZond]
      have hterm : ∀ ρ ∈ ZF x \ F, ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x‖
          ≤ 12 * Real.sqrt x * (ordR ρ * ‖(ρ : ℂ)‖⁻¹) := by
        intro ρ hρ
        have hre : (ρ : ℂ).re = 1 / 2 := by
          by_contra h
          exact (Finset.mem_sdiff.mp hρ).2 (hF ρ h)
        rw [norm_order_mul]
        have h := norm_piMode_half hre hx4
        calc ordR ρ * ‖piMode (ρ : ℂ) x‖ ≤ ordR ρ * (‖(ρ : ℂ)‖⁻¹ * (12 * Real.sqrt x)) :=
              mul_le_mul_of_nonneg_left h (ordR_nonneg ρ)
          _ = _ := by ring
      have hsub : ∑ ρ ∈ ZF x \ F, ordR ρ * ‖(ρ : ℂ)‖⁻¹ ≤ zinv x :=
        Finset.sum_le_sum_of_subset_of_nonneg Finset.sdiff_subset
          (fun ρ _ _ => mul_nonneg (ordR_nonneg ρ) (by positivity))
      calc _ ≤ ∑ ρ ∈ ZF x \ F, ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x‖ :=
            norm_sum_le _ _
        _ ≤ ∑ ρ ∈ ZF x \ F, 12 * Real.sqrt x * (ordR ρ * ‖(ρ : ℂ)‖⁻¹) :=
            Finset.sum_le_sum hterm
        _ = 12 * Real.sqrt x * ∑ ρ ∈ ZF x \ F, ordR ρ * ‖(ρ : ℂ)‖⁻¹ := by
            rw [Finset.mul_sum]
        _ ≤ 12 * Real.sqrt x * zinv x := mul_le_mul_of_nonneg_left hsub (by positivity)
    have hW := zinv_le_log hx4
    calc Real.log x * ‖Zon‖ ≤ Real.log x * (12 * Real.sqrt x * zinv x) :=
          mul_le_mul_of_nonneg_left hon0 hL0
      _ ≤ Real.log x * (12 * Real.sqrt x * (Mlow * 39000 * Real.log x ^ 2)) :=
          mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left hW (by positivity)) hL0
      _ = 12 * (Mlow * 39000) * (Real.log x ^ 3 * Real.sqrt 2 ^ r) := by rw [hsx]; ring
      _ ≤ 12 * (Mlow * 39000) * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r) :=
          mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_right hL3 hs0) (by linarith)
  -- the finitely many zeros below the top line
  have hoff : Real.log x * ‖Zoff‖
      ≤ ∑ ρ ∈ F \ S, ((ordR ρ * ‖(ρ : ℂ)‖⁻¹ * (1 + 4 / (ρ : ℂ).re))
          * ((r : ℝ) ^ 3 * ((2:ℝ) ^ (ρ : ℂ).re) ^ r)
        + (3 * (ordR ρ * ‖(ρ : ℂ)‖⁻¹)) * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r)) := by
    rw [hZoffd]
    calc _ ≤ Real.log x
          * ∑ ρ ∈ F \ S, ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x‖ :=
          mul_le_mul_of_nonneg_left (norm_sum_le _ _) hL0
      _ = ∑ ρ ∈ F \ S, Real.log x
          * ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x‖ := by
          rw [Finset.mul_sum]
      _ ≤ _ := Finset.sum_le_sum fun ρ _ => by
          rw [norm_order_mul]
          have h := norm_piMode_le (ρ := (ρ : ℂ)) ρ.2.1.1 ρ.2.1.2.le hx4
          rw [hxb, hsx] at h
          have hb0 : 0 < (ρ : ℂ).re := ρ.2.1.1
          have hc0 : 0 ≤ ordR ρ * ‖(ρ : ℂ)‖⁻¹ := mul_nonneg (ordR_nonneg ρ) (by positivity)
          have hb4 : 0 ≤ 1 + 4 / (ρ : ℂ).re := by positivity
          have hq0 : 0 ≤ ((2:ℝ) ^ (ρ : ℂ).re) ^ r := by positivity
          calc Real.log x * (ordR ρ * ‖piMode (ρ : ℂ) x‖)
              ≤ Real.log x * (ordR ρ * (‖(ρ : ℂ)‖⁻¹ * ((1 + 4 / (ρ : ℂ).re)
                  * ((2:ℝ) ^ (ρ : ℂ).re) ^ r + 3 * Real.sqrt 2 ^ r))) :=
                mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left h (ordR_nonneg ρ)) hL0
            _ = (ordR ρ * ‖(ρ : ℂ)‖⁻¹ * (1 + 4 / (ρ : ℂ).re))
                  * (Real.log x * ((2:ℝ) ^ (ρ : ℂ).re) ^ r)
                + (3 * (ordR ρ * ‖(ρ : ℂ)‖⁻¹)) * (Real.log x * Real.sqrt 2 ^ r) := by ring
            _ ≤ _ := add_le_add
                (mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_right hLr3 hq0)
                  (mul_nonneg hc0 hb4))
                (mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_right hLr3 hs0)
                  (by linarith))
  -- the integrals of the top line
  have hSI : Real.log x * ‖ZI‖
      ≤ ∑ ρ ∈ S, ((3 * (ordR ρ * ‖(ρ : ℂ)‖⁻¹)) * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r)
        + (4 * (ordR ρ * ‖(ρ : ℂ)‖⁻¹) / (β * Real.log 2))
          * ((r : ℝ)⁻¹ * ((2:ℝ) ^ β) ^ r)) := by
    rw [hZId]
    calc _ ≤ Real.log x
          * ∑ ρ ∈ S, ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ipart (ρ : ℂ) x‖ :=
          mul_le_mul_of_nonneg_left (norm_sum_le _ _) hL0
      _ = ∑ ρ ∈ S, Real.log x
          * ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ipart (ρ : ℂ) x‖ := by
          rw [Finset.mul_sum]
      _ ≤ _ := Finset.sum_le_sum fun ρ hρ => by
          rw [norm_order_mul]
          have hβ0 : 0 < β := by rw [← hSβ ρ hρ]; exact ρ.2.1.1
          have h := norm_ipart_le (ρ := (ρ : ℂ)) ρ.2.1.1 ρ.2.1.2.le hx4
          rw [hSβ ρ hρ, hxb, hsx] at h
          have hc0 : 0 ≤ ordR ρ * ‖(ρ : ℂ)‖⁻¹ := mul_nonneg (ordR_nonneg ρ) (by positivity)
          have e2 : Real.log x * (4 * ((2:ℝ) ^ β) ^ r / (β * Real.log x ^ 2))
              = 4 / (β * Real.log 2) * ((r : ℝ)⁻¹ * ((2:ℝ) ^ β) ^ r) := by
            rw [hL]
            field_simp
          calc Real.log x * (ordR ρ * ‖ipart (ρ : ℂ) x‖)
              ≤ Real.log x * (ordR ρ * (‖(ρ : ℂ)‖⁻¹ * (3 * Real.sqrt 2 ^ r
                  + 4 * ((2:ℝ) ^ β) ^ r / (β * Real.log x ^ 2)))) :=
                mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left h (ordR_nonneg ρ)) hL0
            _ = (3 * (ordR ρ * ‖(ρ : ℂ)‖⁻¹)) * (Real.log x * Real.sqrt 2 ^ r)
                + (ordR ρ * ‖(ρ : ℂ)‖⁻¹)
                  * (Real.log x * (4 * ((2:ℝ) ^ β) ^ r / (β * Real.log x ^ 2))) := by ring
            _ = (3 * (ordR ρ * ‖(ρ : ℂ)‖⁻¹)) * (Real.log x * Real.sqrt 2 ^ r)
                + (4 * (ordR ρ * ‖(ρ : ℂ)‖⁻¹) / (β * Real.log 2))
                  * ((r : ℝ)⁻¹ * ((2:ℝ) ^ β) ^ r) := by rw [e2]; ring
            _ ≤ _ := add_le_add_left
                (mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_right hLr3 hs0)
                  (by linarith)) _
  -- adding up
  have hnL : ∀ w : ℂ, ‖(Real.log x : ℂ) * w‖ = Real.log x * ‖w‖ := fun w => by
    rw [norm_mul, Complex.norm_real, Real.norm_of_nonneg hL0]
  rw [key]
  have n1 := norm_sub_le ((Real.log x : ℂ) * Z - (Real.log x : ℂ) * Zon
    - (Real.log x : ℂ) * Zoff) ((Real.log x : ℂ) * ZI)
  have n2 := norm_sub_le ((Real.log x : ℂ) * Z - (Real.log x : ℂ) * Zon)
    ((Real.log x : ℂ) * Zoff)
  have n3 := norm_sub_le ((Real.log x : ℂ) * Z) ((Real.log x : ℂ) * Zon)
  simp only [hnL] at n1 n2 n3
  unfold rowBound
  linarith

/-- **Finitely many zeros off the line, and the count of primes of square-root
size at the doublings: then no zero is off the line.** Let a finite set hold
every zero of ζ off the line. If the count of primes at `2^r` stays within
`C·r²·√2^r` of `Li` from some row on, the Riemann hypothesis holds. -/
theorem finite_off_line_pi (F : Finset NontrivialZeros)
    (hF : ∀ ρ : NontrivialZeros, (ρ : ℂ).re ≠ 1 / 2 → ρ ∈ F) (C : ℝ)
    (hrows : ∀ᶠ r : ℕ in atTop,
      |(Nat.primeCounting ⌊(2:ℝ) ^ r⌋₊ : ℝ) - Stage3.Li ((2:ℝ) ^ r)|
        ≤ C * (r : ℝ) ^ 2 * Real.sqrt 2 ^ r) :
    RiemannHypothesis := by
  classical
  apply LandauWindow.rh_of_zeroFree_half
  intro s hs hz
  have hs1 : s.re < 1 := by
    by_contra h
    exact riemannZeta_ne_zero_of_one_le_re (not_lt.mp h) hz
  let ρ₀ : NontrivialZeros := ⟨s, ⟨⟨by linarith, hs1⟩, Set.mem_univ _, hz⟩⟩
  have hρ₀F : ρ₀ ∈ F := hF ρ₀ (ne_of_gt hs)
  set F₁ := F.filter (fun ρ : NontrivialZeros => 1 / 2 < (ρ : ℂ).re) with hF₁
  have hF₁ne : F₁.Nonempty := ⟨ρ₀, Finset.mem_filter.mpr ⟨hρ₀F, hs⟩⟩
  obtain ⟨ρm, hρm, hmax⟩ :=
    Finset.exists_max_image F₁ (fun ρ : NontrivialZeros => (ρ : ℂ).re) hF₁ne
  set β := (ρm : ℂ).re with hβdef
  have hβ : 1 / 2 < β := (Finset.mem_filter.mp hρm).2
  have hle : ∀ ρ ∈ F, (ρ : ℂ).re ≤ β := by
    intro ρ hρ
    by_cases h : 1 / 2 < (ρ : ℂ).re
    · exact hmax ρ (Finset.mem_filter.mpr ⟨hρ, h⟩)
    · linarith
  set S := F.filter (fun ρ : NontrivialZeros => (ρ : ℂ).re = β) with hSdef
  have hSne : S.Nonempty :=
    ⟨ρm, Finset.mem_filter.mpr ⟨(Finset.mem_filter.mp hρm).1, rfl⟩⟩
  have hSF : S ⊆ F := Finset.filter_subset _ _
  have hSβ : ∀ ρ ∈ S, (ρ : ℂ).re = β := fun ρ hρ => (Finset.mem_filter.mp hρ).2
  have hlt : ∀ ρ ∈ F \ S, (ρ : ℂ).re < β := by
    intro ρ hρ
    have hρF := (Finset.mem_sdiff.mp hρ).1
    exact lt_of_le_of_ne (hle ρ hρF)
      (fun h => (Finset.mem_sdiff.mp hρ).2 (Finset.mem_filter.mpr ⟨hρF, h⟩))
  have hG := rowBound_isLittleO F S hβ hlt C
  set q : ℝ := (2:ℝ) ^ β with hq
  have hqpos : 0 < q := Real.rpow_pos_of_pos (by norm_num) β
  -- the bound holds from some row on
  have hbound : ∀ᶠ r : ℕ in atTop,
      ‖∑ ρ ∈ S, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * (((2:ℂ) ^ (ρ : ℂ)) ^ r / (ρ : ℂ))‖
        ≤ rowBound F S β C r := by
    filter_upwards [hrows, eventually_ge_atTop (8 + ⌈∑ ρ ∈ F, |(ρ : ℂ).im|⌉₊)] with r hrow hr
    have hFr : F ⊆ ZF ((2:ℝ) ^ r) := by
      intro ρ hρ
      rw [mem_ZF]
      have h1 : |(ρ : ℂ).im| ≤ ∑ ρ ∈ F, |(ρ : ℂ).im| :=
        Finset.single_le_sum (f := fun ρ : NontrivialZeros => |(ρ : ℂ).im|)
          (fun _ _ => abs_nonneg _) hρ
      have hKM : ⌈∑ ρ ∈ F, |(ρ : ℂ).im|⌉₊ ≤ r := by omega
      have h2 : ∑ ρ ∈ F, |(ρ : ℂ).im| ≤ (r : ℝ) :=
        (Nat.le_ceil _).trans (by exact_mod_cast hKM)
      have h3 : (r : ℝ) < (2:ℝ) ^ r := by
        exact_mod_cast (Nat.lt_two_pow_self : r < 2 ^ r)
      linarith
    exact row_bound F S hSF hSβ hF C (by omega) hFr hrow
  -- so the top line fades, which it cannot
  have hO : (fun r : ℕ =>
      ∑ ρ ∈ S, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * (((2:ℂ) ^ (ρ : ℂ)) ^ r / (ρ : ℂ)))
      =o[atTop] fun r : ℕ => ((q : ℝ) : ℂ) ^ r := by
    have hb := (Asymptotics.IsBigO.of_bound' (by
      filter_upwards [hbound] with r hr
      exact hr.trans ((le_abs_self _).trans_eq (Real.norm_eq_abs _).symm))).trans_isLittleO hG
    refine Asymptotics.isLittleO_norm_right.mp ?_
    convert hb using 2 with r
    rw [norm_pow, Complex.norm_real, Real.norm_of_nonneg hqpos.le]
  have hlim := hO.tendsto_div_nhds_zero
  refine LadderFading.line_not_fading S hSne hSβ 0 (hlim.congr fun r => ?_)
  congr 1
  refine Finset.sum_congr rfl fun ρ _ => ?_
  rw [CellModes.mode_two_int, zpow_natCast]
  ring

/-- info: 'FiniteOffLinePi.norm_ipart_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_ipart_le

/-- info: 'FiniteOffLinePi.row_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms row_bound

/-- info: 'FiniteOffLinePi.finite_off_line_pi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms finite_off_line_pi

end

end FiniteOffLinePi
