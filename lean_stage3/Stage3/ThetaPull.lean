/-
ThetaPull — the vertical segment `I₃₇` at a general abscissa `θ`.

WHAT THIS PORTS. `RHPull` (`LineBound.lean:1085` onward) bounds the
vertical segment of the Perron contour at `σRH X = 1/2 + 1/log X`:

    integrand_norm_le      :1096   line bound × Mellin bound × ‖X^s‖
    kernel_le              :1496   ((σ)² + t²)⁻¹ ≤ 4(1 + t²)⁻¹
    norm_line_ge           :—      ‖σ + it‖ ≥ (1 + |t|)/3
    I37_norm_le_decay      :1523   ∫ the 1/‖s‖² Mellin decay
    I37_sqrt_form          :1601   → 22200·e·C/ε · √X · log²X
    I37_norm_le_epsfree    :1873   ∫ the B/‖s‖ Mellin bound, ε-free
    I37_sqrt_log3          :1935   → 66600·e·B/π · √X · log³X

Every one of them consumes exactly two abscissa-specific facts: the line
bound on `ζ'/ζ` (now `ThetaLine.logDerivZeta_line_theta`) and the
identity `X^(σ) = e·√X` (now `Abscissa.rpow_σθ`, giving `e·X^θ`). The two
helpers need only `1/2 < σ`, which `θ ≥ 1/2` supplies. So this module is
the same seven theorems with `σθ θ X` in place of `σRH X`, `X^θ` in place
of `√X`, and `2/(1−θ) ≤ log X` in place of `4 ≤ log X`. Every numeral
survives; the outputs are

    I37_power_form_theta   → 22200·e·C/ε · X^θ · log²X
    I37_power_log3_theta   → 66600·e·B/π · X^θ · log³X

and `I37_sqrt_log3_half` proves the `θ = 1/2` instance is the built
theorem's statement, `√X` included.

WHAT THE `66600` IS. Entry 283 located the census-facing loss of the
RH-abscissa route in this coefficient. It is `6 · 11100`, from the
`log(1+T) ≤ 2 log X` step times the line-bound constant, and it does not
depend on `θ`. Moving `θ` moves the POWER `X^θ`, and leaves the constant
alone — which is exactly what entry 277's shape-free census requirement
asks for.

Companion to notes entries 277, 283–288.
-/
import Mathlib
import Stage3.ThetaLine

namespace Stage3

open Complex Set MeasureTheory intervalIntegral

noncomputable section

local notation "ζ" => riemannZeta

/-! ## The two helpers, needing only `1/2 < σ` -/

theorem half_lt_σθ {θ X : ℝ} (hθlo : 1/2 ≤ θ) (hLX : 0 < Real.log X) :
    (1:ℝ)/2 < σθ θ X := by
  have : (0:ℝ) < 1 / Real.log X := by positivity
  simp only [σθ]; linarith

/-- `4 ≤ log X` follows from the `θ`-hypothesis whenever `θ ≥ 1/2`. -/
theorem four_le_log_of_theta {θ X : ℝ} (hθlo : 1/2 ≤ θ) (hθhi : θ < 1)
    (hLX : 2 / (1 - θ) ≤ Real.log X) : (4:ℝ) ≤ Real.log X := by
  have h1θ : (0:ℝ) < 1 - θ := by linarith
  have : (4:ℝ) ≤ 2 / (1 - θ) := by
    rw [le_div_iff₀ h1θ]; linarith
  linarith

/-- The Cauchy kernel on the line is dominated by `4/(1+t²)`, at any `θ ≥ 1/2`. -/
theorem kernel_le_theta {θ X t : ℝ} (hθlo : 1/2 ≤ θ) (hLX : 0 < Real.log X) :
    ((σθ θ X) ^ 2 + t ^ 2)⁻¹ ≤ 4 * (1 + t ^ 2)⁻¹ := by
  have hσ := half_lt_σθ hθlo hLX
  have hpos2 : (0:ℝ) < (σθ θ X) ^ 2 + t ^ 2 := by nlinarith
  have hpos1 : (0:ℝ) < 1 + t ^ 2 := by positivity
  rw [inv_eq_one_div,
    show (4:ℝ) * (1 + t ^ 2)⁻¹ = 4 / (1 + t ^ 2) by rw [inv_eq_one_div]; ring,
    div_le_div_iff₀ hpos2 hpos1]
  nlinarith

