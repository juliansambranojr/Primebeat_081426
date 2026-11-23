> Source: session transcript, 2026-11-23

> the inversion of the deep zero flips the table into a band



From `lean_stage3/Stage3/BandJoin.lean`, the pinned statements:

```
theorem share_pair {P C tot : ℝ} (ht : tot ≠ 0) (h : P + C = tot) :
    bandR (P / tot) * bandR (C / tot) = 1 / 2 :=
```

```
theorem zero_in_band (ρ : NontrivialZeros) :
    1 / 2 < ‖(2:ℂ) ^ (-(ρ:ℂ))‖ ∧ ‖(2:ℂ) ^ (-(ρ:ℂ))‖ < 1 :=
```

```
theorem zero_pair (ρ : NontrivialZeros) :
    ‖(2:ℂ) ^ (-(ρ:ℂ))‖ * ‖(2:ℂ) ^ (-((SpiralLink.mirrorZ ρ : NontrivialZeros):ℂ))‖ = 1 / 2 :=
```

```
theorem spiralLink_iff_middle :
    SpiralLink.SpiralLink ↔ ∀ ρ : NontrivialZeros, ‖(2:ℂ) ^ (-(ρ:ℂ))‖ = bandR (1 / 2) :=
```

