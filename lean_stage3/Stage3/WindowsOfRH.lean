/-
WindowsOfRH — block R16 of `lean_stage3/design/runs.md`. 2026-11-24.

The reverse of `LandauCriterion.rh_of_windows`, built in steps. This file holds
steps S2 and S4 of the design.

S2. The ramp sum is `y` times the integral of the staircase over `t²`:
  rampSum_eq_mertens   1 ≤ y ⊢ rampSum y = y·Σ_{n≤y} Λ(n)/n − ψ(y)
  sum_vonMangoldt_div  1 ≤ y ⊢ Σ_{n≤y} Λ(n)/n = ψ(y)/y + ∫_{(1,y]} ψ(t)/t²
  rampSum_eq_integral  1 ≤ y ⊢ rampSum y = y·∫_{(1,y]} ψ(t)/t²

S4. The constant is zero: if `G y = c·y + r y` on `(1, ∞)` with
`|r y| ≤ K·y^α`, `α < 1`, then `c = 0`. The Mellin transform of `G` is `Phi`
(`LandauMellinG.mellin_G`), and `Phi` is regular at `1`
(`LandauPoleLocal.Phi_regular_at_one`); a nonzero `c` would give it the pole
`c/(s − 1)`.
  const_eq_zero

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LandauCriterion
import Stage3.LandauPoleLocal
import Stage3.LandauMellinG
import Stage3.JointDialGate
import Stage3.Saddle

namespace WindowsOfRH

noncomputable section

open scoped ArithmeticFunction.vonMangoldt Chebyshev
open Finset MeasureTheory Filter Topology

/-! ### S2 -/

/-- **The ramp sum through the Mertens sum.** For `y ≥ 1`,
`rampSum y = y·Σ_{n≤y} Λ(n)/n − ψ(y)`. -/
theorem rampSum_eq_mertens {y : ℝ} (hy : 1 ≤ y) :
    LandauWindow.rampSum y
      = y * ∑ n ∈ Ioc 0 ⌊y⌋₊, Λ n / (n : ℝ) - ψ y := by
  have hy0 : 0 < y := by linarith
  have hsub : Ioc 0 ⌊y⌋₊ ⊆ range (⌊y⌋₊ + 1) := by
    intro n hn
    rw [mem_Ioc] at hn
    exact mem_range.mpr (by omega)
  have hterm : ∀ n ∈ Ioc 0 ⌊y⌋₊,
      Λ n * max (y / n - 1) 0 = y * (Λ n / n) - Λ n := by
    intro n hn
    rw [mem_Ioc] at hn
    have hnR : (0 : ℝ) < n := by exact_mod_cast hn.1
    have hny : (n : ℝ) ≤ y := le_trans (by exact_mod_cast hn.2) (Nat.floor_le hy0.le)
    have h1 : 1 ≤ y / n := by rw [le_div_iff₀ hnR]; linarith
    rw [max_eq_left (by linarith)]
    field_simp
    try ring
  rw [LandauWindow.rampSum, Chebyshev.psi]
  rw [← Finset.sum_subset hsub (fun n hn hn' => by
    have : n = 0 := by
      rw [mem_range] at hn
      rw [mem_Ioc] at hn'
      omega
    simp [this])]
  rw [Finset.sum_congr rfl hterm, Finset.sum_sub_distrib, Finset.mul_sum]

