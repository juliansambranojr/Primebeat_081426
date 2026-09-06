> Source: session transcript, 2026-09-06 (this session), the bracket in which slice A was asked for

> Continue

> The lemma I need is `Real.tsum_le_of_sum_le` ... Writing slice A: the multiplicity bridge, the band count for on-line zeros near a height, and the band sum bound.

(The second quote is the compaction summary's record of the design sentence; the original message did not survive compaction, and the ellipsis is the summary's.)

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this module postdates it).

NOTEPAD: no line yet.

Lab notebook:

> ## 2026-09-02 — Entry 303 — pricing a Weil-form leaf for Stage 3: the tree's explicit formula has no test-function argument, upstream states the Weil form (Kadiri Thm 3.1, q = 1) with two limit-manage

From `lean_stage3/Stage3/JensenCount.lean`, the count this slice consumes:

```
theorem zeta_local_zero_count {T : ℝ} (hT : 2 ≤ T) :
    ∑ ρ ∈ (zetaWindow_finite hT).toFinset, (analyticOrderNatAt ζ ρ : ℝ)
      ≤ 15 * Real.log T + 73 := by
```

From `lean_stage3/Stage3/WeilBands.lean`, the statements as built:

```
theorem band_count {T : ℝ} (hT : 2 ≤ T) (S : Finset ℂ)
    (hS : ∀ ρ ∈ S, riemannZeta ρ = 0 ∧ ρ.re = 1 / 2 ∧ |ρ.im - T| ≤ 9 / 10) :
    ∑ ρ ∈ S, (analyticOrderNatAt riemannZeta ρ : ℝ) ≤ 15 * Real.log T + 73 := by
```
