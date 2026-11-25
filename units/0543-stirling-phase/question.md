> Source: session transcript, 2026-11-25

> Log it and start



From `lean_stage3/Stage3/StirlingX.lean`, the pinned statements:

```
theorem XY_eq_exp {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (t : ℝ) :
    XY α β t = cexp (log (Real.pi : ℂ) * (α + β) +
      ((logG (wm t + -α / 2) + logG (wp t + -β / 2)) -
        (logG (wp t + α / 2) + logG (wm t + β / 2)))) :=
```

```
theorem exponent_le {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} (ht : 1 ≤ t) :
    ‖(log (Real.pi : ℂ) * (α + β) +
      ((logG (wm t + -α / 2) + logG (wp t + -β / 2)) -
        (logG (wp t + α / 2) + logG (wm t + β / 2)))) -
      log (((t / (2 * Real.pi) : ℝ)) : ℂ) * (-(α + β))‖ ≤ 17 / t :=
```

```
theorem stmtXStirlingRel_holds : StmtXStirlingRel :=
```

