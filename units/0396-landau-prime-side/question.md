> Source: session transcript, 2026-11-22, after unit 0395

> 7

From `lean_stage3/Stage3/LandauPrimeSide.lean`, the definition and the pinned statements:

```
def Ik (σ : ℝ) (k : ℕ) : ℝ :=
  ∫ y in Ioi (1 : ℝ), LandauWindow.G y * Real.log y ^ k * y ^ (-σ - 1)
```

```
theorem iteratedDeriv_Phi_eq_Ik {σ : ℝ} (hσ : 1 < σ) (k : ℕ) :
    iteratedDeriv k LandauMellinG.Phi (σ : ℂ) = (-1) ^ k * ((Ik σ k : ℝ) : ℂ) := by
```

```
theorem Ik_le {σ θ δ C Y b b' : ℝ} (hσ : 1 < σ) (hθ : θ < σ) (hC : 0 ≤ C) (hY : 1 ≤ Y)
    (hδ : 0 ≤ δ) (hwin : ∀ y ∈ Icc Y (Y ^ (1 + δ)), LandauWindow.G y ≤ C * y ^ θ)
    (hb : 0 < b) (hb' : 0 < b') (hb'a : b' < σ - 1) (k : ℕ) :
    Ik σ k ≤ C * (k.factorial / (σ - θ) ^ (k + 1))
      + 8 * (Y ^ b * (k.factorial / (σ - 1 + b) ^ (k + 1)))
      + 8 * ((Y ^ (1 + δ)) ^ (-b') * (k.factorial / (σ - 1 - b') ^ (k + 1))) := by
```
