> Source: session transcript, 2026-11-22, after unit 0391

> Let's do 6

From `lean_stage3/Stage3/LandauTrig.lean`, the pinned statements:

```
theorem sum_block_ge (s : Finset ι) (c z : ι → ℂ)
    (hz : ∀ j ∈ s, ‖z j‖ = 1) (hconst : ∀ j ∈ s, z j = 1 → 0 ≤ (c j).re)
    (T : ℕ → ℝ) (hT : ∀ n, (T n : ℂ) = ∑ j ∈ s, c j * z j ^ n) (a N : ℕ) :
    -(∑ j ∈ s, ‖c j‖ * (2 / ‖z j - 1‖)) ≤ ∑ n ∈ Finset.Ico a (a + N), T n := by
```

```
theorem exists_large_in_block [DecidableEq ι] (s : Finset ι) (c z : ι → ℂ)
    (hz : ∀ j ∈ s, ‖z j‖ = 1) (hinj : Set.InjOn z s)
    (hconst : ∀ j ∈ s, z j = 1 → 0 ≤ (c j).re) (hne : ∃ j ∈ s, c j ≠ 0)
    (T : ℕ → ℝ) (hT : ∀ n, (T n : ℂ) = ∑ j ∈ s, c j * z j ^ n) :
    ∃ τ : ℝ, 0 < τ ∧ ∃ N₀ : ℕ, ∀ a N : ℕ, N₀ ≤ N →
      ∃ n ∈ Finset.Ico a (a + N), τ ≤ T n := by
```
