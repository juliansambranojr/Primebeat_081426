> Source: session transcript, 2026-11-22, after unit 0410

> Go

From unit 0410's closing paragraph, the item taken up: "the Lean gate read on the shape with one logarithm".

From `lean_stage3/Stage3/JointFloorGate.lean`, the pinned statements:

```
theorem weakWindow_relErr {C : ℝ} {k : ℕ} {f L : ℤ → ℝ} {r : ℤ} {n : ℕ}
    (hC : 0 ≤ C) (hpos : 0 ≤ (r : ℝ) - n)
    (h : Stage3.StmtWeakWindow C k f L r n) :
    JointDialGate.StmtRelErrWindow f L r n
      (C * (Real.log 2 * r) ^ k * (2 : ℝ) ^ (-(((r : ℝ) - n) / 2))) := by
```

```
theorem relErrWindow_floor_of_RH (hRH : RiemannHypothesis) :
    ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ ∀ x₀ : ℝ, 16 ≤ x₀ →
      ∀ (r : ℤ) (n : ℕ), x₀ ^ 2 ≤ (2 : ℝ) ^ ((r : ℝ) - n) → 0 ≤ (r : ℝ) - n →
      JointDialGate.StmtRelErrWindow
        (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
        (fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) r n
        ((3 * Stage3.floorConstSplit c₁ c₃ c₄ 112 0 698
              Kadiri.weightedZeroHeightBucket x₀ + 13)
          * (Real.log 2 * r) ^ 1 * (2 : ℝ) ^ (-(((r : ℝ) - n) / 2))) := by
```

