/-
LandauZeroSide — the zeros' reading of the Taylor coefficients of `Phi`,
from below.
Block 7b of `lean_stage3/design/landau.md`. 2026-11-22.

  zero_side   (hz : ζ ρ₀ = 0) (hσ : 1 < σ₀)
              (hS2 : ‖σ₀ − ρ₀‖ < σ₀) :
              ∃ r R τ C₁ N₀, σ₀ − 1 < r ∧ r ≤ ‖σ₀ − ρ₀‖ ∧ r < R ∧ 0 < τ ∧ 0 ≤ C₁ ∧
                ∀ a N, N₀ ≤ N → ∃ k ∈ Ico a (a + N),
                  τ/r^(k+1) − C₁/R^k ≤ Ik σ₀ k / k!

`Ik σ₀ k` is the primes' integral of `LandauPrimeSide`; `(−1)^k·Ik σ₀ k` is the
`k`-th derivative of `Phi` at `σ₀`. `r` is the distance from `σ₀` to the
nearest zeros of `ζ`, `P` the set of those zeros, `R > r` a radius with no
further zero inside. `LandauPoleDisc` gives the derivative as the sum over
`P` up to `k!·C/R^k`. With `z ρ = r/(σ₀ − ρ)`, unimodular, the sum is
`(−1)^k·k!/r^(k+1)·S k`, `S k = Σ_{ρ ∈ P} (A ρ·z ρ)·(z ρ)^k`, real because `P`,
the residues `A ρ` and the `z ρ` are symmetric under conjugation. `LandauTrig`
makes `S k ≥ τ` somewhere in every long block.

What the next slice needs: this lower bound against the upper bound
`LandauPrimeSide.Ik_le`, with the rates of block 7c (block 7d).

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LandauPoleDisc
import Stage3.LandauTrig
import Stage3.LandauPrimeSide

namespace LandauZeroSide

noncomputable section

open Complex Metric Filter Topology
open scoped ComplexConjugate

/-- Past the nearest points of a finite set there is a gap. -/
private lemma exists_gap (F : Finset ℂ) (c : ℂ) (r R₃ : ℝ) (hr : r < R₃) :
    ∃ R₂ : ℝ, r < R₂ ∧ R₂ ≤ R₃ ∧ ∀ ρ ∈ F, ‖c - ρ‖ < R₂ → ‖c - ρ‖ ≤ r := by
  classical
  by_cases h : (F.filter (fun ρ => r < ‖c - ρ‖)).Nonempty
  · obtain ⟨ρm, hρm, hmin⟩ := Finset.exists_min_image _ (fun ρ => ‖c - ρ‖) h
    have hρm' := (Finset.mem_filter.mp hρm).2
    refine ⟨min ‖c - ρm‖ R₃, lt_min hρm' hr, min_le_right _ _, fun ρ hρ hlt => ?_⟩
    by_contra hcon
    push Not at hcon
    have := hmin ρ (Finset.mem_filter.mpr ⟨hρ, hcon⟩)
    exact absurd (lt_of_lt_of_le hlt (min_le_left _ _)) (not_lt.mpr this)
  · refine ⟨R₃, hr, le_rfl, fun ρ hρ _ => ?_⟩
    by_contra hcon
    push Not at hcon
    exact h ⟨ρ, Finset.mem_filter.mpr ⟨hρ, hcon⟩⟩

