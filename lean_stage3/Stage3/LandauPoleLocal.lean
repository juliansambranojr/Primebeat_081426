/-
LandauPoleLocal — `Phi` near a zero of `ζ` and near `1`.
Block 3a of `lean_stage3/design/landau.md`. 2026-11-22.

`Phi s = −ζ'/ζ(s)/(s(s−1)) − 1/(s−1)² + (1+γ)/(s−1)` is `LandauMellinG.Phi`,
the Mellin transform of `G` on `Re s > 1`. As a formula it makes sense
wherever `ζ` does. This module reads its singularities:

  differentiableAt_Phi   (h0 : s ≠ 0) (h1 : s ≠ 1) (hz : ζ s ≠ 0) :
                           DifferentiableAt ℂ Phi s
  Phi_principal_part     (h0 : ρ ≠ 0) (h1 : ρ ≠ 1) (hz : ζ ρ = 0) :
                           ∃ h analytic at ρ, near ρ and off ρ,
                             Phi s = h s + m/(ρ(1−ρ))/(s−ρ),
                           m = analyticOrderNatAt ζ ρ
  Phi_regular_at_one     ∃ h analytic at 1, near 1 and off 1, Phi s = h s

At a zero, `ζ(s) = (s−ρ)^m·g(s)` with `g(ρ) ≠ 0`, so `−ζ'/ζ = −m/(s−ρ) − g'/g`.
At `1`, `ζ(s) = ζ₁(s)/(s−1)` with `ζ₁` entire, `ζ₁(1) = 1`, `ζ₁'(1) = γ`: the
double pole and the simple pole that `Phi` subtracts cancel those of the
first term.

What the next slice needs: these three as the local input of the pole
subtraction on a disc (block 3b).

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LandauMellinG
import Stage3.ContourShift

namespace LandauPoleLocal

noncomputable section

open Complex Filter Topology

/-- If `s ≠ 0`, `s ≠ 1` and `ζ s ≠ 0`, then `Phi` is complex differentiable at `s`. -/
theorem differentiableAt_Phi {s : ℂ} (h0 : s ≠ 0) (h1 : s ≠ 1)
    (hz : riemannZeta s ≠ 0) : DifferentiableAt ℂ LandauMellinG.Phi s := by
  have hd : DifferentiableAt ℂ (deriv riemannZeta) s :=
    (ContourShift.zeta_analyticAt h1).deriv.differentiableAt
  have hζ : DifferentiableAt ℂ riemannZeta s := differentiableAt_riemannZeta h1
  have hs1 : s - 1 ≠ 0 := sub_ne_zero.mpr h1
  have hA : DifferentiableAt ℂ (fun s : ℂ => -deriv riemannZeta s / riemannZeta s) s :=
    hd.neg.div hζ hz
  have hB : DifferentiableAt ℂ (fun s : ℂ => s * (s - 1)) s :=
    differentiableAt_id.mul (differentiableAt_id.sub_const 1)
  have hC : DifferentiableAt ℂ (fun s : ℂ => (s - 1) ^ 2) s :=
    (differentiableAt_id.sub_const 1).pow 2
  have hD : DifferentiableAt ℂ (fun s : ℂ => s - 1) s := differentiableAt_id.sub_const 1
  have h := ((hA.div hB (mul_ne_zero h0 hs1)).sub
    ((differentiableAt_const (1 : ℂ)).div hC (pow_ne_zero 2 hs1))).add
    ((differentiableAt_const (1 + (Real.eulerMascheroniConstant : ℂ))).div hD hs1)
  exact h

