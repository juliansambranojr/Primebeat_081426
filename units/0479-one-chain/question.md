> Source: session transcript, 2026-11-23

> Is the loop compiled by itself or does it connect to every theorem in the tree we went over the past three days? That's what I'm shooting for



From `lean_stage3/Stage3/OneChain.lean`, the pinned statements:

```
theorem one_chain :
    (RiemannHypothesis ↔ SpiralLink.SpiralLink) ∧
    (SpiralLink.SpiralLink ↔ OneAtEachHeight) ∧
    (SpiralLink.SpiralLink ↔ ∀ ρ : NontrivialZeros, restoringForce (ρ : ℂ).re = 0) ∧
    (SpiralLink.SpiralLink ↔ ∃ (C : ℝ) (r₀ : ℤ), CellResidual.CellsSqrt C r₀) :=
```

```
theorem table_of_spiralLink (h : SpiralLink.SpiralLink) :
    ∃ (C : ℝ) (r₀ : ℤ), ∀ (d : ℕ) (r : ℤ), r₀ + ((d + 1 : ℕ) : ℤ) ≤ r →
      |((Construction.tableFrom TableRoute.rowN r d : ℤ) : ℝ)
          - Nonvanishing.stencilR (d + 1) (fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) r|
        ≤ C * CellResidual.cellSize r d :=
```

```
theorem spiralLink_of_finite (F : Finset NontrivialZeros)
    (hF : ∀ ρ : NontrivialZeros, (ρ : ℂ).re ≠ 1 / 2 → ρ ∈ F) (C : ℝ)
    (hrows : ∀ᶠ r : ℕ in Filter.atTop,
      |(Nat.primeCounting ⌊(2:ℝ) ^ r⌋₊ : ℝ) - Stage3.Li ((2:ℝ) ^ r)|
        ≤ C * (r : ℝ) ^ 2 * Real.sqrt 2 ^ r) : SpiralLink.SpiralLink :=
```

```
theorem spiralLink_of_attained (ρ₀ : NontrivialZeros)
    (hmax : ∀ ρ : NontrivialZeros, (ρ : ℂ).re ≤ (ρ₀ : ℂ).re) (C : ℝ)
    (hrows : ∀ᶠ r : ℕ in Filter.atTop,
      |(Nat.primeCounting ⌊(2:ℝ) ^ r⌋₊ : ℝ) - Stage3.Li ((2:ℝ) ^ r)|
        ≤ C * (r : ℝ) ^ 2 * Real.sqrt 2 ^ r) : SpiralLink.SpiralLink :=
```

```
theorem spiralLink_of_finite_accumulation {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    (hfin : ∀ σ : ℝ, 1/2 < σ → ∃ P : Finset ℂ, (∀ p ∈ P, p ≠ 0) ∧
      (∀ ε : ℝ, 0 < ε → {z : ℂ | ∃ ρ : NontrivialZeros, σ ≤ (ρ : ℂ).re ∧
        (2:ℂ) ^ (ρ : ℂ) = z ∧ ∀ p ∈ P, ε ≤ ‖z - p‖}.Finite) ∧
      (∀ ρ : NontrivialZeros, σ < (ρ : ℂ).re → (2:ℂ) ^ (ρ : ℂ) ∉ P)) :
    SpiralLink.SpiralLink :=
```

```
theorem no_exposed_zero {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → |(Nat.primeCounting ⌊(2:ℝ)^k⌋₊ : ℝ) - Stage3.Li ((2:ℝ)^k)|
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    {σ Θ : ℝ} (hσ : 1/2 < σ) (hσΘ : σ < Θ) (hΘ1 : Θ ≤ 1)
    (hΘ : ∀ ρ : NontrivialZeros, (ρ:ℂ).re ≤ Θ) :
    ∃ E : ℝ, σ ≤ E ∧ E < Θ ∧ ∀ (ρ₁ : NontrivialZeros), E < (ρ₁:ℂ).re →
      ∀ κ r₀ : ℝ, 0 ≤ κ → r₀ < ‖(2:ℂ)^(ρ₁:ℂ)‖ + κ →
      (∀ ρ : NontrivialZeros, σ ≤ (ρ:ℂ).re → (2:ℂ)^(ρ:ℂ) ≠ (2:ℂ)^(ρ₁:ℂ) →
        ‖(2:ℂ)^(ρ:ℂ) + (κ:ℂ) * ((2:ℂ)^(ρ₁:ℂ) / ‖(2:ℂ)^(ρ₁:ℂ)‖)‖ ≤ r₀) → False :=
```