/-- The zeros' lower bound on the primes' integral. For a zero `ρ₀` of `riemannZeta` and a
real `σ₀ > 1` with `‖σ₀ − ρ₀‖ < σ₀`, there are `r, R, τ, C₁, N₀` with
`σ₀ − 1 < r ≤ ‖σ₀ − ρ₀‖`, `r < R`, `τ > 0`, `C₁ ≥ 0`, such that every run of at least `N₀`
consecutive naturals contains a `k` with `τ/r^(k+1) − C₁/R^k ≤ Ik σ₀ k / k!`. -/
theorem zero_side {ρ₀ : ℂ} (hz : riemannZeta ρ₀ = 0)
    {σ₀ : ℝ} (hσ : 1 < σ₀) (hS2 : ‖(σ₀ : ℂ) - ρ₀‖ < σ₀) :
    ∃ r R τ C₁ : ℝ, ∃ N₀ : ℕ, σ₀ - 1 < r ∧ r ≤ ‖(σ₀ : ℂ) - ρ₀‖ ∧ r < R ∧
      0 < τ ∧ 0 ≤ C₁ ∧ ∀ a N : ℕ, N₀ ≤ N → ∃ k ∈ Finset.Ico a (a + N),
        τ / r ^ (k + 1) - C₁ / R ^ k ≤ LandauPrimeSide.Ik σ₀ k / k.factorial := by
  classical
  obtain ⟨c, hc⟩ : ∃ c : ℂ, c = (σ₀ : ℂ) := ⟨_, rfl⟩
  rw [← hc] at hS2
  have hcre : c.re = σ₀ := by rw [hc]; simp
  have hcconj : conj c = c := by rw [hc, Complex.conj_ofReal]
  obtain ⟨R₃, hR₃⟩ : ∃ R₃ : ℝ, R₃ = (‖c - ρ₀‖ + σ₀) / 2 := ⟨_, rfl⟩
  have hR₃lt : R₃ < σ₀ := by rw [hR₃]; linarith
  have hρ₀R₃ : ‖c - ρ₀‖ < R₃ := by rw [hR₃]; linarith
  have hpos : closedBall c R₃ ⊆ {s : ℂ | 0 < s.re} := by
    intro s hs
    have h1 : |(s - c).re| ≤ ‖s - c‖ := Complex.abs_re_le_norm _
    have h2 : ‖s - c‖ ≤ R₃ := by simpa [dist_eq_norm] using hs
    have h3 := (abs_le.mp (h1.trans h2)).1
    rw [Complex.sub_re, hcre] at h3
    show 0 < s.re
    linarith
  have hZ : (closedBall c R₃ ∩ riemannZeta.zeroes).Finite :=
    riemannZeta.zeroes_on_Compact_finite' (isCompact_closedBall c R₃)
  obtain ⟨F, hF⟩ : ∃ F : Finset ℂ, F = hZ.toFinset := ⟨_, rfl⟩
  have hFmem : ∀ ρ, ρ ∈ F ↔ ‖c - ρ‖ ≤ R₃ ∧ riemannZeta ρ = 0 := by
    intro ρ
    rw [hF, Set.Finite.mem_toFinset]
    constructor
    · rintro ⟨hb, hzρ⟩
      refine ⟨?_, hzρ⟩
      rw [norm_sub_rev]
      simpa [dist_eq_norm] using hb
    · rintro ⟨hb, hzρ⟩
      refine ⟨?_, hzρ⟩
      rw [mem_closedBall, dist_eq_norm, norm_sub_rev]
      exact hb
  have hρ₀F : ρ₀ ∈ F := (hFmem ρ₀).mpr ⟨hρ₀R₃.le, hz⟩
  have hre1 : ∀ ρ : ℂ, riemannZeta ρ = 0 → ρ.re < 1 := by
    intro ρ hzρ
    by_contra h
    exact riemannZeta_ne_zero_of_one_le_re (not_lt.mp h) hzρ
  obtain ⟨ρ₁, hρ₁F, hmin⟩ := Finset.exists_min_image F (fun ρ => ‖c - ρ‖) ⟨ρ₀, hρ₀F⟩
  obtain ⟨r, hr⟩ : ∃ r : ℝ, r = ‖c - ρ₁‖ := ⟨_, rfl⟩
  rw [← hr] at hmin
  have hρ₁ := (hFmem ρ₁).mp hρ₁F
  have hr_le : r ≤ ‖c - ρ₀‖ := hmin ρ₀ hρ₀F
  have hr_gt : σ₀ - 1 < r := by
    have h1 : (c - ρ₁).re ≤ ‖c - ρ₁‖ := Complex.re_le_norm _
    rw [Complex.sub_re, hcre] at h1
    have := hre1 ρ₁ hρ₁.2
    rw [hr]; linarith
  have hr0 : 0 < r := by linarith
  have hrC : (r : ℂ) ≠ 0 := by exact_mod_cast hr0.ne'
  obtain ⟨R₂, hrR₂, hR₂R₃, hgap⟩ := exists_gap F c r R₃ (lt_of_le_of_lt hr_le hρ₀R₃)
  obtain ⟨R, hR⟩ : ∃ R : ℝ, R = (r + R₂) / 2 := ⟨_, rfl⟩
  have hrR : r < R := by rw [hR]; linarith
  have hRR₂ : R < R₂ := by rw [hR]; linarith
  have hR0 : 0 < R := by linarith
  have hc1 : c ≠ 1 := by
    intro h
    have := congrArg Complex.re h
    rw [hcre] at this
    simp at this
    linarith
  have hcz : riemannZeta c ≠ 0 :=
    riemannZeta_ne_zero_of_one_lt_re (by rw [hcre]; exact hσ)
  obtain ⟨P, C₀, hPmem, hbound⟩ := LandauPoleDisc.Phi_taylor_on_disc (c := c) (R := R)
    (R₂ := R₂) hR0 hRR₂ ((closedBall_subset_closedBall hR₂R₃).trans hpos) hc1 hcz
  have hPdist : ∀ ρ ∈ P, ‖c - ρ‖ = r := by
    intro ρ hρ
    obtain ⟨hb, _, hzρ⟩ := (hPmem ρ).mp hρ
    have hlt : ‖c - ρ‖ < R₂ := by
      rw [norm_sub_rev]
      simpa [dist_eq_norm] using hb
    have hρF : ρ ∈ F := (hFmem ρ).mpr ⟨(hlt.trans_le hR₂R₃).le, hzρ⟩
    exact le_antisymm (hgap ρ hρF hlt) (hmin ρ hρF)
  have hP1 : ∀ ρ ∈ P, ρ ≠ 1 := fun ρ hρ => ((hPmem ρ).mp hρ).2.1
  have hPz : ∀ ρ ∈ P, riemannZeta ρ = 0 := fun ρ hρ => ((hPmem ρ).mp hρ).2.2
  have hPre : ∀ ρ ∈ P, 0 < ρ.re := by
    intro ρ hρ
    have hb := ((hPmem ρ).mp hρ).1
    exact hpos ((closedBall_subset_closedBall hR₂R₃) (ball_subset_closedBall hb))
  have hP0 : ∀ ρ ∈ P, ρ ≠ 0 := by
    intro ρ hρ h
    have := hPre ρ hρ
    rw [h] at this
    simp at this
  have hρ₁1 : ρ₁ ≠ 1 := by
    intro h
    have := hre1 ρ₁ hρ₁.2
    rw [h] at this
    simp at this
  have hρ₁P : ρ₁ ∈ P := by
    refine (hPmem ρ₁).mpr ⟨?_, hρ₁1, hρ₁.2⟩
    rw [mem_ball, dist_eq_norm, norm_sub_rev, ← hr]
    exact hrR₂
  have hcρ : ∀ ρ ∈ P, c - ρ ≠ 0 := by
    intro ρ hρ h
    have := hPdist ρ hρ
    rw [h, norm_zero] at this
    linarith
  -- the coefficients and the frequencies
  obtain ⟨A, hA⟩ : ∃ A : ℂ → ℂ,
      A = fun ρ => (analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ)) := ⟨_, rfl⟩
  obtain ⟨z, hzd⟩ : ∃ z : ℂ → ℂ, z = fun ρ => (r : ℂ) / (c - ρ) := ⟨_, rfl⟩
  obtain ⟨S, hS⟩ : ∃ S : ℕ → ℂ, S = fun k => ∑ ρ ∈ P, (A ρ * z ρ) * z ρ ^ k := ⟨_, rfl⟩
  have hsum : ∀ k : ℕ, ∑ ρ ∈ P, (analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ))
        * ((-1) ^ k * (k.factorial : ℂ) * (c - ρ) ^ (-1 - (k : ℤ)))
      = (-1) ^ k * (k.factorial : ℂ) / (r : ℂ) ^ (k + 1) * S k := by
    intro k
    rw [hS, Finset.mul_sum]
    refine Finset.sum_congr rfl fun ρ hρ => ?_
    have hne := hcρ ρ hρ
    have e : (c - ρ) ^ (-1 - (k : ℤ)) = ((c - ρ) ^ (k + 1))⁻¹ := by
      rw [show (-1 - (k : ℤ)) = -((k + 1 : ℕ) : ℤ) by push_cast; ring, zpow_neg, zpow_natCast]
    rw [e, hA, hzd]
    simp only [div_pow]
    field_simp
    try ring
  -- symmetry under conjugation
  have hconjP : ∀ ρ ∈ P, conj ρ ∈ P := by
    intro ρ hρ
    obtain ⟨hb, h1, hzρ⟩ := (hPmem ρ).mp hρ
    refine (hPmem _).mpr ⟨?_, ?_, ?_⟩
    · rw [mem_ball, dist_eq_norm] at hb ⊢
      have : conj ρ - c = conj (ρ - c) := by rw [map_sub, hcconj]
      rw [this, Complex.norm_conj]
      exact hb
    · intro h
      apply h1
      have := congrArg conj h
      simpa using this
    · rw [riemannZeta_conj, hzρ, map_zero]
  have hAconj : ∀ ρ ∈ P, A (conj ρ) = conj (A ρ) := by
    intro ρ hρ
    rw [hA]
    simp only []
    rw [ContourShift.zeta_order_conj (hP1 ρ hρ)]
    simp [map_div₀]
  have hzconj : ∀ ρ : ℂ, z (conj ρ) = conj (z ρ) := by
    intro ρ
    rw [hzd]
    simp [map_div₀, hcconj]
  have hSreal : ∀ k : ℕ, conj (S k) = S k := by
    intro k
    rw [hS]
    simp only [map_sum, map_mul, map_pow]
    refine Finset.sum_nbij' (fun ρ => conj ρ) (fun ρ => conj ρ) hconjP hconjP
      (fun ρ _ => by simp) (fun ρ _ => by simp) (fun ρ hρ => ?_)
    rw [hAconj ρ hρ, hzconj ρ]
  obtain ⟨T, hTd⟩ : ∃ T : ℕ → ℝ, T = fun k => (S k).re := ⟨_, rfl⟩
  have hT : ∀ k : ℕ, (T k : ℂ) = S k := by
    intro k
    rw [hTd]
    exact Complex.conj_eq_iff_re.mp (hSreal k)
  -- the hypotheses of the lemma on exponential sums
  have hznorm : ∀ ρ ∈ P, ‖z ρ‖ = 1 := by
    intro ρ hρ
    rw [hzd]
    simp only []
    rw [norm_div, Complex.norm_real, Real.norm_of_nonneg hr0.le, hPdist ρ hρ, div_self hr0.ne']
  have hzinj : Set.InjOn z (P : Set ℂ) := by
    intro ρ hρ ρ' hρ' h
    rw [hzd] at h
    simp only [] at h
    rw [div_eq_div_iff (hcρ ρ hρ) (hcρ ρ' hρ')] at h
    have h2 := mul_left_cancel₀ hrC h
    linear_combination h2
  have hconst : ∀ ρ ∈ P, z ρ = 1 → 0 ≤ (A ρ * z ρ).re := by
    intro ρ hρ h
    rw [h, mul_one]
    rw [hzd] at h
    simp only [] at h
    have hρeq : ρ = ((σ₀ - r : ℝ) : ℂ) := by
      have h2 := (div_eq_one_iff_eq (hcρ ρ hρ)).mp h
      rw [hc] at h2
      push_cast
      linear_combination h2
    have hx0 : 0 < σ₀ - r := by
      have := hPre ρ hρ
      rw [hρeq] at this
      simpa using this
    have hx1 : σ₀ - r < 1 := by
      have := hre1 ρ (hPz ρ hρ)
      rw [hρeq] at this
      simpa using this
    have hval : A ρ = (((analyticOrderNatAt riemannZeta ρ : ℝ)
        / ((σ₀ - r) * (1 - (σ₀ - r))) : ℝ) : ℂ) := by
      rw [hA]
      simp only []
      have hden : ρ * (1 - ρ) = ((((σ₀ - r) * (1 - (σ₀ - r)) : ℝ)) : ℂ) := by
        rw [hρeq]; push_cast; ring
      rw [hden]
      push_cast
      ring
    rw [hval, Complex.ofReal_re]
    have : 0 < (σ₀ - r) * (1 - (σ₀ - r)) := mul_pos hx0 (by linarith)
    positivity
  have hne : ∃ ρ ∈ P, A ρ * z ρ ≠ 0 := by
    refine ⟨ρ₁, hρ₁P, mul_ne_zero ?_ ?_⟩
    · rw [hA]
      simp only []
      have hm := ContourShift.one_le_zeta_order hρ₁1 hρ₁.2
      refine div_ne_zero (Nat.cast_ne_zero.mpr (by omega))
        (mul_ne_zero (hP0 ρ₁ hρ₁P) (sub_ne_zero.mpr (Ne.symm hρ₁1)))
    · rw [hzd]
      simp only []
      exact div_ne_zero hrC (hcρ ρ₁ hρ₁P)
  obtain ⟨τ, hτ, N₀, hblock⟩ := LandauTrig.exists_large_in_block P (fun ρ => A ρ * z ρ) z
    hznorm hzinj hconst hne T (fun k => by rw [hT k, hS])
  refine ⟨r, R, τ, max C₀ 0, N₀, hr_gt, by rw [← hc]; exact hr_le, hrR, hτ, le_max_right _ _, fun a N hN => ?_⟩
  obtain ⟨k, hk, hτk⟩ := hblock a N hN
  refine ⟨k, hk, ?_⟩
  have hI := LandauPrimeSide.iteratedDeriv_Phi_eq_Ik hσ k
  rw [← hc] at hI
  have hb := hbound k
  rw [hsum k, hI, ← hT k] at hb
  have hreal : (-1) ^ k * ((LandauPrimeSide.Ik σ₀ k : ℝ) : ℂ)
        - (-1) ^ k * (k.factorial : ℂ) / (r : ℂ) ^ (k + 1) * (T k : ℂ)
      = (((-1) ^ k * (LandauPrimeSide.Ik σ₀ k
          - (k.factorial : ℝ) / r ^ (k + 1) * T k) : ℝ) : ℂ) := by
    push_cast
    ring
  rw [hreal, Complex.norm_real, Real.norm_eq_abs, abs_mul, abs_pow, abs_neg, abs_one, one_pow,
    one_mul] at hb
  have h2 := (abs_le.mp hb).1
  have hfac : (0 : ℝ) < k.factorial := by positivity
  have hrk : 0 < r ^ (k + 1) := by positivity
  have hRk : 0 < R ^ k := by positivity
  have e1 : (k.factorial : ℝ) / r ^ (k + 1) * τ ≤ (k.factorial : ℝ) / r ^ (k + 1) * T k :=
    mul_le_mul_of_nonneg_left hτk (by positivity)
  have e2 : (k.factorial : ℝ) * C₀ / R ^ k ≤ (k.factorial : ℝ) * max C₀ 0 / R ^ k := by
    apply div_le_div_of_nonneg_right _ hRk.le
    exact mul_le_mul_of_nonneg_left (le_max_left _ _) hfac.le
  have e3 : (τ / r ^ (k + 1) - max C₀ 0 / R ^ k) * (k.factorial : ℝ)
      = (k.factorial : ℝ) / r ^ (k + 1) * τ - (k.factorial : ℝ) * max C₀ 0 / R ^ k := by
    ring
  rw [le_div_iff₀ hfac, e3]
  linarith

/-- info: 'LandauZeroSide.zero_side' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zero_side

end

end LandauZeroSide
