> Source: session transcript, 2026-11-23

> You don't know when exactly but at some point  you can see the rain is coming



From `lean_stage3/Stage3/StepsBelow.lean`, the pinned statements:

```
theorem zeta_ne_zero_of_steps_bound {s : ℂ} (hs : 0 < s.re) (hs1 : s ≠ 1) (hs2 : s ≠ 2)
    {δ : ℝ} (hδ : 0 ≤ δ) {C : ℝ} {N₁ : ℕ} (hN₁ : 2 ≤ N₁)
    (H : ∀ N : ℕ, N₁ ≤ N → ‖S N s - K N s 1‖ ≤ C * (N:ℝ) ^ δ)
    {ρ : ℂ} (hρ : s.re + δ < ρ.re) (hρ1 : ρ ≠ 1) : ζ ρ ≠ 0 :=
```

```
theorem rain_steps (ρ₀ : Kadiri.NontrivialZeros) {s : ℂ} (hs : 0 < s.re)
    (hne : (ρ₀ : ℂ) ≠ s) {δ : ℝ} (hδ0 : 0 ≤ δ) (hδ : δ < (ρ₀ : ℂ).re - s.re)
    (C : ℝ) (N₀ : ℕ) :
    ∃ N : ℕ, N₀ ≤ N ∧ 2 ≤ N ∧ C * (N : ℝ) ^ δ < ‖StepsPeak.S N s - StepsPeak.K N s 1‖ :=
```

