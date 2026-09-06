> Source: session transcript, 2026-09-06 (this session), the bracket in which rung 5 was started

> Let's do rung 5

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this module postdates it).

NOTEPAD: no line yet.

Lab notebook:

> ## 2026-09-02 — Entry 303 — pricing a Weil-form leaf for Stage 3: the tree's explicit formula has no test-function argument, upstream states the Weil form (Kadiri Thm 3.1, q = 1) with two limit-manage

From `lean_stage3/Stage3/WeilOffLine.lean`, the statements as built:

```
theorem term_eq_neg_sq {h : ℝ} (hh : 0 < h) (γ : ℝ) (ρ : ℂ) :
    laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ)) = -(ghat h γ (ρ - 1 / 2)) ^ 2 := by
```

```
theorem offline_term_le_explicit {h γ ε : ℝ} (hh : 0 < h) (hγ : 0 < γ)
    (hs : (2 * Real.pi + Real.pi ^ 2) * Real.cosh (ε * h) / (2 * γ * h) ^ 2
      ≤ WeilWindow.Sigma (ε * h)) :
    (laplace (phiC h γ) (-offPt ε γ) * laplace (phiC h γ) (-(1 - offPt ε γ))).re
      ≤ -((h / 2) ^ 2 * (WeilWindow.Sigma (ε * h)
          * (WeilWindow.Sigma (ε * h)
              - 2 * ((2 * Real.pi + Real.pi ^ 2) * Real.cosh (ε * h) / (2 * γ * h) ^ 2)))) := by
```
