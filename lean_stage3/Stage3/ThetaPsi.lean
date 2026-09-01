/-
ThetaPsi — `|ψ(X) − X| ≤ C·X^θ·log³X` from a zero-free half-plane `re > θ`.

WHAT THIS PORTS. The last stretch of `RHPull` (`LineBound.lean`):

    holo_logDerivZeta_of_RH     :1036   holomorphy of ζ'/ζ on the strip
    pull_at_RH_abscissa         :1056   SmoothedChebyshevPull1 at σRH
    integrand_norm_le_horiz     :1181   horizontal integrand, via the crude bound
    integrand_norm_le_horiz_neg :1303   the conjugate segment
    I8_norm_le, I2_norm_le      :1242, :1363
    mellin_vert_le              :2319
    contour_at_instantiation    :2232   the five pieces summed
    psi_weak_of_RH              :2357   ε = X^(−1/2), T = X

RH enters each of these through exactly two facts, both already
generalised: `ζ ≠ 0` right of the abscissa (`Abscissa.zeta_ne_zero_right_of`)
and the crude bound on `ζ'/ζ` (`Abscissa.logDerivZeta_crude_theta`). The
vertical segment is `ThetaPull.I37_power_log3_theta`.

WHAT `θ` CHANGES. Three things, each visible in a hypothesis or a numeral:

  · the horizontal segments have length `1 − θ` where they had `1/2`
    (`horiz_length_theta`); since `1 − θ ≤ 1/2` the RH-shaped bound
    `horiz_small` still covers them;
  · the smoothing parameter is `ε = X^(θ−1)` where it was `X^(−1/2)`,
    so `ε·X = X^θ` and the `I₁`, `I₉` pieces come out as `X^(1−θ)·log X`,
    which `θ ≥ 1/2` folds under `X^θ`;
  · the threshold `x₀` gains `(1/ε₀)^(1/(1−θ))`, because the main-term
    lemma needs `ε < ε₀`, i.e. `X^(1−θ) > 1/ε₀`.

Every numeral survives. The final constant is

    Cclose + C₁ + C₉ + 66600·e·B/π + 2·900·e·B/π + Cmain + 1

verbatim from `psi_weak_of_RH`, and `psi_weak_of_RH_half` proves that the
`θ = 1/2` instance is that theorem's statement, `√X` included.

WHAT THIS IS. `StmtZeroFreeRight θ → ∃ C x₀, ∀ X ≥ x₀, |ψ X − X| ≤ C·X^θ·log³X`
for every `θ ∈ [1/2, 1)`. Entry 285 made RH one setting of a dial; entry
277 measured the census to need `X^θ·log^k X` with `θ = 0.7464`. This
module is the theorem that turns the dial: any proved zero-free
half-plane, at any `θ` in the bracket, now yields the power saving in the
form the census consumes. No `θ < 1` half-plane is proved here or
anywhere in the tree.

Companion to notes entries 277, 283–288.
-/
import Mathlib
import Stage3.ThetaPull

namespace Stage3

open Complex Set MeasureTheory intervalIntegral

noncomputable section

local notation "ζ" => riemannZeta
local notation "ψ" => ChebyshevPsi

/-! ## Facts from the single hypothesis `2/(1−θ) ≤ log X` -/

theorem inv_log_le_theta {θ X : ℝ} (hθhi : θ < 1) (hLX : 2 / (1 - θ) ≤ Real.log X) :
    1 / Real.log X ≤ (1 - θ) / 2 := by
  have h1θ : (0:ℝ) < 1 - θ := by linarith
  have hLpos : (0:ℝ) < Real.log X := by
    have : (0:ℝ) < 2 / (1 - θ) := by positivity
    linarith
  rw [div_le_iff₀ h1θ] at hLX
  rw [div_le_div_iff₀ hLpos (by norm_num)]
  linarith

theorem σθ_lt_one {θ X : ℝ} (hθhi : θ < 1) (hLX : 2 / (1 - θ) ≤ Real.log X) :
    σθ θ X < 1 := by
  have := inv_log_le_theta hθhi hLX
  simp only [σθ]; linarith

theorem lt_σθ {θ X : ℝ} (hLX : 0 < Real.log X) : θ < σθ θ X := by
  have : (0:ℝ) < 1 / Real.log X := by positivity
  simp only [σθ]; linarith

/-- The horizontal segment has length exactly `1 − θ`. -/
theorem horiz_length_theta (θ X : ℝ) : (1 + 1 / Real.log X) - σθ θ X = 1 - θ := by
  simp only [σθ]; ring

/-! ## The contour pull -/

/-- **The holomorphy hypothesis is free right of a zero-free abscissa.** -/
theorem holo_logDerivZeta_theta {θ : ℝ} (hθ : StmtZeroFreeRight θ) {σ₁ T : ℝ}
    (hσ : θ < σ₁) :
    HolomorphicOn (deriv riemannZeta / riemannZeta)
      (Set.Icc σ₁ 2 ×ℂ Set.Icc (-T) T \ {1}) := by
  intro s hs
  have hs1 : s ≠ 1 := by simpa using hs.2
  have hre : σ₁ ≤ s.re := (Complex.mem_reProdIm.mp hs.1).1.1
  have hzne : riemannZeta s ≠ 0 :=
    zeta_ne_zero_right_of hθ (lt_of_lt_of_le hσ hre) hs1
  refine DifferentiableAt.differentiableWithinAt ?_
  exact (differentiableAt_deriv_riemannZeta hs1).div
    (differentiableAt_riemannZeta hs1) hzne

