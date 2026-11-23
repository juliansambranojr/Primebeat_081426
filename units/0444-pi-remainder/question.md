> Source: session transcript, 2026-11-23, after unit 0443

> Yes to the units then work on the open inside these

From `lean_stage3/Stage3/PiRemainder.lean`, the pinned statements:

```
theorem norm_tr_efRem_le_of {x : ℝ} (hx : 256 ≤ x) :
    ‖tr (efRem x) x‖ ≤ Arem * Real.sqrt x * Real.log x ^ 2 :=
```

```
theorem norm_tr_efRem_le :
    ∃ A x₀ : ℝ, 0 ≤ A ∧ ∀ x : ℝ, x₀ ≤ x →
      ‖PiZeros.tr (PiZeros.efRem x) x‖ ≤ A * Real.sqrt x * Real.log x ^ 2 :=
```

```
theorem zinv_le_log {x : ℝ} (hx : 4 ≤ x) : zinv x ≤ Mlow * 39000 * Real.log x ^ 2 :=
```

