> Source: session transcript, 2026-09-06 (this session), the bracket in which slice B2 was asked for

> Continue

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this module postdates it).

NOTEPAD: no line yet.

Lab notebook:

> ## 2026-09-02 — Entry 303 — pricing a Weil-form leaf for Stage 3: the tree's explicit formula has no test-function argument, upstream states the Weil form (Kadiri Thm 3.1, q = 1) with two limit-manage

From `lean_stage3/Stage3/WeilSeries.lean`, the statements as built:

```
theorem term_le_M {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) (ρ : Kadiri.NontrivialZeros)
    (hre : (ρ : ℂ).re = 1 / 2) (him : 11 / 10 ≤ (ρ : ℂ).im) :
    (laplace (phiC h γ) (-(ρ : ℂ)) * laplace (phiC h γ) (-(1 - (ρ : ℂ)))).re
      ≤ M h γ (idx (ρ : ℂ).im) := by
```

```
theorem tsum_upper_le_explicit' {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) :
    ∑' ρ : Upper, weightedTerm h γ ρ.1
      ≤ 88 * (γ + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2) * (Real.pi ^ 2 / 6) := by
```