/-- **Abel summation.** For `y ≥ 1`,
`Σ_{n≤y} Λ(n)/n = ψ(y)/y + ∫_{(1,y]} ψ(t)/t²`. -/
theorem sum_vonMangoldt_div {y : ℝ} (hy : 1 ≤ y) :
    ∑ n ∈ Ioc 0 ⌊y⌋₊, Λ n / (n : ℝ)
      = ψ y / y + ∫ t in Set.Ioc 1 y, ψ t / t ^ 2 := by
  have hy0 : 0 < y := by linarith
  have hdiff : ∀ t ∈ Set.Icc (1 : ℝ) y, DifferentiableAt ℝ (fun t : ℝ => t⁻¹) t := by
    intro t ht
    exact differentiableAt_inv (by linarith [ht.1])
  have hderiv : ∀ t ∈ Set.Icc (1 : ℝ) y, deriv (fun t : ℝ => t⁻¹) t = -(t ^ 2)⁻¹ := by
    intro t _
    rw [deriv_inv]
  have hint : IntegrableOn (deriv (fun t : ℝ => t⁻¹)) (Set.Icc 1 y) := by
    have hc : ContinuousOn (fun t : ℝ => -(t ^ 2)⁻¹) (Set.Icc 1 y) := by
      apply ContinuousOn.neg
      apply ContinuousOn.inv₀ (continuousOn_pow 2)
      intro t ht
      have : (0 : ℝ) < t := by linarith [ht.1]
      positivity
    exact (hc.integrableOn_compact isCompact_Icc).congr_fun
      (fun t ht => (hderiv t ht).symm) measurableSet_Icc
  have hA := sum_mul_eq_sub_integral_mul₀ (fun n => (Λ n : ℝ))
    (by simp) y hdiff hint
  have hL : ∑ k ∈ Icc 0 ⌊y⌋₊, (k : ℝ)⁻¹ * Λ k = ∑ n ∈ Ioc 0 ⌊y⌋₊, Λ n / (n : ℝ) := by
    rw [← add_sum_Ioc_eq_sum_Icc (Nat.zero_le _)]
    simp only [Nat.cast_zero, inv_zero, zero_mul, zero_add]
    exact Finset.sum_congr rfl (fun n _ => by ring)
  have hP : ∑ k ∈ Icc 0 ⌊y⌋₊, (Λ k : ℝ) = ψ y := (Chebyshev.psi_eq_sum_Icc y).symm
  have hI : ∫ t in Set.Ioc 1 y, deriv (fun t : ℝ => t⁻¹) t * ∑ k ∈ Icc 0 ⌊t⌋₊, (Λ k : ℝ)
      = -∫ t in Set.Ioc 1 y, ψ t / t ^ 2 := by
    rw [← integral_neg]
    refine setIntegral_congr_fun measurableSet_Ioc (fun t ht => ?_)
    rw [hderiv t (Set.Ioc_subset_Icc_self ht), ← Chebyshev.psi_eq_sum_Icc t]
    ring
  rw [← hL, hA, hP, hI]
  ring

/-- **S2.** For `y ≥ 1`, `rampSum y = y·∫_{(1,y]} ψ(t)/t²`. -/
theorem rampSum_eq_integral {y : ℝ} (hy : 1 ≤ y) :
    LandauWindow.rampSum y = y * ∫ t in Set.Ioc 1 y, ψ t / t ^ 2 := by
  have hy0 : 0 < y := by linarith
  rw [rampSum_eq_mertens hy, sum_vonMangoldt_div hy]
  field_simp
  try ring

/-! ### S4 -/

/-- The power integral `∫_{(1,∞)} y^(−σ) = 1/(σ − 1)` for real `σ > 1`, in `ℂ`. -/
theorem integral_cpow_neg {σ : ℝ} (hσ : 1 < σ) :
    ∫ y in Set.Ioi (1 : ℝ), (y : ℂ) ^ (-(σ : ℂ)) = 1 / ((σ : ℂ) - 1) := by
  rw [integral_Ioi_cpow_of_lt (by simp; linarith) one_pos]
  simp only [Complex.ofReal_one, Complex.one_cpow]
  have h1 : (σ : ℂ) - 1 ≠ 0 := by
    intro h
    have : (σ : ℂ) = 1 := by linear_combination h
    exact absurd (by exact_mod_cast this) (ne_of_gt hσ)
  have h2 : -(σ : ℂ) + 1 ≠ 0 := by
    intro h; apply h1; linear_combination -h
  field_simp
  try ring

/-- On `(1, ∞)`, `y·y^(−σ−1) = y^(−σ)` in `ℂ`. -/
theorem mul_cpow_eq {y : ℝ} (hy : 0 < y) (σ : ℝ) :
    (y : ℂ) * (y : ℂ) ^ (-(σ : ℂ) - 1) = (y : ℂ) ^ (-(σ : ℂ)) := by
  have hy0 : (y : ℂ) ≠ 0 := by exact_mod_cast hy.ne'
  rw [Complex.cpow_sub _ _ hy0, Complex.cpow_one]
  field_simp

