> Source: session transcript, 2026-11-22, after unit 0429

> Yes and then go on to the open step of joint 10, from "every zero is present in the table's own cells with nonzero weight" to "those cells cannot all stay at square-root size if a zero is off the line"

From `lean_stage3/Stage3/LadderFading.lean`, the pinned statements:

```
theorem sum_sub_shift (Z : Finset ℂ) (c : ℂ → ℂ) {z₀ : ℂ} (hz₀ : z₀ ∈ Z) (r : ℕ) :
    (∑ z ∈ Z, c z * z ^ (r + 1)) - z₀ * ∑ z ∈ Z, c z * z ^ r
      = ∑ z ∈ Z.erase z₀, (c z * (z - z₀)) * z ^ r := by
```

```
theorem not_tendsto_powerSum {R : ℝ} (hR : 0 < R) :
    ∀ (n : ℕ) (Z : Finset ℂ) (c : ℂ → ℂ), Z.card = n → (∀ z ∈ Z, ‖z‖ = R) →
      (∃ z ∈ Z, c z ≠ 0) →
      ¬ Tendsto (fun r : ℕ => (∑ z ∈ Z, c z * z ^ r) / ((R : ℂ)) ^ r) atTop (𝓝 0) := by
```

```
theorem line_not_fading (S : Finset Kadiri.NontrivialZeros) (hS : S.Nonempty) {β : ℝ}
    (hβ : ∀ ρ ∈ S, (ρ : ℂ).re = β) (d : ℕ) :
    ¬ Tendsto (fun r : ℕ =>
        (∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)
          * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (((r : ℤ)) : ℂ))
        / ((((2 : ℝ) ^ β : ℝ)) : ℂ) ^ r) atTop (𝓝 0) := by
```
