> Source: session transcript, 2026-11-23

> Prove Carlson's bound ourselves, which is a large project



From `lean_stage3/Stage3/ZeroDensity.lean`, the pinned statements:

```
theorem zero_density {σ : ℝ} (hσ : 1 / 2 < σ) (hσ1 : σ ≤ 1) :
    ∃ θ C T₀ : ℝ, θ < 1 ∧ 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ Z : Finset ℂ,
      (∀ ρ ∈ Z, riemannZeta ρ = 0 ∧ σ ≤ ρ.re ∧ ρ.re < 1 ∧ 2 ≤ ρ.im ∧ ρ.im ≤ T - 2) →
      (Z.card : ℝ) ≤ C * T ^ θ :=
```

```
theorem inner_le {δ T u : ℝ} {k X N : ℕ} (hδ : 0 < δ) (hδ8 : δ ≤ 1 / 8) (hk2 : 2 ≤ k)
    (hk : 1 ≤ δ * ((k:ℝ) - 1)) (hT2 : 2 ≤ T) (hTk : (k:ℝ) + 2 ≤ T)
    (hX : T ^ δ ≤ X) (hX2 : (X:ℝ) ≤ 2 * T ^ δ) (hN : T ^ (1 + δ) ≤ N)
    (hN2 : (N:ℝ) ≤ 2 * T ^ (1 + δ)) (hX2' : 2 ≤ X) (hXN : X ≤ N) (hTN : T + 3 + k ≤ N)
    (hu : 6 * δ ≤ 2 * u - 1) (hu2 : u ≤ 2) :
    ∫ t in (1:ℝ)..T, ‖MollifiedMean.f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2
      ≤ bConst δ k * T ^ (1 - 6 * δ ^ 2) * (1 + Real.log T) ^ 5 :=
```

```
theorem term4_le {δ T u E : ℝ} {k X N : ℕ} (hδ : 0 < δ) (hT : 1 ≤ T)
    (hk : 1 ≤ δ * ((k:ℝ) - 1)) (hTk : T + 2 + k ≤ 2 * T) (hu : 1 / 2 ≤ u)
    (hX2 : (X:ℝ) ≤ 2 * T ^ δ) (hN : T ^ (1 + δ) ≤ N) :
    T * (X:ℝ) ^ 2 * E ^ 2 * (N:ℝ) ^ (-2 * u)
        * (1 + (T + 2 + k) ^ k * (N:ℝ) ^ (1 - (k:ℝ))) ^ 2
      ≤ 4 * E ^ 2 * (1 + 2 ^ k) ^ 2 * T ^ δ :=
```