/-- **The pull, instantiated at abscissa `θ`.** `RHPull.pull_at_RH_abscissa`
with `σθ θ X` for `σRH X`. -/
theorem pull_at_theta_abscissa {θ : ℝ} (hθ : StmtZeroFreeRight θ)
    (hθlo : 1/2 ≤ θ) (hθhi : θ < 1) {SmoothingF : ℝ → ℝ} {ε : ℝ}
    (ε_pos : 0 < ε) (ε_lt_one : ε < 1) (X : ℝ) (X_gt : 3 < X)
    {T : ℝ} (T_pos : 0 < T) (hLX : 2 / (1 - θ) ≤ Real.log X)
    (suppSmoothingF : Function.support SmoothingF ⊆ Set.Icc (1 / 2) 2)
    (SmoothingFnonneg : ∀ x > 0, 0 ≤ SmoothingF x)
    (mass_one : ∫ x in Set.Ioi 0, SmoothingF x / x = 1)
    (ContDiffSmoothingF : ContDiff ℝ 1 SmoothingF) :
    SmoothedChebyshev SmoothingF ε X =
      I₁ SmoothingF ε X T
      - I₂ SmoothingF ε T X (σθ θ X)
      + I₃₇ SmoothingF ε T X (σθ θ X)
      + I₈ SmoothingF ε T X (σθ θ X)
      + I₉ SmoothingF ε X T
      + mellin (fun x ↦ (Smooth1 SmoothingF ε x : ℂ)) 1 * X := by
  have hL4 := four_le_log_of_theta hθlo hθhi hLX
  have hLpos : (0:ℝ) < Real.log X := by linarith
  have hσθ := lt_σθ (θ := θ) hLpos
  have hσpos : (0:ℝ) < σθ θ X := by linarith
  have hσlt := σθ_lt_one hθhi hLX
  exact SmoothedChebyshevPull1 ε_pos ε_lt_one X X_gt T_pos hσpos hσlt
    (holo_logDerivZeta_theta hθ hσθ) suppSmoothingF SmoothingFnonneg
    mass_one ContDiffSmoothingF

/-! ## The horizontal segments -/

/-- **Pointwise bound on the upper horizontal segment**, from the crude bound
at `θ`. Every numeral is `RHPull.integrand_norm_le_horiz`'s. -/
theorem integrand_norm_le_horiz_theta {θ : ℝ} (hθ : StmtZeroFreeRight θ)
    (hθlo : 1/2 ≤ θ) (hθhi : θ < 1) {ν : ℝ → ℝ} {ε X t σ M : ℝ}
    (hX : 0 < X) (hLX : 2 / (1 - θ) ≤ Real.log X) (ht : 2 ≤ t)
    (hσlo : σθ θ X ≤ σ) (hσhi : σ ≤ 1 + 1 / Real.log X)
    (hMel : ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) + I * (t : ℂ))‖ ≤ M) :
    ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) + I * (t : ℂ))‖
      ≤ (1996 * Real.log (84 * t) + (29 * Real.log t + 129) * Real.log X) * M * X ^ σ := by
  have hL4 := four_le_log_of_theta hθlo hθhi hLX
  have hLpos : (0:ℝ) < Real.log X := by linarith
  have hinv : (0:ℝ) < 1 / Real.log X := by positivity
  have hquarter : 1 / Real.log X ≤ 1 / 4 := by
    rw [div_le_div_iff₀ hLpos (by norm_num)]; linarith
  have hσlo₀ : θ + 1 / Real.log X ≤ σ := hσlo
  have hσlo' : θ < σ := by linarith
  have hσhi' : σ ≤ 2 := by linarith
  have hgappos : (0:ℝ) < σ - θ := by linarith
  have hrecip : 1 / (σ - θ) ≤ Real.log X := by
    rw [div_le_iff₀ hgappos]
    calc (1:ℝ) = (1 / Real.log X) * Real.log X := by field_simp
      _ ≤ (σ - θ) * Real.log X := by nlinarith [hLpos.le]
      _ = Real.log X * (σ - θ) := by ring
  have hcrude := logDerivZeta_crude_theta hθ hθlo ht hσlo' hσhi'
  have hlogt : (0:ℝ) ≤ Real.log t := Real.log_nonneg (by linarith)
  have hzeta : ‖(- deriv ζ ((σ : ℂ) + I * (t : ℂ))) / ζ ((σ : ℂ) + I * (t : ℂ))‖
      ≤ 1996 * Real.log (84 * t) + (29 * Real.log t + 129) * Real.log X := by
    rw [neg_div, norm_neg]
    refine le_trans hcrude ?_
    have hnum : (0:ℝ) ≤ 29 * Real.log t + 129 := by linarith
    have heq : (29 * Real.log t + 129) / (σ - θ)
        = (29 * Real.log t + 129) * (1 / (σ - θ)) := by ring
    rw [heq]
    gcongr
  have hXs : ‖((X : ℂ)) ^ ((σ : ℂ) + I * (t : ℂ))‖ = X ^ σ := by
    rw [Complex.norm_cpow_eq_rpow_re_of_pos hX]
    congr 1
    simp [Complex.add_re, Complex.mul_re]
  have hM0 : 0 ≤ M := le_trans (norm_nonneg _) hMel
  simp only [SmoothedChebyshevIntegrand, Complex.norm_mul, hXs]
  have hXp : (0:ℝ) ≤ X ^ σ := Real.rpow_nonneg hX.le _
  have hlog84 : (0:ℝ) ≤ Real.log (84 * t) := Real.log_nonneg (by linarith)
  have hK : (0:ℝ) ≤ 1996 * Real.log (84 * t) + (29 * Real.log t + 129) * Real.log X := by
    have : (0:ℝ) ≤ (29 * Real.log t + 129) * Real.log X := by positivity
    linarith
  gcongr

