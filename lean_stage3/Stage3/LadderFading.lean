/-
LadderFading — block J10b of `lean_stage3/design/joints.md`. 2026-11-22.

Joint 10 on the table's own ladder, second piece. `AliasClass` showed that the
zeros the ladder folds together contribute one mode with a weight that is not
zero. This module shows that finitely many such modes of one size cannot fade:
their sum along the rows is not small against that size. The proof is the
table's own operation: one difference with the symbol of a mode removes that
mode and keeps every other weight nonzero.

  sum_sub_shift          g(r+1) − z₀·g(r) = Σ_{z ≠ z₀} c z·(z − z₀)·z^r
  not_tendsto_powerSum   0 < R, ‖z‖ = R on Z, c z ≠ 0 for some z ∈ Z
                           ⊢ Σ_{z ∈ Z} c z·z^r / R^r does not tend to 0
  one_sub_inv_ne_zero    1 < ‖z‖ ⊢ 1 − z⁻¹ ≠ 0
  line_not_fading        S nonempty, Re ρ = β on S
                           ⊢ Σ_{ρ ∈ S} m(ρ)/ρ·Sym 2 ρ^d·mode 2 ρ r / (2^β)^r
                             does not tend to 0

What the next slice needs: the zeros off the line may be infinitely many; the
finite case is what this module gives, the rest is open in the block.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.AliasClass

namespace LadderFading

open Finset Filter Topology

noncomputable section

/-- **One difference removes one mode.** Differencing a sum of modes with the
symbol of `z₀` deletes the mode `z₀` and multiplies each other weight by
`z − z₀`. -/
theorem sum_sub_shift (Z : Finset ℂ) (c : ℂ → ℂ) {z₀ : ℂ} (hz₀ : z₀ ∈ Z) (r : ℕ) :
    (∑ z ∈ Z, c z * z ^ (r + 1)) - z₀ * ∑ z ∈ Z, c z * z ^ r
      = ∑ z ∈ Z.erase z₀, (c z * (z - z₀)) * z ^ r := by
  rw [Finset.mul_sum, ← Finset.sum_sub_distrib, ← Finset.sum_erase_add Z _ hz₀]
  have h0 : c z₀ * z₀ ^ (r + 1) - z₀ * (c z₀ * z₀ ^ r) = 0 := by ring
  rw [h0, add_zero]
  exact Finset.sum_congr rfl fun z _ => by ring

