> Source: session transcript, 2026-11-22, after unit 0392

> Block 3

From `lean_stage3/Stage3/LandauPoleLocal.lean`, the pinned statements:

```
theorem differentiableAt_Phi {s : ℂ} (h0 : s ≠ 0) (h1 : s ≠ 1)
    (hz : riemannZeta s ≠ 0) : DifferentiableAt ℂ LandauMellinG.Phi s := by
```

```
theorem Phi_principal_part {ρ : ℂ} (h0 : ρ ≠ 0) (h1 : ρ ≠ 1) (hz : riemannZeta ρ = 0) :
    ∃ h : ℂ → ℂ, AnalyticAt ℂ h ρ ∧ ∀ᶠ s in 𝓝[≠] ρ, LandauMellinG.Phi s
      = h s + (analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ)) / (s - ρ) := by
```

```
theorem Phi_regular_at_one :
    ∃ h : ℂ → ℂ, AnalyticAt ℂ h 1 ∧ ∀ᶠ s in 𝓝[≠] 1, LandauMellinG.Phi s = h s := by
```
