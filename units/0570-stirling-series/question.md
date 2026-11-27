> Source: session transcript, 2026-11-25

> Yes to log and stirling



From `lean_stage3/Stage3/StirlingSeriesLim.lean`, the pinned statements:

```
theorem tendsto_A {z : ℂ} (hz : 0 ≤ z.re) (K : ℕ) :
    Tendsto (seqA K z) atTop (𝓝 ((Real.log (2 * Real.pi) / 2 : ℝ) : ℂ)) :=
```

```
theorem stirling_series {z : ℂ} (hz : 0 < z.re) (hY : 1 / 2 ≤ |z.im|) {K : ℕ} (hK : 1 ≤ K) :
    ‖Stirling.logG z - stirMain (K + 1) z - ((Real.log (2 * Real.pi) / 2 : ℝ) : ℂ)‖
      ≤ ZetaEM.bernBound (2 * K) / (2 * K) * (6 / |z.im|) / ‖z‖ ^ (2 * K - 2) :=
```

