# `lean_stage3/Stage3/RowLeaves.lean`

RowLeaves — block E4 of `lean_stage3/design/joints.md`. 2026-11-22. Two leaves the route to the gate left open (unit 0412).

7 theorems, 0 definitions, 165 lines. Arrows are Lean's own record of what each proof uses.

**Imports:** [`PsiToPi`](../lean_stage3/PsiToPi.md)  
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`HalfSieve`](../lean_stage3/HalfSieve.md), [`PiToPsi`](../lean_stage3/PiToPsi.md), [`RouteGate`](../lean_stage3/RouteGate.md)

## The picture

```mermaid
flowchart LR
  n0["<b>continuousOn_inv_log_sq_Ioi</b><br/>ContinuousOn (fun t : ℝ =＞ 1 / Real.log t ^ 2) (Ioi 1)"]:::shp
  n1["<b>hasDerivAt_Li</b><br/>HasDerivAt Li (1 / Real.log y) y"]:::shp
  n2["<b>hasDerivAt_Li_two_rpow</b><br/>HasDerivAt (fun u : ℝ =＞ Li ((2 : ℝ) ^ u)) (Real.exp (Real.log 2…"]:::shp
  n3["<b>continuousOn_exp_div</b><br/>ContinuousOn (fun t : ℝ =＞ Real.exp (Real.log 2 * t) / t) (Ioi 0…"]:::shp
  n4["<b>hasDerivAt_rowIntegral</b><br/>HasDerivAt (fun u : ℝ =＞ 2 / Real.log 2 + ∫ t in (1 : ℝ)..u, Rea…"]:::shp
  n5["<b>Li_two_rpow</b><br/>Li ((2 : ℝ) ^ x) = 2 / Real.log 2 + ∫ t in (1 : ℝ)..x, Real.exp …"]:::shp
  n6["<b>norm_logDerivZeta_zero</b><br/>‖deriv riemannZeta 0 / riemannZeta 0‖ = Real.log (2 * Real.pi)"]:::thm
  x0(["<b>HalfSieve</b><br/>Li_floor_close"]):::ext
  x1(["<b>PiToPsi</b><br/>Li_mul_log_sub_integral<br/>continuousOn_Li"]):::ext
  x2(["<b>RouteGate</b><br/>relErrWindow_route"]):::ext
  x3(["<b>RouteNum</b><br/>c3n_le<br/>relErrWindow_route_num"]):::ext
  n0 --> n1
  n1 --> n2
  n2 --> n5
  n3 --> n4
  n4 --> n5
  n1 -.-> x0
  n1 -.-> x1
  n5 -.-> x2
  n5 -.-> x3
  n6 -.-> x3
  classDef cnt fill:#dff5ec,stroke:#17694a,color:#111
  classDef shp fill:#f1ecfb,stroke:#5b3fa0,color:#111
  classDef rh fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111
```

An arrow A → B reads "A is used in the proof of B". Green: counting, integers only. Violet: shape, analysis with no ζ. Blue: reads ζ. A name ending in ■ is an end: nothing else uses it. Red: contains `sorry`. Yellow: theorems in another file, counted; a dotted arrow crosses files. Definitions are not drawn; they are listed below the diagram.

## Theorems

<a name="Stage3-continuousOn_inv_log_sq_Ioi"></a>
### `Stage3.continuousOn_inv_log_sq_Ioi`

line 32

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** Helper: `t ↦ 1/(log t)²` is continuous on `(1, ∞)`.

**Proves**

```lean
ContinuousOn (fun t : ℝ => 1 / Real.log t ^ 2) (Ioi 1)
```

**Fed by:** no theorem of this repo; it stands on Mathlib.

