# `lean/Interpolant.lean`

**What it does** (its own header): Interpolant — the smooth interpolant of the main term, constructed. Block C1 of `lean_stage3/design/joints.md`. 2026-11-22.

**Imports:** [`RelativeLi`](../lean/RelativeLi.md).
**Imported by:** [`RouteCell`](../lean/RouteCell.md).

```mermaid
flowchart LR
  n0["F<br/>(def)"]:::dfn
  n1["liRow<br/>(def)"]:::dfn
  n2["f2x_contDiffOn<br/>⊢ ContDiffOn ℝ (⊤ : ℕ∞) Expansion.f2x (Ioi 0)"]:::end_
  n3["f2x_continuousOn<br/>⊢ ContinuousOn Expansion.f2x (Ioi 0)"]:::end_
  n4["F_hasDerivAt<br/>⊢ HasDerivAt F (Expansion.f2x x) x"]:::thm
  n5["F_contDiffOn<br/>⊢ ContDiffOn ℝ (⊤ : ℕ∞) F (Ioi 0)"]:::end_
  n6["liRow_contDiff<br/>⊢ ContDiff ℝ (⊤ : ℕ∞) liRow"]:::thm
  n7["liRow_eq<br/>⊢ liRow x = 2 / Real.log 2 + ∫ t in (1 : ℝ)..x, Expansion.f2x t"]:::thm
  n8["liRow_hasDerivAt<br/>⊢ HasDerivAt liRow (Expansion.f2x x) x"]:::thm
  n9["tableFrom_ne_zero_of_relErr_liRow<br/>⊢ Construction.tableFrom N r d ≠ 0"]:::thm
  x0(["Construction · tableFrom"]):::ext
  x1(["Expansion · f2x"]):::ext
  x2(["Nonvanishing · bdiffZ"]):::ext
  x3(["RelativeGate · StmtRelErrWindow"]):::ext
  x4(["RelativeLi · tableFrom_ne_zero_of_relErr_li'"]):::ext
  x5(["RouteCell · cell_ne_zero_of_route"]):::ext
  x6(["TableDepths · cell_ne_zero_gen"]):::ext
  n0 --> n1
  n0 --> n4
  n0 --> n5
  n0 --> n8
  n1 --> n6
  n1 --> n7
  n1 --> n8
  n1 --> n9
  n1 --> x5
  n1 --> x6
  n4 --> n5
  n4 --> n8
  n6 --> n9
  n7 --> n8
  n7 --> x5
  n7 --> x6
  n8 --> n9
  n9 --> x5
  n9 --> x6
  x0 --> n9
  x1 --> n0
  x1 --> n2
  x1 --> n3
  x1 --> n4
  x1 --> n7
  x1 --> n8
  x2 --> n9
  x3 --> n9
  x4 --> n9
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
| `Interpolant.F`<br/>def, line 32 | ℝ | x : ℝ | The antiderivative of `2^x/x` through the value `2/log 2` at `x = 1`. | `Expansion.f2x` | `Interpolant.F_contDiffOn`, `Interpolant.F_hasDerivAt`, `Interpolant.liRow`, `Interpolant.liRow_hasDerivAt` |
| `Interpolant.liRow`<br/>def, line 35 | ℝ | x : ℝ | The interpolant: `F` cut off smoothly below one half. | `Interpolant.F` | `Interpolant.liRow_contDiff`, `Interpolant.liRow_eq`, `Interpolant.liRow_hasDerivAt`, `Interpolant.tableFrom_ne_zero_of_relErr_liRow`, `RouteCell.cell_ne_zero_of_route`, `TableDepths.cell_ne_zero_gen` |
| `Interpolant.f2x_contDiffOn`<br/>theorem, line 37 | ContDiffOn ℝ (⊤ : ℕ∞) Expansion.f2x (Ioi 0) | — | — | `Expansion.f2x` | — |
| `Interpolant.f2x_continuousOn`<br/>theorem, line 45 | ContinuousOn Expansion.f2x (Ioi 0) | — | — | `Expansion.f2x` | — |
| `Interpolant.F_hasDerivAt`<br/>theorem, line 48 | HasDerivAt F (Expansion.f2x x) x | hx : 0 &lt; x | — | `Expansion.f2x`, `Interpolant.F` | `Interpolant.F_contDiffOn`, `Interpolant.liRow_hasDerivAt` |
| `Interpolant.F_contDiffOn`<br/>theorem, line 64 | ContDiffOn ℝ (⊤ : ℕ∞) F (Ioi 0) | — | — | `Interpolant.F`, `Interpolant.F_hasDerivAt` | — |
| `Interpolant.liRow_contDiff`<br/>theorem, line 69 | ContDiff ℝ (⊤ : ℕ∞) liRow | — | — | `Interpolant.liRow` | `Interpolant.tableFrom_ne_zero_of_relErr_liRow` |
| `Interpolant.liRow_eq`<br/>theorem, line 87 | liRow x = 2 / Real.log 2 + ∫ t in (1 : ℝ)..x, Expansion.f2x t | hx : 1 / 2 ≤ x | — | `Expansion.f2x`, `Interpolant.liRow` | `Interpolant.liRow_hasDerivAt`, `RouteCell.cell_ne_zero_of_route`, `TableDepths.cell_ne_zero_gen` |
| `Interpolant.liRow_hasDerivAt`<br/>theorem, line 93 | HasDerivAt liRow (Expansion.f2x x) x | hx : x ∈ Ioi ((1 : ℝ) / 2) | — | `Expansion.f2x`, `Interpolant.F`, `Interpolant.F_hasDerivAt`, `Interpolant.liRow`, `Interpolant.liRow_eq` | `Interpolant.tableFrom_ne_zero_of_relErr_liRow` |
| `Interpolant.tableFrom_ne_zero_of_relErr_liRow`<br/>theorem, line 103 | Construction.tableFrom N r d ≠ 0 | hrow : ∀ k ∈ Finset.range (d + 2), ((N (r - k) : ℤ) : ℝ) = Nonvanishing.bdiffZ f (r - k); hS : RelativeGate.StmtRelErrWindow f (fun k : ℤ =&gt; liRow k) r (d + 1) ρ; hbot : (1 : ℝ) ≤ (r : ℝ) - (d + 1); hw : 2 * (d : ℝ) ≤ Real.log 2 * ((r : ℝ) - (d + 1)); hρ : ρ &lt; Real.log 2 ^ d / (2 * r * 3 ^ (d + 1)) | The gate with nothing assumed about the main term. | `Construction.tableFrom`, `Interpolant.liRow`, `Interpolant.liRow_contDiff`, `Interpolant.liRow_hasDerivAt`, `Nonvanishing.bdiffZ`, `RelativeGate.StmtRelErrWindow`, `RelativeLi.tableFrom_ne_zero_of_relErr_li'` | `RouteCell.cell_ne_zero_of_route`, `TableDepths.cell_ne_zero_gen` |
