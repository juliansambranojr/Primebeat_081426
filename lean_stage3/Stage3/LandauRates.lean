/-
LandauRates — the scalar inequalities of the assembly.
Block 7c of `lean_stage3/design/landau.md`. 2026-11-22.

  key_ineq          (0 < δ ≤ 1) (0 ≤ λ ≤ δ²/240) :
                      4(λ − log(1−δ/12)) < (1+δ)(log(1+δ/3) − λ)
                      ∧ 0 < log(1+δ/3) − λ ∧ 0 < λ − log(1−δ/12)
  exists_centre     (0 ≤ θ < Re ρ₀ < 1) (0 < δ) :
                      ∃ σ₀ > 1, ‖σ₀ − ρ₀‖ < σ₀ − θ ∧ ‖σ₀ − ρ₀‖ ≤ (σ₀ − 1)(1 + δ²/240)
  exists_pow_small  (0 ≤ q < 1) (0 < ε) : ∃ K, ∀ k ≥ K, c·q^k < ε

`key_ineq` is the inequality between the rates of the two tails that leaves
room for a range of indices on which both are small. `exists_centre` chooses
the real point the Taylor coefficients are read at, far enough to the right
that a given zero is nearer to it than `θ` is, and nearly as near as `1`.

What the next slice needs: these three, in the proof of the criterion
(block 7d).

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Mathlib

namespace LandauRates

noncomputable section

open Filter Topology

theorem key_ineq {δ lam : ℝ} (hδ0 : 0 < δ) (hδ1 : δ ≤ 1) (hl0 : 0 ≤ lam)
    (hl : lam ≤ δ ^ 2 / 240) :
    4 * (lam - Real.log (1 - δ / 12)) < (1 + δ) * (Real.log (1 + δ / 3) - lam)
      ∧ 0 < Real.log (1 + δ / 3) - lam ∧ 0 < lam - Real.log (1 - δ / 12) := by
  have hx : 0 < 1 - δ / 12 := by linarith
  have hy : 0 < 1 + δ / 3 := by linarith
  have hδ2 : δ ^ 2 ≤ δ := by nlinarith
  have hδ3 : δ ^ 3 ≤ δ ^ 2 := by nlinarith [sq_nonneg δ]
  have h1 : -Real.log (1 - δ / 12) ≤ δ / 12 + δ ^ 2 / 132 := by
    have h := Real.log_le_sub_one_of_pos (inv_pos.mpr hx)
    rw [Real.log_inv] at h
    have h' : (1 - δ / 12)⁻¹ ≤ 1 + δ / 12 + δ ^ 2 / 132 := by
      rw [inv_eq_one_div, div_le_iff₀ hx]
      nlinarith [sq_nonneg δ]
    linarith
  have h2 : δ / 3 - δ ^ 2 / 9 ≤ Real.log (1 + δ / 3) := by
    have h := Real.log_le_sub_one_of_pos (inv_pos.mpr hy)
    rw [Real.log_inv] at h
    have h' : (1 + δ / 3)⁻¹ ≤ 1 - δ / 3 + δ ^ 2 / 9 := by
      rw [inv_eq_one_div, div_le_iff₀ hy]
      nlinarith [sq_nonneg δ, pow_pos hδ0 3]
    linarith
  have hneg : Real.log (1 - δ / 12) < 0 := Real.log_neg hx (by linarith)
  have hL3 : δ / 3 - δ ^ 2 / 9 - lam ≤ Real.log (1 + δ / 3) - lam := by linarith
  have hmul : (1 + δ) * (δ / 3 - δ ^ 2 / 9 - lam)
      ≤ (1 + δ) * (Real.log (1 + δ / 3) - lam) :=
    mul_le_mul_of_nonneg_left hL3 (by linarith)
  have hδl : δ * lam ≤ lam := by nlinarith
  refine ⟨?_, ?_, by linarith⟩
  · have e : (1 + δ) * (δ / 3 - δ ^ 2 / 9 - lam)
        = δ / 3 + δ ^ 2 / 3 - δ ^ 2 / 9 - δ ^ 3 / 9 - lam - δ * lam := by ring
    nlinarith
  · nlinarith

theorem exists_centre {ρ₀ : ℂ} {θ δ : ℝ} (hθ0 : 0 ≤ θ) (hθ : θ < ρ₀.re)
    (h1 : ρ₀.re < 1) (hδ : 0 < δ) :
    ∃ σ₀ : ℝ, 1 < σ₀ ∧ ‖(σ₀ : ℂ) - ρ₀‖ < σ₀ - θ
      ∧ ‖(σ₀ : ℂ) - ρ₀‖ ≤ (σ₀ - 1) * (1 + δ ^ 2 / 240) := by
  obtain ⟨M, hM⟩ : ∃ M : ℝ, M = max (240 * (1 + |ρ₀.im|) / δ ^ 2)
      (ρ₀.im ^ 2 / (ρ₀.re - θ)) := ⟨_, rfl⟩
  have hβθ : 0 < ρ₀.re - θ := by linarith
  have hδ2 : 0 < δ ^ 2 := by positivity
  have hM1 : 240 * (1 + |ρ₀.im|) ≤ M * δ ^ 2 := by
    have : 240 * (1 + |ρ₀.im|) / δ ^ 2 ≤ M := by rw [hM]; exact le_max_left _ _
    rwa [div_le_iff₀ hδ2] at this
  have hM2 : ρ₀.im ^ 2 ≤ M * (ρ₀.re - θ) := by
    have : ρ₀.im ^ 2 / (ρ₀.re - θ) ≤ M := by rw [hM]; exact le_max_right _ _
    rwa [div_le_iff₀ hβθ] at this
  have hM0 : 0 ≤ M := by
    have : 0 ≤ 240 * (1 + |ρ₀.im|) := by positivity
    nlinarith
  have hre : ((M + 2 : ℝ) : ℂ).re - ρ₀.re = M + 2 - ρ₀.re := by simp
  have hwre : (((M + 2 : ℝ) : ℂ) - ρ₀).re = M + 2 - ρ₀.re := by simp
  have hwim : (((M + 2 : ℝ) : ℂ) - ρ₀).im = -ρ₀.im := by simp
  refine ⟨M + 2, by linarith, ?_, ?_⟩
  · have hsq : ‖((M + 2 : ℝ) : ℂ) - ρ₀‖ ^ 2 < (M + 2 - θ) ^ 2 := by
      rw [Complex.sq_norm, Complex.normSq_apply, hwre, hwim]
      nlinarith
    exact lt_of_pow_lt_pow_left₀ 2 (by linarith) hsq
  · have h := Complex.norm_le_abs_re_add_abs_im (((M + 2 : ℝ) : ℂ) - ρ₀)
    rw [hwre, hwim, abs_neg, abs_of_pos (by linarith : 0 < M + 2 - ρ₀.re)] at h
    nlinarith

theorem exists_pow_small {q c ε : ℝ} (hq0 : 0 ≤ q) (hq1 : q < 1) (hε : 0 < ε) :
    ∃ K : ℕ, ∀ k : ℕ, K ≤ k → c * q ^ k < ε := by
  have h := (tendsto_pow_atTop_nhds_zero_of_lt_one hq0 hq1).const_mul c
  rw [mul_zero] at h
  exact eventually_atTop.mp (h.eventually (gt_mem_nhds hε))

/-- info: 'LandauRates.key_ineq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms key_ineq

/-- info: 'LandauRates.exists_centre' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exists_centre

/-- info: 'LandauRates.exists_pow_small' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exists_pow_small

end

end LandauRates
