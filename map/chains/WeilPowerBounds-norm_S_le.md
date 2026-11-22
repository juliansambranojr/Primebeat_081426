# What `WeilPowerBounds.norm_S_le` rests on

[`WeilPowerBounds.norm_S_le`](../lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_S_le) in `lean_stage3/Stage3/WeilPowerBounds.lean`, line 104.

**Why.** Upper bound. `‖S m w‖ ≤ cS m · cosh(Re w) / ‖QS m w‖` for `Re w ≠ 0`.

**Proves**

```lean
‖S m w‖ ≤ cS m * Real.cosh w.re / ‖QS m w‖
```

**Needs** (its hypotheses)

  - `` hw : w.re ≠ 0 ``

Behind it: 38 theorems and 11 definitions in 5 files. Every one is listed below; Lean recorded each step.

## The files it passes through

```mermaid
flowchart LR
  f0["<b>WeilLobe</b><br/>1 used"]:::thm
  f1["<b>WeilWindow</b><br/>1 used"]:::thm
  f2["<b>WeilPower</b><br/>28 used"]:::thm
  f3["<b>WeilOddPower</b><br/>11 used"]:::thm
  f4["<b>WeilPowerBounds</b><br/>norm_S_le"]:::end_
  f1 --> f2
  f2 --> f3
  f0 --> f4
  f3 --> f4
  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111
```

An arrow A → B reads "B uses something proved or defined in A"; indirect arrows are left out. Green: the theorem itself. Yellow: a file in the other tree. The number is how many of that file's declarations are on the way.

## Every declaration on the way

Files in dependency order. ★ marks what the theorem's own proof uses directly.

### [`WeilLobe`](../lean_stage3/WeilLobe.md) — 1