/-- **Pointwise bound on the lower horizontal segment**, through the conjugate
symmetry `Slice4b.logDerivZeta_norm_neg`. -/
theorem integrand_norm_le_horiz_neg_theta {θ : ℝ} (hθ : StmtZeroFreeRight θ)
    (hθlo : 1/2 ≤ θ) (hθhi : θ < 1) {ν : ℝ → ℝ} {ε X T σ M : ℝ}
    (hX : 0 < X) (hLX : 2 / (1 - θ) ≤ Real.log X) (hT : 2 ≤ T)
    (hσlo : σθ θ X ≤ σ) (hσhi : σ ≤ 1 + 1 / Real.log X)
    (hMel : ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) - (T : ℂ) * I)‖ ≤ M) :
    ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) - (T : ℂ) * I)‖
      ≤ (1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X) * M * X ^ σ := by
  have hL4 := four_le_log_of_theta hθlo hθhi hLX
  have hLpos : (0:ℝ) < Real.log X := by linarith
  have hinv : (0:ℝ) < 1 / Real.log X := by positivity
  have hquarter : 1 / Real.log X ≤ 1 / 4 := by
    rw [div_le_div_iff₀ hLpos (by norm_num)]; linarith
  have hσlo₀ : θ + 1 / Real.log X ≤ σ := hσlo
  have hσlo' : θ < σ := by linarith
  have hσhi' : σ ≤ 2 := by linarith
  have hgappos : (0:ℝ) < σ - θ := by linarith
  have hrecip : 1 / (σ - θ) ≤ Real.log X := by
    rw [div_le_iff₀ hgappos]
    calc (1:ℝ) = (1 / Real.log X) * Real.log X := by field_simp
      _ ≤ (σ - θ) * Real.log X := by nlinarith [hLpos.le]
      _ = Real.log X * (σ - θ) := by ring
  have hneg : ((σ : ℂ) - (T : ℂ) * I) = ((σ : ℂ) + I * ((-T : ℝ) : ℂ)) := by
    push_cast; ring
  have hsym := Slice4b.logDerivZeta_norm_neg σ T
  have hcrude := logDerivZeta_crude_theta hθ hθlo hT hσlo' hσhi'
  have hlogt : (0:ℝ) ≤ Real.log T := Real.log_nonneg (by linarith)
  have hzeta : ‖(- deriv ζ ((σ : ℂ) - (T : ℂ) * I)) / ζ ((σ : ℂ) - (T : ℂ) * I)‖
      ≤ 1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X := by
    rw [neg_div, norm_neg, hneg, hsym]
    refine le_trans hcrude ?_
    have hnum : (0:ℝ) ≤ 29 * Real.log T + 129 := by linarith
    have heq : (29 * Real.log T + 129) / (σ - θ)
        = (29 * Real.log T + 129) * (1 / (σ - θ)) := by ring
    rw [heq]
    gcongr
  have hXs : ‖((X : ℂ)) ^ ((σ : ℂ) - (T : ℂ) * I)‖ = X ^ σ := by
    rw [Complex.norm_cpow_eq_rpow_re_of_pos hX]
    congr 1
    simp [Complex.sub_re, Complex.mul_re]
  have hM0 : 0 ≤ M := le_trans (norm_nonneg _) hMel
  simp only [SmoothedChebyshevIntegrand, Complex.norm_mul, hXs]
  have hXp : (0:ℝ) ≤ X ^ σ := Real.rpow_nonneg hX.le _
  have hlog84 : (0:ℝ) ≤ Real.log (84 * T) := Real.log_nonneg (by linarith)
  have hK : (0:ℝ) ≤ 1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X := by
    have : (0:ℝ) ≤ (29 * Real.log T + 129) * Real.log X := by positivity
    linarith
  gcongr

/-- **I₈ bounded at abscissa `θ`** — the upper horizontal segment, length `1 − θ`. -/
theorem I8_norm_le_theta {θ : ℝ} (hθ : StmtZeroFreeRight θ)
    (hθlo : 1/2 ≤ θ) (hθhi : θ < 1) {ν : ℝ → ℝ} {ε X T M : ℝ}
    (hX : 0 < X) (hLX : 2 / (1 - θ) ≤ Real.log X) (hT : 2 ≤ T)
    (hMel : ∀ σ : ℝ, σθ θ X ≤ σ → σ ≤ 1 + 1 / Real.log X →
      ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) + I * (T : ℂ))‖ ≤ M) :
    ‖I₈ ν ε T X (σθ θ X)‖
      ≤ (1 / (2 * Real.pi)) * (1 - θ)
        * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X)
            * M * X ^ (1 + 1 / Real.log X)) := by
  have hpi : (0:ℝ) < Real.pi := Real.pi_pos
  have hL4 := four_le_log_of_theta hθlo hθhi hLX
  have hLpos : (0:ℝ) < Real.log X := by linarith
  have hX1 : (1:ℝ) < X := by
    by_contra hcon
    push_neg at hcon
    have := Real.log_nonpos hX.le hcon
    linarith
  have hle : σθ θ X ≤ 1 + 1 / Real.log X := by
    have := horiz_length_theta θ X; linarith
  set K : ℝ := (1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X)
      * M * X ^ (1 + 1 / Real.log X) with hKdef
  have hbound : ∀ σ ∈ Set.uIoc (σθ θ X) (1 + 1 / Real.log X),
      ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) + (T : ℂ) * I)‖ ≤ K := by
    intro σ hσ
    rw [Set.uIoc_of_le hle] at hσ
    have hσlo : σθ θ X ≤ σ := le_of_lt hσ.1
    have hcomm : ((σ : ℂ) + (T : ℂ) * I) = ((σ : ℂ) + I * (T : ℂ)) := by ring
    rw [hcomm]
    refine le_trans
      (integrand_norm_le_horiz_theta hθ hθlo hθhi hX hLX hT hσlo hσ.2 (hMel σ hσlo hσ.2)) ?_
    have hM0 : (0:ℝ) ≤ M := le_trans (norm_nonneg _) (hMel σ hσlo hσ.2)
    have hlog84 : (0:ℝ) ≤ Real.log (84 * T) := Real.log_nonneg (by linarith)
    have hlogT : (0:ℝ) ≤ Real.log T := Real.log_nonneg (by linarith)
    have hC : (0:ℝ) ≤ 1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X := by
      have : (0:ℝ) ≤ (29 * Real.log T + 129) * Real.log X := by positivity
      linarith
    rw [hKdef]
    gcongr
    · exact hX1.le
    · exact hσ.2
  have hint := intervalIntegral.norm_integral_le_of_norm_le_const hbound
  rw [show |(1 + 1 / Real.log X) - σθ θ X| = 1 - θ by
    rw [horiz_length_theta]; exact abs_of_nonneg (by linarith)] at hint
  simp only [I₈, Complex.norm_mul, norm_div, norm_one, ← one_div]
  have h2 : ‖(2:ℂ)‖ = 2 := by norm_num
  have hpin : ‖((Real.pi : ℝ) : ℂ)‖ = Real.pi := by
    rw [Complex.norm_real, Real.norm_of_nonneg hpi.le]
  rw [h2, hpin, Complex.norm_I, mul_one]
  calc 1 / (2 * Real.pi)
        * ‖∫ σ in (σθ θ X)..(1 + 1 / Real.log X),
            SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) + (T : ℂ) * I)‖
      ≤ 1 / (2 * Real.pi) * (K * (1 - θ)) := by gcongr
    _ = 1 / (2 * Real.pi) * (1 - θ) * K := by ring