/-- At a zero `ρ` of `ζ` with `ρ ≠ 0` and `ρ ≠ 1`, of order `m`, there is a function `h`
analytic at `ρ` such that `Phi s = h s + m/(ρ(1−ρ))/(s−ρ)` for `s` near `ρ`, `s ≠ ρ`. -/
theorem Phi_principal_part {ρ : ℂ} (h0 : ρ ≠ 0) (h1 : ρ ≠ 1) (hz : riemannZeta ρ = 0) :
    ∃ h : ℂ → ℂ, AnalyticAt ℂ h ρ ∧ ∀ᶠ s in 𝓝[≠] ρ, LandauMellinG.Phi s
      = h s + (analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ)) / (s - ρ) := by
  have han := ContourShift.zeta_analyticAt h1
  have htop := ContourShift.zeta_order_ne_top h1
  have hm1 := ContourShift.one_le_zeta_order h1 hz
  obtain ⟨n, hn⟩ : ∃ n : ℕ, analyticOrderNatAt riemannZeta ρ = n + 1 :=
    ⟨analyticOrderNatAt riemannZeta ρ - 1, by omega⟩
  have hord : analyticOrderAt riemannZeta ρ = ((n + 1 : ℕ) : ℕ∞) := by
    rw [← hn, Nat.cast_analyticOrderNatAt htop]
  obtain ⟨g, hg, hg0, hfg⟩ := (han.analyticOrderAt_eq_natCast).mp hord
  have hρ1 : ρ - 1 ≠ 0 := sub_ne_zero.mpr h1
  refine ⟨fun s => -(deriv g s / g s) / (s * (s - 1))
      + ((n : ℂ) + 1) * (s + ρ - 1) / (s * (s - 1) * (ρ * (ρ - 1)))
      - 1 / (s - 1) ^ 2 + (1 + (Real.eulerMascheroniConstant : ℂ)) / (s - 1), ?_, ?_⟩
  · -- analytic at ρ
    have hid : AnalyticAt ℂ (fun s : ℂ => s) ρ := analyticAt_id
    have hsub : AnalyticAt ℂ (fun s : ℂ => s - 1) ρ := hid.sub analyticAt_const
    have hden : AnalyticAt ℂ (fun s : ℂ => s * (s - 1)) ρ := hid.mul hsub
    have hden0 : ρ * (ρ - 1) ≠ 0 := mul_ne_zero h0 hρ1
    have hA : AnalyticAt ℂ (fun s : ℂ => -(deriv g s / g s) / (s * (s - 1))) ρ :=
      ((hg.deriv.div hg hg0).neg).div hden hden0
    have hB : AnalyticAt ℂ
        (fun s : ℂ => ((n : ℂ) + 1) * (s + ρ - 1) / (s * (s - 1) * (ρ * (ρ - 1)))) ρ :=
      (analyticAt_const.mul ((hid.add analyticAt_const).sub analyticAt_const)).div
        (hden.mul analyticAt_const) (mul_ne_zero hden0 hden0)
    have hC : AnalyticAt ℂ (fun s : ℂ => 1 / (s - 1) ^ 2) ρ :=
      analyticAt_const.div (hsub.pow 2) (pow_ne_zero 2 hρ1)
    have hD : AnalyticAt ℂ
        (fun s : ℂ => (1 + (Real.eulerMascheroniConstant : ℂ)) / (s - 1)) ρ :=
      analyticAt_const.div hsub hρ1
    exact ((hA.add hB).sub hC).add hD
  · -- the identity off ρ
    have hderiv : ∀ᶠ s in 𝓝 ρ, deriv riemannZeta s
        = ((n : ℂ) + 1) * (s - ρ) ^ n * g s + (s - ρ) ^ (n + 1) * deriv g s := by
      filter_upwards [hfg.eventually_nhds, hg.eventually_analyticAt] with s hs hgs
      have e : deriv riemannZeta s = deriv (fun z : ℂ => (z - ρ) ^ (n + 1) * g z) s :=
        Filter.EventuallyEq.deriv_eq (by
          filter_upwards [hs] with z hz
          simpa [smul_eq_mul] using hz)
      have h0' : HasDerivAt (fun z : ℂ => z - ρ) 1 s := (hasDerivAt_id s).sub_const ρ
      have hp : HasDerivAt (fun z : ℂ => (z - ρ) ^ (n + 1))
          (((n + 1 : ℕ) : ℂ) * (s - ρ) ^ (n + 1 - 1) * 1) s := h0'.pow (n + 1)
      have hmul : HasDerivAt (fun z : ℂ => (z - ρ) ^ (n + 1) * g z)
          (((n + 1 : ℕ) : ℂ) * (s - ρ) ^ (n + 1 - 1) * 1 * g s
            + (s - ρ) ^ (n + 1) * deriv g s) s :=
        hp.mul hgs.differentiableAt.hasDerivAt
      rw [e, hmul.deriv]
      simp only [Nat.add_sub_cancel]
      push_cast
      ring
    have hgne : ∀ᶠ s in 𝓝 ρ, g s ≠ 0 := hg.continuousAt.eventually_ne hg0
    have hs0 : ∀ᶠ s in 𝓝 ρ, s ≠ 0 := continuousAt_id.eventually_ne h0
    have hs1 : ∀ᶠ s in 𝓝 ρ, s ≠ 1 := continuousAt_id.eventually_ne h1
    have hall := (hfg.and (hderiv.and (hgne.and (hs0.and hs1)))).filter_mono
      (nhdsWithin_le_nhds (s := {ρ}ᶜ))
    filter_upwards [hall, self_mem_nhdsWithin] with s hs hsρ
    obtain ⟨hζs, hds, hgs, hs0', hs1'⟩ := hs
    have hsρ' : s - ρ ≠ 0 := sub_ne_zero.mpr hsρ
    have hs1'' : s - 1 ≠ 0 := sub_ne_zero.mpr hs1'
    have h1ρ : 1 - ρ ≠ 0 := sub_ne_zero.mpr (Ne.symm h1)
    rw [smul_eq_mul] at hζs
    rw [LandauMellinG.Phi, hds, hζs, hn]
    push_cast
    field_simp
    try ring