- [`WeilLobe.norm_sinh_le`](../lean_stage3/WeilLobe.md#WeilLobe-norm_sinh_le) — `` ‖Complex.sinh z‖ ≤ Real.cosh z.re ``

### [`WeilWindow`](../lean_stage3/WeilWindow.md) — 1

- [`WeilWindow.P`](../lean_stage3/WeilWindow.md#WeilWindow-P) — *def*

### [`WeilPower`](../lean_stage3/WeilPower.md) — 28

- [`WeilPower.c`](../lean_stage3/WeilPower.md#WeilPower-c) — *def*
- [`WeilPower.P_eq_c_sq`](../lean_stage3/WeilPower.md#WeilPower-P_eq_c_sq) — `` P x = c x ^ 2 ``
- [`WeilPower.P_pow`](../lean_stage3/WeilPower.md#WeilPower-P_pow) — `` P x ^ m = c x ^ (2 * m) ``
- [`WeilPower.c_one`](../lean_stage3/WeilPower.md#WeilPower-c_one) — `` c 1 = 0 ``
- [`WeilPower.c_neg_one`](../lean_stage3/WeilPower.md#WeilPower-c_neg_one) — `` c (-1) = 0 ``
- [`WeilPower.continuous_c`](../lean_stage3/WeilPower.md#WeilPower-continuous_c) — `` Continuous c ``
- [`WeilPower.c_pow_one`](../lean_stage3/WeilPower.md#WeilPower-c_pow_one) — `` c 1 ^ n = 0 ``
- [`WeilPower.c_pow_neg_one`](../lean_stage3/WeilPower.md#WeilPower-c_pow_neg_one) — `` c (-1) ^ n = 0 ``
- [`WeilPower.hasDerivAt_c`](../lean_stage3/WeilPower.md#WeilPower-hasDerivAt_c) — `` HasDerivAt c (-(Real.pi / 2) * Real.sin (Real.pi * x / 2)) x ``
- [`WeilPower.hasDerivAt_s`](../lean_stage3/WeilPower.md#WeilPower-hasDerivAt_s) — `` HasDerivAt (fun y : ℝ => Real.sin (Real.pi * y / 2)) (Real.pi / 2 * c x) x ``
- [`WeilPower.f1`](../lean_stage3/WeilPower.md#WeilPower-f1) — *def*
- [`WeilPower.f2`](../lean_stage3/WeilPower.md#WeilPower-f2) — *def*
- [`WeilPower.hasDerivAt_f`](../lean_stage3/WeilPower.md#WeilPower-hasDerivAt_f) — `` HasDerivAt (fun y : ℝ => c y ^ (k + 1)) (f1 k x) x ``
- [`WeilPower.hasDerivAt_f1`](../lean_stage3/WeilPower.md#WeilPower-hasDerivAt_f1) — `` HasDerivAt (f1 (k + 1)) (f2 k x) x ``
- [`WeilPower.continuous_f1`](../lean_stage3/WeilPower.md#WeilPower-continuous_f1) — `` Continuous (f1 k) ``
- [`WeilPower.continuous_f2`](../lean_stage3/WeilPower.md#WeilPower-continuous_f2) — `` Continuous (f2 k) ``
- [`WeilPower.f1_one`](../lean_stage3/WeilPower.md#WeilPower-f1_one) — `` f1 (k + 1) 1 = 0 ``
- [`WeilPower.f1_neg_one`](../lean_stage3/WeilPower.md#WeilPower-f1_neg_one) — `` f1 (k + 1) (-1) = 0 ``
- [`WeilPower.K`](../lean_stage3/WeilPower.md#WeilPower-K) — *def*
- [`WeilPower.hasDerivAt_E`](../lean_stage3/WeilPower.md#WeilPower-hasDerivAt_E) — `` HasDerivAt (fun y : ℝ => Complex.exp (w * (y : ℂ))) (w * Complex.exp (w * (x : ℂ))) x ``
- [`WeilPower.ibp_twice`](../lean_stage3/WeilPower.md#WeilPower-ibp_twice) — `` w ^ 2 * ∫ x in (-1 : ℝ)..1, ((c x ^ (k + 2) : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)) = ∫ x in (-1 : ℝ)..1, ((f2 k x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)) ``
- [`WeilPower.K_succ`](../lean_stage3/WeilPower.md#WeilPower-K_succ) — `` K (m + 1) w * (w ^ 2 + (Real.pi : ℂ) ^ 2 * ((m : ℂ) + 1) ^ 2) = ((m : ℂ) + 1) * (2 * (m : ℂ) + 1) * (Real.pi : ℂ) ^ 2 / 2 * K m w ``
- [`WeilPower.Q`](../lean_stage3/WeilPower.md#WeilPower-Q) — *def*
- [`WeilPower.cK`](../lean_stage3/WeilPower.md#WeilPower-cK) — *def*
- [`WeilPower.Q_succ`](../lean_stage3/WeilPower.md#WeilPower-Q_succ) — `` Q (m + 1) w = Q m w * (w ^ 2 + (Real.pi : ℂ) ^ 2 * ((m : ℂ) + 1) ^ 2) ``
- [`WeilPower.cK_succ`](../lean_stage3/WeilPower.md#WeilPower-cK_succ) — `` cK (m + 1) = ((m : ℝ) + 1) * (2 * (m : ℝ) + 1) * Real.pi ^ 2 / 2 * cK m ``
- [`WeilPower.K_zero_mul`](../lean_stage3/WeilPower.md#WeilPower-K_zero_mul) — `` K 0 w * w = 2 * Complex.sinh w ``
- [`WeilPower.K_mul_Q`](../lean_stage3/WeilPower.md#WeilPower-K_mul_Q) — `` K m w * Q m w = (cK m : ℂ) * Complex.sinh w ``

### [`WeilOddPower`](../lean_stage3/WeilOddPower.md) — 11

- [`WeilOddPower.q`](../lean_stage3/WeilOddPower.md#WeilOddPower-q) — *def*
- [`WeilOddPower.sin_pi_mul`](../lean_stage3/WeilOddPower.md#WeilOddPower-sin_pi_mul) — `` Real.sin (Real.pi * x) = 2 * Real.sin (Real.pi * x / 2) * c x ``
- [`WeilOddPower.q_eq`](../lean_stage3/WeilOddPower.md#WeilOddPower-q_eq) — `` q m x = -(2 / (((m : ℝ) + 1) * Real.pi)) * f1 (2 * m + 1) x ``
- ★ [`WeilOddPower.S`](../lean_stage3/WeilOddPower.md#WeilOddPower-S) — *def*
- [`WeilOddPower.ibp_once`](../lean_stage3/WeilOddPower.md#WeilOddPower-ibp_once) — `` (∫ x in (-1 : ℝ)..1, ((f1 (k + 1) x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ))) = -(w * ∫ x in (-1 : ℝ)..1, ((c x ^ (k + 2) : ℝ) : ℂ) * Complex.exp (w * (x : ℂ))) ``
- [`WeilOddPower.S_eq`](../lean_stage3/WeilOddPower.md#WeilOddPower-S_eq) — `` S m w = 2 * w * K (m + 1) w / (((m : ℂ) + 1) * (Real.pi : ℂ)) ``
- ★ [`WeilOddPower.QS`](../lean_stage3/WeilOddPower.md#WeilOddPower-QS) — *def*
- ★ [`WeilOddPower.cS`](../lean_stage3/WeilOddPower.md#WeilOddPower-cS) — *def*
- [`WeilOddPower.Q_succ_eq`](../lean_stage3/WeilOddPower.md#WeilOddPower-Q_succ_eq) — `` Q (m + 1) w = w * QS m w ``
- [`WeilOddPower.cS_eq`](../lean_stage3/WeilOddPower.md#WeilOddPower-cS_eq) — `` cS m * (((m : ℝ) + 1) * Real.pi) = 2 * cK (m + 1) ``
- [`WeilOddPower.S_mul_QS`](../lean_stage3/WeilOddPower.md#WeilOddPower-S_mul_QS) — `` S m w * QS m w = (cS m : ℂ) * Complex.sinh w ``

### [`WeilPowerBounds`](../lean_stage3/WeilPowerBounds.md) — 8

- [`WeilPowerBounds.factor_eq`](../lean_stage3/WeilPowerBounds.md#WeilPowerBounds-factor_eq) — `` w ^ 2 + (a : ℂ) ^ 2 = (w - Complex.I * (a : ℂ)) * (w + Complex.I * (a : ℂ)) ``
- [`WeilPowerBounds.norm_factor_ge`](../lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_factor_ge) — `` w.re ^ 2 ≤ ‖w ^ 2 + (a : ℂ) ^ 2‖ ``
- [`WeilPowerBounds.QS_factor`](../lean_stage3/WeilPowerBounds.md#WeilPowerBounds-QS_factor) — `` QS m w = ∏ j ∈ Finset.range (m + 1), (w ^ 2 + ((Real.pi * ((j : ℝ) + 1) : ℝ) : ℂ) ^ 2) ``
- [`WeilPowerBounds.norm_QS_ge`](../lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_QS_ge) — `` (w.re ^ 2) ^ (m + 1) ≤ ‖QS m w‖ ``
- ★ [`WeilPowerBounds.QS_ne_zero`](../lean_stage3/WeilPowerBounds.md#WeilPowerBounds-QS_ne_zero) — `` QS m w ≠ 0 ``
- [`WeilPowerBounds.cS_pos`](../lean_stage3/WeilPowerBounds.md#WeilPowerBounds-cS_pos) — `` 0 < cS m ``
- [`WeilPowerBounds.S_eq_div'`](../lean_stage3/WeilPowerBounds.md#WeilPowerBounds-S_eq_div-) — `` S m w = (cS m : ℂ) * Complex.sinh w / QS m w ``
- ★ [`WeilPowerBounds.norm_S_le'`](../lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_S_le-) — `` ‖S m w‖ ≤ cS m * Real.cosh w.re / ‖QS m w‖ ``

