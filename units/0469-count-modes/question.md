> Source: session transcript, 2026-11-23

> Merge then the count



From `lean_stage3/Stage3/CountModes.lean`, the pinned statements:

```
theorem im_ne_zero (ρ : NontrivialZeros) : (ρ : ℂ).im ≠ 0 :=
```

```
theorem J_sub {k : ℕ} (hk : 1 ≤ k) {w : ℂ} (hw : w.im ≠ 0) :
    J k w - J 1 w = ∫ v in (1:ℝ)..(k:ℝ), Complex.exp ((v:ℂ) * w) / (v:ℂ) :=
```

```
theorem piMode_doubling (ρ : NontrivialZeros) {k : ℕ} (hk : 1 ≤ k) :
    PiZeros.piMode (ρ:ℂ) ((2:ℝ)^k) = J k ((ρ:ℂ) * Real.log 2) + cst ρ :=
```

```
theorem norm_cst_le (ρ : NontrivialZeros) : ‖cst ρ‖ ≤ 4 / (|(ρ:ℂ).im| * Real.log 2) :=
```

