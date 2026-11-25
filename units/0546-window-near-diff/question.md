> Source: session transcript, 2026-11-25

> Yes



From `lean_stage3/Stage3/LevinsonWindowNear.lean`, the pinned statements:

```
theorem sum_order_le_lineCount_sub {a b : ℝ} (ha : 0 ≤ a) (hab : a ≤ b) (E : Finset ℝ)
    (hgt : ∀ γ ∈ E, a < γ) (hle : ∀ γ ∈ E, γ ≤ b)
    (hζ : ∀ γ ∈ E, riemannZeta (1/2 + γ * I) = 0) :
    ∑ γ ∈ E, riemannZeta.order (1/2 + γ * I) ≤ lineCount b - lineCount a :=
```

```
theorem lineCount_nonneg (T : ℝ) : 0 ≤ lineCount T :=
```

```
theorem levinson_count_sub {c a b : ℝ} (hc0 : 0 < c) (hc1 : c ≤ 1) (ha : 4 ≤ a) (hab : a < b)
    (hBot : ∀ x ∈ Icc (1/2 : ℝ) 3,
      riemannZeta (↑x + ↑a * I) + c * deriv riemannZeta (↑x + ↑a * I) ≠ 0)
    (hTop : ∀ x ∈ Icc (1/2 : ℝ) 3,
      riemannZeta (↑x + ↑b * I) + c * deriv riemannZeta (↑x + ↑b * I) ≠ 0)
    (hfac : ∀ t ∈ Icc a b,
      1 - c * (deriv Gammaℝ (1/2 + t * I) / Gammaℝ (1/2 + t * I)).re ≠ 0)
    (hζa : riemannZeta (1/2 + a * I) ≠ 0) :
    (riemannZeta.N b - riemannZeta.N a)
      - 2 * Littlewood.countRight (fun s => riemannZeta s + c * deriv riemannZeta s)
          ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2)
      - (72 * Real.log b + 418) ≤ (lineCount b : ℝ) - (lineCount a : ℝ) :=
```

```
theorem levinson_window_diff {T c σ₀ δ X a b K B : ℝ} {M : ℕ} {β : ℕ → ℂ}
    (hT : Real.exp 26 ≤ T) (hc : c = 1 / Real.log T)
    (hM : 1 ≤ M) (hβ1 : β 1 = 1) (hβ : ∀ h, ‖β h‖ ≤ B)
    (hσ₀ : σ₀ < 1 / 2) (hδ : 0 < δ) (hσδ : 1 / 4 ≤ σ₀ - δ)
    (hX : 3 ≤ X) (hXMB : 32 * M * B ≤ (2 : ℝ) ^ X) (hXa : 2 * X ≤ a)
    (hab : a + 3 ≤ b) (hbT : b ≤ T) (hK1 : 1 ≤ K)
    (hK : ∀ a' b' : ℝ, a ≤ a' → a' ≤ a + 1 → b - 1 ≤ b' → b' ≤ b → a' < b' →
      ∀ σ ∈ Icc (σ₀ - δ) σ₀,
      (1 / (b' - a')) * ∫ t in a'..b',
        ‖(riemannZeta (↑σ + ↑t * I) + c * deriv riemannZeta (↑σ + ↑t * I))
          * LevinsonMollEdge.molli M β (↑σ + ↑t * I)‖ ^ 2 ≤ K) :
    (riemannZeta.N b - riemannZeta.N a)
      - (1 / (Real.pi * (1 / 2 - σ₀))) * ((b - a) / 2 * Real.log K + windowE M B X T a b)
      - (134 * Real.log T + 2918) ≤ (lineCount b : ℝ) - (lineCount a : ℝ) :=
```

```
theorem levinson_window_near {T c σ₀ δ X a b K B : ℝ} {M : ℕ} {β : ℕ → ℂ}
    (hT : Real.exp 26 ≤ T) (hc : c = 1 / Real.log T)
    (hM : 1 ≤ M) (hβ1 : β 1 = 1) (hβ : ∀ h, ‖β h‖ ≤ B)
    (hσ₀ : σ₀ < 1 / 2) (hδ : 0 < δ) (hσδ : 1 / 4 ≤ σ₀ - δ)
    (hX : 3 ≤ X) (hXMB : 32 * M * B ≤ (2 : ℝ) ^ X) (hXa : 2 * X ≤ a)
    (hab : a + 3 ≤ b) (hbT : b ≤ T) (hK1 : 1 ≤ K)
    (hK : ∀ a' b' : ℝ, a ≤ a' → a' ≤ a + 1 → b - 1 ≤ b' → b' ≤ b → a' < b' →
      ∀ σ ∈ Icc (σ₀ - δ) σ₀,
      (1 / (b' - a')) * ∫ t in a'..b',
        ‖(riemannZeta (↑σ + ↑t * I) + c * deriv riemannZeta (↑σ + ↑t * I))
          * LevinsonMollEdge.molli M β (↑σ + ↑t * I)‖ ^ 2 ≤ K) :
    (riemannZeta.N b - riemannZeta.N a)
      - (1 / (Real.pi * (1 / 2 - σ₀))) * ((b - a) / 2 * Real.log K + windowE M B X T a b)
      - (134 * Real.log T + 2918) ≤ (lineCount b : ℝ) :=
```

