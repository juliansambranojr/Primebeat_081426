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

S1. The Riemann hypothesis gives `Saddle.NoRunaway`.
  noRunaway_of_rh

S3. From `NoRunaway`, with `E t = ψ(t) − t`: `E(t)/t²` is integrable on
`(1, ∞)`; for `y > 1`, `G y = c₀·y + r y` with `c₀ = 1 + γ + ∫_{(1,∞)} E/t²` and
`r y = −y·∫_{(y,∞)} E/t²`; `|r y| ≤ K·y^(3/4)`; so `c₀ = 0` by S4.
  E_div_integrableOn   NoRunaway ⊢ IntegrableOn (E t / t²) (1, ∞)
  G_eq                 NoRunaway, 1 < y ⊢ G y = c0·y + r y
  r_bound              NoRunaway ⊢ ∃ K ≥ 0, ∀ y > 1, |r y| ≤ K·y^(3/4)
  c0_eq_zero           NoRunaway ⊢ c0 = 0

S5. The Riemann hypothesis gives a window bound at every `θ ∈ (1/2, 1)`, with
`δ = 1`: `G = r` and the tail is `≤ K_θ·y^θ` from `max x₀ 1` on. With
`LandauCriterion.rh_of_windows`, `SpiralLink` is the window bounds.
  windows_of_rh
  spiralLink_iff_windows

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
    try ring
  have := tendsto_nhds_unique hlimc hlim0
  exact_mod_cast this

/-! ### S1 -/

/-- **S1.** The Riemann hypothesis gives the staircase in the square-root
frame: `|ψ(t) − t| ≤ C·t^(1/2)·(log t)^k` from some point on. -/
theorem noRunaway_of_rh (hRH : RiemannHypothesis) : Saddle.NoRunaway :=
  Saddle.spiralLink_iff_noRunaway.mp (SpiralLink.rh_iff_spiralLink.mp hRH)

/-- info: 'WindowsOfRH.rampSum_eq_integral' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rampSum_eq_integral

/-- info: 'WindowsOfRH.const_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms const_eq_zero

/-- info: 'WindowsOfRH.noRunaway_of_rh' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms noRunaway_of_rh

/-! ### S3 -/

/-- The staircase less the line, `E t = ψ(t) − t`. -/
noncomputable
def E (t : ℝ) : ℝ := ψ t - t

/-- The constant `c₀ = 1 + γ + ∫_{(1,∞)} E(t)/t²`. -/
noncomputable
def c0 : ℝ := 1 + Real.eulerMascheroniConstant + ∫ t in Set.Ioi 1, E t / t ^ 2

/-- The rest `r(y) = −y·∫_{(y,∞)} E(t)/t²`. -/
noncomputable
def r (y : ℝ) : ℝ := -y * ∫ t in Set.Ioi y, E t / t ^ 2

theorem E_div_measurable : Measurable (fun t : ℝ => E t / t ^ 2) := by
  simp only [E]
  exact (Chebyshev.psi_mono.measurable.sub measurable_id).div (measurable_id.pow_const 2)

