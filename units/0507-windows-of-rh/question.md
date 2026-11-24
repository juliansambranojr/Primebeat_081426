> Source: session transcript, 2026-11-24

> The reverse direction, RH ⇒ windows



From `lean_stage3/Stage3/WindowsOfRH.lean`, the pinned statements:

```
theorem rampSum_eq_integral {y : ℝ} (hy : 1 ≤ y) :
    LandauWindow.rampSum y = y * ∫ t in Set.Ioc 1 y, ψ t / t ^ 2 :=
```

```
theorem const_eq_zero {c K α : ℝ} {r : ℝ → ℝ} (hα : α < 1) (hK : 0 ≤ K)
    (hG : ∀ y ∈ Set.Ioi (1 : ℝ), LandauWindow.G y = c * y + r y)
    (hr : ∀ y ∈ Set.Ioi (1 : ℝ), |r y| ≤ K * y ^ α) : c = 0 :=
```

```
theorem noRunaway_of_rh (hRH : RiemannHypothesis) : Saddle.NoRunaway :=
```

```
theorem c0_eq_zero (hN : Saddle.NoRunaway) : c0 = 0 :=
```

```
theorem windows_of_rh (hRH : RiemannHypothesis) :
    ∀ θ : ℝ, 1 / 2 < θ → θ < 1 → ∃ δ C : ℝ, 0 < δ ∧ LandauWindow.WindowBound θ δ C :=
```

```
theorem spiralLink_iff_windows : SpiralLink.SpiralLink ↔
    ∀ θ : ℝ, 1 / 2 < θ → θ < 1 → ∃ δ C : ℝ, 0 < δ ∧ LandauWindow.WindowBound θ δ C :=
```

