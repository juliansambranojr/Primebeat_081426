> Source: session transcript, 2026-11-23

> the whole repos about the table as the start and what we worked on especially today was the table



From `lean_stage3/Stage3/WholeChain.lean`, the pinned statements:

```
theorem whole_chain :
    (RiemannHypothesis ↔ SpiralLink.SpiralLink) ∧
    (SpiralLink.SpiralLink ↔ OneAtEachHeight) ∧
    (SpiralLink.SpiralLink ↔ ∃ (C : ℝ) (r₀ : ℤ), CellResidual.CellsSqrt C r₀) ∧
    (SpiralLink.SpiralLink ↔ HalfSieve.WobbleSqrt) ∧
    (SpiralLink.SpiralLink ↔
      ∀ ρ : NontrivialZeros, ‖(2 : ℂ) ^ (-(ρ : ℂ))‖ = BandJoin.bandR (1 / 2)) ∧
    (SpiralLink.SpiralLink ↔ ∀ ρ : NontrivialZeros,
      ‖((2 : ℝ) : ℂ) ^ (ρ : ℂ)‖ = ‖((2 : ℝ) : ℂ) ^ ((mirrorZ ρ : NontrivialZeros) : ℂ)‖) ∧
    (SpiralLink.SpiralLink ↔ ∀ ρ : NontrivialZeros, Saddle.stretch ρ = 1) ∧
    (SpiralLink.SpiralLink ↔ Saddle.NoRunaway) :=
```

```
theorem table_side :
    (∀ N : ℕ, 2 ≤ N →
      (Nat.primeCounting N : ℤ) = (Nat.primeCounting (Nat.sqrt N) : ℤ) - 1 +
        ∑ T ∈ (SieveExact.smallPrimes N).powerset,
          (-1 : ℤ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℤ)) ∧
    (∀ N : ℕ, ((Finset.Icc 2 N).filter (fun n => ¬ n.Prime)).card
        + (SieveExact.smallPrimes N).card
      = ∑ p ∈ SieveExact.smallPrimes N, CompositeSplit.rough N p) ∧
    (∀ N : ℕ, N = Compression.smooth N + ∑ p ∈ Compression.newPrimes N, N / p) ∧
    (∀ N : ℕ, ∑ k ∈ Finset.Icc 1 N, Chebyshev.psi ((N : ℝ) / (k : ℝ))
      = ∑ n ∈ Finset.Icc 1 N, Real.log (n : ℝ)) ∧
    (∀ (ρ : ℂ) (k : ℤ),
      (2 : ℂ) ^ (ρ + 2 * Real.pi * Complex.I * (k : ℂ) / (Real.log 2 : ℂ)) = (2 : ℂ) ^ ρ) :=
```

```
theorem steps_side :
    (∀ ρ : NontrivialZeros,
      -(analyticOrderNatAt riemannZeta (ρ : ℂ) : ℂ) / (ρ : ℂ) ≠ 0) ∧
    (∀ (ρ₀ : NontrivialZeros) (θ : ℝ), θ < (ρ₀ : ℂ).re → ∀ (C : ℝ) (k : ℕ) (x₀ : ℝ),
      ∃ x : ℝ, x₀ ≤ x ∧ C * x ^ θ * Real.log x ^ k < |Chebyshev.psi x - x|) ∧
    (∀ (ρ₀ : NontrivialZeros) (s : ℂ), 0 < s.re → (ρ₀ : ℂ) ≠ s → ∀ δ : ℝ, 0 ≤ δ →
      δ < (ρ₀ : ℂ).re - s.re → ∀ (C : ℝ) (N₀ : ℕ),
      ∃ N : ℕ, N₀ ≤ N ∧ 2 ≤ N ∧ C * (N : ℝ) ^ δ < ‖StepsPeak.S N s - StepsPeak.K N s 1‖) :=
```

