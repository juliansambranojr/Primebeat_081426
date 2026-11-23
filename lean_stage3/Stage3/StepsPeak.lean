/-
StepsPeak — block R5 of `lean_stage3/design/runs.md`. 2026-11-23.

The first size of unit 0472: the turned steps up to a cutoff `N`, with the ramp
`1 − n/N`, stand at height `m·log N` at a zero of order `m`.

`f(u) = u^(−s)·(1 − u/N)`, `S(N,s) = Σ_{n≤N} Λ(n)·f(n)`, `g = −f'`. Since `f(N) = 0`,
partial summation gives `S(N,s) = ∫_2^N g·ψ`. The explicit formula from `x = 2`
(`ExplicitTwo.explicit_formula_all_two`) writes `ψ(u) = u − Σ_{|γ|<T} m·u^ρ/ρ + E(u,T)`,
and each power `u^a` integrates against `g` to the kernel `K(a)`.

  ramp, slope, S, K     f, g, the turned steps with the ramp, the kernel ∫_2^N u^a·g
  S_eq_integral         S(N,s) = ∫_2^N g·ψ (Mathlib's `sum_mul_eq_sub_integral_mul₁`)
  peak_identity         S − K(1) + Σ_{|γ|<T} (m/ρ)·K(ρ) = ∫_2^N g·E
  norm_slope_le         ‖g(u)‖ ≤ (‖s‖+‖s−1‖)·u^(−σ−1) on [1, N]
  C1, norm_error_le     ‖∫_2^N g·E‖ ≤ (‖s‖+‖s−1‖)·(c1t·N·log²(NT)/T + C₁(σ))
  peak_formula          the identity with the error bound
  K_eq, K_self          K in closed form, for a ≠ s, s−1, and at a = s
  peak_at_zero          at s = ρ₀ the term −m₀·log N + m₀·log 2 + m₀·(ρ₀−1)(N−2)/(ρ₀N)
                          split out of the sum
  norm_K_le             Re a ≤ Re s ⊢ ‖K(a)‖ ≤ (‖s‖/‖a−s‖ + ‖s−1‖/‖a−s+1‖)·2, free of N
  peak_height           no zero below T right of ρ₀ ⊢ S − K(1) + m₀·log N is bounded by
                          m₀·log 2 + m₀·‖ρ₀−1‖/‖ρ₀‖ + a sum over the zeros below T free
                          of N + the error

The constant `C₁(σ) = (c3t·(2/σ) + Bleft2)·(2/σ)` bounds `c3t·A₁(σ) + Bleft2·A₂(σ)` of the
design block through `log u ≤ u^(σ/2)/(σ/2)` and `u^(−σ−5/4) ≤ u^(−σ/2−1)`, both
integrated as `∫_2^N u^(−σ/2−1) ≤ 2/σ`. The weight of a zero is `riemannZeta.order`.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.StepsPole
import Stage3.ExplicitTwo
import Stage3.FixedRowTwo

namespace StepsPeak

open Finset MeasureTheory Kadiri
open scoped Chebyshev

noncomputable section

/-- The ramp `f(u) = u^(−s)·(1 − u/N)`. -/
def ramp (N : ℕ) (s : ℂ) (u : ℝ) : ℂ := (u : ℂ) ^ (-s) * (1 - (u : ℂ) / (N : ℂ))

/-- Minus its slope, `g(u) = s·u^(−s−1) − (s−1)·u^(−s)/N`. -/
def slope (N : ℕ) (s : ℂ) (u : ℝ) : ℂ :=
  s * (u : ℂ) ^ (-s - 1) - (s - 1) * (u : ℂ) ^ (-s) / (N : ℂ)

/-- The turned steps to the cutoff `N`, with the ramp:
`S(N,s) = Σ_{n ≤ N} Λ(n)·n^(−s)·(1 − n/N)`. -/
def S (N : ℕ) (s : ℂ) : ℂ :=
  ∑ n ∈ Icc 0 N, ramp N s n * (ArithmeticFunction.vonMangoldt n : ℂ)

/-- The kernel of a power, `K(a) = ∫_2^N u^a·g(u) du`. -/
def K (N : ℕ) (s a : ℂ) : ℂ := ∫ u in (2:ℝ)..(N:ℝ), (u : ℂ) ^ a * slope N s u

theorem hasDerivAt_ramp {N : ℕ} {s : ℂ} (hs : s ≠ 0) {u : ℝ} (hu : 0 < u) :
    HasDerivAt (ramp N s) (-slope N s u) u := by
  have hu0 : u ≠ 0 := hu.ne'
  have h1 := hasDerivAt_ofReal_cpow_const hu0 (neg_ne_zero.mpr hs)
  have h2 : HasDerivAt (fun y : ℝ => (1 : ℂ) - (y : ℂ) / (N : ℂ)) (-(1 / (N : ℂ))) u := by
    have := ((Complex.ofRealCLM.hasDerivAt (x := u)).div_const (N : ℂ)).const_sub 1
    simpa using this
  have h := h1.mul h2
  have e : (u : ℂ) ^ (-s) = (u : ℂ) ^ (-s - 1) * (u : ℂ) := by
    have hc : (u : ℂ) ≠ 0 := by exact_mod_cast hu0
    conv_lhs => rw [show -s = (-s - 1) + 1 by ring]
    rw [Complex.cpow_add _ _ hc, Complex.cpow_one]
  refine h.congr_deriv ?_
  unfold slope
  rw [e]
  ring

/-- A power is continuous right of `0`. -/
theorem cont_cpow (c : ℂ) : ContinuousOn (fun y : ℝ => (y : ℂ) ^ c) (Set.Ioi 0) := by
  intro t ht
  exact (Complex.continuousAt_ofReal_cpow_const t c (Or.inr (ne_of_gt ht))).continuousWithinAt

theorem cont_slope (N : ℕ) (s : ℂ) : ContinuousOn (slope N s) (Set.Ioi 0) := by
  unfold slope
  exact (continuousOn_const.mul (cont_cpow _)).sub
    ((continuousOn_const.mul (cont_cpow _)).div_const _)

theorem uIcc_sub {N : ℕ} (hN : 2 ≤ N) : Set.uIcc (2:ℝ) N ⊆ Set.Ioi 0 := by
  have hN' : (2:ℝ) ≤ N := by exact_mod_cast hN
  rw [Set.uIcc_of_le hN']
  intro t ht
  exact lt_of_lt_of_le (by norm_num) ht.1

/-- **Partial summation.** `f(N) = 0`, so `S(N,s) = ∫_2^N g·ψ`. -/
theorem S_eq_integral {N : ℕ} (hN : 2 ≤ N) {s : ℂ} (hs : 0 < s.re) :
    S N s = ∫ u in (2:ℝ)..(N:ℝ), slope N s u * ((ψ u : ℝ) : ℂ) := by
  have hs0 : s ≠ 0 := by
    intro h; rw [h] at hs; simp at hs
  have hN' : (2:ℝ) ≤ N := by exact_mod_cast hN
  have hdiff : ∀ t ∈ Set.Icc (2:ℝ) N, DifferentiableAt ℝ (ramp N s) t := fun t ht =>
    (hasDerivAt_ramp hs0 (lt_of_lt_of_le (by norm_num) ht.1)).differentiableAt
  have hint : IntegrableOn (deriv (ramp N s)) (Set.Icc (2:ℝ) N) := by
    have hc : ContinuousOn (fun u => -slope N s u) (Set.Icc (2:ℝ) N) :=
      ((cont_slope N s).mono (fun t ht => lt_of_lt_of_le (by norm_num) ht.1)).neg
    refine (hc.integrableOn_Icc).congr_fun ?_ measurableSet_Icc
    intro t ht
    exact ((hasDerivAt_ramp hs0 (lt_of_lt_of_le (by norm_num) ht.1)).deriv).symm
  have hA := sum_mul_eq_sub_integral_mul₁ (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
    (by simp) (by simp) (N:ℝ) hdiff hint
  rw [Nat.floor_natCast] at hA
  unfold S
  rw [hA]
  have hN0 : (N : ℂ) ≠ 0 := by
    have : (N:ℝ) ≠ 0 := by linarith
    exact_mod_cast this
  have hr : ramp N s (N:ℝ) = 0 := by
    unfold ramp
    rw [Complex.ofReal_natCast, div_self hN0, sub_self, mul_zero]
  rw [hr, zero_mul, zero_sub, intervalIntegral.integral_of_le hN', ← integral_neg]
  refine setIntegral_congr_fun measurableSet_Ioc ?_
  intro t ht
  have ht0 : 0 < t := lt_of_lt_of_le (by norm_num) (le_of_lt ht.1)
  simp only []
  rw [(hasDerivAt_ramp hs0 ht0).deriv, Chebyshev.psi_eq_sum_Icc]
  push_cast
  ring

/-- **The identity.** With `E(u,T) = ψ(u) − u + Σ_{|γ|<T} m·u^ρ/ρ` the remainder of the
explicit formula, `S(N,s) = K(1) − Σ_{|γ|<T} (m/ρ)·K(ρ) + ∫_2^N E·g`. -/
theorem peak_identity {N : ℕ} (hN : 2 ≤ N) {s : ℂ} (hs : 0 < s.re) (T : ℝ) :
    S N s - K N s 1
      + ∑ ρ ∈ FiniteOffLine.ZF T,
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * K N s (ρ : ℂ)
      = ∫ u in (2:ℝ)..(N:ℝ), slope N s u * PiZeros.efRem T u := by
  rw [S_eq_integral hN hs]
  have hψ := PiZeros.integrable_ofReal_of_monotone Chebyshev.psi_mono (N:ℝ)
  have hsl : ContinuousOn (slope N s) (Set.uIcc (2:ℝ) N) := (cont_slope N s).mono (uIcc_sub hN)
  have h1 : IntervalIntegrable (fun u => slope N s u * ((ψ u : ℝ) : ℂ)) volume 2 (N:ℝ) :=
    hψ.continuousOn_mul hsl
  have hK1 : IntervalIntegrable (fun u : ℝ => (u:ℂ) ^ (1:ℂ) * slope N s u) volume 2 (N:ℝ) :=
    ContinuousOn.intervalIntegrable (((cont_cpow 1).mono (uIcc_sub hN)).mul hsl)
  have hZc : ∀ ρ ∈ FiniteOffLine.ZF T, ContinuousOn (fun u : ℝ =>
      ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * ((u:ℂ) ^ (ρ : ℂ) * slope N s u))
      (Set.uIcc (2:ℝ) N) := fun ρ _ =>
    continuousOn_const.mul (((cont_cpow _).mono (uIcc_sub hN)).mul hsl)
  have hZ : ∑ ρ ∈ FiniteOffLine.ZF T,
        ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * K N s (ρ : ℂ)
      = ∫ u in (2:ℝ)..(N:ℝ), ∑ ρ ∈ FiniteOffLine.ZF T,
        ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * ((u:ℂ) ^ (ρ : ℂ) * slope N s u) := by
    rw [intervalIntegral.integral_finsetSum (fun ρ hρ => (hZc ρ hρ).intervalIntegrable)]
    refine Finset.sum_congr rfl (fun ρ _ => ?_)
    unfold K
    rw [intervalIntegral.integral_const_mul]
  have hZint : IntervalIntegrable (fun u : ℝ => ∑ ρ ∈ FiniteOffLine.ZF T,
        ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * ((u:ℂ) ^ (ρ : ℂ) * slope N s u))
      volume 2 (N:ℝ) :=
    ContinuousOn.intervalIntegrable (continuousOn_finsetSum _ hZc)
  rw [hZ]
  unfold K
  rw [← intervalIntegral.integral_sub h1 hK1, ← intervalIntegral.integral_add (h1.sub hK1) hZint]
  refine intervalIntegral.integral_congr (fun u _ => ?_)
  unfold PiZeros.efRem
  rw [PiZeros.zeroPartialSum_eq_sum, Complex.cpow_one, mul_add, mul_sub, Finset.mul_sum]
  congr 1
  · ring
  · refine Finset.sum_congr rfl (fun ρ _ => ?_)
    ring

/-- The size of `g` on `[1, N]`: `‖g(u)‖ ≤ (‖s‖ + ‖s−1‖)·u^(−σ−1)`. -/
theorem norm_slope_le {N : ℕ} {s : ℂ} {u : ℝ} (hu : 1 ≤ u) (huN : u ≤ N) :
    ‖slope N s u‖ ≤ (‖s‖ + ‖s - 1‖) * u ^ (-s.re - 1) := by
  have hu0 : 0 < u := lt_of_lt_of_le one_pos hu
  have hN0 : (0:ℝ) < N := lt_of_lt_of_le hu0 huN
  unfold slope
  refine (norm_sub_le _ _).trans ?_
  rw [norm_mul, norm_div, norm_mul, Complex.norm_cpow_eq_rpow_re_of_pos hu0,
    Complex.norm_cpow_eq_rpow_re_of_pos hu0, Complex.norm_natCast]
  have e1 : (-s - 1).re = -s.re - 1 := by simp
  have e2 : (-s).re = -s.re := by simp
  rw [e1, e2]
  have h3 : u ^ (-s.re) / (N:ℝ) ≤ u ^ (-s.re - 1) := by
    rw [Real.rpow_sub_one hu0.ne']
    exact div_le_div_of_nonneg_left (by positivity) hu0 huN
  have h4 : ‖s - 1‖ * u ^ (-s.re) / (N:ℝ) ≤ ‖s - 1‖ * u ^ (-s.re - 1) := by
    rw [mul_div_assoc]
    exact mul_le_mul_of_nonneg_left h3 (norm_nonneg _)
  linarith

/-- The constant of the error, a function of `σ = Re s` alone:
`C₁(σ) = (c3t·(2/σ) + Bleft2)·(2/σ)`. -/
def C1 (σ : ℝ) : ℝ := (ExplicitTwo.c3t * (2 / σ) + ExplicitTwo.Bleft2) * (2 / σ)

/-- The integrand of the error, pointwise on `[2, N]`. -/
theorem norm_integrand_le {N : ℕ} {s : ℂ} (hs : 0 < s.re) {T : ℝ} (hT : 2 ≤ T) {u : ℝ}
    (hu : 2 ≤ u) (huN : u ≤ N) :
    ‖slope N s u * PiZeros.efRem T u‖
      ≤ (‖s‖ + ‖s - 1‖) * (ExplicitTwo.c1t * Real.log ((N:ℝ) * T) ^ 2 / T
          + (ExplicitTwo.c3t * (2 / s.re) + ExplicitTwo.Bleft2) * u ^ (-s.re / 2 - 1)) := by
  set σ := s.re with hσ
  have hu0 : 0 < u := by linarith
  have hT0 : 0 < T := by linarith
  have hc1 := FixedRowTwo.c1t_nonneg
  have hc3 := FixedRowTwo.c3t_nonneg
  have hB := FixedRowTwo.Bleft2_nonneg
  have hg := norm_slope_le (N := N) (s := s) (by linarith : (1:ℝ) ≤ u) huN
  have hE : ‖PiZeros.efRem T u‖ ≤ ExplicitTwo.c1t * u * Real.log (u*T)^2 / T
      + ExplicitTwo.c3t * Real.log u + ExplicitTwo.Bleft2 * u ^ (-(1:ℝ)/4) :=
    ExplicitTwo.explicit_formula_all_two hu hT
  have hA : 0 ≤ ‖s‖ + ‖s - 1‖ := by positivity
  have hp : 0 ≤ u ^ (-σ - 1) := by positivity
  -- the three pieces
  have hLu0 : 0 ≤ Real.log (u * T) := Real.log_nonneg (by nlinarith)
  have hLu : Real.log (u * T) ^ 2 ≤ Real.log ((N:ℝ) * T) ^ 2 := by
    apply pow_le_pow_left₀ hLu0
    exact Real.log_le_log (by positivity) (by nlinarith)
  have e1 : u ^ (-σ - 1) * u = u ^ (-σ) := by
    rw [← Real.rpow_add_one hu0.ne']
    ring_nf
  have h1 : u ^ (-σ) ≤ 1 := Real.rpow_le_one_of_one_le_of_nonpos (by linarith) (by linarith)
  have t1 : u ^ (-σ - 1) * (ExplicitTwo.c1t * u * Real.log (u*T)^2 / T)
      ≤ ExplicitTwo.c1t * Real.log ((N:ℝ) * T) ^ 2 / T := by
    have e : u ^ (-σ - 1) * (ExplicitTwo.c1t * u * Real.log (u*T)^2 / T)
        = (u ^ (-σ - 1) * u) * (ExplicitTwo.c1t * Real.log (u*T)^2 / T) := by ring
    rw [e, e1]
    have h2 : ExplicitTwo.c1t * Real.log (u*T)^2 / T
        ≤ ExplicitTwo.c1t * Real.log ((N:ℝ) * T) ^ 2 / T :=
      div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left hLu hc1) hT0.le
    have h3 : 0 ≤ ExplicitTwo.c1t * Real.log (u*T)^2 / T := by positivity
    calc u ^ (-σ) * (ExplicitTwo.c1t * Real.log (u*T)^2 / T)
        ≤ 1 * (ExplicitTwo.c1t * Real.log ((N:ℝ) * T) ^ 2 / T) :=
          mul_le_mul h1 h2 h3 zero_le_one
      _ = _ := one_mul _
  have e2 : u ^ (-σ - 1) * u ^ (σ / 2) = u ^ (-σ / 2 - 1) := by
    rw [← Real.rpow_add hu0]
    congr 1
    ring
  have t2 : u ^ (-σ - 1) * (ExplicitTwo.c3t * Real.log u)
      ≤ ExplicitTwo.c3t * (2 / σ) * u ^ (-σ / 2 - 1) := by
    have hl : Real.log u ≤ u ^ (σ / 2) / (σ / 2) :=
      Real.log_le_rpow_div hu0.le (by linarith)
    have hl' : ExplicitTwo.c3t * Real.log u ≤ ExplicitTwo.c3t * (u ^ (σ / 2) / (σ / 2)) :=
      mul_le_mul_of_nonneg_left hl hc3
    calc u ^ (-σ - 1) * (ExplicitTwo.c3t * Real.log u)
        ≤ u ^ (-σ - 1) * (ExplicitTwo.c3t * (u ^ (σ / 2) / (σ / 2))) :=
          mul_le_mul_of_nonneg_left hl' hp
      _ = ExplicitTwo.c3t * (2 / σ) * (u ^ (-σ - 1) * u ^ (σ / 2)) := by
          field_simp
          try ring
      _ = _ := by rw [e2]
  have t3 : u ^ (-σ - 1) * (ExplicitTwo.Bleft2 * u ^ (-(1:ℝ)/4))
      ≤ ExplicitTwo.Bleft2 * u ^ (-σ / 2 - 1) := by
    have e3 : u ^ (-σ - 1) * u ^ (-(1:ℝ)/4) = u ^ (-σ - 1 + -(1:ℝ)/4) :=
      (Real.rpow_add hu0 _ _).symm
    have h4 : u ^ (-σ - 1 + -(1:ℝ)/4) ≤ u ^ (-σ / 2 - 1) :=
      Real.rpow_le_rpow_of_exponent_le (by linarith) (by linarith)
    calc u ^ (-σ - 1) * (ExplicitTwo.Bleft2 * u ^ (-(1:ℝ)/4))
        = ExplicitTwo.Bleft2 * (u ^ (-σ - 1) * u ^ (-(1:ℝ)/4)) := by ring
      _ ≤ _ := by rw [e3]; exact mul_le_mul_of_nonneg_left h4 hB
  have key : u ^ (-σ - 1) * (ExplicitTwo.c1t * u * Real.log (u*T)^2 / T
      + ExplicitTwo.c3t * Real.log u + ExplicitTwo.Bleft2 * u ^ (-(1:ℝ)/4))
      ≤ ExplicitTwo.c1t * Real.log ((N:ℝ) * T) ^ 2 / T
          + (ExplicitTwo.c3t * (2 / σ) + ExplicitTwo.Bleft2) * u ^ (-σ / 2 - 1) := by
    have e : u ^ (-σ - 1) * (ExplicitTwo.c1t * u * Real.log (u*T)^2 / T
        + ExplicitTwo.c3t * Real.log u + ExplicitTwo.Bleft2 * u ^ (-(1:ℝ)/4))
        = u ^ (-σ - 1) * (ExplicitTwo.c1t * u * Real.log (u*T)^2 / T)
          + u ^ (-σ - 1) * (ExplicitTwo.c3t * Real.log u)
          + u ^ (-σ - 1) * (ExplicitTwo.Bleft2 * u ^ (-(1:ℝ)/4)) := by ring
    rw [e]
    nlinarith [t1, t2, t3]
  rw [norm_mul]
  calc ‖slope N s u‖ * ‖PiZeros.efRem T u‖
      ≤ ((‖s‖ + ‖s - 1‖) * u ^ (-σ - 1)) * (ExplicitTwo.c1t * u * Real.log (u*T)^2 / T
          + ExplicitTwo.c3t * Real.log u + ExplicitTwo.Bleft2 * u ^ (-(1:ℝ)/4)) :=
        mul_le_mul hg hE (norm_nonneg _) (by positivity)
    _ = (‖s‖ + ‖s - 1‖) * (u ^ (-σ - 1) * (ExplicitTwo.c1t * u * Real.log (u*T)^2 / T
          + ExplicitTwo.c3t * Real.log u + ExplicitTwo.Bleft2 * u ^ (-(1:ℝ)/4))) := by ring
    _ ≤ _ := mul_le_mul_of_nonneg_left key hA

/-- **The error.** `‖∫_2^N E·g‖ ≤ (‖s‖+‖s−1‖)·(c1t·N·log²(NT)/T + C₁(σ))`. -/
theorem norm_error_le {N : ℕ} (hN : 2 ≤ N) {s : ℂ} (hs : 0 < s.re) {T : ℝ} (hT : 2 ≤ T) :
    ‖∫ u in (2:ℝ)..(N:ℝ), slope N s u * PiZeros.efRem T u‖
      ≤ (‖s‖ + ‖s - 1‖) * (ExplicitTwo.c1t * N * Real.log ((N:ℝ) * T) ^ 2 / T + C1 s.re) := by
  set σ := s.re with hσ
  have hN' : (2:ℝ) ≤ N := by exact_mod_cast hN
  have hT0 : 0 < T := by linarith
  have hc1 := FixedRowTwo.c1t_nonneg
  have hc3 := FixedRowTwo.c3t_nonneg
  have hB := FixedRowTwo.Bleft2_nonneg
  have hA : 0 ≤ ‖s‖ + ‖s - 1‖ := by positivity
  set cN := ExplicitTwo.c1t * Real.log ((N:ℝ) * T) ^ 2 / T with hcN
  set D := ExplicitTwo.c3t * (2 / σ) + ExplicitTwo.Bleft2 with hD
  have hcN0 : 0 ≤ cN := by positivity
  have hD0 : 0 ≤ D := by positivity
  have h0 : (0:ℝ) ∉ Set.uIcc (2:ℝ) N := by
    rw [Set.uIcc_of_le hN']
    intro h
    linarith [h.1]
  have hr : IntervalIntegrable (fun u : ℝ => u ^ (-σ / 2 - 1)) volume 2 (N:ℝ) :=
    intervalIntegral.intervalIntegrable_rpow (Or.inr h0)
  have hint : IntervalIntegrable (fun u : ℝ => (‖s‖ + ‖s - 1‖) * (cN + D * u ^ (-σ / 2 - 1)))
      volume 2 (N:ℝ) :=
    ((intervalIntegrable_const).add (hr.const_mul D)).const_mul _
  have hb := intervalIntegral.norm_integral_le_of_norm_le hN'
    (Filter.Eventually.of_forall (fun u (hu : u ∈ Set.Ioc (2:ℝ) N) =>
      norm_integrand_le (N := N) hs hT (le_of_lt hu.1) hu.2)) hint
  refine hb.trans ?_
  rw [intervalIntegral.integral_const_mul,
    intervalIntegral.integral_add intervalIntegrable_const (hr.const_mul D),
    intervalIntegral.integral_const, intervalIntegral.integral_const_mul,
    integral_rpow (Or.inr ⟨by linarith, h0⟩), smul_eq_mul]
  apply mul_le_mul_of_nonneg_left _ hA
  have e1 : ((N:ℝ) - 2) * cN ≤ ExplicitTwo.c1t * N * Real.log ((N:ℝ) * T) ^ 2 / T := by
    have : ExplicitTwo.c1t * N * Real.log ((N:ℝ) * T) ^ 2 / T = (N:ℝ) * cN := by
      rw [hcN]; ring
    rw [this]
    nlinarith
  have hq : (2:ℝ) ^ (-σ / 2 - 1 + 1) ≤ 1 :=
    Real.rpow_le_one_of_one_le_of_nonpos (by norm_num) (by linarith)
  have hp : 0 ≤ (N:ℝ) ^ (-σ / 2 - 1 + 1) := by positivity
  have e2 : ((N:ℝ) ^ (-σ / 2 - 1 + 1) - (2:ℝ) ^ (-σ / 2 - 1 + 1)) / (-σ / 2 - 1 + 1)
      ≤ 2 / σ := by
    have e : ((N:ℝ) ^ (-σ / 2 - 1 + 1) - (2:ℝ) ^ (-σ / 2 - 1 + 1)) / (-σ / 2 - 1 + 1)
        = ((2:ℝ) ^ (-σ / 2 - 1 + 1) - (N:ℝ) ^ (-σ / 2 - 1 + 1)) * (2 / σ) := by
      have hσ0 : σ ≠ 0 := hs.ne'
      have h' : (-σ / 2 - 1 + 1) = -(σ / 2) := by ring
      rw [h']
      field_simp
      try ring
    rw [e]
    have h2 : 0 < 2 / σ := by positivity
    nlinarith
  have e3 : D * (((N:ℝ) ^ (-σ / 2 - 1 + 1) - (2:ℝ) ^ (-σ / 2 - 1 + 1)) / (-σ / 2 - 1 + 1))
      ≤ C1 σ := by
    unfold C1
    rw [← hD]
    exact mul_le_mul_of_nonneg_left e2 hD0
  linarith

/-- **The height of the peak, as a formula.** For `Re s > 0`, `N ≥ 2`, `T ≥ 2`:
`‖S(N,s) − K(1) + Σ_{|γ|<T} (m/ρ)·K(ρ)‖ ≤ (‖s‖+‖s−1‖)·(c1t·N·log²(NT)/T + C₁(Re s))`. -/
theorem peak_formula {N : ℕ} (hN : 2 ≤ N) {s : ℂ} (hs : 0 < s.re) {T : ℝ} (hT : 2 ≤ T) :
    ‖S N s - K N s 1
      + ∑ ρ ∈ FiniteOffLine.ZF T,
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * K N s (ρ : ℂ)‖
      ≤ (‖s‖ + ‖s - 1‖) * (ExplicitTwo.c1t * N * Real.log ((N:ℝ) * T) ^ 2 / T + C1 s.re) := by
  rw [peak_identity hN hs T]
  exact norm_error_le hN hs hT

/-- info: 'StepsPeak.peak_formula' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms peak_formula

theorem h0_not_mem {N : ℕ} (hN : 2 ≤ N) : (0:ℝ) ∉ Set.uIcc (2:ℝ) N := by
  have hN' : (2:ℝ) ≤ N := by exact_mod_cast hN
  rw [Set.uIcc_of_le hN']
  intro h
  linarith [h.1]

/-- **The kernel in closed form**, for `a ≠ s` and `a ≠ s − 1`. -/
theorem K_eq {N : ℕ} (hN : 2 ≤ N) {s a : ℂ} (h1 : a ≠ s) (h2 : a ≠ s - 1) :
    K N s a = s * ((N:ℂ) ^ (a - s) - 2 ^ (a - s)) / (a - s)
      - (s - 1) * ((N:ℂ) ^ (a - s + 1) - 2 ^ (a - s + 1)) / ((a - s + 1) * N) := by
  have h0 := h0_not_mem hN
  have hN0 : (N:ℂ) ≠ 0 := by
    have : (N:ℝ) ≠ 0 := by
      have : (2:ℝ) ≤ N := by exact_mod_cast hN
      linarith
    exact_mod_cast this
  have has : a - s ≠ 0 := sub_ne_zero.mpr h1
  have has1 : a - s + 1 ≠ 0 := fun h => h2 (by linear_combination h)
  unfold K
  have hc : ∀ u ∈ Set.uIcc (2:ℝ) N, (u:ℂ) ^ a * slope N s u
      = s * (u:ℂ) ^ (a - s - 1) - ((s - 1) / N) * (u:ℂ) ^ (a - s) := by
    intro u hu
    have hu0 : (u:ℂ) ≠ 0 := by
      have : u ≠ 0 := fun h => h0 (h ▸ hu)
      exact_mod_cast this
    have ea : (u:ℂ) ^ a * (u:ℂ) ^ (-s - 1) = (u:ℂ) ^ (a - s - 1) := by
      rw [← Complex.cpow_add _ _ hu0]; congr 1; ring
    have eb : (u:ℂ) ^ a * (u:ℂ) ^ (-s) = (u:ℂ) ^ (a - s) := by
      rw [← Complex.cpow_add _ _ hu0, sub_eq_add_neg]
    unfold slope
    calc (u:ℂ) ^ a * (s * (u:ℂ) ^ (-s - 1) - (s - 1) * (u:ℂ) ^ (-s) / (N:ℂ))
        = s * ((u:ℂ) ^ a * (u:ℂ) ^ (-s - 1)) - ((s - 1) / N) * ((u:ℂ) ^ a * (u:ℂ) ^ (-s)) := by
          ring
      _ = _ := by rw [ea, eb]
  rw [intervalIntegral.integral_congr hc,
    intervalIntegral.integral_sub ((intervalIntegral.intervalIntegrable_cpow (Or.inr h0)).const_mul _)
      ((intervalIntegral.intervalIntegrable_cpow (Or.inr h0)).const_mul _),
    intervalIntegral.integral_const_mul, intervalIntegral.integral_const_mul,
    integral_cpow (Or.inr ⟨fun h => has (by linear_combination h), h0⟩),
    integral_cpow (Or.inr ⟨fun h => has1 (by linear_combination h), h0⟩)]
  rw [show a - s - 1 + 1 = a - s by ring, Complex.ofReal_natCast, Complex.ofReal_ofNat]
  field_simp
  try ring

/-- **The kernel at `a = s`**: `K(s) = s·(log N − log 2) − (s−1)·(N−2)/N`. -/
theorem K_self {N : ℕ} (hN : 2 ≤ N) (s : ℂ) :
    K N s s = s * ((Real.log N - Real.log 2 : ℝ) : ℂ) - (s - 1) * ((N:ℂ) - 2) / N := by
  have h0 := h0_not_mem hN
  have hN' : (2:ℝ) ≤ N := by exact_mod_cast hN
  have hN0 : (N:ℂ) ≠ 0 := by
    have : (N:ℝ) ≠ 0 := by linarith
    exact_mod_cast this
  unfold K
  have hc : ∀ u ∈ Set.uIcc (2:ℝ) N, (u:ℂ) ^ s * slope N s u
      = s * ((u⁻¹ : ℝ) : ℂ) - (s - 1) / N := by
    intro u hu
    have hu0 : (u:ℂ) ≠ 0 := by
      have : u ≠ 0 := fun h => h0 (h ▸ hu)
      exact_mod_cast this
    have ea : (u:ℂ) ^ s * (u:ℂ) ^ (-s - 1) = ((u⁻¹ : ℝ) : ℂ) := by
      rw [← Complex.cpow_add _ _ hu0, show s + (-s - 1) = -1 by ring, Complex.cpow_neg_one,
        Complex.ofReal_inv]
    have eb : (u:ℂ) ^ s * (u:ℂ) ^ (-s) = 1 := by
      rw [← Complex.cpow_add _ _ hu0, show s + -s = 0 by ring, Complex.cpow_zero]
    unfold slope
    calc (u:ℂ) ^ s * (s * (u:ℂ) ^ (-s - 1) - (s - 1) * (u:ℂ) ^ (-s) / (N:ℂ))
        = s * ((u:ℂ) ^ s * (u:ℂ) ^ (-s - 1)) - ((s - 1) / N) * ((u:ℂ) ^ s * (u:ℂ) ^ (-s)) := by
          ring
      _ = _ := by rw [ea, eb, mul_one]
  have hinv : IntervalIntegrable (fun u : ℝ => ((u⁻¹ : ℝ) : ℂ)) volume 2 (N:ℝ) := by
    apply ContinuousOn.intervalIntegrable
    refine Complex.continuous_ofReal.comp_continuousOn (continuousOn_inv₀.mono ?_)
    intro u hu h
    exact h0 (by rw [Set.mem_singleton_iff] at h; exact h ▸ hu)
  rw [intervalIntegral.integral_congr hc,
    intervalIntegral.integral_sub (hinv.const_mul _) intervalIntegrable_const,
    intervalIntegral.integral_const_mul, intervalIntegral.integral_const,
    intervalIntegral.integral_ofReal, integral_inv h0,
    Real.log_div (by linarith) (by norm_num), Complex.real_smul]
  push_cast
  field_simp
  try ring

/-- info: 'StepsPeak.K_self' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms K_self

/-- **The peak at a zero.** At `s = ρ₀`, a nontrivial zero of order `m₀` below the height
`T`, its own term is `−m₀·log N + m₀·log 2 + m₀·(ρ₀−1)·(N−2)/(ρ₀·N)` and the sum runs
over the other zeros below `T`. -/
theorem peak_at_zero {N : ℕ} (hN : 2 ≤ N) (ρ₀ : NontrivialZeros) {T : ℝ} (hT : 2 ≤ T)
    (hρ₀ : |(ρ₀ : ℂ).im| < T) :
    ‖S N ρ₀ - K N ρ₀ 1
      - (-((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℂ) * (Real.log N : ℂ)
          + ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℂ) * (Real.log 2 : ℂ)
          + ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℂ) * ((ρ₀ : ℂ) - 1) * ((N : ℂ) - 2)
              / ((ρ₀ : ℂ) * N))
      + ∑ ρ ∈ (FiniteOffLine.ZF T).erase ρ₀,
          ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * K N ρ₀ (ρ : ℂ)‖
      ≤ (‖(ρ₀ : ℂ)‖ + ‖(ρ₀ : ℂ) - 1‖)
          * (ExplicitTwo.c1t * N * Real.log ((N:ℝ) * T) ^ 2 / T + C1 (ρ₀ : ℂ).re) := by
  have hs : 0 < (ρ₀ : ℂ).re := ρ₀.2.1.1
  have hmem : ρ₀ ∈ FiniteOffLine.ZF T := FiniteOffLine.mem_ZF.mpr hρ₀
  have hρ0 : (ρ₀ : ℂ) ≠ 0 := by
    intro h
    have h' := hs
    rw [h] at h'
    simp at h'
  have hN' : (2:ℝ) ≤ N := by exact_mod_cast hN
  have hN0 : (N:ℂ) ≠ 0 := by
    have : (N:ℝ) ≠ 0 := by linarith
    exact_mod_cast this
  have et : ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℂ) / (ρ₀ : ℂ) * K N ρ₀ (ρ₀ : ℂ)
      = -(-((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℂ) * (Real.log N : ℂ)
          + ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℂ) * (Real.log 2 : ℂ)
          + ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℂ) * ((ρ₀ : ℂ) - 1) * ((N : ℂ) - 2)
              / ((ρ₀ : ℂ) * N)) := by
    rw [K_self hN, Complex.ofReal_sub]
    generalize ((Real.log N : ℝ) : ℂ) = L1
    generalize ((Real.log 2 : ℝ) : ℂ) = L2
    field_simp
    try ring
  have e := peak_formula hN hs hT
  rw [← Finset.add_sum_erase _ _ hmem, et] at e
  refine Eq.trans_le (congrArg norm ?_) e
  ring

/-- info: 'StepsPeak.peak_at_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms peak_at_zero

/-- **Another zero's kernel, free of `N`.** For `a ≠ s`, `a ≠ s − 1` and `Re a ≤ Re s`:
`‖K(a)‖ ≤ (‖s‖/‖a−s‖ + ‖s−1‖/‖a−s+1‖)·2`. -/
theorem norm_K_le {N : ℕ} (hN : 2 ≤ N) {s a : ℂ} (h1 : a ≠ s) (h2 : a ≠ s - 1)
    (hre : a.re ≤ s.re) :
    ‖K N s a‖ ≤ (‖s‖ / ‖a - s‖ + ‖s - 1‖ / ‖a - s + 1‖) * 2 := by
  have hN' : (2:ℝ) ≤ N := by exact_mod_cast hN
  have hNpos : (0:ℝ) < N := by linarith
  have has1 : a - s + 1 ≠ 0 := fun h => h2 (by linear_combination h)
  have hn1 : ‖(N:ℂ) ^ (a - s)‖ ≤ 1 := by
    rw [← Complex.ofReal_natCast, Complex.norm_cpow_eq_rpow_re_of_pos hNpos]
    exact Real.rpow_le_one_of_one_le_of_nonpos (by linarith) (by simp; linarith)
  have hn2 : ‖(2:ℂ) ^ (a - s)‖ ≤ 1 := by
    rw [← Complex.ofReal_ofNat, Complex.norm_cpow_eq_rpow_re_of_pos (by norm_num)]
    exact Real.rpow_le_one_of_one_le_of_nonpos (by norm_num) (by simp; linarith)
  have hn3 : ‖(N:ℂ) ^ (a - s + 1)‖ ≤ N := by
    rw [← Complex.ofReal_natCast, Complex.norm_cpow_eq_rpow_re_of_pos hNpos]
    calc (N:ℝ) ^ (a - s + 1).re ≤ (N:ℝ) ^ (1:ℝ) :=
          Real.rpow_le_rpow_of_exponent_le (by linarith) (by simp; linarith)
      _ = N := Real.rpow_one _
  have hn4 : ‖(2:ℂ) ^ (a - s + 1)‖ ≤ N := by
    rw [← Complex.ofReal_ofNat, Complex.norm_cpow_eq_rpow_re_of_pos (by norm_num)]
    calc (2:ℝ) ^ (a - s + 1).re ≤ (2:ℝ) ^ (1:ℝ) :=
          Real.rpow_le_rpow_of_exponent_le (by norm_num) (by simp; linarith)
      _ = 2 := Real.rpow_one _
      _ ≤ N := hN'
  rw [K_eq hN h1 h2]
  refine (norm_sub_le _ _).trans ?_
  have hX : ‖s * ((N:ℂ) ^ (a - s) - 2 ^ (a - s)) / (a - s)‖ ≤ ‖s‖ / ‖a - s‖ * 2 := by
    rw [norm_div, norm_mul]
    have h : ‖(N:ℂ) ^ (a - s) - 2 ^ (a - s)‖ ≤ 2 := (norm_sub_le _ _).trans (by linarith)
    calc ‖s‖ * ‖(N:ℂ) ^ (a - s) - 2 ^ (a - s)‖ / ‖a - s‖ ≤ ‖s‖ * 2 / ‖a - s‖ :=
          div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left h (norm_nonneg _))
            (norm_nonneg _)
      _ = ‖s‖ / ‖a - s‖ * 2 := by ring
  have hY : ‖(s - 1) * ((N:ℂ) ^ (a - s + 1) - 2 ^ (a - s + 1)) / ((a - s + 1) * N)‖
      ≤ ‖s - 1‖ / ‖a - s + 1‖ * 2 := by
    rw [norm_div, norm_mul, norm_mul, Complex.norm_natCast]
    have h : ‖(N:ℂ) ^ (a - s + 1) - 2 ^ (a - s + 1)‖ ≤ 2 * N :=
      (norm_sub_le _ _).trans (by linarith)
    have hd : ‖a - s + 1‖ ≠ 0 := norm_ne_zero_iff.mpr has1
    have hN0 : (N:ℝ) ≠ 0 := hNpos.ne'
    calc ‖s - 1‖ * ‖(N:ℂ) ^ (a - s + 1) - 2 ^ (a - s + 1)‖ / (‖a - s + 1‖ * N)
        ≤ ‖s - 1‖ * (2 * N) / (‖a - s + 1‖ * N) :=
          div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left h (norm_nonneg _))
            (by positivity)
      _ = ‖s - 1‖ / ‖a - s + 1‖ * 2 := by
          field_simp
          try ring
  linarith

/-- The norm of a zero's order, read in `ℂ`. -/
theorem norm_order (ρ : NontrivialZeros) :
    ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)‖ = ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) := by
  rw [← Complex.ofReal_intCast, Complex.norm_real,
    Real.norm_of_nonneg (FiniteOffLine.order_nonneg ρ)]

/-- **The height of the peak.** If no zero below `T` lies right of `ρ₀`, then
`S(N,ρ₀) − K(1)` stands at `−m₀·log N`, up to `m₀·log 2 + m₀·‖ρ₀−1‖/‖ρ₀‖`, a sum over the
other zeros below `T` free of `N`, and the error of `peak_formula`. -/
theorem peak_height {N : ℕ} (hN : 2 ≤ N) (ρ₀ : NontrivialZeros) {T : ℝ} (hT : 2 ≤ T)
    (hρ₀ : |(ρ₀ : ℂ).im| < T)
    (hright : ∀ ρ ∈ FiniteOffLine.ZF T, (ρ : ℂ).re ≤ (ρ₀ : ℂ).re) :
    ‖S N ρ₀ - K N ρ₀ 1 + ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℂ) * (Real.log N : ℂ)‖
      ≤ ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℝ) * Real.log 2
        + ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℝ) * ‖(ρ₀ : ℂ) - 1‖ / ‖(ρ₀ : ℂ)‖
        + ∑ ρ ∈ (FiniteOffLine.ZF T).erase ρ₀,
            ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) / ‖(ρ : ℂ)‖
              * ((‖(ρ₀ : ℂ)‖ / ‖(ρ : ℂ) - ρ₀‖ + ‖(ρ₀ : ℂ) - 1‖ / ‖(ρ : ℂ) - ρ₀ + 1‖) * 2)
        + (‖(ρ₀ : ℂ)‖ + ‖(ρ₀ : ℂ) - 1‖)
          * (ExplicitTwo.c1t * N * Real.log ((N:ℝ) * T) ^ 2 / T + C1 (ρ₀ : ℂ).re) := by
  have hW := peak_at_zero hN ρ₀ hT hρ₀
  set m₀ : ℂ := ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℂ) with hm₀
  set Zo := ∑ ρ ∈ (FiniteOffLine.ZF T).erase ρ₀,
    ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) / (ρ : ℂ) * K N ρ₀ (ρ : ℂ) with hZo
  set W := S N ρ₀ - K N ρ₀ 1
      - (-m₀ * (Real.log N : ℂ) + m₀ * (Real.log 2 : ℂ)
          + m₀ * ((ρ₀ : ℂ) - 1) * ((N : ℂ) - 2) / ((ρ₀ : ℂ) * N)) + Zo with hWd
  have e : S N ρ₀ - K N ρ₀ 1 + m₀ * (Real.log N : ℂ)
      = W + m₀ * (Real.log 2 : ℂ) + m₀ * ((ρ₀ : ℂ) - 1) * ((N : ℂ) - 2) / ((ρ₀ : ℂ) * N)
        - Zo := by
    rw [hWd]; ring
  rw [e]
  have hN' : (2:ℝ) ≤ N := by exact_mod_cast hN
  have hm0 := FiniteOffLine.order_nonneg ρ₀
  have hρ0 : 0 < ‖(ρ₀ : ℂ)‖ := by
    rw [norm_pos_iff]
    intro h
    have h' := ρ₀.2.1.1
    rw [h] at h'
    simp at h'
  -- the term `m₀·log 2`
  have ha : ‖m₀ * (Real.log 2 : ℂ)‖ = ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℝ) * Real.log 2 := by
    rw [norm_mul, hm₀, norm_order, Complex.norm_real,
      Real.norm_of_nonneg (Real.log_nonneg (by norm_num))]
  -- the term `m₀·(ρ₀−1)·(N−2)/(ρ₀·N)`
  have hb : ‖m₀ * ((ρ₀ : ℂ) - 1) * ((N : ℂ) - 2) / ((ρ₀ : ℂ) * N)‖
      ≤ ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℝ) * ‖(ρ₀ : ℂ) - 1‖ / ‖(ρ₀ : ℂ)‖ := by
    have eN : (N : ℂ) - 2 = (((N:ℝ) - 2 : ℝ) : ℂ) := by push_cast; ring
    rw [norm_div, norm_mul, norm_mul, norm_mul, hm₀, norm_order, Complex.norm_natCast, eN,
      Complex.norm_real, Real.norm_of_nonneg (by linarith)]
    have hNpos : (0:ℝ) < N := by linarith
    have hq : ((N:ℝ) - 2) / N ≤ 1 := by
      rw [div_le_one hNpos]; linarith
    have hc : 0 ≤ ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℝ) * ‖(ρ₀ : ℂ) - 1‖ / ‖(ρ₀ : ℂ)‖ := by
      positivity
    calc ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℝ) * ‖(ρ₀ : ℂ) - 1‖ * ((N:ℝ) - 2)
          / (‖(ρ₀ : ℂ)‖ * N)
        = ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℝ) * ‖(ρ₀ : ℂ) - 1‖ / ‖(ρ₀ : ℂ)‖
            * (((N:ℝ) - 2) / N) := by
          field_simp
      _ ≤ ((riemannZeta.order (ρ₀ : ℂ) : ℤ) : ℝ) * ‖(ρ₀ : ℂ) - 1‖ / ‖(ρ₀ : ℂ)‖ * 1 :=
          mul_le_mul_of_nonneg_left hq hc
      _ = _ := mul_one _
  -- the other zeros
  have hZ : ‖Zo‖ ≤ ∑ ρ ∈ (FiniteOffLine.ZF T).erase ρ₀,
      ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) / ‖(ρ : ℂ)‖
        * ((‖(ρ₀ : ℂ)‖ / ‖(ρ : ℂ) - ρ₀‖ + ‖(ρ₀ : ℂ) - 1‖ / ‖(ρ : ℂ) - ρ₀ + 1‖) * 2) := by
    rw [hZo]
    refine (norm_sum_le _ _).trans (Finset.sum_le_sum (fun ρ hρ => ?_))
    have hne : ρ ≠ ρ₀ := Finset.ne_of_mem_erase hρ
    have hmem := Finset.mem_of_mem_erase hρ
    have h1 : (ρ : ℂ) ≠ (ρ₀ : ℂ) := fun h => hne (Subtype.ext h)
    have h2 : (ρ : ℂ) ≠ (ρ₀ : ℂ) - 1 := by
      intro h
      have hr := congrArg Complex.re h
      have hp := ρ.2.1.1
      have hq := ρ₀.2.1.2
      simp at hr
      linarith
    have hK := norm_K_le hN h1 h2 (hright ρ hmem)
    rw [norm_mul, norm_div, norm_order]
    exact mul_le_mul_of_nonneg_left hK (by
      have := FiniteOffLine.order_nonneg ρ
      positivity)
  calc ‖W + m₀ * (Real.log 2 : ℂ) + m₀ * ((ρ₀ : ℂ) - 1) * ((N : ℂ) - 2) / ((ρ₀ : ℂ) * N)
        - Zo‖
      ≤ ‖W‖ + ‖m₀ * (Real.log 2 : ℂ)‖
        + ‖m₀ * ((ρ₀ : ℂ) - 1) * ((N : ℂ) - 2) / ((ρ₀ : ℂ) * N)‖ + ‖Zo‖ := by
        refine (norm_sub_le _ _).trans ?_
        have h1 := norm_add_le (W + m₀ * (Real.log 2 : ℂ))
          (m₀ * ((ρ₀ : ℂ) - 1) * ((N : ℂ) - 2) / ((ρ₀ : ℂ) * N))
        have h2 := norm_add_le W (m₀ * (Real.log 2 : ℂ))
        linarith
    _ ≤ _ := by
        rw [ha]
        linarith

/-- info: 'StepsPeak.peak_height' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms peak_height

end

end StepsPeak
