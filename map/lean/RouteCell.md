# `lean/RouteCell.lean`

**What it does** (its own header): RouteCell — block E9 of `lean_stage3/design/joints.md`, the table tree's half. The gate (`Interpolant.tableFrom_ne_zero_of_relErr_liRow`) at depth six, on the statement the other tree's explicit-formula route proves under RH.

**Imports:** [`Interpolant`](../lean/Interpolant.md).
**Imported by:** nothing.

```mermaid
flowchart LR
  n0["cell_ne_zero_of_route<br/>⊢ Construction.tableFrom N r 6 ≠ 0"]:::thm
  x0(["Construction · tableFrom"]):::ext
  x1(["Interpolant · liRow"]):::ext
  x2(["Interpolant · liRow_eq"]):::ext
  x3(["Interpolant · tableFrom_ne_zero_of_relErr_liRow"]):::ext
  x4(["Nonvanishing · bdiffZ"]):::ext
  x5(["RelativeGate · StmtRelErrWindow"]):::ext
  x6(["TableRoute · cell_ne_zero_of_RH"]):::ext
  n0 --> x6
  x0 --> n0
  x1 --> n0
  x2 --> n0
  x3 --> n0
  x4 --> n0
  x5 --> n0
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
| `RouteCell.cell_ne_zero_of_route`<br/>theorem, line 28 | Construction.tableFrom N r 6 ≠ 0 | hr : 80 ≤ r; hrow : ∀ k ∈ Finset.range (6 + 2), ((N (r - k) : ℤ) : ℝ) = Nonvanishing.bdiffZ f (r - k); hroute : ∃ ρ : ℝ, RelativeGate.StmtRelErrWindow f (fun m : ℤ =&gt; 2 / Real.log 2 + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r (6 + 1) ρ ∧ ρ &lt; Real.log 2 ^ 6 / (2 * r * 3 ^ (6 + 1)) | — | `Construction.tableFrom`, `Interpolant.liRow`, `Interpolant.liRow_eq`, `Interpolant.tableFrom_ne_zero_of_relErr_liRow`, `Nonvanishing.bdiffZ`, `RelativeGate.StmtRelErrWindow` | `TableRoute.cell_ne_zero_of_RH` |
