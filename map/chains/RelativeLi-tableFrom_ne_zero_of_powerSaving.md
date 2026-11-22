# What `RelativeLi.tableFrom_ne_zero_of_powerSaving` rests on

[`RelativeLi.tableFrom_ne_zero_of_powerSaving`](../lean/RelativeLi.md#RelativeLi-tableFrom_ne_zero_of_powerSaving) in `lean/RelativeLi.lean`, line 70.

**Why.** From a power bound on the rows. `|f(m) − G(m)| ≤ A·(2^m)^θ` on the window with `θ ≤ 1`, and `A·2^((r−d−1)(θ−1))` under the gate's threshold.

**Proves**

```lean
Construction.tableFrom N r d ≠ 0
```

**Needs** (its hypotheses)

  - `` hG : ContDiff ℝ (⊤ : ℕ∞) G ``
  - `` hG' : ∀ x ∈ Ioi ((1 : ℝ) / 2), HasDerivAt G (Expansion.f2x x) x ``
  - `` hrow : ∀ k ∈ range (d + 2), ((N (r - k) : ℤ) : ℝ) = Nonvanishing.bdiffZ f (r - k) ``
  - `` hA : 0 ≤ A ``
  - `` hθ : θ ≤ 1 ``
  - `` hP : ∀ k ∈ range (d + 1 + 1), |f (r - k) - G ((r - k : ℤ) : ℝ)| ≤ A * ((2 : ℝ) ^ ((r : ℝ) - k)) ^ θ ``
  - `` hbot : (1 : ℝ) ≤ (r : ℝ) - (d + 1) ``
  - `` hw : 2 * (d : ℝ) ≤ Real.log 2 * ((r : ℝ) - (d + 1)) ``
  - `` hρ : A * (2 : ℝ) ^ (((r : ℝ) - ((d + 1 : ℕ) : ℝ)) * (θ - 1)) < Real.log 2 ^ d / (2 * r * 3 ^ (d + 1)) ``

Behind it: 39 theorems and 14 definitions in 7 files. Every one is listed below; Lean recorded each step.

## The files it passes through

```mermaid
flowchart LR
  f0["<b>Construction</b><br/>1 used"]:::thm
  f1["<b>Nonvanishing</b><br/>7 used"]:::thm
  f2["<b>Expansion</b><br/>22 used"]:::thm
  f3["<b>MainTerm</b><br/>10 used"]:::thm
  f4["<b>ZerosStencil</b><br/>3 used"]:::thm
  f5["<b>RelativeGate</b><br/>8 used"]:::thm
  f6["<b>RelativeLi</b><br/>tableFrom_ne_zero_of_powerSaving"]:::end_
  f1 --> f2
  f1 --> f3
  f0 --> f4
  f1 --> f5
  f4 --> f5
  f2 --> f6
  f3 --> f6
  f5 --> f6
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

### [`Construction`](../lean/Construction.md) — 1

- ★ [`Construction.tableFrom`](../lean/Construction.md#Construction-tableFrom) — *def*

### [`Nonvanishing`](../lean/Nonvanishing.md) — 7

- ★ [`Nonvanishing.bdiffZ`](../lean/Nonvanishing.md#Nonvanishing-bdiffZ) — *def*
- [`Nonvanishing.stencilR`](../lean/Nonvanishing.md#Nonvanishing-stencilR) — *def*
- [`Nonvanishing.iter_bdiffZ_eq_fwdDiff`](../lean/Nonvanishing.md#Nonvanishing-iter_bdiffZ_eq_fwdDiff) — `` (bdiffZ^[n]) g r = (-1 : ℝ) ^ n * (fwdDiff (-1 : ℤ))^[n] g r ``
- [`Nonvanishing.iter_bdiffZ_eq_stencilR`](../lean/Nonvanishing.md#Nonvanishing-iter_bdiffZ_eq_stencilR) — `` (bdiffZ^[n]) g r = stencilR n g r ``
- [`Nonvanishing.stencilR_row`](../lean/Nonvanishing.md#Nonvanishing-stencilR_row) — `` stencilR d (bdiffZ g) r = stencilR (d + 1) g r ``
- [`Nonvanishing.stencilR_sub`](../lean/Nonvanishing.md#Nonvanishing-stencilR_sub) — `` stencilR n (fun x => f x - L x) r = stencilR n f r - stencilR n L r ``
- [`Nonvanishing.Mlow`](../lean/Nonvanishing.md#Nonvanishing-Mlow) — *def*

### [`Expansion`](../lean/Expansion.md) — 22

- [`Expansion.c`](../lean/Expansion.md#Expansion-c) — *def*
- [`Expansion.S`](../lean/Expansion.md#Expansion-S) — *def*
- [`Expansion.F`](../lean/Expansion.md#Expansion-F) — *def*
- ★ [`Expansion.f2x`](../lean/Expansion.md#Expansion-f2x) — *def*
- [`Expansion.exp_eq_rpow`](../lean/Expansion.md#Expansion-exp_eq_rpow) — `` Real.exp (Real.log 2 * x) = (2 : ℝ) ^ x ``
- [`Expansion.F_zero`](../lean/Expansion.md#Expansion-F_zero) — `` F 0 x = f2x x ``
- [`Expansion.c_rec`](../lean/Expansion.md#Expansion-c_rec) — `` c (d + 1) j = Real.log 2 * c d j + (-(j : ℝ)) * c d (j - 1) ``
- [`Expansion.hasDerivAt_S`](../lean/Expansion.md#Expansion-hasDerivAt_S) — `` HasDerivAt (S d) (∑ j ∈ range (d + 1), c d j * (-(j : ℝ) - 1) * x ^ (-(j + 2 : ℤ))) x ``
- [`Expansion.hasDerivAt_F`](../lean/Expansion.md#Expansion-hasDerivAt_F) — `` HasDerivAt (F d) (F (d + 1) x) x ``
- [`Expansion.iteratedDeriv_f2x`](../lean/Expansion.md#Expansion-iteratedDeriv_f2x) — `` ∀ x ∈ Ioi (0 : ℝ), iteratedDeriv d f2x x = F d x ``
- [`Expansion.t`](../lean/Expansion.md#Expansion-t) — *def*
- [`Expansion.t_nonneg`](../lean/Expansion.md#Expansion-t_nonneg) — `` 0 ≤ t d j x ``
- [`Expansion.S_eq_alt`](../lean/Expansion.md#Expansion-S_eq_alt) — `` S d x = ∑ j ∈ range (d + 1), (-1 : ℝ) ^ j * t d j x ``
- [`Expansion.choose_factorial_step`](../lean/Expansion.md#Expansion-choose_factorial_step) — `` d.choose (j + 1) * (j + 1).factorial = d.choose j * j.factorial * (d - j) ``
- [`Expansion.t_halves`](../lean/Expansion.md#Expansion-t_halves) — `` t d (j + 1) x ≤ t d j x / 2 ``
- [`Expansion.B`](../lean/Expansion.md#Expansion-B) — *def*
- [`Expansion.B_peel`](../lean/Expansion.md#Expansion-B_peel) — `` B d x k = t d k x - B d x (k + 1) ``
- [`Expansion.B_bounds`](../lean/Expansion.md#Expansion-B_bounds) — `` ∀ m k, k + m = d → 0 ≤ B d x k ∧ B d x k ≤ t d k x ``
- [`Expansion.t_zero`](../lean/Expansion.md#Expansion-t_zero) — `` t d 0 x = Real.log 2 ^ d * x⁻¹ ``
- [`Expansion.S_floor`](../lean/Expansion.md#Expansion-S_floor) — `` Real.log 2 ^ d / (2 * x) ≤ S d x ``
- [`Expansion.F_floor`](../lean/Expansion.md#Expansion-F_floor) — `` (2 : ℝ) ^ x * (Real.log 2 ^ d / (2 * x)) ≤ F d x ``
- [`Expansion.hD_of_window`](../lean/Expansion.md#Expansion-hD_of_window) — `` ∀ y ∈ Icc ((r : ℝ) - (d + 1)) r, Nonvanishing.Mlow r d ≤ iteratedDeriv (d + 1) G y ``

### [`MainTerm`](../lean/MainTerm.md) — 10

- [`MainTerm.bdiffR`](../lean/MainTerm.md#MainTerm-bdiffR) — *def*
- [`MainTerm.iter_bdiffR_eq_fwdDiff`](../lean/MainTerm.md#MainTerm-iter_bdiffR_eq_fwdDiff) — `` (bdiffR^[n]) g x = (-1 : ℝ) ^ n * (fwdDiff (-1 : ℝ))^[n] g x ``
- [`MainTerm.iter_bdiffR_eq_sum`](../lean/MainTerm.md#MainTerm-iter_bdiffR_eq_sum) — `` (bdiffR^[n]) g x = ∑ k ∈ range (n + 1), (-1 : ℝ) ^ k * (n.choose k) * g (x - k) ``
- [`MainTerm.stencilR_eq_iter`](../lean/MainTerm.md#MainTerm-stencilR_eq_iter) — `` Nonvanishing.stencilR n (fun k : ℤ => G k) r = (bdiffR^[n]) G r ``
- [`MainTerm.deriv_bdiffR`](../lean/MainTerm.md#MainTerm-deriv_bdiffR) — `` deriv (bdiffR g) = bdiffR (deriv g) ``
- [`MainTerm.contDiff_bdiffR`](../lean/MainTerm.md#MainTerm-contDiff_bdiffR) — `` ContDiff ℝ (⊤ : ℕ∞) (bdiffR g) ``
- [`MainTerm.iteratedDeriv_bdiffR`](../lean/MainTerm.md#MainTerm-iteratedDeriv_bdiffR) — `` iteratedDeriv n (bdiffR g) = bdiffR (iteratedDeriv n g) ``
- [`MainTerm.bdiffR_lb`](../lean/MainTerm.md#MainTerm-bdiffR_lb) — `` m ≤ bdiffR g x ``
- [`MainTerm.iter_bdiffR_lb`](../lean/MainTerm.md#MainTerm-iter_bdiffR_lb) — `` m ≤ (bdiffR^[n]) g x ``
- [`MainTerm.stencilR_ge_of`](../lean/MainTerm.md#MainTerm-stencilR_ge_of) — `` c ≤ |Nonvanishing.stencilR (d + 1) (fun k : ℤ => G k) r| ``

### [`ZerosStencil`](../lean/ZerosStencil.md) — 3

- [`Zeros.tableFrom_eq_fwdDiff`](../lean/ZerosStencil.md#Zeros-tableFrom_eq_fwdDiff) — `` Construction.tableFrom N r d = (-1 : ℤ) ^ d * (fwdDiff (-1 : ℤ))^[d] N r ``
- [`Zeros.stencil`](../lean/ZerosStencil.md#Zeros-stencil) — *def*
- [`Zeros.tableFrom_eq_stencil`](../lean/ZerosStencil.md#Zeros-tableFrom_eq_stencil) — `` Construction.tableFrom N r d = stencil d (fun k => N (r - k)) ``

### [`RelativeGate`](../lean/RelativeGate.md) — 8

- [`RelativeGate.StmtRelErrWindow`](../lean/RelativeGate.md#RelativeGate-StmtRelErrWindow) — *def*
- [`RelativeGate.EhighRel`](../lean/RelativeGate.md#RelativeGate-EhighRel) — *def*
- [`RelativeGate.relWindow_term_le`](../lean/RelativeGate.md#RelativeGate-relWindow_term_le) — `` ρ * (2 : ℝ) ^ ((r : ℝ) - k) = ρ * (2 : ℝ) ^ (r : ℝ) * ((2 : ℝ) ^ (-(1 : ℝ))) ^ k ``
- [`RelativeGate.relError_bound`](../lean/RelativeGate.md#RelativeGate-relError_bound) — `` |stencilR n (fun x => f x - L x) r| ≤ EhighRel r n ρ ``
- [`RelativeGate.relGate_iff`](../lean/RelativeGate.md#RelativeGate-relGate_iff) — `` EhighRel r (d + 1) ρ < Mlow r d ↔ ρ < Real.log 2 ^ d / (2 * r * 3 ^ (d + 1)) ``
- [`RelativeGate.nonvanishing_of_relErr`](../lean/RelativeGate.md#RelativeGate-nonvanishing_of_relErr) — `` stencilR (d + 1) f r ≠ 0 ``
- [`RelativeGate.tableFrom_ne_zero_of_relErr`](../lean/RelativeGate.md#RelativeGate-tableFrom_ne_zero_of_relErr) — `` Construction.tableFrom N r d ≠ 0 ``
- ★ [`RelativeGate.powerSaving_relErr`](../lean/RelativeGate.md#RelativeGate-powerSaving_relErr) — `` StmtRelErrWindow f L r n (A * (2 : ℝ) ^ (((r : ℝ) - n) * (θ - 1))) ``

### [`RelativeLi`](../lean/RelativeLi.md) — 2

- [`RelativeLi.tableFrom_ne_zero_of_relErr_li`](../lean/RelativeLi.md#RelativeLi-tableFrom_ne_zero_of_relErr_li) — `` Construction.tableFrom N r d ≠ 0 ``
- ★ [`RelativeLi.tableFrom_ne_zero_of_relErr_li'`](../lean/RelativeLi.md#RelativeLi-tableFrom_ne_zero_of_relErr_li-) — `` Construction.tableFrom N r d ≠ 0 ``

