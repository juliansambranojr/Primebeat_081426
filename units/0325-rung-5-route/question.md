> Source: session transcript, 2026-09-06 (this session), after unit 0324 was reported

> Is that the best way or the easy way? I’m genuinely curious

> Log it and come back to discuss

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this decision postdates it).

NOTEPAD: no line yet.

From `units/0320-weil-background-stage3/unit.md`, the split this decision revisits:

> A structural fact recorded here for rung 5. One tuned window detects an
> ISOLATED off-line zero. A second off-line zero at nearly the same height
> contributes a term of the opposite sign and can cancel the first. Bombieri
> (2000) Theorem 8 handles that with a finite Hermitian matrix over all the
> off-line zeros in the box and a count of its negative eigenvalues, with a
> linear combination of tuned functions rather than one. So rung 5 splits:
> 5a, the isolated case, which these rungs support; 5b, the general case,

From `lean_stage3/Stage3/WeilOnLine.lean` and `lean_stage3/Stage3/WeilBackground.lean`, the two theorems the decision rests on:

```
theorem tsum_onLine_le {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) :
    ∑' ρ : OnLine, weightedTerm h γ ρ.1 ≤ onLineBound h γ := by
```

```
theorem online_term_le_far {h : ℝ} (hh : 0 < h) (γ : ℝ) {ρ : ℂ} (hρ : ρ.re = 1 / 2)
    (hfar : 1 ≤ |ρ.im - γ|) (hsum : 1 ≤ ρ.im + γ) :
    (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re
      ≤ (h / 2) ^ 2 * ((2 * Real.pi + Real.pi ^ 2) / (h * (ρ.im - γ)) ^ 2
          + (2 * Real.pi + Real.pi ^ 2) / (h * (ρ.im + γ)) ^ 2) ^ 2 := by
```