/-- **I₂ bounded at abscissa `θ`** — the lower horizontal segment, length `1 − θ`. -/
theorem I2_norm_le_theta {θ : ℝ} (hθ : StmtZeroFreeRight θ)
    (hθlo : 1/2 ≤ θ) (hθhi : θ < 1) {ν : ℝ → ℝ} {ε X T M : ℝ}
    (hX : 0 < X) (hLX : 2 / (1 - θ) ≤ Real.log X) (hT : 2 ≤ T)
    (hMel : ∀ σ : ℝ, σθ θ X ≤ σ → σ ≤ 1 + 1 / Real.log X →
      ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) - (T : ℂ) * I)‖ ≤ M) :
    ‖I₂ ν ε T X (σθ θ X)‖
      ≤ (1 / (2 * Real.pi)) * (1 - θ)
        * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X)
            * M * X ^ (1 + 1 / Real.log X)) := by
  have hpi : (0:ℝ) < Real.pi := Real.pi_pos
  have hL4 := four_le_log_of_theta hθlo hθhi hLX
  have hLpos : (0:ℝ) < Real.log X := by linarith
  have hX1 : (1:ℝ) < X := by
    by_contra hcon
    push_neg at hcon
    have := Real.log_nonpos hX.le hcon
    linarith
  have hle : σθ θ X ≤ 1 + 1 / Real.log X := by
    have := horiz_length_theta θ X; linarith
  set K : ℝ := (1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X)
      * M * X ^ (1 + 1 / Real.log X) with hKdef
  have hbound : ∀ σ ∈ Set.uIoc (σθ θ X) (1 + 1 / Real.log X),
      ‖SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) - (T : ℂ) * I)‖ ≤ K := by
    intro σ hσ
    rw [Set.uIoc_of_le hle] at hσ
    have hσlo : σθ θ X ≤ σ := le_of_lt hσ.1
    refine le_trans
      (integrand_norm_le_horiz_neg_theta hθ hθlo hθhi hX hLX hT hσlo hσ.2
        (hMel σ hσlo hσ.2)) ?_
    have hM0 : (0:ℝ) ≤ M := le_trans (norm_nonneg _) (hMel σ hσlo hσ.2)
    have hlog84 : (0:ℝ) ≤ Real.log (84 * T) := Real.log_nonneg (by linarith)
    have hlogT : (0:ℝ) ≤ Real.log T := Real.log_nonneg (by linarith)
    have hC : (0:ℝ) ≤ 1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X := by
      have : (0:ℝ) ≤ (29 * Real.log T + 129) * Real.log X := by positivity
      linarith
    rw [hKdef]
    gcongr
    · exact hX1.le
    · exact hσ.2
  have hint := intervalIntegral.norm_integral_le_of_norm_le_const hbound
  rw [show |(1 + 1 / Real.log X) - σθ θ X| = 1 - θ by
    rw [horiz_length_theta]; exact abs_of_nonneg (by linarith)] at hint
  simp only [I₂, Complex.norm_mul, norm_div, norm_one, ← one_div]
  have h2 : ‖(2:ℂ)‖ = 2 := by norm_num
  have hpin : ‖((Real.pi : ℝ) : ℂ)‖ = Real.pi := by
    rw [Complex.norm_real, Real.norm_of_nonneg hpi.le]
  rw [h2, hpin, Complex.norm_I, mul_one]
  calc 1 / (2 * Real.pi)
        * ‖∫ σ in (σθ θ X)..(1 + 1 / Real.log X),
            SmoothedChebyshevIntegrand ν ε X ((σ : ℂ) - (T : ℂ) * I)‖
      ≤ 1 / (2 * Real.pi) * (K * (1 - θ)) := by gcongr
    _ = 1 / (2 * Real.pi) * (1 - θ) * K := by ring

/-! ## The Mellin factor on the line -/

