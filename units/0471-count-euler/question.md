> Source: session transcript, 2026-11-23

> Merge then the count



From `lean_stage3/Stage3/CountEuler.lean`, the pinned statements:

```
theorem transform_eq {w : ℂ} (hw : w.im ≠ 0) (c : ℂ) (m : ℕ) :
    ∑ j ∈ Finset.range (m + 1), coefE c m j * CountModes.J (j + 1) w = F w c m :=
```

```
theorem class_main {w : ℂ} (hw : w.im ≠ 0) {p κ : ℝ} (hp : 0 ≤ p) (hκ : 0 ≤ κ) (m : ℕ) :
    ∫ s in Set.Ioi (0:ℝ), Pc w p κ m s
      = (((p + κ) ^ (m + 1) : ℝ) : ℂ) / (((m + 1 : ℕ) : ℂ) * w)
        + (∫ s in Set.Ioi (0:ℝ), Qc w p κ (m + 1) s) / ((m + 1 : ℕ) : ℂ) :=
```

```
theorem euler_exposed_false {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → |(Nat.primeCounting ⌊(2:ℝ)^k⌋₊ : ℝ) - Stage3.Li ((2:ℝ)^k)|
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    {σ Θ : ℝ} (hσ : 1/2 < σ) (hσΘ : σ < Θ) (hΘ1 : Θ ≤ 1)
    (hΘ : ∀ ρ : Kadiri.NontrivialZeros, (ρ:ℂ).re ≤ Θ) :
    ∃ E : ℝ, σ ≤ E ∧ E < Θ ∧ ∀ (ρ₁ : Kadiri.NontrivialZeros), E < (ρ₁:ℂ).re →
      ∀ κ r₀ : ℝ, 0 ≤ κ → r₀ < ‖(2:ℂ)^(ρ₁:ℂ)‖ + κ →
      (∀ ρ : Kadiri.NontrivialZeros, σ ≤ (ρ:ℂ).re → (2:ℂ)^(ρ:ℂ) ≠ (2:ℂ)^(ρ₁:ℂ) →
        ‖(2:ℂ)^(ρ:ℂ) + (κ:ℂ) * ((2:ℂ)^(ρ₁:ℂ) / ‖(2:ℂ)^(ρ₁:ℂ)‖)‖ ≤ r₀) → False :=
```

