> Source: session transcript, 2026-09-06, the task that opened this module

> Your task: build one Lean module under this repo's module loop, for section 7 of lean_stage3/design/rung5.md (the comparison at another off-line zero), and commit it through the pre-commit gate together with its unit.

From `lean_stage3/design/rung5.md`, the section the module is built from:

> ## 7. The comparison at another off-line zero — SKETCH

> Zero at `(ε', Δ)`, target at `(ε, 0)`, both read by the same window

> the other zero is suppressed when `Δ² > ε'² − ε²`, at every real part, once

> `h` is large enough that the exponential beats the polynomial. A zero with

From `lean_stage3/design/rung5.md` § 5, the prefactor the comparison pays:

> Prefactor loss between upper and lower bound: one factor `2m+3`.

From `lean_stage3/Stage3/WeilPowerCompare.lean`, the statements as built:

```
theorem norm_S_le_gauss {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0)
    (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) :
    ‖S m w‖ ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖ * Real.exp (Eup m w) := by
```

```
theorem compare_le {m : ℕ} {w : ℂ} {s : ℝ} (hne : QS m w ≠ 0)
    (hw : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (hs : 0 < s)
    (hs2 : s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) :
    ‖S m w‖ ≤ (2 * (m : ℝ) + 3) * (‖w‖ / s) * Real.exp (Eup m w - Elow m s)
      * (S m (s : ℂ)).re := by
```

```
theorem exponent_eq (m : ℕ) (ε' Δ ε h : ℝ) :
    Eup m (wOf ε' Δ h) - Elow m (ε * h)
      = rate m ε' Δ ε * h ^ 2 + qerr m ε' Δ ε * h ^ 4 := by
```

```
theorem compare_suppressed {m : ℕ} {ε' Δ ε h : ℝ} (hε : 0 < ε) (hh : 0 < h) (hε' : ε' ≠ 0)
    (hq : qerr m ε' Δ ε * h ^ 2 ≤ -rate m ε' Δ ε / 2)
    (hw : (ε' ^ 2 + Δ ^ 2) * h ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2)
    (hs : (ε * h) ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) :
    ‖S m (wOf ε' Δ h)‖
      ≤ (2 * (m : ℝ) + 3) * (‖wOf ε' Δ h‖ / (ε * h))
        * Real.exp (rate m ε' Δ ε * h ^ 2 / 2) * (S m ((ε * h : ℝ) : ℂ)).re := by
```