theorem norm_line_ge_theta {θ X t : ℝ} (hθlo : 1/2 ≤ θ) (hLX : 0 < Real.log X) :
    (1 + |t|) / 3 ≤ ‖((σθ θ X : ℂ)) + I * (t : ℂ)‖ := by
  have hσ := half_lt_σθ hθlo hLX
  have hnn : (0:ℝ) ≤ ‖((σθ θ X : ℂ)) + I * (t : ℂ)‖ := norm_nonneg _
  have hsq := RHPull.norm_sq_line (σθ θ X) t
  have habs : |t| ^ 2 = t ^ 2 := sq_abs t
  have habs0 : (0:ℝ) ≤ |t| := abs_nonneg t
  nlinarith [hsq, habs, habs0, hnn, hσ, sq_nonneg (|t| - 1),
    sq_nonneg ‖((σθ θ X : ℂ)) + I * (t : ℂ)‖]

/-! ## The integrand -/

/-- **Pointwise bound on the pull integrand at abscissa `θ`.** -/
theorem integrand_norm_le_theta {θ : ℝ} (hθ : StmtZeroFreeRight θ)
    (hθlo : 1/2 ≤ θ) (hθhi : θ < 1) {ν : ℝ → ℝ} {ε X t M : ℝ}
    (hX : 0 < X) (hLX : 2 / (1 - θ) ≤ Real.log X) (htX : |t| ≤ X)
    (hMel : ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σθ θ X : ℂ) + I * (t : ℂ))‖ ≤ M) :
    ‖SmoothedChebyshevIntegrand ν ε X ((σθ θ X : ℂ) + I * (t : ℂ))‖
      ≤ 11100 * (Real.log X) ^ 2 * M * X ^ (σθ θ X) := by
  have hline := logDerivZeta_line_theta hθ hθlo hθhi hLX htX
  have hlogderiv :
      ‖(- deriv ζ ((σθ θ X : ℂ) + I * (t : ℂ))) / ζ ((σθ θ X : ℂ) + I * (t : ℂ))‖
        ≤ 11100 * (Real.log X) ^ 2 := by
    rw [neg_div, norm_neg]
    exact hline
  have hXs : ‖((X : ℂ)) ^ ((σθ θ X : ℂ) + I * (t : ℂ))‖ = X ^ (σθ θ X) := by
    rw [Complex.norm_cpow_eq_rpow_re_of_pos hX, σθ_re]
  have hM0 : 0 ≤ M := le_trans (norm_nonneg _) hMel
  simp only [SmoothedChebyshevIntegrand, Complex.norm_mul, hXs]
  have h1 : (0:ℝ) ≤ 11100 * (Real.log X) ^ 2 := by positivity
  have hXp : (0:ℝ) ≤ X ^ (σθ θ X) := Real.rpow_nonneg hX.le _
  calc ‖(- deriv ζ ((σθ θ X : ℂ) + I * (t : ℂ))) / ζ ((σθ θ X : ℂ) + I * (t : ℂ))‖
          * ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σθ θ X : ℂ) + I * (t : ℂ))‖
          * X ^ (σθ θ X)
      ≤ (11100 * (Real.log X) ^ 2) * M * X ^ (σθ θ X) := by
        gcongr
    _ = 11100 * (Real.log X) ^ 2 * M * X ^ (σθ θ X) := by ring

/-! ## `I₃₇` with the `1/‖s‖²` Mellin decay -/

