> Source: session transcript, 2026-11-25

> Yes to all please



From `lean_stage3/Stage3/TuringSlope.lean`, the pinned statements:

```
theorem theta_sub_le_sharp {t u : ℝ} (ht : 5 ≤ t) (htu : t ≤ u) :
    Stage3.phaseTheta u - Stage3.phaseTheta t
      ≤ (u - t) * (Real.log (u / (2 * Real.pi)) / 2 + 1 / t) :=
```

```
theorem theta_sub_le_sharp80 {t u : ℝ} (ht : 80 ≤ t) (htu : t ≤ u) :
    Stage3.phaseTheta u - Stage3.phaseTheta t
      ≤ (u - t) * (Real.log (u / (2 * Real.pi)) / 2 + (4 / 5) / t) :=
```

```
theorem turing_S_le_sharp {t h : ℝ} (ht : 80 ≤ t) (hh : 0 < h) :
    S t ≤ ((3 / 2 + 113 / 4) / Real.pi * Real.log (t + h)
        + (2 + (3 / 2) * Real.log 9 + 128) / Real.pi) / h
      + h * (Real.log ((t + h) / (2 * Real.pi)) / 2 + (4 / 5) / t) / (2 * Real.pi) :=
```