/-- **The Mellin transform less its pole.** If `G y = c·y + r y` on `(1, ∞)` with
`|r y| ≤ K·y^α`, `α < 1`, then for `σ > 1`,
`‖Phi σ − c/(σ − 1)‖ ≤ K/(σ − α)`. -/
theorem phi_sub_pole_le {c K α : ℝ} {r : ℝ → ℝ} (hα : α < 1)
    (hG : ∀ y ∈ Set.Ioi (1 : ℝ), LandauWindow.G y = c * y + r y)
    (hr : ∀ y ∈ Set.Ioi (1 : ℝ), |r y| ≤ K * y ^ α) {σ : ℝ} (hσ : 1 < σ) :
    ‖LandauMellinG.Phi σ - c / ((σ : ℂ) - 1)‖ ≤ K / (σ - α) := by
  have hs : 1 < ((σ : ℂ)).re := by simpa using hσ
  have hInt := LandauMellinG.G_mellin_integrable hs
  have hC : IntegrableOn (fun y : ℝ => (c : ℂ) * (y : ℂ) ^ (-(σ : ℂ))) (Set.Ioi 1) :=
    (integrableOn_Ioi_cpow_of_lt (by simp; linarith) one_pos).const_mul _
  have hpole : ∫ y in Set.Ioi (1 : ℝ), (c : ℂ) * (y : ℂ) ^ (-(σ : ℂ))
      = c / ((σ : ℂ) - 1) := by
    rw [integral_const_mul, integral_cpow_neg hσ]
    ring
  have hdiff : LandauMellinG.Phi σ - c / ((σ : ℂ) - 1)
      = ∫ y in Set.Ioi (1 : ℝ),
          ((LandauWindow.G y : ℂ) * (y : ℂ) ^ (-(σ : ℂ) - 1)
            - (c : ℂ) * (y : ℂ) ^ (-(σ : ℂ))) := by
    rw [integral_sub hInt hC, ← LandauMellinG.mellin_G hs, hpole]
  rw [hdiff]
  have hbint : IntegrableOn (fun y : ℝ => K * y ^ (α - σ - 1)) (Set.Ioi 1) :=
    (integrableOn_Ioi_rpow_of_lt (by linarith) one_pos).const_mul _
  have hbval : ∫ y in Set.Ioi (1 : ℝ), K * y ^ (α - σ - 1) = K / (σ - α) := by
    rw [integral_const_mul, integral_Ioi_rpow_of_lt (by linarith) one_pos]
    rw [Real.one_rpow, show α - σ - 1 + 1 = -(σ - α) by ring, neg_div_neg_eq]
    ring
  rw [← hbval]
  refine norm_integral_le_of_norm_le hbint ?_
  rw [ae_restrict_iff' measurableSet_Ioi]
  refine Filter.Eventually.of_forall (fun y hy => ?_)
  have hy0 : 0 < y := lt_trans one_pos hy
  have hyC : (y : ℂ) ≠ 0 := by exact_mod_cast hy0.ne'
  have heq : (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-(σ : ℂ) - 1)
      - (c : ℂ) * (y : ℂ) ^ (-(σ : ℂ)) = (r y : ℂ) * (y : ℂ) ^ (-(σ : ℂ) - 1) := by
    rw [hG y hy, ← mul_cpow_eq hy0 σ]
    push_cast
    ring
  rw [heq, norm_mul, Complex.norm_real, Real.norm_eq_abs,
    Complex.norm_cpow_eq_rpow_re_of_pos hy0]
  have hre : (-(σ : ℂ) - 1).re = -σ - 1 := by simp
  rw [hre]
  have hpow : y ^ (α - σ - 1) = y ^ α * y ^ (-σ - 1) := by
    rw [← Real.rpow_add hy0]; ring_nf
  rw [hpow, ← mul_assoc]
  exact mul_le_mul_of_nonneg_right (hr y hy) (Real.rpow_nonneg hy0.le _)

/-- **S4. The constant is zero.** If `G y = c·y + r y` on `(1, ∞)` with
`|r y| ≤ K·y^α` and `α < 1`, then `c = 0`: `Phi` is regular at `1`, so it has
no pole `c/(s − 1)` there. -/
theorem const_eq_zero {c K α : ℝ} {r : ℝ → ℝ} (hα : α < 1) (hK : 0 ≤ K)
    (hG : ∀ y ∈ Set.Ioi (1 : ℝ), LandauWindow.G y = c * y + r y)
    (hr : ∀ y ∈ Set.Ioi (1 : ℝ), |r y| ≤ K * y ^ α) : c = 0 := by
  obtain ⟨h, hh, hev⟩ := LandauPoleLocal.Phi_regular_at_one
  -- the real approach to 1 from the right, carried into ℂ
  have hmap : Tendsto (fun σ : ℝ => (σ : ℂ)) (𝓝[>] (1 : ℝ)) (𝓝[≠] (1 : ℂ)) := by
    refine tendsto_nhdsWithin_of_tendsto_nhds_of_eventually_within _ ?_ ?_
    · have : Tendsto (fun σ : ℝ => (σ : ℂ)) (𝓝 (1 : ℝ)) (𝓝 ((1 : ℝ) : ℂ)) :=
        Complex.continuous_ofReal.tendsto 1
      simpa using this.mono_left nhdsWithin_le_nhds
    · filter_upwards [self_mem_nhdsWithin] with σ hσ
      intro h1
      have h1' : (σ : ℂ) = 1 := h1
      have : σ = 1 := by exact_mod_cast h1'
      exact absurd this (ne_of_gt hσ)
  -- along it, (σ − 1)·Phi σ tends to 0, by the regularity
  have hlim0 : Tendsto (fun σ : ℝ => ((σ : ℂ) - 1) * LandauMellinG.Phi σ)
      (𝓝[>] (1 : ℝ)) (𝓝 0) := by
    have hcont : Tendsto h (𝓝 (1 : ℂ)) (𝓝 (h 1)) := hh.continuousAt.tendsto
    have hh' : Tendsto (fun σ : ℝ => h σ) (𝓝[>] (1 : ℝ)) (𝓝 (h 1)) :=
      hcont.comp (hmap.mono_right nhdsWithin_le_nhds)
    have hsub : Tendsto (fun σ : ℝ => (σ : ℂ) - 1) (𝓝[>] (1 : ℝ)) (𝓝 0) := by
      have := (hmap.mono_right nhdsWithin_le_nhds).sub_const (1 : ℂ)
      simpa using this
    have hprod := hsub.mul hh'
    rw [zero_mul] at hprod
    refine hprod.congr' ?_
    filter_upwards [hmap.eventually hev] with σ hσ
    rw [hσ]
  -- and it tends to c, by the bound on the rest
  have hlimc : Tendsto (fun σ : ℝ => ((σ : ℂ) - 1) * LandauMellinG.Phi σ)
      (𝓝[>] (1 : ℝ)) (𝓝 (c : ℂ)) := by
    have hrest : Tendsto (fun σ : ℝ =>
        ((σ : ℂ) - 1) * (LandauMellinG.Phi σ - c / ((σ : ℂ) - 1)))
        (𝓝[>] (1 : ℝ)) (𝓝 0) := by
      have hb : Tendsto (fun σ : ℝ => (σ - 1) * (K / (1 - α))) (𝓝[>] (1 : ℝ)) (𝓝 0) := by
        have : Tendsto (fun σ : ℝ => (σ - 1) * (K / (1 - α))) (𝓝 (1 : ℝ))
            (𝓝 ((1 - 1) * (K / (1 - α)))) :=
          ((continuous_id.sub continuous_const).mul continuous_const).tendsto 1
        simpa using this.mono_left nhdsWithin_le_nhds
      refine squeeze_zero_norm' ?_ hb
      filter_upwards [self_mem_nhdsWithin] with σ hσ
      have hσ1 : (1 : ℝ) < σ := hσ
      rw [norm_mul]
      have hn1 : ‖(σ : ℂ) - 1‖ = σ - 1 := by
        rw [show (σ : ℂ) - 1 = ((σ - 1 : ℝ) : ℂ) by push_cast; ring, Complex.norm_real,
          Real.norm_eq_abs, abs_of_pos (by linarith)]
      rw [hn1]
      have hle := phi_sub_pole_le hα hG hr hσ1
      have hKa : K / (σ - α) ≤ K / (1 - α) :=
        div_le_div_of_nonneg_left hK (by linarith) (by linarith)
      exact mul_le_mul_of_nonneg_left (hle.trans hKa) (by linarith)
    have hsum := hrest.add_const (c : ℂ)
    rw [zero_add] at hsum
    refine hsum.congr' ?_
    filter_upwards [self_mem_nhdsWithin] with σ hσ
    have hσ1 : (1 : ℝ) < σ := hσ
    have hne : (σ : ℂ) - 1 ≠ 0 := by
      intro h0
      have : (σ : ℂ) = 1 := by linear_combination h0
      exact absurd (by exact_mod_cast this) (ne_of_gt hσ1)
    field_simp
    ring
  have := tendsto_nhds_unique hlimc hlim0
  exact_mod_cast this

/-- info: 'WindowsOfRH.rampSum_eq_integral' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rampSum_eq_integral

/-- info: 'WindowsOfRH.const_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms const_eq_zero

end

end WindowsOfRH
