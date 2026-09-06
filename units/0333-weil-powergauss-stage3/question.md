> Source: session transcript, 2026-09-06 (this session), the decision that switched the window

> Ok let’s switch

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this module postdates it).

NOTEPAD: no line yet.

From `units/0331-weil-powerbounds-stage3/unit.md`, the bound this module replaces:

> On the real axis. `S_real_eq`: at real `s` the transform is the real
> number `cS m · sinh s / Ps m s`. `Ps_le`: the real product is at most
> the largest factor to the power `m+1`. `sinh_ge`: `sinh s` is at least
> `e^s` over `sinh_denom` 4 for `s` at least `s_min` 1. `S_real_ge`: the
> transform at real `s ≥ 1` is at least `cS m · e^s` over `4` times
> `(s² + π²(m+1)²)` to the power `m+1`. That is the target's main term,
> bounded below.

From `lean_stage3/Stage3/WeilPowerGauss.lean`, the statements as built:

```
theorem euler_sinh (w : ℂ) :
    Tendsto (fun n : ℕ => w * ∏ j ∈ Finset.range n, g w j) atTop (𝓝 (Complex.sinh w)) := by
```

```
theorem norm_S_le_gauss_pos {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0)
    (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (hre : 0 ≤ (w ^ 2).re) :
    ‖S m w‖ ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖
      * Real.exp ((w ^ 2).re / (Real.pi ^ 2 * ((m : ℝ) + 1)) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) := by
```

```
theorem S_real_ge_gauss {m : ℕ} {s : ℝ} (hs : 0 < s)
    (hsmall : s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) :
    4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) * s
      * Real.exp (s ^ 2 * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2)
          - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ≤ (S m (s : ℂ)).re := by
```
