> Source: session transcript, 2026-11-25

> Yes to all please



From `lean_stage3/Stage3/Defect.lean`, the pinned statements:

```
theorem defect_nonneg (T : ℝ) : 0 ≤ defect T :=
```

```
theorem rh_iff_defect_zero : RiemannHypothesis ↔ ∀ T : ℝ, defect T = 0 :=
```

```
theorem N_le_allCount (T : ℝ) : riemannZeta.N T ≤ (allCount T : ℝ) :=
```

```
theorem N_eq_allCount_right {T T' : ℝ} (hTT' : T < T')
    (hno : ∀ z : ℂ, riemannZeta z = 0 → 0 < z.im → T < z.im → T' < z.im) :
    riemannZeta.N T' = (allCount T : ℝ) ∧ lineCount T' = lineCount T :=
```

```
theorem offLine_pair {T : ℝ} {ρ : NontrivialZeros}
    (hρ : ρ ∈ (zerosUpTo T).filter (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re = 1 / 2)) :
    SpiralLink.mirrorZ ρ ∈
        (zerosUpTo T).filter (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re = 1 / 2) ∧
      SpiralLink.mirrorZ ρ ≠ ρ ∧
      ((SpiralLink.mirrorZ ρ : NontrivialZeros) : ℂ).im = (ρ : ℂ).im ∧
      riemannZeta.order ((SpiralLink.mirrorZ ρ : NontrivialZeros) : ℂ)
        = riemannZeta.order (ρ : ℂ) :=
```

```
theorem defect_even (T : ℝ) : Even (defect T) :=
```

```
theorem defect_le_of_floor {c : ℝ}
    (h : ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
      (c - ε) * riemannZeta.N T ≤ (lineCount T : ℝ)) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
      (defect T : ℝ) ≤ (1 - c + ε) * (allCount T : ℝ) :=
```

```
theorem defect_le : ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
    (defect T : ℝ) ≤ (2 / 3 + ε) * (allCount T : ℝ) :=
```

```
theorem defectN_le : ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
    defectN T ≤ (2 / 3 + ε) * riemannZeta.N T :=
```

