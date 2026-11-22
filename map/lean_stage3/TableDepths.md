# `lean_stage3/Stage3/TableDepths.lean`

**What it does** (its own header): TableDepths — block E11 of `lean_stage3/design/joints.md`. 2026-11-22. `TableRoute.cell_ne_zero_of_RH` is depth six. The same route and gate at any depth, from one numeric check at one row, and the instances that fall inside the computed table.

**Imports:** [`TableRoute`](../lean_stage3/TableRoute.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md).

```mermaid
flowchart LR
  n0["sq_le_gen<br/>⊢ r ^ 2 ≤ r₀ ^ 2 * (2:ℝ) ^ ((r - r₀) / 2)"]:::thm
  n1["gate_ineq_gen<br/>⊢ 414 * (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-((r - ((d:ℝ) + 1)) / 2)) ＜ Real…"]:::thm
  n2["cell_ne_zero_gen<br/>⊢ Construction.tableFrom TableRoute.rowN r d ≠ 0"]:::thm
  n3["two_rpow_neg_nat<br/>⊢ (2:ℝ) ^ (-(n:ℝ)) = 1 / (2:ℝ) ^ n"]:::thm
  n4["two_rpow_neg_nat_half<br/>⊢ (2:ℝ) ^ (-(n:ℝ) + 1 / 2) ≤ 1.4143 / (2:ℝ) ^ n"]:::thm
  n5["pow_lower<br/>⊢ (0.6931:ℝ) ^ k ≤ Real.log 2 ^ k"]:::thm
  n6["depth_one<br/>⊢ Construction.tableFrom TableRoute.rowN r 1 ≠ 0"]:::end_
  n7["depth_two<br/>⊢ Construction.tableFrom TableRoute.rowN r 2 ≠ 0"]:::end_
  n8["depth_three<br/>⊢ Construction.tableFrom TableRoute.rowN r 3 ≠ 0"]:::end_
  n9["depth_four<br/>⊢ Construction.tableFrom TableRoute.rowN r 4 ≠ 0"]:::end_
  n10["depth_five<br/>⊢ Construction.tableFrom TableRoute.rowN r 5 ≠ 0"]:::end_
  n11["depth_six<br/>⊢ Construction.tableFrom TableRoute.rowN r 6 ≠ 0"]:::end_
  n12["depth_seven<br/>⊢ Construction.tableFrom TableRoute.rowN r 7 ≠ 0"]:::end_
  n13["depth_eight<br/>⊢ Construction.tableFrom TableRoute.rowN r 8 ≠ 0"]:::end_
  x0(["Construction · tableFrom"]):::ext
  x1(["Interpolant · liRow"]):::ext
  x2(["Interpolant · liRow_eq"]):::ext
  x3(["Interpolant · tableFrom_ne_zero_of_relErr_liRow"]):::ext
  x4(["Nonvanishing · bdiffZ"]):::ext
  x5(["RelativeGate · StmtRelErrWindow"]):::ext
  x6(["GateEval · routeConst_le"]):::ext
  x7(["RouteNum · relErrWindow_route_num"]):::ext
  x8(["RouteNum · routeConst"]):::ext
  x9(["TableRoute · rowN"]):::ext
  n0 --> n1
  n1 --> n2
  n2 --> n10
  n2 --> n11
  n2 --> n12
  n2 --> n13
  n2 --> n6
  n2 --> n7
  n2 --> n8
  n2 --> n9
  n3 --> n10
  n3 --> n13
  n3 --> n4
  n3 --> n6
  n3 --> n7
  n3 --> n8
  n3 --> n9
  n4 --> n11
  n4 --> n12
  n5 --> n10
  n5 --> n11
  n5 --> n12
  n5 --> n13
  n5 --> n6
  n5 --> n7
  n5 --> n8
  n5 --> n9
  x0 --> n10
  x0 --> n11
  x0 --> n12
  x0 --> n13
  x0 --> n2
  x0 --> n6
  x0 --> n7
  x0 --> n8
  x0 --> n9
  x1 --> n2
  x2 --> n2
  x3 --> n2
  x4 --> n2
  x5 --> n2
  x6 --> n2
  x7 --> n2
  x8 --> n2
  x9 --> n10
  x9 --> n11
  x9 --> n12
  x9 --> n13
  x9 --> n2
  x9 --> n6
  x9 --> n7
  x9 --> n8
  x9 --> n9
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
| `TableDepths.sq_le_gen`<br/>theorem, line 27 | r ^ 2 ≤ r₀ ^ 2 * (2:ℝ) ^ ((r - r₀) / 2) | h6 : 6 ≤ r₀; hr : r₀ ≤ r | — | — | `TableDepths.gate_ineq_gen` |
| `TableDepths.gate_ineq_gen`<br/>theorem, line 62 | 414 * (Real.log 2 * r) ^ 1 * (2:ℝ) ^ (-((r - ((d:ℝ) + 1)) / 2)) &lt; Real.log 2 ^ d / (2 * r * 3 ^ (d + 1)) | d : ℕ; h6 : 6 ≤ r₀; hr : r₀ ≤ r; hA : 414 * (2 * 3 ^ (d + 1)) * (r₀ ^ 2 * (2:ℝ) ^ (-((r₀ - ((d:ℝ) + 1)) / 2))) ≤ a; ha : a * Real.log 2 &lt; Real.log 2 ^ d | — | `TableDepths.sq_le_gen` | `TableDepths.cell_ne_zero_gen` |
| `TableDepths.cell_ne_zero_gen`<br/>theorem, line 92 | Construction.tableFrom TableRoute.rowN r d ≠ 0 | hRH : RiemannHypothesis; d : ℕ; hd : d ≤ 24; hfloor : 72 + ((d:ℝ) + 1) ≤ r₀; hA : 414 * (2 * 3 ^ (d + 1)) * (r₀ ^ 2 * (2:ℝ) ^ (-((r₀ - ((d:ℝ) + 1)) / 2))) ≤ a; ha : a * Real.log 2 &lt; Real.log 2 ^ d; hr : r₀ ≤ (r:ℝ) | The route and the gate at depth `d`. | `Construction.tableFrom`, `Interpolant.liRow`, `Interpolant.liRow_eq`, `Interpolant.tableFrom_ne_zero_of_relErr_liRow`, `Nonvanishing.bdiffZ`, `RelativeGate.StmtRelErrWindow`, `GateEval.routeConst_le`, `RouteNum.relErrWindow_route_num`, `Stage3.routeConst`, `TableDepths.gate_ineq_gen`, `TableRoute.rowN` | `TableDepths.depth_eight`, `TableDepths.depth_five`, `TableDepths.depth_four`, `TableDepths.depth_one`, `TableDepths.depth_seven`, `TableDepths.depth_six`, `TableDepths.depth_three`, `TableDepths.depth_two` |
| `TableDepths.two_rpow_neg_nat`<br/>theorem, line 152 | (2:ℝ) ^ (-(n:ℝ)) = 1 / (2:ℝ) ^ n | n : ℕ | — | — | `TableDepths.depth_eight`, `TableDepths.depth_five`, `TableDepths.depth_four`, `TableDepths.depth_one`, `TableDepths.depth_three`, `TableDepths.depth_two`, `TableDepths.two_rpow_neg_nat_half` |
| `TableDepths.two_rpow_neg_nat_half`<br/>theorem, line 155 | (2:ℝ) ^ (-(n:ℝ) + 1 / 2) ≤ 1.4143 / (2:ℝ) ^ n | n : ℕ | — | `TableDepths.two_rpow_neg_nat` | `TableDepths.depth_seven`, `TableDepths.depth_six` |
| `TableDepths.pow_lower`<br/>theorem, line 164 | (0.6931:ℝ) ^ k ≤ Real.log 2 ^ k | k : ℕ | — | — | `TableDepths.depth_eight`, `TableDepths.depth_five`, `TableDepths.depth_four`, `TableDepths.depth_one`, `TableDepths.depth_seven`, `TableDepths.depth_six`, `TableDepths.depth_three`, `TableDepths.depth_two` |
| `TableDepths.depth_one`<br/>theorem, line 168 | Construction.tableFrom TableRoute.rowN r 1 ≠ 0 | hRH : RiemannHypothesis; hr : 74 ≤ r | Depth one, from row 74. | `Construction.tableFrom`, `TableDepths.cell_ne_zero_gen`, `TableDepths.pow_lower`, `TableDepths.two_rpow_neg_nat`, `TableRoute.rowN` | — |
| `TableDepths.depth_two`<br/>theorem, line 180 | Construction.tableFrom TableRoute.rowN r 2 ≠ 0 | hRH : RiemannHypothesis; hr : 75 ≤ r | Depth two, from row 75. | `Construction.tableFrom`, `TableDepths.cell_ne_zero_gen`, `TableDepths.pow_lower`, `TableDepths.two_rpow_neg_nat`, `TableRoute.rowN` | — |
| `TableDepths.depth_three`<br/>theorem, line 195 | Construction.tableFrom TableRoute.rowN r 3 ≠ 0 | hRH : RiemannHypothesis; hr : 76 ≤ r | Depth three, from row 76. | `Construction.tableFrom`, `TableDepths.cell_ne_zero_gen`, `TableDepths.pow_lower`, `TableDepths.two_rpow_neg_nat`, `TableRoute.rowN` | — |
| `TableDepths.depth_four`<br/>theorem, line 210 | Construction.tableFrom TableRoute.rowN r 4 ≠ 0 | hRH : RiemannHypothesis; hr : 77 ≤ r | Depth four, from row 77. | `Construction.tableFrom`, `TableDepths.cell_ne_zero_gen`, `TableDepths.pow_lower`, `TableDepths.two_rpow_neg_nat`, `TableRoute.rowN` | — |
| `TableDepths.depth_five`<br/>theorem, line 225 | Construction.tableFrom TableRoute.rowN r 5 ≠ 0 | hRH : RiemannHypothesis; hr : 78 ≤ r | Depth five, from row 78. | `Construction.tableFrom`, `TableDepths.cell_ne_zero_gen`, `TableDepths.pow_lower`, `TableDepths.two_rpow_neg_nat`, `TableRoute.rowN` | — |
| `TableDepths.depth_six`<br/>theorem, line 240 | Construction.tableFrom TableRoute.rowN r 6 ≠ 0 | hRH : RiemannHypothesis; hr : 80 ≤ r | Depth six, from row 80. | `Construction.tableFrom`, `TableDepths.cell_ne_zero_gen`, `TableDepths.pow_lower`, `TableDepths.two_rpow_neg_nat_half`, `TableRoute.rowN` | — |
| `TableDepths.depth_seven`<br/>theorem, line 260 | Construction.tableFrom TableRoute.rowN r 7 ≠ 0 | hRH : RiemannHypothesis; hr : 85 ≤ r | Depth seven, from row 85. | `Construction.tableFrom`, `TableDepths.cell_ne_zero_gen`, `TableDepths.pow_lower`, `TableDepths.two_rpow_neg_nat_half`, `TableRoute.rowN` | — |
| `TableDepths.depth_eight`<br/>theorem, line 280 | Construction.tableFrom TableRoute.rowN r 8 ≠ 0 | hRH : RiemannHypothesis; hr : 91 ≤ r | Depth eight, from row 91. | `Construction.tableFrom`, `TableDepths.cell_ne_zero_gen`, `TableDepths.pow_lower`, `TableDepths.two_rpow_neg_nat`, `TableRoute.rowN` | — |
