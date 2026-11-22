> Source: session transcript, 2026-11-22, after unit 0414

> Ok

From the assistant's message before it: "I'd do 1 now and then 2 as a draft for you to read."

From `lean_stage3/Stage3/RouteGate.lean`, the pinned statement:

```
theorem relErrWindow_route (hRH : RiemannHypothesis) :
    ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ ∀ x₀ : ℝ, 16 ≤ x₀ →
      ∀ (r : ℤ) (n : ℕ), x₀ ^ 2 ≤ (2 : ℝ) ^ ((r : ℝ) - n) →
      JointDialGate.StmtRelErrWindow
        (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
        (fun m : ℤ => 2 / Real.log 2
          + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r n
        ((3 * Stage3.floorConstSplit c₁ c₃ c₄ 112 0 698 0 x₀ + 13)
          * (Real.log 2 * r) ^ 1 * (2 : ℝ) ^ (-(((r : ℝ) - n) / 2))) := by
```
