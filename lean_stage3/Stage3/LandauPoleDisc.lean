/-
LandauPoleDisc — the derivatives of `Phi` at a regular point, from the zeros
of `ζ` in a disc around it.
Block 3b2 of `lean_stage3/design/landau.md`. 2026-11-22.

  Phi_taylor_on_disc   (hR : 0 < R) (hRR : R < R₂)
                       (hpos : closedBall c R₂ ⊆ {s | 0 < s.re})
                       (hc1 : c ≠ 1) (hcz : ζ c ≠ 0) :
                       ∃ P C, (ρ ∈ P ↔ ρ ∈ ball c R₂ ∧ ρ ≠ 1 ∧ ζ ρ = 0) ∧
                         ∀ k, ‖iteratedDeriv k Phi c
                           − Σ_{ρ ∈ P} m_ρ/(ρ(1−ρ))·(−1)^k·k!·(c − ρ)^(−1−k)‖
                           ≤ k!·C/R^k

`m_ρ = analyticOrderNatAt riemannZeta ρ`. The zeros in the closed disc are
finitely many (upstream). `Phi` has a simple pole of residue `m_ρ/(ρ(1−ρ))`
at each and is regular at `1` (`LandauPoleLocal`); subtracting the poles
leaves a function differentiable on the open disc, whose derivatives at the
centre Cauchy's estimate bounds (`LandauPoleSub`).

What the next slice needs: this with `c = σ₀` real and large, `R₂` just
beyond the nearest zeros and `R` between, so that `P` is the set of nearest
zeros and the remainder has a strictly smaller rate (block 7).

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LandauPoleLocal
import Stage3.LandauPoleSub
import PrimeNumberTheoremAnd.IEANTN.ZetaDefinitions

namespace LandauPoleDisc

noncomputable section

open Filter Topology Metric

/-- For `0 < R < R₂`, a closed disc of radius `R₂` about `c` inside `Re s > 0`, `c ≠ 1` and
`ζ c ≠ 0`: there are a finite set `P`, exactly the zeros `ρ ≠ 1` of ζ in the open disc, and a
`C` such that for every `k` the `k`-th derivative of `Phi` at `c` is within `k!·C/R^k` of
`Σ_{ρ ∈ P} m_ρ/(ρ(1−ρ))·(−1)^k·k!·(c − ρ)^(−1−k)`, with `m_ρ` the order of the zero. -/
theorem Phi_taylor_on_disc {c : ℂ} {R R₂ : ℝ} (hR : 0 < R) (hRR : R < R₂)
    (hpos : closedBall c R₂ ⊆ {s : ℂ | 0 < s.re}) (hc1 : c ≠ 1)
    (hcz : riemannZeta c ≠ 0) :
    ∃ (P : Finset ℂ) (C : ℝ),
      (∀ ρ, ρ ∈ P ↔ ρ ∈ ball c R₂ ∧ ρ ≠ 1 ∧ riemannZeta ρ = 0) ∧
      ∀ k : ℕ, ‖iteratedDeriv k LandauMellinG.Phi c
        - ∑ ρ ∈ P, (analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ))
            * ((-1) ^ k * (k.factorial : ℂ) * (c - ρ) ^ (-1 - (k : ℤ)))‖
        ≤ k.factorial * C / R ^ k := by
  classical
  have hZ : (closedBall c R₂ ∩ riemannZeta.zeroes).Finite :=
    riemannZeta.zeroes_on_Compact_finite' (isCompact_closedBall c R₂)
  set P : Finset ℂ := hZ.toFinset.filter (fun ρ => ρ ∈ ball c R₂ ∧ ρ ≠ 1) with hPd
  have hPmem : ∀ ρ, ρ ∈ P ↔ ρ ∈ ball c R₂ ∧ ρ ≠ 1 ∧ riemannZeta ρ = 0 := by
    intro ρ
    rw [hPd, Finset.mem_filter, Set.Finite.mem_toFinset]
    constructor
    · rintro ⟨⟨_, hz⟩, hb, h1⟩
      exact ⟨hb, h1, hz⟩
    · rintro ⟨hb, h1, hz⟩
      exact ⟨⟨ball_subset_closedBall hb, hz⟩, hb, h1⟩
  set A : ℂ → ℂ := fun ρ => if ρ = 1 then 0
    else (analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ)) with hA
  have h1P : (1 : ℂ) ∉ P := fun h => ((hPmem 1).mp h).2.1 rfl
  have hre : ∀ s ∈ ball c R₂, s ≠ 0 := by
    intro s hs h0
    have := hpos (ball_subset_closedBall hs)
    rw [h0] at this
    simp at this
  have hf : ∀ s ∈ ball c R₂, s ∉ insert (1 : ℂ) P →
      DifferentiableAt ℂ LandauMellinG.Phi s := by
    intro s hs hsQ
    rw [Finset.mem_insert, not_or] at hsQ
    refine LandauPoleLocal.differentiableAt_Phi (hre s hs) hsQ.1 (fun hz => ?_)
    exact hsQ.2 ((hPmem s).mpr ⟨hs, hsQ.1, hz⟩)
  have hloc : ∀ p ∈ insert (1 : ℂ) P, ∃ h : ℂ → ℂ, AnalyticAt ℂ h p ∧
      ∀ᶠ s in 𝓝[≠] p, LandauMellinG.Phi s = h s + A p / (s - p) := by
    intro p hp
    rcases Finset.mem_insert.mp hp with rfl | hpP
    · obtain ⟨h, hh, he⟩ := LandauPoleLocal.Phi_regular_at_one
      refine ⟨h, hh, ?_⟩
      filter_upwards [he] with s hs
      rw [hs, hA]
      simp
    · obtain ⟨hb, hp1, hz⟩ := (hPmem p).mp hpP
      obtain ⟨h, hh, he⟩ := LandauPoleLocal.Phi_principal_part (hre p hb) hp1 hz
      refine ⟨h, hh, ?_⟩
      filter_upwards [he] with s hs
      rw [hs, hA]
      simp only [if_neg hp1]
  obtain ⟨g, hg, hgf⟩ := LandauPoleSub.exists_differentiableOn_sub_poles
    (U := ball c R₂) hf hloc
  have hcQ : c ∉ insert (1 : ℂ) P := by
    rw [Finset.mem_insert, not_or]
    exact ⟨hc1, fun h => hcz ((hPmem c).mp h).2.2⟩
  obtain ⟨C, hC⟩ := LandauPoleSub.taylor_coeff_sub_poles hR isOpen_ball
    (closedBall_subset_ball hRR) hcQ hg hgf
  refine ⟨P, C, hPmem, fun k => ?_⟩
  have hk := hC k
  rw [Finset.sum_insert h1P] at hk
  have hA1 : A 1 = 0 := by rw [hA]; simp
  have hsum : ∑ q ∈ P, A q * ((-1) ^ k * (k.factorial : ℂ) * (c - q) ^ (-1 - (k : ℤ)))
      = ∑ ρ ∈ P, (analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ))
          * ((-1) ^ k * (k.factorial : ℂ) * (c - ρ) ^ (-1 - (k : ℤ))) := by
    refine Finset.sum_congr rfl fun ρ hρ => ?_
    have hρ1 : ρ ≠ 1 := ((hPmem ρ).mp hρ).2.1
    rw [hA]
    simp only [if_neg hρ1]
  rw [hA1, zero_mul, zero_add, hsum] at hk
  exact hk

/-- info: 'LandauPoleDisc.Phi_taylor_on_disc' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Phi_taylor_on_disc

end

end LandauPoleDisc
