> Source: session transcript, 2026-11-23

> Prove Carlson's bound ourselves, which is a large project



From `lean_stage3/Stage3/ZeroSquares.lean`, the pinned statements:

```
theorem card_zeros_le {σ δ T : ℝ} (hσ : 1 / 2 < σ - δ) (hσ1 : σ ≤ 1) (hδ : 0 < δ)
    (hδ4 : δ ≤ 1 / 4) (hT : 5 ≤ T) (X : ℕ) (Z : Finset ℂ)
    (hZ : ∀ ρ ∈ Z, riemannZeta ρ = 0 ∧ σ ≤ ρ.re ∧ ρ.re < 1 ∧ 2 ≤ ρ.im ∧ ρ.im ≤ T - 2) :
    Real.pi * δ ^ 2 * (Z.card : ℝ)
      ≤ 3 * (15 * Real.log T + 73)
          * ∫ u in (σ - δ)..(1 + δ), ∫ t in (1:ℝ)..T,
              ‖MollifiedMean.f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2 :=
```

```
theorem square_lower (X : ℕ) {σ δ : ℝ} (hδ : 0 < δ) (hδ4 : δ ≤ 1 / 4) {ρ : ℂ}
    (hz : riemannZeta ρ = 0) (hσρ : σ ≤ ρ.re) (hρ1 : ρ.re < 1) (n : ℕ)
    (hn1 : (n : ℝ) + 2 ≤ ρ.im) (hn2 : ρ.im < (n : ℝ) + 3) :
    Real.pi * δ ^ 2 ≤ ∫ u in (σ - δ)..(1 + δ), innerI X ((n : ℝ) + 7 / 4) ((n : ℝ) + 13 / 4) u :=
```

```
theorem strips_le (X : ℕ) {T : ℝ} (L : ℕ) (hLT : (L : ℝ) + 3 ≤ T) (u : ℝ) :
    ∑ n ∈ Finset.range L, innerI X ((n : ℝ) + 7 / 4) ((n : ℝ) + 13 / 4) u
      ≤ 3 * innerI X 1 T u :=
```

