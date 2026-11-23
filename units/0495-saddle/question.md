> Source: session transcript, 2026-11-23

> Go for sequence 1-3 and saddle



From `lean_stage3/Stage3/Saddle.lean`, the pinned statements:

```
theorem fold_rounding (N d : ℕ) :
    Int.fract (2 * (N : ℝ) / (d : ℝ))
      = if Int.fract ((N : ℝ) / (d : ℝ)) < 1 / 2 then 2 * Int.fract ((N : ℝ) / (d : ℝ))
        else 2 * Int.fract ((N : ℝ) / (d : ℝ)) - 1 :=
```

```
theorem fold_mirror (x : ℝ) (h : Int.fract (2 * x) ≠ 0) :
    Int.fract (2 * (1 - x)) = 1 - Int.fract (2 * x) :=
```

```
theorem saddle_area (ρ : NontrivialZeros) : stretch ρ * stretch (mirrorZ ρ) = 1 :=
```

```
theorem saddle_of_off_line (ρ : NontrivialZeros) (h : (ρ : ℂ).re ≠ 1 / 2) :
    (1 < stretch ρ ∧ stretch (mirrorZ ρ) < 1) ∨ (stretch ρ < 1 ∧ 1 < stretch (mirrorZ ρ)) :=
```

```
theorem saddle_runs_away (ρ : NontrivialZeros) (h : (ρ : ℂ).re ≠ 1 / 2)
    (C : ℝ) (k : ℕ) (x₀ : ℝ) :
    ∃ x : ℝ, x₀ ≤ x ∧ C * x ^ ((1 : ℝ) / 2) * Real.log x ^ k < |Chebyshev.psi x - x| :=
```

```
theorem spiralLink_iff_noRunaway : SpiralLink.SpiralLink ↔ NoRunaway :=
```

