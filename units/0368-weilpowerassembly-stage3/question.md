> Source: session transcript, 2026-09-08, after units 0366 and 0367

> Let's finish it and do 1. We might be surprised cause you won't know until you get there

From `lean_stage3/Stage3/WeilPowerAssembly.lean`, the def and the pin the module carries:

```
def StmtDetectGap (ε T δ L : ℝ) : Prop :=
  (OffLineBox ε T).Nonempty →
  (∃ ρ₀ ∈ OffLineBox ε T,
    ∀ ρ ∈ (OffLineBox ε T : Set ℂ), ρ ≠ ρ₀ →
      |ρ.im - ρ₀.im| ∉ Set.Ioo (Real.pi ^ 3 / (8 * ε * L / 2)) δ) →
  ∃ G : ℝ → ℂ, IsTest L G ∧ (zeroForm G).re < 0
```

```
theorem detect_gap_exists {ε T δ : ℝ}
    (_hε : 0 < ε) (_hT : 2 ≤ T) (_hδ : 0 < δ) (_hδ1 : δ ≤ 1/2) :
    ∃ L : ℝ, StmtDetectGap ε T δ L
```