/-- **I₃₇, T-free, at abscissa `θ`.** -/
theorem I37_norm_le_decay_theta {θ : ℝ} (hθ : StmtZeroFreeRight θ)
    (hθlo : 1/2 ≤ θ) (hθhi : θ < 1) {ν : ℝ → ℝ} {ε X T C : ℝ}
    (hX : 0 < X) (hLX : 2 / (1 - θ) ≤ Real.log X) (hT : 0 < T) (hTX : T ≤ X)
    (hC : 0 < C) (hε : 0 < ε)
    (hMel : ∀ t : ℝ, ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σθ θ X : ℂ) + I * (t : ℂ))‖
              ≤ C * (ε * ((σθ θ X) ^ 2 + t ^ 2))⁻¹) :
    ‖I₃₇ ν ε T X (σθ θ X)‖
      ≤ (1 / (2 * Real.pi)) * Real.pi
        * (11100 * (Real.log X) ^ 2 * (4 * C / ε) * X ^ (σθ θ X)) := by
  have hpi : (0:ℝ) < Real.pi := Real.pi_pos
  have hL4 := four_le_log_of_theta hθlo hθhi hLX
  have hL0 : (0:ℝ) ≤ Real.log X := by linarith
  have hLpos : (0:ℝ) < Real.log X := by linarith
  have hXp : (0:ℝ) ≤ X ^ (σθ θ X) := Real.rpow_nonneg hX.le _
  set K : ℝ := 11100 * (Real.log X) ^ 2 * (4 * C / ε) * X ^ (σθ θ X) with hKdef
  have hK0 : (0:ℝ) ≤ K := by rw [hKdef]; positivity
  have hbound : ∀ t : ℝ, t ∈ Set.Ioc (-T) T →
      ‖SmoothedChebyshevIntegrand ν ε X ((σθ θ X : ℂ) + (t : ℂ) * I)‖
        ≤ K * (1 + t ^ 2)⁻¹ := by
    intro t ht
    have htT : |t| ≤ T := by
      rw [abs_le]; exact ⟨le_of_lt ht.1, ht.2⟩
    have htX : |t| ≤ X := le_trans htT hTX
    have hcomm : ((σθ θ X : ℂ) + (t : ℂ) * I) = ((σθ θ X : ℂ) + I * (t : ℂ)) := by ring
    rw [hcomm]
    refine le_trans (integrand_norm_le_theta hθ hθlo hθhi hX hLX htX (hMel t)) ?_
    have hker := kernel_le_theta (θ := θ) (X := X) (t := t) hθlo hLpos
    have hCε : (0:ℝ) < C / ε := by positivity
    have hstep : C * (ε * ((σθ θ X) ^ 2 + t ^ 2))⁻¹
        ≤ (4 * C / ε) * (1 + t ^ 2)⁻¹ := by
      rw [mul_inv, ← mul_assoc]
      calc C * ε⁻¹ * ((σθ θ X) ^ 2 + t ^ 2)⁻¹
          ≤ C * ε⁻¹ * (4 * (1 + t ^ 2)⁻¹) := by
            gcongr
        _ = (4 * C / ε) * (1 + t ^ 2)⁻¹ := by field_simp
    rw [hKdef]
    calc 11100 * (Real.log X) ^ 2 * (C * (ε * ((σθ θ X) ^ 2 + t ^ 2))⁻¹) * X ^ (σθ θ X)
        ≤ 11100 * (Real.log X) ^ 2 * ((4 * C / ε) * (1 + t ^ 2)⁻¹) * X ^ (σθ θ X) := by
          gcongr
      _ = 11100 * (Real.log X) ^ 2 * (4 * C / ε) * X ^ (σθ θ X) * (1 + t ^ 2)⁻¹ := by ring
  have hg : IntervalIntegrable (fun t : ℝ => K * (1 + t ^ 2)⁻¹) volume (-T) T := by
    apply Continuous.intervalIntegrable
    fun_prop (disch := intro t; positivity)
  have hab : (-T : ℝ) ≤ T := by linarith
  have hmain := intervalIntegral.norm_integral_le_of_norm_le hab
    (Filter.Eventually.of_forall hbound) hg
  have hint : ∫ t in (-T)..T, K * (1 + t ^ 2)⁻¹ ≤ K * Real.pi := by
    rw [intervalIntegral.integral_const_mul]
    exact mul_le_mul_of_nonneg_left (RHPull.integral_kernel_le T) hK0
  simp only [I₃₇, Complex.norm_mul, norm_div, norm_one, Complex.norm_I, mul_one]
  have h2 : ‖(2:ℂ)‖ = 2 := by norm_num
  have hpin : ‖((Real.pi : ℝ) : ℂ)‖ = Real.pi := by
    rw [Complex.norm_real, Real.norm_of_nonneg hpi.le]
  rw [h2, hpin]
  calc 1 / (2 * Real.pi)
        * (1 * ‖∫ t in (-T)..T, SmoothedChebyshevIntegrand ν ε X ((σθ θ X : ℂ) + (t : ℂ) * I)‖)
      ≤ 1 / (2 * Real.pi) * (1 * (K * Real.pi)) := by
        gcongr
        exact le_trans hmain hint
    _ = 1 / (2 * Real.pi) * Real.pi * K := by ring