**Feeds** (1 that use it)

  - [`Stage3.hasDerivAt_Li`](#Stage3-hasDerivAt_Li) — `` HasDerivAt Li (1 / Real.log y) y ``

<a name="Stage3-hasDerivAt_Li"></a>
### `Stage3.hasDerivAt_Li`

line 42

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** `Li′ = 1/log` beyond one.

**Proves**

```lean
HasDerivAt Li (1 / Real.log y) y
```

**Needs** (its hypotheses)

  - `` hy : 1 < y ``

**Stated with:** [`Stage3.Li`](../lean_stage3/PsiToPi.md#Stage3-Li)

**Fed by** (1 theorem its proof uses)

  - [`Stage3.continuousOn_inv_log_sq_Ioi`](#Stage3-continuousOn_inv_log_sq_Ioi) — `` ContinuousOn (fun t : ℝ => 1 / Real.log t ^ 2) (Ioi 1) ``

**Feeds** (4 that use it)

  - [`HalfSieve.Li_floor_close`](../lean_stage3/HalfSieve.md#HalfSieve-Li_floor_close) (HalfSieve) — `` |Stage3.Li x - Stage3.Li (n : ℝ)| ≤ 2 ``
  - [`PiToPsi.Li_mul_log_sub_integral`](../lean_stage3/PiToPsi.md#PiToPsi-Li_mul_log_sub_integral) (PiToPsi) — `` Stage3.Li x * Real.log x - ∫ t in (2 : ℝ)..x, Stage3.Li t / t = x ``
  - [`PiToPsi.continuousOn_Li`](../lean_stage3/PiToPsi.md#PiToPsi-continuousOn_Li) (PiToPsi) — `` ContinuousOn Stage3.Li (Ioi 1) ``
  - [`Stage3.hasDerivAt_Li_two_rpow`](#Stage3-hasDerivAt_Li_two_rpow) — `` HasDerivAt (fun u : ℝ => Li ((2 : ℝ) ^ u)) (Real.exp (Real.log 2 * x) / x) x ``

<a name="Stage3-hasDerivAt_Li_two_rpow"></a>
### `Stage3.hasDerivAt_Li_two_rpow`

line 71

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** The derivative of `x ↦ Li (2^x)` is `e^(log 2·x)/x`.

**Proves**

```lean
HasDerivAt (fun u : ℝ => Li ((2 : ℝ) ^ u)) (Real.exp (Real.log 2 * x) / x) x
```

**Needs** (its hypotheses)

  - `` hx : 0 < x ``

**Stated with:** [`Stage3.Li`](../lean_stage3/PsiToPi.md#Stage3-Li)

**Fed by** (1 theorem its proof uses)

  - [`Stage3.hasDerivAt_Li`](#Stage3-hasDerivAt_Li) — `` HasDerivAt Li (1 / Real.log y) y ``

**Feeds** (1 that use it)

  - [`Stage3.Li_two_rpow`](#Stage3-Li_two_rpow) — `` Li ((2 : ℝ) ^ x) = 2 / Real.log 2 + ∫ t in (1 : ℝ)..x, Real.exp (Real.log 2 * t) / t ``

<a name="Stage3-continuousOn_exp_div"></a>
### `Stage3.continuousOn_exp_div`

line 89

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** Helper: the row integrand `t ↦ exp (log 2 · t)/t` is continuous on `(0, ∞)`.

**Proves**

```lean
ContinuousOn (fun t : ℝ => Real.exp (Real.log 2 * t) / t) (Ioi 0)
```

**Fed by:** no theorem of this repo; it stands on Mathlib.

**Feeds** (1 that use it)

  - [`Stage3.hasDerivAt_rowIntegral`](#Stage3-hasDerivAt_rowIntegral) — `` HasDerivAt (fun u : ℝ => 2 / Real.log 2 + ∫ t in (1 : ℝ)..u, Real.exp (Real.log 2 * t) / t) (Real.exp (Real.log 2 * x) / x) x ``

<a name="Stage3-hasDerivAt_rowIntegral"></a>
### `Stage3.hasDerivAt_rowIntegral`

line 99

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** For `x > 0`, the row function `u ↦ 2/log 2 + ∫ t in 1..u, exp (log 2 · t)/t` has derivative `exp (log 2 · x)/x` at `x`.

**Proves**

```lean
HasDerivAt (fun u : ℝ => 2 / Real.log 2 + ∫ t in (1 : ℝ)..u, Real.exp (Real.log 2 * t) / t) (Real.exp (Real.log 2 * x) / x) x
```

**Needs** (its hypotheses)

  - `` hx : 0 < x ``

**Fed by** (1 theorem its proof uses)

  - [`Stage3.continuousOn_exp_div`](#Stage3-continuousOn_exp_div) — `` ContinuousOn (fun t : ℝ => Real.exp (Real.log 2 * t) / t) (Ioi 0) ``

**Feeds** (1 that use it)

  - [`Stage3.Li_two_rpow`](#Stage3-Li_two_rpow) — `` Li ((2 : ℝ) ^ x) = 2 / Real.log 2 + ∫ t in (1 : ℝ)..x, Real.exp (Real.log 2 * t) / t ``

<a name="Stage3-Li_two_rpow"></a>
### `Stage3.Li_two_rpow`

line 118

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** The main term at the doublings. Stage 3's `Li` at `2^x` is the antiderivative of `2^t/t` through `2/log 2` at `x = 1`.

**Proves**

```lean
Li ((2 : ℝ) ^ x) = 2 / Real.log 2 + ∫ t in (1 : ℝ)..x, Real.exp (Real.log 2 * t) / t
```

**Needs** (its hypotheses)

  - `` hx : 0 < x ``

**Stated with:** [`Stage3.Li`](../lean_stage3/PsiToPi.md#Stage3-Li)

**Fed by** (2 theorems its proof uses)

  - [`Stage3.hasDerivAt_Li_two_rpow`](#Stage3-hasDerivAt_Li_two_rpow) — `` HasDerivAt (fun u : ℝ => Li ((2 : ℝ) ^ u)) (Real.exp (Real.log 2 * x) / x) x ``
  - [`Stage3.hasDerivAt_rowIntegral`](#Stage3-hasDerivAt_rowIntegral) — `` HasDerivAt (fun u : ℝ => 2 / Real.log 2 + ∫ t in (1 : ℝ)..u, Real.exp (Real.log 2 * t) / t) (Real.exp (Real.log 2 * x) / x) x ``

**Feeds** (2 that use it)

  - [`RouteGate.relErrWindow_route`](../lean_stage3/RouteGate.md#RouteGate-relErrWindow_route) (RouteGate) — `` ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ ∀ x₀ : ℝ, 16 ≤ x₀ → ∀ (r : ℤ) (n : ℕ), x₀ ^ 2 ≤ (2 : ℝ) ^ ((r : ℝ) - n) → JointDialGate.StmtRelErrWindow (f… ``
  - [`RouteNum.relErrWindow_route_num`](../lean_stage3/RouteNum.md#RouteNum-relErrWindow_route_num) (RouteNum) — `` JointDialGate.StmtRelErrWindow (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ)) (fun m : ℤ => 2 / Real.log 2 + ∫ t in (1 : ℝ)..(m : ℝ), Rea… ``

<a name="Stage3-norm_logDerivZeta_zero"></a>
### `Stage3.norm_logDerivZeta_zero`

line 139

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** `K0`, as a number.

**Proves**

```lean
‖deriv riemannZeta 0 / riemannZeta 0‖ = Real.log (2 * Real.pi)
```

**Fed by:** no theorem of this repo; it stands on Mathlib.

**Feeds** (1 that use it)

  - [`RouteNum.c3n_le`](../lean_stage3/RouteNum.md#RouteNum-c3n_le) (RouteNum) — `` Glue.c3n ≤ 15 ``

