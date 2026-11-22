> Source: session transcript, 2026-11-22, after the merge of pull request 8

> The harder general case

From `lean_stage3/Stage3/LadderMean.lean`, the pinned statements:

```
theorem mean_extract {ι : Type*} (w C : ι → ℂ) (hw : ∀ i, ‖w i‖ = 1)
    (hC : Summable fun i => ‖C i‖) (k : ι)
    (h : Tendsto (fun r : ℕ => ∑' i, C i * w i ^ r) atTop (𝓝 0)) :
    ∑' i, (if w i = w k then C i else 0) = 0 := by
```

```
theorem line_not_fading_summable (S : Set Kadiri.NontrivialZeros) {β : ℝ}
    (hβ : ∀ ρ ∈ S, (ρ : ℂ).re = β) (ρ₀ : Kadiri.NontrivialZeros) (hρ₀ : ρ₀ ∈ S)
    (hsum : Summable fun ρ : S => ‖coef ρ‖) (d : ℕ) :
    ¬ Tendsto (fun r : ℕ =>
        (∑' ρ : S, coef ρ * Chain.Sym 2 ((ρ : Kadiri.NontrivialZeros) : ℂ) ^ d
          * Chain.mode 2 ((ρ : Kadiri.NontrivialZeros) : ℂ) (((r : ℤ)) : ℂ))
        / ((((2 : ℝ) ^ β : ℝ)) : ℂ) ^ r) atTop (𝓝 0) := by
```
