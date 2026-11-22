> Source: session transcript, 2026-11-22, after unit 0394

> 3b

From `lean_stage3/Stage3/LandauPoleDisc.lean`, the pinned statement:

```
theorem Phi_taylor_on_disc {c : ℂ} {R R₂ : ℝ} (hR : 0 < R) (hRR : R < R₂)
    (hpos : closedBall c R₂ ⊆ {s : ℂ | 0 < s.re}) (hc1 : c ≠ 1)
    (hcz : riemannZeta c ≠ 0) :
    ∃ (P : Finset ℂ) (C : ℝ),
      (∀ ρ, ρ ∈ P ↔ ρ ∈ ball c R₂ ∧ ρ ≠ 1 ∧ riemannZeta ρ = 0) ∧
      ∀ k : ℕ, ‖iteratedDeriv k LandauMellinG.Phi c
        - ∑ ρ ∈ P, (analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ))
            * ((-1) ^ k * (k.factorial : ℂ) * (c - ρ) ^ (-1 - (k : ℤ)))‖
        ≤ k.factorial * C / R ^ k := by
```
