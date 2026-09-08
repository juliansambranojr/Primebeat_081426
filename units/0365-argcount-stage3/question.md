> Source: session transcript, 2026-09-08, the count-to-argument step, block H3

> the count-to-argument step

> done, resume at § 5.

From `lean_stage3/Stage3/ArgCount.lean`, four of the six pinned statements:

```
theorem argS_le_gt_two {T : ℝ} (hT : 2 < T) : |Stage3.argS T| ≤ 15 * Real.log T + 75
```

```
theorem sCrude_holds : Stage3.StmtSCrude Stage3.argS 15 600
```

```
theorem sCrude_holds_of_good_two (h2 : good 2) : Stage3.StmtSCrude Stage3.argS 15 75
```

```
theorem rvM_crude : riemannZeta.Riemann_vonMangoldt_bound 112 0 698
```
