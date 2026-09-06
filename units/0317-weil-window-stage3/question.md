> Source: session transcript, 2026-09-06 (this session), the bracket in which this rung was asked for

> Let's do the tedious

> Yes to both

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this module and WeilDetect postdate it).

NOTEPAD: no line yet.

Lab notebook:

> ## 2026-09-02 — Entry 302 — weil_Lc_theory.py: L_c(ε, γ_k) in closed form for a fixed raised-cosine window, tested against entry 301's 24 rows — the fixed window's L_c is set by the near lobe and

From `analysis/2026-09-01/weil_Lc_theory.md`, section 3:

```
m2       = int x^2 P = 1/3 - 2/pi^2 = 0.130691
m22      = int x^2 P^2 = (2 - 15/pi^2) / 8 = 0.0600228
```

From `lean_stage3/Stage3/WeilWindow.lean`, the statements as built:

```
theorem m2_ge : 1 / 24 ≤ m2 := by
theorem mul_sinh_ge {s : ℝ} (hs : 0 ≤ s) (x : ℝ) : s * x ^ 2 ≤ x * Real.sinh (s * x) := by
theorem Sigma_ge {s : ℝ} (hs : 0 ≤ s) : s / 24 ≤ Sigma s := by
```
