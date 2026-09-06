> Source: session transcript, 2026-09-06 (this session), the orchestrator's second turn in the loop

> Ok let's keep going

From `lean_stage3/Stage3/WeilPowerPhase.lean`, the statements:

```
theorem T_eq_mul {m : ℕ} {w : ℂ} (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (n : ℕ) :
    T m w n = Complex.exp (w ^ 2 * ((sigmaN m n : ℝ) : ℂ)) * Complex.exp (delta m w n) := by
```

```
theorem norm_S_sub_le {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0)
    (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (hq : q m w ≤ 1) :
    ‖S m w - ((cS m / D m : ℝ) : ℂ) * w * P m w‖
      ≤ 2 * q m w * ‖((cS m / D m : ℝ) : ℂ) * w * P m w‖ := by
```

```
theorem re_S_sq_ge {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0)
    (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (hq : q m w ≤ 1) :
    (cS m / D m) ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m)
        * ((w ^ 2).re * Real.cos (2 * (w ^ 2).im * sigma m)
          - (w ^ 2).im * Real.sin (2 * (w ^ 2).im * sigma m))
      - (cS m / D m) ^ 2 * ‖w‖ ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m)
        * (4 * q m w + 4 * q m w ^ 2)
      ≤ ((S m w) ^ 2).re := by
```
