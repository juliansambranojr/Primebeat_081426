> Source: session transcript, 2026-11-23, after unit 0444

> Yes to the units then work on the open inside these

From `lean_stage3/Stage3/FiniteOffLinePi.lean`, the pinned statements:

```
theorem norm_ipart_le {ρ : ℂ} (hb0 : 0 < ρ.re) (hb1 : ρ.re ≤ 1) {x : ℝ} (hx : 4 ≤ x) :
    ‖ipart ρ x‖
      ≤ ‖ρ‖⁻¹ * (3 * Real.sqrt x + 4 * x ^ ρ.re / (ρ.re * Real.log x ^ 2)) :=
```

```
theorem row_bound (F S : Finset NontrivialZeros) (hSF : S ⊆ F) {β : ℝ}
    (hSβ : ∀ ρ ∈ S, (ρ : ℂ).re = β)
    (hF : ∀ ρ : NontrivialZeros, (ρ : ℂ).re ≠ 1 / 2 → ρ ∈ F) (C : ℝ) {r : ℕ} (hr : 8 ≤ r)
    (hFr : F ⊆ ZF ((2:ℝ) ^ r))
    (hrow : |(Nat.primeCounting ⌊(2:ℝ) ^ r⌋₊ : ℝ) - Stage3.Li ((2:ℝ) ^ r)|
      ≤ C * (r : ℝ) ^ 2 * Real.sqrt 2 ^ r) :
    ‖∑ ρ ∈ S, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * (((2:ℂ) ^ (ρ : ℂ)) ^ r / (ρ : ℂ))‖
      ≤ rowBound F S β C r :=
```

```
theorem finite_off_line_pi (F : Finset NontrivialZeros)
    (hF : ∀ ρ : NontrivialZeros, (ρ : ℂ).re ≠ 1 / 2 → ρ ∈ F) (C : ℝ)
    (hrows : ∀ᶠ r : ℕ in atTop,
      |(Nat.primeCounting ⌊(2:ℝ) ^ r⌋₊ : ℝ) - Stage3.Li ((2:ℝ) ^ r)|
        ≤ C * (r : ℝ) ^ 2 * Real.sqrt 2 ^ r) :
    RiemannHypothesis :=
```

