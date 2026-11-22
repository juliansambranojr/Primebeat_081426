> Source: session transcript, 2026-11-22, after the two corrections to joint 9's draft

> 2

From the assistant's message before it: "2. **The forward statement (9a):** the table of `G` is the zero sum reweighted by the symbol."

From `lean_stage3/Stage3/JointSymbol.lean`, the definitions and the pinned statements:

```
def dd (f : ℝ → ℂ) : ℝ → ℂ := fun y => f y - f (y / 2)
```

```
theorem mellin_dd_iter {s : ℂ} (hs : 1 < s.re) (d : ℕ) :
    ∫ y in Ioi (1 : ℝ), (dd^[d] cutG) y * (y : ℂ) ^ (-s - 1)
      = (1 - (2 : ℂ) ^ (-s)) ^ d * LandauMellinG.Phi s := by
```

```
theorem dd_iter_rule (f : ℝ → ℂ) (d : ℕ) (y : ℝ) :
    (dd^[d + 1] f) y = (dd^[d] f) y - (dd^[d] f) (y / 2) := by
```

```
theorem symPhi_principal_part {ρ : ℂ} (h0 : ρ ≠ 0) (h1 : ρ ≠ 1)
    (hz : riemannZeta ρ = 0) (d : ℕ) :
    ∃ h : ℂ → ℂ, AnalyticAt ℂ h ρ ∧ ∀ᶠ s in 𝓝[≠] ρ,
      (1 - (2 : ℂ) ^ (-s)) ^ d * LandauMellinG.Phi s
        = h s + (1 - (2 : ℂ) ^ (-ρ)) ^ d
            * ((analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ))) / (s - ρ) := by
```
