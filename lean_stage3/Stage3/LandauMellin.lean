/-
LandauMellin — the Mellin transform of the ramp sum on `Re s > 1`.
Block 2 of `lean_stage3/design/landau.md`. 2026-11-22.

For `Re s > 1`,

    ∫₁^∞ rampSum(y)·y^(−s−1) dy = −ζ'/ζ(s) / (s(s−1)),

where `rampSum y = Σ_{n ≤ y} Λ(n)·(y/n − 1)` is `LandauWindow.rampSum`. One
`n` at a time the kernel is `rampK s n y = max(y/n − 1, 0)·y^(−s−1)`, whose
integral over `(1, ∞)` is `n^(−s)/(s(s−1))`. The sum over `n` and the integral
change places by absolute summability, and Mathlib has the L-series of `Λ`
as `−ζ'/ζ`.

  rampK                   the ramp kernel of one `n` (the one definition)
  rampK_integrable        (hs : 1 < s.re) (hn : 1 ≤ n) :
                            IntegrableOn (rampK s n) (Ioi 1)
  rampK_integral          (hs : 1 < s.re) (hn : 1 ≤ n) :
                            ∫ y in Ioi 1, rampK s n y = n^(−s)/(s(s−1))
  rampK_integral_norm     (hs : 1 < s.re) (hn : 1 ≤ n) :
                            ∫ y in Ioi 1, ‖rampK s n y‖ = n^(−σ)/(σ(σ−1)), σ = s.re
  rampSum_eq_tsum         rampSum y = ∑' n, Λ n · max(y/n − 1, 0)
  mellin_rampSum          (hs : 1 < s.re) :
                            ∫ y in Ioi 1, rampSum y · y^(−s−1)
                              = −ζ'(s)/ζ(s)/(s(s−1))

What the next slice needs: the same transform for `G`, which adds the two
elementary integrals of `y·log y` and `y` against `y^(−s−1)` (block 2b), and
then the poles of the right-hand side (block 3).

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LandauWindow

namespace LandauMellin

noncomputable section

open Complex MeasureTheory Set
open scoped LSeries.notation ArithmeticFunction.vonMangoldt

/-- The ramp kernel of one `n`: `max(y/n − 1, 0)·y^(−s−1)`. -/
def rampK (s : ℂ) (n : ℕ) (y : ℝ) : ℂ :=
  ((max (y / n - 1) 0 : ℝ) : ℂ) * (y : ℂ) ^ (-s - 1)

/-- On `(1, ∞)` the kernel is the indicator of `(n, ∞)` times two powers. -/
private lemma rampK_eq_indicator (s : ℂ) {n : ℕ} (hn : 1 ≤ n) {y : ℝ} (hy : 1 < y) :
    rampK s n y = (Ioi (n : ℝ)).indicator
      (fun t : ℝ => (1 / (n : ℂ)) * (t : ℂ) ^ (-s) - (t : ℂ) ^ (-s - 1)) y := by
  have hn0 : (0 : ℝ) < n := by exact_mod_cast hn
  have hy0 : (y : ℂ) ≠ 0 := by exact_mod_cast (by linarith : y ≠ 0)
  by_cases h : (n : ℝ) < y
  · rw [Set.indicator_of_mem (mem_Ioi.mpr h)]
    have hpos : 0 ≤ y / n - 1 := by
      rw [sub_nonneg, le_div_iff₀ hn0]; linarith
    have hpow : (y : ℂ) ^ (-s) = (y : ℂ) ^ (-s - 1) * y := by
      rw [show (-s : ℂ) = (-s - 1) + 1 by ring, Complex.cpow_add _ _ hy0, Complex.cpow_one]
      congr 2; ring
    rw [rampK, max_eq_left hpos, hpow]
    push_cast
    ring
  · rw [Set.indicator_of_notMem (by simpa using h)]
    have hneg : y / n - 1 ≤ 0 := by
      rw [sub_nonpos, div_le_one hn0]; exact not_lt.mp h
    rw [rampK, max_eq_right hneg]
    simp

/-- Helper: for `Re s > 1` and `n ≥ 1`, the two-power function `t^(−s)/n − t^(−s−1)` is
integrable on `(n, ∞)`. -/
private lemma two_powers_integrableOn {s : ℂ} (hs : 1 < s.re) {n : ℕ} (hn : 1 ≤ n) :
    IntegrableOn (fun t : ℝ => (1 / (n : ℂ)) * (t : ℂ) ^ (-s) - (t : ℂ) ^ (-s - 1))
      (Ioi (n : ℝ)) := by
  have hn0 : (0 : ℝ) < n := by exact_mod_cast hn
  have h1 : IntegrableOn (fun t : ℝ => (t : ℂ) ^ (-s)) (Ioi (n : ℝ)) :=
    integrableOn_Ioi_cpow_of_lt (by simp; linarith) hn0
  have h2 : IntegrableOn (fun t : ℝ => (t : ℂ) ^ (-s - 1)) (Ioi (n : ℝ)) :=
    integrableOn_Ioi_cpow_of_lt (by simp; linarith) hn0
  exact (h1.const_mul _).sub h2