/-- **Finitely many modes of one size do not fade.** If the modes `z ∈ Z` all
have modulus `R` and at least one has a weight that is not zero, their sum
along the rows, measured against `R^r`, does not tend to zero. -/
theorem not_tendsto_powerSum {R : ℝ} (hR : 0 < R) :
    ∀ (n : ℕ) (Z : Finset ℂ) (c : ℂ → ℂ), Z.card = n → (∀ z ∈ Z, ‖z‖ = R) →
      (∃ z ∈ Z, c z ≠ 0) →
      ¬ Tendsto (fun r : ℕ => (∑ z ∈ Z, c z * z ^ r) / ((R : ℂ)) ^ r) atTop (𝓝 0) := by
  have hRC : (R : ℂ) ≠ 0 := by exact_mod_cast hR.ne'
  intro n
  induction n with
  | zero =>
      intro Z c hcard _ hex _
      obtain ⟨z, hz, _⟩ := hex
      rw [Finset.card_eq_zero.mp hcard] at hz
      simp at hz
  | succ n ih =>
      intro Z c hcard hnorm hex hlim
      obtain ⟨z₀, hz₀, hc₀⟩ := hex
      by_cases hother : ∃ z ∈ Z.erase z₀, c z * (z - z₀) ≠ 0
      · refine ih (Z.erase z₀) (fun z => c z * (z - z₀))
          (by rw [Finset.card_erase_of_mem hz₀, hcard]; rfl)
          (fun z hz => hnorm z (Finset.mem_of_mem_erase hz)) hother ?_
        have hshift := hlim.comp (tendsto_add_atTop_nat 1)
        have h1 := (hshift.const_mul (R : ℂ)).sub (hlim.const_mul z₀)
        simp only [mul_zero, sub_zero] at h1
        refine h1.congr fun r => ?_
        simp only [Function.comp]
        rw [← sum_sub_shift Z c hz₀ r, pow_succ]
        field_simp
      · push Not at hother
        have hzero : ∀ z ∈ Z.erase z₀, c z = 0 := fun z hz => by
          rcases mul_eq_zero.mp (hother z hz) with h | h
          · exact h
          · exact absurd (sub_eq_zero.mp h) (Finset.ne_of_mem_erase hz)
        have hval : ∀ r : ℕ, (∑ z ∈ Z, c z * z ^ r) = c z₀ * z₀ ^ r := fun r => by
          rw [← Finset.sum_erase_add Z _ hz₀,
            Finset.sum_eq_zero (fun z hz => by rw [hzero z hz, zero_mul]), zero_add]
        have hnormc : ∀ r : ℕ,
            ‖(∑ z ∈ Z, c z * z ^ r) / ((R : ℂ)) ^ r‖ = ‖c z₀‖ := fun r => by
          rw [hval, norm_div, norm_mul, norm_pow, norm_pow, hnorm z₀ hz₀, Complex.norm_real,
            Real.norm_of_nonneg hR.le]
          exact mul_div_cancel_right₀ _ (pow_ne_zero r hR.ne')
        have h0 := hlim.norm
        simp only [norm_zero] at h0
        have hconst : Tendsto (fun _ : ℕ => ‖c z₀‖) atTop (𝓝 0) := h0.congr hnormc
        have h := tendsto_nhds_unique hconst tendsto_const_nhds
        exact hc₀ (norm_eq_zero.mp h.symm)

/-- Outside the unit circle the symbol `1 − z⁻¹` is not zero. -/
theorem one_sub_inv_ne_zero {z : ℂ} (hz : 1 < ‖z‖) : (1 : ℂ) - z⁻¹ ≠ 0 := by
  intro h
  have hz' : z⁻¹ = 1 := (sub_eq_zero.mp h).symm
  have h1 : z = 1 := by rw [← inv_inv z, hz', inv_one]
  rw [h1, norm_one] at hz
  linarith

/-- **A finite line of zeros does not fade from the cells.** Take any nonempty
finite set of zeros of ζ with one real part `β`. Their contribution to the cell
`(r, d)` of the table's own ladder, measured against `2^(rβ)`, does not tend to
zero as the rows go on. -/
theorem line_not_fading (S : Finset Kadiri.NontrivialZeros) (hS : S.Nonempty) {β : ℝ}
    (hβ : ∀ ρ ∈ S, (ρ : ℂ).re = β) (d : ℕ) :
    ¬ Tendsto (fun r : ℕ =>
        (∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)
          * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (((r : ℤ)) : ℂ))
        / ((((2 : ℝ) ^ β : ℝ)) : ℂ) ^ r) atTop (𝓝 0) := by
  classical
  have hnormz : ∀ ρ ∈ S, ‖(2 : ℂ) ^ (ρ : ℂ)‖ = (2 : ℝ) ^ β := fun ρ hρ => by
    have h2 : ((2 : ℂ)) = ((2 : ℝ) : ℂ) := by norm_num
    rw [h2, Complex.norm_cpow_eq_rpow_re_of_pos (by norm_num), hβ ρ hρ]
  have hfib : ∀ r : ℕ,
      ∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)
          * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (((r : ℤ)) : ℂ)
        = ∑ z ∈ S.image (fun ρ : Kadiri.NontrivialZeros => (2 : ℂ) ^ (ρ : ℂ)),
            ((∑ ρ ∈ S.filter (fun ρ : Kadiri.NontrivialZeros => (2 : ℂ) ^ (ρ : ℂ) = z),
                (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)) * (1 - z⁻¹) ^ d) * z ^ r := by
    intro r
    rw [← Finset.sum_fiberwise_of_maps_to
      (g := fun ρ : Kadiri.NontrivialZeros => (2 : ℂ) ^ (ρ : ℂ))
      (t := S.image (fun ρ : Kadiri.NontrivialZeros => (2 : ℂ) ^ (ρ : ℂ)))
      (fun ρ hρ => Finset.mem_image_of_mem _ hρ)]
    refine Finset.sum_congr rfl fun z _ => ?_
    rw [AliasClass.alias_weight _ (fun ρ hρ => (Finset.mem_filter.mp hρ).2) d (r : ℤ),
      zpow_natCast]
  intro hlim
  refine not_tendsto_powerSum (Real.rpow_pos_of_pos (by norm_num : (0 : ℝ) < 2) β) _
    (S.image (fun ρ : Kadiri.NontrivialZeros => (2 : ℂ) ^ (ρ : ℂ)))
    (fun z => (∑ ρ ∈ S.filter (fun ρ : Kadiri.NontrivialZeros => (2 : ℂ) ^ (ρ : ℂ) = z),
        (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)) * (1 - z⁻¹) ^ d)
    rfl ?_ ?_ (hlim.congr fun r => by rw [hfib r])
  · intro z hz
    obtain ⟨ρ, hρ, rfl⟩ := Finset.mem_image.mp hz
    exact hnormz ρ hρ
  · obtain ⟨ρ₀, hρ₀⟩ := hS
    refine ⟨(2 : ℂ) ^ (ρ₀ : ℂ), Finset.mem_image_of_mem _ hρ₀, ?_⟩
    have hne : (S.filter (fun ρ : Kadiri.NontrivialZeros =>
        (2 : ℂ) ^ (ρ : ℂ) = (2 : ℂ) ^ (ρ₀ : ℂ))).Nonempty :=
      ⟨ρ₀, Finset.mem_filter.mpr ⟨hρ₀, rfl⟩⟩
    have hz1 : 1 < ‖(2 : ℂ) ^ (ρ₀ : ℂ)‖ := by
      rw [hnormz ρ₀ hρ₀, ← hβ ρ₀ hρ₀]
      exact Real.one_lt_rpow (by norm_num) (AliasClass.zero_re_pos ρ₀)
    exact mul_ne_zero (AliasClass.sum_order_div_ne_zero _ hne)
      (pow_ne_zero d (one_sub_inv_ne_zero hz1))

/-- info: 'LadderFading.sum_sub_shift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sum_sub_shift

/-- info: 'LadderFading.not_tendsto_powerSum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms not_tendsto_powerSum

/-- info: 'LadderFading.line_not_fading' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms line_not_fading

end

end LadderFading
