> Source: session transcript, 2026-11-23

> flip the table inside out and it becomes a line



From `lean_stage3/Stage3/ShareLink.lean`, the pinned statements:

```
theorem share_is_re {T : ℝ} (hT : 1 < T) (ρ : NontrivialZeros) :
    Real.logb T ‖(T : ℂ) ^ (ρ : ℂ)‖ = (ρ : ℂ).re :=
```

```
theorem pair_shares_add {T : ℝ} (hT : 1 < T) (ρ : NontrivialZeros) :
    Real.logb T ‖(T : ℂ) ^ (ρ : ℂ)‖
      + Real.logb T ‖(T : ℂ) ^ ((mirrorZ ρ : NontrivialZeros) : ℂ)‖ = 1 :=
```

```
theorem meet_sqrt_iff {T : ℝ} (hT : 1 < T) (ρ : NontrivialZeros) :
    ‖(T : ℂ) ^ (ρ : ℂ)‖ = Real.sqrt T ↔ (ρ : ℂ).re = 1 / 2 :=
```

```
theorem spiralLink_iff_meet :
    SpiralLink.SpiralLink ↔ ∀ ρ : NontrivialZeros,
      ‖((2 : ℝ) : ℂ) ^ (ρ : ℂ)‖ = ‖((2 : ℝ) : ℂ) ^ ((mirrorZ ρ : NontrivialZeros) : ℂ)‖ :=
```

