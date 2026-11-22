# `lean_stage3/Stage3/GateEval.lean`

**What it does** (its own header): GateEval — block E9 of `lean_stage3/design/joints.md`. 2026-11-22. The table gate's own inequality, evaluated on the explicit-formula route at the floor `x₀ = 2^36` and depth six.

**Imports:** [`RouteNum`](../lean_stage3/RouteNum.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`TableRoute`](../lean_stage3/TableRoute.md).

```mermaid
flowchart LR
  n0["floor_bound<br/>⊢ 3 * (4 + (16 + 16 * 112 + 16 * 0) / ℓ + (8 * 698 + 8 + 4 * 0) / ℓ ^ 2 …"]:::thm
  n1["routeConst_le<br/>⊢ Stage3.routeConst ((2:ℝ) ^ (36:ℕ)) ≤ 414"]:::thm
  n2["sq_le_two_rpow<br/>⊢ r ^ 2 ≤ 6400 * (2:ℝ) ^ ((r - 80) / 2)"]:::thm
  n3["gate_ineq<br/>⊢ 414 * (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-((r - 7) / 2)) ＜ Real.log 2 ^ 6…"]:::thm
  n4["gate_hyp_of_RH<br/>⊢ ∃ ρ : ℝ, JointDialGate.StmtRelErrWindow (fun m : ℤ =＞ (Nat.primeCounti…"]:::thm
  x0(["AssemblyFloor · floorConst"]):::ext
  x1(["GlueFloor · floorConstSplit"]):::ext
  x2(["JointDialGate · StmtRelErrWindow"]):::ext
  x3(["RouteNum · c1n_le"]):::ext
  x4(["RouteNum · c3n_le"]):::ext
  x5(["RouteNum · c4n_le"]):::ext
  x6(["RouteNum · relErrWindow_route_num"]):::ext
  x7(["RouteNum · routeConst"]):::ext
  x8(["TableDepths · cell_ne_zero_gen"]):::ext
  x9(["TableRoute · cell_ne_zero_of_RH"]):::ext
  n0 --> n1
  n1 --> n4
  n1 --> x8
  n2 --> n3
  n3 --> n4
  n4 --> x9
  x0 --> n1
  x1 --> n1
  x2 --> n4
  x3 --> n1
  x4 --> n1
  x5 --> n1
  x6 --> n4
  x7 --> n1
  x7 --> n4
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
| `GateEval.floor_bound`<br/>theorem, line 30 | 3 * (4 + (16 + 16 * 112 + 16 * 0) / ℓ + (8 * 698 + 8 + 4 * 0) / ℓ ^ 2 + 18 * c1 / ((2:ℝ) ^ (36:ℕ) * (2:ℝ) ^ (18:ℕ)) + c3 / ((2:ℝ) ^ (18:ℕ) * ℓ) + c4 * (1 / (2:ℝ) ^ (9:ℕ)) / (2:ℝ) ^ (18:ℕ)) + 13 ≤ 414 | hc1' : c1 ≤ 88216610000; hc3' : c3 ≤ 15; hc4' : c4 ≤ 6468930000; hℓ : 24.95 ≤ ℓ | — | — | `GateEval.routeConst_le` |
| `GateEval.routeConst_le`<br/>theorem, line 56 | Stage3.routeConst ((2:ℝ) ^ (36:ℕ)) ≤ 414 | — | — | `Stage3.floorConst`, `GateEval.floor_bound`, `Stage3.floorConstSplit`, `RouteNum.c1n_le`, `RouteNum.c3n_le`, `RouteNum.c4n_le`, `Stage3.routeConst` | `GateEval.gate_hyp_of_RH`, `TableDepths.cell_ne_zero_gen` |
| `GateEval.sq_le_two_rpow`<br/>theorem, line 77 | r ^ 2 ≤ 6400 * (2:ℝ) ^ ((r - 80) / 2) | hr : 80 ≤ r | — | — | `GateEval.gate_ineq` |
| `GateEval.gate_ineq`<br/>theorem, line 99 | 414 * (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-((r - 7) / 2)) &lt; Real.log 2 ^ 6 / (2 * r * 3 ^ 7) | hr : 80 ≤ r | — | `GateEval.sq_le_two_rpow` | `GateEval.gate_hyp_of_RH` |
| `GateEval.gate_hyp_of_RH`<br/>theorem, line 145 | ∃ ρ : ℝ, JointDialGate.StmtRelErrWindow (fun m : ℤ =&gt; (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ)) (fun m : ℤ =&gt; 2 / Real.log 2 + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r (6 + 1) ρ ∧ ρ &lt; Real.log 2 ^ 6 / (2 * r * 3 ^ (6 + 1)) | hRH : RiemannHypothesis; hr : 80 ≤ r | The gate's two hypotheses, under RH, at depth six from row 80. | `GateEval.gate_ineq`, `GateEval.routeConst_le`, `JointDialGate.StmtRelErrWindow`, `RouteNum.relErrWindow_route_num`, `Stage3.routeConst` | `TableRoute.cell_ne_zero_of_RH` |