/-- For `Re s > 1` and `n ≥ 1`, the ramp kernel `rampK s n` is integrable on `(1, ∞)`. -/
theorem rampK_integrable {s : ℂ} (hs : 1 < s.re) {n : ℕ} (hn : 1 ≤ n) :
    IntegrableOn (rampK s n) (Ioi 1) := by
  have h := ((two_powers_integrableOn hs hn).integrable_indicator measurableSet_Ioi).integrableOn
    (s := Ioi (1 : ℝ))
  refine h.congr_fun (fun y hy => ?_) measurableSet_Ioi
  exact (rampK_eq_indicator s hn hy).symm

/-- For `Re s > 1` and `n ≥ 1`, the integral of the ramp kernel `rampK s n` over `(1, ∞)` is
`n^(−s)/(s(s−1))`. -/
theorem rampK_integral {s : ℂ} (hs : 1 < s.re) {n : ℕ} (hn : 1 ≤ n) :
    ∫ y in Ioi (1 : ℝ), rampK s n y = (n : ℂ) ^ (-s) / (s * (s - 1)) := by
  have hn0 : (0 : ℝ) < n := by exact_mod_cast hn
  have hnC : (n : ℂ) ≠ 0 := by exact_mod_cast (by omega : n ≠ 0)
  have hs0 : s ≠ 0 := by
    intro h; rw [h] at hs; simp at hs; linarith
  have hs1 : s - 1 ≠ 0 := by
    intro h
    have : s = 1 := by linear_combination h
    rw [this] at hs; simp at hs
  have h1 : IntegrableOn (fun t : ℝ => (t : ℂ) ^ (-s)) (Ioi (n : ℝ)) :=
    integrableOn_Ioi_cpow_of_lt (by simp; linarith) hn0
  have h2 : IntegrableOn (fun t : ℝ => (t : ℂ) ^ (-s - 1)) (Ioi (n : ℝ)) :=
    integrableOn_Ioi_cpow_of_lt (by simp; linarith) hn0
  have hsub : Ioi (1 : ℝ) ∩ Ioi (n : ℝ) = Ioi (n : ℝ) := by
    apply inter_eq_right.mpr
    intro y hy
    have : (1 : ℝ) ≤ n := by exact_mod_cast hn
    exact mem_Ioi.mpr (lt_of_le_of_lt this hy)
  have hcongr : ∫ y in Ioi (1 : ℝ), rampK s n y = ∫ y in Ioi (1 : ℝ), (Ioi (n : ℝ)).indicator
      (fun t : ℝ => (1 / (n : ℂ)) * (t : ℂ) ^ (-s) - (t : ℂ) ^ (-s - 1)) y :=
    setIntegral_congr_fun measurableSet_Ioi (fun y hy => rampK_eq_indicator s hn hy)
  rw [hcongr, setIntegral_indicator measurableSet_Ioi, hsub,
    integral_sub (h1.const_mul _) h2, integral_const_mul,
    integral_Ioi_cpow_of_lt (by simp; linarith) hn0,
    integral_Ioi_cpow_of_lt (by simp; linarith) hn0]
  have e1 : (n : ℂ) ^ (-s + 1) = (n : ℂ) ^ (-s) * n := by
    rw [Complex.cpow_add _ _ hnC, Complex.cpow_one]
  have e2 : (-s - 1 + 1 : ℂ) = -s := by ring
  have hs1' : -s + 1 ≠ 0 := by
    intro h; apply hs1; linear_combination -h
  have hs0' : -s ≠ 0 := neg_ne_zero.mpr hs0
  push_cast
  rw [e2, e1]
  field_simp
  try ring

/-- For `Re s > 1` and `n ≥ 1`, the integral of the norm of the ramp kernel over `(1, ∞)` is
`n^(−σ)/(σ(σ−1))` with `σ = Re s`. -/
theorem rampK_integral_norm {s : ℂ} (hs : 1 < s.re) {n : ℕ} (hn : 1 ≤ n) :
    ∫ y in Ioi (1 : ℝ), ‖rampK s n y‖ = (n : ℝ) ^ (-s.re) / (s.re * (s.re - 1)) := by
  have hn0 : (0 : ℝ) ≤ n := by positivity
  have hσ : 1 < ((s.re : ℝ) : ℂ).re := by simpa using hs
  -- the norm is the kernel at the real point
  have hpt : ∀ y ∈ Ioi (1 : ℝ), ((‖rampK s n y‖ : ℝ) : ℂ) = rampK (s.re : ℂ) n y := by
    intro y hy
    have hy0 : (0 : ℝ) < y := by linarith [mem_Ioi.mp hy]
    have hmax : (0 : ℝ) ≤ max (y / n - 1) 0 := le_max_right _ _
    rw [rampK, rampK, norm_mul, Complex.norm_real, Real.norm_of_nonneg hmax,
      Complex.norm_cpow_eq_rpow_re_of_pos hy0]
    have hre : (-s - 1).re = -s.re - 1 := by simp
    rw [hre]
    push_cast
    rw [Complex.ofReal_cpow hy0.le]
    push_cast
    rfl
  have hC : ((∫ y in Ioi (1 : ℝ), ‖rampK s n y‖ : ℝ) : ℂ)
      = (((n : ℝ) ^ (-s.re) / (s.re * (s.re - 1)) : ℝ) : ℂ) := by
    rw [← integral_complex_ofReal, setIntegral_congr_fun measurableSet_Ioi hpt, rampK_integral hσ hn]
    push_cast
    rw [Complex.ofReal_cpow hn0]
    push_cast
    rfl
  exact_mod_cast hC

