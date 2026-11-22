# What `WeilPowerCompare.compare_suppressed` rests on

[`WeilPowerCompare.compare_suppressed`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-compare_suppressed) in `lean_stage3/Stage3/WeilPowerCompare.lean`, line 294.

**Why.** Suppression at another off-line zero. For `h` in the range where the quartic error is at most half the rate — which by `rate_neg_of_qerr` already makes the rate negative — the transform at the other zero is an exponentially small multiple of the target's.

**Proves**

```lean
‖S m (wOf ε' Δ h)‖ ≤ (2 * (m : ℝ) + 3) * (‖wOf ε' Δ h‖ / (ε * h)) * Real.exp (rate m ε' Δ ε * h ^ 2 / 2) * (S m ((ε * h : ℝ) : ℂ)).re
```

**Needs** (its hypotheses)

  - `` hε : 0 < ε ``
  - `` hh : 0 < h ``
  - `` hε' : ε' ≠ 0 ``
  - `` hq : qerr m ε' Δ ε * h ^ 2 ≤ -rate m ε' Δ ε / 2 ``
  - `` hw : (ε' ^ 2 + Δ ^ 2) * h ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2 ``
  - `` hs : (ε * h) ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2 ``

Behind it: 71 theorems and 23 definitions in 6 files. Every one is listed below; Lean recorded each step.

## The files it passes through

```mermaid
flowchart LR
  f0["<b>WeilWindow</b><br/>1 used"]:::thm
  f1["<b>WeilPower</b><br/>28 used"]:::thm
  f2["<b>WeilOddPower</b><br/>11 used"]:::thm
  f3["<b>WeilPowerBounds</b><br/>6 used"]:::thm
  f4["<b>WeilPowerGauss</b><br/>29 used"]:::thm
  f5["<b>WeilPowerCompare</b><br/>compare_suppressed"]:::end_
  f0 --> f1
  f1 --> f2
  f2 --> f3
  f3 --> f4
  f4 --> f5
  classDef cnt fill:#dff5ec,stroke:#17694a,color:#111
  classDef shp fill:#f1ecfb,stroke:#5b3fa0,color:#111
  classDef rh fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111
```

An arrow A → B reads "B uses something proved or defined in A"; indirect arrows are left out. Green: the theorem itself. Yellow: a file in the other tree. The number is how many of that file's declarations are on the way.

## Every declaration on the way

Files in dependency order. ★ marks what the theorem's own proof uses directly.

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
- [`WeilOddPower.cS`](../lean_stage3/WeilOddPower.md#WeilOddPower-cS) — *def*
- [`WeilOddPower.Q_succ_eq`](../lean_stage3/WeilOddPower.md#WeilOddPower-Q_succ_eq) — `` Q (m + 1) w = w * QS m w ``
- [`WeilOddPower.cS_eq`](../lean_stage3/WeilOddPower.md#WeilOddPower-cS_eq) — `` cS m * (((m : ℝ) + 1) * Real.pi) = 2 * cK (m + 1) ``
- [`WeilOddPower.S_mul_QS`](../lean_stage3/WeilOddPower.md#WeilOddPower-S_mul_QS) — `` S m w * QS m w = (cS m : ℂ) * Complex.sinh w ``

### [`WeilPowerBounds`](../lean_stage3/WeilPowerBounds.md) — 6

- [`WeilPowerBounds.factor_eq`](../lean_stage3/WeilPowerBounds.md#WeilPowerBounds-factor_eq) — `` w ^ 2 + (a : ℂ) ^ 2 = (w - Complex.I * (a : ℂ)) * (w + Complex.I * (a : ℂ)) ``
- [`WeilPowerBounds.norm_factor_ge`](../lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_factor_ge) — `` w.re ^ 2 ≤ ‖w ^ 2 + (a : ℂ) ^ 2‖ ``
- [`WeilPowerBounds.QS_factor`](../lean_stage3/WeilPowerBounds.md#WeilPowerBounds-QS_factor) — `` QS m w = ∏ j ∈ Finset.range (m + 1), (w ^ 2 + ((Real.pi * ((j : ℝ) + 1) : ℝ) : ℂ) ^ 2) ``
- [`WeilPowerBounds.norm_QS_ge`](../lean_stage3/WeilPowerBounds.md#WeilPowerBounds-norm_QS_ge) — `` (w.re ^ 2) ^ (m + 1) ≤ ‖QS m w‖ ``
- [`WeilPowerBounds.QS_ne_zero`](../lean_stage3/WeilPowerBounds.md#WeilPowerBounds-QS_ne_zero) — `` QS m w ≠ 0 ``
- [`WeilPowerBounds.S_eq_div'`](../lean_stage3/WeilPowerBounds.md#WeilPowerBounds-S_eq_div-) — `` S m w = (cS m : ℂ) * Complex.sinh w / QS m w ``

### [`WeilPowerGauss`](../lean_stage3/WeilPowerGauss.md) — 29

- [`WeilPowerGauss.g`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-g) — *def*
- [`WeilPowerGauss.euler_sinh`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-euler_sinh) — `` Tendsto (fun n : ℕ => w * ∏ j ∈ Finset.range n, g w j) atTop (𝓝 (Complex.sinh w)) ``
- [`WeilPowerGauss.D`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-D) — *def*
- [`WeilPowerGauss.D_pos`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-D_pos) — `` 0 < D m ``
- [`WeilPowerGauss.D_eq`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-D_eq) — `` D m = Real.pi ^ (2 * (m + 1)) * (((m + 1).factorial : ℕ) : ℝ) ^ 2 ``
- [`WeilPowerGauss.QS_eq_D_mul`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-QS_eq_D_mul) — `` QS m w = (D m : ℂ) * ∏ j ∈ Finset.range (m + 1), g w j ``
- [`WeilPowerGauss.cprime_eq`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-cprime_eq) — `` cS m / D m = ((Nat.centralBinom (m + 1) : ℕ) : ℝ) / (Real.pi * ((m : ℝ) + 1) * 4 ^ m) ``
- [`WeilPowerGauss.cprime_le`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-cprime_le) — `` cS m / D m ≤ 4 / (Real.pi * ((m : ℝ) + 1)) ``
- [`WeilPowerGauss.cprime_ge`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-cprime_ge) — `` 4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) ≤ cS m / D m ``
- [`WeilPowerGauss.cprime_pos`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-cprime_pos) — `` 0 < cS m / D m ``
- [`WeilPowerGauss.T`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-T) — *def*
- [`WeilPowerGauss.tendsto_S`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-tendsto_S) — `` Tendsto (fun n : ℕ => ((cS m / D m : ℝ) : ℂ) * w * T m w n) atTop (𝓝 (S m w)) ``
- [`WeilPowerGauss.norm_one_add_le`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_one_add_le) — `` ‖1 + x‖ ≤ Real.exp (x.re + ‖x‖ ^ 2) ``
- [`WeilPowerGauss.exp_le_one_add`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-exp_le_one_add) — `` Real.exp (x - x ^ 2) ≤ 1 + x ``
- [`WeilPowerGauss.sum_inv_sq_le`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-sum_inv_sq_le) — `` ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 ≤ 1 / ((m : ℝ) + 1) ``
- [`WeilPowerGauss.sum_inv_sq_ge`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-sum_inv_sq_ge) — `` ((m : ℝ) + 2) / (2 * (m : ℝ) + 3) ^ 2 ≤ ∑ j ∈ Finset.Ico (m + 1) (2 * m + 3), 1 / ((j : ℝ) + 1) ^ 2 ``
- [`WeilPowerGauss.sum_inv_pow4_le`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-sum_inv_pow4_le) — `` ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4 ≤ 1 / ((m : ℝ) + 1) ^ 3 ``
- [`WeilPowerGauss.norm_x_le`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_x_le) — `` ‖w ^ 2 / ((Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2)‖ ≤ 1 / 2 ``
- [`WeilPowerGauss.x_re`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-x_re) — `` (w ^ 2 / ((Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2)).re = (w ^ 2).re / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2) ``
- [`WeilPowerGauss.x_norm`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-x_norm) — `` ‖w ^ 2 / ((Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2)‖ = ‖w‖ ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2) ``
- [`WeilPowerGauss.norm_T_le`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_T_le) — `` ‖T m w n‖ ≤ Real.exp ((w ^ 2).re / Real.pi ^ 2 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 + ‖w‖ ^ 4 / Real.pi ^ 4 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j… ``
- [`WeilPowerGauss.norm_T_le_pos`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_T_le_pos) — `` ‖T m w n‖ ≤ Real.exp ((w ^ 2).re / (Real.pi ^ 2 * ((m : ℝ) + 1)) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ``
- [`WeilPowerGauss.norm_T_le_neg`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_T_le_neg) — `` ‖T m w n‖ ≤ Real.exp ((w ^ 2).re * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ``
- [`WeilPowerGauss.norm_S_le_gauss_pos`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_S_le_gauss_pos) — `` ‖S m w‖ ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖ * Real.exp ((w ^ 2).re / (Real.pi ^ 2 * ((m : ℝ) + 1)) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ``
- [`WeilPowerGauss.norm_S_le_gauss_neg`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-norm_S_le_gauss_neg) — `` ‖S m w‖ ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖ * Real.exp ((w ^ 2).re * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ)… ``
- [`WeilPowerGauss.Tr`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-Tr) — *def*
- [`WeilPowerGauss.T_ofReal`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-T_ofReal) — `` T m (s : ℂ) n = ((Tr m s n : ℝ) : ℂ) ``
- [`WeilPowerGauss.Tr_ge`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-Tr_ge) — `` Real.exp (s ^ 2 * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2) - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ≤ Tr m s n ``
- [`WeilPowerGauss.S_real_ge_gauss`](../lean_stage3/WeilPowerGauss.md#WeilPowerGauss-S_real_ge_gauss) — `` 4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) * s * Real.exp (s ^ 2 * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2) - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ… ``

### [`WeilPowerCompare`](../lean_stage3/WeilPowerCompare.md) — 19

- [`WeilPowerCompare.cP`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-cP) — *def*
- [`WeilPowerCompare.cE`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-cE) — *def*
- [`WeilPowerCompare.cQ`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-cQ) — *def*
- ★ [`WeilPowerCompare.Eup`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-Eup) — *def*
- ★ [`WeilPowerCompare.Elow`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-Elow) — *def*
- [`WeilPowerCompare.norm_S_le_gauss`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-norm_S_le_gauss) — `` ‖S m w‖ ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖ * Real.exp (Eup m w) ``
- [`WeilPowerCompare.S_real_ge_low`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-S_real_ge_low) — `` 4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) * s * Real.exp (Elow m s) ≤ (S m (s : ℂ)).re ``
- ★ [`WeilPowerCompare.S_real_pos`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-S_real_pos) — `` 0 < (S m (s : ℂ)).re ``
- ★ [`WeilPowerCompare.compare_le`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-compare_le) — `` ‖S m w‖ ≤ (2 * (m : ℝ) + 3) * (‖w‖ / s) * Real.exp (Eup m w - Elow m s) * (S m (s : ℂ)).re ``
- ★ [`WeilPowerCompare.wOf`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-wOf) — *def*
- [`WeilPowerCompare.wOf_re`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-wOf_re) — `` (wOf ε Δ h).re = ε * h ``
- [`WeilPowerCompare.wOf_im`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-wOf_im) — `` (wOf ε Δ h).im = Δ * h ``
- [`WeilPowerCompare.wOf_sq_re`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-wOf_sq_re) — `` ((wOf ε Δ h) ^ 2).re = (ε ^ 2 - Δ ^ 2) * h ^ 2 ``
- ★ [`WeilPowerCompare.norm_wOf_sq`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-norm_wOf_sq) — `` ‖wOf ε Δ h‖ ^ 2 = (ε ^ 2 + Δ ^ 2) * h ^ 2 ``
- [`WeilPowerCompare.norm_wOf_pow4`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-norm_wOf_pow4) — `` ‖wOf ε Δ h‖ ^ 4 = ((ε ^ 2 + Δ ^ 2) * h ^ 2) ^ 2 ``
- ★ [`WeilPowerCompare.QS_ne_zero_wOf`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-QS_ne_zero_wOf) — `` QS m (wOf ε Δ h) ≠ 0 ``
- ★ [`WeilPowerCompare.rate`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-rate) — *def*
- ★ [`WeilPowerCompare.qerr`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-qerr) — *def*
- ★ [`WeilPowerCompare.exponent_eq`](../lean_stage3/WeilPowerCompare.md#WeilPowerCompare-exponent_eq) — `` Eup m (wOf ε' Δ h) - Elow m (ε * h) = rate m ε' Δ ε * h ^ 2 + qerr m ε' Δ ε * h ^ 4 ``