theorem mellin_vert_le_theta {θ : ℝ} (hθlo : 1/2 ≤ θ) (hθhi : θ < 1)
    {ν : ℝ → ℝ} (diffν : ContDiff ℝ 1 ν)
    (suppν : ν.support ⊆ Set.Icc (1/2 : ℝ) 2) {B : ℝ}
    (hB : ∀ w : ℂ, 0 < w.re → w.re ≤ 2 → ‖mellin (fun x ↦ (ν x : ℂ)) w‖ ≤ B)
    {ε X : ℝ} (hε : 0 < ε) (hε1 : ε < 1) (hLX : 2 / (1 - θ) ≤ Real.log X) (t : ℝ) :
    ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σθ θ X : ℂ) + I * (t : ℂ))‖
      ≤ B * ‖((σθ θ X : ℂ)) + I * (t : ℂ)‖⁻¹ := by
  have hL4 := four_le_log_of_theta hθlo hθhi hLX
  have hLpos : (0:ℝ) < Real.log X := by linarith
  have hre : (((σθ θ X : ℂ)) + I * (t : ℂ)).re = σθ θ X := σθ_re θ X t
  have h0 : 0 < σθ θ X := by
    have := lt_σθ (θ := θ) hLpos; linarith
  have h2 : σθ θ X ≤ 2 := by
    have := σθ_lt_one hθhi hLX; linarith
  exact RHPull.mellin_smooth1_le diffν suppν hB hε hε1
    (by rw [hre]; exact h0) (by rw [hre]; exact h2)

/-! ## The assembly -/

/-- **Every contour piece summed at abscissa `θ`.** `RHPull.contour_at_instantiation`
with `X^θ` for `√X` on the vertical piece and `1 − θ` for `1/2` on the horizontal
lengths. -/
theorem contour_at_instantiation_theta {θ : ℝ} (hθ : StmtZeroFreeRight θ)
    (hθlo : 1/2 ≤ θ) (hθhi : θ < 1)
    {ν : ℝ → ℝ} {ε X T B B₁ B₉ M₂ M₈ : ℝ}
    (ε_pos : 0 < ε) (ε_lt_one : ε < 1) (X_gt : 3 < X)
    (hX : 0 < X) (hLX : 2 / (1 - θ) ≤ Real.log X) (hT2 : 2 ≤ T) (hTX : T ≤ X) (hB : 0 ≤ B)
    (suppν : Function.support ν ⊆ Set.Icc (1 / 2) 2)
    (νnonneg : ∀ x > 0, 0 ≤ ν x)
    (mass_one : ∫ x in Set.Ioi 0, ν x / x = 1)
    (diffν : ContDiff ℝ 1 ν)
    (hB1 : ‖I₁ ν ε X T‖ ≤ B₁) (hB9 : ‖I₉ ν ε X T‖ ≤ B₉)
    (hMel37 : ∀ t : ℝ, ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σθ θ X : ℂ) + I * (t : ℂ))‖
              ≤ B * ‖((σθ θ X : ℂ)) + I * (t : ℂ)‖⁻¹)
    (hMel8 : ∀ σ : ℝ, σθ θ X ≤ σ → σ ≤ 1 + 1 / Real.log X →
      ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) + I * (T : ℂ))‖ ≤ M₈)
    (hMel2 : ∀ σ : ℝ, σθ θ X ≤ σ → σ ≤ 1 + 1 / Real.log X →
      ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) - (T : ℂ) * I)‖ ≤ M₂) :
    ‖SmoothedChebyshev ν ε X - mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 * X‖
      ≤ B₁ + B₉
        + (66600 * Real.exp 1 * B / Real.pi) * X ^ θ * (Real.log X) ^ 3
        + (1 / (2 * Real.pi)) * (1 - θ)
            * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X)
                * M₈ * X ^ (1 + 1 / Real.log X))
        + (1 / (2 * Real.pi)) * (1 - θ)
            * ((1996 * Real.log (84 * T) + (29 * Real.log T + 129) * Real.log X)
                * M₂ * X ^ (1 + 1 / Real.log X)) := by
  have hT0 : (0:ℝ) < T := by linarith
  have hsplit := pull_at_theta_abscissa hθ hθlo hθhi ε_pos ε_lt_one X X_gt hT0 hLX
    suppν νnonneg mass_one diffν
  have hI37 := I37_power_log3_theta hθ hθlo hθhi hX hLX hT0 hTX hB hMel37
  have hI8 := I8_norm_le_theta hθ hθlo hθhi hX hLX hT2 hMel8
  have hI2 := I2_norm_le_theta hθ hθlo hθhi hX hLX hT2 hMel2
  have hrw : SmoothedChebyshev ν ε X - mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 * X
      = I₁ ν ε X T - I₂ ν ε T X (σθ θ X) + I₃₇ ν ε T X (σθ θ X)
        + I₈ ν ε T X (σθ θ X) + I₉ ν ε X T := by
    rw [hsplit]; ring
  rw [hrw]
  have htri : ∀ a b c d e : ℂ,
      ‖a - b + c + d + e‖ ≤ ‖a‖ + ‖b‖ + ‖c‖ + ‖d‖ + ‖e‖ := by
    intro a b c d e
    calc ‖a - b + c + d + e‖
        ≤ ‖a - b + c + d‖ + ‖e‖ := norm_add_le _ _
      _ ≤ (‖a - b + c‖ + ‖d‖) + ‖e‖ := by gcongr; exact norm_add_le _ _
      _ ≤ ((‖a - b‖ + ‖c‖) + ‖d‖) + ‖e‖ := by gcongr; exact norm_add_le _ _
      _ ≤ (((‖a‖ + ‖b‖) + ‖c‖) + ‖d‖) + ‖e‖ := by gcongr; exact norm_sub_le _ _
      _ = ‖a‖ + ‖b‖ + ‖c‖ + ‖d‖ + ‖e‖ := by ring
  have h := htri (I₁ ν ε X T) (I₂ ν ε T X (σθ θ X)) (I₃₇ ν ε T X (σθ θ X))
    (I₈ ν ε T X (σθ θ X)) (I₉ ν ε X T)
  linarith

