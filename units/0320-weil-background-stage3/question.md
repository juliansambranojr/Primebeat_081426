> Source: session transcript, 2026-09-06 (this session), the bracket in which rung 4b's first half was asked for

> Keep going

> Before writing, one structural fact I have to put in front of you, because it changes the shape of rung 5. The ladder so far tunes a single window to one off-line zero. That detects an isolated off-line zero. If a second off-line zero sits at nearly the same height, its term has the opposite sign available and can cancel the first.

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this module postdates it).

NOTEPAD: no line yet.

Lab notebook:

> ## 2026-09-02 — Entry 303 — pricing a Weil-form leaf for Stage 3: the tree's explicit formula has no test-function argument, upstream states the Weil form (Kadiri Thm 3.1, q = 1) with two limit-mana

From entry 303 §(b), Kadiri's hypotheses on the test function:

```
  trivial case of the Weil-type explicit formula of
  \cite[Theorem 3.1]{Kadiri2005}"). Hypotheses: φ : ℝ → ℂ is C¹;
```

From `lean_stage3/Stage3/WeilBackground.lean`, the statements as built:

```
theorem laplace_phi {h : ℝ} (hh : 0 < h) (γ : ℝ) (z : ℂ) :
    laplace (phiC h γ) z = ghat h γ (-z - 1 / 2) := by
theorem Psi_bound {s : ℝ} (hs : s ≠ 0) : |WeilTransform.Psi s| ≤ (2 * Real.pi + Real.pi ^ 2) / s ^ 2 := by
```
