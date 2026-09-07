> Source: session transcript, 2026-09-07, the second module under the relay, the first at loop version 16

> Go

> done, resume at § 5.

From `lean_stage3/Stage3/WeilPowerNear.lean`, the pinned statements:

```
theorem bracket_nonneg {e' D θ : ℝ} (h1 : 0 < e') (h3 : 0 < D) (hD : D < e')
    (h0 : 0 ≤ θ)
    (hθ : θ * (2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi) ≤ e' ^ 2 - D ^ 2) :
    0 ≤ (e' ^ 2 - D ^ 2) * Real.cos θ - 2 * e' * D * Real.sin θ := by
```

```
theorem term_nonneg {e' D e : ℝ} {lam h b : ℕ} (h1 : 0 < e') (h3 : 0 < D)
    (hD : D < e') (h5 : 0 < e) (hl : 1 ≤ lam) (hh : 1 ≤ h) (hhb : h ≤ b)
    (hN : 4 * e' * D * ((b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
            * (2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi) ≤ e' ^ 2 - D ^ 2) :
    0 ≤ (WeilPowerShell.coef e' D e
          * Complex.exp (WeilPowerShell.zOf e' D e
              * ((WeilPowerGeomGen.uLam lam h : ℝ) : ℂ))).re := by
```

```
theorem shellSum_nonneg {e' D e : ℝ} {lam a b : ℕ} (h1 : 0 < e') (h3 : 0 < D)
    (hD : D < e') (h5 : 0 < e) (hl : 1 ≤ lam) (ha : 1 ≤ a)
    (hN : 4 * e' * D * ((b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
            * (2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi) ≤ e' ^ 2 - D ^ 2) :
    0 ≤ WeilPowerShell.shellSum e' D e lam a b := by
```