/-- **The instantiation arithmetic at `θ`.** With `ε = X^(θ−1)` and `T = X`,
`ε·X = X^θ`, and every error piece lands under `c·X^θ·log³X`:

  smoothing   `ε X log X    = X^θ log X`
  I₁, I₉      `X log X/(εX) = X^(1−θ) log X ≤ X^θ log X`   since `1−θ ≤ θ`
  main term   `ε X          = X^θ`
-/
theorem theta_instantiation_arithmetic {X θ c : ℝ}
    (hX1 : 1 < X) (hθlo : 1/2 ≤ θ) (hθhi : θ ≤ 1) (hLX : 1 ≤ Real.log X) (hc : 0 ≤ c) :
    c * (X ^ (1 - θ))⁻¹ * X * Real.log X ≤ c * X ^ θ * (Real.log X) ^ 3
    ∧ c * X * Real.log X / ((X ^ (1 - θ))⁻¹ * X) ≤ c * X ^ θ * (Real.log X) ^ 3
    ∧ c * ((X ^ (1 - θ))⁻¹ * X) ≤ c * X ^ θ * (Real.log X) ^ 3 := by
  have hX : (0:ℝ) < X := by linarith
  set P : ℝ := X ^ (1 - θ) with hP
  set Q : ℝ := X ^ θ with hQ
  have hP0 : 0 < P := Real.rpow_pos_of_pos hX _
  have hQ0 : 0 < Q := Real.rpow_pos_of_pos hX _
  have hPQ : P * Q = X := by
    rw [hP, hQ, ← Real.rpow_add hX, sub_add_cancel, Real.rpow_one]
  have hQ1 : (1:ℝ) ≤ Q := Real.one_le_rpow hX1.le (by linarith)
  have hPQle : P ≤ Q := Real.rpow_le_rpow_of_exponent_le hX1.le (by linarith)
  have hkey : P⁻¹ * X = Q := by
    rw [← hPQ, inv_mul_cancel_left₀ hP0.ne']
  have hdiv : X / Q = P := by
    rw [← hPQ, mul_div_cancel_right₀ _ hQ0.ne']
  have hcube : Real.log X ≤ (Real.log X) ^ 3 := by
    have hL2 : (1:ℝ) ≤ (Real.log X) ^ 2 := by nlinarith
    nlinarith [hL2, hLX]
  have hcQ : (0:ℝ) ≤ c * Q := by positivity
  refine ⟨?_, ?_, ?_⟩
  · rw [mul_assoc c, hkey]
    exact mul_le_mul_of_nonneg_left hcube hcQ
  · rw [hkey, show c * X * Real.log X / Q = (c * (X / Q)) * Real.log X by field_simp, hdiv]
    have hL0 : (0:ℝ) ≤ Real.log X := by linarith
    calc c * P * Real.log X ≤ c * Q * Real.log X := by gcongr
      _ ≤ c * Q * (Real.log X) ^ 3 := mul_le_mul_of_nonneg_left hcube hcQ
  · rw [hkey]
    have h1 : (1:ℝ) ≤ (Real.log X) ^ 3 := by nlinarith
    calc c * Q ≤ c * Q * (Real.log X) ^ 3 := by nlinarith [hcQ, h1]
      _ = c * Q * (Real.log X) ^ 3 := rfl

/-- **`|ψ X − X| ≤ C·X^θ·log³X` from a zero-free half-plane `re > θ`.**
`RHPull.psi_weak_of_RH` with `StmtZeroFreeRight θ` for RH, `ε = X^(θ−1)` for
`X^(−1/2)`, `T = X` as before. Every constant is obtained: `B` from
`mellin_bump_bounded`, `Cclose` from `SmoothedChebyshevClose`, `C₁`/`C₉` from
`I1Bound`/`I9Bound`, `Cmain` from `MellinOfSmooth1c`. -/
theorem psi_weak_of_theta {θ : ℝ} (hθ : StmtZeroFreeRight θ)
    (hθlo : 1/2 ≤ θ) (hθhi : θ < 1) :
    ∃ C > 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t →
      |ψ t - t| ≤ C * t ^ θ * (Real.log t) ^ 3 := by
  obtain ⟨ν, diffν, νnonneg, suppν, mass_one⟩ := RHPull.bump_exists
  obtain ⟨B, hB0, hB⟩ := RHPull.mellin_bump_bounded diffν suppν
  obtain ⟨Cclose, hCclose0, hCclose⟩ :=
    SmoothedChebyshevClose diffν suppν νnonneg mass_one
  obtain ⟨C1, hC10, hC1⟩ := I1Bound suppν diffν νnonneg mass_one
  obtain ⟨C9, hC90, hC9⟩ := I9Bound suppν diffν νnonneg mass_one
  obtain ⟨Cmain, hCmain0, ε₀, hε₀0, hCmainB⟩ := RHPull.mellin_main_const diffν suppν mass_one
  have h1θ : (0:ℝ) < 1 - θ := by linarith
  refine ⟨Cclose + C1 + C9 + (66600 * Real.exp 1 * B / Real.pi)
      + 2 * (900 * Real.exp 1 * B / Real.pi) + Cmain + 1, by positivity,
    max (Real.exp (2 / (1 - θ) + 6)) (max 16 ((1 / ε₀) ^ (1 - θ)⁻¹ + 1)), ?_⟩
  intro X hXge
  have hexp : Real.exp (2 / (1 - θ) + 6) ≤ X := le_trans (le_max_left _ _) hXge
  have h16 : (16:ℝ) ≤ X := le_trans (le_trans (le_max_left _ _) (le_max_right _ _)) hXge
  have hε₀X : (1 / ε₀) ^ (1 - θ)⁻¹ + 1 ≤ X :=
    le_trans (le_trans (le_max_right _ _) (le_max_right _ _)) hXge
  have hX : (0:ℝ) < X := by linarith
  have hX1 : (1:ℝ) < X := by linarith
  have hLXθ6 : 2 / (1 - θ) + 6 ≤ Real.log X := by
    have := Real.log_le_log (Real.exp_pos _) hexp
    rwa [Real.log_exp] at this
  have hLX : 2 / (1 - θ) ≤ Real.log X := by linarith
  have hL4 := four_le_log_of_theta hθlo hθhi hLX
  have h2θ : (0:ℝ) ≤ 2 / (1 - θ) := by positivity
  have hLX5 : (5:ℝ) ≤ Real.log X := by linarith
  have hL1 : (1:ℝ) ≤ Real.log X := by linarith
  have hLpos : (0:ℝ) < Real.log X := by linarith
  have hX3 : (3:ℝ) < X := by linarith
  -- the parameters: ε = X^(θ−1), so ε·X = X^θ
  have hP0 : 0 < X ^ (1 - θ) := Real.rpow_pos_of_pos hX _
  have hQ0 : 0 < X ^ θ := Real.rpow_pos_of_pos hX _
  have hP1 : 1 < X ^ (1 - θ) := Real.one_lt_rpow hX1 h1θ
  have hPQ : X ^ (1 - θ) * X ^ θ = X := by
    rw [← Real.rpow_add hX, sub_add_cancel, Real.rpow_one]
  set ε : ℝ := (X ^ (1 - θ))⁻¹ with hεdef
  have hε : (0:ℝ) < ε := by rw [hεdef]; positivity
  have hε1 : ε < 1 := by
    rw [hεdef, inv_lt_one_iff₀]
    right; exact hP1
  have hεX : ε * X = X ^ θ := by
    calc ε * X = (X ^ (1 - θ))⁻¹ * (X ^ (1 - θ) * X ^ θ) := by rw [hεdef, hPQ]
      _ = X ^ θ := inv_mul_cancel_left₀ hP0.ne' _
  have hsq4 : (4:ℝ) ≤ Real.sqrt X := by
    have := Real.sqrt_le_sqrt h16
    rwa [show Real.sqrt 16 = 4 by
      rw [show (16:ℝ) = 4 ^ 2 by norm_num, Real.sqrt_sq (by norm_num)]] at this
  have hQ4 : (4:ℝ) ≤ X ^ θ := by
    have : Real.sqrt X ≤ X ^ θ := by
      rw [Real.sqrt_eq_rpow]
      exact Real.rpow_le_rpow_of_exponent_le hX1.le hθlo
    linarith
  have hXε : (2:ℝ) < X * ε := by
    rw [mul_comm, hεX]; linarith
  have hεε₀ : ε < ε₀ := by
    rw [hεdef, inv_lt_iff_one_lt_mul₀ hP0]
    have hlt : (1 / ε₀) ^ (1 - θ)⁻¹ < X := by linarith
    have hinv : 1 / ε₀ < X ^ (1 - θ) := by
      have h := Real.rpow_lt_rpow (by positivity) hlt h1θ
      rwa [Real.rpow_inv_rpow (by positivity) h1θ.ne'] at h
    rw [div_lt_iff₀ hε₀0] at hinv
    linarith [hinv]
  -- the three error pieces
  have hclose := hCclose X hX3 ε hε hε1 hXε
  have hB1 := hC1 ε hε hε1 X hX3 (T := X) hX3
  have hB9 := hC9 hε hε1 X hX3 (T := X) hX3
  have hmainB := hCmainB ε hε hεε₀
  -- Mellin instantiations
  have hMv := mellin_vert_le_theta hθlo hθhi diffν suppν hB hε hε1 hLX
  have hσθpos : 0 < σθ θ X := by
    have := lt_σθ (θ := θ) hLpos; linarith
  have hquarter : 1 / Real.log X ≤ 1 / 4 := by
    rw [div_le_div_iff₀ hLpos (by norm_num)]; linarith
  have hMh8 : ∀ σ : ℝ, σθ θ X ≤ σ → σ ≤ 1 + 1 / Real.log X →
      ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) + I * (X : ℂ))‖ ≤ B / X := by
    intro σ hσ1 hσ2
    have hσ0 : 0 < σ := lt_of_lt_of_le hσθpos hσ1
    have hσ2' : σ ≤ 2 := by linarith
    exact RHPull.mellin_horiz_le diffν suppν hB hε hε1 hX hσ0 hσ2'
  have hMh2 : ∀ σ : ℝ, σθ θ X ≤ σ → σ ≤ 1 + 1 / Real.log X →
      ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) ((σ : ℂ) - (X : ℂ) * I)‖ ≤ B / X := by
    intro σ hσ1 hσ2
    have hσ0 : 0 < σ := lt_of_lt_of_le hσθpos hσ1
    have hσ2' : σ ≤ 2 := by linarith
    exact RHPull.mellin_horiz_le_neg diffν suppν hB hε hε1 hX hσ0 hσ2'
  have hcontour := contour_at_instantiation_theta hθ hθlo hθhi hε hε1 hX3 hX hLX
    (by linarith) (le_refl X) hB0.le suppν νnonneg mass_one diffν hB1 hB9 hMv hMh8 hMh2
  -- main-term piece
  have hmain : ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 * (X : ℂ) - (X : ℂ)‖
      ≤ Cmain * ε * X := by
    have hfac : mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 * (X : ℂ) - (X : ℂ)
        = (mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 - 1) * (X : ℂ) := by ring
    rw [hfac, norm_mul, Complex.norm_real, Real.norm_of_nonneg hX.le]
    calc ‖mellin (fun x ↦ (Smooth1 ν ε x : ℂ)) 1 - 1‖ * X ≤ (Cmain * ε) * X := by
          gcongr
      _ = Cmain * ε * X := by ring
  have htri := RHPull.psi_sub_self_le hclose hcontour hmain
  rw [RHPull.rpow_one_add hX hL4] at htri
  -- horizontal pieces: length 1 − θ ≤ 1/2, then the RH-shaped bound
  have hh := RHPull.horiz_small (X := X) (B := B) hX hLX5 hB0.le
  have hlog84 : (0:ℝ) ≤ Real.log (84 * X) := Real.log_nonneg (by linarith)
  have hKh0 : (0:ℝ) ≤ (1996 * Real.log (84 * X) + (29 * Real.log X + 129) * Real.log X)
      * (B / X) * (Real.exp 1 * X) := by
    have := Real.exp_pos 1
    positivity
  have hhalf : (1:ℝ) - θ ≤ 1 / 2 := by linarith
  have hh' : (1 / (2 * Real.pi)) * (1 - θ)
        * ((1996 * Real.log (84 * X) + (29 * Real.log X + 129) * Real.log X)
            * (B / X) * (Real.exp 1 * X))
      ≤ (900 * Real.exp 1 * B / Real.pi) * (Real.log X) ^ 2 := by
    refine le_trans ?_ hh
    have hpi0 : (0:ℝ) ≤ 1 / (2 * Real.pi) := by have := Real.pi_pos; positivity
    gcongr
  have hQ1 : (1:ℝ) ≤ X ^ θ := by linarith
  have hS : (0:ℝ) ≤ X ^ θ * (Real.log X) ^ 3 := by positivity
  have hL3 : (0:ℝ) ≤ (Real.log X) ^ 3 := by positivity
  have hcube : (Real.log X) ^ 2 ≤ X ^ θ * (Real.log X) ^ 3 := by
    have h1 : (Real.log X) ^ 2 ≤ (Real.log X) ^ 3 :=
      pow_le_pow_right₀ hL1 (by norm_num)
    have h2 : (Real.log X) ^ 3 ≤ X ^ θ * (Real.log X) ^ 3 :=
      le_mul_of_one_le_left hL3 hQ1
    exact le_trans h1 h2
  have hK : (0:ℝ) ≤ 900 * Real.exp 1 * B / Real.pi := by
    have := Real.exp_pos 1; have := Real.pi_pos; positivity
  have hhoriz : (900 * Real.exp 1 * B / Real.pi) * (Real.log X) ^ 2
      ≤ (900 * Real.exp 1 * B / Real.pi) * (X ^ θ * (Real.log X) ^ 3) :=
    mul_le_mul_of_nonneg_left hcube hK
  -- the five summands, each in X^θ·log³X form
  have harith := fun c (hc : 0 ≤ c) =>
    theta_instantiation_arithmetic (X := X) (θ := θ) (c := c) hX1 hθlo hθhi.le hL1 hc
  have e1 : Cclose * ε * X * Real.log X ≤ Cclose * X ^ θ * (Real.log X) ^ 3 := by
    rw [hεdef]
    exact (harith Cclose hCclose0.le).1
  have e2 : C1 * X * Real.log X / (ε * X) ≤ C1 * X ^ θ * (Real.log X) ^ 3 := by
    rw [hεdef]
    exact (harith C1 hC10.le).2.1
  have e3 : C9 * X * Real.log X / (ε * X) ≤ C9 * X ^ θ * (Real.log X) ^ 3 := by
    rw [hεdef]
    exact (harith C9 hC90.le).2.1
  have e4 : Cmain * ε * X ≤ Cmain * X ^ θ * (Real.log X) ^ 3 := by
    have h := (harith Cmain hCmain0.le).2.2
    rw [hεdef]
    calc Cmain * (X ^ (1 - θ))⁻¹ * X = Cmain * ((X ^ (1 - θ))⁻¹ * X) := by ring
      _ ≤ Cmain * X ^ θ * (Real.log X) ^ 3 := h
  linarith only [htri, hh', e1, e2, e3, e4, hhoriz, hS]

/-! ## The weld at `θ = 1/2` -/

/-- **`psi_weak_of_RH` recovered.** At `θ = 1/2` under RH, the general bound
is `RHPull.psi_weak_of_RH`'s statement, `√t` included. -/
theorem psi_weak_of_RH_half (hRH : RiemannHypothesis) :
    ∃ C > 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t →
      |ψ t - t| ≤ C * Real.sqrt t * (Real.log t) ^ 3 := by
  obtain ⟨C, hC, x₀, h⟩ :=
    psi_weak_of_theta (θ := 1/2) (zeroFreeRight_of_RH hRH) le_rfl (by norm_num)
  refine ⟨C, hC, x₀, fun t ht => ?_⟩
  rw [Real.sqrt_eq_rpow]
  exact h t ht

/-- `StmtPsiWeak` at `k = 3` from RH, through the `θ`-dial. Same statement as
`RHPull.stmtPsiWeak_of_RH`. -/
theorem stmtPsiWeak_of_RH_half (hRH : RiemannHypothesis) :
    ∃ C > 0, ∃ x₀ : ℝ, Stage3.StmtPsiWeak C 3 x₀ :=
  psi_weak_of_RH_half hRH

end

/-! ## Axiom check -/

/-- info: 'Stage3.pull_at_theta_abscissa' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.pull_at_theta_abscissa

/-- info: 'Stage3.contour_at_instantiation_theta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.contour_at_instantiation_theta

/-- info: 'Stage3.psi_weak_of_theta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.psi_weak_of_theta

/-- info: 'Stage3.psi_weak_of_RH_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.psi_weak_of_RH_half

/-- info: 'Stage3.stmtPsiWeak_of_RH_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.stmtPsiWeak_of_RH_half

end Stage3
