> Source: session transcript, 2026-09-07, the fourth module under the relay

> Go

> done, resume at § 5.

From `lean_stage3/Stage3/WeilPowerCount.lean`, the leaf and the closure:

```
def StmtShortCount (cnt : ℝ → ℝ) (c₁ c₂ : ℝ) : Prop :=
  ∀ T : ℝ, 2 ≤ T → cnt T ≤ c₁ * Real.log T + c₂
```

```
theorem exists_range_log {c₁ c₂ lρ D E : ℝ} {W : ℕ}
    (hlρ : 0 < lρ) (hc₁ : 0 ≤ c₁) (hc₂ : 0 ≤ c₂) (hD : 0 ≤ D) (hE : 0 ≤ E)
    (hα : c₁ * ((W : ℝ) + 1) * lρ < 1) :
    ∃ L : ℝ, 0 ≤ L ∧ ∀ M : ℝ, 0 ≤ M → M ≤ D + L →
      (c₁ * M + c₂) * ((W : ℝ) + 1) * lρ + E ≤ L := by
```