/-- Beyond `max x₀ 1`, `|E(t)/t²| ≤ A·t^(θ'−2)`, the log absorbed at `θ' > 1/2`. -/
theorem E_div_le {C x₀ θ' : ℝ} {k : ℕ} (h : Stage3.StmtPsiWeakTheta (1 / 2) C k x₀)
    (hθ' : 1 / 2 < θ') :
    ∃ A : ℝ, 0 ≤ A ∧ ∀ t : ℝ, max x₀ 1 ≤ t → |E t / t ^ 2| ≤ A * t ^ (θ' - 2) := by
  have hε : 0 < θ' - 1 / 2 := by linarith
  refine ⟨max C 0 / (2 * (θ' - 1 / 2) / (2 * ((k : ℝ) + 1))) ^ k,
    div_nonneg (le_max_right _ _) (pow_nonneg (by positivity) _), fun t ht => ?_⟩
  have ht1 : 1 ≤ t := le_trans (le_max_right _ _) ht
  have ht0 : 0 < t := by linarith
  have hx0t : x₀ ≤ t := le_trans (le_max_left _ _) ht
  have hlog : 0 ≤ Real.log t ^ k := pow_nonneg (Real.log_nonneg ht1) _
  have hb : |ψ t - t| ≤ max C 0 * t ^ (1 / 2 : ℝ) * Real.log t ^ k := by
    refine le_trans (h t hx0t) ?_
    exact mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_right (le_max_left _ _)
      (Real.rpow_nonneg ht0.le _)) hlog
  have hab := JointDialGate.log_absorbed (k := k) (le_max_right C 0) hθ' ht1
  have ht2 : (0 : ℝ) < t ^ 2 := by positivity
  rw [abs_div, abs_of_pos ht2, div_le_iff₀ ht2]
  have hpow : t ^ (θ' - 2) * t ^ 2 = t ^ θ' := by
    rw [← Real.rpow_two, ← Real.rpow_add ht0]
    congr 1
    ring
  simp only [E]
  calc |ψ t - t| ≤ _ := hb
    _ ≤ _ := hab
    _ = _ := by rw [mul_assoc, hpow]

/-- **S3 (a).** `E(t)/t²` is integrable on `(1, ∞)`. -/
theorem E_div_integrableOn (hN : Saddle.NoRunaway) :
    IntegrableOn (fun t : ℝ => E t / t ^ 2) (Set.Ioi 1) := by
  obtain ⟨C, k, x₀, h⟩ := hN
  obtain ⟨A, hA, hle⟩ := E_div_le h (θ' := 3 / 4) (by norm_num)
  have hx₁1 : 1 ≤ max x₀ 1 := le_max_right _ _
  rw [← Set.Ioc_union_Ioi_eq_Ioi hx₁1]
  refine IntegrableOn.union ?_ ?_
  · have hbound : ∀ t ∈ Set.Ioc 1 (max x₀ 1), ‖E t / t ^ 2‖ ≤ ψ (max x₀ 1) + max x₀ 1 := by
      intro t ht
      have ht1 : 1 ≤ t := ht.1.le
      have ht2 : 1 ≤ t ^ 2 := one_le_pow₀ ht1
      rw [Real.norm_eq_abs, abs_div, abs_of_pos (show (0 : ℝ) < t ^ 2 by positivity)]
      refine le_trans (div_le_self (abs_nonneg _) ht2) ?_
      simp only [E]
      have hψ0 := Chebyshev.psi_nonneg t
      have hψ := Chebyshev.psi_mono ht.2
      rw [abs_le]
      constructor <;> linarith [ht.2]
    refine Integrable.mono' (g := fun _ => ψ (max x₀ 1) + max x₀ 1) ?_
      E_div_measurable.aestronglyMeasurable ?_
    · exact integrableOn_const measure_Ioc_lt_top.ne
    · rw [ae_restrict_iff' measurableSet_Ioc]
      exact Filter.Eventually.of_forall hbound
  · have hint : IntegrableOn (fun t : ℝ => A * t ^ ((3 / 4 : ℝ) - 2)) (Set.Ioi (max x₀ 1)) :=
      (integrableOn_Ioi_rpow_of_lt (by norm_num) (by linarith)).const_mul _
    refine Integrable.mono' hint E_div_measurable.aestronglyMeasurable ?_
    rw [ae_restrict_iff' measurableSet_Ioi]
    exact Filter.Eventually.of_forall (fun t ht => by
      rw [Real.norm_eq_abs]; exact hle t (le_of_lt ht))

/-- **S3 (b).** For `y > 1`, `G y = c₀·y + r y`. -/
theorem G_eq (hN : Saddle.NoRunaway) {y : ℝ} (hy : 1 < y) :
    LandauWindow.G y = c0 * y + r y := by
  have hint := E_div_integrableOn hN
  have hy0 : 0 < y := by linarith
  have hintC : IntegrableOn (fun t : ℝ => E t / t ^ 2) (Set.Ioc 1 y) :=
    hint.mono_set Set.Ioc_subset_Ioi_self
  have hintI : IntegrableOn (fun t : ℝ => E t / t ^ 2) (Set.Ioi y) :=
    hint.mono_set (Set.Ioi_subset_Ioi hy.le)
  have hinv : IntegrableOn (fun t : ℝ => t⁻¹) (Set.Ioc 1 y) := by
    have hc : ContinuousOn (fun t : ℝ => t⁻¹) (Set.Icc 1 y) :=
      continuousOn_inv₀.mono (fun t ht => ne_of_gt (lt_of_lt_of_le one_pos ht.1))
    exact (hc.integrableOn_compact isCompact_Icc).mono_set Set.Ioc_subset_Icc_self
  have hlog : ∫ t in Set.Ioc 1 y, t⁻¹ = Real.log y := by
    rw [← intervalIntegral.integral_of_le hy.le, integral_inv_of_pos one_pos hy0, div_one]
  have hsplit : ∫ t in Set.Ioi 1, E t / t ^ 2
      = (∫ t in Set.Ioc 1 y, E t / t ^ 2) + (∫ t in Set.Ioi y, E t / t ^ 2) := by
    rw [← setIntegral_union (Set.Ioc_disjoint_Ioi le_rfl) measurableSet_Ioi hintC hintI,
      Set.Ioc_union_Ioi_eq_Ioi hy.le]
  have hpsi : ∫ t in Set.Ioc 1 y, ψ t / t ^ 2
      = (∫ t in Set.Ioc 1 y, E t / t ^ 2) + (∫ t in Set.Ioc 1 y, t⁻¹) := by
    rw [← integral_add hintC hinv]
    refine setIntegral_congr_fun measurableSet_Ioc (fun t ht => ?_)
    have ht0 : 0 < t := by linarith [ht.1]
    simp only [E]
    field_simp
    try ring
  rw [LandauWindow.G, rampSum_eq_integral hy.le, hpsi, hlog, c0, r, hsplit]
  ring

/-- The tail at exponent `θ' ∈ (1/2, 1)`: beyond `max x₀ 1`, `|r y| ≤ K·y^θ'`. -/
theorem tail_le {C x₀ θ' : ℝ} {k : ℕ} (h : Stage3.StmtPsiWeakTheta (1 / 2) C k x₀)
    (hθ'lo : 1 / 2 < θ') (hθ'1 : θ' < 1) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ y : ℝ, max x₀ 1 ≤ y → |r y| ≤ K * y ^ θ' := by
  obtain ⟨A, hA, hle⟩ := E_div_le h hθ'lo
  refine ⟨A / (1 - θ'), div_nonneg hA (by linarith), fun y hy => ?_⟩
  have hy1 : 1 ≤ y := le_trans (le_max_right _ _) hy
  have hy0 : 0 < y := by linarith
  have hbint : IntegrableOn (fun t : ℝ => A * t ^ (θ' - 2)) (Set.Ioi y) :=
    (integrableOn_Ioi_rpow_of_lt (by linarith) hy0).const_mul _
  have hbval : ∫ t in Set.Ioi y, A * t ^ (θ' - 2) = A / (1 - θ') * y ^ (θ' - 1) := by
    rw [integral_const_mul, integral_Ioi_rpow_of_lt (by linarith) hy0]
    rw [show θ' - 2 + 1 = θ' - 1 by ring]
    have h1 : 1 - θ' ≠ 0 := by linarith
    have h2 : θ' - 1 ≠ 0 := by linarith
    field_simp
    try ring
  have hI : ‖∫ t in Set.Ioi y, E t / t ^ 2‖ ≤ A / (1 - θ') * y ^ (θ' - 1) := by
    rw [← hbval]
    refine norm_integral_le_of_norm_le hbint ?_
    rw [ae_restrict_iff' measurableSet_Ioi]
    exact Filter.Eventually.of_forall (fun t ht => by
      rw [Real.norm_eq_abs]; exact hle t (le_trans hy (le_of_lt ht)))
  rw [Real.norm_eq_abs] at hI
  have hsplit : y * y ^ (θ' - 1) = y ^ θ' := by
    conv_rhs => rw [show θ' = 1 + (θ' - 1) by ring]
    rw [Real.rpow_add hy0, Real.rpow_one]
  simp only [r]
  rw [abs_mul, abs_neg, abs_of_pos hy0]
  calc y * |∫ t in Set.Ioi y, E t / t ^ 2|
      ≤ y * (A / (1 - θ') * y ^ (θ' - 1)) := mul_le_mul_of_nonneg_left hI hy0.le
    _ = A / (1 - θ') * y ^ θ' := by rw [← hsplit]; ring

/-- **S3 (c).** For `y > 1`, `|r y| ≤ K·y^(3/4)`. -/
theorem r_bound (hN : Saddle.NoRunaway) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ y ∈ Set.Ioi (1 : ℝ), |r y| ≤ K * y ^ (3 / 4 : ℝ) := by
  have hint := E_div_integrableOn hN
  obtain ⟨C, k, x₀, h⟩ := hN
  obtain ⟨K₁, hK₁, hK₁le⟩ := tail_le h (θ' := 3 / 4) (by norm_num) (by norm_num)
  have hM0 : 0 ≤ ∫ t in Set.Ioi (1 : ℝ), ‖E t / t ^ 2‖ :=
    setIntegral_nonneg measurableSet_Ioi (fun _ _ => norm_nonneg _)
  have hx₁ : 0 ≤ max x₀ 1 := le_trans zero_le_one (le_max_right _ _)
  have hxM := mul_nonneg hx₁ hM0
  refine ⟨K₁ + max x₀ 1 * ∫ t in Set.Ioi (1 : ℝ), ‖E t / t ^ 2‖, add_nonneg hK₁ hxM,
    fun y hy => ?_⟩
  have hy1 : 1 < y := hy
  have hy0 : 0 < y := by linarith
  have hyp : 1 ≤ y ^ (3 / 4 : ℝ) := Real.one_le_rpow hy1.le (by norm_num)
  have hpos : 0 ≤ y ^ (3 / 4 : ℝ) := by linarith
  have e : (K₁ + max x₀ 1 * ∫ t in Set.Ioi (1 : ℝ), ‖E t / t ^ 2‖) * y ^ (3 / 4 : ℝ)
      = K₁ * y ^ (3 / 4 : ℝ)
        + (max x₀ 1 * ∫ t in Set.Ioi (1 : ℝ), ‖E t / t ^ 2‖) * y ^ (3 / 4 : ℝ) := by ring
  rw [e]
  rcases le_or_gt (max x₀ 1) y with hyx | hyx
  · have h1 := hK₁le y hyx
    have h2 := mul_nonneg hxM hpos
    linarith
  · have hI : |∫ t in Set.Ioi y, E t / t ^ 2| ≤ ∫ t in Set.Ioi (1 : ℝ), ‖E t / t ^ 2‖ := by
      rw [← Real.norm_eq_abs]
      refine le_trans (norm_integral_le_integral_norm _) ?_
      exact setIntegral_mono_set hint.norm (Filter.Eventually.of_forall (fun _ => norm_nonneg _))
        (Set.Ioi_subset_Ioi hy1.le).eventuallyLE
    simp only [r]
    rw [abs_mul, abs_neg, abs_of_pos hy0]
    have h1 := mul_le_mul hyx.le hI (abs_nonneg _) hx₁
    have h2 := le_mul_of_one_le_right hxM hyp
    have h3 := mul_nonneg hK₁ hpos
    linarith

/-- **S3 (d).** The constant `c₀` is zero. -/
theorem c0_eq_zero (hN : Saddle.NoRunaway) : c0 = 0 := by
  obtain ⟨K, hK, hr⟩ := r_bound hN
  exact const_eq_zero (α := 3 / 4) (by norm_num) hK (fun y hy => G_eq hN hy) hr

end

-- `open scoped Chebyshev` makes `θ` a token; S5 states its exponent as `θ`, so it
-- sits in a fresh section that opens only what it needs.
noncomputable section

/-! ### S5 -/

/-- **S5.** The Riemann hypothesis gives a window bound at every `θ ∈ (1/2, 1)`. -/
theorem windows_of_rh (hRH : RiemannHypothesis) :
    ∀ θ : ℝ, 1 / 2 < θ → θ < 1 → ∃ δ C : ℝ, 0 < δ ∧ LandauWindow.WindowBound θ δ C := by
  intro θ hθlo hθ1
  have hN := noRunaway_of_rh hRH
  have hc := c0_eq_zero hN
  obtain ⟨C, k, x₀, h⟩ := noRunaway_of_rh hRH
  obtain ⟨K, _, hle⟩ := tail_le h hθlo hθ1
  refine ⟨1, K, one_pos, fun Y₀ => ⟨max Y₀ (max (max x₀ 1) 2), le_max_left _ _,
    fun y hy => ?_⟩⟩
  have hYy := hy.1
  have hy2 : 2 ≤ y := le_trans (le_trans (le_max_right _ _) (le_max_right _ _)) hYy
  have hyx : max x₀ 1 ≤ y := le_trans (le_trans (le_max_left _ _) (le_max_right _ _)) hYy
  rw [G_eq hN (by linarith), hc, zero_mul, zero_add]
  exact le_trans (le_abs_self _) (hle y hyx)

/-- **SpiralLink is the window bounds.** -/
theorem spiralLink_iff_windows : SpiralLink.SpiralLink ↔
    ∀ θ : ℝ, 1 / 2 < θ → θ < 1 → ∃ δ C : ℝ, 0 < δ ∧ LandauWindow.WindowBound θ δ C :=
  ⟨fun h => windows_of_rh (SpiralLink.rh_iff_spiralLink.mpr h),
    fun h => SpiralLink.rh_iff_spiralLink.mp (LandauCriterion.rh_of_windows h)⟩

/-- info: 'WindowsOfRH.c0_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms c0_eq_zero

/-- info: 'WindowsOfRH.windows_of_rh' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms windows_of_rh

/-- info: 'WindowsOfRH.spiralLink_iff_windows' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms spiralLink_iff_windows

end

end WindowsOfRH