/-- **The vertical segment in `X^θ log²X` form.** `RHPull.I37_sqrt_form`
with `X^θ` where it had `√X`. -/
theorem I37_power_form_theta {θ : ℝ} (hθ : StmtZeroFreeRight θ)
    (hθlo : 1/2 ≤ θ) (hθhi : θ < 1) {ν : ℝ → ℝ} {ε X T C : ℝ}
    (hX : 0 < X) (hLX : 2 / (1 - θ) ≤ Real.log X) (hT : 0 < T) (hTX : T ≤ X)
    (hC : 0 < C) (hε : 0 < ε)
    (hMel : ∀ t : ℝ, ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σθ θ X : ℂ) + I * (t : ℂ))‖
              ≤ C * (ε * ((σθ θ X) ^ 2 + t ^ 2))⁻¹) :
    ‖I₃₇ ν ε T X (σθ θ X)‖
      ≤ (22200 * Real.exp 1 * C / ε) * X ^ θ * (Real.log X) ^ 2 := by
  have hpi : (0:ℝ) < Real.pi := Real.pi_pos
  have hL4 := four_le_log_of_theta hθlo hθhi hLX
  have hLpos : (0:ℝ) < Real.log X := by linarith
  refine le_trans (I37_norm_le_decay_theta hθ hθlo hθhi hX hLX hT hTX hC hε hMel) ?_
  rw [rpow_σθ hX hLpos]
  rw [show (1:ℝ) / (2 * Real.pi) * Real.pi = 1 / 2 by field_simp]
  have hL0 : (0:ℝ) ≤ Real.log X := by linarith
  have hXθ : (0:ℝ) ≤ X ^ θ := Real.rpow_nonneg hX.le _
  have he : (0:ℝ) < Real.exp 1 := Real.exp_pos 1
  rw [div_eq_mul_inv]
  ring_nf
  rfl

/-! ## `I₃₇` with the ε-free `B/‖s‖` Mellin bound -/

