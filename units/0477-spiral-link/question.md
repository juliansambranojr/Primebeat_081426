> Source: session transcript, 2026-11-23

> State that link in lean



From `lean_stage3/Stage3/SpiralLink.lean`, the pinned statements:

```
theorem mirrorZ_eq_iff (ρ : NontrivialZeros) : mirrorZ ρ = ρ ↔ (ρ : ℂ).re = 1 / 2 :=
```

```
theorem off_line_is_two (ρ : NontrivialZeros) (h : (ρ : ℂ).re ≠ 1 / 2) :
    mirrorZ ρ ≠ ρ ∧ ((mirrorZ ρ : NontrivialZeros) : ℂ).im = (ρ : ℂ).im ∧
      ¬ isHermitianHandshake (ρ : ℂ).re ∧
      ¬ isHermitianHandshake ((mirrorZ ρ : NontrivialZeros) : ℂ).re :=
```

```
theorem rh_iff_spiralLink : RiemannHypothesis ↔ SpiralLink :=
```

```
theorem rh_iff_one_at_each_height : RiemannHypothesis ↔ OneAtEachHeight :=
```

```
theorem spiralLink_iff_one : SpiralLink ↔ OneAtEachHeight :=
```

