> Source: session transcript, 2026-11-25

> Yes



From `lean_stage3/Stage3/LevinsonWindow.lean`, the pinned statements:

```
theorem countRight_right_le {f : ℂ → ℂ} {z w w' : ℂ} {σ : ℝ}
    (hsub : Rectangle z w' ⊆ Rectangle z w) (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hz : f z ≠ 0) : countRight f z w' σ ≤ countRight f z w σ :=
```

```
theorem lineCount_mono {T T' : ℝ} (h : T ≤ T') : lineCount T ≤ lineCount T' :=
```

```
theorem N_step_le {t u : ℝ} (ht : 4 ≤ t) (htu : t ≤ u) (hu : u ≤ t + 1) :
    riemannZeta.N u - riemannZeta.N t ≤ 31 * Real.log u + 1250 :=
```

```
theorem G_line_ne {c t : ℝ} (hc : c ≠ 0)
    (hfac : 1 - c * (deriv Gammaℝ (1/2 + t * I) / Gammaℝ (1/2 + t * I)).re ≠ 0)
    (hs : riemannZeta (1/2 + t * I) = 0 → deriv riemannZeta (1/2 + t * I) ≠ 0) :
    riemannZeta (1/2 + t * I) + c * deriv riemannZeta (1/2 + t * I) ≠ 0 :=
```

```
theorem levinson_window {T c σ₀ δ X a b K B : ℝ} {M : ℕ} {β : ℕ → ℂ}
    (hT : Real.exp 26 ≤ T) (hc : c = 1 / Real.log T)
    (hM : 1 ≤ M) (hβ1 : β 1 = 1) (hβ : ∀ h, ‖β h‖ ≤ B)
    (hσ₀ : σ₀ < 1 / 2) (hδ : 0 < δ) (hσδ : 1 / 4 ≤ σ₀ - δ)
    (hX : 3 ≤ X) (hXMB : 32 * M * B ≤ (2 : ℝ) ^ X) (hXa : 2 * X ≤ a)
    (hab : a + 3 ≤ b) (hbT : b ≤ T) (hK1 : 1 ≤ K)
    (hK : ∀ a' b' : ℝ, a ≤ a' → a' < b' → b' ≤ b → ∀ σ ∈ Icc (σ₀ - δ) σ₀,
      (1 / (b' - a')) * ∫ t in a'..b',
        ‖(riemannZeta (↑σ + ↑t * I) + c * deriv riemannZeta (↑σ + ↑t * I))
          * LevinsonMollEdge.molli M β (↑σ + ↑t * I)‖ ^ 2 ≤ K)
    (hsimple : ∀ t ∈ Icc a b,
      riemannZeta (1/2 + t * I) = 0 → deriv riemannZeta (1/2 + t * I) ≠ 0) :
    (riemannZeta.N b - riemannZeta.N a)
      - (1 / (Real.pi * (1 / 2 - σ₀))) * ((b - a) / 2 * Real.log K + windowE M B X T a b)
      - (134 * Real.log T + 2918) ≤ (lineCount b : ℝ) :=
```

