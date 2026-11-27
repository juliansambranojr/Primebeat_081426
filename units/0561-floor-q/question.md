> Source: session transcript, 2026-11-25

> Yes to all please



From `lean_stage3/Stage3/FloorQ.lean`, the pinned statements:

```
theorem logmaxQ_le {x ε₁ : ℝ} (hε₁ : 0 < ε₁)
    (hx : x ≤ KflQ Q0 (FloorConst.Ar P0) (FloorConst.Br P0) (FloorConst.Cr P0) (49 / 100) (3 / 2)
      + 2 * ε₁) :
    Real.log (max 1 x) / (3 / 2) ≤ (1 - 224 / 625) + 2 * ε₁ :=
```

```
theorem stepQ {ε₁ : ℝ} (hε₁ : 0 < ε₁) : ∃ T₁ : ℝ, 1 ≤ T₁ ∧ ∀ T : ℝ, T₁ ≤ T →
    (224 / 625 - 2 * ε₁) * (riemannZeta.N T - riemannZeta.N (T / 2)) - ε₁ * T * Real.log T
      ≤ (LineCount.lineCount T : ℝ) - (LineCount.lineCount (T / 2) : ℝ) :=
```

```
theorem levinson_floorQ : ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
    (224 / 625 - ε) * riemannZeta.N T ≤ (LineCount.lineCount T : ℝ) :=
```

