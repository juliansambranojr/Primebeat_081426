> Source: session transcript, 2026-09-06 (this session), the bracket in which slice B3 was asked for

> Continue

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this module postdates it).

NOTEPAD: no line yet.

Lab notebook:

> ## 2026-09-02 — Entry 303 — pricing a Weil-form leaf for Stage 3: the tree's explicit formula has no test-function argument, upstream states the Weil form (Kadiri Thm 3.1, q = 1) with two limit-manage

From `lean_stage3/Stage3/WeilOnLine.lean`, the statements as built:

```
theorem lowSet_finite : lowSet.Finite := by
```

```
theorem tsum_onLine_le {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) :
    ∑' ρ : OnLine, weightedTerm h γ ρ.1 ≤ onLineBound h γ := by
```

```
theorem onLineBound_le {h γ : ℝ} (hγ : 11 / 10 ≤ γ) :
    onLineBound h γ
      ≤ 2 * (88 * (γ + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2) * (Real.pi ^ 2 / 6))
        + 4 * h ^ 2 * lowCount := by
```