/-- There is a function `h` analytic at `1` with `Phi s = h s` for `s` near `1`, `s ≠ 1`. -/
theorem Phi_regular_at_one :
    ∃ h : ℂ → ℂ, AnalyticAt ℂ h 1 ∧ ∀ᶠ s in 𝓝[≠] 1, LandauMellinG.Phi s = h s := by
  set N : ℂ → ℂ := fun s => -1 - deriv riemannZeta₁ s / riemannZeta₁ s
      + (1 + (Real.eulerMascheroniConstant : ℂ)) * s with hN
  have hne : ∀ᶠ s in 𝓝 (1 : ℂ), riemannZeta₁ s ≠ 0 := riemannZeta₁_ne_zero_of_near_one
  have hU : {s : ℂ | riemannZeta₁ s ≠ 0} ∈ 𝓝 (1 : ℂ) := hne
  have hNd : DifferentiableOn ℂ N {s : ℂ | riemannZeta₁ s ≠ 0} := by
    intro s hs
    have hd1 : DifferentiableAt ℂ (deriv riemannZeta₁) s :=
      (differentiable_riemannZeta₁.analyticAt s).deriv.differentiableAt
    have hd0 : DifferentiableAt ℂ riemannZeta₁ s := differentiable_riemannZeta₁ s
    exact ((((differentiableAt_const (-1 : ℂ)).sub (hd1.div hd0 hs)).add
      ((differentiableAt_const _).mul differentiableAt_id))).differentiableWithinAt
  have hds : AnalyticAt ℂ (dslope N 1) 1 :=
    ((Complex.differentiableOn_dslope hU).mpr hNd).analyticAt hU
  have hN1 : N 1 = 0 := by
    simp only [hN, deriv_riemannZeta₁_one, riemannZeta₁_one]
    ring
  refine ⟨fun s => dslope N 1 s / s, hds.div analyticAt_id one_ne_zero, ?_⟩
  have hs0 : ∀ᶠ s in 𝓝 (1 : ℂ), s ≠ 0 := continuousAt_id.eventually_ne one_ne_zero
  have hall := (hne.and hs0).filter_mono (nhdsWithin_le_nhds (s := {(1 : ℂ)}ᶜ))
  filter_upwards [hall, self_mem_nhdsWithin] with s hs hs1
  obtain ⟨hζ1, hs0'⟩ := hs
  have hs1' : s ≠ 1 := hs1
  have hs1'' : s - 1 ≠ 0 := sub_ne_zero.mpr hs1'
  rw [dslope_of_ne _ hs1', slope_def_field, hN1, sub_zero, LandauMellinG.Phi,
    deriv_riemannZeta_eq_neg_inv_sub_sq_mul_add hs1', riemannZeta_eq_inv_sub_mul hs1']
  simp only [hN]
  field_simp
  try ring

/-- info: 'LandauPoleLocal.differentiableAt_Phi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms differentiableAt_Phi

/-- info: 'LandauPoleLocal.Phi_principal_part' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Phi_principal_part

/-- info: 'LandauPoleLocal.Phi_regular_at_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Phi_regular_at_one

end

end LandauPoleLocal
