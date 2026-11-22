> Source: session transcript, 2026-11-22, after unit 0433

> build "a wobble is invisible to the integer count exactly when it sits at a zero"

From `lean_stage3/Stage3/WobbleCount.lean`, the definition and the pinned statements:

```
def wobbleSum (ρ : ℂ) (N : ℕ) : ℂ :=
  ∑ n ∈ Finset.range N, (N : ℂ) ^ ρ / ((n : ℂ) + 1) ^ ρ
```

```
theorem count_identity (N : ℕ) :
    ∑ n ∈ Finset.Ioc 0 N, Real.log n
      = ∑ d ∈ Finset.Ioc 0 N, ∑ m ∈ Finset.Ioc 0 (N / d), Λ m := by
```

```
theorem wobbleSum_expansion {N : ℕ} (hN : 0 < N) {ρ : ℂ} (hρ : 0 < ρ.re) (hρ1 : ρ ≠ 1) :
    ∃ E : ℂ, ‖E‖ ≤ ‖ρ‖ * ‖ρ + 1‖ / 4 ∧
      wobbleSum ρ N = riemannZeta ρ * (N : ℂ) ^ ρ + (N : ℂ) / (1 - ρ) + 1 / 2 + E := by
```

```
theorem invisible_iff {ρ : ℂ} (hρ : 0 < ρ.re) (hρ1 : ρ ≠ 1) :
    (∃ C : ℝ, ∀ N : ℕ, 0 < N → ‖wobbleSum ρ N - (N : ℂ) / (1 - ρ)‖ ≤ C)
      ↔ riemannZeta ρ = 0 := by
```