/-- The ramp sum at `y` equals the infinite sum over all `n` of `Λ(n)·max(y/n − 1, 0)`. -/
theorem rampSum_eq_tsum (y : ℝ) :
    LandauWindow.rampSum y = ∑' n : ℕ, Λ n * max (y / n - 1) 0 := by
  rw [LandauWindow.rampSum]
  symm
  apply tsum_eq_sum
  intro n hn
  have hlt : (⌊y⌋₊ : ℝ) + 1 ≤ n := by
    have : ⌊y⌋₊ + 1 ≤ n := by
      simpa [Finset.mem_range, not_lt] using hn
    exact_mod_cast this
  have hy : y < n := lt_of_lt_of_le (Nat.lt_floor_add_one y) hlt
  have hn0 : (0 : ℝ) < n := lt_of_lt_of_le (by positivity) hlt
  have : y / n - 1 ≤ 0 := by
    rw [sub_nonpos, div_le_one hn0]; exact hy.le
  rw [max_eq_right this, mul_zero]

/-- The Mellin transform of the ramp sum: for `Re s > 1`, the integral over `(1, ∞)` of
`rampSum(y)·y^(−s−1)` equals `−ζ'(s)/ζ(s)/(s(s−1))`. -/
theorem mellin_rampSum {s : ℂ} (hs : 1 < s.re) :
    ∫ y in Ioi (1 : ℝ), (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1)
      = -deriv riemannZeta s / riemannZeta s / (s * (s - 1)) := by
  set F : ℕ → ℝ → ℂ := fun n y => (Λ n : ℂ) * rampK s n y with hF
  have hσ0 : 0 < s.re * (s.re - 1) := by nlinarith
  -- each term is integrable
  have hint : ∀ n, Integrable (F n) (volume.restrict (Ioi (1 : ℝ))) := by
    intro n
    rcases Nat.eq_zero_or_pos n with rfl | hn
    · simp [hF]
    · exact (rampK_integrable hs hn).const_mul _
  -- the integrals of the norms
  have hnorm : ∀ n, ∫ y in Ioi (1 : ℝ), ‖F n y‖ = ‖LSeries.term ↗Λ s n‖ / (s.re * (s.re - 1)) := by
    intro n
    rcases Nat.eq_zero_or_pos n with rfl | hn
    · simp [hF]
    · have hn0 : (0 : ℝ) < n := by exact_mod_cast hn
      simp only [hF, norm_mul]
      rw [integral_const_mul, rampK_integral_norm hs hn, LSeries.norm_term_eq,
        if_neg (by omega : n ≠ 0), Real.rpow_neg hn0.le]
      field_simp
  have hsum : Summable fun n => ∫ y in Ioi (1 : ℝ), ‖F n y‖ := by
    simp_rw [hnorm]
    exact (ArithmeticFunction.LSeriesSummable_vonMangoldt hs).norm.div_const _
  have key := (hasSum_integral_of_summable_integral_norm hint hsum).tsum_eq
  -- the pointwise sum
  have hpt : ∀ y : ℝ, ∑' n, F n y = (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1) := by
    intro y
    simp only [hF, rampK, ← mul_assoc]
    rw [tsum_mul_right, rampSum_eq_tsum, Complex.ofReal_tsum]
    push_cast
    rfl
  -- the termwise integrals
  have hterm : ∀ n, ∫ y in Ioi (1 : ℝ), F n y = LSeries.term ↗Λ s n / (s * (s - 1)) := by
    intro n
    rcases Nat.eq_zero_or_pos n with rfl | hn
    · simp [hF]
    · simp only [hF]
      rw [integral_const_mul, rampK_integral hs hn, LSeries.term_def₀ (by simp)]
      ring
  simp_rw [hpt, hterm] at key
  rw [← key, tsum_div_const, ← ArithmeticFunction.LSeries_vonMangoldt_eq_deriv_riemannZeta_div hs]
  rfl

/-- info: 'LandauMellin.rampK_integral' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rampK_integral

/-- info: 'LandauMellin.rampK_integral_norm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rampK_integral_norm

/-- info: 'LandauMellin.mellin_rampSum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mellin_rampSum

end

end LandauMellin
