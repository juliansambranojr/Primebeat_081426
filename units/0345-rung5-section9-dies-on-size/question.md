> Source: session transcript, 2026-09-06 (this session), the orchestrator's turn in the loop

> no, i want you to run in the loop next, so you can see how it feels and if it made it better or worse for you. so is that 1 and 2 or 1-4 on your list?

> go

From `lean_stage3/design/rung5.md` § 9 before this unit, the caveat the run started from:

```
Caveat found and not yet resolved: the cluster is defined through `h`, and
Dirichlet picks `h`. Fix in the sketch: define the cluster by an
`h`-independent superset (all off-line zeros within `1/2` in height of the
widened box) and align all of them; `N` is then the band count of the
widened region.
```

From `lean_stage3/Stage3/WeilPowerGauss.lean`, the two bounds whose gap is the finding:

```
theorem cprime_le (m : ℕ) : cS m / D m ≤ 4 / (Real.pi * ((m : ℝ) + 1)) := by
```

```
theorem cprime_ge (m : ℕ) :
    4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) ≤ cS m / D m := by
```

```
theorem sum_inv_sq_ge (m : ℕ) :
    ((m : ℝ) + 2) / (2 * (m : ℝ) + 3) ^ 2 ≤ ∑ j ∈ Finset.Ico (m + 1) (2 * m + 3), 1 / ((j : ℝ) + 1) ^ 2 := by
```
