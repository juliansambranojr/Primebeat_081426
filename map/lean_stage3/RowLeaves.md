# `lean_stage3/Stage3/RowLeaves.lean`

**What it does** (its own header): RowLeaves — block E4 of `lean_stage3/design/joints.md`. 2026-11-22. Two leaves the route to the gate left open (unit 0412).

**Imports:** [`PsiToPi`](../lean_stage3/PsiToPi.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`RouteGate`](../lean_stage3/RouteGate.md).

```mermaid
flowchart LR
  n0["continuousOn_inv_log_sq_Ioi<br/>⊢ ContinuousOn (fun t : ℝ =＞ 1 / Real.log t ^ 2) (Ioi 1)"]:::lone
  n1["hasDerivAt_Li<br/>⊢ HasDerivAt Li (1 / Real.log y) y"]:::thm
  n2["hasDerivAt_Li_two_rpow<br/>⊢ HasDerivAt (fun u : ℝ =＞ Li ((2 : ℝ) ^ u)) (Real.exp (Real.log 2 * x) …"]:::thm
  n3["continuousOn_exp_div<br/>⊢ ContinuousOn (fun t : ℝ =＞ Real.exp (Real.log 2 * t) / t) (Ioi 0)"]:::lone
  n4["hasDerivAt_rowIntegral<br/>⊢ HasDerivAt (fun u : ℝ =＞ 2 / Real.log 2 + ∫ t in (1 : ℝ)..u, Real.exp …"]:::thm
  n5["Li_two_rpow<br/>⊢ Li ((2 : ℝ) ^ x) = 2 / Real.log 2 + ∫ t in (1 : ℝ)..x, Real.exp (Real.…"]:::thm
  n6["norm_logDerivZeta_zero<br/>⊢ ‖deriv riemannZeta 0 / riemannZeta 0‖ = Real.log (2 * Real.pi)"]:::thm
  x0(["PsiToPi · Li"]):::ext
  x1(["RouteGate · relErrWindow_route"]):::ext
  x2(["RouteNum · c3n_le"]):::ext
  x3(["RouteNum · relErrWindow_route_num"]):::ext
  n1 --> n2
  n2 --> n5
  n4 --> n5
  n5 --> x1
  n5 --> x3
  n6 --> x2
  x0 --> n1
  x0 --> n2
  x0 --> n5
  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef dfn fill:#f2f2f2,stroke:#777,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111,stroke-dasharray:2 2
```

Blue: theorem. Green: a theorem nothing else uses (an end). Dashed white: connects to nothing. Grey: definition. Red: contains `sorry`. Yellow: in another file. An arrow A → B reads "A is used by B".

## Every declaration

| declaration | proves (output) | needs (input) | why (its own docstring) | uses | used by |
|---|---|---|---|---|---|
| `Stage3.continuousOn_inv_log_sq_Ioi`<br/>theorem, line 31 | ContinuousOn (fun t : ℝ =&gt; 1 / Real.log t ^ 2) (Ioi 1) | — | — | — | — |
| `Stage3.hasDerivAt_Li`<br/>theorem, line 41 | HasDerivAt Li (1 / Real.log y) y | hy : 1 &lt; y | `Li′ = 1/log` beyond one. | `Stage3.Li` | `Stage3.hasDerivAt_Li_two_rpow` |
| `Stage3.hasDerivAt_Li_two_rpow`<br/>theorem, line 70 | HasDerivAt (fun u : ℝ =&gt; Li ((2 : ℝ) ^ u)) (Real.exp (Real.log 2 * x) / x) x | hx : 0 &lt; x | The derivative of `x ↦ Li (2^x)` is `e^(log 2·x)/x`. | `Stage3.Li`, `Stage3.hasDerivAt_Li` | `Stage3.Li_two_rpow` |
| `Stage3.continuousOn_exp_div`<br/>theorem, line 87 | ContinuousOn (fun t : ℝ =&gt; Real.exp (Real.log 2 * t) / t) (Ioi 0) | — | — | — | — |
| `Stage3.hasDerivAt_rowIntegral`<br/>theorem, line 95 | HasDerivAt (fun u : ℝ =&gt; 2 / Real.log 2 + ∫ t in (1 : ℝ)..u, Real.exp (Real.log 2 * t) / t) (Real.exp (Real.log 2 * x) / x) x | hx : 0 &lt; x | — | — | `Stage3.Li_two_rpow` |
| `Stage3.Li_two_rpow`<br/>theorem, line 114 | Li ((2 : ℝ) ^ x) = 2 / Real.log 2 + ∫ t in (1 : ℝ)..x, Real.exp (Real.log 2 * t) / t | hx : 0 &lt; x | The main term at the doublings. Stage 3's `Li` at `2^x` is the antiderivative of `2^t/t` through `2/log 2` at `x = 1`. | `Stage3.Li`, `Stage3.hasDerivAt_Li_two_rpow`, `Stage3.hasDerivAt_rowIntegral` | `RouteGate.relErrWindow_route`, `RouteNum.relErrWindow_route_num` |
| `Stage3.norm_logDerivZeta_zero`<br/>theorem, line 135 | ‖deriv riemannZeta 0 / riemannZeta 0‖ = Real.log (2 * Real.pi) | — | `K0`, as a number. | — | `RouteNum.c3n_le` |
