> Source: session transcript, 2026-11-23

> Prove Carlson's bound ourselves, which is a large project



From `lean_stage3/Stage3/ZeroSummable.lean`, the pinned statements:

```
theorem summable_order_div {σ : ℝ} (hσ : 1 / 2 < σ) :
    Summable fun ρ : {ρ : Kadiri.NontrivialZeros // σ ≤ ((ρ : Kadiri.NontrivialZeros) : ℂ).re} =>
      ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℝ)
        / ‖((ρ : Kadiri.NontrivialZeros) : ℂ)‖ :=
```

```
theorem summable_norm_coef (S : Set NontrivialZeros) {σ : ℝ} (hσ : 1 / 2 < σ)
    (hS : ∀ ρ ∈ S, σ ≤ (ρ : ℂ).re) :
    Summable fun ρ : S => ‖LadderMean.coef ρ‖ :=
```

```
theorem sum_le_const {σ : ℝ} (hσ : 1 / 2 < σ) (hσ1 : σ ≤ 1) :
    ∃ M : ℝ, ∀ v : Finset NontrivialZeros, (∀ ρ ∈ v, σ ≤ (ρ : ℂ).re) →
      ∑ ρ ∈ v, w ρ ≤ M :=
```

