> Source: session transcript, 2026-11-24

> So would a proof be valid if we name for any base x = rate of creep to show that you need x bases to scale the wall?

From `lean_stage3/Stage3/BandJoin.lean`, the circle of the critical line:

```
theorem spiralLink_iff_middle :
    SpiralLink.SpiralLink ↔ ∀ ρ : NontrivialZeros, ‖(2:ℂ) ^ (-(ρ:ℂ))‖ = bandR (1 / 2) := by
```
