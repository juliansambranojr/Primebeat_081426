> Source: session transcript, 2026-09-06 (this session), after unit 0326 was reported

> Let's do rung 5

> Is this logged?

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this decision postdates it).

NOTEPAD: no line yet.

From `lean_stage3/Stage3/WeilDetect.lean`, the header's statement of what is open:

> WHAT IS NOT PROVED. `StmtDetect ε T L` for any explicit L(ε, T). That is the
> bounded-height rectangle theorem: Bombieri's Theorem 8 / Theorem 10 (finite
> multiset of off-line zeros ⇒ negative eigenvalues, no formula for the
> support) made explicit by entry 302's raised-cosine window, with the zeros

From `units/0326-weil-offline-stage3/unit.md`, where the constraint was first recorded:

> What it opens. The identity holds for every zero, so the terms of the other
> off-line zeros have the same shape, with `g` read at their own points. Their
> size grows like `cosh` of their own distance from the line times `h`, while
> their decay in height is polynomial. That is the constraint the next slice
> has to meet, and it is recorded in the transcript bracket of this unit.

From `lean_stage3/Stage3/WeilOffLine.lean` and `lean_stage3/Stage3/WeilLobe.lean`, the theorems the finding rests on:

```
theorem term_eq_neg_sq {h : ℝ} (hh : 0 < h) (γ : ℝ) (ρ : ℂ) :
    laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ)) = -(ghat h γ (ρ - 1 / 2)) ^ 2 := by
```

```
theorem SigmaC_bound (w : ℂ) (hw : w ≠ 0) :
    ‖SigmaC w‖ ≤ (2 * Real.pi + Real.pi ^ 2) * Real.cosh w.re / ‖w‖ ^ 2 := by
```
