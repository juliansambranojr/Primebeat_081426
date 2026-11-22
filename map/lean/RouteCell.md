# `lean/RouteCell.lean`

RouteCell — block E9 of `lean_stage3/design/joints.md`, the table tree's half. The gate (`Interpolant.tableFrom_ne_zero_of_relErr_liRow`) at depth six, on the statement the other tree's explicit-formula route proves under RH.

1 theorem, 0 definitions, 62 lines. Arrows are Lean's own record of what each proof uses.

**Imports:** [`Interpolant`](../lean/Interpolant.md)  
**Imported by:** nothing

## The picture

```mermaid
flowchart LR
  n0["<b>cell_ne_zero_of_route</b><br/>Construction.tableFrom N r 6 ≠ 0"]:::shp
  x0(["<b>Interpolant</b><br/>liRow_eq<br/>tableFrom_ne_zero_of_relErr_liRow"]):::ext
  x1(["<b>TableRoute</b><br/>cell_ne_zero_of_RH"]):::ext
  n0 -.-> x1
  x0 -.-> n0
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

<a name="RouteCell-cell_ne_zero_of_route"></a>
### `RouteCell.cell_ne_zero_of_route`

line 28

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Proves**

```lean
Construction.tableFrom N r 6 ≠ 0
```

**Needs** (its hypotheses)

  - `` hr : 80 ≤ r ``
  - `` hrow : ∀ k ∈ Finset.range (6 + 2), ((N (r - k) : ℤ) : ℝ) = Nonvanishing.bdiffZ f (r - k) ``
  - `` hroute : ∃ ρ : ℝ, RelativeGate.StmtRelErrWindow f (fun m : ℤ => 2 / Real.log 2 + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r (6 + 1) ρ ∧ ρ < Real.log 2 ^ 6 / (2 * r * 3 ^ (6 + 1)) ``

**Stated with:** [`Construction.tableFrom`](../lean/Construction.md#Construction-tableFrom), [`Nonvanishing.bdiffZ`](../lean/Nonvanishing.md#Nonvanishing-bdiffZ), [`RelativeGate.StmtRelErrWindow`](../lean/RelativeGate.md#RelativeGate-StmtRelErrWindow)

**Fed by** (2 theorems its proof uses)

  - [`Interpolant.liRow_eq`](../lean/Interpolant.md#Interpolant-liRow_eq) (Interpolant) — `` liRow x = 2 / Real.log 2 + ∫ t in (1 : ℝ)..x, Expansion.f2x t ``
  - [`Interpolant.tableFrom_ne_zero_of_relErr_liRow`](../lean/Interpolant.md#Interpolant-tableFrom_ne_zero_of_relErr_liRow) (Interpolant) — `` Construction.tableFrom N r d ≠ 0 ``

**Definitions its proof touches:** [`Expansion.f2x`](../lean/Expansion.md#Expansion-f2x), [`Interpolant.liRow`](../lean/Interpolant.md#Interpolant-liRow)

**Feeds** (1 that use it)

  - [`TableRoute.cell_ne_zero_of_RH`](../lean_stage3/TableRoute.md#TableRoute-cell_ne_zero_of_RH) (TableRoute) — `` Construction.tableFrom rowN r 6 ≠ 0 ``