/-- **I₃₇ with the ε-free Mellin bound, at abscissa `θ`.** -/
theorem I37_norm_le_epsfree_theta {θ : ℝ} (hθ : StmtZeroFreeRight θ)
    (hθlo : 1/2 ≤ θ) (hθhi : θ < 1) {ν : ℝ → ℝ} {ε X T B : ℝ}
    (hX : 0 < X) (hLX : 2 / (1 - θ) ≤ Real.log X) (hT : 0 < T) (hTX : T ≤ X) (hB : 0 ≤ B)
    (hMel : ∀ t : ℝ, ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σθ θ X : ℂ) + I * (t : ℂ))‖
              ≤ B * ‖((σθ θ X : ℂ)) + I * (t : ℂ)‖⁻¹) :
    ‖I₃₇ ν ε T X (σθ θ X)‖
      ≤ (1 / (2 * Real.pi)) * (6 * Real.log (1 + T))
        * (11100 * (Real.log X) ^ 2 * B * X ^ (σθ θ X)) := by
  have hpi : (0:ℝ) < Real.pi := Real.pi_pos
  have hL4 := four_le_log_of_theta hθlo hθhi hLX
  have hL0 : (0:ℝ) ≤ Real.log X := by linarith
  have hLpos : (0:ℝ) < Real.log X := by linarith
  have hXp : (0:ℝ) ≤ X ^ (σθ θ X) := Real.rpow_nonneg hX.le _
  set K : ℝ := 11100 * (Real.log X) ^ 2 * B * X ^ (σθ θ X) with hKdef
  have hK0 : (0:ℝ) ≤ K := by rw [hKdef]; positivity
  have hbound : ∀ t : ℝ, t ∈ Set.Ioc (-T) T →
      ‖SmoothedChebyshevIntegrand ν ε X ((σθ θ X : ℂ) + (t : ℂ) * I)‖
        ≤ (3 * K) * (1 + |t|)⁻¹ := by
    intro t ht
    have htT : |t| ≤ T := by rw [abs_le]; exact ⟨le_of_lt ht.1, ht.2⟩
    have htX : |t| ≤ X := le_trans htT hTX
    have hcomm : ((σθ θ X : ℂ) + (t : ℂ) * I) = ((σθ θ X : ℂ) + I * (t : ℂ)) := by ring
    rw [hcomm]
    refine le_trans (integrand_norm_le_theta hθ hθlo hθhi hX hLX htX (hMel t)) ?_
    have hnl := norm_line_ge_theta (θ := θ) (X := X) (t := t) hθlo hLpos
    have habs : (0:ℝ) < 1 + |t| := by positivity
    have hnpos : (0:ℝ) < ‖((σθ θ X : ℂ)) + I * (t : ℂ)‖ := by
      refine lt_of_lt_of_le ?_ hnl
      positivity
    have hinv : ‖((σθ θ X : ℂ)) + I * (t : ℂ)‖⁻¹ ≤ 3 * (1 + |t|)⁻¹ := by
      rw [inv_eq_one_div, show (3:ℝ) * (1 + |t|)⁻¹ = 3 / (1 + |t|) by
        rw [inv_eq_one_div]; ring, div_le_div_iff₀ hnpos habs]
      linarith
    rw [hKdef]
    calc 11100 * (Real.log X) ^ 2 * (B * ‖((σθ θ X : ℂ)) + I * (t : ℂ)‖⁻¹) * X ^ (σθ θ X)
        ≤ 11100 * (Real.log X) ^ 2 * (B * (3 * (1 + |t|)⁻¹)) * X ^ (σθ θ X) := by gcongr
      _ = 3 * (11100 * (Real.log X) ^ 2 * B * X ^ (σθ θ X)) * (1 + |t|)⁻¹ := by ring
  have hcontg : Continuous fun t : ℝ => (3 * K) * (1 + |t|)⁻¹ := by
    fun_prop (disch := intro t; positivity)
  have hab : (-T : ℝ) ≤ T := by linarith
  have hgint : IntervalIntegrable (fun t : ℝ => (3 * K) * (1 + |t|)⁻¹) volume (-T) T :=
    hcontg.intervalIntegrable _ _
  have hmain := intervalIntegral.norm_integral_le_of_norm_le hab
    (Filter.Eventually.of_forall hbound) hgint
  have hint : ∫ t in (-T)..T, (3 * K) * (1 + |t|)⁻¹ = 6 * Real.log (1 + T) * K := by
    rw [intervalIntegral.integral_const_mul, RHPull.integral_abs_kernel hT.le]
    ring
  rw [hint] at hmain
  simp only [I₃₇, Complex.norm_mul, norm_div, norm_one, Complex.norm_I, mul_one]
  have h2 : ‖(2:ℂ)‖ = 2 := by norm_num
  have hpin : ‖((Real.pi : ℝ) : ℂ)‖ = Real.pi := by
    rw [Complex.norm_real, Real.norm_of_nonneg hpi.le]
  rw [h2, hpin]
  calc 1 / (2 * Real.pi)
        * (1 * ‖∫ t in (-T)..T, SmoothedChebyshevIntegrand ν ε X ((σθ θ X : ℂ) + (t : ℂ) * I)‖)
      ≤ 1 / (2 * Real.pi) * (1 * (6 * Real.log (1 + T) * K)) := by gcongr
    _ = 1 / (2 * Real.pi) * (6 * Real.log (1 + T)) * K := by ring

