> Source: session transcript, 2026-11-24

> Yes



From `lean_stage3/Stage3/LevinsonCount.lean`, the pinned statements:

```
theorem G_analyticOnNhd_rect (c : ℝ) {a b : ℝ} (ha : 4 ≤ a) (hab : a ≤ b) :
    AnalyticOnNhd ℂ (fun s => riemannZeta s + c * deriv riemannZeta s)
      (Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I)) :=
```

```
theorem levinson_count {c a b : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) (ha : 4 ≤ a) (hab : a < b)
    (hB : ∀ p ∈ RectangleBorder ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I),
      riemannZeta p + c * deriv riemannZeta p ≠ 0)
    (hfac : ∀ t ∈ Set.Icc a b,
      1 - c * (deriv Gammaℝ (1/2 + t * I) / Gammaℝ (1/2 + t * I)).re ≠ 0) :
    (riemannZeta.N b - riemannZeta.N a)
      - 2 * Littlewood.countRight (fun s => riemannZeta s + c * deriv riemannZeta s)
          ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2)
      - (72 * Real.log b + 418) ≤ (lineCount b : ℝ) :=
```

