> Source: session transcript, 2026-09-07, after unit 0358 closed the circularity

> Let’s do it

From `lean_stage3/design/rung5.md` § 13, the requirement this unit prices:

```
Replace alignment by averaging. Take `h` over the integers of `[h₀, H]`
with `m + 1 = λh`, weights `w_h = 1/(target lower bound at h)` so the
target's weighted term is at least `1` at every `h`, and consider
`Σ_h w_h · zeroForm(φ_h)`.
```

From `lean_stage3/Stage3/WeilPowerNear.lean`, the sign condition whose reach sets the boundary:

```
theorem bracket_nonneg {e' D θ : ℝ} (h1 : 0 < e') (h3 : 0 < D) (hD : D < e')
    (h0 : 0 ≤ θ)
    (hθ : θ * (2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi) ≤ e' ^ 2 - D ^ 2) :
    0 ≤ (e' ^ 2 - D ^ 2) * Real.cos θ - 2 * e' * D * Real.sin θ := by
```