/-- **The vertical segment at `X^θ log³X`, ε-free.** `RHPull.I37_sqrt_log3`
with `X^θ` where it had `√X`. The `66600 = 6·11100` is untouched by `θ`. -/
theorem I37_power_log3_theta {θ : ℝ} (hθ : StmtZeroFreeRight θ)
    (hθlo : 1/2 ≤ θ) (hθhi : θ < 1) {ν : ℝ → ℝ} {ε X T B : ℝ}
    (hX : 0 < X) (hLX : 2 / (1 - θ) ≤ Real.log X) (hT : 0 < T) (hTX : T ≤ X) (hB : 0 ≤ B)
    (hMel : ∀ t : ℝ, ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σθ θ X : ℂ) + I * (t : ℂ))‖
              ≤ B * ‖((σθ θ X : ℂ)) + I * (t : ℂ)‖⁻¹) :
    ‖I₃₇ ν ε T X (σθ θ X)‖
      ≤ (66600 * Real.exp 1 * B / Real.pi) * X ^ θ * (Real.log X) ^ 3 := by
  have hpi : (0:ℝ) < Real.pi := Real.pi_pos
  have hL4 := four_le_log_of_theta hθlo hθhi hLX
  have hL0 : (0:ℝ) ≤ Real.log X := by linarith
  have hLpos : (0:ℝ) < Real.log X := by linarith
  have hX1 : (1:ℝ) < X := by
    by_contra hcon
    push_neg at hcon
    have := Real.log_nonpos hX.le hcon
    linarith
  have hXθ : (0:ℝ) ≤ X ^ θ := Real.rpow_nonneg hX.le _
  have hlogT : Real.log (1 + T) ≤ 2 * Real.log X := by
    have h1 : (1:ℝ) + T ≤ 2 * X := by linarith
    have h2 : Real.log (1 + T) ≤ Real.log (2 * X) :=
      Real.log_le_log (by linarith) h1
    have h3 : Real.log (2 * X) = Real.log 2 + Real.log X := by
      rw [Real.log_mul (by norm_num) (by linarith)]
    have h4 : Real.log 2 ≤ 1 := le_of_lt (Real.log_two_lt_d9.trans (by norm_num))
    linarith
  refine le_trans (I37_norm_le_epsfree_theta hθ hθlo hθhi hX hLX hT hTX hB hMel) ?_
  rw [rpow_σθ hX hLpos]
  have hKpos : (0:ℝ) ≤ 11100 * (Real.log X) ^ 2 * B * (Real.exp 1 * X ^ θ) := by
    have := Real.exp_pos 1
    positivity
  calc 1 / (2 * Real.pi) * (6 * Real.log (1 + T))
        * (11100 * (Real.log X) ^ 2 * B * (Real.exp 1 * X ^ θ))
      ≤ 1 / (2 * Real.pi) * (6 * (2 * Real.log X))
        * (11100 * (Real.log X) ^ 2 * B * (Real.exp 1 * X ^ θ)) := by
        have h6 : (0:ℝ) ≤ 1 / (2 * Real.pi) := by positivity
        have : (0:ℝ) ≤ 6 := by norm_num
        gcongr
    _ = (66600 * Real.exp 1 * B / Real.pi) * X ^ θ * (Real.log X) ^ 3 := by
        field_simp
        ring

/-! ## The weld at `θ = 1/2` -/

/-- **`I37_sqrt_log3` recovered.** Under RH, at `θ = 1/2`, the general
bound is `RHPull.I37_sqrt_log3`'s statement — `σθ (1/2) X` is `σRH X` by
`rfl`, and `X^(1/2) = √X`. -/
theorem I37_sqrt_log3_half (hRH : RiemannHypothesis) {ν : ℝ → ℝ} {ε X T B : ℝ}
    (hX : 0 < X) (hLX : 4 ≤ Real.log X) (hT : 0 < T) (hTX : T ≤ X) (hB : 0 ≤ B)
    (hMel : ∀ t : ℝ, ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((RHPull.σRH X : ℂ) + I * (t : ℂ))‖
              ≤ B * ‖((RHPull.σRH X : ℂ)) + I * (t : ℂ)‖⁻¹) :
    ‖I₃₇ ν ε T X (RHPull.σRH X)‖
      ≤ (66600 * Real.exp 1 * B / Real.pi) * Real.sqrt X * (Real.log X) ^ 3 := by
  have h := I37_power_log3_theta (θ := 1/2) (zeroFreeRight_of_RH hRH) le_rfl (by norm_num)
    hX (by norm_num; linarith) hT hTX hB hMel
  rw [Real.sqrt_eq_rpow]
  exact h

end

/-! ## Axiom check -/

/-- info: 'Stage3.integrand_norm_le_theta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.integrand_norm_le_theta

/-- info: 'Stage3.I37_power_form_theta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.I37_power_form_theta

/-- info: 'Stage3.I37_power_log3_theta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.I37_power_log3_theta

/-- info: 'Stage3.I37_sqrt_log3_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.I37_sqrt_log3_half

end Stage3
