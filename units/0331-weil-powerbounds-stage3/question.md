> Source: session transcript, 2026-09-06 (this session), the decision that switched the window

> Ok let’s switch

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this module postdates it).

NOTEPAD: no line yet.

From `units/0327-rung-5-window-finding/unit.md`, what the new window was asked for:

> Every other off-line zero grows the same way. By `term_eq_neg_sq` the term
> of a zero at real part one half plus `ε'` is minus the square of the
> transform read at its own point, and by `SigmaC_bound` that transform is at
> most `cosh(ε'h)` over a power of its distance. Its size is exponential in
> its own real part times `h` and polynomial in its height gap from the
> window. A zero with a larger real part than the target, at any height,
> therefore beats the target once `h` is large, and no polynomial decay in
> height can cancel an exponential in the real part.

From `lean_stage3/Stage3/WeilPowerBounds.lean`, the statements as built:

```
theorem norm_S_le {m : ℕ} {w : ℂ} (hw : w.re ≠ 0) :
    ‖S m w‖ ≤ cS m * Real.cosh w.re / ‖QS m w‖ :=
```

```
theorem norm_S_le_far {m : ℕ} {w : ℂ}
    (hfar : 2 * (w.re ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ≤ w.im ^ 2) :
    ‖S m w‖ ≤ cS m * Real.cosh w.re * (2 / w.im ^ 2) ^ (m + 1) := by
```

```
theorem S_real_ge {m : ℕ} {s : ℝ} (hs : 1 ≤ s) :
    cS m * Real.exp s / (4 * (s ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ^ (m + 1))
      ≤ (S m (s : ℂ)).re := by
```
