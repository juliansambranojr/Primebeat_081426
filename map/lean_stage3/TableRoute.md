# `lean_stage3/Stage3/TableRoute.lean`

**What it does** (its own header): TableRoute — block E10 of `lean_stage3/design/joints.md`: the join between the two trees, closed for the explicit-formula route. 2026-11-22.

**Imports:** [`GateEval`](../lean_stage3/GateEval.md), [`RouteCell`](../lean_stage3/TablePort_RouteCell.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`TableDepths`](../lean_stage3/TableDepths.md).

```mermaid
flowchart LR
  n0["rowN<br/>(def)"]:::dfn
  n1["cell_ne_zero_of_RH<br/>⊢ Construction.tableFrom rowN r 6 ≠ 0"]:::end_
  x0(["Construction · tableFrom"]):::ext
  x1(["Nonvanishing · bdiffZ"]):::ext
  x2(["RouteCell · cell_ne_zero_of_route"]):::ext
  x3(["GateEval · gate_hyp_of_RH"]):::ext
  x4(["TableDepths · cell_ne_zero_gen"]):::ext
  x5(["TableDepths · depth_eight"]):::ext
  x6(["TableDepths · depth_five"]):::ext
  x7(["TableDepths · depth_four"]):::ext
  x8(["TableDepths · depth_one"]):::ext
  x9(["TableDepths · depth_seven"]):::ext
  x10(["TableDepths · depth_six"]):::ext
  x11(["TableDepths · depth_three"]):::ext
  x12(["TableDepths · depth_two"]):::ext
  n0 --> n1
  n0 --> x10
  n0 --> x11
  n0 --> x12
  n0 --> x4
  n0 --> x5
  n0 --> x6
  n0 --> x7
  n0 --> x8
  n0 --> x9
  x0 --> n1
  x1 --> n1
  x2 --> n1
  x3 --> n1
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
| `TableRoute.rowN`<br/>def, line 27 | ℤ | m : ℤ | The table's row: the number of primes in the dyadic block `(2^(m−1), 2^m]`. | — | `TableDepths.cell_ne_zero_gen`, `TableDepths.depth_eight`, `TableDepths.depth_five`, `TableDepths.depth_four`, `TableDepths.depth_one`, `TableDepths.depth_seven`, `TableDepths.depth_six`, `TableDepths.depth_three`, `TableDepths.depth_two`, `TableRoute.cell_ne_zero_of_RH` |
| `TableRoute.cell_ne_zero_of_RH`<br/>theorem, line 32 | Construction.tableFrom rowN r 6 ≠ 0 | hRH : RiemannHypothesis; hr : 80 ≤ r | Under RH, depth six has no zero from row 80 on. | `Construction.tableFrom`, `Nonvanishing.bdiffZ`, `RouteCell.cell_ne_zero_of_route`, `GateEval.gate_hyp_of_RH`, `TableRoute.rowN` | — |
