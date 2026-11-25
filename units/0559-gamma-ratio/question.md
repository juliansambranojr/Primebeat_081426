> Source: session transcript, 2026-11-25

> Yes please



From `lean_stage3/Stage3/GrRatio.lean`, the pinned statements:

```
theorem gamma_ratio8 : ∃ B : ℝ, 0 < B ∧ ∀ T : ℝ, 16 ≤ T → ∀ z w : ℂ,
    1 / 8 ≤ z.re → z.re ≤ 7 → 1 / 8 ≤ w.re → w.re ≤ 7 →
    T / 8 ≤ z.im → z.im ≤ 3 * T → T / 8 ≤ w.im → w.im ≤ 3 * T → |z.im - w.im| ≤ 1 →
    ‖Gammaℝ z‖ / ‖Gammaℝ w‖ * Real.exp (-(Real.log T / 2) * (z.re - w.re)) ≤ B :=
```

```
theorem grR_sub {L : ℝ} (hL : L ≠ 0) (i : ℕ) {w : ℂ} (hw0 : 0 < w.re) :
    (((-1 / L) ^ i : ℝ) : ℂ) * MeanQ.grR i w - (((-1 / 2 : ℝ) ^ i : ℝ) : ℂ) =
      ∑ j ∈ Finset.range i, (i.choose (j + 1) : ℂ) * (((-1 / 2 : ℝ) ^ (i - (j + 1)) : ℝ) : ℂ) *
        ((((-1 / L) ^ (j + 1) : ℝ) : ℂ) * iteratedDeriv (j + 1) (hw L w) w) :=
```

```
theorem stmtGrRatio_holds (n : ℕ) : MeanQ.StmtGrRatio n :=
```

