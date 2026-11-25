> Source: session transcript, 2026-11-25

> Yes to all please



From `lean_stage3/Stage3/FloorSum.lean`, the pinned statements:

```
theorem K_ge_one : 1 ≤ Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10) :=
```

```
theorem step_X {ε₁ : ℝ} (hε₁ : 0 < ε₁) : ∃ T₁ : ℝ, 1 ≤ T₁ ∧ ∀ T : ℝ, T₁ ≤ T →
    (1 / 3 - 2 * ε₁) * (riemannZeta.N T - riemannZeta.N (T / 2)) - ε₁ * T * Real.log T
      ≤ (LineCount.lineCount T : ℝ) - (LineCount.lineCount (T / 2) : ℝ) :=
```

```
theorem N_ge : ∀ᶠ T : ℝ in atTop, T * Real.log T / 20 ≤ riemannZeta.N T :=
```

```
theorem levinson_floor : ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
    (1 / 3 - ε) * riemannZeta.N T ≤ (LineCount.lineCount T : ℝ) :=
```

